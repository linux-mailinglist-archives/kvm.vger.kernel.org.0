Return-Path: <kvm+bounces-1048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1A97E4831
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4685281369
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A11D358B3;
	Tue,  7 Nov 2023 18:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fl5LXkaG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D60234CFD
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:24:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C172B0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699381439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Fa7TX1dpbFH/Zga8tQtJE/RfR0M2MgCr3mjwgTk8t8=;
	b=Fl5LXkaGck37DFxwivAL2IyHnWFRVAQ4qL6nyxdSKNw+Q3QvGQ/mslhhgi42t5XFGkYvHf
	jzKNSkkyHd3e84XfnuqzFiDzcHrmusokHTHL3LVqGtQE5V3SkJW8Nol0qkNh9CuXyBow9U
	zcI8ZrhRnkXczmp4Gaox4+kpuOFJKMk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-K9o0x6dRM7-AdSHpmzwUIQ-1; Tue, 07 Nov 2023 13:23:58 -0500
X-MC-Unique: K9o0x6dRM7-AdSHpmzwUIQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4090fa518bbso39952005e9.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:23:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699381437; x=1699986237;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Fa7TX1dpbFH/Zga8tQtJE/RfR0M2MgCr3mjwgTk8t8=;
        b=XCMHrmxWt+It7diK/LEtzjSNKe4aS+iZlkCOS03an4i9OswZicnBsd8QzNisrcRGd1
         pofgyUJWEm/a5DJfCRxgxDVuytOC9/1VkgFyJs0RBmO6xFQkUMjZkzO01TBrNPZnuIWq
         1asHPBFKvkXl87/Wqvr0i+e/atmAd25AEqT6hk4LmQdiYQB4JbWeXAuzP8LSb5u1dFI3
         ly5Yye5okxMG9piLrEvmYR8QRbZhWxR3iFU2uJ86BWv4y4bfC9v47gKEZGATAD7+MY34
         hcqBzhYtjL7VQVbsuV5WLiNJ+ytVN9PBqxaTfniFwxPlkJXYFf57HWbSgBZzTHmrcwrJ
         qRZA==
X-Gm-Message-State: AOJu0YzClHHiSdaB1z3cYYnTZOgl+zSi1qwDWigO1/pCVwCOyj4UEgUo
	E6RNMvBZTkL5Aj3UnMf1m8U4pu7ynEmJnkP/hKlWDbCo9Acnhd5z0Ucwl9zwrNcpUTdqMGk0Syi
	I6M7rwCGrmD7k
X-Received: by 2002:adf:ecc9:0:b0:31f:ffd1:6cf4 with SMTP id s9-20020adfecc9000000b0031fffd16cf4mr24244597wro.12.1699381437640;
        Tue, 07 Nov 2023 10:23:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFOtFN7OscvQ1twrJ8oLPMfSY0r0hR/w6/F5GYecbQ+YusNKtCVkEmYXnc5fkUoq9po9cma5Q==
X-Received: by 2002:adf:ecc9:0:b0:31f:ffd1:6cf4 with SMTP id s9-20020adfecc9000000b0031fffd16cf4mr24244585wro.12.1699381437298;
        Tue, 07 Nov 2023 10:23:57 -0800 (PST)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id e12-20020adffd0c000000b0032d893d8dc8sm3045610wrr.2.2023.11.07.10.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:23:57 -0800 (PST)
Message-ID: <449d3b0506dbab0ec6c397de778addde02ef19f0.camel@redhat.com>
Subject: Re: [PATCH 09/14] KVM: selftests: Fix vmxon_pa == vmcs12_pa ==
 -1ull vmx_set_nested_state_test for !eVMCS case
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Nov 2023 20:23:55 +0200
In-Reply-To: <20231025152406.1879274-10-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
	 <20231025152406.1879274-10-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-10-25 at 17:24 +0200, Vitaly Kuznetsov wrote:
> The "vmxon_pa == vmcs12_pa == -1ull" test happens to work by accident: as
> Enlightened VMCS is always supported, set_default_vmx_state() adds
> 'KVM_STATE_NESTED_EVMCS' to 'flags' and the following branch of
> vmx_set_nested_state() is executed:
> 
>         if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
>             (!guest_can_use(vcpu, X86_FEATURE_VMX) ||
>              !vmx->nested.enlightened_vmcs_enabled))
>                         return -EINVAL;
> 
> as 'enlightened_vmcs_enabled' is false. In fact, "vmxon_pa == vmcs12_pa ==
> -1ull" is a valid state when not tainted by wrong flags so the test should
> aim for this branch:
> 
>         if (kvm_state->hdr.vmx.vmxon_pa == INVALID_GPA)
>                 return 0;
> 
> Test all this properly:
> - Without KVM_STATE_NESTED_EVMCS in the flags, the expected return value is
> '0'.
> - With KVM_STATE_NESTED_EVMCS flag (when supported) set, the expected
> return value is '-EINVAL' prior to enabling eVMCS and '0' after.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../kvm/x86_64/vmx_set_nested_state_test.c       | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> index 41ea7028a1f8..67a62a5a8895 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
> @@ -125,21 +125,25 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
>  
>  	/*
>  	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
> -	 * setting the nested state but flags other than eVMCS must be clear.
> -	 * The eVMCS flag can be set if the enlightened VMCS capability has
> -	 * been enabled.
> +	 * setting the nested state. When the eVMCS flag is not set, the
> +	 * expected return value is '0'.
>  	 */
>  	set_default_vmx_state(state, state_sz);
> +	state->flags = 0;
>  	state->hdr.vmx.vmxon_pa = -1ull;
>  	state->hdr.vmx.vmcs12_pa = -1ull;
> -	test_nested_state_expect_einval(vcpu, state);
> +	test_nested_state(vcpu, state);
>  
> -	state->flags &= KVM_STATE_NESTED_EVMCS;
> +	/*
> +	 * When eVMCS is supported, the eVMCS flag can only be set if the
> +	 * enlightened VMCS capability has been enabled.
> +	 */
>  	if (have_evmcs) {
> +		state->flags = KVM_STATE_NESTED_EVMCS;
>  		test_nested_state_expect_einval(vcpu, state);
>  		vcpu_enable_evmcs(vcpu);
> +		test_nested_state(vcpu, state);
>  	}
> -	test_nested_state(vcpu, state);
>  
>  	/* It is invalid to have vmxon_pa == -1ull and SMM flags non-zero. */
>  	state->hdr.vmx.smm.flags = 1;


Makes sense, but I am not 100% sure that I haven't missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


