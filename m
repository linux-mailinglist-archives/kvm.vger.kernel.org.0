Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0506D69DCED
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 10:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjBUJ2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 04:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjBUJ23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 04:28:29 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CE8B443;
        Tue, 21 Feb 2023 01:28:27 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id y44so3760293ljq.7;
        Tue, 21 Feb 2023 01:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cMvEWx93T+DKuH/EfNzVMzxjU3ZfkiKTGej0rtS7XU=;
        b=h/MKpwswKXFMPyFd7oBDdGwT1y9EKS9WAjFXU+U9BdYQN554vMrvq7yaIJ2bISdl5q
         68rK/XqSK0ZTzubookOAKlQiRkh/Qb+Y8NhBvjuVdNePw8caYBX8chcYUBHO+Txivp94
         styxcRkySeYlHXAer1Fcb1AVJGRFD8XAwBVbdMhmVttT+M1PksmkX6OnEr+7/MJxcciD
         sdGiFEPtgOoRpI9UQnVRKTdt7WL8TCV/H0zeJTdw3HvdESLUNxvHPOInJrwl6qHi9tcH
         Ks92c0JaxDH8N94zNzsfA/+AuA3X+OhIFaa51UecB9hENAWk21HAG3e29iK6ok7jWNio
         Fi+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7cMvEWx93T+DKuH/EfNzVMzxjU3ZfkiKTGej0rtS7XU=;
        b=7xW7yq8zHv0lAC78SI0VDzfbXrZNO+AaJi4vhiewGaTRwasK9fVmj9pKkFgUH1e5Ka
         ONWEZM5I6aQmzAMj3af1mCOYZhZGQ6vQCTDRH4fFAAvvmOOn3jauomDsNFU0Gq3ijfbL
         izIhmeDFGtim28Q0QIoXf25uWlUpqIz0hqQPEGpa716coCCTCyEkHzj7IAhXJyHoCfer
         ZMNs0toS7lNoIYb0ogR0BFD0wxbpuds89d0BZJcldxGyMRKFZUymBl4nWQbBHbpZTDJD
         ReraNKJhM1vRtmsSXsYU/LYCS5zWPow6DA0mwfY60/jQJUawKPMexKbbuJPTHHlbDrmT
         MDGg==
X-Gm-Message-State: AO0yUKVfLVTVluJ/9WXIH01Nn4TbS8bPLkRLgWlzgUSDgPSj2DVetw5o
        jI9gv0A4hNDsnLokq0g30ZA=
X-Google-Smtp-Source: AK7set84dqJj7wcs9uzj2n8kT//QPqBDPmWF+AwkpmwrrrE3ZAh41j4XgidURaSXeFVF8sErCcmqqw==
X-Received: by 2002:a05:651c:897:b0:295:90b2:da6b with SMTP id d23-20020a05651c089700b0029590b2da6bmr206314ljq.0.1676971705705;
        Tue, 21 Feb 2023 01:28:25 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id o16-20020a2e9b50000000b002958bb2deacsm123022ljj.46.2023.02.21.01.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 01:28:25 -0800 (PST)
Date:   Tue, 21 Feb 2023 11:28:23 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 24/56] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <20230221112823.000063e4@gmail.com>
In-Reply-To: <20230220183847.59159-25-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-25-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023 12:38:15 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The behavior and requirement for the SEV-legacy command is altered when
> the SNP firmware is in the INIT state. See SEV-SNP firmware specification
> for more details.
> 
> Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
> when SNP is enabled to satisfy new requirements for the SNP. Continue
> allocating a 1mb region for !SNP configuration.
> 
> While at it, provide API that can be used by others to allocate a page
> that can be used by the firmware. The immediate user for this API will
> be the KVM driver. The KVM driver to need to allocate a firmware context
> page during the guest creation. The context page need to be updated
> by the firmware. See the SEV-SNP specification for further details.
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 148 +++++++++++++++++++++++++++++++++--
>  include/linux/psp-sev.h      |   9 +++
>  2 files changed, 149 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index eca4e59b0f44..4c12e98a1219 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -94,6 +94,13 @@ static void *sev_init_ex_buffer;
>   */
>  struct sev_data_range_list *snp_range_list;
>  
> +/* When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB size. */
> +#define SEV_SNP_ES_TMR_SIZE	(2 * 1024 * 1024)

It would be better to re-use the kernel size definition macros. E.g. SZ_2MB.

> +
> +static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
> +
> +static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -216,11 +223,134 @@ void snp_mark_pages_offline(unsigned long pfn, unsigned int npages)
>  }
>  EXPORT_SYMBOL_GPL(snp_mark_pages_offline);
>  
> +static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
> +{
> +	/* Cbit maybe set in the paddr */

This is confusing.

I suppose C-bit is treated as a attribute of PTE in the kernel not part of the
PA. It means only a PTE might carry a C-bit. 

The paddr is from __pa(page_address()). It is not extracted from a PTE. Thus, the
return from them should never have a C-bit.

BTW: Wouldn't it be better to have pfn as input param instead of paddr?

The caller has struct page, calling snp_reclaim_pages(page_to_pfn(page), xxxxx)
would be much clearer than the current conversion:
page_address() (struct page is converted to VA), __pa() (VA is converted to PA)
in the caller and then PA is converted to pfn here.

> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
> +	int ret, err, i, n = 0;
> +

should be unsigned int i, n; as the input param npage is unsigned int.

> +	if (!pfn_valid(pfn)) {
> +		pr_err("%s: Invalid PFN %lx\n", __func__, pfn);
> +		return 0;
> +	}
> +
> +	for (i = 0; i < npages; i++, pfn++, n++) {
> +		paddr = pfn << PAGE_SHIFT;
> +
> +		if (locked)
> +			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
> +		else
> +			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
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
> +	 */
> +	snp_mark_pages_offline(pfn, npages - n);
> +	return ret;
> +}
> +
> +static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, bool locked)

The same comment as above. Better take pfn or page instead of paddr with
redundant conversions.

> +{
> +	/* Cbit maybe set in the paddr */
> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
> +	int rc, n = 0, i;
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
> +static void __snp_free_firmware_pages(struct page *page, int order, bool locked)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	unsigned long paddr, npages = 1ul << order;
> +
> +	if (!page)
> +		return;
> +
> +	paddr = __pa((unsigned long)page_address(page));
> +	if (sev->snp_initialized &&
> +	    snp_reclaim_pages(paddr, npages, locked))
> +		return;
> +
> +	__free_pages(page, order);
> +}
> +
> +void snp_free_firmware_page(void *addr)
> +{
> +	if (!addr)
> +		return;
> +
> +	__snp_free_firmware_pages(virt_to_page(addr), 0, false);
> +}
> +EXPORT_SYMBOL_GPL(snp_free_firmware_page);
> +
>  static void *sev_fw_alloc(unsigned long len)
>  {
>  	struct page *page;
>  
> -	page = alloc_pages(GFP_KERNEL, get_order(len));
> +	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), false);
>  	if (!page)
>  		return NULL;
>  
> @@ -468,7 +598,7 @@ static int __sev_init_locked(int *error)
>  		data.tmr_address = __pa(sev_es_tmr);
>  
>  		data.flags |= SEV_INIT_FLAGS_SEV_ES;
> -		data.tmr_len = SEV_ES_TMR_SIZE;
> +		data.tmr_len = sev_es_tmr_size;
>  	}
>  
>  	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> @@ -491,7 +621,7 @@ static int __sev_init_ex_locked(int *error)
>  		data.tmr_address = __pa(sev_es_tmr);
>  
>  		data.flags |= SEV_INIT_FLAGS_SEV_ES;
> -		data.tmr_len = SEV_ES_TMR_SIZE;
> +		data.tmr_len = sev_es_tmr_size;
>  	}
>  
>  	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
> @@ -982,6 +1112,8 @@ static int __sev_snp_init_locked(int *error)
>  	sev->snp_initialized = true;
>  	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>  
> +	sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
> +
>  	return rc;
>  }
>  
> @@ -1499,8 +1631,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>  		/* The TMR area was encrypted, flush it from the cache */
>  		wbinvd_on_all_cpus();
>  
> -		free_pages((unsigned long)sev_es_tmr,
> -			   get_order(SEV_ES_TMR_SIZE));
> +		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
> +					  get_order(sev_es_tmr_size),
> +					  false);
>  		sev_es_tmr = NULL;
>  	}
>  
> @@ -1511,8 +1644,7 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>  	}
>  
>  	if (snp_range_list) {
> -		free_pages((unsigned long)snp_range_list,
> -			   get_order(PAGE_SIZE));
> +		snp_free_firmware_page(snp_range_list);
>  		snp_range_list = NULL;
>  	}
>  
> @@ -1593,7 +1725,7 @@ void sev_pci_init(void)
>  	}
>  
>  	/* Obtain the TMR memory area for SEV-ES use */
> -	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
> +	sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
>  	if (!sev_es_tmr)
>  		dev_warn(sev->dev,
>  			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 8edf5c548fbf..d19744807471 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -922,6 +922,8 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>  int sev_do_cmd(int cmd, void *data, int *psp_ret);
>  
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
> +void *snp_alloc_firmware_page(gfp_t mask);
> +void snp_free_firmware_page(void *addr);
>  
>  /**
>   * sev_mark_pages_offline - insert non-reclaimed firmware/guest pages
> @@ -959,6 +961,13 @@ static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_P
>  
>  void snp_mark_pages_offline(unsigned long pfn, unsigned int npages) {}
>  
> +static inline void *snp_alloc_firmware_page(gfp_t mask)
> +{
> +	return NULL;
> +}
> +
> +static inline void snp_free_firmware_page(void *addr) { }
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */

