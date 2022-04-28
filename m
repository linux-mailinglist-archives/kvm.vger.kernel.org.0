Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6BB512CB6
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245248AbiD1H3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245122AbiD1H2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:28:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3D693337A
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651130732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yeVOqZbYRiNPAjZcGJsVbxNYFa7g1Sew5FJ0Zr5e5DQ=;
        b=Xvn5BVZcwmp6qkOek61YZfVO4dNiUeWB32DegSfoZkJRmrtPo0jqHzO55Zkw4zitE2BiOZ
        IBKvW4Ywzkl28VoDW+MMnHG67uywPUQaFeZ1VoXpWTgAcf0amNskeygOVRZVUR83UZEz/M
        zTBy3wfvvRqDEuS8uxXjrym9pDGaQtc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-zkEQllv_NVu2Bjb_0gH7kA-1; Thu, 28 Apr 2022 03:25:29 -0400
X-MC-Unique: zkEQllv_NVu2Bjb_0gH7kA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BB0918A6582;
        Thu, 28 Apr 2022 07:25:28 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1ACEF40D2971;
        Thu, 28 Apr 2022 07:25:23 +0000 (UTC)
Message-ID: <b969c4cce719ebbb0532cff7a9c50571e30f67d2.camel@redhat.com>
Subject: Re: [syzbot] WARNING in kvm_mmu_uninit_tdp_mmu (2)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     syzbot <syzbot+a8ad3ee1525a0c4b40ec@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Date:   Thu, 28 Apr 2022 10:25:22 +0300
In-Reply-To: <13b3235ef66f22475fd4059df95ad0144548ccd1.camel@redhat.com>
References: <00000000000082452505dd503126@google.com>
         <13b3235ef66f22475fd4059df95ad0144548ccd1.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 19:20 +0300, Maxim Levitsky wrote:
> On Sat, 2022-04-23 at 03:56 -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    59f0c2447e25 Merge tag 'net-5.18-rc4' of git://git.kernel...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15a61430f00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=6bc13fa21dd76a9b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=a8ad3ee1525a0c4b40ec
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134363d0f00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ed3e34f00000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+a8ad3ee1525a0c4b40ec@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 3597 at arch/x86/kvm/mmu/tdp_mmu.c:57 kvm_mmu_uninit_tdp_mmu+0xf8/0x130 arch/x86/kvm/mmu/tdp_mmu.c:57
> > Modules linked in:
> > CPU: 1 PID: 3597 Comm: syz-executor294 Not tainted 5.18.0-rc3-syzkaller-00060-g59f0c2447e25 #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> > RIP: 0010:kvm_mmu_uninit_tdp_mmu+0xf8/0x130 arch/x86/kvm/mmu/tdp_mmu.c:57
> > Code: 83 d8 a0 00 00 48 39 c5 75 24 e8 e3 4d 5a 00 e8 9e e0 45 00 5b 5d e9 d7 4d 5a 00 e8 b2 42 a5 00 e9 3d ff ff ff e8 c8 4d 5a 00 <0f> 0b eb ad e8 bf 4d 5a 00 0f 0b eb d3 e8 c6 42 a5 00 e9 64 ff ff
> > RSP: 0018:ffffc90002e37c08 EFLAGS: 00010293
> > RAX: 0000000000000000 RBX: ffffc90002cda000 RCX: 0000000000000000
> > RDX: ffff888023f1e180 RSI: ffffffff811e1688 RDI: 0000000000000001
> > RBP: ffffc90002ce40e8 R08: 0000000000000001 R09: 0000000000000001
> > R10: ffffffff817ead48 R11: 0000000000000000 R12: ffffc90002cda000
> > R13: ffffc90002e37c50 R14: 0000000000000003 R15: ffffc90002cdb240
> > FS:  0000000000000000(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000560ac4d0cd68 CR3: 000000000ba8e000 CR4: 0000000000152ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  kvm_arch_destroy_vm+0x350/0x470 arch/x86/kvm/x86.c:11860
> >  kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1230 [inline]
> >  kvm_put_kvm+0x4fa/0xb70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1264
> >  kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1287
> >  __fput+0x277/0x9d0 fs/file_table.c:317
> >  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
> >  exit_task_work include/linux/task_work.h:37 [inline]
> >  do_exit+0xaff/0x2a00 kernel/exit.c:795
> >  do_group_exit+0xd2/0x2f0 kernel/exit.c:925
> >  __do_sys_exit_group kernel/exit.c:936 [inline]
> >  __se_sys_exit_group kernel/exit.c:934 [inline]
> >  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x7f0327505409
> > Code: Unable to access opcode bytes at RIP 0x7f03275053df.
> > RSP: 002b:00007ffc4a0be998 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> > RAX: ffffffffffffffda RBX: 00007f0327578350 RCX: 00007f0327505409
> > RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> > RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 68742f636f72702f
> > R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f0327578350
> > R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> >  </TASK>
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> > 
> 
> I can reproduce this in a VM, by running and CTRL+C'in my ipi_stress test,
> I am using to test AVIC, but without any relevant patches in the guest kernel.

Update: I can reproduce it in a guest running mainline 5.18-rc1, and 5.17.0 kernels,
even without AVIC enabled in the guest.

[mlevitsk@fedora34 ~]$[  187.567377] ------------[ cut here ]------------
[  187.568245] WARNING: CPU: 1 PID: 3835 at arch/x86/kvm/mmu/tdp_mmu.c:46 kvm_mmu_uninit_tdp_mmu+0x47/0x50 [kvm]
[  187.570145] Modules linked in: kvm_amd ccp kvm irqbypass xt_CHECKSUM xt_MASQUERADE xt_conntrack uinput ipt_REJECT snd_seq_dummy snd_hrtimer ip6table_mangle ip6table_nat ip6table_filter ip6_tables
iptable_mangle iptable_nat nf_nat bridge rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace rfkill sunrpc vfat fat snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec
snd_hwdep snd_hda_core rng_core snd_seq input_leds snd_seq_device joydev snd_pcm snd_timer lpc_ich mfd_core rtc_cmos snd pcspkr virtio_input efi_pstore button sch_fq_codel ext4 mbcache jbd2
hid_generic usbhid hid virtio_gpu virtio_dma_buf drm_shmem_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm i2c_core virtio_net net_failover failover virtio_console
virtio_blk crc32_pclmul xhci_pci crc32c_intel xhci_hcd virtio_pci virtio virtio_pci_legacy_dev virtio_pci_modern_dev virtio_ring dm_mirror dm_region_hash dm_log fuse ipv6 autofs4 [last unloaded: ccp]
[  187.584353] CPU: 1 PID: 3835 Comm: CPU 0/KVM Tainted: G    B             5.17.0-BISECT #5
[  187.585784] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  187.587110] RIP: 0010:kvm_mmu_uninit_tdp_mmu+0x47/0x50 [kvm]
[  187.588108] Code: 48 89 e5 48 39 c2 75 21 48 8b 87 40 a3 00 00 48 81 c7 40 a3 00 00 48 39 f8 75 08 e8 f3 c9 c6 e0 5d c3 c3 90 0f 0b 90 eb f2 90 <0f> 0b 90 eb d9 0f 1f 40 00 0f 1f 44 00 00 55 8b 05
50 d8 0f e2 48
[  187.591236] RSP: 0018:ffffc900025cfd58 EFLAGS: 00010283
[  187.592138] RAX: ffffc90002643350 RBX: ffffc9000263a240 RCX: 0000000000000000
[  187.593409] RDX: ffff88810c5e8f18 RSI: ffffffff81a5a96c RDI: ffffc90002639000
[  187.594616] RBP: ffffc900025cfd58 R08: 0000000000000000 R09: 0000000000000000
[  187.595801] R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90002639000
[  187.596996] R13: ffffc90002639000 R14: ffff888104b7a3b0 R15: dead000000000100
[  187.598213] FS:  0000000000000000(0000) GS:ffff888468840000(0000) knlGS:0000000000000000
[  187.599587] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  187.600571] CR2: 0000000000000000 CR3: 0000000108e67000 CR4: 0000000000350ee0
[  187.601789] Call Trace:
[  187.602224]  <TASK>
[  187.602610]  kvm_mmu_uninit_vm+0x22/0x30 [kvm]
[  187.603424]  kvm_arch_destroy_vm+0x135/0x1c0 [kvm]
[  187.604267]  kvm_destroy_vm+0x1a4/0x330 [kvm]
[  187.605058]  kvm_put_kvm+0x26/0x40 [kvm]
[  187.605771]  kvm_vm_release+0x22/0x30 [kvm]
[  187.606521]  __fput+0xa9/0x270
[  187.607051]  ____fput+0xe/0x10
[  187.607591]  task_work_run+0x61/0xa0
[  187.608205]  do_exit+0x3ae/0xc00
[  187.608848]  do_group_exit+0x3b/0xc0
[  187.609472]  __x64_sys_exit_group+0x18/0x20
[  187.610179]  do_syscall_64+0x36/0x80
[  187.610808]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  187.611668] RIP: 0033:0x7fda52300021
[  187.612281] Code: Unable to access opcode bytes at RIP 0x7fda522ffff7.
[  187.613394] RSP: 002b:00007fda4d5c4348 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[  187.614680] RAX: ffffffffffffffda RBX: 00007fda523f8470 RCX: 00007fda52300021
[  187.615892] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
[  187.617098] RBP: 0000000000000001 R08: fffffffffffffb68 R09: 0000000000000000
[  187.618308] R10: 0000000000000020 R11: 0000000000000246 R12: 00007fda523f8470
[  187.619524] R13: 000000000000000f R14: 00007fda523f8948 R15: 0000000000000000
[  187.620744]  </TASK>
[  187.621128] irq event stamp: 0
[  187.621662] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[  187.622732] hardirqs last disabled at (0): [<ffffffff81131499>] copy_process+0xaa9/0x2060
[  187.624116] softirqs last  enabled at (0): [<ffffffff81131499>] copy_process+0xaa9/0x2060
[  187.625575] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  187.626635] ---[ end trace 0000000000000000 ]---


Reloading kvm module also shows these warnings:



[mlevitsk@fedora34 ~]$[  187.567377] ------------[ cut here ]------------
[  187.568245] WARNING: CPU: 1 PID: 3835 at arch/x86/kvm/mmu/tdp_mmu.c:46 kvm_mmu_uninit_tdp_mmu+0x47/0x50 [kvm]
[  187.570145] Modules linked in: kvm_amd ccp kvm irqbypass xt_CHECKSUM xt_MASQUERADE xt_conntrack uinput ipt_REJECT snd_seq_dummy snd_hrtimer ip6table_mangle ip6table_nat ip6table_filter ip6_tables
iptable_mangle iptable_nat nf_nat bridge rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace rfkill sunrpc vfat fat snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec
snd_hwdep snd_hda_core rng_core snd_seq input_leds snd_seq_device joydev snd_pcm snd_timer lpc_ich mfd_core rtc_cmos snd pcspkr virtio_input efi_pstore button sch_fq_codel ext4 mbcache jbd2
hid_generic usbhid hid virtio_gpu virtio_dma_buf drm_shmem_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm i2c_core virtio_net net_failover failover virtio_console
virtio_blk crc32_pclmul xhci_pci crc32c_intel xhci_hcd virtio_pci virtio virtio_pci_legacy_dev virtio_pci_modern_dev virtio_ring dm_mirror dm_region_hash dm_log fuse ipv6 autofs4 [last unloaded: ccp]
[  187.584353] CPU: 1 PID: 3835 Comm: CPU 0/KVM Tainted: G    B             5.17.0-BISECT #5
[  187.585784] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  187.587110] RIP: 0010:kvm_mmu_uninit_tdp_mmu+0x47/0x50 [kvm]
[  187.588108] Code: 48 89 e5 48 39 c2 75 21 48 8b 87 40 a3 00 00 48 81 c7 40 a3 00 00 48 39 f8 75 08 e8 f3 c9 c6 e0 5d c3 c3 90 0f 0b 90 eb f2 90 <0f> 0b 90 eb d9 0f 1f 40 00 0f 1f 44 00 00 55 8b 05
50 d8 0f e2 48
[  187.591236] RSP: 0018:ffffc900025cfd58 EFLAGS: 00010283
[  187.592138] RAX: ffffc90002643350 RBX: ffffc9000263a240 RCX: 0000000000000000
[  187.593409] RDX: ffff88810c5e8f18 RSI: ffffffff81a5a96c RDI: ffffc90002639000
[  187.594616] RBP: ffffc900025cfd58 R08: 0000000000000000 R09: 0000000000000000
[  187.595801] R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90002639000
[  187.596996] R13: ffffc90002639000 R14: ffff888104b7a3b0 R15: dead000000000100
[  187.598213] FS:  0000000000000000(0000) GS:ffff888468840000(0000) knlGS:0000000000000000
[  187.599587] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  187.600571] CR2: 0000000000000000 CR3: 0000000108e67000 CR4: 0000000000350ee0
[  187.601789] Call Trace:
[  187.602224]  <TASK>
[  187.602610]  kvm_mmu_uninit_vm+0x22/0x30 [kvm]
[  187.603424]  kvm_arch_destroy_vm+0x135/0x1c0 [kvm]
[  187.604267]  kvm_destroy_vm+0x1a4/0x330 [kvm]
[  187.605058]  kvm_put_kvm+0x26/0x40 [kvm]
[  187.605771]  kvm_vm_release+0x22/0x30 [kvm]
[  187.606521]  __fput+0xa9/0x270
[  187.607051]  ____fput+0xe/0x10
[  187.607591]  task_work_run+0x61/0xa0
[  187.608205]  do_exit+0x3ae/0xc00
[  187.608848]  do_group_exit+0x3b/0xc0
[  187.609472]  __x64_sys_exit_group+0x18/0x20
[  187.610179]  do_syscall_64+0x36/0x80
[  187.610808]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  187.611668] RIP: 0033:0x7fda52300021
[  187.612281] Code: Unable to access opcode bytes at RIP 0x7fda522ffff7.
[  187.613394] RSP: 002b:00007fda4d5c4348 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
[  187.614680] RAX: ffffffffffffffda RBX: 00007fda523f8470 RCX: 00007fda52300021
[  187.615892] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
[  187.617098] RBP: 0000000000000001 R08: fffffffffffffb68 R09: 0000000000000000
[  187.618308] R10: 0000000000000020 R11: 0000000000000246 R12: 00007fda523f8470
[  187.619524] R13: 000000000000000f R14: 00007fda523f8948 R15: 0000000000000000
[  187.620744]  </TASK>
[  187.621128] irq event stamp: 0
[  187.621662] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[  187.622732] hardirqs last disabled at (0): [<ffffffff81131499>] copy_process+0xaa9/0x2060
[  187.624116] softirqs last  enabled at (0): [<ffffffff81131499>] copy_process+0xaa9/0x2060
[  187.625575] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  187.626635] ---[ end trace 0000000000000000 ]---
[  344.161810] =============================================================================
[  344.164789] BUG kvm_mmu_page_header (Tainted: G    B   W        ): Objects remaining in kvm_mmu_page_header on __kmem_cache_shutdown()
[  344.169042] -----------------------------------------------------------------------------
[  344.169042] 
[  344.172392] Slab 0x0000000054960c26 objects=22 used=1 fp=0x00000000b117b6cb flags=0x7fff00000000200(slab|node=0|zone=1|lastcpupid=0x3fff)
[  344.176757] CPU: 3 PID: 4037 Comm: modprobe Tainted: G    B   W         5.17.0-BISECT #5
[  344.179857] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  344.184111] Call Trace:
[  344.185101]  <TASK>
[  344.185884]  dump_stack_lvl+0x49/0x5e
[  344.187203]  dump_stack+0x10/0x12
[  344.188424]  slab_err+0x95/0xc9
[  344.189585]  __kmem_cache_shutdown.cold+0x38/0x168
[  344.191324]  kmem_cache_destroy+0x55/0x140
[  344.192799]  kvm_mmu_module_exit+0x21/0x40 [kvm]
[  344.194781]  kvm_arch_exit+0x5c/0xb0 [kvm]
[  344.196996]  kvm_exit+0x9a/0xb0 [kvm]
[  344.198421]  svm_exit+0x9/0xe77 [kvm_amd]
[  344.199862]  __do_sys_delete_module.constprop.0+0x188/0x270
[  344.201919]  ? syscall_enter_from_user_mode+0x8d/0x140
[  344.203853]  ? trace_hardirqs_on+0x2a/0xf0
[  344.205333]  __x64_sys_delete_module+0x12/0x20
[  344.206983]  do_syscall_64+0x36/0x80
[  344.208398]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  344.210178] RIP: 0033:0x7f8377ead00b
[  344.211559] Code: 73 01 c3 48 8b 0d 6d 1e 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3d 1e 0c 00 f7
d8 64 89 01 48
[  344.218181] RSP: 002b:00007ffe007de3a8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  344.220769] RAX: ffffffffffffffda RBX: 000056414301cdb0 RCX: 00007f8377ead00b
[  344.223314] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000056414301ce18
[  344.225842] RBP: 000056414301cdb0 R08: 0000000000000000 R09: 0000000000000000
[  344.228519] R10: 00007f8377f20ac0 R11: 0000000000000206 R12: 000056414301ce18
[  344.230988] R13: 0000000000000000 R14: 000056414301ce18 R15: 00007ffe007e06b8
[  344.233529]  </TASK>
[  344.234291] Object 0x00000000a24c1b47 @offset=3864
[  344.236078] ------------[ cut here ]------------
[  344.237842] kmem_cache_destroy kvm_mmu_page_header: Slab cache still has objects when called from kvm_mmu_module_exit+0x21/0x40 [kvm]
[  344.237923] WARNING: CPU: 3 PID: 4037 at mm/slab_common.c:502 kmem_cache_destroy+0x133/0x140
[  344.246110] Modules linked in: kvm_amd(-) ccp kvm irqbypass xt_CHECKSUM xt_MASQUERADE xt_conntrack uinput ipt_REJECT snd_seq_dummy snd_hrtimer ip6table_mangle ip6table_nat ip6table_filter
ip6_tables iptable_mangle iptable_nat nf_nat bridge rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace rfkill sunrpc vfat fat snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg
snd_hda_codec snd_hwdep snd_hda_core rng_core snd_seq input_leds snd_seq_device joydev snd_pcm snd_timer lpc_ich mfd_core rtc_cmos snd pcspkr virtio_input efi_pstore button sch_fq_codel ext4 mbcache
jbd2 hid_generic usbhid hid virtio_gpu virtio_dma_buf drm_shmem_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm i2c_core virtio_net net_failover failover virtio_console
virtio_blk crc32_pclmul xhci_pci crc32c_intel xhci_hcd virtio_pci virtio virtio_pci_legacy_dev virtio_pci_modern_dev virtio_ring dm_mirror dm_region_hash dm_log fuse ipv6 autofs4 [last unloaded: ccp]
[  344.263589] CPU: 3 PID: 4037 Comm: modprobe Tainted: G    B   W         5.17.0-BISECT #5
[  344.265177] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  344.266563] RIP: 0010:kmem_cache_destroy+0x133/0x140
[  344.267461] Code: e7 e8 a1 ba 06 00 e9 21 ff ff ff c3 90 49 8b 54 24 58 48 8b 4d 08 48 c7 c6 00 c8 03 82 48 c7 c7 20 b4 2e 82 e8 33 d1 69 00 90 <0f> 0b 90 90 e9 f9 fe ff ff 0f 1f 40 00 55 48 89 e5
41 57 49 89 ff
[  344.270738] RSP: 0018:ffffc90002973e68 EFLAGS: 00010286
[  344.271672] RAX: 0000000000000000 RBX: 0000000000000040 RCX: 0000000000000000
[  344.272940] RDX: 0000000000000001 RSI: ffffffff822d34b8 RDI: 00000000ffffffff
[  344.274180] RBP: ffffc90002973e80 R08: ffff8884687fffe8 R09: 0000000000013ffb
[  344.275479] R10: ffff888468640000 R11: 3fffffffffffffff R12: ffff88810d2e6600
[  344.276877] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  344.278102] FS:  00007f8377d80b80(0000) GS:ffff8884688c0000(0000) knlGS:0000000000000000
[  344.279637] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  344.280684] CR2: 0000565399780ff8 CR3: 0000000111f88000 CR4: 0000000000350ee0
[  344.282021] Call Trace:
[  344.282455]  <TASK>
[  344.282948]  kvm_mmu_module_exit+0x21/0x40 [kvm]
[  344.283794]  kvm_arch_exit+0x5c/0xb0 [kvm]
[  344.284577]  kvm_exit+0x9a/0xb0 [kvm]
[  344.285403]  svm_exit+0x9/0xe77 [kvm_amd]
[  344.286126]  __do_sys_delete_module.constprop.0+0x188/0x270
[  344.287090]  ? syscall_enter_from_user_mode+0x8d/0x140
[  344.288022]  ? trace_hardirqs_on+0x2a/0xf0
[  344.288746]  __x64_sys_delete_module+0x12/0x20
[  344.289612]  do_syscall_64+0x36/0x80
[  344.290218]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  344.291153] RIP: 0033:0x7f8377ead00b
[  344.291876] Code: 73 01 c3 48 8b 0d 6d 1e 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3d 1e 0c 00 f7
d8 64 89 01 48
[  344.295115] RSP: 002b:00007ffe007de3a8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  344.296601] RAX: ffffffffffffffda RBX: 000056414301cdb0 RCX: 00007f8377ead00b
[  344.297899] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000056414301ce18
[  344.299145] RBP: 000056414301cdb0 R08: 0000000000000000 R09: 0000000000000000
[  344.300490] R10: 00007f8377f20ac0 R11: 0000000000000206 R12: 000056414301ce18
[  344.301805] R13: 0000000000000000 R14: 000056414301ce18 R15: 00007ffe007e06b8
[  344.303042]  </TASK>
[  344.303459] irq event stamp: 0
[  344.304104] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[  344.305179] hardirqs last disabled at (0): [<ffffffff81131499>] copy_process+0xaa9/0x2060
[  344.306708] softirqs last  enabled at (0): [<ffffffff81131499>] copy_process+0xaa9/0x2060
[  344.308234] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  344.309358] ---[ end trace 0000000000000000 ]---


This happens while running a nested guest, and the print is from the guest.
Host is running all my nested AVIC patches, but that should not matter,
since I disabled AVIC in the guest.

I will test it on vanilla host as well.


Best regards,
	Maxim Levitsky

> 
> 
> [  304.367317] WARNING: CPU: 1 PID: 5460 at arch/x86/kvm/mmu/tdp_mmu.c:57 kvm_mmu_uninit_tdp_mmu+0x55/0x60 [kvm]
> [  304.368751] Modules linked in: kvm_amd(O) ccp kvm(O) irqbypass xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT uinput snd_seq_dummy snd_hrtimer ip6table_mangle ip6table_nat ip6table_filter
> ip6_tables iptable_mangle iptable_nat nf_nat bridge rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace rfkill sunrpc vfat fat snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg
> snd_hda_codec snd_hwdep snd_hda_core rng_core snd_seq snd_seq_device input_leds snd_pcm joydev snd_timer snd lpc_ich mfd_core virtio_input efi_pstore pcspkr rtc_cmos button sch_fq_codel ext4 mbcache
> jbd2 hid_generic usbhid hid virtio_gpu virtio_dma_buf drm_shmem_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops virtio_blk virtio_net drm net_failover virtio_console failover
> i2c_core crc32_pclmul crc32c_intel xhci_pci xhci_hcd virtio_pci virtio virtio_pci_legacy_dev virtio_pci_modern_dev virtio_ring dm_mirror dm_region_hash dm_log fuse ipv6 autofs4 [last unloaded: ccp]
> [  304.383703] CPU: 1 PID: 5460 Comm: CPU 6/KVM Tainted: G        W  O      5.18.0-rc4.unstable #5
> [  304.384804] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> [  304.385659] RIP: 0010:kvm_mmu_uninit_tdp_mmu+0x55/0x60 [kvm]
> [  304.386302] Code: 8d 83 28 a4 00 00 48 39 c2 75 1e 48 8b 83 18 a4 00 00 48 81 c3 18 a4 00 00 48 39 d8 75 11 e8 52 d5 8d e0 48 8b 5d f8 c9 c3 90 <0f> 0b 90 eb dc 90 0f 0b 90 eb e9 0f 1f 44 00 00 55
> 8b 05 a0 c3 d6
> [  304.388246] RSP: 0018:ffffc90003503bf0 EFLAGS: 00010293
> [  304.388807] RAX: ffffc900034cb428 RBX: ffffc900034c1000 RCX: 0000000000000000
> [  304.389561] RDX: ffff888120446c80 RSI: ffffffff8115e949 RDI: ffffffff81a6ee08
> [  304.390315] RBP: ffffc90003503bf8 R08: 0000000000000000 R09: 0000000000000000
> [  304.391078] R10: 0000000000000394 R11: 0000000000000386 R12: ffffc900034c1000
> [  304.391818] R13: ffffc900034c1000 R14: ffff888113d8b728 R15: dead000000000100
> [  304.392573] FS:  0000000000000000(0000) GS:ffff88846ce40000(0000) knlGS:0000000000000000
> [  304.393430] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  304.394050] CR2: 0000000000000000 CR3: 0000000002c21000 CR4: 0000000000350ee0
> [  304.394805] Call Trace:
> [  304.395086]  <TASK>
> [  304.395315]  kvm_mmu_uninit_vm+0x22/0x30 [kvm]
> [  304.395821]  kvm_arch_destroy_vm+0x135/0x1c0 [kvm]
> [  304.396365]  kvm_destroy_vm+0x19d/0x310 [kvm]
> [  304.396858]  kvm_put_kvm+0x26/0x40 [kvm]
> [  304.397390]  kvm_vm_release+0x22/0x30 [kvm]
> [  304.397865]  __fput+0xa5/0x270
> [  304.398207]  ____fput+0xe/0x10
> [  304.398532]  task_work_run+0x61/0xb0
> [  304.398913]  do_exit+0x3a9/0xb60
> [  304.399286]  do_group_exit+0x3b/0xc0
> [  304.399676]  get_signal+0xd9c/0xde0
> [  304.400062]  arch_do_signal_or_restart+0x37/0x790
> [  304.400576]  ? do_futex+0x8a/0x150
> [  304.400950]  exit_to_user_mode_prepare+0x152/0x240
> [  304.401603]  syscall_exit_to_user_mode+0x1f/0x60
> [  304.402230]  do_syscall_64+0x44/0x80
> [  304.402690]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  304.408493] RIP: 0033:0x7f593c746a8a
> [  304.408887] Code: Unable to access opcode bytes at RIP 0x7f593c746a60.
> [  304.409589] RSP: 002b:00007f59348ed5a0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> [  304.410407] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007f593c746a8a
> [  304.411365] RDX: 0000000000000000 RSI: 0000000000000189 RDI: 000055f11c7f4fe8
> [  304.411366] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000ffffffff
> [  304.411367] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [  304.411368] R13: 000055f11c7f4fe8 R14: 0000000000000000 R15: 0000000000000000
> [  304.411371]  </TASK>
> [  304.414745] irq event stamp: 0
> [  304.415086] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [  304.415762] hardirqs last disabled at (0): [<ffffffff811339cb>] copy_process+0x94b/0x1ec0
> [  304.416628] softirqs last  enabled at (0): [<ffffffff811339cb>] copy_process+0x94b/0x1ec0
> [  304.417510] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [  304.418186] ---[ end trace 0000000000000000 ]---
> 
> 
> Best regards,
> 	Maxim Levitsky


