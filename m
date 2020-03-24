Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0731319193B
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgCXSee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:34:34 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:35292 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727318AbgCXSed (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 14:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585074871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ZJqfs+Ow1XzRDF0cAMw7udrxVvYxzXME1Cp7ORdgzI=;
        b=hPe2cVMWii3ZY3UiYrIWoGuUkDGejj+96Jkk1B8AfPftai/Sa0NWCcAxpHwOcAF93N1aZn
        G2Q8wyiJN/HOtzLfM7YxL1hJ8cpuXzMhaZOtXSZTR3DJxwLA8+FnmRyP4AsmgKcawWOYaD
        PuakX7yTUbA9LoGmyX+51rOMMj3IpFM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-fw6JN4uHOhCszYy4jUpj3A-1; Tue, 24 Mar 2020 14:34:29 -0400
X-MC-Unique: fw6JN4uHOhCszYy4jUpj3A-1
Received: by mail-wm1-f69.google.com with SMTP id s15so1582668wmc.0
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 11:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6ZJqfs+Ow1XzRDF0cAMw7udrxVvYxzXME1Cp7ORdgzI=;
        b=tI6ypBztrTgqdC1ncggVZYhQyF2Lc+xF77p0JrqFsuMnMFLMOjcOeiVuV78KHSIUiR
         Y5m5p7Lhd8l3u5/PI+tx+I37tOgnwxBNXYPT9gr0UyJA7vGUEuM9EKw4+wVcinzYwHGg
         X1oX8SBnMKYOMFlpd5rqP945Zp4V1Jg6WnmgtQ6BQuusPuOPVJavRfvT/86EVw4nbWhK
         oMPMqjAdtDCFhVa0k9ygGmBM6UeqisSRiG4y8Z3GOhhO5SubqIt+96asOv/d7S3cjAKi
         PIdRu2DDK1x3Z/3YBzX5lOx5BkimUIQy/ac+6oCbd4NUqabk/L2+JJX1kxMY8e+QWUj9
         yqDg==
X-Gm-Message-State: ANhLgQ0+qTyAkkQapMcV+tD+ExvhfzJo+QA/LEaUerenAoB+QruqOJt9
        u0vLGIsbJtXc+PUqaozyYOg1JeC7DbCu0wmz4gqqGqjlQqjJdXWqaLbvQFGEHuaG1SrMCd0Ltlp
        Cof4GBjGH/9O1
X-Received: by 2002:adf:dd86:: with SMTP id x6mr31819803wrl.169.1585074868529;
        Tue, 24 Mar 2020 11:34:28 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuCAe/rn2Aicw35jdGbZd7Clfm6waLJyNnVeOjwPm9ho+IbIPYkPjybUosROUum4zOmxMNJsQ==
X-Received: by 2002:adf:dd86:: with SMTP id x6mr31819768wrl.169.1585074868268;
        Tue, 24 Mar 2020 11:34:28 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id d6sm3754866wrw.10.2020.03.24.11.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:34:27 -0700 (PDT)
Date:   Tue, 24 Mar 2020 14:34:23 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v1 20/22] intel_iommu: propagate PASID-based iotlb
 invalidation to host
Message-ID: <20200324183423.GE127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-21-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-21-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:17AM -0700, Liu Yi L wrote:
> This patch propagates PASID-based iotlb invalidation to host.
> 
> Intel VT-d 3.0 supports nested translation in PASID granular.
> Guest SVA support could be implemented by configuring nested
> translation on specific PASID. This is also known as dual stage
> DMA translation.
> 
> Under such configuration, guest owns the GVA->GPA translation
> which is configured as first level page table in host side for
> a specific pasid, and host owns GPA->HPA translation. As guest
> owns first level translation table, piotlb invalidation should
> be propagated to host since host IOMMU will cache first level
> page table related mappings during DMA address translation.
> 
> This patch traps the guest PASID-based iotlb flush and propagate
> it to host.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/i386/intel_iommu.c          | 139 +++++++++++++++++++++++++++++++++++++++++
>  hw/i386/intel_iommu_internal.h |   7 +++
>  2 files changed, 146 insertions(+)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index b9ac07d..10d314d 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -3134,15 +3134,154 @@ static bool vtd_process_pasid_desc(IntelIOMMUState *s,
>      return (ret == 0) ? true : false;
>  }
>  
> +/**
> + * Caller of this function should hold iommu_lock.
> + */
> +static void vtd_invalidate_piotlb(IntelIOMMUState *s,
> +                                  VTDBus *vtd_bus,
> +                                  int devfn,
> +                                  DualIOMMUStage1Cache *stage1_cache)
> +{
> +    VTDHostIOMMUContext *vtd_dev_icx;
> +    HostIOMMUContext *host_icx;
> +
> +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
> +    if (!vtd_dev_icx) {
> +        goto out;
> +    }
> +    host_icx = vtd_dev_icx->host_icx;
> +    if (!host_icx) {
> +        goto out;
> +    }
> +    if (host_iommu_ctx_flush_stage1_cache(host_icx, stage1_cache)) {
> +        error_report("Cache flush failed");

I think this should not easily be triggered by the guest, but just in
case... Let's use error_report_once() to be safe.

> +    }
> +out:
> +    return;
> +}
> +
> +static inline bool vtd_pasid_cache_valid(
> +                          VTDPASIDAddressSpace *vtd_pasid_as)
> +{
> +    return vtd_pasid_as->iommu_state &&

This check can be dropped because always true?

If you agree with both the changes, please add:

Reviewed-by: Peter Xu <peterx@redhat.com>

> +           (vtd_pasid_as->iommu_state->pasid_cache_gen
> +             == vtd_pasid_as->pasid_cache_entry.pasid_cache_gen);
> +}
> +
> +/**
> + * This function is a loop function for the s->vtd_pasid_as
> + * list with VTDPIOTLBInvInfo as execution filter. It propagates
> + * the piotlb invalidation to host. Caller of this function
> + * should hold iommu_lock.
> + */
> +static void vtd_flush_pasid_iotlb(gpointer key, gpointer value,
> +                                  gpointer user_data)
> +{
> +    VTDPIOTLBInvInfo *piotlb_info = user_data;
> +    VTDPASIDAddressSpace *vtd_pasid_as = value;
> +    uint16_t did;
> +
> +    /*
> +     * Needs to check whether the pasid entry cache stored in
> +     * vtd_pasid_as is valid or not. "invalid" means the pasid
> +     * cache has been flushed, thus host should have done piotlb
> +     * invalidation together with a pasid cache invalidation, so
> +     * no need to pass down piotlb invalidation to host for better
> +     * performance. Only when pasid entry cache is "valid", should
> +     * a piotlb invalidation be propagated to host since it means
> +     * guest just modified a mapping in its page table.
> +     */
> +    if (!vtd_pasid_cache_valid(vtd_pasid_as)) {
> +        return;
> +    }
> +
> +    did = vtd_pe_get_domain_id(
> +                &(vtd_pasid_as->pasid_cache_entry.pasid_entry));
> +
> +    if ((piotlb_info->domain_id == did) &&
> +        (piotlb_info->pasid == vtd_pasid_as->pasid)) {
> +        vtd_invalidate_piotlb(vtd_pasid_as->iommu_state,
> +                              vtd_pasid_as->vtd_bus,
> +                              vtd_pasid_as->devfn,
> +                              piotlb_info->stage1_cache);
> +    }
> +
> +    /*
> +     * TODO: needs to add QEMU piotlb flush when QEMU piotlb
> +     * infrastructure is ready. For now, it is enough for passthru
> +     * devices.
> +     */
> +}
> +
>  static void vtd_piotlb_pasid_invalidate(IntelIOMMUState *s,
>                                          uint16_t domain_id,
>                                          uint32_t pasid)
>  {
> +    VTDPIOTLBInvInfo piotlb_info;
> +    DualIOMMUStage1Cache *stage1_cache;
> +    struct iommu_cache_invalidate_info *cache_info;
> +
> +    stage1_cache = g_malloc0(sizeof(*stage1_cache));
> +    stage1_cache->pasid = pasid;
> +
> +    cache_info = &stage1_cache->cache_info;
> +    cache_info->version = IOMMU_UAPI_VERSION;
> +    cache_info->cache = IOMMU_CACHE_INV_TYPE_IOTLB;
> +    cache_info->granularity = IOMMU_INV_GRANU_PASID;
> +    cache_info->pasid_info.pasid = pasid;
> +    cache_info->pasid_info.flags = IOMMU_INV_PASID_FLAGS_PASID;
> +
> +    piotlb_info.domain_id = domain_id;
> +    piotlb_info.pasid = pasid;
> +    piotlb_info.stage1_cache = stage1_cache;
> +
> +    vtd_iommu_lock(s);
> +    /*
> +     * Here loops all the vtd_pasid_as instances in s->vtd_pasid_as
> +     * to find out the affected devices since piotlb invalidation
> +     * should check pasid cache per architecture point of view.
> +     */
> +    g_hash_table_foreach(s->vtd_pasid_as,
> +                         vtd_flush_pasid_iotlb, &piotlb_info);
> +    vtd_iommu_unlock(s);
> +    g_free(stage1_cache);
>  }
>  
>  static void vtd_piotlb_page_invalidate(IntelIOMMUState *s, uint16_t domain_id,
>                               uint32_t pasid, hwaddr addr, uint8_t am, bool ih)
>  {
> +    VTDPIOTLBInvInfo piotlb_info;
> +    DualIOMMUStage1Cache *stage1_cache;
> +    struct iommu_cache_invalidate_info *cache_info;
> +
> +    stage1_cache = g_malloc0(sizeof(*stage1_cache));
> +    stage1_cache->pasid = pasid;
> +
> +    cache_info = &stage1_cache->cache_info;
> +    cache_info->version = IOMMU_UAPI_VERSION;
> +    cache_info->cache = IOMMU_CACHE_INV_TYPE_IOTLB;
> +    cache_info->granularity = IOMMU_INV_GRANU_ADDR;
> +    cache_info->addr_info.flags = IOMMU_INV_ADDR_FLAGS_PASID;
> +    cache_info->addr_info.flags |= ih ? IOMMU_INV_ADDR_FLAGS_LEAF : 0;
> +    cache_info->addr_info.pasid = pasid;
> +    cache_info->addr_info.addr = addr;
> +    cache_info->addr_info.granule_size = 1 << (12 + am);
> +    cache_info->addr_info.nb_granules = 1;
> +
> +    piotlb_info.domain_id = domain_id;
> +    piotlb_info.pasid = pasid;
> +    piotlb_info.stage1_cache = stage1_cache;
> +
> +    vtd_iommu_lock(s);
> +    /*
> +     * Here loops all the vtd_pasid_as instances in s->vtd_pasid_as
> +     * to find out the affected devices since piotlb invalidation
> +     * should check pasid cache per architecture point of view.
> +     */
> +    g_hash_table_foreach(s->vtd_pasid_as,
> +                         vtd_flush_pasid_iotlb, &piotlb_info);
> +    vtd_iommu_unlock(s);
> +    g_free(stage1_cache);
>  }
>  
>  static bool vtd_process_piotlb_desc(IntelIOMMUState *s,
> diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
> index 314e2c4..967cc4f 100644
> --- a/hw/i386/intel_iommu_internal.h
> +++ b/hw/i386/intel_iommu_internal.h
> @@ -560,6 +560,13 @@ struct VTDPASIDCacheInfo {
>                                        VTD_PASID_CACHE_DEVSI)
>  typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
>  
> +struct VTDPIOTLBInvInfo {
> +    uint16_t domain_id;
> +    uint32_t pasid;
> +    DualIOMMUStage1Cache *stage1_cache;
> +};
> +typedef struct VTDPIOTLBInvInfo VTDPIOTLBInvInfo;
> +
>  /* PASID Table Related Definitions */
>  #define VTD_PASID_DIR_BASE_ADDR_MASK  (~0xfffULL)
>  #define VTD_PASID_TABLE_BASE_ADDR_MASK (~0xfffULL)
> -- 
> 2.7.4
> 

-- 
Peter Xu

