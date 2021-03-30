Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CEE34EEF1
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 19:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhC3RFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 13:05:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232118AbhC3REp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 13:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617123885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w2lAv6Y8ocPT8PnVS3wa7b+VzR9sgZuZpuwMMYuUfRA=;
        b=Wlsme69DIYH6oDlehK4Cr0CRlBwkUydU4egbVJC/6BVqNlt+ndTUj57LXsKmVXS0Lv5Sbx
        LjkQxMrbpiZblqG2lTtncOTQV2lMNpXt7zdibWckL8fyT3T0kBBuhMmtn6qYxUvcodv5+W
        W+MLxcEDucY3dd1ZupLY9+EoZvJrWD8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-mDZQBlFENbGqJm6Dwk5gVw-1; Tue, 30 Mar 2021 13:04:42 -0400
X-MC-Unique: mDZQBlFENbGqJm6Dwk5gVw-1
Received: by mail-wr1-f70.google.com with SMTP id o11so10644401wrc.4
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 10:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w2lAv6Y8ocPT8PnVS3wa7b+VzR9sgZuZpuwMMYuUfRA=;
        b=oTKHc+ZNApst4rtU2KPQPDNbHvpCRmEtVX+OoIx7HBJghrMIvQ2M5VnW3nJk/eeR5U
         GveFpKcfc1vkP4AkjX81wa99n5gpntxoEnwbXecnAILlAQuCj9nW0Rp8MrKvn2MuTZ7T
         ndYnBIj78bYh067zNre1TQo54QivdPTqsbJ0JGU6Vt5QOTVIoVrRSiLB41lnpbnuI4hy
         fY+RtIW+IGcXWUWFsVKuFw8myqLxy4/ILyNLPxaXxT5ByYloJMpQiBy7KlmHImYbC369
         xE4x0Xf2SxJK8pENduWxowAltJWbHTmHdxIB5qn3MChm8ABhGw1My/17A0AMS36Hx/ja
         f7sA==
X-Gm-Message-State: AOAM5331VF5bWx8gPZj2f1nlSWuPdZRKpa30ZmkGB9DC34lcXawitegJ
        jYRZthMe5GtPAf/25+rVD4F8rdNlnqIR7VTDJsOq53zhc1F+7PvQyqfcIY3xaz40+Wq4qUJZnvP
        cYx9b7ZtkEhKX
X-Received: by 2002:a1c:94:: with SMTP id 142mr5215326wma.0.1617123880255;
        Tue, 30 Mar 2021 10:04:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwugJHlzSS2mn8UQWmSis1ODZnV8Ol3jz22ZDpQ2ZeAwkBOxRJlOkJMe6AE9fWnLS9GnIN4Dw==
X-Received: by 2002:a1c:94:: with SMTP id 142mr5215293wma.0.1617123880037;
        Tue, 30 Mar 2021 10:04:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c9sm33421003wrr.78.2021.03.30.10.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 10:04:34 -0700 (PDT)
Subject: Re: [syzbot] WARNING in unsafe_follow_pfn
To:     syzbot <syzbot+015dd7cdbbbc2c180c65@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, bp@alien8.de, daniel.vetter@ffwll.ch,
        daniel.vetter@intel.com, hpa@zytor.com, jmattson@google.com,
        jmorris@namei.org, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        m.szyprowski@samsung.com, mchehab@kernel.org, mingo@redhat.com,
        seanjc@google.com, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com, tfiga@chromium.org,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
References: <000000000000ca9a6005bec29ebe@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2db3c803-6a94-9345-261a-a2bb74370c02@redhat.com>
Date:   Tue, 30 Mar 2021 19:04:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <000000000000ca9a6005bec29ebe@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/03/21 17:26, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    93129492 Add linux-next specific files for 20210326
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=169ab21ad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6f2f73285ea94c45
> dashboard link: https://syzkaller.appspot.com/bug?extid=015dd7cdbbbc2c180c65
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119b8d06d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112e978ad00000
> 
> The issue was bisected to:
> 
> commit d40b9fdee6dc819d8fc35f70c345cbe0394cde4c
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Tue Mar 16 15:33:01 2021 +0000
> 
>      mm: Add unsafe_follow_pfn
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122d2016d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=112d2016d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=162d2016d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+015dd7cdbbbc2c180c65@syzkaller.appspotmail.com
> Fixes: d40b9fdee6dc ("mm: Add unsafe_follow_pfn")

This is basically intentional because get_vaddr_frames is broken, isn't 
it?  I think it needs to be ignored in syzkaller.

Paolo

> ------------[ cut here ]------------
> unsafe follow_pfn usage
> WARNING: CPU: 1 PID: 8426 at mm/memory.c:4807 unsafe_follow_pfn+0x20f/0x260 mm/memory.c:4807
> Modules linked in:
> CPU: 0 PID: 8426 Comm: syz-executor677 Not tainted 5.12.0-rc4-next-20210326-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:unsafe_follow_pfn+0x20f/0x260 mm/memory.c:4807
> Code: 8b 7c 24 20 49 89 6d 00 e8 6e 84 64 07 e9 30 ff ff ff e8 f4 19 cb ff 48 c7 c7 40 1f 76 89 c6 05 56 eb 09 0c 01 e8 34 1a 21 07 <0f> 0b e9 71 fe ff ff 41 bc ea ff ff ff e9 06 ff ff ff e8 1a 65 0f
> RSP: 0018:ffffc9000161f660 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 1ffff920002c3ecc RCX: 0000000000000000
> RDX: ffff88801954d580 RSI: ffffffff815c3fd5 RDI: fffff520002c3ebe
> RBP: ffff888023d56948 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815bd77e R11: 0000000000000000 R12: 0000000021000000
> R13: ffff8880143a4010 R14: 0000000000000000 R15: 0000000000000110
> FS:  00000000005d1300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f172c4cd6c0 CR3: 0000000011f70000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   get_vaddr_frames+0x337/0x600 drivers/media/common/videobuf2/frame_vector.c:72
>   vb2_create_framevec+0x55/0xc0 drivers/media/common/videobuf2/videobuf2-memops.c:50
>   vb2_vmalloc_get_userptr+0xce/0x4c0 drivers/media/common/videobuf2/videobuf2-vmalloc.c:90
>   __prepare_userptr+0x342/0x15f0 drivers/media/common/videobuf2/videobuf2-core.c:1128
>   __buf_prepare+0x635/0x7d0 drivers/media/common/videobuf2/videobuf2-core.c:1367
>   vb2_core_qbuf+0xa9d/0x11c0 drivers/media/common/videobuf2/videobuf2-core.c:1658
>   vb2_qbuf+0x135/0x1a0 drivers/media/common/videobuf2/videobuf2-v4l2.c:820
>   vb2_ioctl_qbuf+0xfb/0x140 drivers/media/common/videobuf2/videobuf2-v4l2.c:1050
>   v4l_qbuf drivers/media/v4l2-core/v4l2-ioctl.c:2027 [inline]
>   v4l_qbuf+0x92/0xc0 drivers/media/v4l2-core/v4l2-ioctl.c:2021
>   __video_do_ioctl+0xb94/0xe20 drivers/media/v4l2-core/v4l2-ioctl.c:2951
>   video_usercopy+0x253/0x1300 drivers/media/v4l2-core/v4l2-ioctl.c:3297
>   v4l2_ioctl+0x1b3/0x250 drivers/media/v4l2-core/v4l2-dev.c:366
>   vfs_ioctl fs/ioctl.c:48 [inline]
>   __do_sys_ioctl fs/ioctl.c:753 [inline]
>   __se_sys_ioctl fs/ioctl.c:739 [inline]
>   __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x443639
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffee3065668 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443639
> RDX: 0000000020000140 RSI: 00000000c058560f RDI: 0000000000000004
> RBP: 00000000004031e0 R08: 00000000004004a0 R09: 00000000004004a0
> R10: 00236962762f7665 R11: 0000000000000246 R12: 0000000000403270
> R13: 0000000000000000 R14: 00000000004b1018 R15: 00000000004004a0
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

