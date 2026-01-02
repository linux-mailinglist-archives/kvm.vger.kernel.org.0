Return-Path: <kvm+bounces-66955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3394CEF084
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 18:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 510E6300A28A
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 17:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590A528750B;
	Fri,  2 Jan 2026 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vlCdmtgt"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEAA1E531
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 17:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767373836; cv=none; b=fx0X7rISCp3cW8WPYtwdXXItAooBHY23xJvfsxByVDkRadpqQcY/AoJ9pwt/MWZHFCovsftMjo499XM+4RNFJXbENGki0xgD+2+2elD5fXHsnI+fRrn+xQxLHBl5esSj5LridTGB2Q5oLIByTbyyXzILdqlp4B4UFXupk9A156U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767373836; c=relaxed/simple;
	bh=tY7Sj0Wt8ofwV9+N5ha5BDvDitbq3rSLlm59a+CLOSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhVYQ2RPWgAZOxelkv7YXgfh4kP/W0+0874uYjbIkn67bTm9WvKFRWSDgZCGxy3AQ6Zb7QRn5fR7vo1CtzieIqllL/gmlB28LhkNKQYTgvyfET5nms4JgD3uuKfeS3/O5CBbuL/WM840eI2MOACGTPAeZh3rIGnLUmmgo5kfTYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vlCdmtgt; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Jan 2026 17:10:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767373830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jVV1USKSvlkP8yy4xlBDNM9RAl76sphsQ5V9uMR2oHg=;
	b=vlCdmtgtMIxaW81mMsur8wK/rEEgTOOUMtcLgWwmSxP2Vz2CcZrG+LS6zCMrp/P+tNdJTE
	iGgy3y57Mq466D17AOcEx4V3De3b/l2hps5vWyXQR1/kwsCDp7Y1b4lZAL6WG50pw11vso
	zHin2v43gjeOeTH++RQGXFpV0FNDJ7c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 20/21] KVM: selftests: Rename
 vm_get_page_table_entry() to vm_get_pte()
Message-ID: <txx7pwn52hbd5oen56famqzwtauxdiwuw7ulrq3jiqr3t5dy6d@pxwlz2tkjswo>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-21-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230230150.4150236-21-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 30, 2025 at 03:01:49PM -0800, Sean Christopherson wrote:
> Shorten the API to get a PTE as the "PTE" acronym is ubiquitous, and the
> "page table entry" makes it unnecessarily difficult to quickly understand
> what callers are doing.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  tools/testing/selftests/kvm/include/x86/processor.h           | 2 +-
>  tools/testing/selftests/kvm/lib/x86/processor.c               | 2 +-
>  tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c            | 2 +-
>  .../selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c     | 4 +---
>  4 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
> index 7b7d962244d6..ab29b1c7ed2d 100644
> --- a/tools/testing/selftests/kvm/include/x86/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> @@ -1357,7 +1357,7 @@ static inline bool kvm_is_ignore_msrs(void)
>  	return get_kvm_param_bool("ignore_msrs");
>  }
>  
> -uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
> +uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr);
>  
>  uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
>  		       uint64_t a3);
> diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> index 5a3385d48902..ab869a98bbdc 100644
> --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> @@ -390,7 +390,7 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
>  	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
>  }
>  
> -uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
> +uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr)
>  {
>  	int level = PG_LEVEL_4K;
>  
> diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
> index a3b7ce155981..c542cc4762b1 100644
> --- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
> +++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
> @@ -619,7 +619,7 @@ int main(int argc, char *argv[])
>  	 */
>  	gva = vm_vaddr_unused_gap(vm, NTEST_PAGES * PAGE_SIZE, KVM_UTIL_MIN_VADDR);
>  	for (i = 0; i < NTEST_PAGES; i++) {
> -		pte = vm_get_page_table_entry(vm, data->test_pages + i * PAGE_SIZE);
> +		pte = vm_get_pte(vm, data->test_pages + i * PAGE_SIZE);
>  		gpa = addr_hva2gpa(vm, pte);
>  		virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PAGE_MASK);
>  		data->test_pages_pte[i] = gva + (gpa & ~PAGE_MASK);
> diff --git a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
> index fabeeaddfb3a..0e8aec568010 100644
> --- a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
> +++ b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
> @@ -47,7 +47,6 @@ int main(int argc, char *argv[])
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm;
>  	struct ucall uc;
> -	uint64_t *pte;
>  	uint64_t *hva;
>  	uint64_t gpa;
>  	int rc;
> @@ -73,8 +72,7 @@ int main(int argc, char *argv[])
>  	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
>  	memset(hva, 0, PAGE_SIZE);
>  
> -	pte = vm_get_page_table_entry(vm, MEM_REGION_GVA);
> -	*pte |= BIT_ULL(MAXPHYADDR);
> +	*vm_get_pte(vm, MEM_REGION_GVA) |= BIT_ULL(MAXPHYADDR);
>  
>  	vcpu_run(vcpu);
>  
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

