Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284A35B119C
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 02:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiIHAxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 20:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiIHAxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 20:53:13 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32C3ABD4C
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 17:53:11 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a8so3534536lff.13
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 17:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=o3rkDof3IyVXtWl1z1ETwCijwcrWKVndm9BeuGNQ/0E=;
        b=TJQcsQQe52ZH7ng5VwtFE2qrhvyTXF05tseWwiIQ/DvU+gQUBaY4oXnerWBxy09F99
         nY2WHglYO9LOmDRAlCIE+8frjgvBxfYUztGA9RkX0Shu13yhcFLOXep+YM5kFTdmhYEF
         e4a/DiYyJB4mb3GKmUoY5cDSjN0hcIlBnglMJBZProl/faLmsUipgjpveazzYtdX0Iy1
         7YxFXw2xAtzczPqfTbN0+hMYb38z7TLJnSvrxM/+artnvc7M5RtZeXlT6yR8GWEs+uaw
         7KOTkeYl4yTbeA7isM8Mq9kugShVwiXU5flsI906Uw9MmadTSNfE1VyYt9kUb3J+xH2Y
         oozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=o3rkDof3IyVXtWl1z1ETwCijwcrWKVndm9BeuGNQ/0E=;
        b=ZNfCqN1NPtf2IALDS7yC58xMsmSeRFn+5rtjWbiF5Q6PjL2+3mMGj7B/KOExbBaNrE
         AbGP8hcJr6k56H9dDtJ9jakG9PfddCzbHVBiqgnyzOUbis64TKKjv+uW58nHnNacdfaT
         Zyx9r/zbXy5XGrSEgee8DPnDVW0TsYioSA1sobTp2WWt/8PNWOuZ+p0ZgObvtPcg0lWt
         rrrjHWXOwkIc9l2gSgUUryXOnxfxmhpuew0Npb6QzUQDCvPokvTg4bM2XPTLVev1qTJ5
         r18M7ZOVWOsPxXXaEsB0z5bHOJqUN0i1p/RhbwSTLErQRy/m4lbOQ48WuMs8LDToUBCf
         B2og==
X-Gm-Message-State: ACgBeo0kLo7WFlBfzNs9kmXBjmVYoQ4SIXjrQZZoxMKF15kbj3Ay0CxO
        PmJnelDBHm9vQY14e5+dY09QQsl5tYoMrgfFxqQCEfqxmdE=
X-Google-Smtp-Source: AA6agR4eobKxTm/e9iJ+K6opJ8DwV7fWs0//dxv2m3IkbmsEhwq2UCDeWsoQSZFziY5Pgs3tDi1jxrQ4lKw/pYCCt74=
X-Received: by 2002:a05:6512:110d:b0:494:7626:57a0 with SMTP id
 l13-20020a056512110d00b00494762657a0mr1792377lfg.302.1662598389835; Wed, 07
 Sep 2022 17:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <20220415215901.1737897-15-oupton@google.com>
 <Yl4leEoIg+dr/1QM@google.com> <Yl4n7o45K0HFK52S@google.com> <CAOQ_QsiNS2foL8CocwErdEQnpdgbOySjV9Y-4ZG0f-y-XJPQOg@mail.gmail.com>
In-Reply-To: <CAOQ_QsiNS2foL8CocwErdEQnpdgbOySjV9Y-4ZG0f-y-XJPQOg@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 7 Sep 2022 17:52:43 -0700
Message-ID: <CALzav=dWPCekXQnLP80-DyA2VJ2yuFjmBUYsfmeOeMsVmQLKQQ@mail.gmail.com>
Subject: Re: [RFC PATCH 14/17] KVM: arm64: Punt last page reference to rcu
 callback for parallel walk
To:     Oliver Upton <oupton@google.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 19, 2022 at 5:53 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Ricardo,
>
> On Mon, Apr 18, 2022 at 8:09 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > On Mon, Apr 18, 2022 at 07:59:04PM -0700, Ricardo Koller wrote:
> > > On Fri, Apr 15, 2022 at 09:58:58PM +0000, Oliver Upton wrote:
> > > > It is possible that a table page remains visible to another thread until
> > > > the next rcu synchronization event. To that end, we cannot drop the last
> > > > page reference synchronous with post-order traversal for a parallel
> > > > table walk.
> > > >
> > > > Schedule an rcu callback to clean up the child table page for parallel
> > > > walks.
> > > >
> > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_pgtable.h |  3 ++
> > > >  arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++--
> > > >  arch/arm64/kvm/mmu.c                 | 44 +++++++++++++++++++++++++++-
> > > >  3 files changed, 67 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > > > index 74955aba5918..52e55e00f0ca 100644
> > > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > > @@ -81,6 +81,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
> > > >   * @put_page:                      Decrement the refcount on a page. When the
> > > >   *                         refcount reaches 0 the page is automatically
> > > >   *                         freed.
> > > > + * @free_table:                    Drop the last page reference, possibly in the
> > > > + *                         next RCU sync if doing a shared walk.
> > > >   * @page_count:                    Return the refcount of a page.
> > > >   * @phys_to_virt:          Convert a physical address into a virtual
> > > >   *                         address mapped in the current context.
> > > > @@ -98,6 +100,7 @@ struct kvm_pgtable_mm_ops {
> > > >     void            (*get_page)(void *addr);
> > > >     void            (*put_page)(void *addr);
> > > >     int             (*page_count)(void *addr);
> > > > +   void            (*free_table)(void *addr, bool shared);
> > > >     void*           (*phys_to_virt)(phys_addr_t phys);
> > > >     phys_addr_t     (*virt_to_phys)(void *addr);
> > > >     void            (*dcache_clean_inval_poc)(void *addr, size_t size);
> > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > > index 121818d4c33e..a9a48edba63b 100644
> > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > @@ -147,12 +147,19 @@ static inline void kvm_pgtable_walk_end(void)
> > > >  {}
> > > >
> > > >  #define kvm_dereference_ptep       rcu_dereference_raw
> > > > +
> > > > +static inline void kvm_pgtable_destroy_barrier(void)
> > > > +{}
> > > > +
> > > >  #else
> > > >  #define kvm_pgtable_walk_begin     rcu_read_lock
> > > >
> > > >  #define kvm_pgtable_walk_end       rcu_read_unlock
> > > >
> > > >  #define kvm_dereference_ptep       rcu_dereference
> > > > +
> > > > +#define kvm_pgtable_destroy_barrier        rcu_barrier
> > > > +
> > > >  #endif
> > > >
> > > >  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
> > > > @@ -1063,7 +1070,12 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
> > > >             childp = kvm_pte_follow(*old, mm_ops);
> > > >     }
> > > >
> > > > -   mm_ops->put_page(childp);
> > > > +   /*
> > > > +    * If we do not have exclusive access to the page tables it is possible
> > > > +    * the unlinked table remains visible to another thread until the next
> > > > +    * rcu synchronization.
> > > > +    */
> > > > +   mm_ops->free_table(childp, shared);
> > > >     mm_ops->put_page(ptep);
> > > >
> > > >     return ret;
> > > > @@ -1203,7 +1215,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > > >                                            kvm_granule_size(level));
> > > >
> > > >     if (childp)
> > > > -           mm_ops->put_page(childp);
> > > > +           mm_ops->free_table(childp, shared);
> > > >
> > > >     return 0;
> > > >  }
> > > > @@ -1433,7 +1445,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > > >     mm_ops->put_page(ptep);
> > > >
> > > >     if (kvm_pte_table(*old, level))
> > > > -           mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
> > > > +           mm_ops->free_table(kvm_pte_follow(*old, mm_ops), shared);
> > > >
> > > >     return 0;
> > > >  }
> > > > @@ -1452,4 +1464,10 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> > > >     pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
> > > >     pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
> > > >     pgt->pgd = NULL;
> > > > +
> > > > +   /*
> > > > +    * Guarantee that all unlinked subtrees associated with the stage2 page
> > > > +    * table have also been freed before returning.
> > > > +    */
> > > > +   kvm_pgtable_destroy_barrier();
> > > >  }
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index cc6ed6b06ec2..6ecf37009c21 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -98,9 +98,50 @@ static bool kvm_is_device_pfn(unsigned long pfn)
> > > >  static void *stage2_memcache_zalloc_page(void *arg)
> > > >  {
> > > >     struct kvm_mmu_caches *mmu_caches = arg;
> > > > +   struct stage2_page_header *hdr;
> > > > +   void *addr;
> > > >
> > > >     /* Allocated with __GFP_ZERO, so no need to zero */
> > > > -   return kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> > > > +   addr = kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
> > > > +   if (!addr)
> > > > +           return NULL;
> > > > +
> > > > +   hdr = kvm_mmu_memory_cache_alloc(&mmu_caches->header_cache);
> > > > +   if (!hdr) {
> > > > +           free_page((unsigned long)addr);
> > > > +           return NULL;
> > > > +   }
> > > > +
> > > > +   hdr->page = virt_to_page(addr);
> > > > +   set_page_private(hdr->page, (unsigned long)hdr);
> > > > +   return addr;
> > > > +}
> > > > +
> > > > +static void stage2_free_page_now(struct stage2_page_header *hdr)
> > > > +{
> > > > +   WARN_ON(page_ref_count(hdr->page) != 1);
> > > > +
> > > > +   __free_page(hdr->page);
> > > > +   kmem_cache_free(stage2_page_header_cache, hdr);
> > > > +}
> > > > +
> > > > +static void stage2_free_page_rcu_cb(struct rcu_head *head)
> > > > +{
> > > > +   struct stage2_page_header *hdr = container_of(head, struct stage2_page_header,
> > > > +                                                 rcu_head);
> > > > +
> > > > +   stage2_free_page_now(hdr);
> > > > +}
> > > > +
> > > > +static void stage2_free_table(void *addr, bool shared)
> > > > +{
> > > > +   struct page *page = virt_to_page(addr);
> > > > +   struct stage2_page_header *hdr = (struct stage2_page_header *)page_private(page);
> > > > +
> > > > +   if (shared)
> > > > +           call_rcu(&hdr->rcu_head, stage2_free_page_rcu_cb);
> > >
> > > Can the number of callbacks grow to "dangerous" numbers? can it be
> > > bounded with something like the following?
> > >
> > > if number of readers is really high:
> > >       synchronize_rcu()
> > > else
> > >       call_rcu()
> >
> > sorry, meant to say "number of callbacks"
>
> Good point. I don't have data for this, but generally speaking I do
> not believe we need to enqueue a callback for every page. In fact,
> since we already make the invalid PTE visible in pre-order traversal
> we could theoretically free all tables from a single RCU callback (per
> fault).

I noticed this change was made in v1, but I don't understand the
reasoning. Whether page tables are freed in many callbacks (one per
table) or a single callback (one per subtree), we will still do the
same amount of work in RCU callbacks. In fact the latter (i.e. v1)
approach seems like it ends up doing more work in the RCU callback
because it has to do the page table traversal rather than just call
free() a bunch of times. I'm also not sure if RCU callbacks have any
limitations on how long they can/should take (it may be better to have
lots of tiny callbacks than one large one). OTOH maybe I'm just
misunderstanding something so I thought I'd ask :)

>
> I think if we used synchronize_rcu() then we would need to drop the
> mmu lock since it will block the thread.
>
> --
> Thanks,
> Oliver
