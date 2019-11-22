Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E908E1066F1
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 08:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKVHTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 02:19:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:42891 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfKVHTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 02:19:01 -0500
Received: by mail-io1-f71.google.com with SMTP id p1so4257299ioo.9
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 23:19:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1cUcF3hJKE1N4P4WyddDQmYqcNZvFWfBMCxod9a8Ztg=;
        b=JPm+GhI76Xrrb4t/xJpZUjPPGqivGM0ocK7wKIeBBIq3uFHQ6xlUMgU4bE3KR1gMcr
         cA8Lln8nmFY0O+zog+HLi0aESlJaMayURpAv4KMY/K7EiZALCjg57yqjgV+q3lwpvG2v
         S2aeO7WMC8mN+wTEZrzb8cbU39ValV01YXJ1fMPhB8ZqE9vzqGlNSkiOlz279vksqKog
         wE9LtSIScBqN4V7xiDI1L1kFhfMzIjX7XQE2z39OTxsX6UU/jtpP+OTsbxWdSg2465cY
         B12Z3mwjh1IoiEQMpnaerMafcNjrFyLHwgR89zWH2PGEfwHju9PThGoJ1P1g4YJm7SKF
         DisQ==
X-Gm-Message-State: APjAAAWLg0e/oTtr5jd1za8xEVsr79cwQ4DLW7QnbhzLcBDqMGC1FuGV
        MmxNvnQd3scDxH+kI5XWm3ZECxq4hz6xEfhCJyS2IiUUAgWb
X-Google-Smtp-Source: APXvYqz7YQR3Ph2vR2o/JQ6Y+lyCMjwoGf4NoUXt8LcJXs8VhmLZT2rHE8UUekeFjpMnBlonHBj9FzFznQfgOmicwRtoMmh+YsCi
MIME-Version: 1.0
X-Received: by 2002:a92:3602:: with SMTP id d2mr14510424ila.7.1574407140976;
 Thu, 21 Nov 2019 23:19:00 -0800 (PST)
Date:   Thu, 21 Nov 2019 23:19:00 -0800
In-Reply-To: <000000000000e67a05057314ddf6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005eb1070597ea3a1f@google.com>
Subject: Re: general protection fault in __schedule (2)
From:   syzbot <syzbot+7e2ab84953e4084a638d@syzkaller.appspotmail.com>
To:     casey@schaufler-ca.com, frederic@kernel.org,
        gregkh@linuxfoundation.org, hpa@zytor.com, jmattson@google.com,
        jmorris@namei.org, karahmed@amazon.de,
        kstewart@linuxfoundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, mingo@kernel.org,
        mingo@redhat.com, pasha.tatashin@oracle.com, pbonzini@redhat.com,
        pombredanne@nexb.com, rkrcmar@redhat.com, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this bug to:

commit 8fcc4b5923af5de58b80b53a069453b135693304
Author: Jim Mattson <jmattson@google.com>
Date:   Tue Jul 10 09:27:20 2018 +0000

     kvm: nVMX: Introduce KVM_CAP_NESTED_STATE

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124cdbace00000
start commit:   234b69e3 ocfs2: fix ocfs2 read block panic
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=114cdbace00000
console output: https://syzkaller.appspot.com/x/log.txt?x=164cdbace00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5fa12be50bca08d8
dashboard link: https://syzkaller.appspot.com/bug?extid=7e2ab84953e4084a638d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150f0a4e400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f67111400000

Reported-by: syzbot+7e2ab84953e4084a638d@syzkaller.appspotmail.com
Fixes: 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
