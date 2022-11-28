Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F9863B3EC
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 22:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiK1VHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 16:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiK1VGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 16:06:39 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2A73123A
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:06:16 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id db10-20020a0568306b0a00b0066d43e80118so7828184otb.1
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p9UkJ7VBK4eJN8AOTn00Jhc8bbgrKXPIVkvokyH+neY=;
        b=EmNdPKsuUWm0ICW46GQTce/XFTAmWmWRaSzqVOqzVe4444xImnX8wNT0TjXvCrssBA
         si6x24ctUI4ZKzFWD+ms6IpNmjTVAjJjEelqL3zY4Aiq/MP/FhqYegvTazy5jqCqOrKD
         4/zF+psi/VY579MvmhrQW/sQ0O/3h4GyI3glA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p9UkJ7VBK4eJN8AOTn00Jhc8bbgrKXPIVkvokyH+neY=;
        b=hyl9r60pOCxHz3ZyFJobpT3CiMgnXxRfeliVXZf/ccfHKBCDDHCDfCTr18liCo5MiK
         n5hlf0xyv/UqrEAsoVjFuq69TeICh7pVon5VEYVIH5NmT/Aof6t0zGWEJKJ5/5dKbFAS
         M1sEEXlfVjMsMVT9yxuxs6Sa/L1V5OFGh7BCThyGksFay1vqpSne33nffHoceaXqnvuK
         xcGjD8NLRoz8D1Y46lBc/PQkePJEFQ9ohIKdPh3QFV4aNCKqocBcAtVbEzaVkUDV5jSr
         QCrGC0+dwLpWR3WIim6EssPuwaIRpMASiZB1R0zOD45NtOzfL/RM1xRWuotCbji+6G4/
         +MDQ==
X-Gm-Message-State: ANoB5plj+UBuncmVm2BcfdYCEFbiE7jwnMb8O498xeLnomJIdRzVKAcV
        Bu54SVK+9IAPFuc7HkyeNH9QuPskT33uUlpWLOCPMdJRbg==
X-Google-Smtp-Source: AA0mqf7RBLreP49klQg2LDKQ4TT5Rwzv5tU1ZyPle4LEpP4LySP+j+8Yoj1VhUzfRZBgKV7y5mijlxol7Qbga2t4Qyk=
X-Received: by 2002:a05:6830:22f2:b0:669:3797:c1b4 with SMTP id
 t18-20020a05683022f200b006693797c1b4mr25619436otc.293.1669669575965; Mon, 28
 Nov 2022 13:06:15 -0800 (PST)
MIME-Version: 1.0
References: <20221128161424.608889-1-apatel@ventanamicro.com> <20221128161424.608889-6-apatel@ventanamicro.com>
In-Reply-To: <20221128161424.608889-6-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 28 Nov 2022 13:06:05 -0800
Message-ID: <CAOnJCU+VbNhRQEbCYwzB75d=VzuhO6=++KC6w5S+Fg0p52QaNg@mail.gmail.com>
Subject: Re: [PATCH 5/9] RISC-V: KVM: Move sbi related struct and functions to kvm_vcpu_sbi.h
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

On Mon, Nov 28, 2022 at 8:14 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> Just like asm/kvm_vcpu_timer.h, we should have all sbi related struct
> and functions in asm/kvm_vcpu_sbi.h.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h     | 10 ++--------
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  6 ++++++
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 6502f9099965..91c74b09a970 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -16,6 +16,7 @@
>  #include <asm/hwcap.h>
>  #include <asm/kvm_vcpu_fp.h>
>  #include <asm/kvm_vcpu_insn.h>
> +#include <asm/kvm_vcpu_sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
>
>  #define KVM_MAX_VCPUS                  1024
> @@ -94,10 +95,6 @@ struct kvm_arch {
>         struct kvm_guest_timer timer;
>  };
>
> -struct kvm_sbi_context {
> -       int return_handled;
> -};
> -
>  struct kvm_cpu_trap {
>         unsigned long sepc;
>         unsigned long scause;
> @@ -216,7 +213,7 @@ struct kvm_vcpu_arch {
>         struct kvm_csr_decode csr_decode;
>
>         /* SBI context */
> -       struct kvm_sbi_context sbi_context;
> +       struct kvm_vcpu_sbi_context sbi_context;
>
>         /* Cache pages needed to program page tables with spinlock held */
>         struct kvm_mmu_memory_cache mmu_page_cache;
> @@ -326,7 +323,4 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
>  void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
>
> -int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
> -int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
> -
>  #endif /* __RISCV_KVM_HOST_H__ */
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index d4e3e600beef..f79478a85d2d 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -14,6 +14,10 @@
>  #define KVM_SBI_VERSION_MAJOR 1
>  #define KVM_SBI_VERSION_MINOR 0
>
> +struct kvm_vcpu_sbi_context {
> +       int return_handled;
> +};
> +
>  struct kvm_vcpu_sbi_extension {
>         unsigned long extid_start;
>         unsigned long extid_end;
> @@ -31,7 +35,9 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
>                                      struct kvm_run *run,
>                                      u32 type, u64 flags);
> +int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
> +int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>
>  #ifdef CONFIG_RISCV_SBI_V01
>  extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
-- 
Regards,
Atish
