Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293F85101F5
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 17:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbiDZPge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 11:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348202AbiDZPgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 11:36:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E3EE158F55
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 08:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650987202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=txfe2oimGBNCp3utGQEk2MCQ7mcScSc02C68RknEsCs=;
        b=HFyfOD0eYQ70550Ux9VewLO7yWCRaaFYnllmhdWkb04fLWH0M+FhWG2iDPdNsJG/e/bjNX
        zTYPk9strzEwXci0P3EUPsgg5ljXdqcvMArVKjBGP7WGkZ7jldH4z5wKwEb9VAnOZO7o0N
        ItUh8ef7AN+Pzme0RExOKkYy+z8rDmg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260--PVOIeSRNjSUZj2FKNnigg-1; Tue, 26 Apr 2022 11:33:19 -0400
X-MC-Unique: -PVOIeSRNjSUZj2FKNnigg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 751AD85A5BE;
        Tue, 26 Apr 2022 15:33:19 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3B31C28114;
        Tue, 26 Apr 2022 15:33:13 +0000 (UTC)
Message-ID: <e415e20f899407fb24dfb8ecbc1940c5cb14a302.camel@redhat.com>
Subject: kvm_gfn_to_pfn_cache_refresh started getting a warning recently
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     David Woodhouse <dwmw2@infradead.org>
Date:   Tue, 26 Apr 2022 18:33:12 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[  390.511995] BUG: sleeping function called from invalid context at include/linux/highmem-internal.h:161
[  390.513681] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 4439, name: CPU 0/KVM
[  390.515045] preempt_count: 1, expected: 0
[  390.515733] INFO: lockdep is turned off.
[  390.516405] irq event stamp: 0
[  390.516928] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[  390.517989] hardirqs last disabled at (0): [<ffffffff811339cb>] copy_process+0x94b/0x1ec0
[  390.519370] softirqs last  enabled at (0): [<ffffffff811339cb>] copy_process+0x94b/0x1ec0
[  390.520767] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  390.521827] CPU: 4 PID: 4439 Comm: CPU 0/KVM Tainted: G        W  O      5.18.0-rc4.unstable #5
[  390.523284] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  390.524596] Call Trace:
[  390.525021]  <TASK>
[  390.525393]  dump_stack_lvl+0x49/0x5e
[  390.526022]  dump_stack+0x10/0x12
[  390.526597]  __might_resched.cold+0xc7/0xd8
[  390.527316]  __might_sleep+0x43/0x70
[  390.527929]  kvm_gfn_to_pfn_cache_refresh+0x404/0x5a0 [kvm]
[  390.528975]  kvm_gfn_to_pfn_cache_init+0x4b/0x120 [kvm]
[  390.529919]  kvm_write_system_time+0x4a/0x80 [kvm]
[  390.530798]  kvm_set_msr_common+0x73c/0xeb0 [kvm]
[  390.531657]  ? lock_acquire+0x174/0x2b0
[  390.532318]  ? rcu_read_lock_sched_held+0x16/0x80
[  390.533125]  svm_set_msr+0x29c/0x7b0 [kvm_amd]
[  390.533885]  __kvm_set_msr+0x7f/0x1c0 [kvm]
[  390.534659]  ? kvm_msr_allowed+0x119/0x180 [kvm]
[  390.535505]  kvm_emulate_wrmsr+0x54/0x2a0 [kvm]
[  390.536337]  msr_interception+0x1c/0x30 [kvm_amd]
[  390.537157]  svm_invoke_exit_handler+0x9d/0xe0 [kvm_amd]
[  390.538064]  svm_handle_exit+0xe7/0x320 [kvm_amd]
[  390.538871]  kvm_arch_vcpu_ioctl_run+0xf6e/0x1d00 [kvm]
[  390.539822]  ? __mutex_unlock_slowpath+0x4a/0x2e0
[  390.540625]  ? rcu_read_lock_sched_held+0x16/0x80
[  390.541430]  kvm_vcpu_ioctl+0x289/0x750 [kvm]
[  390.542228]  ? kvm_vcpu_ioctl+0x289/0x750 [kvm]
[  390.543050]  ? lock_release+0x1c4/0x270
[  390.543711]  ? __fget_files+0xe1/0x1a0
[  390.544358]  ? do_futex+0xa6/0x150
[  390.544971]  __x64_sys_ioctl+0x8e/0xc0
[  390.545625]  do_syscall_64+0x36/0x80
[  390.546243]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  390.547106] RIP: 0033:0x7f6b4e6dc0ab
[  390.547722] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d bd 0c 00 f7
d8 64 89 01 48
[  390.550852] RSP: 002b:00007f6b4997e5c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  390.552133] RAX: ffffffffffffffda RBX: 000055860718d700 RCX: 00007f6b4e6dc0ab
[  390.553334] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000c
[  390.554536] RBP: 00007f6b4997e6c0 R08: 0000558604ea4e60 R09: 00000000000000ff
[  390.555727] R10: 00005586049fdc1a R11: 0000000000000246 R12: 00007ffd90ecd33e
[  390.556931] R13: 00007ffd90ecd33f R14: 0000000000000000 R15: 00007f6b49980640
[  390.558138]  </TASK>

Decoded trace:

[  390.525393] dump_stack_lvl+0x49/0x5e 
[  390.526022] dump_stack+0x10/0x12 
[  390.526597] __might_resched.cold+0xc7/0xd8 
[  390.527316] __might_sleep+0x43/0x70 
[  390.527929] kvm_gfn_to_pfn_cache_refresh (/home/mlevitsk/Kernel/br-vm-64/src/./include/linux/highmem-internal.h:161 /home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/../../../virt/kvm/pfncache.c:240) 
kvm
[  390.528975] kvm_gfn_to_pfn_cache_init (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/../../../virt/kvm/pfncache.c:328) kvm
[  390.529919] kvm_write_system_time (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/x86.c:2292) kvm
[  390.530798] kvm_set_msr_common (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/x86.c:3627) kvm
[  390.531657] ? lock_acquire+0x174/0x2b0 
[  390.532318] ? rcu_read_lock_sched_held+0x16/0x80 
[  390.533125] svm_set_msr (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/svm/svm.c:2986) kvm_amd
[  390.533885] __kvm_set_msr (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/x86.c:1837) kvm
[  390.534659] ? kvm_msr_allowed (/home/mlevitsk/Kernel/br-vm-64/src/./include/linux/srcu.h:191 /home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/x86.c:1765) kvm
[  390.535505] kvm_emulate_wrmsr (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/x86.c:1842 /home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/x86.c:1910 /home/mlevitsk/Kernel/br-vm-
64/src/arch/x86/kvm/x86.c:2020) kvm
[  390.536337] msr_interception (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/svm/svm.c:2997) kvm_amd
[  390.537157] svm_invoke_exit_handler (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/svm/svm.c:3293) kvm_amd
[  390.538064] svm_handle_exit (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/svm/svm.c:3364) kvm_amd
[  390.538871] kvm_arch_vcpu_ioctl_run (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/x86.c:10433 /home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/x86.c:10632) kvm
[  390.539822] ? __mutex_unlock_slowpath+0x4a/0x2e0 
[  390.540625] ? rcu_read_lock_sched_held+0x16/0x80 
[  390.541430] kvm_vcpu_ioctl (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/../../../virt/kvm/kvm_main.c:3952) kvm
[  390.542228] ? kvm_vcpu_ioctl (/home/mlevitsk/Kernel/br-vm-64/src/arch/x86/kvm/../../../virt/kvm/kvm_main.c:3952) kvm
[  390.543050] ? lock_release+0x1c4/0x270 
[  390.543711] ? __fget_files+0xe1/0x1a0 
[  390.544358] ? do_futex+0xa6/0x150 
[  390.544971] __x64_sys_ioctl+0x8e/0xc0 
[  390.545625] do_syscall_64+0x36/0x80 
[  390.546243] entry_SYSCALL_64_after_hwframe+0x44/0xae 
[  390.547106] RIP: 0033:0x7f6b4e6dc0ab
[ 390.547722] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d bd 0c 00 f7 d


This points to 'new_khva = kmap(pfn_to_page(new_pfn));'

kmap can indeed sleep but we hold a spinlock.

Best regards,
	Maxim Levitsky


