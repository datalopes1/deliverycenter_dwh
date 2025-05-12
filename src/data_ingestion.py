import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
import os
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def ingest_data(file_path:str, table_name:str, engine):
    """
    Lê um arquivo CSV e ingere os dados para uma tabela no PostgreSQL

    Args:
        file_path (str): Caminho para o arquivo CSV.
        table_name (str): Nome da tabela no banco de dados.
        engine: Objeto engine do SQLAlchemy para conexão com o banco de dados.
    """
    try:
        logger.info(f"Lendo arquivo: {file_path}")
        df = pd.read_csv(f"{file_path}", encoding='latin-1')
        logger.info(f"Dados lidos com sucesso. Linhas: {len(df)}")

        logger.info(f"Inseridos dados na tabela '{table_name}'")
        df.to_sql(table_name, engine, if_exists='replace', index=False)
        logger.info(f"Ingestão de {table_name} concluída com sucesso!")

    except FileNotFoundError:
        logger.error(f"Erro: Arquivo não encontrado em '{file_path}'.")
    except Exception as e:
        logger.error(f"Error na ingestão de '{table_name}' a partir de '{file_path}': {e}", exc_info=True)

if __name__=='__main__':
    logger.info("Iniciando o processo de ingestão dos dados...")
    
    load_dotenv()

    USUARIO = os.environ.get('DB_USER')
    SENHA = os.environ.get('DB_PASSWORD')
    HOST = os.environ.get('DB_HOST')
    DB = os.environ.get('DB_NAME')

    try:
        logger.info(f"Conectando ao banco de dados: {HOST}/{DB}")
        psql_engine = create_engine(f"postgresql://{USUARIO}:{SENHA}@{HOST}:5432/{DB}")
    except Exception as e:
        logger.error(f"Falha ao conectar ao banco de dados: {e}")

    tables = [
        {'file_path': 'data/raw/channels.csv', 'table_name': 'raw_channels'},
        {'file_path': 'data/raw/deliveries.csv', 'table_name': 'raw_deliveries'},
        {'file_path': 'data/raw/drivers.csv', 'table_name': 'raw_drivers'},
        {'file_path': 'data/raw/hubs.csv', 'table_name': 'raw_hubs'},
        {'file_path': 'data/raw/orders.csv', 'table_name': 'raw_orders'},
        {'file_path': 'data/raw/payments.csv', 'table_name': 'raw_payments'},
        {'file_path': 'data/raw/stores.csv', 'table_name': 'raw_stores'}
    ]

    for table in tables:
        ingest_data(table['file_path'], table['table_name'], psql_engine)
    
    psql_engine.dispose()
    logger.info(f"Processo de ingestão de dados concluído.")