Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9F46BD8AD
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 20:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCPTNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 15:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjCPTNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 15:13:05 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446D937731
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 12:12:58 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id u23-20020a6be917000000b007532ab65c70so1259149iof.12
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 12:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678993977;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U7xPE9eHjZFiRatnko2u5b3DgPyVKb9Z04I4THxWcHA=;
        b=YGrMsRPMZNg3LEJfT3iF6Giq1CDHIDF8Yc2bTOBOHwtzGBoxKyiJ26kfluk6dxvyDj
         ea+7uorz3YUcrNx5z7qebiijsOKbgcE1e1qXjIcaFoe2r9+xlhEV23JEeyAVR/3qbhmd
         5uRfQrRJ6EjeJUTk8qDqlVFmqs5+clv5eJjia0RBOGMcJJnwZgZPF4sUg34balKMF4SR
         9h2oN6dlXeXWhAUAlB3O8rkgUfM23MTBslDXfNj+BB20V2VbWqechlDWQ97Hifykfg7s
         zo1jTsuooQlf18iJRl7cg+rybwrcyG3to53V6AGSyFuTN/v951D5r3vfrKGY3oMpRpCM
         hULA==
X-Gm-Message-State: AO0yUKVGYOW7IDP6eawJrlhbiXN2UkBcksZu3gbqpQkTm8O21gbFgKiI
        VJgiOCLayb5MJsiGDNplWLOyZ/BamjI2SVQ342Wcw7D7ZR2z
X-Google-Smtp-Source: AK7set8iENLiJJcuU7KGbv5SPcslX1Xx8ih7ZxAYfEeQTB2zuyrWs36a2NISGBtPQ+8fuCG/DGR7CBdQCLGobTFBZ47UUIQ60c/S
MIME-Version: 1.0
X-Received: by 2002:a5d:9a96:0:b0:745:c41a:8f0f with SMTP id
 c22-20020a5d9a96000000b00745c41a8f0fmr69348iom.2.1678993977437; Thu, 16 Mar
 2023 12:12:57 -0700 (PDT)
Date:   Thu, 16 Mar 2023 12:12:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009af47405f7093fc6@google.com>
Subject: [syzbot] [kvm?] WARNING in kvm_arch_vcpu_ioctl_run (4)
From:   syzbot <syzbot+8accb43ddc6bd1f5713a@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ee3f96b16468 Merge tag 'nfsd-6.3-1' of git://git.kernel.or..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11622f64c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cab35c936731a347
dashboard link: https://syzkaller.appspot.com/bug?extid=8accb43ddc6bd1f5713a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bd61acc80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17402eb0c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a7ac3e540d6d/disk-ee3f96b1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/604b5042d73d/vmlinux-ee3f96b1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5a6d400b42b5/bzImage-ee3f96b1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8accb43ddc6bd1f5713a@syzkaller.appspotmail.com

kvm_intel: KVM_SET_TSS_ADDR needs to be called before running vCPU
kvm_intel: set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5082 at arch/x86/kvm/x86.c:11060 kvm_arch_vcpu_ioctl_run+0x2464/0x2af0 arch/x86/kvm/x86.c:11060
Modules linked in:
CPU: 0 PID: 5082 Comm: syz-executor178 Not tainted 6.2.0-syzkaller-13115-gee3f96b16468 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
RIP: 0010:kvm_arch_vcpu_ioctl_run+0x2464/0x2af0 arch/x86/kvm/x86.c:11060
Code: 74 c3 00 e9 2f de ff ff 48 c7 c7 80 45 78 8e e8 02 74 c3 00 e9 a9 dc ff ff e8 38 f8 71 00 0f 0b e9 6c e0 ff ff e8 2c f8 71 00 <0f> 0b e9 a4 e0 ff ff e8 20 f8 71 00 be 08 00 00 00 65 48 8b 1c 25
RSP: 0018:ffffc90003b4fcb0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8880236e0000 RSI: ffffffff81130274 RDI: 0000000000000005
RBP: ffff888021798000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90003bfac90 R14: ffff88802319a8c0 R15: ffff8880217982ec
FS:  000055555600f300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000073d95000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_vcpu_ioctl+0x574/0xfe0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4099
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7ff9dc1b2289
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcad58a378 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff9dc1b2289
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007ff9dc175ce0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff9dc175d70
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
