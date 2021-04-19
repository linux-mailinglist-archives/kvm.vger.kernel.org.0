Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D633649AC
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 20:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240776AbhDSSNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 14:13:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240427AbhDSSNh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 14:13:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618855986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HF4kUt6uo1pz0kDZO0Dm42FTpI2CrAdF2GCGvaRpLXk=;
        b=HeIIDTX5yEeQ9Cbip1oHUMndGlAOIGqrEYWRMuH9eDB4PcFnT3vSWaeAoaK9tT1+AOuFaX
        4F7ThvcWpVFSb86pCiAN4s/SXPPNWAE5gfZL8+kPNCtd+BDlz44Hj+soN1aN4MZpYAwn+0
        Cn2pG/HfdF22K0+avbid1AYRxo5K8CU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-gN93IN-GOBuvt7780zokKg-1; Mon, 19 Apr 2021 14:13:04 -0400
X-MC-Unique: gN93IN-GOBuvt7780zokKg-1
Received: by mail-ed1-f71.google.com with SMTP id n18-20020a0564020612b02903853320059eso2611018edv.0
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HF4kUt6uo1pz0kDZO0Dm42FTpI2CrAdF2GCGvaRpLXk=;
        b=HpRGZtEdEigHBKU4ynHcWzzVTPWh0m7Wwkkh9/kLLmjVFBGKJF92YhOwcVu7PMwoos
         9Gf1vFlGMlKY/45wmU2fdt4WqYzwkRURSTAvR7amFxaaxOOvtcQDacIsmR/REUePeuGl
         dx092lt2JkXYcWVcDI+b2faSHFwjbAontJ8MiYpFL0ck/hD2GzrpVb4JMZFP4JYs5brk
         X4M4TdLt2VzdlXO0R60I+VKs5vNUzWAEw1v9Qyn1MmPXmYOohQQI++3V4ej6a34X0jh0
         D+2VtLXD2rAneCQEsOabKv+OUksv+GZxr9ScwEae7J+QsQBBSgWqx5FqEj8+VNTpdsZQ
         sDFg==
X-Gm-Message-State: AOAM531hJQyOBZyxFppMR8k4GUiJj+JtNEoBsWCsjPSq7RimaOP63vkg
        0w3jy9N3HoiLkwqw3AoHiTEiOvKcYSVr7CBSMxi6llYwd0rvhYe+rx5nLxL5cEGvORfxz3QgSB+
        QEFaPZYfY9JkC
X-Received: by 2002:a50:9e03:: with SMTP id z3mr15295381ede.190.1618855983764;
        Mon, 19 Apr 2021 11:13:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbErgUIeihBQ/GTX0gT88PFxBXk76pMa0vUhQc5CsdjnDccixZKfMwN5DnAqeIoG/idPCfLg==
X-Received: by 2002:a50:9e03:: with SMTP id z3mr15295363ede.190.1618855983593;
        Mon, 19 Apr 2021 11:13:03 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id he35sm10135288ejc.2.2021.04.19.11.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 11:13:02 -0700 (PDT)
Date:   Mon, 19 Apr 2021 20:13:00 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 8/8] arm/arm64: psci: don't assume method
 is hvc
Message-ID: <20210419181300.a76dmywqyye2tx2p@gator.home>
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-9-drjones@redhat.com>
 <a7896505-8343-9b26-6174-e1b17a697a81@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7896505-8343-9b26-6174-e1b17a697a81@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021 at 05:33:37PM +0100, Alexandru Elisei wrote:
> On 4/7/21 7:59 PM, Andrew Jones wrote:
> > +psci_invoke_fn psci_invoke;
> 
> In setup(), we set the conduit after we call assert() several time. If the asert()
> fails, then psci_system_off() will end up calling a NULL function. Maybe there
> should be some sort of check for that?

I can initialize psci_invoke to something that will fail in a more obvious
manner.

> 
> > +
> >  __attribute__((noinline))
> > -int psci_invoke(unsigned long function_id, unsigned long arg0,
> > -		unsigned long arg1, unsigned long arg2)
> > +int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
> > +		    unsigned long arg1, unsigned long arg2)
> >  {
> >  	asm volatile(
> >  		"hvc #0"
> > @@ -22,6 +24,17 @@ int psci_invoke(unsigned long function_id, unsigned long arg0,
> >  	return function_id;
> >  }
> >  
> > +__attribute__((noinline))
> > +int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
> > +		    unsigned long arg1, unsigned long arg2)
> > +{
> > +	asm volatile(
> > +		"smc #0"
> > +	: "+r" (function_id)
> > +	: "r" (arg0), "r" (arg1), "r" (arg2));
> > +	return function_id;
> 
> I haven't been able to figure out what prevents the compiler from shuffling the
> arguments around before executing the inline assembly, such that x0-x3 doesn't
> contain the arguments in the order we are expecting.

We know the arguments will be in r0-r3 because of the noinline and that
shuffling them wouldn't make much sense, but I agree that this is in the
realm of [too] fragile assumptions.

> 
> Some excerpts from the extended asm help page [1] that make me believe that the
> compiler doesn't provide any guarantees:
> 
> "If you must use a specific register, but your Machine Constraints do not provide
> sufficient control to select the specific register you want, local register
> variables may provide a solution"
> 
> "Using the generic ‘r’ constraint instead of a constraint for a specific register
> allows the compiler to pick the register to use, which can result in more
> efficient code."
> 
> Same with psci_invoke_hvc(). Doing both in assembly (like Linux) should be
> sufficient and fairly straightforward.

OK, I'll just use assembly to avoid the assumptions.

> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#Extended-Asm
> 
> > +}
> > +
> >  int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
> >  {
> >  #ifdef __arm__
> > diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> > index 5cda2d919d2b..e595a9e5a167 100644
> > --- a/lib/arm/setup.c
> > +++ b/lib/arm/setup.c
> > @@ -25,6 +25,7 @@
> >  #include <asm/processor.h>
> >  #include <asm/smp.h>
> >  #include <asm/timer.h>
> > +#include <asm/psci.h>
> >  
> >  #include "io.h"
> >  
> > @@ -55,6 +56,26 @@ int mpidr_to_cpu(uint64_t mpidr)
> >  	return -1;
> >  }
> >  
> > +static void psci_set_conduit(void)
> > +{
> > +	const void *fdt = dt_fdt();
> > +	const struct fdt_property *method;
> > +	int node, len;
> > +
> > +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,psci-0.2");
> > +	assert_msg(node >= 0, "PSCI v0.2 compatibility required");
> > +
> > +	method = fdt_get_property(fdt, node, "method", &len);
> > +	assert(method != NULL && len == 4);
> > +
> > +	if (strcmp(method->data, "hvc") == 0)
> > +		psci_invoke = psci_invoke_hvc;
> > +	else if (strcmp(method->data, "smc") == 0)
> > +		psci_invoke = psci_invoke_smc;
> > +	else
> > +		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
> > +}
> 
> Any particular reason for doing this here instead of in psci.c? This looks like
> something that belongs to that file, but that might just be my personal preference.

I don't have a strong preference on this, so I'll move it.

Thanks,
drew

