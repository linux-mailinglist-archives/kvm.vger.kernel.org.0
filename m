Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EE92A1D11
	for <lists+kvm@lfdr.de>; Sun,  1 Nov 2020 11:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgKAKLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 05:11:09 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:38721 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgKAKLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Nov 2020 05:11:08 -0500
Received: by mail-il1-f198.google.com with SMTP id p17so8196935ilb.5
        for <kvm@vger.kernel.org>; Sun, 01 Nov 2020 02:11:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DNT5DJaDDfNyecwyRLYDgxpqveMo4JQlWpmg6tKju2w=;
        b=Wpk505DQTmU03qWDclYpyS0Cu6uQZaaw/5MFZ0QZJ43Bbk6R+sUk23d/SkbvEDAX0c
         Hfwh2QDimwHFecl7otUVS0BmpqjOH1HBCZMgUEh2XOU5IuF+S7tddsdAlwz0jHK0fBRT
         KOyaWsYS7+oa0Zs9+BlMDf0ntZZgLtpYJZ6Xr2WAx+x70oJbFJsiVUyWVcVhkf7ShqbK
         ecpipJLBkDc6KqdIzaRXzIOoDt2OYMkthOBHLAMWXNaTR+lImIVippEkUuelLd5+W9sY
         lEpW4tUVzGXs23/5yN6gwr7oRq2BjMU8GG+/f/NmJeUMDyl2ImkvHPN4a0iA3aL6s3yp
         KhdQ==
X-Gm-Message-State: AOAM533MKon4HjCkEzB7Amd1M04dRhrCXBWfV1s9L80W5BUO9MqOU6xq
        WvAL9jJp9LKU8JXdTcUYCZ3sv6/YzVbaPVm33Der/to2RzLZ
X-Google-Smtp-Source: ABdhPJxctS2I+L3olPckb3hh9hZfKdD6yTrHGSqPX4hCaO2tFQcVdPn7k0R/QGO6z2nDrR9NItqN/DEwl64WRNQKAKC4+6c8m+GR
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3f1:: with SMTP id s17mr7616578jaq.102.1604225467601;
 Sun, 01 Nov 2020 02:11:07 -0800 (PST)
Date:   Sun, 01 Nov 2020 02:11:07 -0800
In-Reply-To: <00000000000052792305af1c7614@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000022d95405b308d905@google.com>
Subject: Re: BUG: unable to handle kernel paging request in pvclock_gtod_notify
From:   syzbot <syzbot+815c663e220da75b02b6@syzkaller.appspotmail.com>
To:     b.zolnierkie@samsung.com, bp@alien8.de, dan.carpenter@oracle.com,
        george.kennedy@oracle.com, hpa@zytor.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a49145acfb975d921464b84fe00279f99827d816
Author: George Kennedy <george.kennedy@oracle.com>
Date:   Tue Jul 7 19:26:03 2020 +0000

    fbmem: add margin check to fb_check_caps()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17499724500000
start commit:   60e72093 Merge tag 'clk-fixes-for-linus' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
dashboard link: https://syzkaller.appspot.com/bug?extid=815c663e220da75b02b6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1162b04d900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=135e7383900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: fbmem: add margin check to fb_check_caps()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
