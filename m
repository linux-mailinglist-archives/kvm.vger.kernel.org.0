Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0459D78B3FE
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 17:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjH1PH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 11:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjH1PHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 11:07:32 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A100F0;
        Mon, 28 Aug 2023 08:07:29 -0700 (PDT)
Received: from [192.168.100.7] (unknown [39.34.186.61])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id AAAC366003AF;
        Mon, 28 Aug 2023 16:07:23 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1693235248;
        bh=sr9SjVvaxxnuxLehHItSO7my0Y1+sMDPHbIQTOSR8vA=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=BpI/MBIrLv8briDSnCEbNdRGggJWxzTSLJYgwYb97A2RHl87D6CDyXVsJzrid2PkY
         rimEGAwMgCfAuCT3GOVNmwo7NtXOsWcKMkdmKi7PE6eN3seTc5hSPqUriL182O3vWT
         EqEW+m4pqQhXKGSaG3h31PE7LmYM1XInHEpgNec+M+robCFkGm10PIBQkWeX125tJn
         tkJhcf22RW3UNoPxg1mLM9JiVXx9+/hS2z7P/LSK3Oa7QoFmTfFLLmoduzJbwoaR0R
         hgLeZFwA4KP8cw7dQbB022kXj9HwV76puRDlnzEd34BLXDcP497h4GxxpFJBK93U5O
         YiY5J6VLrgU5g==
Message-ID: <edeca3d3-bf4c-4c5d-8879-dca5173b6659@collabora.com>
Date:   Mon, 28 Aug 2023 20:07:16 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Subject: Re: [v5.15] WARNING in kvm_arch_vcpu_ioctl_run
To:     syzbot <syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com>,
        syzkaller-lts-bugs@googlegroups.com,
        syzbot <syzbot+b000b7d21f93fc69de32@syzkaller.appspotmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
References: <00000000000099cf1805faee14d7@google.com>
Content-Language: en-US
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <00000000000099cf1805faee14d7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/23 1:28 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit: 8a7f2a5c5aa1 Linux 5.15.110
This same warning has also been found on  6.1.21.

> git tree: linux-5.15.y
> console output: https://syzkaller.appspot.com/x/log.txt?x=15f12318280000
> kernel config: https://syzkaller.appspot.com/x/.config?x=ba8d5c9d6c5289f
> dashboard link: https://syzkaller.appspot.com/bug?extid=412c9ae97b4338c5187e
> compiler: Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=10e13c84280000
> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=149d9470280000
I've tried all the C and syz reproducers. I've also tried syz-crash which
launched multiple instances of VMs and ran syz reproducer. But the issue
didn't get reproduced.

I don't have kvm skills. Can someone have a look at the the warning
(probably by static analysis)?

> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/fc04f54c047f/disk-8a7f2a5c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6b4ba4cb1191/vmlinux-8a7f2a5c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d927dc3f9670/bzImage-8a7f2a5c.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 3502 at arch/x86/kvm/x86.c:10310 kvm_arch_vcpu_ioctl_run+0x1d63/0x1f80
> Modules linked in:
> CPU: 1 PID: 3502 Comm: syz-executor306 Not tainted 5.15.110-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
> RIP: 0010:kvm_arch_vcpu_ioctl_run+0x1d63/0x1f80 arch/x86/kvm/x86.c:10310
> Code: df e8 71 ac b9 00 e9 e5 fa ff ff 89 d9 80 e1 07 38 c1 0f 8c 26 fb ff ff 48 89 df e8 57 ac b9 00 e9 19 fb ff ff e8 4d 52 70 00 <0f> 0b e9 e0 fb ff ff 89 d9 80 e1 07 38 c1 0f 8c 63 fb ff ff 48 89
> RSP: 0018:ffffc90002bcfc60 EFLAGS: 00010293
> RAX: ffffffff810f8c33 RBX: 0000000000000000 RCX: ffff888012bc1d00
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: dffffc0000000000 R08: ffffffff8116a882 R09: fffffbfff1bc744e
> R10: 0000000000000000 R11: dffffc0000000001 R12: ffff888012bc1d00
> R13: ffff888077580000 R14: ffff8880775800f0 R15: ffff88801e2a9000
> FS: 000055555696f300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fafc4b53130 CR3: 000000007c8ce000 CR4: 00000000003526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> kvm_vcpu_ioctl+0x7f0/0xcf0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3863
> vfs_ioctl fs/ioctl.c:51 [inline]
> __do_sys_ioctl fs/ioctl.c:874 [inline]
> __se_sys_ioctl+0xf1/0x160 fs/ioctl.c:860
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x61/0xcb
> RIP: 0033:0x7fafc4ae1ed9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd3bb98a48 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 000000000000cdf3 RCX: 00007fafc4ae1ed9
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 00007ffd3bb98be8 R09: 00007ffd3bb98be8
> R10: 00007ffd3bb98be8 R11: 0000000000000246 R12: 00007ffd3bb98a5c
> R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
> </TASK>
> 
> 
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 

-- 
BR,
Muhammad Usama Anjum
