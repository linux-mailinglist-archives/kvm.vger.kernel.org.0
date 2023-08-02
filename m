Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B31776CC21
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 13:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjHBL4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 07:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbjHBL4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 07:56:21 -0400
Received: from ustc.edu.cn (email.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E472E26B0;
        Wed,  2 Aug 2023 04:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:Reply-To:References:MIME-Version:Content-Type:
        Content-Disposition:In-Reply-To; bh=msXnw5IG4jvKLMzQa2hmaHiEHyhn
        q8MqCAoMVYtLez8=; b=vD/7w/cwOmZ3edXHeLLoku0r7UxarQs0TgHNr6vfjbOb
        MavwZ+Xh04TxWTDwF9JLFH50mTDtrRMhgAI+0rf7TNlNIbDXDp2zhA4x2O/J5gEc
        1VnpGNphY7VhaKAHy3tYxIzFKvWljEyWpPvjnWhWS9tOQOAYB0FJWxmvXa0Sbvo=
Received: from localhost (unknown [139.224.204.105])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBn1BxRRMpkBIUTAA--.3970S2;
        Wed, 02 Aug 2023 19:56:01 +0800 (CST)
Date:   Wed, 2 Aug 2023 19:56:01 +0800
From:   Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
Message-ID: <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ>
Reply-To: Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com>
 <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn>
X-CM-TRANSID: LkAmygBn1BxRRMpkBIUTAA--.3970S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXr1xGw1kKFyfXw17Xr4Dtwb_yoW5Xry8pF
        WxK3ZIkrs7Jrn3Zr4Dta1UAryFya9xGr47Xr18J3s8A3s0v3Za9ryIkrZ0k3ZrCrWfWw10
        v3y0qF9F9a4DArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyYb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
        1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWU
        JVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r
        W3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8
        JbIYCTnIWIevJa73UjIFyTuYvjxUc_-PUUUUU
X-CM-SenderInfo: pzx200xj1rqzxdloh3xvwfhvlgxou0/
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 11:45:29PM +0800, wuzongyong wrote:
> 
> On 2023/7/31 23:03, Tom Lendacky wrote:
> > On 7/31/23 09:30, Sean Christopherson wrote:
> >> On Sat, Jul 29, 2023, wuzongyong wrote:
> >>> Hi,
> >>> I am writing a firmware in Rust to support SEV based on project td-shim[1].
> >>> But when I create a SEV VM (just SEV, no SEV-ES and no SEV-SNP) with the firmware,
> >>> the linux kernel crashed because the int3 instruction in int3_selftest() cause a
> >>> #UD.
> >>
> >> ...
> >>
> >>> BTW, if a create a normal VM without SEV by qemu & OVMF, the int3 instruction always generates a
> >>> #BP.
> >>> So I am confused now about the behaviour of int3 instruction, could anyone help to explain the behaviour?
> >>> Any suggestion is appreciated!
> >>
> >> Have you tried my suggestions from the other thread[*]?
> Firstly, I'm sorry for sending muliple mails with the same content. I thought the mails I sent previously 
> didn't be sent successfully.
> And let's talk the problem here.
> >>
> >>    : > > I'm curious how this happend. I cannot find any condition that would
> >>    : > > cause the int3 instruction generate a #UD according to the AMD's spec.
> >>    :
> >>    : One possibility is that the value from memory that gets executed diverges from the
> >>    : value that is read out be the #UD handler, e.g. due to patching (doesn't seem to
> >>    : be the case in this test), stale cache/tlb entries, etc.
> >>    :
> >>    : > > BTW, it worked nomarlly with qemu and ovmf.
> >>    : >
> >>    : > Does this happen every time you boot the guest with your firmware? What
> >>    : > processor are you running on?
> >>    :
> Yes, every time.
> The processor I used is EPYC 7T83.
> >>    : And have you ruled out KVM as the culprit?  I.e. verified that KVM is NOT injecting
> >>    : a #UD.  That obviously shouldn't happen, but it should be easy to check via KVM
> >>    : tracepoints.
> >
> > I have a feeling that KVM is injecting the #UD, but it will take instrumenting KVM to see which path the #UD is being injected from.
> >
> > Wu Zongyo, can you add some instrumentation to figure that out if the trace points towards KVM injecting the #UD?
> Ok, I will try to do that.
You're right. The #UD is injected by KVM.

The path I found is:
    svm_vcpu_run
        svm_complete_interrupts
	    kvm_requeue_exception // vector = 3
	        kvm_make_request

    vcpu_enter_guest
        kvm_check_and_inject_events
	    svm_inject_exception
	        svm_update_soft_interrupt_rip
		    __svm_skip_emulated_instruction
		        x86_emulate_instruction
			    svm_can_emulate_instruction
			        kvm_queue_exception(vcpu, UD_VECTOR)

Does this mean a #PF intercept occur when the guest try to deliver a
#BP through the IDT? But why?

Thanks

> >
> > Thanks,
> > Tom
> >
> >>
> >> [*] https://lore.kernel.org/all/ZMFd5kkehlkIfnBA@google.com

