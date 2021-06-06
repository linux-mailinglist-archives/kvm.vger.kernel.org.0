Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D23239D232
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 01:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhFFX26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Jun 2021 19:28:58 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37870 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhFFX25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Jun 2021 19:28:57 -0400
Received: by mail-io1-f72.google.com with SMTP id x9-20020a6bd0090000b029048faf40f12dso10893593ioa.4
        for <kvm@vger.kernel.org>; Sun, 06 Jun 2021 16:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=oU4NTLB/bp0z6BEIAwWBRS3a/Lf5yLyHqXlovXbqmkg=;
        b=irHRRiTQtlJN0Wi51XWpzwgov0iqXbnV7VgUxpE6qm2QByS1oNVsIdyPY47IEOH6aj
         m0zfUrOvxpwvT7XEOIeIlaSijwn8gQ9gcXKGQe1VKK0u/xSxK6ICNWyVmerc4KPzIaNs
         8+OX9zOPUEGS/drSW71Hydz5S5J7+aDEjosnA7+n4Pc80072ufyFDWsN23Ond7P42Hkc
         px5cuADnpSVWSoqZo8Thbo3D0R7a34X/S+L1Z8ptFonrtLGemwa0YPTI56ociAjBa8Zs
         9c+DmuMBhbAIg4qS80YSgAK02ONnNvCHsXirdBMaSwwFtdNv/uRcSZ478Zj5Ti2nqOHU
         X+qQ==
X-Gm-Message-State: AOAM530QleqVm/bbYVDKu/Wh8Q2PL/WkyGJkvnz9i6r0C5KFtC5LrDI4
        fhYuurKcXsDNYNw4L+lKJFZoHa4/8pMZ93yeDD54hqIRX3ce
X-Google-Smtp-Source: ABdhPJzb3G2hoCzgVwB/T+9VYoq4H8SE2XUt3w03m2CtvaYNrHvF/JrdNZcYD4S0sVLcH/qtUV7Fcmn4qONbNjPoSCWrV9RN4jqe
MIME-Version: 1.0
X-Received: by 2002:a5e:8d16:: with SMTP id m22mr12517729ioj.139.1623022027203;
 Sun, 06 Jun 2021 16:27:07 -0700 (PDT)
Date:   Sun, 06 Jun 2021 16:27:07 -0700
In-Reply-To: <000000000000f8e51405beaebdde@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064e7d505c4214310@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nfc_llcp_sock_unlink
From:   syzbot <syzbot+8b7c5fc0cfb74afee8d1@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, benjamin.tissoires@redhat.com,
        bp@alien8.de, davem@davemloft.net, hpa@zytor.com, jikos@kernel.org,
        jkosina@suse.cz, jmattson@google.com, joro@8bytes.org,
        kuba@kernel.org, kvm@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        masahiroy@kernel.org, maxtram95@gmail.com, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tseewald@gmail.com, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit f567d6ef8606fb427636e824c867229ecb5aefab
Author: Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Sun Feb 7 14:47:40 2021 +0000

    HID: plantronics: Workaround for double volume key presses

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e41588300000
start commit:   bbd6f0a9 bnxt_en: Fix RX consumer index logic in the error..
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=339c2ecce8fdd1d0
dashboard link: https://syzkaller.appspot.com/bug?extid=8b7c5fc0cfb74afee8d1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1712a893d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1298b469d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: HID: plantronics: Workaround for double volume key presses

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
