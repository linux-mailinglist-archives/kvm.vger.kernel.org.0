Return-Path: <kvm+bounces-4288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87824810A20
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 07:16:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E3ED28202A
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 06:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC4AF9F7;
	Wed, 13 Dec 2023 06:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WEvFf2Mm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C59F2
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 22:16:33 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-50bf26b677dso6199192e87.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 22:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1702448192; x=1703052992; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aCLT5UxX3ic1D8SnaFGchw7AZpD/VDB8rMNC+FjYo/c=;
        b=WEvFf2MmdMn+WJSArm/FVitURHRMi/rCtct2eF47Gz0sJjoTkb6lxlwaXLqNY6WP7J
         uSVqLTg9M2K2J95jvqnUMWl8Q8B394Stf0UnePzFqLYGvA0BygkUQDxdQtPyVmR5XcEs
         eCbPxGBkHbMJMYecqqsZF8SvkaCsb0rTdQgrORjsuO9EGTch3AUr7+2x4tEvmfPziz9w
         zRwyXzuCTxSiQAFiGVSpULPkSzyfksaA7Gb+6MbApGzpNSciBLHCX372iJy4mdfRAJtc
         /bwIntx1TwfP3e362IScBzdFhp1zZly9gcRy2exCwjZ6Z5i3qg/kdeSvHBEWBOJZbwft
         TrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702448192; x=1703052992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aCLT5UxX3ic1D8SnaFGchw7AZpD/VDB8rMNC+FjYo/c=;
        b=Cyx1xDEqPx6Jmp501Wg+/Bc+3N88WmzQMMvSsKcPcDeaa37lGGK0wqrk2Nyp5UdH7w
         JsGuwiAQBHs42viwkJC4JQbmcyFl8aTxxlm3FNMZf8E2HnqqS+27BZ3v0VDdXc4CLm+f
         q4TNKls/z5PgvkdmXQUe9GWySGP1cOAw6zR1KUlXxze5gg8SfmSmstMgJPgtnNSI1XQ+
         /F4R/mi52xdXWFJ2Clz1cSzuURfyFox4rjYKh4QiW1Fzrj68iUCi67Ox5LPypKvQzZiE
         Yia3Lnv7qpZ1L5Fd+sZFhxjzKbDnegBvQzkSHu2mk4i8ka4ET/pZOQBk7TAo9+qCJiL9
         bxBw==
X-Gm-Message-State: AOJu0YzSnvFHQtfQUyI+29kAD3CQTeRjphcfkAYKzs5163OMUg0SPvr3
	LBqicRNhbSwATHHesdjRSO5W6pahACk/DvFtiX0bRg==
X-Google-Smtp-Source: AGHT+IGyghldClfn31V0MQMWGLZzCGALUHqlVVAMFgcmDYeLOD49X5FAOoL1dW4PLVS+GqzsYn0uP2igPy0TYL4nAIk=
X-Received: by 2002:a19:f717:0:b0:50b:e576:ea2b with SMTP id
 z23-20020a19f717000000b0050be576ea2bmr2067249lfe.126.1702448191950; Tue, 12
 Dec 2023 22:16:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231024132655.730417-1-cleger@rivosinc.com> <20231024132655.730417-5-cleger@rivosinc.com>
In-Reply-To: <20231024132655.730417-5-cleger@rivosinc.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Wed, 13 Dec 2023 11:46:19 +0530
Message-ID: <CAK9=C2WJv4PX5FAAPUcttK4UDDNWdyNWmLG_zXwx60WrMgXO8Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] riscv: kvm: Use SYM_*() assembly macros instead of
 deprecated ones
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Andrew Jones <ajones@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2023 at 6:58=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
> ENTRY()/END()/WEAK() macros are deprecated and we should make use of the
> new SYM_*() macros [1] for better annotation of symbols. Replace the
> deprecated ones with the new ones and fix wrong usage of END()/ENDPROC()
> to correctly describe the symbols.
>
> [1] https://docs.kernel.org/core-api/asm-annotations.html
>
> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Queued this patch for Linux-6.8

Thanks,
Anup


> ---
>  arch/riscv/kvm/vcpu_switch.S | 28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index d74df8eb4d71..8b18473780ac 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -15,7 +15,7 @@
>         .altmacro
>         .option norelax
>
> -ENTRY(__kvm_riscv_switch_to)
> +SYM_FUNC_START(__kvm_riscv_switch_to)
>         /* Save Host GPRs (except A0 and T0-T6) */
>         REG_S   ra, (KVM_ARCH_HOST_RA)(a0)
>         REG_S   sp, (KVM_ARCH_HOST_SP)(a0)
> @@ -208,9 +208,9 @@ __kvm_switch_return:
>
>         /* Return to C code */
>         ret
> -ENDPROC(__kvm_riscv_switch_to)
> +SYM_FUNC_END(__kvm_riscv_switch_to)
>
> -ENTRY(__kvm_riscv_unpriv_trap)
> +SYM_CODE_START(__kvm_riscv_unpriv_trap)
>         /*
>          * We assume that faulting unpriv load/store instruction is
>          * 4-byte long and blindly increment SEPC by 4.
> @@ -231,12 +231,10 @@ ENTRY(__kvm_riscv_unpriv_trap)
>         csrr    a1, CSR_HTINST
>         REG_S   a1, (KVM_ARCH_TRAP_HTINST)(a0)
>         sret
> -ENDPROC(__kvm_riscv_unpriv_trap)
> +SYM_CODE_END(__kvm_riscv_unpriv_trap)
>
>  #ifdef CONFIG_FPU
> -       .align 3
> -       .global __kvm_riscv_fp_f_save
> -__kvm_riscv_fp_f_save:
> +SYM_FUNC_START(__kvm_riscv_fp_f_save)
>         csrr t2, CSR_SSTATUS
>         li t1, SR_FS
>         csrs CSR_SSTATUS, t1
> @@ -276,10 +274,9 @@ __kvm_riscv_fp_f_save:
>         sw t0, KVM_ARCH_FP_F_FCSR(a0)
>         csrw CSR_SSTATUS, t2
>         ret
> +SYM_FUNC_END(__kvm_riscv_fp_f_save)
>
> -       .align 3
> -       .global __kvm_riscv_fp_d_save
> -__kvm_riscv_fp_d_save:
> +SYM_FUNC_START(__kvm_riscv_fp_d_save)
>         csrr t2, CSR_SSTATUS
>         li t1, SR_FS
>         csrs CSR_SSTATUS, t1
> @@ -319,10 +316,9 @@ __kvm_riscv_fp_d_save:
>         sw t0, KVM_ARCH_FP_D_FCSR(a0)
>         csrw CSR_SSTATUS, t2
>         ret
> +SYM_FUNC_END(__kvm_riscv_fp_d_save)
>
> -       .align 3
> -       .global __kvm_riscv_fp_f_restore
> -__kvm_riscv_fp_f_restore:
> +SYM_FUNC_START(__kvm_riscv_fp_f_restore)
>         csrr t2, CSR_SSTATUS
>         li t1, SR_FS
>         lw t0, KVM_ARCH_FP_F_FCSR(a0)
> @@ -362,10 +358,9 @@ __kvm_riscv_fp_f_restore:
>         fscsr t0
>         csrw CSR_SSTATUS, t2
>         ret
> +SYM_FUNC_END(__kvm_riscv_fp_f_restore)
>
> -       .align 3
> -       .global __kvm_riscv_fp_d_restore
> -__kvm_riscv_fp_d_restore:
> +SYM_FUNC_START(__kvm_riscv_fp_d_restore)
>         csrr t2, CSR_SSTATUS
>         li t1, SR_FS
>         lw t0, KVM_ARCH_FP_D_FCSR(a0)
> @@ -405,4 +400,5 @@ __kvm_riscv_fp_d_restore:
>         fscsr t0
>         csrw CSR_SSTATUS, t2
>         ret
> +SYM_FUNC_END(__kvm_riscv_fp_d_restore)
>  #endif
> --
> 2.42.0
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

