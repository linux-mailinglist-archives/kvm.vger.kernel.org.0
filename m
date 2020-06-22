Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3E2203795
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 15:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgFVNMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 09:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728636AbgFVNMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 09:12:52 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C66C061573
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 06:12:52 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id a21so15541405oic.8
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 06:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qcGU7nvBRl72foMmnfzxCxyVhGZeHsJifexaVS75v3Y=;
        b=Rza3aMY1Yo+yqYktcrUVWa/BOjei8LvddkKoUYWWAq4RkaoAOVto5q3/Wfk8atX0ZK
         eG6ZtVMQ23JOclHAZq37tE1LFBQEay0d4h8QREnzX+tLaTHDfddYleL+b3b3mAR5bKh8
         N+BhFAzdfC3EKuvgdyNOX24pXCM/sBVD4+r0as2/+w8lm/F51XB8y8SzvEfUs0v5ALIF
         qf3skkbaRj2Pl6+A5gqJkDukbFx0RvSE0gi5dJAPl7pQBoCSgy2SG70laF6Xv3SW1OXl
         AeOV85Ic4e9pKfRL72wMvCp6Zsrb2JUntAXc+YrTs7INEIJ/HaegoeaTEk0C5rCcv4G9
         JUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qcGU7nvBRl72foMmnfzxCxyVhGZeHsJifexaVS75v3Y=;
        b=Tkl+5lSJXB7EWq3B3KmBfivEc1Md5/9PAVaedZso+m3CwxPX8nfj/jyLA7oj4NKyUK
         M8a7BBJwA9tslKNxBlClZGb03vJc5MQj3F/Lu2mQaeDFKLABokqRb69l0AkXxYAlnu/B
         CkFYiXZkokKGHhtiQ4RwK0J83DRr9wLMqhPjxzBu8qAjd1K9iIL6xJPxBXzWO7kVZ1Vq
         PetLY0E3o7EOzWGJcWpi3z+LOxUD1piSm4EJzElbKjJyrnvVATHNuFz3SfFrtPCnVYHd
         ncH71aUFMh9LxBkTqiGMLJTlHxHlUGmK5UaEZjiV2TmfWhHJjlaDSltG54pQLqF9xWo1
         8dHw==
X-Gm-Message-State: AOAM53010dxsDlG7zyLMmoHzY8LrJB2nlKoj2WMKtQ5esEtifQvDcawF
        pDaPxia0aKOu1C19MFpRO9aUU3Yn8sfyhlRWBPvIcPIzxv4=
X-Google-Smtp-Source: ABdhPJxzjHByYX9BlhdruUuU+p8vDMZcooI2U2quqMiV5mzu6OY3UiQ+JK3QBL5mU6Rjjj5s2am9JE76MTziI7uDkdg=
X-Received: by 2002:a05:6808:34f:: with SMTP id j15mr12828286oie.121.1592831571442;
 Mon, 22 Jun 2020 06:12:51 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c25ce105a8a8fcd9@google.com> <20200622094923.GP576888@hirez.programming.kicks-ass.net>
 <CANpmjNMJL2euWekeJ-pRcW7-BQaDCmfCSr=8Z3Mfnz-ugtUX4g@mail.gmail.com>
In-Reply-To: <CANpmjNMJL2euWekeJ-pRcW7-BQaDCmfCSr=8Z3Mfnz-ugtUX4g@mail.gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Mon, 22 Jun 2020 15:12:39 +0200
Message-ID: <CANpmjNNb7P6eemu2=Pt7WKjfuh7VAcy5eDODUkJgkQFjzGRdGw@mail.gmail.com>
Subject: Re: linux-next build error (9)
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     syzbot <syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, vkuznets@redhat.com,
        wanpengli@tencent.com, "the arch/x86 maintainers" <x86@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Jun 2020 at 13:06, Marco Elver <elver@google.com> wrote:
>
> On Mon, 22 Jun 2020 at 11:49, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Mon, Jun 22, 2020 at 02:37:12AM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    27f11fea Add linux-next specific files for 20200622
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=138dc743100000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=41c659db5cada6f4
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=dbf8cf3717c8ef4a90a0
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com
> > >
> > > ./arch/x86/include/asm/kvm_para.h:99:29: error: inlining failed in call to always_inline 'kvm_handle_async_pf': function attribute mismatch
> > > ./arch/x86/include/asm/processor.h:824:29: error: inlining failed in call to always_inline 'prefetchw': function attribute mismatch
> > > ./arch/x86/include/asm/current.h:13:44: error: inlining failed in call to always_inline 'get_current': function attribute mismatch
> > > arch/x86/mm/fault.c:1353:1: error: inlining failed in call to always_inline 'handle_page_fault': function attribute mismatch
> > > ./arch/x86/include/asm/processor.h:576:29: error: inlining failed in call to always_inline 'native_swapgs': function attribute mismatch
> > > ./arch/x86/include/asm/fsgsbase.h:33:38: error: inlining failed in call to always_inline 'rdgsbase': function attribute mismatch
> > > ./arch/x86/include/asm/irq_stack.h:40:29: error: inlining failed in call to always_inline 'run_on_irqstack_cond': function attribute mismatch
> > > ./include/linux/debug_locks.h:15:28: error: inlining failed in call to always_inline '__debug_locks_off': function attribute mismatch
> > > ./include/asm-generic/atomic-instrumented.h:70:1: error: inlining failed in call to always_inline 'atomic_add_return': function attribute mismatch
> > > kernel/locking/lockdep.c:396:29: error: inlining failed in call to always_inline 'lockdep_recursion_finish': function attribute mismatch
> > > kernel/locking/lockdep.c:4725:5: error: inlining failed in call to always_inline '__lock_is_held': function attribute mismatch
> >
> > Hurmph, I though that was cured in GCC >= 8. Marco?
>
> Yeah, time to upgrade syzbot's compiler. This experimental gcc 9.0.0
> still has the bug, but stable gcc 9 doesn't. For now, I think this
> requires no fixes on the kernel side.

#syz invalid

compiler upgraded.
