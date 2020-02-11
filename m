Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248BF1599C7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 20:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731666AbgBKTav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 14:30:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46850 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729604AbgBKTav (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 14:30:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581449450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8/RCUyQmY3b0O8AQSk1+jlR5RNjP8umXMh5ezZmYzvI=;
        b=i4U+kqowWa/h0Z39wFca9z4JF2/7HFqEx02bYgFr6ql4JSG6F3ikiITjP8fWhTEb/4oKnv
        1ZupL4230fbUF2Zms1TB0lv6YS3YpABvQVScJPEGAtbVCbVdO8OHpw4blZW7sv+FzPAIY0
        xvbEWHk19EKXvadqRqIrqtWikbY1m3o=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-CjLLj68LMNiZ7BQdX5aVJQ-1; Tue, 11 Feb 2020 14:30:28 -0500
X-MC-Unique: CjLLj68LMNiZ7BQdX5aVJQ-1
Received: by mail-qv1-f70.google.com with SMTP id b8so7910461qvw.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 11:30:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8/RCUyQmY3b0O8AQSk1+jlR5RNjP8umXMh5ezZmYzvI=;
        b=E4M67IfS2UiVmcBUrN0TUK1kbxd8ZYxQxndZBeN2NyuWIHt7kMHOIYsHgCt/+Uq1or
         Xgmoo6P9FDytrnACQsAgiFn+Pr0CX1QnezTj9j0JBLnQ31s53pyt0OMz1he4na4h6jcB
         cIjoSIJ0Aa2oISkOwxn4C6CSkHjny5QCcEiF5e6n4hJdw8i2O9uwIKbAFzp6E/coqkMX
         rNVusgwIMC+VqzT6xcztQdx14mHe/dWu1mT/xQQum6Hp4bo0Z8pxy+aD1aiALBzhMgvu
         C/U4+qPclgQR9NaClJJyay6mmBRJOy+os29RdKu9dtKb0PDEMFtuxaVY82GGMPlWDwkP
         i7YQ==
X-Gm-Message-State: APjAAAWKiiRApYTEAi/OjjBDt7ScuzcKtRxhKyWdZglzEYRtdkpcmv7/
        OC3KZMmSqaR3c0gOEpkrZM/9mK0o9nK54KPqhh57us9aMyN/A423uFIoGQOafXvM2jc5eZ5+nxM
        vYkFStwPyXJ/k
X-Received: by 2002:aed:20f1:: with SMTP id 104mr3844936qtb.121.1581449426139;
        Tue, 11 Feb 2020 11:30:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqwV7nTONMBjVSfOQa7+i/GT2MWP7mnSbWBzLJMFZCetQl5L8ytr9gNO7kK+R69gcoYxbEk3VA==
X-Received: by 2002:aed:20f1:: with SMTP id 104mr3844911qtb.121.1581449425846;
        Tue, 11 Feb 2020 11:30:25 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id 24sm2612882qka.32.2020.02.11.11.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 11:30:25 -0800 (PST)
Date:   Tue, 11 Feb 2020 14:30:22 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        eric.auger@redhat.com, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 11/25] vfio: get stage-1 pasid formats from Kernel
Message-ID: <20200211193022.GI984290@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-12-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1580300216-86172-12-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 29, 2020 at 04:16:42AM -0800, Liu, Yi L wrote:
> From: Liu Yi L <yi.l.liu@intel.com>
> 
> VFIO checks IOMMU UAPI version when it finds Kernel supports
> VFIO_TYPE1_NESTING_IOMMU. It is enough for UAPI compatibility
> check. However, IOMMU UAPI may support multiple stage-1 pasid
> formats in a specific UAPI version, which is highly possible
> since IOMMU UAPI supports stage-1 formats across all IOMMU vendors.
> So VFIO needs to get the supported formats from Kernel and tell
> vIOMMU. Let vIOMMU select proper format when setup dual stage DMA
> translation.
> 
> This patch gets the stage-1 pasid format from kernel by using IOCTL
> VFIO_IOMMU_GET_INFO and pass the supported format to vIOMMU by the
> DualStageIOMMUObject instance which has been registered to vIOMMU.
> 
> This patch referred some code from Shameer Kolothum.
> https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg03759.html
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/iommu/dual_stage_iommu.c         |  5 ++-
>  hw/vfio/common.c                    | 85 ++++++++++++++++++++++++++++++++++++-
>  include/hw/iommu/dual_stage_iommu.h | 10 ++++-
>  3 files changed, 97 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/iommu/dual_stage_iommu.c b/hw/iommu/dual_stage_iommu.c
> index be4179d..d5a7168 100644
> --- a/hw/iommu/dual_stage_iommu.c
> +++ b/hw/iommu/dual_stage_iommu.c
> @@ -48,9 +48,12 @@ int ds_iommu_pasid_free(DualStageIOMMUObject *dsi_obj, uint32_t pasid)
>  }
>  
>  void ds_iommu_object_init(DualStageIOMMUObject *dsi_obj,
> -                          DualStageIOMMUOps *ops)
> +                          DualStageIOMMUOps *ops,
> +                          DualStageIOMMUInfo *uinfo)
>  {
>      dsi_obj->ops = ops;
> +
> +    dsi_obj->uinfo.pasid_format = uinfo->pasid_format;
>  }
>  
>  void ds_iommu_object_destroy(DualStageIOMMUObject *dsi_obj)
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index fc1723d..a07824b 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -1182,10 +1182,84 @@ static int vfio_get_iommu_type(VFIOContainer *container,
>  static struct DualStageIOMMUOps vfio_ds_iommu_ops = {
>  };
>  
> +static int vfio_get_iommu_info(VFIOContainer *container,
> +                         struct vfio_iommu_type1_info **info)

Better comment on the function to remember to free(*info) after use
for the callers.

> +{
> +
> +    size_t argsz = sizeof(struct vfio_iommu_type1_info);
> +

Nit: extra newline.

> +
> +    *info = g_malloc0(argsz);
> +
> +retry:
> +    (*info)->argsz = argsz;
> +
> +    if (ioctl(container->fd, VFIO_IOMMU_GET_INFO, *info)) {
> +        g_free(*info);
> +        *info = NULL;
> +        return -errno;
> +    }
> +
> +    if (((*info)->argsz > argsz)) {
> +        argsz = (*info)->argsz;
> +        *info = g_realloc(*info, argsz);
> +        goto retry;
> +    }
> +
> +    return 0;
> +}
> +
> +static struct vfio_info_cap_header *
> +vfio_get_iommu_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
> +{
> +    struct vfio_info_cap_header *hdr;
> +    void *ptr = info;
> +
> +    if (!(info->flags & VFIO_IOMMU_INFO_CAPS)) {
> +        return NULL;
> +    }
> +
> +    for (hdr = ptr + info->cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
> +        if (hdr->id == id) {
> +            return hdr;
> +        }
> +    }
> +
> +    return NULL;
> +}
> +
> +static int vfio_get_nesting_iommu_format(VFIOContainer *container,
> +                                         uint32_t *pasid_format)
> +{
> +    struct vfio_iommu_type1_info *info;
> +    struct vfio_info_cap_header *hdr;
> +    struct vfio_iommu_type1_info_cap_nesting *cap;
> +
> +    if (vfio_get_iommu_info(container, &info)) {
> +        return -errno;

Should return the retcode from vfio_get_iommu_info.

> +    }
> +
> +    hdr = vfio_get_iommu_info_cap(info,
> +                        VFIO_IOMMU_TYPE1_INFO_CAP_NESTING);
> +    if (!hdr) {
> +        g_free(info);
> +        return -errno;
> +    }
> +
> +    cap = container_of(hdr,
> +                struct vfio_iommu_type1_info_cap_nesting, header);
> +    *pasid_format = cap->pasid_format;
> +
> +    g_free(info);
> +    return 0;
> +}
> +
>  static int vfio_init_container(VFIOContainer *container, int group_fd,
>                                 Error **errp)
>  {
>      int iommu_type, ret;
> +    uint32_t format;
> +    DualStageIOMMUInfo uinfo;
>  
>      iommu_type = vfio_get_iommu_type(container, errp);
>      if (iommu_type < 0) {
> @@ -1214,7 +1288,16 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
>      }
>  
>      if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
> -        ds_iommu_object_init(&container->dsi_obj, &vfio_ds_iommu_ops);
> +        if (vfio_get_nesting_iommu_format(container, &format)) {
> +            error_setg_errno(errp, errno,
> +                             "Failed to get nesting iommu format");
> +            return -errno;

Same here, you might want to return the retcode from
vfio_get_nesting_iommu_format()?

> +        }
> +
> +        uinfo.pasid_format = format;
> +        ds_iommu_object_init(&container->dsi_obj,
> +                             &vfio_ds_iommu_ops, &uinfo);
> +
>          if (iommu_context_register_ds_iommu(container->iommu_ctx,
>                                              &container->dsi_obj)) {
>              /*
> diff --git a/include/hw/iommu/dual_stage_iommu.h b/include/hw/iommu/dual_stage_iommu.h
> index e9891e3..c6100b4 100644
> --- a/include/hw/iommu/dual_stage_iommu.h
> +++ b/include/hw/iommu/dual_stage_iommu.h
> @@ -23,12 +23,14 @@
>  #define HW_DS_IOMMU_H
>  
>  #include "qemu/queue.h"
> +#include <linux/iommu.h>
>  #ifndef CONFIG_USER_ONLY
>  #include "exec/hwaddr.h"
>  #endif
>  
>  typedef struct DualStageIOMMUObject DualStageIOMMUObject;
>  typedef struct DualStageIOMMUOps DualStageIOMMUOps;
> +typedef struct DualStageIOMMUInfo DualStageIOMMUInfo;
>  
>  struct DualStageIOMMUOps {
>      /* Allocate pasid from DualStageIOMMU (a.k.a. host IOMMU) */
> @@ -41,11 +43,16 @@ struct DualStageIOMMUOps {
>                        uint32_t pasid);
>  };
>  
> +struct DualStageIOMMUInfo {
> +    uint32_t pasid_format;
> +};
> +
>  /*
>   * This is an abstraction of Dual-stage IOMMU.
>   */
>  struct DualStageIOMMUObject {
>      DualStageIOMMUOps *ops;
> +    DualStageIOMMUInfo uinfo;
>  };
>  
>  int ds_iommu_pasid_alloc(DualStageIOMMUObject *dsi_obj, uint32_t min,
> @@ -53,7 +60,8 @@ int ds_iommu_pasid_alloc(DualStageIOMMUObject *dsi_obj, uint32_t min,
>  int ds_iommu_pasid_free(DualStageIOMMUObject *dsi_obj, uint32_t pasid);
>  
>  void ds_iommu_object_init(DualStageIOMMUObject *dsi_obj,
> -                          DualStageIOMMUOps *ops);
> +                          DualStageIOMMUOps *ops,
> +                          DualStageIOMMUInfo *uinfo);
>  void ds_iommu_object_destroy(DualStageIOMMUObject *dsi_obj);
>  
>  #endif
> -- 
> 2.7.4
> 

-- 
Peter Xu

