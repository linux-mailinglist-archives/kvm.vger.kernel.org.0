Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205333FB92F
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbhH3PnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 11:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbhH3PnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 11:43:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1475C061760
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 08:42:06 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso14142077pjh.5
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 08:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lk3dNfnbxwb9IGxCTTy4Crpi7GjccN8ibRlNAb6VBdM=;
        b=wFlfNk17Q3KmvZ1biMt+GfBkmu0p3Ce6GXAJtP0tAp7ZXzvTMD67v9o9guVgixH7Tb
         kZPUqpTAbUTjWc1fMxKc+dmvF21CAOmR2Gxtv8LHZPatCtVBTdpwCMA2ZCXHnqs/xqUX
         tTEJXVaBm0mUlNmRaba58fKoHpOAJ6fWbY5Kib6MILA0w80JZOaHRg6h53c6XszD/OtU
         VGmnDjOGRwY/ysqHb4tczJ9LBLtOlrjfk32x/xlEbda0omkc8dTlAjRWe5qDwNdJRQFQ
         AQD5c95stzGawJqbjA5P1UAeiCwpISd+3W0X2GAlXEjBG3P2PJgHthk0L4MKsZu85u5K
         VTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lk3dNfnbxwb9IGxCTTy4Crpi7GjccN8ibRlNAb6VBdM=;
        b=cQDQkZZyHB3kVmBMPLAuOqvt5vXbv446b4HPkO1KcwMYc/Mpt/yBktyANv7blW2Yc9
         C6bZ21Qhr/XcGnqkgeF4QWDjGl861mf882HhzAelg109ditVCrQOHivCbrGLwlIaWbz+
         EYELSkkV/PIJ5qjXtMe7OrFN78jPMV2ISDFmx0dIL2xSioi0fSsvXGPPVf5fLeXEFduE
         Y2w6Be41gWoUVS+XHkwd1CIGsBfKY5N/p7DHBCBogbN3QsquD4Oqg8vmPUlDBAkkNgAC
         7Q/A8uh0COSMk54Tcq0ytNoqET/q25QKvIxWxeVUfRb4Yq8pkd/EGLbrlVftwoYW/ARl
         DNHA==
X-Gm-Message-State: AOAM533PTGtvLmtWyAzUuxSz4kH7KnjCwn4r2jWwWoLeU+5fn1tdVxcS
        ojT4nldLpyFyKoK8qlTJzR5H9Q==
X-Google-Smtp-Source: ABdhPJx+lopma4AgkjICQ8jnGEHv26dZVDa3YeR++YNuraXhAkglsID4yMm6PZ2D9hA1YCzx1zsGHQ==
X-Received: by 2002:a17:90a:ea08:: with SMTP id w8mr37457611pjy.218.1630338126036;
        Mon, 30 Aug 2021 08:42:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d17sm14836938pfn.110.2021.08.30.08.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 08:42:05 -0700 (PDT)
Date:   Mon, 30 Aug 2021 15:42:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] WARNING in exception_type
Message-ID: <YSz8SVKML5Ilxedn@google.com>
References: <000000000000fa5aea05cac3895f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000fa5aea05cac3895f@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 30, 2021, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3f5ad13cb012 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=156f9a4d300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=94074b5caf8665c7
> dashboard link: https://syzkaller.appspot.com/bug?extid=200c08e88ae818f849ce
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13848dfe300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=136d69e1300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
> 
> L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8469 at arch/x86/kvm/x86.c:525 exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
> Modules linked in:
> CPU: 1 PID: 8469 Comm: syz-executor531 Not tainted 5.14.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
> Code: 31 ff 45 31 ed 44 89 e6 e8 25 75 69 00 45 85 e4 41 0f 95 c5 45 01 ed e8 d6 6d 69 00 44 89 e8 5b 41 5c 41 5d c3 e8 c8 6d 69 00 <0f> 0b e8 c1 6d 69 00 41 bd 03 00 00 00 5b 44 89 e8 41 5c 41 5d c3
> RSP: 0018:ffffc90000f1f8f0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 00000000000000a2 RCX: 0000000000000000
> RDX: ffff888018461c40 RSI: ffffffff810c3b28 RDI: 0000000000000003
> RBP: ffff888020868000 R08: 000000000000001f R09: 00000000000000a2
> R10: ffffffff810c3aaa R11: 0000000000000006 R12: 00000000000000a2
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000040
> FS:  000000000179c300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fffd362aad8 CR3: 00000000182ef000 CR4: 00000000001526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  x86_emulate_instruction+0xef6/0x1460 arch/x86/kvm/x86.c:7853

LOL, syzbot configures the VM with MAXPHYADDR=1 and hilarity ensues.  The non-nested
translate_gfn() fails to prepare the #PF, and also doesn't check allow_smaller_maxphyaddr.
I should get a series out today to clean up the mess.

>  kvm_mmu_page_fault+0x2f0/0x1810 arch/x86/kvm/mmu/mmu.c:5199
>  handle_ept_misconfig+0xdf/0x3e0 arch/x86/kvm/vmx/vmx.c:5336
>  __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6021 [inline]
>  vmx_handle_exit+0x336/0x1800 arch/x86/kvm/vmx/vmx.c:6038
>  vcpu_enter_guest+0x2a1c/0x4430 arch/x86/kvm/x86.c:9712
>  vcpu_run arch/x86/kvm/x86.c:9779 [inline]
>  kvm_arch_vcpu_ioctl_run+0x47d/0x1b20 arch/x86/kvm/x86.c:10010
>  kvm_vcpu_ioctl+0x49e/0xe50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3652
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:1069 [inline]
>  __se_sys_ioctl fs/ioctl.c:1055 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x441159
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffd362c598 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 0000000000441159
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 0000000000404c50 R08: 0000000000400488 R09: 0000000000400488
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000404ce0
> R13: 0000000000000000 R14: 00000000004ae018 R15: 0000000000400488
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
