Return-Path: <kvm+bounces-2017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3167F081A
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 18:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 568D21C20846
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 17:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9082D1945C;
	Sun, 19 Nov 2023 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GEF40cfK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B9E11D
	for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700415186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bGwBPAT+9iPn9FyAJmqTJpBz0lhkFdp1EboyOFP7JO8=;
	b=GEF40cfKl2dF5X42fRCBbUbFD8VPH5+g0ib6EkNobuZ2+v7u1VVXTTmDl7fZt78dUtoK+9
	sy2LvoUWo/sWJ5hJiFKuPPcFFvvHBnkvZ/zTntVoV1SLk/7MfqN1KLVo+gvt91AoQRLkB5
	0WQQxzsHDD+vW80VpEchwfLQ6mUkgWo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-uAq_WxArOTaAGcunjHmPKg-1; Sun, 19 Nov 2023 12:33:05 -0500
X-MC-Unique: uAq_WxArOTaAGcunjHmPKg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40a3efec9a7so8642125e9.1
        for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:33:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700415184; x=1701019984;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bGwBPAT+9iPn9FyAJmqTJpBz0lhkFdp1EboyOFP7JO8=;
        b=jnAcQ5HMIL0/gVBEEcSLh0m8TB18MrPxcP5ENEavNhEdAV1QodMEIlLEyETXf+6Hol
         Kqv5tMtzBr7/RpvbnieeI4FsQjXf04/qygJltcyk7P6BbEhJhUpVzGlGNd0xsW+j9uv1
         oUR+T2KEn7duRVQvHgdNvGcPNIy14shy4GXC+Pp0O3rn9oFZzI0x30pxQxs5HvN0/vCa
         iWO/Ek4g41KP2qycZjOiKj4lkD3YglbApzMHwstwZ0Zoe+ibfUzPVL9KbcIUx+EW2oz7
         xMGbTL/NOR1LLndp/LxjZ11hVtws6NSWYxk7obgiXAo9FU2tnf/Um3JtV7E24fLz6AZW
         /arw==
X-Gm-Message-State: AOJu0YzkTRL06ufe1rHWlWfmDWLdE16pw75EKpne7/dOGWf7vfKTuz23
	83iIDPyryBe56iVtXbJi48NFx2UvauHTfOa74Fa/Wo4kMcd+gkNQwGRFEDx0Q99B653OBHgYvYC
	ubbH8Dei3PQkNukjiUGPp
X-Received: by 2002:a05:600c:1c85:b0:405:39b4:3145 with SMTP id k5-20020a05600c1c8500b0040539b43145mr4342323wms.2.1700415183964;
        Sun, 19 Nov 2023 09:33:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHEwowleSE1HT+eTey8xjaU0nHGjxwnEn4bjwoQAHpzSw+fIjq/Rrupk3zgDka3oUADjycGyw==
X-Received: by 2002:a05:600c:1c85:b0:405:39b4:3145 with SMTP id k5-20020a05600c1c8500b0040539b43145mr4342311wms.2.1700415183630;
        Sun, 19 Nov 2023 09:33:03 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id l6-20020a5d5606000000b00331698cb263sm8361056wrv.103.2023.11.19.09.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 09:33:03 -0800 (PST)
Message-ID: <8c518aae88a6db2347813985ea4e7c2ccee585da.camel@redhat.com>
Subject: Re: [PATCH 4/9] KVM: x86: Avoid double CPUID lookup when updating
 MWAIT at runtime
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Nov 2023 19:33:01 +0200
In-Reply-To: <20231110235528.1561679-5-seanjc@google.com>
References: <20231110235528.1561679-1-seanjc@google.com>
	 <20231110235528.1561679-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> Move the handling of X86_FEATURE_MWAIT during CPUID runtime updates to
> utilize the lookup done for other CPUID.0x1 features.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5cf3d697ecb3..6777780be6ae 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -276,6 +276,11 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  
>  		cpuid_entry_change(best, X86_FEATURE_APIC,
>  			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> +
> +		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> +			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> +					   vcpu->arch.ia32_misc_enable_msr &
> +					   MSR_IA32_MISC_ENABLE_MWAIT);
>  	}
>  
>  	best = cpuid_entry2_find(entries, nent, 7, 0);
> @@ -296,14 +301,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>  		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
>  		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
> -
> -	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
> -		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> -		if (best)
> -			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> -					   vcpu->arch.ia32_misc_enable_msr &
> -					   MSR_IA32_MISC_ENABLE_MWAIT);
> -	}
>  }
>  
>  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


