Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2288480D18
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 21:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbhL1Uxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 15:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbhL1Uxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 15:53:53 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7828CC061574
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 12:53:53 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id v19so14400217plo.7
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 12:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rtheOD954UZ4UHCXkqeufnOIwdZjJ8l/GyWaTKzepqc=;
        b=qvmQZgDTRL+6+kkvT7+kghe6lbOhac4fIgFJ6G46s2mFi0mCaLcxV+UXEt/SIoXnY3
         iMaBz/GroXquQardt3zE0P900z5vDxOqZw5XMGPYvGr4xFBJ4MatgCeaOBDoHlJ446rb
         1FINfb8XUdz2lgTviBBoHs7XdAfQjZVKtofuus/AGm5NAqMX+AMoA9vNp0wAlv5TyiL/
         u+a60xuUsovfoEnOAVHOE15CAV6pCwRP/o7LC6f7UXB7MBgmBHMcssvq0tWl4QXuKzx+
         lXHTNeNeORoWceKX9PmwZo0fYzCDG7DlnV8A8dCmS+RM7Raqzovk6oo9QuhEgnr8UmRx
         dyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rtheOD954UZ4UHCXkqeufnOIwdZjJ8l/GyWaTKzepqc=;
        b=cxfoMiJqqbKmtDRVIWEWNygtmmJQQ6P/Ec5rnvBhR+pIym8jkmhh9zkRX+jFBSuN2D
         Kd+I1hPzuX16XWCxlteMj3rgfC63TiPv3Qwz8NZaTKTWPatUISzjGa7seBflpyhaSorP
         dYB9zd7y6t897SvbSZ/9eXHthHktby2ez4sIrLli3YVxTIHVdthSo1/L51AkT71m7ecJ
         a6E9KM93InzwavTEHS/6i/xOhOc9UF03sifNOWYAv0SAq/XbOv/8YUtuIhxgkf9H3fUq
         Wp7jEhTVmaYHXh45/WSGgQodf4HHXqWQTeqGjbATokSam72FzC67Tu6IHTTryVrv4rm6
         xyOQ==
X-Gm-Message-State: AOAM5301Ad1mGAf6+oVgGusKmndt71DiLT9CAOGYoEk0ZOeyd8EXyg9D
        Z6XEFV6KuQHZe1Ux9F1guaLSIQ==
X-Google-Smtp-Source: ABdhPJwGZ2GNhrhQf0tiTMu3HKqGnEQOlhG373uOM20jR2RCWsJnMAFQRcUm5imzOzNgpgsmVghZsA==
X-Received: by 2002:a17:903:191:b0:148:b9fc:c42b with SMTP id z17-20020a170903019100b00148b9fcc42bmr23367215plg.63.1640724832747;
        Tue, 28 Dec 2021 12:53:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j23sm17908259pgn.40.2021.12.28.12.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 12:53:52 -0800 (PST)
Date:   Tue, 28 Dec 2021 20:53:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+82112403ace4cbd780d8@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Subject: Re: [syzbot] WARNING in vmx_queue_exception
Message-ID: <Yct5XTxo/E10r5hW@google.com>
References: <0000000000008a5baf05d3fb593e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000008a5baf05d3fb593e@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 25, 2021, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6e0567b73052 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=128c1adbb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6104739ac5f067ea
> dashboard link: https://syzkaller.appspot.com/bug?extid=82112403ace4cbd780d8
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+82112403ace4cbd780d8@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 28019 at arch/x86/kvm/vmx/vmx.c:1616 vmx_queue_exception+0x2f2/0x440 arch/x86/kvm/vmx/vmx.c:1616
> Modules linked in:
> CPU: 1 PID: 28019 Comm: syz-executor.5 Not tainted 5.16.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:vmx_queue_exception+0x2f2/0x440 arch/x86/kvm/vmx/vmx.c:1616
> Code: 41 5e 41 5f 5d e9 de b3 fd ff e8 79 22 60 00 eb 05 e8 72 22 60 00 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 5e 22 60 00 <0f> 0b e9 78 fe ff ff 89 f9 80 e1 07 38 c1 0f 8c 35 fd ff ff e8 15
> RSP: 0018:ffffc90010587450 EFLAGS: 00010287
> RAX: ffffffff812469b2 RBX: 0000000000000001 RCX: 0000000000040000
> RDX: ffffc900051ea000 RSI: 0000000000001923 RDI: 0000000000001924
> RBP: 0000000000000000 R08: ffffffff81246824 R09: ffffed100645904d
> R10: ffffed100645904d R11: 0000000000000000 R12: ffff8880322c8000
> R13: dffffc0000000000 R14: 0000000000000006 R15: 0000000080000006
> FS:  00007fe6788f8700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4f4bcd8058 CR3: 0000000087d66000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  kvm_inject_exception arch/x86/kvm/x86.c:9071 [inline]
>  inject_pending_event arch/x86/kvm/x86.c:9145 [inline]
>  vcpu_enter_guest+0x19aa/0x9df0 arch/x86/kvm/x86.c:9801
>  vcpu_run+0x4d3/0xe50 arch/x86/kvm/x86.c:10055
>  kvm_arch_vcpu_ioctl_run+0x494/0xb20 arch/x86/kvm/x86.c:10250
>  kvm_vcpu_ioctl+0x894/0xe20 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3727
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:874 [inline]
>  __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:860
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae

This is all but guaranteed to be "fixed" by commit cd0e615c49e5 ("KVM: nVMX:
Synthesize TRIPLE_FAULT for L2 if emulation is required").  The GCE instance has
unrestricted guest enabled, which means the only way for emulation_required to be
set is by disabling it in vmcs12.  That's also supported by the fact that this
just recently showed up, as commit c8607e4a086f ("KVM: x86: nVMX: don't fail
nested VM entry on invalid guest state if !from_vmentry") likely allowed syzkaller
to get emulation_required set while L2 is active.

But, "fixed" is in quotes because is that only covers the nested case, there are
a multitude of ways that userspace can trigger the WARN when running non-nested
with kvm_intel.unrestricted_guest=0.  The easiest "fix" would be to simply delete
the WARN.  The downside is that instead of getting a WARN or explicit error, the
vCPU will go into the weeds if userspace or KVM screws up.

The alternative is to add a pre-check in KVM_RUN to detect userspace abuse/bugs,
which would allow KVM to keep the WARN to detect KVM bugs.  A check in KVM_RUN is
necessary because KVM can't force specific ordering between KVM_SET_VCPU_EVENTS
and KVM_SET_SREGS, e.g. clearing exception.pending in KVM_SET_SREGS doesn't prevent
userspace from setting it in KVM_SET_VCPU_EVENTS, and disallowing KVM_SET_VCPU_EVENTS
with emulation_required would prevent userspace from queuing an exception and then
stuffing sregs.

I'll send a patch and test for the clean fix, it's not really gross, just annoying
that unrestricted_guest=0 requires so much dedicated handling :-/
