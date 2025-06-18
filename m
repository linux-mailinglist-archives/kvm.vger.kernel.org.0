Return-Path: <kvm+bounces-49819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED29ADE3D8
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 08:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE95217117E
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC85205E3E;
	Wed, 18 Jun 2025 06:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LSVfc6Ss"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D093F20C480
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 06:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750228891; cv=none; b=LNIf3xBK0OSh80estGCwqFBspZxFah/6IUg0gv76AUBRlKlj0ATlrwndKPyxWNKWlQlJSp0QV3O2H+0GAY4zyUP8QzNVrO41ktBIzt52kjr0L6FdziO1fthPSQpHTgOAwlD9s5ieWvz5ta1OvmBRTY3gVAgjU7WS24VxqB132nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750228891; c=relaxed/simple;
	bh=M/l30/IRoenHGy5VzSUsqFROULvVyK5iMYOn2/mDCaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s+pL07KzFXivHINCwGOYnhWisncWFMM2MEN4H22YmXpX0HPANhCGt6DVW8iykCpvH9r40nT4lAuSdyh325MPT6leOC0mSeFQn3fMBtD6F54LddYTQdGFrrJQkLygk5ruAg6PDVc5NH82rPU5UCJ6ArPsmhCQ7VdLfbtjB2nkubs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LSVfc6Ss; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <8c51685c-de2f-48ed-b0b6-87ac44073684@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750228874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vx7JDHQ6srbDcbhQvBkA6hELvFYIhF9e9poQ0xOUOKU=;
	b=LSVfc6SsSY39VUCNHIgJHBxVAduEis1okaYmqlEta/beC6pWCMHiDXb8ENn+9cgxXfbWDc
	mq9E4uQsWEQGw70tjcMYaxay4likm+RkUbuzfA4s1apaPUs/SsGEgQXdps85zHQFD0W9DR
	iTs3i3xvcTYC+aiGX2yUt+C6iWk6Zfs=
Date: Tue, 17 Jun 2025 23:41:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 08/12] RISC-V: KVM: Factor-out MMU related declarations
 into separate headers
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250613065743.737102-1-apatel@ventanamicro.com>
 <20250613065743.737102-9-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250613065743.737102-9-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/12/25 11:57 PM, Anup Patel wrote:
> The MMU, TLB, and VMID management for KVM RISC-V already exists as
> seprate sources so create separate headers along these lines. This
> further simplifies asm/kvm_host.h header.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>   arch/riscv/include/asm/kvm_host.h | 100 +-----------------------------
>   arch/riscv/include/asm/kvm_mmu.h  |  26 ++++++++
>   arch/riscv/include/asm/kvm_tlb.h  |  78 +++++++++++++++++++++++
>   arch/riscv/include/asm/kvm_vmid.h |  27 ++++++++
>   arch/riscv/kvm/aia_imsic.c        |   1 +
>   arch/riscv/kvm/main.c             |   1 +
>   arch/riscv/kvm/mmu.c              |   1 +
>   arch/riscv/kvm/tlb.c              |   2 +
>   arch/riscv/kvm/vcpu.c             |   1 +
>   arch/riscv/kvm/vcpu_exit.c        |   1 +
>   arch/riscv/kvm/vm.c               |   1 +
>   arch/riscv/kvm/vmid.c             |   2 +
>   12 files changed, 143 insertions(+), 98 deletions(-)
>   create mode 100644 arch/riscv/include/asm/kvm_mmu.h
>   create mode 100644 arch/riscv/include/asm/kvm_tlb.h
>   create mode 100644 arch/riscv/include/asm/kvm_vmid.h
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 6162575e2177..bd5341efa127 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -16,6 +16,8 @@
>   #include <asm/hwcap.h>
>   #include <asm/kvm_aia.h>
>   #include <asm/ptrace.h>
> +#include <asm/kvm_tlb.h>
> +#include <asm/kvm_vmid.h>
>   #include <asm/kvm_vcpu_fp.h>
>   #include <asm/kvm_vcpu_insn.h>
>   #include <asm/kvm_vcpu_sbi.h>
> @@ -56,24 +58,6 @@
>   					 BIT(IRQ_VS_TIMER) | \
>   					 BIT(IRQ_VS_EXT))
>   
> -enum kvm_riscv_hfence_type {
> -	KVM_RISCV_HFENCE_UNKNOWN = 0,
> -	KVM_RISCV_HFENCE_GVMA_VMID_GPA,
> -	KVM_RISCV_HFENCE_VVMA_ASID_GVA,
> -	KVM_RISCV_HFENCE_VVMA_ASID_ALL,
> -	KVM_RISCV_HFENCE_VVMA_GVA,
> -};
> -
> -struct kvm_riscv_hfence {
> -	enum kvm_riscv_hfence_type type;
> -	unsigned long asid;
> -	unsigned long order;
> -	gpa_t addr;
> -	gpa_t size;
> -};
> -
> -#define KVM_RISCV_VCPU_MAX_HFENCE	64
> -
>   struct kvm_vm_stat {
>   	struct kvm_vm_stat_generic generic;
>   };
> @@ -99,15 +83,6 @@ struct kvm_vcpu_stat {
>   struct kvm_arch_memory_slot {
>   };
>   
> -struct kvm_vmid {
> -	/*
> -	 * Writes to vmid_version and vmid happen with vmid_lock held
> -	 * whereas reads happen without any lock held.
> -	 */
> -	unsigned long vmid_version;
> -	unsigned long vmid;
> -};
> -
>   struct kvm_arch {
>   	/* G-stage vmid */
>   	struct kvm_vmid vmid;
> @@ -311,77 +286,6 @@ static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
>   	return IS_ENABLED(CONFIG_GUEST_PERF_EVENTS) && !!vcpu;
>   }
>   
> -#define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
> -
> -void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
> -					  gpa_t gpa, gpa_t gpsz,
> -					  unsigned long order);
> -void kvm_riscv_local_hfence_gvma_vmid_all(unsigned long vmid);
> -void kvm_riscv_local_hfence_gvma_gpa(gpa_t gpa, gpa_t gpsz,
> -				     unsigned long order);
> -void kvm_riscv_local_hfence_gvma_all(void);
> -void kvm_riscv_local_hfence_vvma_asid_gva(unsigned long vmid,
> -					  unsigned long asid,
> -					  unsigned long gva,
> -					  unsigned long gvsz,
> -					  unsigned long order);
> -void kvm_riscv_local_hfence_vvma_asid_all(unsigned long vmid,
> -					  unsigned long asid);
> -void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
> -				     unsigned long gva, unsigned long gvsz,
> -				     unsigned long order);
> -void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
> -
> -void kvm_riscv_tlb_flush_process(struct kvm_vcpu *vcpu);
> -
> -void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
> -void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
> -void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu);
> -
> -void kvm_riscv_fence_i(struct kvm *kvm,
> -		       unsigned long hbase, unsigned long hmask);
> -void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
> -				    unsigned long hbase, unsigned long hmask,
> -				    gpa_t gpa, gpa_t gpsz,
> -				    unsigned long order);
> -void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
> -				    unsigned long hbase, unsigned long hmask);
> -void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
> -				    unsigned long hbase, unsigned long hmask,
> -				    unsigned long gva, unsigned long gvsz,
> -				    unsigned long order, unsigned long asid);
> -void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
> -				    unsigned long hbase, unsigned long hmask,
> -				    unsigned long asid);
> -void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
> -			       unsigned long hbase, unsigned long hmask,
> -			       unsigned long gva, unsigned long gvsz,
> -			       unsigned long order);
> -void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
> -			       unsigned long hbase, unsigned long hmask);
> -
> -int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> -			     phys_addr_t hpa, unsigned long size,
> -			     bool writable, bool in_atomic);
> -void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
> -			      unsigned long size);
> -int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
> -			 struct kvm_memory_slot *memslot,
> -			 gpa_t gpa, unsigned long hva, bool is_write);
> -int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
> -void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
> -void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
> -void __init kvm_riscv_gstage_mode_detect(void);
> -unsigned long __init kvm_riscv_gstage_mode(void);
> -int kvm_riscv_gstage_gpa_bits(void);
> -
> -void __init kvm_riscv_gstage_vmid_detect(void);
> -unsigned long kvm_riscv_gstage_vmid_bits(void);
> -int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
> -bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
> -void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
> -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
> -
>   int kvm_riscv_setup_default_irq_routing(struct kvm *kvm, u32 lines);
>   
>   void __kvm_riscv_unpriv_trap(void);
> diff --git a/arch/riscv/include/asm/kvm_mmu.h b/arch/riscv/include/asm/kvm_mmu.h
> new file mode 100644
> index 000000000000..4e1654282ee4
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_mmu.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2025 Ventana Micro Systems Inc.
> + */
> +
> +#ifndef __RISCV_KVM_MMU_H_
> +#define __RISCV_KVM_MMU_H_
> +
> +#include <linux/kvm_types.h>
> +
> +int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> +			     phys_addr_t hpa, unsigned long size,
> +			     bool writable, bool in_atomic);
> +void kvm_riscv_gstage_iounmap(struct kvm *kvm, gpa_t gpa,
> +			      unsigned long size);
> +int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
> +			 struct kvm_memory_slot *memslot,
> +			 gpa_t gpa, unsigned long hva, bool is_write);
> +int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
> +void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
> +void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
> +void kvm_riscv_gstage_mode_detect(void);
> +unsigned long kvm_riscv_gstage_mode(void);
> +int kvm_riscv_gstage_gpa_bits(void);
> +
> +#endif
> diff --git a/arch/riscv/include/asm/kvm_tlb.h b/arch/riscv/include/asm/kvm_tlb.h
> new file mode 100644
> index 000000000000..cd00c9a46cb1
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_tlb.h
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2025 Ventana Micro Systems Inc.
> + */
> +
> +#ifndef __RISCV_KVM_TLB_H_
> +#define __RISCV_KVM_TLB_H_
> +
> +#include <linux/kvm_types.h>
> +
> +enum kvm_riscv_hfence_type {
> +	KVM_RISCV_HFENCE_UNKNOWN = 0,
> +	KVM_RISCV_HFENCE_GVMA_VMID_GPA,
> +	KVM_RISCV_HFENCE_VVMA_ASID_GVA,
> +	KVM_RISCV_HFENCE_VVMA_ASID_ALL,
> +	KVM_RISCV_HFENCE_VVMA_GVA,
> +};
> +
> +struct kvm_riscv_hfence {
> +	enum kvm_riscv_hfence_type type;
> +	unsigned long asid;
> +	unsigned long order;
> +	gpa_t addr;
> +	gpa_t size;
> +};
> +
> +#define KVM_RISCV_VCPU_MAX_HFENCE	64
> +
> +#define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
> +
> +void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
> +					  gpa_t gpa, gpa_t gpsz,
> +					  unsigned long order);
> +void kvm_riscv_local_hfence_gvma_vmid_all(unsigned long vmid);
> +void kvm_riscv_local_hfence_gvma_gpa(gpa_t gpa, gpa_t gpsz,
> +				     unsigned long order);
> +void kvm_riscv_local_hfence_gvma_all(void);
> +void kvm_riscv_local_hfence_vvma_asid_gva(unsigned long vmid,
> +					  unsigned long asid,
> +					  unsigned long gva,
> +					  unsigned long gvsz,
> +					  unsigned long order);
> +void kvm_riscv_local_hfence_vvma_asid_all(unsigned long vmid,
> +					  unsigned long asid);
> +void kvm_riscv_local_hfence_vvma_gva(unsigned long vmid,
> +				     unsigned long gva, unsigned long gvsz,
> +				     unsigned long order);
> +void kvm_riscv_local_hfence_vvma_all(unsigned long vmid);
> +
> +void kvm_riscv_tlb_flush_process(struct kvm_vcpu *vcpu);
> +
> +void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu);
> +void kvm_riscv_hfence_vvma_all_process(struct kvm_vcpu *vcpu);
> +void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu);
> +
> +void kvm_riscv_fence_i(struct kvm *kvm,
> +		       unsigned long hbase, unsigned long hmask);
> +void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
> +				    unsigned long hbase, unsigned long hmask,
> +				    gpa_t gpa, gpa_t gpsz,
> +				    unsigned long order);
> +void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
> +				    unsigned long hbase, unsigned long hmask);
> +void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
> +				    unsigned long hbase, unsigned long hmask,
> +				    unsigned long gva, unsigned long gvsz,
> +				    unsigned long order, unsigned long asid);
> +void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
> +				    unsigned long hbase, unsigned long hmask,
> +				    unsigned long asid);
> +void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
> +			       unsigned long hbase, unsigned long hmask,
> +			       unsigned long gva, unsigned long gvsz,
> +			       unsigned long order);
> +void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
> +			       unsigned long hbase, unsigned long hmask);
> +
> +#endif
> diff --git a/arch/riscv/include/asm/kvm_vmid.h b/arch/riscv/include/asm/kvm_vmid.h
> new file mode 100644
> index 000000000000..ab98e1434fb7
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vmid.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2025 Ventana Micro Systems Inc.
> + */
> +
> +#ifndef __RISCV_KVM_VMID_H_
> +#define __RISCV_KVM_VMID_H_
> +
> +#include <linux/kvm_types.h>
> +
> +struct kvm_vmid {
> +	/*
> +	 * Writes to vmid_version and vmid happen with vmid_lock held
> +	 * whereas reads happen without any lock held.
> +	 */
> +	unsigned long vmid_version;
> +	unsigned long vmid;
> +};
> +
> +void __init kvm_riscv_gstage_vmid_detect(void);
> +unsigned long kvm_riscv_gstage_vmid_bits(void);
> +int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
> +bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
> +void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
> +void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
> +
> +#endif
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index 29ef9c2133a9..40b469c0a01f 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -16,6 +16,7 @@
>   #include <linux/swab.h>
>   #include <kvm/iodev.h>
>   #include <asm/csr.h>
> +#include <asm/kvm_mmu.h>
>   
>   #define IMSIC_MAX_EIX	(IMSIC_MAX_ID / BITS_PER_TYPE(u64))
>   
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 4b24705dc63a..b861a5dd7bd9 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -11,6 +11,7 @@
>   #include <linux/module.h>
>   #include <linux/kvm_host.h>
>   #include <asm/cpufeature.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/kvm_nacl.h>
>   #include <asm/sbi.h>
>   
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index a5387927a1c1..c1a3eb076df3 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -15,6 +15,7 @@
>   #include <linux/vmalloc.h>
>   #include <linux/kvm_host.h>
>   #include <linux/sched/signal.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/kvm_nacl.h>
>   #include <asm/page.h>
>   #include <asm/pgtable.h>
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index f46a27658c2e..6fc4361c3d75 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -15,6 +15,8 @@
>   #include <asm/cpufeature.h>
>   #include <asm/insn-def.h>
>   #include <asm/kvm_nacl.h>
> +#include <asm/kvm_tlb.h>
> +#include <asm/kvm_vmid.h>
>   
>   #define has_svinval()	riscv_has_extension_unlikely(RISCV_ISA_EXT_SVINVAL)
>   
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 6eb11c913b13..8ad7b31f5939 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -18,6 +18,7 @@
>   #include <linux/fs.h>
>   #include <linux/kvm_host.h>
>   #include <asm/cacheflush.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/kvm_nacl.h>
>   #include <asm/kvm_vcpu_vector.h>
>   
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index 85c43c83e3b9..965df528de90 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -9,6 +9,7 @@
>   #include <linux/kvm_host.h>
>   #include <asm/csr.h>
>   #include <asm/insn-def.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/kvm_nacl.h>
>   
>   static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index b27ec8f96697..8601cf29e5f8 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -11,6 +11,7 @@
>   #include <linux/module.h>
>   #include <linux/uaccess.h>
>   #include <linux/kvm_host.h>
> +#include <asm/kvm_mmu.h>
>   
>   const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>   	KVM_GENERIC_VM_STATS()
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 92c01255f86f..3b426c800480 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -14,6 +14,8 @@
>   #include <linux/smp.h>
>   #include <linux/kvm_host.h>
>   #include <asm/csr.h>
> +#include <asm/kvm_tlb.h>
> +#include <asm/kvm_vmid.h>
>   
>   static unsigned long vmid_version = 1;
>   static unsigned long vmid_next;


LGTM.
Reviewed-by: Atish Patra <atishp@rivosinc.com>


