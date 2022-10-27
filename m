Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074EF6101D5
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 21:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbiJ0TjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 15:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbiJ0TjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 15:39:16 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9527B1FD
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 12:39:15 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9so2634220pll.7
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 12:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O2NkXj9b8GIWiwayXjdQwEOUvMETKpM4KU/4hcOebL0=;
        b=GwveO1jmuT2KKfkB6sv3UWF3d8Z9o++2NmVrZc8pMnD93EaxbNdtj3+oKwWDhNMH0G
         MqWHIWLegOifhD8fgDroGHPbhgilYxZcxZ84UHTu8gKqSuRrBxjjVbW26Qq/kxHwF9p/
         zyV+r7Bvfx1K1UYDN/I8b0eTTQ/YFbQkZjPiYDvrNGvvPwidkKk7qL470B89CQ1Ny7sd
         W9hAMhThi1SVcAgpXT/tfI3T7OinI9pm7YS9KDzzHIYo6ziEbpp6FKzRPwC9OXxPbZXN
         Plnb7MePJZlZPYay4hUC1gYU+KeHUxjPiS61TNC2mrd1bZVwsDUc7mXYj2vtJGrNaI5z
         WiJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O2NkXj9b8GIWiwayXjdQwEOUvMETKpM4KU/4hcOebL0=;
        b=T8B9cqs70Xm4arC3w6iq+m/FkgAGIx5z6xLGfIZ9aUziVr5w1G9EMY1LG6sjGQVPEs
         +nigYe76OZg5yyted4I5k3Fjt3APbHOfPaAj3pM/wu9YSCO/NFkOo7eOlWe2kc/i36hk
         t5Bh5CSftyUuRKofaFRaqbMRqCZfScC4rjkBSmZkhRAd4RtbCv1ORdlOQagGeDnO2QsL
         j/cSypBJ/S3tA5UiDQNWosDg1iqIMcetjV1cKOpVeFrrpGqQSqUKz0sZmGFY+HiodND3
         oz3vlBEHxW5uC+lqseROzkh9n3WsKeRfWj6oxhv589AY4Vch8aYGYTDqzCTdldykmzsp
         ZV9Q==
X-Gm-Message-State: ACrzQf36eDmmvYPkWW5PyDlEyqN02fH13rlHnHI2sNrOtukWEXmaOd24
        pPVgD59knsT+BfeYK8H3rfEBqQ==
X-Google-Smtp-Source: AMsMyM5zdeTevGroK/CdwRyq4cPw+3twJy73xqXx0G52rWiMovidPVkoX7adzkQlWuymQ+sdm1uypw==
X-Received: by 2002:a17:90b:1c0d:b0:213:1a9c:5b1 with SMTP id oc13-20020a17090b1c0d00b002131a9c05b1mr11560981pjb.188.1666899555145;
        Thu, 27 Oct 2022 12:39:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w1-20020a623001000000b0056bad6ff1c7sm1528327pfw.54.2022.10.27.12.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 12:39:14 -0700 (PDT)
Date:   Thu, 27 Oct 2022 19:39:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 14/16] svm: rewerite vm entry macros
Message-ID: <Y1reX9Uha1gc3e4y@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-15-mlevitsk@redhat.com>
 <Y1GZu5ztBadhFphk@google.com>
 <35fe5a9c8ef5155f226df7beb24917d9b2020871.camel@redhat.com>
 <Y1bt5eGAOuYJINze@google.com>
 <0fdd437cfa347258de2841c4af2532e6b49751a7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fdd437cfa347258de2841c4af2532e6b49751a7.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022, Maxim Levitsky wrote:
> On Mon, 2022-10-24 at 19:56 +0000, Sean Christopherson wrote:
> > > And also there is segment registers, etc, etc.
> > 
> > Which aren't GPRs.
> 
> But user can want to use them too.

My point is that they don't need to be handled in this the VM-Entry/VM-Exit path
as both VMX and SVM context switch all segment information through the VMCS/VMCB.
In other words, if we want to provide easy, generic access to segment information,
that can be done completely separately from this code and in a separate struct.

> > > Note though that my LBR tests do still need this as a macro because they must
> > > not do any extra jumps/calls as these clobber the LBR registers.
> > 
> > Shouldn't it be fairly easy to account for the CALL in the asm routine?  Taking
> > on that sort of dependency is quite gross, but it'd likely be less maintenance
> > in the long run than an inline asm blob.
> 
> That is not possible - the SVM has just one LBR - so doing call will erase it.

Ugh, that's a pain.  

> I'll think of something, I also do want to turn this into a function.

Actually, IIUC, there's no need to preserve the LBR across the call to a VMRUN
subroutine.  When checking that the host value is preserved, LBRs are disabled
before the call.  When checking that the guest value leaks back into the host,
the host value is irrelevant, the only thing that matters is that the LBR is
pre-filled with something other than the guest value, and that functionality is
provided by the call into the VMRUN subroutine.

LBR side topic #1, sequences like this should really be a single asm blob:

	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
	DO_BRANCH(...);
	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);

as there is nothing that prevents the compiler from inserting a branch between
DO_BRANCH() and the wrmsr().  It's extremely unlikely, but technicall possible.

LBR side topic #2, the tests are broken on our Milan systems.  I've poked around
a few times, but haven't dug in deep yet (and probably won't have cycles to do so
anytime soon).

PASS: Basic LBR test
PASS: Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)
PASS: Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)
PASS: Test that with LBRV enabled, guest LBR state doesn't leak (1)
Unhandled exception 6 #UD at ip 000000000040175c
error_code=0000      rflags=00010086      cs=00000008
rax=00000000004016e7 rcx=00000000000001dc rdx=80000000004016e7 rbx=0000000000414920
rbp=000000000042fa38 rsi=0000000000000000 rdi=0000000000414d98
 r8=00000000004176f9  r9=00000000000003f8 r10=000000000000000d r11=0000000000000000
r12=0000000000000000 r13=0000000000000000 r14=0000000000000000 r15=0000000000000000
cr0=0000000080010011 cr2=0000000000000000 cr3=00000000010bf000 cr4=0000000000040020
cr8=0000000000000000
