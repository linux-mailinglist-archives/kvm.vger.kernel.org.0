Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12274BE5F1
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358692AbiBUNNU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 08:13:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358709AbiBUNNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 08:13:12 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638221EEF8
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 05:12:46 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id v123-20020a6bc581000000b0063d8771a58aso9593137iof.0
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 05:12:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=MJCRQcTNaOuw0J+t9DmTL6f/nxjstKT6G2s40iYRbfI=;
        b=HUgVWd7YZ2rnt3w2jgN+96Yz+f3h8exKZ1Gd/58TkCM2DViJnAPe29nzrvdCOLR+U2
         7nvydRTO2XLVXOy9TkEAuCTH2/Jo7mTzDhW+zpWDdvUvqn47AXJyas5v09gXiktIN15T
         bUNL0tJj/OJL8vzBfhVNty8oz46NRgfHCdYvsy8LXEe/ZClrPXoTXPimVAL1ZwaUBgwL
         0axBCOiIH7fDsRBAnPoEKrV0z8B0AlBFG/7tlCC8jnC1GMMDE1gA6FLyX7D8SeGWLFaK
         VSIijj5/VQPSiuK8PEw8pg9Sr7Nx+rD6B0zxcfmx0jnacjudUp7PyfEu1dzk16qxh6zT
         KeYQ==
X-Gm-Message-State: AOAM530Lgf80b4i3ozdub6w0DOvSzd7p640JmN9XI1Tlp6BpIKbGWhM/
        knDUYXGQBOBEk9lee/2gtCdgvt19muakJcIE+ord5qTEGB7+
X-Google-Smtp-Source: ABdhPJxs6d7TUGoLF15yyTZxzDOnxXQcBCts1wy8sEkS9o9R+dFgcbnIRVimKrne0Z170U5cPwTjTMNt1OsNB4Q6uImQjrhvPEVU
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d0d:b0:2c2:1d2c:5b2d with SMTP id
 i13-20020a056e021d0d00b002c21d2c5b2dmr7354706ila.168.1645449165777; Mon, 21
 Feb 2022 05:12:45 -0800 (PST)
Date:   Mon, 21 Feb 2022 05:12:45 -0800
In-Reply-To: <20220221131236.ekihumv67fpsjsoq@sgarzare-redhat>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000005d3df05d886fd4a@google.com>
Subject: Re: [syzbot] general protection fault in vhost_iotlb_itree_first
From:   syzbot <syzbot+bbb030fc51d6f3c5d067@syzkaller.appspotmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, sgarzare@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> #syz test: https://github.com/stefano-garzarella/linux.git vsock-fix-stop

This crash does not have a reproducer. I cannot test it.

>
> On Sat, Feb 19, 2022 at 01:18:24AM -0800, syzbot wrote:
>>Hello,
>>
>>syzbot found the following issue on:
>>
>>HEAD commit:    359303076163 tty: n_tty: do not look ahead for EOL charact..
>>git tree:       upstream
>>console output: https://syzkaller.appspot.com/x/log.txt?x=16b34b54700000
>>kernel config:  https://syzkaller.appspot.com/x/.config?x=da674567f7b6043d
>>dashboard link: https://syzkaller.appspot.com/bug?extid=bbb030fc51d6f3c5d067
>>compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>>Unfortunately, I don't have any reproducer for this issue yet.
>>
>>IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>Reported-by: syzbot+bbb030fc51d6f3c5d067@syzkaller.appspotmail.com
>>
>>general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
>>KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>>CPU: 1 PID: 17981 Comm: vhost-17980 Not tainted 5.17.0-rc4-syzkaller-00052-g359303076163 #0
>>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>RIP: 0010:vhost_iotlb_itree_iter_first drivers/vhost/iotlb.c:19 [inline]
>>RIP: 0010:vhost_iotlb_itree_first+0x29/0x280 drivers/vhost/iotlb.c:169
>>Code: 00 41 57 41 56 41 55 49 89 d5 41 54 55 48 89 fd 53 48 89 f3 e8 e8 eb a0 fa 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 e8 01 00 00 4c 8b 65 00 4d 85 e4 0f 84 b3 01 00
>>RSP: 0018:ffffc90004f57ac8 EFLAGS: 00010246
>>RAX: dffffc0000000000 RBX: 30303030320a0028 RCX: ffffc900103dc000
>>RDX: 0000000000000000 RSI: ffffffff86d72738 RDI: 0000000000000000
>>RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000002
>>R10: ffffffff86d62d88 R11: 0000000000000000 R12: ffff8880260e4d68
>>R13: 303030305f3a3057 R14: dffffc0000000000 R15: 0000000000000000
>>FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>CR2: 00007f2d46121901 CR3: 000000001d652000 CR4: 00000000003506e0
>>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>Call Trace:
>> <TASK>
>> translate_desc+0x11e/0x3e0 drivers/vhost/vhost.c:2054
>> vhost_get_vq_desc+0x662/0x22c0 drivers/vhost/vhost.c:2300
>> vhost_vsock_handle_tx_kick+0x277/0xa20 drivers/vhost/vsock.c:522
>> vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
>> kthread+0x2e9/0x3a0 kernel/kthread.c:377
>> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>> </TASK>
>>Modules linked in:
>>---[ end trace 0000000000000000 ]---
>>RIP: 0010:vhost_iotlb_itree_iter_first drivers/vhost/iotlb.c:19 [inline]
>>RIP: 0010:vhost_iotlb_itree_first+0x29/0x280 drivers/vhost/iotlb.c:169
>>Code: 00 41 57 41 56 41 55 49 89 d5 41 54 55 48 89 fd 53 48 89 f3 e8 e8 eb a0 fa 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 e8 01 00 00 4c 8b 65 00 4d 85 e4 0f 84 b3 01 00
>>RSP: 0018:ffffc90004f57ac8 EFLAGS: 00010246
>>RAX: dffffc0000000000 RBX: 30303030320a0028 RCX: ffffc900103dc000
>>RDX: 0000000000000000 RSI: ffffffff86d72738 RDI: 0000000000000000
>>RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000002
>>R10: ffffffff86d62d88 R11: 0000000000000000 R12: ffff8880260e4d68
>>R13: 303030305f3a3057 R14: dffffc0000000000 R15: 0000000000000000
>>FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>CR2: 00007f2d449f6718 CR3: 000000001d652000 CR4: 00000000003506e0
>>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>----------------
>>Code disassembly (best guess):
>>   0:	00 41 57             	add    %al,0x57(%rcx)
>>   3:	41 56                	push   %r14
>>   5:	41 55                	push   %r13
>>   7:	49 89 d5             	mov    %rdx,%r13
>>   a:	41 54                	push   %r12
>>   c:	55                   	push   %rbp
>>   d:	48 89 fd             	mov    %rdi,%rbp
>>  10:	53                   	push   %rbx
>>  11:	48 89 f3             	mov    %rsi,%rbx
>>  14:	e8 e8 eb a0 fa       	callq  0xfaa0ec01
>>  19:	48 89 ea             	mov    %rbp,%rdx
>>  1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>>  23:	fc ff df
>>  26:	48 c1 ea 03          	shr    $0x3,%rdx
>>* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>>  2e:	0f 85 e8 01 00 00    	jne    0x21c
>>  34:	4c 8b 65 00          	mov    0x0(%rbp),%r12
>>  38:	4d 85 e4             	test   %r12,%r12
>>  3b:	0f                   	.byte 0xf
>>  3c:	84                   	.byte 0x84
>>  3d:	b3 01                	mov    $0x1,%bl
>>
>>
>>---
>>This report is generated by a bot. It may contain errors.
>>See https://goo.gl/tpsmEJ for more information about syzbot.
>>syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>>syzbot will keep track of this issue. See:
>>https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>
>
