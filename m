Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513B05140A7
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 04:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiD2C3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 22:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiD2C3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 22:29:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E9134C42D
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 19:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651199196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sVqWArjGQBw4naKwcsqkItcIxkER5lSumVvlIWNosQg=;
        b=De1E+2gDeglJZwG/PtEHF2qExFWsFYNhy7xJ3nUIAOyO6ywVlUwgF2etAIjXJNCHPFi1NW
        S3ETVwUPVkpK3FWcpLxUlMgPFPK04WpQaQXHFfF6cUA/OL0CfyLEw41TGcPWaA3RpdiHYS
        HJdEq+a4o3KnqBRYt5c4C4Vq3V663Ak=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-4_bv6J8XPgiv6d6KfNbhmA-1; Thu, 28 Apr 2022 22:26:34 -0400
X-MC-Unique: 4_bv6J8XPgiv6d6KfNbhmA-1
Received: by mail-lf1-f71.google.com with SMTP id br31-20020a056512401f00b00471c57013ceso2730683lfb.3
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 19:26:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sVqWArjGQBw4naKwcsqkItcIxkER5lSumVvlIWNosQg=;
        b=r3Two+viV0NDbNgfkQMmGtfUpMKcTnoJL37W9kXy5vq9TGibtiC1wmTG0U4nsnpQxR
         2A//UnZdfMJ9GG8ZtMLqjBmMBEEsx25ztVOIuWdDOaBC7PFiJqIre58ZlcFTC2baWK0w
         6OPlHRo1He7YB5PQJSz6CjJMahgChAPcxi9Sh6jJo4pZLcbV9JKY7THknTQdKsNm6XLk
         BXNb06j45uL/U1sf5nYK7wOEVvZVF3GK0mphcQTYiiXScI2oSl30ifZ4/DJSE6Ti2Z5l
         Y2zQT3XZyIZ9FgZVqj75XERIpwXFNW5DlbUYnsDL9amY+LkdZzMMbt3n0LxtgAqqc9Z+
         JhzA==
X-Gm-Message-State: AOAM532ye3HaZQEFSOO6D5D68F+TUXIon+9j8QJWzfvQfOe3wXIWwPqv
        J4qaec1FrNXu0GUoEOSTApIe5y6BVA8QUTQVkPwyyIV5saxLoq7w1ffBETIIq2O73F6oGcr8RK+
        7xySM4NLxqDGQiFkdiqjX2vxmi0o7
X-Received: by 2002:a05:6512:1288:b0:472:34e9:ee31 with SMTP id u8-20020a056512128800b0047234e9ee31mr5297086lfs.190.1651199193052;
        Thu, 28 Apr 2022 19:26:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuG1Yc95KMna57hKnDE6aiiHRGa/IPpBDyILJUKCE8CWA2f6a2/aKwjdaJhnwoOG6lPUCpiLYAoxf4zEoNoOo=
X-Received: by 2002:a05:6512:1288:b0:472:34e9:ee31 with SMTP id
 u8-20020a056512128800b0047234e9ee31mr5297058lfs.190.1651199192768; Thu, 28
 Apr 2022 19:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220428211351.3897-1-joao.m.martins@oracle.com> <20220428211351.3897-5-joao.m.martins@oracle.com>
In-Reply-To: <20220428211351.3897-5-joao.m.martins@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 29 Apr 2022 10:26:21 +0800
Message-ID: <CACGkMEug0zW0pWCSEtHQ5KE5KRpXyWvgJmPZm-yvJnCLmocAYg@mail.gmail.com>
Subject: Re: [PATCH RFC 04/10] intel_iommu: Second Stage Access Dirty bit support
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 5:14 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> IOMMU advertises Access/Dirty bits if the extended capability
> DMAR register reports it (ECAP, mnemonic ECAP.SSADS albeit it used
> to be known as SLADS before). The first stage table, though, has no bit for
> advertising Access/Dirty, unless referenced via a scalable-mode PASID Entry.
> Relevant Intel IOMMU SDM ref for first stage table "3.6.2 Accessed, Extended
> Accessed, and Dirty Flags" and second stage table "3.7.2 Accessed and Dirty
> Flags".
>
> To enable it we depend on scalable-mode for the second-stage table,
> so we limit use of dirty-bit to scalable-mode To use SSADS, we set a bit in
> the scalable-mode PASID Table entry, by setting bit 9 (SSADE). When
> we do so we require flushing the context/pasid-table caches and IOTLB much
> like AMD. Relevant SDM refs:
>
> "3.7.2 Accessed and Dirty Flags"
> "6.5.3.3 Guidance to Software for Invalidations,
>  Table 23. Guidance to Software for Invalidations"
>
> To read out what's dirtied, same thing as past implementations is done.
> Dirty bit support is located in the same location (bit 9). The IOTLB
> caches some attributes when SSADE is enabled and dirty-ness information,
> so we also need to flush IOTLB to make sure IOMMU attempts to set the
> dirty bit again. Relevant manuals over the hardware translation is
> chapter 6 with some special mention to:
>
> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
> "6.2.4 IOTLB"
>
> The first 12bits of the PTE are already cached via the SLPTE pointer,
> similar to how it is added in amd-iommu. Use also the previously
> added PASID entry cache in order to fetch whether Dirty bit was
> enabled or not in the SM second stage table.
>
> This is useful for covering and prototyping IOMMU support for access/dirty
> bits.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  hw/i386/intel_iommu.c          | 85 ++++++++++++++++++++++++++++++----
>  hw/i386/intel_iommu_internal.h |  4 ++
>  hw/i386/trace-events           |  2 +
>  3 files changed, 82 insertions(+), 9 deletions(-)
>
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 752940fa4c0e..e946f793a968 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -651,6 +651,21 @@ static uint64_t vtd_get_slpte(dma_addr_t base_addr, uint32_t index)
>      return slpte;
>  }
>
> +/* Get the content of a spte located in @base_addr[@index] */
> +static uint64_t vtd_set_slpte(dma_addr_t base_addr, uint32_t index,
> +                              uint64_t slpte)
> +{
> +
> +    if (dma_memory_write(&address_space_memory,
> +                         base_addr + index * sizeof(slpte), &slpte,
> +                         sizeof(slpte), MEMTXATTRS_UNSPECIFIED)) {
> +        slpte = (uint64_t)-1;
> +        return slpte;
> +    }
> +
> +    return vtd_get_slpte(base_addr, index);
> +}
> +
>  /* Given an iova and the level of paging structure, return the offset
>   * of current level.
>   */
> @@ -720,6 +735,11 @@ static inline bool vtd_pe_present(VTDPASIDEntry *pe)
>      return pe->val[0] & VTD_PASID_ENTRY_P;
>  }
>
> +static inline bool vtd_pe_slad_enabled(VTDPASIDEntry *pe)
> +{
> +    return pe->val[0] & VTD_SM_PASID_ENTRY_SLADE;
> +}
> +
>  static int vtd_get_pe_in_pasid_leaf_table(IntelIOMMUState *s,
>                                            uint32_t pasid,
>                                            dma_addr_t addr,
> @@ -1026,6 +1046,33 @@ static VTDBus *vtd_find_as_from_bus_num(IntelIOMMUState *s, uint8_t bus_num)
>      return NULL;
>  }
>
> +static inline bool vtd_ssad_update(IntelIOMMUState *s, uint16_t pe_flags,
> +                                   uint64_t *slpte, bool is_write,
> +                                   bool reads, bool writes)
> +{
> +    bool dirty, access = reads;
> +
> +    if (!(pe_flags & VTD_SM_PASID_ENTRY_SLADE)) {
> +        return false;
> +    }
> +
> +    dirty = access = false;
> +
> +    if (is_write && writes && !(*slpte & VTD_SL_D)) {
> +        *slpte |= VTD_SL_D;
> +        trace_vtd_dirty_update(*slpte);
> +        dirty = true;
> +    }
> +
> +    if (((!is_write && reads) || dirty) && !(*slpte & VTD_SL_A)) {
> +        *slpte |= VTD_SL_A;
> +        trace_vtd_access_update(*slpte);
> +        access = true;
> +    }
> +
> +    return dirty || access;
> +}
> +
>  /* Given the @iova, get relevant @slptep. @slpte_level will be the last level
>   * of the translation, can be used for deciding the size of large page.
>   */
> @@ -1039,6 +1086,7 @@ static int vtd_iova_to_slpte(IntelIOMMUState *s, VTDContextEntry *ce,
>      uint32_t offset;
>      uint64_t slpte;
>      uint64_t access_right_check;
> +    uint16_t pe_flags;
>
>      if (!vtd_iova_range_check(s, iova, ce, aw_bits)) {
>          error_report_once("%s: detected IOVA overflow (iova=0x%" PRIx64 ")",
> @@ -1054,14 +1102,7 @@ static int vtd_iova_to_slpte(IntelIOMMUState *s, VTDContextEntry *ce,
>          slpte = vtd_get_slpte(addr, offset);
>
>          if (slpte == (uint64_t)-1) {
> -            error_report_once("%s: detected read error on DMAR slpte "
> -                              "(iova=0x%" PRIx64 ")", __func__, iova);
> -            if (level == vtd_get_iova_level(s, ce)) {
> -                /* Invalid programming of context-entry */
> -                return -VTD_FR_CONTEXT_ENTRY_INV;
> -            } else {
> -                return -VTD_FR_PAGING_ENTRY_INV;
> -            }
> +            goto inv_slpte;
>          }
>          *reads = (*reads) && (slpte & VTD_SL_R);
>          *writes = (*writes) && (slpte & VTD_SL_W);
> @@ -1081,6 +1122,14 @@ static int vtd_iova_to_slpte(IntelIOMMUState *s, VTDContextEntry *ce,
>          }
>
>          if (vtd_is_last_slpte(slpte, level)) {
> +            pe_flags = vtd_sm_pasid_entry_flags(s, ce);
> +            if (vtd_ssad_update(s, pe_flags, &slpte, is_write,
> +                                *reads, *writes)) {
> +                slpte = vtd_set_slpte(addr, offset, slpte);
> +                if (slpte == (uint64_t)-1) {
> +                    goto inv_slpte;
> +                }
> +            }
>              *slptep = slpte;
>              *slpte_level = level;
>              return 0;
> @@ -1088,6 +1137,16 @@ static int vtd_iova_to_slpte(IntelIOMMUState *s, VTDContextEntry *ce,
>          addr = vtd_get_slpte_addr(slpte, aw_bits);
>          level--;
>      }
> +
> +inv_slpte:
> +    error_report_once("%s: detected read error on DMAR slpte "
> +                      "(iova=0x%" PRIx64 ")", __func__, iova);
> +    if (level == vtd_get_iova_level(s, ce)) {
> +        /* Invalid programming of context-entry */
> +        return -VTD_FR_CONTEXT_ENTRY_INV;
> +    } else {
> +        return -VTD_FR_PAGING_ENTRY_INV;
> +    }
>  }
>
>  typedef int (*vtd_page_walk_hook)(IOMMUTLBEvent *event, void *private);
> @@ -1742,6 +1801,13 @@ static bool vtd_do_iommu_translate(VTDAddressSpace *vtd_as, PCIBus *bus,
>          slpte = iotlb_entry->slpte;
>          access_flags = iotlb_entry->access_flags;
>          page_mask = iotlb_entry->mask;
> +        if (vtd_ssad_update(s, iotlb_entry->sm_pe_flags, &slpte, is_write,
> +                            access_flags & IOMMU_RO, access_flags & IOMMU_WO)) {
> +                uint32_t offset;
> +
> +                offset = vtd_iova_level_offset(addr, vtd_get_iova_level(s, &ce));
> +                vtd_set_slpte(addr, offset, slpte);
> +        }
>          goto out;
>      }
>
> @@ -3693,7 +3759,8 @@ static void vtd_init(IntelIOMMUState *s)
>
>      /* TODO: read cap/ecap from host to decide which cap to be exposed. */
>      if (s->scalable_mode) {
> -        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
> +        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS |
> +                   VTD_ECAP_SLADS;
>      }

We probably need a dedicated command line parameter and make it compat
for pre 7.1 machines.

Otherwise we may break migration.

Thanks

>
>      if (s->snoop_control) {
> diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
> index 1ff13b40f9bb..c00f6e7b4a72 100644
> --- a/hw/i386/intel_iommu_internal.h
> +++ b/hw/i386/intel_iommu_internal.h
> @@ -192,6 +192,7 @@
>  #define VTD_ECAP_MHMV               (15ULL << 20)
>  #define VTD_ECAP_SRS                (1ULL << 31)
>  #define VTD_ECAP_SMTS               (1ULL << 43)
> +#define VTD_ECAP_SLADS              (1ULL << 45)
>  #define VTD_ECAP_SLTS               (1ULL << 46)
>
>  /* CAP_REG */
> @@ -492,6 +493,7 @@ typedef struct VTDRootEntry VTDRootEntry;
>
>  #define VTD_SM_PASID_ENTRY_AW          7ULL /* Adjusted guest-address-width */
>  #define VTD_SM_PASID_ENTRY_DID(val)    ((val) & VTD_DOMAIN_ID_MASK)
> +#define VTD_SM_PASID_ENTRY_SLADE       (1ULL << 9)
>
>  /* Second Level Page Translation Pointer*/
>  #define VTD_SM_PASID_ENTRY_SLPTPTR     (~0xfffULL)
> @@ -515,5 +517,7 @@ typedef struct VTDRootEntry VTDRootEntry;
>  #define VTD_SL_PT_BASE_ADDR_MASK(aw) (~(VTD_PAGE_SIZE - 1) & VTD_HAW_MASK(aw))
>  #define VTD_SL_IGN_COM              0xbff0000000000000ULL
>  #define VTD_SL_TM                   (1ULL << 62)
> +#define VTD_SL_A                    (1ULL << 8)
> +#define VTD_SL_D                    (1ULL << 9)
>
>  #endif
> diff --git a/hw/i386/trace-events b/hw/i386/trace-events
> index eb5f075873cd..e4122ee8a999 100644
> --- a/hw/i386/trace-events
> +++ b/hw/i386/trace-events
> @@ -66,6 +66,8 @@ vtd_frr_new(int index, uint64_t hi, uint64_t lo) "index %d high 0x%"PRIx64" low
>  vtd_warn_invalid_qi_tail(uint16_t tail) "tail 0x%"PRIx16
>  vtd_warn_ir_vector(uint16_t sid, int index, int vec, int target) "sid 0x%"PRIx16" index %d vec %d (should be: %d)"
>  vtd_warn_ir_trigger(uint16_t sid, int index, int trig, int target) "sid 0x%"PRIx16" index %d trigger %d (should be: %d)"
> +vtd_access_update(uint64_t slpte) "slpte 0x%"PRIx64
> +vtd_dirty_update(uint64_t slpte) "slpte 0x%"PRIx64
>
>  # amd_iommu.c
>  amdvi_evntlog_fail(uint64_t addr, uint32_t head) "error: fail to write at addr 0x%"PRIx64" +  offset 0x%"PRIx32
> --
> 2.17.2
>

