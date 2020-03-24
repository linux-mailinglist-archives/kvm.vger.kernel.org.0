Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272B6190AFE
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgCXKcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:32:08 -0400
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:22826
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbgCXKcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 06:32:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCqnA29+8Mw1XctzHNpLAlogbjRHp2w+NJ4RMxbEGutHZfJHILHG0E0EtmeCu44jfQRF2KFCtEvHvHR4mVRjqZ3mLfVNLFh7nrBRZC1c5kT8j8hefgTqtkNvLoNm8WQcA4FTqHH2TAx5cDe++zQzXgs0mCOM9JrUX7Ln2OT35Z4pD0m8C9YM9eHZsMKQsyr0akRMVrzNuznZERAdInhG02JNRQRHCWk+P2nR+WyaF+z13QcLvtJR3EcesRMGhup1kfQhMmzmRwT9Gg2RMyDVsjGfeOSl/KNeBfvb8hYmEdJ/u48C7zByN8tgIPe1qBE0+egHznHVUGKIY2Rb90OrRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiVSQJeeOVejK2+8+q8JKOkFWkMeJMFSCttvrzQgawE=;
 b=miDfzIJCfgvsqJNBQfYm/wgdjXcWV1eUlaYetk9aMXAHg/GNi4uY2mNTbSYiYmHiy15DKOoDUcbtwc1J59cSWN/aS/vIuIXwZgcCQ2M5wMvgXxdtzfE99vH+EdtzDLyviT8o2JlsO5uVnk366YkyzLhWtvAynZLLZEOkFd29KEiRWrCemxijMhAm313u2Pyj4prg/pPvhp4hZ+CJXZHF7hzZd/3dKUeNkFVRFOp6vDyspigJ1fC1aQPc9KM4zUDQHXRoGBY1MsdhonCe+xtDw+zCas8lm9KxksoJazG9P+fIXhW8hvyo4Ki+vIJrHhg7QfBl83gw8OFzcMk56O6tOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiVSQJeeOVejK2+8+q8JKOkFWkMeJMFSCttvrzQgawE=;
 b=BEgL7BY9AnrZSvQQjj5tMVTaDVsYNqnUYdzDmLO2lZoC0gxr6dNluXT2u6hgomXiJnlvpM1JL3EL8mAG0Em7h9eIAc8INiGYVAl1Ch+Ptazp2VhsdIh+yN1F9TXmKPbCmaNmoC9L0Z+U2G5rkV+iJlXg+gRYvV82/4ds3AuQeQk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
Received: from AM6PR04MB5925.eurprd04.prod.outlook.com (20.179.2.147) by
 AM6PR04MB5285.eurprd04.prod.outlook.com (20.177.32.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 10:32:00 +0000
Received: from AM6PR04MB5925.eurprd04.prod.outlook.com
 ([fe80::dd71:5f33:1b21:cd9e]) by AM6PR04MB5925.eurprd04.prod.outlook.com
 ([fe80::dd71:5f33:1b21:cd9e%5]) with mapi id 15.20.2835.023; Tue, 24 Mar 2020
 10:32:00 +0000
Subject: Re: [PATCH 1/9] vfio/fsl-mc: Add VFIO framework skeleton for fsl-mc
 devices
To:     Diana Craciun <diana.craciun@oss.nxp.com>, kvm@vger.kernel.org,
        alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org,
        bharatb.yadav@gmail.com
Cc:     linux-kernel@vger.kernel.org,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200323171911.27178-1-diana.craciun@oss.nxp.com>
 <20200323171911.27178-2-diana.craciun@oss.nxp.com>
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
Message-ID: <4e766043-df91-31fc-e639-816c02f0ba03@nxp.com>
Date:   Tue, 24 Mar 2020 12:31:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200323171911.27178-2-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR04CA0021.eurprd04.prod.outlook.com
 (2603:10a6:206:1::34) To AM6PR04MB5925.eurprd04.prod.outlook.com
 (2603:10a6:20b:ab::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.107] (86.121.54.4) by AM5PR04CA0021.eurprd04.prod.outlook.com (2603:10a6:206:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Tue, 24 Mar 2020 10:31:59 +0000
X-Originating-IP: [86.121.54.4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 347843b0-a420-4763-d09c-08d7cfde95cc
X-MS-TrafficTypeDiagnostic: AM6PR04MB5285:|AM6PR04MB5285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB528586188B8F9B6A7750353DECF10@AM6PR04MB5285.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(6486002)(16576012)(316002)(186003)(16526019)(53546011)(26005)(36756003)(66476007)(66946007)(30864003)(66556008)(86362001)(31696002)(8676002)(44832011)(5660300002)(478600001)(8936002)(956004)(2616005)(4326008)(52116002)(81156014)(81166006)(2906002)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB5285;H:AM6PR04MB5925.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rMiIPp1QPZXtKROwkq6wV+apuk1613O1W0ih/i2hrmMIhBRYHL+hrmaEajhwWszDYUnktgiI87LZOYSQbCB1BXSyUFL4c8e8JT6uEM2MAh7Ha89qw23xtJ+bYN8TaByf015PVFtD6AubbPVQ8N8khCcSP/P3SsqmMclmCzWAdWOV41DUXzH76PgZHmGMSd9GcboBfiTwwaeY9J2+frTQmWhs02lLVVk5XedhsdH47QQQD4dGReKQDXoi/MBfwtqHGz7q8/Gs8YDFNwOk484bdu4H8igs5bTlCMNonAuHblwn/uoS/GI6PQTsCcbozqWvN+yX0TAIeKTf9NJIkyamssQoAeqB9ge5Ix/HaguYK/So0tHNs3pvUBJfU5ZTR8XEbCfaxG6XYNeUxVo4QcbFm1MZuBqVl8SEE2mAEMzkj7780X2zy52E2Q/OneNqacb
X-MS-Exchange-AntiSpam-MessageData: SvW8Msg4ir0fZLtnGylG4qwntzs/zsM4+ratl8yD/tw2ukSxwX0W1Fo0ihNZBQeBywvI4acWZ2V+yVnc3z4uqa/OHtisC5XGrXugbhXdsyLbILxcTmGFxi05kfKJbzwuGUjaA/FHFNpE+/4+JUsA1g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 347843b0-a420-4763-d09c-08d7cfde95cc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 10:32:00.0700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DoUPPGlOAMlVQnCxD1jmJ8BjxUjOn1ls+0KQFiHd4RkfYe+1/MRnjv/jVQsdg7qwFVMTmDG1y344t5huuzsTuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5285
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/23/2020 7:19 PM, Diana Craciun wrote:
> From: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> 
> DPAA2 (Data Path Acceleration Architecture) consists in
> mechanisms for processing Ethernet packets, queue management,
> accelerators, etc.
> 
> The Management Complex (mc) is a hardware entity that manages the DPAA2
> hardware resources. It provides an object-based abstraction for software
> drivers to use the DPAA2 hardware. The MC mediates operations such as
> create, discover, destroy of DPAA2 objects.
> The MC provides memory-mapped I/O command interfaces (MC portals) which
> DPAA2 software drivers use to operate on DPAA2 objects.
> 
> A DPRC is a container object that holds other types of DPAA2 objects.
> Each object in the DPRC is a Linux device and bound to a driver.
> The MC-bus driver is a platform driver (different from PCI or platform
> bus). The DPRC driver does runtime management of a bus instance. It
> performs the initial scan of the DPRC and handles changes in the DPRC
> configuration (adding/removing objects).
> 
> All objects inside a container share the same hardware isolation
> context, meaning that only an entire DPRC can be assigned to
> a virtual machine.
> When a container is assigned to a virtual machine, all the objects
> within that container are assigned to that virtual machine.
> The DPRC container assigned to the virtual machine is not allowed
> to change contents (add/remove objects) by the guest. The restriction
> is set by the host and enforced by the mc hardware.
> 
> The DPAA2 objects can be directly assigned to the guest. However
> the MC portals (the memory mapped command interface to the MC) need
> to be emulated because there are commands that configure the
> interrupts and the isolation IDs which are virtual in the guest.
> 
> Example:
> echo vfio-fsl-mc > /sys/bus/fsl-mc/devices/dprc.2/driver_override
> echo dprc.2 > /sys/bus/fsl-mc/drivers/vfio-fsl-mc/bind
> 
> The dprc.2 is bound to the VFIO driver and all the objects within
> dprc.2 are going to be bound to the VFIO driver.
> 
> This patch adds the infrastructure for VFIO support for fsl-mc
> devices. Subsequent patches will add support for binding and secure
> assigning these devices using VFIO.
> 
> More details about the DPAA2 objects can be found here:
> Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  MAINTAINERS                               |   6 +
>  drivers/vfio/Kconfig                      |   1 +
>  drivers/vfio/Makefile                     |   1 +
>  drivers/vfio/fsl-mc/Kconfig               |   9 ++
>  drivers/vfio/fsl-mc/Makefile              |   2 +
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 161 ++++++++++++++++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  14 ++
>  include/uapi/linux/vfio.h                 |   1 +
>  8 files changed, 195 insertions(+)
>  create mode 100644 drivers/vfio/fsl-mc/Kconfig
>  create mode 100644 drivers/vfio/fsl-mc/Makefile
>  create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc.c
>  create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cc1d18cb5d18..fc547e6f5bf8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17566,6 +17566,12 @@ F:	drivers/vfio/
>  F:	include/linux/vfio.h
>  F:	include/uapi/linux/vfio.h
>  
> +VFIO FSL-MC DRIVER
> +M:	Diana Craciun <diana.craciun@oss.nxp.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/fsl-mc/
> +
>  VFIO MEDIATED DEVICE DRIVERS
>  M:	Kirti Wankhede <kwankhede@nvidia.com>
>  L:	kvm@vger.kernel.org
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index fd17db9b432f..5533df91b257 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -47,4 +47,5 @@ menuconfig VFIO_NOIOMMU
>  source "drivers/vfio/pci/Kconfig"
>  source "drivers/vfio/platform/Kconfig"
>  source "drivers/vfio/mdev/Kconfig"
> +source "drivers/vfio/fsl-mc/Kconfig"
>  source "virt/lib/Kconfig"
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index de67c4725cce..fee73f3d9480 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
>  obj-$(CONFIG_VFIO_PCI) += pci/
>  obj-$(CONFIG_VFIO_PLATFORM) += platform/
>  obj-$(CONFIG_VFIO_MDEV) += mdev/
> +obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
> diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
> new file mode 100644
> index 000000000000..b1a527d6b6f2
> --- /dev/null
> +++ b/drivers/vfio/fsl-mc/Kconfig
> @@ -0,0 +1,9 @@
> +config VFIO_FSL_MC
> +	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
> +	depends on VFIO && FSL_MC_BUS && EVENTFD
> +	help
> +	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
> +	  (Management Complex) devices. This is required to passthrough
> +	  fsl-mc bus devices using the VFIO framework.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/fsl-mc/Makefile b/drivers/vfio/fsl-mc/Makefile
> new file mode 100644
> index 000000000000..6f2b80645d5b
> --- /dev/null
> +++ b/drivers/vfio/fsl-mc/Makefile
> @@ -0,0 +1,2 @@
> +vfio-fsl_mc-y := vfio_fsl_mc.o
> +obj-$(CONFIG_VFIO_FSL_MC) += vfio_fsl_mc.o
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> new file mode 100644
> index 000000000000..320fb09b5691
> --- /dev/null
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -0,0 +1,161 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/*
> + * Copyright 2013-2016 Freescale Semiconductor Inc.
> + * Copyright 2016-2017,2019-2020 NXP
> + */
> +
> +#include <linux/device.h>
> +#include <linux/iommu.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/vfio.h>
> +#include <linux/fsl/mc.h>
> +
> +#include "vfio_fsl_mc_private.h"
> +
> +static int vfio_fsl_mc_open(void *device_data)
> +{
> +	if (!try_module_get(THIS_MODULE))
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static void vfio_fsl_mc_release(void *device_data)
> +{
> +	module_put(THIS_MODULE);
> +}
> +
> +static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
> +			      unsigned long arg)
> +{
> +	switch (cmd) {
> +	case VFIO_DEVICE_GET_INFO:
> +	{
> +		return -EINVAL;
> +	}
> +	case VFIO_DEVICE_GET_REGION_INFO:
> +	{
> +		return -EINVAL;
> +	}
> +	case VFIO_DEVICE_GET_IRQ_INFO:
> +	{
> +		return -EINVAL;
> +	}
> +	case VFIO_DEVICE_SET_IRQS:
> +	{
> +		return -EINVAL;
> +	}
> +	case VFIO_DEVICE_RESET:
> +	{
> +		return -EINVAL;
> +	}
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	return -EINVAL;
> +}
> +
> +static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	return -EINVAL;
> +}
> +
> +static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
> +{
> +	return -EINVAL;
> +}
> +
> +static const struct vfio_device_ops vfio_fsl_mc_ops = {
> +	.name		= "vfio-fsl-mc",
> +	.open		= vfio_fsl_mc_open,
> +	.release	= vfio_fsl_mc_release,
> +	.ioctl		= vfio_fsl_mc_ioctl,
> +	.read		= vfio_fsl_mc_read,
> +	.write		= vfio_fsl_mc_write,
> +	.mmap		= vfio_fsl_mc_mmap,
> +};
> +
> +static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
> +{
> +	struct iommu_group *group;
> +	struct vfio_fsl_mc_device *vdev;
> +	struct device *dev = &mc_dev->dev;
> +	int ret;
> +
> +	group = vfio_iommu_group_get(dev);
> +	if (!group) {
> +		dev_err(dev, "%s: VFIO: No IOMMU group\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	vdev = devm_kzalloc(dev, sizeof(*vdev), GFP_KERNEL);
> +	if (!vdev) {
> +		vfio_iommu_group_put(group, dev);
> +		return -ENOMEM;
> +	}
> +
> +	vdev->mc_dev = mc_dev;
> +
> +	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
> +	if (ret) {
> +		dev_err(dev, "%s: Failed to add to vfio group\n", __func__);
> +		vfio_iommu_group_put(group, dev);
> +		return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
> +{
> +	struct vfio_fsl_mc_device *vdev;
> +	struct device *dev = &mc_dev->dev;
> +
> +	vdev = vfio_del_group_dev(dev);
> +	if (!vdev)
> +		return -EINVAL;
> +
> +	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
> +	devm_kfree(dev, vdev);
> +
> +	return 0;
> +}
> +
> +/*
> + * vfio-fsl_mc is a meta-driver, so use driver_override interface to
> + * bind a fsl_mc container with this driver and match_id_table is NULL.
> + */
> +static struct fsl_mc_driver vfio_fsl_mc_driver = {
> +	.probe		= vfio_fsl_mc_probe,
> +	.remove		= vfio_fsl_mc_remove,
> +	.match_id_table = NULL,
> +	.driver	= {
> +		.name	= "vfio-fsl-mc",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init vfio_fsl_mc_driver_init(void)
> +{
> +	return fsl_mc_driver_register(&vfio_fsl_mc_driver);
> +}
> +
> +static void __exit vfio_fsl_mc_driver_exit(void)
> +{
> +	fsl_mc_driver_unregister(&vfio_fsl_mc_driver);
> +}
> +
> +module_init(vfio_fsl_mc_driver_init);
> +module_exit(vfio_fsl_mc_driver_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("VFIO for FSL-MC devices - User Level meta-driver");
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> new file mode 100644
> index 000000000000..b92858a003c0
> --- /dev/null
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> +/*
> + * Copyright 2013-2016 Freescale Semiconductor Inc.
> + * Copyright 2016,2019-2020 NXP
> + */
> +
> +#ifndef VFIO_FSL_MC_PRIVATE_H
> +#define VFIO_FSL_MC_PRIVATE_H
> +
> +struct vfio_fsl_mc_device {
> +	struct fsl_mc_device		*mc_dev;
> +};
> +
> +#endif /* VFIO_PCI_PRIVATE_H */

This should be VFIO_FSL_MC_PRIVATE_H.

---
Best Regards, Laurentiu

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a147ead..6d0a7a071ef4 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -201,6 +201,7 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
>  #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
>  #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
> +#define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  };
> 
