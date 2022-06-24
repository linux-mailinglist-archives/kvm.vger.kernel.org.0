Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB5B559BD8
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiFXOnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiFXOnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:43:01 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194BB38A0
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:43:00 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id b23so3009597ljh.7
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 07:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c74mHiS9ndNQXugtz6cvlyHO4YfoU5Amna4jcCNFMrs=;
        b=H/ksdZ6l5zr/vi1yB0rt5Eri5/yAGDIDhJ+WxLtjolC+ufKy6G6zPlGl+RRyQ8X0yb
         KHR8ASjiTXJXazdAdIrcuZ2Cs25VbGzQxT++z2kemk7qCE31TwlEGNOFZz1VF98ViVgG
         DVB/LJous1QnTbkIZZt+g4YbndYf5ChpQiC4rpkQ5ReCIQTQumhdcGb/4pood8k+SwZN
         paHcsBmYu6mMMyQfqBR3cSwe3jcLr2EN+96eNG+ci+lB+YDn35X5J9KksySor56ctnXt
         T4lmVaUFlX5DI1QNKrmef517KCnrYSiznbpl/5KssWEh9sSpuWq7z0YsqPsbLgD3MCFS
         uQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c74mHiS9ndNQXugtz6cvlyHO4YfoU5Amna4jcCNFMrs=;
        b=Qd6mPPvvScUfInRsAzC9ApO0tn9rt/Bwh3Tq6a/hBjvkSWges+QtemzrRaivc1Q8CD
         RvBYNqQTCQONmZeldbjJaNWFplRZfqtQlDDBrONyZG8ovfHeD+W+qCrORxE//juPT2xs
         J31ed6+C4+bb2BRrSR818AU+QYGluDOsMxeNgT1qK8T2CSdV4NSRJq4V7ow9Qhlmeab7
         CFr9HmucJiQzF/ubS3nwNXi9FJpIo2RUpBrAilk9GOxd05n5c0VpkfDh4byFhgq9W3Q8
         IdfG02y6AsBiBoWJe/mTg6+suOgtsuX/9VcqMamrpVKV9GYM3vF5x9cNNIRvPgt0TN7x
         RAKg==
X-Gm-Message-State: AJIora8VSFNoCMFW51TGe00HlByYmClQZmM6kZrWhooBIEoO/XlhEuP9
        HPaVXfUIBLEGEfaI7Pg15LKgSFBrLnlpwqtxB5rT92P2DOhCgsPs
X-Google-Smtp-Source: AGRyM1vYszCbgCJkIeTLTax5rPL2YqFzl1LowMYrI+vR1nuQeKj/955rGAXK6XhwauP1YAq9QkIKvVeNZu/Zq5Nkw8Y=
X-Received: by 2002:a05:651c:1549:b0:258:4386:f6a2 with SMTP id
 y9-20020a05651c154900b002584386f6a2mr7672748ljp.527.1656081778232; Fri, 24
 Jun 2022 07:42:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <6d5c899030b113755e6c093e8bb9ad123280edc6.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <6d5c899030b113755e6c093e8bb9ad123280edc6.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 24 Jun 2022 08:42:46 -0600
Message-ID: <CAMkAt6rV0GMuMwz35fEd19Z-mxXiiO6f2pF23QxTBD70Hzxf0Q@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 24/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
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

>
> +19. KVM_SNP_LAUNCH_START
> +------------------------
> +
> +The KVM_SNP_LAUNCH_START command is used for creating the memory encryption
> +context for the SEV-SNP guest. To create the encryption context, user must
> +provide a guest policy, migration agent (if any) and guest OS visible
> +workarounds value as defined SEV-SNP specification.
> +
> +Parameters (in): struct  kvm_snp_launch_start
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_snp_launch_start {
> +                __u64 policy;           /* Guest policy to use. */
> +                __u64 ma_uaddr;         /* userspace address of migration agent */
> +                __u8 ma_en;             /* 1 if the migtation agent is enabled */

migration

> +                __u8 imi_en;            /* set IMI to 1. */
> +                __u8 gosvw[16];         /* guest OS visible workarounds */
> +        };
> +
> +See the SEV-SNP specification for further detail on the launch input.
> +
>  References
>  ==========
>

>
> +static int snp_decommission_context(struct kvm *kvm)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       struct sev_data_snp_decommission data = {};
> +       int ret;
> +
> +       /* If context is not created then do nothing */
> +       if (!sev->snp_context)
> +               return 0;
> +
> +       data.gctx_paddr = __sme_pa(sev->snp_context);
> +       ret = snp_guest_decommission(&data, NULL);

Do we have a similar race like in sev_unbind_asid() with DEACTIVATE
and WBINVD/DF_FLUSH? The SNP_DECOMMISSION spec looks quite similar to
DEACTIVATE.

> +       if (WARN_ONCE(ret, "failed to release guest context"))
> +               return ret;
> +
> +       /* free the context page now */
> +       snp_free_firmware_page(sev->snp_context);
> +       sev->snp_context = NULL;
> +
> +       return 0;
> +}
> +
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
