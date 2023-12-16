.PHONY: airflow/network
airflow/network:
	docker network create airflow-network

.PHONY: airflow/db
airflow/db:
	docker run --rm -it --name airflow-db --network airflow-network \
		-e POSTGRES_USER=airflow \
		-e POSTGRES_PASSWORD=airflow \
		-e POSTGRES_DB=airflow \
		postgres:13

.PHONY: airflow/db/init
airflow/db/init:
	docker run --rm --network airflow-network \
		-e AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@airflow-db/airflow \
		apache/airflow:2.2.3 airflow db init

.PHONY: airflow/web
airflow/web:
	docker run --rm -it --name airflow-web --network airflow-network \
		-p 8080:8080 \
		-v $(PWD)/dags:/opt/airflow/dags \
		-e AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@airflow-db/airflow \
		-e AIRFLOW__WEBSERVER__SECRET_KEY=secret_key \
		apache/airflow:2.2.3 airflow webserver

.PHONY: airflow/scheduler
airflow/scheduler:
	docker run --rm -it --name airflow-scheduler --network airflow-network \
		-v $(PWD)/dags:/opt/airflow/dags \
		-e AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@airflow-db/airflow \
		-e AIRFLOW__WEBSERVER__SECRET_KEY=secret_key \
		apache/airflow:2.2.3 airflow scheduler

.PHONY: airflow/users/create
airflow/users/create:
	docker run --rm --network airflow-network \
		-e AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@airflow-db/airflow \
		apache/airflow:2.2.3 airflow users create \
		--username admin \
		--firstname Manuel \
		--lastname Saric \
		--role Admin \
		--email admin@example.com \
		--password secret

.PHONY: airflow/users/list
airflow/users/list:
	docker run --rm --network airflow-network \
		-e AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@airflow-db/airflow \
		apache/airflow:2.2.3 airflow users list
