Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644766828CE
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjAaJ2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjAaJ2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:28:01 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8D49753
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:28:00 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso18394701pjj.1
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cRicPiuaBpPdTHFzOhiCezQ5GuYSGllcRPaK1dz/uvE=;
        b=b68LiQHhWG3BL76DPGqfQQR8n8lH8MhamuMSFuRccumQrqSxrFcpNzdHuWE0ZrmaOj
         85t7w84ieF8VtgWrBMU3b93HPfiZRrsIzU6QEDBpWc3JT9ufUkERMQdZqInh/l18wd7n
         TXnnQ3LerHMIrQesfDzvyGDIPEEXsmufdJmro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cRicPiuaBpPdTHFzOhiCezQ5GuYSGllcRPaK1dz/uvE=;
        b=I2ybWQ7OfxEM/JTf/wrddD38Fi7yGx/oEFlCHU/fweWgNiQh9Nkf50bx3p9RIp7NPP
         YWiRcfDT7HHrAS/9UXJLaevq/NSGU/AHJKRins3EXypn7lmGJ0Zf4LNSlclTfXZ7xFYr
         EcmnObBYElxScla962GrrqHISO3k/XHSh0W+eDm2YGxt9peZ7CSWaKaDQBkOfyrWseg+
         Nn8UBSAAf64JCy0RjKtqelC2sQmeoGYfsETSKL74aGnIkCGjr7ZJXUyTc7us4t0IJItj
         SrTQ+gP86D7IiH+BbEYtdKXr7oDS1qRzcVaKBy1tQr9X6E5PwjPNnIOLPPKmziZuEZMA
         Up1A==
X-Gm-Message-State: AFqh2koY9TR0xobaGCFJIxf+zVQNtfG32xYNwO7HrEsyQaioZLJpCLVO
        ovWoG3f73yDv80akyQdRvAWVWxh8qqP84/hv302E
X-Google-Smtp-Source: AMrXdXuqJZe71wMHsvHQa+/ofcNqzAcOCHpQvFAoA3yjOjAFaR3HQs3cLMhLk6QI5qrARLILCxRb9Lw/BmeYIUF58Rg=
X-Received: by 2002:a17:902:8f8a:b0:193:794:ba9 with SMTP id
 z10-20020a1709028f8a00b0019307940ba9mr6658889plo.22.1675157280064; Tue, 31
 Jan 2023 01:28:00 -0800 (PST)
MIME-Version: 1.0
References: <20230128072737.2995881-1-apatel@ventanamicro.com> <20230128072737.2995881-4-apatel@ventanamicro.com>
In-Reply-To: <20230128072737.2995881-4-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 31 Jan 2023 01:27:48 -0800
Message-ID: <CAOnJCUKDYkJz0RNEYnPFrSax7e8cATvqYTXwPA+58Y8zVqEZCQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID
 mask defines
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:28 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The hgatp.VMID mask defines are used before shifting when extracting
> VMID value from hgatp CSR value so based on the convention followed
> in the other parts of asm/csr.h, the hgatp.VMID mask defines should
> not have a _MASK suffix.
>
> While we are here, let's use GENMASK() for hgatp.VMID and hgatp.PPN.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/include/asm/csr.h | 12 ++++++------
>  arch/riscv/kvm/mmu.c         |  3 +--
>  arch/riscv/kvm/vmid.c        |  4 ++--
>  3 files changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 3c8d68152bce..3176355cf4e9 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -131,25 +131,25 @@
>
>  #define HGATP32_MODE_SHIFT     31
>  #define HGATP32_VMID_SHIFT     22
> -#define HGATP32_VMID_MASK      _AC(0x1FC00000, UL)
> -#define HGATP32_PPN            _AC(0x003FFFFF, UL)
> +#define HGATP32_VMID           GENMASK(28, 22)
> +#define HGATP32_PPN            GENMASK(21, 0)
>
>  #define HGATP64_MODE_SHIFT     60
>  #define HGATP64_VMID_SHIFT     44
> -#define HGATP64_VMID_MASK      _AC(0x03FFF00000000000, UL)
> -#define HGATP64_PPN            _AC(0x00000FFFFFFFFFFF, UL)
> +#define HGATP64_VMID           GENMASK(57, 44)
> +#define HGATP64_PPN            GENMASK(43, 0)
>
>  #define HGATP_PAGE_SHIFT       12
>
>  #ifdef CONFIG_64BIT
>  #define HGATP_PPN              HGATP64_PPN
>  #define HGATP_VMID_SHIFT       HGATP64_VMID_SHIFT
> -#define HGATP_VMID_MASK                HGATP64_VMID_MASK
> +#define HGATP_VMID             HGATP64_VMID
>  #define HGATP_MODE_SHIFT       HGATP64_MODE_SHIFT
>  #else
>  #define HGATP_PPN              HGATP32_PPN
>  #define HGATP_VMID_SHIFT       HGATP32_VMID_SHIFT
> -#define HGATP_VMID_MASK                HGATP32_VMID_MASK
> +#define HGATP_VMID             HGATP32_VMID
>  #define HGATP_MODE_SHIFT       HGATP32_MODE_SHIFT
>  #endif
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index dbc4ca060174..829a7065ae01 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -748,8 +748,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
>         unsigned long hgatp = gstage_mode;
>         struct kvm_arch *k = &vcpu->kvm->arch;
>
> -       hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) &
> -                HGATP_VMID_MASK;
> +       hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_VMID;
>         hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
>
>         csr_write(CSR_HGATP, hgatp);
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 6cd93995fb65..6f4d4979a759 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -26,9 +26,9 @@ void kvm_riscv_gstage_vmid_detect(void)
>
>         /* Figure-out number of VMID bits in HW */
>         old = csr_read(CSR_HGATP);
> -       csr_write(CSR_HGATP, old | HGATP_VMID_MASK);
> +       csr_write(CSR_HGATP, old | HGATP_VMID);
>         vmid_bits = csr_read(CSR_HGATP);
> -       vmid_bits = (vmid_bits & HGATP_VMID_MASK) >> HGATP_VMID_SHIFT;
> +       vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
>         vmid_bits = fls_long(vmid_bits);
>         csr_write(CSR_HGATP, old);
>
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

-- 
Regards,
Atish
