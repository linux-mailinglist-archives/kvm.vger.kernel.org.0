Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB75152A0C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 12:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgBELmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 06:42:04 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23491 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725385AbgBELmE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 06:42:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580902923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jpUu4fMYbDbSNsl7P/RwPZTrmlpIgKsPg3QXKvzeK4Q=;
        b=bTNOZXtfRX9ifVla79NgPB/6692811XpJmrNBDZyPTcCYFGeh2SkyRbfsn5dBVjO6VAHo0
        /t3eimSKz2b8viiGgErieK9LRvJeBxVaBfauJ9n0dLBeheIKSK8yBAh9s5qdhQ68aWnTlq
        lOYArDxpeRGLMC/z0HZV0EO/ruMea24=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-QNTrSiTaMKy0QULRE_ugSA-1; Wed, 05 Feb 2020 06:42:01 -0500
X-MC-Unique: QNTrSiTaMKy0QULRE_ugSA-1
Received: by mail-wr1-f72.google.com with SMTP id j4so1051177wrs.13
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 03:42:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jpUu4fMYbDbSNsl7P/RwPZTrmlpIgKsPg3QXKvzeK4Q=;
        b=MP9QgXA0kn2s1N8QpXmt8j34V3mVvbqVZZSoO8XeHbrRJAVo+CqOvfT910BJLnpYIE
         guWkI5fwR+e1BUJRR4HL0n5nEckmYACKKUKuaVwToAcVfk4/FXJ3su5K08iqLOBrrnYp
         9z9QjoBFHtY8UwdulzD43tLUQ/1Xdvf4vUjdBvPPOAewYKPOM+j481Zd94ydAslYZGz2
         /lIPqH6SJL7lKg7eWiGv947vxScDvIvTWxM5awidv298kVRViZToCLVx/O5rCm29UMIR
         7WuSVVzTgr/j34Gn4cgmSU0RFPYEIAJ3b+j1pDLQJrolimUX0TwTKXbqsMukwM03dHDj
         opYQ==
X-Gm-Message-State: APjAAAV5E2lLCc4f3fa2Y/CfVAG2X7EBReCoCoOST0dk5VrP4K5mMOe7
        ETLX+/z7/yAc+i1xlCLxfTCGbIwP9Q5+Ur8B+7dnyXHy9aXNa6R40o0wrX9fVX/6X8ZNXWsqvLA
        awDV+vwSDT5lm
X-Received: by 2002:a05:600c:2042:: with SMTP id p2mr5543394wmg.79.1580902920343;
        Wed, 05 Feb 2020 03:42:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqzcY862LI5mYgTkhraujvfi3KdcZ5/gHdSqKm5EAl0UKiDZrq9uLi0a2BXur+Fx4gZ1M2Q6Ag==
X-Received: by 2002:a05:600c:2042:: with SMTP id p2mr5543379wmg.79.1580902920147;
        Wed, 05 Feb 2020 03:42:00 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x132sm8880748wmg.0.2020.02.05.03.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 03:41:59 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Fix the name for the SMEP CPUID bit
In-Reply-To: <20200204175034.18201-1-sean.j.christopherson@intel.com>
References: <20200204175034.18201-1-sean.j.christopherson@intel.com>
Date:   Wed, 05 Feb 2020 12:41:58 +0100
Message-ID: <871rr9mfax.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Fix the X86_FEATURE_* name for SMEP, which is incorrectly named
> X86_FEATURE_INVPCID_SINGLE and is a wee bit confusing when looking at
> the SMEP unit tests.
>
> Note, there is no INVPCID_SINGLE CPUID bit, the bogus name likely came
> from the Linux kernel, which has a synthetic feature flag for
> INVPCID_SINGLE in word 7, bit 7 (CPUID 0x7.EBX is stored in word 9).
>
> Fixes: 6ddcc29 ("kvm-unit-test: x86: Implement a generic wrapper for cpuid/cpuid_indexed functions")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  lib/x86/processor.h | 2 +-
>  x86/access.c        | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 7057180..03fdf64 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -138,7 +138,7 @@ static inline u8 cpuid_maxphyaddr(void)
>  #define	X86_FEATURE_XMM2		(CPUID(0x1, 0, EDX, 26))
>  #define	X86_FEATURE_TSC_ADJUST		(CPUID(0x7, 0, EBX, 1))
>  #define	X86_FEATURE_HLE			(CPUID(0x7, 0, EBX, 4))
> -#define	X86_FEATURE_INVPCID_SINGLE	(CPUID(0x7, 0, EBX, 7))
> +#define	X86_FEATURE_SMEP	        (CPUID(0x7, 0, EBX, 7))
>  #define	X86_FEATURE_INVPCID		(CPUID(0x7, 0, EBX, 10))
>  #define	X86_FEATURE_RTM			(CPUID(0x7, 0, EBX, 11))
>  #define	X86_FEATURE_SMAP		(CPUID(0x7, 0, EBX, 20))
> diff --git a/x86/access.c b/x86/access.c
> index 5233713..7303fc3 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -860,7 +860,7 @@ static int check_smep_andnot_wp(ac_pool_t *pool)
>  	ac_test_t at1;
>  	int err_prepare_andnot_wp, err_smep_andnot_wp;
>  
> -	if (!this_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
> +	if (!this_cpu_has(X86_FEATURE_SMEP)) {
>  	    return 1;
>  	}
>  
> @@ -955,7 +955,7 @@ static int ac_test_run(void)
>  	}
>      }
>  
> -    if (!this_cpu_has(X86_FEATURE_INVPCID_SINGLE)) {
> +    if (!this_cpu_has(X86_FEATURE_SMEP)) {
>  	tests++;
>  	if (set_cr4_smep(1) == GP_VECTOR) {
>              successes++;

"No functional change intended" :-)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

