Return-Path: <kvm+bounces-2435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7B07F763E
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 15:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE537282078
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 14:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE4542D615;
	Fri, 24 Nov 2023 14:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Ctooe/e9"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81D61992;
	Fri, 24 Nov 2023 06:21:29 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EDE9D40E014B;
	Fri, 24 Nov 2023 14:21:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YSeBXnDxtyE4; Fri, 24 Nov 2023 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1700835684; bh=70iKoPUGxr70BVQmnLb6A91Gn+tCho1RWbxI7o21LXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ctooe/e9xdy7g9A5Dt3Co0Eih6gkBFObocpqY9kf+AVVX2JHHnrhGw956oEpX2JSl
	 pWLZ+ahyE8qbumSobifYHrDWkNgjqRE2iukzLYGxMCdUQe23vykj1F8o+tPwuVVJeX
	 8FDKfwXuaG1ThoXbxS2ho06wnEKITKqosOxfM+NS+c5QbXPzFqdbQOnEv7pu3M1sAS
	 ch19QwIEi5sim25VWG59lh+/w9JdOgZ3Pk9zZWj4KUKSCaQkY6V21JUmGpqCKJEDeq
	 GeyndQcsiIhyBcDub9T5+b2SkMCQ3PAXXJX55NKbmMxfVWfNd/sIt1YcDglyMRKGD3
	 Tw4vME3fA66qWtvNS0bhOMQo7RlE6dIOBNfdMuDqxRfDAvwOUuHaw0AA6KDANfVEA1
	 gqSfIZGxL2/3bnUeNNZ3vhPytb603QwpgcLvmYQQDfpp51v+P3sULMlfBLI6VqutPx
	 T2sjDy5Q66tOUvH9FVsBs8vCfKtjTc7MujYkFp88FWTDu6VmN9lMgpYsTCFENJ+0Gh
	 9i8PFahOe9kp4ZGsyLzADxDhStdNLcg2Y3WYGs+G15F4ko4D83as9ax0X/aHqNuXE1
	 vW6e47/s0EI/jlEnPXTx52prR/UIzAk2uwbVXPuoUvaDNBaRKKTBvkLWPm9WqvnnHk
	 od6sd/wlEQNH5QrX5sJdyX44=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E2DD740E01A5;
	Fri, 24 Nov 2023 14:20:43 +0000 (UTC)
Date: Fri, 24 Nov 2023 15:20:43 +0100
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
Subject: Re: [PATCH v10 12/50] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20231124142043.GJZWCxOxeX0MLyZEWs@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-13-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-13-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:41AM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The integrity guarantee of SEV-SNP is enforced through the RMP table.
> The RMP is used with standard x86 and IOMMU page tables to enforce
> memory restrictions and page access rights. The RMP check is enforced as
> soon as SEV-SNP is enabled globally in the system. When hardware
> encounters an RMP-check failure, it raises a page-fault exception.
> 
> The rmp_make_private() and rmp_make_shared() helpers are used to add
> or remove the pages from the RMP table. Improve the rmp_make_private()
> to invalidate state so that pages cannot be used in the direct-map after
> they are added the RMP table, and restored to their default valid
> permission after the pages are removed from the RMP table.

Brijesh's SOB comes

<--- here,

then Ashish's two tags.

Please audit your whole set for such inconsistencies.

> @@ -404,6 +440,21 @@ static int rmpupdate(u64 pfn, struct rmp_state *val)
>  	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>  		return -ENXIO;
>  
> +	level = RMP_TO_X86_PG_LEVEL(val->pagesize);
> +	npages = page_level_size(level) / PAGE_SIZE;
> +
> +	/*
> +	 * If page is getting assigned in the RMP table then unmap it from the
> +	 * direct map.

Here I'm missing the explanation *why* the pages need to be unmapped
from the direct map.

What happens if not?

> +	 */
> +	if (val->assigned) {
> +		if (invalidate_direct_map(pfn, npages)) {
> +			pr_err("Failed to unmap %d pages at pfn 0x%llx from the direct_map\n",
> +			       npages, pfn);

invalidate_direct_map() already dumps an error message - no need to do
that here too.

> +			return -EFAULT;
> +		}
> +	}
> +
>  	do {
>  		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
>  		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> @@ -422,6 +473,17 @@ static int rmpupdate(u64 pfn, struct rmp_state *val)
>  		return -EFAULT;
>  	}
>  
> +	/*
> +	 * Restore the direct map after the page is removed from the RMP table.
> +	 */
> +	if (!val->assigned) {
> +		if (restore_direct_map(pfn, npages)) {
> +			pr_err("Failed to map %d pages at pfn 0x%llx into the direct_map\n",
> +			       npages, pfn);

Ditto.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

