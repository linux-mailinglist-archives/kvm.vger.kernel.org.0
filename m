Return-Path: <kvm+bounces-214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C60477DD4D4
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:43:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00D311C20C28
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF90208D8;
	Tue, 31 Oct 2023 17:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQC2ajM1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8717491
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:43:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD826A2
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iUnO9/SZ6ap+H+Ma/kTTfFeGQM3g1ED274282AbLD1g=;
	b=hQC2ajM1OnqZ39N6i8BXE2egmiOYoEfxjO5R9P4J1+mHGG1BmHB2YnnM5lpdZ29YonLSqV
	gnIWQzuwYj+Mq+4CPHF56L12cRHFlu6PCC4WOhNXj8VNlgyYIYgZgaZSB43Z9af7K9Mrfk
	M4H/3AsPd20IQmbKFpJ6TTXK1ZKRZmE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-8d0N5j6CMwOkhenMLVanyA-1; Tue, 31 Oct 2023 13:43:24 -0400
X-MC-Unique: 8d0N5j6CMwOkhenMLVanyA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-408374a3d6bso40584355e9.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774203; x=1699379003;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iUnO9/SZ6ap+H+Ma/kTTfFeGQM3g1ED274282AbLD1g=;
        b=Tdpj7tazrTidukEAYzK2RdZnDtXgb8DDaemziSTyUzbGtCGjOis2u3yb3ja2OPOdww
         +JMXmZFbNsSxBb9Gj5y4PWfg6QIKCgf01zJXchQI9ZEaRGJufitQTxfBIVfHBwJY5vXh
         P9dl/w86A6b0tamC02q4UGabIwusEVa22Mek4bblEz0ROIvXGet/ZKWPUOFZQV6WNVNv
         aC8XBZ+5fxyFEf2Zkkpb5evEh1voCSsLJHfapEQMHNNrgmDEuG6k1uFmn3AyMpRTQiL5
         A0+JYzJm7RZ7t3rJ0F8BkKrXvusaE7xxGEhKcwWdXi7EM5H2j1LIjVyU4p7daGFniP90
         +YOg==
X-Gm-Message-State: AOJu0YybJgDEW5XpgVv6iAXN/w7zG8Kd22yzgfYPwaS74Jz3LSZGqUZ1
	tOc1HNWNyArb3ElNvxSS3XoFLOBhXvlzLsh1UN4wLuLcmFzchT/NAi5HB9zoF3a0Lawqf2wwHD3
	UebSB2jBmjzwW
X-Received: by 2002:a05:6000:1566:b0:32f:92f3:dbbb with SMTP id 6-20020a056000156600b0032f92f3dbbbmr2910205wrz.70.1698774203078;
        Tue, 31 Oct 2023 10:43:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8rn9CSehfODrcFmZD5QheiiN4lzDXyj4HypO00ymz85ULxp1cgvjUsluFYDBcQidkpb8kqw==
X-Received: by 2002:a05:6000:1566:b0:32f:92f3:dbbb with SMTP id 6-20020a056000156600b0032f92f3dbbbmr2910191wrz.70.1698774202709;
        Tue, 31 Oct 2023 10:43:22 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id t1-20020a05600001c100b0032415213a6fsm1984587wrx.87.2023.10.31.10.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:43:22 -0700 (PDT)
Message-ID: <0ad2b2b4d394ca4c8b805535444f97db4e9cc690.camel@redhat.com>
Subject: Re: [PATCH v6 01/25] x86/fpu/xstate: Manually check and add
 XFEATURE_CET_USER xstate bit
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:43:20 +0200
In-Reply-To: <20230914063325.85503-2-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-2-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
> reflect true dependency between CET features and the xstate bit, instead
> manually check and add the bit back if either SHSTK or IBT is supported.
> 
> Both user mode shadow stack and indirect branch tracking features depend
> on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
> 
> Although in real world a platform with IBT but no SHSTK is rare, but in
> virtualization world it's common, guest SHSTK and IBT can be controlled
> independently via userspace app.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index cadf68737e6b..12c8cb278346 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -73,7 +73,6 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>  	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>  	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>  	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
> -	[XFEATURE_CET_USER]			= X86_FEATURE_SHSTK,
>  	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>  	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>  };
> @@ -798,6 +797,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>  			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>  	}
>  
> +	/*
> +	 * Manually add CET user mode xstate bit if either SHSTK or IBT is
> +	 * available. Both features depend on the xstate bit to save/restore
> +	 * CET user mode state.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
> +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
> +
>  	if (!cpu_feature_enabled(X86_FEATURE_XFD))
>  		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>  


The goal of the xsave_cpuid_features is to disable xfeature state bits which are enabled
in CPUID, but their parent feature bit (e.g X86_FEATURE_AVX512) is disabled in CPUID, 
something that should not happen on real CPU, but can happen if the user explicitly
disables the feature on the kernel command line and/or due to virtualization.

However the above code does the opposite, it will enable XFEATURE_CET_USER xsaves component,
when in fact, it might be disabled in the CPUID (and one can say that in theory such
configuration is even useful, since the kernel can still context switch CET msrs manually).


So I think that the code should do this instead:

if (!boot_cpu_has(X86_FEATURE_SHSTK) && !boot_cpu_has(X86_FEATURE_IBT))
 	fpu_kernel_cfg.max_features &= ~BIT_ULL(XFEATURE_CET_USER);


Best regards,
	Maxim Levitsky





