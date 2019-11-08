Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CEBF57DC
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 21:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732445AbfKHTms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 14:42:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731522AbfKHTms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 14:42:48 -0500
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8537C5D611
        for <kvm@vger.kernel.org>; Fri,  8 Nov 2019 19:42:47 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id g17so2862770wmc.4
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 11:42:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hC59yqiltYn4vvyKnCEG+/GKT1N5JkWniSQcOQlyHmc=;
        b=HeNKlTp1cru5gMxKFK++2CsrCKD9V0zwfmKDJAYfA/01Yr7t9LefnAQGN1XwHYp2Wi
         dFh+TG3ppL46a3EtV4U+UxHP/HT+WNrJOvfZDjbPuG19jOpCZpYqaYR1bmpwhA+/LqsR
         hqP4uPFGzdA6BslEAV7SEtpVssNH+aIxQA+UX7E7EGCG7FSRAVla6wh4TlcCWv7kd9P0
         E4kmLh3kFfI5i5gZd0d9ug7Sfu4XM3KBmP76ghg/XwP3D3qLeFQ01TgfJHkjctSnzr7j
         wlCIBJy8FQeN9CvQ14/B5NpEpaRMy1qgxBNZ9QCuNVUMalUVCjsrBBKDjcnFnhURkDCa
         dArQ==
X-Gm-Message-State: APjAAAW17bL8o/Kg2PW7JZBRmuGHJz7g33zKhxIhhgtY+uuOhcvyqSyK
        lJax2rnpQNJXVeFj6bCWwJFls9JtNvlpbebS4+zqxd8wknHT0rxO93xpGKfN31ZQpqXU5OWcAnK
        roV4Z4jp+9Mfn
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr10490055wrv.216.1573242166031;
        Fri, 08 Nov 2019 11:42:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqzZrG7rZe8SIDZ8LBTBdzCrruPtLQvP7N7cD4A29kVchgyhUWiqVUhF8K4meBoi8TlF+y75AA==
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr10490028wrv.216.1573242165669;
        Fri, 08 Nov 2019 11:42:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e8cd:9f0f:a5dc:7ad5? ([2001:b07:6468:f312:e8cd:9f0f:a5dc:7ad5])
        by smtp.gmail.com with ESMTPSA id 16sm10182438wmf.0.2019.11.08.11.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 11:42:45 -0800 (PST)
Subject: Re: kernel BUG at arch/x86/kvm/mmu.c:LINE! (2)
To:     syzbot <syzbot+824609cfabee9c6e153c@syzkaller.appspotmail.com>,
        abbotti@mev.co.uk, bp@alien8.de, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, hpa@zytor.com,
        hsweeten@visionengravers.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, olsonse@umich.edu, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
References: <00000000000018f5440596da964b@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dd6b9b2c-a6d7-43a3-2e71-2cc5e2066673@redhat.com>
Date:   Fri, 8 Nov 2019 20:42:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <00000000000018f5440596da964b@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

#syz dup:  KASAN: slab-out-of-bounds Read in handle_vmptrld

On 08/11/19 20:14, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    847120f8 Merge branch 'for-linus' of
> git://git.kernel.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12d60164e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5e2eca3f31f9bf
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=824609cfabee9c6e153c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e2a12ce00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13314994e00000
> 
> The bug was bisected to:
> 
> commit 1ffe8bdc09f8bfcaad76d71ae68b623c7e03f20f
> Author: Spencer E. Olson <olsonse@umich.edu>
> Date:   Mon Oct 10 14:14:19 2016 +0000
> 
>     staging: comedi: ni_mio_common: split out ao arming from ni_ao_inttrig
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122977fae00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=162977fae00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+824609cfabee9c6e153c@syzkaller.appspotmail.com
> Fixes: 1ffe8bdc09f8 ("staging: comedi: ni_mio_common: split out ao
> arming from ni_ao_inttrig")
> 
> L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646
> and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html
> for details.
> ------------[ cut here ]------------
> kernel BUG at arch/x86/kvm/mmu.c:3324!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 8688 Comm: syz-executor906 Not tainted 5.4.0-rc6+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:transparent_hugepage_adjust+0x490/0x530 arch/x86/kvm/mmu.c:3324
> Code: 63 00 48 8b 45 b8 48 83 e8 01 e9 19 fd ff ff e8 36 3c 63 00 48 8b
> 45 b8 48 83 e8 01 48 89 45 c8 e9 a1 fd ff ff e8 20 3c 63 00 <0f> 0b 48
> 89 df e8 66 9e 9e 00 e9 9f fb ff ff 4c 89 ff e8 59 9e 9e
> RSP: 0018:ffff88809753f690 EFLAGS: 00010293
> RAX: ffff88809549e6c0 RBX: ffff88809753f778 RCX: ffffffff810fe787
> RDX: 0000000000000000 RSI: ffffffff810fe8c0 RDI: 0000000000000007
> RBP: ffff88809753f6d8 R08: ffff88809549e6c0 R09: ffffed10131ed682
> R10: ffffed10131ed681 R11: ffff888098f6b40b R12: ffff88809753f768
> R13: 0000000000000083 R14: 000000000008fe81 R15: 0000000000000000
> FS:  000000000158e880(0000) GS:ffff8880ae800000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000009f2a4000 CR4: 00000000001426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  tdp_page_fault+0x56e/0x650 arch/x86/kvm/mmu.c:4216
>  kvm_mmu_page_fault+0x1dd/0x1800 arch/x86/kvm/mmu.c:5439
>  handle_ept_violation+0x259/0x560 arch/x86/kvm/vmx/vmx.c:5185
>  vmx_handle_exit+0x29f/0x1730 arch/x86/kvm/vmx/vmx.c:5929
>  vcpu_enter_guest arch/x86/kvm/x86.c:8227 [inline]
>  vcpu_run arch/x86/kvm/x86.c:8291 [inline]
>  kvm_arch_vcpu_ioctl_run+0x1cb8/0x70d0 arch/x86/kvm/x86.c:8498
>  kvm_vcpu_ioctl+0x4dc/0xfc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2772
>  vfs_ioctl fs/ioctl.c:46 [inline]
>  file_ioctl fs/ioctl.c:509 [inline]
>  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
>  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
>  __do_sys_ioctl fs/ioctl.c:720 [inline]
>  __se_sys_ioctl fs/ioctl.c:718 [inline]
>  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
>  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x443f49
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89
> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
> f0 ff ff 0f 83 7b d8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffd991d67d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00000000004002e0 RCX: 0000000000443f49
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
> RBP: 00000000006ce018 R08: 00000000004002e0 R09: 00000000004002e0
> R10: 00000000004002e0 R11: 0000000000000246 R12: 0000000000401c50
> R13: 0000000000401ce0 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 911095bae56804bc ]---
> RIP: 0010:transparent_hugepage_adjust+0x490/0x530 arch/x86/kvm/mmu.c:3324
> Code: 63 00 48 8b 45 b8 48 83 e8 01 e9 19 fd ff ff e8 36 3c 63 00 48 8b
> 45 b8 48 83 e8 01 48 89 45 c8 e9 a1 fd ff ff e8 20 3c 63 00 <0f> 0b 48
> 89 df e8 66 9e 9e 00 e9 9f fb ff ff 4c 89 ff e8 59 9e 9e
> RSP: 0018:ffff88809753f690 EFLAGS: 00010293
> RAX: ffff88809549e6c0 RBX: ffff88809753f778 RCX: ffffffff810fe787
> RDX: 0000000000000000 RSI: ffffffff810fe8c0 RDI: 0000000000000007
> RBP: ffff88809753f6d8 R08: ffff88809549e6c0 R09: ffffed10131ed682
> R10: ffffed10131ed681 R11: ffff888098f6b40b R12: ffff88809753f768
> R13: 0000000000000083 R14: 000000000008fe81 R15: 0000000000000000
> FS:  000000000158e880(0000) GS:ffff8880ae800000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000009f2a4000 CR4: 00000000001426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see:
> https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

