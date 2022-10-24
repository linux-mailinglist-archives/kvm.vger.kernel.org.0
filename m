Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EB260BE07
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 00:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiJXW6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 18:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiJXW6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 18:58:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA952764ED
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 14:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666646325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JODcClftCms+c2Sg+OewrqadUKPqbmSmPOn2SgO5BJY=;
        b=jGFE4Cz6GiSf5c2e88sWQmACVqj6yGaJXXwdNnrhPQPV0GJBqWw3fa7P/2fSWgJ1+lTQ+/
        tLyG3PlJ3CCkViZcLwwHfwlBnQwOE5LvCsK117ryr6DOHNgbkR65wXZxR+EPutmi5v2OaK
        6hGU+/QM5rNLb/Vh6LmboGwzbmSs3vE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-635-fO0EZ8NqNyuXAzrxq7Duaw-1; Mon, 24 Oct 2022 08:36:40 -0400
X-MC-Unique: fO0EZ8NqNyuXAzrxq7Duaw-1
Received: by mail-pl1-f199.google.com with SMTP id q12-20020a170902dacc00b00184ba4faf1cso6381579plx.23
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JODcClftCms+c2Sg+OewrqadUKPqbmSmPOn2SgO5BJY=;
        b=gukHJ2Qmz1sBxz6XrslDla8v/dxoAUIYkr/TZUyiZu2lietUco56M+iar26/37cBX7
         laJIvCZFaoz00hLqO2hfuyR6kARdQ+S8sMAZtEscWqb6c2r/wt3IJF6nsW+fNdlNnka6
         i0v0Wp6ILBaPjdHI4Wj3ywaU2h+v4yxcpSRpdlOtQExFaAv4m9aBzKM100sk7rTXmPfK
         CujclhEKSLzhZXAEwSu+Z/RnImtdzKv2Fztg6o9QSsuL084RXMQ1Yp1gQKiGriRSHSs+
         iraBwCylx4G4d87vBu+hUpqBw8c49r4oEPXxAwMeWfuSeDfcPxmMfPDjB7P8zPFFzmc2
         ZQoQ==
X-Gm-Message-State: ACrzQf0eMG5f2wSayB8vaPBVzoYdKWFc1xsF4/lHeqPduT7BRuOE4keZ
        C6GLyvLXyU9BKZwaWqmduIjLnRobYw/C6Co72sbJSexEwVCeS6ejtXEWaVQiDQI8vE8qGDPK3hb
        aNcw44eWeuFqA
X-Received: by 2002:a17:902:8ec8:b0:186:9c32:79c8 with SMTP id x8-20020a1709028ec800b001869c3279c8mr8155040plo.105.1666614998248;
        Mon, 24 Oct 2022 05:36:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6fIf3T11GR9B8NvUdWfdyomTEwTceCEC39dnC40ZMPZ9N2l1U54ZJ8n4OOCrUhIePyfGcqtg==
X-Received: by 2002:ad4:5b8b:0:b0:4b3:f368:de23 with SMTP id 11-20020ad45b8b000000b004b3f368de23mr26991296qvp.73.1666614987809;
        Mon, 24 Oct 2022 05:36:27 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id u9-20020a05622a198900b0039cbe823f3csm12968512qtc.10.2022.10.24.05.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:36:27 -0700 (PDT)
Message-ID: <a52dfb9b126354f0ec6a3f6cb514cc5e426b22ae.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/16] x86: make irq_enable avoid the
 interrupt shadow
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Oct 2022 15:36:24 +0300
In-Reply-To: <Y1GNE9YdEuGPkadi@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-2-mlevitsk@redhat.com> <Y1GNE9YdEuGPkadi@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 18:01 +0000, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > Tests that need interrupt shadow can't rely on irq_enable function anyway,
> > as its comment states,  and it is useful to know for sure that interrupts
> > are enabled after the call to this function.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  lib/x86/processor.h       | 9 ++++-----
> >  x86/apic.c                | 1 -
> >  x86/ioapic.c              | 1 -
> >  x86/svm_tests.c           | 9 ---------
> >  x86/tscdeadline_latency.c | 1 -
> >  x86/vmx_tests.c           | 7 -------
> >  6 files changed, 4 insertions(+), 24 deletions(-)
> > 
> > diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> > index 03242206..9db07346 100644
> > --- a/lib/x86/processor.h
> > +++ b/lib/x86/processor.h
> > @@ -720,13 +720,12 @@ static inline void irq_disable(void)
> >         asm volatile("cli");
> >  }
> >  
> > -/* Note that irq_enable() does not ensure an interrupt shadow due
> > - * to the vagaries of compiler optimizations.  If you need the
> > - * shadow, use a single asm with "sti" and the instruction after it.
> > - */
> >  static inline void irq_enable(void)
> >  {
> > -       asm volatile("sti");
> > +       asm volatile(
> > +                       "sti \n\t"
> 
> Formatting is odd.  Doesn't really matter, but I think this can simply be:
> 
> static inline void sti_nop(void)
> {
>         asm volatile("sti; nop");

"\n\t" is what gcc manual recommends for separating the assembly lines as you know from the gcc manual:
https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html
"You may place multiple assembler instructions together in a single asm string, separated by 
the characters normally used in assembly code for the system. A combination that works in 
most places is a newline to break the line, plus a tab character to move to the instruction 
field (written as ‘\n\t’). Some assemblers allow semicolons as a line separator. 
However, note that some assembler dialects use semicolons to start a comment"

Looks like gnu assembler does use semicolon for new statements and hash for comments 
but some assemblers do semicolon for comments.

I usually use just "\n", but the safest is "\n\t".


> }
> 
> 
> > +                       "nop\n\t"
> 
> I like the idea of a helper to enable IRQs and consume pending interrupts, but I
> think we should add a new helper instead of changing irq_enable().
> 
> Hmm, or alternatively, kill off irq_enable() and irq_disable() entirely and instead
> add sti_nop().  I like this idea even better.  The helpers are all x86-specific,
> so there's no need to add a layer of abstraction, and sti() + sti_nop() has the
> benefit of making it very clear what code is being emitted without having to come
> up with clever function names.
> 
> And I think we should go even further and provide a helper to do the entire sequence
> of enable->nop->disable, which is a very common pattern.  No idea what to call
> this one, though I suppose sti_nop_cli() would work.
> 
> My vote is to replace all irq_enable() and irq_disable() usage with sti() and cli(),
> and then introduce sti_nop() and sti_nop_cli() (or whatever it gets called) and
> convert users as appropriate.

OK.

> 
> > +       );
> >  }
> >  
> >  static inline void invlpg(volatile void *va)
> > diff --git a/x86/apic.c b/x86/apic.c
> > index 23508ad5..a8964d88 100644
> > --- a/x86/apic.c
> > +++ b/x86/apic.c
> > @@ -36,7 +36,6 @@ static void __test_tsc_deadline_timer(void)
> >      irq_enable();
> >  
> >      wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
> > -    asm volatile ("nop");
> 
> I'm not entirely sure the existing nop is necessary here, but it's a functional
> change since it hoists the nop above the WRMSR.  To be safe, probably best to
> leave this as-is for now.

I had doubts about this, IMHO both before and after are equally good, but anyway to be safe,
I'll revert this change.


> 
> >      report(tdt_count == 1, "tsc deadline timer");
> >      report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
> >  }
> 
> ...
> 
> > diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
> > index a3bc4ea4..c54530dd 100644
> > --- a/x86/tscdeadline_latency.c
> > +++ b/x86/tscdeadline_latency.c
> > @@ -73,7 +73,6 @@ static void start_tsc_deadline_timer(void)
> >      irq_enable();
> >  
> >      wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC)+delta);
> > -    asm volatile ("nop");
> 
> Another functional change that should be skipped, at least for now.

OK.

> 


Best regards,
	Maxim Levitsky

