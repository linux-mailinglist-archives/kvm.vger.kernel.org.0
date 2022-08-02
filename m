Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A54587C8C
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 14:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbiHBMkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 08:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236172AbiHBMj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 08:39:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862C42251C;
        Tue,  2 Aug 2022 05:39:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A4D5612CB;
        Tue,  2 Aug 2022 12:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5BDC433D6;
        Tue,  2 Aug 2022 12:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659443997;
        bh=PCR0ioV6fNZP3YUrBL59/cNasicX5SaYXfiF0EyEclg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NQqr3uk+c9m8SmN+EpeKHs99sSRP5o4d6itRIx1sQ9JIx0GuQN0Zh7stPoohY+zo0
         3PF69OpEy4klTKYs0DWgkN8uzyVg15Z9jCPwtINZX9ljfqMcBTxrDFYGNrdKAScBmu
         b9Yjfa66tjoqT6Ride43cu6yx0fVXlu9PZ6h8G5RKm8rF0jQKJ9cBKG6cKWXaIL7IW
         crcs5ni4zlwinZuKU/9i42bKlDq/67Ii6Era/B43XFJaMgwTdr50bjUPoljnk0YpaA
         J+OGdQHe36jFoy30fIx8dy3et4mHaQxnD+88QDJTxg27K2vokVRduOlR5UONFbgpx7
         1tk4aP1uvMa3Q==
Date:   Tue, 2 Aug 2022 15:39:54 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com
Subject: Re: [PATCH Part2 v6 18/49] crypto: ccp: Provide APIs to query
 extended attestation report
Message-ID: <YukbGl5aZMK1PWRF@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <afae5980fd4adf52932a9d639a0b0bfe83255c0a.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afae5980fd4adf52932a9d639a0b0bfe83255c0a.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'd rephrase "Provide in-kernel API..." (e.g. not uapi).

On Mon, Jun 20, 2022 at 11:06:06PM +0000, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Version 2 of the GHCB specification defines VMGEXIT that is used to get
> the extended attestation report. The extended attestation report includes
> the certificate blobs provided through the SNP_SET_EXT_CONFIG.
> 
> The snp_guest_ext_guest_request() will be used by the hypervisor to get
> the extended attestation report. See the GHCB specification for more
> details.

What is "the hypersivor"? Could it be replaced with e.g. KVM for
clarity?

> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 43 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 24 ++++++++++++++++++++
>  2 files changed, 67 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 97b479d5aa86..f6306b820b86 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -25,6 +25,7 @@
>  #include <linux/fs.h>
>  
>  #include <asm/smp.h>
> +#include <asm/sev.h>
>  
>  #include "psp-dev.h"
>  #include "sev-dev.h"
> @@ -1857,6 +1858,48 @@ int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
>  }
>  EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
>  
> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
> +{
> +	unsigned long expected_npages;
> +	struct sev_device *sev;
> +	int rc;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return -ENODEV;
> +
> +	sev = psp_master->sev_data;
> +
> +	if (!sev->snp_inited)
> +		return -EINVAL;
> +
> +	/*
> +	 * Check if there is enough space to copy the certificate chain. Otherwise
> +	 * return ERROR code defined in the GHCB specification.
> +	 */
> +	expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
> +	if (*npages < expected_npages) {
> +		*npages = expected_npages;
> +		*fw_err = SNP_GUEST_REQ_INVALID_LEN;
> +		return -EINVAL;
> +	}
> +
> +	rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)&fw_err);
> +	if (rc)
> +		return rc;
> +
> +	/* Copy the certificate blob */
> +	if (sev->snp_certs_data) {
> +		*npages = expected_npages;
> +		memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);
> +	} else {
> +		*npages = 0;
> +	}
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);

Undocumented export.

> +
>  static void sev_exit(struct kref *ref)
>  {
>  	misc_deregister(&misc_dev->misc);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index a3bb792bb842..cd37ccd1fa1f 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -945,6 +945,23 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>  
> +/**
> + * snp_guest_ext_guest_request - perform the SNP extended guest request command
> + *  defined in the GHCB specification.
> + *
> + * @data: the input guest request structure
> + * @vaddr: address where the certificate blob need to be copied.
> + * @npages: number of pages for the certificate blob.
> + *    If the specified page count is less than the certificate blob size, then the
> + *    required page count is returned with error code defined in the GHCB spec.
> + *    If the specified page count is more than the certificate blob size, then
> + *    page count is updated to reflect the amount of valid data copied in the
> + *    vaddr.
> + */

This kdoc is misplaced: it should be in sev-dev.c, right before the
implementation. Also it does not say anything about return value, and
still the return type is "int".

> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +				unsigned long vaddr, unsigned long *npages,
> +				unsigned long *error);
> +
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  static inline int
> @@ -992,6 +1009,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
>  
>  static inline void snp_free_firmware_page(void *addr) { }
>  
> +static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +					      unsigned long vaddr, unsigned long *n,
> +					      unsigned long *error)
> +{
> +	return -ENODEV;
> +}
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */
> -- 
> 2.25.1
> 

BR, Jarkko
