Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6436B25DACF
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgIDOAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:00:39 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:55783
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730551AbgIDN7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 09:59:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIOxaMhiCoJuYa6j/iLZVtJOkbU9FBohvumE43ytPvBEgjcXZnXn1kvw6ahkwjtE6O7m+daXL4b8N2SxWv4AYSRMz+rEiZzIpQXEjqu/jhOluEaGNye7rk6eP16PCO3xNQrwSV3ffRZbxJio9QoskTR7MuUhfCnC5xEaFnCr+xEkDavHwWiD1vjHu6Cdt2PXoI9//bYgrCg8g8RQ/uxVypQvkm/GFv/F1MvrvwheGi0TscCAWAwhiP740BiO8IHIFdjANSOVwiaEUSWyTbomXNiWCOx2wMhIRI8U3FWSGb5zbWMcWQpnAB2CA0A9aQ5dnQLL5qzN2Vt4eqNLhPf3qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnpL2NF9Pr6KJLwPSyKPQUS2xGl7CpZlKZSC985qxCQ=;
 b=cTO5jlu2Jrw24iYiKCL4uD1eQ7hulfDnWuMXD2e6QKxm1X+K+PUEH4HHUABvACAaTgeNFjfV9WgDdZJyIFz2TsGeF1IRdjeVWSH0d5IontJaqWzr/z+3SJvG63xVUTuXVw8PheIsHQhKOefeIdQUxyt6yUEb02dGePPCbj1u14cwqECxwzsXPH1cs4Cg2gcfCYD0OPIpJaHWq9hQ9oR0KrB/0OoqTLr/YQCQmiJP8ZZil9kXz1iGbCBqoX+D/8IGWWVrCHJVWZCMvUczjO7EZQA+VsRgWgOe2Z3VRNwKVVeUlGG4nneJNZGoSISaOwQJmk5QN/ZErAp2DKuU1mbr0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnpL2NF9Pr6KJLwPSyKPQUS2xGl7CpZlKZSC985qxCQ=;
 b=RHLcBTrMAczs+rauCestwBP2blC12r9whUYMwqT7/lf2SAJpyHEKhwE8sndWsTy6zf9aruL4r0pv8/Y2fNY/bVIzeZ+PDsTj/0YtA9XAkH5Ez4NhnqwosdmnrHcPqJX1Ge6AAIKguAtKqr9qLqlRATwAtR4FpGCzApzrPob8QT0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VE1PR04MB7486.eurprd04.prod.outlook.com
 (2603:10a6:800:1b2::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 4 Sep
 2020 13:59:39 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607%9]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 13:59:39 +0000
Subject: Re: [PATCH v4 01/10] vfio/fsl-mc: Add VFIO framework skeleton for
 fsl-mc devices
To:     Auger Eric <eric.auger@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-2-diana.craciun@oss.nxp.com>
 <4636da7d-0c97-4c14-cfac-bdb4c9e6cd83@redhat.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <da339828-1696-7d46-3548-3b99746e92fe@oss.nxp.com>
Date:   Fri, 4 Sep 2020 16:59:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <4636da7d-0c97-4c14-cfac-bdb4c9e6cd83@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0022.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::35) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM0PR02CA0022.eurprd02.prod.outlook.com (2603:10a6:208:3e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Fri, 4 Sep 2020 13:59:38 +0000
X-Originating-IP: [188.27.189.94]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35182c40-c013-4c72-67f8-08d850dac407
X-MS-TrafficTypeDiagnostic: VE1PR04MB7486:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7486DF6F55F8BC3AED7EF74BBE2D0@VE1PR04MB7486.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tw3J9Qoih46UM96WTuwho1M5SPMTjeSVlr2GzOTOG03Vb2lhCNiD5aE/EU+bFcr4Fljxk5+twVGcw7IT6EUkg+z5HXT8vsVgsc6+1OO6uGMw02fVCvy+hBF76my3IG1+P9L4+BvOjRu/D2cXU6RjF5V6REyo0bIvJgEZygmISpMBaqjNka0Oygg1/11sYsaSvjIuvmplyGgY2o2rUxC7WA8uakFpAqgd1gLhrcfge+4/NHsJcD/8GfWQyXNT1H1oi2Wa861RUTFuIOpo9DNgC52E3e6CiG12frmDSXDdt3kIkR8LhWncNaRDLNVbIV6+lPcLDD4T0Za7XDjbxH7AYflTGbSopiIgnTMFPM8VSotRMe3yiP4NUJtFeN9zEpdH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(26005)(66476007)(30864003)(186003)(66556008)(66946007)(52116002)(2906002)(53546011)(956004)(2616005)(5660300002)(16576012)(16526019)(8676002)(6486002)(86362001)(8936002)(478600001)(6666004)(4326008)(31686004)(316002)(31696002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N6b8+GLWWQlzxlEOGLXqrqjFJBwtKpRbK0fFOWEaEhZj/SWcyFkPaxvP5JtSIsyCGG/ysLKnzgcqBZ7AvvDuoBC7vcvVz5kZ35rYTLyZHpNJE0BB1UcX7EVD59vX278gKE8GMYUAMHK1FciAgF6HAT5Mh3wZNRKlJx6AQRecf+rasfWz+DaPT8N2BzwGJamtd9BPoWLcPb0Ua2+LvmanfbnvW+te6/mJeMBVzjgvF7G+DWSlSai3J0GsKERWnxh4JW03odgq2l0CBHgTor16t2g7w0A08zrqBA5R1rPhkIFlYcRGKluW5wh8NLCizupp4gstzxtf1i3YynGfJyGqwNnls+nIGlRaKVWFfYkw359YpSv+XGrl7Ac8zdnMRjnXBXmenr7PIavzP31QOsW922+7xJGb9eY8pC5X+7dWr20Cdx50oHZGMxE5tYUNc/ZLBjNzzJTZihcdqWF86bezvrJUVFUjClCPrxhanhUHfIQK+njqu0no7wKt99jsT/xFaHEyObUwRaMjx7vutYYXN07RCsSwtEayAvMABiWDRGLOqCKkqTe1sMWfamM7KLkEAxP4P/LWW2VJDQNJdVOdqsTaFaCO2PEqf+vjUwtUNI9GXxicD/LRsnz3H24HUy1H07vz+zWRzwq4Q6y85sWD1g==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35182c40-c013-4c72-67f8-08d850dac407
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 13:59:39.7086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fOD25r3IzG6SWKO2IByyi4pfgrv8uHT5+iq/1yFXU9MePwOlpzfiCYfLF02mntLOnJGv9ZqlxzyoIcQ9eGv7sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7486
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 9/3/2020 5:06 PM, Auger Eric wrote:
> Hi Diana,
> 
> On 8/26/20 11:33 AM, Diana Craciun wrote:
>> From: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>>
>> DPAA2 (Data Path Acceleration Architecture) consists in
>> mechanisms for processing Ethernet packets, queue management,
>> accelerators, etc.
>>
>> The Management Complex (mc) is a hardware entity that manages the DPAA2
>> hardware resources. It provides an object-based abstraction for software
>> drivers to use the DPAA2 hardware. The MC mediates operations such as
>> create, discover, destroy of DPAA2 objects.
>> The MC provides memory-mapped I/O command interfaces (MC portals) which
>> DPAA2 software drivers use to operate on DPAA2 objects.
>>
>> A DPRC is a container object that holds other types of DPAA2 objects.
>> Each object in the DPRC is a Linux device and bound to a driver.
>> The MC-bus driver is a platform driver (different from PCI or platform
>> bus). The DPRC driver does runtime management of a bus instance. It
>> performs the initial scan of the DPRC and handles changes in the DPRC
>> configuration (adding/removing objects).
>>
>> All objects inside a container share the same hardware isolation
>> context, meaning that only an entire DPRC can be assigned to
>> a virtual machine.
>> When a container is assigned to a virtual machine, all the objects
>> within that container are assigned to that virtual machine.
>> The DPRC container assigned to the virtual machine is not allowed
>> to change contents (add/remove objects) by the guest. The restriction
>> is set by the host and enforced by the mc hardware.
>>
>> The DPAA2 objects can be directly assigned to the guest. However
>> the MC portals (the memory mapped command interface to the MC) need
>> to be emulated because there are commands that configure the
>> interrupts and the isolation IDs which are virtual in the guest.
>>
>> Example:
>> echo vfio-fsl-mc > /sys/bus/fsl-mc/devices/dprc.2/driver_override
>> echo dprc.2 > /sys/bus/fsl-mc/drivers/vfio-fsl-mc/bind
>>
>> The dprc.2 is bound to the VFIO driver and all the objects within
>> dprc.2 are going to be bound to the VFIO driver.
>>
>> This patch adds the infrastructure for VFIO support for fsl-mc
>> devices. Subsequent patches will add support for binding and secure
>> assigning these devices using VFIO.
>>
>> More details about the DPAA2 objects can be found here:
>> Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
>>
>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   MAINTAINERS                               |   6 +
>>   drivers/vfio/Kconfig                      |   1 +
>>   drivers/vfio/Makefile                     |   1 +
>>   drivers/vfio/fsl-mc/Kconfig               |   9 ++
>>   drivers/vfio/fsl-mc/Makefile              |   4 +
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 160 ++++++++++++++++++++++
>>   drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  14 ++
>>   include/uapi/linux/vfio.h                 |   1 +
>>   8 files changed, 196 insertions(+)
>>   create mode 100644 drivers/vfio/fsl-mc/Kconfig
>>   create mode 100644 drivers/vfio/fsl-mc/Makefile
>>   create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>   create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3b186ade3597..f3f9ea108588 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -18229,6 +18229,12 @@ F:	drivers/vfio/
>>   F:	include/linux/vfio.h
>>   F:	include/uapi/linux/vfio.h
>>   
>> +VFIO FSL-MC DRIVER
>> +M:	Diana Craciun <diana.craciun@oss.nxp.com>
>> +L:	kvm@vger.kernel.org
>> +S:	Maintained
>> +F:	drivers/vfio/fsl-mc/
>> +
>>   VFIO MEDIATED DEVICE DRIVERS
>>   M:	Kirti Wankhede <kwankhede@nvidia.com>
>>   L:	kvm@vger.kernel.org
>> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
>> index fd17db9b432f..5533df91b257 100644
>> --- a/drivers/vfio/Kconfig
>> +++ b/drivers/vfio/Kconfig
>> @@ -47,4 +47,5 @@ menuconfig VFIO_NOIOMMU
>>   source "drivers/vfio/pci/Kconfig"
>>   source "drivers/vfio/platform/Kconfig"
>>   source "drivers/vfio/mdev/Kconfig"
>> +source "drivers/vfio/fsl-mc/Kconfig"
>>   source "virt/lib/Kconfig"
>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>> index de67c4725cce..fee73f3d9480 100644
>> --- a/drivers/vfio/Makefile
>> +++ b/drivers/vfio/Makefile
>> @@ -9,3 +9,4 @@ obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
>>   obj-$(CONFIG_VFIO_PCI) += pci/
>>   obj-$(CONFIG_VFIO_PLATFORM) += platform/
>>   obj-$(CONFIG_VFIO_MDEV) += mdev/
>> +obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
>> diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
>> new file mode 100644
>> index 000000000000..b1a527d6b6f2
>> --- /dev/null
>> +++ b/drivers/vfio/fsl-mc/Kconfig
>> @@ -0,0 +1,9 @@
>> +config VFIO_FSL_MC
>> +	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
>> +	depends on VFIO && FSL_MC_BUS && EVENTFD
>> +	help
>> +	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
>> +	  (Management Complex) devices. This is required to passthrough
>> +	  fsl-mc bus devices using the VFIO framework.
>> +
>> +	  If you don't know what to do here, say N.
>> diff --git a/drivers/vfio/fsl-mc/Makefile b/drivers/vfio/fsl-mc/Makefile
>> new file mode 100644
>> index 000000000000..0c6e5d2ddaae
>> --- /dev/null
>> +++ b/drivers/vfio/fsl-mc/Makefile
>> @@ -0,0 +1,4 @@
>> +# SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>> +
>> +vfio-fsl-mc-y := vfio_fsl_mc.o
>> +obj-$(CONFIG_VFIO_FSL_MC) += vfio-fsl-mc.o
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> new file mode 100644
>> index 000000000000..8b53c2a25b32
>> --- /dev/null
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -0,0 +1,160 @@
>> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>> +/*
>> + * Copyright 2013-2016 Freescale Semiconductor Inc.
>> + * Copyright 2016-2017,2019-2020 NXP
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/iommu.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/vfio.h>
>> +#include <linux/fsl/mc.h>
>> +
>> +#include "vfio_fsl_mc_private.h"
>> +
>> +static int vfio_fsl_mc_open(void *device_data)
>> +{
>> +	if (!try_module_get(THIS_MODULE))
>> +		return -ENODEV;
>> +
>> +	return 0;
>> +}
>> +
>> +static void vfio_fsl_mc_release(void *device_data)
>> +{
>> +	module_put(THIS_MODULE);
>> +}
>> +
>> +static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>> +			      unsigned long arg)
>> +{
>> +	switch (cmd) {
>> +	case VFIO_DEVICE_GET_INFO:
>> +	{
>> +		return -ENOTTY;
>> +	}
>> +	case VFIO_DEVICE_GET_REGION_INFO:
>> +	{
>> +		return -ENOTTY;
>> +	}
>> +	case VFIO_DEVICE_GET_IRQ_INFO:
>> +	{
>> +		return -ENOTTY;
>> +	}
>> +	case VFIO_DEVICE_SET_IRQS:
>> +	{
>> +		return -ENOTTY;
>> +	}
>> +	case VFIO_DEVICE_RESET:
>> +	{
>> +		return -ENOTTY;
>> +	}
>> +	default:
>> +		return -ENOTTY;
>> +	}
>> +}
>> +
>> +static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
>> +				size_t count, loff_t *ppos)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
>> +				 size_t count, loff_t *ppos)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static const struct vfio_device_ops vfio_fsl_mc_ops = {
>> +	.name		= "vfio-fsl-mc",
>> +	.open		= vfio_fsl_mc_open,
>> +	.release	= vfio_fsl_mc_release,
>> +	.ioctl		= vfio_fsl_mc_ioctl,
>> +	.read		= vfio_fsl_mc_read,
>> +	.write		= vfio_fsl_mc_write,
>> +	.mmap		= vfio_fsl_mc_mmap,
>> +};
>> +
>> +static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>> +{
>> +	struct iommu_group *group;
>> +	struct vfio_fsl_mc_device *vdev;
>> +	struct device *dev = &mc_dev->dev;
>> +	int ret;
>> +
>> +	group = vfio_iommu_group_get(dev);
>> +	if (!group) {
>> +		dev_err(dev, "%s: VFIO: No IOMMU group\n", __func__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	vdev = devm_kzalloc(dev, sizeof(*vdev), GFP_KERNEL);
>> +	if (!vdev) {
>> +		vfio_iommu_group_put(group, dev);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	vdev->mc_dev = mc_dev;
>> +
>> +	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
>> +	if (ret) {
>> +		dev_err(dev, "%s: Failed to add to vfio group\n", __func__);
>> +		vfio_iommu_group_put(group, dev);
>> +		return ret;
>> +	}
>> +
>> +	return ret;
> nit: introduce out_group_put: as in other files
> This will be usable also in subsequent patches
>> +}
>> +
>> +static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>> +{
>> +	struct vfio_fsl_mc_device *vdev;
>> +	struct device *dev = &mc_dev->dev;
>> +
>> +	vdev = vfio_del_group_dev(dev);
>> +	if (!vdev)
>> +		return -EINVAL;
>> +
>> +	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * vfio-fsl_mc is a meta-driver, so use driver_override interface to
>> + * bind a fsl_mc container with this driver and match_id_table is NULL.
>> + */
>> +static struct fsl_mc_driver vfio_fsl_mc_driver = {
>> +	.probe		= vfio_fsl_mc_probe,
>> +	.remove		= vfio_fsl_mc_remove,
>> +	.match_id_table = NULL,
> not needed?

The driver will always match on driver_override, there is no need for 
static ids.

>> +	.driver	= {
>> +		.name	= "vfio-fsl-mc",
>> +		.owner	= THIS_MODULE,
>> +	},
>> +};
>> +
>> +static int __init vfio_fsl_mc_driver_init(void)
>> +{
>> +	return fsl_mc_driver_register(&vfio_fsl_mc_driver);
>> +}
>> +
>> +static void __exit vfio_fsl_mc_driver_exit(void)
>> +{
>> +	fsl_mc_driver_unregister(&vfio_fsl_mc_driver);
>> +}
>> +
>> +module_init(vfio_fsl_mc_driver_init);
>> +module_exit(vfio_fsl_mc_driver_exit);
>> +
>> +MODULE_LICENSE("GPL v2");
> Don't you need MODULE_LICENSE("Dual BSD/GPL"); ?

Yes, will change.

>> +MODULE_DESCRIPTION("VFIO for FSL-MC devices - User Level meta-driver");
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> new file mode 100644
>> index 000000000000..e79cc116f6b8
>> --- /dev/null
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
>> @@ -0,0 +1,14 @@
>> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
>> +/*
>> + * Copyright 2013-2016 Freescale Semiconductor Inc.
>> + * Copyright 2016,2019-2020 NXP
>> + */
>> +
>> +#ifndef VFIO_FSL_MC_PRIVATE_H
>> +#define VFIO_FSL_MC_PRIVATE_H
>> +
>> +struct vfio_fsl_mc_device {
>> +	struct fsl_mc_device		*mc_dev;
>> +};
>> +
>> +#endif /* VFIO_FSL_MC_PRIVATE_H */
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 920470502329..95deac891378 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -201,6 +201,7 @@ struct vfio_device_info {
>>   #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
>>   #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
>>   #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
>> +#define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
>>   	__u32	num_regions;	/* Max region index + 1 */
>>   	__u32	num_irqs;	/* Max IRQ index + 1 */
>>   };
>>
> Thanks
> 
> Eric
> 

Thanks,
Diana
