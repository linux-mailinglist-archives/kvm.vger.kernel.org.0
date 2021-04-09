Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F93E35A574
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 20:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhDISOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 14:14:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31232 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234684AbhDISOT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 14:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617992045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9cxnipGcOQ8CcCKiRMMTjqef1u0BHrZmiuaF7aZ+aCk=;
        b=bGKHKGvldL7co+4PXMnUHJJLFrpgEqYC1bxg8bv8PjPMaodNaPC8V9QMZblkbzb6neZKo4
        JQXt9eSNG4KFS305xe6UESb+RyzBz7grNmNbj6fgr+jU2ySA+UhIXWa8lJ5wI+XTuE2sS0
        hppJS75uBeuZlpsNEisiL5psfZRviwU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-GAIOpPtDPpqurpj3VD-yxg-1; Fri, 09 Apr 2021 14:14:02 -0400
X-MC-Unique: GAIOpPtDPpqurpj3VD-yxg-1
Received: by mail-pl1-f198.google.com with SMTP id b13so2538100plh.19
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 11:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9cxnipGcOQ8CcCKiRMMTjqef1u0BHrZmiuaF7aZ+aCk=;
        b=Su5CJa6qxgcMItnMalvf2qsJPvGfn41v6kGTjmn273FqYF+iX1giYAhRGyizjc0di7
         hL8ftYFLMOGLuTSIG22JZ3C1HImc3Bq6+f1ixgPfjzJNSDc9P2b+kfOj5Zvj4eLZytXs
         qtaPPqdiy2TiLZJfth1ErcOAcnKjdjVN2GB+Ap0Obr2kwxPo4ZJvvu/7vWQvUDX1bQIH
         Ro4wLj96ACtVmVOjRcjswTK+uTT5PvpUsJxl0NNyaOKBDPrMPsEuXRyojWCn6NSAjk7V
         JeJbSTe92sjNjoO4e6RJjYgRFeKltEvy21Y/kkzCftjrgJCktD33xtrGDgVzCIHMflwW
         s9TA==
X-Gm-Message-State: AOAM5302vzdKEf1nqEg6ICVVTnbCp28iPDSJT+KsFCiadiYbq3fQIm7g
        yQbaJ5gXxT1fvW+ppesd459c9EHZaebwS7lT0QWaonWGmD9SxBxiEeaiSxaNbXGFjcyt7x+sSHG
        IL3uV3ekErbEy
X-Received: by 2002:a17:90a:116:: with SMTP id b22mr9198823pjb.128.1617992041254;
        Fri, 09 Apr 2021 11:14:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/hRH3Vgz3SM+P6g9kyScDLaNcTV74DrN8WtrqAE9AzUV24YoQUM8ZhORkL3ZWQP6B2ZIOIg==
X-Received: by 2002:a17:90a:116:: with SMTP id b22mr9198805pjb.128.1617992041012;
        Fri, 09 Apr 2021 11:14:01 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f6sm3672500pgd.61.2021.04.09.11.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:14:00 -0700 (PDT)
Date:   Sat, 10 Apr 2021 02:13:43 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     syzbot <syzbot+d6a0e4b80bd39f54c2f6@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, bp@alien8.de, chao@kernel.org,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        masahiroy@kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rostedt@goodmis.org, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, will@kernel.org,
        x86@kernel.org, xiang@kernel.org
Subject: Re: [syzbot] BUG: spinlock bad magic in erofs_pcpubuf_growsize
Message-ID: <20210409181343.GA875233@xiangao.remote.csb>
References: <00000000000012002d05bf8dec8d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00000000000012002d05bf8dec8d@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Apr 09, 2021 at 10:59:15AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9c54130c Add linux-next specific files for 20210406
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1654617ed00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d125958c3995ddcd
> dashboard link: https://syzkaller.appspot.com/bug?extid=d6a0e4b80bd39f54c2f6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101a5786d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1147dd0ed00000
> 
> The issue was bisected to:
> 
> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
> Author: Mark Rutland <mark.rutland@arm.com>
> Date:   Mon Jan 11 15:37:07 2021 +0000
> 
>     lockdep: report broken irq restoration
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d8d7aad00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13d8d7aad00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15d8d7aad00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d6a0e4b80bd39f54c2f6@syzkaller.appspotmail.com
> Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")
> 
> loop0: detected capacity change from 0 to 31
> BUG: spinlock bad magic on CPU#1, syz-executor062/8434
>  lock: 0xffff8880b9c31d60, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> CPU: 1 PID: 8434 Comm: syz-executor062 Not tainted 5.12.0-rc6-next-20210406-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
>  do_raw_spin_lock+0x216/0x2b0 kernel/locking/spinlock_debug.c:112
>  erofs_pcpubuf_growsize+0x36f/0x620 fs/erofs/pcpubuf.c:83
>  z_erofs_load_lz4_config+0x1ef/0x3e0 fs/erofs/decompressor.c:64
>  erofs_read_superblock fs/erofs/super.c:331 [inline]
>  erofs_fc_fill_super+0xe84/0x1d10 fs/erofs/super.c:499
>  get_tree_bdev+0x440/0x760 fs/super.c:1293
>  vfs_get_tree+0x89/0x2f0 fs/super.c:1498
>  do_new_mount fs/namespace.c:2905 [inline]
>  path_mount+0x132a/0x1fa0 fs/namespace.c:3235
>  do_mount fs/namespace.c:3248 [inline]
>  __do_sys_mount fs/namespace.c:3456 [inline]
>  __se_sys_mount fs/namespace.c:3433 [inline]
>  __x64_sys_mount+0x27f/0x300 fs/namespace.c:3433
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x444f7a
> Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe1fa3c2a8 EFLAGS: 00000286 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffe1fa3c300 RCX: 0000000000444f7a
> RDX: 0000000020000000 RSI: 0000000020000100 RDI: 00007ffe1fa3c2c0
> RBP: 00007ffe1fa3c2c0 R08: 00007ffe1fa3c300 R09: 
> 

Thanks for the report. It's a spinlock uninitialization issue actually
due to the new patchset (bisect was wrong here), I will fix it up soon.

Thanks,
Gao Xiang

