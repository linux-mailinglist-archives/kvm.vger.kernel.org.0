Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BD01E12E2
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 18:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389087AbgEYQpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 12:45:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58369 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387766AbgEYQpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 12:45:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590425107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OPs8IJfxt9IIGMMe9Npa9waPsMBNELWLmsbx6KFSrGA=;
        b=L6W1uSf8mZaeh/onuz1PpFuKQ/awPAaZi7l4OoKVgFK5nlE6GCQSz4Z6rlcphVWpNWII4F
        /il6cRWkZToEQUao+bQBoU4KfiNF7/RnXpwCl/S4U6NJWmMsibPfV1PNwQn8iIwf4CgHFa
        FqBkYthwXBviDlpNAntIzoho00cSSJw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-c65NxUciOBagfpECqMc1BQ-1; Mon, 25 May 2020 12:45:06 -0400
X-MC-Unique: c65NxUciOBagfpECqMc1BQ-1
Received: by mail-wr1-f71.google.com with SMTP id n6so667327wrv.6
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 09:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OPs8IJfxt9IIGMMe9Npa9waPsMBNELWLmsbx6KFSrGA=;
        b=Y+7E2B9OJEDAIgDWLDePqxzrQNsfEl4IROkhKcv74P2njUh93tIrtfp6DCM1FBdRKk
         dULu8K5fMuDOEKVQYQ5OrmMWw1mkeECQSV9/bk9maOGjbeVVVdzK02oMRjnKI+qk3WvJ
         ResURyRKo92HTtMjwmRmnfTAsUfOS4gOKnoiNZ+LxVeIggZ8hZh/oSzH2Oyf7ynOiux6
         EBc/ooxfaskT9wPwl4KRMBmTXHhSNK4ADlv2hXn1mNQyBtKS2Xblu9icHUpVxwLqhz0R
         P2M3Tzzhj8XkAjSJyuvAqoqOugNCiijuq7Rp5UWgdsQwikN0d8QzyfsOuUCKIdP4FasO
         CZiQ==
X-Gm-Message-State: AOAM531zLNZ4MTKKLPdKgNgsbo5odQz4tqR+qtZZttJV9baNJ7Hp5IQX
        bUh9/wg8tDcYnAp/dgPWr0GShj1zON6owUg8iP2HaeTVkFzDqihow/Kc3SU0pa3dVqqxBIi4QPS
        IYbWDkPrV/ABK
X-Received: by 2002:a5d:5106:: with SMTP id s6mr15471983wrt.267.1590425103999;
        Mon, 25 May 2020 09:45:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAIu7R/ZZNNHoXpBfB18tsKZoGb8gQR6MxKBLhAlE9XoQVh89SsbBLVY3YEXg/GqZm871f0Q==
X-Received: by 2002:a5d:5106:: with SMTP id s6mr15471950wrt.267.1590425103643;
        Mon, 25 May 2020 09:45:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id y7sm2202233wmg.26.2020.05.25.09.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 09:45:03 -0700 (PDT)
Subject: Re: #DE
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
References: <0fa0acac-f3b6-96c0-6ac8-18ec4d573aab@redhat.com>
 <233a810765c8b026778e76e9f8828a9ad0b3716d.camel@redhat.com>
 <b58b5d08-97a6-1e64-d8db-7ce74084553a@redhat.com>
 <3957e9600ae84bf8548d05ab8fbeb343d0239843.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <deb611de-76a9-b0b4-751b-8ef91d5f8902@redhat.com>
Date:   Mon, 25 May 2020 18:45:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <3957e9600ae84bf8548d05ab8fbeb343d0239843.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/20 17:13, Maxim Levitsky wrote:
> With all this said, this is what is happening:
> 
> 1. The host sets interrupt window. It needs interrupts window because (I guess) that guest
> disabled interrupts and it waits till interrupts are enabled to inject the interrupt.
> 
> To be honest this is VMX limitation, and in SVM (I think according to the spec) you can inject
> interrupts whenever you want and if the guest can't accept then interrupt, the vector written to EVENTINJ field,
> will be moved to V_INTR_VECTOR and V_INTR flag will be set,

Not exactly, EVENTINJ ignores the interrupt flag and everything else.  
But yes, you can inject the interrupt any time you want using V_IRQ + 
V_INTR_VECTOR and it will be injected by the processor.  This is a 
very interesting feature but it doesn't fit very well in the KVM
architecture so we're not using it.  Hyper-V does (and it is also
why it broke mercilessly).

> 2. Since SVM doesn't really have a concept of interrupt window 
> intercept, this is faked by setting V_INTR, as if injected (or as
> they call it virtual) interrupt is pending, together with intercept
> of virtual interrupts,
Correct.

> 4. After we enter the nested guest, we eventually get an VMexit due
> to unrelated reason and we sync the V_INTR that *we* set
> to the nested vmcs, since in theory that flag could have beeing set
> by the CPU itself, if the guest itself used EVENTINJ to inject
> an event to its nested guest while the nested guest didn't have
> interrupts enabled (KVM doesn't do this, but we can't assume that)

I suppose you mean in sync_nested_vmcb_control.  Here, in the latest version,
we have:

        mask = V_IRQ_MASK | V_TPR_MASK;
        if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
            is_intercept(svm, SVM_EXIT_VINTR)) {
                /*
                 * In order to request an interrupt window, L0 is usurping
                 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
                 * even if it was clear in L1's VMCB.  Restoring it would be
                 * wrong.  However, in this case V_IRQ will remain true until
                 * interrupt_window_interception calls svm_clear_vintr and
                 * restores int_ctl.  We can just leave it aside.
                 */
                mask &= ~V_IRQ_MASK;
        }

and svm_clear_vintr will copy V_IRQ, V_INTR_VECTOR, etc. back from the nested_vmcb
into svm->vmcb.  Is that enough to fix the bug?

> 5. At that point the bomb is ticking. Once the guest ends dealing
> with the nested guest VMexit, and executes VMRUN, we enter the nested
> guest with V_INTR enabled. V_INTER intercept is disabled since we
> disabled our interrupt window long ago, guest is also currently
> doesn't enable any interrupt window, so we basically injecting to the
> guest whatever is there in V_INTR_VECTOR in the nested guest's VMCB.

Yep, this sounds correct.  The question is whether it can still happen
in the latest version of the code, where I tried to think more about who
owns which int_ctl bits when.

> Now that I am thinking about this the issue is deeper that I thought
> and it stems from the abuse of the V_INTR on AMD. IMHO the best
> solution is to avoid interrupt windows on AMD unless really needed
> (like with level-triggered interrupts or so)

Yes, that is the root cause.  However I'm not sure it would be that
much simpler if we didn't abuse VINTR like that, because INT_CTL is a
very complicated field.

> Now the problem is that it is next to impossible to know the source
> of the VINTR pending flag. Even if we remember that host is currently
> setup an interrupt window, the guest afterwards could have used
> EVENTINJ + interrupt disabled nested guest, to raise that flag as
> well, and might need to know about it.

Actually it is possible!  is_intercept tests L0's VINTR intercept
(see get_host_vmcb in svm.h), and that will be true if and only if
we are abusing the V_IRQ/V_INTR_PRIO/V_INTR_VECTOR fields.

Furthermore, L0 should not use VINTR during nested VMRUN only if both
the following conditions are true:

- L1 is not using V_INTR_MASKING

- L0 has a pending interrupt (of course)

This is because when virtual interrupts are in use, you can inject
physical interrupts into L1 at any time by taking an EXIT_INTR vmexit.

My theory as to why the bug could happen involved a race between
the call to kvm_x86_ops.interrupt_allowed(vcpu, true) in
inject_pending_event and the call to kvm_cpu_has_injectable_intr
in vcpu_enter_guest.  Again, that one should be fixed in the
latest version on the branch, but there could be more than one bug!

> I have an idea on how to fix this, which is about 99% correct and will only fail if the guest attempt something that
> is undefined anyway.
> 
> Lets set the vector of the fake VINTR to some reserved exception value, rather that 0 (which the guest is not supposed to inject ever to the nested guest),
> so then we will know if the VINTR is from our fake injection or from the guest itself.
> If it is our VINTR then we will not sync it to the guest.
> In theory it can be even 0, since exceptions should never be injected as interrupts anyway, this is also reserved operation.

Unfortunately these are interrupts, not exceptions.  You _can_ configure
the PIC (or probably the IOAPIC too) to inject vectors in the 0-31 range.
Are you old enough to remember INT 8 as the timer interrupt? :)

Thanks very much for the detective work though!  You made a good walkthrough
overall so you definitely understood good parts of the code.

Paolo

