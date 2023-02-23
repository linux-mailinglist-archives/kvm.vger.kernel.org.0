Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5FB6A039D
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 09:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbjBWIPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 03:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjBWIPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 03:15:45 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDE74D62E;
        Thu, 23 Feb 2023 00:15:03 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id z42so2391758ljq.13;
        Thu, 23 Feb 2023 00:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=433bYYY/TmoUpHBBY/tF9/GMluKPjfLdJmiTSrcvVWQ=;
        b=ktgvXtmjePsRRHA2T3w8lM2xrjXS/08CD5atW+arTYAcRj8dsMzcBKjOLIP5saXWZx
         vMYppLTWw+nrGswXuDS6tugtxeNF9G9TDd3bvsTcgCzQcdHWqKD3aES8A2O76C6tHgcm
         vBeXi6ziB7vO6zOA26AEOu9fPi98odlT/tYmiE2VwQ/feJ8JAeaKO+1V6B8CI4TwR/aM
         0NmuvOYBPLsCifYLfuNIPpbGWgpblX1/72Xk+KuO8WMwkVyEC2iIAQYx6b5LlxHKFOdM
         ne5mpbMdbr+HsuO8kWAIhw2gL6U2pQA11lN2DbL30A+8Mbba0JbRa1QKOP1AvyB4A4fE
         4lpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=433bYYY/TmoUpHBBY/tF9/GMluKPjfLdJmiTSrcvVWQ=;
        b=1G2B1KiqUoWjOw88QwjSbZvt43UBHQg76yjOIUw6xCJ4518GohjfgoaHNgr6DSJ2IJ
         /r8kIgvGq45xDbIiN10CPOFFDhnA7lFzUFqd9oSW2hP7zuYaCSZgm7X8BznJBtO541I0
         PM2Cgv8w6xfinn6rqVfdPs9Vi3AkYcrLL2x6DVdYo3pIFb+mZVmUgXvRyX6/ztuDB2E8
         dFp6jloIE4IGc72vB/+4ZGA38JCr5p2SU/UajFaAN9ExRIltxfb8534uhZkzMwnMKYBN
         URkSlwyla4jp23zfnP/bI/OiTjheMZ1SZrAv+QNNDH3WsF1KQuGAUUofboMr77KiWRxy
         S10A==
X-Gm-Message-State: AO0yUKVJoVnNduvIMarEds4ys5cSsyDAvcvIwzqP/C0qEIdW6ttb+/P8
        t27F5vTaJePQTnhaaW6SHKwUq6abSiI=
X-Google-Smtp-Source: AK7set/Ixb3WSqFMEhxCzQ689X3ZTVmK8ruI8pPEZ7ylGKFiKBp4ONoeUFKy8Fks/gcWB3v04QjpIw==
X-Received: by 2002:a2e:bd06:0:b0:290:6302:8c7e with SMTP id n6-20020a2ebd06000000b0029063028c7emr4290489ljq.3.1677140099620;
        Thu, 23 Feb 2023 00:14:59 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id 10-20020ac2568a000000b004db39e80733sm1244450lfr.155.2023.02.23.00.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 00:14:59 -0800 (PST)
Date:   Thu, 23 Feb 2023 10:14:57 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, nikunj.dadhania@amd.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 28/56] crypto: ccp: Provide APIs to query
 extended attestation report
Message-ID: <20230223101457.000051ae@gmail.com>
In-Reply-To: <8462a7e8-f021-6b55-75b4-5dbdaf013897@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-29-michael.roth@amd.com>
        <20230222222421.00001a62@gmail.com>
        <8462a7e8-f021-6b55-75b4-5dbdaf013897@amd.com>
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

On Wed, 22 Feb 2023 16:35:43 -0600
"Kalra, Ashish" <ashish.kalra@amd.com> wrote:

> On 2/22/2023 2:24 PM, Zhi Wang wrote:
> > On Mon, 20 Feb 2023 12:38:19 -0600
> > Michael Roth <michael.roth@amd.com> wrote:
> > 
> > It seems in the discussion:
> > https://lore.kernel.org/lkml/f18fae8b-a928-cd82-e0b3-eac62ad3e106@amd.com/,
> > this API is going to be removed. Will that fix land in this patch series or not?
> > If not, It would be better to mention it in the comment message of this one
> > or patch 45.
> > If yes, I guess this patch is not needed.
> >   
> 
> This API is definitely not going to be removed.
> 
> There will be some fixes and optimizations added to the API 
> implementation (as per the discussions) and that will be included in v9.
> 

Thanks.

I should use the term "this API is going to be refined" as
snp_guest_ext_guest_request() is going to be renamed and refined. I gave
this comment because when digging this patch, I found this API was going to be
changed in the discussion based on v7 when digging this patch. It would be
really nice to mention it in the v8 so that some review efforts can be saved.
For example, some people might choose to skip reviewing this one in v8 and get
back on it in the next version when it is ready. Or people can also evaluate
the possible changes in v9 when reviewing this part.

> Thanks,
> Ashish
> 
> >> From: Brijesh Singh <brijesh.singh@amd.com>
> >>
> >> Version 2 of the GHCB specification defines VMGEXIT that is used to get
> >> the extended attestation report. The extended attestation report includes
> >> the certificate blobs provided through the SNP_SET_EXT_CONFIG.
> >>
> >> The snp_guest_ext_guest_request() will be used by the hypervisor to get
> >> the extended attestation report. See the GHCB specification for more
> >> details.
> >>
> >> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> >> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >> Signed-off-by: Michael Roth <michael.roth@amd.com>
> >> ---
> >>   drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
> >>   include/linux/psp-sev.h      | 33 +++++++++++++++++++++++++
> >>   2 files changed, 80 insertions(+)
> >>
> >> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> >> index b56b00ca2cd4..e65563bc8298 100644
> >> --- a/drivers/crypto/ccp/sev-dev.c
> >> +++ b/drivers/crypto/ccp/sev-dev.c
> >> @@ -2017,6 +2017,53 @@ int sev_guest_df_flush(int *error)
> >>   }
> >>   EXPORT_SYMBOL_GPL(sev_guest_df_flush);
> >>   
> >> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> >> +				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
> >> +{
> >> +	unsigned long expected_npages;
> >> +	struct sev_device *sev;
> >> +	int rc;
> >> +
> >> +	if (!psp_master || !psp_master->sev_data)
> >> +		return -ENODEV;
> >> +
> >> +	sev = psp_master->sev_data;
> >> +
> >> +	if (!sev->snp_initialized)
> >> +		return -EINVAL;
> >> +
> >> +	mutex_lock(&sev->snp_certs_lock);
> >> +	/*
> >> +	 * Check if there is enough space to copy the certificate chain. Otherwise
> >> +	 * return ERROR code defined in the GHCB specification.
> >> +	 */
> >> +	expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
> >> +	if (*npages < expected_npages) {
> >> +		*npages = expected_npages;
> >> +		*fw_err = SNP_GUEST_REQ_INVALID_LEN;
> >> +		mutex_unlock(&sev->snp_certs_lock);
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)fw_err);
> >> +	if (rc) {
> >> +		mutex_unlock(&sev->snp_certs_lock);
> >> +		return rc;
> >> +	}
> >> +
> >> +	/* Copy the certificate blob */
> >> +	if (sev->snp_certs_data) {
> >> +		*npages = expected_npages;
> >> +		memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);
> >> +	} else {
> >> +		*npages = 0;
> >> +	}
> >> +
> >> +	mutex_unlock(&sev->snp_certs_lock);
> >> +	return rc;
> >> +}
> >> +EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
> >> +
> >>   static void sev_exit(struct kref *ref)
> >>   {
> >>   	misc_deregister(&misc_dev->misc);
> >> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> >> index d19744807471..81bafc049eca 100644
> >> --- a/include/linux/psp-sev.h
> >> +++ b/include/linux/psp-sev.h
> >> @@ -931,6 +931,32 @@ void snp_free_firmware_page(void *addr);
> >>    */
> >>   void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
> >>   
> >> +/**
> >> + * snp_guest_ext_guest_request - perform the SNP extended guest request command
> >> + *  defined in the GHCB specification.
> >> + *
> >> + * @data: the input guest request structure
> >> + * @vaddr: address where the certificate blob need to be copied.
> >> + * @npages: number of pages for the certificate blob.
> >> + *    If the specified page count is less than the certificate blob size, then the
> >> + *    required page count is returned with error code defined in the GHCB spec.
> >> + *    If the specified page count is more than the certificate blob size, then
> >> + *    page count is updated to reflect the amount of valid data copied in the
> >> + *    vaddr.
> >> + *
> >> + * @sev_ret: sev command return code
> >> + *
> >> + * Returns:
> >> + * 0 if the sev successfully processed the command
> >> + * -%ENODEV    if the sev device is not available
> >> + * -%ENOTSUPP  if the sev does not support SEV
> >> + * -%ETIMEDOUT if the sev command timed out
> >> + * -%EIO       if the sev returned a non-zero return code
> >> + */
> >> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> >> +				unsigned long vaddr, unsigned long *npages,
> >> +				unsigned long *error);
> >> +
> >>   #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
> >>   
> >>   static inline int
> >> @@ -968,6 +994,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
> >>   
> >>   static inline void snp_free_firmware_page(void *addr) { }
> >>   
> >> +static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> >> +					      unsigned long vaddr, unsigned long *n,
> >> +					      unsigned long *error)
> >> +{
> >> +	return -ENODEV;
> >> +}
> >> +
> >>   #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
> >>   
> >>   #endif	/* __PSP_SEV_H__ */  
> >   

