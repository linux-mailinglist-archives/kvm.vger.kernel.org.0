Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A768F145121
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 10:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgAVJvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 04:51:47 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45390 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730265AbgAVJvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 04:51:45 -0500
Received: by mail-pf1-f195.google.com with SMTP id 2so3085903pfg.12
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 01:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xVR9x6fM2xzK4CKYnGrCoedB91n8E59iP4vrQcT6/Cc=;
        b=SL5pc2v4rzu0t/sIxUVKsPax0l/PXzcKBRaIWwZ4iLcPkvZteLAnhOOtpEsCSy+eiV
         Ajy+sJLt9w1ID6ZE+OKUeePODTifYrHkC3LtAxSCo94pdOx1eq7hZSWA34IBcZxHbECU
         EElnJYYZ6wXN0D3q2nk0XWKCxOgW8ePQkVUUQzOj4Hjbtmv45aF7jvhM2ihsGJOLqJap
         s9N+jQRzH/6EBW8o6R7IEvj0S/zv4bPOilJUU7T3gAsbUfIj3fXEYyEI0urph6hmXj5H
         8Z/eMlIRX9R5Qk8PjzRsD723xpwXxKKoWXH+aXURupBqJj6RUX1ysYFkkTwl96yjx7Gr
         5rsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xVR9x6fM2xzK4CKYnGrCoedB91n8E59iP4vrQcT6/Cc=;
        b=mqzBh/cGKKWCB9TySGAJ3yEwqovp4JhtVpMyswHnxJOpzGbfyZcThYExsPCaCmvYs0
         2M2b1hH+hfn2nGJYshooHva9KyF3j3AcFYWiIZVvbQBV7oKD0Vpay+LI2ORapjewygEQ
         lNWFVgpxyMuw//9kBg1tJwsEctlDl2r8R/5iH7ZYsIIQR+DCHl3/Sc77+Z7NT7RVyoS9
         7FNZVbuZ+gEywGrL2xa4pAogVhEk8Zvfy0D+8FEqSrrcaxaG2A3m+m/QG5v6LNYS9HOe
         YC7qg4wonoPO4hsGpVM5ZZ4Ks2BlKJfEXqViM+erHHwthXSA2sIb28dsF+GisoBA/Nry
         dXwg==
X-Gm-Message-State: APjAAAVuDUAay1phjFITp8gMep2Gtp3Kx/Y5pQG2KQZPgQpg9YP+lEm6
        olruWIGSBTfdx+3m3d8Gx0kiTg==
X-Google-Smtp-Source: APXvYqxhsXW7xijstNxsEVVnebiBj4SpfUFODK1JXkfj8MtTWYuMdIYqci74PCWGu1F1l+P/fymYbw==
X-Received: by 2002:a63:f5c:: with SMTP id 28mr10463745pgp.348.1579686704353;
        Wed, 22 Jan 2020 01:51:44 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id r62sm48010289pfc.89.2020.01.22.01.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 01:51:43 -0800 (PST)
Date:   Wed, 22 Jan 2020 01:51:39 -0800
From:   Oliver Upton <oupton@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Check preconditions for RDTSC
 test
Message-ID: <20200122095139.GA229137@google.com>
References: <20200122073959.192050-1-oupton@google.com>
 <87wo9jstzj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo9jstzj.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 22, 2020 at 10:47:28AM +0100, Vitaly Kuznetsov wrote:
> Oliver Upton <oupton@google.com> writes:
> 
> > The RDTSC VM-exit test requires the 'use TSC offsetting' processor-based
> > VM-execution control be allowed on the host. Check this precondition
> > before running the test rather than asserting it later on to avoid
> > erroneous failures on a host without TSC offsetting.
> >
> > Cc: Aaron Lewis <aaronlewis@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  x86/vmx_tests.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > index 3b150323b325..de9a931216e2 100644
> > --- a/x86/vmx_tests.c
> > +++ b/x86/vmx_tests.c
> > @@ -9161,9 +9161,6 @@ static void vmx_vmcs_shadow_test(void)
> >   */
> >  static void reset_guest_tsc_to_zero(void)
> >  {
> > -	TEST_ASSERT_MSG(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET,
> > -			"Expected support for 'use TSC offsetting'");
> > -
> >  	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
> >  	vmcs_write(TSC_OFFSET, -rdtsc());
> >  }
> > @@ -9210,6 +9207,11 @@ static void rdtsc_vmexit_diff_test(void)
> >  	int fail = 0;
> >  	int i;
> >  
> > +	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET)) {
> > +		printf("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
> > +		return;
> > +	}
> > +
> 
> Can we use test_skip() instead, something like
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index dd32b3aef08b..bfecf36d37ef 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -9166,6 +9166,9 @@ static void rdtsc_vmexit_diff_test(void)
>         int fail = 0;
>         int i;
>  
> +       if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET))
> +               test_skip("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
> +
>         test_set_guest(rdtsc_vmexit_diff_test_guest);
>  
>         reset_guest_tsc_to_zero();
> 
> ?

Even better :) Thanks Vitaly!

> >  	test_set_guest(rdtsc_vmexit_diff_test_guest);
> >  
> >  	reset_guest_tsc_to_zero();
> 
> -- 
> Vitaly
> 
