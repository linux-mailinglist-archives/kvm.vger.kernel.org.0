Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7272918FD0E
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 19:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgCWStP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 14:49:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33451 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbgCWStP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 14:49:15 -0400
Received: by mail-pf1-f194.google.com with SMTP id j1so5239860pfe.0
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 11:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Be0byEQEuSk3IXBoJdwRjwzTAyPFQzNjWKeAUvfe7g=;
        b=jVm9GcLifAjC4v5Sh1oiCIq2yhfvkJO92duEvhSWa8wGdGzKTi8EpTkeC+GCh407tm
         cdjUzowuRBdnRfsd2K65EdAY8TXEBV1eG8w4DSG4ZlFlltcWtrEHoSyCn277ffLp7jg4
         4XE38dW6bvW2ywAdCP1lwAFHl2P0XZf6YG8EOkDFxeQUmjvRzJFbvdvtPf5NOnLaR3KD
         VHK/ASBOsGfeQV7T4aS6AWmOk+/YF/LqbZdiSlPLRA0kSgVejjJrG7ztVCHQaoMNOTeJ
         jTC6Uk+/rpAv/MTBVgDN46/cSdIMNUoRPt4Bzf91NdvsxwfWoFWG06CFa+eaEX71xR+N
         +z2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Be0byEQEuSk3IXBoJdwRjwzTAyPFQzNjWKeAUvfe7g=;
        b=APOTQ4VQkHuNdEtn6y71jZMlvmCvGdk654i/gWftwZ3/Fkm0tAnfSmMawXAKehzfyr
         q853IeRyPf0ECOM4YNb71vCAxKOliutSb1j2kKiw5Sgo8iYrQDJBOSkrXNjKXkMIa1wm
         mbsCRKH+DIYQgsk/u01WeFi4h5p4RYxl/heeeXDdBDWFdzsclpA+B8J22S7M1A+T2eM3
         KgvbqPnCD3T8tOwL4hk7OhHAAczNOPJiRktkFP+1wv6HFZD6eBfk0pXJQMwMhIF0h1s4
         YsuEWq/03BMhL3vSsseWv1OS6RCcSamRuv1V9/99JW0jK14AdvORFfiC4ZhXG4sEdGRk
         hhXQ==
X-Gm-Message-State: ANhLgQ2jghLBRQZVoGWdfD3JfB/9/Cl5LEl2MU21ZcsgMCwrDV8d/nsM
        /SftFjHUjFYlLX5Mko35k2z/FRDdLKo8n+9yZLgcRQ==
X-Google-Smtp-Source: ADFU+vvnpnqVAoDduMrcV8ToAM1RMBQSQ4Hr34mZ+t0XwoTT3dDL9piL85VMbLyDtkrAbdvsqmy9GZNf3wubp0QGrN4=
X-Received: by 2002:a63:a34d:: with SMTP id v13mr2286104pgn.10.1584989352808;
 Mon, 23 Mar 2020 11:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000277a0405a16bd5c9@google.com> <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
 <5058aabe-f32d-b8ef-57ed-f9c0206304c5@redhat.com> <CAG_fn=WYtSoyi63ACaz-ya=Dbi+BFU-_mADDpL6gQvDimQscmw@mail.gmail.com>
 <20200323163925.GP28711@linux.intel.com> <CAKwvOdkE8OAu=Gj4MKWwpctka6==6EtrbF3e1tvF=jS2hBB3Ow@mail.gmail.com>
 <CAKwvOdkXi1MN2Yqqoa6ghw14tQ25WYgyJkSv35-+1KRb=cmhZw@mail.gmail.com>
 <CAG_fn=WE0BmuHSxUoBJWQ9dnZ4X5ZpBqcT9rQaDE_6HAfTYKQA@mail.gmail.com>
 <CAG_fn=Uf2dDo4K9X==wE=eL8HQMc1an8m8H18tvWd9Mkyhpskg@mail.gmail.com> <CAKwvOdntYiM8afOA2nX6dtLp9FWk-1E3Mc+oVRJ_Y8X-9kr81Q@mail.gmail.com>
In-Reply-To: <CAKwvOdntYiM8afOA2nX6dtLp9FWk-1E3Mc+oVRJ_Y8X-9kr81Q@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 23 Mar 2020 11:49:01 -0700
Message-ID: <CAKwvOdn10Ts_AU6i+7toj7NkMwK-+0yr5wTrN0XEDudBWS0sPQ@mail.gmail.com>
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

On Mon, Mar 23, 2020 at 11:16 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Mon, Mar 23, 2020 at 11:06 AM Alexander Potapenko <glider@google.com> wrote:
> >
> > On Mon, Mar 23, 2020 at 6:55 PM Alexander Potapenko <glider@google.com> wrote:
> > >
> > > I've reduced the faulty test case to the following code:
> > >
> > > =================================
> > > a;
> > > long b;
> > > register unsigned long current_stack_pointer asm("rsp");
> > > handle_external_interrupt_irqoff() {
> > >   asm("and $0xfffffffffffffff0, %%rsp\n\tpush $%c[ss]\n\tpush "
> > >       "%[sp]\n\tpushf\n\tpushq $%c[cs]\n\tcall *%[thunk_target]\n"
> > >       : [ sp ] "=&r"(b), "+r" (current_stack_pointer)
> > >       : [ thunk_target ] "rm"(a), [ ss ] "i"(3 * 8), [ cs ] "i"(2 * 8) );
> > > }
> > > =================================
> > > (in fact creduce even throws away current_stack_pointer, but we
> > > probably want to keep it to prove the point).
> > >
> > > Clang generates the following code for it:
> > >
> > > $ clang vmx.i -O2 -c -w -o vmx.o
> > > $ objdump -d vmx.o
> > > ...
> > > 0000000000000000 <handle_external_interrupt_irqoff>:
> > >    0: 8b 05 00 00 00 00    mov    0x0(%rip),%eax        # 6
> > > <handle_external_interrupt_irqoff+0x6>
> > >    6: 89 44 24 fc          mov    %eax,-0x4(%rsp)
> > >    a: 48 83 e4 f0          and    $0xfffffffffffffff0,%rsp
> > >    e: 6a 18                pushq  $0x18
> > >   10: 50                    push   %rax
> > >   11: 9c                    pushfq
> > >   12: 6a 10                pushq  $0x10
> > >   14: ff 54 24 fc          callq  *-0x4(%rsp)
> > >   18: 48 89 05 00 00 00 00 mov    %rax,0x0(%rip)        # 1f
> > > <handle_external_interrupt_irqoff+0x1f>
> > >   1f: c3                    retq
> > >
> > > The question is whether using current_stack_pointer as an output is
> > > actually a valid way to tell the compiler it should not clobber RSP.
> > > Intuitively it is, but explicitly adding RSP to the clobber list
> > > sounds a bit more bulletproof.
> >
> > Ok, I am wrong: according to
> > https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html it's incorrect to
> > list RSP in the clobber list.
>
> You could force `entry` into a register:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4d22b1b5e822..083a7e980bb5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6277,7 +6277,7 @@ static void
> handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  #endif
>                 ASM_CALL_CONSTRAINT
>                 :
> -               THUNK_TARGET(entry),
> +               [thunk_target] "a"(entry),
>                 [ss]"i"(__KERNEL_DS),
>                 [cs]"i"(__KERNEL_CS)
>         );
>
> (https://stackoverflow.com/a/48877683/1027966 had some interesting
> feedback to this problem)

Sean said:
> It looks like clang doesn't honor
> ASM_CALL_CONSTRAINT, which effectively tells the compiler that %rsp is
> getting clobbered, e.g. the "mov %r14,0x8(%rsp)" is loading @entry for
> "callq *0x8(%rsp)", which breaks because of asm's pushes.

I'm not sure about this, I think ASM_CALL_CONSTRAINT may be a red
herring, based on the commit message that added it (commit
f5caf621ee357 ("x86/asm: Fix inline asm call constraints for Clang")).

Further, it seems the "m" in "rm" in THUNK_TARGET for
CONFIG_RETPOLINE=n is problematic.

THUNK_TARGET defines [thunk_target] as "rm" when CONFIG_RETPOLINE is
not set, which isn't constrained enough for this specific case; if
`entry` winds up at the bottom of the stack where rsp points to, then
`%rsp` is good enough to satisfy the constraints for using `entry` as
an input.  For inline assembly that modifies the the stack pointer
before using this input, the underspecification of constraints is
dangerous, and results in an indirect call to a previously pushed
flags register.

So maybe we can find why
commit 76b043848fd2 ("x86/retpoline: Add initial retpoline support")
added THUNK_TARGET with and without "m" constraint, and either:
- remove "m" from THUNK_TARGET. (Maybe this doesn't compile somewhere)
or
- use my above recommendation locally avoiding THUNK_TARGET.  We can
use "r" rather than "a" (what Clang would have picked) or "b (what GCC
would have picked) to give the compilers maximal flexibility.
-- 
Thanks,
~Nick Desaulniers
