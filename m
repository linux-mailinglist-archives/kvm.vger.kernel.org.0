Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE1F4CC6B2
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 21:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiCCUBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 15:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbiCCUA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 15:00:58 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2081A3612
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 12:00:12 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id u20so10430889lff.2
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 12:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XdCcZyTQlEvwCdpSeL9P0phdZ5Hpdtn6dZc0rjHSW8M=;
        b=od1yIg95+CfH0Er2Q6ZxDVX8E+h22royw+Jgi0l04kppqs7UAhDcNuvNvoWwZfy4gr
         E69u1g4B9aheDOS50DBsJ9Yjc6JqyP8m8d9uCZJQ7fZVIXNKdmeJj5WTyortRopJXwiy
         IIzRsYiDXs0fLMjixYxqTBn4HGnLeQOu0yAufWXl4iizsNelZd9k84LitsaHRpCpXqR5
         QA9UfUsFG9M6ThuLTLZbD2Uwe+WWQ5NnZYT77FOCZar4ADLhTbkh/bUX0GKN+mDLWne/
         /Twms4A5l7yhnkVtEbW0FUBkwKPn2sJ+iAGTXrQ5sZP2QfVQrkZUQHPLBCGsTI4JDuAO
         LNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XdCcZyTQlEvwCdpSeL9P0phdZ5Hpdtn6dZc0rjHSW8M=;
        b=OPyH9q7gb4KZfE8+hdYJxus6uZ8rJ9fxSZxdBawHSvewjNNgEbSbSW+tDsyMvoMnCs
         aSnVBwjPT8y7F+CPBHceDDr6AFTenHg86lnfgPzaUwRUK89vvZ5fSVsMXL9x19RM3K49
         j5R8XqqPLumexBwhgWeGw6UmT4jOZTOFPgPDa/cMHkIDqpEdML6VxpDUscD6+L37NjB3
         GZb5JPJfRWL7yOtuhzko2iBq5HJhWKjseaYkEXhYpoMYzfFr2dQnRU2JFqXLiKJqk2jP
         hc2u2X2r6H5T6cSnH4JEXg40DYxX8AY4s5XlWcVuKFDAm0Oy6CkB3RI1ENaKRlA0+LXO
         W+NQ==
X-Gm-Message-State: AOAM530WGKeaZ1e6hGBYBGg7uZ2BFNluM7SXTAA6eegzyENrmnjK7gN7
        kvzAdx/JzeBWB835Ttf69lwSwPYNLFUcosROUyWFDQ==
X-Google-Smtp-Source: ABdhPJy70vvPhVO9hNsXi3IEtgb4JO94NJq+8oOsCYhdAap5C91vIcRAPvWwLLJqlhwZYX8S2XoTW+BJvuWRoLZWOUE=
X-Received: by 2002:a19:7503:0:b0:443:3d52:fde6 with SMTP id
 y3-20020a197503000000b004433d52fde6mr22374315lfe.250.1646337610216; Thu, 03
 Mar 2022 12:00:10 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-22-dmatlack@google.com>
 <CANgfPd8uR6AHYvckAvmjNMvFsPLm7aLmYXW62nbtqKMijqQQ_A@mail.gmail.com>
 <CALzav=f8mSoFA5mMKCfguUGrkF0R5=pWEBaHVwXRg-9hQiy==g@mail.gmail.com> <CANgfPd8Zrp+0vjhRbrycty2mhrv6VT1hCAA7ZRMhyOmHGskPfQ@mail.gmail.com>
In-Reply-To: <CANgfPd8Zrp+0vjhRbrycty2mhrv6VT1hCAA7ZRMhyOmHGskPfQ@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 3 Mar 2022 11:59:43 -0800
Message-ID: <CALzav=f+iS9n=54uVwFsfFoSeg36mJG2azrew8nLu+tyA-Mf_w@mail.gmail.com>
Subject: Re: [PATCH 21/23] KVM: x86/mmu: Fully split huge pages that require
 extra pte_list_desc structs
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 4:37 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Mon, Feb 28, 2022 at 3:41 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Mon, Feb 28, 2022 at 1:22 PM Ben Gardon <bgardon@google.com> wrote:
> > >
> > > On Wed, Feb 2, 2022 at 5:03 PM David Matlack <dmatlack@google.com> wrote:
> > > >
> > > > When splitting a huge page we need to add all of the lower level SPTEs
> > > > to the memslot rmap. The current implementation of eager page splitting
> > > > bails if adding an SPTE would require allocating an extra pte_list_desc
> > > > struct. Fix this limitation by allocating enough pte_list_desc structs
> > > > before splitting the huge page.
> > > >
> > > > This eliminates the need for TLB flushing under the MMU lock because the
> > > > huge page is always entirely split (no subregion of the huge page is
> > > > unmapped).
> > > >
> > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > ---
> > > >  arch/x86/include/asm/kvm_host.h |  10 ++++
> > > >  arch/x86/kvm/mmu/mmu.c          | 101 ++++++++++++++++++--------------
> > > >  2 files changed, 67 insertions(+), 44 deletions(-)
> > > >
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index d0b12bfe5818..a0f7578f7a26 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1232,6 +1232,16 @@ struct kvm_arch {
> > > >         hpa_t   hv_root_tdp;
> > > >         spinlock_t hv_root_tdp_lock;
> > > >  #endif
> > > > +
> > > > +       /*
> > > > +        * Memory cache used to allocate pte_list_desc structs while splitting
> > > > +        * huge pages. In the worst case, to split one huge page we need 512
> > > > +        * pte_list_desc structs to add each new lower level leaf sptep to the
> > > > +        * memslot rmap.
> > > > +        */
> > > > +#define HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY 512
> > > > +       __DEFINE_KVM_MMU_MEMORY_CACHE(huge_page_split_desc_cache,
> > > > +                                     HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY);
> > > >  };
> > > >
> > > >  struct kvm_vm_stat {
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 825cfdec589b..c7981a934237 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -5905,6 +5905,11 @@ void kvm_mmu_init_vm(struct kvm *kvm)
> > > >         node->track_write = kvm_mmu_pte_write;
> > > >         node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> > > >         kvm_page_track_register_notifier(kvm, node);
> > > > +
> > > > +       kvm->arch.huge_page_split_desc_cache.capacity =
> > > > +               HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY;
> > > > +       kvm->arch.huge_page_split_desc_cache.kmem_cache = pte_list_desc_cache;
> > > > +       kvm->arch.huge_page_split_desc_cache.gfp_zero = __GFP_ZERO;
> > > >  }
> > > >
> > > >  void kvm_mmu_uninit_vm(struct kvm *kvm)
> > > > @@ -6035,9 +6040,42 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> > > >                 kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> > > >  }
> > > >
> > > > +static int min_descs_for_split(const struct kvm_memory_slot *slot, u64 *huge_sptep)
> > > > +{
> > > > +       struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> > > > +       int split_level = huge_sp->role.level - 1;
> > > > +       int i, min = 0;
> > > > +       gfn_t gfn;
> > > > +
> > > > +       gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
> > > >
> > > > -static int alloc_memory_for_split(struct kvm *kvm, struct kvm_mmu_page **spp, gfp_t gfp)
> > > > +       for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> > > > +               if (rmap_need_new_pte_list_desc(slot, gfn, split_level))
> > > > +                       min++;
> > > > +
> > > > +               gfn += KVM_PAGES_PER_HPAGE(split_level);
> > > > +       }
> > > > +
> > > > +       return min;
> > > > +}
> > >
> > > Is this calculation worth doing? It seems like we're doing a lot of
> > > work here to calculate exactly how many pages we need to allocate, but
> > > if eager splitting we'll be doing this over and over again. It seems
> > > like it would be more efficient to just always fill the cache since
> > > any extra pages allocated to split one page can be used to split the
> > > next one.
> >
> > topup_huge_page_split_desc_cache() does fill the cache. This
> > calculation is just to determine the minimum number of objects needed
> > to split the next huge page, so that we can skip refilling the cache
> > when its unnecessary.
> >
> > I think you are suggesting we unconditionally topup the cache and
> > hard-code the min to 513 (the capacity of the cache)? That would
> > certainly allow us to drop this function (less code complexity) but
> > would result in extra unnecessary allocations. If the cost of those
> > allocations is negligible then I can see an argument for going with
> > your approach.
>
> Right, exactly.
> If you're eagerly splitting the entire EPT for a VM, then the number
> of extra allocations is bounded at 513 because memory allocated for
> one page can be used for the next one if not needed right?
> If you check how many you need on each pass, you'll be doing
> potentially O(pages split) extra work, so I suspect that
> unconditionally filling the cache will scale better.

Makes sense. I'll do some testing and see if we can drop this code. Thanks!

>
> >
> > >
> > > > +
> > > > +static int topup_huge_page_split_desc_cache(struct kvm *kvm, int min, gfp_t gfp)
> > > > +{
> > > > +       struct kvm_mmu_memory_cache *cache =
> > > > +               &kvm->arch.huge_page_split_desc_cache;
> > > > +
> > > > +       return __kvm_mmu_topup_memory_cache(cache, min, gfp);
> > > > +}
> > > > +
> > > > +static int alloc_memory_for_split(struct kvm *kvm, struct kvm_mmu_page **spp,
> > > > +                                 int min_descs, gfp_t gfp)
> > > >  {
> > > > +       int r;
> > > > +
> > > > +       r = topup_huge_page_split_desc_cache(kvm, min_descs, gfp);
> > > > +       if (r)
> > > > +               return r;
> > > > +
> > > >         if (*spp)
> > > >                 return 0;
> > > >
> > > > @@ -6050,9 +6088,9 @@ static int prepare_to_split_huge_page(struct kvm *kvm,
> > > >                                       const struct kvm_memory_slot *slot,
> > > >                                       u64 *huge_sptep,
> > > >                                       struct kvm_mmu_page **spp,
> > > > -                                     bool *flush,
> > > >                                       bool *dropped_lock)
> > > >  {
> > > > +       int min_descs = min_descs_for_split(slot, huge_sptep);
> > > >         int r = 0;
> > > >
> > > >         *dropped_lock = false;
> > > > @@ -6063,22 +6101,18 @@ static int prepare_to_split_huge_page(struct kvm *kvm,
> > > >         if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > > >                 goto drop_lock;
> > > >
> > > > -       r = alloc_memory_for_split(kvm, spp, GFP_NOWAIT | __GFP_ACCOUNT);
> > > > +       r = alloc_memory_for_split(kvm, spp, min_descs, GFP_NOWAIT | __GFP_ACCOUNT);
> > > >         if (r)
> > > >                 goto drop_lock;
> > > >
> > > >         return 0;
> > > >
> > > >  drop_lock:
> > > > -       if (*flush)
> > > > -               kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > > > -
> > > > -       *flush = false;
> > > >         *dropped_lock = true;
> > > >
> > > >         write_unlock(&kvm->mmu_lock);
> > > >         cond_resched();
> > > > -       r = alloc_memory_for_split(kvm, spp, GFP_KERNEL_ACCOUNT);
> > > > +       r = alloc_memory_for_split(kvm, spp, min_descs, GFP_KERNEL_ACCOUNT);
> > > >         write_lock(&kvm->mmu_lock);
> > > >
> > > >         return r;
> > > > @@ -6122,10 +6156,10 @@ static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
> > > >
> > > >  static int kvm_mmu_split_huge_page(struct kvm *kvm,
> > > >                                    const struct kvm_memory_slot *slot,
> > > > -                                  u64 *huge_sptep, struct kvm_mmu_page **spp,
> > > > -                                  bool *flush)
> > > > +                                  u64 *huge_sptep, struct kvm_mmu_page **spp)
> > > >
> > > >  {
> > > > +       struct kvm_mmu_memory_cache *cache;
> > > >         struct kvm_mmu_page *split_sp;
> > > >         u64 huge_spte, split_spte;
> > > >         int split_level, index;
> > > > @@ -6138,9 +6172,9 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
> > > >                 return -EOPNOTSUPP;
> > > >
> > > >         /*
> > > > -        * Since we did not allocate pte_list_desc_structs for the split, we
> > > > -        * cannot add a new parent SPTE to parent_ptes. This should never happen
> > > > -        * in practice though since this is a fresh SP.
> > > > +        * We did not allocate an extra pte_list_desc struct to add huge_sptep
> > > > +        * to split_sp->parent_ptes. An extra pte_list_desc struct should never
> > > > +        * be necessary in practice though since split_sp is brand new.
> > > >          *
> > > >          * Note, this makes it safe to pass NULL to __link_shadow_page() below.
> > > >          */
> > > > @@ -6151,6 +6185,7 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
> > > >
> > > >         split_level = split_sp->role.level;
> > > >         access = split_sp->role.access;
> > > > +       cache = &kvm->arch.huge_page_split_desc_cache;
> > > >
> > > >         for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> > > >                 split_sptep = &split_sp->spt[index];
> > > > @@ -6158,25 +6193,11 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
> > > >
> > > >                 BUG_ON(is_shadow_present_pte(*split_sptep));
> > > >
> > > > -               /*
> > > > -                * Since we did not allocate pte_list_desc structs for the
> > > > -                * split, we can't add a new SPTE that maps this GFN.
> > > > -                * Skipping this SPTE means we're only partially mapping the
> > > > -                * huge page, which means we'll need to flush TLBs before
> > > > -                * dropping the MMU lock.
> > > > -                *
> > > > -                * Note, this make it safe to pass NULL to __rmap_add() below.
> > > > -                */
> > > > -               if (rmap_need_new_pte_list_desc(slot, split_gfn, split_level)) {
> > > > -                       *flush = true;
> > > > -                       continue;
> > > > -               }
> > > > -
> > > >                 split_spte = make_huge_page_split_spte(
> > > >                                 huge_spte, split_level + 1, index, access);
> > > >
> > > >                 mmu_spte_set(split_sptep, split_spte);
> > > > -               __rmap_add(kvm, NULL, slot, split_sptep, split_gfn, access);
> > > > +               __rmap_add(kvm, cache, slot, split_sptep, split_gfn, access);
> > > >         }
> > > >
> > > >         /*
> > > > @@ -6222,7 +6243,6 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
> > > >         struct kvm_mmu_page *sp = NULL;
> > > >         struct rmap_iterator iter;
> > > >         u64 *huge_sptep, spte;
> > > > -       bool flush = false;
> > > >         bool dropped_lock;
> > > >         int level;
> > > >         gfn_t gfn;
> > > > @@ -6237,7 +6257,7 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
> > > >                 level = sptep_to_sp(huge_sptep)->role.level;
> > > >                 gfn = sptep_to_gfn(huge_sptep);
> > > >
> > > > -               r = prepare_to_split_huge_page(kvm, slot, huge_sptep, &sp, &flush, &dropped_lock);
> > > > +               r = prepare_to_split_huge_page(kvm, slot, huge_sptep, &sp, &dropped_lock);
> > > >                 if (r) {
> > > >                         trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
> > > >                         break;
> > > > @@ -6246,7 +6266,7 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
> > > >                 if (dropped_lock)
> > > >                         goto restart;
> > > >
> > > > -               r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp, &flush);
> > > > +               r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp);
> > > >
> > > >                 trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
> > > >
> > > > @@ -6261,7 +6281,7 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
> > > >         if (sp)
> > > >                 kvm_mmu_free_sp(sp);
> > > >
> > > > -       return flush;
> > > > +       return false;
> > > >  }
> > > >
> > > >  static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
> > > > @@ -6269,7 +6289,6 @@ static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
> > > >                                           gfn_t start, gfn_t end,
> > > >                                           int target_level)
> > > >  {
> > > > -       bool flush;
> > > >         int level;
> > > >
> > > >         /*
> > > > @@ -6277,21 +6296,15 @@ static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
> > > >          * down to the target level. This ensures pages are recursively split
> > > >          * all the way to the target level. There's no need to split pages
> > > >          * already at the target level.
> > > > -        *
> > > > -        * Note that TLB flushes must be done before dropping the MMU lock since
> > > > -        * rmap_try_split_huge_pages() may partially split any given huge page,
> > > > -        * i.e. it may effectively unmap (make non-present) a portion of the
> > > > -        * huge page.
> > > >          */
> > > >         for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
> > > > -               flush = slot_handle_level_range(kvm, slot,
> > > > -                                               rmap_try_split_huge_pages,
> > > > -                                               level, level, start, end - 1,
> > > > -                                               true, flush);
> > > > +               slot_handle_level_range(kvm, slot,
> > > > +                                       rmap_try_split_huge_pages,
> > > > +                                       level, level, start, end - 1,
> > > > +                                       true, false);
> > > >         }
> > > >
> > > > -       if (flush)
> > > > -               kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > > > +       kvm_mmu_free_memory_cache(&kvm->arch.huge_page_split_desc_cache);
> > > >  }
> > > >
> > > >  /* Must be called with the mmu_lock held in write-mode. */
> > > > --
> > > > 2.35.0.rc2.247.g8bbb082509-goog
> > > >
