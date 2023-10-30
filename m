Return-Path: <kvm+bounces-54-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D77287DB39D
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:40:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DCA1B20DC6
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE26D26E;
	Mon, 30 Oct 2023 06:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fB5eJIL3"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A893AD263
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:40:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFF119BA
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 23:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698647989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5nyjgS0fYQSx/D6IewuJYJKpefagBoQYUrzFE3HJwSY=;
	b=fB5eJIL3QOH7J2z/nlzm6z96Mz7TIe1d0+gfnjhjmWfN2yYRaedXmMCsSUsop/dumjnT2h
	Jh6iHC97uIMhSkz2lmb+qZOd4AVrdv02iRClEHlAjSZHv5hdpYrZ6krrrV/TiWTzKdGcEC
	lGxWX+cRBdB6p0vNV2Zn07lXhXoVQjg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-g96-M_q9MFi6P5sjkTI-Rw-1; Mon, 30 Oct 2023 02:39:43 -0400
X-MC-Unique: g96-M_q9MFi6P5sjkTI-Rw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7789577b582so549759685a.0
        for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 23:39:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698647983; x=1699252783;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5nyjgS0fYQSx/D6IewuJYJKpefagBoQYUrzFE3HJwSY=;
        b=FuwA9qzLroqt2E9dRa4FRkYGcpY+5bk/18GALrXGXxe5TYOQQuCiQg6xHp347V+MwG
         RfXnMdtOvmnrSo3M3RwfHhjwJMV63PsRQtmESzU9awSspq+RxKi3LdyKAzSmJaN4GhUq
         sHSv2sa+xrO2fA1JYy0jvksEw3hl+bw4qw+g+iS1qgVSESwemOzG6jdBhNuFrpmLtgJL
         w/JG0UU2OrvUYCZ9pc4lBXVubv1x6jKBq+DoUptEqcgAXeA0Qpp0JB2qg1yQajU/Pclj
         uCMTQCxRpqL/tLcq26BgS9ihUOQ3mf9jPnEw27D0C9l3zgnVOoGxEx0lWmtd6zXJ5ahn
         o9+Q==
X-Gm-Message-State: AOJu0Yy7SxiHv5uSJPsV5v1Cr28TTHUrecKGiicKqfvp6MLg0IsZGQk+
	JCaCbinPAJvXiSXdVBn3G/r+b3ut35SddmXPnBymNso1AEcSIftAnpay/xV7L3rMSKeERBd5wbe
	4L2/cTCl1UJsg
X-Received: by 2002:a05:620a:284a:b0:774:3581:588f with SMTP id h10-20020a05620a284a00b007743581588fmr10211177qkp.53.1698647982934;
        Sun, 29 Oct 2023 23:39:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbHw2zXdgTmOe2Ipypz0FWeothc3gJE844cZo0OJypubB7AFZMaV4V7mlETkwq0DTLZNfoTw==
X-Received: by 2002:a05:620a:284a:b0:774:3581:588f with SMTP id h10-20020a05620a284a00b007743581588fmr10211165qkp.53.1698647982600;
        Sun, 29 Oct 2023 23:39:42 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:3f78:514a:4f03:fdc0? ([2a01:e0a:280:24f0:3f78:514a:4f03:fdc0])
        by smtp.gmail.com with ESMTPSA id e22-20020a05620a209600b007756d233fbdsm3088023qka.37.2023.10.29.23.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Oct 2023 23:39:42 -0700 (PDT)
Message-ID: <365845dd-ffc4-4a0d-b5cd-622e18ae9eef@redhat.com>
Date: Mon, 30 Oct 2023 07:39:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 1/2] vfio/migration: Add debugfs to live migration
 driver
Content-Language: en-US
To: Longfang Liu <liulongfang@huawei.com>, alex.williamson@redhat.com,
 jgg@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 jonathan.cameron@huawei.com
Cc: bcreeley@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@openeuler.org
References: <20231028075447.41939-1-liulongfang@huawei.com>
 <20231028075447.41939-2-liulongfang@huawei.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <20231028075447.41939-2-liulongfang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/28/23 09:54, Longfang Liu wrote:
> There are multiple devices, software and operational steps involved
> in the process of live migration. An error occurred on any node may
> cause the live migration operation to fail.
> This complex process makes it very difficult to locate and analyze
> the cause when the function fails.
> 
> In order to quickly locate the cause of the problem when the
> live migration fails, I added a set of debugfs to the vfio
> live migration driver.
> 
>      +-------------------------------------------+
>      |                                           |
>      |                                           |
>      |                  QEMU                     |
>      |                                           |
>      |                                           |
>      +---+----------------------------+----------+
>          |      ^                     |      ^
>          |      |                     |      |
>          |      |                     |      |
>          v      |                     v      |
>       +---------+--+               +---------+--+
>       |src vfio_dev|               |dst vfio_dev|
>       +--+---------+               +--+---------+
>          |      ^                     |      ^
>          |      |                     |      |
>          v      |                     |      |
>     +-----------+----+           +-----------+----+
>     |src dev debugfs |           |dst dev debugfs |
>     +----------------+           +----------------+
> 
> The entire debugfs directory will be based on the definition of
> the CONFIG_DEBUG_FS macro. If this macro is not enabled, the
> interfaces in vfio.h will be empty definitions, and the creation
> and initialization of the debugfs directory will not be executed.
> 
>     vfio
>      |
>      +---<dev_name1>
>      |    +---migration
>      |        +--state
>      |
>      +---<dev_name2>
>           +---migration
>               +--state
> 
> debugfs will create a public root directory "vfio" file.
> then create a dev_name() file for each live migration device.
> First, create a unified state acquisition file of "migration"
> in this device directory.
> Then, create a public live migration state lookup file "state".
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   drivers/vfio/Kconfig      | 10 +++++
>   drivers/vfio/Makefile     |  1 +
>   drivers/vfio/debugfs.c    | 90 +++++++++++++++++++++++++++++++++++++++
>   drivers/vfio/vfio.h       | 14 ++++++
>   drivers/vfio/vfio_main.c  |  4 ++
>   include/linux/vfio.h      |  7 +++
>   include/uapi/linux/vfio.h |  1 +
>   7 files changed, 127 insertions(+)
>   create mode 100644 drivers/vfio/debugfs.c
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 6bda6dbb4878..ceae52fd7586 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -80,6 +80,16 @@ config VFIO_VIRQFD
>   	select EVENTFD
>   	default n
>   
> +config VFIO_DEBUGFS
> +	bool "Export VFIO internals in DebugFS"
> +	depends on DEBUG_FS
> +	help
> +	  Allows exposure of VFIO device internals. This option enables
> +	  the use of debugfs by VFIO drivers as required. The device can
> +	  cause the VFIO code create a top-level debug/vfio directory
> +	  during initialization, and then populate a subdirectory with
> +	  entries as required.
> +
>   source "drivers/vfio/pci/Kconfig"
>   source "drivers/vfio/platform/Kconfig"
>   source "drivers/vfio/mdev/Kconfig"
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index c82ea032d352..d43a699d55b1 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -8,6 +8,7 @@ vfio-$(CONFIG_VFIO_GROUP) += group.o
>   vfio-$(CONFIG_IOMMUFD) += iommufd.o
>   vfio-$(CONFIG_VFIO_CONTAINER) += container.o
>   vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> +vfio-$(CONFIG_VFIO_DEBUGFS) += debugfs.o
>   
>   obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>   obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> diff --git a/drivers/vfio/debugfs.c b/drivers/vfio/debugfs.c
> new file mode 100644
> index 000000000000..9f02ae15e084
> --- /dev/null
> +++ b/drivers/vfio/debugfs.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, HiSilicon Ltd.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/vfio.h>
> +#include "vfio.h"
> +
> +static struct dentry *vfio_debugfs_root;
> +
> +static int vfio_device_state_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev = seq->private;
> +	struct vfio_device *vdev = container_of(vf_dev, struct vfio_device, device);
> +	enum vfio_device_mig_state state;
> +	int ret;
> +
> +	BUILD_BUG_ON(VFIO_DEVICE_STATE_NR !=
> +		VFIO_DEVICE_STATE_PRE_COPY_P2P + 1);
> +
> +	ret = vdev->mig_ops->migration_get_state(vdev, &state);
> +	if (ret)
> +		return -EINVAL;
> +
> +	switch (state) {
> +	case VFIO_DEVICE_STATE_ERROR:
> +		seq_puts(seq, "ERROR\n");
> +		break;
> +	case VFIO_DEVICE_STATE_STOP:
> +		seq_puts(seq, "STOP\n");
> +		break;
> +	case VFIO_DEVICE_STATE_RUNNING:
> +		seq_puts(seq, "RUNNING\n");
> +		break;
> +	case VFIO_DEVICE_STATE_STOP_COPY:
> +		seq_puts(seq, "STOP_COPY\n");
> +		break;
> +	case VFIO_DEVICE_STATE_RESUMING:
> +		seq_puts(seq, "RESUMING\n");
> +		break;
> +	case VFIO_DEVICE_STATE_RUNNING_P2P:
> +		seq_puts(seq, "RUNNING_P2P\n");
> +		break;
> +	case VFIO_DEVICE_STATE_PRE_COPY:
> +		seq_puts(seq, "PRE_COPY\n");
> +		break;
> +	case VFIO_DEVICE_STATE_PRE_COPY_P2P:
> +		seq_puts(seq, "PRE_COPY_P2P\n");
> +		break;
> +	default:
> +		seq_puts(seq, "Invalid\n");
> +	}
> +
> +	return 0;
> +}
> +
> +void vfio_device_debugfs_init(struct vfio_device *vdev)
> +{
> +	struct device *dev = &vdev->device;
> +
> +	vdev->debug_root = debugfs_create_dir(dev_name(vdev->dev), vfio_debugfs_root);
> +
> +	if (vdev->mig_ops) {
> +		struct dentry *vfio_dev_migration = NULL;
> +
> +		vfio_dev_migration = debugfs_create_dir("migration", vdev->debug_root);
> +		debugfs_create_devm_seqfile(dev, "state", vfio_dev_migration,
> +					  vfio_device_state_read);
> +	}
> +}
> +
> +void vfio_device_debugfs_exit(struct vfio_device *vdev)
> +{
> +	debugfs_remove_recursive(vdev->debug_root);
> +}
> +
> +void vfio_debugfs_create_root(void)
> +{
> +	vfio_debugfs_root = debugfs_create_dir("vfio", NULL);
> +}
> +
> +void vfio_debugfs_remove_root(void)
> +{
> +	debugfs_remove_recursive(vfio_debugfs_root);
> +	vfio_debugfs_root = NULL;
> +}
> +
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 307e3f29b527..bde84ad344e5 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -448,4 +448,18 @@ static inline void vfio_device_put_kvm(struct vfio_device *device)
>   }
>   #endif
>   
> +#ifdef CONFIG_VFIO_DEBUGFS
> +void vfio_debugfs_create_root(void);
> +void vfio_debugfs_remove_root(void);
> +
> +void vfio_device_debugfs_init(struct vfio_device *vdev);
> +void vfio_device_debugfs_exit(struct vfio_device *vdev);
> +#else
> +static inline void vfio_debugfs_create_root(void) { }
> +static inline void vfio_debugfs_remove_root(void) { }
> +
> +static inline void vfio_device_debugfs_init(struct vfio_device *vdev) { }
> +static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { }
> +#endif /* CONFIG_VFIO_DEBUGFS */
> +
>   #endif
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index e31e1952d7b8..94f02b6891ac 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -311,6 +311,7 @@ static int __vfio_register_dev(struct vfio_device *device,
>   	refcount_set(&device->refcount, 1);
>   
>   	vfio_device_group_register(device);
> +	vfio_device_debugfs_init(device);
>   
>   	return 0;
>   err_out:
> @@ -378,6 +379,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>   		}
>   	}
>   
> +	vfio_device_debugfs_exit(device);
>   	/* Balances vfio_device_set_group in register path */
>   	vfio_device_remove_group(device);
>   }
> @@ -1676,6 +1678,7 @@ static int __init vfio_init(void)
>   	if (ret)
>   		goto err_alloc_dev_chrdev;
>   
> +	vfio_debugfs_create_root();
>   	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>   	return 0;
>   
> @@ -1691,6 +1694,7 @@ static int __init vfio_init(void)
>   
>   static void __exit vfio_cleanup(void)
>   {
> +	vfio_debugfs_remove_root();
>   	ida_destroy(&vfio.device_ida);
>   	vfio_cdev_cleanup();
>   	class_destroy(vfio.device_class);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 454e9295970c..769d7af86225 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -69,6 +69,13 @@ struct vfio_device {
>   	u8 iommufd_attached:1;
>   #endif
>   	u8 cdev_opened:1;
> +#ifdef CONFIG_DEBUG_FS
> +	/*
> +	 * debug_root is a static property of the vfio_device
> +	 * which must be set prior to registering the vfio_device.
> +	 */
> +	struct dentry *debug_root;
> +#endif
>   };
>   
>   /**
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 7f5fb010226d..2b68e6cdf190 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1219,6 +1219,7 @@ enum vfio_device_mig_state {
>   	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>   	VFIO_DEVICE_STATE_PRE_COPY = 6,
>   	VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
> +	VFIO_DEVICE_STATE_NR,
>   };
>   
>   /**


