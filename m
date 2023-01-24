Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7767A35C
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 20:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbjAXTrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 14:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjAXTrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 14:47:49 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27782D64
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 11:47:45 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id jm10so15750995plb.13
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 11:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rBOnCGCgHA+h0K4xs09JZ5tAOGOdOOhqvso345IlOIU=;
        b=ZSXXZeemVSovNxhQzHf9Z6or5tBD3OaIxkSFLDWe9qUpCcpKApi2WezWutb4FsWmck
         Bc7osK0nICXv5nhT5zCJxDGnASi70eG9QMju5DLCXR1o4VpFvPWu/I4+ngZNfMSa/1Kx
         m2HRWGNIA7TvPwwDvNffxqg26m+AEK7PJBckA3m0/l6xm99vO4YuiCbGqa++A7hSZjnT
         9za9yX11av86lgD7Sm4fSOFzFkYMfSxMxHXw3P3eJeutXeM5aRRxG+Nn0vr32Sjb7n3/
         KpWFCVv3XctlLnWBSM4uLqYQr0F+pHRVp0GZG2PC6uu0QzOWjYPTmX1oO8DNO9yuqngj
         +MFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBOnCGCgHA+h0K4xs09JZ5tAOGOdOOhqvso345IlOIU=;
        b=HkTiAl0IEPuAzLyrV5XH6tYts7s3rRLWhLdPNezlmBb0sckLmHdogF/Iw9AveNEUQ2
         4vxlAFBAO6Hp6OgLMdmIYpqXI7gzev8J3QEzL762cCQ5itZf3e7EqhpbOoMBzgN3gVub
         4cePcKG/I+m830EcqAxjgcHC+H/8LblX+3fUoOnaWEE45Z3WEqBZBnAs36mu1gqN2h7Z
         Ja7qlDhlBheSgsDhHxm6sYzyyd3+1ghPBDVekemqpytVuxEDb2QYrONOzqYnOOlESeVe
         A2rg3sXEED9byPbOy+Wk2EP3pq+GfjE2SA8MFsJsJyP96rAwuhzm2aP4kwg88Ua7wKKO
         cwmg==
X-Gm-Message-State: AO0yUKWx1qYfQtqIFka4eqsxyDjei6GA+PzuzFB8gs9SBEPEttYdR6WM
        tfXSFxMbl4Tuf4V0ShN3P/EN7A==
X-Google-Smtp-Source: AK7set8NJy9M0ezGgLaxBUVb12bBQKzoTnKgDIc66cy27BxETG1+iJHbHSZiW6otM5EdTd1HQAYjnQ==
X-Received: by 2002:a05:6a20:4c08:b0:a4:efde:2ed8 with SMTP id fm8-20020a056a204c0800b000a4efde2ed8mr353958pzb.0.1674589665147;
        Tue, 24 Jan 2023 11:47:45 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 18-20020a170902ee5200b00172fad607b3sm2030142plo.207.2023.01.24.11.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 11:47:44 -0800 (PST)
Date:   Tue, 24 Jan 2023 19:47:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] KVM: x86/cpuid: Add X86_FEATURE_AMD_PMU_V2 as a
 KVM-only leaf entry
Message-ID: <Y9A13G5b1tuoIRUq@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
 <20221111102645.82001-6-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111102645.82001-6-likexu@tencent.com>
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

On Fri, Nov 11, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Alias X86_FEATURE_AMD_PMU_V2 for feature AMD_PMU_V2 in KVM-only leafs that
> aren't scattered by cpufeatures.h so that it can be used in KVM, e.g. to
> query guest CPUID.  As a bonus, no translation is needed for these features
> in __feature_translate().
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/reverse_cpuid.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index a19d473d0184..7cfedb3e47c0 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -13,6 +13,7 @@
>   */
>  enum kvm_only_cpuid_leafs {
>  	CPUID_12_EAX	 = NCAPINTS,
> +	CPUID_8000_0022_EAX,
>  	NR_KVM_CPU_CAPS,
>  
>  	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> @@ -23,7 +24,15 @@ enum kvm_only_cpuid_leafs {
>  /* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
>  #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
>  #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
> +#define KVM_X86_FEATURE_AMD_PMU_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
>  
> +/*
> + * Alias X86_FEATURE_* to the KVM variant for features in KVM-only leafs that
> + * aren't scattered by cpufeatures.h so that X86_FEATURE_* can be used in KVM,
> + * e.g. to query guest CPUID.  As a bonus, no translation is needed for these
> + * features in __feature_translate().
> + */
> +#define X86_FEATURE_AMD_PMU_V2      KVM_X86_FEATURE_AMD_PMU_V2

I gave you bad input earlier, for purely KVM-defined flags there's no need for an
intermediate KVM_X86_FEATURE_AMD_PMU_V2, this could simply be:

  #define X86_FEATURE_AMD_PMU_V2         KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)

That's a moot point though because, after much searching because I had a very hard
time believing the kernel wouldn't want to know about this flag, I found commit

  d6d0c7f681fd ("x86/cpufeatures: Add PerfMonV2 feature bit")

from nearly a year ago.  I.e. to avoid confusiong, this needs to be a scattered
flag, not a purely KVM flag.

---
 arch/x86/kvm/reverse_cpuid.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 4945456fd646..333e28b0a13c 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -15,6 +15,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
 	CPUID_7_1_EDX,
 	CPUID_8000_0007_EDX,
+	CPUID_8000_0022_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -47,6 +48,9 @@ enum kvm_only_cpuid_leafs {
 /* CPUID level 0x80000007 (EDX). */
 #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
 
+/* CPUID level 0x80000022 (EAX) */
+#define KVM_X86_FEATURE_PERFMON_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -73,6 +77,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
 	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
 	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
+	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 };
 
 /*
@@ -107,6 +112,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
 		return KVM_X86_FEATURE_SGX_EDECCSSA;
 	else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
 		return KVM_X86_FEATURE_CONSTANT_TSC;
+	else if (x86_feature == X86_FEATURE_PERFMON_V2)
+		return KVM_X86_FEATURE_PERFMON_V2;
 
 	return x86_feature;
 }

base-commit: 5f3f3cc1279cd5cd52d301b97844bd3ce40c8020
-- 

