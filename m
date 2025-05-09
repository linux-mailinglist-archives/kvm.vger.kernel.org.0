Return-Path: <kvm+bounces-46085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B6282AB1C0F
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 20:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1A467BA24C
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 18:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7CB823ED5A;
	Fri,  9 May 2025 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QmAOyYPC"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D722B8C5;
	Fri,  9 May 2025 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746814199; cv=none; b=Q1NtHPRkre8ryUKjGna8UlS6k0o/NV2nn/JAlhw1ZWwQxKRKNqMKofyMQGCy5tNYWmSToj4Fua3Kc3CNFoRKV2mRXTIPGfQ0jtkSoT94tQZ89j4nZAcFvLa+le11gP+/CfqBsF5xbB0KS/fLMJOX3qkBV1lreR58bD1g1BNaQXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746814199; c=relaxed/simple;
	bh=NVAQxVyOoG9FX0y6Y2rJq7+QOyDoipjbegh4hKfM6Ok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HSxJ1kpi+s2oDh7zdnlJsFVb17AGm8NLY4/SwUVGdirN2ZpKUXBvYTuG2Xi59tIRQ/Lvo6ST/sLkaRl7JSdD575ohaMq105CenIPCpQl6vht8b9Mr3iUw8Y5O7CSGIPFefCFakCDh1NN6s9PV4l9u3BCKG8MjtFdN/XKKMz1fuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QmAOyYPC; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <87b2eade-acda-428e-81af-d4927e517ebe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746814184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=URPGJAItur5ro86msDKguo+AsJb0M+Qreyerm9JUIhE=;
	b=QmAOyYPC6u20ITPaBw6Ha8aJZ5SkuvYHSBzdZn+LukNn9N+RF2l6kZWl4i8HY2iN8xSa3/
	tRR0b2Vwb3FURyyvyNGCNFznDS++FHxCJiarEuklu+4bAraa+0PNDh4WOi8CnQ/hVnXHkT
	cQd2oib4+zm6/z7aTg3m38NqWDWGL6E=
Date: Fri, 9 May 2025 11:09:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 14/14] RISC-V: KVM: add support for
 SBI_FWFT_MISALIGNED_DELEG
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org
Cc: Samuel Holland <samuel.holland@sifive.com>,
 Andrew Jones <ajones@ventanamicro.com>, Deepak Gupta <debug@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
 <20250424173204.1948385-15-cleger@rivosinc.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250424173204.1948385-15-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 4/24/25 10:32 AM, ClÃ©ment LÃ©ger wrote:
> SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
> misaligned load/store exceptions. Save and restore it during CPU
> load/put.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Deepak Gupta <debug@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   arch/riscv/kvm/vcpu.c          |  3 +++
>   arch/riscv/kvm/vcpu_sbi_fwft.c | 36 ++++++++++++++++++++++++++++++++++
>   2 files changed, 39 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 542747e2c7f5..d98e379945c3 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -646,6 +646,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   {
>   	void *nsh;
>   	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>   
>   	vcpu->cpu = -1;
>   
> @@ -671,6 +672,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   		csr->vstval = nacl_csr_read(nsh, CSR_VSTVAL);
>   		csr->hvip = nacl_csr_read(nsh, CSR_HVIP);
>   		csr->vsatp = nacl_csr_read(nsh, CSR_VSATP);
> +		cfg->hedeleg = nacl_csr_read(nsh, CSR_HEDELEG);
>   	} else {
>   		csr->vsstatus = csr_read(CSR_VSSTATUS);
>   		csr->vsie = csr_read(CSR_VSIE);
> @@ -681,6 +683,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   		csr->vstval = csr_read(CSR_VSTVAL);
>   		csr->hvip = csr_read(CSR_HVIP);
>   		csr->vsatp = csr_read(CSR_VSATP);
> +		cfg->hedeleg = csr_read(CSR_HEDELEG);

Can we avoid saving hedeleg in vcpu_put path by updating the 
cfg->hedeleg in kvm_sbi_fwft_set_misaligned_delegation.

We already update the hedeleg in vcpu_load path from cfg->hedeleg.
If the next vcpu did not enable delegation it will get the correct 
config written to hedeleg.

This will save us a csr read cost in each VM exit path for something 
that is probably configured once in guest life time.

>   	}
>   }
>   
> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
> index b0f66c7bf010..d16ee477042f 100644
> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
> @@ -14,6 +14,8 @@
>   #include <asm/kvm_vcpu_sbi.h>
>   #include <asm/kvm_vcpu_sbi_fwft.h>
>   
> +#define MIS_DELEG (BIT_ULL(EXC_LOAD_MISALIGNED) | BIT_ULL(EXC_STORE_MISALIGNED))
> +
>   struct kvm_sbi_fwft_feature {
>   	/**
>   	 * @id: Feature ID
> @@ -68,7 +70,41 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
>   	return false;
>   }
>   
> +static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
> +{
> +	return misaligned_traps_can_delegate();
> +}
> +
> +static long kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
> +					struct kvm_sbi_fwft_config *conf,
> +					unsigned long value)
> +{
> +	if (value == 1)
> +		csr_set(CSR_HEDELEG, MIS_DELEG);
> +	else if (value == 0)
> +		csr_clear(CSR_HEDELEG, MIS_DELEG);
> +	else
> +		return SBI_ERR_INVALID_PARAM;
> +
> +	return SBI_SUCCESS;
> +}
> +
> +static long kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
> +					struct kvm_sbi_fwft_config *conf,
> +					unsigned long *value)
> +{
> +	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) == MIS_DELEG;
> +
> +	return SBI_SUCCESS;
> +}
> +
>   static const struct kvm_sbi_fwft_feature features[] = {
> +	{
> +		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
> +		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
> +		.set = kvm_sbi_fwft_set_misaligned_delegation,
> +		.get = kvm_sbi_fwft_get_misaligned_delegation,
> +	},
>   };
>   
>   static struct kvm_sbi_fwft_config *


