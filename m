Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9759547935
	for <lists+kvm@lfdr.de>; Sun, 12 Jun 2022 09:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiFLHff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jun 2022 03:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiFLHfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jun 2022 03:35:32 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D144F39BA2
        for <kvm@vger.kernel.org>; Sun, 12 Jun 2022 00:35:29 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id e4-20020a056e020b2400b002d5509de6f3so2564223ilu.6
        for <kvm@vger.kernel.org>; Sun, 12 Jun 2022 00:35:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1Xgh0uMJ75AgI9MjY81mi9Hj4ZGB8BF+ScF7gj9/dZs=;
        b=7oV78FdCcEW77zAf9CAmvrsSm7jS/dA83sOmD0bdkSoPbJpHBbBYL6n43Cm91carWV
         +FbNhh07s5DgwTjXxVkTlo5PJTHZy8BKsgvN/oR9V+B2jNoMwyLd6Ly5ddiQwYNsbrmW
         suYbvncLl7aDkJuvu7IqkrJb0++0qAYMHHAgm7t/IKc0Y0FrrtzCV9KrGU8fUnqlVXZb
         RyxRopToGEKkOq5/PXmD2aA8f3SLhvb1DigB/PHgm+Km3/hIlDMwXrzRthpGKmdyMhGm
         1OMICo0LXUKohILXhV/1YGGlcNJOKEuwWaLwoYftTqKS7S+umgGdBZ1KLXHy7uRpI4y1
         AU9w==
X-Gm-Message-State: AOAM532H24ph61PXsbXZPANzDkl8PiLEYbGCHePWqIolaZVlk8Xr5WJ2
        YUoraKet0pR9NRa27Fah4vrx1daBxZyIiIwum0pYAJShJg28
X-Google-Smtp-Source: ABdhPJyFszkRlznaIKtJRNsItp2ig/3Ynjfye5LPspwE2oE45vUhET4fVhR5gtyI6VgYzWK2bJ0wpu5vhofFsGPNvpaD7ZJzJB39
MIME-Version: 1.0
X-Received: by 2002:a92:c24c:0:b0:2d1:cdd0:1959 with SMTP id
 k12-20020a92c24c000000b002d1cdd01959mr28765647ilo.39.1655019329229; Sun, 12
 Jun 2022 00:35:29 -0700 (PDT)
Date:   Sun, 12 Jun 2022 00:35:29 -0700
In-Reply-To: <0000000000000a5eae05d8947adb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003719fc05e13b37e3@google.com>
Subject: Re: [syzbot] WARNING in handle_exception_nmi (2)
From:   syzbot <syzbot+4688c50a9c8e68e7aaa1@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    7a68065eb9cd Merge tag 'gpio-fixes-for-v5.19-rc2' of git:/..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=177df408080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20ac3e0ebf0db3bd
dashboard link: https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12087173f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16529343f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4688c50a9c8e68e7aaa1@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3609 at arch/x86/kvm/vmx/vmx.c:4896 handle_exception_nmi+0xfdc/0x1190 arch/x86/kvm/vmx/vmx.c:4896
Modules linked in:
CPU: 0 PID: 3609 Comm: syz-executor169 Not tainted 5.19.0-rc1-syzkaller-00303-g7a68065eb9cd #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:handle_exception_nmi+0xfdc/0x1190 arch/x86/kvm/vmx/vmx.c:4896
Code: 0f 84 c8 f3 ff ff e8 33 5c 58 00 48 89 ef c7 85 84 0d 00 00 00 00 00 00 e8 21 35 ec ff 41 89 c4 e9 af f3 ff ff e8 14 5c 58 00 <0f> 0b e9 69 f6 ff ff e8 08 5c 58 00 be f5 ff ff ff bf 01 00 00 00
RSP: 0018:ffffc9000309faf8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801ba1d880 RSI: ffffffff8122171c RDI: 0000000000000001
RBP: ffff88807cd88000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 00000000a0000975
R13: ffff88807cd88248 R14: 0000000000000000 R15: 0000000080000300
FS:  0000555556c8d300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000229ca000 CR4: 00000000003526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 00000000b8fecd19 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6174 [inline]
 vmx_handle_exit+0x498/0x1950 arch/x86/kvm/vmx/vmx.c:6191
 vcpu_enter_guest arch/x86/kvm/x86.c:10361 [inline]
 vcpu_run arch/x86/kvm/x86.c:10450 [inline]
 kvm_arch_vcpu_ioctl_run+0x4208/0x66f0 arch/x86/kvm/x86.c:10654
 kvm_vcpu_ioctl+0x570/0xf30 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3944
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f56efaee199
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc37353158 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f56efaee199
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f56efab1bf0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f56efab1c80
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

