Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268A8240327
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 10:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgHJIGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 04:06:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21297 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725846AbgHJIGj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Aug 2020 04:06:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597046797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OcahFa/ozGtHspvNjlza3UxikXMeL5PGYiQh3U0aBls=;
        b=azMavoQPn6hFeqG/2l56QK2JgMrKpWVxg8NtjfvJDjI9mqbOiDT8tFIRa/bO0Z9MWJBRUZ
        OjiOvjDTWrUXuVks6Z8HpilyOXyGZdR33rdUD2OdUnlIncgV+pOQjESaICBTYsw0c0uahP
        sQ2+Ju2JMxBuMrHu47LbKPwbSr1Ilbs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-ODkWXGzQP4ahjTWp974Niw-1; Mon, 10 Aug 2020 04:06:32 -0400
X-MC-Unique: ODkWXGzQP4ahjTWp974Niw-1
Received: by mail-ej1-f69.google.com with SMTP id pj3so1889731ejb.19
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 01:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OcahFa/ozGtHspvNjlza3UxikXMeL5PGYiQh3U0aBls=;
        b=Uiy3tQx77LPMN8+cpGSA4DGH0FK04gBkfOOuUKmvUKxo17kN/zwj4x1+c+VtfDlWpH
         4vvpaE7RPJ+oRPdk5ZOGrItOX6+ms9cE/QvXHVq5HIhhXj6b6xbrVLUhusb2wyvqplC8
         Vy5RhC3/O5HLojoYG/Vq2zUud4I7t5WRwBwLFmZReME4SnuZgte/XdZ78ExLw7/Z2EMv
         epdTgYxTg0Up8EH7hSvKIvhVQCdgPPNB62dUyNEcQjWFmijXvNP0usMJEzRzl61AC8hO
         3tR6c8Ji1LEPZf172i8ixf4ImFAQvbXs7+EM3u1S2zMrCoqdWn8Vz7frvu2vSOJ6O1GE
         tD0g==
X-Gm-Message-State: AOAM533qiLoNb3j+ntbN5WIykntp0uP5jKXkCpxUJUnr9tXO7HhzDb9P
        x/O+SsarWqeVq74t7VM2Cy+tlpf2qUncdS3GW7NDQ9jpUgV80MsJIj6RX0Y8t7FI2doQSHaqAq+
        HW/5U6mnnTKKl
X-Received: by 2002:a17:906:9385:: with SMTP id l5mr20142322ejx.144.1597046790005;
        Mon, 10 Aug 2020 01:06:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvamq9BuWqnIdnErIwJVAWKSj/F3XVmYf1XapjDCPpElibWU2Ao+jAty5c/AbzI3WAjBnQTQ==
X-Received: by 2002:a17:906:9385:: with SMTP id l5mr20142296ejx.144.1597046789737;
        Mon, 10 Aug 2020 01:06:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u4sm11888104edy.18.2020.08.10.01.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 01:06:29 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org,
        syzbot <syzbot+c116bcba868f8148cd3e@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        wanpengli@tencent.com, x86@kernel.org,
        Nitesh Narayan Lal <nitesh@redhat.com>
Subject: Re: WARNING in rcu_irq_exit
In-Reply-To: <000000000000843c1005ac7a990c@google.com>
References: <000000000000843c1005ac7a990c@google.com>
Date:   Mon, 10 Aug 2020 10:06:28 +0200
Message-ID: <875z9qorgb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot <syzbot+c116bcba868f8148cd3e@syzkaller.appspotmail.com> writes:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    47ec5303 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17228c62900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c783f658542f35
> dashboard link: https://syzkaller.appspot.com/bug?extid=c116bcba868f8148cd3e
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c116bcba868f8148cd3e@syzkaller.appspotmail.com
>
> device lo entered promiscuous mode
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 29030 at kernel/rcu/tree.c:772 rcu_irq_exit+0x19/0x20 kernel/rcu/tree.c:773
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 29030 Comm: syz-executor.2 Not tainted 5.8.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1f0/0x31e lib/dump_stack.c:118
>  panic+0x264/0x7a0 kernel/panic.c:231
>  __warn+0x227/0x250 kernel/panic.c:600
>  report_bug+0x1b1/0x2e0 lib/bug.c:198
>  handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
>  exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
>  asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
> RIP: 0010:rcu_irq_exit+0x19/0x20 kernel/rcu/tree.c:773
> Code: 0b c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 83 3d fd fb 68 01 00 74 0b 65 8b 05 50 00 dc 77 85 c0 75 05 e9 07 ff ff ff <0f> 0b e9 00 ff ff ff 41 56 53 83 3d da fb 68 01 00 74 0f 65 8b 05
> RSP: 0018:ffffc90001806e70 EFLAGS: 00010002
> RAX: 0000000000000001 RBX: 0000000000000082 RCX: 0000000000040000
> RDX: ffffc9000da6b000 RSI: 0000000000003173 RDI: 0000000000003174
> RBP: ffff8880a2ce9fa8 R08: ffffffff817a9064 R09: ffffed1015d26cf5
> R10: ffffed1015d26cf5 R11: 0000000000000000 R12: dffffc0000000000
> R13: 000000000000003c R14: dffffc0000000000 R15: 000000000000003c
>  rcu_irq_exit_irqson+0x80/0x110 kernel/rcu/tree.c:827
...

Chances are this is fixed by Tglx' 

commit 87fa7f3e98a1310ef1ac1900e7ee7f9610a038bc
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Jul 8 21:51:54 2020 +0200

    x86/kvm: Move context tracking where it belongs

(in kvm/next currently).

See also: https://lore.kernel.org/kvm/ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com/
which was confirmed to be fixed by the above mentioned commit.

-- 
Vitaly

