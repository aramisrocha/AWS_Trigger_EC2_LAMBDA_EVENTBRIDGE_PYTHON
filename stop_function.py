import boto3

# Listar as regiões
ec2_client = boto3.client('ec2')
regions = [region['RegionName']
           for region in ec2_client.describe_regions()['Regions']]

# Buscar em todas as regiões
for region in regions:
    ec2 = boto3.resource('ec2', region_name=region)

    print("Region:", region)

    # Filtrar somente as instâncias com a tag 'name' definida como 'night_sleep'
    instances = ec2.instances.filter(
        Filters=[
            {'Name': 'instance-state-name', 'Values': ['running']},
            {'Name': 'tag:Name', 'Values': ['night_sleep']}
        ])

    # Parar as Instâncias
    for instance in instances:
        instance.stop()
        print('Stopped instance:', instance.id)
