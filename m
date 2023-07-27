Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF2C764967
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjG0HyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbjG0Hx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:53:57 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E6B30F9;
        Thu, 27 Jul 2023 00:49:18 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2b9aa1d3029so9045151fa.2;
        Thu, 27 Jul 2023 00:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690444156; x=1691048956;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4whf+byTbm4cJNX65zR9TvBd0HghhsB3DRH+MFYWbS0=;
        b=sx3fJjrrVeO0aZTsM526q8sE/tRtBxRHNAMyNvvWHCxuGKpQ8KLIywiuVzP8J7Frqe
         g4DzDMhIoM4vrDo+WGPct0+icon7/E6t4JYtdBOzcqujkTbX5gvVI8dd9cX2ZW52i5k0
         uQjtW+UKxZdnnXQaoypCfrvdZJeDHRWnYvK0RqMlzS0Z7GHHYTTc1xDEQ5FCPaP/Zn9t
         udBWGlpBoSnWXJnaiZVsAauHxLnO7BDvO72eT6ROB4k7UnoV9kbqO0FmmKBVcGi3gLpV
         eLaEuEqRKdn7wED/egJ7UZcT/X8m4fu0GEUmh21tOSFyn6MdrclLTlKC14VffLkP8D0z
         GEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690444156; x=1691048956;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4whf+byTbm4cJNX65zR9TvBd0HghhsB3DRH+MFYWbS0=;
        b=FbyYkovOC26OBny3qY6ZktpLGwxNycLNtztXv/U2OZQNxdSZHZRReVvck2nyUQWRYo
         sURDjw5i3FBpAjS2IhZyuw4poaIRds1hIpEcCeluj0Odnt2Vy+sV/I2MVcxjtA37Z0TX
         7DoTS0huA+qxoMhQMtMcG75gN9QFkpPf1QJknkFz0IcoFH8hmvXC98R9Yb/00/ArET00
         SLOa9walYt3Wn6XI7ok4IAu3bNgxFYzTliD/PeecKKFxgGbMKakSU92fqmnEsxe+hJv6
         AA2fnHXTkT/nWzHX8748x+WsPzfBXFdMvEwjC1cAvTUiPvEaOi7Bq3QA32UqcusejZ+R
         zSTA==
X-Gm-Message-State: ABy/qLZtrqLDrVTp0FoY+kBotsZ5yDNbpewyMOonE86N8gZ4og3EFw3W
        Y91Xzy3WvhoeCywitkA1Vm7gxDeph50Sjpn8heo=
X-Google-Smtp-Source: APBJJlEIn4SowAyXjgQOZPk+8jLV6yNmp/WB+PLHg9ZZ2IH6/t1VT90K8yXFBp90n4LmZksgAlcLO5t6L20s5Bx7IAA=
X-Received: by 2002:a2e:9ed4:0:b0:2b9:aa4d:372c with SMTP id
 h20-20020a2e9ed4000000b002b9aa4d372cmr950250ljk.16.1690444155880; Thu, 27 Jul
 2023 00:49:15 -0700 (PDT)
MIME-Version: 1.0
From:   Yikebaer Aizezi <yikebaer61@gmail.com>
Date:   Thu, 27 Jul 2023 15:49:03 +0800
Message-ID: <CALcu4raaDCUr1O+UGASjaPa+2jyoWkkCo287GSJPBGgUVA4L0g@mail.gmail.com>
Subject: 
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jarkko@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: fdf0eaf11452d72945af31804e2a1048ee1b574c (tag: v6.5-rc2)

git tree: upstream

console output:
https://drive.google.com/file/d/1FiemC_AWRT-6EGscpQJZNzYhXZty6BVr/view?usp=drive_link
kernel config: https://drive.google.com/file/d/1fgPLKOw7QbKzhK6ya5KUyKyFhumQgunw/view?usp=drive_link
C reproducer: https://drive.google.com/file/d/1SiLpYTZ7Du39ubgf1k1BIPlu9ZvMjiWZ/view?usp=drive_link
Syzlang reproducer:
https://drive.google.com/file/d/1eWSmwvNGOlZNU-0-xsKhUgZ4WG2VLZL5/view?usp=drive_link
Similar report:
https://groups.google.com/g/syzkaller-bugs/c/C2ud-S1Thh0/m/z4iI7l_dAgAJ

If you fix this issue, please add the following tag to the commit:
Reported-by: Yikebaer Aizezi <yikebaer61@gmail.com>

kvm: vcpu 129: requested lapic timer restore with starting count
register 0x390=4241646265 (4241646265 ns) > initial count (296265111
ns). Using initial count to start timer.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1977 at arch/x86/kvm/x86.c:11098
kvm_arch_vcpu_ioctl_run+0x152f/0x1830 arch/x86/kvm/x86.c:11098
Modules linked in:
CPU: 0 PID: 1977 Comm: syz-executor Not tainted 6.5.0-rc2 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:kvm_arch_vcpu_ioctl_run+0x152f/0x1830 arch/x86/kvm/x86.c:11098
Code: fd ff ff e8 83 ca 67 00 44 89 ee 48 c7 c7 80 8e 42 89 c6 05 e3
40 1e 0c 01 e8 2d 22 33 00 0f 0b e9 ed fc ff ff e8 61 ca 67 00 <0f> 0b
e9 ff fb ff ff e8 55 ca 67 00 80 3d c0 40 1e 0c 00 0f 85 19
RSP: 0018:ffffc900072dfcd8 EFLAGS: 00010212
RAX: 00000000000006a9 RBX: ffff88801852c000 RCX: ffffc90002bd9000
RDX: 0000000000040000 RSI: ffffffff81114ddf RDI: ffff88810e5d0880
RBP: ffff888018995180 R08: 0000000000000000 R09: fffffbfff1f4f5b0
R10: ffffffff8fa7ad87 R11: 0000000000000001 R12: ffff8880189951ac
R13: 0000000000000000 R14: ffff8880189959a8 R15: ffff888018995268
FS:  00007feb64c14640(0000) GS:ffff888063e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000002a8 CR3: 0000000114888000 CR4: 0000000000752ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 kvm_vcpu_ioctl+0x4de/0xcc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x173/0x1e0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x47959d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feb64c14068 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 000000000047959d
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000008
RBP: 000000000059c0a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 000000000000000b R14: 0000000000437250 R15: 00007feb64bf4000
 </TASK>

Modules linked in:
CPU: 0 PID: 1977 Comm: syz-executor Not tainted 6.5.0-rc2 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:kvm_arch_vcpu_ioctl_run+0x152f/0x1830 arch/x86/kvm/x86.c:11098
Code: fd ff ff e8 83 ca 67 00 44 89 ee 48 c7 c7 80 8e 42 89 c6 05 e3
40 1e 0c 01 e8 2d 22 33 00 0f 0b e9 ed fc ff ff e8 61 ca 67 00 <0f> 0b
e9 ff fb ff ff e8 55 ca 67 00 80 3d c0 40 1e 0c 00 0f 85 19
RSP: 0018:ffffc900072dfcd8 EFLAGS: 00010212
RAX: 00000000000006a9 RBX: ffff88801852c000 RCX: ffffc90002bd9000
RDX: 0000000000040000 RSI: ffffffff81114ddf RDI: ffff88810e5d0880
RBP: ffff888018995180 R08: 0000000000000000 R09: fffffbfff1f4f5b0
R10: ffffffff8fa7ad87 R11: 0000000000000001 R12: ffff8880189951ac
R13: 0000000000000000 R14: ffff8880189959a8 R15: ffff888018995268
FS:  00007feb64c14640(0000) GS:ffff888063e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000002a8 CR3: 0000000114888000 CR4: 0000000000752ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 kvm_vcpu_ioctl+0x4de/0xcc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x173/0x1e0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x47959d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feb64c14068 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 000000000047959d
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000008
RBP: 000000000059c0a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 000000000000000b R14: 0000000000437250 R15: 00007feb64bf4000
 </TASK>
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 0 PID: 1977 Comm: syz-executor Not tainted 6.5.0-rc2 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x92/0xf0 lib/dump_stack.c:106
 panic+0x570/0x620 kernel/panic.c:340
 check_panic_on_warn+0x8e/0x90 kernel/panic.c:236
 __warn+0xee/0x340 kernel/panic.c:673
 __report_bug lib/bug.c:199 [inline]
 report_bug+0x25d/0x460 lib/bug.c:219
 handle_bug+0x3c/0x70 arch/x86/kernel/traps.c:324
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:345
 asm_exc_invalid_op+0x16/0x20 arch/x86/include/asm/idtentry.h:568
RIP: 0010:kvm_arch_vcpu_ioctl_run+0x152f/0x1830 arch/x86/kvm/x86.c:11098
Code: fd ff ff e8 83 ca 67 00 44 89 ee 48 c7 c7 80 8e 42 89 c6 05 e3
40 1e 0c 01 e8 2d 22 33 00 0f 0b e9 ed fc ff ff e8 61 ca 67 00 <0f> 0b
e9 ff fb ff ff e8 55 ca 67 00 80 3d c0 40 1e 0c 00 0f 85 19
RSP: 0018:ffffc900072dfcd8 EFLAGS: 00010212
RAX: 00000000000006a9 RBX: ffff88801852c000 RCX: ffffc90002bd9000
RDX: 0000000000040000 RSI: ffffffff81114ddf RDI: ffff88810e5d0880
RBP: ffff888018995180 R08: 0000000000000000 R09: fffffbfff1f4f5b0
R10: ffffffff8fa7ad87 R11: 0000000000000001 R12: ffff8880189951ac
R13: 0000000000000000 R14: ffff8880189959a8 R15: ffff888018995268
 kvm_vcpu_ioctl+0x4de/0xcc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x173/0x1e0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x47959d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feb64c14068 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 000000000047959d
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000008
RBP: 000000000059c0a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 000000000000000b R14: 0000000000437250 R15: 00007feb64bf4000
 </TASK>
Dumping ftrace buffer:
   (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 1 seconds..
