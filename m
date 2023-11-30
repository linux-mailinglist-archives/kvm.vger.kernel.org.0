Return-Path: <kvm+bounces-2996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5017FF90E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:08:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44AC7281754
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB8C59153;
	Thu, 30 Nov 2023 18:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NNVIzMuy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE3010EF
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701367696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vg7FQUhH1bp/4aBDJKaF0HS+7XR0RmUcrDXUDZg2Qqw=;
	b=NNVIzMuyFuCQpxr78w6jhYLNtylBOUZwHt587Ve9GOKRRdk0C9jSqZwXpZRWhwKQWg7RaU
	/MkHQ9FJlO+oVN66+DKWxVs56GWp/5KK9m3LdJQ1OTiUsYao3IZkcMX/o93VTD/drz7yI2
	3UbclSu106Q5r/8ZS9rPyUZwFVDcQ9c=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-n8FoQSV5NFeZcB42Uq0JBA-1; Thu, 30 Nov 2023 13:08:14 -0500
X-MC-Unique: n8FoQSV5NFeZcB42Uq0JBA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-50bc42e2bffso1581862e87.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:08:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701367691; x=1701972491;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vg7FQUhH1bp/4aBDJKaF0HS+7XR0RmUcrDXUDZg2Qqw=;
        b=mPWK266yMc1CCaqOQAHpopUlfllcJrfEn1aX0qVYCfCFc5K3AOlscTuQ87yhYtAXor
         6bnCRgD/DnMJLsqZDg94tkBtQfZXJI8ELNrx22H0ruMegloSOkoQgDQhM7m7a0ulglgQ
         dlx/m8GNt9zZT0iaakrPvhkZGuiK22gwTYDiC/VkoOuBveW0aXrUhEDiXmaL/Ic7LWkz
         tQBpkES0uKqSWUauMoGARmHaD4xZbLdsItUG5YTcvAs8UD5UErBKry0mZ8isbm19bChe
         /YdMPLZBiaXfprgBCHUSYlAAYa8fbfSwlf1cdcRaTy/AxHvE5Gc1UqmVS53NrC7fx0Ce
         zcRQ==
X-Gm-Message-State: AOJu0YxG58kjOvbvbrS07ot+euliu8+hqVwkdjJBchky9/yllVBscEIf
	pZmnH72g0HETGOjE7V9uR3liJ9OQNcjB3Q+5aqj+ie2vf/VDxcvabBm+p0FA74OcS2nDTF1CNjy
	r2BLuhvlsO1Xc6d8De5dQ
X-Received: by 2002:a50:d6d7:0:b0:54a:f86f:669e with SMTP id l23-20020a50d6d7000000b0054af86f669emr47636edj.18.1701365641672;
        Thu, 30 Nov 2023 09:34:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpDjeF/sufV646oy68VsCAXZtRSgpL2qetDDSjPs2/Nq5Eagnb89phtm84qwH2mKTnZJMOUQ==
X-Received: by 2002:a19:f805:0:b0:50b:c6c7:a777 with SMTP id a5-20020a19f805000000b0050bc6c7a777mr21212lff.41.1701365586343;
        Thu, 30 Nov 2023 09:33:06 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id cf31-20020a056512281f00b0050bc6bd5231sm212171lfb.253.2023.11.30.09.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:33:05 -0800 (PST)
Message-ID: <3c16bb90532fbd2ec95b5a3d42a93bbbf77c4d37.camel@redhat.com>
Subject: Re: [PATCH v7 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Thu, 30 Nov 2023 19:33:03 +0200
In-Reply-To: <20231124055330.138870-5-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-5-weijiang.yang@intel.com>
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
> Define new XFEATURE_MASK_KERNEL_DYNAMIC set including the features can be

I am not sure though that this name is correct, but I don't know if I can
suggest a better name.

> optionally enabled by kernel components, i.e., the features are required by
> specific kernel components. Currently it's used by KVM to configure guest
> dedicated fpstate for calculating the xfeature and fpstate storage size etc.
> 
> The kernel dynamic xfeatures now only contain XFEATURE_CET_KERNEL, which is
> supported by host as they're enabled in xsaves/xrstors operating xfeature set
> (XCR0 | XSS), but the relevant CPU feature, i.e., supervisor shadow stack, is
> not enabled in host kernel so it can be omitted for normal fpstate by default.
> 
> Remove the kernel dynamic feature from fpu_kernel_cfg.default_features so that
> the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors can be
> optimized by HW for normal fpstate.
> 
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/fpu/xstate.h | 5 ++++-
>  arch/x86/kernel/fpu/xstate.c      | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
> index 3b4a038d3c57..a212d3851429 100644
> --- a/arch/x86/include/asm/fpu/xstate.h
> +++ b/arch/x86/include/asm/fpu/xstate.h
> @@ -46,9 +46,12 @@
>  #define XFEATURE_MASK_USER_RESTORE	\
>  	(XFEATURE_MASK_USER_SUPPORTED & ~XFEATURE_MASK_PKRU)
>  
> -/* Features which are dynamically enabled for a process on request */
> +/* Features which are dynamically enabled per userspace request */
>  #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
>  
> +/* Features which are dynamically enabled per kernel side request */

I suggest to explain this a bit better. How about something like that:

"Kernel features that are not enabled by default for all processes, but can
be still used by some processes, for example to support guest virtualization"

But feel free to keep it as is or propose something else. IMHO this will
be confusing this way or another.


Another question: kernel already has a notion of 'independent features'
which are currently kernel features that are enabled in IA32_XSS but not present in 'fpu_kernel_cfg.max_features'

Currently only 'XFEATURE_LBR' is in this set. These features are saved/restored manually
from independent buffer (in case of LBRs, perf code cares for this).

Does it make sense to add CET_S to there as well instead of having XFEATURE_MASK_KERNEL_DYNAMIC, and maybe rename the
'XFEATURE_MASK_INDEPENDENT' to something like 'XFEATURES_THE_KERNEL_DOESNT_CARE_ABOUT'
(terrible name, but you might think of a better name)


> +#define XFEATURE_MASK_KERNEL_DYNAMIC	XFEATURE_MASK_CET_KERNEL
> +
>  /* All currently supported supervisor features */
>  #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
>  					    XFEATURE_MASK_CET_USER | \
> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index b57d909facca..ba4172172afd 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -824,6 +824,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>  	/* Clean out dynamic features from default */
>  	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>  	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> +	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;
>  
>  	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>  	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;



Best regards,
	Maxim Levitsky




