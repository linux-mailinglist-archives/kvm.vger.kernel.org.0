Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3F636216B
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 15:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhDPNtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 09:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbhDPNtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 09:49:33 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D52CC06175F
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 06:49:08 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id c6so20794680qtc.1
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 06:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYneuFs5qWO9bsAYoBAn6F1iILdYYCc0Lxy2wJHSxBU=;
        b=bU3meBNxxBzaKETh/aEfIie9Jn0SCG2lRqDJYo4LIsIp/I+58ldhLKrSje16wpEjzT
         pZ8AOylwgVPtiRVZeyBklxpevyFna5bB7mTeD5sYtJZGw1v8GaQ19c/MVOESbpmSjB1k
         qzeHuxEwnv9q0u1JSFkmVIkGuKqr6ldlUbR8efWq9inAXbKBjFp9cwWpxSTjDB5wJQV8
         tAX+pjyaT+9gcg09t4ffx92oBl8usDDRl74okxq1N/+qsVj7vPHcB2Kh07SYNs6uv7vs
         aAZs1dtSX6eBitfvL2BeKYkvzfzZ9MuCXFe6Cp5c/eGU4ENFGMvGkrVK54yzDWpaWQ7Z
         nCYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYneuFs5qWO9bsAYoBAn6F1iILdYYCc0Lxy2wJHSxBU=;
        b=BY/C51ymRXcUhRaRGNc6qRoczvqDwBQgLhA44/DC7aGAdvy/xoPqCo+C0/Go4x5VcU
         Gv71u2Pv0GuhVTkkCOPmt2157+FyOxGoUBvLsmoVJcTuovDPZ43DveZsZaIu/EUlwnD4
         COyFOoUpTYqvArdebsLlesprE4+J1GU9vDKlciE+A66zkwxO1LHKrOu0lyiZNoFu0lbl
         D3QqskKZX6ikMKYpovWiG/85Jgcj4KGmmcdnILrrEkB/90Ut0XNPHBDRXrrZaPLbKcdH
         seErucBN44k0dEetRIN/R/WNlmZGpD9odq6/0RwwAMIuo9IEYZFAR2qp8CJZoutAFknk
         ZVOQ==
X-Gm-Message-State: AOAM531v5t1VXBKIGZWOxiuF+p6Hf6yTmaycu2d4a/i5hQXgoaIuAJ06
        jn7VAgVSBkQSBzbjY9+AzICQQs3qU6cOSFJlXfYsaQ==
X-Google-Smtp-Source: ABdhPJwPhSpv/j6epjRIR3wB4SQGpNaNCb+17E6D/kUePNhiDW7CWQqklh+7Bn618qQfrg5sA2VxFLnD5l3aGDTiLwk=
X-Received: by 2002:ac8:768c:: with SMTP id g12mr7877451qtr.67.1618580947114;
 Fri, 16 Apr 2021 06:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ae236f05bfde0678@google.com> <20210413134147.54556d9d@gandalf.local.home>
 <20210413134314.16068eeb@gandalf.local.home> <CACT4Y+ZrkE=ZKKncTOJRJgOTNfU8PGz=k+8V+0602ftTCHkc6Q@mail.gmail.com>
 <20210413144009.6ed2feb8@gandalf.local.home> <20210413144335.4ff14cf2@gandalf.local.home>
 <CACT4Y+YipDUHQiqJ=gtEeBQGz2AjqT6e_fje5DHsm0a5e+-GRQ@mail.gmail.com>
 <20210416091300.0758c62a@gandalf.local.home> <CACT4Y+YutXjDarTu_J=EjsDDgt5LzXyNjN-hd1ZpWg6kDYgw6g@mail.gmail.com>
In-Reply-To: <CACT4Y+YutXjDarTu_J=EjsDDgt5LzXyNjN-hd1ZpWg6kDYgw6g@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 16 Apr 2021 15:48:55 +0200
Message-ID: <CACT4Y+ZdDwSthQ4tWcoig3bKejgpEYDOo8QcSPjBkg3=b618Ww@mail.gmail.com>
Subject: Re: Bisections with different bug manifestations
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     syzkaller <syzkaller@googlegroups.com>,
        syzbot <syzbot+61e04e51b7ac86930589@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, masahiroy@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        rafael.j.wysocki@intel.com,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021 at 3:26 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Fri, Apr 16, 2021 at 3:13 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Fri, 16 Apr 2021 09:51:45 +0200
> > Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > If you look at substantial base of bisection logs, you will find lots
> > > of cases where bug types, functions don't match. Kernel crashes
> > > differently even on the same revision. And obviously things change if
> > > you change revisions. Also if you see presumably a different bug, what
> > > does it say regarding the original bug.
> >
> > Yes, but there are also several types of cases where the issue will be the
> > same. Namely lockdep. I agree that use after free warnings can have a side
> > effect, and may be more difficult.
>
> But how do we know it's lockdep, rather than a use-after-free
> manifested as lockdep?
> A Significant portion of kernel bugs are caused by concurrency and can
> manifest in different ways, e.g. these are not lockdep, or WARN, or
> use-after-free, but rather a race in nature.
>
> > But there's many other bugs that remain
> > consistent across kernels. And if you stumble on one of them, look for it
> > only.
>
> For example? Does not look to be true for WARN, BUG, KASAN,
> "inconsistent lock state".
>
>
> > And if you hit another bug, and if it doesn't crash, then ignore it (of
> > course this could be an issue if you have panic on warning set). But
> > otherwise, just skip it.
>
> It's not possible to skip, say, BUG.
> And if we skip, say, a use-after-free, how do we know we are not
> making things worse? Because now we are running on corrupted memory,
> so anything can happen. Definitely a stray lockdep report can happen,
> or other way around not happen when it should...
>
> > > I would very much like to improve automatic bisection quality, but it
> > > does not look trivial at all.
> > >
> > > Some random examples where, say, your hypothesis of WARN-to-WARN,
> > > BUG-to-BUG does not hold even on the same kernel revision (add to this
> >
> > At least lockdep to lockdep, as when I do manual bisects, that's exactly
> > what I look for, and ignore all other warnings. And that has found the
> > problem commit pretty much every time.
>
> What lockdep bug types do you mean? All?
> In the examples above you can see at least "inconsistent lock state"
> mixed with 2 other completely different bug types.

I've looked for some examples.

Here a reliable deadlock in io_uring changes to reliable task hung in io_uring:
run #6: crashed: possible deadlock in io_poll_double_wake
all runs: crashed: INFO: task hung in io_ring_exit_work
https://syzkaller.appspot.com/text?tag=Log&x=135e4d31d00000

Here deadlock is mixed with "lock held when returning to user space":
run #6: crashed: possible deadlock in inet_stream_connect
run #7: crashed: WARNING: lock held when returning to user space in
inet_stream_connect
https://syzkaller.appspot.com/text?tag=Log&x=109b88f2d00000

Here a reliable deadlock in n_tty_receive_buf_common changes to UAF in
n_tty_receive_buf_common:
all runs: crashed: possible deadlock in n_tty_receive_buf_common
all runs: crashed: KASAN: use-after-free Read in n_tty_receive_buf_common
https://syzkaller.appspot.com/text?tag=Log&x=106596b5e00000

Here deadlock changes to UAF and corrupted list:
run #4: crashed: possible deadlock in neigh_change_state
run #1: crashed: KASAN: use-after-free Read in neigh_mark_dead
run #2: crashed: BUG: corrupted list in ___neigh_create
run #3: crashed: BUG: corrupted list in neigh_mark_dead
https://syzkaller.appspot.com/text?tag=Log&x=1328a1e2e00000

But it also shows another interesting aspect, kernel output is
sometimes corrupted and kernel does not manage to print proper
complete oops message. In these cases we can't reliably say that it's
also a deadlock or not, we can't say anything about the crash, it's
unparsable. This problem also shows up here:
https://syzkaller.appspot.com/text?tag=Log&x=145c3a6d200000
and here
https://syzkaller.appspot.com/text?tag=Log&x=1006f18c600000
and in the second one also these 2 are mixed:
run #1: crashed: WARNING: locking bug in corrupted
run #2: crashed: WARNING: possible circular locking dependency detected

This one shows a related issue. Kernel crash output periodically
changes, and a testing system fails to parse it. This can happen if we
go back to older releases, or when we do fix bisection and test a very
new kernel with changed output:
https://syzkaller.appspot.com/text?tag=Log&x=108f4416e00000


It's also easy to imagine that a program that triggers 2 deadlocks on
different revisions, both are deadlocks, but completely different and
unrelated. And we can't look at function names as they change over
time.
All these things are almost trivial when you do bisection manually.
But for an automated system, they are quite challenging to handle.



> > > different revisions and the fact that a different bug does not give
> > > info regarding the original bug):
> > >
> >
> > Can you tell me that all these examples bisected to the commit that caused
> > the bug? Because if it did not, then you may have just proved my point ;-)
>
> I don't know now what was the result, but for a single run these were
> manifestations of the same root bug.
> E.g. see below, that's UAF in fuse_dev_do_read vs WARNING in
> request_end. request_end is also fuse. And you can see that a memory
> corruption causing a random bug type, in this case WARNING, but can as
> well be LOCKDEP.
>
>
> > > run #0: crashed: KASAN: use-after-free Read in fuse_dev_do_read
> > > run #1: crashed: WARNING in request_end
> > > run #2: crashed: KASAN: use-after-free Read in fuse_dev_do_read
> > > run #3: OK
> > > run #4: OK
