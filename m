Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D9E65CACB
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 01:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238629AbjADA1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 19:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238878AbjADA0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 19:26:50 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3780217078
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 16:26:37 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-46198b81e5eso458625837b3.4
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 16:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=02mnvKjkhi+xqLep6DzPBxrzeHbprJIX5INEltwEFXw=;
        b=gGZg55l1b1mZlnDCLtatnvQwmQA2FRB/ktmm4UXYdg3wvFnQvOi/QtzqCUUhsOkM6W
         M1beO67ciuMC/B1h85YFSncgsD3ZtKbyo5hCbHy1p20qReZJ+j8iX2qrwak8oez851MV
         WnhPvutG+SWH90aVJZBoRZZRCM2re1Q5hGgzN6C+EJlcw8hGZp+xrNjQdKNjldmafBTq
         Mu1lwd+147Nm8CYZEnKvXH//t4Myg1IMeIyuBk1kW6sqp4R4VDVbUl/pP6cqjsKgDBIF
         6040jlc1umqQE/yCj11drvRRkWjtlErx0+/S+yrG4OF0X5ZDJuQorJurH83YbEfEdkrh
         g+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=02mnvKjkhi+xqLep6DzPBxrzeHbprJIX5INEltwEFXw=;
        b=gxNPv5GycuaXSTVTf8WjekbnYEgndjlQn5IOiHrJcI+vTd3z7AX6LjrRkfp8osffOV
         x+mGgzsEfUNtH96zDWv0dyamIqdNQbX1DaoXF1AphEPY088buTXEPvFofQHj/G+cwOjf
         uqY/scgM8UAfdxHH456nUY29OMmf3Im82CVfX7g7v/c94s8UjpWZCKp8wEUPbKVHm1+F
         4vJEUjQsb32jZ45jyy9QuDVc0e+RknHITomLFur0N+JqYfAfBEn7fQhSsyy3eE+HUx+a
         6RieP0kbGRTwnDlX0wTQNNblPccfnqq/3tR5gHP/M67dJihHbMXmX5YZHI0eHBFlId36
         USMg==
X-Gm-Message-State: AFqh2kqlytkbNFFWNUG6P/0ePjsUwcAcueWPeztAbeR815U4Rh+jcSmP
        7Yb77hCNCXqeEFZ/bauL/zol4MgjXFhcf6hqlu49TA==
X-Google-Smtp-Source: AMrXdXsRncjs155iDBzmCdCkR0Og3SGOHrZ62e2qaHcfaYHvZ/YWeTsIDl7qRKcnpHiZjrZYaClIUnmR+hbn1NE4d/4=
X-Received: by 2002:a81:1605:0:b0:475:d2f4:6522 with SMTP id
 5-20020a811605000000b00475d2f46522mr4693939yww.120.1672791996047; Tue, 03 Jan
 2023 16:26:36 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-2-vipinsh@google.com>
 <Y64MsBubSyPNmMyk@google.com> <CAHVum0efBBe+OEiJw1-L+F1R8d-xPanAKjktgkg7Q2SXDot+KQ@mail.gmail.com>
In-Reply-To: <CAHVum0efBBe+OEiJw1-L+F1R8d-xPanAKjktgkg7Q2SXDot+KQ@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 3 Jan 2023 16:25:59 -0800
Message-ID: <CAHVum0cZtDYZN2bD3TZgUNpcWiy2-Qkw1mb40syut_2kkR=Agg@mail.gmail.com>
Subject: Re: [Patch v3 1/9] KVM: x86/mmu: Repurpose KVM MMU shrinker to purge
 shadow page caches
To:     David Matlack <dmatlack@google.com>, seanjc@google.com,
        pbonzini@redhat.com
Cc:     bgardon@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 3, 2023 at 10:01 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Thu, Dec 29, 2022 at 1:55 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, Dec 21, 2022 at 06:34:49PM -0800, Vipin Sharma wrote:
> > > mmu_shrink_scan() is very disruptive to VMs. It picks the first
> > > VM in the vm_list, zaps the oldest page which is most likely an upper
> > > level SPTEs and most like to be reused. Prior to TDP MMU, this is even
> > > more disruptive in nested VMs case, considering L1 SPTEs will be the
> > > oldest even though most of the entries are for L2 SPTEs.
> > >
> > > As discussed in
> > > https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/
> > > shrinker logic has not be very useful in actually keeping VMs performant
> > > and reducing memory usage.
> > >
> > > Change mmu_shrink_scan() to free pages from the vCPU's shadow page
> > > cache.  Freeing pages from cache doesn't cause vCPU exits, therefore, a
> > > VM's performance should not be affected.
> >
> > Can you split this commit up? e.g. First drop the old shrinking logic in
> > one commit (but leave the shrinking infrastructure in place). Then a
> > commit to make the shrinker free the per-vCPU shadow page caches. And
> > then perhaps another to make the shrinker free the per-VM shadow page
> > cache used for eager splitting.
> >
>
> Sounds good, I will separate it in two parts, one for dropping old
> logic, one for adding per vcpu shadow page caches. Patch 3 is enabling
> shrinkerto free per-VM shadow page.
>
> > >
> > > This also allows to change cache capacities without worrying too much
> > > about high memory usage in cache.
> > >
> > > Tested this change by running dirty_log_perf_test while dropping cache
> > > via "echo 2 > /proc/sys/vm/drop_caches" at 1 second interval
> > > continuously. There were WARN_ON(!mc->nobjs) messages printed in kernel
> > > logs from kvm_mmu_memory_cache_alloc(), which is expected.
> > >
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h |   5 +
> > >  arch/x86/kvm/mmu/mmu.c          | 163 +++++++++++++++++++-------------
> > >  arch/x86/kvm/mmu/mmu_internal.h |   2 +
> > >  arch/x86/kvm/mmu/tdp_mmu.c      |   3 +-
> > >  include/linux/kvm_host.h        |   1 +
> > >  virt/kvm/kvm_main.c             |  11 ++-
> > >  6 files changed, 114 insertions(+), 71 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index aa4eb8cfcd7e..89cc809e4a00 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -786,6 +786,11 @@ struct kvm_vcpu_arch {
> > >       struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
> > >       struct kvm_mmu_memory_cache mmu_page_header_cache;
> > >
> > > +     /*
> > > +      * Protects change in size of mmu_shadow_page_cache cache.
> > > +      */
> > > +     spinlock_t mmu_shadow_page_cache_lock;
> > > +
> > >       /*
> > >        * QEMU userspace and the guest each have their own FPU state.
> > >        * In vcpu_run, we switch between the user and guest FPU contexts.
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 254bc46234e0..157417e1cb6e 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -164,7 +164,10 @@ struct kvm_shadow_walk_iterator {
> > >
> > >  static struct kmem_cache *pte_list_desc_cache;
> > >  struct kmem_cache *mmu_page_header_cache;
> > > -static struct percpu_counter kvm_total_used_mmu_pages;
> > > +/*
> > > + * Total number of unused pages in MMU shadow page cache.
> > > + */
> > > +static struct percpu_counter kvm_total_unused_mmu_pages;
> > >
> > >  static void mmu_spte_set(u64 *sptep, u64 spte);
> > >
> > > @@ -655,6 +658,22 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> > >       }
> > >  }
> > >
> > > +static int mmu_topup_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
> > > +                                  spinlock_t *cache_lock)
> > > +{
> > > +     int orig_nobjs;
> > > +     int r;
> > > +
> > > +     spin_lock(cache_lock);
> > > +     orig_nobjs = cache->nobjs;
> > > +     r = kvm_mmu_topup_memory_cache(cache, PT64_ROOT_MAX_LEVEL);
> > > +     if (orig_nobjs != cache->nobjs)
> > > +             percpu_counter_add(&kvm_total_unused_mmu_pages,
> > > +                                (cache->nobjs - orig_nobjs));
> > > +     spin_unlock(cache_lock);
> > > +     return r;
> > > +}
> > > +
> > >  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> > >  {
> > >       int r;
> > > @@ -664,8 +683,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> > >                                      1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
> > >       if (r)
> > >               return r;
> > > -     r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> > > -                                    PT64_ROOT_MAX_LEVEL);
> > > +     r = mmu_topup_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> > > +                                   &vcpu->arch.mmu_shadow_page_cache_lock);
> > >       if (r)
> > >               return r;
> > >       if (maybe_indirect) {
> > > @@ -678,10 +697,25 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> > >                                         PT64_ROOT_MAX_LEVEL);
> > >  }
> > >
> > > +static void mmu_free_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
> > > +                                  spinlock_t *cache_lock)
> > > +{
> > > +     int orig_nobjs;
> > > +
> > > +     spin_lock(cache_lock);
> > > +     orig_nobjs = cache->nobjs;
> > > +     kvm_mmu_free_memory_cache(cache);
> > > +     if (orig_nobjs)
> > > +             percpu_counter_sub(&kvm_total_unused_mmu_pages, orig_nobjs);
> > > +
> > > +     spin_unlock(cache_lock);
> > > +}
> >
> > It would be nice to avoid adding these wrapper functions.
> >
> > Once you add a mutex to protect the caches from being freed while vCPUs
> > are in the middle of a page fault you can drop the spin lock. After that
> > the only reason to have these wrappers is to update
> > kvm_total_unused_mmu_pages.
> >
> > Do we really need kvm_total_unused_mmu_pages? Why not just dynamically
> > calculate the number of of unused pages in mmu_shrink_count()? Or just
> > estimate the count, e.g. num_vcpus * KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE?
> > Or have per-VM or per-vCPU shrinkers to avoid needing to do any
> > aggregation?
> >
>
> I think we can drop this, by default we can return num_kvms *
> num_vcpus * nodes * KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>
> Whenever mmu_shrink_scan() is called if there are no pages to free
> then return SHRINK_STOP which will stop any subsequent calls during
> that time.
>
>
> > > +
> > >  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> > >  {
> > >       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> > > -     kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> > > +     mmu_free_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> > > +                              &vcpu->arch.mmu_shadow_page_cache_lock);
> > >       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
> >
> > mmu_shadowed_info_cache can be freed by the shrinker as well.
> >

Yes, I can do that as well.

> > >       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
> > >  }
> > > @@ -1693,27 +1727,15 @@ static int is_empty_shadow_page(u64 *spt)
> > >  }
> > >  #endif
> > >
> > > -/*
> > > - * This value is the sum of all of the kvm instances's
> > > - * kvm->arch.n_used_mmu_pages values.  We need a global,
> > > - * aggregate version in order to make the slab shrinker
> > > - * faster
> > > - */
> > > -static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
> > > -{
> > > -     kvm->arch.n_used_mmu_pages += nr;
> > > -     percpu_counter_add(&kvm_total_used_mmu_pages, nr);
> > > -}
> > > -
> > >  static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > >  {
> > > -     kvm_mod_used_mmu_pages(kvm, +1);
> > > +     kvm->arch.n_used_mmu_pages++;
> > >       kvm_account_pgtable_pages((void *)sp->spt, +1);
> > >  }
> > >
> > >  static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > >  {
> > > -     kvm_mod_used_mmu_pages(kvm, -1);
> > > +     kvm->arch.n_used_mmu_pages--;
> > >       kvm_account_pgtable_pages((void *)sp->spt, -1);
> > >  }
> > >
> > > @@ -2150,8 +2172,31 @@ struct shadow_page_caches {
> > >       struct kvm_mmu_memory_cache *page_header_cache;
> > >       struct kvm_mmu_memory_cache *shadow_page_cache;
> > >       struct kvm_mmu_memory_cache *shadowed_info_cache;
> > > +     /*
> > > +      * Protects change in size of shadow_page_cache cache.
> > > +      */
> > > +     spinlock_t *shadow_page_cache_lock;
> > >  };
> > >
> > > +void *kvm_mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *shadow_page_cache,
> > > +                                 spinlock_t *cache_lock)
> > > +{
> > > +     int orig_nobjs;
> > > +     void *page;
> > > +
> > > +     if (!cache_lock) {
> > > +             spin_lock(cache_lock);
> > > +             orig_nobjs = shadow_page_cache->nobjs;
> > > +     }
> > > +     page = kvm_mmu_memory_cache_alloc(shadow_page_cache);
> > > +     if (!cache_lock) {
> > > +             if (orig_nobjs)
> > > +                     percpu_counter_dec(&kvm_total_unused_mmu_pages);
> > > +             spin_unlock(cache_lock);
> > > +     }
> > > +     return page;
> > > +}
> > > +
> > >  static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
> > >                                                     struct shadow_page_caches *caches,
> > >                                                     gfn_t gfn,
> > > @@ -2161,7 +2206,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
> > >       struct kvm_mmu_page *sp;
> > >
> > >       sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
> > > -     sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
> > > +     sp->spt = kvm_mmu_sp_memory_cache_alloc(caches->shadow_page_cache,
> > > +                                             caches->shadow_page_cache_lock);
> > >       if (!role.direct)
> > >               sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
> > >
> > > @@ -2218,6 +2264,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
> > >               .page_header_cache = &vcpu->arch.mmu_page_header_cache,
> > >               .shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache,
> > >               .shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
> > > +             .shadow_page_cache_lock = &vcpu->arch.mmu_shadow_page_cache_lock
> > >       };
> > >
> > >       return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
> > > @@ -5916,6 +5963,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> > >       vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> > >
> > >       vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> > > +     spin_lock_init(&vcpu->arch.mmu_shadow_page_cache_lock);
> > >
> > >       vcpu->arch.mmu = &vcpu->arch.root_mmu;
> > >       vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> > > @@ -6051,11 +6099,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
> > >               kvm_tdp_mmu_zap_invalidated_roots(kvm);
> > >  }
> > >
> > > -static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> > > -{
> > > -     return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
> > > -}
> > > -
> > >  static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> > >                       struct kvm_memory_slot *slot,
> > >                       struct kvm_page_track_notifier_node *node)
> > > @@ -6277,6 +6320,7 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
> > >       /* Direct SPs do not require a shadowed_info_cache. */
> > >       caches.page_header_cache = &kvm->arch.split_page_header_cache;
> > >       caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
> > > +     caches.shadow_page_cache_lock = NULL;
> > >
> > >       /* Safe to pass NULL for vCPU since requesting a direct SP. */
> > >       return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
> > > @@ -6646,66 +6690,49 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
> > >  static unsigned long
> > >  mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> > >  {
> > > -     struct kvm *kvm;
> > > -     int nr_to_scan = sc->nr_to_scan;
> > > +     struct kvm_mmu_memory_cache *cache;
> > > +     struct kvm *kvm, *first_kvm = NULL;
> > >       unsigned long freed = 0;
> > > +     /* spinlock for memory cache */
> > > +     spinlock_t *cache_lock;
> > > +     struct kvm_vcpu *vcpu;
> > > +     unsigned long i;
> > >
> > >       mutex_lock(&kvm_lock);
> > >
> > >       list_for_each_entry(kvm, &vm_list, vm_list) {
> > > -             int idx;
> > > -             LIST_HEAD(invalid_list);
> > > -
> > > -             /*
> > > -              * Never scan more than sc->nr_to_scan VM instances.
> > > -              * Will not hit this condition practically since we do not try
> > > -              * to shrink more than one VM and it is very unlikely to see
> > > -              * !n_used_mmu_pages so many times.
> > > -              */
> > > -             if (!nr_to_scan--)
> > > +             if (first_kvm == kvm)
> > >                       break;
> > > -             /*
> > > -              * n_used_mmu_pages is accessed without holding kvm->mmu_lock
> > > -              * here. We may skip a VM instance errorneosly, but we do not
> > > -              * want to shrink a VM that only started to populate its MMU
> > > -              * anyway.
> > > -              */
> > > -             if (!kvm->arch.n_used_mmu_pages &&
> > > -                 !kvm_has_zapped_obsolete_pages(kvm))
> > > -                     continue;
> > > +             if (!first_kvm)
> > > +                     first_kvm = kvm;
> > > +             list_move_tail(&kvm->vm_list, &vm_list);
> > >
> > > -             idx = srcu_read_lock(&kvm->srcu);
> > > -             write_lock(&kvm->mmu_lock);
> > > +             kvm_for_each_vcpu(i, vcpu, kvm) {
> >
> > What protects this from racing with vCPU creation/deletion?
> >

vCPU deletion:
We take kvm_lock in mmu_shrink_scan(), the same lock is taken in
kvm_destroy_vm() to remove a vm from vm_list. So, once we are
iterating vm_list we will not see any VM removal which will means no
vcpu removal.

I didn't find any other code for vCPU deletion except failures during
VM and VCPU set up. A VM is only added to vm_list after successful
creation.

vCPU creation:
I think it will work.

kvm_vm_ioctl_create_vcpus() initializes the vcpu, adds it to
kvm->vcpu_array which is of the type xarray and is managed by RCU.
After this online_vcpus is incremented. So, kvm_for_each_vcpu() which
uses RCU to read entries, if it sees incremented online_vcpus value
then it will also sees all of the vcpu initialization.

@Sean, Paolo

Is the above explanation correct, kvm_for_each_vcpu() is safe without any lock?

> > > +                     cache = &vcpu->arch.mmu_shadow_page_cache;
> > > +                     cache_lock = &vcpu->arch.mmu_shadow_page_cache_lock;
> > > +                     if (READ_ONCE(cache->nobjs)) {
> > > +                             spin_lock(cache_lock);
> > > +                             freed += kvm_mmu_empty_memory_cache(cache);
> > > +                             spin_unlock(cache_lock);
> > > +                     }
> >
> > What about freeing kvm->arch.split_shadow_page_cache as well?
> >

I am doing this in patch 3.

> > >
> > > -             if (kvm_has_zapped_obsolete_pages(kvm)) {
> > > -                     kvm_mmu_commit_zap_page(kvm,
> > > -                           &kvm->arch.zapped_obsolete_pages);
> > > -                     goto unlock;
> > >               }
> > >
> > > -             freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
> > > -
> > > -unlock:
> > > -             write_unlock(&kvm->mmu_lock);
> > > -             srcu_read_unlock(&kvm->srcu, idx);
> > > -
> > > -             /*
> > > -              * unfair on small ones
> > > -              * per-vm shrinkers cry out
> > > -              * sadness comes quickly
> > > -              */
> > > -             list_move_tail(&kvm->vm_list, &vm_list);
> > > -             break;
> > > +             if (freed >= sc->nr_to_scan)
> > > +                     break;
> > >       }
> > >
> > > +     if (freed)
> > > +             percpu_counter_sub(&kvm_total_unused_mmu_pages, freed);
> > >       mutex_unlock(&kvm_lock);
> > > +     percpu_counter_sync(&kvm_total_unused_mmu_pages);
> > >       return freed;
> > >  }
> > >
> > >  static unsigned long
> > >  mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
> > >  {
> > > -     return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
> > > +     return percpu_counter_sum_positive(&kvm_total_unused_mmu_pages);
> > >  }
> > >
> > >  static struct shrinker mmu_shrinker = {
> > > @@ -6820,7 +6847,7 @@ int kvm_mmu_vendor_module_init(void)
> > >       if (!mmu_page_header_cache)
> > >               goto out;
> > >
> > > -     if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
> > > +     if (percpu_counter_init(&kvm_total_unused_mmu_pages, 0, GFP_KERNEL))
> > >               goto out;
> > >
> > >       ret = register_shrinker(&mmu_shrinker, "x86-mmu");
> > > @@ -6830,7 +6857,7 @@ int kvm_mmu_vendor_module_init(void)
> > >       return 0;
> > >
> > >  out_shrinker:
> > > -     percpu_counter_destroy(&kvm_total_used_mmu_pages);
> > > +     percpu_counter_destroy(&kvm_total_unused_mmu_pages);
> > >  out:
> > >       mmu_destroy_caches();
> > >       return ret;
> > > @@ -6847,7 +6874,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
> > >  void kvm_mmu_vendor_module_exit(void)
> > >  {
> > >       mmu_destroy_caches();
> > > -     percpu_counter_destroy(&kvm_total_used_mmu_pages);
> > > +     percpu_counter_destroy(&kvm_total_unused_mmu_pages);
> > >       unregister_shrinker(&mmu_shrinker);
> > >  }
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > > index ac00bfbf32f6..c2a342028b6a 100644
> > > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > > @@ -325,4 +325,6 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> > >  void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> > >  void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> > >
> > > +void *kvm_mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *shadow_page_cache,
> > > +                                 spinlock_t *cache_lock);
> > >  #endif /* __KVM_X86_MMU_INTERNAL_H */
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 764f7c87286f..4974fa96deff 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -264,7 +264,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
> > >       struct kvm_mmu_page *sp;
> > >
> > >       sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > > -     sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > > +     sp->spt = kvm_mmu_sp_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache,
> > > +                                             &vcpu->arch.mmu_shadow_page_cache_lock);
> > >
> > >       return sp;
> > >  }
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 01aad8b74162..efd9b38ea9a2 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -1362,6 +1362,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
> > >  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> > >  int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);
> > >  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
> > > +int kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc);
> > >  void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
> > >  void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> > >  #endif
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 13e88297f999..f2d762878b97 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -438,8 +438,10 @@ int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
> > >       return mc->nobjs;
> > >  }
> > >
> > > -void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> > > +int kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc)
> > >  {
> > > +     int freed = mc->nobjs;
> > > +
> > >       while (mc->nobjs) {
> > >               if (mc->kmem_cache)
> > >                       kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
> > > @@ -447,8 +449,13 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> > >                       free_page((unsigned long)mc->objects[--mc->nobjs]);
> > >       }
> > >
> > > -     kvfree(mc->objects);
> > > +     return freed;
> > > +}
> > >
> > > +void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> > > +{
> > > +     kvm_mmu_empty_memory_cache(mc);
> > > +     kvfree(mc->objects);
> > >       mc->objects = NULL;
> > >       mc->capacity = 0;
> > >  }
> > > --
> > > 2.39.0.314.g84b9a713c41-goog
> > >
