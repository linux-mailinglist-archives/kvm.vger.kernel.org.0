Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C211C40661E
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 05:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhIJD3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 23:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhIJD3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 23:29:21 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC95C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 20:28:11 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id x10-20020a056830408a00b004f26cead745so455040ott.10
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 20:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UieKKUbo09vigeTGRsi4douxAAlNSVtFLyaLJNMJYZA=;
        b=s2DH9HshjSdUjX5RQDFXPAXPgQBV7mcTQ5XXwI8sBWEGGnD7/iTqEkcv/TtD4A61iu
         S/WuZs4WOttAf6ZUBHtC8S5FngwmdjB1YC3yS7vhYSCtup4oDq7lRaWVZHwEW/AlOXDr
         xKP0AsijEFz9BWAB5UqEBrjwXLX61GR/SF2Z3isXNW773kwsAwBsndaYlvoGukvE1N7H
         3PF7x6kG4BGptKyKurg3zUSRRqEhzkQSY06DBeWB2af5zJ9SDWRazTcuBhmnRZfaQMAJ
         7wQF6jHLp6q86H+euYe7GMObuHmr2t8XIz6tb0ld26sK7L7kdJyLjNK2VfPFd/L2729W
         rSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UieKKUbo09vigeTGRsi4douxAAlNSVtFLyaLJNMJYZA=;
        b=6WE1Du9lKVBmh6mUpM2FrNnZP50JrujVxxDatTeEJXyskB6mPLnFldbgZxUSvfMcAB
         IDZc3uQab9yEf9dNPgbG+818pX1BedJLZzN5uwwBcRYSKrHvJGRZ/K+8+kZ8f2l8FerF
         0gt9fPDKQEEYH9gMdoXkP4qE3CgnOqiaQFYSH6LQSSgdwO7r9CVPbyK+AAz/hOUbgxN+
         Ddxh9BX5We0A559Pq9jnzVYOKCA/6SKY6AFkA1A/h6T6Onxa0q5Ykc47O+nOmJFaKv67
         8wZVXMGq1iFvP0hoRbWmAr4yoS9zivNMxE6gvGqbWt5cF/HLpm78u6reLWKgrPrze7EH
         t+hA==
X-Gm-Message-State: AOAM531srDrdOTvpinwxqMTWfzE+Ukgi8Qqreupgf2EB6MAg+cX0uBrh
        052o9YxQZOUnyP+L5kWpIk7terJfdPOflF0r20RRLw==
X-Google-Smtp-Source: ABdhPJygHsmlgHEAZLMm5r+tKUYJ57NEXNEd3ZTCM/AiLFbevyN26U5tU997Fbv3XxUJc40jyM38JSL6xbSdiA0s89A=
X-Received: by 2002:a05:6830:349c:: with SMTP id c28mr2873634otu.35.1631244490681;
 Thu, 09 Sep 2021 20:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-18-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-18-brijesh.singh@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 9 Sep 2021 20:27:59 -0700
Message-ID: <CAA03e5Fb9nGQ8mVJzDvRi4ujq_g0q8zOjOOx4+rYZOJRkrmbhg@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 17/45] crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG
 command
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

`

On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
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
>  Documentation/virt/coco/sevguest.rst |  28 +++++++
>  drivers/crypto/ccp/sev-dev.c         | 115 +++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h         |   3 +
>  include/uapi/linux/psp-sev.h         |  17 ++++
>  4 files changed, 163 insertions(+)
>
> diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
> index 7c51da010039..64a1b5167b33 100644
> --- a/Documentation/virt/coco/sevguest.rst
> +++ b/Documentation/virt/coco/sevguest.rst
> @@ -134,3 +134,31 @@ See GHCB specification for further detail on how to parse the certificate blob.
>  The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
>  status includes API major, minor version and more. See the SEV-SNP
>  specification for further details.
> +
> +2.4 SNP_SET_EXT_CONFIG
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
> +For more information on the certificate blob layout, see the GHCB spec
> +(extended guest request message).
> +
> +
> +2.4 SNP_GET_EXT_CONFIG
> +----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_ext_config
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_SET_EXT_CONFIG is used to query the system-wide configuration set
> +through the SNP_SET_EXT_CONFIG.
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 16c6df5d412c..9ba194acbe85 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1132,6 +1132,10 @@ static int __sev_snp_shutdown_locked(int *error)
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
> @@ -1436,6 +1440,111 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>         return ret;
>  }
>
> +static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
> +{
> +       struct sev_device *sev = psp_master->sev_data;
> +       struct sev_user_data_ext_snp_config input;
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

This API to retrieve the length of the certs seems pretty odd. We only
return the length if the input.certs_address is non-NULL. But if we
know the length how did we allocate an address to write to
`input.certs_address`?

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

Is `psp_copy_user_blob()` implemented in this patch series? When I
searched through the patches, I only found an implementation that
always returns an error. But maybe I missed the implementation?

Also, out of curiosity, any reason we cannot use copy_from_user here?

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
> @@ -1490,6 +1599,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>         case SNP_PLATFORM_STATUS:
>                 ret = sev_ioctl_snp_platform_status(&input);
>                 break;
> +       case SNP_SET_EXT_CONFIG:
> +               ret = sev_ioctl_snp_set_config(&input, writable);
> +               break;
> +       case SNP_GET_EXT_CONFIG:
> +               ret = sev_ioctl_snp_get_config(&input);
> +               break;

What is the intended use of `SNP_GET_EXT_CONFIG`. Yes, I get that it
returns the "EXT config" previously set via `SNP_SET_EXT_CONFIG`. But
presumably the caller can keep track of what it's previously passed to
`SNP_SET_EXT_CONFIG`. Does it really need to call into the kernel to
get these certs?

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
> 2.17.1
>
