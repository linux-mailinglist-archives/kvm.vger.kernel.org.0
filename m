Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5822320C
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 06:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGQEUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 00:20:06 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:48236 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgGQEUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 00:20:05 -0400
Received: by mail-io1-f69.google.com with SMTP id r9so5688331ioa.15
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 21:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=j3PfTK/pr4L9iYESodCey/qnyjNi8Dw657O6Mf+Zg20=;
        b=RrameXs4AzPamOB3pbeAL0uUvPy2SUubt+kLYJFDL6No40zS8BhYCM2dthIwUS3iVD
         PlQ4/fp4fRxopDEkjeou3wH3dA2cvmtXLP/eYCT0FZHKqYuXCRkVyGJ9qL21bLZPwAy+
         lN1G3B8ny/zfdXmiqc9+t0bx5Fyw3xvlcFk+zwRTtTuhINY6HYh+cI1lRvv4cDuyjYfC
         htRXaFopSipcxYp6D1W+WeSfW0RMZiWQTuZyMkzGmz/ocYxfJtf5SyyJgbbcqA0h2IA/
         l71bB+LhgJ0LuBfIZBtcF8/eUQ8o0mB7/iSS16GZQjAEiIbAvjCz2okdJKrFs/LLGBCl
         G0LQ==
X-Gm-Message-State: AOAM530rs4HELSVoneJBfpLkE0gwVbSu5LLlbGtJ3cR3o8/dSDxn0xWh
        MCmwahpCLwrG9wxaD+4wn8QDxNwFTpZhEARHLsIA9URk7jGa
X-Google-Smtp-Source: ABdhPJw4xwEhl32rilyRDk1xXUs9He2nKD1ic8BW/rpDuSPhQLS4k36SMiiZktAg7h2AcmcBDhCU1OoPlc3a6bevTEdbZc6L7EZA
MIME-Version: 1.0
X-Received: by 2002:a6b:8e56:: with SMTP id q83mr7806086iod.61.1594959604449;
 Thu, 16 Jul 2020 21:20:04 -0700 (PDT)
Date:   Thu, 16 Jul 2020 21:20:04 -0700
In-Reply-To: <000000000000264c6305a9c74d9b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a787b205aa9b7863@google.com>
Subject: Re: INFO: rcu detected stall in tipc_release
From:   syzbot <syzbot+3654c027d861c6df4b06@syzkaller.appspotmail.com>
To:     bp@alien8.de, davem@davemloft.net, fweisbec@gmail.com,
        hpa@zytor.com, jmaloy@redhat.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tuong.t.lien@dektech.com.au,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit 5e9eeccc58f3e6bcc99b929670665d2ce047e9c9
Author: Tuong Lien <tuong.t.lien@dektech.com.au>
Date:   Wed Jun 3 05:06:01 2020 +0000

    tipc: fix NULL pointer dereference in streaming

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14641620900000
start commit:   7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16641620900000
console output: https://syzkaller.appspot.com/x/log.txt?x=12641620900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=3654c027d861c6df4b06
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12948233100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11344c05100000

Reported-by: syzbot+3654c027d861c6df4b06@syzkaller.appspotmail.com
Fixes: 5e9eeccc58f3 ("tipc: fix NULL pointer dereference in streaming")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
