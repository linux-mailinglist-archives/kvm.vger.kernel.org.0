Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A979777C68C
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 05:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbjHODzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 23:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbjHODxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 23:53:11 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7E3BC;
        Mon, 14 Aug 2023 20:53:05 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4fe7e1ef45dso7994530e87.1;
        Mon, 14 Aug 2023 20:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692071583; x=1692676383;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vJ5e2Jmry9UpiO8uRUtDPMDVTbABCY1puQ0VmQCvbl0=;
        b=OJ5QApd0CAXoDjLadFjjmuPwx8+fZY0UexKEMOqOH4yKMSbFbzsrbXVepPmQe1prRQ
         LF1Bu8hknslDqsmGYCpUgqNCym7X+/C7b2M9Pc1DgtQgfn5ujbNghQ3wYYtzcLplRQfm
         8QHrJTBDcZEMw1FV/3U/SAYelliUxI3RRHvNRY9YoNtb1F11UqnG5psxcV3otoZv1H82
         RAf00kH2b6EPZSZsmkN3L+urNciXg/Q/0eKuRet4SzHCNb7NEmNdTbhygF92+NWrLrgB
         Eyt0JES/Evsy2Y1DN8BurXBgSnotnuBY5ZTDyuw5OE+2Idp1LkJDfy88kM01j1R5wNe6
         T2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692071583; x=1692676383;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vJ5e2Jmry9UpiO8uRUtDPMDVTbABCY1puQ0VmQCvbl0=;
        b=HiT2up2kirQHIk2ydRHnRZ7L5DK2zr7hRMOmDt09r0Ryo3Kii4dq9qL1osqIuahhio
         zE+AD2HEwy/cHgy5ukNyKYXce9QE7TvliFWGA9GZj6AKtr0rzK9GrREV60p4WDc/MmzV
         OP3kPHrvxkFbcYoV+HfFwtq+0aTuMUraF7Jaqy/zFXV0+5MNjpviKWkWlpDdke/6La+z
         MdFHuG09RNJUeQ65D5ZQIvXTZY+qA1SuvvjZOnT26SCu3HmLolPJ2fv1u10BfGkBjy47
         ANJQTS2OYm85cyf9MbiKxjn4jIUavWxKsGNLJOy11Krlmmh4YaOf4cpOpAREKWZuCc9R
         uNDg==
X-Gm-Message-State: AOJu0YzctuRckz1eIUQxxnLORSHXF8+lu6Fj1+XtJDG4fcHhYRrtns2z
        S538xpr/3xtleTL95c66lIcwzFJwpl82S4Oq6mJdzqixVGMUMWiists=
X-Google-Smtp-Source: AGHT+IGU+FJw1H1zuB+qJSfWK+rj8sA16TbcHTfL8bNyYuYszaoW5dWb0Y5jzVgkW5z6Afcl0xY28miDe5sPkx7It34=
X-Received: by 2002:a05:6512:33d1:b0:4e0:a426:6ddc with SMTP id
 d17-20020a05651233d100b004e0a4266ddcmr9714070lfg.0.1692071582510; Mon, 14 Aug
 2023 20:53:02 -0700 (PDT)
MIME-Version: 1.0
From:   Yikebaer Aizezi <yikebaer61@gmail.com>
Date:   Tue, 15 Aug 2023 11:52:50 +0800
Message-ID: <CALcu4rY9qc-bhYnpNYwyVtcn3-6+YQ=Z4GUSXuP1vFtQtiY65A@mail.gmail.com>
Subject: WARNING in kvm_vcpu_reset
To:     linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        bp@alien8.de, hpa@zytor.com, kvm@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

When using Healer to fuzz the Latest Linux-6.5-rc6,  the following crash
was triggered.

HEAD commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421 (tag: v6.5-rc6=EF=BC=
=89
git tree: upstream

console output:
https://drive.google.com/file/d/1Ccnfmov-_93xUAySMZSzVcoh48Aca3l7/view?usp=
=3Ddrive_link
kernel config:https://drive.google.com/file/d/17hBWtOF3u_m7QNnAglE4GRL-sjI0=
YfQH/view?usp=3Ddrive_link
C reproducer:https://drive.google.com/file/d/1Qji71sIPoWM1_tjYFN59y-TNHXNtS=
Y8K/view?usp=3Ddrive_link
Syzlang reproducer:
https://drive.google.com/file/d/1_jSavSvc5zHbe8lW8Oo6OXK4Aj5ijcec/view?usp=
=3Ddrive_link


If you fix this issue, please add the following tag to the commit:
Reported-by: Yikebaer Aizezi <yikebaer61@gmail.com>

--------------------------------------------------------------cut
here-----------------------------------------------------------------------=
-----------

WARNING: CPU: 0 PID: 20692 at arch/x86/kvm/x86.c:12023
kvm_vcpu_reset+0x1d6/0x1410 arch/x86/kvm/x86.c:12023
Modules linked in:
CPU: 0 PID: 20692 Comm: syz-executor Not tainted 6.5.0-rc6 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:kvm_vcpu_reset+0x1d6/0x1410 arch/x86/kvm/x86.c:12023
Code: 8e 7a 11 00 00 8b 9d 98 02 00 00 31 ff 41 89 df 41 83 e7 01 44
89 fe e8 f8 6e 6f 00 45 84 ff 0f 84 a8 09 00 00 e8 ea 72 6f 00 <0f> 0b
e8 e3 72 6f 00 4c 89 e2 48 b8 00 00 00 00 00 fc ff df 48 c1
RSP: 0018:ffffc9000342fa10 EFLAGS: 00010216
RAX: 00000000000037c6 RBX: 0000000000000002 RCX: ffffc90002b59000
RDX: 0000000000040000 RSI: ffffffff8110f806 RDI: 0000000000000005
RBP: ffff8881130dc3b0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff8881130dc648
R13: 0000000000000001 R14: ffff8881130dc5f8 R15: 0000000000000000
FS:  00007f6d890e4640(0000) GS:ffff888063c00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000112b8d000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 shutdown_interception+0x66/0xb0 arch/x86/kvm/svm/svm.c:2148
 svm_invoke_exit_handler+0x79/0x3e0 arch/x86/kvm/svm/svm.c:3390
 svm_handle_exit+0x3a8/0x7c0 arch/x86/kvm/svm/svm.c:3450
 vcpu_enter_guest arch/x86/kvm/x86.c:10868 [inline]
 vcpu_run+0x2b98/0x4df0 arch/x86/kvm/x86.c:10971
 kvm_arch_vcpu_ioctl_run+0x4db/0x1a80 arch/x86/kvm/x86.c:11192
 kvm_vcpu_ioctl+0x56c/0xf40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4124
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x199/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6d87e9442d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6d890e4048 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6d87fcc0a0 RCX: 00007f6d87e9442d
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
RBP: 00007f6d87f014b8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6d87f00b51
R13: 000000000000000b R14: 00007f6d87fcc0a0 R15: 00007f6d890c4000
 </TASK>

Modules linked in:
CPU: 0 PID: 20692 Comm: syz-executor Not tainted 6.5.0-rc6 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:kvm_vcpu_reset+0x1d6/0x1410 arch/x86/kvm/x86.c:12023
Code: 8e 7a 11 00 00 8b 9d 98 02 00 00 31 ff 41 89 df 41 83 e7 01 44
89 fe e8 f8 6e 6f 00 45 84 ff 0f 84 a8 09 00 00 e8 ea 72 6f 00 <0f> 0b
e8 e3 72 6f 00 4c 89 e2 48 b8 00 00 00 00 00 fc ff df 48 c1
RSP: 0018:ffffc9000342fa10 EFLAGS: 00010216
RAX: 00000000000037c6 RBX: 0000000000000002 RCX: ffffc90002b59000
RDX: 0000000000040000 RSI: ffffffff8110f806 RDI: 0000000000000005
RBP: ffff8881130dc3b0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff8881130dc648
R13: 0000000000000001 R14: ffff8881130dc5f8 R15: 0000000000000000
FS:  00007f6d890e4640(0000) GS:ffff888063c00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000112b8d000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 shutdown_interception+0x66/0xb0 arch/x86/kvm/svm/svm.c:2148
 svm_invoke_exit_handler+0x79/0x3e0 arch/x86/kvm/svm/svm.c:3390
 svm_handle_exit+0x3a8/0x7c0 arch/x86/kvm/svm/svm.c:3450
 vcpu_enter_guest arch/x86/kvm/x86.c:10868 [inline]
 vcpu_run+0x2b98/0x4df0 arch/x86/kvm/x86.c:10971
 kvm_arch_vcpu_ioctl_run+0x4db/0x1a80 arch/x86/kvm/x86.c:11192
 kvm_vcpu_ioctl+0x56c/0xf40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4124
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x199/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6d87e9442d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6d890e4048 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6d87fcc0a0 RCX: 00007f6d87e9442d
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
RBP: 00007f6d87f014b8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6d87f00b51
R13: 000000000000000b R14: 00007f6d87fcc0a0 R15: 00007f6d890c4000
 </TASK>
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 0 PID: 20692 Comm: syz-executor Not tainted 6.5.0-rc6 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd5/0x150 lib/dump_stack.c:106
 panic+0x67e/0x730 kernel/panic.c:340
 check_panic_on_warn+0xad/0xb0 kernel/panic.c:236
 __warn+0xee/0x390 kernel/panic.c:673
 __report_bug lib/bug.c:199 [inline]
 report_bug+0x2d9/0x500 lib/bug.c:219
 handle_bug+0x3c/0x70 arch/x86/kernel/traps.c:326
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:347
 asm_exc_invalid_op+0x16/0x20 arch/x86/include/asm/idtentry.h:568
RIP: 0010:kvm_vcpu_reset+0x1d6/0x1410 arch/x86/kvm/x86.c:12023
Code: 8e 7a 11 00 00 8b 9d 98 02 00 00 31 ff 41 89 df 41 83 e7 01 44
89 fe e8 f8 6e 6f 00 45 84 ff 0f 84 a8 09 00 00 e8 ea 72 6f 00 <0f> 0b
e8 e3 72 6f 00 4c 89 e2 48 b8 00 00 00 00 00 fc ff df 48 c1
RSP: 0018:ffffc9000342fa10 EFLAGS: 00010216
RAX: 00000000000037c6 RBX: 0000000000000002 RCX: ffffc90002b59000
RDX: 0000000000040000 RSI: ffffffff8110f806 RDI: 0000000000000005
RBP: ffff8881130dc3b0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff8881130dc648
R13: 0000000000000001 R14: ffff8881130dc5f8 R15: 0000000000000000
 shutdown_interception+0x66/0xb0 arch/x86/kvm/svm/svm.c:2148
 svm_invoke_exit_handler+0x79/0x3e0 arch/x86/kvm/svm/svm.c:3390
 svm_handle_exit+0x3a8/0x7c0 arch/x86/kvm/svm/svm.c:3450
 vcpu_enter_guest arch/x86/kvm/x86.c:10868 [inline]
 vcpu_run+0x2b98/0x4df0 arch/x86/kvm/x86.c:10971
 kvm_arch_vcpu_ioctl_run+0x4db/0x1a80 arch/x86/kvm/x86.c:11192
 kvm_vcpu_ioctl+0x56c/0xf40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4124
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x199/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6d87e9442d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6d890e4048 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6d87fcc0a0 RCX: 00007f6d87e9442d
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
RBP: 00007f6d87f014b8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6d87f00b51
R13: 000000000000000b R14: 00007f6d87fcc0a0 R15: 00007f6d890c4000
 </TASK>
Dumping ftrace buffer:
   (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 1 seconds..
