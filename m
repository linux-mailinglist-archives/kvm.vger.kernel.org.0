Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017BDED34B
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2019 13:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfKCMLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Nov 2019 07:11:01 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:55501 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfKCMLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Nov 2019 07:11:01 -0500
Received: by mail-il1-f198.google.com with SMTP id n81so13145508ili.22
        for <kvm@vger.kernel.org>; Sun, 03 Nov 2019 04:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Xwpp1TpBnHfvp2xyxP9sGt3bT4ULRP3XGkhH7PJ6jAk=;
        b=W1YvMsEwTbZHnngVfwK7976XhouMfYAfPgt49mQqmZuyrqDgreJATwbnjGQde6sfj0
         U3T8Cw0n/5WQ831RaZmr347+K8X3JsLw9jmV0APHI70HWTm0vcfLoD6QGexHkpKWn7dX
         MRvADLSVFsymsC3Bkcnl4NgatXHL15CRQCCLERky86crVEasr7vlSUMAcAcpAYHmBPuU
         jweWueLWjvbVKujlpk6S03JpcwDODuppWMSsRmZFiMmpuIMZev+lTXPKHdcDHs5MjjmF
         tE2WpEfSoaMQd9VYSW153Ki7CEF4K73K0bKrd1qm9FYQC3TBy5SZgtcZVs/4KBzhTzZn
         MdvQ==
X-Gm-Message-State: APjAAAV3Oo2pWAg6+pvuKT/DtrEZ9qDCf0+eIYJZJriF6aZnfNc/kSi3
        ATmxMMulgiqMfDp7cMqhhkf7RX+Ff+276RkJqYgk7wDER8mJ
X-Google-Smtp-Source: APXvYqx324ib1pU4r9irwayKJOfblhDSkACmPuLheadxHDJ3/934Bk8/0s2wIFbkvhgpGWnUhpc83GCO/s2Ut414yZgxr1V+W8Ix
MIME-Version: 1.0
X-Received: by 2002:a5e:d90c:: with SMTP id n12mr18996926iop.140.1572783060398;
 Sun, 03 Nov 2019 04:11:00 -0800 (PST)
Date:   Sun, 03 Nov 2019 04:11:00 -0800
In-Reply-To: <000000000000251bba05966d7473@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009fb83d05967017a0@google.com>
Subject: Re: INFO: task hung in synchronize_rcu
From:   syzbot <syzbot+89a8060879fa0bd2db4f@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        junaids@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this bug to:

commit 9121923c457d1d8667a6e3a67302c29e5c5add6b
Author: Jim Mattson <jmattson@google.com>
Date:   Thu Oct 24 23:03:26 2019 +0000

     kvm: Allocate memslots and buses before calling kvm_arch_init_vm

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14b34f5ce00000
start commit:   9d234505 Merge tag 'hwmon-for-v5.4-rc6' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16b34f5ce00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12b34f5ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbbed3e8d4eb64bf
dashboard link: https://syzkaller.appspot.com/bug?extid=89a8060879fa0bd2db4f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13509b84e00000

Reported-by: syzbot+89a8060879fa0bd2db4f@syzkaller.appspotmail.com
Fixes: 9121923c457d ("kvm: Allocate memslots and buses before calling  
kvm_arch_init_vm")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
