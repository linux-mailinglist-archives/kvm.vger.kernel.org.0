Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561CA76CF68
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 16:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbjHBOBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 10:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbjHBOBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 10:01:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448C12115
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 07:01:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d0d27cd9db9so1745515276.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 07:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690984894; x=1691589694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LWQhgcpOHDr1rw8y2Xbv/aNJIPmCPmv4Y4vUkSeErdM=;
        b=qhpzbe5SFqOiIrHvQHgOqDoxegwElVej3r0xmxwLd7SQG26HPdgavSHYZak5haXn9H
         U2y0MbkYKjUUoIEop6x4GmtgEWy4X+ks6QSZ7elCQFh0Hws/FnbZ4c35mRi4TvSy0OSq
         en/oMx6ixoQO5YXiQoJUwVrO79aK3kMZPWkxxa5SQCS2XGh32xSlFQbEueGyeBGfVjl9
         7emEzrJhp9MnBpKQDwqxXLupfKVS946VBgivBYdx3hitHZL+2WiHcKbQkAVCOYp/YbsM
         J7QmMs5q2nFKRn1/OVlAj5aaMCgTZrMjxi0as2SRoKyIF0VQBUKpk/cdKRxsmbGI1zu6
         TArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690984894; x=1691589694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LWQhgcpOHDr1rw8y2Xbv/aNJIPmCPmv4Y4vUkSeErdM=;
        b=FkZaeqZS0VW2ojm3Ce3ixrVI8szMftx5uVqXaddOQ32rOCr4Xitr9TDJmtG0IK33mt
         GZZWbcVeZNL0iVszx5wrr1ri//C45hZS8dYsFd5qNWjsUHAg1s2aNIcUuSg6PrHsTILv
         MrYzKg81Jkus0NSSQhrGa/DLaQ9aDGM+z697FL2zzI0fox19w4AZaS3H2e2F9mfQgK6I
         Dxhv9GyVR0boOfqeGQivtHp1vXX9Usa1/b5QrXzkaEfKnvsQHq3xVkkYwKUmPC4390zi
         805Dzllo3jBYvsTQBMJ2mhFip++TRqo/O+fWy5IP9Orrip4wqW9LcZqQxzEcNUNApSV7
         SW8Q==
X-Gm-Message-State: ABy/qLau31016g0bETECs6v1QUpWAMz+kQk1JTI29HzMhr24YQChMyKm
        C7toqL6K1wU9M83Lozh9ovwVXQ1H95s=
X-Google-Smtp-Source: APBJJlHg+Xe6hYniFjo5V5A9YHAm4vVueRG5AdwMAFAOIdfDulVy0asCFDgtH1f/gmpKpCh5WHs9WGMyhbQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11cb:b0:d16:7ccc:b406 with SMTP id
 n11-20020a05690211cb00b00d167cccb406mr187562ybu.5.1690984894557; Wed, 02 Aug
 2023 07:01:34 -0700 (PDT)
Date:   Wed, 2 Aug 2023 07:01:32 -0700
In-Reply-To: <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ>
Mime-Version: 1.0
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com> <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn> <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ>
Message-ID: <ZMphvF+0H9wHQr5B@google.com>
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
From:   Sean Christopherson <seanjc@google.com>
To:     Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Wu Zongyo wrote:
> On Mon, Jul 31, 2023 at 11:45:29PM +0800, wuzongyong wrote:
> > 
> > On 2023/7/31 23:03, Tom Lendacky wrote:
> > > On 7/31/23 09:30, Sean Christopherson wrote:
> > >> On Sat, Jul 29, 2023, wuzongyong wrote:
> > >>> Hi,
> > >>> I am writing a firmware in Rust to support SEV based on project td-shim[1].
> > >>> But when I create a SEV VM (just SEV, no SEV-ES and no SEV-SNP) with the firmware,
> > >>> the linux kernel crashed because the int3 instruction in int3_selftest() cause a
> > >>> #UD.
> > >>
> > >> ...
> > >>
> > >>> BTW, if a create a normal VM without SEV by qemu & OVMF, the int3 instruction always generates a
> > >>> #BP.
> > >>> So I am confused now about the behaviour of int3 instruction, could anyone help to explain the behaviour?
> > >>> Any suggestion is appreciated!
> > >>
> > >> Have you tried my suggestions from the other thread[*]?
> > Firstly, I'm sorry for sending muliple mails with the same content. I thought the mails I sent previously 
> > didn't be sent successfully.
> > And let's talk the problem here.
> > >>
> > >>    : > > I'm curious how this happend. I cannot find any condition that would
> > >>    : > > cause the int3 instruction generate a #UD according to the AMD's spec.
> > >>    :
> > >>    : One possibility is that the value from memory that gets executed diverges from the
> > >>    : value that is read out be the #UD handler, e.g. due to patching (doesn't seem to
> > >>    : be the case in this test), stale cache/tlb entries, etc.
> > >>    :
> > >>    : > > BTW, it worked nomarlly with qemu and ovmf.
> > >>    : >
> > >>    : > Does this happen every time you boot the guest with your firmware? What
> > >>    : > processor are you running on?
> > >>    :
> > Yes, every time.
> > The processor I used is EPYC 7T83.
> > >>    : And have you ruled out KVM as the culprit?  I.e. verified that KVM is NOT injecting
> > >>    : a #UD.  That obviously shouldn't happen, but it should be easy to check via KVM
> > >>    : tracepoints.
> > >
> > > I have a feeling that KVM is injecting the #UD, but it will take instrumenting KVM to see which path the #UD is being injected from.
> > >
> > > Wu Zongyo, can you add some instrumentation to figure that out if the trace points towards KVM injecting the #UD?
> > Ok, I will try to do that.
> You're right. The #UD is injected by KVM.
> 
> The path I found is:
>     svm_vcpu_run
>         svm_complete_interrupts
> 	    kvm_requeue_exception // vector = 3
> 	        kvm_make_request
> 
>     vcpu_enter_guest
>         kvm_check_and_inject_events
> 	    svm_inject_exception
> 	        svm_update_soft_interrupt_rip
> 		    __svm_skip_emulated_instruction
> 		        x86_emulate_instruction
> 			    svm_can_emulate_instruction
> 			        kvm_queue_exception(vcpu, UD_VECTOR)
> 
> Does this mean a #PF intercept occur when the guest try to deliver a
> #BP through the IDT? But why?

I doubt it's a #PF.  A #NPF is much more likely, though it could be something
else entirely, but I'm pretty sure that would require bugs in both the host and
guest.

What is the last exit recorded by trace_kvm_exit() before the #UD is injected?
