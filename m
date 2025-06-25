Return-Path: <kvm+bounces-50628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EA73AE78E0
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CBB31896FE4
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6961E5B6F;
	Wed, 25 Jun 2025 07:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="j+dxlps+"
X-Original-To: kvm@vger.kernel.org
Received: from sg-3-15.ptr.tlmpb.com (sg-3-15.ptr.tlmpb.com [101.45.255.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7186220C00D
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750837209; cv=none; b=f3+LaBaqGe/8AiVS2zs+PokfLOhY/Tr3/cEs8n8HpnAI6CsX0mSrAdYRfveU5H1HXQKl6zDWUr1B94H+G6Cc4cM0okUMyralTSpSMQlKQPp4R5oEuPFciKYWcuM9MPmYOLejqrGo8LztzBPTe+U5bgdYH9NGSOGeA5crqOmf3XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750837209; c=relaxed/simple;
	bh=H76aGG9NANKQKUoBKScTVy6S4W+i5WmHwJChDecDC4E=;
	h=Message-Id:Mime-Version:References:Content-Type:Cc:From:
	 In-Reply-To:Subject:To:Date; b=tMlc8s9dHO3K6l0bfSvRYjbUcmZTRKEVI4qdZqyeauGOxZmP/oQHcSRZQ12Het1tA5vxMnlleLraEdZ4Thqx3qRx2eRAVnLRhFQLvggmY6R8pRgo86qO0iK+nmD218SXmPXvjrfD/d7cw+sOiZwCv1ETVdXxygOrIRHP5qoW15M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=j+dxlps+; arc=none smtp.client-ip=101.45.255.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750837193;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yzsraZSWqwSvVbcAdyXaFFgenrSPFsa+2FOgTUwiozM=;
 b=j+dxlps+gqW75WVPPsqWlJvqwvDuXfQft+a69WvTgKMfG1ztI7NAwby5qicDw6C1+PSBxw
 anus9AjfqKrhz+CeM1ftngoAyn6nIG/2al8nXPvRgFxxZoDZRJQ9dz2n49mku6rDE6IsPV
 EQiJgGU6FXMYxuoUupl7koWKIUCmuDGPCEFuFUgutgoFLDUXrcpwohxK9/JTytFS/8AWqO
 bcBc/nmibBonzP9JG+TOhkRmLQFUxfEee0VnXIjfv57q+3semoTOuB6gZcfPqmdruAGMrP
 z0y6cFdUQCLmm8C28TzINWZdhEGMCEctyUnaBMFooxCKHWz/xXXmB4YZDXq3vg==
Message-Id: <88b20a43-46c7-4297-ac20-dea7b0157c92@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618113532.471448-1-apatel@ventanamicro.com> <20250618113532.471448-8-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, <kvm@vger.kernel.org>, 
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@rivosinc.com>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20250618113532.471448-8-apatel@ventanamicro.com>
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
Received: from [127.0.0.1] ([139.226.59.215]) by smtp.feishu.cn with ESMTPS; Wed, 25 Jun 2025 15:39:50 +0800
X-Lms-Return-Path: <lba+2685ba7c7+c5d702+vger.kernel.org+liujingqi@lanxincomputing.com>
Subject: Re: [PATCH v3 07/12] RISC-V: KVM: Use ncsr_xyz() in kvm_riscv_vcpu_trap_redirect()
To: "Anup Patel" <apatel@ventanamicro.com>, 
	"Atish Patra" <atish.patra@linux.dev>
Date: Wed, 25 Jun 2025 15:39:48 +0800
User-Agent: Mozilla Thunderbird
Content-Language: en-US

On 6/18/2025 7:35 PM, Anup Patel wrote:
> The H-extension CSRs accessed by kvm_riscv_vcpu_trap_redirect() will
> trap when KVM RISC-V is running as Guest/VM hence remove these traps
> by using ncsr_xyz() instead of csr_xyz().
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/kvm/vcpu_exit.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 6e0c18412795..85c43c83e3b9 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -9,6 +9,7 @@
>   #include <linux/kvm_host.h>
>   #include <asm/csr.h>
>   #include <asm/insn-def.h>
> +#include <asm/kvm_nacl.h>
>   
>   static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
>   			     struct kvm_cpu_trap *trap)
> @@ -135,7 +136,7 @@ unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
>   void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>   				  struct kvm_cpu_trap *trap)
>   {
> -	unsigned long vsstatus = csr_read(CSR_VSSTATUS);
> +	unsigned long vsstatus = ncsr_read(CSR_VSSTATUS);
>   
>   	/* Change Guest SSTATUS.SPP bit */
>   	vsstatus &= ~SR_SPP;
> @@ -151,15 +152,15 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>   	vsstatus &= ~SR_SIE;
>   
>   	/* Update Guest SSTATUS */
> -	csr_write(CSR_VSSTATUS, vsstatus);
> +	ncsr_write(CSR_VSSTATUS, vsstatus);
>   
>   	/* Update Guest SCAUSE, STVAL, and SEPC */
> -	csr_write(CSR_VSCAUSE, trap->scause);
> -	csr_write(CSR_VSTVAL, trap->stval);
> -	csr_write(CSR_VSEPC, trap->sepc);
> +	ncsr_write(CSR_VSCAUSE, trap->scause);
> +	ncsr_write(CSR_VSTVAL, trap->stval);
> +	ncsr_write(CSR_VSEPC, trap->sepc);
>   
>   	/* Set Guest PC to Guest exception vector */
> -	vcpu->arch.guest_context.sepc = csr_read(CSR_VSTVEC);
> +	vcpu->arch.guest_context.sepc = ncsr_read(CSR_VSTVEC);
>   
>   	/* Set Guest privilege mode to supervisor */
>   	vcpu->arch.guest_context.sstatus |= SR_SPP;

Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>

Thanks,
Nutty

