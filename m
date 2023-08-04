Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B1A76F7E5
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjHDCdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjHDCds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:33:48 -0400
Received: from ustc.edu.cn (email.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B9FB4224;
        Thu,  3 Aug 2023 19:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:Reply-To:References:MIME-Version:Content-Type:
        Content-Disposition:In-Reply-To; bh=EBhrcRFMBzAWOm64LZMJWLBVhYxm
        tGhdBvKAQ5lgBYE=; b=Wh5dde25GmuwklwJ81uWjJBzppn4Oc8m+1vYEcTO+SgQ
        4rr/6IpZEIbvxyxfHxkOw+dMjy7CO/q6wMjZxA424FQ8cwKz3OcxJgTwwtqfl7r1
        8DdxdxWq8qBTty24cgcf/ayVHVep+CuMqZKCwySAWOb4Yyf758xwid0xr2gVb0g=
Received: from localhost (unknown [139.224.204.105])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygBn1Bx4Y8xkRIguAA--.7404S2;
        Fri, 04 Aug 2023 10:33:28 +0800 (CST)
Date:   Fri, 4 Aug 2023 10:33:28 +0800
From:   Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
Message-ID: <ZMxjeB9PmCpJNgXF@iZuf6hx7901barev1c282cZ>
Reply-To: Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
References: <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn>
 <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ>
 <ZMphvF+0H9wHQr5B@google.com>
 <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com>
 <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com>
 <bdf548d1-84cb-6885-c4eb-cbb16c4a3e3b@amd.com>
 <ZMsekJG8PF0f4sCp@iZuf6hx7901barev1c282cZ>
 <ZMto2Yza4rd2JdXf@iZuf6hx7901barev1c282cZ>
 <ZMu7Cl6im9JwjHIQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMu7Cl6im9JwjHIQ@google.com>
X-CM-TRANSID: LkAmygBn1Bx4Y8xkRIguAA--.7404S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WFyrJF4fuF4xZry7Cw48WFg_yoW8Aw48pF
        yrJa10yF4ktrW7Grsayrn0yFW2y392krW5uryxGrn5Awn0v3s7XF4xWryjkr9xur1rK3WF
        qF4Yvw43uwn7Z3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyFb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E
        4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
        WUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
        Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rV
        WrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_
        GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8pnQUUUUUU==
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

On Thu, Aug 03, 2023 at 02:34:50PM +0000, Sean Christopherson wrote:
> On Thu, Aug 03, 2023, Wu Zongyo wrote:
> > On Thu, Aug 03, 2023 at 11:27:12AM +0800, Wu Zongyo wrote:
> > > > > > 
> > > > > > I'm guessing it was a #NPF, too. Could it be related to the changes that
> > > > > > went in around svm_update_soft_interrupt_rip()?
> > > Yes, it's a #NPF with exit code 0x400.
> > > 
> > > There must be something I didn't handle corretly since it behave normally with
> > > qemu & ovmf If I don't add int3 before mcheck_cpu_init().
> > > 
> > > So it'a about memory, is there something I need to pay special attention
> > > to?
> > > 
> > > Thanks
> > I check the fault address of #NPF, and it is the IDT entry address of
> > the guest kernel. The NPT page table is not constructed for the IDT
> > entry and the #NPF is generated when guest try to access IDT.
> > 
> > With qemu & ovmf, I didn't see the #NPF when guest invoke the int3
> > handler. That means the NPT page table has already been constructed, but
> > when?
> 
> More than likely, the page was used by the guest at some point earlier in boot.
> Why the page is faulted in for certain setups but not others isn't really all
> that interesting in terms of fixing the KVM bug, both guest behaviors are completely
> normal and should work.
> 
> Can you try this patch I suggested earlier?  If this fixes the problem, I'll post
> a formal patch.
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d381ad424554..2eace114a934 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -385,6 +385,9 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
>         }
> 
>         if (!svm->next_rip) {
> +               if (sev_guest(vcpu->kvm))
> +                       return 0;
> +
>                 if (unlikely(!commit_side_effects))
>                         old_rflags = svm->vmcb->save.rflags;
> 

Yes, the patch solves the problem.


