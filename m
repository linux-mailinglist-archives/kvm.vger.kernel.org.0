Return-Path: <kvm+bounces-225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BEDA7DD577
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:51:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CE5D1C20CA1
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44DDC20B37;
	Tue, 31 Oct 2023 17:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QjFk2tQk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95C220322
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:51:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CCFC2
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SueeyoA5l3+NPz+H4PFR4IPPiYp17+NNZKETDXfz4I=;
	b=QjFk2tQkzF+zEMkAOKucPqp9rbupwd+Xkr1LM211+0sYWeVDsqZ6ORpFsDvS6lHvB4EmRJ
	pzZpwnmcD99D9ZleQxMSfAIXedo8x2sSalzSNO+5WizlpfXr3gJDWc+q7IXJW9PT1YlvMq
	tBSGDJ/ksP34/NMqeIbef+6uL/hNXzw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-vXAk3WdzPbmnWG2NYOJ61A-1; Tue, 31 Oct 2023 13:51:17 -0400
X-MC-Unique: vXAk3WdzPbmnWG2NYOJ61A-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-32de95ec119so2983868f8f.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:51:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774676; x=1699379476;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8SueeyoA5l3+NPz+H4PFR4IPPiYp17+NNZKETDXfz4I=;
        b=q3XeaBiJiouLGSjhpdMpXRD1iY1vl25MGtOZBT95Whp2/pHbnG0Zhe5WsdcJYLcaWC
         ID28tTRuXrD4ouJyQpb/4j05W4vZ5tZJyWo60RleYIF0Qxd4nkiFKcA+6k53tThum24g
         LaHoDCU17naBRfDVW7O/imVScrKDQoU/jK8yDE9z+h56jp3sGff1SSklsptBagE2d7FI
         hJ61Uu0m2273waeC13hynHjBzdDjbWLkcZrAqjyvLKRtcaxqBCN8x3B0Kk1I0LctqToD
         FUWAkRBskyRGN5V6Fav0DIC0T7MAoclOUhACCHN/O4VauietJHhiM6v3FDKCdsSX9vu0
         JrjA==
X-Gm-Message-State: AOJu0Yy1E5faW21C2HxR7dUByJeSC/krChAHFQ+j7osUjiu6H3HeaQWO
	LG0RaEIAYJWt02Y0MOSq4vqutGyKK4VLYiJyMYv9bu/c0Efhdug3u9C7DyZ1iiaqH+elTwrQ0YR
	tkZiI7vLWsXjt
X-Received: by 2002:a5d:47af:0:b0:32f:8085:73f8 with SMTP id 15-20020a5d47af000000b0032f808573f8mr6478774wrb.18.1698774676363;
        Tue, 31 Oct 2023 10:51:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkCbM75bWqZ+oLxgMQHEz9Csq8A+q8FpCePzqItnI8N2+bPrxGlu1MWWo57WPrcTxgXvbQpA==
X-Received: by 2002:a5d:47af:0:b0:32f:8085:73f8 with SMTP id 15-20020a5d47af000000b0032f808573f8mr6478757wrb.18.1698774676021;
        Tue, 31 Oct 2023 10:51:16 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d5447000000b003176c6e87b1sm2018881wrv.81.2023.10.31.10.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:51:15 -0700 (PDT)
Message-ID: <3f704ac87db03493a1d1bf8b7ae74b5a586ddbaf.camel@redhat.com>
Subject: Re: [PATCH v6 13/25] KVM: x86: Initialize kvm_caps.supported_xss
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:51:13 +0200
In-Reply-To: <20230914063325.85503-14-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-14-weijiang.yang@intel.com>
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
> Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
> XSAVES is supported. host_xss contains the host supported xstate feature
> bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
> enabled XSS feature bits, the resulting value represents the supervisor
> xstates that are available to guest and are backed by host FPU framework
> for swapping {guest,host} XSAVE-managed registers/MSRs.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/x86.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a616d84bd39..66edbed25db8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -226,6 +226,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>  				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>  
> +#define KVM_SUPPORTED_XSS     0
> +
>  u64 __read_mostly host_efer;
>  EXPORT_SYMBOL_GPL(host_efer);
>  
> @@ -9515,12 +9517,13 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>  		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
>  	}
> +	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
> +		rdmsrl(MSR_IA32_XSS, host_xss);
> +		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
> +	}
>  
>  	rdmsrl_safe(MSR_EFER, &host_efer);
>  
> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
> -		rdmsrl(MSR_IA32_XSS, host_xss);
> -
>  	kvm_init_pmu_capability(ops->pmu_ops);
>  
>  	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





