Return-Path: <kvm+bounces-49563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E21AD9F78
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 21:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85F593B8C93
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 19:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271362E7640;
	Sat, 14 Jun 2025 19:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gu4kqTYo"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA87156C6F;
	Sat, 14 Jun 2025 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749929380; cv=none; b=tQneqedaYijVXL73Kj9lvAfYulm13vi9euH4uEWd08FmTgAeguHKIRY3G2QqytYnbYM3y3N4Y3jVhOMT5d6vjYUseN7t+Z0Wxc0e3A1OwePphtsZ8vpnBD16L9wh0X8XO1r71NblnhkPJZSx2ahDSbVbD5s9ixPVyURTZMysqbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749929380; c=relaxed/simple;
	bh=GWZseLWsS//zsX21MW0UUkqllIe3UMAz7mnhotza1/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ExRmipb/WwgSJpvv++j1RwluC5RaHl5bSkky/SuW4Nzs1z322A0OrsxmvPSwq08WBy4Refl+lPiA4P2JkMU8Gc6204LmFvaCdy/VVdxAcW3YoyI+O6+Gtc5mHP3tyaj2KDM6cP6ZREGIS6Wb6fyPlcEhMOVgMTRcYmZ3K79Zp1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gu4kqTYo; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <a581401c-01e1-45b6-a55e-0361185114ff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749929375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xN5d4MLrE2OQ8z204hwuo+c3IAo79fmudrGii3bZ0SQ=;
	b=gu4kqTYosEX2z8Jawy6sUn46pmdpjICOMDHx+kLeGU0mzgiTJ4fVGt/ibuHu5MUM0+R9Mu
	P1YwF+4/pf/EbxfN6DYizSvGglPO8OCBpveXpJNJdfdrPY0huFfbinUlr/3016VVYNgXIj
	mWnCv6Up2cMXDw/23G+K2QwBYkzdvd0=
Date: Sat, 14 Jun 2025 12:29:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 10/12] RISC-V: KVM: Add vmid field to struct
 kvm_riscv_hfence
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250613065743.737102-1-apatel@ventanamicro.com>
 <20250613065743.737102-11-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250613065743.737102-11-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/12/25 11:57 PM, Anup Patel wrote:
> Currently, the struct kvm_riscv_hfence does not have vmid field
> and various hfence processing functions always pick vmid assigned
> to the guest/VM. This prevents us from doing hfence operation on
> arbitrary vmid hence add vmid field to struct kvm_riscv_hfence
> and use it wherever applicable.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_tlb.h |  1 +
>   arch/riscv/kvm/tlb.c             | 30 ++++++++++++++++--------------
>   2 files changed, 17 insertions(+), 14 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_tlb.h b/arch/riscv/include/asm/kvm_tlb.h
> index cd00c9a46cb1..f67e03edeaec 100644
> --- a/arch/riscv/include/asm/kvm_tlb.h
> +++ b/arch/riscv/include/asm/kvm_tlb.h
> @@ -19,6 +19,7 @@ enum kvm_riscv_hfence_type {
>   struct kvm_riscv_hfence {
>   	enum kvm_riscv_hfence_type type;
>   	unsigned long asid;
> +	unsigned long vmid;
>   	unsigned long order;
>   	gpa_t addr;
>   	gpa_t size;
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index 6fc4361c3d75..349fcfc93f54 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -237,49 +237,43 @@ static bool vcpu_hfence_enqueue(struct kvm_vcpu *vcpu,
>   
>   void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
>   {
> -	unsigned long vmid;
>   	struct kvm_riscv_hfence d = { 0 };
> -	struct kvm_vmid *v = &vcpu->kvm->arch.vmid;
>   
>   	while (vcpu_hfence_dequeue(vcpu, &d)) {
>   		switch (d.type) {
>   		case KVM_RISCV_HFENCE_UNKNOWN:
>   			break;
>   		case KVM_RISCV_HFENCE_GVMA_VMID_GPA:
> -			vmid = READ_ONCE(v->vmid);
>   			if (kvm_riscv_nacl_available())
> -				nacl_hfence_gvma_vmid(nacl_shmem(), vmid,
> +				nacl_hfence_gvma_vmid(nacl_shmem(), d.vmid,
>   						      d.addr, d.size, d.order);
>   			else
> -				kvm_riscv_local_hfence_gvma_vmid_gpa(vmid, d.addr,
> +				kvm_riscv_local_hfence_gvma_vmid_gpa(d.vmid, d.addr,
>   								     d.size, d.order);
>   			break;
>   		case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
>   			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
> -			vmid = READ_ONCE(v->vmid);
>   			if (kvm_riscv_nacl_available())
> -				nacl_hfence_vvma_asid(nacl_shmem(), vmid, d.asid,
> +				nacl_hfence_vvma_asid(nacl_shmem(), d.vmid, d.asid,
>   						      d.addr, d.size, d.order);
>   			else
> -				kvm_riscv_local_hfence_vvma_asid_gva(vmid, d.asid, d.addr,
> +				kvm_riscv_local_hfence_vvma_asid_gva(d.vmid, d.asid, d.addr,
>   								     d.size, d.order);
>   			break;
>   		case KVM_RISCV_HFENCE_VVMA_ASID_ALL:
>   			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
> -			vmid = READ_ONCE(v->vmid);
>   			if (kvm_riscv_nacl_available())
> -				nacl_hfence_vvma_asid_all(nacl_shmem(), vmid, d.asid);
> +				nacl_hfence_vvma_asid_all(nacl_shmem(), d.vmid, d.asid);
>   			else
> -				kvm_riscv_local_hfence_vvma_asid_all(vmid, d.asid);
> +				kvm_riscv_local_hfence_vvma_asid_all(d.vmid, d.asid);
>   			break;
>   		case KVM_RISCV_HFENCE_VVMA_GVA:
>   			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_RCVD);
> -			vmid = READ_ONCE(v->vmid);
>   			if (kvm_riscv_nacl_available())
> -				nacl_hfence_vvma(nacl_shmem(), vmid,
> +				nacl_hfence_vvma(nacl_shmem(), d.vmid,
>   						 d.addr, d.size, d.order);
>   			else
> -				kvm_riscv_local_hfence_vvma_gva(vmid, d.addr,
> +				kvm_riscv_local_hfence_vvma_gva(d.vmid, d.addr,
>   								d.size, d.order);
>   			break;
>   		default:
> @@ -336,10 +330,12 @@ void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
>   				    gpa_t gpa, gpa_t gpsz,
>   				    unsigned long order)
>   {
> +	struct kvm_vmid *v = &kvm->arch.vmid;
>   	struct kvm_riscv_hfence data;
>   
>   	data.type = KVM_RISCV_HFENCE_GVMA_VMID_GPA;
>   	data.asid = 0;
> +	data.vmid = READ_ONCE(v->vmid);
>   	data.addr = gpa;
>   	data.size = gpsz;
>   	data.order = order;
> @@ -359,10 +355,12 @@ void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
>   				    unsigned long gva, unsigned long gvsz,
>   				    unsigned long order, unsigned long asid)
>   {
> +	struct kvm_vmid *v = &kvm->arch.vmid;
>   	struct kvm_riscv_hfence data;
>   
>   	data.type = KVM_RISCV_HFENCE_VVMA_ASID_GVA;
>   	data.asid = asid;
> +	data.vmid = READ_ONCE(v->vmid);
>   	data.addr = gva;
>   	data.size = gvsz;
>   	data.order = order;
> @@ -374,10 +372,12 @@ void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
>   				    unsigned long hbase, unsigned long hmask,
>   				    unsigned long asid)
>   {
> +	struct kvm_vmid *v = &kvm->arch.vmid;
>   	struct kvm_riscv_hfence data;
>   
>   	data.type = KVM_RISCV_HFENCE_VVMA_ASID_ALL;
>   	data.asid = asid;
> +	data.vmid = READ_ONCE(v->vmid);
>   	data.addr = data.size = data.order = 0;
>   	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
>   			    KVM_REQ_HFENCE_VVMA_ALL, &data);
> @@ -388,10 +388,12 @@ void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
>   			       unsigned long gva, unsigned long gvsz,
>   			       unsigned long order)
>   {
> +	struct kvm_vmid *v = &kvm->arch.vmid;
>   	struct kvm_riscv_hfence data;
>   
>   	data.type = KVM_RISCV_HFENCE_VVMA_GVA;
>   	data.asid = 0;
> +	data.vmid = READ_ONCE(v->vmid);
>   	data.addr = gva;
>   	data.size = gvsz;
>   	data.order = order;
Reviewed-by: Atish Patra <atishp@rivosinc.com>

