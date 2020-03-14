Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7F9185A1F
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 06:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCOFE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Mar 2020 01:04:27 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40740 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgCOFE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Mar 2020 01:04:27 -0400
Received: by mail-qk1-f195.google.com with SMTP id j2so7461164qkl.7
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 22:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wAGBaGlP5UjGPHzk24EwmtbBIUN0VOZVoqYTIi4xf8s=;
        b=Vfg9IUL1wQtNRrZmPe6JtE+jjCAl0DofHknEisT0EbX3xBQN3Dz8aPLIm8ZvAFZLpW
         qN+z/fTYjhI9C4NcGE1LFZdKV+Yyf5pCx/sLqJrSab0GaDDcTFoL/opOC63Io96pVQ0N
         iC/I/5JKSpaT+w3wCUwKSbR0zsCKLzhxwnLbnolKriSY3W/NvvOuDw/x2xVh/OVQUlJ9
         vXwpCt7G8jpOrnUZ1gMzKxcrX249o0IWQR1VspqSENNXPDe5TD7sG7kjDa5ViEDOExG4
         QHRK48BSBvgJIqyfN5BwgCl20FR8cPE9CCt1C9ilZLLQO8f3ddEqV5vi2Zmq4wWcOxFI
         m7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wAGBaGlP5UjGPHzk24EwmtbBIUN0VOZVoqYTIi4xf8s=;
        b=bn9aybXbwdg43L7kMm4QxGfk1wQnU/NQtyXJ5Z57RAegal8FKLkt1b+4FogJYWdsW3
         HJTxQ7VsPTRrRkHXx0qcGrIVU1OfqEnDQb0/6BYsQCm7sbx2v2YQsXWtRkhifBXApBsi
         4H5mS5G+Eqfbhvb3UhFJFtXOQZcz1cF9i5/e2CxBo4bQ6OjxIq9Ub4ZSEOeWv0lk4Qtv
         JU+gkfe0op3mdCmZDIFRF0EByLYIZJncmiEbbAFOOCNP/xujXP3pxfWXK/P1+At8QBFo
         VKQEkUnOwb0vqYeUNbwmFjWX7I4nB1p9jTVHChGjWhCtw4xZseIRt/Ilx4Q950i0VFB9
         eOqA==
X-Gm-Message-State: ANhLgQ0dOcLsrfVumYkXukgFkkIoWjTFbvzsmx9SRwLIdc4gCUPHNPSO
        L7tQHT4DYGSEX/peECUV7eaUtpsfNl1RXhYeti+XEp/6zPo=
X-Google-Smtp-Source: ADFU+vsaWhVJeWwbcUR3mI1iOg1Kx7ily9lUjGMV/AaCuYWbtMaJdWvOnghbteC5GlnLye9vMTld7eLbldeE1uH+RS8=
X-Received: by 2002:a37:8b01:: with SMTP id n1mr15063650qkd.407.1584172414971;
 Sat, 14 Mar 2020 00:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f4b79505a0cad08b@google.com>
In-Reply-To: <000000000000f4b79505a0cad08b@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 14 Mar 2020 08:53:24 +0100
Message-ID: <CACT4Y+YOYhEngp_aGHrzMG=dZO=dUVjpjC72vd6_L01fROUchQ@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 corrupted (5)
To:     syzbot <syzbot+8b0e78e390d1715b0f4e@syzkaller.appspotmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        KVM list <kvm@vger.kernel.org>
Cc:     allison@lohutok.net, alsa-devel@alsa-project.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Richard Fontana <rfontana@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Takashi Iwai <tiwai@suse.com>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 14, 2020 at 7:37 AM syzbot
<syzbot+8b0e78e390d1715b0f4e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    30bb5572 Merge tag 'ktest-v5.6' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15d300b1e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a5295e161cd85b82
> dashboard link: https://syzkaller.appspot.com/bug?extid=8b0e78e390d1715b0f4e
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a57709e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13de9e91e00000

Looking at the reproducer, it's all KVM, +KVM maintainers.

> The bug was bisected to:
>
> commit 271213ef4d0d3a3b80d4cf95c5f2bebb5643e666
> Author: Takashi Iwai <tiwai@suse.de>
> Date:   Tue Dec 10 06:34:50 2019 +0000
>
>     ALSA: pcxhr: Support PCM sync_stop
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1566b08de00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1766b08de00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1366b08de00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+8b0e78e390d1715b0f4e@syzkaller.appspotmail.com
> Fixes: 271213ef4d0d ("ALSA: pcxhr: Support PCM sync_stop")
>
> BUG: kernel NULL pointer dereference, address: 0000000000000086
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD a27fa067 P4D a27fa067 PUD a2185067 PMD 0
> Oops: 0010 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 9168 Comm: syz-executor418 Not tainted 5.6.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:0x86
> Code: Bad RIP value.
> RSP: 0018:ffffc90002c9f998 EFLAGS: 00010086
> RAX: ffffc90002c9f9c8 RBX: fffffe0000000000 RCX: ffff8880a31b6280
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000ec0 R08: ffffffff839888d3 R09: ffffffff811c7d9a
> R10: ffff8880a31b6280 R11: 0000000000000002 R12: dffffc0000000000
> R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
> FS:  0000000000981880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000000005c CR3: 00000000986d2000 CR4: 00000000001426e0
> Call Trace:
> Modules linked in:
> CR2: 0000000000000086
> ---[ end trace 7c78bc94cfc0a37d ]---
> RIP: 0010:0x86
> Code: Bad RIP value.
> RSP: 0018:ffffc90002c9f998 EFLAGS: 00010086
> RAX: ffffc90002c9f9c8 RBX: fffffe0000000000 RCX: ffff8880a31b6280
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000ec0 R08: ffffffff839888d3 R09: ffffffff811c7d9a
> R10: ffff8880a31b6280 R11: 0000000000000002 R12: dffffc0000000000
> R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
> FS:  0000000000981880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000000005c CR3: 00000000986d2000 CR4: 00000000001426e0
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
