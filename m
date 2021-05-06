Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E1237582F
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbhEFQH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 12:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235766AbhEFQHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 12:07:24 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714AFC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 09:06:24 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id n10so5270256ion.8
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 09:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O1zJWb3qB+EP13McqhSlTFt6Ovbn+SkH7VlepgiYqmk=;
        b=pGhu9ts0g4k+8keyAjQfcfiPJuYhuSUrPkpXtpgblvnP2USD1qte9/txNjNbN4LzlO
         nYuR+A9w39xL1sFf5LpOKXHduZ2Y7lZBwrRNn1swI8tkPgsNv6ITW5zerLrYy1BED1OC
         kCQbGqs2yiK6qUbx9z3Vzq9tOQ5aN4hE/sKO+im9v5E77dLg9Ls8E/7WKDtJdE/C4MDN
         ye/gqbxiyvGF+4nPV/DdSEyTYlLKziDDwGX/jOkIaA4WvUmN+o8a3BD9Jnlxbd+O4NXF
         zq2vbSCjv7/QIU3zxXfJ3Ob3gaXvJfrkFvmWBLUiPT+MNjHZAC26whL16pP0oFZz+qLy
         Q+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O1zJWb3qB+EP13McqhSlTFt6Ovbn+SkH7VlepgiYqmk=;
        b=EOAdCZjub2sxRCsGaq3VyX5LRNgLeoKaMfcK5NeOrlCEqnFLCCZNDZ0SVkI7eHyNRx
         Rct7bpYzEfAqvlgkDVzSUBPrrQoGe2KYzqx0n0TnZTtYM0zgpBL3ZnZPOz9cgScqt9w1
         DeZpamA00jB9n9ZEjARJKWC/TSHirh3esMI2TLEn5Xyx9Bnuac22ncw1yr98Rf9Z9H/s
         Uf7x5G4zMJ20sioSiPULIGd8Ygw7ypaq6hsfZx94BQuZsxxsgnVuTepbC7JFRdMH4fns
         8zS6ZyHZBbstH46OmI5NBfLq3mas2Lih4QeS4tZXSTvxVBGrf9jlcNj9f+f61bmi0SNf
         x1lg==
X-Gm-Message-State: AOAM530z+gieDxGSQeSJNUmk4vKfAb9ASu3bIYOfYhZsU/kBVvogBXAa
        mqUOZL8XaVdfWgL6jUipQxoY4gQvu+kQaQ==
X-Google-Smtp-Source: ABdhPJy21qcGx+MXY+DsnvWPPS263M1q6l1IAwFVwn1ev66ydObsd/1ufnGaFUgntBiC+V5E/5erxA==
X-Received: by 2002:a63:2c81:: with SMTP id s123mr4986398pgs.168.1620316876476;
        Thu, 06 May 2021 09:01:16 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b1sm2669424pgf.84.2021.05.06.09.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 09:01:15 -0700 (PDT)
Date:   Thu, 6 May 2021 16:01:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jacob Xu <jacobhxu@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: Do not assign values to unaligned pointer to 128
 bits
Message-ID: <YJQSx9vb1lT3P79j@google.com>
References: <20210506004847.210466-1-jacobhxu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506004847.210466-1-jacobhxu@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please use [kvm-unit-tests PATCH ...] for the subject, it took me a depressingly
long time to figure out which code base this applied to (though admittedly there
was a non-zero amount of PEBKAC going on).

On Wed, May 05, 2021, Jacob Xu wrote:
> When compiled with clang, the following statement gets converted into a
> movaps instructions.
> mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> 
> Since mem is an unaligned pointer to a union of an sse, we get a GP when
> running.
> 
> All we want is to make the values between mem and v different for this
> testcase, so let's just memset the pointer at mem, and convert to
> uint8_t pointer. Then the compiler will not assume the pointer is
> aligned to 128 bits.
> 
> Fixes: e5e76263b5 ("x86: add additional test cases for sse exceptions to
> emulator.c")
> 
> Signed-off-by: Jacob Xu <jacobhxu@google.com>
> ---
>  x86/emulator.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 9705073..672bfda 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -716,12 +716,12 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
>  
>  	// test unaligned access for movups, movupd and movaps
>  	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> -	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> +	memset((uint8_t *)mem, 0, 128);

Shouldn't this be '16', as in 16 bytes / 128 bits?  And would it makes sense to
use a pattern other than '0', if only for giggles?

>  	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
>  	report(sseeq(&v, mem), "movups unaligned");
>  
>  	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> -	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> +	memset((uint8_t *)mem, 0, 128);
>  	asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
>  	report(sseeq(&v, mem), "movupd unaligned");
>  	exceptions = 0;
> @@ -734,7 +734,7 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
>  	// setup memory for cross page access
>  	mem = (sse_union *)(&bytes[4096-8]);
>  	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> -	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> +	memset((uint8_t *)mem, 0, 128);
>  
>  	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
>  	report(sseeq(&v, mem), "movups unaligned crosspage");
> -- 
> 2.31.1.527.g47e6f16901-goog
> 
