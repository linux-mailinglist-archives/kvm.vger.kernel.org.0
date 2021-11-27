Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C829246006D
	for <lists+kvm@lfdr.de>; Sat, 27 Nov 2021 18:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355747AbhK0RQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 12:16:27 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:35437 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbhK0RO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 12:14:27 -0500
Received: by mail-il1-f197.google.com with SMTP id m9-20020a056e021c2900b002a1d679b412so6611033ilh.2
        for <kvm@vger.kernel.org>; Sat, 27 Nov 2021 09:11:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=K+yxiNRvoRZS9pRMwE6nb/0gBHDc0Ghntu/MPpY6soc=;
        b=h/CD06n//kbno4wuM5H+JztfSm1dnOQ2olcVcWoDOhcbbnUpt/fOHlhl39DflZbf15
         RAg4Uw86dy2hAqQx1knOArV2fhRqGyfKrOWy17J6PeTlLUgFJmpUtk9GO7skCviuHIZI
         SZxSeagd2NBAEbjT+eZZJouddhkv9GxRR933L1vLpEI64OcV3JKkv/DuFHR3swVOTKsX
         PjicdaIYDF1BqsqUDJ9CCRHsf3vNwldGOItKO9v6ieSKl9ForTJ+fHqeGeSTlzG5+kD6
         vvSoP2Mpse1AfYrnsc/mlEXZYLEB7RJ+fSmLp7K+KTV9GQAAlA5YhbV4lhns5uuI9MF+
         T2mw==
X-Gm-Message-State: AOAM532O0DvsavShvAurBY7Rq1p3kQ3l00ChKOWVYGFf7yK5L3fcNtij
        bRY8MvKq2VYd+pEyFPe2yBEbU/fo7TPyHKVn7fjiGVUhf9Mp
X-Google-Smtp-Source: ABdhPJxN9Miw3DqoHDLxUvrACmzL4ogERn4NVrpIgHCvzKvRM+ZyHHT1Pr+qY94keK/uOJQGLs4hNy1ZU9EM9VemVO9Q28CuOl5v
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216b:: with SMTP id s11mr15014619ilv.228.1638033072609;
 Sat, 27 Nov 2021 09:11:12 -0800 (PST)
Date:   Sat, 27 Nov 2021 09:11:12 -0800
In-Reply-To: <0000000000003544c405c8a3026a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006c5f7705d1c84b93@google.com>
Subject: Re: [syzbot] INFO: rcu detected stall in newstat
From:   syzbot <syzbot+84ef57449019b1be878d@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab+huawei@kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        rajatasthana4@gmail.com, sean@mess.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 476db72e521983ecb847e4013b263072bb1110fc
Author: Rajat Asthana <rajatasthana4@gmail.com>
Date:   Wed Aug 18 20:31:10 2021 +0000

    media: mceusb: return without resubmitting URB in case of -EPROTO error.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14c58e09b00000
start commit:   7e96bf476270 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=1dee114394f7d2c2
dashboard link: https://syzkaller.appspot.com/bug?extid=84ef57449019b1be878d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f2aac9d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15470c66300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: media: mceusb: return without resubmitting URB in case of -EPROTO error.

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
