Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8207F60B895
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 21:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbiJXTvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 15:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbiJXTvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 15:51:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1261270820
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 11:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666635321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cqm42HCzTPmqRHvRuk2lK8D5KJGi0ESjRVRr0rW8XG8=;
        b=RZkndFMLQvNcCRfAIUusiIvKbP+D5hdCHDnr1y6H/kkMybpcEds/DvvXm73xLKu1MFirVb
        KnwmnZLtRkrBjX5BlI6F323Z/eDrvy6LykjXscu6u0zw3eksvyN0p31smkvPR+ZRbmkJ6q
        VOjl7pJIKt+Br+GdQ4CEusy9o8rfADc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-393-grMeT09sNvuesR8pKS5HsA-1; Mon, 24 Oct 2022 08:45:58 -0400
X-MC-Unique: grMeT09sNvuesR8pKS5HsA-1
Received: by mail-qt1-f198.google.com with SMTP id b12-20020a05622a020c00b003983950639bso6981061qtx.16
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 05:45:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cqm42HCzTPmqRHvRuk2lK8D5KJGi0ESjRVRr0rW8XG8=;
        b=umtma/48FxyOHiQXTG7n0L35xu53QMYM+xXfCaqA4YmL+tYcPf4U1taJMdqXwMy+0F
         XGh8FL+2A7DMnhzQVS5RiQgaLO+Ba9UgTiA0gGY4wfX9AM1MzrWyZ/4S50/upsQH5tsO
         Blurz3LyB9nbmx8e6FbSBOSNz1w2KfXA8+0p7tcNDSelMCK304j+5vMC4cG+mrzBq1Yz
         5Fl+gUdSo90CONLCKfAIlKgpmB4cufGEq3xHx+PR/GBnnBR7y1eaX4NNewugnMItuL1m
         u6IBZmqRJEmb9N0ixhsGw3hFHBVbAilDYJbLhFIEXJdD8rQvPB+i2k4hFA+HnvhbCdAK
         Ix1Q==
X-Gm-Message-State: ACrzQf1paTj/iwP2Xo8iFClcI+wjongFu9v0AIw6qYnAzeAYijgWB9wU
        MKerSUtpIL5vlkTnv9JIoZe5zic1H4tH5SlEfPkaMKXv4SK7QLOBHJ7LEf0NzMLTsiul1mOBV/P
        jY4GeTyny7h0F
X-Received: by 2002:a05:622a:1905:b0:39c:f723:f31 with SMTP id w5-20020a05622a190500b0039cf7230f31mr25769170qtc.54.1666615557415;
        Mon, 24 Oct 2022 05:45:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4yxniUdLYLT9lwvGHDLr6ysfIYuxfhFF/WjNZznxO/H4YlhilYZU3XuxdxSyQBr0/jE3231A==
X-Received: by 2002:a05:622a:1905:b0:39c:f723:f31 with SMTP id w5-20020a05622a190500b0039cf7230f31mr25769158qtc.54.1666615557096;
        Mon, 24 Oct 2022 05:45:57 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id f11-20020a05620a408b00b006eeb51bb33dsm15261243qko.78.2022.10.24.05.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 05:45:56 -0700 (PDT)
Message-ID: <35fe5a9c8ef5155f226df7beb24917d9b2020871.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 14/16] svm: rewerite vm entry macros
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 24 Oct 2022 15:45:53 +0300
In-Reply-To: <Y1GZu5ztBadhFphk@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-15-mlevitsk@redhat.com>
         <Y1GZu5ztBadhFphk@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-20 at 18:55 +0000, Sean Christopherson wrote:
> On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> 
> Changelog please.  This patch in particular is extremely difficult to review
> without some explanation of what is being done, and why.
> 
> If it's not too much trouble, splitting this over multiple patches would be nice.
> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  lib/x86/svm_lib.h | 58 +++++++++++++++++++++++++++++++++++++++
> >  x86/svm.c         | 51 ++++++++++------------------------
> >  x86/svm.h         | 70 ++---------------------------------------------
> >  x86/svm_tests.c   | 24 ++++++++++------
> >  4 files changed, 91 insertions(+), 112 deletions(-)
> > 
> > diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> > index 27c3b137..59db26de 100644
> > --- a/lib/x86/svm_lib.h
> > +++ b/lib/x86/svm_lib.h
> > @@ -71,4 +71,62 @@ u8* svm_get_io_bitmap(void);
> >  #define MSR_BITMAP_SIZE 8192
> >  
> >  
> > +struct svm_extra_regs
> 
> Why not just svm_gprs?  This could even include RAX by grabbing it from the VMCB
> after VMRUN.

I prefer to have a single source of truth - if I grab it from vmcb, then
it will have to be synced to vmcb on each vmrun, like the KVM does,
but it also has dirty registers bitmap and such. I prefer to keep it simple.

Plus there is also RSP in vmcb, and RFLAGS, and even RIP to some extent is a GPR.
To call this struct svm_gprs, I would have to include them there as well.
And also there is segment registers, etc, etc.

So instead of pretending that this struct contains all the GPRs of the guest
(or host while guest is running) I renamed it to state that it contains only
some gprs that SVM doesn't context switch.

> 
> > +{
> > +    u64 rbx;
> > +    u64 rcx;
> > +    u64 rdx;
> > +    u64 rbp;
> > +    u64 rsi;
> > +    u64 rdi;
> > +    u64 r8;
> > +    u64 r9;
> > +    u64 r10;
> > +    u64 r11;
> > +    u64 r12;
> > +    u64 r13;
> > +    u64 r14;
> > +    u64 r15;
> 
> Tab instead of spaces.
> 
> > +};
> > +
> > +#define SWAP_GPRS(reg) \
> > +               "xchg %%rcx, 0x08(%%" reg ")\n\t"       \
> 
> No need for 2-tab indentation.
> 
> > +               "xchg %%rdx, 0x10(%%" reg ")\n\t"       \
> > +               "xchg %%rbp, 0x18(%%" reg ")\n\t"       \
> > +               "xchg %%rsi, 0x20(%%" reg ")\n\t"       \
> > +               "xchg %%rdi, 0x28(%%" reg ")\n\t"       \
> > +               "xchg %%r8,  0x30(%%" reg ")\n\t"       \
> > +               "xchg %%r9,  0x38(%%" reg ")\n\t"       \
> > +               "xchg %%r10, 0x40(%%" reg ")\n\t"       \
> > +               "xchg %%r11, 0x48(%%" reg ")\n\t"       \
> > +               "xchg %%r12, 0x50(%%" reg ")\n\t"       \
> > +               "xchg %%r13, 0x58(%%" reg ")\n\t"       \
> > +               "xchg %%r14, 0x60(%%" reg ")\n\t"       \
> > +               "xchg %%r15, 0x68(%%" reg ")\n\t"       \
> > +               \
> 
> Extra line.
> 
> > +               "xchg %%rbx, 0x00(%%" reg ")\n\t"       \
> 
> Why is RBX last here, but first in the struct?  Ah, because the initial swap uses
> RBX as the scratch register.  Why use RAX for the post-VMRUN swap?  AFAICT, that's
> completely arbitrary.

Let me explain:

On entry to the guest the code has to save the host GPRs and then load the guest GPRs.

Host RAX and RBX are set by the gcc as I requested with "a" and "b" modifiers, but even
these should not be changed by the assembly code from the values set in the input.
(At least I haven't found a way to mark a register as both input and clobber)

Now RAX is the hardcoded input to VMRUN, thus I leave it alone, and use RBX as regs pointer,
which is restored to the guest value (and host value stored in the regs) at the end of SWAP_GPRs.

I could have used another GPR for regs pointer, but not RAX, because if I were to use RAX,
I would need then to restore it to vmcb pointer before vmrun, which will complicate the code.

That is what the kernel VMRUN code does though, however it doesn't preserve the host GPRs mostly,
relying on function ABI to preserve only registers that ABI states to be preserved.
IMHO all of this just doesn't matter much, as long as it works.

Now after the VMRUN, all have is useless RAX (points to VMCB) and RSP still pointing to the stack.
Guest values of these were stored to VMCB and host values restored from host save area by the CPU.

So after VMRUN no register can be touched but RAX, you can't even pop values from the stack,
since that would overwrite the guest value.

So on restore I pop from the stack the regs pointer to RAX, and using it I swap the guest and host GPRs.
and then I restore the RAX again to its VMCB pointer value.

I hope that explains why on entry I use RBX and on exit I use RAX.

If I switch to full blown assembly function for this, then I could do it.

Note though that my LBR tests do still need this as a macro because they must not do
any extra jumps/calls as these clobber the LBR registers.

> 
> > +
> > +
> 
> > +#define __SVM_VMRUN(vmcb, regs, label)          \
> > +               asm volatile (                          \
> 
> Unnecessarily deep indentation.
> 
> > +                       "vmload %%rax\n\t"                  \
> > +                       "push %%rax\n\t"                    \
> > +                       "push %%rbx\n\t"                    \
> > +                       SWAP_GPRS("rbx")                    \
> > +                       ".global " label "\n\t"             \
> > +                       label ": vmrun %%rax\n\t"           \
> > +                       "vmsave %%rax\n\t"                  \
> > +                       "pop %%rax\n\t"                     \
> > +                       SWAP_GPRS("rax")                    \
> > +                       "pop %%rax\n\t"                     \
> > +                       :                                   \
> > +                       : "a" (virt_to_phys(vmcb)),         \
> > +                         "b"(regs)                         \
> > +                       /* clobbers*/                       \
> > +                       : "memory"                          \
> > +               );
> 
> If we're going to rewrite this, why not turn it into a proper assembly routine?
> E.g. the whole test_run() noinline thing just so that vmrun_rip isn't redefined
> is gross.

I had limited time working on this, but yes it makes sense.
I see if I find time to do it.


> 
> > diff --git a/x86/svm.c b/x86/svm.c
> > index 37b4cd38..9484a6d1 100644
> > --- a/x86/svm.c
> > +++ b/x86/svm.c
> > @@ -76,11 +76,11 @@ static void test_thunk(struct svm_test *test)
> >         vmmcall();
> >  }
> >  
> > -struct regs regs;
> > +struct svm_extra_regs regs;
> >  
> > -struct regs get_regs(void)
> > +struct svm_extra_regs* get_regs(void)
> >  {
> > -       return regs;
> > +       return &regs;
> 
> This isn't strictly necessary, is it?  I.e. avoiding the copy can be done in a
> separate patch, no?
Yes.
> 
> > @@ -2996,7 +2998,7 @@ static void svm_lbrv_test1(void)
> >  
> >         wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
> >         DO_BRANCH(host_branch1);
> > -       SVM_BARE_VMRUN;
> > +       SVM_VMRUN(vmcb,regs);
> 
> Space after the comma.  Multiple cases below too.
> 
> >         dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> >  
> >         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> > @@ -3011,6 +3013,8 @@ static void svm_lbrv_test1(void)
> >  
> >  static void svm_lbrv_test2(void)
> >  {
> > +       struct svm_extra_regs* regs = get_regs();
> > +
> >         report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
> >  
> >         vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
> > @@ -3019,7 +3023,7 @@ static void svm_lbrv_test2(void)
> >         wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
> >         DO_BRANCH(host_branch2);
> >         wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
> > -       SVM_BARE_VMRUN;
> > +       SVM_VMRUN(vmcb,regs);
> >         dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> >         wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
> >  
> > @@ -3035,6 +3039,8 @@ static void svm_lbrv_test2(void)
> >  
> >  static void svm_lbrv_nested_test1(void)
> >  {
> > +       struct svm_extra_regs* regs = get_regs();
> > +
> >         if (!lbrv_supported()) {
> >                 report_skip("LBRV not supported in the guest");
> >                 return;
> > @@ -3047,7 +3053,7 @@ static void svm_lbrv_nested_test1(void)
> >  
> >         wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
> >         DO_BRANCH(host_branch3);
> > -       SVM_BARE_VMRUN;
> > +       SVM_VMRUN(vmcb,regs);
> >         dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> >         wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
> >  
> > @@ -3068,6 +3074,8 @@ static void svm_lbrv_nested_test1(void)
> >  
> >  static void svm_lbrv_nested_test2(void)
> >  {
> > +       struct svm_extra_regs* regs = get_regs();
> > +
> >         if (!lbrv_supported()) {
> >                 report_skip("LBRV not supported in the guest");
> >                 return;
> > @@ -3083,7 +3091,7 @@ static void svm_lbrv_nested_test2(void)
> >  
> >         wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
> >         DO_BRANCH(host_branch4);
> > -       SVM_BARE_VMRUN;
> > +       SVM_VMRUN(vmcb,regs);
> >         dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> >         wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
> >  
> > -- 
> > 2.26.3
> > 
> 

Best regards,
	Maxim Levitsky

