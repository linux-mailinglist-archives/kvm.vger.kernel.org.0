Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDFE1917E4
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 18:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgCXRlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 13:41:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:58470 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727266AbgCXRlb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 13:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585071688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1cxwpAjAvJgiTag2oVzWW4NLxKFpoQLU/K4LJGxmdn4=;
        b=Y/BRhQdK4EOyDTZ9DsoTuTrLSdxgJBWnxJSB2nD3qEN+/sBWhrsISonS3yb5HmJ3bTxxtq
        aTfWDY2utFjc2OLZ2SODt6Qs3HnOPYBP6di3TI97sGJCEPJd9KxRFCKqGGKIss6wlzkyy3
        jGlJ9jKXpQqqcmJ9aNxHltTPZRLawBE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-g95hJA0zPBOkWqffXA01HA-1; Tue, 24 Mar 2020 13:41:26 -0400
X-MC-Unique: g95hJA0zPBOkWqffXA01HA-1
Received: by mail-wr1-f72.google.com with SMTP id f15so4185897wrt.4
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 10:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1cxwpAjAvJgiTag2oVzWW4NLxKFpoQLU/K4LJGxmdn4=;
        b=AuW0tpzQ1RGuIJxnEF1jvRwxihKmixFdrMwG7kxpAL8cglh/x/pBAsrwamoLQvgs2r
         pJLdiQFJCTT3RfIUgwBWv80q2lYTefIQCSrs2/Q/0tT4Ai+VySm/izhI/kPEvevIPvsc
         C9hdyfHiAX+fATGpL79PRnk3c421SGfPHCmDMEMq0jennIxJNnFsEMh6GqKdMD1L3gGn
         DA+VXAIz+4Ot9KL/ZonC1APDeAGmq2Is9gT9UTrXSMcc4a/m4HjjyXVEKlgIFjh+WfHT
         UQPSKONuGTlF8KMSEAqHwYUrHkkB/QHkYKdvqIE/hii05UrGkZtiAy5wyWF5gi5w3mZ5
         oYug==
X-Gm-Message-State: ANhLgQ3YkDKoVH/oES9JLk7x4CnBz8FM6MxvJ0ZO2/E5Y4dTeVX52yWk
        M4Bg7gW/EixMjqhljWYOgFIdeTJHJgs05BVY5oewqErF5O6NMBtsI2dAwXdS9eH1xYZMLQzTFAz
        e6KgezY58/vbM
X-Received: by 2002:adf:e58b:: with SMTP id l11mr37584216wrm.284.1585071685530;
        Tue, 24 Mar 2020 10:41:25 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vskLeqJJmIEg7vdsO1QDMncjP2clWiJKq0b3N1n1wRxCfHVqpqMMkxuGAp2sqmv+URSA6KjRg==
X-Received: by 2002:adf:e58b:: with SMTP id l11mr37584183wrm.284.1585071685293;
        Tue, 24 Mar 2020 10:41:25 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w11sm29978822wrv.86.2020.03.24.10.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 10:41:24 -0700 (PDT)
Date:   Tue, 24 Mar 2020 13:41:21 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v1 13/22] vfio: add bind stage-1 page table support
Message-ID: <20200324174121.GX127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-14-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-14-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:10AM -0700, Liu Yi L wrote:
> This patch adds bind_stage1_pgtbl() definition in HostIOMMUContextClass,
> also adds corresponding implementation in VFIO. This is to expose a way
> for vIOMMU to setup dual stage DMA translation for passthru devices on
> hardware.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/iommu/host_iommu_context.c         | 49 ++++++++++++++++++++++++++++++-
>  hw/vfio/common.c                      | 55 ++++++++++++++++++++++++++++++++++-
>  include/hw/iommu/host_iommu_context.h | 26 ++++++++++++++++-
>  3 files changed, 127 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
> index af61899..8a53376 100644
> --- a/hw/iommu/host_iommu_context.c
> +++ b/hw/iommu/host_iommu_context.c
> @@ -69,21 +69,67 @@ int host_iommu_ctx_pasid_free(HostIOMMUContext *host_icx, uint32_t pasid)
>      return hicxc->pasid_free(host_icx, pasid);
>  }
>  
> +int host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *host_icx,
> +                                     DualIOMMUStage1BindData *data)
> +{
> +    HostIOMMUContextClass *hicxc;
> +
> +    if (!host_icx) {
> +        return -EINVAL;
> +    }
> +
> +    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(host_icx);
> +    if (!hicxc) {
> +        return -EINVAL;
> +    }
> +
> +    if (!(host_icx->flags & HOST_IOMMU_NESTING) ||
> +        !hicxc->bind_stage1_pgtbl) {
> +        return -EINVAL;
> +    }
> +
> +    return hicxc->bind_stage1_pgtbl(host_icx, data);
> +}
> +
> +int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *host_icx,
> +                                       DualIOMMUStage1BindData *data)
> +{
> +    HostIOMMUContextClass *hicxc;
> +
> +    if (!host_icx) {
> +        return -EINVAL;
> +    }
> +
> +    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(host_icx);
> +    if (!hicxc) {
> +        return -EINVAL;
> +    }
> +
> +    if (!(host_icx->flags & HOST_IOMMU_NESTING) ||
> +        !hicxc->unbind_stage1_pgtbl) {
> +        return -EINVAL;
> +    }
> +
> +    return hicxc->unbind_stage1_pgtbl(host_icx, data);
> +}
> +
>  void host_iommu_ctx_init(void *_host_icx, size_t instance_size,
>                           const char *mrtypename,
> -                         uint64_t flags)
> +                         uint64_t flags, uint32_t formats)
>  {
>      HostIOMMUContext *host_icx;
>  
>      object_initialize(_host_icx, instance_size, mrtypename);
>      host_icx = HOST_IOMMU_CONTEXT(_host_icx);
>      host_icx->flags = flags;
> +    host_icx->stage1_formats = formats;
>      host_icx->initialized = true;
>  }
>  
>  void host_iommu_ctx_destroy(HostIOMMUContext *host_icx)
>  {
>      host_icx->flags = 0x0;
> +    host_icx->stage1_formats = 0x0;

This could be dropped too with the function..

>      host_icx->initialized = false;
>  }
>  
> @@ -92,6 +138,7 @@ static void host_icx_init_fn(Object *obj)
>      HostIOMMUContext *host_icx = HOST_IOMMU_CONTEXT(obj);
>  
>      host_icx->flags = 0x0;
> +    host_icx->stage1_formats = 0x0;

Same here...

>      host_icx->initialized = false;
>  }
>  
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index e0f2828..770a785 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -1223,6 +1223,52 @@ static int vfio_host_icx_pasid_free(HostIOMMUContext *host_icx,
>      return 0;
>  }
>  
> +static int vfio_host_icx_bind_stage1_pgtbl(HostIOMMUContext *host_icx,

Same name issue on icx?  Feel free to choose anything that aligns with
your previous decision...

> +                                           DualIOMMUStage1BindData *bind_data)
> +{
> +    VFIOContainer *container = container_of(host_icx, VFIOContainer, host_icx);
> +    struct vfio_iommu_type1_bind *bind;
> +    unsigned long argsz;
> +    int ret = 0;
> +
> +    argsz = sizeof(*bind) + sizeof(bind_data->bind_data);
> +    bind = g_malloc0(argsz);
> +    bind->argsz = argsz;
> +    bind->flags = VFIO_IOMMU_BIND_GUEST_PGTBL;
> +    memcpy(&bind->data, &bind_data->bind_data, sizeof(bind_data->bind_data));
> +
> +    if (ioctl(container->fd, VFIO_IOMMU_BIND, bind)) {
> +        ret = -errno;
> +        error_report("%s: pasid (%u) bind failed: %d",
> +                      __func__, bind_data->pasid, ret);
> +    }
> +    g_free(bind);
> +    return ret;
> +}
> +
> +static int vfio_host_icx_unbind_stage1_pgtbl(HostIOMMUContext *host_icx,
> +                                        DualIOMMUStage1BindData *bind_data)
> +{
> +    VFIOContainer *container = container_of(host_icx, VFIOContainer, host_icx);
> +    struct vfio_iommu_type1_bind *bind;
> +    unsigned long argsz;
> +    int ret = 0;
> +
> +    argsz = sizeof(*bind) + sizeof(bind_data->bind_data);
> +    bind = g_malloc0(argsz);
> +    bind->argsz = argsz;
> +    bind->flags = VFIO_IOMMU_UNBIND_GUEST_PGTBL;
> +    memcpy(&bind->data, &bind_data->bind_data, sizeof(bind_data->bind_data));
> +
> +    if (ioctl(container->fd, VFIO_IOMMU_BIND, bind)) {
> +        ret = -errno;
> +        error_report("%s: pasid (%u) unbind failed: %d",
> +                      __func__, bind_data->pasid, ret);
> +    }
> +    g_free(bind);
> +    return ret;
> +}
> +
>  /**
>   * Get iommu info from host. Caller of this funcion should free
>   * the memory pointed by the returned pointer stored in @info
> @@ -1337,6 +1383,7 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
>          struct vfio_iommu_type1_info_cap_nesting nesting = {
>                                           .nesting_capabilities = 0x0,
>                                           .stage1_formats = 0, };
> +        uint32_t stage1_formats;
>  
>          ret = vfio_get_nesting_iommu_cap(container, &nesting);
>          if (ret) {
> @@ -1347,10 +1394,14 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
>  
>          flags |= (nesting.nesting_capabilities & VFIO_IOMMU_PASID_REQS) ?
>                   HOST_IOMMU_PASID_REQUEST : 0;
> +        flags |= HOST_IOMMU_NESTING;
> +        stage1_formats = nesting.stage1_formats;
> +
>          host_iommu_ctx_init(&container->host_icx,
>                              sizeof(container->host_icx),
>                              TYPE_VFIO_HOST_IOMMU_CONTEXT,
> -                            flags);
> +                            flags,
> +                            stage1_formats);

We can consider passing in nesting.stage1_formats and drop
stage1_formats.

>      }
>  
>      container->iommu_type = iommu_type;
> @@ -1943,6 +1994,8 @@ static void vfio_host_iommu_context_class_init(ObjectClass *klass,
>  
>      hicxc->pasid_alloc = vfio_host_icx_pasid_alloc;
>      hicxc->pasid_free = vfio_host_icx_pasid_free;
> +    hicxc->bind_stage1_pgtbl = vfio_host_icx_bind_stage1_pgtbl;
> +    hicxc->unbind_stage1_pgtbl = vfio_host_icx_unbind_stage1_pgtbl;
>  }
>  
>  static const TypeInfo vfio_host_iommu_context_info = {
> diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
> index 5f11a4c..97c9473 100644
> --- a/include/hw/iommu/host_iommu_context.h
> +++ b/include/hw/iommu/host_iommu_context.h
> @@ -41,6 +41,7 @@
>                           TYPE_HOST_IOMMU_CONTEXT)
>  
>  typedef struct HostIOMMUContext HostIOMMUContext;
> +typedef struct DualIOMMUStage1BindData DualIOMMUStage1BindData;
>  
>  typedef struct HostIOMMUContextClass {
>      /* private */
> @@ -54,6 +55,16 @@ typedef struct HostIOMMUContextClass {
>      /* Reclaim pasid from HostIOMMUContext (a.k.a. host software) */
>      int (*pasid_free)(HostIOMMUContext *host_icx,
>                        uint32_t pasid);
> +    /*
> +     * Bind stage-1 page table to a hostIOMMU w/ dual stage
> +     * DMA translation capability.
> +     * @bind_data specifies the bind configurations.
> +     */
> +    int (*bind_stage1_pgtbl)(HostIOMMUContext *dsi_obj,
> +                             DualIOMMUStage1BindData *bind_data);
> +    /* Undo a previous bind. @bind_data specifies the unbind info. */
> +    int (*unbind_stage1_pgtbl)(HostIOMMUContext *dsi_obj,
> +                               DualIOMMUStage1BindData *bind_data);
>  } HostIOMMUContextClass;
>  
>  /*
> @@ -62,17 +73,30 @@ typedef struct HostIOMMUContextClass {
>  struct HostIOMMUContext {
>      Object parent_obj;
>  #define HOST_IOMMU_PASID_REQUEST (1ULL << 0)
> +#define HOST_IOMMU_NESTING       (1ULL << 1)
>      uint64_t flags;
> +    uint32_t stage1_formats;
>      bool initialized;
>  };
>  
> +struct DualIOMMUStage1BindData {
> +    uint32_t pasid;
> +    union {
> +        struct iommu_gpasid_bind_data gpasid_bind;
> +    } bind_data;
> +};
> +
>  int host_iommu_ctx_pasid_alloc(HostIOMMUContext *host_icx, uint32_t min,
>                                 uint32_t max, uint32_t *pasid);
>  int host_iommu_ctx_pasid_free(HostIOMMUContext *host_icx, uint32_t pasid);
> +int host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *host_icx,
> +                                     DualIOMMUStage1BindData *data);
> +int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *host_icx,
> +                                       DualIOMMUStage1BindData *data);
>  
>  void host_iommu_ctx_init(void *_host_icx, size_t instance_size,
>                           const char *mrtypename,
> -                         uint64_t flags);
> +                         uint64_t flags, uint32_t formats);
>  void host_iommu_ctx_destroy(HostIOMMUContext *host_icx);
>  
>  #endif
> -- 
> 2.7.4
> 

-- 
Peter Xu

