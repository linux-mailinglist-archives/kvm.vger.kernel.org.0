Return-Path: <kvm+bounces-2197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BACE7F3391
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 17:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 943E9B220CF
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 16:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8865A10A;
	Tue, 21 Nov 2023 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eVwqUMJq"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FE2112;
	Tue, 21 Nov 2023 08:22:41 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0FE4A40E0031;
	Tue, 21 Nov 2023 16:22:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id oGV3VnjCGa0l; Tue, 21 Nov 2023 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1700583756; bh=KxtFZyD5p+0QcjGE2q3dM11exyBdBO+J4w/uEQye0ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eVwqUMJqsVBloXiFRt+258PJZFxtbn4wup872Xc1eoqsrYQJz+sNNzMfmerWNy9Ye
	 gJS9fWp4qQRzMrP/8h2ZCNfdu0EyfGQjIx/4dXPX/YYQ+/s5+bhQQsWsxBhwnzpteO
	 sRlbZz6JKXOrk4JPgu3m9+bf2ulEoQJyAGr5xRvZQv3QffnTgXrj8i/6DT0ZD2MMCG
	 a7F/anwpZmcKO4rgvu/vfInEj0icBwTmo9dyjASF19D5fWnlRnQz7gZvEixvsDzY7I
	 dMsaKp1tq3jRgTCizTvL2E/10HFgE27HT64RIbLAM76/wiXAiLf2iHI0OsvDfS+AkY
	 FVrgvhJjTphltPocEVyzTEoq+YCP8d3m/cg6cPLIKRBGPJmmWlWR8TutanG6QMYtDL
	 /7lFAyeO4IZ3hZgxOlAEZQn0kff60spdv8O8ugxapdgUvPqiXzKrjSAJ40sOUl3Say
	 P1+0IsBOsneK/9T2yy2gTJ/7e8OIgsBU7bM+HJbyGHb3kKm97uMyq8UAcGfVnYG6M4
	 YPInq/u+smERJV4XSqxngcedV06ZTkID1BHdNOqgucK9mlKQLChBTKtiGAheZNy7jM
	 x7+ghE5Nr1+wm+4Rn3W12IJbzDp+jqAnUCfodqx+BMXrNfZ21JeHa/naTZq8kOfIU6
	 bJClC6oA6/aymqRh/j5YGUlg=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6FCF940E0032;
	Tue, 21 Nov 2023 16:21:55 +0000 (UTC)
Date: Tue, 21 Nov 2023 17:21:49 +0100
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
Subject: Re: [PATCH v10 11/50] x86/sev: Add helper functions for RMPUPDATE
 and PSMASH instruction
Message-ID: <20231121162149.GFZVzZHQB1g2bdvJie@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-12-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-12-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:40AM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
> hypervisor will use the instruction to add pages to the RMP table. See
> APM3 for details on the instruction operations.
> 
> The PSMASH instruction expands a 2MB RMP entry into a corresponding set
> of contiguous 4KB-Page RMP entries. The hypervisor will use this

s/-Page//

> instruction to adjust the RMP entry without invalidating the previous
> RMP entry.

"... without invalidating it."

This below is useless text in the commit message - that should be all
visible from the patch itself.

> Add the following external interface API functions:
> 
> psmash(): Used to smash a 2MB aligned page into 4K pages while
> preserving the Validated bit in the RMP.
> 
> rmp_make_private(): Used to assign a page to guest using the RMPUPDATE
> instruction.
> 
> rmp_make_shared(): Used to transition a page to hypervisor/shared
> state using the RMPUPDATE instruction.

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Since Brijesh is the author, first comes his SOB, then Ashish's and then
yours.

> [mdr: add RMPUPDATE retry logic for transient FAIL_OVERLAP errors]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h | 14 +++++
>  arch/x86/include/asm/sev-host.h   | 10 ++++
>  arch/x86/virt/svm/sev.c           | 89 +++++++++++++++++++++++++++++++
>  3 files changed, 113 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 1e6fb93d8ab0..93ec8c12c91d 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -173,8 +173,22 @@ struct snp_psc_desc {
>  #define GHCB_ERR_INVALID_INPUT		5
>  #define GHCB_ERR_INVALID_EVENT		6
>  
> +/* RMUPDATE detected 4K page and 2MB page overlap. */
> +#define RMPUPDATE_FAIL_OVERLAP		4
> +
>  /* RMP page size */
>  #define RMP_PG_SIZE_4K			0
> +#define RMP_PG_SIZE_2M			1

RMP_PG_LEVEL_2M

>  #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> +#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
> +
> +struct rmp_state {
> +	u64 gpa;
> +	u8 assigned;
> +	u8 pagesize;
> +	u8 immutable;
> +	u8 rsvd;
> +	u32 asid;
> +} __packed;
>  
>  #endif
> diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
> index bb06c57f2909..1df989411334 100644
> --- a/arch/x86/include/asm/sev-host.h
> +++ b/arch/x86/include/asm/sev-host.h
> @@ -16,9 +16,19 @@
>  #ifdef CONFIG_KVM_AMD_SEV
>  int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
>  void sev_dump_hva_rmpentry(unsigned long address);
> +int psmash(u64 pfn);
> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
> +int rmp_make_shared(u64 pfn, enum pg_level level);
>  #else
>  static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENXIO; }
>  static inline void sev_dump_hva_rmpentry(unsigned long address) {}
> +static inline int psmash(u64 pfn) { return -ENXIO; }
> +static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
> +				   bool immutable)
> +{
> +	return -ENXIO;
> +}
> +static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENXIO; }
>  #endif
>  
>  #endif
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index cac3e311c38f..24a695af13a5 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -367,3 +367,92 @@ void sev_dump_hva_rmpentry(unsigned long hva)
>  	sev_dump_rmpentry(pte_pfn(*pte));
>  }
>  EXPORT_SYMBOL_GPL(sev_dump_hva_rmpentry);
> +
> +/*
> + * PSMASH a 2MB aligned page into 4K pages in the RMP table while preserving the
> + * Validated bit.
> + */
> +int psmash(u64 pfn)
> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	int ret;
> +
> +	pr_debug("%s: PFN: 0x%llx\n", __func__, pfn);

Left over?

> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;

That needs to happen first in the function.

> +
> +	/* Binutils version 2.36 supports the PSMASH mnemonic. */
> +	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
> +		      : "=a"(ret)
> +		      : "a"(paddr)

Add an empty space between the " and the (

> +		      : "memory", "cc");
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(psmash);
> +
> +static int rmpupdate(u64 pfn, struct rmp_state *val)

rmp_state *state

so that it is clear what this is.

> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	int ret, level, npages;
> +	int attempts = 0;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;
> +
> +	do {
> +		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
> +		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> +			     : "=a"(ret)
> +			     : "a"(paddr), "c"((unsigned long)val)

Add an empty space between the " and the (

> +			     : "memory", "cc");
> +
> +		attempts++;
> +	} while (ret == RMPUPDATE_FAIL_OVERLAP);

What's the logic here? Loop as long as it says "overlap"?

How "transient" is that overlapping condition?

What's the upper limit of that loop?

This loop should check a generously chosen upper limit of attempts and
then break if that limit is reached.

> +	if (ret) {
> +		pr_err("RMPUPDATE failed after %d attempts, ret: %d, pfn: %llx, npages: %d, level: %d\n",
> +		       attempts, ret, pfn, npages, level);

You're dumping here uninitialized stack variables npages and level.
Looks like leftover from some prior version of this function.

> +		sev_dump_rmpentry(pfn);
> +		dump_stack();

This is going to become real noisy on a huge machine with a lot of SNP
guests.

> +		return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Assign a page to guest using the RMPUPDATE instruction.
> + */

One-line comment works too.

/* Assign ... */

> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
> +{
> +	struct rmp_state val;
> +
> +	memset(&val, 0, sizeof(val));
> +	val.assigned = 1;
> +	val.asid = asid;
> +	val.immutable = immutable;
> +	val.gpa = gpa;
> +	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> +
> +	return rmpupdate(pfn, &val);
> +}
> +EXPORT_SYMBOL_GPL(rmp_make_private);
> +
> +/*
> + * Transition a page to hypervisor/shared state using the RMPUPDATE instruction.
> + */

Ditto.

> +int rmp_make_shared(u64 pfn, enum pg_level level)
> +{
> +	struct rmp_state val;
> +
> +	memset(&val, 0, sizeof(val));
> +	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> +
> +	return rmpupdate(pfn, &val);
> +}
> +EXPORT_SYMBOL_GPL(rmp_make_shared);
> -- 

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

