Return-Path: <kvm+bounces-4727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFAA581746F
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 15:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 664CBB2254C
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 14:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CB03A1C1;
	Mon, 18 Dec 2023 14:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="f7Ico4zk"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6EE37881;
	Mon, 18 Dec 2023 14:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2115840E00A9;
	Mon, 18 Dec 2023 14:58:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id duilsy3bKYSQ; Mon, 18 Dec 2023 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702911518; bh=1weCWgHoOtoy2vZBHy2ouJrV4MN1BpD6yK4soKgP07A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f7Ico4zkVTqrPgNkFulLln5Nn7Rt6hd6Lducnsi8AYtG2bRm1E7fIBe6Agbk2AS6/
	 FBDdj+dVtsq21L4WCqfqzN77iciza6p2Aazc2xTtVR3SxGuiOp0VPWoYs+A/dgTw5b
	 FgSNf+naMbhlKqPoTH4nYKt6j/lGJTCzRFDF4XDSqBeJbwFjcBzMZA6eR0ZnvgW5aN
	 /N2XD1CjVWWNzuNDrtaYPgb/nDgDtai+TfUQDFIVaeu0uSEwHoXEt+3JE6DkHhBz6j
	 wvXlKb79qjR05I27rf8pvHauSbZPWHvBhI6rsPg1l8zLgirQ22GzSLcHG+dOypn41P
	 PcoxaCOKIRq+p6J/7+9P+8OePnsL2wBeWwV1cvApZkEYjZhj6gxrQsBbuLgucPLPdh
	 t8RC4QYZ50vBVCiyindR7gHvpBk9/KtPZSxrkHRhlg3/rkjSjF4p4Z2DMEFrl7ydMC
	 fmG7msrfTsjutInRMdlsQJBiQI1INizVxWIRhb+u7mGKAarSV0OH67C80Lko5LTDDe
	 srRrnXx9sapR/7cSRyPEKGogfLs/jNmNHc7T2XI9NAIVSSFtNoxs4tYoSR8TR17OpG
	 6jEfc1CY0Pj+fXzA549HB2h4pmBSG3wjep4rqzlZPMZqBTnh5l17Nw0wYsSbaICG+w
	 CkPBR5p/qZQ9y1BnQook8fHg=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9413440E0030;
	Mon, 18 Dec 2023 14:57:58 +0000 (UTC)
Date: Mon, 18 Dec 2023 15:57:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
	alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 23/50] KVM: SEV: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
Message-ID: <20231218145752.GQZYBd8D1iJBrI3cWs@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-24-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-24-michael.roth@amd.com>


Just typos:

On Mon, Oct 16, 2023 at 08:27:52AM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> RMP entry of a VMCB, VMSA or AVIC backing page.
> 
> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> backing pages as "in-use" via a reserved bit in the corresponding RMP
> entry after a successful VMRUN. This is done for _all_ VMs, not just
> SNP-Active VMs.
> 
> If the hypervisor accesses an in-use page through a writable
> translation, the CPU will throw an RMP violation #PF. On early SNP
> hardware, if an in-use page is 2mb aligned and software accesses any
> part of the associated 2mb region with a hupage, the CPU will

"hugepage"

> incorrectly treat the entire 2mb region as in-use and signal a spurious
> RMP violation #PF.
> 
> The recommended is to not use the hugepage for the VMCB, VMSA or

s/recommended/recommendation/
s/the hugepage/a hugepage/

> AVIC backing page for similar reasons. Add a generic allocator that will
> ensure that the page returns is not hugepage (2mb or 1gb) and is safe to

"... the page returned is not a hugepage..."

...

> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long pfn;
> +	struct page *p;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +
> +	/*
> +	 * Allocate an SNP safe page to workaround the SNP erratum where
> +	 * the CPU will incorrectly signal an RMP violation  #PF if a
> +	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
> +	 * or AVIC backing page. The recommeded workaround is to not use the

"recommended"

> +	 * hugepage.
> +	 *
> +	 * Allocate one extra page, use a page which is not 2mb aligned
> +	 * and free the other.
> +	 */
> +	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> +	if (!p)
> +		return NULL;
> +
> +	split_page(p, 1);
> +
> +	pfn = page_to_pfn(p);
> +	if (IS_ALIGNED(pfn, PTRS_PER_PMD))
> +		__free_page(p++);
> +	else
> +		__free_page(p + 1);
> +
> +	return p;
> +}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

