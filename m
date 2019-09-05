Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C6AA9E3E
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 11:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733253AbfIEJZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 05:25:56 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44247 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730872AbfIEJZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 05:25:55 -0400
Received: by mail-oi1-f196.google.com with SMTP id w6so1210909oie.11;
        Thu, 05 Sep 2019 02:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VFHJ387P8zR9bXIGHUXV1cLigtt/phW3cSnanO7IPXo=;
        b=hOjanp9PqcJlXoE4DwMUXVTq96Tvl75q1CFpmRg4tmPWT4CDwiszxWwXqcQ5X/aYg0
         ++oQWrQqbuUAF4MRRxF9zz2THSbSRJW/cimvodRL7RqVh6eIRj1x4f031utdXkubGf+o
         uNR2a+m+TbzfF1zktJKQfmxVs/ZhAmGDjU9uw9a+rmKjeu4wKM1bPmEzy6Bqcp2z+EvL
         OWno06os//ixUIJfuBK2NMHHdbPZRXkRgjEK0ZgAn2hM+qvtGmHSqmKmaxihC32d/NPd
         3j6wP4rh3nO3UCQsxfZS4AwdL3oNMH4onNnKA0Sby7AImQNNhMZXyWMxiqKjkKYMC2Vq
         oXew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VFHJ387P8zR9bXIGHUXV1cLigtt/phW3cSnanO7IPXo=;
        b=bo8fqE22Yso2VpUlT5YKOmuwpgCUR34t9RwrcWeMFb+3dOIt2X1Fc7kqhOt3iePtWE
         VuJlbmQjZe2qHFI2k+UvGiQpfPqrPlORKc77JIpYLmb1FUKSCTQ6+v5sHjQXnBFsZoIg
         SuLinvrEU9JEHxSKVoKqVXXBfjwQaUSbFNJ39cRyRivQ2Ltx8ZTaAHWAVpNHMEeI8GMW
         274d7n2wryXkFQSSELjBtyXDxj+kcSqvKkcMMB34rUtwcI4SpmrkTzBJ6+afWsViaWlq
         ZvKgfW5x+lH/tlWE8qeEQuOAPAjBnlF9fMv6cPwP7JW0n5kILAweXMjUv5juG5kHpIFz
         OvSg==
X-Gm-Message-State: APjAAAVHXxDLxQEJKlDz6iEFIYUoL406+MsTLUYE6gkVILEfvAEChhRo
        wPwTBMDApGOTEmpCJXp5vR0JJI2U2cBMbv9OeUk=
X-Google-Smtp-Source: APXvYqzD2sX0jdF8eMqAF3mbE5fLEECJkC7+LQzqc4bMkc2UN1eib0nN6IgUL88mx5bMYDL9FesnvWiYY74WU+F9KXM=
X-Received: by 2002:aca:49cf:: with SMTP id w198mr1739510oia.141.1567675554276;
 Thu, 05 Sep 2019 02:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e3072b0591ca1937@google.com>
In-Reply-To: <000000000000e3072b0591ca1937@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 5 Sep 2019 17:25:41 +0800
Message-ID: <CANRm+CxBdFjVrYzAe_Rs=v6BMSq9Gx+ngDrEitK6aez=kMq2XQ@mail.gmail.com>
Subject: Re: general protection fault in __apic_accept_irq
To:     syzbot <syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, devel@linuxdriverproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, mikelley@microsoft.com,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Sep 2019 at 16:53, syzbot
<syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    3b47fd5c Merge tag 'nfs-for-5.3-4' of git://git.linux-nfs...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=124af12a600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=144488c6c6c6d2b6
> dashboard link: https://syzkaller.appspot.com/bug?extid=dff25ee91f0c7d5c1695
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10954676600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1752fe0a600000
>
> The bug was bisected to:
>
> commit 0aa67255f54df192d29aec7ac6abb1249d45bda7
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Mon Nov 26 15:47:29 2018 +0000
>
>      x86/hyper-v: move synic/stimer control structures definitions to
> hyperv-tlfs.h
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=156128c1600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=136128c1600000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
> Fixes: 0aa67255f54d ("x86/hyper-v: move synic/stimer control structures
> definitions to hyperv-tlfs.h")
>
> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000004 data
> 0x94
> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000004 data
> 0x48c
> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000004 data
> 0x4ac
> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000005 data
> 0x1520
> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000006 data
> 0x15d4
> kvm [9347]: vcpu0, guest rIP: 0xcc Hyper-V uhandled wrmsr: 0x40000007 data
> 0x15c4
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 9347 Comm: syz-executor665 Not tainted 5.3.0-rc7+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029

Thanks for the report, I found the root cause, will send a patch soon.

> Code: 89 55 cc 41 89 f4 48 89 fb 49 bd 00 00 00 00 00 fc ff df e8 5c c9 5d
> 00 48 89 5d c0 4c 8d b3 98 00 00 00 4d 89 f7 49 c1 ef 03 <43> 80 3c 2f 00
> 74 08 4c 89 f7 e8 6b c4 96 00 49 8b 06 48 89 45 d0
> RSP: 0018:ffff88808a30f9b0 EFLAGS: 00010202
> RAX: ffffffff8115c384 RBX: 0000000000000000 RCX: ffff8880977f2140
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff88808a30fa10 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffed1011461f64 R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: 0000000000000098 R15: 0000000000000013
> FS:  0000555555e35880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000008f96d000 CR4: 00000000001426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   kvm_apic_set_irq+0xb4/0x140 arch/x86/kvm/lapic.c:558
>   stimer_notify_direct arch/x86/kvm/hyperv.c:648 [inline]
>   stimer_expiration arch/x86/kvm/hyperv.c:659 [inline]
>   kvm_hv_process_stimers+0x594/0x1650 arch/x86/kvm/hyperv.c:686
>   vcpu_enter_guest+0x2b2a/0x54b0 arch/x86/kvm/x86.c:7896
>   vcpu_run+0x393/0xd40 arch/x86/kvm/x86.c:8152
>   kvm_arch_vcpu_ioctl_run+0x636/0x900 arch/x86/kvm/x86.c:8360
>   kvm_vcpu_ioctl+0x6cf/0xaf0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2765
>   do_vfs_ioctl+0x744/0x1730 fs/ioctl.c:46
>   ksys_ioctl fs/ioctl.c:713 [inline]
>   __do_sys_ioctl fs/ioctl.c:720 [inline]
>   __se_sys_ioctl fs/ioctl.c:718 [inline]
>   __x64_sys_ioctl+0xe3/0x120 fs/ioctl.c:718
>   do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x442a19
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 1b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffca3d2a208 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000442a19
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 00000000006cd018 R08: 00000000004002c8 R09: 00000000004002c8
> R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000403ac0
> R13: 0000000000403b50 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 8515c4c18eb55117 ]---
> RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
> Code: 89 55 cc 41 89 f4 48 89 fb 49 bd 00 00 00 00 00 fc ff df e8 5c c9 5d
> 00 48 89 5d c0 4c 8d b3 98 00 00 00 4d 89 f7 49 c1 ef 03 <43> 80 3c 2f 00
> 74 08 4c 89 f7 e8 6b c4 96 00 49 8b 06 48 89 45 d0
> RSP: 0018:ffff88808a30f9b0 EFLAGS: 00010202
> RAX: ffffffff8115c384 RBX: 0000000000000000 RCX: ffff8880977f2140
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff88808a30fa10 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffed1011461f64 R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: 0000000000000098 R15: 0000000000000013
> FS:  0000555555e35880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000008f96d000 CR4: 00000000001426f0
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
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
