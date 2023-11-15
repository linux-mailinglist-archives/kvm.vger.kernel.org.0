Return-Path: <kvm+bounces-1834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E51247EC82E
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 17:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 201D91C20B9B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 16:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751BD31756;
	Wed, 15 Nov 2023 16:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="htGOrDLe"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F683173C;
	Wed, 15 Nov 2023 16:09:50 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DCC83;
	Wed, 15 Nov 2023 08:09:48 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A522340E018F;
	Wed, 15 Nov 2023 16:09:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id XnjlSzdNZWW9; Wed, 15 Nov 2023 16:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1700064582; bh=bueQ2kw7gyEFK0bJoqQbhhrZVo/9ubg2OCMl9sxv48U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=htGOrDLe+3bJficaYArCv8d5oQ8bNdPh02lr3A54uQfa/eBBm6wyzdJr2GalIjlBg
	 CMi9t46e+ppAubFDqG9qjUioO4AeE3WwDA+d3OlGAzmTsmYoV9wca+Qax1skABRNzW
	 nOQrmVHAFiDs5ROjiFOvA4Fn7n1+BGR1J/vFUuCRHMY9XXRyDlr8RHhw3mVKA5kHtm
	 x3MXIsRL8kPsWoQgRYm7pgS/Yya6wY24cf7hq1n34j7yXXQTLRHbXmaHopZhxf0Zrh
	 0ABQIgTbeddkTIXb2u6tT3XqgeHWtrGyXHXpJrxe8LRPW6IkXr+2zXO5AFxH9PFm87
	 tR61dMECG/8Q8JMGs7WO+sFHZpT3rxgyyc1gvhnQhhsRu7BZLaXvNf0cbOTY7Tf/7A
	 rihB0PXLS/S69T6KmHf4blvUYlJmm4SGvnnGhZrX5/FOW2pG4yXZt2PPqfSYh2uOvj
	 XX2QcR+9mQN7HTtCX0qphDqtLTrD7vxcVEFBK0zwGR11ggnBdyNWN8jr7If1A16dO3
	 I7SzyUrQ9f7iskGXh7Nvby7p7OS9JleG9hdR1F1/tij7BgjRi/Eb5kWdgPmMYrpIlp
	 ZuQhd05YRHikbirhjVOGagNSe1s9xDEn6dUIVdxkovglOs74ktLMU/3d1HZnFWHnRc
	 3NdkbkJ7Myl//EmKR6/Lf/4U=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8FA4440E0030;
	Wed, 15 Nov 2023 16:09:01 +0000 (UTC)
Date: Wed, 15 Nov 2023 17:08:52 +0100
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
	tony.luck@intel.com, marcorr@google.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 08/50] x86/fault: Add helper for dumping RMP entries
Message-ID: <20231115160852.GDZVTtFHB0+HpVZnpG@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-9-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-9-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:37AM -0500, Michael Roth wrote:
> +/*
> + * Dump the raw RMP entry for a particular PFN. These bits are documented in the
> + * PPR for a particular CPU model and provide useful information about how a
> + * particular PFN is being utilized by the kernel/firmware at the time certain
> + * unexpected events occur, such as RMP faults.
> + */
> +static void sev_dump_rmpentry(u64 dumped_pfn)

Just "dump_rmentry"

s/dumped_pfn/pfn/g

> +	struct rmpentry e;
> +	u64 pfn, pfn_end;
> +	int level, ret;
> +	u64 *e_data;
> +
> +	ret = __snp_lookup_rmpentry(dumped_pfn, &e, &level);
> +	if (ret) {
> +		pr_info("Failed to read RMP entry for PFN 0x%llx, error %d\n",
> +			dumped_pfn, ret);
> +		return;
> +	}
> +
> +	e_data = (u64 *)&e;
> +	if (e.assigned) {
> +		pr_info("RMP entry for PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> +			dumped_pfn, e_data[1], e_data[0]);
> +		return;
> +	}
> +
> +	/*
> +	 * If the RMP entry for a particular PFN is not in an assigned state,
> +	 * then it is sometimes useful to get an idea of whether or not any RMP
> +	 * entries for other PFNs within the same 2MB region are assigned, since
> +	 * those too can affect the ability to access a particular PFN in
> +	 * certain situations, such as when the PFN is being accessed via a 2MB
> +	 * mapping in the host page table.
> +	 */
> +	pfn = ALIGN(dumped_pfn, PTRS_PER_PMD);
> +	pfn_end = pfn + PTRS_PER_PMD;
> +
> +	while (pfn < pfn_end) {
> +		ret = __snp_lookup_rmpentry(pfn, &e, &level);
> +		if (ret) {
> +			pr_info_ratelimited("Failed to read RMP entry for PFN 0x%llx\n", pfn);

Why ratelmited?

No need to print anything if you fail to read it - simply dump the range
[pfn, pfn_end], _data[0], e_data[1] exactly *once* before the loop and
inside the loop dump only the ones you can lookup...

> +			pfn++;
> +			continue;
> +		}
> +
> +		if (e_data[0] || e_data[1]) {
> +			pr_info("No assigned RMP entry for PFN 0x%llx, but the 2MB region contains populated RMP entries, e.g.: PFN 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> +				dumped_pfn, pfn, e_data[1], e_data[0]);
> +			return;
> +		}
> +		pfn++;
> +	}
> +
> +	pr_info("No populated RMP entries in the 2MB region containing PFN 0x%llx\n",
> +		dumped_pfn);

... and then you don't need this one either.

> +}
> +
> +void sev_dump_hva_rmpentry(unsigned long hva)
> +{
> +	unsigned int level;
> +	pgd_t *pgd;
> +	pte_t *pte;
> +
> +	pgd = __va(read_cr3_pa());
> +	pgd += pgd_index(hva);
> +	pte = lookup_address_in_pgd(pgd, hva, &level);

If this is using the current CR3, why aren't you simply using
lookup_address() here without the need to read pgd?

> +
> +	if (pte) {

	if (!pte)

Doh.

> +		pr_info("Can't dump RMP entry for HVA %lx: no PTE/PFN found\n", hva);
> +		return;
> +	}
> +
> +	sev_dump_rmpentry(pte_pfn(*pte));
> +}
> +EXPORT_SYMBOL_GPL(sev_dump_hva_rmpentry);

Who's going to use this, kvm?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

