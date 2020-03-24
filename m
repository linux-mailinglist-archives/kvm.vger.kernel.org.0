Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F8C19185B
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCXSAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:00:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:36247 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727310AbgCXSAZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 14:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585072823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nb4bEMPfjRxTaIrjTk0Rhq1s2Rfj5iijs2kFV+3ZVgU=;
        b=Gp9ucMR/1MPURmxtlOiBmRB+iPkNAzvzdPJJhttdeONPoZhKBuvHSjr7Nkfy1dupwIQZ/Z
        hWspqDqbo/5X/L4dpFKxs7UN0JJhm6bS4HdmYXOXImZxB62GV3v0Ox+jD60lFyI2wIwRh2
        5uDK2M5m632WmEQobnoSInWLBWXi2lY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-mqqOLL0PMQilIkt5XkDkCQ-1; Tue, 24 Mar 2020 14:00:21 -0400
X-MC-Unique: mqqOLL0PMQilIkt5XkDkCQ-1
Received: by mail-wr1-f72.google.com with SMTP id h14so3429262wrr.12
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 11:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nb4bEMPfjRxTaIrjTk0Rhq1s2Rfj5iijs2kFV+3ZVgU=;
        b=YRuHU2TtIWeSmv6XftY24wB7RmDCOVUYAD7wakXKXVAjR6nOjpXubRXvhy6RiZZbLu
         e874A1KyQ5iKC39SrhckneEqGb+y6n7zSBkNfJEs2hHzGBj4h9oJUS1fRmAinMts27Kr
         2r87LGE/GIHMEKCY/imqmVPTddM5JCA4X6X+RtRKYrJJ/ZfwSF3Qj0M341Bp47KhMEKt
         nhXEtnFInWyQaBBild8YlCsFmHZR8yJy7OZ74ptaHjqtChF6qXLj20QHVMCD2e7EVE63
         4BoZBxKnk/p60hgHjqziw9/gHfAjlnOSPhlF1ph5wWDQUaAPJkMUQHO27LVfdyjlzvv0
         Gq8g==
X-Gm-Message-State: ANhLgQ2JeBM+IiHMAWUJMdQSDC7jsti7N2rlr/bR3XRmfBWBOZAjU2+T
        PSJ/4dDrxLaY56EBOXVxZzdNnkYSB/8iBOtAJXkTMgcaYGcxdePZPlJ+pfInBr7zuVGj4UsoLS3
        TLw5OszTmi3C3
X-Received: by 2002:a7b:c449:: with SMTP id l9mr6617247wmi.167.1585072820643;
        Tue, 24 Mar 2020 11:00:20 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtzefn+uaUs6t0CBbyqQmHaSA1SUyoHri8KmFoikwAFzi+Gqvoh5Wnr/WwKUufupDoPsPj+Rw==
X-Received: by 2002:a7b:c449:: with SMTP id l9mr6617220wmi.167.1585072820379;
        Tue, 24 Mar 2020 11:00:20 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id u8sm29031276wrn.69.2020.03.24.11.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:00:19 -0700 (PDT)
Date:   Tue, 24 Mar 2020 14:00:13 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v1 15/22] intel_iommu: replay guest pasid bindings to host
Message-ID: <20200324180013.GZ127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-16-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-16-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:12AM -0700, Liu Yi L wrote:
> This patch adds guest pasid bindings replay for domain
> selective pasid cache invalidation(dsi) and global pasid
> cache invalidation by walking guest pasid table.
> 
> Reason:
> Guest OS may flush the pasid cache with a larger granularity.
> e.g. guest does a svm_bind() but flush the pasid cache with
> global or domain selective pasid cache invalidation instead
> of pasid selective(psi) pasid cache invalidation. Regards to
> such case, it works in host. Per spec, a global or domain
> selective pasid cache invalidation should be able to cover
> what a pasid selective invalidation does. The only concern
> is performance deduction since dsi and global cache invalidation
> will flush more than psi. To align with native, vIOMMU needs
> emulator needs to do replay for the two invalidation granularity
> to reflect the latest pasid bindings in guest pasid table.

This is actually related to my question in the other patch on whether
the replay can and should also work for the PSI case too.  I'm still
confused on why the guest cannot use a PSI for a newly created PASID
entry for one device?

> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/i386/intel_iommu.c          | 128 ++++++++++++++++++++++++++++++++++++++++-
>  hw/i386/intel_iommu_internal.h |   1 +
>  2 files changed, 127 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 0423c83..8ec638f 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -2717,6 +2717,130 @@ static VTDPASIDAddressSpace *vtd_add_find_pasid_as(IntelIOMMUState *s,
>      return vtd_pasid_as;
>  }
>  
> +/**
> + * Constant information used during pasid table walk
> +   @vtd_bus, @devfn: device info
> + * @flags: indicates if it is domain selective walk
> + * @did: domain ID of the pasid table walk
> + */
> +typedef struct {
> +    VTDBus *vtd_bus;
> +    uint16_t devfn;
> +#define VTD_PASID_TABLE_DID_SEL_WALK   (1ULL << 0);
> +    uint32_t flags;
> +    uint16_t did;
> +} vtd_pasid_table_walk_info;

So this is going to be similar to VTDPASIDCacheInfo as I mentioned.
Maybe you can use a shared object for both?

> +
> +/**
> + * Caller of this function should hold iommu_lock.
> + */
> +static bool vtd_sm_pasid_table_walk_one(IntelIOMMUState *s,
> +                                        dma_addr_t pt_base,
> +                                        int start,
> +                                        int end,
> +                                        vtd_pasid_table_walk_info *info)
> +{
> +    VTDPASIDEntry pe;
> +    int pasid = start;
> +    int pasid_next;
> +    VTDPASIDAddressSpace *vtd_pasid_as;
> +    VTDPASIDCacheEntry *pc_entry;
> +
> +    while (pasid < end) {
> +        pasid_next = pasid + 1;
> +
> +        if (!vtd_get_pe_in_pasid_leaf_table(s, pasid, pt_base, &pe)
> +            && vtd_pe_present(&pe)) {
> +            vtd_pasid_as = vtd_add_find_pasid_as(s,
> +                                       info->vtd_bus, info->devfn, pasid);

For this chunk:

> +            pc_entry = &vtd_pasid_as->pasid_cache_entry;
> +            if (s->pasid_cache_gen == pc_entry->pasid_cache_gen) {
> +                vtd_update_pe_in_cache(s, vtd_pasid_as, &pe);
> +            } else {
> +                vtd_fill_in_pe_in_cache(s, vtd_pasid_as, &pe);
> +            }

We already got &pe, then would it be easier to simply call:

               vtd_update_pe_in_cache(s, vtd_pasid_as, &pe);

?

Since IIUC the cache_gen is only helpful to avoid looking up the &pe.
And the vtd_pasid_entry_compare() check should be even more solid than
the cache_gen.

> +        }
> +        pasid = pasid_next;
> +    }
> +    return true;
> +}
> +
> +/*
> + * Currently, VT-d scalable mode pasid table is a two level table,
> + * this function aims to loop a range of PASIDs in a given pasid
> + * table to identify the pasid config in guest.
> + * Caller of this function should hold iommu_lock.
> + */
> +static void vtd_sm_pasid_table_walk(IntelIOMMUState *s,
> +                                    dma_addr_t pdt_base,
> +                                    int start,
> +                                    int end,
> +                                    vtd_pasid_table_walk_info *info)
> +{
> +    VTDPASIDDirEntry pdire;
> +    int pasid = start;
> +    int pasid_next;
> +    dma_addr_t pt_base;
> +
> +    while (pasid < end) {
> +        pasid_next = pasid + VTD_PASID_TBL_ENTRY_NUM;
> +        if (!vtd_get_pdire_from_pdir_table(pdt_base, pasid, &pdire)
> +            && vtd_pdire_present(&pdire)) {
> +            pt_base = pdire.val & VTD_PASID_TABLE_BASE_ADDR_MASK;
> +            if (!vtd_sm_pasid_table_walk_one(s,
> +                              pt_base, pasid, pasid_next, info)) {

vtd_sm_pasid_table_walk_one() never returns false.  Remove this check?
Maybe also let vtd_sm_pasid_table_walk_one() to return nothing.

> +                break;
> +            }
> +        }
> +        pasid = pasid_next;
> +    }
> +}
> +
> +/**
> + * This function replay the guest pasid bindings to hots by
> + * walking the guest PASID table. This ensures host will have
> + * latest guest pasid bindings.
> + */
> +static void vtd_replay_guest_pasid_bindings(IntelIOMMUState *s,
> +                                            uint16_t *did,
> +                                            bool is_dsi)
> +{
> +    VTDContextEntry ce;
> +    VTDHostIOMMUContext *vtd_dev_icx;
> +    int bus_n, devfn;
> +    vtd_pasid_table_walk_info info;
> +
> +    if (is_dsi) {
> +        info.flags = VTD_PASID_TABLE_DID_SEL_WALK;
> +        info.did = *did;
> +    }
> +
> +    /*
> +     * In this replay, only needs to care about the devices which
> +     * are backed by host IOMMU. For such devices, their vtd_dev_icx
> +     * instances are in the s->vtd_dev_icx_list. For devices which
> +     * are not backed byhost IOMMU, it is not necessary to replay
> +     * the bindings since their cache could be re-created in the future
> +     * DMA address transaltion.
> +     */
> +    vtd_iommu_lock(s);
> +    QLIST_FOREACH(vtd_dev_icx, &s->vtd_dev_icx_list, next) {
> +        bus_n = pci_bus_num(vtd_dev_icx->vtd_bus->bus);
> +        devfn = vtd_dev_icx->devfn;
> +
> +        if (!vtd_dev_to_context_entry(s, bus_n, devfn, &ce)) {
> +            info.vtd_bus = vtd_dev_icx->vtd_bus;
> +            info.devfn = devfn;
> +            vtd_sm_pasid_table_walk(s,
> +                                    VTD_CE_GET_PASID_DIR_TABLE(&ce),
> +                                    0,
> +                                    VTD_MAX_HPASID,
> +                                    &info);
> +        }
> +    }
> +    vtd_iommu_unlock(s);
> +}
> +
>  static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
>  {
>      VTDPASIDCacheInfo pc_info;
> @@ -2735,7 +2859,6 @@ static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
>      vtd_iommu_unlock(s);
>  
>      /*
> -     * TODO:
>       * Domain selective PASID cache invalidation flushes
>       * all the pasid caches within a domain. To be safe,
>       * after invalidating the pasid caches, emulator needs
> @@ -2743,6 +2866,7 @@ static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
>       * dir and pasid table. e.g. When the guest setup a new
>       * PASID entry then send a PASID DSI.
>       */
> +    vtd_replay_guest_pasid_bindings(s, &domain_id, true);
>      return 0;
>  }
>  
> @@ -2881,13 +3005,13 @@ static int vtd_pasid_cache_gsi(IntelIOMMUState *s)
>      vtd_iommu_unlock(s);
>  
>      /*
> -     * TODO:
>       * Global PASID cache invalidation flushes all
>       * the pasid caches. To be safe, after invalidating
>       * the pasid caches, emulator needs to replay the
>       * pasid bindings by walking guest pasid dir and
>       * pasid table.
>       */
> +    vtd_replay_guest_pasid_bindings(s, NULL, false);
>      return 0;
>  }
>  
> diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
> index 4451acf..b0a324c 100644
> --- a/hw/i386/intel_iommu_internal.h
> +++ b/hw/i386/intel_iommu_internal.h
> @@ -554,6 +554,7 @@ typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
>  #define VTD_PASID_TABLE_BITS_MASK     (0x3fULL)
>  #define VTD_PASID_TABLE_INDEX(pasid)  ((pasid) & VTD_PASID_TABLE_BITS_MASK)
>  #define VTD_PASID_ENTRY_FPD           (1ULL << 1) /* Fault Processing Disable */
> +#define VTD_PASID_TBL_ENTRY_NUM       (1ULL << 6)
>  
>  /* PASID Granular Translation Type Mask */
>  #define VTD_PASID_ENTRY_P              1ULL
> -- 
> 2.7.4
> 

-- 
Peter Xu

