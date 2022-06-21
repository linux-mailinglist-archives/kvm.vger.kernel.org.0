Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9FD553E80
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 00:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353601AbiFUWar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 18:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiFUWap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 18:30:45 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4435831524
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:30:44 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id a29so24740020lfk.2
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=be4KTBeZxtpbZf3YZP05Js8VaqFOMrf83r+bDTDFiOM=;
        b=TbHQbtE0PGZvjMfU0/fdCKW8kn0RfxMLcQkuL7vMebVX3ouG4SBKD8sC2tkjx1p4tL
         JxLcXHa+y4RxHDPxAebJuKeKGscJoUKjrE8VXTvglAp1x/G4b03ih1fW6yNXCTiMQAPw
         teAuWEmSVhc73eNHdbcV4Cw5YrPPKwRNTZrJn8Pi8wlXst7by6Z/L8eV9UBD3t3RBMx4
         6tPWew7RqfGH09r381WEW8Hp903+By355KdF31SA7pdi4YDiewE/7uhPhZfmYqySyvZp
         6jI1juXcpFpqrIIQaJi/mwPudugxTKnpFg9ho/joL50I2hmuYTg9jX/3uWx6noKgzt2W
         Yh6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=be4KTBeZxtpbZf3YZP05Js8VaqFOMrf83r+bDTDFiOM=;
        b=j8+cpViSa5W/UEezSsJdroNH+TLcD+Tv9Cj7e/hZsPLvRMcYyraKEpvm5DzIiCTPGE
         4acP3CG60FAV6+dWSb/ALPn61Lrtaeiw7grb/cUlRU6u8/fYSs6X29Em9NlJRkq4nags
         z2y9e+8elWgLKYqB+Ta5IsNbG9NkC6QAyfYuGk1oGs8BN4svTrhJgWKddYkp6PyxxFQi
         jTS1PKgcB+XBYeLe6yozn+ieI4riDHJ0MyG0PG3IDkih06Qrj0Dg7xVdo5JbQk+8YAXy
         zGEsw+FqNQCBwTduEIFF0xKR5vRuB/ZSik9ulsHoxcF4p6oqGHm8dVfIydRVzyp4LABV
         UPqw==
X-Gm-Message-State: AJIora9tUDzRUlqXm2cWcVUR2qOQvXZpGCEsQEcGQvZ275T666XkB2WR
        6aUphaXNBmSui/3Rvjj1p3P1yelh69sRPWt/mA/KuA==
X-Google-Smtp-Source: AGRyM1tNImbx2kxK7HvpjgFsrzYuq9fWYBmKlPeBU+D7of5gQReoy2FIhun71/isgSXq7ZOimBGSU35RGWxiIk/cWOU=
X-Received: by 2002:a05:6512:3085:b0:479:3986:1d23 with SMTP id
 z5-20020a056512308500b0047939861d23mr274153lfd.373.1655850642319; Tue, 21 Jun
 2022 15:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <afae5980fd4adf52932a9d639a0b0bfe83255c0a.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <afae5980fd4adf52932a9d639a0b0bfe83255c0a.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 21 Jun 2022 16:30:30 -0600
Message-ID: <CAMkAt6pn4FmJchYP9ac3q_Zcrnupgs9Qu-fMe6axXzW_YE283Q@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 18/49] crypto: ccp: Provide APIs to query
 extended attestation report
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 5:06 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Version 2 of the GHCB specification defines VMGEXIT that is used to get
> the extended attestation report. The extended attestation report includes
> the certificate blobs provided through the SNP_SET_EXT_CONFIG.
>
> The snp_guest_ext_guest_request() will be used by the hypervisor to get
> the extended attestation report. See the GHCB specification for more
> details.
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
> +                               unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
> +{
> +       unsigned long expected_npages;
> +       struct sev_device *sev;
> +       int rc;
> +
> +       if (!psp_master || !psp_master->sev_data)
> +               return -ENODEV;
> +
> +       sev = psp_master->sev_data;
> +
> +       if (!sev->snp_inited)
> +               return -EINVAL;
> +
> +       /*
> +        * Check if there is enough space to copy the certificate chain. Otherwise
> +        * return ERROR code defined in the GHCB specification.
> +        */
> +       expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
> +       if (*npages < expected_npages) {
> +               *npages = expected_npages;
> +               *fw_err = SNP_GUEST_REQ_INVALID_LEN;
> +               return -EINVAL;
> +       }
> +
> +       rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)&fw_err);

We can just pass |fw_error| here (with the cast) here right? Not need
to do &fw_err.

      rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)fw_err);

> +       if (rc)
> +               return rc;
> +
> +       /* Copy the certificate blob */
> +       if (sev->snp_certs_data) {
> +               *npages = expected_npages;
> +               memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);

Why don't we just make |vaddr| into a void* instead of an unsigned long?

> +       } else {
> +               *npages = 0;
> +       }
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
> +
>  static void sev_exit(struct kref *ref)
>  {
>         misc_deregister(&misc_dev->misc);
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
> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +                               unsigned long vaddr, unsigned long *npages,
> +                               unsigned long *error);
> +
>  #else  /* !CONFIG_CRYPTO_DEV_SP_PSP */
>
>  static inline int
> @@ -992,6 +1009,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
>
>  static inline void snp_free_firmware_page(void *addr) { }
>
> +static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> +                                             unsigned long vaddr, unsigned long *n,
> +                                             unsigned long *error)
> +{
> +       return -ENODEV;
> +}
> +
>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>
>  #endif /* __PSP_SEV_H__ */
> --
> 2.25.1
>
