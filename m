Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9F942989B
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbhJKVJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 17:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhJKVJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 17:09:19 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35748C061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 14:07:19 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id i189so13621369ioa.1
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 14:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXJkhPO8JlVoNXyrvPyexOdkensEvhVOevutI0g6qPw=;
        b=moM1ePaYrIf+Unmm9Wh3ZHkd9LVplgg+1h1XWHIi8Gkg0nQNPW5QSluo1g3pJaJBuD
         pGhfcARAmwJDROx0RohyWSojRcAc4CFOZ62m5Gd9N2kbh2ogx5y2KI1AsPMBoGT2xlVQ
         lEpqvqcQgbYA/AHm9+KVtMMGtW6vpwDMOSP+mryE/3eSyqLOFzz+WdALlO0hoEOfwApX
         rUWGy0f2u3wnVPJNWLUDriVEangoYFU5Kmjs8NYmPIHI+n8PTV2nftWuZqA2eqU4uLg+
         nQo2pdCTSPbvGORKNWQpCdA9O6hi2obJAxkqc7QTgHA2/WtW3SCPc5Z/j0+F/VNpIoRh
         Z9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXJkhPO8JlVoNXyrvPyexOdkensEvhVOevutI0g6qPw=;
        b=11zgmZRn6CxpeYrbWSsx84IHWuVecb9TC6WLsnui3AsMl4b9xlOBymdcWHxsKC6cRY
         TrotWWgU5M82IOb6X7rUcjtH2BPDAqLpOGRBmWg1dxWQjOMyG+OmAyKi7V48xjrU5b+/
         bOnhVANUqttgzwCMBoNl4KbK3fxxJvQnrczEFxFbEndcMOc2qZ5tIvJwuj3DodsUb9p9
         jOPQ5Yz+mjFZ71vfLx4XWF0EhvrCcrPDCQyUZkY8I8XkK2xTZHsXX6jvzmvxmu/s3SvV
         Hkt57Km9yqgIrU9XmFB+WNBG8PR1vUl/bPCZwrZo8yk/md0WkERJL9QgVzNC4b5d9bHz
         32RA==
X-Gm-Message-State: AOAM5337L0pOtJFPGmtejuiJ9z6S0NN17/QN43FoA9A+iFpGXtop3mOx
        0IiDHyzNdCBki1OUmAtpcKQGgU2CvYGHNNQvNc/K1LkMqhE=
X-Google-Smtp-Source: ABdhPJxx7sos4yk50Gq7m6MUrwUq3E/0CA2W1mAjAd36TdEvboyiiZpPko5AFdSLOZzKG9AVS0rG+8be5plzwDdSQbA=
X-Received: by 2002:a02:6048:: with SMTP id d8mr20009260jaf.61.1633986438412;
 Mon, 11 Oct 2021 14:07:18 -0700 (PDT)
MIME-Version: 1.0
References: <20211011204418.162846-1-dmatlack@google.com>
In-Reply-To: <20211011204418.162846-1-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 11 Oct 2021 14:07:07 -0700
Message-ID: <CANgfPd9R5kv-URf2huH8NBmggrh_1wfa+ap=1QRWN4YdJHCXEQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Rename slot_handle_leaf to slot_handle_level_4k
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021 at 1:44 PM David Matlack <dmatlack@google.com> wrote:
>
> slot_handle_leaf is a misnomer because it only operates on 4K SPTEs
> whereas "leaf" is used to describe any valid terminal SPTE (4K or
> large page). Rename slot_handle_leaf to slot_handle_level_4k to
> avoid confusion.
>
> Making this change makes it more obvious there is a benign discrepency
> between the legacy MMU and the TDP MMU when it comes to dirty logging.
> The legacy MMU only operates on 4K SPTEs when zapping for collapsing
> and when clearing D-bits. The TDP MMU, on the other hand, operates on
> SPTEs on all levels. The TDP MMU behavior is technically overkill but
> not incorrect. So opportunistically add comments to explain the
> difference.

Note that at least in the zapping case when disabling dirty logging,
the TDP MMU will still only zap pages if they're mapped smaller than
the highest granularity they could be. As a result it uses a slower
check, but shouldn't be doing many (if any) extra zaps.

>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 24a9f4c3f5e7..f00644e79ef5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5382,8 +5382,8 @@ slot_handle_level(struct kvm *kvm, const struct kvm_memory_slot *memslot,
>  }
>
>  static __always_inline bool
> -slot_handle_leaf(struct kvm *kvm, const struct kvm_memory_slot *memslot,
> -                slot_level_handler fn, bool flush_on_yield)
> +slot_handle_level_4k(struct kvm *kvm, const struct kvm_memory_slot *memslot,
> +                    slot_level_handler fn, bool flush_on_yield)
>  {
>         return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
>                                  PG_LEVEL_4K, flush_on_yield);
> @@ -5772,7 +5772,12 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>
>         if (kvm_memslots_have_rmaps(kvm)) {
>                 write_lock(&kvm->mmu_lock);
> -               flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
> +               /*
> +                * Strictly speaking only 4k SPTEs need to be zapped because
> +                * KVM never creates intermediate 2m mappings when performing
> +                * dirty logging.
> +                */
> +               flush = slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
>                 if (flush)
>                         kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
>                 write_unlock(&kvm->mmu_lock);
> @@ -5809,8 +5814,11 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>
>         if (kvm_memslots_have_rmaps(kvm)) {
>                 write_lock(&kvm->mmu_lock);
> -               flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty,
> -                                        false);
> +               /*
> +                * Strictly speaking only 4k SPTEs need to be cleared because
> +                * KVM always performs dirty logging at a 4k granularity.
> +                */
> +               flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
>                 write_unlock(&kvm->mmu_lock);
>         }
>
> --
> 2.33.0.882.g93a45727a2-goog
>
