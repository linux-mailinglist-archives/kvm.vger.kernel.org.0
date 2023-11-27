Return-Path: <kvm+bounces-2506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B747F9D04
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 11:00:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2905B1C20CBB
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 10:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74633179AF;
	Mon, 27 Nov 2023 10:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="M6Rt7dYW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D898183;
	Mon, 27 Nov 2023 02:00:31 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7ECCC40E0257;
	Mon, 27 Nov 2023 10:00:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BU3zEmMa-BjB; Mon, 27 Nov 2023 10:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701079225; bh=TtlE36AUctgokR2LY9a4CvYQHcd567Ym1wq8sq+2ihM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M6Rt7dYWHGuYYMKKnLHdE+bsGHF4qtcXP+fynrgyym9GNI2DisXZC/Im1xT+/o7ky
	 vPEWJVl69HWMWMtsPt4j7/Maw8VNJUX8xA6vTrjjh0hu6NjyPY74CNk2vOpPKAaRyr
	 eKUaIRfaJ671zR1EZ7+EIHom+tYw3QpojOHy0Tvbnf9OWdz6YrRppAv4btNQ24JKAG
	 ys+2POPXC2GIhcNbDyLmCPlW6bnhZhwmOOnOpKQpYBLmD56/gdjCoiQTQwJzW3rLW3
	 BRjzUP2icnTuEN5XYI8+sryVJjw7KRTSqb+xDKhQBEOoJGxr/8ICUdFYK44slWI85j
	 N3EYYhf8P/f2EDo95DHJ6iqXaRp2fyo0hoWARYy3s4mWnma41/nz2SFsWL+A5jZUN9
	 kyIn1B88ZjyJH2l/W+Zt7XuJSDsWLa/k1N0P6zaD5b5BL/sH6lknLw63swIpXLtpXQ
	 Sz+5D1rUWLIt7lNSiTx7krZmSV1RpOoP+4mguMQpVuHkXfcZEXI2TlxQFnrkIvz3nB
	 rxu5dSBq25HD2LP5DOJdprHsyRqw3/r/B7X90yhqMyBRamWw7ZI4piTMVxxuOSsgPp
	 Y5ZJgsTZuvZe4I2q3oZTtxYmyPqgHgvKlyVaDctG5MbOoTTQlisZcOge/khZj1o1Jp
	 F4+/JjWMsZQKD/FINdCPRVsQ=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 00F5940E014B;
	Mon, 27 Nov 2023 09:59:43 +0000 (UTC)
Date: Mon, 27 Nov 2023 10:59:37 +0100
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
	Brijesh Singh <brijesh.singh@amd.com>,
	Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v10 14/50] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Message-ID: <20231127095937.GLZWRoiaqGlJMX54Xb@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-15-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231016132819.1002933-15-michael.roth@amd.com>

On Mon, Oct 16, 2023 at 08:27:43AM -0500, Michael Roth wrote:
> +/*
> + * SEV_DATA_RANGE_LIST:
> + *   Array containing range of pages that firmware transitions to HV-fixed
> + *   page state.
> + */
> +struct sev_data_range_list *snp_range_list;
> +static int __sev_snp_init_locked(int *error);

Put the function above the caller instead of doing a forward
declaration.

>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -466,9 +479,9 @@ static inline int __sev_do_init_locked(int *psp_ret)
>  		return __sev_init_locked(psp_ret);
>  }
>  
> -static int __sev_platform_init_locked(int *error)
> +static int ___sev_platform_init_locked(int *error, bool probe)
>  {
> -	int rc = 0, psp_ret = SEV_RET_NO_FW_CALL;
> +	int rc, psp_ret = SEV_RET_NO_FW_CALL;
>  	struct psp_device *psp = psp_master;
>  	struct sev_device *sev;
>  
> @@ -480,6 +493,34 @@ static int __sev_platform_init_locked(int *error)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> +	/*
> +	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
> +	 * so perform SEV-SNP initialization at probe time.
> +	 */
> +	rc = __sev_snp_init_locked(error);
> +	if (rc && rc != -ENODEV) {
> +		/*
> +		 * Don't abort the probe if SNP INIT failed,
> +		 * continue to initialize the legacy SEV firmware.
> +		 */
> +		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n", rc, *error);
> +	}
> +
> +	/* Delay SEV/SEV-ES support initialization */
> +	if (probe && !psp_init_on_probe)
> +		return 0;
> +
> +	if (!sev_es_tmr) {
> +		/* Obtain the TMR memory area for SEV-ES use */
> +		sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
> +		if (sev_es_tmr)
> +			/* Must flush the cache before giving it to the firmware */
> +			clflush_cache_range(sev_es_tmr, SEV_ES_TMR_SIZE);
> +		else
> +			dev_warn(sev->dev,
> +				 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> +		}
> +
>  	if (sev_init_ex_buffer) {
>  		rc = sev_read_init_ex_file();
>  		if (rc)
> @@ -522,6 +563,11 @@ static int __sev_platform_init_locked(int *error)
>  	return 0;
>  }
>  
> +static int __sev_platform_init_locked(int *error)
> +{
> +	return ___sev_platform_init_locked(error, false);
> +}

Uff, this is silly. And it makes the code hard to follow and that meat
of the platform init functionality in the ___-prefixed function a mess.

And the problem is that that "probe" functionality is replicated from
the one place where it is actually needed - sev_pci_init() which calls
that new sev_platform_init_on_probe() function - to everything that
calls __sev_platform_init_locked() for which you've added a wrapper.

What you should do, instead, is split the code around
__sev_snp_init_locked() in a separate function which does only that and
is called something like __sev_platform_init_snp_locked() or so which
does that unconditional work. And then you define:

_sev_platform_init_locked(int *error, bool probe)

note the *one* '_' - i.e., first layer:

_sev_platform_init_locked(int *error, bool probe):
{
	__sev_platform_init_snp_locked(error);

	if (!probe)
		return 0;

	if (psp_init_on_probe)
		__sev_platform_init_locked(error);

	...
}

and you do the probing in that function only so that it doesn't get lost
in the bunch of things __sev_platform_init_locked() does.

And then you call _sev_platform_init_locked() everywhere and no need for
a second sev_platform_init_on_probe().

> +
>  int sev_platform_init(int *error)
>  {
>  	int rc;
> @@ -534,6 +580,17 @@ int sev_platform_init(int *error)
>  }
>  EXPORT_SYMBOL_GPL(sev_platform_init);
>  
> +static int sev_platform_init_on_probe(int *error)
> +{
> +	int rc;
> +
> +	mutex_lock(&sev_cmd_mutex);
> +	rc = ___sev_platform_init_locked(error, true);
> +	mutex_unlock(&sev_cmd_mutex);
> +
> +	return rc;
> +}
> +
>  static int __sev_platform_shutdown_locked(int *error)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -838,6 +895,191 @@ static int sev_update_firmware(struct device *dev)
>  	return ret;
>  }
>  
> +static void snp_set_hsave_pa(void *arg)
> +{
> +	wrmsrl(MSR_VM_HSAVE_PA, 0);
> +}
> +
> +static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
> +{
> +	struct sev_data_range_list *range_list = arg;
> +	struct sev_data_range *range = &range_list->ranges[range_list->num_elements];
> +	size_t size;
> +
> +	if ((range_list->num_elements * sizeof(struct sev_data_range) +
> +	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
> +		return -E2BIG;

Why? A comment would be helpful like with the rest this patch adds.

> +	switch (rs->desc) {
> +	case E820_TYPE_RESERVED:
> +	case E820_TYPE_PMEM:
> +	case E820_TYPE_ACPI:
> +		range->base = rs->start & PAGE_MASK;
> +		size = (rs->end + 1) - rs->start;
> +		range->page_count = size >> PAGE_SHIFT;
> +		range_list->num_elements++;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __sev_snp_init_locked(int *error)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_data_snp_init_ex data;
> +	struct sev_device *sev;
> +	int rc = 0;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENODEV;
> +
> +	if (!psp || !psp->sev_data)
> +		return -ENODEV;

Only caller checks this already.

> +	sev = psp->sev_data;
> +
> +	if (sev->snp_initialized)

Do we really need this silly boolean or is there a way to query the
platform whether SNP has been initialized?

> +		return 0;
> +
> +	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
> +		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
> +			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
> +		return 0;
> +	}
> +
> +	/*
> +	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
> +	 * across all cores.
> +	 */
> +	on_each_cpu(snp_set_hsave_pa, NULL, 1);
> +
> +	/*
> +	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list of
> +	 * system physical address ranges to convert into the HV-fixed page states
> +	 * during the RMP initialization.  For instance, the memory that UEFI
> +	 * reserves should be included in the range list. This allows system
> +	 * components that occasionally write to memory (e.g. logging to UEFI
> +	 * reserved regions) to not fail due to RMP initialization and SNP enablement.
> +	 */
> +	if (sev_version_greater_or_equal(SNP_MIN_API_MAJOR, 52)) {

Is there a generic way to probe SNP_INIT_EX presence in the firmware or
are FW version numbers the only way?

> +		/*
> +		 * Firmware checks that the pages containing the ranges enumerated
> +		 * in the RANGES structure are either in the Default page state or in the

"default"

> +		 * firmware page state.
> +		 */
> +		snp_range_list = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +		if (!snp_range_list) {
> +			dev_err(sev->dev,
> +				"SEV: SNP_INIT_EX range list memory allocation failed\n");
> +			return -ENOMEM;
> +		}
> +
> +		/*
> +		 * Retrieve all reserved memory regions setup by UEFI from the e820 memory map
> +		 * to be setup as HV-fixed pages.
> +		 */
> +


^ Superfluous newline.

> +		rc = walk_iomem_res_desc(IORES_DESC_NONE, IORESOURCE_MEM, 0, ~0,
> +					 snp_range_list, snp_filter_reserved_mem_regions);
> +		if (rc) {
> +			dev_err(sev->dev,
> +				"SEV: SNP_INIT_EX walk_iomem_res_desc failed rc = %d\n", rc);
> +			return rc;
> +		}
> +
> +		memset(&data, 0, sizeof(data));
> +		data.init_rmp = 1;
> +		data.list_paddr_en = 1;
> +		data.list_paddr = __psp_pa(snp_range_list);
> +
> +		/*
> +		 * Before invoking SNP_INIT_EX with INIT_RMP=1, make sure that
> +		 * all dirty cache lines containing the RMP are flushed.
> +		 *
> +		 * NOTE: that includes writes via RMPUPDATE instructions, which
> +		 * are also cacheable writes.
> +		 */
> +		wbinvd_on_all_cpus();
> +
> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT_EX, &data, error);
> +		if (rc)
> +			return rc;
> +	} else {
> +		/*
> +		 * SNP_INIT is equivalent to SNP_INIT_EX with INIT_RMP=1, so
> +		 * just as with that case, make sure all dirty cache lines
> +		 * containing the RMP are flushed.
> +		 */
> +		wbinvd_on_all_cpus();
> +
> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
> +		if (rc)
> +			return rc;
> +	}

So instead of duplicating the code here at the end of the if-else
branching, you can do:

	void *arg = &data;

	if () {
		...
		cmd = SEV_CMD_SNP_INIT_EX;
	} else {
		cmd = SEV_CMD_SNP_INIT;
		arg = NULL;
	}

	wbinvd_on_all_cpus();
	rc = __sev_do_cmd_locked(cmd, arg, error);
	if (rc)
		return rc;

> +	/* Prepare for first SNP guest launch after INIT */
> +	wbinvd_on_all_cpus();

Why is that WBINVD needed?

> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> +	if (rc)
> +		return rc;
> +
> +	sev->snp_initialized = true;
> +	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
> +
> +	return rc;
> +}
> +
> +static int __sev_snp_shutdown_locked(int *error)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_data_snp_shutdown_ex data;
> +	int ret;
> +
> +	if (!sev->snp_initialized)
> +		return 0;
> +
> +	memset(&data, 0, sizeof(data));
> +	data.length = sizeof(data);
> +	data.iommu_snp_shutdown = 1;
> +
> +	wbinvd_on_all_cpus();
> +
> +retry:
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
> +	/* SHUTDOWN may require DF_FLUSH */
> +	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
> +		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
> +		if (ret) {
> +			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed\n");
> +			return ret;

When you return here,  sev->snp_initialized is still true but, in
reality, it probably is in some half-broken state after issuing those
commands you it is not really initialized anymore.

> +		}
> +		goto retry;

This needs an upper limit from which to break out and not potentially
endless-loop.

> +	}
> +	if (ret) {
> +		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
> +		return ret;
> +	}
> +
> +	sev->snp_initialized = false;
> +	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
> +
> +	return ret;
> +}
> +
> +static int sev_snp_shutdown(int *error)
> +{
> +	int rc;
> +
> +	mutex_lock(&sev_cmd_mutex);
> +	rc = __sev_snp_shutdown_locked(error);

Why is this "locked" version even there if it is called only here?

IOW, put all the logic in here - no need for
__sev_snp_shutdown_locked().

> +	mutex_unlock(&sev_cmd_mutex);
> +
> +	return rc;
> +}

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

