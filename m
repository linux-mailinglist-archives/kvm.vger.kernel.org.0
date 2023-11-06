Return-Path: <kvm+bounces-812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA9CF7E2B6D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 18:47:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 716D5281803
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5AE2C862;
	Mon,  6 Nov 2023 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="xwHBJzAw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E8329D0F
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 17:47:32 +0000 (UTC)
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF9DD4C
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 09:47:30 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6ce322b62aeso2999317a34.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 09:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1699292849; x=1699897649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AjiTCAPQ/Dvh52BiHkeWzErmU2ehyc+Vb2ES67exqnE=;
        b=xwHBJzAw/uzAkKsYhpH7d2DW8I+ChudZ66luAjAoiv8RYK/2HYoEAPXUGoLadZbfyU
         YZp+4KPx5d90muzJJ7pS547Gd1mUIm9mRNYQpfP/xaEpf9ETH87n08ljjSNwzSc16bWJ
         KMuLLkPMwuyjuDeoatltmCjG+a0surbeI9J1FNsXE6JRFzPnLSJmIddIdnOP7rhdUVit
         U1dQ43B/XiYUe1a6lajh8RVopO7fVKF3sOG4xEe4mWRmy7XiZIqv6/cR4S6IGqHwRTUc
         BeVtiY8pqIRtEh655JjZoy3M7typfmtz2pNuQOHbxmhE+V+C5ikWx9gx4d5pCHFHX9Ic
         Yp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699292849; x=1699897649;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AjiTCAPQ/Dvh52BiHkeWzErmU2ehyc+Vb2ES67exqnE=;
        b=T9ZujR9tTE0wACl54Rc/T7Sj+M3cFm50N2VgMxi7X6eOl4GgpUNnCPM/TARaCdDPxC
         i9F8FmeE9FSdPYGkJZ5bjEh0COcec5xGVnx+WFcqt3gG5xxVAfMNrjjj95NaP5LsQ+zl
         yfxiuGwIbJJAXSQFf76pkQ4WV8zN7UEfpz80s3V06jSvH2Qo6dioHkSe5Ki8fSmR8uYW
         gSNRwGIrqbn0okMVx+JfNc2B5mN8dkPqFWssjAQtWPjs5kVmWEJoINDDqsfCRiWLvcDA
         DSqLAjcn1l01twQZS70B8s+s5XCwnC8V3MKEIpi+Pj2XRzBcfFHzOn0mx4qBJyQ7VY7m
         Cnrg==
X-Gm-Message-State: AOJu0Yw98G5PSpVqQyhbSkpYTsnl/ZHxTTOUpP/qFsmxOAWb3/UnF9fc
	gcv/x8m/8HNLA3tMzEG5+YcXBA==
X-Google-Smtp-Source: AGHT+IFHaQWxtub12aD9f9065e5oc0uXm1/nB/k434xLnQkRciT453rkxM4oCkVOVhn2njVQQYU0sw==
X-Received: by 2002:a05:6830:925:b0:6cd:8c8:1654 with SMTP id v37-20020a056830092500b006cd08c81654mr35325191ott.2.1699292849495;
        Mon, 06 Nov 2023 09:47:29 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id az5-20020a056830458500b006c4727812fdsm1340215otb.15.2023.11.06.09.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 09:47:28 -0800 (PST)
Date: Mon, 06 Nov 2023 09:47:28 -0800 (PST)
X-Google-Original-Date: Mon, 06 Nov 2023 09:40:24 PST (-0800)
Subject:     Re: [PATCH v2 4/5] riscv: kvm: Use SYM_*() assembly macros instead of deprecated ones
In-Reply-To: <20231024132655.730417-5-cleger@rivosinc.com>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  anup@brainfault.org, atishp@atishpatra.org, ajones@ventanamicro.com, cleger@rivosinc.com,
  linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
  kvm-riscv@lists.infradead.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: cleger@rivosinc.com
Message-ID: <mhng-a152f6da-63a0-4863-a637-e6ee4f4fa4d7@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 24 Oct 2023 06:26:54 PDT (-0700), cleger@rivosinc.com wrote:
> ENTRY()/END()/WEAK() macros are deprecated and we should make use of the
> new SYM_*() macros [1] for better annotation of symbols. Replace the
> deprecated ones with the new ones and fix wrong usage of END()/ENDPROC()
> to correctly describe the symbols.
>
> [1] https://docs.kernel.org/core-api/asm-annotations.html
>
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_switch.S | 28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index d74df8eb4d71..8b18473780ac 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -15,7 +15,7 @@
>  	.altmacro
>  	.option norelax
>
> -ENTRY(__kvm_riscv_switch_to)
> +SYM_FUNC_START(__kvm_riscv_switch_to)
>  	/* Save Host GPRs (except A0 and T0-T6) */
>  	REG_S	ra, (KVM_ARCH_HOST_RA)(a0)
>  	REG_S	sp, (KVM_ARCH_HOST_SP)(a0)
> @@ -208,9 +208,9 @@ __kvm_switch_return:
>
>  	/* Return to C code */
>  	ret
> -ENDPROC(__kvm_riscv_switch_to)
> +SYM_FUNC_END(__kvm_riscv_switch_to)
>
> -ENTRY(__kvm_riscv_unpriv_trap)
> +SYM_CODE_START(__kvm_riscv_unpriv_trap)
>  	/*
>  	 * We assume that faulting unpriv load/store instruction is
>  	 * 4-byte long and blindly increment SEPC by 4.
> @@ -231,12 +231,10 @@ ENTRY(__kvm_riscv_unpriv_trap)
>  	csrr	a1, CSR_HTINST
>  	REG_S	a1, (KVM_ARCH_TRAP_HTINST)(a0)
>  	sret
> -ENDPROC(__kvm_riscv_unpriv_trap)
> +SYM_CODE_END(__kvm_riscv_unpriv_trap)
>
>  #ifdef	CONFIG_FPU
> -	.align 3
> -	.global __kvm_riscv_fp_f_save
> -__kvm_riscv_fp_f_save:
> +SYM_FUNC_START(__kvm_riscv_fp_f_save)
>  	csrr t2, CSR_SSTATUS
>  	li t1, SR_FS
>  	csrs CSR_SSTATUS, t1
> @@ -276,10 +274,9 @@ __kvm_riscv_fp_f_save:
>  	sw t0, KVM_ARCH_FP_F_FCSR(a0)
>  	csrw CSR_SSTATUS, t2
>  	ret
> +SYM_FUNC_END(__kvm_riscv_fp_f_save)
>
> -	.align 3
> -	.global __kvm_riscv_fp_d_save
> -__kvm_riscv_fp_d_save:
> +SYM_FUNC_START(__kvm_riscv_fp_d_save)
>  	csrr t2, CSR_SSTATUS
>  	li t1, SR_FS
>  	csrs CSR_SSTATUS, t1
> @@ -319,10 +316,9 @@ __kvm_riscv_fp_d_save:
>  	sw t0, KVM_ARCH_FP_D_FCSR(a0)
>  	csrw CSR_SSTATUS, t2
>  	ret
> +SYM_FUNC_END(__kvm_riscv_fp_d_save)
>
> -	.align 3
> -	.global __kvm_riscv_fp_f_restore
> -__kvm_riscv_fp_f_restore:
> +SYM_FUNC_START(__kvm_riscv_fp_f_restore)
>  	csrr t2, CSR_SSTATUS
>  	li t1, SR_FS
>  	lw t0, KVM_ARCH_FP_F_FCSR(a0)
> @@ -362,10 +358,9 @@ __kvm_riscv_fp_f_restore:
>  	fscsr t0
>  	csrw CSR_SSTATUS, t2
>  	ret
> +SYM_FUNC_END(__kvm_riscv_fp_f_restore)
>
> -	.align 3
> -	.global __kvm_riscv_fp_d_restore
> -__kvm_riscv_fp_d_restore:
> +SYM_FUNC_START(__kvm_riscv_fp_d_restore)
>  	csrr t2, CSR_SSTATUS
>  	li t1, SR_FS
>  	lw t0, KVM_ARCH_FP_D_FCSR(a0)
> @@ -405,4 +400,5 @@ __kvm_riscv_fp_d_restore:
>  	fscsr t0
>  	csrw CSR_SSTATUS, t2
>  	ret
> +SYM_FUNC_END(__kvm_riscv_fp_d_restore)
>  #endif

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>

