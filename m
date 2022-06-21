Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B3F552DC0
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 10:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347679AbiFUI64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 04:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348591AbiFUI6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 04:58:40 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AFCE1C;
        Tue, 21 Jun 2022 01:58:38 -0700 (PDT)
Received: from zn.tnic (p2e55dbad.dip0.t-ipconnect.de [46.85.219.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 56AB81EC0576;
        Tue, 21 Jun 2022 10:58:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1655801913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=THe01fFq/VVSfqs+JIwBFS+S4rUvRCAH2e4Ug2QOtbU=;
        b=D+3TDXk5A70FXJH4amYBCqq2eUl/InLmvpky5ywFpHbkfYH1+/Kz38D2aCavRLr5MNpjLH
        ZN1T8Ki7n5eZa/dUy75+mre+HAkaSlGhiRRig23k/VnuKHepcD61Q+DSn+RLtU4GXIJM+n
        OKktuV65Kc6g13PHIcdaO7+gvy4nPsk=
Date:   Tue, 21 Jun 2022 10:58:29 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, michael.roth@amd.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 01/49] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <YrGINaPc3cojG6/3@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <7abfca61f8595c036e1bd9f1d65ab78af0006627.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7abfca61f8595c036e1bd9f1d65ab78af0006627.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 10:59:01PM +0000, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Add CPU feature detection for Secure Encrypted Virtualization with
> Secure Nested Paging. This feature adds a strong memory integrity
> protection to help prevent malicious hypervisor-based attacks like
> data replay, memory re-mapping, and more.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

verify_tags: Warning: Sender Ashish Kalra <Ashish.Kalra@amd.com> hasn't signed off on the patch!

When you send someone else's patch, you need to add your SOB underneath
it to state that you have handled that patch too, on its way mainline.

While waiting for review, please brush up on the development process by
perusing the documentation in Documentation/process/ and especially

Documentation/process/submitting-patches.rst

> ---
>  arch/x86/include/asm/cpufeatures.h       | 1 +
>  arch/x86/kernel/cpu/amd.c                | 3 ++-
>  tools/arch/x86/include/asm/cpufeatures.h | 1 +
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 30da1341f226..1cba0217669f 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -407,6 +407,7 @@
>  #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */

Do you not see how there's a space between the '+' and the single-digit
number so that the vertical formatting works?

>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
>  
>  /*
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 0c0b09796ced..2e87015a9d69 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -559,7 +559,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  	 *	      If the kernel has not enabled SME via any means then
>  	 *	      don't advertise the SME feature.
>  	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
> -	 *            SEV and SEV_ES feature (set in scattered.c).
> +	 *            SEV, SEV_ES and SEV_SNP feature.

Let's generalize that so that it doesn't get updated with every feature:

"... then don't advertize SEV and any additional functionality based on it."

>  	 *
>  	 *   In all cases, since support for SME and SEV requires long mode,
>  	 *   don't advertise the feature under CONFIG_X86_32.
> @@ -594,6 +594,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  clear_sev:
>  		setup_clear_cpu_cap(X86_FEATURE_SEV);
>  		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
> +		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>  	}
>  }
>  
> diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
> index 73e643ae94b6..a636342ecb26 100644
> --- a/tools/arch/x86/include/asm/cpufeatures.h
> +++ b/tools/arch/x86/include/asm/cpufeatures.h
> @@ -405,6 +405,7 @@
>  #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_SEV_SNP		(19*32+4)  /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */

Ditto.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
