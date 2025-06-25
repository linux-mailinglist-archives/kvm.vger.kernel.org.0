Return-Path: <kvm+bounces-50632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFEEDAE7932
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DF163A9864
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D8320CCE5;
	Wed, 25 Jun 2025 07:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="mBTR6Pgj"
X-Original-To: kvm@vger.kernel.org
Received: from sg-1-21.ptr.blmpb.com (sg-1-21.ptr.blmpb.com [118.26.132.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493C92153FB
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750838146; cv=none; b=poNBvPFtrGm7WIQVBqChw77VeoTXjvwBEXTHSL1Fh5/gPfYOjJC+tHjHUzZw15G7sI7x+sA9sI5plCj0ElIZbL2C8PepJDruONAVkO2MXEo1OM4SdIIvejgfFLZmTXP/m8+yKq4AReMmYKjmXHjktiVyfu/Z0hOGdVMFMJ2qC4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750838146; c=relaxed/simple;
	bh=hW3k6z49kKwNRejfAMcgIdFU5548Dv/b8lnlYkL2ZcM=;
	h=From:Date:References:Message-Id:To:Cc:Subject:Content-Type:
	 In-Reply-To:Mime-Version; b=OuscDKBBPCfSISixAAmcyQV5c14Faz6nu7+vtN0hUMUS8ORY6rT2iYxI5gBNJzKOXTLwPem3rFrWe1uxsXJNbJpnPer2lKKXUzaiJeDpqUFe3sZDQ5eBFhu0O+V53J0iP3lSkzZXanC9wPE4Hgk07I/Dorfu2i/QmRYALies1ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=mBTR6Pgj; arc=none smtp.client-ip=118.26.132.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1750838130;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Uwcz+ylJEsmNE1CVgp+CscW5a5nPPX8eXKPrXaxr/uc=;
 b=mBTR6PgjmCU+frhNcEwLlXR8N78NYFR8ZiLbDiT1l99f1D6q6v6n28ASL4Jth+22MTKN5R
 od9MIDiPk92CTCB68s4YSWslGs0z5R/hFySbeZxwLvuaA3lIJDCkijGpShrs008oP1ZYLG
 Ty0N2gbiXvW57po93CoX3okpkXIZJgImBlZKD0npBeUS/nwMQgG35eHcRakGfSQ6zeabf+
 LiUXO0kpinv+JCj3aRVRGSWA3RzORVORACUy6QXDZ5+cbehoAIcoIv1wU5oFDLxZjQdyXG
 BaN2X0DNNaLwAL4HmPkzfS1Ap2yU29Wz5a+a06BUMlvWjfnIHRHQWYTrW0txfg==
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Date: Wed, 25 Jun 2025 15:55:25 +0800
Content-Transfer-Encoding: 7bit
Content-Language: en-US
References: <20250618113532.471448-1-apatel@ventanamicro.com> <20250618113532.471448-11-apatel@ventanamicro.com>
Message-Id: <e074d79d-a8c6-42c6-bffb-543112778c1b@lanxincomputing.com>
To: "Anup Patel" <apatel@ventanamicro.com>, 
	"Atish Patra" <atish.patra@linux.dev>
Cc: "Palmer Dabbelt" <palmer@dabbelt.com>, 
	"Paul Walmsley" <paul.walmsley@sifive.com>, 
	"Alexandre Ghiti" <alex@ghiti.fr>, 
	"Andrew Jones" <ajones@ventanamicro.com>, 
	"Anup Patel" <anup@brainfault.org>, <kvm@vger.kernel.org>, 
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@rivosinc.com>
Subject: Re: [PATCH v3 10/12] RISC-V: KVM: Add vmid field to struct kvm_riscv_hfence
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20250618113532.471448-11-apatel@ventanamicro.com>
User-Agent: Mozilla Thunderbird
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
Received: from [127.0.0.1] ([139.226.59.215]) by smtp.feishu.cn with ESMTPS; Wed, 25 Jun 2025 15:55:27 +0800
X-Lms-Return-Path: <lba+2685bab70+0d7a2a+vger.kernel.org+liujingqi@lanxincomputing.com>

On 6/18/2025 7:35 PM, Anup Patel wrote:
> Currently, the struct kvm_riscv_hfence does not have vmid field
> and various hfence processing functions always pick vmid assigned
> to the guest/VM. This prevents us from doing hfence operation on
> arbitrary vmid hence add vmid field to struct kvm_riscv_hfence
> and use it wherever applicable.
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
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

Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>

Thanks,
Nutty

