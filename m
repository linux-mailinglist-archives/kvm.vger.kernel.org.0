Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C727A516F13
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 13:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384806AbiEBLvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 07:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241744AbiEBLvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 07:51:48 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE53A167D4
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 04:48:19 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso10598734ioo.13
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 04:48:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Yz+wn22ujEUKCk4p7FisUPt8bMfaKkzSjy4HRUtOLdg=;
        b=HVbbI0Sw/SuP9LSg8HkD7eA2zGog4u5RfTTTTp1dvtA7lZNxGWq8PZhYbLTnzs1ZYf
         S2jdUtNS47PC7UKXp5O9r/DrYlMG91EzvrkrYsIbkpwmSwvj8ZT43fE37co1cJXgoqB4
         TAFtNAlWCed6zlN4tzXRYPxI7BMSpVPzEJkauL5G+mHwJFUVNDPHPwUrNwx0FuPzj4Jg
         GfkMOUZlSqPqn3f5fkLOUkFgGZSiGF2JAwig5C0jig1HW/naGZLoSBhCBBHpstgJbJfN
         Hq8L/kD/4Q8Rvi9WxlXgxUuEqP03hGkoN6CEVf+1Ep8Aiat04tjeAGPlwhL9cQoSPAwG
         IYWQ==
X-Gm-Message-State: AOAM533fzlin67bV+a4+KHNhrPesVa0PkPhrVuKYi4OkHuvROkq4+E9R
        whouaMTJUNaJGZldIRRC2Ql5lLV1paG2dc+vGkpWRAfNA/Xp
X-Google-Smtp-Source: ABdhPJxXHkBU1sNJNGtPP588E9+M/reUxQ54mGhlaY7+ODPl9vfDYmAh81OuYUTPBUyJRxclevbNy+NMlHq2gpG/YkFVDB3XHU3m
MIME-Version: 1.0
X-Received: by 2002:a02:a518:0:b0:32a:fd7e:ace0 with SMTP id
 e24-20020a02a518000000b0032afd7eace0mr4632233jam.208.1651492099286; Mon, 02
 May 2022 04:48:19 -0700 (PDT)
Date:   Mon, 02 May 2022 04:48:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed68ec05de05f7c4@google.com>
Subject: [syzbot] WARNING in vmx_queue_exception (2)
From:   syzbot <syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com>
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

Hello,

syzbot found the following issue on:

HEAD commit:    57ae8a492116 Merge tag 'driver-core-5.18-rc5' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d27d72f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d21a72f6016e37e8
dashboard link: https://syzkaller.appspot.com/bug?extid=cfafed3bb76d3e37581b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1202b25af00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1386a07af00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 2 PID: 3674 at arch/x86/kvm/vmx/vmx.c:1628 vmx_queue_exception+0x3e6/0x450 arch/x86/kvm/vmx/vmx.c:1628
Modules linked in:
CPU: 2 PID: 3674 Comm: syz-executor352 Not tainted 5.18.0-rc4-syzkaller-00396-g57ae8a492116 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:vmx_queue_exception+0x3e6/0x450 arch/x86/kvm/vmx/vmx.c:1628
Code: 89 fa 48 c1 ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0 7f 04 84 c0 75 6c 44 0f b6 b5 7c 0d 00 00 e9 16 ff ff ff e8 5a 7b 58 00 <0f> 0b e9 87 fd ff ff e8 5e 72 a3 00 e9 b5 fc ff ff e8 54 72 a3 00
RSP: 0018:ffffc90003017b10 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000080000800 RCX: 0000000000000000
RDX: ffff88801d230100 RSI: ffffffff811fe996 RDI: 0000000000000003
RBP: ffff888023464040 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff811fe71b R11: 0000000000000000 R12: 0000000000000001
R13: 00000000fffffffd R14: 0000000000000000 R15: dffffc0000000000
FS:  0000555555918300(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000235cc000 CR4: 0000000000152ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_inject_exception arch/x86/kvm/x86.c:9339 [inline]
 inject_pending_event+0x592/0x1480 arch/x86/kvm/x86.c:9350
 vcpu_enter_guest arch/x86/kvm/x86.c:10072 [inline]
 vcpu_run arch/x86/kvm/x86.c:10360 [inline]
 kvm_arch_vcpu_ioctl_run+0xff7/0x6680 arch/x86/kvm/x86.c:10561
 kvm_vcpu_ioctl+0x570/0xf30 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3943
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7effdacd6f49
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc580ec718 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007effdacd6f49
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007effdac9aa40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007effdac9aad0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
