Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ADF2A84B3
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 18:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbgKERRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 12:17:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:45103 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731535AbgKERRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 12:17:10 -0500
Received: by mail-il1-f198.google.com with SMTP id z18so1632336ilb.12
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 09:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Rfdp0/IC9VqRIhN/SmK7/bJW5Cqy/A/9wt6SQdrC/so=;
        b=NrqdWMQnRVbHLgedF30tdwDBsnYnaniYyU1CIDKD4prcvYkjYNmr6LAM889ChPqi2A
         bYSo8G+o3c470P2vKGmFs7w1gwjxhe4RXnFmnUe6gPrnDYewEQrMDq3ulvwxOcNkQSty
         PzB+oODHZMEEGZOei0iahTgLAHYZaYMrybKPGKaMjJsp2MfVDPwO95MCXAABjSx6LiT7
         hrRXyKG8ctjO0iCfZya4cfqRB0lyXBXP2RNuWcixMLBCbYs+qPkv1NstfzLzRio6pYII
         PXZhWBviB6igZMLWZpRMnOBOmySxgTb4i3hcYtIJOCZY+v7emyjlhhph3A7FfPnTBDMf
         2J7w==
X-Gm-Message-State: AOAM531Mi7K6o65J75QFWoXTRMVXTAGv2umHyTXeXPuoFW51Il5t49J6
        /FS6H+KCxmC6oftlA2Wbj3p+B5khN5nw674C/wcgjrygBUzX
X-Google-Smtp-Source: ABdhPJz6aE++DpR5GB57XSRgnn/AejK0OmDlD9JNlHk2Cn/tHZAQrZtFP17BXU3YjRc+tzy/tebsQtaCi4N/l2rop3tvXbzsLPOf
MIME-Version: 1.0
X-Received: by 2002:a92:7a0c:: with SMTP id v12mr2249529ilc.37.1604596628995;
 Thu, 05 Nov 2020 09:17:08 -0800 (PST)
Date:   Thu, 05 Nov 2020 09:17:08 -0800
In-Reply-To: <000000000000dd392b05b0a1b7ac@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014484705b35f4414@google.com>
Subject: Re: WARNING in handle_exception_nmi
From:   syzbot <syzbot+4e78ae6b12b00b9d1042@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, peterz@infradead.org,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit f8e48a3dca060e80f672d398d181db1298fbc86c
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Oct 22 10:23:02 2020 +0000

    lockdep: Fix preemption WARN for spurious IRQ-enable

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17bbfa8a500000
start commit:   d3d45f82 Merge tag 'pinctrl-v5.9-2' of git://git.kernel.or..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
dashboard link: https://syzkaller.appspot.com/bug?extid=4e78ae6b12b00b9d1042
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f24a0b900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167b838f900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: lockdep: Fix preemption WARN for spurious IRQ-enable

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
