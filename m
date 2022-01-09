Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042DE4889C1
	for <lists+kvm@lfdr.de>; Sun,  9 Jan 2022 15:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235765AbiAIOFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jan 2022 09:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiAIOFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jan 2022 09:05:38 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96C1C06173F;
        Sun,  9 Jan 2022 06:05:37 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id b13so42932598edd.8;
        Sun, 09 Jan 2022 06:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=1T/jOp2YlfQdXwI5Lba833/98dqJmXanJ/UjQY3X2JY=;
        b=OM+jlDrL74+JWv85i8qlUlrOvkcy7gVikjVc7ybfxLifJwRKJP3XIj8T+YAik9PAv/
         mACjkRlvZOe3p2MKUIerDw5pcHlmJvTEpKs/+ChoT6SMGxC/ZVrRCWAlk0/smE8Sa9P5
         vDNvxvQrJzmC69sEZCMLEmQw173WXprL32hv/jeFhkb/poDiphw6YxWLQpw1bkUolfE5
         Cwa0T10KiiwGzDOlUxqwXGLaAyUky7wUgQ1dPBhofyvDev+w3cn0hGp5SYl2z+vRJqv9
         nvPWEzJWjJ86bdrNFgXESvJzipDMn2f0a1KcsUYI/HDGJtG/F8GZg8byFqlYPArkT59Z
         4F9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=1T/jOp2YlfQdXwI5Lba833/98dqJmXanJ/UjQY3X2JY=;
        b=nLzNjALf9wTfoMe2HM+Bum+Do8qavveTG0Vf+R96eJTjDC7u0yesteO5denKdLSg96
         yXT0dJrYjHcLtAevqP/f1m/5f7GWK/6hbk8w2FU7ifImQ+RvNaoFsXLSf15cHklPr3GI
         03KbYqcUVqn97geTRYYSbGlPW3s+rco1d0LJWSk/A6WTphFrW4Dz3QNCM0BsAHrwC7t9
         nStj4d9oyXPIlXJThJJH+UOOKhNHxCxj6rR9P6NbTP+Wboa8kqBysKHBxjzI09wHAt8P
         sOpQwgifLUnZKYDALvXc4f3/jp+eQYJQB0w2zWnUPuBwOMdOdXSb54wtXP00upFWu+MV
         ctFQ==
X-Gm-Message-State: AOAM531n4yPhYYJTgfKTkD6pUWdlBRAdcAgDL6JlFR8owdcmOXsFyJIZ
        8O6/kyei1Ouiu7mAOcZW+Vv1XcbQucclr1wB7/4=
X-Google-Smtp-Source: ABdhPJwiVfWz1fgtQciEOSQSLf/tNpKgIyuXTJDat67dbZujfGxLXKQ+NvmRDuO0wh7z4gjvACjlPZWzJRmv6ytR/wg=
X-Received: by 2002:a50:ec81:: with SMTP id e1mr9684850edr.37.1641737136387;
 Sun, 09 Jan 2022 06:05:36 -0800 (PST)
MIME-Version: 1.0
From:   "Sabri N. Ferreiro" <snferreiro1@gmail.com>
Date:   Sun, 9 Jan 2022 22:05:24 +0800
Message-ID: <CAKG+3NTTHD3iXgK67B4R3e+ScZ+vW5H4FdwLYy9CR5oBF44DOA@mail.gmail.com>
Subject: WARNING in kvm_mmu_uninit_tdp_mmu
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sunhao.th@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

When using Syzkaller to fuzz the Linux kernel, it triggers the following crash.

HEAD commit: a7904a538933 Linux 5.16-rc6
git tree: upstream
console output: https://pastebin.com/raw/keWCUeJ2
kernel config: https://docs.google.com/document/d/1w94kqQ4ZSIE6BW-5WIhqp4_Zh7XTPH57L5OF2Xb6O6o/view
C reproducer: https://pastebin.com/raw/kSxa6Yit
Syzlang reproducer: https://pastebin.com/raw/2RMu8p6E

If you fix this issue, please add the following tag to the commit:
Reported-by: Yuheng Shen mosesfonscqf75@gmail.com

------------[ cut here ]------------
WARNING: CPU: 5 PID: 29657 at arch/x86/kvm/mmu/tdp_mmu.c:46
kvm_mmu_uninit_tdp_mmu+0xb9/0xf0
Modules linked in:
CPU: 5 PID: 29657 Comm: syz-executor.5 Not tainted 5.16.0-rc8+ #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:kvm_mmu_uninit_tdp_mmu+0xb9/0xf0
Code: ea 03 80 3c 02 00 75 39 48 8b 83 e8 ae 00 00 48 39 c5 75 1a e8
48 86 5a 00 e8 e3 bf 46 00 5b 5d e9 3c 86 5a 00 e8 37 86 5a 00 <0f> 0b
eb b7 e8 2e 86 5a 00 0f 0b eb dd e8 a5 38 a1 00 e9 60 ff ff
RSP: 0018:ffffc90016057b30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc90015f89000 RCX: ffff888130d18000
RDX: 0000000000000000 RSI: ffff888130d18000 RDI: 0000000000000002
RBP: ffffc90015f93ef8 R08: ffffffff811cc8f9 R09: 0000000000000000
R10: 0000000000000001 R11: fffffbfff20e793a R12: ffffc90015f8b1c8
R13: 0000000000000003 R14: ffffc90015f8b1e8 R15: dffffc0000000000
FS:  00007f7f240cb700(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f76caf3498 CR3: 0000000123d22000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 kvm_arch_destroy_vm+0x42b/0x5b0
 kvm_put_kvm+0x4e9/0xbd0
 kvm_vcpu_release+0x4d/0x70
 __fput+0x286/0x9f0
 task_work_run+0xe0/0x1a0
 get_signal+0x1fb5/0x25e0
 arch_do_signal_or_restart+0x2ed/0x1c40
 exit_to_user_mode_prepare+0x192/0x2a0
 syscall_exit_to_user_mode+0x19/0x60
 do_syscall_64+0x42/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7f257dd89d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7f240cac28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: 0000000000000000 RBX: 00007f7f258fd2a0 RCX: 00007f7f257dd89d
RDX: 0000000000000000 RSI: 000000000000ae9a RDI: 0000000000000005
RBP: 00007f7f2584a00d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffdf486b75f R14: 00007f7f258fd2a0 R15: 00007f7f240cadc0
 </TASK>
