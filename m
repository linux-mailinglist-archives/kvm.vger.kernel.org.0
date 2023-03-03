Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF5D6AA0EA
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjCCVQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCCVQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:16:23 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5F861505
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:16:22 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so7480830pjb.1
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 13:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677878182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CtyA8+dkXpvEYtxvtI/sfRVujKNNWUCMFpU0T4e2ANw=;
        b=mexMqQCHkUBNav+b3Y4MjfvCRmY7UCJfNabi0qFZFmsR6uq4XB5oFVChCDx0og52Iq
         6mGPxLI5dc8F6pc2bXoradxGgIjlWTEp7GOZwwrZQtB70TZnGx7bD21bRhQeoJhy2Mj5
         SJMKgKScZE/cBCslcwWERdVg/+APDPQR9G9PRQTqAqhN/CzVrVfkXLb4h99xXPJX4VeZ
         CrGfPEJ9Qur+lGuSZ8g6+86WEIn956n/gvGgBGAjX1NlCaktwLbZOklwhKAah+4mf0ac
         ohZGKOv8o0aVwJmKgs/yRM9wbPlLb/iGR2buxdAYebtvP/Vqn5l8/TRYDEpqarYP0IMK
         Q6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677878182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtyA8+dkXpvEYtxvtI/sfRVujKNNWUCMFpU0T4e2ANw=;
        b=xeum28UVQjqqtpU2vjSHEdzNV/bn7OBwSpQJm/RgArjGllMOyd/Hsf6ErEocGgfiYU
         ABOlG07op5A/Uh06rTi5b0r2549OobB+sdGo1jyHNPriCAQhTRLkekGUrE7HHmnn2zVv
         M7nYFGLF+yOaQs4vtxyxSS/rRD4z3dP7p/H/zmdcmhfBsnarFR7pPIhh4WO3AuSk1CXO
         FnQD73pJz7eLOhrJL2b6n7LIsq5FJxDVh+sdluC/6OSUDpyfP00aCFH2wDIroyyFbZ+h
         Wuhobx1juPQSZOa5BQxZ0gQJtwkbMBmDI9WXJsQQZLtkIuRAYot0K4dLO2doUiUU0hCS
         i3fQ==
X-Gm-Message-State: AO0yUKWPn3C6FkXhvq2IKXD4ca2K3Dvf1vY89LM1Kau/AwBrcbP4o1R5
        d3rq9fRhHhlq1nQDQz+s8huL5w==
X-Google-Smtp-Source: AK7set8ibM0Zo7HuO8uLV0Jz3PCK1vLi/cQiqF71eubcV0ybfol7mF4sFzgninhJL1RC/13q+0x3Dg==
X-Received: by 2002:a05:6a20:748d:b0:cc:f597:228e with SMTP id p13-20020a056a20748d00b000ccf597228emr3254931pzd.41.1677878182146;
        Fri, 03 Mar 2023 13:16:22 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id v18-20020aa78092000000b00597caf6236esm2021378pff.150.2023.03.03.13.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 13:16:21 -0800 (PST)
Date:   Fri, 3 Mar 2023 21:16:18 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Subject: Re: [PATCH v3 7/8] KVM: selftests: Add XFEATURE masks to common code
Message-ID: <ZAJjoiZopqIXDoDc@google.com>
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-8-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224223607.1580880-8-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023, Aaron Lewis wrote:
> Add XFEATURE masks to processor.h to make them more broadly available
> in KVM selftests.
> 
> Use the names from the kernel's fpu/types.h for consistency, i.e.
> rename XTILECFG and XTILEDATA to XTILE_CFG and XTILE_DATA respectively.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  | 17 ++++++++++++++
>  tools/testing/selftests/kvm/x86_64/amx_test.c | 22 +++++++------------
>  2 files changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 62dc54c8e0c4..ebe83cfe521c 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -48,6 +48,23 @@ extern bool host_cpu_is_amd;
>  #define X86_CR4_SMAP		(1ul << 21)
>  #define X86_CR4_PKE		(1ul << 22)
>  
> +#define XFEATURE_MASK_FP		BIT_ULL(0)
> +#define XFEATURE_MASK_SSE		BIT_ULL(1)
> +#define XFEATURE_MASK_YMM		BIT_ULL(2)
> +#define XFEATURE_MASK_BNDREGS		BIT_ULL(3)
> +#define XFEATURE_MASK_BNDCSR		BIT_ULL(4)
> +#define XFEATURE_MASK_OPMASK		BIT_ULL(5)
> +#define XFEATURE_MASK_ZMM_Hi256		BIT_ULL(6)
> +#define XFEATURE_MASK_Hi16_ZMM		BIT_ULL(7)
> +#define XFEATURE_MASK_XTILE_CFG		BIT_ULL(17)
> +#define XFEATURE_MASK_XTILE_DATA	BIT_ULL(18)
> +
> +#define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK | \
> +					 XFEATURE_MASK_ZMM_Hi256 | \
> +					 XFEATURE_MASK_Hi16_ZMM)
> +#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILE_DATA | \
> +					 XFEATURE_MASK_XTILE_CFG)
> +
>  /* Note, these are ordered alphabetically to match kvm_cpuid_entry2.  Eww. */
>  enum cpuid_output_regs {
>  	KVM_CPUID_EAX,
> diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
> index 4b733ad21831..14a7656620d5 100644
> --- a/tools/testing/selftests/kvm/x86_64/amx_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
> @@ -33,12 +33,6 @@
>  #define MAX_TILES			16
>  #define RESERVED_BYTES			14
>  
> -#define XFEATURE_XTILECFG		17
> -#define XFEATURE_XTILEDATA		18
> -#define XFEATURE_MASK_XTILECFG		(1 << XFEATURE_XTILECFG)
> -#define XFEATURE_MASK_XTILEDATA		(1 << XFEATURE_XTILEDATA)
> -#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILECFG | XFEATURE_MASK_XTILEDATA)
> -
>  #define XSAVE_HDR_OFFSET		512
>  
>  struct xsave_data {
> @@ -187,14 +181,14 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
>  	__tilerelease();
>  	GUEST_SYNC(5);
>  	/* bit 18 not in the XCOMP_BV after xsavec() */
> -	set_xstatebv(xsave_data, XFEATURE_MASK_XTILEDATA);
> -	__xsavec(xsave_data, XFEATURE_MASK_XTILEDATA);
> -	GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILEDATA) == 0);
> +	set_xstatebv(xsave_data, XFEATURE_MASK_XTILE_DATA);
> +	__xsavec(xsave_data, XFEATURE_MASK_XTILE_DATA);
> +	GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILE_DATA) == 0);
>  
>  	/* xfd=0x40000, disable amx tiledata */
> -	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);
> +	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
>  	GUEST_SYNC(6);
> -	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILEDATA);
> +	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
>  	set_tilecfg(amx_cfg);
>  	__ldtilecfg(amx_cfg);
>  	/* Trigger #NM exception */
> @@ -206,11 +200,11 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
>  
>  void guest_nm_handler(struct ex_regs *regs)
>  {
> -	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
> +	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
>  	GUEST_SYNC(7);
> -	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
> +	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
>  	GUEST_SYNC(8);
> -	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
> +	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
>  	/* Clear xfd_err */
>  	wrmsr(MSR_IA32_XFD_ERR, 0);
>  	/* xfd=0, enable amx */
> -- 
> 2.39.2.637.g21b0678d19-goog
> 
Can I take your commit into my series? This seems to be closely related
with amx_test itself without much relationship with the xcr0 test.
Thoughts?
