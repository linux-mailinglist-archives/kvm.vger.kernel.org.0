Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B035F440867
	for <lists+kvm@lfdr.de>; Sat, 30 Oct 2021 12:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhJ3KrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Oct 2021 06:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbhJ3KrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Oct 2021 06:47:00 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD23CC061714
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 03:44:30 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso5746533wme.3
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 03:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Owxi/n7Fx0SJoSS9cC/e1uduIXAyjAqNAmsPt6qbgto=;
        b=jSkPC/QBK5xxcp1tj1Ts2JvKge7/c8MKntbCcf8Ns9H7K5CPuGw4nxsWOd55iQCYDa
         xx8QL3r8W92+cfwJySYPd6MSYpDbs/OdfNHOhVWA9iq8pguHoZHRLp2uCKkMIzXnse2m
         JDQfbk0CA515yZy9pFFoH13I4cHdhUXimkbmg4CiRXlbTkwP3miZlNDH76lMj9KXRkyG
         1G6Gjo1o0I/Wl9HZxgSwAlFfW0trEj2DimXUpCa9PvV/PPZXSUzCvLdFhvCK79620jmg
         nBWWk+QpLWF39LGhElWnvy9B6xje8TPzHnsua9Kr0hMMLpF2NFvDM2kLB6xoTbvza7A8
         FnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Owxi/n7Fx0SJoSS9cC/e1uduIXAyjAqNAmsPt6qbgto=;
        b=7lpZmDjSN+DRauZQJjgBvh3qoqalf7H1xyw3mxgby5lpqp5K31SmloJEdwXpx8rW9s
         Kqq9Pj7AKfMNal3oFgl1vfN+b1hvwlWVFIH1ubEEP++3ggUpb9tWPrD+96Ojsurd4fH5
         LEX6fa9mDP2LyAePzjZP8TaWYeJ59W/i0SlxGGum6mTgaYxW8oplmJ37GB5T5eQtwt9H
         3OvDdubswArW1VWtOWCtDrC4akDxzLtioZDdgY2WfWgBGzGnE/NwpQW4bP1A9S7B3SdF
         6s3aWpyGVBPYhYbEXJJZJ4j9N86Gk7OotadpcBAGf5/4Kd3PHQZBUeUdElSR+hD3Qtnh
         CilA==
X-Gm-Message-State: AOAM530kzBJqg0gI4DazyaE48puXU2e081BWahFCrLPHFLdRPzLPpyf8
        yA9pqks7VSbng2fWFUCOdiGLfGmvZhS4sDkbxgf6bw==
X-Google-Smtp-Source: ABdhPJwNYuQjuSOJn/muXc1QAfRCjP5LsIUGH6Fmyf7/G9wtn+pWosQjOO+CfVTuGyft/TlJYzIwIhaf5kdB41vdB90=
X-Received: by 2002:a05:600c:2f97:: with SMTP id t23mr26595625wmn.59.1635590669104;
 Sat, 30 Oct 2021 03:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <1635319253-100581-1-git-send-email-cuibixuan@linux.alibaba.com>
In-Reply-To: <1635319253-100581-1-git-send-email-cuibixuan@linux.alibaba.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 30 Oct 2021 16:14:17 +0530
Message-ID: <CAAhSdy2-c1S9SkbpZ-2zZ8vjxaZDgoUhB5-8fnTiXS8+XxFFxg@mail.gmail.com>
Subject: Re: [PATCH -next] RISC-V: KVM: fix boolreturn.cocci warnings
To:     Bixuan Cui <cuibixuan@linux.alibaba.com>
Cc:     KVM General <kvm@vger.kernel.org>, kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.or>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 27, 2021 at 12:51 PM Bixuan Cui <cuibixuan@linux.alibaba.com> wrote:
>
> Fix boolreturn.cocci warnings:
> ./arch/riscv/kvm/mmu.c:603:9-10: WARNING: return of 0/1 in function
> 'kvm_age_gfn' with return type bool
> ./arch/riscv/kvm/mmu.c:582:9-10: WARNING: return of 0/1 in function
> 'kvm_set_spte_gfn' with return type bool
> ./arch/riscv/kvm/mmu.c:621:9-10: WARNING: return of 0/1 in function
> 'kvm_test_age_gfn' with return type bool
> ./arch/riscv/kvm/mmu.c:568:9-10: WARNING: return of 0/1 in function
> 'kvm_unmap_gfn_range' with return type bool
>
> Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>

Looks good to me.

Applied to riscv_kvm_next, Thanks!

Regards,
Anup

> ---
>  arch/riscv/kvm/mmu.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 3a00c2d..d81bae8 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -565,12 +565,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>         if (!kvm->arch.pgd)
> -               return 0;
> +               return false;
>
>         stage2_unmap_range(kvm, range->start << PAGE_SHIFT,
>                            (range->end - range->start) << PAGE_SHIFT,
>                            range->may_block);
> -       return 0;
> +       return false;
>  }
>
>  bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> @@ -579,7 +579,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>         kvm_pfn_t pfn = pte_pfn(range->pte);
>
>         if (!kvm->arch.pgd)
> -               return 0;
> +               return false;
>
>         WARN_ON(range->end - range->start != 1);
>
> @@ -587,10 +587,10 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>                               __pfn_to_phys(pfn), PAGE_SIZE, true, true);
>         if (ret) {
>                 kvm_debug("Failed to map stage2 page (error %d)\n", ret);
> -               return 1;
> +               return true;
>         }
>
> -       return 0;
> +       return false;
>  }
>
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> @@ -600,13 +600,13 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>         u64 size = (range->end - range->start) << PAGE_SHIFT;
>
>         if (!kvm->arch.pgd)
> -               return 0;
> +               return false;
>
>         WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
>
>         if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
>                                    &ptep, &ptep_level))
> -               return 0;
> +               return false;
>
>         return ptep_test_and_clear_young(NULL, 0, ptep);
>  }
> @@ -618,13 +618,13 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>         u64 size = (range->end - range->start) << PAGE_SHIFT;
>
>         if (!kvm->arch.pgd)
> -               return 0;
> +               return false;
>
>         WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
>
>         if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
>                                    &ptep, &ptep_level))
> -               return 0;
> +               return false;
>
>         return pte_young(*ptep);
>  }
> --
> 1.8.3.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
