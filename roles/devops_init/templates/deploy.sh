echo "Change directory to /var/www/pb_devops"
cd /var/www/pb_devops
echo "============================================"

echo "Stash git changes"
git stash
echo "==========================================="

echo "Pull origin ${1}"
git pull origin ${1}
echo "==========================================="

echo "Apply stash"
git stash apply
echo "==========================================="

echo "Execute make-template script"
bash ./scripts/make-template.sh ${1}
echo "============================================"

# echo "Update vault"
# make prod-vault-up
# echo "==========================================="

# echo "Update services"
# make prod-service-up
# echo "==========================================="

echo "Success!"
