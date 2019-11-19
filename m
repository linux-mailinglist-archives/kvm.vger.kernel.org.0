Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6100D103053
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 00:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfKSXht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 18:37:49 -0500
Received: from mail-eopbgr740092.outbound.protection.outlook.com ([40.107.74.92]:25275
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbfKSXhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 18:37:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFkEtmmzbXeO2qYv6m+VBNxP4X/jZNoR74dK6bieXznIjsLLPq1eZSl70Gu/cf6ME/rcimGFZgrB4Gz92Jq/0xmSexSmYeMrDJO5OYub7AGn8tISFch5CVamx4Tt4YNod9IgoV5GTw4B6420uA2n5Q8HEatBji5zDbGDiwhGxq8IVNBUFTudJWfLFt01bpiK46Z0XTEDoL6W9jOBs/ISimxw41dYGiMjh6shjeAi0hBmqPz+M0l7JujYgd/NBIt2II/kAXPLG8dGDtFiX8p50SLF+7cY/HZiBzn7PZaewPwku1O1GKc6iObmkYHcbJb/6dR+WQcwtZWwaTm3czTxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1sgkeW8s8KJPbYNIHYWFJPaZCkrEJcmzUoZZ49ge+I=;
 b=ksDVTi7pKcJJTOyv4SmvbaukSGen0M1BJ+BgHs7ttC0rTfOZmQplG2VTf3c8UxFD4Mwq09qGS3T5iDJ1UeONXFdRrrzJni/us6aYlh5ykW+gs1SXtPvq5t0EbAWcdJm2Dvt0A4Knz8CRZC3WYbzcTOYIcUEdkTvmx5u00rr7FKhGjpbQ3/AeOz8sPSyruGhIdI68/D4vc1ZkHCpBDWPBl7jZkfx33+NNMIOeNRU95/S2Fsm5BqYDgHlt+1XuBg6Kt4QsiCPD/yeybQcs1V5upY/wCypQZ8Z76s7Qt5cg+okyV4DI/HMsGh7JK203EM/67HyylGVMugrt4+y+u5AS0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1sgkeW8s8KJPbYNIHYWFJPaZCkrEJcmzUoZZ49ge+I=;
 b=f297DyjUmI1u9eQaA2p9ZEL0pSVZWOk0yUmS6fL4zQ0dYHkqMVR8Kov/Q+f8Ot0W6bSXR66PJFTBvUUHA6Et97DEDQffZtRcjEKwB/P8ao3EtwWOTpC44p2DXPRoXdJpj7hod7tlM+N0/Gdy8E9iGbxONyxWbLruZhLKu0MDgBE=
Received: from CY4PR21MB0629.namprd21.prod.outlook.com (10.175.115.19) by
 CY4PR21MB0789.namprd21.prod.outlook.com (10.175.121.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.3; Tue, 19 Nov 2019 23:37:44 +0000
Received: from CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::ed94:4b6d:5371:285c]) by CY4PR21MB0629.namprd21.prod.outlook.com
 ([fe80::ed94:4b6d:5371:285c%5]) with mapi id 15.20.2495.006; Tue, 19 Nov 2019
 23:37:44 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh@kernel.org" <robh@kernel.org>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "paulmck@linux.ibm.com" <paulmck@linux.ibm.com>
CC:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Thread-Topic: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Thread-Index: AQHVmGxauB7OPo498EatkuQ0bgSaPqeTEvjg
Date:   Tue, 19 Nov 2019 23:37:43 +0000
Message-ID: <CY4PR21MB06295B84DDA48DD414B21071D74C0@CY4PR21MB0629.namprd21.prod.outlook.com>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
In-Reply-To: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-11-19T23:37:41.8135810Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4baa8fe5-2a13-4574-b2ca-7f98aceea2f4;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: add63804-abfe-4afb-0e81-08d76d4979d5
x-ms-traffictypediagnostic: CY4PR21MB0789:|CY4PR21MB0789:|CY4PR21MB0789:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB0789F6573A220C6D75E16538D74C0@CY4PR21MB0789.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(366004)(39860400002)(396003)(189003)(199004)(6246003)(8936002)(110136005)(66446008)(66476007)(7416002)(54906003)(66556008)(66946007)(25786009)(64756008)(10090500001)(76116006)(22452003)(316002)(14454004)(5660300002)(10290500003)(1511001)(52536014)(478600001)(66066001)(2201001)(476003)(486006)(11346002)(446003)(86362001)(81166006)(81156014)(33656002)(8676002)(76176011)(2906002)(6116002)(3846002)(4326008)(71190400001)(71200400001)(2501003)(99286004)(30864003)(8990500004)(102836004)(6506007)(305945005)(9686003)(6436002)(55016002)(186003)(256004)(74316002)(26005)(229853002)(14444005)(7736002)(7696005)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0789;H:CY4PR21MB0629.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g9ygW9c6xe8ns2IOS9jGOGYQhCholMo9x31rz9qpZX9IPahFkEntWp8M9TipUBCOkSG7c1dnOd3oaX9Dbu35hVfgYGOsDXJskmcczPIuAPCFYBSQS/+XXggPRMDGafKt4Rri1xExSP9D1Tjyieqbeu63uxg0vwrruTEU5jvuqYdHU6cJy63euhJ0AUR6N9AsJZGvTWivFTkRlhgnE0YsqCnrVMhJHO5PD+aM3QmCa+w/tyE9T/T3BatY4QSFgs+rkYy0MDTj2g87da949OaRwRN1WDPMztqkCfkX7om1kLic4zyWcGlPxqyae+M52LVOkQQSEWIEa1LW2dnOqU2YqJgremM9tbXTj7KCORRIEtZCXoYzBac5P+rH1AvxDj3Yts/xq5XVD6KA3s9Rezpz2Wy7hcqAE3LtlHMrZc63flqqZvu+eoOdtV0tLavNaBVM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: add63804-abfe-4afb-0e81-08d76d4979d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 23:37:43.8841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: esl+gqcDOjBtxecLKNG0145zczzKYaC4NKWx/oczkLi7Dgnd0x9gSrnjwdfDZTpClra+2PuZaq5Nz91NkXI4+vQALPZ0+8VrUZdXirTxbrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0789
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: lantianyu1986@gmail.com <lantianyu1986@gmail.com> Sent: Monday, Novem=
ber 11, 2019 12:45 AM
>=20
> This patch is to add VFIO VMBUS driver support in order to expose
> VMBUS devices to user space drivers(Reference Hyper-V UIO driver).
> DPDK now has netvsc PMD driver support and it may get VMBUS resources
> via VFIO interface with new driver support.
>=20
> So far, Hyper-V doesn't provide virtual IOMMU support and so this
> driver needs to be used with VFIO noiommu mode.
>=20
> Current netvsc PMD driver in DPDK doesn't have IRQ mode support.
> This driver version skips IRQ control part and adds later when
> there is a real request.

Let me suggest some cleaned up wording for the commit message:

Add a VFIO VMBus driver to expose VMBus devices to user-space
drivers in a manner similar to the Hyper-V UIO driver.  For example,
DPDK has a netvsc Poll-Mode Driver (PMD) and it can get VMBus
resources via the VFIO interface with this new driver.

Hyper-V doesn't provide a virtual IOMMU in guest VMs, so this=20
driver must be used in VFIO noiommu mode.

The current netvsc PMD driver in DPDK doesn't use IRQ mode so this
driver does not implement IRQ control.  IRQ control can be added
later when there is a PMD driver that needs it.

>=20
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  MAINTAINERS                     |   1 +
>  drivers/vfio/Kconfig            |   1 +
>  drivers/vfio/Makefile           |   1 +
>  drivers/vfio/vmbus/Kconfig      |   9 +
>  drivers/vfio/vmbus/vfio_vmbus.c | 407
> ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  12 ++
>  6 files changed, 431 insertions(+)
>  create mode 100644 drivers/vfio/vmbus/Kconfig
>  create mode 100644 drivers/vfio/vmbus/vfio_vmbus.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 55199ef7fa74..6f61fb351a5d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7574,6 +7574,7 @@ F:	drivers/scsi/storvsc_drv.c
>  F:	drivers/uio/uio_hv_generic.c
>  F:	drivers/video/fbdev/hyperv_fb.c
>  F:	drivers/iommu/hyperv-iommu.c
> +F:	drivers/vfio/vmbus/
>  F:	net/vmw_vsock/hyperv_transport.c
>  F:	include/clocksource/hyperv_timer.h
>  F:	include/linux/hyperv.h
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index fd17db9b432f..f4e075fcedbe 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -47,4 +47,5 @@ menuconfig VFIO_NOIOMMU
>  source "drivers/vfio/pci/Kconfig"
>  source "drivers/vfio/platform/Kconfig"
>  source "drivers/vfio/mdev/Kconfig"
> +source "drivers/vfio/vmbus/Kconfig"
>  source "virt/lib/Kconfig"
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index de67c4725cce..acef916cba7f 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_VFIO_SPAPR_EEH) +=3D vfio_spapr_eeh.o
>  obj-$(CONFIG_VFIO_PCI) +=3D pci/
>  obj-$(CONFIG_VFIO_PLATFORM) +=3D platform/
>  obj-$(CONFIG_VFIO_MDEV) +=3D mdev/
> +obj-$(CONFIG_VFIO_VMBUS) +=3D vmbus/
> diff --git a/drivers/vfio/vmbus/Kconfig b/drivers/vfio/vmbus/Kconfig
> new file mode 100644
> index 000000000000..27a85daae55a
> --- /dev/null
> +++ b/drivers/vfio/vmbus/Kconfig
> @@ -0,0 +1,9 @@
> +config VFIO_VMBUS
> +	tristate "VFIO support for vmbus devices"
> +	depends on VFIO && HYPERV
> +	help
> +	  Support for the VMBUS VFIO bus driver. Expose VMBUS
> +	  resources to user space drivers(e.g, DPDK and SPDK).
> +
> +	  If you don't know what to do here, say N.
> +

Let's use consistent capitalization of "VMBus".   So:

config VFIO_VMBUS
	tristate "VFIO support for Hyper-V VMBus devices"
	depends on VFIO && HYPERV
	help
	 Support for the VMBus VFIO driver, which exposes VMBus
	 resources to user space drivers (e.g., DPDK and SPDK).

	 If you don't know what to do here, say N.


> diff --git a/drivers/vfio/vmbus/vfio_vmbus.c b/drivers/vfio/vmbus/vfio_vm=
bus.c
> new file mode 100644
> index 000000000000..25d9cafa2c0a
> --- /dev/null
> +++ b/drivers/vfio/vmbus/vfio_vmbus.c
> @@ -0,0 +1,407 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * VFIO VMBUS driver.
> + *
> + * Copyright (C) 2019, Microsoft, Inc.
> + *
> + * Author : Lan Tianyu <Tianyu.Lan@microsoft.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/vfio.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/hyperv.h>
> +
> +#include "../../hv/hyperv_vmbus.h"
> +
> +
> +#define DRIVER_VERSION	"0.0.1"
> +#define DRIVER_AUTHOR	"Tianyu Lan <Tianyu.Lan@microsoft.com>"
> +#define DRIVER_DESC	"VFIO driver for VMBus devices"
> +
> +#define HV_RING_SIZE	 (512 * HV_HYP_PAGE_SIZE) /* 2M Ring size */
> +#define SEND_BUFFER_SIZE (16 * 1024 * 1024)
> +#define RECV_BUFFER_SIZE (31 * 1024 * 1024)
> +
> +struct vmbus_mem {
> +	phys_addr_t		addr;
> +	resource_size_t		size;
> +};
> +
> +struct vfio_vmbus_device {
> +	struct hv_device *hdev;
> +	atomic_t refcnt;
> +	struct  vmbus_mem mem[VFIO_VMBUS_MAX_MAP_NUM];
> +
> +	void	*recv_buf;
> +	void	*send_buf;
> +};
> +
> +static void vfio_vmbus_channel_cb(void *context)
> +{
> +	struct vmbus_channel *chan =3D context;
> +
> +	/* Disable interrupts on channel */
> +	chan->inbound.ring_buffer->interrupt_mask =3D 1;
> +
> +	/* Issue a full memory barrier after masking interrupt */
> +	virt_mb();
> +}
> +
> +static int vfio_vmbus_ring_mmap(struct file *filp, struct kobject *kobj,
> +			    struct bin_attribute *attr,
> +			    struct vm_area_struct *vma)
> +{
> +	struct vmbus_channel *channel
> +		=3D container_of(kobj, struct vmbus_channel, kobj);
> +	void *ring_buffer =3D page_address(channel->ringbuffer_page);
> +
> +	if (channel->state !=3D CHANNEL_OPENED_STATE)
> +		return -ENODEV;
> +
> +	return vm_iomap_memory(vma, virt_to_phys(ring_buffer),
> +			       channel->ringbuffer_pagecount << PAGE_SHIFT);

Use HV_HYP_PAGE_SHIFT since ringbuffer_pagecount is in units of the
Hyper-V page size, which may be different from the guest PAGE_SIZE.

> +}
> +
> +static const struct bin_attribute ring_buffer_bin_attr =3D {
> +	.attr =3D {
> +		.name =3D "ring",
> +		.mode =3D 0600,
> +	},
> +	.size =3D 2 * HV_RING_SIZE,
> +	.mmap =3D vfio_vmbus_ring_mmap,
> +};
> +

[snip]

> +static int vfio_vmbus_probe(struct hv_device *dev,
> +			 const struct hv_vmbus_device_id *dev_id)
> +{
> +	struct vmbus_channel *channel =3D dev->channel;
> +	struct vfio_vmbus_device *vdev;
> +	struct iommu_group *group;
> +	u32 gpadl;
> +	void *ring_buffer;
> +	int ret;
> +
> +	group =3D vfio_iommu_group_get(&dev->device);
> +	if (!group)
> +		return -EINVAL;
> +
> +	vdev =3D kzalloc(sizeof(*vdev), GFP_KERNEL);
> +	if (!vdev) {
> +		vfio_iommu_group_put(group, &dev->device);
> +		return -ENOMEM;
> +	}
> +
> +	ret =3D vfio_add_group_dev(&dev->device, &vfio_vmbus_ops, vdev);
> +	if (ret)
> +		goto free_vdev;
> +
> +	vdev->hdev =3D dev;
> +	ret =3D vmbus_alloc_ring(channel, HV_RING_SIZE, HV_RING_SIZE);
> +	if (ret)
> +		goto del_group_dev;
> +
> +	set_channel_read_mode(channel, HV_CALL_ISR);
> +
> +	ring_buffer =3D page_address(channel->ringbuffer_page);
> +	vdev->mem[VFIO_VMBUS_TXRX_RING_MAP].addr
> +		=3D virt_to_phys(ring_buffer);
> +	vdev->mem[VFIO_VMBUS_TXRX_RING_MAP].size
> +		=3D channel->ringbuffer_pagecount << PAGE_SHIFT;

Use HV_HYP_PAGE_SHIFT per my earlier comment.

> +
> +	vdev->mem[VFIO_VMBUS_INT_PAGE_MAP].addr
> +		=3D (phys_addr_t)vmbus_connection.int_page;
> +	vdev->mem[VFIO_VMBUS_INT_PAGE_MAP].size =3D PAGE_SIZE;

Use HV_HYP_PAGE_SIZE since the interrupt page is sized to the
Hyper-V page size, not the guest page size.

> +
> +	vdev->mem[VFIO_VMBUS_MON_PAGE_MAP].addr
> +		=3D (phys_addr_t)vmbus_connection.monitor_pages[1];
> +	vdev->mem[VFIO_VMBUS_MON_PAGE_MAP].size =3D PAGE_SIZE;

Same here for the monitor page.

> +
> +	vdev->recv_buf =3D vzalloc(RECV_BUFFER_SIZE);
> +	if (vdev->recv_buf =3D=3D NULL) {
> +		ret =3D -ENOMEM;
> +		goto free_ring;
> +	}
> +
> +	ret =3D vmbus_establish_gpadl(channel, vdev->recv_buf,
> +				    RECV_BUFFER_SIZE, &gpadl);
> +	if (ret)
> +		goto free_recv_buf;
> +
> +	vdev->mem[VFIO_VMBUS_RECV_BUF_MAP].addr
> +		=3D (phys_addr_t)vdev->recv_buf;
> +	vdev->mem[VFIO_VMBUS_RECV_BUF_MAP].size =3D RECV_BUFFER_SIZE;
> +
> +	/* Expose Recv GPADL via region info. */
> +	vdev->mem[VFIO_VMBUS_RECV_GPADL].addr =3D gpadl;
> +
> +	vdev->send_buf =3D vzalloc(SEND_BUFFER_SIZE);
> +	if (vdev->send_buf =3D=3D NULL) {
> +		ret =3D -ENOMEM;
> +		goto free_recv_gpadl;
> +	}
> +
> +	ret =3D vmbus_establish_gpadl(channel, vdev->send_buf,
> +				    SEND_BUFFER_SIZE, &gpadl);
> +	if (ret)
> +		goto free_send_buf;
> +
> +	vdev->mem[VFIO_VMBUS_SEND_BUF_MAP].addr
> +		=3D (phys_addr_t)vdev->send_buf;
> +	vdev->mem[VFIO_VMBUS_SEND_BUF_MAP].size =3D SEND_BUFFER_SIZE;
> +
> +	/* Expose Send GPADL via region info. */
> +	vdev->mem[VFIO_VMBUS_SEND_GPADL].addr =3D gpadl;
> +
> +	ret =3D sysfs_create_bin_file(&channel->kobj, &ring_buffer_bin_attr);
> +	if (ret)
> +		dev_notice(&dev->device,
> +			   "sysfs create ring bin file failed; %d\n", ret);
> +
> +	return 0;
> +
> + free_send_buf:
> +	vfree(vdev->send_buf);
> + free_recv_gpadl:
> +	vmbus_teardown_gpadl(channel, vdev->mem[VFIO_VMBUS_RECV_GPADL].addr);
> + free_recv_buf:
> +	vfree(vdev->recv_buf);
> + free_ring:
> +	vmbus_free_ring(channel);
> + del_group_dev:
> +	vfio_del_group_dev(&dev->device);
> + free_vdev:
> +	vfio_iommu_group_put(group, &dev->device);
> +	kfree(vdev);
> +	return -EINVAL;
> +}
> +

[snip]

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a147ead..611baf7a30e4 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -201,6 +201,7 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
>  #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
>  #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
> +#define VFIO_DEVICE_FLAGS_VMBUS  (1 << 6)	/* vfio-vmbus device */
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  };
> @@ -564,6 +565,17 @@ enum {
>  	VFIO_PCI_NUM_IRQS
>  };
>=20
> +enum {
> +	VFIO_VMBUS_TXRX_RING_MAP =3D 0,
> +	VFIO_VMBUS_INT_PAGE_MAP,
> +	VFIO_VMBUS_MON_PAGE_MAP,
> +	VFIO_VMBUS_RECV_BUF_MAP,
> +	VFIO_VMBUS_SEND_BUF_MAP,
> +	VFIO_VMBUS_RECV_GPADL,
> +	VFIO_VMBUS_SEND_GPADL,
> +	VFIO_VMBUS_MAX_MAP_NUM,

While the code that uses VFIO_VMBUS_MAX_MAP_NUM appears
correct, the "MAX_MAP_NUM" in the symbol name tends to
imply that this is an index value.  But it's not the max index
value -- it's actually a "count" or "size".  I think it would be
clearer as VFIO_VMBUS_MAP_COUNT or
VFIO_VMBUS_MAP_SIZE.

> +};
> +
>  /*
>   * The vfio-ccw bus driver makes use of the following fixed region and
>   * IRQ index mapping. Unimplemented regions return a size of zero.
> --
> 2.14.5

