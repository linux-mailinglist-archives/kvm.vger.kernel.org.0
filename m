Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2182F2B36
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 10:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392639AbhALJYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 04:24:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38777 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390516AbhALJYD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 04:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610443356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DbZ2mWidhHIHDmUCebTkUysNh5Tf6lzfSjTlizkeo6w=;
        b=JnaHm2SDKaMc+1u4sWkLOqHecQo3gevoSt0CI31Ra+Cf9iL93f9ymBEeCxwKTdqGqoNGoP
        BYnfOsG18FEhDSkcLo+UjWUlFr8mj786FqL8fCNJGT3AUp3cYg7fQwIFCVl1QKl4sSUBqE
        LirsM4OZ/8VIKaflUlim19CcPf9sSAY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-P3YtZOg-PiazdadSrJHIKA-1; Tue, 12 Jan 2021 04:22:32 -0500
X-MC-Unique: P3YtZOg-PiazdadSrJHIKA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F419E180A092;
        Tue, 12 Jan 2021 09:22:30 +0000 (UTC)
Received: from [10.36.114.62] (ovpn-114-62.ams2.redhat.com [10.36.114.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F017160BE2;
        Tue, 12 Jan 2021 09:22:22 +0000 (UTC)
Subject: Re: [RFC v3 2/2] vfio/platform: msi: add Broadcom platform devices
To:     Vikas Gupta <vikas.gupta@broadcom.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com,
        ashwin.kamath@broadcom.com, zachary.schroff@broadcom.com,
        manish.kurup@broadcom.com
References: <20201124161646.41191-1-vikas.gupta@broadcom.com>
 <20201214174514.22006-1-vikas.gupta@broadcom.com>
 <20201214174514.22006-3-vikas.gupta@broadcom.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b3dcbca3-c85a-d327-e64e-5830286dfbba@redhat.com>
Date:   Tue, 12 Jan 2021 10:22:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201214174514.22006-3-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 12/14/20 6:45 PM, Vikas Gupta wrote:
> Add msi support for Broadcom platform devices
> 
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> ---
>  drivers/vfio/platform/Kconfig                 |  1 +
>  drivers/vfio/platform/Makefile                |  1 +
>  drivers/vfio/platform/msi/Kconfig             |  9 ++++
>  drivers/vfio/platform/msi/Makefile            |  2 +
>  .../vfio/platform/msi/vfio_platform_bcmplt.c  | 49 +++++++++++++++++++
>  5 files changed, 62 insertions(+)
>  create mode 100644 drivers/vfio/platform/msi/Kconfig
>  create mode 100644 drivers/vfio/platform/msi/Makefile
>  create mode 100644 drivers/vfio/platform/msi/vfio_platform_bcmplt.c
what does plt mean?
> 
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index dc1a3c44f2c6..7b8696febe61 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -21,3 +21,4 @@ config VFIO_AMBA
>  	  If you don't know what to do here, say N.
>  
>  source "drivers/vfio/platform/reset/Kconfig"
> +source "drivers/vfio/platform/msi/Kconfig"
> diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
> index 3f3a24e7c4ef..9ccdcdbf0e7e 100644
> --- a/drivers/vfio/platform/Makefile
> +++ b/drivers/vfio/platform/Makefile
> @@ -5,6 +5,7 @@ vfio-platform-y := vfio_platform.o
>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform-base.o
>  obj-$(CONFIG_VFIO_PLATFORM) += reset/
> +obj-$(CONFIG_VFIO_PLATFORM) += msi/
>  
>  vfio-amba-y := vfio_amba.o
>  
> diff --git a/drivers/vfio/platform/msi/Kconfig b/drivers/vfio/platform/msi/Kconfig
> new file mode 100644
> index 000000000000..54d6b70e1e32
> --- /dev/null
> +++ b/drivers/vfio/platform/msi/Kconfig
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config VFIO_PLATFORM_BCMPLT_MSI
> +	tristate "MSI support for Broadcom platform devices"
> +	depends on VFIO_PLATFORM && (ARCH_BCM_IPROC || COMPILE_TEST)
> +	default ARCH_BCM_IPROC
> +	help
> +	  Enables the VFIO platform driver to handle msi for Broadcom devices
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/platform/msi/Makefile b/drivers/vfio/platform/msi/Makefile
> new file mode 100644
> index 000000000000..27422d45cecb
> --- /dev/null
> +++ b/drivers/vfio/platform/msi/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0
> +obj-$(CONFIG_VFIO_PLATFORM_BCMPLT_MSI) += vfio_platform_bcmplt.o
> diff --git a/drivers/vfio/platform/msi/vfio_platform_bcmplt.c b/drivers/vfio/platform/msi/vfio_platform_bcmplt.c
> new file mode 100644
> index 000000000000..a074b5e92d77
> --- /dev/null
> +++ b/drivers/vfio/platform/msi/vfio_platform_bcmplt.c
> @@ -0,0 +1,49 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2020 Broadcom.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/interrupt.h>
> +#include <linux/msi.h>
> +#include <linux/vfio.h>
> +
> +#include "../vfio_platform_private.h"
> +
> +#define RING_SIZE		(64 << 10)
> +
> +#define RING_MSI_ADDR_LS	0x03c
> +#define RING_MSI_ADDR_MS	0x040
> +#define RING_MSI_DATA_VALUE	0x064
Those 3 defines would not be needed anymore with that implementation option.
> +
> +static u32 bcm_num_msi(struct vfio_platform_device *vdev)
> +{
> +	struct vfio_platform_region *reg = &vdev->regions[0];
> +
> +	return (reg->size / RING_SIZE);
> +}
> +
> +static struct vfio_platform_msi_node vfio_platform_bcmflexrm_msi_node = {
> +	.owner = THIS_MODULE,
> +	.compat = "brcm,iproc-flexrm-mbox",
> +	.of_get_msi = bcm_num_msi,
> +};
> +
> +static int __init vfio_platform_bcmflexrm_msi_module_init(void)
> +{
> +	__vfio_platform_register_msi(&vfio_platform_bcmflexrm_msi_node);
> +
> +	return 0;
> +}
> +
> +static void __exit vfio_platform_bcmflexrm_msi_module_exit(void)
> +{
> +	vfio_platform_unregister_msi("brcm,iproc-flexrm-mbox");
> +}
> +
> +module_init(vfio_platform_bcmflexrm_msi_module_init);
> +module_exit(vfio_platform_bcmflexrm_msi_module_exit);
One thing I would like to discuss with Alex.

As the reset module is mandated (except if reset_required is forced to
0), I am wondering if we shouldn't try to turn the reset module into a
"specialization" module and put the msi hooks there. I am afraid we may
end up having modules for each and every vfio platform feature
specialization. At the moment that's fully bearable but I can't predict
what's next.

As the mandated feature is the reset capability maybe we could just keep
the config/module name terminology, tune the kconfig help message to
mention the msi support in case of flex-rm?

What do you think?

Thanks

Eric




> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Broadcom");
> 

