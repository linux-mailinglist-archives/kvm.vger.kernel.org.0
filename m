Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20EA34D670
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 20:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhC2SAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 14:00:11 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55585 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhC2SAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 14:00:05 -0400
Received: by mail-io1-f72.google.com with SMTP id e15so11455135ioe.22
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 11:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FVXCBOA19N+8Cvll8rclzhhBLyzXsPQ/MO+es+WHLpQ=;
        b=HGTQIQmlWlB30UmxZ3HHfzoO9NCya1ABQdoUi2/S/l54rug6Ol2RhG51DPrgv9sWzS
         ZCcm7aUJxje0JjkawQJpg5kJqjArRhp1M93+I9D6zOzUj04SZzPC4/oY1+9pN0Au5RV+
         KnARnurgI1Ux513OSsSIxCMpAFlAAYlujsaHuLGJaAE8DQ318VPICnegwQGYBwxzPGJQ
         grS0e+L4wDB6Qdu8YtbxXXs1aOCWXyvfmowU+JPtAn0oCgcdcIZyQVFvgSpuZQaGEv1s
         Lu/A0uQmcrIMJQhMxQK4RXHNbA5QXlnbw3uj+WudkyAOd4VG15d7nbjyQARmJsgUa8Ym
         0aUQ==
X-Gm-Message-State: AOAM533jEKdX/6BP6BjULwK2GRlc8bGoPMHLabk85r+rxNUtfIulfbnf
        IZDQAGhDBg7PLNh+TDcuB1yMBheVRhw3cdVOSIbeVTqSQUCd
X-Google-Smtp-Source: ABdhPJzA0LAxPGtiKmML9IoNwD88JU3yBTm0rMsiXA81RF9MUpeqfJLWyeqqtAtj1XKb9BtLojmu4DuLYkgDJ+wiZRE5MyhpYnd+
MIME-Version: 1.0
X-Received: by 2002:a02:ccd9:: with SMTP id k25mr24914140jaq.43.1617040805381;
 Mon, 29 Mar 2021 11:00:05 -0700 (PDT)
Date:   Mon, 29 Mar 2021 11:00:05 -0700
In-Reply-To: <000000000000cbcdca05bea7e829@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cacb2205beb0a63e@google.com>
Subject: Re: [syzbot] WARNING: still has locks held in io_sq_thread
From:   syzbot <syzbot+796d767eb376810256f5@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, bp@alien8.de,
        hpa@zytor.com, io-uring@vger.kernel.org, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, pbonzini@redhat.com,
        peterz@infradead.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit c8cc7e853192d520ab6a5957f5081034103587ae
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Tue Feb 9 08:30:03 2021 +0000

    lockdep: Noinstr annotate warn_bogus_irq_restore()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152deb3ad00000
start commit:   81b1d39f Merge tag '5.12-rc4-smb3' of git://git.samba.org/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=172deb3ad00000
console output: https://syzkaller.appspot.com/x/log.txt?x=132deb3ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4e9addca54f3b44
dashboard link: https://syzkaller.appspot.com/bug?extid=796d767eb376810256f5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d06ddcd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150764bed00000

Reported-by: syzbot+796d767eb376810256f5@syzkaller.appspotmail.com
Fixes: c8cc7e853192 ("lockdep: Noinstr annotate warn_bogus_irq_restore()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
