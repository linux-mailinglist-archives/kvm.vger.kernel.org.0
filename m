Return-Path: <kvm+bounces-3006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9BA7FFAE3
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:11:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB6981C211D0
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8955FF16;
	Thu, 30 Nov 2023 19:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjHKIPkI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDD810F1
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701371465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EkCMhFpiP/sdJl9nslDpr6bpl6B4gQB+ldegoyD9sYM=;
	b=WjHKIPkItRT5SF2RkACAkXeQgPi4ZqgagY18eYHIIElArWH3vvMZf0OqID5AiGU8yrKmoi
	JjfXrZMqNxUUt3SQVF158OXJqucOSCBgM2Zp/1M5Gkh+0n1DXNyM2618QmCtAnyFPwYLb0
	tYB2JcCuSTJzDkNoMRYB9/7BLuorHtQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-cWeYNq3lMPqBUO9_bRGKhg-1; Thu, 30 Nov 2023 14:11:04 -0500
X-MC-Unique: cWeYNq3lMPqBUO9_bRGKhg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2c9cc4f6972so9172011fa.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:11:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701371461; x=1701976261;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EkCMhFpiP/sdJl9nslDpr6bpl6B4gQB+ldegoyD9sYM=;
        b=QkkFNr578vblxNkxgq4WZX8EDAkFErUApQw56vKFvdvxlCHJcNuf0PvBO0ZuLmqJ9c
         8IS6cXZORYtyT4E9yXLB6xM2IBuGjefrZTLfhh4B5Ffq3IwkGHL71iQSQgVd1QczDMpg
         82dZQBxRvR+yHhUDUNefwDsFlZyujWzN/K8l/npjoTqPOPk75zbZlxyZb1Cpud3zIqj9
         e+1YSdYgkhyZYYhWdV5OV8dOT2yeoAUtU3k46tqdorsojMN6RZur4/qliknYGrYzVS9i
         UV+UGTSrQ39S4AeDWi0yZBmpXpWpjry2/cJ0DGc8fHIetq9xf1iNrWmkSo7v7FNCQuUd
         jEBg==
X-Gm-Message-State: AOJu0YwqkiSd746EIjqoNwo9OJucYT2hYEcIEa1aRWJ70/uLOrguB43o
	jcioolIHb1kAvZet20V9uaNDrZg/3sjS+9qkOCgzE0Xsky+7y8Qfqpq030nN2jxgX/5TUFY8PX8
	TohRVHBYa79YnEHP9YuO9
X-Received: by 2002:a2e:2e05:0:b0:2c9:d5bc:d1e6 with SMTP id u5-20020a2e2e05000000b002c9d5bcd1e6mr2360lju.44.1701371460402;
        Thu, 30 Nov 2023 11:11:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFza7U9/12615LfgTxmIGc5pXDaVHNaln+IrotDbqNHf6KkGfPK0Mfevm8RZ3Mrmt9N20hCeA==
X-Received: by 2002:ac2:5397:0:b0:50a:40b6:2d37 with SMTP id g23-20020ac25397000000b0050a40b62d37mr2940lfh.40.1701365203737;
        Thu, 30 Nov 2023 09:26:43 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id v10-20020a19740a000000b00507977e9a38sm209487lfe.35.2023.11.30.09.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:26:43 -0800 (PST)
Message-ID: <c22d17ab04bf5f27409518e3e79477d579b55071.camel@redhat.com>
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:26:40 +0200
In-Reply-To: <20231124055330.138870-3-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-3-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
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
> settings,in real world the case is rare. In other words, the exitings
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
> index 73f6bc00d178..6e50a4251e2b 100644
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
>  	if (!cpu_feature_enabled(X86_FEATURE_XFD))
>  		fpu_kernel_cfg.max_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>  

I am curious:

Any reason why my review feedback was not applied even though you did agree
that it is reasonable?


https://lore.kernel.org/lkml/c72dfaac-1622-94cf-a81d-9d7ed81b2f55@intel.com/

Best regards,
	Maxim Levitsky


