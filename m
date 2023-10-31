Return-Path: <kvm+bounces-232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E324A7DD592
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9807D2818E8
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41BC2136B;
	Tue, 31 Oct 2023 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aFPnW+xu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BB1210F1
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:54:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA26113
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HoYxQsWM95/556mkX4Vbf+MlD34BoItbzU2fJF3frwU=;
	b=aFPnW+xu/Uabzs75pnJ4TuhnPEnz4tCCIq+kOpAgzNnRoAKxX4wms6qeWWZPHqiK1+a/3m
	Hyk3xFJj3daHrW+sIs9dUgtoT7h5ZEqH7YY9iT322+X2fzt1FXXnvz8/VH4mXttYAnwMu2
	Xunv9SAKvVLb2uPHloEDzlFaQ/mPgjc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-v0o91dfvOW2gGcdaZUeG9A-1; Tue, 31 Oct 2023 13:54:19 -0400
X-MC-Unique: v0o91dfvOW2gGcdaZUeG9A-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4094cc441baso9784125e9.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774857; x=1699379657;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HoYxQsWM95/556mkX4Vbf+MlD34BoItbzU2fJF3frwU=;
        b=V0pRv9RdnR3P1zZFBQIj4Z7ZOt9CHSNFzIXVqUfbA4PVPrK9HA68zTE6tHDYPgH3qS
         qIzZOnL4CRsLCj6rVJ+S3BF3cBaEBRviG8rhcL2XIXFRkGHPHiUssUN2eBlduT+r/nvV
         hwPTPnetYTBFpAuo+KLCvsELLm0HFzuL4PfcNZG2jCFdEzmWvVpPs54I1frV32aoA0eU
         TKljCVj8PgDc+lqo/ykNOQ7w/9iNDyqnQGeQ5oZhhpxwPjTE96a37QbCN/70HoaKytHe
         2yx0FdpnffkyD6FL7xwQbyfUCYKzf3G+VympbayRlo5Jnup8+zdRLK6gVHdAuWM+3txE
         MJTA==
X-Gm-Message-State: AOJu0YwayWhshGIyzxhbRABjSA/knH7BTN71hYLkeZXkjdZ4N/x8aZId
	G5uoLxV7188xZtWXGe8wnOPw9/xVlgoSNXdf0CnLxsZeFV9gZwefMUGTdXwAxHVCO223KqGuf1v
	L/6SHhnaUg4Vq
X-Received: by 2002:a05:600c:1991:b0:405:7400:1e3d with SMTP id t17-20020a05600c199100b0040574001e3dmr10727053wmq.32.1698774856951;
        Tue, 31 Oct 2023 10:54:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpmxtFKyrQGGtwocdWDBt4yMlZH69my0R5jpaCJjj/hvgJHUZ5cgByh0t/kUqJK8bTs+NG9Q==
X-Received: by 2002:a05:600c:1991:b0:405:7400:1e3d with SMTP id t17-20020a05600c199100b0040574001e3dmr10727029wmq.32.1698774856589;
        Tue, 31 Oct 2023 10:54:16 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id o8-20020adfe808000000b0031980294e9fsm2004208wrm.116.2023.10.31.10.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:54:16 -0700 (PDT)
Message-ID: <ea3609bf7c7759b682007042b98191d91d10a751.camel@redhat.com>
Subject: Re: [PATCH v6 18/25] KVM: x86: Use KVM-governed feature framework
 to track "SHSTK/IBT enabled"
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:54:14 +0200
In-Reply-To: <20230914063325.85503-19-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-19-weijiang.yang@intel.com>
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
> Use the governed feature framework to track whether X86_FEATURE_SHSTK
> and X86_FEATURE_IBT features can be used by userspace and guest, i.e.,
> the features can be used iff both KVM and guest CPUID can support them.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/governed_features.h | 2 ++
>  arch/x86/kvm/vmx/vmx.c           | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> index 423a73395c10..db7e21c5ecc2 100644
> --- a/arch/x86/kvm/governed_features.h
> +++ b/arch/x86/kvm/governed_features.h
> @@ -16,6 +16,8 @@ KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
>  KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
>  KVM_GOVERNED_X86_FEATURE(VGIF)
>  KVM_GOVERNED_X86_FEATURE(VNMI)
> +KVM_GOVERNED_X86_FEATURE(SHSTK)
> +KVM_GOVERNED_X86_FEATURE(IBT)
>  
>  #undef KVM_GOVERNED_X86_FEATURE
>  #undef KVM_GOVERNED_FEATURE
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9409753f45b0..fd5893b3a2c8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7765,6 +7765,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
>  
>  	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
> +	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_IBT);
>  
>  	vmx_setup_uret_msrs(vmx);
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


PS: IMHO The whole 'governed feature framework' is very confusing and somewhat poorly documented.

Currently the only partial explanation of it, is at 'governed_features', which doesn't
explain how to use it.

For the reference this is how KVM expects governed features to be used in the common case
(there are some exceptions to this but they are rare)

1. If a feature is not enabled in host CPUID or KVM doesn't support it, 
   KVM is expected to not enable it in KVM cpu caps.

2. Userspace uploads guest CPUID.

3. After the guest CPUID upload, the vendor code calls kvm_governed_feature_check_and_set() which sets
	governed features = True iff feature is supported in both kvm cpu caps and in guest CPUID.

4. kvm/vendor code uses 'guest_can_use()' to query the value of the governed feature instead of reading
guest CPUID.

It might make sense to document the above somewhere at least.

Now about another thing I am thinking:

I do know that the mess of boolean flags that svm had is worse than these governed features and functionality wise these are equivalent.

However thinking again about the whole thing: 

IMHO the 'governed features' is another quite confusing term that a KVM developer will need to learn and keep in memory.

Because of that, can't we just use guest CPUID as a single source of truth and drop all the governed features code?

In most cases, when the governed feature value will differ from the guest CPUID is when a feature is enabled in the guest CPUID,
but not enabled in the KVM caps.

I do see two exceptions to this: XSAVES on AMD and X86_FEATURE_GBPAGES, in which the opposite happens,
governed feature is enabled, even when the feature is hidden from the guest CPUID, but it might be
better from
readability wise point, to deal with these cases manually and we unlikely to have many new such cases in the future.

So for the common case of CPUID mismatch, when the governed feature is disabled but guest CPUID is enabled,
does it make sense to allow this? 

Such a feature which is advertised as supported but not really working is a recipe of hard to find guest bugs IMHO.

IMHO it would be much better to just check this condition and do kvm_vm_bugged() or something in case when a feature
is enabled in the guest CPUID but KVM can't support it, and then just use guest CPUID in 'guest_can_use()'.

Best regards,
	Maxim Levitsky







