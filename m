Return-Path: <kvm+bounces-5468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7709A8224B4
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:25:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81B211C22CA0
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9F417995;
	Tue,  2 Jan 2024 22:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="grqLAdEn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053A017984
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 22:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704234289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CYn/vUM+/4R41HRwQ17+oVSWatSqLcOgnz5S4r/6JAc=;
	b=grqLAdEnKi5sHwKjdLVrmIZHZlhPyta1TYXG8GRXRfasCYdJqE2b0VD3xAIIzmb+gFkHCF
	+qdjori3eIp9jRvbyZKCiVJUYaJLn1Y1eljX+w0XHFfCnNgzjbhlhJStMV0U5Uw2hkreE/
	Dlj+iFIxCDI9YdPaGiYi8g52mealqlw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-j6C-ssUbODKAyC-yXO5OWw-1; Tue, 02 Jan 2024 17:24:47 -0500
X-MC-Unique: j6C-ssUbODKAyC-yXO5OWw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40d5aa2f118so54604465e9.3
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 14:24:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704234286; x=1704839086;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CYn/vUM+/4R41HRwQ17+oVSWatSqLcOgnz5S4r/6JAc=;
        b=Osls7SyhbIzdpps2agQLY/XhEH+wxc9zEvtb4YHPzCdNOFkyRANZm2VCAZIQrmB2VD
         yTWen3O3YQn2yZCdlRhmh7/VizU1dM1FBPqV8PwEJSXvWGSL4X31japXv7daNwOUoyEN
         F8x8XMU/3vNT2CKdYmXXAre+lvoyhBunKNwOGDRRE2Lc0D18sc46kAcPfSjCs1vOW8HV
         kowvvAJ2dCiUU/EpgrBh7oHAvCmx9lt5ZgRYL2TFn2UCPDRLeDv1mF+p5nBalrvr8gA2
         GXh8ACudRX3l0XFdr7uqol54Yy3j7fIyuIo6rZHF+tFSri5eCa+Vaw9BG5kWztezi0kf
         aa+A==
X-Gm-Message-State: AOJu0YxhOTAGndQ4U7Wbzv54X7fqZVNgB/JKaXnqyUA1u7lP1ELnUTSC
	emUepP5JJemkAB8nhrCznOQiUy0okZzbp8qloWxpoMzgszJ4h3s1A8x/7vq3CU5bd68xN/av17O
	qe8jAy29wNzbuldAPouMe
X-Received: by 2002:a05:600c:2d84:b0:40b:5e59:ccb3 with SMTP id i4-20020a05600c2d8400b0040b5e59ccb3mr9117483wmg.148.1704234286762;
        Tue, 02 Jan 2024 14:24:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGeyAavm14jo8VNBn/kNdwGw8it5/6egahtSIt52ZS26oNudQ7lKvGR/SHjdeWVOyqjyvX3Dg==
X-Received: by 2002:a05:600c:2d84:b0:40b:5e59:ccb3 with SMTP id i4-20020a05600c2d8400b0040b5e59ccb3mr9117479wmg.148.1704234286495;
        Tue, 02 Jan 2024 14:24:46 -0800 (PST)
Received: from starship ([147.235.223.38])
        by smtp.gmail.com with ESMTPSA id w13-20020a05600c474d00b0040c46719966sm315706wmo.25.2024.01.02.14.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 14:24:46 -0800 (PST)
Message-ID: <5c71c27f0730fc6edcf7d19036d1226786c30364.camel@redhat.com>
Subject: Re: [PATCH v8 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Wed, 03 Jan 2024 00:24:44 +0200
In-Reply-To: <20231221140239.4349-3-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-3-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
> Remove XFEATURE_CET_USER entry from dependency array as the entry doesn't
> reflect true dependency between CET features and the user xstate bit.
> Enable the bit in fpu_kernel_cfg.max_features when either SHSTK or IBT is
> available.
> 
> Both user mode shadow stack and indirect branch tracking features depend
> on XFEATURE_CET_USER bit in XSS to automatically save/restore user mode
> xstate registers, i.e., IA32_U_CET and IA32_PL3_SSP whenever necessary.
> 
> Note, the issue, i.e., CPUID only enumerates IBT but no SHSTK is resulted
> from CET KVM series which synthesizes guest CPUIDs based on userspace
> settings,in real world the case is rare. In other words, the existing
> dependency check is correct when only user mode SHSTK is available.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/kernel/fpu/xstate.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index 07911532b108..f6b98693da59 100644
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
> +	 * CET user mode xstate bit has been cleared by above sanity check.
> +	 * Now pick it up if either SHSTK or IBT is available. Either feature
> +	 * depends on the xstate bit to save/restore user mode states.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT))
> +		fpu_kernel_cfg.max_features |= BIT_ULL(XFEATURE_CET_USER);
> +

I am still not convinced that this is not a workaround for a bug in the sanity check code,
and I don't really like this, but whatever, as long as the code works, 
I don't intend to fight over this. Let it be.

Best regards,
	Maxim Levitsky


>  	if (!cpu_feature_enabled(X86_FEATURE_XFD))
>  		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>  





