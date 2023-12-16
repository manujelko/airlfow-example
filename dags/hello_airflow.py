from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator


def print_hello():
    print("Hello Airflow!")


dag = DAG(
    "hello_airflow",
    description="Simple tutorial DAG",
    schedule_interval="* * * * *",
    start_date=datetime(2023, 12, 14),
    catchup=False,
)

hello_operator = PythonOperator(
    task_id="hello_task", python_callable=print_hello, dag=dag
)
