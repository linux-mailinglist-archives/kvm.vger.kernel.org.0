Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C71EF3014
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 14:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389323AbfKGNmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 08:42:18 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:49181 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389228AbfKGNmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 08:42:11 -0500
Received: by mail-il1-f199.google.com with SMTP id c2so2631627ilj.16
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 05:42:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=e82UTgwLSYIZvR2zraa9Nggc087nss86NXJiBWUJu+E=;
        b=PAfWHW+L0Y9ipgDwhl82jbkETuTG5TC9XakwzRntzp1SShgcCb2rWKTrQP6ZFVNLVB
         ppaOvTa3Hv2mkhqEaKV9pVin5n+Icrr88uT2K3mRBxjhDgGh6lRNm1cNFmbr1K4eUsOD
         D6hkl9BtKe5cdZpV/TogW8gH8mGYlytnR9/jqrvZ25PsYf3uLX5wOlmSumRwHBnFT8sH
         3ilWlFMLL1WdvXEx4fh90Mi6jm+9H5bVv7SAgdbFjOustfYb0u/K3Pnlh50Q4pSg50eo
         BuTwCHmyp8dyL6IBRhOgYsIL0W3ubARrzEqpg3tY/71vkEnLqMAZHtEy+7Q22YB89Ozf
         ocIw==
X-Gm-Message-State: APjAAAVn3hr5qxZyRaqnF0kOXnoHjqIzpFZhq0aBfIhjBWrC4DM/JDqk
        3iB7pSh2xVutfj+PFxB3tjv/PTXiVJeH94WWZrnKu4nt6yjX
X-Google-Smtp-Source: APXvYqy2SR949y+R/aVsMmYYpVrF/WYb/9SXBHKSkoi9zyTyoMPvuzLrrPMK2lAbn35Yo+YCSE2zXinrZz2HbDMgOboAl0ltcz5n
MIME-Version: 1.0
X-Received: by 2002:a92:35dd:: with SMTP id c90mr4277087ilf.191.1573134129105;
 Thu, 07 Nov 2019 05:42:09 -0800 (PST)
Date:   Thu, 07 Nov 2019 05:42:09 -0800
In-Reply-To: <0000000000000cc0de0572736043@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3131f0596c1d4ed@google.com>
Subject: Re: KASAN: use-after-free Read in __schedule (2)
From:   syzbot <syzbot+ceded3495a1d59f2d244@syzkaller.appspotmail.com>
To:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liran.alon@oracle.com, luto@kernel.org, mark.kanda@oracle.com,
        mingo@redhat.com, patrick.colp@oracle.com, pbonzini@redhat.com,
        rkrcmar@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot suspects this bug was fixed by commit:

commit 26b471c7e2f7befd0f59c35b257749ca57e0ed70
Author: Liran Alon <liran.alon@oracle.com>
Date:   Sun Sep 16 11:28:20 2018 +0000

     KVM: nVMX: Fix bad cleanup on error of get/set nested state IOCTLs

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14830572600000
start commit:   234b69e3 ocfs2: fix ocfs2 read block panic
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=5fa12be50bca08d8
dashboard link: https://syzkaller.appspot.com/bug?extid=ceded3495a1d59f2d244
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1634bbae400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1728324e400000

If the result looks correct, please mark the bug fixed by replying with:

#syz fix: KVM: nVMX: Fix bad cleanup on error of get/set nested state IOCTLs

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
