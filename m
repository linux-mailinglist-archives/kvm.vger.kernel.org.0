Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDB15337C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgBEO4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:56:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47985 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbgBEO4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 09:56:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580914605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqRN+O/HKVxSNVUucT6huyoj2+tbJesfpGIf63dxO6M=;
        b=Ng2AyYgApj4OgOlU1AckKQt1Jvp0QYtllD8RS7Ion8uuiWn1JJZaU7bkxOvnrKoAzn1XNt
        /mDXo2Gmn9HrJR0YanX2H+RgFJTYhpM3rnU8jPTM/B0NJXOoELdQfJmX2gO5DxmtNeJSL8
        kw5Po/ncEPsikkymaoDTAWEWr98+nEQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-8M7E71OKORucbv-GSkqrkQ-1; Wed, 05 Feb 2020 09:56:44 -0500
X-MC-Unique: 8M7E71OKORucbv-GSkqrkQ-1
Received: by mail-wm1-f69.google.com with SMTP id p26so1103262wmg.5
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:56:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qqRN+O/HKVxSNVUucT6huyoj2+tbJesfpGIf63dxO6M=;
        b=h4IgS7OjBGT/78gkynJm21xiKlUTUW5KQKQl974IPh04DaE+ZuMH/+U1ds3WU2RSnT
         vd+LBKBLG03R2OFwcJJok8I4auTTxG+Nl1kLxZcsu5KGeV8++jOhGfZBN4UKFbip8jJw
         k1ewuyHhEkJFQHeVQgP/8lHKJBob2CSXJE+DhfXU1D9iPhmTam6I40my52mfhdtTUfsp
         YExgksDn8DINR8HIipGnduLOd1vTMxLTKTLSuNOIQDirMO8NxG9ZGRbCVkI9FtRUKp/5
         0Ce8s5ZGmDi0feiRXb41rJSPKKg2NlIceyI6+DgZScNXarywkIf1sM7GMdufyAN25uU5
         FIqw==
X-Gm-Message-State: APjAAAUv4xpfFDqbMPXknhYkGtGwMyOVDeQqBy3fROzbviSs5+Jwcfel
        k9DUJugPgtuqLuV85NULwhBWp3dUfWm1HVbToAe/yvQBxUfE2TZF82jZflULo0CuWGhmWl72hGW
        1sMAAjmKLdsuY
X-Received: by 2002:a7b:c209:: with SMTP id x9mr821334wmi.0.1580914602598;
        Wed, 05 Feb 2020 06:56:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqyCwuRnRjldkua6i2sYsmllZTK3xrIyn1JRc2cw4rkE9nYLTgI3YyShHyZzq+v+Siqkwqfqnw==
X-Received: by 2002:a7b:c209:: with SMTP id x9mr821333wmi.0.1580914602240;
        Wed, 05 Feb 2020 06:56:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56? ([2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56])
        by smtp.gmail.com with ESMTPSA id s139sm8464403wme.35.2020.02.05.06.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 06:56:41 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: Fix the name for the SMEP CPUID bit
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200204175034.18201-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5a12d565-4243-1e9c-ff1e-fcf962733648@redhat.com>
Date:   Wed, 5 Feb 2020 15:56:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200204175034.18201-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/20 18:50, Sean Christopherson wrote:
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
> 

Queued, thanks.

Paolo

