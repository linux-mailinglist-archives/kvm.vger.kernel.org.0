Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6527518FC80
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 19:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbgCWSQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 14:16:27 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41904 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgCWSQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 14:16:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id b1so7594775pgm.8
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 11:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oF1tkIGle6loJ68IzLpATfP9PzEsBIHwJQBtleldmqY=;
        b=hukwjY/xfQ3ON3p60ApXpQlAWY0xmuNX5Tj1X0+k1zGrlfaSGUofPsl1hjqi3v0Bsv
         eFUfIZD5p37PtdZt1CMm1r23pm0lm5cvqOrzv3c485vfu2I4rJILQio0rN0BmWAoL00P
         3r7X7Ja+n5tH5Yaf3jkKOMcUNzlCtdfi3oh/oocSZ+hVKPRNKa7sKKzHChe5GLiTBOdT
         mL0oNFo3e8oI9TV/N3pnSLjTh9kAdIXISMT1Uz7KXHgHsJi+8XnUrHYfa5oqKT9LwO/c
         sHcyr+OTTSHFSwUMr6Uv8ULzsQ5ZzbbNlcDM+LFz9h6YmfVw78SnC+GrmCdxIymFnoSR
         NZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oF1tkIGle6loJ68IzLpATfP9PzEsBIHwJQBtleldmqY=;
        b=hcVRv65YBZpprLUUZ4mPRVnXS30d5CsbaHWHV0pMQ6+i620j8qiirLBAL/WooKoYuk
         TcNnEGLVWKSvc1y8lpZAG/UrMjsHwsDaOInnsnGCuD8wfo9Az0mSf24GgmOrQ5kbhQq9
         DFmU33bmG3hdTC7tBsRwklpYDXkteTEN/+Q6PDjfuxIidgfI3lu/g6iHrmPjmn+0lWDT
         df48vWq1JIAW78TmP4n2DCI9QTMtFB4aMBfj53fZkGZ+NU8b1ehV4wMZU0duVHv5j/og
         +cJnGDfpt90ZhnwSdxdq7rlAFbedP6ux7L/8wPDFM3ZcWTCakyNehdhMuAyl7xTq/pv7
         4UCw==
X-Gm-Message-State: ANhLgQ0ROgVoSdnXuqTAnVNJ8iPFR1DLdfoHrSrB22Jba/47FTprEHhJ
        eqLt8R67CdrbVA7lEoP9cWQql84S9MExeHekndFOEA==
X-Google-Smtp-Source: ADFU+vv2iYLu1L6anIRJMMN/E+Q1Cdon51m2vsAakkb8bamzkUGQXaFvTiRkRiQhJ1qag+Z6OSvcOdlD220MkIz4r4M=
X-Received: by 2002:a63:4453:: with SMTP id t19mr22058669pgk.381.1584987385383;
 Mon, 23 Mar 2020 11:16:25 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000277a0405a16bd5c9@google.com> <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
 <5058aabe-f32d-b8ef-57ed-f9c0206304c5@redhat.com> <CAG_fn=WYtSoyi63ACaz-ya=Dbi+BFU-_mADDpL6gQvDimQscmw@mail.gmail.com>
 <20200323163925.GP28711@linux.intel.com> <CAKwvOdkE8OAu=Gj4MKWwpctka6==6EtrbF3e1tvF=jS2hBB3Ow@mail.gmail.com>
 <CAKwvOdkXi1MN2Yqqoa6ghw14tQ25WYgyJkSv35-+1KRb=cmhZw@mail.gmail.com>
 <CAG_fn=WE0BmuHSxUoBJWQ9dnZ4X5ZpBqcT9rQaDE_6HAfTYKQA@mail.gmail.com> <CAG_fn=Uf2dDo4K9X==wE=eL8HQMc1an8m8H18tvWd9Mkyhpskg@mail.gmail.com>
In-Reply-To: <CAG_fn=Uf2dDo4K9X==wE=eL8HQMc1an8m8H18tvWd9Mkyhpskg@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 23 Mar 2020 11:16:12 -0700
Message-ID: <CAKwvOdntYiM8afOA2nX6dtLp9FWk-1E3Mc+oVRJ_Y8X-9kr81Q@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in handle_external_interrupt_irqoff
To:     Alexander Potapenko <glider@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        syzbot <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 11:06 AM Alexander Potapenko <glider@google.com> wrote:
>
> On Mon, Mar 23, 2020 at 6:55 PM Alexander Potapenko <glider@google.com> wrote:
> >
> > I've reduced the faulty test case to the following code:
> >
> > =================================
> > a;
> > long b;
> > register unsigned long current_stack_pointer asm("rsp");
> > handle_external_interrupt_irqoff() {
> >   asm("and $0xfffffffffffffff0, %%rsp\n\tpush $%c[ss]\n\tpush "
> >       "%[sp]\n\tpushf\n\tpushq $%c[cs]\n\tcall *%[thunk_target]\n"
> >       : [ sp ] "=&r"(b), "+r" (current_stack_pointer)
> >       : [ thunk_target ] "rm"(a), [ ss ] "i"(3 * 8), [ cs ] "i"(2 * 8) );
> > }
> > =================================
> > (in fact creduce even throws away current_stack_pointer, but we
> > probably want to keep it to prove the point).
> >
> > Clang generates the following code for it:
> >
> > $ clang vmx.i -O2 -c -w -o vmx.o
> > $ objdump -d vmx.o
> > ...
> > 0000000000000000 <handle_external_interrupt_irqoff>:
> >    0: 8b 05 00 00 00 00    mov    0x0(%rip),%eax        # 6
> > <handle_external_interrupt_irqoff+0x6>
> >    6: 89 44 24 fc          mov    %eax,-0x4(%rsp)
> >    a: 48 83 e4 f0          and    $0xfffffffffffffff0,%rsp
> >    e: 6a 18                pushq  $0x18
> >   10: 50                    push   %rax
> >   11: 9c                    pushfq
> >   12: 6a 10                pushq  $0x10
> >   14: ff 54 24 fc          callq  *-0x4(%rsp)
> >   18: 48 89 05 00 00 00 00 mov    %rax,0x0(%rip)        # 1f
> > <handle_external_interrupt_irqoff+0x1f>
> >   1f: c3                    retq
> >
> > The question is whether using current_stack_pointer as an output is
> > actually a valid way to tell the compiler it should not clobber RSP.
> > Intuitively it is, but explicitly adding RSP to the clobber list
> > sounds a bit more bulletproof.
>
> Ok, I am wrong: according to
> https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html it's incorrect to
> list RSP in the clobber list.

You could force `entry` into a register:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4d22b1b5e822..083a7e980bb5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6277,7 +6277,7 @@ static void
handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 #endif
                ASM_CALL_CONSTRAINT
                :
-               THUNK_TARGET(entry),
+               [thunk_target] "a"(entry),
                [ss]"i"(__KERNEL_DS),
                [cs]"i"(__KERNEL_CS)
        );

(https://stackoverflow.com/a/48877683/1027966 had some interesting
feedback to this problem)
-- 
Thanks,
~Nick Desaulniers
