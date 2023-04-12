Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB34E6DFECA
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 21:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjDLThw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 15:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDLThu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 15:37:50 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAC5269F
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 12:37:49 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m20-20020a170902c45400b001a641823abdso5121013plm.18
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 12:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681328269; x=1683920269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WGPFGa6a5AyBKhKxp6OsNW9GYoSIZ4PdLtwW24G9FKo=;
        b=MiYEWqDhRnABU3naI6gHGiNu4DYRKpHa8WFmvFxco7fq+UveqF9VTOD3pMUQoJhtY9
         gBS+kqy6r9ZUqV3QawGdB8Z1/JwvugouPseU4SF9+JWAAIs91Y7iV1/TGGkdM+NAm/zD
         x6CYFn0/ENR3xGwdsUiZU/VMYKxjOgk94myuDcWagH1E6zefkuKyPF+iEKis/pjAly5O
         AL7LGiPhVMF4ulprtosfJ3xVqJc8dNZ55xB7vO1s3cJIeF0MWx5pCoeLbtbQa1wd7l6V
         SwWym1Kd3wvEmChDkp/w07zOkZOFJxOLI7uU1BecWorn+0CmoK3YZKsHBifMW3/y1Ldb
         zdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681328269; x=1683920269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WGPFGa6a5AyBKhKxp6OsNW9GYoSIZ4PdLtwW24G9FKo=;
        b=PlvFxaAbXs6dKfstJcG/w+RYQgod6NDDlIKkowDjxsahPYJSW6aKcjrIlTIF4dRNoS
         px6Qjpr3lCVBs7PvnPo+pKp9ek8b7MiAY6o9i60sLyV7FSGl/8zj9XVl2TxT1eZUZzWH
         6zuZoYPmgpvcZQryFCihGIdH0baTR9uxlL1rqS26F03Og0KTQYNTdHM8UqTY7vNbJg7f
         e1xrPxYsbBTDLne9aISZo1JsFSx0I9BQ5GsP+H5RZ0dpEuMKHYzJdxZGKaUbL1X7+7Gv
         d/WPR2h6G8w3FoWWSDehTeSEfDQKE3gCjvCPcbItmdoC5pMPoBq9o5APj0cNPkqvFMWg
         pIiQ==
X-Gm-Message-State: AAQBX9fiN1e8LVPKp1D03/ja//n63LHihSd64cYQrO/7neU8Gw5HccQT
        CxdOGRGjrd1jEvcdXEmIuYLbpgURU98=
X-Google-Smtp-Source: AKy350ZeYSUnY3rkhOuQXtXKS+M/PQ1H/WWYcUufEfimNOsKQ0XLXzLQ/pdHOg6715P0xJONOorpoo0jx74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:211d:0:b0:519:ad33:fa96 with SMTP id
 h29-20020a63211d000000b00519ad33fa96mr2166203pgh.12.1681328269200; Wed, 12
 Apr 2023 12:37:49 -0700 (PDT)
Date:   Wed, 12 Apr 2023 12:37:48 -0700
In-Reply-To: <SA1PR11MB6734897C0BC0FC7481333E29A89B9@SA1PR11MB6734.namprd11.prod.outlook.com>
Mime-Version: 1.0
References: <20230410081438.1750-1-xin3.li@intel.com> <20230410081438.1750-34-xin3.li@intel.com>
 <ZDSEjhGV9D90J6Bx@google.com> <SA1PR11MB6734897C0BC0FC7481333E29A89B9@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <ZDcIjF/QnCZNkXJ8@google.com>
Subject: Re: [PATCH v8 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to
 generate FRED stack frames
From:   Sean Christopherson <seanjc@google.com>
To:     Xin3 Li <xin3.li@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        Shan Kang <shan.kang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023, Xin3 Li wrote:
> 
> > And then this is equally gross.  Rather than funnel FRED+legacy into a single
> > function only to split them back out, just route FRED into its own asm subroutine.
> > The common bits are basically the creation/destruction of the stack frame and
> > the CALL itself, i.e. the truly interesting bits are what's different.
> 
> I try to catch up with you but am still confused.
> 
> Because a FRED stack frame always contains an error code pushed after RIP,
> the FRED entry code doesn't push any error code.
> 
> Thus I introduced a trampoline code, which is called to have the return
> instruction address pushed first. Then the trampoline code pushes an error
> code (0 for both IRQ and NMI) and jumps to fred_entrypoint_kernel() for NMI
> handling or calls external_interrupt() for IRQ handling.
> 
> The return RIP is used to return from fred_entrypoint_kernel(), but not
> external_interrupt().

...

> > +	/*
> > +	* A FRED stack frame has extra 16 bytes of information pushed at the
> > +	* regular stack top compared to an IDT stack frame.
> > +	*/
> > +	push $0         /* Reserved by FRED, must be 0 */
> > +	push $0         /* FRED event data, 0 for NMI and external interrupts */
> > +	shl $32, %rax
> > +	orq $__KERNEL_DS | $FRED_64_BIT_MODE, %ax
> > +	push %rax	/* Vector (from the "caller") and DS */
> > +
> > +	push %rbp
> > +	pushf
> > +	push \cs_val
> 
> We need to push the RIP of the next instruction here. Or are you suggesting
> we don't need to care about it because it may not be used to return from the
> callee?

...

> > +	push $0 /* FRED error code, 0 for NMI and external interrupts */
> > +	PUSH_REGS
> > +
> > +	/* Load @pt_regs */
> > +	movq    %rsp, %_ASM_ARG1
> > +
> > +	call \call_target

The CALL here would push RIP, I missed/forgot the detail that the error code needs
to be pushed _after_ RIP, not before.

Unless CET complains, there's no need for a trampoline, just LEA+PUSH the return
RIP, PUSH the error code, and JMP to the handler.  IMO, that isn't any weirder than
a trampoline, and it's a bit more obviously weird, e.g. the LEA+PUSH can have a nice
big comment.
