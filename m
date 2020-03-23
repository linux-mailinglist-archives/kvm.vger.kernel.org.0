Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867FC18FC48
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 19:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbgCWSGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 14:06:30 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:40267 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgCWSGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 14:06:30 -0400
Received: by mail-pf1-f176.google.com with SMTP id l184so7861039pfl.7
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 11:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KXLJ6VFfxrFZrwSfkhbx8s/k+sv6GEa0mybadcnXPi4=;
        b=agTtoD7/xmJ76Q4f/peu0SvnIjf7I/7ksbIm0Dq+4fUNxLcMT2a0PIU6yYxxb8P9XT
         x5VOKrLwrBNTz8XRvlXqLlDqCejbirKNcUSVG7Axs25XUnNuk8nCuF1iabTudPDZG2Km
         2jZqkUF4poz4tErZlCkaG8SOhPsXgB+P2LL3mqfQ1TWa23WKqaxTK5FD4HfYK6SuEHk0
         H0vNjCupJ1MjHt8xYibjjBpqt7Bj2Uu6S6Y72fhZBgqw3+irZ90L6+Mw0kWKrm8EaJ18
         Bzf5/J7NWIA1fESjMMHerWOoSNDpfKFjm1xe5KiarSpG2Ebfii/xr+wta77CMVsqXciN
         z6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KXLJ6VFfxrFZrwSfkhbx8s/k+sv6GEa0mybadcnXPi4=;
        b=L5vznXiKseIPYMOruPNuyvaNnKCDTShPF+FIpzCqOEI8VukGT/WXtYOiiYDg1aKb44
         bmORKzH32S1qYirhf0uDhRFPMBhD2LRYo20kTc+c8sgcltlY3EJkummHBZhPCmJVuHAi
         bIDVuzY/40+F3E06VcOMhKZolLBNmrUJIBOdgc8wYd41lwoYDIsOfMI7T1ZmKzA7UwzH
         oIUVYY2LJ0xqlxJtIrEiwCNfbFDxwI/7uZ54A1ZHriQyC3zygrdcqCV6kVKPKiNPMMmS
         w9YXdlEmFP7alJ6TRHRkk69XPu25TSEPE3GcfA1mErQ3SGsB3W9OXmgysSbXGCU0m7AE
         +nww==
X-Gm-Message-State: ANhLgQ3KkGC5wahCHRdEJahjjBIO1qTRPumWIdpIbgXhfMPr04bVOMS5
        ME5DpxJaezdpWlOhkhw8t+yZRjYZ7BxxJ+XBoo3Fyg==
X-Google-Smtp-Source: ADFU+vtGnpMIgFHH3SOOLWJ9G91PYJwF/AxwafsOHarZSBsqA4YP+vmLIs/CLtKIK7wnnWINd78LJn5Kdc2Ha2nzYYQ=
X-Received: by 2002:a63:4e22:: with SMTP id c34mr23785364pgb.263.1584986788735;
 Mon, 23 Mar 2020 11:06:28 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000277a0405a16bd5c9@google.com> <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
 <5058aabe-f32d-b8ef-57ed-f9c0206304c5@redhat.com> <CAG_fn=WYtSoyi63ACaz-ya=Dbi+BFU-_mADDpL6gQvDimQscmw@mail.gmail.com>
 <20200323163925.GP28711@linux.intel.com> <CAKwvOdkE8OAu=Gj4MKWwpctka6==6EtrbF3e1tvF=jS2hBB3Ow@mail.gmail.com>
 <CAKwvOdkXi1MN2Yqqoa6ghw14tQ25WYgyJkSv35-+1KRb=cmhZw@mail.gmail.com> <CAG_fn=WE0BmuHSxUoBJWQ9dnZ4X5ZpBqcT9rQaDE_6HAfTYKQA@mail.gmail.com>
In-Reply-To: <CAG_fn=WE0BmuHSxUoBJWQ9dnZ4X5ZpBqcT9rQaDE_6HAfTYKQA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 23 Mar 2020 11:06:16 -0700
Message-ID: <CAKwvOdkfaSeXV5zd2unGAtPdzmS9N1Z7kSUB0g13aGHDg9fc8w@mail.gmail.com>
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

On Mon, Mar 23, 2020 at 10:55 AM Alexander Potapenko <glider@google.com> wrote:
>
> I've reduced the faulty test case to the following code:
>
> =================================
> a;
> long b;
> register unsigned long current_stack_pointer asm("rsp");
> handle_external_interrupt_irqoff() {
>   asm("and $0xfffffffffffffff0, %%rsp\n\tpush $%c[ss]\n\tpush "
>       "%[sp]\n\tpushf\n\tpushq $%c[cs]\n\tcall *%[thunk_target]\n"
>       : [ sp ] "=&r"(b), "+r" (current_stack_pointer)
>       : [ thunk_target ] "rm"(a), [ ss ] "i"(3 * 8), [ cs ] "i"(2 * 8) );
> }
> =================================
> (in fact creduce even throws away current_stack_pointer, but we
> probably want to keep it to prove the point).
>
> Clang generates the following code for it:
>
> $ clang vmx.i -O2 -c -w -o vmx.o
> $ objdump -d vmx.o
> ...
> 0000000000000000 <handle_external_interrupt_irqoff>:
>    0: 8b 05 00 00 00 00    mov    0x0(%rip),%eax        # 6
> <handle_external_interrupt_irqoff+0x6>
>    6: 89 44 24 fc          mov    %eax,-0x4(%rsp)
>    a: 48 83 e4 f0          and    $0xfffffffffffffff0,%rsp
>    e: 6a 18                pushq  $0x18
>   10: 50                    push   %rax
>   11: 9c                    pushfq
>   12: 6a 10                pushq  $0x10
>   14: ff 54 24 fc          callq  *-0x4(%rsp)
>   18: 48 89 05 00 00 00 00 mov    %rax,0x0(%rip)        # 1f
> <handle_external_interrupt_irqoff+0x1f>
>   1f: c3                    retq
>
> The question is whether using current_stack_pointer as an output is
> actually a valid way to tell the compiler it should not clobber RSP.
> Intuitively it is, but explicitly adding RSP to the clobber list
> sounds a bit more bulletproof.

Ok, I think this reproducer demonstrates the issue:
https://godbolt.org/z/jAafjz
I *think* what's happening is that we're not specifying correctly that
the stack is being modified by inline asm, so using variable
references against the stack pointer is not correct.

commit f5caf621ee357 ("x86/asm: Fix inline asm call constraints for Clang")
has more context about ASM_CALL_CONSTRAINT.

It seems that specifying "rsp" in the clobber list is a -Wdeprecated
warning in GCC, and an error in Clang (unless you remove
current_stack_pointer as an output, but will get Clang to produce the
correct code).

-- 
Thanks,
~Nick Desaulniers
