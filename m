Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED353375A97
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhEFS7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhEFS67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:58:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92E9C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:58:00 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gj14so3838054pjb.5
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P9I9rDg26Q2V97zgGas1g52p1U3fzjO7Ue2DgK7mij4=;
        b=B7+UeLfzmEquIe+5GZzD10zk/Ek1giutP7I9S5kdP0eFIq9xuWwoQ5ezw36/e65hch
         ASqezKcwZWHQTMg/kzqgbJoScEtYE68mT/2/Q33tPO+tTu9FXoMFkKL3sHmjtQ1fCUGQ
         qivVRiZdc/21r31h9T0unDNXuv2EMGYmf0TmpYNJP1o7ZNY44OaK8jJTunEKYxLXSOo2
         ripVGDgsRRcGbFnbgviBtpLQVSkF2c0giFt88sl6b+oL042mQpFhbJX5wX3edFBFm1pV
         ahN0Bh9/cr0hHdtVLCLJqOpckMGt7sJEXLeartWEG74AwYY/W6y0mMA2zx4nMxoXkwsQ
         bQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P9I9rDg26Q2V97zgGas1g52p1U3fzjO7Ue2DgK7mij4=;
        b=tNps+E9hoU3U8ae1HOAzKqmnG0DdkmJUXmmvbnffpgrDfNkg74wfuehy+cL7G2fiak
         0tnwEB/qkIx+BcsXrC67uCZhUX8f/QfyAd71HKC8zZVgNl6JhfRpieB0Qa2DvtcRb52I
         XvyH2zal8hPqn2dnnIHJepeHo3T53j7Zc/hE1DMGw9SqihLaBHLL254Ib5FZlm8chVDL
         0eozinZGe3KSGZDpHEHt7wlyD0atMIk0ybnBCpfAgbd8UAWZ4ohK4fkJ7+vrFO7aPCDs
         6+9WlebcqrOSpyUOMl1aW9HcWRIUwNN9Hxt7hlQm7huiBd+eiV+vnprJ+IzDe8QdSsr9
         ck9A==
X-Gm-Message-State: AOAM533R4J7WY76z/qQXZ35P+bzOYAr1VFY29xyHilig7qqNlA/KP/Ct
        Ep//y6udjEh4bigjAhhVFME1TA==
X-Google-Smtp-Source: ABdhPJyUKL7tKf0IthEIdezYUHRdFlj7VjhPCLAOxRvISEm+qwEI8LRTcmwM2w38cfBVEtxt70NSzQ==
X-Received: by 2002:a17:90a:cf8a:: with SMTP id i10mr6210801pju.188.1620327479986;
        Thu, 06 May 2021 11:57:59 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w74sm2809572pfc.173.2021.05.06.11.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 11:57:59 -0700 (PDT)
Date:   Thu, 6 May 2021 18:57:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jacob Xu <jacobhxu@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2] x86: Do not assign values to unaligned
 pointer to 128 bits
Message-ID: <YJQ8NN6EzzZEiJ6a@google.com>
References: <20210506184925.290359-1-jacobhxu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506184925.290359-1-jacobhxu@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021, Jacob Xu wrote:
> When compiled with clang, the following statement gets converted into a
> movaps instructions.
> mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> 
> Since mem is an unaligned pointer to a union of an sse, we get a GP when
> running.
> 
> All we want is to make the values between mem and v different for this
> testcase, so let's just memset the pointer at mem, and convert to
> uint32_t pointer. Then the compiler will not assume the pointer is
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
> index 9705073..a2c7e5b 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -716,12 +716,12 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
>  
>  	// test unaligned access for movups, movupd and movaps
>  	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> -	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> +	memset((uint32_t *)mem, 0xdecafbad, sizeof(mem));

memset() takes a void *, which it casts to an char, i.e. it works on one byte at
a time.  Casting to a uint32_t won't make it write the full "0xdecafbad", it will
just repease 0xad over and over.

The size needs to be sizeof(*mem), i.e. the size of the object that mem points to,
not the size of the pointer's storage.

>  	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
>  	report(sseeq(&v, mem), "movups unaligned");
>  
>  	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> -	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> +	memset((uint32_t *)mem, 0xdecafbad, sizeof(mem));
>  	asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
>  	report(sseeq(&v, mem), "movupd unaligned");
>  	exceptions = 0;
> @@ -734,7 +734,7 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
>  	// setup memory for cross page access
>  	mem = (sse_union *)(&bytes[4096-8]);
>  	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
> -	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
> +	memset((uint32_t *)mem, 0xdecafbad, sizeof(mem));
>  
>  	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
>  	report(sseeq(&v, mem), "movups unaligned crosspage");
> -- 
> 2.31.1.607.g51e8a6a459-goog
> 
