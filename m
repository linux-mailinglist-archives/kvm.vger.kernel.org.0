Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C276C73B
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 09:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjHBHnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 03:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbjHBHmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 03:42:33 -0400
Received: from mgamail.intel.com (unknown [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F651EA
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 00:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690962032; x=1722498032;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GwPiwjg0i2K9L8XD5Q2aQMXQ75PL3dJWZdYCk5VsBtM=;
  b=HDGq3wWZhX1niSxdGJ72jV3FKa7sGS+jbV0UkOyd/M8//6wDydUL4orp
   aKqOvlmkAng0A62s0Uu916X5ta0iXYUF/bowv2Yr1vJzDBt9Q5pcxpuPF
   pPdlp8UQr8hfNDOPAf5+KbjooVMB5T3/k70Ka4UGx68/2C3TVHHx1Q1lG
   15EQeqp9fn5sAIZIrC/bK7OACCVQU4nNJ5KMcqHXzGwn0wMFIQq3nX4fx
   UCEMR8kwFUqhfvSdAlTyTT6TQP4K0v4rHRydc+68Ta44TGUlNqdsVOeGI
   fObSffy0VxImMpCXYsbRVCN0E3ngA8fL02W8Tt5/JSJvy8gvmli7Itxkt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="368405930"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="368405930"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 00:40:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="872363597"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 00:40:32 -0700
Message-ID: <7653b2aa-14f7-b1a2-f0fc-cd3b3c012e8d@intel.com>
Date:   Wed, 2 Aug 2023 15:40:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
Content-Language: en-US
To:     Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com
References: <20230802022954.193843-1-tao1.su@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230802022954.193843-1-tao1.su@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/2023 10:29 AM, Tao Su wrote:
> Latest Intel platform GraniteRapids-D introduces AMX-COMPLEX, which adds
> two instructions to perform matrix multiplication of two tiles containing
> complex elements and accumulate the results into a packed single precision
> tile.
> 
> AMX-COMPLEX is enumerated via CPUID.(EAX=7,ECX=1):EDX[bit 8]
> 
> Since there are no new VMX controls or additional host enabling required
> for guests to use this feature, advertise the CPUID to userspace.
> 
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/cpuid.c         | 3 ++-
>   arch/x86/kvm/reverse_cpuid.h | 1 +
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7f4d13383cf2..883ec8d5a77f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -647,7 +647,8 @@ void kvm_set_cpu_caps(void)
>   	);
>   
>   	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
> -		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
> +		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
> +		F(AMX_COMPLEX)
>   	);
>   
>   	kvm_cpu_cap_mask(CPUID_D_1_EAX,
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index 56cbdb24400a..b81650678375 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -43,6 +43,7 @@ enum kvm_only_cpuid_leafs {
>   /* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
>   #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
>   #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
> +#define X86_FEATURE_AMX_COMPLEX         KVM_X86_FEATURE(CPUID_7_1_EDX, 8)
>   #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
>   
>   /* CPUID level 0x80000007 (EDX). */
> 
> base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4

