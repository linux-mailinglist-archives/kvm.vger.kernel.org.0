Return-Path: <kvm+bounces-48625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DDA5ACFAB0
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 03:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4ED8916F8E0
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 01:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DD23596A;
	Fri,  6 Jun 2025 01:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ffuQcmh7"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5881805B
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 01:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749172882; cv=none; b=Ay8ZstU5c9fLUwApIrln2ywooPt08yO/3iU1M/9/OMOeTXQ7ipFHKhiIQq5yjLtcZk6o7ApC9HbqUwMZvDcGBuj3gHujMxj3o8Kel1p7o2zehnCKG6zrrBQW3ehNQ9OWEu73XD74vQAVsrsBzuf+wxoeJoYIsZADxleo1gfYcdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749172882; c=relaxed/simple;
	bh=gix5L869sGTvfLYorKge2i9dJIKj3m5mjK5cZtko69Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q8AgQMC+3u9kyXG+TKUG+WtYs44ZDnYO4VUUaqjN4Y1V5gPzp6IbEmRk8GaAhap7BA90JWWLm6gFPuoWtOFWe9xbJ8YLzUQi+TqlyJPTmoPmGXL9eqFVwxw9tcHr9OV8XRDOWkLPnmVLYsbEpITdHGBSC3Zr6DGX0RIq4iZMTG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ffuQcmh7; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <54c9651f-47ee-4b0d-8df4-2a0da679b2c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749172875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDGaaLcSzuIeoOSHuJpYzbEv+9LO2YuTG7IVWKH//Q8=;
	b=ffuQcmh7yCa/+CRsdD0k+UqoNRh8L0BnFQJKzRE3+ZlNWTibag47VUBlXpzf4hSKL3ZF+Y
	+U6IJSaXz3u3gjh1Axg1AF9zLLd8ntsozD8EgTkMSC3de6O98FlwTvPWvPAc0fsofGCX3T
	0/lt4OwWfAoz/SNWlNVJMrzbYkMpQhk=
Date: Thu, 5 Jun 2025 18:21:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 05/13] RISC-V: KVM: Rename and move
 kvm_riscv_local_tlb_sanitize()
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250605061458.196003-1-apatel@ventanamicro.com>
 <20250605061458.196003-6-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250605061458.196003-6-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/4/25 11:14 PM, Anup Patel wrote:
> The kvm_riscv_local_tlb_sanitize() deals with sanitizing current
> VMID related TLB mappings when a VCPU is moved from one host CPU
> to another.
>
> Let's move kvm_riscv_local_tlb_sanitize() to VMID management
> sources and rename it to kvm_riscv_gstage_vmid_sanitize().
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_host.h |  3 +--
>   arch/riscv/kvm/tlb.c              | 23 -----------------------
>   arch/riscv/kvm/vcpu.c             |  4 ++--
>   arch/riscv/kvm/vmid.c             | 23 +++++++++++++++++++++++
>   4 files changed, 26 insertions(+), 27 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 85cfebc32e4c..134adc30af52 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -327,8 +327,6 @@ void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
>   				     unsigned long order);
>   void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
>   
> -void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
> -
>   void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
>   void kvm_riscv_hfence_gvma_vmid_all_process(struct kvm_vcpu *vcpu);
>   void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
> @@ -376,6 +374,7 @@ unsigned long kvm_riscv_gstage_vmid_bits(void);
>   int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
>   bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
>   void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
> +void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
>   
>   int kvm_riscv_setup_default_irq_routing(struct kvm *kvm, u32 lines);
>   
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index 2f91ea5f8493..b3461bfd9756 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -156,29 +156,6 @@ void kvm_riscv_local_hfence_vvma_all(unsigned long vmid)
>   	csr_write(CSR_HGATP, hgatp);
>   }
>   
> -void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
> -{
> -	unsigned long vmid;
> -
> -	if (!kvm_riscv_gstage_vmid_bits() ||
> -	    vcpu->arch.last_exit_cpu == vcpu->cpu)
> -		return;
> -
> -	/*
> -	 * On RISC-V platforms with hardware VMID support, we share same
> -	 * VMID for all VCPUs of a particular Guest/VM. This means we might
> -	 * have stale G-stage TLB entries on the current Host CPU due to
> -	 * some other VCPU of the same Guest which ran previously on the
> -	 * current Host CPU.
> -	 *
> -	 * To cleanup stale TLB entries, we simply flush all G-stage TLB
> -	 * entries by VMID whenever underlying Host CPU changes for a VCPU.
> -	 */
> -
> -	vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
> -	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> -}
> -
>   void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
>   {
>   	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_RCVD);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index f98a1894d55b..cc7d00bcf345 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -961,12 +961,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		}
>   
>   		/*
> -		 * Cleanup stale TLB enteries
> +		 * Sanitize VMID mappings cached (TLB) on current CPU
>   		 *
>   		 * Note: This should be done after G-stage VMID has been
>   		 * updated using kvm_riscv_gstage_vmid_ver_changed()
>   		 */
> -		kvm_riscv_local_tlb_sanitize(vcpu);
> +		kvm_riscv_gstage_vmid_sanitize(vcpu);
>   
>   		trace_kvm_entry(vcpu);
>   
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index ddc98714ce8e..92c01255f86f 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -122,3 +122,26 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
>   	kvm_for_each_vcpu(i, v, vcpu->kvm)
>   		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
>   }
> +
> +void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long vmid;
> +
> +	if (!kvm_riscv_gstage_vmid_bits() ||
> +	    vcpu->arch.last_exit_cpu == vcpu->cpu)
> +		return;
> +
> +	/*
> +	 * On RISC-V platforms with hardware VMID support, we share same
> +	 * VMID for all VCPUs of a particular Guest/VM. This means we might
> +	 * have stale G-stage TLB entries on the current Host CPU due to
> +	 * some other VCPU of the same Guest which ran previously on the
> +	 * current Host CPU.
> +	 *
> +	 * To cleanup stale TLB entries, we simply flush all G-stage TLB
> +	 * entries by VMID whenever underlying Host CPU changes for a VCPU.
> +	 */
> +
> +	vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
> +	kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> +}


Reviewed-by: Atish Patra <atishp@rivosinc.com>


