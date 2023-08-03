Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED38B76DEFF
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 05:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbjHCD2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 23:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjHCD1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 23:27:44 -0400
Received: from ustc.edu.cn (email.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F561272A;
        Wed,  2 Aug 2023 20:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:Reply-To:References:MIME-Version:Content-Type:
        Content-Disposition:Content-Transfer-Encoding:In-Reply-To; bh=bd
        dxYDM5apsIslXV2cs/xXI53EabgYuAyY8wWPoNGvg=; b=jqVdQduAIgxMdGz7TI
        2b1OA66CSkzQSeTSfR9ZTPN12tyTruIWp66Ri6I/3gkc9OO3ftdCdoYweYtTMGvz
        I1h35JyO/j/BH9NB0t5LX582OQaWoExvOBM+VD6R7sRi7JxTmqtScQjGm1QDzSsF
        DktuJVGkO9eAhbDMBxMFUDuAM=
Received: from localhost (unknown [139.224.204.105])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBn1ByQHstko0UjAA--.5436S2;
        Thu, 03 Aug 2023 11:27:12 +0800 (CST)
Date:   Thu, 3 Aug 2023 11:27:12 +0800
From:   Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
Message-ID: <ZMsekJG8PF0f4sCp@iZuf6hx7901barev1c282cZ>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bdf548d1-84cb-6885-c4eb-cbb16c4a3e3b@amd.com>
X-CM-TRANSID: LkAmygBn1ByQHstko0UjAA--.5436S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKr1DZr4xGF47Zw13Jw15CFg_yoW7CFW7pF
        Z7tF15tFWUJr1kJr1Utr1UJry5tr47Jw1UXr1UJFyrJrWqyr1Fgr4UXrn09F1DJr4rJr1U
        tw18J3srur17ArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUy2b7Iv0xC_tr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s02
        6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
        I_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
        6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
        0_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j
        6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jY6wZUUUUU=
X-CM-SenderInfo: pzx200xj1rqzxdloh3xvwfhvlgxou0/
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023 at 03:03:45PM -0500, Tom Lendacky wrote:
> On 8/2/23 09:33, Tom Lendacky wrote:
> > On 8/2/23 09:25, Tom Lendacky wrote:
> > > On 8/2/23 09:01, Sean Christopherson wrote:
> > > > On Wed, Aug 02, 2023, Wu Zongyo wrote:
> > > > > On Mon, Jul 31, 2023 at 11:45:29PM +0800, wuzongyong wrote:
> > > > > > 
> > > > > > On 2023/7/31 23:03, Tom Lendacky wrote:
> > > > > > > On 7/31/23 09:30, Sean Christopherson wrote:
> > > > > > > > On Sat, Jul 29, 2023, wuzongyong wrote:
> > > > > > > > > Hi,
> > > > > > > > > I am writing a firmware in Rust to support
> > > > > > > > > SEV based on project td-shim[1].
> > > > > > > > > But when I create a SEV VM (just SEV, no
> > > > > > > > > SEV-ES and no SEV-SNP) with the firmware,
> > > > > > > > > the linux kernel crashed because the int3
> > > > > > > > > instruction in int3_selftest() cause a
> > > > > > > > > #UD.
> > > > > > > > 
> > > > > > > > ...
> > > > > > > > 
> > > > > > > > > BTW, if a create a normal VM without SEV by
> > > > > > > > > qemu & OVMF, the int3 instruction always
> > > > > > > > > generates a
> > > > > > > > > #BP.
> > > > > > > > > So I am confused now about the behaviour of
> > > > > > > > > int3 instruction, could anyone help to
> > > > > > > > > explain the behaviour?
> > > > > > > > > Any suggestion is appreciated!
> > > > > > > > 
> > > > > > > > Have you tried my suggestions from the other thread[*]?
> > > > > > Firstly, I'm sorry for sending muliple mails with the
> > > > > > same content. I thought the mails I sent previously
> > > > > > didn't be sent successfully.
> > > > > > And let's talk the problem here.
> > > > > > > > 
> > > > > > > >     : > > I'm curious how this happend. I cannot
> > > > > > > > find any condition that would
> > > > > > > >     : > > cause the int3 instruction generate a
> > > > > > > > #UD according to the AMD's spec.
> > > > > > > >     :
> > > > > > > >     : One possibility is that the value from
> > > > > > > > memory that gets executed diverges from the
> > > > > > > >     : value that is read out be the #UD handler,
> > > > > > > > e.g. due to patching (doesn't seem to
> > > > > > > >     : be the case in this test), stale cache/tlb entries, etc.
> > > > > > > >     :
> > > > > > > >     : > > BTW, it worked nomarlly with qemu and ovmf.
> > > > > > > >     : >
> > > > > > > >     : > Does this happen every time you boot the
> > > > > > > > guest with your firmware? What
> > > > > > > >     : > processor are you running on?
> > > > > > > >     :
> > > > > > Yes, every time.
> > > > > > The processor I used is EPYC 7T83.
> > > > > > > >     : And have you ruled out KVM as the
> > > > > > > > culprit?  I.e. verified that KVM is NOT
> > > > > > > > injecting
> > > > > > > >     : a #UD.  That obviously shouldn't happen,
> > > > > > > > but it should be easy to check via KVM
> > > > > > > >     : tracepoints.
> > > > > > > 
> > > > > > > I have a feeling that KVM is injecting the #UD, but
> > > > > > > it will take instrumenting KVM to see which path the
> > > > > > > #UD is being injected from.
> > > > > > > 
> > > > > > > Wu Zongyo, can you add some instrumentation to
> > > > > > > figure that out if the trace points towards KVM
> > > > > > > injecting the #UD?
> > > > > > Ok, I will try to do that.
> > > > > You're right. The #UD is injected by KVM.
> > > > > 
> > > > > The path I found is:
> > > > >      svm_vcpu_run
> > > > >          svm_complete_interrupts
> > > > >         kvm_requeue_exception // vector = 3
> > > > >             kvm_make_request
> > > > > 
> > > > >      vcpu_enter_guest
> > > > >          kvm_check_and_inject_events
> > > > >         svm_inject_exception
> > > > >             svm_update_soft_interrupt_rip
> > > > >             __svm_skip_emulated_instruction
> > > > >                 x86_emulate_instruction
> > > > >                 svm_can_emulate_instruction
> > > > >                     kvm_queue_exception(vcpu, UD_VECTOR)
> > > > > 
> > > > > Does this mean a #PF intercept occur when the guest try to deliver a
> > > > > #BP through the IDT? But why?
> > > > 
> > > > I doubt it's a #PF.  A #NPF is much more likely, though it could
> > > > be something
> > > > else entirely, but I'm pretty sure that would require bugs in
> > > > both the host and
> > > > guest.
> > > > 
> > > > What is the last exit recorded by trace_kvm_exit() before the
> > > > #UD is injected?
> > > 
> > > I'm guessing it was a #NPF, too. Could it be related to the changes that
> > > went in around svm_update_soft_interrupt_rip()?
Yes, it's a #NPF with exit code 0x400.

There must be something I didn't handle corretly since it behave normally with
qemu & ovmf If I don't add int3 before mcheck_cpu_init().

So it'a about memory, is there something I need to pay special attention
to?

Thanks
> > > 
> > > 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the
> > > instruction")
> > 
> > Sorry, that should have been:
> > 
> > 7e5b5ef8dca3 ("KVM: SVM: Re-inject INTn instead of retrying the insn on
> > "failure"")
> 
> Doh! I was right the first time... sigh
> 
> 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
> 
> Thanks,
> Tom
> 
> > 
> > > 
> > > Before this the !nrips check would prevent the call into
> > > svm_skip_emulated_instruction(). But now, there is a call to:
> > > 
> > >    svm_update_soft_interrupt_rip()
> > >      __svm_skip_emulated_instruction()
> > >        kvm_emulate_instruction()
> > >          x86_emulate_instruction() (passed a NULL insn pointer)
> > >            kvm_can_emulate_insn() (passed a NULL insn pointer)
> > >              svm_can_emulate_instruction() (passed NULL insn pointer)
> > > 
> > > Because it is an SEV guest, it ends up in the "if (unlikely(!insn))" path
> > > and injects the #UD.
> > > 
> > > Thanks,
> > > Tom
> > > 

