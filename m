Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7294333D29
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 13:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhCJM6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 07:58:45 -0500
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:3809
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232540AbhCJM6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 07:58:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6nMNJIuwX1mHqL1eaprzlVUj/UmOlbF7ypT2EUGf9vpgQg0YQzltvztL0vll600WHWmLXW3hUW5xqcB48amfgFb7JjfareTdizKyi7fnL4OV0Ac26s8Rmj4My3U+DP/ssHu/Al2xynKJ/z1pU1CEuFz8pyfouInw8lF8wCu4L8oc2ieyOQuNFwtfx2OdpVtbwh1fAg+zVH++C9h+EJO/LH6UlE4/QEyowNmpS2SnPMraJ114bfG3Ta9kh2lpucBQtItD4/XpH/4a2CPtJELLejmg4YV0lQyiEWqccvwSHZ+3L/RSFODpCzZNI7uqRNDAggwAjd/vz2j6VK86b15+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYFUoP2P0XTpuu4fukI5akvOhPngYP9S5MjHNIznMO8=;
 b=oT/OyC7sBu/M3VdvOy5ntAP+grFCm7TlDNysleLF7Vt3En0FH5o1bS8NXySrh8gwhEtFbHiHk+lvWXM0zIyiJtppdH1hp8V/hl2ChU/i3g/Wrt8ZpcTWTJY1hGqpgTfpmmIVKbupnAnjZ3UZRD38oN6tMzhpbexKRcq+XbZ4uOdgBcUz+5nmuzYXpgJCfPPF4Hs+pzpW0gTbN9CvPV8VB4m/H80H3y3Rk1WT+b5Q8petzw+2FDRay820H9tG5iB4AuX9ZE9IQMuFzy8zxm+KMGvhTa39Mv6A639xS/pCPh959MrGjNCtw0Z+nuR1mM5bEnuZ+POvOayiPYJ8ouKHRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYFUoP2P0XTpuu4fukI5akvOhPngYP9S5MjHNIznMO8=;
 b=MGYsUyzp/Pw3v1xyRSKFEgfOMbPf9YeOC2XPVjaIBc+nRe9XexpnmW4IGFvR0Am0MZh1vxXbsqVAj0fVEYNaR2ZGyqAGJNkplsissqpd9bi9vzSSdtXqvd0PtssSzr20mJ0LFYALnQojgqQpQsmAYOIDQEmeF5f997CPHsaclR8SxKbdGtEE9b/srIpbItodYh7HzCpP+zXHajYOvyF8roPxE9zhld83hcAC6oWrWU+O5uW5FaPXdOIRfpTcdacamVGvu+T2n9SMYwmogZi/0fmbEakDv+69/JKWQnHU+XSmRQoZnoeMaoB0L0aelh3Pyti/GpXTTzJgZFiu093+Mw==
Received: from CO2PR05CA0103.namprd05.prod.outlook.com (2603:10b6:104:1::29)
 by MN2PR12MB3984.namprd12.prod.outlook.com (2603:10b6:208:16f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 12:58:06 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::7c) by CO2PR05CA0103.outlook.office365.com
 (2603:10b6:104:1::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend
 Transport; Wed, 10 Mar 2021 12:58:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 12:58:05 +0000
Received: from [172.27.11.49] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 12:57:59 +0000
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
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
Date:   Wed, 10 Mar 2021 14:57:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 012850f3-39e1-46a0-5221-08d8e3c425d6
X-MS-TrafficTypeDiagnostic: MN2PR12MB3984:
X-Microsoft-Antispam-PRVS: <MN2PR12MB398421A6BD78C69E1B1C7721DE919@MN2PR12MB3984.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k9vwC5k9RVvD+varrfH0PEB5jWqlapjJyGpzKOrgOUFwIuoFBY+/LHVIA4kDXLh32KZAg0mXlIMJ6O1eeIGyxygeDCl1H51Y8NbUBQjB92Ux0/orizfQQdO/Z2EEOt/Z6gvjh2TPNwAA4n7AfXuLw6c7kZEZKrFS5Ji861Z6qIBGCYb4NIMO/g8CY4bcMnkH960gnGAW0+vSD71t+BYgK/qB2EXXV9y3Ao46klXsMeMcC5H4DoZNRiNTYB7nIenXG/ESqPo4R+58i9C0qLNyDuKSBTROlq1HP1KNA2GQFPUy5jP6OGZUk5Ab190HG/9H360aSnN1DEhUhSyF8+aJUvnlPcFbfcwR3wwIOMzJ+BtlU0wl/cMgzDaE0iz09+fvF5fSrB7+8g6pUbt5xqNVq7g3ELhiK05N7ywM7l9NBp/xg7bCWDHNQhfUlZN6lNpWUAi0w6vdT1+7FeZVSBOFSq4J83PANbhrtSYruBY2JcjCc2o6zQOprItPo/aysr4S8rIb6y6HRfw5036WydjrtN1+F1YiB/om/IrSe0m3MnbM9GBysWKerUDMRAurc1m6PxqdP7MNbCgPnlE/kv5QQBjLLTK/SEQqPWCV/vzNfP+lBUbgvR3yjd27tVd2aY3aGXFh6mHH5Zxtcc5N30yGc9/Sz06mgrcmq4a0yW7unw2FxP9ArddhjWvpt9cRhIEN3CYZUUFLo4+gGCejO9lldQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(46966006)(36840700001)(86362001)(4326008)(70206006)(426003)(5660300002)(31696002)(2906002)(53546011)(2616005)(336012)(83380400001)(8676002)(7636003)(36906005)(316002)(26005)(34020700004)(82310400003)(30864003)(16576012)(54906003)(110136005)(82740400003)(36860700001)(70586007)(47076005)(16526019)(356005)(186003)(31686004)(8936002)(36756003)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 12:58:05.9863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 012850f3-39e1-46a0-5221-08d8e3c425d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3984
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/10/2021 8:39 AM, Alexey Kardashevskiy wrote:
>
>
> On 09/03/2021 19:33, Max Gurtovoy wrote:
>> The new drivers introduced are nvlink2gpu_vfio_pci.ko and
>> npu2_vfio_pci.ko.
>> The first will be responsible for providing special extensions for
>> NVIDIA GPUs with NVLINK2 support for P9 platform (and others in the
>> future). The last will be responsible for POWER9 NPU2 unit (NVLink2 host
>> bus adapter).
>>
>> Also, preserve backward compatibility for users that were binding
>> NVLINK2 devices to vfio_pci.ko. Hopefully this compatibility layer will
>> be dropped in the future
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>   drivers/vfio/pci/Kconfig                      |  28 +++-
>>   drivers/vfio/pci/Makefile                     |   7 +-
>>   .../pci/{vfio_pci_npu2.c => npu2_vfio_pci.c}  | 144 ++++++++++++++++-
>>   drivers/vfio/pci/npu2_vfio_pci.h              |  24 +++
>>   ...pci_nvlink2gpu.c => nvlink2gpu_vfio_pci.c} | 149 +++++++++++++++++-
>>   drivers/vfio/pci/nvlink2gpu_vfio_pci.h        |  24 +++
>>   drivers/vfio/pci/vfio_pci.c                   |  61 ++++++-
>>   drivers/vfio/pci/vfio_pci_core.c              |  18 ---
>>   drivers/vfio/pci/vfio_pci_core.h              |  14 --
>>   9 files changed, 422 insertions(+), 47 deletions(-)
>>   rename drivers/vfio/pci/{vfio_pci_npu2.c => npu2_vfio_pci.c} (64%)
>>   create mode 100644 drivers/vfio/pci/npu2_vfio_pci.h
>>   rename drivers/vfio/pci/{vfio_pci_nvlink2gpu.c => 
>> nvlink2gpu_vfio_pci.c} (67%)
>>   create mode 100644 drivers/vfio/pci/nvlink2gpu_vfio_pci.h
>>
>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>> index 829e90a2e5a3..88c89863a205 100644
>> --- a/drivers/vfio/pci/Kconfig
>> +++ b/drivers/vfio/pci/Kconfig
>> @@ -48,8 +48,30 @@ config VFIO_PCI_IGD
>>           To enable Intel IGD assignment through vfio-pci, say Y.
>>   -config VFIO_PCI_NVLINK2
>> -    def_bool y
>> +config VFIO_PCI_NVLINK2GPU
>> +    tristate "VFIO support for NVIDIA NVLINK2 GPUs"
>>       depends on VFIO_PCI_CORE && PPC_POWERNV
>>       help
>> -      VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
>> +      VFIO PCI driver for NVIDIA NVLINK2 GPUs with specific extensions
>> +      for P9 Witherspoon machine.
>> +
>> +config VFIO_PCI_NPU2
>> +    tristate "VFIO support for IBM NPU host bus adapter on P9"
>> +    depends on VFIO_PCI_NVLINK2GPU && PPC_POWERNV
>> +    help
>> +      VFIO PCI specific extensions for IBM NVLink2 host bus adapter 
>> on P9
>> +      Witherspoon machine.
>> +
>> +config VFIO_PCI_DRIVER_COMPAT
>> +    bool "VFIO PCI backward compatibility for vendor specific 
>> extensions"
>> +    default y
>> +    depends on VFIO_PCI
>> +    help
>> +      Say Y here if you want to preserve VFIO PCI backward
>> +      compatibility. vfio_pci.ko will continue to automatically use
>> +      the NVLINK2, NPU2 and IGD VFIO drivers when it is attached to
>> +      a compatible device.
>> +
>> +      When N is selected the user must bind explicity to the module
>> +      they want to handle the device and vfio_pci.ko will have no
>> +      device specific special behaviors.
>> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
>> index f539f32c9296..86fb62e271fc 100644
>> --- a/drivers/vfio/pci/Makefile
>> +++ b/drivers/vfio/pci/Makefile
>> @@ -2,10 +2,15 @@
>>     obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>>   obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>> +obj-$(CONFIG_VFIO_PCI_NPU2) += npu2-vfio-pci.o
>> +obj-$(CONFIG_VFIO_PCI_NVLINK2GPU) += nvlink2gpu-vfio-pci.o
>>     vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o 
>> vfio_pci_rdwr.o vfio_pci_config.o
>>   vfio-pci-core-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>> -vfio-pci-core-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2gpu.o 
>> vfio_pci_npu2.o
>>   vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
>>     vfio-pci-y := vfio_pci.o
>> +
>> +npu2-vfio-pci-y := npu2_vfio_pci.o
>> +
>> +nvlink2gpu-vfio-pci-y := nvlink2gpu_vfio_pci.o
>> diff --git a/drivers/vfio/pci/vfio_pci_npu2.c 
>> b/drivers/vfio/pci/npu2_vfio_pci.c
>> similarity index 64%
>> rename from drivers/vfio/pci/vfio_pci_npu2.c
>> rename to drivers/vfio/pci/npu2_vfio_pci.c
>> index 717745256ab3..7071bda0f2b6 100644
>> --- a/drivers/vfio/pci/vfio_pci_npu2.c
>> +++ b/drivers/vfio/pci/npu2_vfio_pci.c
>> @@ -14,19 +14,28 @@
>>    *    Author: Alex Williamson <alex.williamson@redhat.com>
>>    */
>>   +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +
>> +#include <linux/module.h>
>>   #include <linux/io.h>
>>   #include <linux/pci.h>
>>   #include <linux/uaccess.h>
>>   #include <linux/vfio.h>
>> +#include <linux/list.h>
>>   #include <linux/sched/mm.h>
>>   #include <linux/mmu_context.h>
>>   #include <asm/kvm_ppc.h>
>>     #include "vfio_pci_core.h"
>> +#include "npu2_vfio_pci.h"
>>     #define CREATE_TRACE_POINTS
>>   #include "npu2_trace.h"
>>   +#define DRIVER_VERSION  "0.1"
>> +#define DRIVER_AUTHOR   "Alexey Kardashevskiy <aik@ozlabs.ru>"
>> +#define DRIVER_DESC     "NPU2 VFIO PCI - User Level meta-driver for 
>> POWER9 NPU NVLink2 HBA"
>> +
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_npu2_mmap);
>>     struct vfio_pci_npu2_data {
>> @@ -36,6 +45,10 @@ struct vfio_pci_npu2_data {
>>       unsigned int link_speed; /* The link speed from DT's 
>> ibm,nvlink-speed */
>>   };
>>   +struct npu2_vfio_pci_device {
>> +    struct vfio_pci_core_device    vdev;
>> +};
>> +
>>   static size_t vfio_pci_npu2_rw(struct vfio_pci_core_device *vdev,
>>           char __user *buf, size_t count, loff_t *ppos, bool iswrite)
>>   {
>> @@ -120,7 +133,7 @@ static const struct vfio_pci_regops 
>> vfio_pci_npu2_regops = {
>>       .add_capability = vfio_pci_npu2_add_capability,
>>   };
>>   -int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
>> +static int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
>>   {
>>       int ret;
>>       struct vfio_pci_npu2_data *data;
>> @@ -220,3 +233,132 @@ int vfio_pci_ibm_npu2_init(struct 
>> vfio_pci_core_device *vdev)
>>         return ret;
>>   }
>> +
>> +static void npu2_vfio_pci_release(void *device_data)
>> +{
>> +    struct vfio_pci_core_device *vdev = device_data;
>> +
>> +    mutex_lock(&vdev->reflck->lock);
>> +    if (!(--vdev->refcnt)) {
>> +        vfio_pci_vf_token_user_add(vdev, -1);
>> +        vfio_pci_core_spapr_eeh_release(vdev);
>> +        vfio_pci_core_disable(vdev);
>> +    }
>> +    mutex_unlock(&vdev->reflck->lock);
>> +
>> +    module_put(THIS_MODULE);
>> +}
>> +
>> +static int npu2_vfio_pci_open(void *device_data)
>> +{
>> +    struct vfio_pci_core_device *vdev = device_data;
>> +    int ret = 0;
>> +
>> +    if (!try_module_get(THIS_MODULE))
>> +        return -ENODEV;
>> +
>> +    mutex_lock(&vdev->reflck->lock);
>> +
>> +    if (!vdev->refcnt) {
>> +        ret = vfio_pci_core_enable(vdev);
>> +        if (ret)
>> +            goto error;
>> +
>> +        ret = vfio_pci_ibm_npu2_init(vdev);
>> +        if (ret && ret != -ENODEV) {
>> +            pci_warn(vdev->pdev,
>> +                 "Failed to setup NVIDIA NV2 ATSD region\n");
>> +            vfio_pci_core_disable(vdev);
>> +            goto error;
>> +        }
>> +        ret = 0;
>> +        vfio_pci_probe_mmaps(vdev);
>> +        vfio_pci_core_spapr_eeh_open(vdev);
>> +        vfio_pci_vf_token_user_add(vdev, 1);
>> +    }
>> +    vdev->refcnt++;
>> +error:
>> +    mutex_unlock(&vdev->reflck->lock);
>> +    if (ret)
>> +        module_put(THIS_MODULE);
>> +    return ret;
>> +}
>> +
>> +static const struct vfio_device_ops npu2_vfio_pci_ops = {
>> +    .name        = "npu2-vfio-pci",
>> +    .open        = npu2_vfio_pci_open,
>> +    .release    = npu2_vfio_pci_release,
>> +    .ioctl        = vfio_pci_core_ioctl,
>> +    .read        = vfio_pci_core_read,
>> +    .write        = vfio_pci_core_write,
>> +    .mmap        = vfio_pci_core_mmap,
>> +    .request    = vfio_pci_core_request,
>> +    .match        = vfio_pci_core_match,
>> +};
>> +
>> +static int npu2_vfio_pci_probe(struct pci_dev *pdev,
>> +        const struct pci_device_id *id)
>> +{
>> +    struct npu2_vfio_pci_device *npvdev;
>> +    int ret;
>> +
>> +    npvdev = kzalloc(sizeof(*npvdev), GFP_KERNEL);
>> +    if (!npvdev)
>> +        return -ENOMEM;
>> +
>> +    ret = vfio_pci_core_register_device(&npvdev->vdev, pdev,
>> +            &npu2_vfio_pci_ops);
>> +    if (ret)
>> +        goto out_free;
>> +
>> +    return 0;
>> +
>> +out_free:
>> +    kfree(npvdev);
>> +    return ret;
>> +}
>> +
>> +static void npu2_vfio_pci_remove(struct pci_dev *pdev)
>> +{
>> +    struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>> +    struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
>> +    struct npu2_vfio_pci_device *npvdev;
>> +
>> +    npvdev = container_of(core_vpdev, struct npu2_vfio_pci_device, 
>> vdev);
>> +
>> +    vfio_pci_core_unregister_device(core_vpdev);
>> +    kfree(npvdev);
>> +}
>> +
>> +static const struct pci_device_id npu2_vfio_pci_table[] = {
>> +    { PCI_VDEVICE(IBM, 0x04ea) },
>> +    { 0, }
>> +};
>> +
>> +static struct pci_driver npu2_vfio_pci_driver = {
>> +    .name            = "npu2-vfio-pci",
>> +    .id_table        = npu2_vfio_pci_table,
>> +    .probe            = npu2_vfio_pci_probe,
>> +    .remove            = npu2_vfio_pci_remove,
>> +#ifdef CONFIG_PCI_IOV
>> +    .sriov_configure    = vfio_pci_core_sriov_configure,
>> +#endif
>> +    .err_handler        = &vfio_pci_core_err_handlers,
>> +};
>> +
>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>> +struct pci_driver *get_npu2_vfio_pci_driver(struct pci_dev *pdev)
>> +{
>> +    if (pci_match_id(npu2_vfio_pci_driver.id_table, pdev))
>> +        return &npu2_vfio_pci_driver;
>> +    return NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(get_npu2_vfio_pci_driver);
>> +#endif
>> +
>> +module_pci_driver(npu2_vfio_pci_driver);
>> +
>> +MODULE_VERSION(DRIVER_VERSION);
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>> +MODULE_DESCRIPTION(DRIVER_DESC);
>> diff --git a/drivers/vfio/pci/npu2_vfio_pci.h 
>> b/drivers/vfio/pci/npu2_vfio_pci.h
>> new file mode 100644
>> index 000000000000..92010d340346
>> --- /dev/null
>> +++ b/drivers/vfio/pci/npu2_vfio_pci.h
>> @@ -0,0 +1,24 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2020, Mellanox Technologies, Ltd.  All rights 
>> reserved.
>> + *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
>> + */
>> +
>> +#ifndef NPU2_VFIO_PCI_H
>> +#define NPU2_VFIO_PCI_H
>> +
>> +#include <linux/pci.h>
>> +#include <linux/module.h>
>> +
>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>> +#if defined(CONFIG_VFIO_PCI_NPU2) || 
>> defined(CONFIG_VFIO_PCI_NPU2_MODULE)
>> +struct pci_driver *get_npu2_vfio_pci_driver(struct pci_dev *pdev);
>> +#else
>> +struct pci_driver *get_npu2_vfio_pci_driver(struct pci_dev *pdev)
>> +{
>> +    return NULL;
>> +}
>> +#endif
>> +#endif
>> +
>> +#endif /* NPU2_VFIO_PCI_H */
>> diff --git a/drivers/vfio/pci/vfio_pci_nvlink2gpu.c 
>> b/drivers/vfio/pci/nvlink2gpu_vfio_pci.c
>> similarity index 67%
>> rename from drivers/vfio/pci/vfio_pci_nvlink2gpu.c
>> rename to drivers/vfio/pci/nvlink2gpu_vfio_pci.c
>> index 6dce1e78ee82..84a5ac1ce8ac 100644
>> --- a/drivers/vfio/pci/vfio_pci_nvlink2gpu.c
>> +++ b/drivers/vfio/pci/nvlink2gpu_vfio_pci.c
>> @@ -1,6 +1,6 @@
>>   // SPDX-License-Identifier: GPL-2.0-only
>>   /*
>> - * VFIO PCI NVIDIA Whitherspoon GPU support a.k.a. NVLink2.
>> + * VFIO PCI NVIDIA NVLink2 GPUs support.
>>    *
>>    * Copyright (C) 2018 IBM Corp.  All rights reserved.
>>    *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
>> @@ -12,6 +12,9 @@
>>    *    Author: Alex Williamson <alex.williamson@redhat.com>
>>    */
>>   +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +
>> +#include <linux/module.h>
>>   #include <linux/io.h>
>>   #include <linux/pci.h>
>>   #include <linux/uaccess.h>
>> @@ -21,10 +24,15 @@
>>   #include <asm/kvm_ppc.h>
>>     #include "vfio_pci_core.h"
>> +#include "nvlink2gpu_vfio_pci.h"
>>     #define CREATE_TRACE_POINTS
>>   #include "nvlink2gpu_trace.h"
>>   +#define DRIVER_VERSION  "0.1"
>> +#define DRIVER_AUTHOR   "Alexey Kardashevskiy <aik@ozlabs.ru>"
>> +#define DRIVER_DESC     "NVLINK2GPU VFIO PCI - User Level 
>> meta-driver for NVIDIA NVLink2 GPUs"
>> +
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_nvgpu_mmap_fault);
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(vfio_pci_nvgpu_mmap);
>>   @@ -39,6 +47,10 @@ struct vfio_pci_nvgpu_data {
>>       struct notifier_block group_notifier;
>>   };
>>   +struct nv_vfio_pci_device {
>> +    struct vfio_pci_core_device    vdev;
>> +};
>> +
>>   static size_t vfio_pci_nvgpu_rw(struct vfio_pci_core_device *vdev,
>>           char __user *buf, size_t count, loff_t *ppos, bool iswrite)
>>   {
>> @@ -207,7 +219,8 @@ static int vfio_pci_nvgpu_group_notifier(struct 
>> notifier_block *nb,
>>       return NOTIFY_OK;
>>   }
>>   -int vfio_pci_nvidia_v100_nvlink2_init(struct vfio_pci_core_device 
>> *vdev)
>> +static int
>> +vfio_pci_nvidia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
>>   {
>>       int ret;
>>       u64 reg[2];
>> @@ -293,3 +306,135 @@ int vfio_pci_nvidia_v100_nvlink2_init(struct 
>> vfio_pci_core_device *vdev)
>>         return ret;
>>   }
>> +
>> +static void nvlink2gpu_vfio_pci_release(void *device_data)
>> +{
>> +    struct vfio_pci_core_device *vdev = device_data;
>> +
>> +    mutex_lock(&vdev->reflck->lock);
>> +    if (!(--vdev->refcnt)) {
>> +        vfio_pci_vf_token_user_add(vdev, -1);
>> +        vfio_pci_core_spapr_eeh_release(vdev);
>> +        vfio_pci_core_disable(vdev);
>> +    }
>> +    mutex_unlock(&vdev->reflck->lock);
>> +
>> +    module_put(THIS_MODULE);
>> +}
>> +
>> +static int nvlink2gpu_vfio_pci_open(void *device_data)
>> +{
>> +    struct vfio_pci_core_device *vdev = device_data;
>> +    int ret = 0;
>> +
>> +    if (!try_module_get(THIS_MODULE))
>> +        return -ENODEV;
>> +
>> +    mutex_lock(&vdev->reflck->lock);
>> +
>> +    if (!vdev->refcnt) {
>> +        ret = vfio_pci_core_enable(vdev);
>> +        if (ret)
>> +            goto error;
>> +
>> +        ret = vfio_pci_nvidia_v100_nvlink2_init(vdev);
>> +        if (ret && ret != -ENODEV) {
>> +            pci_warn(vdev->pdev,
>> +                 "Failed to setup NVIDIA NV2 RAM region\n");
>> +            vfio_pci_core_disable(vdev);
>> +            goto error;
>> +        }
>> +        ret = 0;
>> +        vfio_pci_probe_mmaps(vdev);
>> +        vfio_pci_core_spapr_eeh_open(vdev);
>> +        vfio_pci_vf_token_user_add(vdev, 1);
>> +    }
>> +    vdev->refcnt++;
>> +error:
>> +    mutex_unlock(&vdev->reflck->lock);
>> +    if (ret)
>> +        module_put(THIS_MODULE);
>> +    return ret;
>> +}
>> +
>> +static const struct vfio_device_ops nvlink2gpu_vfio_pci_ops = {
>> +    .name        = "nvlink2gpu-vfio-pci",
>> +    .open        = nvlink2gpu_vfio_pci_open,
>> +    .release    = nvlink2gpu_vfio_pci_release,
>> +    .ioctl        = vfio_pci_core_ioctl,
>> +    .read        = vfio_pci_core_read,
>> +    .write        = vfio_pci_core_write,
>> +    .mmap        = vfio_pci_core_mmap,
>> +    .request    = vfio_pci_core_request,
>> +    .match        = vfio_pci_core_match,
>> +};
>> +
>> +static int nvlink2gpu_vfio_pci_probe(struct pci_dev *pdev,
>> +        const struct pci_device_id *id)
>> +{
>> +    struct nv_vfio_pci_device *nvdev;
>> +    int ret;
>> +
>> +    nvdev = kzalloc(sizeof(*nvdev), GFP_KERNEL);
>> +    if (!nvdev)
>> +        return -ENOMEM;
>> +
>> +    ret = vfio_pci_core_register_device(&nvdev->vdev, pdev,
>> +            &nvlink2gpu_vfio_pci_ops);
>> +    if (ret)
>> +        goto out_free;
>> +
>> +    return 0;
>> +
>> +out_free:
>> +    kfree(nvdev);
>> +    return ret;
>> +}
>> +
>> +static void nvlink2gpu_vfio_pci_remove(struct pci_dev *pdev)
>> +{
>> +    struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>> +    struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
>> +    struct nv_vfio_pci_device *nvdev;
>> +
>> +    nvdev = container_of(core_vpdev, struct nv_vfio_pci_device, vdev);
>> +
>> +    vfio_pci_core_unregister_device(core_vpdev);
>> +    kfree(nvdev);
>> +}
>> +
>> +static const struct pci_device_id nvlink2gpu_vfio_pci_table[] = {
>> +    { PCI_VDEVICE(NVIDIA, 0x1DB1) }, /* GV100GL-A NVIDIA Tesla 
>> V100-SXM2-16GB */
>> +    { PCI_VDEVICE(NVIDIA, 0x1DB5) }, /* GV100GL-A NVIDIA Tesla 
>> V100-SXM2-32GB */
>> +    { PCI_VDEVICE(NVIDIA, 0x1DB8) }, /* GV100GL-A NVIDIA Tesla 
>> V100-SXM3-32GB */
>> +    { PCI_VDEVICE(NVIDIA, 0x1DF5) }, /* GV100GL-B NVIDIA Tesla 
>> V100-SXM2-16GB */
>
>
> Where is this list from?
>
> Also, how is this supposed to work at the boot time? Will the kernel 
> try binding let's say this one and nouveau? Which one is going to win?

At boot time nouveau driver will win since the vfio drivers don't 
declare MODULE_DEVICE_TABLE


>
>
>> +    { 0, }
>
>
> Why a comma?

I'll remove the comma.


>
>> +};
>
>
>
>> +
>> +static struct pci_driver nvlink2gpu_vfio_pci_driver = {
>> +    .name            = "nvlink2gpu-vfio-pci",
>> +    .id_table        = nvlink2gpu_vfio_pci_table,
>> +    .probe            = nvlink2gpu_vfio_pci_probe,
>> +    .remove            = nvlink2gpu_vfio_pci_remove,
>> +#ifdef CONFIG_PCI_IOV
>> +    .sriov_configure    = vfio_pci_core_sriov_configure,
>> +#endif
>
>
> What is this IOV business about?

from vfio_pci

#ifdef CONFIG_PCI_IOV
module_param(enable_sriov, bool, 0644);
MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV 
configuration.  Enabling SR-IOV on a PF typically requires support of 
the userspace PF driver, enabling VFs without such support may result in 
non-functional VFs or PF.");
#endif


>
>
>> +    .err_handler        = &vfio_pci_core_err_handlers,
>> +};
>> +
>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev *pdev)
>> +{
>> +    if (pci_match_id(nvlink2gpu_vfio_pci_driver.id_table, pdev))
>> +        return &nvlink2gpu_vfio_pci_driver;
>
>
> Why do we need matching PCI ids here instead of looking at the FDT 
> which will work better?

what is FDT ? any is it better to use it instead of match_id ?


>
>
>> +    return NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(get_nvlink2gpu_vfio_pci_driver);
>> +#endif
>> +
>> +module_pci_driver(nvlink2gpu_vfio_pci_driver);
>> +
>> +MODULE_VERSION(DRIVER_VERSION);
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>> +MODULE_DESCRIPTION(DRIVER_DESC);
>> diff --git a/drivers/vfio/pci/nvlink2gpu_vfio_pci.h 
>> b/drivers/vfio/pci/nvlink2gpu_vfio_pci.h
>> new file mode 100644
>> index 000000000000..ebd5b600b190
>> --- /dev/null
>> +++ b/drivers/vfio/pci/nvlink2gpu_vfio_pci.h
>> @@ -0,0 +1,24 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2020, Mellanox Technologies, Ltd.  All rights 
>> reserved.
>> + *     Author: Max Gurtovoy <mgurtovoy@nvidia.com>
>> + */
>> +
>> +#ifndef NVLINK2GPU_VFIO_PCI_H
>> +#define NVLINK2GPU_VFIO_PCI_H
>> +
>> +#include <linux/pci.h>
>> +#include <linux/module.h>
>> +
>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>> +#if defined(CONFIG_VFIO_PCI_NVLINK2GPU) || 
>> defined(CONFIG_VFIO_PCI_NVLINK2GPU_MODULE)
>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev 
>> *pdev);
>> +#else
>> +struct pci_driver *get_nvlink2gpu_vfio_pci_driver(struct pci_dev *pdev)
>> +{
>> +    return NULL;
>> +}
>> +#endif
>> +#endif
>> +
>> +#endif /* NVLINK2GPU_VFIO_PCI_H */
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index dbc0a6559914..8e81ea039f31 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -27,6 +27,10 @@
>>   #include <linux/uaccess.h>
>>     #include "vfio_pci_core.h"
>> +#ifdef CONFIG_VFIO_PCI_DRIVER_COMPAT
>> +#include "npu2_vfio_pci.h"
>> +#include "nvlink2gpu_vfio_pci.h"
>> +#endif
>>     #define DRIVER_VERSION  "0.2"
>>   #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
>> @@ -142,14 +146,48 @@ static const struct vfio_device_ops 
>> vfio_pci_ops = {
>>       .match        = vfio_pci_core_match,
>>   };
>>   +/*
>> + * This layer is used for backward compatibility. Hopefully it will be
>> + * removed in the future.
>> + */
>> +static struct pci_driver *vfio_pci_get_compat_driver(struct pci_dev 
>> *pdev)
>> +{
>> +    switch (pdev->vendor) {
>> +    case PCI_VENDOR_ID_NVIDIA:
>> +        switch (pdev->device) {
>> +        case 0x1db1:
>> +        case 0x1db5:
>> +        case 0x1db8:
>> +        case 0x1df5:
>> +            return get_nvlink2gpu_vfio_pci_driver(pdev);
>
> This does not really need a switch, could simply call these 
> get_xxxx_vfio_pci_driver. Thanks,

maybe the result will be the same but I don't think we need to send all 
NVIDIA devices or IBM devices to this function.

we can maybe export the tables from the vfio_vendor driver and match it 
here.

>
>
>> +        default:
>> +            return NULL;
>> +        }
>> +    case PCI_VENDOR_ID_IBM:
>> +        switch (pdev->device) {
>> +        case 0x04ea:
>> +            return get_npu2_vfio_pci_driver(pdev);
>> +        default:
>> +            return NULL;
>> +        }
>> +    }
>> +
>> +    return NULL;
>> +}
>> +
>>   static int vfio_pci_probe(struct pci_dev *pdev, const struct 
>> pci_device_id *id)
>>   {
>>       struct vfio_pci_device *vpdev;
>> +    struct pci_driver *driver;
>>       int ret;
>>         if (vfio_pci_is_denylisted(pdev))
>>           return -EINVAL;
>>   +    driver = vfio_pci_get_compat_driver(pdev);
>> +    if (driver)
>> +        return driver->probe(pdev, id);
>> +
>>       vpdev = kzalloc(sizeof(*vpdev), GFP_KERNEL);
>>       if (!vpdev)
>>           return -ENOMEM;
>> @@ -167,14 +205,21 @@ static int vfio_pci_probe(struct pci_dev *pdev, 
>> const struct pci_device_id *id)
>>     static void vfio_pci_remove(struct pci_dev *pdev)
>>   {
>> -    struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>> -    struct vfio_pci_core_device *core_vpdev = vfio_device_data(vdev);
>> -    struct vfio_pci_device *vpdev;
>> -
>> -    vpdev = container_of(core_vpdev, struct vfio_pci_device, vdev);
>> -
>> -    vfio_pci_core_unregister_device(core_vpdev);
>> -    kfree(vpdev);
>> +    struct pci_driver *driver;
>> +
>> +    driver = vfio_pci_get_compat_driver(pdev);
>> +    if (driver) {
>> +        driver->remove(pdev);
>> +    } else {
>> +        struct vfio_device *vdev = dev_get_drvdata(&pdev->dev);
>> +        struct vfio_pci_core_device *core_vpdev;
>> +        struct vfio_pci_device *vpdev;
>> +
>> +        core_vpdev = vfio_device_data(vdev);
>> +        vpdev = container_of(core_vpdev, struct vfio_pci_device, vdev);
>> +        vfio_pci_core_unregister_device(core_vpdev);
>> +        kfree(vpdev);
>> +    }
>>   }
>>     static int vfio_pci_sriov_configure(struct pci_dev *pdev, int 
>> nr_virtfn)
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c 
>> b/drivers/vfio/pci/vfio_pci_core.c
>> index 4de8e352df9c..f9b39abe54cb 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -354,24 +354,6 @@ int vfio_pci_core_enable(struct 
>> vfio_pci_core_device *vdev)
>>           }
>>       }
>>   -    if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
>> -        IS_ENABLED(CONFIG_VFIO_PCI_NVLINK2)) {
>> -        ret = vfio_pci_nvidia_v100_nvlink2_init(vdev);
>> -        if (ret && ret != -ENODEV) {
>> -            pci_warn(pdev, "Failed to setup NVIDIA NV2 RAM region\n");
>> -            goto disable_exit;
>> -        }
>> -    }
>> -
>> -    if (pdev->vendor == PCI_VENDOR_ID_IBM &&
>> -        IS_ENABLED(CONFIG_VFIO_PCI_NVLINK2)) {
>> -        ret = vfio_pci_ibm_npu2_init(vdev);
>> -        if (ret && ret != -ENODEV) {
>> -            pci_warn(pdev, "Failed to setup NVIDIA NV2 ATSD region\n");
>> -            goto disable_exit;
>> -        }
>> -    }
>> -
>>       return 0;
>>     disable_exit:
>> diff --git a/drivers/vfio/pci/vfio_pci_core.h 
>> b/drivers/vfio/pci/vfio_pci_core.h
>> index 8989443c3086..31f3836e606e 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.h
>> +++ b/drivers/vfio/pci/vfio_pci_core.h
>> @@ -204,20 +204,6 @@ static inline int vfio_pci_igd_init(struct 
>> vfio_pci_core_device *vdev)
>>       return -ENODEV;
>>   }
>>   #endif
>> -#ifdef CONFIG_VFIO_PCI_NVLINK2
>> -extern int vfio_pci_nvidia_v100_nvlink2_init(struct 
>> vfio_pci_core_device *vdev);
>> -extern int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev);
>> -#else
>> -static inline int vfio_pci_nvidia_v100_nvlink2_init(struct 
>> vfio_pci_core_device *vdev)
>> -{
>> -    return -ENODEV;
>> -}
>> -
>> -static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device 
>> *vdev)
>> -{
>> -    return -ENODEV;
>> -}
>> -#endif
>>     #ifdef CONFIG_S390
>>   extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device 
>> *vdev,
>>
>
