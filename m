Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348E6553E5F
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 00:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiFUWN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 18:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiFUWNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 18:13:38 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C383A30F63
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:13:36 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a13so14798149lfr.10
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FhT6OgEtSRMHYL/iMsKO81waTMS99DUORODlB8eMUM8=;
        b=a7hoFAhgQmpKSok/Lhi54i4SFrBkg28yrGhZvbu5aYam+yowAkMrXoahazNTU2k2Up
         TXmLEe5TeVQ3YZxcvE/4fpKCLU7CpV6rwYS0EPHxp0gsSJmx/zfSZrwHiM0ExWf27/a3
         tmPrrDXnR3tSW+DPFtzWDEIdPYLa1yH5n+Lv/SEVTDJXRpJ7dqsP4Y/br0cURQsxWx+D
         tz2KHFJsYXNc1xSxHdbAVJ2i4LXyEllM/BFHxTvjyAc2f25ZGyFyRFwsiTgfTlbnKICs
         KrRb9HI2BL2mcHkcYgVklHZWmMMYkoW+ZrYVxnle/SG3fJuYDf6VOS6jB3DrV8WwcSzV
         ep3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FhT6OgEtSRMHYL/iMsKO81waTMS99DUORODlB8eMUM8=;
        b=sWny8ImttBIxjo+YZ2WCSJW7wz0nnizMXJEB0PJM/Uhs0gRHO5mNiUN2FFYE2S98A1
         /mxZR/M3mfkubYJvZS+qgnSpEot2I7I5slKz7U/hQeuA/eZO09NlV564Orh0sjvKkdY4
         M90nVIat/TV6TbzsjgEfMP/cwOwtsvhIN3m9bVTRl3zx1QjEHQdFup3A+ZiWnItFvNlA
         EWXwqdq2b2mobwM1/SfUR7CWUIINYstIIh/nD4lSmV/TsNUbvx5XDuTsH3X7bhXXVce5
         9MxjSMPTm2lmWPLPsne99zugfgr9rZ7IZXiFG+5KI4vjLMRwGKcpc/gFD1frsS6eeQmM
         VWWg==
X-Gm-Message-State: AJIora9Prq3IE9x71dZ3YrpazmBJ0qFf4TlD4ITbLG3VBOCOD41PW1/P
        A3hKfGgyK2Jm79UvPbbXjFutkcI+bqJNypelDEdOPg==
X-Google-Smtp-Source: AGRyM1vZzONrGhIdryRXMBvMBWgyMydFB/KNCIogQq5HGQtB2z3xPzoZumHyfUXbMaC9I0J80N3eYKZKpITx63fF3Ik=
X-Received: by 2002:a05:6512:a94:b0:47f:6621:cf2a with SMTP id
 m20-20020a0565120a9400b0047f6621cf2amr250041lfu.193.1655849614508; Tue, 21
 Jun 2022 15:13:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <d325cb5d7961f015400999dda7ee8e08e4ca2ec6.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <d325cb5d7961f015400999dda7ee8e08e4ca2ec6.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 21 Jun 2022 16:13:22 -0600
Message-ID: <CAMkAt6okrB57pwWu1RCRA1BqTzosD52KFHn7XD6DoJNFo1N72A@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 17/49] crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG
 command
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 5:06 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The SEV-SNP firmware provides the SNP_CONFIG command used to set the
> system-wide configuration value for SNP guests. The information includes
> the TCB version string to be reported in guest attestation reports.
>
> Version 2 of the GHCB specification adds an NAE (SNP extended guest
> request) that a guest can use to query the reports that include additional
> certificates.
>
> In both cases, userspace provided additional data is included in the
> attestation reports. The userspace will use the SNP_SET_EXT_CONFIG
> command to give the certificate blob and the reported TCB version string
> at once. Note that the specification defines certificate blob with a
> specific GUID format; the userspace is responsible for building the
> proper certificate blob. The ioctl treats it an opaque blob.
>
> While it is not defined in the spec, but let's add SNP_GET_EXT_CONFIG
> command that can be used to obtain the data programmed through the
> SNP_SET_EXT_CONFIG.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  Documentation/virt/coco/sevguest.rst |  27 +++++++
>  drivers/crypto/ccp/sev-dev.c         | 115 +++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h         |   3 +
>  include/uapi/linux/psp-sev.h         |  17 ++++
>  4 files changed, 162 insertions(+)
>
> diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
> index 11ea67c944df..3014de47e4ce 100644
> --- a/Documentation/virt/coco/sevguest.rst
> +++ b/Documentation/virt/coco/sevguest.rst
> @@ -145,6 +145,33 @@ The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
>  status includes API major, minor version and more. See the SEV-SNP
>  specification for further details.
>
> +2.5 SNP_SET_EXT_CONFIG
> +----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_ext_config
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
> +reported TCB version in the attestation report. The command is similar to
> +SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
> +command also accepts an additional certificate blob defined in the GHCB
> +specification.
> +
> +If the certs_address is zero, then previous certificate blob will deleted.

... then the previous certificate blob will be deleted.

> +For more information on the certificate blob layout, see the GHCB spec
> +(extended guest request message).
> +
> +2.6 SNP_GET_EXT_CONFIG
> +----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_ext_config
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_SET_EXT_CONFIG is used to query the system-wide configuration set
> +through the SNP_SET_EXT_CONFIG.
> +
>  3. SEV-SNP CPUID Enforcement
>  ============================
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b9b6fab31a82..97b479d5aa86 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1312,6 +1312,10 @@ static int __sev_snp_shutdown_locked(int *error)
>         if (!sev->snp_inited)
>                 return 0;
>
> +       /* Free the memory used for caching the certificate data */
> +       kfree(sev->snp_certs_data);
> +       sev->snp_certs_data = NULL;
> +
>         /* SHUTDOWN requires the DF_FLUSH */
>         wbinvd_on_all_cpus();
>         __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
> @@ -1616,6 +1620,111 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>         return ret;
>  }
>
> +static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
> +{
> +       struct sev_device *sev = psp_master->sev_data;
> +       struct sev_user_data_ext_snp_config input;

Lets memset |input| to zero to avoid leaking kernel memory, see
"crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel
memory leak"

> +       int ret;
> +
> +       if (!sev->snp_inited || !argp->data)
> +               return -EINVAL;
> +
> +       if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +               return -EFAULT;
> +
> +       /* Copy the TCB version programmed through the SET_CONFIG to userspace */
> +       if (input.config_address) {
> +               if (copy_to_user((void * __user)input.config_address,
> +                                &sev->snp_config, sizeof(struct sev_user_data_snp_config)))
> +                       return -EFAULT;
> +       }
> +
> +       /* Copy the extended certs programmed through the SNP_SET_CONFIG */
> +       if (input.certs_address && sev->snp_certs_data) {
> +               if (input.certs_len < sev->snp_certs_len) {
> +                       /* Return the certs length to userspace */
> +                       input.certs_len = sev->snp_certs_len;
> +
> +                       ret = -ENOSR;
> +                       goto e_done;
> +               }
> +
> +               if (copy_to_user((void * __user)input.certs_address,
> +                                sev->snp_certs_data, sev->snp_certs_len))
> +                       return -EFAULT;
> +       }
> +
> +       ret = 0;
> +
> +e_done:
> +       if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
> +               ret = -EFAULT;
> +
> +       return ret;
> +}
> +
> +static int sev_ioctl_snp_set_config(struct sev_issue_cmd *argp, bool writable)
> +{
> +       struct sev_device *sev = psp_master->sev_data;
> +       struct sev_user_data_ext_snp_config input;
> +       struct sev_user_data_snp_config config;
> +       void *certs = NULL;
> +       int ret = 0;
> +
> +       if (!sev->snp_inited || !argp->data)
> +               return -EINVAL;
> +
> +       if (!writable)
> +               return -EPERM;
> +
> +       if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +               return -EFAULT;
> +
> +       /* Copy the certs from userspace */
> +       if (input.certs_address) {
> +               if (!input.certs_len || !IS_ALIGNED(input.certs_len, PAGE_SIZE))
> +                       return -EINVAL;
> +
> +               certs = psp_copy_user_blob(input.certs_address, input.certs_len);

I see that psp_copy_user_blob() uses memdup_user() which tracks the
allocated memory to GFP_USER. Given this memory is long lived and now
belongs to the PSP driver in perpetuity, should this be tracked with
GFP_KERNEL?

> +               if (IS_ERR(certs))
> +                       return PTR_ERR(certs);
> +       }
> +
> +       /* Issue the PSP command to update the TCB version using the SNP_CONFIG. */
> +       if (input.config_address) {
> +               if (copy_from_user(&config,
> +                                  (void __user *)input.config_address, sizeof(config))) {
> +                       ret = -EFAULT;
> +                       goto e_free;
> +               }
> +
> +               ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +               if (ret)
> +                       goto e_free;
> +
> +               memcpy(&sev->snp_config, &config, sizeof(config));
> +       }
> +
> +       /*
> +        * If the new certs are passed then cache it else free the old certs.
> +        */
> +       if (certs) {
> +               kfree(sev->snp_certs_data);
> +               sev->snp_certs_data = certs;
> +               sev->snp_certs_len = input.certs_len;
> +       } else {
> +               kfree(sev->snp_certs_data);
> +               sev->snp_certs_data = NULL;
> +               sev->snp_certs_len = 0;
> +       }

Do we need another lock here? When I look at 18/49 it seems like
snp_guest_ext_guest_request() it seems like we have a race for
|sev->snp_certs_data|

> +
> +       return 0;
> +
> +e_free:
> +       kfree(certs);
> +       return ret;
> +}
> +
>  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>  {
>         void __user *argp = (void __user *)arg;
> @@ -1670,6 +1779,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>         case SNP_PLATFORM_STATUS:
>                 ret = sev_ioctl_snp_platform_status(&input);
>                 break;
> +       case SNP_SET_EXT_CONFIG:
> +               ret = sev_ioctl_snp_set_config(&input, writable);
> +               break;
> +       case SNP_GET_EXT_CONFIG:
> +               ret = sev_ioctl_snp_get_config(&input);
> +               break;
>         default:
>                 ret = -EINVAL;
>                 goto out;
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index fe5d7a3ebace..d2fe1706311a 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -66,6 +66,9 @@ struct sev_device {
>
>         bool snp_inited;
>         struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
> +       void *snp_certs_data;
> +       u32 snp_certs_len;
> +       struct sev_user_data_snp_config snp_config;

Since this gets copy_to_user'd can we memset this to 0 to prevent
leaking kernel uninitialized memory? Similar to recent patches with
kzalloc and __GPF_ZERO usage.


>  };
>
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index ffd60e8b0a31..60e7a8d1a18e 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -29,6 +29,8 @@ enum {
>         SEV_GET_ID,     /* This command is deprecated, use SEV_GET_ID2 */
>         SEV_GET_ID2,
>         SNP_PLATFORM_STATUS,
> +       SNP_SET_EXT_CONFIG,
> +       SNP_GET_EXT_CONFIG,
>
>         SEV_MAX,
>  };
> @@ -190,6 +192,21 @@ struct sev_user_data_snp_config {
>         __u8 rsvd[52];
>  } __packed;
>
> +/**
> + * struct sev_data_snp_ext_config - system wide configuration value for SNP.
> + *
> + * @config_address: address of the struct sev_user_data_snp_config or 0 when
> + *             reported_tcb does not need to be updated.
> + * @certs_address: address of extended guest request certificate chain or
> + *              0 when previous certificate should be removed on SNP_SET_EXT_CONFIG.
> + * @certs_len: length of the certs
> + */
> +struct sev_user_data_ext_snp_config {
> +       __u64 config_address;           /* In */
> +       __u64 certs_address;            /* In */
> +       __u32 certs_len;                /* In */
> +};
> +
>  /**
>   * struct sev_issue_cmd - SEV ioctl parameters
>   *
> --
> 2.25.1
>
