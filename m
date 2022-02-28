Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC1E4C7E26
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 00:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiB1XQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 18:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiB1XP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 18:15:58 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6273434A8
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 15:15:18 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id qa43so1380122ejc.12
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 15:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YoMcd1THGICE2VmFdB1g9ucNae/b72PiOrCiwNgNrHU=;
        b=KhtPHrlkCURcM/UDBBkeodB+MwqbXhCYxIVriYq1RYVisuUokQNsczDB3hQnCjh13P
         dGriIG4ser0KM6mSB/so8J613WiFLIc4Mv35AFphKcMNEeILY+yj3elC4P9dqFziDi6M
         DFzQ4yMg0YkaDkaa8nKOCbK74RpLZ++Fhot/hpWZNCazzfI/tCKutWNL8ddELyM9XemI
         S5bzecFcpoQjnzKR0VZ40WnFmFLmcXM29CFHi2KJQPelJ5MrExIWnORPuwm2p9P91+ip
         U36GnMV++U65e0g3o61gUjhzODsUsCrWU6Jw+tvcxqubsYJ2UO2ARirKrPb65RR16DNQ
         f4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YoMcd1THGICE2VmFdB1g9ucNae/b72PiOrCiwNgNrHU=;
        b=oNxrBxN5a1Kvq4H/h4ajHGACX4U9TkkNtRA9is0BVcAi0JW2pHEjfaZ/WnOrWfz4Cw
         h5XHyTH7rbl5tRDnHJVs7S7kKOgpLIiepKlVNtk1/Q1+vzwWVv1u5OcawoKHG2qTxGOR
         jYsnblbHu6uE3/rWchqhsDC5lkCaXCidz0PetDXOeGPinjZ8ep/n0UISPRCdDK9voXtR
         Svy6Ajsb7F5TkGivYqj5dUn3eGwfXUIi1ZK7ivEla/h64XxKsi1v9pWMlL3bSdXQg7sD
         4Q7+Q7qGChYPUeGzvKnAeogXZj+tINoot/K5UlOTn9kjuhVq4bhKleBr+NJJML1LyS0+
         6NhQ==
X-Gm-Message-State: AOAM5324tTFsbRajgTC7uAnw6gKKpyfLfA6+8pHo0COm0suyEq48+JSX
        r4Uv/WftlRYEgWSunqthITPqmRB98cq4zn7l+9RJZQ==
X-Google-Smtp-Source: ABdhPJzSHjeJ7F+cuoVIipgP3k6yZJEAYMkVrQKA16PD9Mq0TBuXRo/e4tUKkl4xX25JnrRcdV07J0qpBfCey9bP1r4=
X-Received: by 2002:a17:906:d14e:b0:6cd:8d7e:eec9 with SMTP id
 br14-20020a170906d14e00b006cd8d7eeec9mr16959496ejb.28.1646090116919; Mon, 28
 Feb 2022 15:15:16 -0800 (PST)
MIME-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com> <20220226001546.360188-4-seanjc@google.com>
In-Reply-To: <20220226001546.360188-4-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 15:15:03 -0800
Message-ID: <CANgfPd9dFhYpQdVQQ9ic+yepPKCG3Vrek0tcYbP8rjzuZD_OLA@mail.gmail.com>
Subject: Re: [PATCH v3 03/28] KVM: x86/mmu: Fix wrong/misleading comments in
 TDP MMU fast zap
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

On Fri, Feb 25, 2022 at 4:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Fix misleading and arguably wrong comments in the TDP MMU's fast zap
> flow.  The comments, and the fact that actually zapping invalid roots was
> added separately, strongly suggests that zapping invalid roots is an
> optimization and not required for correctness.  That is a lie.
>
> KVM _must_ zap invalid roots before returning from kvm_mmu_zap_all_fast(),
> because when it's called from kvm_mmu_invalidate_zap_pages_in_memslot(),
> KVM is relying on it to fully remove all references to the memslot.  Once
> the memslot is gone, KVM's mmu_notifier hooks will be unable to find the
> stale references as the hva=>gfn translation is done via the memslots.
> If KVM doesn't immediately zap SPTEs and userspace unmaps a range after
> deleting a memslot, KVM will fail to zap in response to the mmu_notifier
> due to not finding a memslot corresponding to the notifier's range, which
> leads to a variation of use-after-free.
>
> The other misleading comment (and code) explicitly states that roots
> without a reference should be skipped.  While that's technically true,
> it's also extremely misleading as it should be impossible for KVM to
> encounter a defunct root on the list while holding mmu_lock for write.
> Opportunstically add a WARN to enforce that invariant.
>
> Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
> Fixes: 4c6654bd160d ("KVM: x86/mmu: Tear down roots before kvm_mmu_zap_all_fast returns")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

A couple nits about missing words, but otherwise looks good.

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c     |  8 +++++++
>  arch/x86/kvm/mmu/tdp_mmu.c | 46 +++++++++++++++++++++-----------------
>  2 files changed, 33 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b2c1c4eb6007..80607513a1f2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5662,6 +5662,14 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>
>         write_unlock(&kvm->mmu_lock);
>
> +       /*
> +        * Zap the invalidated TDP MMU roots, all SPTEs must be dropped before
> +        * returning to the caller, e.g. if the zap is in response to a memslot
> +        * deletion, mmu_notifier callbacks will be unable to reach the SPTEs
> +        * associated with the deleted memslot once the update completes, and
> +        * Deferring the zap until the final reference to the root is put would
> +        * lead to use-after-free.
> +        */
>         if (is_tdp_mmu_enabled(kvm)) {
>                 read_lock(&kvm->mmu_lock);
>                 kvm_tdp_mmu_zap_invalidated_roots(kvm);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 9357780ec28f..12866113fb4f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -826,12 +826,11 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  }
>
>  /*
> - * Since kvm_tdp_mmu_zap_all_fast has acquired a reference to each
> - * invalidated root, they will not be freed until this function drops the
> - * reference. Before dropping that reference, tear down the paging
> - * structure so that whichever thread does drop the last reference
> - * only has to do a trivial amount of work. Since the roots are invalid,
> - * no new SPTEs should be created under them.
> + * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
> + * zap" completes.  Since kvm_tdp_mmu_invalidate_all_roots() has acquired a
> + * reference to each invalidated root, roots will not be freed until after this
> + * function drops the gifted reference, e.g. so that vCPUs don't get stuck with
> + * tearing paging structures.

Nit: tearing down paging structures

>   */
>  void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  {
> @@ -855,21 +854,25 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  }
>
>  /*
> - * Mark each TDP MMU root as invalid so that other threads
> - * will drop their references and allow the root count to
> - * go to 0.
> + * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
> + * is about to be zapped, e.g. in response to a memslots update.  The caller is
> + * responsible for invoking kvm_tdp_mmu_zap_invalidated_roots() to the actual

Nit: to do

> + * zapping.
>   *
> - * Also take a reference on all roots so that this thread
> - * can do the bulk of the work required to free the roots
> - * once they are invalidated. Without this reference, a
> - * vCPU thread might drop the last reference to a root and
> - * get stuck with tearing down the entire paging structure.
> + * Take a reference on all roots to prevent the root from being freed before it
> + * is zapped by this thread.  Freeing a root is not a correctness issue, but if
> + * a vCPU drops the last reference to a root prior to the root being zapped, it
> + * will get stuck with tearing down the entire paging structure.
>   *
> - * Roots which have a zero refcount should be skipped as
> - * they're already being torn down.
> - * Already invalid roots should be referenced again so that
> - * they aren't freed before kvm_tdp_mmu_zap_all_fast is
> - * done with them.
> + * Get a reference even if the root is already invalid,
> + * kvm_tdp_mmu_zap_invalidated_roots() assumes it was gifted a reference to all
> + * invalid roots, e.g. there's no epoch to identify roots that were invalidated
> + * by a previous call.  Roots stay on the list until the last reference is
> + * dropped, so even though all invalid roots are zapped, a root may not go away
> + * for quite some time, e.g. if a vCPU blocks across multiple memslot updates.
> + *
> + * Because mmu_lock is held for write, it should be impossible to observe a
> + * root with zero refcount, i.e. the list of roots cannot be stale.
>   *
>   * This has essentially the same effect for the TDP MMU
>   * as updating mmu_valid_gen does for the shadow MMU.
> @@ -879,9 +882,10 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
>         struct kvm_mmu_page *root;
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
> -       list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
> -               if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
> +       list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> +               if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
>                         root->role.invalid = true;
> +       }
>  }
>
>  /*
> --
> 2.35.1.574.g5d30c73bfb-goog
>
