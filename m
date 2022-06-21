Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E5D553E09
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 23:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355660AbiFUVno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 17:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356323AbiFUVnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 17:43:32 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E361417592
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 14:43:26 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id g12so10954960ljk.11
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 14:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RaH322YAfZ65JMqhLFboGn96Qf6ZOePhsZrijH5KbCY=;
        b=D3/p22SjNtBkp5qEhE4PypZKC+l3FMV1mhcEN+p6jsNQhcEDuTDTjJxGGLOJxbogOF
         1hFTZ9BOEVKlgp02OsdyaGnv3jsasAPBa/Cnnn2ZVpnyiylHmg6eMVeg4UOWSS0+p6zX
         sdy+2066vX5/bbMcM3aRdbC1PfISSKXvU7NaQ/kzpQjqwI/qZveOUZN3ugQivMMRJkUd
         767YoEBbRRZIM8FyEma3DgNG5SB6FMsF8zbh96yzu29kt8zP32y8BNiGjtAdoKvgo2HK
         SJwOxxywLUJ1z091ovPz98tTKskg+w9ZxRTuR70p3dBhFgE3sxOSL5tGHMYs7Mh864Qz
         uO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RaH322YAfZ65JMqhLFboGn96Qf6ZOePhsZrijH5KbCY=;
        b=qoVKd/lwv/YS48QcrFbxy+XLyEJZ2SJBSuXvMGI5YeFDKuwEp1FogUCea3JUyVTaHa
         ZlTvIodWAwRqaGDxhZcepb2N88VdvSTiwAnCGa1Jkx5q2ULMv5kxp6INPhMp33uvN7ha
         dWpa52rGYs5rTLD/2SDVQ6EGB0WUc8bs9BKcbTk4vS06UBowW/7/2KPutAcZ1KKdR0s/
         OakiVQbDeENMGwcbQq8AgafO01aK5Q3hLKXkuVm9l2yVyJO8js1t4ZrDjBQTMSp8eJS5
         hSEWuFP96kWeKnoNOxsOQYgkq3FTN0b9AGwvlLt7j80Je+XRk/OD/lmXT5UuntFYXbff
         SYfQ==
X-Gm-Message-State: AJIora+OkEtzuVREJv3ifEO05RedGPpYipq4y2jpNslrZs91QbEr+XHz
        9NRwoBvd6JwPY2phc1DKBJKp07cAG/JiW1w8o5NbqQ==
X-Google-Smtp-Source: AGRyM1t5LrtreIfpkqHvv2yWX9Y68V+SEkl3eaqcL/xXhjiBuz27iIjbUSSQa72Yfnt0/LC6HDLYtul7ha0wfZsOe5Q=
X-Received: by 2002:a2e:8805:0:b0:255:6e73:9a67 with SMTP id
 x5-20020a2e8805000000b002556e739a67mr91486ljh.426.1655847804879; Tue, 21 Jun
 2022 14:43:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 21 Jun 2022 15:43:13 -0600
Message-ID: <CAMkAt6qL_p8Fp=ED5hER665GHzQn=nwZQhFg4MwHt7QanS4wVw@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP commands
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

(

On Mon, Jun 20, 2022 at 5:05 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Provide the APIs for the hypervisor to manage an SEV-SNP guest. The
> commands for SEV-SNP is defined in the SEV-SNP firmware specification.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++
>  include/linux/psp-sev.h      | 73 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 97 insertions(+)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index f1173221d0b9..35d76333e120 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1205,6 +1205,30 @@ int sev_guest_df_flush(int *error)
>  }
>  EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>
> +int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error)
> +{
> +       return sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, data, error);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_decommission);
> +
> +int snp_guest_df_flush(int *error)
> +{
> +       return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_df_flush);

Why not instead change sev_guest_df_flush() to be SNP aware? That way
callers get the right behavior without having to know if SNP is
enabled or not.

int sev_guest_df_flush(int *error)
{
  if (!psp_master || !psp_master->sev_data)
   return -EINVAL;

  if (psp_master->sev_data->snp_inited)
    return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);

  return sev_do_cmd(SEV_CMD_DF_FLUSH, NULL, error);
}

> +int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
> +{
> +       return sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, data, error);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_page_reclaim);
> +
> +int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
> +{
> +       return sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, data, error);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
> +
>  static void sev_exit(struct kref *ref)
>  {
>         misc_deregister(&misc_dev->misc);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index ef4d42e8c96e..9f921d221b75 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -881,6 +881,64 @@ int sev_guest_df_flush(int *error);
>   */
>  int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>
> +/**
> + * snp_guest_df_flush - perform SNP DF_FLUSH command
> + *
> + * @sev_ret: sev command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int snp_guest_df_flush(int *error);
> +
> +/**
> + * snp_guest_decommission - perform SNP_DECOMMISSION command
> + *
> + * @decommission: sev_data_decommission structure to be processed
> + * @sev_ret: sev command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error);
> +
> +/**
> + * snp_guest_page_reclaim - perform SNP_PAGE_RECLAIM command
> + *
> + * @decommission: sev_snp_page_reclaim structure to be processed
> + * @sev_ret: sev command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
> +
> +/**
> + * snp_guest_dbg_decrypt - perform SEV SNP_DBG_DECRYPT command
> + *
> + * @sev_ret: sev command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
> +
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>
>  #else  /* !CONFIG_CRYPTO_DEV_SP_PSP */
> @@ -908,6 +966,21 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
>
>  static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
>
> +static inline int
> +snp_guest_decommission(struct sev_data_snp_decommission *data, int *error) { return -ENODEV; }
> +
> +static inline int snp_guest_df_flush(int *error) { return -ENODEV; }
> +
> +static inline int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
> +{
> +       return -ENODEV;
> +}
> +
> +static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
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
