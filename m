Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC6D658738
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 23:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiL1WJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 17:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbiL1WI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 17:08:56 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984D815FE4
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 14:08:46 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id j206so18807436ybj.1
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 14:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/j/2fk/COQFHOsFOomujVdwLSD+qEUXjmVj2uVzmYHw=;
        b=cnDcLQxS8OP/jEGBwG5LG99vXOCmzEAie46qN1BFDMAWslECvbsEC7qzGuFoywrYBP
         hPlGR9ULz8gBrEX9AWrzOZ5Ph44ZVAc7GW4d3oGiCzLgcm+GzGc0kM/23fEsBYacD/yt
         11JahwGMxLULcvl+50fVd8MuqDCz01QmO2orNVOjivppSb0a1Y8uD1JPtZ9Y+Y0lg6Y7
         TyJLr7bBn6eAs4y6VWRKrd+uBsQ0RWCwTxdjKcnhGD7bSWt0NjTYPzM0sK4ISB903izF
         HJhlwNPjqn/cyFnN5heYbztrsE8363Q2tn/IpCMntgpI0suPsYEm07GIRHG6kLjbNuEm
         SLBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/j/2fk/COQFHOsFOomujVdwLSD+qEUXjmVj2uVzmYHw=;
        b=VI5d/i++yQW9E355Byjs/b52bYDz3U1x0keOF7QfwRhaTm0dLan7+sP2psgrWUrpH5
         pTWmvFvvXOs0abC5HyylMuQSHlHTh6VA1s8Hz+8mG5Y2jVUo7S0SuflU39qsg057b1vi
         w2xvp1p6FnragWJIMwqxXtZssmOdOnJxxsziJBgamyTj/JTvF6GZtd2adp41Wra2UMRB
         hq5uSaYoR6dx9dK0yiqEPhsZ6xIcOvcgCey6rSER2SD8L3YrELlcGZZs5tFJAtxA6SKg
         FGSMtFZ+1BcS/7/BWYwp9J30KcPARcikcpN9OxWi/Ty3uSot9hei2CeBS0wyoD8Ste+B
         IHvQ==
X-Gm-Message-State: AFqh2krZDfKZ8olafsP0RI3oDrk2JGPJiQOYiwaQWIjmvs7X8hFtK1Oo
        ZHZaK+TNf6Qow+UcI9opFGc+HU2lvXJMPk3wgss3bQ==
X-Google-Smtp-Source: AMrXdXt/e+q1reiVSs3v1tgeVAqYuF5q0lEWFNznlqU6MZ4QYGJ2CIqQpdf73kQXrv8VdFqfVSzKhlFi6vYkxwrzg0Q=
X-Received: by 2002:a25:6c86:0:b0:703:2633:87c1 with SMTP id
 h128-20020a256c86000000b00703263387c1mr3453511ybc.132.1672265325913; Wed, 28
 Dec 2022 14:08:45 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-9-vipinsh@google.com>
 <CANgfPd-sByYUeFxrRpuTYn=mVdDTmrOMeDW8Ath+PzWe06V8-g@mail.gmail.com>
In-Reply-To: <CANgfPd-sByYUeFxrRpuTYn=mVdDTmrOMeDW8Ath+PzWe06V8-g@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 28 Dec 2022 14:08:10 -0800
Message-ID: <CAHVum0enjcCepUoD3gfZDEhK6a=9Juz=e_mFxsQB2e1HhHiCfA@mail.gmail.com>
Subject: Re: [Patch v3 8/9] KVM: x86/mmu: Make split_shadow_page_cache NUMA aware
To:     Ben Gardon <bgardon@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Tue, Dec 27, 2022 at 11:43 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Dec 21, 2022 at 6:35 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > Make split_shadow_page_cache NUMA aware and allocate page table's pages
> > during the split based on the underlying physical page's NUMA node.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 +-
> >  arch/x86/kvm/mmu/mmu.c          | 50 ++++++++++++++++++---------------
> >  2 files changed, 29 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index b1f319ad6f89..7b3f36ae37a4 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1410,7 +1410,7 @@ struct kvm_arch {
> >          *
> >          * Protected by kvm->slots_lock.
> >          */
> > -       struct kvm_mmu_memory_cache split_shadow_page_cache;
> > +       struct kvm_mmu_memory_cache split_shadow_page_cache[MAX_NUMNODES];
> >         struct kvm_mmu_memory_cache split_page_header_cache;
> >
> >         /*
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 511c6ef265ee..7454bfc49a51 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6126,7 +6126,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> >  int kvm_mmu_init_vm(struct kvm *kvm)
> >  {
> >         struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> > -       int r;
> > +       int r, nid;
> >
> >         INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> >         INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
> > @@ -6145,8 +6145,9 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> >         INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache,
> >                                   mmu_page_header_cache, NUMA_NO_NODE);
> >
> > -       INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache,
> > -                                 NULL, NUMA_NO_NODE);
> > +       for_each_node(nid)
>
> Again, assuming no one sets CONFIG_NODE_SHIFT to a ridiculous value,
> it would probably be fine to initialize the entire array here since
> that doesn't take any extra memory and we're not in a super hot path.

This goes through the entire array. I think you are confusing it with
for_each_online_node().

>
> > +               INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache[nid],
> > +                                         NULL, NUMA_NO_NODE);
> >         spin_lock_init(&kvm->arch.split_shadow_page_cache_lock);
> >
> >         INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache,
> > @@ -6157,10 +6158,13 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> >
> >  static void mmu_free_vm_memory_caches(struct kvm *kvm)
> >  {
> > +       int nid;
> > +
> >         kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
> >         kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
> > -       mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache,
> > -                                &kvm->arch.split_shadow_page_cache_lock);
> > +       for_each_node(nid)
>
> Again, could just iterate over the whole array here.
>
> > +               mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache[nid],
> > +                                        &kvm->arch.split_shadow_page_cache_lock);
> >  }
> >
> >  void kvm_mmu_uninit_vm(struct kvm *kvm)
> > @@ -6269,7 +6273,7 @@ static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
> >         return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
> >  }
> >
> > -static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> > +static bool need_topup_split_caches_or_resched(struct kvm *kvm, int nid)
> >  {
> >         if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> >                 return true;
> > @@ -6281,10 +6285,10 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> >          */
> >         return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_MIN_NR_OBJECTS) ||
> >                need_topup(&kvm->arch.split_page_header_cache, 1) ||
> > -              need_topup(&kvm->arch.split_shadow_page_cache, 1);
> > +              need_topup(&kvm->arch.split_shadow_page_cache[nid], 1);
> >  }
> >
> > -static int topup_split_caches(struct kvm *kvm)
> > +static int topup_split_caches(struct kvm *kvm, int nid)
> >  {
> >         /*
> >          * Allocating rmap list entries when splitting huge pages for nested
> > @@ -6314,18 +6318,21 @@ static int topup_split_caches(struct kvm *kvm)
> >         if (r)
> >                 return r;
> >
> > -       return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache,
> > +       return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache[nid],
> >                                          &kvm->arch.split_shadow_page_cache_lock,
> >                                          1);
> >  }
> >
> > -static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
> > +static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm,
> > +                                                       u64 *huge_sptep,
> > +                                                       u64 huge_spte)
>
> These can go on the same line.

Git diff is showing it weirdly. They are aligned to "struct kvm *kvm"
and both will be on different lines to keep them in the 80 char limit.


>
> >  {
> >         struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> >         struct shadow_page_caches caches = {};
> >         union kvm_mmu_page_role role;
> >         unsigned int access;
> >         gfn_t gfn;
> > +       int nid;
> >
> >         gfn = kvm_mmu_page_get_gfn(huge_sp, spte_index(huge_sptep));
> >         access = kvm_mmu_page_get_access(huge_sp, spte_index(huge_sptep));
> > @@ -6338,9 +6345,11 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
> >          */
> >         role = kvm_mmu_child_role(huge_sptep, /*direct=*/true, access);
> >
> > +       nid = kvm_pfn_to_page_table_nid(spte_to_pfn(huge_spte));
> > +
> >         /* Direct SPs do not require a shadowed_info_cache. */
> >         caches.page_header_cache = &kvm->arch.split_page_header_cache;
> > -       caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
> > +       caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache[nid];
> >         caches.shadow_page_cache_lock = &kvm->arch.split_shadow_page_cache_lock;
> >
> >         /* Safe to pass NULL for vCPU since requesting a direct SP. */
> > @@ -6360,7 +6369,7 @@ static void shadow_mmu_split_huge_page(struct kvm *kvm,
> >         gfn_t gfn;
> >         int index;
> >
> > -       sp = shadow_mmu_get_sp_for_split(kvm, huge_sptep);
> > +       sp = shadow_mmu_get_sp_for_split(kvm, huge_sptep, huge_spte);
> >
> >         for (index = 0; index < SPTE_ENT_PER_PAGE; index++) {
> >                 sptep = &sp->spt[index];
> > @@ -6398,7 +6407,7 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
> >                                           u64 *huge_sptep)
> >  {
> >         struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> > -       int level, r = 0;
> > +       int level, r = 0, nid;
> >         gfn_t gfn;
> >         u64 spte;
> >
> > @@ -6406,13 +6415,14 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
> >         gfn = kvm_mmu_page_get_gfn(huge_sp, spte_index(huge_sptep));
> >         level = huge_sp->role.level;
> >         spte = *huge_sptep;
> > +       nid = kvm_pfn_to_page_table_nid(spte_to_pfn(spte));
> >
> >         if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES) {
> >                 r = -ENOSPC;
> >                 goto out;
> >         }
> >
> > -       if (need_topup_split_caches_or_resched(kvm)) {
> > +       if (need_topup_split_caches_or_resched(kvm, nid)) {
> >                 write_unlock(&kvm->mmu_lock);
> >                 cond_resched();
> >                 /*
> > @@ -6420,7 +6430,7 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
> >                  * rmap iterator should be restarted because the MMU lock was
> >                  * dropped.
> >                  */
> > -               r = topup_split_caches(kvm) ?: -EAGAIN;
> > +               r = topup_split_caches(kvm, nid) ?: -EAGAIN;
> >                 write_lock(&kvm->mmu_lock);
> >                 goto out;
> >         }
> > @@ -6709,17 +6719,15 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
> >  }
> >
> >  static unsigned long mmu_shrink_cache(struct kvm_mmu_memory_cache *cache,
> > -                                     int cache_count,
> >                                       spinlock_t *cache_lock)
> >  {
> >         unsigned long freed = 0;
> >         int nid;
> >
> >         spin_lock(cache_lock);
> > -       for (nid = 0; nid < cache_count; nid++) {
> > -               if (node_online(nid) && cache[nid].nobjs)
> > +       for_each_online_node(nid)
> > +               if (cache[nid].nobjs)
> >                         freed += kvm_mmu_empty_memory_cache(&cache[nid]);
> > -       }
> >         spin_unlock(cache_lock);
> >         return freed;
> >  }
> > @@ -6741,8 +6749,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> >                         first_kvm = kvm;
> >                 list_move_tail(&kvm->vm_list, &vm_list);
> >
> > -               freed += mmu_shrink_cache(&kvm->arch.split_shadow_page_cache,
> > -                                         1,
> > +               freed += mmu_shrink_cache(kvm->arch.split_shadow_page_cache,
> >                                           &kvm->arch.split_shadow_page_cache_lock);
> >
> >                 if (freed >= sc->nr_to_scan)
> > @@ -6750,7 +6757,6 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> >
> >                 kvm_for_each_vcpu(i, vcpu, kvm) {
> >                         freed += mmu_shrink_cache(vcpu->arch.mmu_shadow_page_cache,
> > -                                                 MAX_NUMNODES,
> >                                                   &vcpu->arch.mmu_shadow_page_cache_lock);
> >                 }
> >
> > --
> > 2.39.0.314.g84b9a713c41-goog
> >
