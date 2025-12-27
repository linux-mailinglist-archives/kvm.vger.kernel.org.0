Return-Path: <kvm+bounces-66718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DCCFCDFC36
	for <lists+kvm@lfdr.de>; Sat, 27 Dec 2025 13:52:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A0C53025FB0
	for <lists+kvm@lfdr.de>; Sat, 27 Dec 2025 12:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C6D31A04D;
	Sat, 27 Dec 2025 12:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOFEWRCs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFD13126C9
	for <kvm@vger.kernel.org>; Sat, 27 Dec 2025 12:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766839758; cv=none; b=XPMqqJo0B9ixeXZNyp6XZekSQBte0+mefSEe2sGH8KFRjXYopN131uvLfUFn38iM3nCJnrPGQvydvnThKA8DNKPrSL86UiyeDCB7q3G9WNrBkpcBrz9T282BmjCLhThqF+aUofN2Rj1JtiHmw2oZ9nw50YFL9ejSnsWrqJifeqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766839758; c=relaxed/simple;
	bh=0kfMRiadnGarHTALRRW411hh4urIGuwlrxzm+obaeeo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bi6E00fP6N57E8fYcQOR3cTuhJu+d95qnaRVW8TA6BLZioX7viKnuV2iffGl1W7EvTMlIVk0rJKRGE2TAF7KMf9r7kx90mNizfzsySTfNsQfcPLpkVZWeQXlFImubEJ6F9fBUQATWc0ONZdmL+GSEQUk1QGoo+a/C1TxkfpmxWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOFEWRCs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CE3C4AF09
	for <kvm@vger.kernel.org>; Sat, 27 Dec 2025 12:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766839758;
	bh=0kfMRiadnGarHTALRRW411hh4urIGuwlrxzm+obaeeo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UOFEWRCsnKFg9u0eMWOp7mzMvsSYqeNed7NVPxhEBoDSx8nRaCf2SZLym+t0flOTp
	 8mpXL6oZKeEFgYTjZP9/T24300hr3pTARneiuODz1w6Om79A3ZdRjuASJ5uQDyDN0o
	 uvALQLeXbYMbXAed4tWZgwHWHJOlxhlk5rKH7FEazqhTknGOpO7d+KA2E4uPgZNQEK
	 aIM4Yyh04ybCv76jaB4dqLA6NUMqYcNdS8vF9ADMbSIyvXKUi17rk5dapZ09ccdJFe
	 PzMmEEH0CSXpJu4V3gYBStDjH0ApfbvC25z2fpr1dt7aMK5kTlgRh7AdAqHstd3DYy
	 52yicC1oi8++w==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b802d5e9f06so1003669366b.1
        for <kvm@vger.kernel.org>; Sat, 27 Dec 2025 04:49:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUb43PELsI6NrE5VIwd8FYwK5vLHb3KKmEhdw+zTAI0nkFYws5eFwZfkMIfidkV8lwHAU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGVsRhn0sOz+iUmS0BgYgJGMFQeZJSJ6nDyXj8S4Qqr0gqjShU
	i8DxiQMf69BJyjMw7eQzD/20dO0VGSbT44Yv+1wdcOZJyvgJzkck54K8iAFc3dB3H22/Cdvtz3W
	mMhQva9y5RFxdZA4T2OXAYaZmnZlMSfY=
X-Google-Smtp-Source: AGHT+IEsqJc6khAJ2cHADfIJcu27io1v3NCx+cZczeIdVZMpBJsCG/bgaEOBzeDbgzYZiUCK4ID38MWYx4XuE0EW6xs=
X-Received: by 2002:a17:907:d0c:b0:b73:9280:2e7 with SMTP id
 a640c23a62f3a-b80371a3eacmr2514207366b.34.1766839756759; Sat, 27 Dec 2025
 04:49:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251227012712.2921408-1-lixianglai@loongson.cn> <20251227012712.2921408-3-lixianglai@loongson.cn>
In-Reply-To: <20251227012712.2921408-3-lixianglai@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 27 Dec 2025 20:49:34 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6vxwDkBUQgY=YKnhk+3i_hW06E0UFLHK5F3VnG7tzdwA@mail.gmail.com>
X-Gm-Features: AQt7F2o4bcq8N1cKAf4bYOyGrQYxTcPXCNmzgRy8noVX91JZSVXC4jPh3i1tjbc
Message-ID: <CAAhV-H6vxwDkBUQgY=YKnhk+3i_hW06E0UFLHK5F3VnG7tzdwA@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Xianglai Li <lixianglai@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, stable@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Tiezhu Yang <yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Xianglai,

On Sat, Dec 27, 2025 at 9:52=E2=80=AFAM Xianglai Li <lixianglai@loongson.cn=
> wrote:
>
> Insert the appropriate UNWIND macro definition into the kvm_exc_entry in
> the assembly function to guide the generation of correct ORC table entrie=
s,
> thereby solving the timeout problem of loading the livepatch-sample modul=
e
> on a physical machine running multiple vcpus virtual machines.
>
> While solving the above problems, we have gained an additional benefit,
> that is, we can obtain more call stack information
>
> Stack information that can be obtained before the problem is fixed:
> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> [<0>] kvm_exc_entry+0x100/0x1e0
>
> Stack information that can be obtained after the problem is fixed:
> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
> [<0>] kvm_exc_entry+0x104/0x1e4
> [<0>] kvm_enter_guest+0x38/0x11c
> [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
> [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
> [<0>] sys_ioctl+0x498/0xf00
> [<0>] do_syscall+0x98/0x1d0
> [<0>] handle_syscall+0xb8/0x158
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Charlie Jenkins <charlie@rivosinc.com>
> Cc: Xianglai Li <lixianglai@loongson.cn>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
>
>  arch/loongarch/kvm/switch.S | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index 93845ce53651..a3ea9567dbe5 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -10,6 +10,7 @@
>  #include <asm/loongarch.h>
>  #include <asm/regdef.h>
>  #include <asm/unwind_hints.h>
> +#include <linux/kvm_types.h>
>
>  #define HGPR_OFFSET(x)         (PT_R0 + 8*x)
>  #define GGPR_OFFSET(x)         (KVM_ARCH_GGPR + 8*x)
> @@ -110,9 +111,9 @@
>          * need to copy world switch code to DMW area.
>          */
>         .text
> +       .p2align PAGE_SHIFT
>         .cfi_sections   .debug_frame
>  SYM_CODE_START(kvm_exc_entry)
> -       .p2align PAGE_SHIFT
>         UNWIND_HINT_UNDEFINED
>         csrwr   a2,   KVM_TEMP_KS
>         csrrd   a2,   KVM_VCPU_KS
> @@ -170,6 +171,7 @@ SYM_CODE_START(kvm_exc_entry)
>         /* restore per cpu register */
>         ld.d    u0, a2, KVM_ARCH_HPERCPU
>         addi.d  sp, sp, -PT_SIZE
> +       UNWIND_HINT_REGS
>
>         /* Prepare handle exception */
>         or      a0, s0, zero
> @@ -200,7 +202,7 @@ ret_to_host:
>         jr      ra
>
>  SYM_CODE_END(kvm_exc_entry)
> -EXPORT_SYMBOL(kvm_exc_entry)
> +EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
Why not use EXPORT_SYMBOL_FOR_KVM in the first patch directly?

>
>  /*
>   * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
> @@ -215,6 +217,14 @@ SYM_FUNC_START(kvm_enter_guest)
>         /* Save host GPRs */
>         kvm_save_host_gpr a2
>
> +       /*
> +        * The csr_era member variable of the pt_regs structure is requir=
ed
> +        * for unwinding orc to perform stack traceback, so we need to pu=
t
> +        * pc into csr_era member variable here.
> +        */
> +       pcaddi  t0, 0
> +       st.d    t0, a2, PT_ERA
I am still confused here, does this overwrite PT_ERA stored by
kvm_save_host_gpr?

Huacai

> +
>         addi.d  a2, a1, KVM_VCPU_ARCH
>         st.d    sp, a2, KVM_ARCH_HSP
>         st.d    tp, a2, KVM_ARCH_HTP
> @@ -225,7 +235,7 @@ SYM_FUNC_START(kvm_enter_guest)
>         csrwr   a1, KVM_VCPU_KS
>         kvm_switch_to_guest
>  SYM_FUNC_END(kvm_enter_guest)
> -EXPORT_SYMBOL(kvm_enter_guest)
> +EXPORT_SYMBOL_FOR_KVM(kvm_enter_guest)
>
>  SYM_FUNC_START(kvm_save_fpu)
>         fpu_save_csr    a0 t1
> @@ -233,7 +243,7 @@ SYM_FUNC_START(kvm_save_fpu)
>         fpu_save_cc     a0 t1 t2
>         jr              ra
>  SYM_FUNC_END(kvm_save_fpu)
> -EXPORT_SYMBOL(kvm_save_fpu)
> +EXPORT_SYMBOL_FOR_KVM(kvm_save_fpu)
>
>  SYM_FUNC_START(kvm_restore_fpu)
>         fpu_restore_double a0 t1
> @@ -241,7 +251,7 @@ SYM_FUNC_START(kvm_restore_fpu)
>         fpu_restore_cc     a0 t1 t2
>         jr                 ra
>  SYM_FUNC_END(kvm_restore_fpu)
> -EXPORT_SYMBOL(kvm_restore_fpu)
> +EXPORT_SYMBOL_FOR_KVM(kvm_restore_fpu)
>
>  #ifdef CONFIG_CPU_HAS_LSX
>  SYM_FUNC_START(kvm_save_lsx)
> @@ -250,7 +260,7 @@ SYM_FUNC_START(kvm_save_lsx)
>         lsx_save_data   a0 t1
>         jr              ra
>  SYM_FUNC_END(kvm_save_lsx)
> -EXPORT_SYMBOL(kvm_save_lsx)
> +EXPORT_SYMBOL_FOR_KVM(kvm_save_lsx)
>
>  SYM_FUNC_START(kvm_restore_lsx)
>         lsx_restore_data a0 t1
> @@ -258,7 +268,7 @@ SYM_FUNC_START(kvm_restore_lsx)
>         fpu_restore_csr  a0 t1 t2
>         jr               ra
>  SYM_FUNC_END(kvm_restore_lsx)
> -EXPORT_SYMBOL(kvm_restore_lsx)
> +EXPORT_SYMBOL_FOR_KVM(kvm_restore_lsx)
>  #endif
>
>  #ifdef CONFIG_CPU_HAS_LASX
> @@ -268,7 +278,7 @@ SYM_FUNC_START(kvm_save_lasx)
>         lasx_save_data  a0 t1
>         jr              ra
>  SYM_FUNC_END(kvm_save_lasx)
> -EXPORT_SYMBOL(kvm_save_lasx)
> +EXPORT_SYMBOL_FOR_KVM(kvm_save_lasx)
>
>  SYM_FUNC_START(kvm_restore_lasx)
>         lasx_restore_data a0 t1
> @@ -276,7 +286,7 @@ SYM_FUNC_START(kvm_restore_lasx)
>         fpu_restore_csr   a0 t1 t2
>         jr                ra
>  SYM_FUNC_END(kvm_restore_lasx)
> -EXPORT_SYMBOL(kvm_restore_lasx)
> +EXPORT_SYMBOL_FOR_KVM(kvm_restore_lasx)
>  #endif
>
>  #ifdef CONFIG_CPU_HAS_LBT
> --
> 2.39.1
>

