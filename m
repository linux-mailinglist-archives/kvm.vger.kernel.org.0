Return-Path: <kvm+bounces-224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37C597DD528
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E500C2818A9
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC15521A0C;
	Tue, 31 Oct 2023 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bPG+0UEj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBA320B10
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:47:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6DF91
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YGq193LtBbfYWxLteF7JwAWgv8pm+P/KLCPfheg7LiM=;
	b=bPG+0UEjEiNIVIGJcZITx11IdEwypuks6RPExjojxkbZ3GCkVsuOAvX7GGdA+4LXk5CnGC
	otAZrCjko6HfHmeLKgRQKsi5IYD68US8HaUQQUB3inyRA6yMKvVTHCBtcSWkLo5gyPS82D
	lUi2O0GIQegK0k3aEvMv69cqjkTOq5E=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-X-VD8LpUMAqdGT0i__cgxA-1; Tue, 31 Oct 2023 13:47:22 -0400
X-MC-Unique: X-VD8LpUMAqdGT0i__cgxA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-507c4c57567so6391143e87.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:47:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774441; x=1699379241;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YGq193LtBbfYWxLteF7JwAWgv8pm+P/KLCPfheg7LiM=;
        b=aMfChqgxq0UIC0KZvhP7l/gUZG8YeuI3sX1tW/XstVuDuI59LWHGaYyuifQMg7fJrH
         Gza73cuM9AkamIxu8/+mhcy+0ILzkYmBEd9KQG63EXu+xVlzSMoIOc274kgXzBE7pyhr
         BXBACgahCW37QxoBAhnPrMar8mYDRgX/JMKYtBYw+PQZ3O8XXaZ5VEkXbj95x24EHJ+x
         //GeuG9dP+dwe70jz0ZkSR4vlog7GxE/bPiOOzMExdvD64rHZavCCYtwXkc9c+XAT7NV
         xmQNl78/RN7KPEB5LjTIWFCrERoWJRKuPM4/JDdr3qPq/+DJgsym1DmiSgUDvp5t2LXH
         zM9A==
X-Gm-Message-State: AOJu0YwAsEfFF5+dWoMmSvknAxq4jr96VHinz87kRkIabzL9brDeKyko
	uVyECQfTWl+S65I7xAhiHp7bif5w7Dppzuo+AO01V6SlbEhZ21XayOzm0a2JTUb2olsN0+UqNyZ
	FocnEeBfuqUDX
X-Received: by 2002:a19:a411:0:b0:502:fff9:64da with SMTP id q17-20020a19a411000000b00502fff964damr9806287lfc.53.1698774441070;
        Tue, 31 Oct 2023 10:47:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHr4+e3yKcsTlIJFrosy++mDAX9Uum8J6H9NAhaA9CLQBuU5y9jo8eO0pSEv7wj5sQ4lmH25Q==
X-Received: by 2002:a19:a411:0:b0:502:fff9:64da with SMTP id q17-20020a19a411000000b00502fff964damr9806266lfc.53.1698774440720;
        Tue, 31 Oct 2023 10:47:20 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id b17-20020a5d4b91000000b0032dba85ea1bsm2012068wrt.75.2023.10.31.10.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:47:20 -0700 (PDT)
Message-ID: <e10fb116aa67509f7a63660a6b0731e28935c820.camel@redhat.com>
Subject: Re: [PATCH v6 11/25] KVM: x86: Report XSS as to-be-saved if there
 are supported features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:47:18 +0200
In-Reply-To: <20230914063325.85503-12-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-12-weijiang.yang@intel.com>
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
> From: Sean Christopherson <seanjc@google.com>
> 
> Add MSR_IA32_XSS to list of MSRs reported to userspace if supported_xss
> is non-zero, i.e. KVM supports at least one XSS based feature.


I can't believe that CET is the first supervisor feature that KVM supports...

Ah, now I understand why:

1. XSAVES on AMD can't really be intercepted (other than clearing CR4.OSXSAVE bit, which isn't an option if you want to support AVX for example)
   On VMX however you can intercept XSAVES and even intercept it only when it touches specific bits of state that you don't want the guest to read/write
   freely.

2. Even if it was possible to intercept it, guests use XSAVES on every context switch if available and emulating it might be costly.

3. Emulating XSAVES is also not that easy to do correctly.

However XSAVES touches various MSRs, thus letting the guest use it unintercepted means giving access to host MSRs,
which might be wrong security wise in some cases.

Thus I see that KVM hardcodes the IA32_XSS to 0, and that makes the XSAVES work exactly like XSAVE.

And for some features which would benefit from XSAVES state components,
KVM likely won't even be able to do so due to this limitation.
(this is allowed thankfully by the CPUID), forcing the guests to use rdmsr/wrmsr instead.


However it is possible to enable IA32_XSS bits in case the msrs XSAVES reads/writes can't do harm to the host, and then KVM
can context switch these MSRs when the guest exits and that is what is done here with CET.

If you think that a short summary of the above can help the future reader to understand why IA32_XSS support is added only now,
it might be a good idea to add a few lines to the changelog of this patch.

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/x86.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0b55c043dab..1258d1d6dd52 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1464,6 +1464,7 @@ static const u32 msrs_to_save_base[] = {
>  	MSR_IA32_UMWAIT_CONTROL,
>  
>  	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
> +	MSR_IA32_XSS,
>  };
>  
>  static const u32 msrs_to_save_pmu[] = {
> @@ -7195,6 +7196,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>  		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
>  			return;
>  		break;
> +	case MSR_IA32_XSS:
> +		if (!kvm_caps.supported_xss)
> +			return;
> +		break;
>  	default:
>  		break;
>  	}


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky






