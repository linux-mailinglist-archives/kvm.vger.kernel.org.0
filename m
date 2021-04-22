Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5790368300
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 17:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237797AbhDVPIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 11:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237781AbhDVPIj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 11:08:39 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49972C06138D
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 08:08:03 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id j7so23627231pgi.3
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 08:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Oihop7JLhBVaA4GdmD12GWAGpSdFMpgp2Nm7icLJcM0=;
        b=Z6L09iP0KOHbFoUbH1jfA1pVZsLLCAS6Sf3f8881hysiqAhsbSq7V4v9VkZZxNn9kK
         zfIs3dH2fyGLFc7KUmOOZMtiCy+BnSlZbhET50zkO5SN2ATaiiFnFPBRS93LQL5XUTtb
         OC8ikFPUc6FTh7dnEC/wKQuSMfXKbZSLeWU1axMvQQYsAN29VaCLBMfcMejw6x47uV6o
         EMSQw9gOJNBl6Y4cpb8dfolMDiclsvDJfnAkmWxM9rySSuX24M8nZHetRo0/cN5NQMsj
         4cWFELdC3RacRwk3x525HQvoQIl5LrgEmvD8u0Gur53mXDwr2FfZfeWR3dW2KU/1jMdr
         J9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oihop7JLhBVaA4GdmD12GWAGpSdFMpgp2Nm7icLJcM0=;
        b=iXledzbxxU1omESAfrjP7S/ARsnegMCYlR9X63tKZM3hRPhwEvPMWf2vGdvDp4ovSF
         jWgCWxlNNJ/6RC+64qCg1jFhGyAahipOIT2A0tHKcTOyUiUG+4Xt2TdILItDn7kNvqNz
         bPaTayga7zbw0iYur0bA4QI3QH4+eZGawyR6ovW0lRoNWO8ssFI4NqWtMTX7goJaXAid
         f9tVykzvpwKpddcb8S7rBY5SIVFq0g36zXEE0ikHTobFIuIReTUynYxmy5GoUIwy0NCc
         Hw4ziDwqawikcP2/RKRPSpFvp/EXyuoI5I7ZIqiPQ9VpD5vz4Qtk21g7tm6Jov145nBI
         nwmQ==
X-Gm-Message-State: AOAM533OCoIAkwsTRPa+gItpfTnQVLA1tLExZr90y5G+V7swmX9sjikd
        5ZNfyvrKm1fCAkRPM5QtXJ72ww==
X-Google-Smtp-Source: ABdhPJzlADuO7DWMA4vxQWWSdprkRQzNUrfqmzcx4b2dRRv9SM88Pz9tWkChQKFdmhOhGrWqDiQMtg==
X-Received: by 2002:a63:581:: with SMTP id 123mr4047247pgf.430.1619104082326;
        Thu, 22 Apr 2021 08:08:02 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id ch21sm5253715pjb.8.2021.04.22.08.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 08:08:01 -0700 (PDT)
Date:   Thu, 22 Apr 2021 15:07:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] KVM: x86: simplify zero'ing of entry->ebx
Message-ID: <YIGRTfMm0MfypN22@google.com>
References: <20210422141129.250525-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422141129.250525-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently entry->ebx is being zero'd by masking itself with zero.
> Simplify this by just assigning zero, cleans up static analysis
> warning.
> 
> Addresses-Coverity: ("Bitwise-and with zero")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 57744a5d1bc2..9bcc2ff4b232 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -851,7 +851,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
>  			      SGX_ATTR_PROVISIONKEY | SGX_ATTR_EINITTOKENKEY |
>  			      SGX_ATTR_KSS;
> -		entry->ebx &= 0;
> +		entry->ebx = 0;

I 100% understand the code is funky, but using &= is intentional.  ebx:eax holds
a 64-bit value that is a effectively a set of feature flags.  While the upper
32 bits are extremely unlikely to be used any time soon, if a feature comes
along then the correct behavior would be:

		entry->ebx &= SGX_ATTR_FANCY_NEW_FEATURE;

While directly setting entry->ebx would be incorrect.  The idea is to set up a
future developer for success so that they don't forget to add the "&".

TL;DR: I'd prefer to keep this as is, even though it's rather ridiculous.

>  		break;
>  	/* Intel PT */
>  	case 0x14:
> -- 
> 2.30.2
> 
