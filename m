Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7F77828F
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 23:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjHJVOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 17:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjHJVOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 17:14:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B652737
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 14:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xw8GDwAv/fOZXpe7oxLyny+b+r9BYyurYvWXK93j7M8=; b=gVDWmVdEHL2WK0QVwiKZOK6pvM
        PNWxAXDvO5ZMfx7t0CIfalfyE1iridTemmVTOTNhpSp+BBbUhVfgnjv0ZlyACnaGDpvUb0PZPeEND
        3lNJ62qfbmz0fqJ35+MeCsnH0+rN0KSwd0NQA0S1w3k3UEsr+GEhr0rYxe1N4gBpwtICXdvtRkXU9
        XNumcxIAeJRBWa2gRjRRB0/LtwJ6Tc1Bl8ervWqQOg4agi8xkUvhk5bovejm07EP9UC2TImnu7++Q
        Ld74aS+qD5Ri/hha0z2yZ9iLWzb4TKI43C2LdBsOXdDJfOYVnQwPJPpV8Jjm0WiTxnTcCM4qf7ofc
        cIE4kbtw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qUCyv-006lpO-13;
        Thu, 10 Aug 2023 21:14:09 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B16DD30020B;
        Thu, 10 Aug 2023 23:14:08 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 971722067FA3D; Thu, 10 Aug 2023 23:14:08 +0200 (CEST)
Date:   Thu, 10 Aug 2023 23:14:08 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Nikunj A Dadhania <nikunj@amd.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
Message-ID: <20230810211408.GI212435@hirez.programming.kicks-ass.net>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <20230803120637.GD214207@hirez.programming.kicks-ass.net>
 <b22761ea-cab6-0e11-cdc9-ec26c300cd3f@redhat.com>
 <20230803190728.GJ212435@hirez.programming.kicks-ass.net>
 <7c2f6fa3-23ba-6df5-24d9-28f95f866574@redhat.com>
 <20230804204840.GR212435@hirez.programming.kicks-ass.net>
 <20230804231954.swdjx6lxkccxals6@treble>
 <20230805005551.GT212435@hirez.programming.kicks-ass.net>
 <fdf4d17a-e134-6e03-87d0-2c018c13a891@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdf4d17a-e134-6e03-87d0-2c018c13a891@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 04:17:41PM +0200, Paolo Bonzini wrote:
> On 8/5/23 02:55, Peter Zijlstra wrote:
> > > +	 * Clobbering BP here is mostly ok since GIF will block NMIs and with
> > > +	 * the exception of #MC and the kvm_rebooting _ASM_EXTABLE()s below
> > > +	 * nothing untoward will happen until BP is restored.
> > > +	 *
> > > +	 * The kvm_rebooting exceptions should not want to unwind stack, and
> > > +	 * while #MV might want to unwind stack, it is ultimately fatal.
> > > +	 */
> > Aside from me not being able to type #MC, I did realize that the
> > kvm_reboot exception will go outside noinstr code and can hit
> > tracing/instrumentation and do unwinds from there.
> 
> Asynchronously disabling SVM requires an IPI, so kvm_rebooting cannot change
> within CLGI/STGI.   We can check it after CLGI instead of waiting for a #GP:

Seems fair; thanks!

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 956726d867aa..e3755f5eaf81 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4074,7 +4074,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
> kvm_vcpu *vcpu)
>  	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>  		x86_spec_ctrl_set_guest(svm->virt_spec_ctrl);
> 
> -	svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
> +	if (unlikely(kvm_rebooting))
> +		svm->vmcb->control.exit_code = SVM_EXIT_PAUSE;
> +	else
> +		svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
> 
>  	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>  		x86_spec_ctrl_restore_host(svm->virt_spec_ctrl);
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 8e8295e774f0..34641b3a6823 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -270,23 +270,12 @@ SYM_FUNC_START(__svm_vcpu_run)
>  	RESTORE_GUEST_SPEC_CTRL_BODY
>  	RESTORE_HOST_SPEC_CTRL_BODY
> 
> -10:	cmpb $0, kvm_rebooting
> -	jne 2b
> -	ud2
> -30:	cmpb $0, kvm_rebooting
> -	jne 4b
> -	ud2
> -50:	cmpb $0, kvm_rebooting
> -	jne 6b
> -	ud2
> -70:	cmpb $0, kvm_rebooting
> -	jne 8b
> -	ud2
> +10:	ud2
> 
>  	_ASM_EXTABLE(1b, 10b)
> -	_ASM_EXTABLE(3b, 30b)
> -	_ASM_EXTABLE(5b, 50b)
> -	_ASM_EXTABLE(7b, 70b)
> +	_ASM_EXTABLE(3b, 10b)
> +	_ASM_EXTABLE(5b, 10b)
> +	_ASM_EXTABLE(7b, 10b)
> 
>  SYM_FUNC_END(__svm_vcpu_run)
> 
> 
> Paolo
> 
