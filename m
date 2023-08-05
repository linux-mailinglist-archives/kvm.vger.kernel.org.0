Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022C5770CCC
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 02:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjHEA4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 20:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjHEA4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 20:56:17 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB791704
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 17:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NEnC9HafMTNwHpy9Qx+WTJWK9AEMzfkvSrTH/A9L5w0=; b=kgMs9SCNiZfNauZbHjGvlG7FJT
        T9JhcDU/hnkaWZc6VTTDfTEHQsrUDGIP0XgrreXVeAv0xbxV/Zolvs/CZ1rYphjD7jrVghT24Gbbd
        tDFxZ7lFSWo/GwXzuMMmCG3hmk+Z3xcxE+md+yiGWYonANkz2Iq4haJ0sse/ub0bTQtCjB0I4FpJe
        4qtcx6Oa0HhD6kag4ofq//E+ax3qCq/HxIpmdU9J2TFbxiZwM9fHzEKHG8+IDC4ICMZJz9706tKLW
        T0AImw3dewfnjYP5TRv5lITQdwMsKAcQIGffJDH9q0ZeUXNTj8VoBHVgUw9BEO+ySt/0dYmS1LBfx
        qHwqBVHQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qS5aC-000ke6-1f;
        Sat, 05 Aug 2023 00:55:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 25EF7300235;
        Sat,  5 Aug 2023 02:55:52 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 02A0327960555; Sat,  5 Aug 2023 02:55:51 +0200 (CEST)
Date:   Sat, 5 Aug 2023 02:55:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nikunj A Dadhania <nikunj@amd.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH] KVM: SVM: Add exception to disable objtool warning for
 kvm-amd.o
Message-ID: <20230805005551.GT212435@hirez.programming.kicks-ass.net>
References: <20230802091107.1160320-1-nikunj@amd.com>
 <20230803120637.GD214207@hirez.programming.kicks-ass.net>
 <b22761ea-cab6-0e11-cdc9-ec26c300cd3f@redhat.com>
 <20230803190728.GJ212435@hirez.programming.kicks-ass.net>
 <7c2f6fa3-23ba-6df5-24d9-28f95f866574@redhat.com>
 <20230804204840.GR212435@hirez.programming.kicks-ass.net>
 <20230804231954.swdjx6lxkccxals6@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804231954.swdjx6lxkccxals6@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 06:19:54PM -0500, Josh Poimboeuf wrote:

> Looks mostly right, except this now creates an unnecessary gap in
> unwinding coverage for the ORC unwinder.  So it's better to put the
> FP-specific changes behind CONFIG_FRAME_POINTER:

Fair enough.

> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 80e3fe184d17..0c5c2f090e93 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -3,10 +3,6 @@
>  ccflags-y += -I $(srctree)/arch/x86/kvm
>  ccflags-$(CONFIG_KVM_WERROR) += -Werror
>  
> -ifeq ($(CONFIG_FRAME_POINTER),y)
> -OBJECT_FILES_NON_STANDARD_vmenter.o := y
> -endif
> -
>  include $(srctree)/virt/kvm/Makefile.kvm
>  
>  kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 8e8295e774f0..51f6851b1ae5 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -99,6 +99,9 @@
>   */
>  SYM_FUNC_START(__svm_vcpu_run)
>  	push %_ASM_BP
> +#ifdef CONFIG_FRAME_POINTER
> +	mov %_ASM_SP, %_ASM_BP
> +#endif
>  #ifdef CONFIG_X86_64
>  	push %r15
>  	push %r14
> @@ -121,7 +124,20 @@ SYM_FUNC_START(__svm_vcpu_run)
>  	/* Needed to restore access to percpu variables.  */
>  	__ASM_SIZE(push) PER_CPU_VAR(svm_data + SD_save_area_pa)
>  
> -	/* Finally save @svm. */
> +	/*
> +	 * Finally save frame pointer and @svm.
> +	 *
> +	 * Clobbering BP here is mostly ok since GIF will block NMIs and with
> +	 * the exception of #MC and the kvm_rebooting _ASM_EXTABLE()s below
> +	 * nothing untoward will happen until BP is restored.
> +	 *
> +	 * The kvm_rebooting exceptions should not want to unwind stack, and
> +	 * while #MV might want to unwind stack, it is ultimately fatal.
> +	 */

Aside from me not being able to type #MC, I did realize that the
kvm_reboot exception will go outside noinstr code and can hit
tracing/instrumentation and do unwinds from there.
