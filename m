Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E165319C336
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 15:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgDBNww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 09:52:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40899 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgDBNww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 09:52:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id a81so3727933wmf.5
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 06:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Af2JSDwihc8nF6h/8r9tRfhzK4NkNkC7mPnujbacA4E=;
        b=WYfXg3X36AvqTwJlAkbyeB6mKBOAK4tblKRvp+PMMksyR0S+HJiQ8pBMj3B8ZUuAyx
         9iFRCYbcf7lfCQMiTODRucJHoBZHdViAHeeudHlctD3QMK3Nk6uqA4b6yPPC3ZrtUD/Z
         c5vy1wJM/9q0Xg/l6zOKJJ7K9Pdum8Yk6zYxbAJLfrX1bgMDIBsISAHQ93Ww2aOTyF9H
         jwL2pYynj7Sy+tGf70y/BhPAtrsRWlqoxT2kL2R3v3862E9vGOtoAK7yFFk4nfSD0oAw
         Ksv7LLgk+aMBu8EqTzLL7LcEDcdMqxpBUaNqyrkWiOHrfRYMiOPaqTtrrkwRGO7ljpMl
         KCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Af2JSDwihc8nF6h/8r9tRfhzK4NkNkC7mPnujbacA4E=;
        b=tQ56bIm/Kk223hCinXMERQOOdodZhzauad9ghLJuUI+ulF4M9o6ts7nQK9TSefNu68
         1pQK8H/YMBx1FHE8JqCxX77EpeUfYClvbEhcwHWPTK9GgL0H/fxq9vdqJFDafBK99J7w
         Wk/sXA+DxM9uX9NsRv/COLr0LZQv6/NadQnGyv8ctANtYG3oB4ZsLfD+IMJ3z/iWuTn0
         Iq3AWzpT32VuBaEfSjgCXXth9kV4kLlvkff1k8ie23H0nzI43WFX5uNELCyWjO2U9xM+
         qc9itG9SUL1XY9VUlKtd/MXvR++aA04HQeXFLpK+/251vNBcqsNVPfOUb6xybT4R1WlY
         q60A==
X-Gm-Message-State: AGi0PuYtJRNCGtE9KH47GEs0JxWJrNjNAp40MnfQk+LBrEBbzapkvFua
        NIu5FWd4hxu1/I4GYGLGL7iDMA==
X-Google-Smtp-Source: APiQypLNnVYOD2AZt87qLBOpKyN+9iazNk3xW8ANrER0HUdIDL6UmjerB/gZbsECOzD4MivOwsvPlw==
X-Received: by 2002:a1c:2285:: with SMTP id i127mr3827555wmi.152.1585835569034;
        Thu, 02 Apr 2020 06:52:49 -0700 (PDT)
Received: from myrica ([2001:171b:226b:54a0:6097:1406:6470:33b5])
        by smtp.gmail.com with ESMTPSA id w204sm7370919wma.1.2020.04.02.06.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 06:52:48 -0700 (PDT)
Date:   Thu, 2 Apr 2020 15:52:40 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hao.wu@intel.com
Subject: Re: [PATCH v1 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Message-ID: <20200402135240.GE1176452@myrica>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584880325-10561-2-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On Sun, Mar 22, 2020 at 05:31:58AM -0700, Liu, Yi L wrote:
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> For a long time, devices have only one DMA address space from platform
> IOMMU's point of view. This is true for both bare metal and directed-
> access in virtualization environment. Reason is the source ID of DMA in
> PCIe are BDF (bus/dev/fnc ID), which results in only device granularity
> DMA isolation. However, this is changing with the latest advancement in
> I/O technology area. More and more platform vendors are utilizing the PCIe
> PASID TLP prefix in DMA requests, thus to give devices with multiple DMA
> address spaces as identified by their individual PASIDs. For example,
> Shared Virtual Addressing (SVA, a.k.a Shared Virtual Memory) is able to
> let device access multiple process virtual address space by binding the
> virtual address space with a PASID. Wherein the PASID is allocated in
> software and programmed to device per device specific manner. Devices
> which support PASID capability are called PASID-capable devices. If such
> devices are passed through to VMs, guest software are also able to bind
> guest process virtual address space on such devices. Therefore, the guest
> software could reuse the bare metal software programming model, which
> means guest software will also allocate PASID and program it to device
> directly. This is a dangerous situation since it has potential PASID
> conflicts and unauthorized address space access.

It's worth noting that this applies to Intel VT-d with scalable mode, not
IOMMUs that use one PASID space per VM

> It would be safer to
> let host intercept in the guest software's PASID allocation. Thus PASID
> are managed system-wide.
> 
> This patch adds VFIO_IOMMU_PASID_REQUEST ioctl which aims to passdown
> PASID allocation/free request from the virtual IOMMU. Additionally, such
> requests are intended to be invoked by QEMU or other applications which
> are running in userspace, it is necessary to have a mechanism to prevent
> single application from abusing available PASIDs in system. With such
> consideration, this patch tracks the VFIO PASID allocation per-VM. There
> was a discussion to make quota to be per assigned devices. e.g. if a VM
> has many assigned devices, then it should have more quota. However, it
> is not sure how many PASIDs an assigned devices will use. e.g. it is
> possible that a VM with multiples assigned devices but requests less
> PASIDs. Therefore per-VM quota would be better.
> 
> This patch uses struct mm pointer as a per-VM token. We also considered
> using task structure pointer and vfio_iommu structure pointer. However,
> task structure is per-thread, which means it cannot achieve per-VM PASID
> alloc tracking purpose. While for vfio_iommu structure, it is visible
> only within vfio. Therefore, structure mm pointer is selected. This patch
> adds a structure vfio_mm. A vfio_mm is created when the first vfio
> container is opened by a VM. On the reverse order, vfio_mm is free when
> the last vfio container is released. Each VM is assigned with a PASID
> quota, so that it is not able to request PASID beyond its quota. This
> patch adds a default quota of 1000. This quota could be tuned by
> administrator. Making PASID quota tunable will be added in another patch
> in this series.
> 
> Previous discussions:
> https://patchwork.kernel.org/patch/11209429/
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/vfio/vfio.c             | 130 ++++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c | 104 ++++++++++++++++++++++++++++++++
>  include/linux/vfio.h            |  20 +++++++
>  include/uapi/linux/vfio.h       |  41 +++++++++++++
>  4 files changed, 295 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index c848262..d13b483 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -32,6 +32,7 @@
>  #include <linux/vfio.h>
>  #include <linux/wait.h>
>  #include <linux/sched/signal.h>
> +#include <linux/sched/mm.h>
>  
>  #define DRIVER_VERSION	"0.3"
>  #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
> @@ -46,6 +47,8 @@ static struct vfio {
>  	struct mutex			group_lock;
>  	struct cdev			group_cdev;
>  	dev_t				group_devt;
> +	struct list_head		vfio_mm_list;
> +	struct mutex			vfio_mm_lock;
>  	wait_queue_head_t		release_q;
>  } vfio;
>  
> @@ -2129,6 +2132,131 @@ int vfio_unregister_notifier(struct device *dev, enum vfio_notify_type type,
>  EXPORT_SYMBOL(vfio_unregister_notifier);
>  
>  /**
> + * VFIO_MM objects - create, release, get, put, search
> + * Caller of the function should have held vfio.vfio_mm_lock.
> + */
> +static struct vfio_mm *vfio_create_mm(struct mm_struct *mm)
> +{
> +	struct vfio_mm *vmm;
> +	struct vfio_mm_token *token;
> +	int ret = 0;
> +
> +	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
> +	if (!vmm)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Per mm IOASID set used for quota control and group operations */
> +	ret = ioasid_alloc_set((struct ioasid_set *) mm,

Hmm, either we need to change the token of ioasid_alloc_set() to "void *",
or pass an actual ioasid_set struct, but this cast doesn't look good :)

As I commented on the IOASID series, I think we could embed a struct
ioasid_set into vfio_mm, pass that struct to all other ioasid_* functions,
and get rid of ioasid_sid.

> +			       VFIO_DEFAULT_PASID_QUOTA, &vmm->ioasid_sid);
> +	if (ret) {
> +		kfree(vmm);
> +		return ERR_PTR(ret);
> +	}
> +
> +	kref_init(&vmm->kref);
> +	token = &vmm->token;
> +	token->val = mm;

Why the intermediate token struct?  Could we just store the mm_struct
pointer within vfio_mm?

Thanks,
Jean

> +	vmm->pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
> +	mutex_init(&vmm->pasid_lock);
> +
> +	list_add(&vmm->vfio_next, &vfio.vfio_mm_list);
> +
> +	return vmm;
> +}
