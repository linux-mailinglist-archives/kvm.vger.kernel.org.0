Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E26C3E7C5F
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 17:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243105AbhHJPfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 11:35:12 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54988 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243242AbhHJPfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 11:35:00 -0400
Received: by mail-io1-f69.google.com with SMTP id 81-20020a6b02540000b02905824a68848bso13956839ioc.21
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 08:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ezvPuPtMzOuRLqecX2VTZ2ztz0IyxYGYWNq3bM8LvCs=;
        b=hgKPCvioP4bGN4mSyzedTYA2WKsu7qIegJOBvfP6o8Msmz/JJ3Fw0dCy3T8OR4VeFW
         QMu+Q5h60L53nwpUgXyQ2u/UQ8WkQzibMiPeyMMBgHdzT4eXJU1zi/2UA/khhkkQHF26
         n245rujzrzlKbg/Pe4AmAyW44qYIOJPjkf+lKPBcFaXkntrIbRKLzb2FnX6QAR70jdOS
         VsohioN0fWGfCLW17VmBSF0KZsWA0LS68W/Y2D3ebjVHN1bu44KSfDiax5VJxvLXqyDo
         tzvVXcbur/36B7hYfUGLgjiH1noNjURCLX96LHKECKwyDDPyeKt+OuUvZBN28MD5y5kR
         KB7w==
X-Gm-Message-State: AOAM530MoxRq1ftWg9AzX79tF0pxiqkgTE00+nFffNjHQtgfPdX0/Ncr
        HZOpj81rQI/2tIVOxjN2kGiENyrLBbgTDRWt8J0jZMU1uhAB
X-Google-Smtp-Source: ABdhPJxUNwqzmK5BP4xy5zYm2dHKjVhr9kXAul5tmQWBzbKn7f/vtTtKsjuaPj76egcfQsjLcONIB+8s6JEZ9u6yEHxs1CkpszEd
MIME-Version: 1.0
X-Received: by 2002:a5d:9ac1:: with SMTP id x1mr16641ion.191.1628609652476;
 Tue, 10 Aug 2021 08:34:12 -0700 (PDT)
Date:   Tue, 10 Aug 2021 08:34:12 -0700
In-Reply-To: <0000000000007faf7505c91bb19d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d04e9b05c9363bf1@google.com>
Subject: Re: [syzbot] general protection fault in hwsim_new_edge_nl
From:   syzbot <syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, alex.aring@gmail.com, bp@alien8.de,
        davem@davemloft.net, frederic@kernel.org, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, mark.rutland@arm.com,
        masahiroy@kernel.org, mingo@redhat.com, mudongliangabcd@gmail.com,
        netdev@vger.kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rostedt@goodmis.org, seanjc@google.com, sedat.dilek@gmail.com,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vitor@massaru.org, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has bisected this issue to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13927981300000
start commit:   d09c548dbf3b net: sched: act_mirred: Reset ct info when mi..
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10527981300000
console output: https://syzkaller.appspot.com/x/log.txt?x=17927981300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
dashboard link: https://syzkaller.appspot.com/bug?extid=fafb46da3f65fdbacd16
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152ee39e300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15946ff1300000

Reported-by: syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
