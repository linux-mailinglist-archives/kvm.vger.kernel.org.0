Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B4D203551
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 13:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgFVLGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 07:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgFVLGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 07:06:36 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B59C061796
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 04:06:35 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id e5so12675577ote.11
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 04:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bVCGBNAMVVzJBUyEH8AYaaJuZeDFv/AQspAXfpR7QWs=;
        b=H0nc56373dVnFC0+ikr2sQCUW3pSnEIy19Lc57N1R1+mlC6lUNu5QQPGytZhsXgC7f
         c6Uk3RG80/AsxrGiNe5k//VGeexfUJ264jlYjVOoIG+NxTKBE+lhBVgR/a/XpjmBh1vO
         /mvEhZTrcZNBlPOdxsj6hPKS4fIuxWRF29fs9M4eYDgc6TEbmTSITFQdJnLM770QuTdR
         c91KXzpGjPgaX/ZJo6uxQ4z2MAjuHjSKvZcjDOS9bP3f198zaE1eW0140/qQiNCNazUn
         RJomDJKecJdfe65g/1abkUo1Zl7W+quhWj4+4IwZaYIUHiOxcTzLlE1Af+Uvco54MLIA
         dQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bVCGBNAMVVzJBUyEH8AYaaJuZeDFv/AQspAXfpR7QWs=;
        b=oSXNV133a0MczpXb27hkvnYYNI2Gu2hNpvPtXTSlfq2Ic9abz1NVUrtZaejK44U4Xx
         5X7/GP3TAdIbmTYbIScXnRMNoeS05+mbfCY7Wd6ppzUBHKgrSqtoyb5u0wJUKP7eMA9M
         7gamjRl+VX1CuDRdcz+DogQkK21DRc0iRN7nAuSj9XMoqhiQDAVVVAqMKQ7PWt6eLmW1
         /VaCzoXEzUaNYX6A3Mls9+5wKGhq4h7y4h4Lrlhrg1daNVFMY3fIuJ8RWeTGWye8sU+o
         fRNc4lSTR7WbsGYZKcO4Ro5PDG8RZhGUqmWaQAyo0qC5jJVcGEPKgfnrGNCt5iLGyRFt
         sSGA==
X-Gm-Message-State: AOAM533IFwH71sm8OUqA9TPzTgg2gSg6SpOg76QQ+OIfLvdq7PCSh3SZ
        QzRkgG40uXPUis5HURY8nAFblW+tcSWpwfA4vBq9Vw==
X-Google-Smtp-Source: ABdhPJxAl2Be/hK5NnkGkpXO2GQ9KziacpATXhsXKpvvVg2BuS4BDxq29uLM52C/E3EyVpoHnBW9WWKjtAa5gKfsGeQ=
X-Received: by 2002:a9d:638c:: with SMTP id w12mr10791348otk.251.1592823994787;
 Mon, 22 Jun 2020 04:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c25ce105a8a8fcd9@google.com> <20200622094923.GP576888@hirez.programming.kicks-ass.net>
In-Reply-To: <20200622094923.GP576888@hirez.programming.kicks-ass.net>
From:   Marco Elver <elver@google.com>
Date:   Mon, 22 Jun 2020 13:06:23 +0200
Message-ID: <CANpmjNMJL2euWekeJ-pRcW7-BQaDCmfCSr=8Z3Mfnz-ugtUX4g@mail.gmail.com>
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

On Mon, 22 Jun 2020 at 11:49, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Jun 22, 2020 at 02:37:12AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    27f11fea Add linux-next specific files for 20200622
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=138dc743100000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=41c659db5cada6f4
> > dashboard link: https://syzkaller.appspot.com/bug?extid=dbf8cf3717c8ef4a90a0
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com
> >
> > ./arch/x86/include/asm/kvm_para.h:99:29: error: inlining failed in call to always_inline 'kvm_handle_async_pf': function attribute mismatch
> > ./arch/x86/include/asm/processor.h:824:29: error: inlining failed in call to always_inline 'prefetchw': function attribute mismatch
> > ./arch/x86/include/asm/current.h:13:44: error: inlining failed in call to always_inline 'get_current': function attribute mismatch
> > arch/x86/mm/fault.c:1353:1: error: inlining failed in call to always_inline 'handle_page_fault': function attribute mismatch
> > ./arch/x86/include/asm/processor.h:576:29: error: inlining failed in call to always_inline 'native_swapgs': function attribute mismatch
> > ./arch/x86/include/asm/fsgsbase.h:33:38: error: inlining failed in call to always_inline 'rdgsbase': function attribute mismatch
> > ./arch/x86/include/asm/irq_stack.h:40:29: error: inlining failed in call to always_inline 'run_on_irqstack_cond': function attribute mismatch
> > ./include/linux/debug_locks.h:15:28: error: inlining failed in call to always_inline '__debug_locks_off': function attribute mismatch
> > ./include/asm-generic/atomic-instrumented.h:70:1: error: inlining failed in call to always_inline 'atomic_add_return': function attribute mismatch
> > kernel/locking/lockdep.c:396:29: error: inlining failed in call to always_inline 'lockdep_recursion_finish': function attribute mismatch
> > kernel/locking/lockdep.c:4725:5: error: inlining failed in call to always_inline '__lock_is_held': function attribute mismatch
>
> Hurmph, I though that was cured in GCC >= 8. Marco?

Yeah, time to upgrade syzbot's compiler. This experimental gcc 9.0.0
still has the bug, but stable gcc 9 doesn't. For now, I think this
requires no fixes on the kernel side.

Thanks,
-- Marco
