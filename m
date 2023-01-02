Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F7D65B082
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 12:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbjABLYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 06:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbjABLXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 06:23:53 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AAA55B8
        for <kvm@vger.kernel.org>; Mon,  2 Jan 2023 03:23:51 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id ge16so26095161pjb.5
        for <kvm@vger.kernel.org>; Mon, 02 Jan 2023 03:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WvoweWw/70ivy5NhGIDsQUyOQzuO+TAKiYfPlBf2qwI=;
        b=YchLhpPconal93iXKzKSH3gjBZFo64/w295n1NXc+vfqOt8vXqu/YZ/7Biub6l8XJT
         1GL+W1kK/Cs7oe/JS9XCTV1IjxPXvnXjY5tTQId3qOGpOu3rJGJvbss1pLxlni8GkNCC
         iGFfF6EtIBVxS9YqcUUGFi/wFYr7Ogq+LwvqVtBV/2D2jvOYV3qdxYvYXWj6sC0mJNsU
         gJi1RJZpTBT6lFF7lOpbZfxtFLrGvLnPME9Mq4RmzbDY2aIl/n94QEwXB0dEIQTw+XtB
         Rnd/F3BEFwqowu8Hck9Et3OlElTkSwR2ZE5zaplS58L87vdu7WS14gptw+w6P1bsN3a0
         tipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WvoweWw/70ivy5NhGIDsQUyOQzuO+TAKiYfPlBf2qwI=;
        b=fqHy0Lv/1mukN+rLho/QpXdkY0E6F32BTK7Jj7cw6p/xHHU1hokT8xBoFn3nHkxvbK
         deYFdOBjrVZGtW3WqjFNDJLl3fSPAu1IkNJ2AWExbczOXDZjKJFakM/5QdxiqWxrTAep
         G75+fq7EiwD/fQsDkljsoxnoptGNuy3kwMBfYgRWhaZSZDuiFXlBPp9MdqX+KPFqR/Ok
         XXIM2L6PSu1xWGc4NH67pvflbRgj1GoozFGcAaZjSCj2Z3suH6EmRQI5S9G5c3rbqMKa
         1Faeju3py/unSkBBmyPgICSEqmYgRwt0IUo950zs+q1JRAR1PZm6/mFFcVvMSAiIUTJF
         826Q==
X-Gm-Message-State: AFqh2krW7r5RcFmSdnZwlBPAQQSYfmlSWiHOMWHEj8ibUuCqJFukveCa
        uJxa816R5wYCJO8yREVsYDfoew==
X-Google-Smtp-Source: AMrXdXsIV1+R6Q3jwWt535qSNqSmJo2qQnw8GByeE6YAMD5Q/YI21RfUVdJ18geg7rpHDbEymWK8eA==
X-Received: by 2002:a17:902:b615:b0:191:4367:7fde with SMTP id b21-20020a170902b61500b0019143677fdemr3646444pls.0.1672658631287;
        Mon, 02 Jan 2023 03:23:51 -0800 (PST)
Received: from [2620:15c:29:203:20a4:1331:a6b6:c59b] ([2620:15c:29:203:20a4:1331:a6b6:c59b])
        by smtp.gmail.com with ESMTPSA id m4-20020a170902db0400b0018703bf42desm19942476plx.159.2023.01.02.03.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 03:23:50 -0800 (PST)
Date:   Mon, 2 Jan 2023 03:23:49 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Nikunj A Dadhania <nikunj@amd.com>
cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        stable@kernel.org
Subject: Re: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation
 support
In-Reply-To: <20230102083810.71178-1-nikunj@amd.com>
Message-ID: <3169b54b-d990-7707-5ec4-cde7261318fe@google.com>
References: <20230102083810.71178-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2 Jan 2023, Nikunj A Dadhania wrote:

> The hypervisor can enable various new features (SEV_FEATURES[1:63])
> and start the SNP guest. Some of these features need guest side
> implementation. If any of these features are enabled without guest
> side implementation, the behavior of the SNP guest will be undefined.
> The SNP guest boot may fail in a non-obvious way making it difficult
> to debug.
> 
> Instead of allowing the guest to continue and have it fail randomly
> later, detect this early and fail gracefully.
> 
> SEV_STATUS MSR indicates features which hypervisor has enabled. While
> booting, SNP guests should ascertain that all the enabled features
> have guest side implementation. In case any feature is not implemented
> in the guest, the guest terminates booting with SNP feature
> unsupported exit code.
> 
> More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
> 
> [1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
> 
> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
> CC: Borislav Petkov <bp@alien8.de>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: <stable@kernel.org>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> ---
> 
> Changes:
> v2:
> * Updated Documentation/x86/amd-memory-encryption.rst
> * Address review feedback from Boris/Tom
> 
> v1:
> * Dropped _ENABLED from the feature bits
> * Use approprate macro/function names and move closer to the function where
>   it is used.
> * More details added to the commit message and comments
> * Fixed compilation issue
> ---
>  Documentation/x86/amd-memory-encryption.rst | 35 +++++++++++++++++++
>  arch/x86/boot/compressed/sev.c              | 37 +++++++++++++++++++++
>  arch/x86/include/asm/msr-index.h            | 20 +++++++++++
>  arch/x86/include/asm/sev-common.h           |  1 +
>  4 files changed, 93 insertions(+)
> 
> diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
> index a1940ebe7be5..b8b6b87be995 100644
> --- a/Documentation/x86/amd-memory-encryption.rst
> +++ b/Documentation/x86/amd-memory-encryption.rst
> @@ -95,3 +95,38 @@ by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
>  not enable SME, then Linux will not be able to activate memory encryption, even
>  if configured to do so by default or the mem_encrypt=on command line parameter
>  is specified.
> +
> +Secure Nested Paging (SNP):
> +===========================
> +SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be enabled
> +by the hypervisor for security enhancements. Some of these features need
> +guest side implementation to function correctly. The below table lists the
> +expected guest behavior with various possible scenarios of guest/hypervisor
> +SNP feature support.
> +
> ++---------------+---------------+---------------+---------------+
> +|Feature Enabled|  Guest needs  |   Guest has   |  Guest boot   |
> +|     by HV     |implementation |implementation |   behavior    |
> ++---------------+---------------+---------------+---------------+
> +|      No       |      No       |      No       |     Boot      |
> +|               |               |               |               |
> ++---------------+---------------+---------------+---------------+
> +|      No       |      Yes      |      No       |     Boot      |
> +|               |               |               |               |
> ++---------------+---------------+---------------+---------------+
> +|      No       |      Yes      |      Yes      |     Boot      |
> +|               |               |               |               |
> ++---------------+---------------+---------------+---------------+
> +|      Yes      |      No       |      No       |   Boot with   |
> +|               |               |               |feature enabled|
> ++---------------+---------------+---------------+---------------+
> +|      Yes      |      Yes      |      No       | Graceful Boot |
> +|               |               |               |    Failure    |
> ++---------------+---------------+---------------+---------------+
> +|      Yes      |      Yes      |      Yes      |   Boot with   |
> +|               |               |               |feature enabled|
> ++---------------+---------------+---------------+---------------+
> +

Couple things:

 - I'd assume that the documentation would refer the reader to the
   SNP_FEATURES_IMPL_REQ mask that defines whether the guest is required 
   to have a specific feature or not.

 - Don't hate me, but I feel wanting more from this, such as a rationale
   for why certain features are required in the guest.  When a guest fails
   to boot and the reasoning provided by a cloud provider is "your guest
   doesn't support ${feature}", the natural question to ask will be "why 
   do I need ${feature}?"

> +More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
> +
> +[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index c93930d5ccbd..43793f46cfc1 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -270,6 +270,36 @@ static void enforce_vmpl0(void)
>  		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
>  }
>  
> +/*
> + * SNP_FEATURES_IMPL_REQ is the mask of SNP features that will need
> + * guest side implementation for proper functioning of the guest. If any
> + * of these features are enabled in the hypervisor but are lacking guest
> + * side implementation, the behavior of the guest will be undefined. The
> + * guest could fail in non-obvious way making it difficult to debug.
> + *
> + * As the behavior of reserved feature bits is unknown to be on the
> + * safe side add them to the required features mask.

If one or more of the reserved feature bits turns out to not be required 
for the SNP guest to function correctly, is this the correct choice?

IIUC, legacy guests would fail to boot correctly (and unnecessarily, 
because of this change) if they do not have an implentation for a 
non-required feature.  Absent this change, however, they would proceed 
just fine.

> + */
> +#define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |			\
> +				MSR_AMD64_SNP_REFLECT_VC |		\
> +				MSR_AMD64_SNP_RESTRICTED_INJ |		\
> +				MSR_AMD64_SNP_ALT_INJ |			\
> +				MSR_AMD64_SNP_DEBUG_SWAP |		\
> +				MSR_AMD64_SNP_VMPL_SSS |		\
> +				MSR_AMD64_SNP_SECURE_TSC |		\
> +				MSR_AMD64_SNP_VMGEXIT_PARAM |		\
> +				MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
> +				MSR_AMD64_SNP_RESERVED_BIT13 |		\
> +				MSR_AMD64_SNP_RESERVED_BIT15 |		\
> +				MSR_AMD64_SNP_RESERVED_MASK)
> +
> +/*
> + * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
> + * by the guest kernel. As and when a new feature is implemented in the
> + * guest kernel, a corresponding bit should be added to the mask.
> + */
> +#define SNP_FEATURES_PRESENT (0)
> +
>  void sev_enable(struct boot_params *bp)
>  {
>  	unsigned int eax, ebx, ecx, edx;
> @@ -335,6 +365,13 @@ void sev_enable(struct boot_params *bp)
>  		if (!(get_hv_features() & GHCB_HV_FT_SNP))
>  			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
>  
> +		/*
> +		 * Terminate the boot if hypervisor has enabled any feature
> +		 * lacking guest side implementation.
> +		 */
> +		if (sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT)
> +			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);

We can't help out by specifying which feature(s)?

> +
>  		enforce_vmpl0();
>  	}
>  
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 37ff47552bcb..d3fe82c5d6b6 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -566,6 +566,26 @@
>  #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>  #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
>  
> +/* SNP feature bits enabled by the hypervisor */
> +#define MSR_AMD64_SNP_VTOM			BIT_ULL(3)
> +#define MSR_AMD64_SNP_REFLECT_VC		BIT_ULL(4)
> +#define MSR_AMD64_SNP_RESTRICTED_INJ		BIT_ULL(5)
> +#define MSR_AMD64_SNP_ALT_INJ			BIT_ULL(6)
> +#define MSR_AMD64_SNP_DEBUG_SWAP		BIT_ULL(7)
> +#define MSR_AMD64_SNP_PREVENT_HOST_IBS		BIT_ULL(8)
> +#define MSR_AMD64_SNP_BTB_ISOLATION		BIT_ULL(9)
> +#define MSR_AMD64_SNP_VMPL_SSS			BIT_ULL(10)
> +#define MSR_AMD64_SNP_SECURE_TSC		BIT_ULL(11)
> +#define MSR_AMD64_SNP_VMGEXIT_PARAM		BIT_ULL(12)
> +#define MSR_AMD64_SNP_IBS_VIRT			BIT_ULL(14)
> +#define MSR_AMD64_SNP_VMSA_REG_PROTECTION	BIT_ULL(16)
> +#define MSR_AMD64_SNP_SMT_PROTECTION		BIT_ULL(17)
> +
> +/* SNP feature bits reserved for future use. */
> +#define MSR_AMD64_SNP_RESERVED_BIT13		BIT_ULL(13)
> +#define MSR_AMD64_SNP_RESERVED_BIT15		BIT_ULL(15)
> +#define MSR_AMD64_SNP_RESERVED_MASK		GENMASK_ULL(63, 18)
> +
>  #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
>  
>  /* AMD Collaborative Processor Performance Control MSRs */
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index b8357d6ecd47..db60cbb01b31 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -148,6 +148,7 @@ struct snp_psc_desc {
>  #define GHCB_SEV_ES_GEN_REQ		0
>  #define GHCB_SEV_ES_PROT_UNSUPPORTED	1
>  #define GHCB_SNP_UNSUPPORTED		2
> +#define GHCB_SNP_FEAT_NOT_IMPLEMENTED	3
>  
>  /* Linux-specific reason codes (used with reason set 1) */
>  #define SEV_TERM_SET_LINUX		1
> -- 
> 2.32.0
> 
> 
