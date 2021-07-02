Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92D3BA4AC
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 22:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhGBUcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 16:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231137AbhGBUcN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Jul 2021 16:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625257780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=43m9ZMNlwSNeKVrq0tRO/O1TR5j/lIl0glWtuE7KCzs=;
        b=jV3gUdG67XzJ3bQmBBI8AYDHyU7OZXFmjCLP5FKhuFo6B6sQyF3yy/DjYchS/Ti41eJ8rv
        op5zJA6+awWMPWrOSujE6TM2hiYrLcagbFME0JK1LPnSmnNumwER1ADHIKVDnTzQFB6poR
        WN+gEO+rKtQzMJ5RG0Y9pkod+wR8/Uo=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-HhTcoXIzNUKNInkuzf4h_Q-1; Fri, 02 Jul 2021 16:29:39 -0400
X-MC-Unique: HhTcoXIzNUKNInkuzf4h_Q-1
Received: by mail-oi1-f198.google.com with SMTP id b18-20020acafd120000b029023d714b710fso6270157oii.4
        for <kvm@vger.kernel.org>; Fri, 02 Jul 2021 13:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43m9ZMNlwSNeKVrq0tRO/O1TR5j/lIl0glWtuE7KCzs=;
        b=EUKz/dRr7rKwD3q0hvJaVSeytHCmGPsh+yzDT5bDfAmzfnl2N+tHVnkCfTWBwHW40s
         q6rsBTKZA/rEJEy4sj7N7/7eGrxbzfJpJqL9dHH6sAJ+kEwj0vqkz3CvjqJjlldZhOtL
         EB9lpiVsaQ3wCFM0Haeya3dU2QcsIXLJ8ej9KeoQ+vj3HdS+KJiwKP+e+mkTjRDsj+Jg
         TvxL89SOdiDrT+O5bWBkFMb5MJv3hQxDpJ/9WsOLY5qrFe0QtYfpK/RT8n/RRcZ9Sjqv
         oSYru7S1ulR1AHLQGX6/m4Mi2Y6MtzbAzndPdf2lZ7JQo3HGAgJbFEotVsV7rWDRbB3I
         e0rQ==
X-Gm-Message-State: AOAM533F4JLzUoQxXjmOx3hWZg1krbXhq6gX6xwKdG3Hgm/s1UPdUQft
        6Y9Sovd0hFdIbWUGXeCgHJnjXjj+SApR9Zyr3vfv4kXuwezDt9NOGFFF8l0KxQpcT2ryqIRSBVc
        KQwokLvz48IAU
X-Received: by 2002:aca:3bc3:: with SMTP id i186mr1209797oia.102.1625257778612;
        Fri, 02 Jul 2021 13:29:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJGZxdvdDgbA5jf/eA3mNAUGNVwqo/oKw3QtnN938999lHw9G7kVlYyunnUZrw5ODGPAbp+Q==
X-Received: by 2002:aca:3bc3:: with SMTP id i186mr1209778oia.102.1625257778458;
        Fri, 02 Jul 2021 13:29:38 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id o45sm788385ota.59.2021.07.02.13.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 13:29:38 -0700 (PDT)
Date:   Fri, 2 Jul 2021 14:29:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <yuzenghui@huawei.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 2/4] hisi_acc_vfio_pci: Override ioctl method to limit
 BAR2 region size
Message-ID: <20210702142937.5cbe366f.alex.williamson@redhat.com>
In-Reply-To: <20210702095849.1610-3-shameerali.kolothum.thodi@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
        <20210702095849.1610-3-shameerali.kolothum.thodi@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Jul 2021 10:58:47 +0100
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> HiSilicon ACC VF device BAR2 region consists of both functional register
> space and migration control register space. From a security point of
> view, it's not advisable to export the migration control region to Guest.
> 
> Hence, hide the migration region and report only the functional register
> space.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/pci/hisi_acc_vfio_pci.c | 42 +++++++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> index a9e173098ab5..d57cf6d7adaf 100644
> --- a/drivers/vfio/pci/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> @@ -12,6 +12,46 @@
>  #include <linux/vfio.h>
>  #include <linux/vfio_pci_core.h>
>  
> +static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> +				    unsigned long arg)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +
> +	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> +		struct pci_dev *pdev = vdev->pdev;
> +		struct vfio_region_info info;
> +		unsigned long minsz;
> +
> +		minsz = offsetofend(struct vfio_region_info, offset);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +
> +			/*
> +			 * ACC VF dev BAR2 region(64K) consists of both functional
> +			 * register space and migration control register space.
> +			 * Report only the first 32K(functional region) to Guest.
> +			 */
> +			info.size = pci_resource_len(pdev, info.index) / 2;
> +

Great, but what actually prevents the user from accessing the full
extent of the BAR since you're re-using core code for read/write/mmap,
which are all basing access on pci_resource_len()?  Thanks,

Alex

> +			info.flags = VFIO_REGION_INFO_FLAG_READ |
> +					VFIO_REGION_INFO_FLAG_WRITE |
> +					VFIO_REGION_INFO_FLAG_MMAP;
> +
> +			return copy_to_user((void __user *)arg, &info, minsz) ?
> +					    -EFAULT : 0;
> +		}
> +	}
> +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +}
> +
>  static int hisi_acc_vfio_pci_open(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =
> @@ -33,7 +73,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>  	.name		= "hisi-acc-vfio-pci",
>  	.open		= hisi_acc_vfio_pci_open,
>  	.release	= vfio_pci_core_release,
> -	.ioctl		= vfio_pci_core_ioctl,
> +	.ioctl		= hisi_acc_vfio_pci_ioctl,
>  	.read		= vfio_pci_core_read,
>  	.write		= vfio_pci_core_write,
>  	.mmap		= vfio_pci_core_mmap,

