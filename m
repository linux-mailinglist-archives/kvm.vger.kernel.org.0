Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4109B358009
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 11:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhDHJ5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 05:57:11 -0400
Received: from mail-mw2nam12on2078.outbound.protection.outlook.com ([40.107.244.78]:23041
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231421AbhDHJ5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 05:57:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsqG/8L8hdmTi+deXY2QOils6JwKJVZl6WMHT2Ub3tGpO7UDTZ1l6T5LiucInCVQFLyILzLp9wcp9DM4EahtOOtgyadZkKycS0P9YuejJeSUHW6ppemcyEjDJaTM7BKC4n3PJEn81Uw5hGNtjldRnPzb8OsoTA/jcXlUdj31gdhKA9tbxZXxq1XLcApklASE/szpYhrC/h/icSRppA95ic8cDYMDcUHcrX2telPDrFZclfQ6H+dMrdC+Zhhj0iwPAm9PEX4IImkGRRB2HKPToo8Q8n6JA3Y5xYDvjPCNnUtIIRGyMYmOCYCA9+VmjMwVagIKiNQpSFOKKdSwGOHm9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKKmiP/ZYLEfXoSZ223O1M5YtXVJZPkrXu6z7elbM0o=;
 b=FxOdA3cHuzQIHfvM/wuTNT9obS2MPoEv/qw0HbTrYZ/rAi626iQj4gNtzE2dadMdAXnPqxZSj3s6i4DdwbEJaW1BFtZupsNvpTKns9SkBdjhEK6g21iAGmnTVwPH2WP9FwWzTdo2r1LM4HW4SthOPhS5cZuOSRABFeN5WZclYhmEGCU3JP2Izv/2qPTe1yL28xnVsHjjvJSyHVRJg+X0Z/3B497tuyE8r75h2tLhF9luzDbZ4e//vaaeZIZEZgsAK6WY/JZxxjKZDbII8BCXR8kHmhD3HxDjdhqREhCxpnPJn3Aav0ZhTyOU6VRd9ZXi4jblxvoFM3hb9Pddni/WaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKKmiP/ZYLEfXoSZ223O1M5YtXVJZPkrXu6z7elbM0o=;
 b=hrH/RpFsb7v8n97UvEEykTMgXFi42NZ8GEy9QRpwzu50u/ITBRYnJCnSPmGcUY9aRx9wy5ZzJDTxDUXYIF2ghCC81GmUBlmMwCoW5WUU/jEntBLgaOPd80vjUrPiLRyjJ6en3qH0E2MzxVDjqVuQky6pFB+Ifc+gwLhbL0JUWZoGDr42waIBwdAFyql3NgWoVWgFKIcmEDHXmWf8WYejvRZMDjNXjIadkHxfTnf6+/QkRV0o/20b/Z5yOqq2cYG96SwI5ZjewABf/1Rdg7sAumT88JCQlFCt3kuxsFW0RviioK9HTELj3GtdWtiDpwNma7an29mjt2tD3s0LiYUZtQ==
Received: from CO2PR06CA0063.namprd06.prod.outlook.com (2603:10b6:104:3::21)
 by MWHPR12MB1279.namprd12.prod.outlook.com (2603:10b6:300:d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Thu, 8 Apr
 2021 09:56:57 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:3:cafe::35) by CO2PR06CA0063.outlook.office365.com
 (2603:10b6:104:3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 09:56:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 09:56:57 +0000
Received: from [172.27.15.189] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 09:56:55 +0000
Subject: Re: [PATCH v2 1/3] virtio: update reset callback to return status
To:     Jason Wang <jasowang@redhat.com>, <mst@redhat.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>, <cohuck@redhat.com>
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <16fa0e31-a305-3b41-b0d3-ad76aa00177b@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <1f134102-4ccb-57e3-858d-3922d851ce8a@nvidia.com>
Date:   Thu, 8 Apr 2021 12:56:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <16fa0e31-a305-3b41-b0d3-ad76aa00177b@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2181dc24-5614-41b9-c129-08d8fa74a5c5
X-MS-TrafficTypeDiagnostic: MWHPR12MB1279:
X-Microsoft-Antispam-PRVS: <MWHPR12MB127992656868D9F87B5B0091DE749@MWHPR12MB1279.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9afPjp5CJP1AwmeGMvwDiIyqgO153HOXswTGK4igSIA7/FGhbKfXDLj3nBqN5JkNtwPx3n+DEodmQUuQwXEKB3WlRKtt+Y8ErU3k/2hqnA2xGuD/8i1mclrxEUj5WdAhnfDi1gIP4JZWv0Db54GAbnUC5Lpt78QnbYVEZUM+2dyDm8nBlbVkSZZpkAULhk0M04oyuUdYt2KUmJ2IE/wKknUREeLRbbSJB69SV9fdg/f6GWrGIQXAExwxLck3jrB8cQHsdUJCiCSblvwt7uXTNoVzjkybq/3TaBjMbxBQrr0tTxslA7d15DVn6BDOcgrYwC9XfhPBU++C48xAPzfsInUz/2j/tRoOztFqsakF4eEgQEG2Ef/WXfjIUU8jkiG2wDWRsXmsCFxYkp7kX//tqm3Nuh5X4Es4Iua7/k8RCB3szcUcmEm1ky2SGQ6HIsMi8qPQEb7d1ePBXA6puufyO5i4crGPLM2GUoX7CaN9TzMfkhItFhzMh9URsE7h/BrgQd9ip4TwDFsNiWKKr/95XKVW1XMyY2W5HPbcXtt1yn+aay+UUP2SXyukg5EN+blxYMFoswpNGk1Xl/sAVJYzQ6bYCdkm+XRfa7WjLGG2WqYFBGsw58Ibtbg6TKBarkILwPn5sAzQT/GlNKS6e7T+/tWo/hwu22vIikQYbAyG0LwYwr7NBBxx8uRJ8YIX3ny
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(46966006)(36840700001)(82740400003)(4326008)(7636003)(30864003)(83380400001)(31696002)(82310400003)(31686004)(186003)(15650500001)(16526019)(70586007)(356005)(26005)(6666004)(2906002)(70206006)(86362001)(36756003)(5660300002)(426003)(53546011)(478600001)(8936002)(47076005)(8676002)(336012)(16576012)(54906003)(110136005)(36860700001)(2616005)(316002)(36906005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:56:57.5916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2181dc24-5614-41b9-c129-08d8fa74a5c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1279
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/8/2021 11:58 AM, Jason Wang wrote:
>
> 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
>> The reset device operation, usually is an operation that might fail from
>> various reasons. For example, the controller might be in a bad state and
>> can't answer to any request. Usually, the paravirt SW based virtio
>> devices always succeed in reset operation but this is not the case for
>> HW based virtio devices.
>
>
> I would like to know under what condition that the reset operation may 
> fail (except for the case of a bugg guest).

The controller might not be ready or stuck. This is a real use case for 
many PCI devices.

For real devices the FW might be in a bad state and it can happen also 
for paravirt device if you have a bug in the controller code or if you 
entered some error flow (Out of memory).

You don't want to be stuck because of one bad device.


>
>
>>
>> This commit is also a preparation for adding a timeout mechanism for
>> resetting virtio devices.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>
>> changes from v1:
>>   - update virtio_ccw.c (Cornelia)
>>   - update virtio_uml.c
>>   - update mlxbf-tmfifo.c
>
>
> Note that virtio driver may call reset, so you probably need to 
> convert them.

I'm sure I understand.

Convert to what ?

Thanks.

>
> Thanks
>
>
>>
>> ---
>>   arch/um/drivers/virtio_uml.c             |  4 +++-
>>   drivers/platform/mellanox/mlxbf-tmfifo.c |  4 +++-
>>   drivers/remoteproc/remoteproc_virtio.c   |  4 +++-
>>   drivers/s390/virtio/virtio_ccw.c         |  9 ++++++---
>>   drivers/virtio/virtio.c                  | 22 +++++++++++++++-------
>>   drivers/virtio/virtio_mmio.c             |  3 ++-
>>   drivers/virtio/virtio_pci_legacy.c       |  4 +++-
>>   drivers/virtio/virtio_pci_modern.c       |  3 ++-
>>   drivers/virtio/virtio_vdpa.c             |  4 +++-
>>   include/linux/virtio_config.h            |  5 +++--
>>   10 files changed, 43 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
>> index 91ddf74ca888..b6e66265ed32 100644
>> --- a/arch/um/drivers/virtio_uml.c
>> +++ b/arch/um/drivers/virtio_uml.c
>> @@ -827,11 +827,13 @@ static void vu_set_status(struct virtio_device 
>> *vdev, u8 status)
>>       vu_dev->status = status;
>>   }
>>   -static void vu_reset(struct virtio_device *vdev)
>> +static int vu_reset(struct virtio_device *vdev)
>>   {
>>       struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
>>         vu_dev->status = 0;
>> +
>> +    return 0;
>>   }
>>     static void vu_del_vq(struct virtqueue *vq)
>> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c 
>> b/drivers/platform/mellanox/mlxbf-tmfifo.c
>> index bbc4e71a16ff..c192b8ac5d9e 100644
>> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
>> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
>> @@ -980,11 +980,13 @@ static void 
>> mlxbf_tmfifo_virtio_set_status(struct virtio_device *vdev,
>>   }
>>     /* Reset the device. Not much here for now. */
>> -static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>> +static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>>   {
>>       struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
>>         tm_vdev->status = 0;
>> +
>> +    return 0;
>>   }
>>     /* Read the value of a configuration field. */
>> diff --git a/drivers/remoteproc/remoteproc_virtio.c 
>> b/drivers/remoteproc/remoteproc_virtio.c
>> index 0cc617f76068..ca9573c62c3d 100644
>> --- a/drivers/remoteproc/remoteproc_virtio.c
>> +++ b/drivers/remoteproc/remoteproc_virtio.c
>> @@ -191,7 +191,7 @@ static void rproc_virtio_set_status(struct 
>> virtio_device *vdev, u8 status)
>>       dev_dbg(&vdev->dev, "status: %d\n", status);
>>   }
>>   -static void rproc_virtio_reset(struct virtio_device *vdev)
>> +static int rproc_virtio_reset(struct virtio_device *vdev)
>>   {
>>       struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
>>       struct fw_rsc_vdev *rsc;
>> @@ -200,6 +200,8 @@ static void rproc_virtio_reset(struct 
>> virtio_device *vdev)
>>         rsc->status = 0;
>>       dev_dbg(&vdev->dev, "reset !\n");
>> +
>> +    return 0;
>>   }
>>     /* provide the vdev features as retrieved from the firmware */
>> diff --git a/drivers/s390/virtio/virtio_ccw.c 
>> b/drivers/s390/virtio/virtio_ccw.c
>> index 54e686dca6de..52b32555e746 100644
>> --- a/drivers/s390/virtio/virtio_ccw.c
>> +++ b/drivers/s390/virtio/virtio_ccw.c
>> @@ -732,14 +732,15 @@ static int virtio_ccw_find_vqs(struct 
>> virtio_device *vdev, unsigned nvqs,
>>       return ret;
>>   }
>>   -static void virtio_ccw_reset(struct virtio_device *vdev)
>> +static int virtio_ccw_reset(struct virtio_device *vdev)
>>   {
>>       struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>>       struct ccw1 *ccw;
>> +    int ret;
>>         ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
>>       if (!ccw)
>> -        return;
>> +        return -ENOMEM;
>>         /* Zero status bits. */
>>       vcdev->dma_area->status = 0;
>> @@ -749,8 +750,10 @@ static void virtio_ccw_reset(struct 
>> virtio_device *vdev)
>>       ccw->flags = 0;
>>       ccw->count = 0;
>>       ccw->cda = 0;
>> -    ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>> +    ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>>       ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
>> +
>> +    return ret;
>>   }
>>     static u64 virtio_ccw_get_features(struct virtio_device *vdev)
>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>> index 4b15c00c0a0a..ddbfd5b5f3bd 100644
>> --- a/drivers/virtio/virtio.c
>> +++ b/drivers/virtio/virtio.c
>> @@ -338,7 +338,7 @@ int register_virtio_device(struct virtio_device 
>> *dev)
>>       /* Assign a unique device index and hence name. */
>>       err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
>>       if (err < 0)
>> -        goto out;
>> +        goto out_err;
>>         dev->index = err;
>>       dev_set_name(&dev->dev, "virtio%u", dev->index);
>> @@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device 
>> *dev)
>>         /* We always start by resetting the device, in case a previous
>>        * driver messed it up.  This also tests that code path a 
>> little. */
>> -    dev->config->reset(dev);
>> +    err = dev->config->reset(dev);
>> +    if (err)
>> +        goto out_ida;
>>         /* Acknowledge that we've seen the device. */
>>       virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>> @@ -362,10 +364,14 @@ int register_virtio_device(struct virtio_device 
>> *dev)
>>        */
>>       err = device_add(&dev->dev);
>>       if (err)
>> -        ida_simple_remove(&virtio_index_ida, dev->index);
>> -out:
>> -    if (err)
>> -        virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>> +        goto out_ida;
>> +
>> +    return 0;
>> +
>> +out_ida:
>> +    ida_simple_remove(&virtio_index_ida, dev->index);
>> +out_err:
>> +    virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>       return err;
>>   }
>>   EXPORT_SYMBOL_GPL(register_virtio_device);
>> @@ -408,7 +414,9 @@ int virtio_device_restore(struct virtio_device *dev)
>>         /* We always start by resetting the device, in case a previous
>>        * driver messed it up. */
>> -    dev->config->reset(dev);
>> +    ret = dev->config->reset(dev);
>> +    if (ret)
>> +        goto err;
>>         /* Acknowledge that we've seen the device. */
>>       virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
>> index 56128b9c46eb..12b8f048c48d 100644
>> --- a/drivers/virtio/virtio_mmio.c
>> +++ b/drivers/virtio/virtio_mmio.c
>> @@ -256,12 +256,13 @@ static void vm_set_status(struct virtio_device 
>> *vdev, u8 status)
>>       writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
>>   }
>>   -static void vm_reset(struct virtio_device *vdev)
>> +static int vm_reset(struct virtio_device *vdev)
>>   {
>>       struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
>>         /* 0 status means a reset. */
>>       writel(0, vm_dev->base + VIRTIO_MMIO_STATUS);
>> +    return 0;
>>   }
>>     diff --git a/drivers/virtio/virtio_pci_legacy.c 
>> b/drivers/virtio/virtio_pci_legacy.c
>> index d62e9835aeec..0b5d95e3efa1 100644
>> --- a/drivers/virtio/virtio_pci_legacy.c
>> +++ b/drivers/virtio/virtio_pci_legacy.c
>> @@ -89,7 +89,7 @@ static void vp_set_status(struct virtio_device 
>> *vdev, u8 status)
>>       iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>   }
>>   -static void vp_reset(struct virtio_device *vdev)
>> +static int vp_reset(struct virtio_device *vdev)
>>   {
>>       struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>       /* 0 status means a reset. */
>> @@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
>>       ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>       /* Flush pending VQ/configuration callbacks. */
>>       vp_synchronize_vectors(vdev);
>> +
>> +    return 0;
>>   }
>>     static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 
>> vector)
>> diff --git a/drivers/virtio/virtio_pci_modern.c 
>> b/drivers/virtio/virtio_pci_modern.c
>> index fbd4ebc00eb6..cc3412a96a17 100644
>> --- a/drivers/virtio/virtio_pci_modern.c
>> +++ b/drivers/virtio/virtio_pci_modern.c
>> @@ -158,7 +158,7 @@ static void vp_set_status(struct virtio_device 
>> *vdev, u8 status)
>>       vp_modern_set_status(&vp_dev->mdev, status);
>>   }
>>   -static void vp_reset(struct virtio_device *vdev)
>> +static int vp_reset(struct virtio_device *vdev)
>>   {
>>       struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>> @@ -174,6 +174,7 @@ static void vp_reset(struct virtio_device *vdev)
>>           msleep(1);
>>       /* Flush pending VQ/configuration callbacks. */
>>       vp_synchronize_vectors(vdev);
>> +    return 0;
>>   }
>>     static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 
>> vector)
>> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
>> index e28acf482e0c..5fd4e627a9b0 100644
>> --- a/drivers/virtio/virtio_vdpa.c
>> +++ b/drivers/virtio/virtio_vdpa.c
>> @@ -97,11 +97,13 @@ static void virtio_vdpa_set_status(struct 
>> virtio_device *vdev, u8 status)
>>       return ops->set_status(vdpa, status);
>>   }
>>   -static void virtio_vdpa_reset(struct virtio_device *vdev)
>> +static int virtio_vdpa_reset(struct virtio_device *vdev)
>>   {
>>       struct vdpa_device *vdpa = vd_get_vdpa(vdev);
>>         vdpa_reset(vdpa);
>> +
>> +    return 0;
>>   }
>>     static bool virtio_vdpa_notify(struct virtqueue *vq)
>> diff --git a/include/linux/virtio_config.h 
>> b/include/linux/virtio_config.h
>> index 8519b3ae5d52..d2b0f1699a75 100644
>> --- a/include/linux/virtio_config.h
>> +++ b/include/linux/virtio_config.h
>> @@ -44,9 +44,10 @@ struct virtio_shm_region {
>>    *    status: the new status byte
>>    * @reset: reset the device
>>    *    vdev: the virtio device
>> - *    After this, status and feature negotiation must be done again
>> + *    Upon success, status and feature negotiation must be done again
>>    *    Device must not be reset from its vq/config callbacks, or in
>>    *    parallel with being added/removed.
>> + *    Returns 0 on success or error status.
>>    * @find_vqs: find virtqueues and instantiate them.
>>    *    vdev: the virtio_device
>>    *    nvqs: the number of virtqueues to find
>> @@ -82,7 +83,7 @@ struct virtio_config_ops {
>>       u32 (*generation)(struct virtio_device *vdev);
>>       u8 (*get_status)(struct virtio_device *vdev);
>>       void (*set_status)(struct virtio_device *vdev, u8 status);
>> -    void (*reset)(struct virtio_device *vdev);
>> +    int (*reset)(struct virtio_device *vdev);
>>       int (*find_vqs)(struct virtio_device *, unsigned nvqs,
>>               struct virtqueue *vqs[], vq_callback_t *callbacks[],
>>               const char * const names[], const bool *ctx,
>
