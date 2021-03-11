Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6182E336972
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 02:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhCKBLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 20:11:25 -0500
Received: from mail-eopbgr750083.outbound.protection.outlook.com ([40.107.75.83]:64429
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229512AbhCKBK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 20:10:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXJv+s1EWuazWMLBV8K/AIOp00JHaIzQFNdzdMa6EGQh5VWxjK1hSN+sHiQIlOSR90HVFN2ZMGohL1OHV7+l/KbIA6y+NPRrsWMwYY+U8BsO6qdNB4NpH8YCVmuVSnyIee62pE/bHSYplmSNydRHyLQlVjsaWXmrMkfdwtCX55g69BhRqTYxfWJGHrxSasbRO1+e1nwchI5aWoir0wg5Lh7gpwykzixKvCDRa3uhROHihD3O7I+JbvyK5olLmAuOm/3J9ZeC9qWI6AZ5/ozvrSLQgjj0gaM2iTrQ8pgcQpApyell6ccogL1aENdhAelwlEc1P0RPiWjAiYXpqPHcXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9J1iM1FTV3Us/TXcI42WlqbYanwEJqUUWoPSjskvfU=;
 b=R6YiLnh1QdrlFDHwslFU/nSUxh5+ngPjJzg4DzVhY7m/8ENGDv6yf+w3dNnjhe/YflwMhItu/3pv3Iucem0pzJcezGoGsKEZbLSG/zsNJRfxW4aMQCJCWIzsleYbug6tWO1HtUD4/ab5UH8fXgplGtCsImw7a4mbAKRI9qzP7pHKq2Cn7vCWfv2mRGuRH9qtyvYeNJdL4Fo/Vw783SL2WY5RNDGX/UxuCJfHWJVuivylRfEGknknG0+VLuVWqBIF1PFBxVeFaPrmu1Vj26Fp60IzMZQiMxM/O8GYAxJY2w5ImMfoUnKjxkBAzvdTT/ioYli4S0foXYZdXsVU4ih1tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9J1iM1FTV3Us/TXcI42WlqbYanwEJqUUWoPSjskvfU=;
 b=dgnu16rWawgaeGtF1hk1QCpbuTpz81wxvebAQSgRE8KZYnRRvZhdiaSmIJFjuj2/g6+XWPQtQdYF8RKXclOVrgG0ipSjtahpfjPiqZtGwAu3qBMjQ6aHgXPI5Pc7DytsQZk+AcD3Sj6xoxjj+xcivvwFak8TsrNP4XuzntJCOsVuj5ibB8rPZPeh+evvgcQ8xnOwuOVseIXFbEPdBb3C9p76VWHrJx3jchtd9ZRi622estMWpeHBnPybUdbDobDkn0RDDCUTxR4ok0PGdyWVJ4c3d77eI92zEUvzlp+Y2deHdCFODO5jaRiVjDqsnSUXSh1YDaxzN2wWQlxAyLbhUA==
Received: from DS7PR03CA0179.namprd03.prod.outlook.com (2603:10b6:5:3b2::34)
 by CH2PR12MB4151.namprd12.prod.outlook.com (2603:10b6:610:78::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Thu, 11 Mar
 2021 01:10:55 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::2b) by DS7PR03CA0179.outlook.office365.com
 (2603:10b6:5:3b2::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 01:10:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 01:10:54 +0000
Received: from [172.27.0.7] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 01:10:46 +0000
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor vfio_pci
 drivers
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <mjrosato@linux.ibm.com>, <hch@lst.de>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <11ae505a-f9fe-f182-3864-cb25b342771f@ozlabs.ru>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <11d9145a-f0e2-ead8-8a59-dc8c29c57400@nvidia.com>
Date:   Thu, 11 Mar 2021 03:10:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <11ae505a-f9fe-f182-3864-cb25b342771f@ozlabs.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac372ed3-ada3-4ff8-e3c7-08d8e42a855e
X-MS-TrafficTypeDiagnostic: CH2PR12MB4151:
X-Microsoft-Antispam-PRVS: <CH2PR12MB415124D8719768C43CDF8BB0DE909@CH2PR12MB4151.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gn09Rln/OIwvN2ZjfV21gduUmp2jq3x2UJGZsvH9T4uVTnq+SoydOifkfgzRAK7R1x/znvFwMPC6mTUpfULkKu6Q0Wn9EHPC10Hj6mN2AfqjPzuTsN4XsP4qLVjemv3dbECwtFMwFaQGAUZy/ITRGjErG6AVnHq9Ek9uN8rib/eLSBrdKAHrG70fmNbwgy/JmNRntB8//a9wHtS9B+n5MStQ2iFBb+UgETe8i6VOBiHfUl3DzyQo6E363LZTyzpFm8F1QVoNjxlhSTc9cHm3VssM9pzvG/1KFMq9G+i8mJUlJy3LvaPwZDt1OmRdGzWAgrtk9Dm+dgOPr0XGpXGQJxMj2fLRuDxT4AQSHTYHcVC6g2MAXDBeNxHiZqKuleIqINNlwBeU9uDYfG0FUYMtF5z+LgDVd7s21kigaefy25H53avQKXy/Xz5ziQ8T9MUMtgyo/xV0q0LhqLPSR1MQDGyzvmwEYC1RRuAgNC+CIpKophK6RzCcM+XXU683jFM7tLhglbWhO2dSPXyvqC8edOArXvylPZrMTvEuzgBoG9de6843KTYYoLqqZyT0A/slOc2VLIW37FVDmMwJvPxes7QW2dOUyrkAQSonowSG+VvfkfVR83Rh38JD6vSI29xh756X5ZOPNO0f5CZK33TXW6dX/y6sI1ty9CPAh8kjzhMM5daS9KCjKF/1SbQEsAdRI27BcPNaHtYgqmwxhlNnVg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(46966006)(36840700001)(82310400003)(31696002)(30864003)(70206006)(16576012)(70586007)(47076005)(186003)(2616005)(8676002)(110136005)(426003)(5660300002)(53546011)(83380400001)(34070700002)(316002)(36860700001)(36756003)(6666004)(31686004)(7636003)(26005)(16526019)(2906002)(54906003)(86362001)(4326008)(36906005)(336012)(82740400003)(356005)(8936002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 01:10:54.8643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac372ed3-ada3-4ff8-e3c7-08d8e42a855e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4151
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/10/2021 4:19 PM, Alexey Kardashevskiy wrote:
>
>
> On 10/03/2021 23:57, Max Gurtovoy wrote:
>>
>> On 3/10/2021 8:39 AM, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 09/03/2021 19:33, Max Gurtovoy wrote:
>>>> The new drivers introduced are nvlink2gpu_vfio_pci.ko and
>>>> npu2_vfio_pci.ko.
>>>> The first will be responsible for providing special extensions for
>>>> NVIDIA GPUs with NVLINK2 support for P9 platform (and others in the
>>>> future). The last will be responsible for POWER9 NPU2 unit (NVLink2 
>>>> host
>>>> bus adapter).
>>>>
>>>> Also, preserve backward compatibility for users that were binding
>>>> NVLINK2 devices to vfio_pci.ko. Hopefully this compatibility layer 
>>>> will
>>>> be dropped in the future
>>>>
>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> ---
>>>>   drivers/vfio/pci/Kconfig                      |  28 +++-
>>>>   drivers/vfio/pci/Makefile                     |   7 +-
>>>>   .../pci/{vfio_pci_npu2.c => npu2_vfio_pci.c}  | 144 
>>>> ++++++++++++++++-
>>>>   drivers/vfio/pci/npu2_vfio_pci.h              |  24 +++
>>>>   ...pci_nvlink2gpu.c => nvlink2gpu_vfio_pci.c} | 149 
>>>> +++++++++++++++++-
>>>>   drivers/vfio/pci/nvlink2gpu_vfio_pci.h        |  24 +++
>>>>   drivers/vfio/pci/vfio_pci.c                   |  61 ++++++-
>>>>   drivers/vfio/pci/vfio_pci_core.c              |  18 ---
>>>>   drivers/vfio/pci/vfio_pci_core.h              |  14 --
>>>>   9 files changed, 422 insertions(+), 47 deletions(-)
>>>>   rename drivers/vfio/pci/{vfio_pci_npu2.c => npu2_vfio_pci.c} (64%)
>>>>   create mode 100644 drivers/vfio/pci/npu2_vfio_pci.h
>>>>   rename drivers/vfio/pci/{vfio_pci_nvlink2gpu.c => 
>>>> nvlink2gpu_vfio_pci.c} (67%)
>>>>   create mode 100644 drivers/vfio/pci/nvlink2gpu_vfio_pci.h
>>>>
>>>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>>>> index 829e90a2e5a3..88c89863a205 100644
>>>> --- a/drivers/vfio/pci/Kconfig
>>>> +++ b/drivers/vfio/pci/Kconfig
>>>> @@ -48,8 +48,30 @@ config VFIO_PCI_IGD
>>>>           To enable Intel IGD assignment through vfio-pci, say Y.
>>>>   -config VFIO_PCI_NVLINK2
>>>> -    def_bool y
>>>> +config VFIO_PCI_NVLINK2GPU
>>>> +    tristate "VFIO support for NVIDIA NVLINK2 GPUs"
>>>>       depends on VFIO_PCI_CORE && PPC_POWERNV
>>>>       help
>>>> -      VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 
>>>> GPUs
>>>> +      VFIO PCI driver for NVIDIA NVLINK2 GPUs with specific 
>>>> extensions
>>>> +      for P9 Witherspoon machine.
>>>> +
>>>> +config VFIO_PCI_NPU2
>>>> +    tristate "VFIO support for IBM NPU host bus adapter on P9"
>>>> +    depends on VFIO_PCI_NVLINK2GPU && PPC_POWERNV
>>>> +    help
>>>> +      VFIO PCI specific extensions for IBM NVLink2 host bus 
>>>> adapter on P9
>>>> +      Witherspoon machine.
>>>> +
>>>> +config VFIO_PCI_DRIVER_COMPAT
>>>> +    bool "VFIO PCI backward compatibility for vendor specific 
>>>> extensions"
>>>> +    default y
>>>> +    depends on VFIO_PCI
>>>> +    help
>>>> +      Say Y here if you want to preserve VFIO PCI backward
>>>> +      compatibility. vfio_pci.ko will continue to automatically use
>>>> +      the NVLINK2, NPU2 and IGD VFIO drivers when it is attached to
>>>> +      a compatible device.
>>>> +
>>>> +      When N is selected the user must bind explicity to the module
>>>> +      they want to handle the device and vfio_pci.ko will have no
>>>> +      device specific special behaviors.
>>>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>>>> index f539f32c9296..86fb62e271fc 100644
>>>> --- a/drivers/vfio/pci/Makefile
>>>> +++ b/drivers/vfio/pci/Makefile
>>>> @@ -2,10 +2,15 @@
>>>>     obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>>>>   obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>>>> +obj-$(CONFIG_VFIO_PCI_NPU2) += npu2-vfio-pci.o
>>>> +obj-$(CONFIG_VFIO_PCI_NVLINK2GPU) += nvlink2gpu-vfio-pci.o
>>>>     vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o 
>>>> vfio_pci_rdwr.o vfio_pci_config.o
>>>>   vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>>>> -vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2gpu.o 
>>>> vfio_pci_npu2.o
>>>>   vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
>>>>     vfio-pci-y := vfio_pci.o
>>>> +
>>>> +npu2-vfio-pci-y := npu2_vfio_pci.o
>>>> +
>>>> +nvlink2gpu-vfio-pci-y := nvlink2gpu_vfio_pci.o
>>>> diff --git a/drivers/vfio/pci/vfio_pci_npu2.c 
>>>> b/drivers/vfio/pci/npu2_vfio_pci.c
>>>> similarity index 64%
>>>> rename from drivers/vfio/pci/vfio_pci_npu2.c
>>>> rename to drivers/vfio/pci/npu2_vfio_pci.c
>>>> index 717745256ab3..7071bda0f2b6 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_npu2.c
>>>> +++ b/drivers/vfio/pci/npu2_vfio_pci.c
>>>> @@ -14,19 +14,28 @@
>>>>    *    Author: Alex Williamson <alex.williamson@redhat.com>
>>>>    */
>>>>   +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>>> +
>>>> +#include <linux/module.h>
>>>>   #include <linux/io.h>
>>>>   #include <linux/pci.h>
>>>>   #include <linux/uaccess.h>
>>>>   #include <linux/vfio.h>
>>>> +#include <linux/list.h>
>>>>   #include <linux/sched/mm.h>
>>>>   #include <linux/mmu_context.h>
>>>>   #include <asm/kvm_ppc.h>
>>>>     #include "vfio_pci_core.h"
>>>> +#include "npu2_vfio_pci.h"
>>>>     #define CREATE_TRACE_POINTS
>>>>   #include "npu2_trace.h"
>>>>   +#define DRIVER_VERSION  "0.1"
>>>> +#define DRIVER_AUTHOR   "Alexey Kardashevskiy <aik@ozlabs.ru>"
>>>> +#define DRIVER_DESC     "NPU2 VFIO PCI - User Level meta-driver 
>>>> for POWER9 NPU NVLink2 HBA"
>>>> +
>>>>   EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_npu2_mmap);
>>>>     struct vfio_pci_npu2_data {
>>>> @@ -36,6 +45,10 @@ struct vfio_pci_npu2_data {
>>>>       unsigned int link_speed; /* The link speed from DT's 
>>>> ibm,nvlink-speed */
>>>>   };
>>>>   +struct npu2_vfio_pci_device {
>>>> +    struct vfio_pci_core_device    vdev;
>>>> +};
>>>> +
>>>>   static size_t vfio_pci_npu2_rw(struct vfio_pci_core_device *vdev,
>>>>           char __user *buf, size_t count, loff_t *ppos, bool iswrite)
>>>>   {
>>>> @@ -120,7 +133,7 @@ static const struct vfio_pci_regops 
>>>> vfio_pci_npu2_regops = {
>>>>       .add_capability = vfio_pci_npu2_add_capability,
>>>>   };
>>>>   -int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
>>>> +static int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
>>>>   {
>>>>       int ret;
>>>>       struct vfio_pci_npu2_data *data;
>>>> @@ -220,3 +233,132 @@ int vfio_pci_ibm_npu2_init(struct 
>>>> vfio_pci_core_device *vdev)
>>>>         return ret;
>>>>   }
>>>> +
>>>> +static void npu2_vfio_pci_release(void *device_data)
>>>> +{
>>>> +    struct vfio_pci_core_device *vdev = device_data;
>>>> +
>>>> +    mutex_lock(&vdev->reflck->lock);
>>>> +    if (!(--vdev->refcnt)) {
>>>> +        vfio_pci_vf_token_user_add(vdev, -1);
>>>> +        vfio_pci_core_spapr_eeh_release(vdev);
>>>> +        vfio_pci_core_disable(vdev);
>>>> +    }
>>>> +    mutex_unlock(&vdev->reflck->lock);
>>>> +
>>>> +    module_put(THIS_MODULE);
>>>> +}
>>>> +
>>>> +static int npu2_vfio_pci_open(void *device_data)
>>>> +{
>>>> +    struct vfio_pci_core_device *vdev = device_data;
>>>> +    int ret = 0;
>>>> +
>>>> +    if (!try_module_get(THIS_MODULE))
>>>> +        return -ENODEV;
>>>> +
>>>> +    mutex_lock(&vdev->reflck->lock);
>>>> +
>>>> +    if (!vdev->refcnt) {
>>>> +        ret = vfio_pci_core_enable(vdev);
>>>> +        if (ret)
>>>> +            goto error;
>>>> +
>>>> +        ret = vfio_pci_ibm_npu2_init(vdev);
>>>> +        if (ret && ret != -ENODEV) {
>>>> +            pci_warn(vdev->pdev,
>>>> +                 "Failed to setup NVIDIA NV2 ATSD region\n");
>>>> +            vfio_pci_core_disable(vdev);
>>>> +            goto error;
>>>> +        }
>>>> +        ret = 0;
>>>> +        vfio_pci_probe_mmaps(vdev);
>>>> +        vfio_pci_core_spapr_eeh_open(vdev);
>>>> +        vfio_pci_vf_token_user_add(vdev, 1);
>>>> +    }
>>>> +    vdev->refcnt++;
>>>> +error:
>>>> +    mutex_unlock(&vdev->reflck->lock);
>>>> +    if (ret)
>>>> +        module_put(THIS_MODULE);
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static const struct vfio_device_ops npu2_vfio_pci_ops = {
>>>> +    .name        = "npu2-vfio-pci",
>>>> +    .open        = npu2_vfio_pci_open,
>>>> +    .release    = npu2_vfio_pci_release,
>>>> +    .ioctl        = vfio_pci_core_ioctl,
>>>> +    .read        = vfio_pci_core_read,
>>>> +    .write        = vfio_pci_core_write,
>>>> +    .mmap        = vfio_pci_core_mmap,
>>>> +    .request    = vfio_pci_core_request,
>>>> +    .match        = vfio_pci_core_match,
>>>> +};
>>>> +
>>>> +static int npu2_vfio_pci_probe(struct pci_dev *pdev,
>>>> +        const struct pci_device_id *id)
>>>> +{
>>>> +    struct npu2_vfio_pci_device *npvdev;
>>>> +    int ret;
>>>> +
>>>> +    npvdev = kzalloc(sizeof(*npvdev), GFP_KERNEL);
>>>> +    if (!npvdev)
>>>> +        return -ENOMEM;
>>>> +
>>>> +    ret = vfio_pci_core_register_device(&npvdev->vdev, pdev,
>>>> +            &npu2_vfio_pci_ops);
>>>> +    if (ret)
>>>> +        goto out_free;
>>>> +
>>>> +    return 0;
>>>> +
>>>> +out_free:
>>>> +    kfree(npvdev);
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static void npu2_vfio_pci_remove(struct pci_dev *pdev)
>>>> +{
>>>> +    struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>>>> +    struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
>>>> +    struct npu2_vfio_pci_device *npvdev;
>>>> +
>>>> +    npvdev = container_of(core_vpdev, struct npu2_vfio_pci_device, 
>>>> vdev);
>>>> +
>>>> +    vfio_pci_core_unregister_device(core_vpdev);
>>>> +    kfree(npvdev);
>>>> +}
>>>> +
>>>> +static const struct pci_device_id npu2_vfio_pci_table[] = {
>>>> +    { PCI_VDEVICE(IBM, 0x04ea) },
>>>> +    { 0, }
>>>> +};
>>>> +
>>>> +static struct pci_driver npu2_vfio_pci_driver = {
>>>> +    .name            = "npu2-vfio-pci",
>>>> +    .id_table        = npu2_vfio_pci_table,
>>>> +    .probe            = npu2_vfio_pci_probe,
>>>> +    .remove            = npu2_vfio_pci_remove,
>>>> +#ifdef CONFIG_PCI_IOV
>>>> +    .sriov_configure    = vfio_pci_core_sriov_configure,
>>>> +#endif
>>>> +    .err_handler        = &vfio_pci_core_err_handlers,
>>>> +};
>>>> +
>>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>>> +struct pci_driver *get_npu2_vfio_pci_driver(struct pci_dev *pdev)
>>>> +{
>>>> +    if (pci_match_id(npu2_vfio_pci_driver.id_table, pdev))
>>>> +        return &npu2_vfio_pci_driver;
>>>> +    return NULL;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(get_npu2_vfio_pci_driver);
>>>> +#endif
>>>> +
>>>> +module_pci_driver(npu2_vfio_pci_driver);
>>>> +
>>>> +MODULE_VERSION(DRIVER_VERSION);
>>>> +MODULE_LICENSE("GPL v2");
>>>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>>>> +MODULE_DESCRIPTION(DRIVER_DESC);
>>>> diff --git a/drivers/vfio/pci/npu2_vfio_pci.h 
>>>> b/drivers/vfio/pci/npu2_vfio_pci.h
>>>> new file mode 100644
>>>> index 000000000000..92010d340346
>>>> --- /dev/null
>>>> +++ b/drivers/vfio/pci/npu2_vfio_pci.h
>>>> @@ -0,0 +1,24 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/*
>>>> + * Copyright (c) 2020, Mellanox Technologies, Ltd.  All rights 
>>>> reserved.
>>>> + *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> + */
>>>> +
>>>> +#ifndef NPU2_VFIO_PCI_H
>>>> +#define NPU2_VFIO_PCI_H
>>>> +
>>>> +#include <linux/pci.h>
>>>> +#include <linux/module.h>
>>>> +
>>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>>> +#if defined(CONFIG_VFIO_PCI_NPU2) || 
>>>> defined(CONFIG_VFIO_PCI_NPU2_MODULE)
>>>> +struct pci_driver *get_npu2_vfio_pci_driver(struct pci_dev *pdev);
>>>> +#else
>>>> +struct pci_driver *get_npu2_vfio_pci_driver(struct pci_dev *pdev)
>>>> +{
>>>> +    return NULL;
>>>> +}
>>>> +#endif
>>>> +#endif
>>>> +
>>>> +#endif /* NPU2_VFIO_PCI_H */
>>>> diff --git a/drivers/vfio/pci/vfio_pci_nvlink2gpu.c 
>>>> b/drivers/vfio/pci/nvlink2gpu_vfio_pci.c
>>>> similarity index 67%
>>>> rename from drivers/vfio/pci/vfio_pci_nvlink2gpu.c
>>>> rename to drivers/vfio/pci/nvlink2gpu_vfio_pci.c
>>>> index 6dce1e78ee82..84a5ac1ce8ac 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_nvlink2gpu.c
>>>> +++ b/drivers/vfio/pci/nvlink2gpu_vfio_pci.c
>>>> @@ -1,6 +1,6 @@
>>>>   // SPDX-License-Identifier: GPL-2.0-only
>>>>   /*
>>>> - * VFIO PCI NVIDIA Whitherspoon GPU support a.k.a. NVLink2.
>>>> + * VFIO PCI NVIDIA NVLink2 GPUs support.
>>>>    *
>>>>    * Copyright (C) 2018 IBM Corp.  All rights reserved.
>>>>    *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
>>>> @@ -12,6 +12,9 @@
>>>>    *    Author: Alex Williamson <alex.williamson@redhat.com>
>>>>    */
>>>>   +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>>> +
>>>> +#include <linux/module.h>
>>>>   #include <linux/io.h>
>>>>   #include <linux/pci.h>
>>>>   #include <linux/uaccess.h>
>>>> @@ -21,10 +24,15 @@
>>>>   #include <asm/kvm_ppc.h>
>>>>     #include "vfio_pci_core.h"
>>>> +#include "nvlink2gpu_vfio_pci.h"
>>>>     #define CREATE_TRACE_POINTS
>>>>   #include "nvlink2gpu_trace.h"
>>>>   +#define DRIVER_VERSION  "0.1"
>>>> +#define DRIVER_AUTHOR   "Alexey Kardashevskiy <aik@ozlabs.ru>"
>>>> +#define DRIVER_DESC     "NVLINK2GPU VFIO PCI - User Level 
>>>> meta-driver for NVIDIA NVLink2 GPUs"
>>>> +
>>>>   EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_nvgpu_mmap_fault);
>>>>   EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_nvgpu_mmap);
>>>>   @@ -39,6 +47,10 @@ struct vfio_pci_nvgpu_data {
>>>>       struct notifier_block group_notifier;
>>>>   };
>>>>   +struct nv_vfio_pci_device {
>>>> +    struct vfio_pci_core_device    vdev;
>>>> +};
>>>> +
>>>>   static size_t vfio_pci_nvgpu_rw(struct vfio_pci_core_device *vdev,
>>>>           char __user *buf, size_t count, loff_t *ppos, bool iswrite)
>>>>   {
>>>> @@ -207,7 +219,8 @@ static int vfio_pci_nvgpu_group_notifier(struct 
>>>> notifier_block *nb,
>>>>       return NOTIFY_OK;
>>>>   }
>>>>   -int vfio_pci_nvidia_v100_nvlink2_init(struct 
>>>> vfio_pci_core_device *vdev)
>>>> +static int
>>>> +vfio_pci_nvidia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
>>>>   {
>>>>       int ret;
>>>>       u64 reg[2];
>>>> @@ -293,3 +306,135 @@ int vfio_pci_nvidia_v100_nvlink2_init(struct 
>>>> vfio_pci_core_device *vdev)
>>>>         return ret;
>>>>   }
>>>> +
>>>> +static void nvlink2gpu_vfio_pci_release(void *device_data)
>>>> +{
>>>> +    struct vfio_pci_core_device *vdev = device_data;
>>>> +
>>>> +    mutex_lock(&vdev->reflck->lock);
>>>> +    if (!(--vdev->refcnt)) {
>>>> +        vfio_pci_vf_token_user_add(vdev, -1);
>>>> +        vfio_pci_core_spapr_eeh_release(vdev);
>>>> +        vfio_pci_core_disable(vdev);
>>>> +    }
>>>> +    mutex_unlock(&vdev->reflck->lock);
>>>> +
>>>> +    module_put(THIS_MODULE);
>>>> +}
>>>> +
>>>> +static int nvlink2gpu_vfio_pci_open(void *device_data)
>>>> +{
>>>> +    struct vfio_pci_core_device *vdev = device_data;
>>>> +    int ret = 0;
>>>> +
>>>> +    if (!try_module_get(THIS_MODULE))
>>>> +        return -ENODEV;
>>>> +
>>>> +    mutex_lock(&vdev->reflck->lock);
>>>> +
>>>> +    if (!vdev->refcnt) {
>>>> +        ret = vfio_pci_core_enable(vdev);
>>>> +        if (ret)
>>>> +            goto error;
>>>> +
>>>> +        ret = vfio_pci_nvidia_v100_nvlink2_init(vdev);
>>>> +        if (ret && ret != -ENODEV) {
>>>> +            pci_warn(vdev->pdev,
>>>> +                 "Failed to setup NVIDIA NV2 RAM region\n");
>>>> +            vfio_pci_core_disable(vdev);
>>>> +            goto error;
>>>> +        }
>>>> +        ret = 0;
>>>> +        vfio_pci_probe_mmaps(vdev);
>>>> +        vfio_pci_core_spapr_eeh_open(vdev);
>>>> +        vfio_pci_vf_token_user_add(vdev, 1);
>>>> +    }
>>>> +    vdev->refcnt++;
>>>> +error:
>>>> +    mutex_unlock(&vdev->reflck->lock);
>>>> +    if (ret)
>>>> +        module_put(THIS_MODULE);
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static const struct vfio_device_ops nvlink2gpu_vfio_pci_ops = {
>>>> +    .name        = "nvlink2gpu-vfio-pci",
>>>> +    .open        = nvlink2gpu_vfio_pci_open,
>>>> +    .release    = nvlink2gpu_vfio_pci_release,
>>>> +    .ioctl        = vfio_pci_core_ioctl,
>>>> +    .read        = vfio_pci_core_read,
>>>> +    .write        = vfio_pci_core_write,
>>>> +    .mmap        = vfio_pci_core_mmap,
>>>> +    .request    = vfio_pci_core_request,
>>>> +    .match        = vfio_pci_core_match,
>>>> +};
>>>> +
>>>> +static int nvlink2gpu_vfio_pci_probe(struct pci_dev *pdev,
>>>> +        const struct pci_device_id *id)
>>>> +{
>>>> +    struct nv_vfio_pci_device *nvdev;
>>>> +    int ret;
>>>> +
>>>> +    nvdev = kzalloc(sizeof(*nvdev), GFP_KERNEL);
>>>> +    if (!nvdev)
>>>> +        return -ENOMEM;
>>>> +
>>>> +    ret = vfio_pci_core_register_device(&nvdev->vdev, pdev,
>>>> +            &nvlink2gpu_vfio_pci_ops);
>>>> +    if (ret)
>>>> +        goto out_free;
>>>> +
>>>> +    return 0;
>>>> +
>>>> +out_free:
>>>> +    kfree(nvdev);
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static void nvlink2gpu_vfio_pci_remove(struct pci_dev *pdev)
>>>> +{
>>>> +    struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>>>> +    struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
>>>> +    struct nv_vfio_pci_device *nvdev;
>>>> +
>>>> +    nvdev = container_of(core_vpdev, struct nv_vfio_pci_device, 
>>>> vdev);
>>>> +
>>>> +    vfio_pci_core_unregister_device(core_vpdev);
>>>> +    kfree(nvdev);
>>>> +}
>>>> +
>>>> +static const struct pci_device_id nvlink2gpu_vfio_pci_table[] = {
>>>> +    { PCI_VDEVICE(NVIDIA, 0x1DB1) }, /* GV100GL-A NVIDIA Tesla 
>>>> V100-SXM2-16GB */
>>>> +    { PCI_VDEVICE(NVIDIA, 0x1DB5) }, /* GV100GL-A NVIDIA Tesla 
>>>> V100-SXM2-32GB */
>>>> +    { PCI_VDEVICE(NVIDIA, 0x1DB8) }, /* GV100GL-A NVIDIA Tesla 
>>>> V100-SXM3-32GB */
>>>> +    { PCI_VDEVICE(NVIDIA, 0x1DF5) }, /* GV100GL-B NVIDIA Tesla 
>>>> V100-SXM2-16GB */
>>>
>>>
>>> Where is this list from?
>>>
>>> Also, how is this supposed to work at the boot time? Will the kernel 
>>> try binding let's say this one and nouveau? Which one is going to win?
>>
>> At boot time nouveau driver will win since the vfio drivers don't 
>> declare MODULE_DEVICE_TABLE
>
>
> ok but where is the list from anyway?

I did some checkings and was told that the SXM devices where the ones 
that were integrated into P9.

If you or anyone on the mailing list has some comments here, please add 
them and I'll do double check.

>
>
>>
>>
>>>
>>>
>>>> +    { 0, }
>>>
>>>
>>> Why a comma?
>>
>> I'll remove the comma.
>>
>>
>>>
>>>> +};
>>>
>>>
>>>
>>>> +
>>>> +static struct pci_driver nvlink2gpu_vfio_pci_driver = {
>>>> +    .name            = "nvlink2gpu-vfio-pci",
>>>> +    .id_table        = nvlink2gpu_vfio_pci_table,
>>>> +    .probe            = nvlink2gpu_vfio_pci_probe,
>>>> +    .remove            = nvlink2gpu_vfio_pci_remove,
>>>> +#ifdef CONFIG_PCI_IOV
>>>> +    .sriov_configure    = vfio_pci_core_sriov_configure,
>>>> +#endif
>>>
>>>
>>> What is this IOV business about?
>>
>> from vfio_pci
>>
>> #ifdef CONFIG_PCI_IOV
>> module_param(enable_sriov, bool, 0644);
>> MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV 
>> configuration.  Enabling SR-IOV on a PF typically requires support of 
>> the userspace PF driver, enabling VFs without such support may result 
>> in non-functional VFs or PF.");
>> #endif
>
>
> I know what IOV is in general :) What I meant to say was that I am 
> pretty sure these GPUs cannot do IOV so this does not need to be in 
> these NVLink drivers.

Thanks.

I'll verify it and remove for v4.


>
>
>
>>
>>
>>>
>>>
>>>> +    .err_handler        = &vfio_pci_core_err_handlers,
>>>> +};
>>>> +
>>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev 
>>>> *pdev)
>>>> +{
>>>> +    if (pci_match_id(nvlink2gpu_vfio_pci_driver.id_table, pdev))
>>>> +        return &nvlink2gpu_vfio_pci_driver;
>>>
>>>
>>> Why do we need matching PCI ids here instead of looking at the FDT 
>>> which will work better?
>>
>> what is FDT ? any is it better to use it instead of match_id ?
>
>
> Flattened Device Tree - a way for the firmware to pass the 
> configuration to the OS. This data tells if there are NVLinks and what 
> they are linked to. This defines if the feature is available as it 
> should work with any GPU in this form factor.
>
>
>>
>>>
>>>
>>>> +    return NULL;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(get_nvlink2gpu_vfio_pci_driver);
>>>> +#endif
>>>> +
>>>> +module_pci_driver(nvlink2gpu_vfio_pci_driver);
>>>> +
>>>> +MODULE_VERSION(DRIVER_VERSION);
>>>> +MODULE_LICENSE("GPL v2");
>>>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>>>> +MODULE_DESCRIPTION(DRIVER_DESC);
>>>> diff --git a/drivers/vfio/pci/nvlink2gpu_vfio_pci.h 
>>>> b/drivers/vfio/pci/nvlink2gpu_vfio_pci.h
>>>> new file mode 100644
>>>> index 000000000000..ebd5b600b190
>>>> --- /dev/null
>>>> +++ b/drivers/vfio/pci/nvlink2gpu_vfio_pci.h
>>>> @@ -0,0 +1,24 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/*
>>>> + * Copyright (c) 2020, Mellanox Technologies, Ltd.  All rights 
>>>> reserved.
>>>> + *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> + */
>>>> +
>>>> +#ifndef NVLINK2GPU_VFIO_PCI_H
>>>> +#define NVLINK2GPU_VFIO_PCI_H
>>>> +
>>>> +#include <linux/pci.h>
>>>> +#include <linux/module.h>
>>>> +
>>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>>> +#if defined(CONFIG_VFIO_PCI_NVLINK2GPU) || 
>>>> defined(CONFIG_VFIO_PCI_NVLINK2GPU_MODULE)
>>>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev 
>>>> *pdev);
>>>> +#else
>>>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev 
>>>> *pdev)
>>>> +{
>>>> +    return NULL;
>>>> +}
>>>> +#endif
>>>> +#endif
>>>> +
>>>> +#endif /* NVLINK2GPU_VFIO_PCI_H */
>>>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>>>> index dbc0a6559914..8e81ea039f31 100644
>>>> --- a/drivers/vfio/pci/vfio_pci.c
>>>> +++ b/drivers/vfio/pci/vfio_pci.c
>>>> @@ -27,6 +27,10 @@
>>>>   #include <linux/uaccess.h>
>>>>     #include "vfio_pci_core.h"
>>>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>>>> +#include "npu2_vfio_pci.h"
>>>> +#include "nvlink2gpu_vfio_pci.h"
>>>> +#endif
>>>>     #define DRIVER_VERSION  "0.2"
>>>>   #define DRIVER_AUTHOR   "Alex Williamson 
>>>> <alex.williamson@redhat.com>"
>>>> @@ -142,14 +146,48 @@ static const struct vfio_device_ops 
>>>> vfio_pci_ops = {
>>>>       .match        = vfio_pci_core_match,
>>>>   };
>>>>   +/*
>>>> + * This layer is used for backward compatibility. Hopefully it 
>>>> will be
>>>> + * removed in the future.
>>>> + */
>>>> +static struct pci_driver *vfio_pci_get_compat_driver(struct 
>>>> pci_dev *pdev)
>>>> +{
>>>> +    switch (pdev->vendor) {
>>>> +    case PCI_VENDOR_ID_NVIDIA:
>>>> +        switch (pdev->device) {
>>>> +        case 0x1db1:
>>>> +        case 0x1db5:
>>>> +        case 0x1db8:
>>>> +        case 0x1df5:
>>>> +            return get_nvlink2gpu_vfio_pci_driver(pdev);
>>>
>>> This does not really need a switch, could simply call these 
>>> get_xxxx_vfio_pci_driver. Thanks,
>>
>> maybe the result will be the same but I don't think we need to send 
>> all NVIDIA devices or IBM devices to this function.
>
> We can tolerate this on POWER (the check is really cheap) and for 
> everybody else this driver won't even compile.

I'll improve this function.

Thanks.


>
>
>> we can maybe export the tables from the vfio_vendor driver and match 
>> it here.
>
>
> I am still missing the point of device matching. It won't bind by 
> default at the boot time and it won't make the existing user life any 
> easier as they use libvirt which overrides this anyway.

we're trying to improve the subsystem to be more flexible and we still 
want to preserve backward compatibility for the near future.


>
>
>>>
>>>
>>>> +        default:
>>>> +            return NULL;
>>>> +        }
>>>> +    case PCI_VENDOR_ID_IBM:
>>>> +        switch (pdev->device) {
>>>> +        case 0x04ea:
>>>> +            return get_npu2_vfio_pci_driver(pdev);
>>>> +        default:
>>>> +            return NULL;
>>>> +        }
>>>> +    }
>>>> +
>>>> +    return NULL;
>>>> +}
>>>> +
>>>>   static int vfio_pci_probe(struct pci_dev *pdev, const struct 
>>>> pci_device_id *id)
>>>>   {
>>>>       struct vfio_pci_device *vpdev;
>>>> +    struct pci_driver *driver;
>>>>       int ret;
>>>>         if (vfio_pci_is_denylisted(pdev))
>>>>           return -EINVAL;
>>>>   +    driver = vfio_pci_get_compat_driver(pdev);
>>>> +    if (driver)
>>>> +        return driver->probe(pdev, id);
>>>> +
>>>>       vpdev = kzalloc(sizeof(*vpdev), GFP_KERNEL);
>>>>       if (!vpdev)
>>>>           return -ENOMEM;
>>>> @@ -167,14 +205,21 @@ static int vfio_pci_probe(struct pci_dev 
>>>> *pdev, const struct pci_device_id *id)
>>>>     static void vfio_pci_remove(struct pci_dev *pdev)
>>>>   {
>>>> -    struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>>>> -    struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
>>>> -    struct vfio_pci_device *vpdev;
>>>> -
>>>> -    vpdev = container_of(core_vpdev, struct vfio_pci_device, vdev);
>>>> -
>>>> -    vfio_pci_core_unregister_device(core_vpdev);
>>>> -    kfree(vpdev);
>>>> +    struct pci_driver *driver;
>>>> +
>>>> +    driver = vfio_pci_get_compat_driver(pdev);
>>>> +    if (driver) {
>>>> +        driver->remove(pdev);
>>>> +    } else {
>>>> +        struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>>>> +        struct vfio_pci_core_device *core_vpdev;
>>>> +        struct vfio_pci_device *vpdev;
>>>> +
>>>> +        core_vpdev = vfio_device_data(vdev);
>>>> +        vpdev = container_of(core_vpdev, struct vfio_pci_device, 
>>>> vdev);
>>>> +        vfio_pci_core_unregister_device(core_vpdev);
>>>> +        kfree(vpdev);
>>>> +    }
>>>>   }
>>>>     static int vfio_pci_sriov_configure(struct pci_dev *pdev, int 
>>>> nr_virtfn)
>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c 
>>>> b/drivers/vfio/pci/vfio_pci_core.c
>>>> index 4de8e352df9c..f9b39abe54cb 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>>> @@ -354,24 +354,6 @@ int vfio_pci_core_enable(struct 
>>>> vfio_pci_core_device *vdev)
>>>>           }
>>>>       }
>>>>   -    if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
>>>> -        IS_ENABLED(CONFIG_VFIO_PCI_NVLINK2)) {
>>>> -        ret = vfio_pci_nvidia_v100_nvlink2_init(vdev);
>>>> -        if (ret && ret != -ENODEV) {
>>>> -            pci_warn(pdev, "Failed to setup NVIDIA NV2 RAM 
>>>> region\n");
>>>> -            goto disable_exit;
>>>> -        }
>>>> -    }
>>>> -
>>>> -    if (pdev->vendor == PCI_VENDOR_ID_IBM &&
>>>> -        IS_ENABLED(CONFIG_VFIO_PCI_NVLINK2)) {
>>>> -        ret = vfio_pci_ibm_npu2_init(vdev);
>>>> -        if (ret && ret != -ENODEV) {
>>>> -            pci_warn(pdev, "Failed to setup NVIDIA NV2 ATSD 
>>>> region\n");
>>>> -            goto disable_exit;
>>>> -        }
>>>> -    }
>>>> -
>>>>       return 0;
>>>>     disable_exit:
>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.h 
>>>> b/drivers/vfio/pci/vfio_pci_core.h
>>>> index 8989443c3086..31f3836e606e 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_core.h
>>>> +++ b/drivers/vfio/pci/vfio_pci_core.h
>>>> @@ -204,20 +204,6 @@ static inline int vfio_pci_igd_init(struct 
>>>> vfio_pci_core_device *vdev)
>>>>       return -ENODEV;
>>>>   }
>>>>   #endif
>>>> -#ifdef CONFIG_VFIO_PCI_NVLINK2
>>>> -extern int vfio_pci_nvidia_v100_nvlink2_init(struct 
>>>> vfio_pci_core_device *vdev);
>>>> -extern int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev);
>>>> -#else
>>>> -static inline int vfio_pci_nvidia_v100_nvlink2_init(struct 
>>>> vfio_pci_core_device *vdev)
>>>> -{
>>>> -    return -ENODEV;
>>>> -}
>>>> -
>>>> -static inline int vfio_pci_ibm_npu2_init(struct 
>>>> vfio_pci_core_device *vdev)
>>>> -{
>>>> -    return -ENODEV;
>>>> -}
>>>> -#endif
>>>>     #ifdef CONFIG_S390
>>>>   extern int vfio_pci_info_zdev_add_caps(struct 
>>>> vfio_pci_core_device *vdev,
>>>>
>>>
>
