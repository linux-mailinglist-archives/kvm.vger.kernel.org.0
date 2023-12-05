Return-Path: <kvm+bounces-3563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C553B8053CA
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:06:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F0202817D2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048695ABB4;
	Tue,  5 Dec 2023 12:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ftlyBZR2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9419113
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 04:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701777966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gLQBzFrGAwHxvXK/ZG9NaPPTM+NhimNuV2r2+MSj3NI=;
	b=ftlyBZR2FLO5Y3zAKUh1cywe7QWeAhTVYfM4/K574O9FCNKBp9E/iwE+ch0Zl913JCjnzq
	fSbfrOQc0vg2LURSxNX7IRTlhwRJXerGmEPvMKychh4eVbQiUSETq17GgQ8bEVF+mOiHmu
	ycR11PRY0ZJGavhb5g2sSacuhMhup28=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-CRtrspL9Oj-8fqafV8pXWQ-1; Tue, 05 Dec 2023 07:06:03 -0500
X-MC-Unique: CRtrspL9Oj-8fqafV8pXWQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3335df64539so312301f8f.3
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 04:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701777962; x=1702382762;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gLQBzFrGAwHxvXK/ZG9NaPPTM+NhimNuV2r2+MSj3NI=;
        b=VTV1HWUSc7zoKidItqei9xpyq08+his4TJoveBWe8kLm3UQl0xMLkn51AI9/gSZ8tU
         7Ken5GMNwphc0GA+Wp3c6ynXf6n9HHqpGD4CQyXAQl/8W3mmAyvBGyDJ0lOLHmGMd0kQ
         V8311z4mqjCuavfogfUKj3RhndEvboj54WaScE5ie1/hc2MwuPsiUl64lZMQAKUGjDKE
         kfzbyXuQan4OyGbzwsdubO8aQOQoyQhotfleb4dCX3limIEMLxQVOJnDE9vCRNeF3cJi
         iavlh/Howrdx5QGzxdZQEvwXoFhPCIVFa7lWHDb/v5h3TEuTABMWKHtluOxeNr14uMfc
         3ZXw==
X-Gm-Message-State: AOJu0Yxm+OUzGcNNg0MZ7M1bBFlWtItEjAFD9rL2ngdWXp13nNWhb1D8
	qzz2IBOLuvpINifOqnPhDT8hdJLFZ52wthiNWZJ6rXPN5heuXrj5u/KmlmmkW5qrH6nop0Afvtm
	VI3xrkLrtjPDB
X-Received: by 2002:adf:fdcc:0:b0:332:fd68:6657 with SMTP id i12-20020adffdcc000000b00332fd686657mr2991738wrs.56.1701777961906;
        Tue, 05 Dec 2023 04:06:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBrA0d52Py0zl0DkG0g7Ozkl9cNsZiQl5RA5UryUTAXd9eUBrE9D6LQdrH2w9+XMQYtnR54A==
X-Received: by 2002:adf:fdcc:0:b0:332:fd68:6657 with SMTP id i12-20020adffdcc000000b00332fd686657mr2991730wrs.56.1701777961633;
        Tue, 05 Dec 2023 04:06:01 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id g18-20020a5d6992000000b003333abf3edfsm8875966wru.47.2023.12.05.04.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 04:06:01 -0800 (PST)
Message-ID: <24a1d40e2c084546b349f595ad3f89689c8e9a47.camel@redhat.com>
Subject: Re: [PATCH v2 08/16] KVM: x86: hyper-v: Split off
 nested_evmcs_handle_vmclear()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Date: Tue, 05 Dec 2023 14:06:00 +0200
In-Reply-To: <20231205103630.1391318-9-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
	 <20231205103630.1391318-9-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-12-05 at 11:36 +0100, Vitaly Kuznetsov wrote:
> To avoid overloading handle_vmclear() with Hyper-V specific details and to
> prepare the code to making Hyper-V emulation optional, create a dedicated
> nested_evmcs_handle_vmclear() helper.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 38 ++++++++++++++++++++++++--------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 382c0746d069..903b6f9ea2bd 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -243,6 +243,29 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vmptr)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	/*
> +	 * When Enlightened VMEntry is enabled on the calling CPU we treat
> +	 * memory area pointer by vmptr as Enlightened VMCS (as there's no good
> +	 * way to distinguish it from VMCS12) and we must not corrupt it by
> +	 * writing to the non-existent 'launch_state' field. The area doesn't
> +	 * have to be the currently active EVMCS on the calling CPU and there's
> +	 * nothing KVM has to do to transition it from 'active' to 'non-active'
> +	 * state. It is possible that the area will stay mapped as
> +	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
> +	 */
> +	if (!guest_cpuid_has_evmcs(vcpu) ||
> +	    !evmptr_is_valid(nested_get_evmptr(vcpu)))
> +		return false;
> +
> +	if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr)
> +		nested_release_evmcs(vcpu);
> +
> +	return true;
> +}
> +
>  static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
>  				     struct loaded_vmcs *prev)
>  {
> @@ -5286,18 +5309,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>  	if (vmptr == vmx->nested.vmxon_ptr)
>  		return nested_vmx_fail(vcpu, VMXERR_VMCLEAR_VMXON_POINTER);
>  
> -	/*
> -	 * When Enlightened VMEntry is enabled on the calling CPU we treat
> -	 * memory area pointer by vmptr as Enlightened VMCS (as there's no good
> -	 * way to distinguish it from VMCS12) and we must not corrupt it by
> -	 * writing to the non-existent 'launch_state' field. The area doesn't
> -	 * have to be the currently active EVMCS on the calling CPU and there's
> -	 * nothing KVM has to do to transition it from 'active' to 'non-active'
> -	 * state. It is possible that the area will stay mapped as
> -	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
> -	 */
> -	if (likely(!guest_cpuid_has_evmcs(vcpu) ||
> -		   !evmptr_is_valid(nested_get_evmptr(vcpu)))) {
> +	if (likely(!nested_evmcs_handle_vmclear(vcpu, vmptr))) {
>  		if (vmptr == vmx->nested.current_vmptr)
>  			nested_release_vmcs12(vcpu);
>  
> @@ -5314,8 +5326,6 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>  					   vmptr + offsetof(struct vmcs12,
>  							    launch_state),
>  					   &zero, sizeof(zero));
> -	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
> -		nested_release_evmcs(vcpu);
>  	}
>  
>  	return nested_vmx_succeed(vcpu);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky


