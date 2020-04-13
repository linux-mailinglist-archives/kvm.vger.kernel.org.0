Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C721A6575
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 13:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgDMLDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 07:03:06 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37199 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbgDMLDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 07:03:05 -0400
Received: by mail-il1-f199.google.com with SMTP id z14so3231120ilz.4
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 04:03:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2IOvHbBUeIFh4zGFQjXxW5DQqukbUbAB0rjAVOkLv/w=;
        b=T1qc+3VMi04fFR6b9EEOYwZqfy3eAwJcjDqBD1NBZK4AVjH++VFsAwOQ6up5HTzno3
         ZvxKqA4bHmHRmNKMtEhyxPoohvrfpYKJ8Xn3O0Xv7P320wRua7jZ4pmdeAM1OBqCceiN
         BGK0nDR7Z3lIVF1qlhW+XJ7hHY4AEB6mBaxpbPTSOxjeh32Ln3KcrCuX0OlVVZPrkJDD
         y4McKXregHfnZo447zp2pE8Y14YNDQNKjODQKCBsw3cnLG71IZZA07G+KwXDuFq9pOHh
         ul4G0JewjYxU3iZFtlxI+o1XCp2CNEWNmPD3acs+WeiYDeIMzpkru+0gJ25i/D8pvquJ
         QbxQ==
X-Gm-Message-State: AGi0Pub+KlikDKGRFCd6nG8T/s9mSjmHJDCTJ4RMageWEh1puay8jx0u
        xBZSE8EHzDxl/xFrFjP3JaabGNUp2GZpVv1sf43NbYgJ1cHP
X-Google-Smtp-Source: APiQypLicYJNdk15GuKhgeGZAg5xWK36DdcdM4+DwXTrzX3cEvE+bTGd6A8kvDoJZPtS1k1WvcOTKwpdKA0d2t1jNBkZKQ6dx5jB
MIME-Version: 1.0
X-Received: by 2002:a92:d98c:: with SMTP id r12mr4971216iln.224.1586775784334;
 Mon, 13 Apr 2020 04:03:04 -0700 (PDT)
Date:   Mon, 13 Apr 2020 04:03:04 -0700
In-Reply-To: <0000000000003311fd05a327a060@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6ae4905a32a0633@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in gfn_to_memslot
From:   syzbot <syzbot+2e0179e5185bcd5b9440@syzkaller.appspotmail.com>
To:     christoffer.dall@arm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        peterx@redhat.com, sean.j.christopherson@intel.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this bug to:

commit 36947254e5f981aeeedab1c7dfa35fc34d330e80
Author: Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Tue Feb 18 21:07:32 2020 +0000

    KVM: Dynamically size memslot array based on number of used slots

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1099775de00000
start commit:   4f8a3cc1 Merge tag 'x86-urgent-2020-04-12' of git://git.ke..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1299775de00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1499775de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3bfbde87e8e65624
dashboard link: https://syzkaller.appspot.com/bug?extid=2e0179e5185bcd5b9440
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e78c7de00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14cf613fe00000

Reported-by: syzbot+2e0179e5185bcd5b9440@syzkaller.appspotmail.com
Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
