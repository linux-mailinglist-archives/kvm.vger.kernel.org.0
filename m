Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8833D1492
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhGUQKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 12:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbhGUQKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 12:10:20 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D58FC061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 09:50:57 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id g22so3114093iom.1
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 09:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iNA8kzrwXJHf408t5Tny5lnj4ZPK3z3F1NJP36I5Y5k=;
        b=pQ3dxdw3glhs1TXiqouA23s/fl4P57CdrE3/fxRpCiW4BTx0hKO6moGAnLjEeMSOMn
         iFtB8sWD4e2EvDL9VLMUf38iNm+2s46hcd4WVKpk7ArK9ZShWw+nNaNGt9hvMWjj+j2Z
         tsKQhlyEszJgqJclBWqDZRWYnDUgZQDQbRllW07haAl0OdTcqYvYpCjdODlHg9xgZ4lk
         BOskCs+LNUJNQF68qHAIgtGyaCpp1bTrVqPN4pH67+ifTT+7S56fAmXaSANuzVy1fOJ0
         1YWWDEfN4arnF1K5JAMCFzORl3nqRNLvpkxy7c4YQzi241B/5Fucc0YLBFloGHMsJ++H
         mEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iNA8kzrwXJHf408t5Tny5lnj4ZPK3z3F1NJP36I5Y5k=;
        b=VFULW3iL7R3qNwbqZPATfBy00m3UqTSjK+OrddLNn9Fc0R51FLeHTdxtHJ869dWmsF
         czWJpZTAaTAbPoTIBG0D7nn7Rl9yX/E16+9Q80ZLU7XQyDwcElq+KO5y3rGFiAk0J4tq
         sFHd9hl1m+5sk3UjjBHNUjGOnTF8/BKIVKM0+5UzxGGxzTZrOS4ac4oPjoFmE5GZZmvX
         5vmU4iNExnFEiQwbKLkS3WvF4p8IjShy9n9hcBADN5MCOvJIkd0DbvOBdlKNRhuCu5p/
         NkU+/Y2XFlnYA3iDvbqnEffDW66EjlZbMZpdn9oYPwSKkGWHUML8+HvIIliwpF9H3cZY
         XobA==
X-Gm-Message-State: AOAM531NO9OP5QW0ISGwnEP659Aiu7k5wfqlFeGpB0xNlXeWg6did5Ki
        ESLkBtTqRmjKSkcrTP5laDaeFurOtL3RM9oodmFShw==
X-Google-Smtp-Source: ABdhPJwKOZCb7YgcyRhS5qzLmp7wxF3TFGcQ+TTxsrBG76B/g9rmTTS5s2WUWsWTWmi38Q5Yn1Gajf+5If4lsXQXZmo=
X-Received: by 2002:a5d:8a17:: with SMTP id w23mr14684461iod.19.1626886256295;
 Wed, 21 Jul 2021 09:50:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210721051247.355435-1-mizhang@google.com> <20210721051247.355435-3-mizhang@google.com>
In-Reply-To: <20210721051247.355435-3-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 21 Jul 2021 09:50:44 -0700
Message-ID: <CANgfPd810e1tz-ip5M3dB6VmJQMtkKJNmB1RqAy=fui8SGTozA@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: mmu/x86: Add detailed page size stats
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20, 2021 at 10:13 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> Existing KVM code tracks the number of large pages regardless of their
> sizes. Therefore, when large page of 1GB (or larger) is adopted, the
> information becomes less useful because lpages counts a mix of 1G and 2M
> pages.
>
> So bridge the gap and provide a comprehensive page stats of all sizes from
> 4K to 512G.
>
> Suggested-by: Ben Gardon <bgardon@google.com>
> Suggested-by: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 11 ++++++++-
>  arch/x86/kvm/mmu.h              |  2 ++
>  arch/x86/kvm/mmu/mmu.c          | 43 +++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/tdp_mmu.c      | 10 +++-----
>  arch/x86/kvm/x86.c              |  6 ++++-
>  5 files changed, 51 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..1b7b024f9573 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1206,9 +1206,18 @@ struct kvm_vm_stat {
>         u64 mmu_recycled;
>         u64 mmu_cache_miss;
>         u64 mmu_unsync;
> -       u64 lpages;
> +       atomic64_t lpages;
>         u64 nx_lpage_splits;
>         u64 max_mmu_page_hash_collisions;
> +       union {
> +               struct {
> +                       atomic64_t pages_4k;
> +                       atomic64_t pages_2m;
> +                       atomic64_t pages_1g;
> +                       atomic64_t pages_512g;
> +               };
> +               atomic64_t pages[4];
> +       } page_stats;
>  };
>
>  struct kvm_vcpu_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 83e6c6965f1e..56d9c947a0cd 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -240,4 +240,6 @@ static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>         return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
>  }
>
> +void kvm_update_page_stats(struct kvm *kvm, u64 spte, int level, int delta);

Delta should be count here to match below, or you should change below to delta.

> +
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c45ddd2c964f..9ba25f00ca2b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -588,16 +588,33 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>         return flush;
>  }
>
> +void kvm_update_page_stats(struct kvm *kvm, u64 spte, int level, int count)
> +{
> +       if (!is_last_spte(spte, level))
> +               return;
> +       /*
> +        * If the backing page is a large page, update the lpages stat first,
> +        * then log the specific type of backing page. Only log pages at highter

*higher

> +        * levels if they are marked as large pages. (As opposed to simply
> +        * pointing to another level of page tables.).
> +        */
> +       if (is_large_pte(spte))
> +               atomic64_add(count, (atomic64_t *)&kvm->stat.lpages);

I don't think you need the casts to atomic64_t * here since these
variables are already defined as atomic64_t.


> +       atomic64_add(count,
> +               (atomic64_t *)&kvm->stat.page_stats.pages[level-1]);
> +}
> +
>  /*
>   * Rules for using mmu_spte_clear_track_bits:
>   * It sets the sptep from present to nonpresent, and track the
>   * state bits, it is used to clear the last level sptep.
>   * Returns non-zero if the PTE was previously valid.
>   */
> -static int mmu_spte_clear_track_bits(u64 *sptep)
> +static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>  {
>         kvm_pfn_t pfn;
>         u64 old_spte = *sptep;
> +       int level = sptep_to_sp(sptep)->role.level;
>
>         if (!spte_has_volatile_bits(old_spte))
>                 __update_clear_spte_fast(sptep, 0ull);
> @@ -607,6 +624,8 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
>         if (!is_shadow_present_pte(old_spte))
>                 return 0;
>
> +       kvm_update_page_stats(kvm, old_spte, level, -1);
> +
>         pfn = spte_to_pfn(old_spte);
>
>         /*
> @@ -984,9 +1003,10 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
>         }
>  }
>
> -static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
> +static void pte_list_remove(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> +                           u64 *sptep)
>  {
> -       mmu_spte_clear_track_bits(sptep);
> +       mmu_spte_clear_track_bits(kvm, sptep);
>         __pte_list_remove(sptep, rmap_head);
>  }
>
> @@ -1119,7 +1139,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
>
>  static void drop_spte(struct kvm *kvm, u64 *sptep)
>  {
> -       if (mmu_spte_clear_track_bits(sptep))
> +       if (mmu_spte_clear_track_bits(kvm, sptep))
>                 rmap_remove(kvm, sptep);
>  }
>
> @@ -1129,7 +1149,6 @@ static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
>         if (is_large_pte(*sptep)) {
>                 WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
>                 drop_spte(kvm, sptep);
> -               --kvm->stat.lpages;
>                 return true;
>         }
>
> @@ -1386,7 +1405,7 @@ static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>         while ((sptep = rmap_get_first(rmap_head, &iter))) {
>                 rmap_printk("spte %p %llx.\n", sptep, *sptep);
>
> -               pte_list_remove(rmap_head, sptep);
> +               pte_list_remove(kvm, rmap_head, sptep);
>                 flush = true;
>         }
>
> @@ -1421,13 +1440,13 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>                 need_flush = 1;
>
>                 if (pte_write(pte)) {
> -                       pte_list_remove(rmap_head, sptep);
> +                       pte_list_remove(kvm, rmap_head, sptep);
>                         goto restart;
>                 } else {
>                         new_spte = kvm_mmu_changed_pte_notifier_make_spte(
>                                         *sptep, new_pfn);
>
> -                       mmu_spte_clear_track_bits(sptep);
> +                       mmu_spte_clear_track_bits(kvm, sptep);
>                         mmu_spte_set(sptep, new_spte);
>                 }
>         }
> @@ -2232,8 +2251,6 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>         if (is_shadow_present_pte(pte)) {
>                 if (is_last_spte(pte, sp->role.level)) {
>                         drop_spte(kvm, spte);
> -                       if (is_large_pte(pte))
> -                               --kvm->stat.lpages;
>                 } else {
>                         child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
>                         drop_parent_pte(child, spte);
> @@ -2690,10 +2707,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>
>         pgprintk("%s: setting spte %llx\n", __func__, *sptep);
>         trace_kvm_mmu_set_spte(level, gfn, sptep);
> -       if (!was_rmapped && is_large_pte(*sptep))
> -               ++vcpu->kvm->stat.lpages;
>
>         if (!was_rmapped) {
> +               kvm_update_page_stats(vcpu->kvm, *sptep,
> +                       sptep_to_sp(sptep)->role.level, 1);
>                 rmap_count = rmap_add(vcpu, sptep, gfn);
>                 if (rmap_count > RMAP_RECYCLE_THRESHOLD)
>                         rmap_recycle(vcpu, sptep, gfn);
> @@ -5669,7 +5686,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>                 if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
>                     sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
>                                                                pfn, PG_LEVEL_NUM)) {
> -                       pte_list_remove(rmap_head, sptep);
> +                       pte_list_remove(kvm, rmap_head, sptep);
>
>                         if (kvm_available_flush_tlb_with_range())
>                                 kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index caac4ddb46df..24bd7f03248c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -446,12 +446,10 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>
>         trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
>
> -       if (is_large_pte(old_spte) != is_large_pte(new_spte)) {
> -               if (is_large_pte(old_spte))
> -                       atomic64_sub(1, (atomic64_t*)&kvm->stat.lpages);
> -               else
> -                       atomic64_add(1, (atomic64_t*)&kvm->stat.lpages);
> -       }
> +       if (is_large_pte(old_spte) && !is_large_pte(new_spte))
> +               kvm_update_page_stats(kvm, old_spte, level, -1);
> +       else if (!is_large_pte(old_spte) && is_large_pte(new_spte))
> +               kvm_update_page_stats(kvm, new_spte, level, 1);
>
>         /*
>          * The only times a SPTE should be changed from a non-present to
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8166ad113fb2..23444257fcbd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -237,7 +237,11 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>         STATS_DESC_ICOUNTER(VM, mmu_unsync),
>         STATS_DESC_ICOUNTER(VM, lpages),
>         STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
> -       STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
> +       STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
> +       STATS_DESC_ICOUNTER(VM, page_stats.pages_4k),
> +       STATS_DESC_ICOUNTER(VM, page_stats.pages_2m),
> +       STATS_DESC_ICOUNTER(VM, page_stats.pages_1g),
> +       STATS_DESC_ICOUNTER(VM, page_stats.pages_512g)
>  };
>  static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
>                 sizeof(struct kvm_vm_stat) / sizeof(u64));
> --
> 2.32.0.402.g57bb445576-goog
>
