Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3B36EB3EC
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 23:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbjDUVwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 17:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbjDUVwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 17:52:42 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C0F1BF8
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 14:52:40 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51c18f5ae60so1524338a12.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 14:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682113960; x=1684705960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HMsg4nmJr9Osyznf6S6bHdZ6vDeDrUhREwLX6UGd8T8=;
        b=XvsxnBgk29sdZsc1idOkaA4saQHitnYVxiuWLfPvQYA4gJjUA0Eax8NP6eYtNqR3ee
         4M8iRSBz8QogM+10jEopg0WJoIMroxEwWvwhMZRwvcP/9YKwEsjVGEx1aOcV3VuY1m3u
         uB/uYY4qESrX6Z1m+VLGFlwzsogxd1ySHWqe47vhDg5k3/1sBaGMDfYD2pGKCFu9gwtt
         Dq86ic1cx9+DkwWMjUW0JEvgSaer47uaocf45slybIAtKLOjRYw89z5uJSu1zmCzvupR
         QfbyNrb0tff8312OlkakXbsa3/e1zQC4Nfuu1vW9A7vNuaB9WIVw1FF32p495ltI+1vA
         ynmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682113960; x=1684705960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HMsg4nmJr9Osyznf6S6bHdZ6vDeDrUhREwLX6UGd8T8=;
        b=WLg4Kbk45f8Z3KFUORYtaLPPwQondgdTNlt+SO3UEB4pp6gBR1l2eP9i0Bf21AvQmi
         5RhsntwDiXwes1rWcGSm+sW0FvTLdRBD/2mlHEgjCxW20jiWZxo4MUzvdudc+etyloAi
         TycsSolFbpxUswmmYne3lirdfbU9LWKDP8OCXBi6WlAk2iZU/4jBuAkX/tOowzLSgNCT
         Zb688FIlCFE+F1rDJxX3ZbcokQpr9J6REUEyDX59AMxho+ferStkqBGWZ2VU+2zSJWSy
         J7jgymvduyQj66uwFOkvm5EvkKmoAAPS3DXabFR7r0GIUvSm9uh/BnHE7nPYHaqsRXJq
         x/mQ==
X-Gm-Message-State: AAQBX9c3fFuXcH9uN13EdTfyq1itQlDTWQ9L0H+uqTdJy2JYK0Y3qsga
        REH6WHzFR7JVOPUtHlM+2+OZ8XbL2Gg=
X-Google-Smtp-Source: AKy350bNGZ0YwNCOoK47veefne8EuX49Y7h0rsJEJN50Jsq85FTnEuNaK8IUJn8w9z2rCbRF2CTWUSGfbYs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:551e:0:b0:524:e24a:df56 with SMTP id
 j30-20020a63551e000000b00524e24adf56mr523655pgb.5.1682113959758; Fri, 21 Apr
 2023 14:52:39 -0700 (PDT)
Date:   Fri, 21 Apr 2023 14:52:38 -0700
In-Reply-To: <000000000000a0bc2b05f9dd7fab@google.com>
Mime-Version: 1.0
References: <000000000000a0bc2b05f9dd7fab@google.com>
Message-ID: <ZEMFpqxvOHd2kZiu@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_tdp_mmu_invalidate_all_roots
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+094a74444165dbcd3a54@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d3e1ee0e67e7 Add linux-next specific files for 20230421
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16ac3de0280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=53c789efbcc06cf6
> dashboard link: https://syzkaller.appspot.com/bug?extid=094a74444165dbcd3a54
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c558a9e1fe6a/disk-d3e1ee0e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2ec100a34c4c/vmlinux-d3e1ee0e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/1afcd9936dc1/bzImage-d3e1ee0e.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+094a74444165dbcd3a54@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 12623 at arch/x86/kvm/mmu/tdp_mmu.c:943 kvm_tdp_mmu_invalidate_all_roots+0x2bd/0x370 arch/x86/kvm/mmu/tdp_mmu.c:943
> Modules linked in:
> CPU: 0 PID: 12623 Comm: syz-executor.3 Not tainted 6.3.0-rc7-next-20230421-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
> RIP: 0010:kvm_tdp_mmu_invalidate_all_roots+0x2bd/0x370 arch/x86/kvm/mmu/tdp_mmu.c:943
> Call Trace:
>  <TASK>
>  kvm_mmu_uninit_tdp_mmu+0x16/0x100 arch/x86/kvm/mmu/tdp_mmu.c:48
>  kvm_mmu_uninit_vm+0x6a/0x70 arch/x86/kvm/mmu/mmu.c:6239
>  kvm_arch_destroy_vm+0x369/0x490 arch/x86/kvm/x86.c:12465
>  kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1245 [inline]
>  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:5017 [inline]
>  kvm_dev_ioctl+0x11be/0x1bb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:5059
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Gah, kvm->users_count is elevated when the VM is destroyed if creation fails,
but mmu_lock isn't held in that case, and lockdep yells.  This particular bug is
effectively a false positive, nothing else holds a reference to the VM.

However, syzbot found another bug that _is_ a real problem (hasn't been reported
upstream yet for whatever reason).  Not holding mmu_lock during "real" VM destruction
is problematic because walking the list can race with the asynchronous worker
deleting and freeing from the list.

Posted a fixed version[*] that should resolve both issues by protecting the walk
with RCU.

[*] https://lore.kernel.org/all/20230421214946.2571580-1-seanjc@google.com

==================================================================
BUG: KASAN: slab-use-after-free in kvm_tdp_mmu_invalidate_all_roots+0x2e3/0x370 arch/x86/kvm/mmu/tdp_mmu.c:945
Read of size 8 at addr ffff88801c8cf948 by task syz-executor.1/17012

CPU: 0 PID: 17012 Comm: syz-executor.1 Not tainted 6.3.0-rc7-next-20230421-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
print_report mm/kasan/report.c:462 [inline]
kasan_report+0x11c/0x130 mm/kasan/report.c:572
kvm_tdp_mmu_invalidate_all_roots+0x2e3/0x370 arch/x86/kvm/mmu/tdp_mmu.c:945
kvm_mmu_uninit_tdp_mmu+0x16/0x100 arch/x86/kvm/mmu/tdp_mmu.c:48
kvm_mmu_uninit_vm+0x6a/0x70 arch/x86/kvm/mmu/mmu.c:6239
kvm_arch_destroy_vm+0x369/0x490 arch/x86/kvm/x86.c:12465
kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1313 [inline]
kvm_put_kvm+0x4da/0xae0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1347
kvm_vcpu_release+0x51/0x70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3846
__fput+0x27c/0xa90 fs/file_table.c:321
task_work_run+0x16f/0x270 kernel/task_work.c:179
resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
__syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fd7a583e01b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007ffc821a2fb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 000000000000000a RCX: 00007fd7a583e01b
RDX: 0000000000000000 RSI: 00007fd7a5400000 RDI: 0000000000000009
RBP: 00007fd7a59ad980 R08: 0000000000000000 R09: 0000000071612a4e
R10: 0000000000000000 R11: 0000000000000293 R12: 000000000014ffb4
R13: 00007ffc821a30b0 R14: 00007fd7a59ac050 R15: 0000000000000032
</TASK>
