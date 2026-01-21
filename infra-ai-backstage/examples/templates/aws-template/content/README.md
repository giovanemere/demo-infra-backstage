# ${{ values.name }}

## Descripción
${{ values.description }}

## Arquitectura AWS
- **S3**: Almacenamiento estático
- **CloudFront**: CDN global
- **Región**: ${{ values.region }}

## Despliegue
```bash
aws s3 mb s3://${{ values.name }} --region ${{ values.region }}
aws s3 website s3://${{ values.name }} --index-document index.html
```
