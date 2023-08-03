Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF8C76E36A
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbjHCIo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjHCIoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:44:24 -0400
Received: from ustc.edu.cn (email.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A190FDA;
        Thu,  3 Aug 2023 01:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Subject:
        Message-ID:Reply-To:References:MIME-Version:Content-Type:
        Content-Disposition:In-Reply-To; bh=yXnEgMyB+c/lKx03qRo/gn5A2aJh
        N2Ua96JMPHGvbm8=; b=sd+r0iqT9xJ6UUOW8AsRNOz5v/B21/0i9IhD0VfQOb3Y
        I7tulBEl0AUysnMflLMbQJCTVjgupVYn3CgsRqDgZzP3uLUSeGwVcFFpv0fXoRZd
        xECT/T4/yjpIgIr8cXdJ7buk3QzR9LiawPOC4ggwasebs5rvyJe0vEKUnhhiH+I=
Received: from localhost (unknown [139.224.204.105])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygDHmqbZaMtkmg8nAA--.458S2;
        Thu, 03 Aug 2023 16:44:09 +0800 (CST)
Date:   Thu, 3 Aug 2023 16:44:09 +0800
From:   Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
Message-ID: <ZMto2Yza4rd2JdXf@iZuf6hx7901barev1c282cZ>
Reply-To: Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com>
 <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn>
 <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ>
 <ZMphvF+0H9wHQr5B@google.com>
 <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com>
 <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com>
 <bdf548d1-84cb-6885-c4eb-cbb16c4a3e3b@amd.com>
 <ZMsekJG8PF0f4sCp@iZuf6hx7901barev1c282cZ>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMsekJG8PF0f4sCp@iZuf6hx7901barev1c282cZ>
X-CM-TRANSID: LkAmygDHmqbZaMtkmg8nAA--.458S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKr4UKry7GrykJr4xuF43trb_yoW7trWxpF
        W8G3WDtr4UJr18AryUtr4kAryYyr4fAr4jqr1UAw13Ja4qk3Wrtr4xtrW5CF1UCr4fAr1U
        tr10q3srWryUArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUy2b7Iv0xC_KF4lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E
        4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
        WUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
        Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rV
        WrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_
        Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jOb18UUUUU=
X-CM-SenderInfo: pzx200xj1rqzxdloh3xvwfhvlgxou0/
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 11:27:12AM +0800, Wu Zongyo wrote:
> On Wed, Aug 02, 2023 at 03:03:45PM -0500, Tom Lendacky wrote:
> > On 8/2/23 09:33, Tom Lendacky wrote:
> > > On 8/2/23 09:25, Tom Lendacky wrote:
> > > > On 8/2/23 09:01, Sean Christopherson wrote:
> > > > > On Wed, Aug 02, 2023, Wu Zongyo wrote:
> > > > > > On Mon, Jul 31, 2023 at 11:45:29PM +0800, wuzongyong wrote:
> > > > > > > 
> > > > > > > On 2023/7/31 23:03, Tom Lendacky wrote:
> > > > > > > > On 7/31/23 09:30, Sean Christopherson wrote:
> > > > > > > > > On Sat, Jul 29, 2023, wuzongyong wrote:
> > > > > > > > > > Hi,
> > > > > > > > > > I am writing a firmware in Rust to support
> > > > > > > > > > SEV based on project td-shim[1].
> > > > > > > > > > But when I create a SEV VM (just SEV, no
> > > > > > > > > > SEV-ES and no SEV-SNP) with the firmware,
> > > > > > > > > > the linux kernel crashed because the int3
> > > > > > > > > > instruction in int3_selftest() cause a
> > > > > > > > > > #UD.
> > > > > > > > > 
> > > > > > > > > ...
> > > > > > > > > 
> > > > > > > > > > BTW, if a create a normal VM without SEV by
> > > > > > > > > > qemu & OVMF, the int3 instruction always
> > > > > > > > > > generates a
> > > > > > > > > > #BP.
> > > > > > > > > > So I am confused now about the behaviour of
> > > > > > > > > > int3 instruction, could anyone help to
> > > > > > > > > > explain the behaviour?
> > > > > > > > > > Any suggestion is appreciated!
> > > > > > > > > 
> > > > > > > > > Have you tried my suggestions from the other thread[*]?
> > > > > > > Firstly, I'm sorry for sending muliple mails with the
> > > > > > > same content. I thought the mails I sent previously
> > > > > > > didn't be sent successfully.
> > > > > > > And let's talk the problem here.
> > > > > > > > > 
> > > > > > > > > ??? : > > I'm curious how this happend. I cannot
> > > > > > > > > find any condition that would
> > > > > > > > > ??? : > > cause the int3 instruction generate a
> > > > > > > > > #UD according to the AMD's spec.
> > > > > > > > > ??? :
> > > > > > > > > ??? : One possibility is that the value from
> > > > > > > > > memory that gets executed diverges from the
> > > > > > > > > ??? : value that is read out be the #UD handler,
> > > > > > > > > e.g. due to patching (doesn't seem to
> > > > > > > > > ??? : be the case in this test), stale cache/tlb entries, etc.
> > > > > > > > > ??? :
> > > > > > > > > ??? : > > BTW, it worked nomarlly with qemu and ovmf.
> > > > > > > > > ??? : >
> > > > > > > > > ??? : > Does this happen every time you boot the
> > > > > > > > > guest with your firmware? What
> > > > > > > > > ??? : > processor are you running on?
> > > > > > > > > ??? :
> > > > > > > Yes, every time.
> > > > > > > The processor I used is EPYC 7T83.
> > > > > > > > > ??? : And have you ruled out KVM as the
> > > > > > > > > culprit?? I.e. verified that KVM is NOT
> > > > > > > > > injecting
> > > > > > > > > ??? : a #UD.? That obviously shouldn't happen,
> > > > > > > > > but it should be easy to check via KVM
> > > > > > > > > ??? : tracepoints.
> > > > > > > > 
> > > > > > > > I have a feeling that KVM is injecting the #UD, but
> > > > > > > > it will take instrumenting KVM to see which path the
> > > > > > > > #UD is being injected from.
> > > > > > > > 
> > > > > > > > Wu Zongyo, can you add some instrumentation to
> > > > > > > > figure that out if the trace points towards KVM
> > > > > > > > injecting the #UD?
> > > > > > > Ok, I will try to do that.
> > > > > > You're right. The #UD is injected by KVM.
> > > > > > 
> > > > > > The path I found is:
> > > > > > ???? svm_vcpu_run
> > > > > > ???????? svm_complete_interrupts
> > > > > > ??????? kvm_requeue_exception // vector = 3
> > > > > > ??????????? kvm_make_request
> > > > > > 
> > > > > > ???? vcpu_enter_guest
> > > > > > ???????? kvm_check_and_inject_events
> > > > > > ??????? svm_inject_exception
> > > > > > ??????????? svm_update_soft_interrupt_rip
> > > > > > ??????????? __svm_skip_emulated_instruction
> > > > > > ??????????????? x86_emulate_instruction
> > > > > > ??????????????? svm_can_emulate_instruction
> > > > > > ??????????????????? kvm_queue_exception(vcpu, UD_VECTOR)
> > > > > > 
> > > > > > Does this mean a #PF intercept occur when the guest try to deliver a
> > > > > > #BP through the IDT? But why?
> > > > > 
> > > > > I doubt it's a #PF.? A #NPF is much more likely, though it could
> > > > > be something
> > > > > else entirely, but I'm pretty sure that would require bugs in
> > > > > both the host and
> > > > > guest.
> > > > > 
> > > > > What is the last exit recorded by trace_kvm_exit() before the
> > > > > #UD is injected?
> > > > 
> > > > I'm guessing it was a #NPF, too. Could it be related to the changes that
> > > > went in around svm_update_soft_interrupt_rip()?
> Yes, it's a #NPF with exit code 0x400.
> 
> There must be something I didn't handle corretly since it behave normally with
> qemu & ovmf If I don't add int3 before mcheck_cpu_init().
> 
> So it'a about memory, is there something I need to pay special attention
> to?
> 
> Thanks
I check the fault address of #NPF, and it is the IDT entry address of
the guest kernel. The NPT page table is not constructed for the IDT
entry and the #NPF is generated when guest try to access IDT.

With qemu & ovmf, I didn't see the #NPF when guest invoke the int3
handler. That means the NPT page table has already been constructed, but
when?

> > > > 
> > > > 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the
> > > > instruction")
> > > 
> > > Sorry, that should have been:
> > > 
> > > 7e5b5ef8dca3 ("KVM: SVM: Re-inject INTn instead of retrying the insn on
> > > "failure"")
> > 
> > Doh! I was right the first time... sigh
> > 
> > 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
> > 
> > Thanks,
> > Tom
> > 
> > > 
> > > > 
> > > > Before this the !nrips check would prevent the call into
> > > > svm_skip_emulated_instruction(). But now, there is a call to:
> > > > 
> > > > ?? svm_update_soft_interrupt_rip()
> > > > ???? __svm_skip_emulated_instruction()
> > > > ?????? kvm_emulate_instruction()
> > > > ???????? x86_emulate_instruction() (passed a NULL insn pointer)
> > > > ?????????? kvm_can_emulate_insn() (passed a NULL insn pointer)
> > > > ???????????? svm_can_emulate_instruction() (passed NULL insn pointer)
> > > > 
> > > > Because it is an SEV guest, it ends up in the "if (unlikely(!insn))" path
> > > > and injects the #UD.
> > > > 
> > > > Thanks,
> > > > Tom
> > > > 

