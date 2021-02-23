Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595E732342C
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 00:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhBWXZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 18:25:08 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:41639 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbhBWXRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 18:17:50 -0500
Received: by mail-il1-f200.google.com with SMTP id d11so169350ilu.8
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 15:17:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gxwmyLE4SO4oZCr9Sp7tYxHthtIvfwFjtggaVC9TLEY=;
        b=qRsRXBlpvEXxcqTqIHIgoQUbPnqRiQzA1S/ZEVza35gmcOZ/6vpWqwGqFhJ6JS9cbW
         ZmOFkGt37idrYB5Cv804AaAgSICyG9n+g3nw/5xGcduZuXslpxSG30khE2vmCgEFcE1k
         piKaNizCWk9a67XZYlUZ/4K0Q80lYXL4Lh/WUgjohjDe7OAttZKnoP1m8dipYgcVj0vZ
         0+esVofSGMiiYPVvHclcONfagRPKc46TtN8Xtg1drsUK7sF8YcwjTVDplViA57fheULl
         9O6rPCud/d+kKRr5yx2UC7jPvfTbd1RXuK/eVtKsYbNuFqPUrJWrugSSWPRQaEnA1S3+
         x+/A==
X-Gm-Message-State: AOAM530jFYiVPfDweAlXGQ6rSm+WnkpAVNYYrEPyF+gbMt8cG1f0xW+e
        Yl7fMVy8esa/itwmtgYK7GUZit5X2oJZDwAloCzOVBSKMLeV
X-Google-Smtp-Source: ABdhPJxYMQRLjCGcu4le9+pAKne7p4M1hhMXnq5Lth1vDibAlbh+oMC6vk0slJxcCfpjngyHErXn1JGb1zpfvJVCqGsT9oaRHYFP
MIME-Version: 1.0
X-Received: by 2002:a02:1909:: with SMTP id b9mr23360492jab.141.1614122227911;
 Tue, 23 Feb 2021 15:17:07 -0800 (PST)
Date:   Tue, 23 Feb 2021 15:17:07 -0800
In-Reply-To: <0000000000007ff56205ba985b60@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000004e7d105bc091e06@google.com>
Subject: Re: general protection fault in vmx_vcpu_run (2)
From:   syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>
To:     bp@alien8.de, bp@suse.de, dave.hansen@intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lstoakes@gmail.com, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit 167dcfc08b0b1f964ea95d410aa496fd78adf475
Author: Lorenzo Stoakes <lstoakes@gmail.com>
Date:   Tue Dec 15 20:56:41 2020 +0000

    x86/mm: Increase pgt_buf size for 5-level page tables

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13fe3ea8d00000
start commit:   a99163e9 Merge tag 'devicetree-for-5.12' of git://git.kern..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10013ea8d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17fe3ea8d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=49116074dd53b631
dashboard link: https://syzkaller.appspot.com/bug?extid=42a71c84ef04577f1aef
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141f3f04d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17de4f12d00000

Reported-by: syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com
Fixes: 167dcfc08b0b ("x86/mm: Increase pgt_buf size for 5-level page tables")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
