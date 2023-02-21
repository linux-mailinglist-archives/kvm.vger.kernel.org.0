Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E1B69E961
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 22:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjBUVWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 16:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBUVWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 16:22:03 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62F930B37;
        Tue, 21 Feb 2023 13:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677014522; x=1708550522;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ehLy/IW0xpkSfeCuJBkmt64WJ8nBnpPBUAfnlKm8V7U=;
  b=i8KAiQww2K6Z1JMppcYyPIB9rt2hlQ8K67vRqCpYkBk6WXYCQCpzrI7v
   dgd3iesTH5Gt4Ocon5zFCtoL3T2WCtu/mL5bFQrMoFykQtbp/bDu0b4Rw
   XTAzwH2591frrEYIHil+sR23Ursr0faVO3hJWOtlFtCtpl3YdKphJDclT
   31yxnkrrUsI8pF8WCZX8dEb7v3wTUljq+ApPtqeBplNM3/1xTFyUya1tQ
   6cWVlJ+ROMnXtf+kY5YxhbIO6F9XzyyjgPu11niBeYLR1f2lDlNo0zPeb
   HAQSGj4Z6bPfS8Nl4Rl4Wt/4V1bMZbyWe/7Ljvz81pU+FDmKzCA/kk55L
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="332758857"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="332758857"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 13:22:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="781151547"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="781151547"
Received: from dakateri-mobl2.amr.corp.intel.com (HELO [10.212.137.160]) ([10.212.137.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 13:21:59 -0800
Message-ID: <856ded9e-facd-fe6d-2f71-bb0cf5b1d546@linux.intel.com>
Date:   Tue, 21 Feb 2023 13:21:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v8 10/56] x86/cpufeatures: Add SEV-SNP CPU feature
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
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
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-11-michael.roth@amd.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20230220183847.59159-11-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/20/23 10:38 AM, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Add CPU feature detection for Secure Encrypted Virtualization with
> Secure Nested Paging. This feature adds a strong memory integrity
> protection to help prevent malicious hypervisor-based attacks like
> data replay, memory re-mapping, and more.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>

Too many signed-off-by's. Are you missing Co-developed-by?

> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h       | 1 +
>  arch/x86/kernel/cpu/amd.c                | 5 +++--
>  tools/arch/x86/include/asm/cpufeatures.h | 1 +
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 1419c4e04d45..480b4eaef310 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -420,6 +420,7 @@
>  #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
>  #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
>  
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 860b60273df3..c7884198ad5b 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -558,8 +558,8 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>  	 *	      SME feature (set in scattered.c).
>  	 *	      If the kernel has not enabled SME via any means then
>  	 *	      don't advertise the SME feature.
> -	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
> -	 *            SEV and SEV_ES feature (set in scattered.c).

Did you remove the related scattered.c code mentioned above in a different patch?

> +	 *   For SEV: If BIOS has not enabled SEV then don't advertise SEV and
> +	 *	      any additional functionality based on it.
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
> index b71f4f2ecdd5..e81606fcd2ab 100644
> --- a/tools/arch/x86/include/asm/cpufeatures.h
> +++ b/tools/arch/x86/include/asm/cpufeatures.h
> @@ -417,6 +417,7 @@
>  #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
>  #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
>  

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
