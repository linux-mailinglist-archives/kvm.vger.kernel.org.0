Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3D4647900
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 23:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiLHWpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 17:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiLHWpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 17:45:34 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA3C78BB0
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 14:45:32 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3e45d25de97so31260337b3.6
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 14:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4hng1VfGQ3OFYRasuE9ueI1rvZnLW0A5liApM0Pedj0=;
        b=T8+kN5wBAMJg+qs32fQKCFpkkqoGUVOryGOvKhm1Zgmb4x4gsAzBDSY+KOkgeikfen
         OGtIlKqN343mBSM6nhT/GdseSTJo4NtWrpQLN+UfarU1MYQyRHoj6pGDAmqptvZ3EBeB
         Bp6m0XE9yMujSX6MIK8zsC8VyQ8YvAR3AHIpXieaBUtTtmbLkBaIkRo1ebYgfE4B5FuQ
         7fKVInZ/jcfOIGQUPsb2/cLQks6f349U5T3bG7nc0ktF0q38VUJaHmBZieYGqPLTupNT
         R2T6JyXmQb8hJuHWXr6ey4/esc0V8Y3BQ130xSIFEysilCIoJ23Ui0cCh70FuYL3mhMm
         7UVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4hng1VfGQ3OFYRasuE9ueI1rvZnLW0A5liApM0Pedj0=;
        b=IFwcwS0rA/TVrUqfznTlsSKEZBFtN7hNDxmh7FlnrjWkYB7baiveDyhrojsgxffPcm
         7O6Gm8mJDS7BwXAzRQGdEk6bsubHpBOYhfBLQykNw2e5086h3C/O0y3ygL+izb30tm9F
         7oUtNZU5MY8n6V9cQey+Ps1p5QQ5vzr1iFst/5HaPvNnaMSFNWfR0CcZtV6utrD231Hk
         fK7PT2CmkN8EDxM0GLv3cIHRXzCQHLC5pza8vodDA2U51mHJ6JvOaOBFSJdnsowoH3/i
         5kr4iAac+Ai1x6pMovFobQKRonsSbogCihoQ4okgCHMW0i02lLHQgcx2LTtuBijeJs7h
         QvKw==
X-Gm-Message-State: ANoB5pkImtLflfxfcni29Sc+igKghIcK+vNG2irRCB2q6T45b3MnNvOm
        WpALVRSmpCgFIzGHcEJDGBqdkDwGkhL6j9ecpTbOBQ==
X-Google-Smtp-Source: AA0mqf76cVFrQyHROjizxFGLHHf+hQXQa//OlimyfH9+StrPeuPgXHihp5u4ACkxi2OA0k+yyiszIoo/4MYPGomja/A=
X-Received: by 2002:a0d:dd8a:0:b0:391:c415:f872 with SMTP id
 g132-20020a0ddd8a000000b00391c415f872mr7483891ywe.318.1670539531335; Thu, 08
 Dec 2022 14:45:31 -0800 (PST)
MIME-Version: 1.0
References: <20221201195718.1409782-1-vipinsh@google.com> <20221201195718.1409782-2-vipinsh@google.com>
 <CANgfPd_sZoW6gRNgs44BbBu4RhwqNPjUO-=biJ++L5d8LpU3zg@mail.gmail.com>
 <Y4481WPLstNidb9X@google.com> <CANgfPd_Ya0TeSBp5ipseA3fT1C0L3NPGSaZ=0ACjyKa_PvrZxA@mail.gmail.com>
 <Y45dldZnI6OIf+a5@google.com>
In-Reply-To: <Y45dldZnI6OIf+a5@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 8 Dec 2022 14:44:55 -0800
Message-ID: <CAHVum0cjqsdG2NEjRF3ZRtUY2t2=Tb9H4OyOz9wpmsrN--Sjhg@mail.gmail.com>
Subject: Re: [Patch v2 1/2] KVM: x86/mmu: Allocate page table pages on TDP
 splits during dirty log enable on the underlying page's numa node
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, dmatlack@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
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

On Mon, Dec 5, 2022 at 1:07 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 05, 2022, Ben Gardon wrote:
> > On Mon, Dec 5, 2022 at 10:47 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > > +static bool __read_mostly numa_aware_pagetable = true;
> > > > > +module_param_named(numa_aware_pagetable, numa_aware_pagetable, bool, 0644);
> > > > > +
> > > >
> > > > I'm usually all for having module params to control things, but in
> > > > this case I don't think it provides much value because whether this
> > > > NUMA optimization is useful or not is going to depend more on VM size
> > > > and workload than anything else. If we wanted to make this
> > > > configurable, a VM capability would probably be a better mechanism so
> > > > that userspace could leave it off when running small,
> > > > non-performance-sensitive VMs
> > >
> > > Would we actually want to turn it off in this case?  IIUC, @nid is just the
> > > preferred node, i.e. failure to allocate for the preferred @nid will result in
> > > falling back to other nodes, not outright failure.  So the pathological worst
> > > case scenario would be that for a system with VMs that don't care about performance,
> > > all of a nodes memory is allocated due to all VMs starting on that node.
> > >
> > > On the flip side, if a system had a mix of VM shapes, I think we'd want even the
> > > performance insensitive VMs to be NUMA aware so that they can be sequestered on
> > > their own node(s), i.e. don't "steal" memory from the VMs that are performance
> > > sensitive and have been affined to a single node.
> >
> > Yeah, the only reason to turn it off would be to save memory. As a
> > strawman, if you had 100 1-vCPU VMs on a 2 node system, you'd have
> > 4000 pages allocated in caches, doing nothing.
>

I will keep it as a module parameter for now as Sean noted we don't
want insensitive VMs to impact the performance sensitive VMs. Also, as
noted below, changing shrinker behaviour to free cache will allow to
reclaim memory of unused node.

If there is a better reason for using capability let me know we can
discuss more about it.

> The management of the caches really should be addressed separately, and this is
> the perfect excuse to finally get some traction on mmu_shrink_scan().
>
> From a while back[1]:
>
>  : I know we proposed dropping mmu_shrink_scan(), but the more I think about that,
>  : the more I think that an outright drop is wrong.  The real issue is that KVM as
>  : quite literally the dumbest possible "algorithm" for zapping possibly-in-use
>  : shadow pages, and doesn't target the zapping to fit the cgroup that's under
>  : pressure.
>  :
>  : So for this, IMO rather than assume that freeing the caches when any memslot
>  : disables dirty logging, I think it makes sense to initially keep the caches and
>  : only free them at VM destruction.  Then in follow-up patches, if we want, free
>  : the caches in the mmu_shrink_scan(), and/or add a function hook for toggling
>  : eager_page_split to topup/free the caches accordingly.  That gives userspace
>  : explicit control over when the caches are purged, and does the logical thing of
>  : freeing the caches when eager_page_split is disabled.
>
> The current mmu_shrink_scan() implementation is basically useless.  It's so naive
> that relying on it to react to memory pressure all but guarantees that guest
> performance will tank if the shrinker kicks in.  E.g. KVM zaps the oldest pages,
> which are likely upper level SPTEs and thus most likely to be reused.  And prior
> to the TDP MMU, a guest running nested VMs would more than likely zap L1's SPTEs
> even if the majority of shadow pages were allocated for L2.
>
> And as pointed out in the RFC to drop shrinker support entirely[1], for well over
> a decade KVM zapped a single page in each call from the shrinker, i.e. it was
> _really_ useless.  And although in [1] I said adding memcg would be easy, doing
> so in a performant way would be quite difficult as the per-cpu counter would need
> to be made memcg aware (didn't think about that before).
>
> Lastly, given that I completely broke the shrink logic for ~6 months and someone
> only noticed when n_max_mmu_pages kicked in (commit 8fc517267fb2 "KVM: x86: Zap
> the oldest MMU pages, not the newest"), I highly doubt anyone is relying on the
> current shrinker logic, i.e. KVM_SET_NR_MMU_PAGES is used for setups that actually
> need to limit the number of MMU pages beyond KVM's default.
>
> My vote is to do something like the below: repurpose KVM's shrinker integration
> to only purge the shadow page caches.  That can be done with almost no impact on
> guest performance, e.g. with a dedicated spinlock, reclaiming from the caches
> wouldn't even need to kick the vCPU.  Supporting reclaim of the caches would allow
> us to change the cache capacity and/or behavior without having to worry too much
> about exploding memory, and would make KVM's shrinker support actually usable.
>
> [1] https://lore.kernel.org/all/YqzRGj6ryBZfGBSl@google.com
> [2] https://lore.kernel.org/all/20220503221357.943536-1-vipinsh@google.com
>

As discussed offline.
1. I will create a patch in this series which changes the behaviour of
shrinker by freeing the cache.

2. One suggestion came up was to fill the cache of the correct node
only in the topup stage by using the PFN after kvm_faulin_pfn(). We
decided it is not good because mmu_topup_memory_cache() cannot be
called after kvm_faultin_pf() as topup will increase the time between
reading the mmu_invalidate_seq and checking it in
is_page_fault_stale() which will increase chances of retrying page
fault and reducing the guest performance.

3. I will reduce the cache size and try to see if there is any impact observed.

> ---
>  arch/x86/include/asm/kvm_host.h |   2 +
>  arch/x86/kvm/mmu/mmu.c          | 131 ++++++++++++++++----------------
>  2 files changed, 69 insertions(+), 64 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 283cbb83d6ae..f123bd985e1a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -786,6 +786,8 @@ struct kvm_vcpu_arch {
>         struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
>         struct kvm_mmu_memory_cache mmu_page_header_cache;
>
> +       spinlock_t mmu_shadow_page_cache_lock;
> +
>         /*
>          * QEMU userspace and the guest each have their own FPU state.
>          * In vcpu_run, we switch between the user and guest FPU contexts.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4736d7849c60..fca74cb1f2ce 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -157,7 +157,12 @@ struct kvm_shadow_walk_iterator {
>
>  static struct kmem_cache *pte_list_desc_cache;
>  struct kmem_cache *mmu_page_header_cache;
> -static struct percpu_counter kvm_total_used_mmu_pages;
> +
> +/*
> + * The total number of allocated, unused MMU pages, i.e. the total number of
> + * unused pages sitting in kvm_mmu_memory_cache structures.
> + */
> +static struct percpu_counter kvm_total_unused_mmu_pages;
>
>  static void mmu_spte_set(u64 *sptep, u64 spte);
>
> @@ -643,6 +648,23 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         }
>  }
>
> +static int kvm_mmu_topup_sp_cache(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_mmu_memory_cache *cache = &vcpu->arch.mmu_shadow_page_cache;
> +       int orig_nobjs = cache->nobjs;
> +       int r;
> +
> +       spin_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
> +       r = kvm_mmu_topup_memory_cache(cache, PT64_ROOT_MAX_LEVEL);
> +
> +       if (cache->nobjs != orig_nobjs)
> +               percpu_counter_add(&kvm_total_unused_mmu_pages,
> +                                  cache->nobjs - orig_nobjs);
> +       spin_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
> +
> +       return r;
> +}
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>         int r;
> @@ -652,10 +674,11 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>                                        1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>         if (r)
>                 return r;
> -       r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -                                      PT64_ROOT_MAX_LEVEL);
> +
> +       r = kvm_mmu_topup_sp_cache(vcpu);
>         if (r)
>                 return r;
> +
>         if (maybe_indirect) {
>                 r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadowed_info_cache,
>                                                PT64_ROOT_MAX_LEVEL);
> @@ -1681,28 +1704,23 @@ static int is_empty_shadow_page(u64 *spt)
>  }
>  #endif
>
> -/*
> - * This value is the sum of all of the kvm instances's
> - * kvm->arch.n_used_mmu_pages values.  We need a global,
> - * aggregate version in order to make the slab shrinker
> - * faster
> - */
> -static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
> -{
> -       kvm->arch.n_used_mmu_pages += nr;
> -       percpu_counter_add(&kvm_total_used_mmu_pages, nr);
> -}
> -
>  static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -       kvm_mod_used_mmu_pages(kvm, +1);
> +       kvm->arch.n_used_mmu_pages++;
>         kvm_account_pgtable_pages((void *)sp->spt, +1);
> +
> +       percpu_counter_dec(&kvm_total_unused_mmu_pages);
>  }
>
>  static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -       kvm_mod_used_mmu_pages(kvm, -1);
> +       kvm->arch.n_used_mmu_pages--;
>         kvm_account_pgtable_pages((void *)sp->spt, -1);
> +
> +       /*
> +        * KVM doesn't put freed pages back into the cache, thus freeing a page
> +        * doesn't affect the number of unused MMU pages.
> +        */
>  }
>
>  static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
> @@ -5859,6 +5877,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>         vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>
>         vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +       spin_lock_init(&vcpu->arch.mmu_shadow_page_cache_lock);
>
>         vcpu->arch.mmu = &vcpu->arch.root_mmu;
>         vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> @@ -5994,11 +6013,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>                 kvm_tdp_mmu_zap_invalidated_roots(kvm);
>  }
>
> -static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> -{
> -       return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
> -}
> -
>  static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>                         struct kvm_memory_slot *slot,
>                         struct kvm_page_track_notifier_node *node)
> @@ -6583,69 +6597,58 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
>         }
>  }
>
> -static unsigned long
> -mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> +static unsigned long mmu_shrink_scan(struct shrinker *shrink,
> +                                    struct shrink_control *sc)
>  {
> +       struct kvm_mmu_memory_cache *cache;
> +       struct kvm_vcpu *vcpu;
>         struct kvm *kvm;
> -       int nr_to_scan = sc->nr_to_scan;
>         unsigned long freed = 0;
> +       unsigned long i;
>
>         mutex_lock(&kvm_lock);
>
>         list_for_each_entry(kvm, &vm_list, vm_list) {
> -               int idx;
> -               LIST_HEAD(invalid_list);
> +               kvm_for_each_vcpu(i, vcpu, kvm) {
> +                       cache = &vcpu->arch.mmu_shadow_page_cache;
>
> -               /*
> -                * Never scan more than sc->nr_to_scan VM instances.
> -                * Will not hit this condition practically since we do not try
> -                * to shrink more than one VM and it is very unlikely to see
> -                * !n_used_mmu_pages so many times.
> -                */
> -               if (!nr_to_scan--)
> -                       break;
> -               /*
> -                * n_used_mmu_pages is accessed without holding kvm->mmu_lock
> -                * here. We may skip a VM instance errorneosly, but we do not
> -                * want to shrink a VM that only started to populate its MMU
> -                * anyway.
> -                */
> -               if (!kvm->arch.n_used_mmu_pages &&
> -                   !kvm_has_zapped_obsolete_pages(kvm))
> -                       continue;
> +                       if (!READ_ONCE(cache->nobjs))
> +                               continue;
>
> -               idx = srcu_read_lock(&kvm->srcu);
> -               write_lock(&kvm->mmu_lock);
> -
> -               if (kvm_has_zapped_obsolete_pages(kvm)) {
> -                       kvm_mmu_commit_zap_page(kvm,
> -                             &kvm->arch.zapped_obsolete_pages);
> -                       goto unlock;
> +                       spin_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
> +                       while (cache->nobjs) {
> +                               free_page((unsigned long)cache->objects[--cache->nobjs]);
> +                               ++freed;
> +                       }
> +                       spin_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
>                 }
>
> -               freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
> -
> -unlock:
> -               write_unlock(&kvm->mmu_lock);
> -               srcu_read_unlock(&kvm->srcu, idx);
> -
>                 /*
>                  * unfair on small ones
>                  * per-vm shrinkers cry out
>                  * sadness comes quickly
>                  */
>                 list_move_tail(&kvm->vm_list, &vm_list);
> -               break;
> +
> +               /*
> +                * Process all vCPUs before checking if enough pages have been
> +                * freed as a very naive way of providing fairness, e.g. to
> +                * avoid starving a single vCPU.
> +                */
> +               if (freed >= sc->nr_to_scan)
> +                       break;
>         }
>
>         mutex_unlock(&kvm_lock);
> +
> +       sc->nr_scanned = freed;
>         return freed;
>  }
>
> -static unsigned long
> -mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
> +static unsigned long mmu_shrink_count(struct shrinker *shrink,
> +                                     struct shrink_control *sc)
>  {
> -       return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
> +       return percpu_counter_read_positive(&kvm_total_unused_mmu_pages);
>  }
>
>  static struct shrinker mmu_shrinker = {
> @@ -6753,7 +6756,7 @@ int kvm_mmu_vendor_module_init(void)
>         if (!mmu_page_header_cache)
>                 goto out;
>
> -       if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
> +       if (percpu_counter_init(&kvm_total_unused_mmu_pages, 0, GFP_KERNEL))
>                 goto out;
>
>         ret = register_shrinker(&mmu_shrinker, "x86-mmu");
> @@ -6763,7 +6766,7 @@ int kvm_mmu_vendor_module_init(void)
>         return 0;
>
>  out_shrinker:
> -       percpu_counter_destroy(&kvm_total_used_mmu_pages);
> +       percpu_counter_destroy(&kvm_total_unused_mmu_pages);
>  out:
>         mmu_destroy_caches();
>         return ret;
> @@ -6780,7 +6783,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
>  void kvm_mmu_vendor_module_exit(void)
>  {
>         mmu_destroy_caches();
> -       percpu_counter_destroy(&kvm_total_used_mmu_pages);
> +       percpu_counter_destroy(&kvm_total_unused_mmu_pages);
>         unregister_shrinker(&mmu_shrinker);
>  }
>
>
> base-commit: d709db0a0c05a6a2973655ed88690d4d43128d60
> --
