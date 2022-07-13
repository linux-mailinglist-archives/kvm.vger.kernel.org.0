Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB9572ABC
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 03:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiGMBXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 21:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiGMBXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 21:23:39 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3147A2AFB
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 18:23:35 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-31caffa4a45so98770057b3.3
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 18:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ie5knz6Z7le3iq/Y674AyR+LGN3gRnAoNdlxx7P/y9I=;
        b=RTsKcNxUJJz87MBB2H9d50Uc3Goi8S+lsi1B77YpCFUTLx1Nh7BPBDKPacVZBx1ejr
         zB71wkVArXOsLKhg66kDL+hNE8ZWZrist3SWBobyvIPmFKQNb2Kfb3/5ZFAtHlnL46Lk
         mCo7oVRGdLcynpPypBb3qpQ5njCXRRIxrqPdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ie5knz6Z7le3iq/Y674AyR+LGN3gRnAoNdlxx7P/y9I=;
        b=aWeLEoB8HbPwYnNr/d/jQsP/zBJnfdf1P9P+T/entGJjMZjZ4jzpsVePsWF/RjNZQL
         1E8Kr6hTCPR22Dk+Wf30MZRKhlPI4E+8aVrb3AnsJHCulvebuLN+Jqz5MkwlOCFBF0ys
         kvazSPHNxlJJRmUvMEZZ+n8627yipN77nbpt0fX7XNzYx0WhexB9yW5a6oyCkq361x8y
         iSdCs0qkfnjhZD5nRcweT5qnjmcKRkfHl+8sydg8QCCiWLStJQXhn+LRu8wM41e5ja1K
         N3Egd7y0NQE7TYrd2LnJEekIvaz2OJeHFamwmgEFOgQkjQTNfYqo17qSNVeAQTaYmPFg
         n+3g==
X-Gm-Message-State: AJIora+dWdQT9NyzE461fJeQwOEAo6I+vYUTKh8v7/or6LH5v1ec7s5h
        oYDvawYYxDQ8i56E9FP3nnpA8859D6XnumN+0l1r
X-Google-Smtp-Source: AGRyM1tqyP71llyjRs2TrZupwm5NzJqxWxkUC/TBWrNYs7b2AbEUEKsjzxC+kLWriHpNto4Ma84s+Tf/oDKV492vYnI=
X-Received: by 2002:a81:1514:0:b0:31c:a84b:350a with SMTP id
 20-20020a811514000000b0031ca84b350amr1426871ywv.400.1657675414441; Tue, 12
 Jul 2022 18:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220707145248.458771-1-apatel@ventanamicro.com> <20220707145248.458771-5-apatel@ventanamicro.com>
In-Reply-To: <20220707145248.458771-5-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 12 Jul 2022 18:23:23 -0700
Message-ID: <CAOnJCUKjFMMsrNWR=hzB+qbw4SECWS3+DOJDun90emnM-Vkpiw@mail.gmail.com>
Subject: Re: [PATCH 4/5] RISC-V: KVM: Use PAGE_KERNEL_IO in kvm_riscv_gstage_ioremap()
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 7, 2022 at 7:53 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> When the host has Svpbmt extension, we should use page based memory
> type 2 (i.e. IO) for IO mappings in the G-stage page table.
>
> To achieve this, we replace use of PAGE_KERNEL with PAGE_KERNEL_IO
> in the kvm_riscv_gstage_ioremap().
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f7862ca4c4c6..bc545aef6034 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -361,7 +361,7 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
>         pfn = __phys_to_pfn(hpa);
>
>         for (addr = gpa; addr < end; addr += PAGE_SIZE) {
> -               pte = pfn_pte(pfn, PAGE_KERNEL);
> +               pte = pfn_pte(pfn, PAGE_KERNEL_IO);
>
>                 if (!writable)
>                         pte = pte_wrprotect(pte);
> --
> 2.34.1
>

LGTM.

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
