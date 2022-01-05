Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C084F485A6D
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 22:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244337AbiAEVJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 16:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244334AbiAEVJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 16:09:18 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F8EC061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 13:09:18 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso4168729pjm.4
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 13:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0iyAXlgHwtdqwZs9XS4BcUOoOXGf2dlrNrwEOliwxsM=;
        b=eB2Jlp+s/XG6hiEZlAj7p/pCThrVr7OZHBjuBseFXUeBi0o7Gd0w2lfVWkWTzg16Gd
         kfffceXKmMTx4/pdkKJz7trBIwkww/9Ys+fzS6C/G4zkvNytiv2bEoRVQsKwZK19hddw
         FTyz75KK2UcMr8zSx0+m9rmqwKZuNcU4X/UOrlBJ5zpfyls0gwMLXdlpkoOb/1myHyaT
         VPuIRTuucXDUz5NdOrDjaHOf7NPSwE5XiBkOKDNRMgnSVnKDSm0xjbRopSGBfA0k5wBG
         EA+ZXXbWFFc5EY6N7x68tTM3g3owU57mAvshN409LoXh4LN/SztpiY276aWfGntxTeY5
         mGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0iyAXlgHwtdqwZs9XS4BcUOoOXGf2dlrNrwEOliwxsM=;
        b=AWb+fDKARh3JlJeoT3x3z1O+UwZZdbXZVkC4+ezTmLDJhLv6ABJQHe7v2AiifqIK4p
         buCAaAVLvrG+cEanMbEBI2ZwkmgbWXRkJsjzvSY/BqVRsxlK5NYrHHrHIGCeMew83wJ7
         J0MPKTWxSIQUZwuJNaShF+S4/F5uIdRuF8Tx9fJV5T0tREFc9+UaIPdLRAiFYXvPJDCN
         Zssvo+0iC++FpOZR6ur6DmirrzRRsgLLRsNDQryAmLZ9lGvJh15arFMm6bBvUZi5rxh2
         Nt1D21Ahbdo797guyU0oBLxbo7DNm6It2WdhBJYrd6624zJvS5aYdPsqpCoasEV0oh7D
         tEYg==
X-Gm-Message-State: AOAM531zAA8z5eR/wWqmcUlHUhecED5zK/eEQ0a7JHhVmoWdNTeN3U71
        KBfKo92xejy5WwwgSxYTs5JUag==
X-Google-Smtp-Source: ABdhPJzPLJD1Dm1hba3BUJSJPotIbPOs24yIMTb14I7Zmfr3EpfIos423kbLAbEeYFdmZmlN5TKBPw==
X-Received: by 2002:a17:90b:1b0d:: with SMTP id nu13mr6167455pjb.231.1641416957384;
        Wed, 05 Jan 2022 13:09:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k3sm37677056pgq.54.2022.01.05.13.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 13:09:16 -0800 (PST)
Date:   Wed, 5 Jan 2022 21:09:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] KVM: x86/pmu: Make top-down.slots event
 unavailable in supported leaf
Message-ID: <YdYI+chaa6DsImb0@google.com>
References: <20220105050711.67280-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105050711.67280-1-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> When we choose to disable the fourth fixed counter TOPDOWN.SLOTS,
> we need to also reduce the length of the 0AH.EBX bit vector, which
> enumerates architecture performance monitoring events, and set
> 0AH.EBX.[bit 7] to 1 if the new value of EAX[31:24] is still > 7.
> 
> Fixes: 2e8cd7a3b8287 ("kvm: x86: limit the maximum number of vPMU fixed counters to 3")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/cpuid.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0b920e12bb6d..1f0131145296 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -782,6 +782,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		eax.split.mask_length = cap.events_mask_len;
>  
>  		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
> +
> +		/*
> +		 * The 8th Intel pre-defined architectural event (Topdown Slots) will be supported
> +		 * if the 4th fixed counter exists && EAX[31:24] > 7 && EBX[7] = 0.

Please wrap at ~80 chars.

> +		 *
> +		 * Currently, KVM needs to set EAX[31:24] < 8 or EBX[7] == 1
> +		 * to make this event unavailable in a consistent way.
> +		 */
> +		if (edx.split.num_counters_fixed < 4) {
> +			if (eax.split.mask_length > 7)
> +				eax.split.mask_length--;

This will break if there's a bit>7 enumerated in EBX (events_mask) that KVM wants
to expose to the guest.  It doesn't cause problems today because bits 31:8 are all
reserved, but that will not always be the case.

We could do

		if (edx.split.num_counters_fixed < 4) {
			if (eax.split.mask_length == 7)
				eax.split.mask_length--;
			else
				cap.events_mask |= BIT_ULL(7);
		}

but I don't see any reason to make this more complex than:

		if (edx.split.num_counters_fixed < 4 &&
		    eax.split.mask_length > 7)
			cap.events_mask |= BIT_ULL(7);

> +			if (eax.split.mask_length > 7)
> +				cap.events_mask |= BIT_ULL(7);
> +		}
> +
>  		edx.split.bit_width_fixed = cap.bit_width_fixed;
>  		if (cap.version)
>  			edx.split.anythread_deprecated = 1;
> -- 
> 2.33.1
> 
