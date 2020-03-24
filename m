Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C4A1917AE
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 18:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgCXRcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 13:32:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:37105 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbgCXRcX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 13:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585071140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GrsrYmGM1AADC57bcUJPVufWR3pkmc2k0K/i2gP4OSg=;
        b=N4K9CFYzMsIcA1LRO1M/hAbZnxnQNSZ4kWyPeB80PnzqytRYwZwsvcrxTX5sNXWlvqET25
        6bjR6et/IMDj9ZI0BhqQopfXJyhZ02U5F3dh3QVbasjmWZC3r85zos1+iQwKDpnq/jpyCW
        DI51gP5doymIHhlh7eMzbjDNnoSlOes=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-isNmTVYQPMy6cP4y6B3neg-1; Tue, 24 Mar 2020 13:32:16 -0400
X-MC-Unique: isNmTVYQPMy6cP4y6B3neg-1
Received: by mail-wr1-f69.google.com with SMTP id y1so4561959wrn.10
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 10:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GrsrYmGM1AADC57bcUJPVufWR3pkmc2k0K/i2gP4OSg=;
        b=RSsF9j6J97Ob0ANxtZRLAJxZA7loVwE0+7exLuA4jmqqFy1FaDEMpohp8KjWn2SnzP
         Qu/ETlYxBebmDweeCKNGIqqSFgljynvesJ3Au3MPhojM5+qNLoDx6mXKp7rALj449YDh
         7pwSAPzfwD143NZByMTSQd8J6dRVruPf53q/LTLJHuOG9jDKxNZ2RQizegHmY7bysQMs
         8Foz7N1Fw6Q+XPdzrEkn0r3UzA1c3FjKU409HlCgBL1tzNQDnMjE+uGK1/MQTl1vf2XU
         BbC2LB/ashme/C+TwGqk11bQ1mFLL0i/edNrstwcKe741zoGNV+nNRewmcg7prrPsc/R
         ZSdw==
X-Gm-Message-State: ANhLgQ0c6RvJ3vkaJW3WJ7VecWDd+7kOxP59ajRzbutKaNt7mdvM9CbA
        kGXGyq7U1Mb9RqHMcUe9AWAJbrijRefEw9jC/aFL/ekLGoCBMxV7yNp0mYScFxCPbx1RCwgZr5q
        6AAjrobKJ9BBS
X-Received: by 2002:adf:e8c1:: with SMTP id k1mr8249330wrn.381.1585071135498;
        Tue, 24 Mar 2020 10:32:15 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuqPXiMa9oysikk2eQCH9xItRcZLzlsmAnQ5WEPcXSPynGkLX0PagJoTQUYrzhSaplSl7uXBg==
X-Received: by 2002:adf:e8c1:: with SMTP id k1mr8249287wrn.381.1585071135042;
        Tue, 24 Mar 2020 10:32:15 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id g3sm13007480wrm.66.2020.03.24.10.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 10:32:14 -0700 (PDT)
Date:   Tue, 24 Mar 2020 13:32:09 -0400
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
Subject: Re: [PATCH v1 12/22] intel_iommu: add PASID cache management
 infrastructure
Message-ID: <20200324173209.GW127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-13-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-13-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:09AM -0700, Liu Yi L wrote:
> This patch adds a PASID cache management infrastructure based on
> new added structure VTDPASIDAddressSpace, which is used to track
> the PASID usage and future PASID tagged DMA address translation
> support in vIOMMU.
> 
>     struct VTDPASIDAddressSpace {
>         VTDBus *vtd_bus;
>         uint8_t devfn;
>         AddressSpace as;
>         uint32_t pasid;
>         IntelIOMMUState *iommu_state;
>         VTDContextCacheEntry context_cache_entry;
>         QLIST_ENTRY(VTDPASIDAddressSpace) next;
>         VTDPASIDCacheEntry pasid_cache_entry;
>     };
> 
> Ideally, a VTDPASIDAddressSpace instance is created when a PASID
> is bound with a DMA AddressSpace. Intel VT-d spec requires guest
> software to issue pasid cache invalidation when bind or unbind a
> pasid with an address space under caching-mode. However, as
> VTDPASIDAddressSpace instances also act as pasid cache in this
> implementation, its creation also happens during vIOMMU PASID
> tagged DMA translation. The creation in this path will not be
> added in this patch since no PASID-capable emulated devices for
> now.
> 
> The implementation in this patch manages VTDPASIDAddressSpace
> instances per PASID+BDF (lookup and insert will use PASID and
> BDF) since Intel VT-d spec allows per-BDF PASID Table. When a
> guest bind a PASID with an AddressSpace, QEMU will capture the
> guest pasid selective pasid cache invalidation, and allocate
> remove a VTDPASIDAddressSpace instance per the invalidation
> reasons:
> 
>     *) a present pasid entry moved to non-present
>     *) a present pasid entry to be a present entry
>     *) a non-present pasid entry moved to present
> 
> vIOMMU emulator could figure out the reason by fetching latest
> guest pasid entry.
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
>  hw/i386/intel_iommu.c          | 394 +++++++++++++++++++++++++++++++++++++++++
>  hw/i386/intel_iommu_internal.h |  14 ++
>  hw/i386/trace-events           |   1 +
>  include/hw/i386/intel_iommu.h  |  33 +++-
>  4 files changed, 441 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 1daeab2..c985cae 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -40,6 +40,7 @@
>  #include "kvm_i386.h"
>  #include "migration/vmstate.h"
>  #include "trace.h"
> +#include "qemu/jhash.h"
>  
>  /* context entry operations */
>  #define VTD_CE_GET_RID2PASID(ce) \
> @@ -65,6 +66,8 @@
>  static void vtd_address_space_refresh_all(IntelIOMMUState *s);
>  static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n);
>  
> +static void vtd_pasid_cache_reset(IntelIOMMUState *s);
> +
>  static void vtd_panic_require_caching_mode(void)
>  {
>      error_report("We need to set caching-mode=on for intel-iommu to enable "
> @@ -276,6 +279,7 @@ static void vtd_reset_caches(IntelIOMMUState *s)
>      vtd_iommu_lock(s);
>      vtd_reset_iotlb_locked(s);
>      vtd_reset_context_cache_locked(s);
> +    vtd_pasid_cache_reset(s);
>      vtd_iommu_unlock(s);
>  }
>  
> @@ -686,6 +690,11 @@ static inline bool vtd_pe_type_check(X86IOMMUState *x86_iommu,
>      return true;
>  }
>  
> +static inline uint16_t vtd_pe_get_domain_id(VTDPASIDEntry *pe)
> +{
> +    return VTD_SM_PASID_ENTRY_DID((pe)->val[1]);
> +}
> +
>  static inline bool vtd_pdire_present(VTDPASIDDirEntry *pdire)
>  {
>      return pdire->val & 1;
> @@ -2395,19 +2404,402 @@ static bool vtd_process_iotlb_desc(IntelIOMMUState *s, VTDInvDesc *inv_desc)
>      return true;
>  }
>  
> +static inline void vtd_init_pasid_key(uint32_t pasid,
> +                                     uint16_t sid,
> +                                     struct pasid_key *key)
> +{
> +    key->pasid = pasid;
> +    key->sid = sid;
> +}
> +
> +static guint vtd_pasid_as_key_hash(gconstpointer v)
> +{
> +    struct pasid_key *key = (struct pasid_key *)v;
> +    uint32_t a, b, c;
> +
> +    /* Jenkins hash */
> +    a = b = c = JHASH_INITVAL + sizeof(*key);
> +    a += key->sid;
> +    b += extract32(key->pasid, 0, 16);
> +    c += extract32(key->pasid, 16, 16);
> +
> +    __jhash_mix(a, b, c);
> +    __jhash_final(a, b, c);
> +
> +    return c;
> +}
> +
> +static gboolean vtd_pasid_as_key_equal(gconstpointer v1, gconstpointer v2)
> +{
> +    const struct pasid_key *k1 = v1;
> +    const struct pasid_key *k2 = v2;
> +
> +    return (k1->pasid == k2->pasid) && (k1->sid == k2->sid);
> +}
> +
> +static inline int vtd_dev_get_pe_from_pasid(IntelIOMMUState *s,
> +                                            uint8_t bus_num,
> +                                            uint8_t devfn,
> +                                            uint32_t pasid,
> +                                            VTDPASIDEntry *pe)
> +{
> +    VTDContextEntry ce;
> +    int ret;
> +    dma_addr_t pasid_dir_base;
> +
> +    if (!s->root_scalable) {
> +        return -VTD_FR_PASID_TABLE_INV;
> +    }
> +
> +    ret = vtd_dev_to_context_entry(s, bus_num, devfn, &ce);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    pasid_dir_base = VTD_CE_GET_PASID_DIR_TABLE(&ce);
> +    ret = vtd_get_pe_from_pasid_table(s,
> +                                  pasid_dir_base, pasid, pe);

The indents across the series are still strange...  Take this one as
example, nornally I'll indent at the left bracket if I want to use
another newline:

       ret = vtd_get_pe_from_pasid_table(s, pasid_dir_base,
                                         pasid, pe);

And here actually you don't need a new line at all because it's only
70 chars...

I don't think it's a must (I am always not sure whether we should be
that strict on all these), but it should be preferred if you change
all the similar places with the same indentation as the existing code.

> +
> +    return ret;
> +}
> +
> +static bool vtd_pasid_entry_compare(VTDPASIDEntry *p1, VTDPASIDEntry *p2)
> +{
> +    return !memcmp(p1, p2, sizeof(*p1));
> +}
> +
> +/**
> + * This function cached the pasid entry in &vtd_pasid_as. Also
> + * notifies host about the new pasid binding. Caller of this
> + * function should hold iommu_lock.
> + */
> +static inline void vtd_fill_in_pe_in_cache(IntelIOMMUState *s,
> +                                           VTDPASIDAddressSpace *vtd_pasid_as,
> +                                           VTDPASIDEntry *pe)
> +{
> +    VTDPASIDCacheEntry *pc_entry = &vtd_pasid_as->pasid_cache_entry;
> +
> +    pc_entry->pasid_entry = *pe;
> +    pc_entry->pasid_cache_gen = s->pasid_cache_gen;
> +    /*
> +     * TODO:
> +     * - send pasid bind to host for passthru devices
> +     */
> +}
> +
> +/**
> + * This function updates the pasid entry cached in &vtd_pasid_as.
> + * Caller of this function should hold iommu_lock.
> + */
> +static void vtd_update_pe_in_cache(IntelIOMMUState *s,
> +                                   VTDPASIDAddressSpace *vtd_pasid_as,
> +                                   VTDPASIDEntry *pe)
> +{
> +    VTDPASIDCacheEntry *pc_entry = &vtd_pasid_as->pasid_cache_entry;
> +
> +    if (vtd_pasid_entry_compare(pe, &pc_entry->pasid_entry)) {
> +        /* No need to go further as cached pasid entry is latest */
> +        return;
> +    }
> +
> +    vtd_fill_in_pe_in_cache(s, vtd_pasid_as, pe);
> +}
> +
> +/**
> + * This function is used to clear pasid_cache_gen of cached pasid
> + * entry in vtd_pasid_as instances. Caller of this function should
> + * hold iommu_lock.
> + */
> +static gboolean vtd_flush_pasid(gpointer key, gpointer value,
> +                                gpointer user_data)
> +{
> +    VTDPASIDCacheInfo *pc_info = user_data;
> +    VTDPASIDAddressSpace *vtd_pasid_as = value;
> +    IntelIOMMUState *s = vtd_pasid_as->iommu_state;
> +    VTDPASIDCacheEntry *pc_entry = &vtd_pasid_as->pasid_cache_entry;
> +    VTDBus *vtd_bus = vtd_pasid_as->vtd_bus;
> +    VTDPASIDEntry pe;
> +    uint16_t did;
> +    uint32_t pasid;
> +    uint16_t devfn;
> +    int ret;
> +
> +    did = vtd_pe_get_domain_id(&pc_entry->pasid_entry);
> +    pasid = vtd_pasid_as->pasid;
> +    devfn = vtd_pasid_as->devfn;
> +
> +    if (!(pc_entry->pasid_cache_gen == s->pasid_cache_gen)) {
> +        return false;
> +    }
> +
> +    switch (pc_info->flags & VTD_PASID_CACHE_INFO_MASK) {
> +    case VTD_PASID_CACHE_PASIDSI:
> +        if (pc_info->pasid != pasid) {
> +            return false;
> +        }
> +        /* Fall through */
> +    case VTD_PASID_CACHE_DOMSI:
> +        if (pc_info->domain_id != did) {
> +            return false;
> +        }
> +        /* Fall through */
> +    case VTD_PASID_CACHE_GLOBAL:
> +        break;
> +    default:
> +        error_report("invalid pc_info->flags");
> +        abort();
> +    }
> +
> +    /*
> +     * pasid cache invalidation may indicate a present pasid
> +     * entry to present pasid entry modification. To cover such
> +     * case, vIOMMU emulator needs to fetch latest guest pasid
> +     * entry and check cached pasid entry, then update pasid
> +     * cache and send pasid bind/unbind to host properly.
> +     */
> +    ret = vtd_dev_get_pe_from_pasid(s,
> +                  pci_bus_num(vtd_bus->bus), devfn, pasid, &pe);
> +    if (ret) {
> +        /*
> +         * No valid pasid entry in guest memory. e.g. pasid entry
> +         * was modified to be either all-zero or non-present. Either
> +         * case means existing pasid cache should be removed.
> +         */
> +        goto remove;
> +    }
> +
> +    vtd_update_pe_in_cache(s, vtd_pasid_as, &pe);
> +    /*
> +     * TODO:
> +     * - when pasid-base-iotlb(piotlb) infrastructure is ready,
> +     *   should invalidate QEMU piotlb togehter with this change.
> +     */
> +    return false;
> +remove:
> +    /*
> +     * TODO:
> +     * - send pasid bind to host for passthru devices
> +     * - when pasid-base-iotlb(piotlb) infrastructure is ready,
> +     *   should invalidate QEMU piotlb togehter with this change.
> +     */
> +    return true;
> +}
> +
> +/**
> + * This function finds or adds a VTDPASIDAddressSpace for a device
> + * when it is bound to a pasid. Caller of this function should hold
> + * iommu_lock.
> + */
> +static VTDPASIDAddressSpace *vtd_add_find_pasid_as(IntelIOMMUState *s,
> +                                                   VTDBus *vtd_bus,
> +                                                   int devfn,
> +                                                   uint32_t pasid)
> +{
> +    struct pasid_key key;
> +    struct pasid_key *new_key;
> +    VTDPASIDAddressSpace *vtd_pasid_as;
> +    uint16_t sid;
> +
> +    sid = vtd_make_source_id(pci_bus_num(vtd_bus->bus), devfn);
> +    vtd_init_pasid_key(pasid, sid, &key);
> +    vtd_pasid_as = g_hash_table_lookup(s->vtd_pasid_as, &key);
> +
> +    if (!vtd_pasid_as) {
> +        new_key = g_malloc0(sizeof(*new_key));
> +        vtd_init_pasid_key(pasid, sid, new_key);
> +        /*
> +         * Initiate the vtd_pasid_as structure.
> +         *
> +         * This structure here is used to track the guest pasid
> +         * binding and also serves as pasid-cache mangement entry.
> +         *
> +         * TODO: in future, if wants to support the SVA-aware DMA
> +         *       emulation, the vtd_pasid_as should have include
> +         *       AddressSpace to support DMA emulation.
> +         */
> +        vtd_pasid_as = g_malloc0(sizeof(VTDPASIDAddressSpace));
> +        vtd_pasid_as->iommu_state = s;
> +        vtd_pasid_as->vtd_bus = vtd_bus;
> +        vtd_pasid_as->devfn = devfn;
> +        vtd_pasid_as->context_cache_entry.context_cache_gen = 0;
> +        vtd_pasid_as->pasid = pasid;
> +        vtd_pasid_as->pasid_cache_entry.pasid_cache_gen = 0;
> +        g_hash_table_insert(s->vtd_pasid_as, new_key, vtd_pasid_as);
> +    }
> +    return vtd_pasid_as;
> +}
> +
>  static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
>  {
> +    VTDPASIDCacheInfo pc_info;
> +
> +    trace_vtd_pasid_cache_dsi(domain_id);
> +
> +    pc_info.flags = VTD_PASID_CACHE_DOMSI;
> +    pc_info.domain_id = domain_id;
> +
> +    /*
> +     * Loop all existing pasid caches and update them.
> +     */
> +    vtd_iommu_lock(s);
> +    g_hash_table_foreach_remove(s->vtd_pasid_as,
> +                                 vtd_flush_pasid, &pc_info);
> +    vtd_iommu_unlock(s);
> +
> +    /*
> +     * TODO:
> +     * Domain selective PASID cache invalidation flushes
> +     * all the pasid caches within a domain. To be safe,
> +     * after invalidating the pasid caches, emulator needs
> +     * to replay the pasid bindings by walking guest pasid
> +     * dir and pasid table. e.g. When the guest setup a new
> +     * PASID entry then send a PASID DSI.
> +     */
>      return 0;
>  }
>  
>  static int vtd_pasid_cache_psi(IntelIOMMUState *s,
>                                 uint16_t domain_id, uint32_t pasid)
>  {
> +    VTDPASIDCacheInfo pc_info;
> +    VTDHostIOMMUContext *vtd_dev_icx;
> +
> +    /* PASID selective implies a DID selective */
> +    pc_info.flags = VTD_PASID_CACHE_PASIDSI;
> +    pc_info.domain_id = domain_id;
> +    pc_info.pasid = pasid;
> +
> +    /*
> +     * Regards to a pasid selective pasid cache invalidation (PSI),
> +     * it could be either cases of below:
> +     * a) a present pasid entry moved to non-present
> +     * b) a present pasid entry to be a present entry
> +     * c) a non-present pasid entry moved to present
> +     *
> +     * Here the handling of a PSI follows below steps:
> +     * 1) loop all the exisitng vtd_pasid_as instances to update them
> +     *    according to the latest guest pasid entry in pasid table.
> +     *    this will make sure affected existing vtd_pasid_as instances
> +     *    cached the latest pasid entries. Also, during the loop, the
> +     *    host should be notified if needed. e.g. pasid unbind or pasid
> +     *    update. Should be able to cover case a) and case b).
> +     *
> +     * 2) loop all devices to cover case c)
> +     *    - For devices which have HostIOMMUContext instances,
> +     *      we loop them and check if guest pasid entry exists. If yes,
> +     *      it is case c), we update the pasid cache and also notify
> +     *      host.
> +     *    - For devices which have no HostIOMMUContext, it is not
> +     *      necessary to create pasid cache at this phase since it
> +     *      could be created when vIOMMU does DMA address translation.
> +     *      This is not yet implemented since there is no emulated
> +     *      pasid-capable devices today. If we have such devices in
> +     *      future, the pasid cache shall be created there.
> +     */
> +
> +    vtd_iommu_lock(s);
> +    /* Step 1: loop all the exisitng vtd_pasid_as instances */
> +    g_hash_table_foreach_remove(s->vtd_pasid_as,
> +                                vtd_flush_pasid, &pc_info);
> +

<START>

> +    /*
> +     * Step 2: loop all the exisitng vtd_dev_icx instances.
> +     * Ideally, needs to loop all devices to find if there is any new
> +     * PASID binding regards to the PASID cache invalidation request.
> +     * But it is enough to loop the devices which are backed by host
> +     * IOMMU. For devices backed by vIOMMU (a.k.a emulated devices),
> +     * if new PASID happened on them, their vtd_pasid_as instance could
> +     * be created during future vIOMMU DMA translation.
> +     */
> +    QLIST_FOREACH(vtd_dev_icx, &s->vtd_dev_icx_list, next) {
> +        VTDPASIDAddressSpace *vtd_pasid_as;
> +        VTDPASIDCacheEntry *pc_entry;
> +        VTDPASIDEntry pe;
> +        VTDBus *vtd_bus = vtd_dev_icx->vtd_bus;
> +        uint16_t devfn = vtd_dev_icx->devfn;
> +        int bus_n = pci_bus_num(vtd_bus->bus);
> +
> +        /* i) fetch vtd_pasid_as and check if it is valid */
> +        vtd_pasid_as = vtd_add_find_pasid_as(s, vtd_bus,
> +                                             devfn, pasid);

I don't feel like it's correct here...

Assuming we have two devices assigned D1, D2.  D1 uses PASID=1, D2
uses PASID=2.  When invalidating against PASID=1, are you also going
to create a VTDPASIDAddressSpace also for D2 with PASID=1?

I feel like we shouldn't create VTDPASIDAddressSpace only if it
existed, say, until when we reach vtd_dev_get_pe_from_pasid() below
with retcode==0.

Besides this...

> +        pc_entry = &vtd_pasid_as->pasid_cache_entry;
> +        if (s->pasid_cache_gen == pc_entry->pasid_cache_gen) {
> +            /*
> +             * pasid_cache_gen equals to s->pasid_cache_gen means
> +             * vtd_pasid_as is valid after the above s->vtd_pasid_as
> +             * updates in Step 1. Thus no need for the below steps.
> +             */
> +            continue;
> +        }
> +
> +        /*
> +         * ii) vtd_pasid_as is not valid, it's potentailly a new
> +         *    pasid bind. Fetch guest pasid entry.
> +         */
> +        if (vtd_dev_get_pe_from_pasid(s, bus_n, devfn, pasid, &pe)) {
> +            continue;
> +        }
> +
> +        /*
> +         * iii) pasid entry exists, update pasid cache
> +         *
> +         * Here need to check domain ID since guest pasid entry
> +         * exists. What needs to do are:
> +         *   - update the pc_entry in the vtd_pasid_as
> +         *   - set proper pc_entry.pasid_cache_gen
> +         *   - pass down the latest guest pasid entry config to host
> +         *     (will be added in later patch)
> +         */
> +        if (domain_id == vtd_pe_get_domain_id(&pe)) {
> +            vtd_fill_in_pe_in_cache(s, vtd_pasid_as, &pe);
> +        }
> +    }

<END>

... I'm a bit confused on the whole range between <START> and <END> on
how it differs from the vtd_replay_guest_pasid_bindings() you're going
to introduce.  Shouldn't the replay code do similar thing?  Can we
merge them?

My understanding is that we can just make sure to do it right once in
the replay code (the three cases: INVALID->VALID, VALID->INVALID,
VALID->VALID), then no matter whether it's DSI/PSI/GSI, we call the
replay code probably with VTDPASIDCacheInfo* passed in, then the
replay code will know what to look after.

> +
> +    vtd_iommu_unlock(s);
>      return 0;
>  }
>  
> +/**
> + * Caller of this function should hold iommu_lock
> + */
> +static void vtd_pasid_cache_reset(IntelIOMMUState *s)
> +{
> +    VTDPASIDCacheInfo pc_info;
> +
> +    trace_vtd_pasid_cache_reset();
> +
> +    pc_info.flags = VTD_PASID_CACHE_GLOBAL;
> +
> +    /*
> +     * Reset pasid cache is a big hammer, so use
> +     * g_hash_table_foreach_remove which will free
> +     * the vtd_pasid_as instances, indicates the
> +     * cached pasid_cache_gen would be set to 0.
> +     */
> +    g_hash_table_foreach_remove(s->vtd_pasid_as,
> +                           vtd_flush_pasid, &pc_info);

Would this make sure the per pasid_as pasid_cache_gen will be reset to
zero?  I'm not very sure, say, what if the memory is stall during a
reset and still have the old data?

I'm not sure, but I feel like we should simply drop all pasid_as here,
rather than using the same code for a global pasid invalidation.

> +    s->pasid_cache_gen = 1;
> +}
> +
>  static int vtd_pasid_cache_gsi(IntelIOMMUState *s)
>  {
> +    trace_vtd_pasid_cache_gsi();
> +
> +    vtd_iommu_lock(s);
> +    s->pasid_cache_gen++;
> +    if (s->pasid_cache_gen > PASID_CACHE_GEN_MAX) {
> +        vtd_pasid_cache_reset(s);
> +    }
> +    vtd_iommu_unlock(s);
> +
> +    /*
> +     * TODO:
> +     * Global PASID cache invalidation flushes all
> +     * the pasid caches. To be safe, after invalidating
> +     * the pasid caches, emulator needs to replay the
> +     * pasid bindings by walking guest pasid dir and
> +     * pasid table.
> +     */
>      return 0;
>  }
>  
> @@ -4110,6 +4502,8 @@ static void vtd_realize(DeviceState *dev, Error **errp)
>                                       g_free, g_free);
>      s->vtd_as_by_busptr = g_hash_table_new_full(vtd_uint64_hash, vtd_uint64_equal,
>                                                g_free, g_free);
> +    s->vtd_pasid_as = g_hash_table_new_full(vtd_pasid_as_key_hash,
> +                                   vtd_pasid_as_key_equal, g_free, g_free);
>      vtd_init(s);
>      sysbus_mmio_map(SYS_BUS_DEVICE(s), 0, Q35_HOST_BRIDGE_IOMMU_ADDR);
>      pci_setup_iommu(bus, &vtd_iommu_ops, dev);
> diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
> index 0ca5f0b..01fd95c 100644
> --- a/hw/i386/intel_iommu_internal.h
> +++ b/hw/i386/intel_iommu_internal.h
> @@ -307,6 +307,7 @@ typedef enum VTDFaultReason {
>      VTD_FR_IR_SID_ERR = 0x26,   /* Invalid Source-ID */
>  
>      VTD_FR_PASID_TABLE_INV = 0x58,  /*Invalid PASID table entry */
> +    VTD_FR_PASID_ENTRY_P = 0x59, /* The Present(P) field of pasidt-entry is 0 */
>  
>      /* This is not a normal fault reason. We use this to indicate some faults
>       * that are not referenced by the VT-d specification.
> @@ -515,6 +516,19 @@ typedef struct VTDRootEntry VTDRootEntry;
>  #define VTD_SM_CONTEXT_ENTRY_RSVD_VAL0(aw)  (0x1e0ULL | ~VTD_HAW_MASK(aw))
>  #define VTD_SM_CONTEXT_ENTRY_RSVD_VAL1      0xffffffffffe00000ULL
>  
> +struct VTDPASIDCacheInfo {
> +#define VTD_PASID_CACHE_GLOBAL   (1ULL << 0)
> +#define VTD_PASID_CACHE_DOMSI    (1ULL << 1)
> +#define VTD_PASID_CACHE_PASIDSI  (1ULL << 2)
> +    uint32_t flags;
> +    uint16_t domain_id;
> +    uint32_t pasid;
> +};
> +#define VTD_PASID_CACHE_INFO_MASK    (VTD_PASID_CACHE_GLOBAL | \
> +                                      VTD_PASID_CACHE_DOMSI  | \
> +                                      VTD_PASID_CACHE_PASIDSI)
> +typedef struct VTDPASIDCacheInfo VTDPASIDCacheInfo;
> +
>  /* PASID Table Related Definitions */
>  #define VTD_PASID_DIR_BASE_ADDR_MASK  (~0xfffULL)
>  #define VTD_PASID_TABLE_BASE_ADDR_MASK (~0xfffULL)
> diff --git a/hw/i386/trace-events b/hw/i386/trace-events
> index f7cd4e5..60d20c1 100644
> --- a/hw/i386/trace-events
> +++ b/hw/i386/trace-events
> @@ -23,6 +23,7 @@ vtd_inv_qi_tail(uint16_t head) "write tail %d"
>  vtd_inv_qi_fetch(void) ""
>  vtd_context_cache_reset(void) ""
>  vtd_pasid_cache_gsi(void) ""
> +vtd_pasid_cache_reset(void) ""
>  vtd_pasid_cache_dsi(uint16_t domain) "Domian slective PC invalidation domain 0x%"PRIx16
>  vtd_pasid_cache_psi(uint16_t domain, uint32_t pasid) "PASID slective PC invalidation domain 0x%"PRIx16" pasid 0x%"PRIx32
>  vtd_re_not_present(uint8_t bus) "Root entry bus %"PRIu8" not present"
> diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
> index da0a5f7..9782ac4 100644
> --- a/include/hw/i386/intel_iommu.h
> +++ b/include/hw/i386/intel_iommu.h
> @@ -65,6 +65,8 @@ typedef union VTD_IR_MSIAddress VTD_IR_MSIAddress;
>  typedef struct VTDPASIDDirEntry VTDPASIDDirEntry;
>  typedef struct VTDPASIDEntry VTDPASIDEntry;
>  typedef struct VTDHostIOMMUContext VTDHostIOMMUContext;
> +typedef struct VTDPASIDCacheEntry VTDPASIDCacheEntry;
> +typedef struct VTDPASIDAddressSpace VTDPASIDAddressSpace;
>  
>  /* Context-Entry */
>  struct VTDContextEntry {
> @@ -97,6 +99,31 @@ struct VTDPASIDEntry {
>      uint64_t val[8];
>  };
>  
> +struct pasid_key {
> +    uint32_t pasid;
> +    uint16_t sid;
> +};
> +
> +struct VTDPASIDCacheEntry {
> +    /*
> +     * The cache entry is obsolete if
> +     * pasid_cache_gen!=IntelIOMMUState.pasid_cache_gen
> +     */
> +    uint32_t pasid_cache_gen;
> +    struct VTDPASIDEntry pasid_entry;
> +};
> +
> +struct VTDPASIDAddressSpace {
> +    VTDBus *vtd_bus;
> +    uint8_t devfn;
> +    AddressSpace as;
> +    uint32_t pasid;
> +    IntelIOMMUState *iommu_state;
> +    VTDContextCacheEntry context_cache_entry;
> +    QLIST_ENTRY(VTDPASIDAddressSpace) next;
> +    VTDPASIDCacheEntry pasid_cache_entry;
> +};
> +
>  struct VTDAddressSpace {
>      PCIBus *bus;
>      uint8_t devfn;
> @@ -267,6 +294,9 @@ struct IntelIOMMUState {
>  
>      GHashTable *vtd_as_by_busptr;   /* VTDBus objects indexed by PCIBus* reference */
>      VTDBus *vtd_as_by_bus_num[VTD_PCI_BUS_MAX]; /* VTDBus objects indexed by bus number */
> +    GHashTable *vtd_pasid_as;   /* VTDPASIDAddressSpace instances */
> +#define PASID_CACHE_GEN_MAX  512
> +    uint32_t pasid_cache_gen;   /* Should be in [1,MAX] */
>      /* list of registered notifiers */
>      QLIST_HEAD(, VTDAddressSpace) vtd_as_with_notifiers;
>  
> @@ -289,7 +319,8 @@ struct IntelIOMMUState {
>  
>      /*
>       * Protects IOMMU states in general.  Currently it protects the
> -     * per-IOMMU IOTLB cache, and context entry cache in VTDAddressSpace.
> +     * per-IOMMU IOTLB cache, and context entry cache in VTDAddressSpace,
> +     * and pasid cache in VTDPASIDAddressSpace.
>       * Protect the update/usage of HostIOMMUContext pointer cached in
>       * VTDBus->dev_icx array as array elements may be updated by hotplug
>       */
> -- 
> 2.7.4
> 

-- 
Peter Xu

