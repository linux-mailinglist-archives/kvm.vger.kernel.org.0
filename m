Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40794112189
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 03:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfLDCpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 21:45:02 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:33996 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfLDCpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 21:45:02 -0500
Received: by mail-io1-f69.google.com with SMTP id a13so4057291iol.1
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 18:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=tCMUC5Ey7adRpUDsqcilcHQWuXQS9qiXWW1HvjkqOis=;
        b=oReLYIkh7h+DkoYppXlcOUhYCei3W9pWS7nQcBExQ71++TDl3X0wcekIUvsW3KkWSb
         g63obtzs+y1dfZzpKF7agtVLCJFAuILo82+ALntE/Yb8IUiBnHOP3Sv5GxpHUoLAvT1a
         ODwzOY0ZAYNUiNw47wXyOyoZLE42POTICg1PvesEH6rndcgyyR/yBjK6lm12vN/GRvj1
         rbrYdl7uBv1i5H23HqnPiMNjjfnOao5ezAo3dRgr8oE46w6lfmocs8XI3CHWx9HrvD5I
         Ai4gV65ZGyRyUvMqbDTvheyJZ/p0owMYhzktKwQuDeCUfDQrpXzYQpyZwqzjH+fJTy5U
         h+DA==
X-Gm-Message-State: APjAAAWpbjSoUas9BtG1bqAgIXTQtX+8gPD/yvyP7bxfp2dexGZHKAbf
        Y6mMyZtNrCpEPIS2zoL/xXRzoLrlN3Nm5o34aXwz741Zh1Kw
X-Google-Smtp-Source: APXvYqyTpaCVnDPlSz0wClrWbfe+GR1eD78eZBnhUlXj8esJwkaZhmLdyNh5D6nMvOl+CrbF0oIsolfNn5+b3maERg4zP5CgEcgx
MIME-Version: 1.0
X-Received: by 2002:a05:6638:a4a:: with SMTP id 10mr1003754jap.44.1575427501287;
 Tue, 03 Dec 2019 18:45:01 -0800 (PST)
Date:   Tue, 03 Dec 2019 18:45:01 -0800
In-Reply-To: <000000000000dd04830598d50133@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009574da0598d7ccfa@google.com>
Subject: Re: KASAN: use-after-free Read in tty_open
From:   syzbot <syzbot+9af6d43c1beabec8fd05@syzkaller.appspotmail.com>
To:     gleb@kernel.org, gregkh@linuxfoundation.org,
        gwshan@linux.vnet.ibm.com, hpa@zytor.com, jslaby@suse.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, mpe@ellerman.id.au, pbonzini@redhat.com,
        ruscur@russell.cc, stewart@linux.vnet.ibm.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this bug to:

commit 2de50e9674fc4ca3c6174b04477f69eb26b4ee31
Author: Russell Currey <ruscur@russell.cc>
Date:   Mon Feb 8 04:08:20 2016 +0000

     powerpc/powernv: Remove support for p5ioc2

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e5fc32e00000
start commit:   76bb8b05 Merge tag 'kbuild-v5.5' of git://git.kernel.org/p..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17e5fc32e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e5fc32e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd226651cb0f364b
dashboard link: https://syzkaller.appspot.com/bug?extid=9af6d43c1beabec8fd05
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d15061e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b69aeae00000

Reported-by: syzbot+9af6d43c1beabec8fd05@syzkaller.appspotmail.com
Fixes: 2de50e9674fc ("powerpc/powernv: Remove support for p5ioc2")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
