Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB79AED1B6
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2019 05:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfKCEgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Nov 2019 00:36:03 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:42322 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfKCEgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Nov 2019 00:36:03 -0400
Received: by mail-il1-f200.google.com with SMTP id b7so1153846ilh.9
        for <kvm@vger.kernel.org>; Sat, 02 Nov 2019 21:36:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=M+1ZDFfcrH+VAQWLoZZHEEfvJgWEhhXd8OnHFWpRv3Y=;
        b=jjLtmocF3hryEY7VjP/OAiu5y5tobFc5Ixp99okqNr3VF6IuAwfx0V9Idb0J8LTHXT
         CqUb2th/DtV6iv26opmb4DHlOuzVyu9+k8o6L8liMwUcpc0KF31wElK/D6s/wGuxRDfO
         JpkEpnGYOP4hhHp088uek84t4+QUdX0qsia4jDxI4ox8aYxUjlmRWWmPcOE74fox1+Ok
         WJcOLnzvsbJKBpwNsIS7L2mG/+Rr8ONGZdZ7LqLAxDw+zkv1vJrln1ydIatphY1rafpL
         e2JKz91v4qd/mdePeCbh7u6JS3b+ZTPbHeDo3mXT+cmlpoIYMSRo8RKyDpMiCw7BfNIB
         wAkw==
X-Gm-Message-State: APjAAAXVEL0ADNEGIRY3iMsTb7lke2VfgSigzmif22IPzPa4Agz6mYWT
        sKg0E1q6yRplDsCPtF0dYrONrWB1QjQP7xVDns4anBoYwi6e
X-Google-Smtp-Source: APXvYqxItIWYSpOcf1AXFMpH8Ub6pBbhUL7/Lcw2BhVvs92D6D18UI0J7DOxRBzc+z8rKFuUe7pN6yF0MfklBEJKCDLhBTRh49FR
MIME-Version: 1.0
X-Received: by 2002:a92:c525:: with SMTP id m5mr4523632ili.91.1572755761014;
 Sat, 02 Nov 2019 21:36:01 -0700 (PDT)
Date:   Sat, 02 Nov 2019 21:36:01 -0700
In-Reply-To: <000000000000bd85b40596657dfa@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000742ddc059669bc92@google.com>
Subject: Re: WARNING: suspicious RCU usage in kvm_dev_ioctl
From:   syzbot <syzbot+75475908cd0910f141ee@syzkaller.appspotmail.com>
To:     jmattson@google.com, jsperbeck@google.com, junaids@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this bug to:

commit a97b0e773e492ae319a7e981e98962a1060215f9
Author: Jim Mattson <jmattson@google.com>
Date:   Fri Oct 25 11:34:58 2019 +0000

     kvm: call kvm_arch_destroy_vm if vm creation fails

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f19914e00000
start commit:   9d234505 Merge tag 'hwmon-for-v5.4-rc6' of git://git.kerne..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10099914e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17f19914e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbbed3e8d4eb64bf
dashboard link: https://syzkaller.appspot.com/bug?extid=75475908cd0910f141ee
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e20268e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15209b84e00000

Reported-by: syzbot+75475908cd0910f141ee@syzkaller.appspotmail.com
Fixes: a97b0e773e49 ("kvm: call kvm_arch_destroy_vm if vm creation fails")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
