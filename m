Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C335CF6ABE
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2019 19:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfKJSWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Nov 2019 13:22:01 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:39053 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfKJSWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Nov 2019 13:22:01 -0500
Received: by mail-io1-f71.google.com with SMTP id e17so10306586ioc.6
        for <kvm@vger.kernel.org>; Sun, 10 Nov 2019 10:22:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6IYsbyGOlas2TYkBAA+OX3C+c+c7PZmkmS2Lj4e2olM=;
        b=ZFc8uqjF2eNC7aWttBCKhNB3c1FFfGwGDUjl/p8znqwN09SrF7i1GuSocL23DuyA9t
         eyDzpeRpf5uUvAOFlhia3wHnJGaZi5q29uX2OIr2JhyPbuCfJlYcDA9h4j9NMoh0Ub72
         f2jW2NLsUC03oOAbKiPnlpQfZT0yRcPsTO8DO8gswO9MOjtt7qKLs/s4DfBKDjb+BoKi
         ANqPtyS4qTq0PyiBBZXg7byKCpgZGGBLEPjH73e1n8ntxFAEqg2dYlM07x7CGf4UxilD
         VgiQXcqq9cpoxZ3P1rurSrE97LRso9NGPUNK/LRIQOzY5O6W58cZCaaq27qlCA7qKwP3
         wWEQ==
X-Gm-Message-State: APjAAAUnnYdKpwM9TLvj7q/wdCMlMn/Vr4rtB5Jp8HYziSp4nPHBTLVQ
        pdSvZFlZ6Qocw5QdamcwVhgVoGhPUuZQa4GDqX/2qUgRBLxD
X-Google-Smtp-Source: APXvYqwMQzZ1opUlIK8pdiq3H2xsR+xRhM/WZ5LyKgYFGDDzAwpnulN1V5k5E71tn+RB6nDtjNGlfXgoCchmQxi7xESS5hCBRlUI
MIME-Version: 1.0
X-Received: by 2002:a92:48cf:: with SMTP id j76mr25098653ilg.189.1573410120472;
 Sun, 10 Nov 2019 10:22:00 -0800 (PST)
Date:   Sun, 10 Nov 2019 10:22:00 -0800
In-Reply-To: <000000000000be219705967f9963@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000051218f059702171a@google.com>
Subject: Re: general protection fault in kvm_coalesced_mmio_init
From:   syzbot <syzbot+e27e7027eb2b80e44225@syzkaller.appspotmail.com>
To:     jmattson@google.com, junaids@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, syzkaller-bugs@googlegroups.com
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13eaf7ece00000
start commit:   00aff683 Merge tag 'for-5.4-rc6-tag' of git://git.kernel.o..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=101af7ece00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17eaf7ece00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=896c87b73c6fcda6
dashboard link: https://syzkaller.appspot.com/bug?extid=e27e7027eb2b80e44225
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ed65aae00000

Reported-by: syzbot+e27e7027eb2b80e44225@syzkaller.appspotmail.com
Fixes: 9121923c457d ("kvm: Allocate memslots and buses before calling  
kvm_arch_init_vm")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
