Return-Path: <kvm+bounces-1045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B867C7E4823
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:21:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 481A1B20D04
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA870358B0;
	Tue,  7 Nov 2023 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LVqt+a62"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39136358A5
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:21:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993C4125
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699381293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sds6ydhRM76Ih9NP6DrxTnDzxVIOrfMyTi3/n3q+3yY=;
	b=LVqt+a62bcIuVAzIAatrnomWyRy+MGcCSk9yUyifn4yy0Gt3jMq+LuED51tX6XXGJ/zLzU
	UEHYX0BVzv9EqrnqODzOwCmOgsnxdR3xPYmqxXX1S8YPr3q9tJWl4zjR8T9n8dcodirJ9m
	Yx8ZqCMUREXITtfHx5uP4VH0vlcwf9Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-Hpd4APL9OimVpF6zzJJfUg-1; Tue, 07 Nov 2023 13:21:31 -0500
X-MC-Unique: Hpd4APL9OimVpF6zzJJfUg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32d9602824dso2877405f8f.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:21:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699381290; x=1699986090;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sds6ydhRM76Ih9NP6DrxTnDzxVIOrfMyTi3/n3q+3yY=;
        b=NhLBUUGB658IYm1HRT6CkNGDmEnrnMvutrv4L6rosT0DHleOG0SvpdvImWeuw5s7X2
         RYneqKJ1H+3slHijhuv/wY/Gpghep5OQIfv365Qsin9SbwzfC6WrAYjEmgSt1BMJMztE
         z2PrB1vqyP04AIjQnAVb6P7G+NTlHL5cSosSvbn4uqYoAYYrTNVu0zUv8wVvlYDT8ubZ
         rVy/Yd/yVIz7r983YpvQzJgqdHoEqhbtPLzeUI+KQkVUru5wHXZkSQDmXUHT/WOBAMLF
         jzyzO0bE+Iuc5h5jrECMYDYa5EKEdDmSkC8MuAMIzBIdzR4U+PS4AeXOOsqkULJ7gvY7
         OWjQ==
X-Gm-Message-State: AOJu0YwWDBF+FRF3mp+G1nMArCODjuoedcurCGWWCFGucGP0Vbw1hxrM
	y4FRkMaAlGNBdDuhesv+lFXdziCwQ8zu7Lt3IaqDsi902ZUKRj8ntpLTK8c/GkL+xG5w6t31A+z
	CHWfwtBxjs7Sb
X-Received: by 2002:a05:6000:2a5:b0:32f:7a65:da66 with SMTP id l5-20020a05600002a500b0032f7a65da66mr27671103wry.44.1699381289935;
        Tue, 07 Nov 2023 10:21:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuznJxNynYkO9slS06rtEpCayJe6NLTZJfhoJ6OrUX+1CrJPkYh3L0/eC7XadqoE3XJkKvxg==
X-Received: by 2002:a05:6000:2a5:b0:32f:7a65:da66 with SMTP id l5-20020a05600002a500b0032f7a65da66mr27671093wry.44.1699381289690;
        Tue, 07 Nov 2023 10:21:29 -0800 (PST)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id d2-20020adfe2c2000000b00327cd5e5ac1sm3022535wrj.1.2023.11.07.10.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:21:29 -0800 (PST)
Message-ID: <66b737135fd8a12f8b79ef22a9b1cef8f9c56496.camel@redhat.com>
Subject: Re: [PATCH 07/14] KVM: x86: hyper-v: Introduce
 kvm_hv_nested_transtion_tlb_flush() helper
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Nov 2023 20:21:27 +0200
In-Reply-To: <20231025152406.1879274-8-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
	 <20231025152406.1879274-8-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-10-25 at 17:23 +0200, Vitaly Kuznetsov wrote:
> As a preparation to making Hyper-V emulation optional, introduce a helper
> to handle pending KVM_REQ_HV_TLB_FLUSH requests.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.h     | 12 ++++++++++++
>  arch/x86/kvm/svm/nested.c | 10 ++--------
>  arch/x86/kvm/vmx/nested.c | 10 ++--------
>  3 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index ddb1d0b019e6..75dcbe598fbc 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -246,6 +246,18 @@ static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu)
>  	return kvm_hv_get_assist_page(vcpu);
>  }
>  
> +static inline void kvm_hv_nested_transtion_tlb_flush(struct kvm_vcpu *vcpu, bool tdp_enabled)
> +{
> +	/*
> +	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
> +	 * L2's VP_ID upon request from the guest. Make sure we check for
> +	 * pending entries in the right FIFO upon L1/L2 transition as these
> +	 * requests are put by other vCPUs asynchronously.
> +	 */
> +	if (to_hv_vcpu(vcpu) && tdp_enabled)
> +		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +}
> +
>  int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
>  
>  #endif
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 3fea8c47679e..74c04102ef01 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -487,14 +487,8 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
>  
>  static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
>  {
> -	/*
> -	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
> -	 * L2's VP_ID upon request from the guest. Make sure we check for
> -	 * pending entries in the right FIFO upon L1/L2 transition as these
> -	 * requests are put by other vCPUs asynchronously.
> -	 */
> -	if (to_hv_vcpu(vcpu) && npt_enabled)
> -		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +	/* Handle pending Hyper-V TLB flush requests */
> +	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
>  
>  	/*
>  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c5ec0ef51ff7..382c0746d069 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1139,14 +1139,8 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> -	/*
> -	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
> -	 * L2's VP_ID upon request from the guest. Make sure we check for
> -	 * pending entries in the right FIFO upon L1/L2 transition as these
> -	 * requests are put by other vCPUs asynchronously.
> -	 */
> -	if (to_hv_vcpu(vcpu) && enable_ept)
> -		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +	/* Handle pending Hyper-V TLB flush requests */
> +	kvm_hv_nested_transtion_tlb_flush(vcpu, enable_ept);
>  
>  	/*
>  	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


