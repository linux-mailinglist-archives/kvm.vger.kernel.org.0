Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C7067F8D1
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 15:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjA1Ouu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 09:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjA1Out (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 09:50:49 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F612A985
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 06:50:48 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id n6so4512428edo.9
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 06:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DBXSTbWOpbyF5+frNOEk/hH0Z+eGpJNPlrQ7g8wtf0A=;
        b=uUexcNfO30UjCbKwKx74Gql5Rmx8+ALCuoDRocqRbFMEtf44z9k+/xg21ePsEYmK8c
         2BkiSlNp/04fIILL5bIOwrFM1cKPrHD8aWAFQyMnI9JCvt/IwQ1HYAVLfZPXKiMegtFS
         mBxh9fmTmlx0mpAuGnNU5a/p5zZgeGhj/obdzu0vKSWnVAD1S2OBCxy18VJTOfW5fEkI
         QP5YN9ixsZ3LXMrj9IQkhWTBGPOgihIYbU4SH4erx3LAlrpaFnfT6V+xX0mCudfs1bex
         8GbmvOaDj/CjeVK7uPTXdV1rC71ygd/HQ000TH/Ls/QR5UnJnlhgZdxjgzhRnxlBYqnz
         Xu/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DBXSTbWOpbyF5+frNOEk/hH0Z+eGpJNPlrQ7g8wtf0A=;
        b=2F/xn8UxFhahIyIm0gMCoKNCBDoyrLiRCA+h9a96yj4u6QdNbFJ3mM9yEY+Gk5Tn1n
         3vAPQjmIu0eZW6o8z+RNjy9q232f/U6UH/cMZD0PLE1HHvTV0d6ehiQcux1BL/7UB11S
         qeWDDWN9QtnEvSweoTFznyi52Ms5c3v5n9EdrRWMzNQ3KmwbH7Grwtykvgu+aN+PckCR
         2MkylyOLhuFyNLxH+9+2LmPWuzzou0IbR1+jcctMK6uODbiJHXiBIHxb3SLV4CCzBh6n
         TN3tYfj/VsFMt6v0ADkUxRMcOMV7Tp3pQfSaLFDgAyfRyiWj2ehG5dXz3UxHrf2nv3fU
         hIIw==
X-Gm-Message-State: AFqh2kqi9bGZqTWbc3LTXjYAWWwghmPrT2xu+bpgwaAPPkl5qOewOEB2
        Gc3ALNm6G+lcAbFza59NebskdiojCRLBIuzHjHlADQ==
X-Google-Smtp-Source: AMrXdXtSWGV7otTK1SyQ3Ij49MHvVuSfLEnVU/bhRk6Fxe5rygpK3j2j9KrgO9F/Thb8es1Wg+EwZVYHecWfUWVoFbg=
X-Received: by 2002:a05:6402:378c:b0:49c:1316:d9d1 with SMTP id
 et12-20020a056402378c00b0049c1316d9d1mr7556998edb.12.1674917446995; Sat, 28
 Jan 2023 06:50:46 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-5-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-5-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 28 Jan 2023 20:20:34 +0530
Message-ID: <CAAhSdy1MHE29vwTU1Tafo+g7fmi2JXznAUe5_pGv-boW0M8oFA@mail.gmail.com>
Subject: Re: [PATCH v3 04/14] RISC-V: KVM: Define a probe function for SBI
 extension data structures
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> Currently the probe function just checks if an SBI extension is
> registered or not. However, the extension may not want to advertise
> itself depending on some other condition.
> An additional extension specific probe function will allow
> extensions to decide if they want to be advertised to the caller or
> not. Any extension that does not require additional dependency checks
> can avoid implementing this function.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
>  arch/riscv/kvm/vcpu_sbi_base.c        | 13 +++++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index f79478a..45ba341 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -29,6 +29,9 @@ struct kvm_vcpu_sbi_extension {
>         int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                        unsigned long *out_val, struct kvm_cpu_trap *utrap,
>                        bool *exit);
> +
> +       /* Extension specific probe function */
> +       unsigned long (*probe)(struct kvm_vcpu *vcpu);
>  };
>
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 5d65c63..846d518 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -19,6 +19,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  {
>         int ret = 0;
>         struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       const struct kvm_vcpu_sbi_extension *sbi_ext;
>
>         switch (cp->a6) {
>         case SBI_EXT_BASE_GET_SPEC_VERSION:
> @@ -43,8 +44,16 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>                          */
>                         kvm_riscv_vcpu_sbi_forward(vcpu, run);
>                         *exit = true;
> -               } else
> -                       *out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
> +               } else {
> +                       sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> +                       if (sbi_ext) {
> +                               if (sbi_ext->probe)
> +                                       *out_val = sbi_ext->probe(vcpu);
> +                               else
> +                                       *out_val = 1;
> +                       } else
> +                               *out_val = 0;
> +               }
>                 break;
>         case SBI_EXT_BASE_GET_MVENDORID:
>                 *out_val = vcpu->arch.mvendorid;
> --
> 2.25.1
>
