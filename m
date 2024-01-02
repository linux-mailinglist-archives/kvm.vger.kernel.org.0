Return-Path: <kvm+bounces-5473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C55558224C9
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C6E6B223A3
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9533517734;
	Tue,  2 Jan 2024 22:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PDuM+ksa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7294A171CE
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 22:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704234822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aklVF7gjNm9HsKz2eLpKYn2+4/LCvjSC9f8idLQqBwU=;
	b=PDuM+ksa51u9roAHB/58zWE97j5B5hnbhIWYdWWX+VDxuV2hwe8jukavM8JgX94aTDx4fr
	flFDzQDfBYV8xgWa2NMqYxX6qmWHJwIi68RPg4FG+huxdduRXm2V/bTvw/74L+YIQlk/fi
	qIWIfeLCiu4XyQwjeYv9y9rVYwxtBDk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-kZ24kaAvOOOVQVYKKCD6gQ-1; Tue, 02 Jan 2024 17:33:40 -0500
X-MC-Unique: kZ24kaAvOOOVQVYKKCD6gQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40d5aa2f118so54641315e9.3
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 14:33:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704234819; x=1704839619;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aklVF7gjNm9HsKz2eLpKYn2+4/LCvjSC9f8idLQqBwU=;
        b=A1i3EHXUguoJ8m1V+muj/tDjRjYYEE3h04+G1gzRhqe27FUKQKADl8/2WHkUIMIplB
         MyIp62Px2CUn7AlDeQqhAG6zuHKN93LoUuNtUDQ1o1jRYQthXabLP7OFrFf9POJMxfNZ
         1pBpq9wJsnk0Yq0O33Fs9KOHPeG/yHurcWSETIY9sovmYDGyTJNdtOGx7ByOGq4oJep4
         hEXP5BCyZ9JRJmWJrcLsPX1IuE40nCfWmaulLbGmS0v6fgp5XLDdhAVJTpEPXZCWVGB7
         Zh+X6w0Myvlu3wcxrKJV+/m6ej2bWMSnow1XtHlUQgcHsi99fvjXh2QVmsQXMelwkdbq
         3DbA==
X-Gm-Message-State: AOJu0YxN9+mvA/P90SDacO+FCBlQzWCrWGe/5zrQgV8SU8l9sZGL45DK
	Eb+3mmbLRzsgaanMUXbsE8M4rvodOMXC+y847CYqaTn6msILGzRkpS3BvgXwoJTPifqj5NZdOjF
	UASsEGS4tB6ggKkKNk9fS
X-Received: by 2002:a05:600c:63c7:b0:40d:8550:6da1 with SMTP id dx7-20020a05600c63c700b0040d85506da1mr2625839wmb.104.1704234819496;
        Tue, 02 Jan 2024 14:33:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEP+ifXi2AaCGdMILtyHdCX4h+k0iH8Rm/5PBnxhsG/Z7budk55fKYLg324JnH5Cc+F9rB64g==
X-Received: by 2002:a05:600c:63c7:b0:40d:8550:6da1 with SMTP id dx7-20020a05600c63c700b0040d85506da1mr2625829wmb.104.1704234819169;
        Tue, 02 Jan 2024 14:33:39 -0800 (PST)
Received: from starship ([147.235.223.38])
        by smtp.gmail.com with ESMTPSA id p13-20020a5d48cd000000b00336898daceasm28659613wrs.96.2024.01.02.14.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 14:33:38 -0800 (PST)
Message-ID: <2e41d4d07007bdae6f1f05eb6d487a9aa4a42eb5.camel@redhat.com>
Subject: Re: [PATCH v8 08/26] KVM: x86: Rework cpuid_get_supported_xcr0() to
 operate on vCPU data
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Wed, 03 Jan 2024 00:33:36 +0200
In-Reply-To: <20231221140239.4349-9-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-9-weijiang.yang@intel.com>
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
> From: Sean Christopherson <seanjc@google.com>
> 
> Rework and rename cpuid_get_supported_xcr0() to explicitly operate on
> vCPU state, i.e. on a vCPU's CPUID state, now that the only usage of
> the helper is to retrieve a vCPU's already-set CPUID.
> 
> Prior to commit 275a87244ec8 ("KVM: x86: Don't adjust guest's CPUID.0x12.1
> (allowed SGX enclave XFRM)"), KVM incorrectly fudged guest CPUID at runtime,
> which in turn necessitated massaging the incoming CPUID state for
> KVM_SET_CPUID{2} so as not to run afoul of kvm_cpuid_check_equal().
> I.e. KVM also invoked cpuid_get_supported_xcr0() with the incoming CPUID
> state, and thus without an explicit vCPU object.
> 
> Opportunistically move the helper below kvm_update_cpuid_runtime() to make
> it harder to repeat the mistake of querying supported XCR0 for runtime
> updates.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 33 ++++++++++++++++-----------------
>  1 file changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 294e5bd5f8a0..624954203b40 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -247,21 +247,6 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
>  		vcpu->arch.pv_cpuid.features = best->eax;
>  }
>  
> -/*
> - * Calculate guest's supported XCR0 taking into account guest CPUID data and
> - * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
> - */
> -static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
> -{
> -	struct kvm_cpuid_entry2 *best;
> -
> -	best = cpuid_entry2_find(entries, nent, 0xd, 0);
> -	if (!best)
> -		return 0;
> -
> -	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
> -}
> -
>  static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
>  				       int nent)
>  {
> @@ -312,6 +297,21 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>  
> +/*
> + * Calculate guest's supported XCR0 taking into account guest CPUID data and
> + * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
> + */
> +static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpuid_entry2 *best;
> +
> +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
> +	if (!best)
> +		return 0;
> +
> +	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
> +}
> +
>  static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
>  {
>  #ifdef CONFIG_KVM_HYPERV
> @@ -361,8 +361,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		kvm_apic_set_version(vcpu);
>  	}
>  
> -	vcpu->arch.guest_supported_xcr0 =
> -		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
> +	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
>  
>  	kvm_update_pv_runtime(vcpu);
>  

Looks like I forgot to add my reviewed-by:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


