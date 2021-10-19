Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4CD434233
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 01:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhJSXkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 19:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhJSXkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 19:40:43 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCBFC06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 16:38:28 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id a8so20143138ilj.10
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 16:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=plVOINU2lyLd0ufKF/RaavELvup4bW1+STm8AzLvR+8=;
        b=s5GBRZd0pwZcWPasAM2W7hEBjjyAkFyMRZPGMfMtoI8cq2bnIU95VVurTlKEBZGSTd
         1rqfXJCvWkSasBSrU0/WodbHg0ptM/ecZuBsFC2WsmWFK5QsyEZIANbVs+E7LA6WSMlE
         CBzfctZiNvaIB3jlqy9EMhMtdtbcnhkfFXKQu/b3v7GLqUr2PpV3/IQueZ4yI3H6xZxY
         BcdDkpt2nYtqq/5YIC90DrNHwlYLn/wClMhFb1/szFdyOATYCpVjHUenJTaeD27pjkI8
         gtqp9++P0Hck6uFmr6mBVAXJY2Z159ab+BZq8wxx/p0n3Rvz5wUsAYLyrFcI2qd/dqXO
         jisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=plVOINU2lyLd0ufKF/RaavELvup4bW1+STm8AzLvR+8=;
        b=DoOYqwlUeML8lahV79cXfUkjDWvb+FqUGgefSdubJmGahigI/1OzRg70PIhBQUUFbs
         ns3PHy7NxvicQptai1/wHlw90K8N3mgm1tWFvMn5U/WxqJgxMd/sRhcQKysvTezwudcx
         7yAwlYNy/RcrOxEUCGNW7EDN+8EiHuuU6zUPbi1qaodCkkvFhiTmLcptM2r11Zaxkibm
         TGgSZ6okkOxkftrD4s/up2DId0irVULWc+4PUkVONXXEz3ZZqCIBS08o9ZhFx6LK1f69
         fGFdRXRpDhuHpcDl5nMP8c7J+mq+yUY+ocL8KtxEyqPEeAizauxjpzUUkOg2fd5YhKyf
         llkA==
X-Gm-Message-State: AOAM531StiezsLRx+psVaLw7OURRNLcnObUpP1b7iHA2lDLtllHoCSBf
        ZYkQ+yeQe/Fdt/4Y5+2R13NMWzsNfja41NYpFy5R5g==
X-Google-Smtp-Source: ABdhPJwP1Yg+19a0LRoEPfcbfULEWDCLd4qpcY3GwlzgItbg3eqOoYfpUfRaUuRsrLJGTGCi8PinntPAuo5k5nQ6ST8=
X-Received: by 2002:a05:6e02:1708:: with SMTP id u8mr10958831ill.2.1634686707622;
 Tue, 19 Oct 2021 16:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211019162223.3935109-1-dmatlack@google.com>
In-Reply-To: <20211019162223.3935109-1-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 19 Oct 2021 16:38:16 -0700
Message-ID: <CANgfPd9_Rym6cRMXhVXxQDS4mt5YptWp3J+3NgPdg16FAENPXQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Rename slot_handle_leaf to slot_handle_level_4k
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 19, 2021 at 9:22 AM David Matlack <dmatlack@google.com> wrote:
>
> slot_handle_leaf is a misnomer because it only operates on 4K SPTEs
> whereas "leaf" is used to describe any valid terminal SPTE (4K or
> large page). Rename slot_handle_leaf to slot_handle_level_4k to
> avoid confusion.
>
> Making this change makes it more obvious there is a benign discrepency
> between the legacy MMU and the TDP MMU when it comes to dirty logging.
> The legacy MMU only iterates through 4K SPTEs when zapping for
> collapsing and when clearing D-bits. The TDP MMU, on the other hand,
> iterates through SPTEs on all levels.
>
> The TDP MMU behavior of zapping SPTEs at all levels is technically
> overkill for its current dirty logging implementation, which always
> demotes to 4k SPTES, but both the TDP MMU and legacy MMU zap if and only
> if the SPTE can be replaced by a larger page, i.e. will not spuriously
> zap 2m (or larger) SPTEs. Opportunistically add comments to explain this
> discrepency in the code.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
> v1: https://lore.kernel.org/kvm/20211011204418.162846-1-dmatlack@google.com/
> - Clarified that the TDP MMU does not perform spurious zaps in commit
>   message [Sean, Ben]
> - Use "legacy MMU" instead of "KVM" in comments to avoid comments
>   becoming stale in the future if the TDP MMU gets support for 2m dirty
>   logging [Sean]
>
>  arch/x86/kvm/mmu/mmu.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 24a9f4c3f5e7..fa918289c9e0 100644
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
> +                * Zap only 4k SPTEs since the legacy MMU only supports dirty
> +                * logging at a 4k granularity and never creates collapsible
> +                * 2m SPTEs during dirty logging.
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
> +                * Clear dirty bits only on 4k SPTEs since the legacy MMU only
> +                * support dirty logging at a 4k granularity.
> +                */
> +               flush = slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
>                 write_unlock(&kvm->mmu_lock);
>         }
>
> --
> 2.33.0.1079.g6e70778dc9-goog
>
