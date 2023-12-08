Return-Path: <kvm+bounces-3913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA45680A41E
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 14:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A3681C20D98
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 13:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A67E1C6AF;
	Fri,  8 Dec 2023 13:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GbulNFr8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4594F1995;
	Fri,  8 Dec 2023 05:06:08 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E733740E00CC;
	Fri,  8 Dec 2023 13:06:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id UcgXcBcz720k; Fri,  8 Dec 2023 13:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702040762; bh=k9BBLCJJHxA1EJZX5E05AB1l8VGWke2lYGmIBt3xYhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GbulNFr88+NES6gJHTFBzrBKX/G3XJQuA9w1k2sxH60A/Wa+Q0S4Q4ADKct/6sZd7
	 jWtKPKbepUNQmtCtWDUDBg+npO3ghryF1cxT/96f7+4PpMoauZm3/LQj/AZ+po9XXs
	 nfTqUr4v/Po53yiRNUaaeLru/Iw1JXnsWaOrCJv7f5vFwVQ1mrT8aiVQtly4JT4SvD
	 i+uSxZ1UCEMnWehnui2RGaHlOT0kUlAMce/KNpms2x4RWI5TI2GSkmOs5mf7SqHIiS
	 o40ADaVmrbYYCe1DaIbJQpTW5SNs3d62nQpVEp1+bUdXacnFLMUTnj6kuNXDqJmWNo
	 lebCrPQqNlaYsODU4eKlhHYDK68Vbx87AdzVEmBqkce3j+dYhl0qgQWsCFH2nbl9QQ
	 WtJirz/E27HdFcX46vJQoUnQRBbahjobKBRvgejZqMwVGLWiJWRpty46e3aolqeUDA
	 eH1IDSafl/VjW2eltN6Xit1ttGsl36wW+bf4UVfpZ1mi2B0Fq7DnsVRGZmvcdzBW7L
	 iSk7BTgF/O/fJ0srB42um9or3KpbvdcjjDw4RZGuQ9vie2HF2j6X0ZRJ0/Fqo7c12p
	 WPisowwqJylliuaF9EcI7pqy9VkHToC0fGcJMZ1sB3C1BaBZ0FYpe+ND1BmLfusJ5E
	 hEPD6WDU7YS2VPZbYbCGhfnY=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B4F4140E00A9;
	Fri,  8 Dec 2023 13:05:21 +0000 (UTC)
Date: Fri, 8 Dec 2023 14:05:20 +0100
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
Subject: Re: [PATCH v10 17/50] crypto: ccp: Handle the legacy TMR allocation
 when SNP is enabled
Message-ID: <20231208130520.GFZXMUkKR+aexFpxXf@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-18-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-18-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:46AM -0500, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The behavior and requirement for the SEV-legacy command is altered when
> the SNP firmware is in the INIT state. See SEV-SNP firmware specification
> for more details.
> 
> Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
> when SNP is enabled to satisfy new requirements for the SNP. Continue

s/the //

> allocating a 1mb region for !SNP configuration.
> 
> While at it, provide API that can be used by others to allocate a page

"...an API... ... to allocate a firmware page."

Simple.

> that can be used by the firmware.

> The immediate user for this API will be the KVM driver.

Delete that sentence.

> The KVM driver to need to allocate a firmware context

"The KVM driver needs to allocate ...

> page during the guest creation. The context page need to be updated

"needs"

> by the firmware. See the SEV-SNP specification for further details.
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> [mdr: use struct sev_data_snp_page_reclaim instead of passing paddr
>       directly to SEV_CMD_SNP_PAGE_RECLAIM]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 151 ++++++++++++++++++++++++++++++++---
>  include/linux/psp-sev.h      |   9 +++
>  2 files changed, 151 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 613b25f81498..ea21307a2b34 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -30,6 +30,7 @@
>  #include <asm/smp.h>
>  #include <asm/cacheflush.h>
>  #include <asm/e820/types.h>
> +#include <asm/sev-host.h>
>  
>  #include "psp-dev.h"
>  #include "sev-dev.h"
> @@ -93,6 +94,13 @@ static void *sev_init_ex_buffer;
>  struct sev_data_range_list *snp_range_list;
>  static int __sev_snp_init_locked(int *error);
>  
> +/* When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB size. */
> +#define SEV_SNP_ES_TMR_SIZE	(2 * 1024 * 1024)

There's "SEV", "SNP" *and* "ES". Wow.

Let's do this:

#define SEV_TMR_SIZE	SZ_1M
#define SNP_TMR_SIZE	SZ_2M

Done.

> +static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
> +
> +static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);

Instead of doing forward declarations, move the whole logic around
__sev_do_cmd_locked() up here in the file so that you can call that
function by other functions without forward declarations.

The move should probably be a pre-patch.

>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -193,11 +201,131 @@ static int sev_cmd_buffer_len(int cmd)
>  	return 0;
>  }
>  
> +static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
> +{
> +	/* Cbit maybe set in the paddr */
> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
> +	int ret, err, i, n = 0;
> +
> +	for (i = 0; i < npages; i++, pfn++, n++) {
> +		struct sev_data_snp_page_reclaim data = {0};
> +
> +		data.paddr = pfn << PAGE_SHIFT;

This shifting back'n'forth between paddr and pfn makes this function
hard to read. Let's use only paddr (diff ontop):

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ea21307a2b34..25078b0253bd 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -203,14 +203,15 @@ static int sev_cmd_buffer_len(int cmd)
 
 static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
 {
-	/* Cbit maybe set in the paddr */
-	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
 	int ret, err, i, n = 0;
 
-	for (i = 0; i < npages; i++, pfn++, n++) {
+	/* C-bit maybe set, clear it: */
+	paddr = __sme_clr(paddr);
+
+	for (i = 0; i < npages; i++, paddr += PAGE_SIZE, n++) {
 		struct sev_data_snp_page_reclaim data = {0};
 
-		data.paddr = pfn << PAGE_SHIFT;
+		data.paddr = paddr;
 
 		if (locked)
 			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
@@ -220,7 +221,7 @@ static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool lock
 		if (ret)
 			goto cleanup;
 
-		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
+		ret = rmp_make_shared(__phys_to_pfn(paddr), PG_LEVEL_4K);
 		if (ret)
 			goto cleanup;
 	}
@@ -232,7 +233,7 @@ static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool lock
 	 * If failed to reclaim the page then page is no longer safe to
 	 * be release back to the system, leak it.
 	 */
-	snp_leak_pages(pfn, npages - n);
+	snp_leak_pages(__phys_to_pfn(paddr), npages - n);
 	return ret;
 }
 
> +
> +		if (locked)
> +			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +		else
> +			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +
> +		if (ret)
> +			goto cleanup;
> +
> +		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> +		if (ret)
> +			goto cleanup;
> +	}
> +
> +	return 0;
> +
> +cleanup:
> +	/*
> +	 * If failed to reclaim the page then page is no longer safe to
> +	 * be release back to the system, leak it.

"released"

> +	 */
> +	snp_leak_pages(pfn, npages - n);
> +	return ret;
> +}
> +
> +static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, bool locked)
> +{
> +	/* Cbit maybe set in the paddr */
> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
> +	int rc, n = 0, i;

That n looks like it can be replaced by i.

> +
> +	for (i = 0; i < npages; i++, n++, pfn++) {
> +		rc = rmp_make_private(pfn, 0, PG_LEVEL_4K, 0, true);
> +		if (rc)
> +			goto cleanup;
> +	}
> +
> +	return 0;
> +
> +cleanup:
> +	/*
> +	 * Try unrolling the firmware state changes by
> +	 * reclaiming the pages which were already changed to the
> +	 * firmware state.
> +	 */
> +	snp_reclaim_pages(paddr, n, locked);
> +
> +	return rc;
> +}
> +
> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)

AFAICT, @locked is always false. So it can go.

> +{
> +	unsigned long npages = 1ul << order, paddr;
> +	struct sev_device *sev;
> +	struct page *page;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return NULL;
> +
> +	page = alloc_pages(gfp_mask, order);
> +	if (!page)
> +		return NULL;
> +
> +	/* If SEV-SNP is initialized then add the page in RMP table. */
> +	sev = psp_master->sev_data;
> +	if (!sev->snp_initialized)
> +		return page;
> +
> +	paddr = __pa((unsigned long)page_address(page));
> +	if (rmp_mark_pages_firmware(paddr, npages, locked))
> +		return NULL;
> +
> +	return page;
> +}
> +
> +void *snp_alloc_firmware_page(gfp_t gfp_mask)
> +{
> +	struct page *page;
> +
> +	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
> +
> +	return page ? page_address(page) : NULL;
> +}
> +EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
> +
> +static void __snp_free_firmware_pages(struct page *page, int order, bool locked)a

This @locked too is always false. It becomes true later in

Subject: [PATCH v10 50/50] crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump

which talks about some panic notifier running in atomic context. But
then you can't take locks in atomic context.

Looks like this whole dance around the locked thing needs a cleanup.

...


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

