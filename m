Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA21C4D8576
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 13:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiCNMwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 08:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbiCNMwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 08:52:39 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C38321B1
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 05:51:29 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2dc242a79beso161337257b3.8
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 05:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=0hwovVYgP3mGujUVRa+0EXWnvlkG8+Qr5fRIelkpXxM=;
        b=p6rh3aKXRdSAeyhTBWvkb9PXkqbUO5r30M+yLgLuWKipFVhpuNW5xfT2RnfEYBAzeC
         kkmln8rZAuumu4qvV0+p7rqGcXcZjVVodCGEF/gWllqNw86onvScpRt7+MV04Sv8IkHT
         pDYEYzIp9hIOYFk/AjDgoMFW4Pp3rc/+i0KKoEAaR9GWM0ymvfaaIEzLTedyTUE9PbnF
         k7T31BqoPffuLZAfgOsbkKoykjfe/VPUuHcZda9+L+vroHtXCkmyR/DIsIUAfYHbbWw5
         aGiTqijCvYeiQsGMvvCjVOSAfZCw+Pu7g5RrxqAiJIrYA1+r9EsrdLFfKTkjEw5uoyHD
         Cj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=0hwovVYgP3mGujUVRa+0EXWnvlkG8+Qr5fRIelkpXxM=;
        b=VPXNKTLdsTrD1B3U50pjgfJAzK5Rm4Tt09mFyHTSY5kD0PHvNzsF1g8eScC4cq+/zZ
         xY+sywIIpC//9cEqdvji8izQjtK+cQMEUcmO9dwXfIu6FKoC4mP7bhVq3OTSUD2W3iHh
         K32e3is+RTOJKkcp/JJ7q7ojt1Yo4MVgU9TbLxvT9fSGHJymxqupbeVsmmU3Bt24bSq+
         ga2aSzQY/wESqYQo91CKINXG0CWjq5TvB2rQTesR7VqyOs/IyY/o9whtkZ55RUJfawYi
         XO2ywY8z82BsRl1iZtIofDLu08soZneXVbJSs01g081GK9trpkdGt7B5MGlJbgAIiyvS
         2NWw==
X-Gm-Message-State: AOAM533ZLnQqOrBKKJLTG+IkZ5lhcFaJAuJJR0dDZUzL2ywPbw/XUzA2
        zHv4H7drnXxq01hn3flegjgPU36HLugH+CUsFlWC9pc6hE0DmnyE
X-Google-Smtp-Source: ABdhPJzMi9wzr1CXBtQPKVErB7okkB8ivKKmqm74MYzFseu5+5eV32ta93w6gnhfEGfRQrBXSioTrUbPpaESHtiA4as=
X-Received: by 2002:a81:4ed5:0:b0:2dc:e57:e5f2 with SMTP id
 c204-20020a814ed5000000b002dc0e57e5f2mr18654717ywb.199.1647262287990; Mon, 14
 Mar 2022 05:51:27 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 14 Mar 2022 18:21:17 +0530
Message-ID: <CA+G9fYsziOWHkV+YbKymtpVBkL=DAHnmMfkeuWvx0pJPg=fMEA@mail.gmail.com>
Subject: WARNING: CPU: 0 PID: 884 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3162
 mark_page_dirty_in_slot
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     open list <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While running kselftest kvm tests on Linux mainline 5.17.0-rc8 on x86_64 device
the following kernel warning was noticed

# selftests: kvm: hyperv_clock
[   59.752584] ------------[ cut here ]------------
[   59.757297] WARNING: CPU: 0 PID: 884 at
arch/x86/kvm/../../../virt/kvm/kvm_main.c:3162
mark_page_dirty_in_slot+0xba/0xd0
[   59.768196] Modules linked in: x86_pkg_temp_thermal fuse
[   59.773531] CPU: 0 PID: 884 Comm: hyperv_clock Not tainted 5.17.0-rc8 #1
[   59.780242] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.5 11/26/2020
[   59.787652] RIP: 0010:mark_page_dirty_in_slot+0xba/0xd0
[   59.792894] Code: 89 ea 09 c6 e8 07 cd 00 00 5b 41 5c 41 5d 41 5e
5d c3 48 8b 83 c0 00 00 00 49 63 d5 f0 48 0f ab 10 5b 41 5c 41 5d 41
5e 5d c3 <0f> 0b 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 44 00 00 eb 80 0f 1f
40 00
[   59.811659] RSP: 0018:ffffa1548109bbe0 EFLAGS: 00010246
[   59.816919] RAX: 0000000080000000 RBX: ffff9174c5303a00 RCX: 0000000000000000
[   59.824068] RDX: 0000000000000000 RSI: ffffffffb6e29061 RDI: ffffffffb6e29061
[   59.831219] RBP: ffffa1548109bc00 R08: 0000000000000000 R09: 0000000000000001
[   59.838369] R10: 0000000000000001 R11: 0000000000000000 R12: ffffa1548109d000
[   59.845545] R13: 0000000000000022 R14: 0000000000000000 R15: 0000000000000004
[   59.852721] FS:  00007f07cc7b9740(0000) GS:ffff917827a00000(0000)
knlGS:0000000000000000
[   59.860822] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   59.866585] CR2: 0000000000000000 CR3: 0000000106700006 CR4: 00000000003726f0
[   59.873737] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   59.880886] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   59.888034] Call Trace:
[   59.890512]  <TASK>
[   59.892641]  __kvm_write_guest_page+0xc8/0x100
[   59.897112]  kvm_write_guest+0x61/0xb0
[   59.900882]  kvm_hv_invalidate_tsc_page+0xd3/0x140
[   59.905688]  ? kvm_hv_invalidate_tsc_page+0x72/0x140
[   59.910676]  kvm_arch_vm_ioctl+0x20f/0xb70
[   59.914789]  ? __lock_acquire+0x3af/0x2370
[   59.918913]  ? __this_cpu_preempt_check+0x13/0x20
[   59.923638]  ? lock_is_held_type+0xdd/0x130
[   59.927845]  kvm_vm_ioctl+0x774/0xe10
[   59.931530]  ? ktime_get_coarse_real_ts64+0xbe/0xd0
[   59.936429]  ? __this_cpu_preempt_check+0x13/0x20
[   59.941178]  ? lockdep_hardirqs_on+0x7e/0x100
[   59.945552]  ? ktime_get_coarse_real_ts64+0xbe/0xd0
[   59.950493]  ? ktime_get_coarse_real_ts64+0xbe/0xd0
[   59.955459]  ? security_file_ioctl+0x37/0x50
[   59.959753]  __x64_sys_ioctl+0x91/0xc0
[   59.963524]  do_syscall_64+0x5c/0x80
[   59.967125]  ? do_syscall_64+0x69/0x80
[   59.970896]  ? syscall_exit_to_user_mode+0x3e/0x50
[   59.975706]  ? do_syscall_64+0x69/0x80
[   59.979495]  ? exc_page_fault+0x7c/0x250
[   59.983453]  ? asm_exc_page_fault+0x8/0x30
[   59.987570]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   59.992637] RIP: 0033:0x7f07cc0b78f7
[   59.996234] Code: b3 66 90 48 8b 05 a1 35 2c 00 64 c7 00 26 00 00
00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 71 35 2c 00 f7 d8 64 89
01 48
[   60.014996] RSP: 002b:00007ffdf0b37478 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[   60.022581] RAX: ffffffffffffffda RBX: 000000004030ae7b RCX: 00007f07cc0b78f7
[   60.029729] RDX: 00007ffdf0b374b0 RSI: 000000004030ae7b RDI: 0000000000000006
[   60.036880] RBP: 0000000000000007 R08: 000000000040de60 R09: 0000000000000007
[   60.044030] R10: 0000000000067816 R11: 0000000000000246 R12: 00007f07cc7bf000
[   60.051180] R13: 0000000000000007 R14: 0000000000006592 R15: 0000000000136843
[   60.058357]  </TASK>
[   60.060566] irq event stamp: 6625
[   60.063925] hardirqs last  enabled at (6635): [<ffffffffb7064848>]
__up_console_sem+0x58/0x60
[   60.072511] hardirqs last disabled at (6644): [<ffffffffb706482d>]
__up_console_sem+0x3d/0x60
[   60.081044] softirqs last  enabled at (6092): [<ffffffffb8400327>]
__do_softirq+0x327/0x493
[   60.089407] softirqs last disabled at (6085): [<ffffffffb6fe3a65>]
irq_exit_rcu+0xe5/0x130
[   60.097735] ---[ end trace 0000000000000000 ]---
ok 6 selftests: kvm: hyperv_clock

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

metadata:
  git_describe: v5.17-rc8
  git_ref: master
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline
  git_sha: 09688c0166e76ce2fb85e86b9d99be8b0084cdf9
  kernel-config: https://builds.tuxbuild.com/26LbaUN6vcuAN7Rd69gZkFWp5J8/config
  build: https://builds.tuxbuild.com/26LbaUN6vcuAN7Rd69gZkFWp5J8/

--
Linaro LKFT
https://lkft.linaro.org

[1] https://lkft.validation.linaro.org/scheduler/job/4714912#L1520
[2] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.17-rc8/testrun/8445627/suite/linux-log-parser/test/check-kernel-warning-4714912/details/
