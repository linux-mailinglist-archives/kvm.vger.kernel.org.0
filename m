Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E012A35E69F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhDMSoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231980AbhDMSn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:43:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3BD26113E;
        Tue, 13 Apr 2021 18:43:36 +0000 (UTC)
Date:   Tue, 13 Apr 2021 14:43:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dmitry Vyukov <dvyukov@google.com>
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
Subject: Re: [syzbot] possible deadlock in del_gendisk
Message-ID: <20210413144335.4ff14cf2@gandalf.local.home>
In-Reply-To: <20210413144009.6ed2feb8@gandalf.local.home>
References: <000000000000ae236f05bfde0678@google.com>
        <20210413134147.54556d9d@gandalf.local.home>
        <20210413134314.16068eeb@gandalf.local.home>
        <CACT4Y+ZrkE=ZKKncTOJRJgOTNfU8PGz=k+8V+0602ftTCHkc6Q@mail.gmail.com>
        <20210413144009.6ed2feb8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 14:40:09 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> ------------[ cut here ]------------
> raw_local_irq_restore() called with IRQs enabled
> WARNING: CPU: 0 PID: 8777 at kernel/locking/irqflag-debug.c:9 warn_bogus_irq_restore kernel/locking/irqflag-debug.c:9 [inline]
> WARNING: CPU: 0 PID: 8777 at kernel/locking/irqflag-debug.c:9 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:7

In fact, when you have the above, which is a WARN() with text:

 "raw_local_irq_restore() called with IRQs enabled"

It is pretty much guaranteed that all triggers of this bug will have the
above warning with the same text.

-- Steve

