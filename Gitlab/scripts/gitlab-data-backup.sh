docker exec -t "$(docker container ls --all --quiet --filter "name=gitlab")" gitlab-backup create
