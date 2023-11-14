Return-Path: <kvm+bounces-1651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D657EB20F
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BFE8281222
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1914122F;
	Tue, 14 Nov 2023 14:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="M7fWSXjw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A6141222;
	Tue, 14 Nov 2023 14:25:36 +0000 (UTC)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234F4CA;
	Tue, 14 Nov 2023 06:25:35 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7515E40E0171;
	Tue, 14 Nov 2023 14:25:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NpxUmh6qH1xl; Tue, 14 Nov 2023 14:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1699971929; bh=S9j4pHyC5eZLovFq9DRdpMMk7CVfs5bDRVFiXlSpQno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M7fWSXjw2JBel9ThmJ9QDNCHaD5NxcrsjiYGuZ4LFSYhzr8pwCXECZxnUwimfrnPa
	 ZT9rJ7dRyg8oH+tiW56ux7lLMvP1KtI+FbygIUmL/jGCSSkXDoYS0A0VgYIiUCMA4H
	 bPAqU7d/Kij5AFE9EDHJjIWUpf6jKdoReOKgjceyKEqZQtdbjvzG9FFuETFUvdMcHk
	 x1y5yOAge4H7RuHmAXLyuxBoIh6vT/B+qKDOqvaflDoqGMEi+E4FGCxI3nxB6LOFPa
	 23YOxOgVc93EVki++VYcVYmYETwDpbTg1OVWnlkmz3zV/i+VhwrQU3mnnyukh8Pa1y
	 Z8rYS/I2/juroXA5McUNecg4yFIFOfnOe1th06HlaRw+cczqm25nkp1Ca9kr28KfH7
	 Jid67JdK5aI+qwrWlxyxv6iGDkYtP/SMGTtvgmNL58RV5+bLZ4M9R3Qtx7rpL9/VcZ
	 8l8NJPXXzULhWJbHP89JBGZNca7532vih3kd7jNu2AdSbGK6x+t3foNfol9CXjKC1k
	 +3YZzfVz0Zy+CgOAao/tsmgtYQfzSbGILuVsSsjrGAA6w2jg2HIgkxabDldxFf80/6
	 qJtedObJ0xgbMZB9p0vfuUl/t5UmB8i5Jo/YZ+/6TdZ28Mb3ocaKW1hFc1ApJEqR4V
	 OU5lxwsBX1DQp6rpAf+drH3Y=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0548540E018F;
	Tue, 14 Nov 2023 14:24:48 +0000 (UTC)
Date: Tue, 14 Nov 2023 15:24:42 +0100
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
Subject: Re: [PATCH v10 07/50] x86/sev: Add RMP entry lookup helpers
Message-ID: <20231114142442.GCZVODKh03BoMFdlmj@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-8-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-8-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:36AM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The snp_lookup_page_in_rmptable() can be used by the host to read the RMP

$ git grep snp_lookup_page_in_rmptable
$

Stale commit message. And not very telling. Please rewrite.

> entry for a given page. The RMP entry format is documented in AMD PPR, see
> https://bugzilla.kernel.org/attachment.cgi?id=296015.

<--- Brijesh's SOB comes first here if he's the primary author.

> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> [mdr: separate 'assigned' indicator from return code]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  4 +++
>  arch/x86/include/asm/sev-host.h   | 22 +++++++++++++
>  arch/x86/virt/svm/sev.c           | 53 +++++++++++++++++++++++++++++++
>  3 files changed, 79 insertions(+)
>  create mode 100644 arch/x86/include/asm/sev-host.h
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index b463fcbd4b90..1e6fb93d8ab0 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -173,4 +173,8 @@ struct snp_psc_desc {
>  #define GHCB_ERR_INVALID_INPUT		5
>  #define GHCB_ERR_INVALID_EVENT		6
>  
> +/* RMP page size */
> +#define RMP_PG_SIZE_4K			0

RMP_PG_LEVEL_4K just like the generic ones.

> +#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)

What else is there besides X86 PG level?

IOW, RMP_TO_PG_LEVEL simply.

> +
>  #endif
> diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h

Nah, we don't need a third sev header:

arch/x86/include/asm/sev-common.h
arch/x86/include/asm/sev.h
arch/x86/include/asm/sev-host.h

Put it in sev.h pls.

sev-common.h should be merged into sev.h too unless there's a compelling
reason not to which I don't see atm.

> new file mode 100644
> index 000000000000..4c487ce8457f
> --- /dev/null
> +++ b/arch/x86/include/asm/sev-host.h

...

> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 8b9ed72489e4..7d3802605376 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -53,6 +53,9 @@ struct rmpentry {
>   */
>  #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
>  
> +/* Mask to apply to a PFN to get the first PFN of a 2MB page */
> +#define PFN_PMD_MASK	(~((1ULL << (PMD_SHIFT - PAGE_SHIFT)) - 1))

GENMASK_ULL

>  static struct rmpentry *rmptable_start __ro_after_init;
>  static u64 rmptable_max_pfn __ro_after_init;
>  
> @@ -237,3 +240,53 @@ static int __init snp_rmptable_init(void)
>   * the page(s) used for DMA are hypervisor owned.
>   */
>  fs_initcall(snp_rmptable_init);
> +
> +static int rmptable_entry(u64 pfn, struct rmpentry *entry)

The signature of this one should be:

static struct rmpentry *get_rmp_entry(u64 pfn)

and the callers should use the IS_ERR* macros to check whether it
returns a valid pointer or a negative value for error.

Ditto for the other two functions here.

> +	if (WARN_ON_ONCE(pfn > rmptable_max_pfn))
> +		return -EFAULT;
> +
> +	*entry = rmptable_start[pfn];

This wants to be called rmptable[] then.

> +
> +	return 0;
> +}
> +
> +static int __snp_lookup_rmpentry(u64 pfn, struct rmpentry *entry, int *level)
> +{
> +	struct rmpentry large_entry;
> +	int ret;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;

ENODEV or so.

> +
> +	ret = rmptable_entry(pfn, entry);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Find the authoritative RMP entry for a PFN. This can be either a 4K
> +	 * RMP entry or a special large RMP entry that is authoritative for a
> +	 * whole 2M area.
> +	 */
> +	ret = rmptable_entry(pfn & PFN_PMD_MASK, &large_entry);
> +	if (ret)
> +		return ret;
> +
> +	*level = RMP_TO_X86_PG_LEVEL(large_entry.pagesize);
> +
> +	return 0;
> +}
> +
> +int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
> +{
> +	struct rmpentry e;
> +	int ret;
> +
> +	ret = __snp_lookup_rmpentry(pfn, &e, level);
> +	if (ret)
> +		return ret;
> +
> +	*assigned = !!e.assigned;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> -- 

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

