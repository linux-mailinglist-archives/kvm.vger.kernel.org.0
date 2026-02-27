Return-Path: <kvm+bounces-72130-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CLUNRE+oWnsrQQAu9opvQ
	(envelope-from <kvm+bounces-72130-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 07:47:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E34F1B3760
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 07:47:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D26EB30CE47E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 06:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9484E37A4AA;
	Fri, 27 Feb 2026 06:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPYM0RiM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC89B3375C2
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772174847; cv=none; b=DJTGB5WsB3slSUKJeamXVEU+iIlmeUIUwNEEs80K8DfLh/rjXgmsnjWWrUOPzmVvm2ySmBRgk9pU/YoPLza4BKlPlle+xFyGfKgZYdAMoGHTFJDBJTT43GQtg+sM1fNGpDhCcLn6lXUZVZAVDvQ31rGMAXz/4+IaLDui+soOGek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772174847; c=relaxed/simple;
	bh=KO2bW00MM7LDG//quqXYZmj/ahwm2FnxZhGD6CmuPkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QDepT+cDQQyd+oqmwrWZIkEWV5E4BP5L5gaPywjuJqjQd120UXGlPUSuSVPzOz/cTaup4qLJTBSmNsHar5woWXuftiw2GaWKQ2EsQfJIMtWT9twG9qV6McRdgm2gI8F7lxz3HiO0V1N3lv25Hf7qFNrgF4Lp52y9gC5uPNDuOLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPYM0RiM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF83C19422;
	Fri, 27 Feb 2026 06:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772174847;
	bh=KO2bW00MM7LDG//quqXYZmj/ahwm2FnxZhGD6CmuPkc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PPYM0RiMcmK4BZUonZBiN7hp3nR4ppxvaDhDxzl0NbcO5XRjZ91TMYXbShCI54IVZ
	 JvN1rA3Ml1woOMP0m+wIjntDHOEu3aRhaIP0zOtPkZ9E/CKzgktxC/jyEMpkxbexf7
	 /czR5FfE/5J98rtUZWaEnsjHK8VYxycf1GGbFpDpN3bMnxMxPSepmdiQaXS2Oyu+zG
	 Npyx/UwNsnLxyP7A/JPD4f5fR831f9pRGSjIKcSNqRUy/5hLhU+NiFgvSF4d+s3mQ8
	 v9AWPK6Y16exoSilsS+YLigMUjHo4g2eU/p0IHsvOVH4LZe6H7/i3oA/LzqlljZK9h
	 zfarBq1DXpLUA==
Message-ID: <abfbe83b-23fb-400d-9069-b8bf4ad21d95@kernel.org>
Date: Fri, 27 Feb 2026 07:47:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 2/2] powerpc/64s: Add support for huge pfnmaps
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org,
 Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com>
 <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72130-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,lists.ozlabs.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chleroy@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3E34F1B3760
X-Rspamd-Action: no action



Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
> This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
> This also adds support for {pte,pmd,pud}_pgprot helpers needed for
> follow_pfnmap APIs.
> 
> This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
> it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
> VFIO PCI core driver already supports fault handling at PMD / PUD level
> for more efficient BAR mappings.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>


> ---
> 
> @linux-mm:
> Is there any official test which I could use to verify this functionality.
> 
> For now I used basic ivshmem setup + vfio using Qemu and validated using some
> basic test to see that we are seeing these prints.
> 
> [ 4351.435050] vfio_pci_mmap_huge_fault: 3 callbacks suppressed
> [ 4351.435234] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x0: 0x100
> [ 4351.457005] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x40: 0x100
> [ 4351.463684] vfio-pci 0001:00:00.0: vfio_pci_mmap_huge_fault(,order = 5) BAR 2 page offset 0x20: 0x100
> 
>   arch/powerpc/Kconfig                         |  1 +
>   arch/powerpc/include/asm/book3s/64/pgtable.h | 23 ++++++++++++++++++++
>   arch/powerpc/include/asm/pgtable.h           | 12 ++++++++++
>   3 files changed, 36 insertions(+)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index ad7a2fe63a2a..cf9283757e5d 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -172,6 +172,7 @@ config PPC
>   	select ARCH_STACKWALK
>   	select ARCH_SUPPORTS_ATOMIC_RMW
>   	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC_BOOK3S || PPC_8xx
> +	select ARCH_SUPPORTS_HUGE_PFNMAP	if PPC_BOOK3S_64 && TRANSPARENT_HUGEPAGE
>   	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if !HUGETLB_PAGE
>   	select ARCH_SUPPORTS_SCHED_MC		if SMP
>   	select ARCH_SUPPORTS_SCHED_SMT		if PPC64 && SMP
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index 1a91762b455d..639cbf34f752 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1289,6 +1289,29 @@ static inline pud_t pud_mkhuge(pud_t pud)
>   	return pud;
>   }
> 
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +static inline bool pmd_special(pmd_t pmd)
> +{
> +	return pte_special(pmd_pte(pmd));
> +}
> +
> +static inline pmd_t pmd_mkspecial(pmd_t pmd)
> +{
> +	return pte_pmd(pte_mkspecial(pmd_pte(pmd)));
> +}
> +#endif
> +
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +static inline bool pud_special(pud_t pud)
> +{
> +	return pte_special(pud_pte(pud));
> +}
> +
> +static inline pud_t pud_mkspecial(pud_t pud)
> +{
> +	return pte_pud(pte_mkspecial(pud_pte(pud)));
> +}
> +#endif
> 
>   #define __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
>   extern int pmdp_set_access_flags(struct vm_area_struct *vma,
> diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
> index dcd3a88caaf6..2d27cb1c2334 100644
> --- a/arch/powerpc/include/asm/pgtable.h
> +++ b/arch/powerpc/include/asm/pgtable.h
> @@ -63,6 +63,18 @@ static inline pgprot_t pte_pgprot(pte_t pte)
>   	return __pgprot(pte_flags);
>   }
> 
> +#define pmd_pgprot pmd_pgprot
> +static inline pgprot_t pmd_pgprot(pmd_t pmd)
> +{
> +	return pte_pgprot(pmd_pte(pmd));
> +}
> +
> +#define pud_pgprot pud_pgprot
> +static inline pgprot_t pud_pgprot(pud_t pud)
> +{
> +	return pte_pgprot(pud_pte(pud));
> +}
> +
>   static inline pgprot_t pgprot_nx(pgprot_t prot)
>   {
>   	return pte_pgprot(pte_exprotect(__pte(pgprot_val(prot))));
> --
> 2.53.0
> 
> 


