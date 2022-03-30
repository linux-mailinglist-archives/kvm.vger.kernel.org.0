Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099794EC4E0
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344515AbiC3MtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345719AbiC3MsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A32A3DE0BD
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 05:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648644381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cY9iRrSyIjyr8eHAHOFNCcuwIKiRiHCTr2xUfjfq6G4=;
        b=M2wFO3zOGYSa1C2zd2AKyob4Py9EfrV2gP+9GwWyFrTFdj9jx47QdAcE7DHVa6ZHlpxrV4
        bP/nvkQWCBSQ66C+EEdZmFT6/z+nLOaw2R5S/tL0+PzcZsiwK+kU7Vj58AoKLTolJjN7kG
        IkECnFdXilkYZHwF+WMB7OvypSvkbSg=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-AOAeiIsoMGOYyRFg08rK4w-1; Wed, 30 Mar 2022 08:46:20 -0400
X-MC-Unique: AOAeiIsoMGOYyRFg08rK4w-1
Received: by mail-lj1-f199.google.com with SMTP id h4-20020a2ea484000000b002480c04898aso8725289lji.6
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 05:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cY9iRrSyIjyr8eHAHOFNCcuwIKiRiHCTr2xUfjfq6G4=;
        b=eCu4q3hEvnvIbf7+skFNVe9NbFyw8FAQ82usFmYZhmTUkC7DsB9pgnEh5hpZPH1XyE
         GKN8uHPcxCl3Eb1d0Wb3npDGn8RK/NEaIxjy1uj2z/ryXejL0iRWmP038fH0horxHD7a
         Ocme1TmVlTtWLM8/tDnAC6pxigIiY8guKCry/2p5UqbfpP8vBA8sGJ8gnA0cD2nf51fj
         dyf7DxuEagZzQ4Oj8RsMc5Lgy4Q93AexV9CwOegrK9thYfdJkcrt/3R9JNYdMoL5sytV
         sbTNDmRTWhTpYblkR7J0lfd6Cjj580QNn3WRcqvfHJecC7QoPNxzEK2HEM88DjOm90mH
         E4iw==
X-Gm-Message-State: AOAM531JvorDKn8JUHOvz+rcTOjZKeWh7IT2rTLS/6kGYwVpvJLMMSXg
        ac1wTtmsVXP3Abkqkiv3aR+Ugi0dR92jzHRi+By7Zb5M427g0TJyiW3OJ7lyuidSBSeRz94pCoK
        xbUugp+gHuxBCAQNmkInNoD+knwTY
X-Received: by 2002:a19:3801:0:b0:444:150b:9ef5 with SMTP id f1-20020a193801000000b00444150b9ef5mr6417030lfa.523.1648644378763;
        Wed, 30 Mar 2022 05:46:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxohcZvDmrCT7SVJwea3bV7ZiKnRdT3t2ScVn6wDOH/YuLWQwKIoTgNBTNByfkbi2NYVhuUrmZGN0KTa9eQDF8=
X-Received: by 2002:a19:3801:0:b0:444:150b:9ef5 with SMTP id
 f1-20020a193801000000b00444150b9ef5mr6417016lfa.523.1648644378499; Wed, 30
 Mar 2022 05:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <CA+QYu4q7K-pkAbMt3br_7O-Lu2OWyieLfyiju0PNEiy5YdKYzg@mail.gmail.com>
In-Reply-To: <CA+QYu4q7K-pkAbMt3br_7O-Lu2OWyieLfyiju0PNEiy5YdKYzg@mail.gmail.com>
From:   Jan Stancek <jstancek@redhat.com>
Date:   Wed, 30 Mar 2022 14:46:02 +0200
Message-ID: <CAASaF6yhTpXcWhTyg5VSU6czPPws5+sQ3vR7AWC8xxM7Xm_BGg@mail.gmail.com>
Subject: Re: RIP: 0010:param_get_bool.cold+0x0/0x2 - LTP read_all_sys - 5.17.0
To:     Bruno Goncalves <bgoncalv@redhat.com>, kvm <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Li Wang <liwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+CC kvm

Issue seems to be that nx_huge_pages is not initialized (-1) and
attempted to be used as boolean when reading
/sys/module/kvm/parameters/nx_huge_pages

CONFIG_KVM=Y,  CONFIG_UBSAN=y, but kvm_mmu_module_init() doesn't
appear to run, since kvm detects no HW support:
# dmesg |grep kvm
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000003] kvm-clock: using sched offset of 1155425753112 cycles
[    0.000007] clocksource: kvm-clock: mask: 0xffffffffffffffff
max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.045066] kvm-guest: PV spinlocks enabled
[    0.705370] clocksource: Switched to clocksource kvm-clock
[    0.913593] kvm: no hardware support for 'kvm_intel'
[    0.915574] kvm: no hardware support for 'kvm_amd'
[    2.284925] systemd[1]: Detected virtualization kvm.
[    4.158909] Stack Depot allocating hash table with kvmalloc
[    8.120446] systemd[1]: Detected virtualization kvm.

Initializing 'nx_huge_pages' to 0 (in out branch) or write to
/sys/module/kvm/parameters/nx_huge_pages before read makes it go away
too:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 02cf0a7e1d14..b3b8b9a22e20 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8921,6 +8921,7 @@ int kvm_arch_init(void *opaque)
 out_free_x86_emulator_cache:
        kmem_cache_destroy(x86_emulator_cache);
 out:
+       nx_huge_pages = 0;
        return r;
 }

On Mon, Mar 28, 2022 at 4:10 PM Bruno Goncalves <bgoncalv@redhat.com> wrote:
>
> Hello,
>
> We've observed the panic below when testing mainline kernel. More logs
> can be found on [1] and CKI tracker [2].
>
> [12057.972471] LTP: starting read_all_sys (read_all -d /sys -q -r 3)
> [12062.975732] zram: Added device: zram1
> [12062.980426] zram: Added device: zram2
> [12062.983235] zram: Added device: zram3
> [12063.510331] WARNING! power/level is deprecated; use power/control instead
> [12064.466740] bdi 1:2: the stable_pages_required attribute has been
> removed. Use the stable_writes queue attribute instead.
> [12066.625736] invalid opcode: 0000 [#1] PREEMPT SMP PTI
> [12066.626556] CPU: 0 PID: 128980 Comm: read_all Tainted: G
> OE     5.17.0 #1
> [12066.627745] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [12066.628608] RIP: 0010:param_get_bool.cold+0x0/0x2
> [12066.629356] Code: 3b ff e9 55 f8 3d ff 48 8b 75 00 8d 51 ff 48 c7
> c7 60 47 84 af e8 2a 69 00 00 b8 e4 ff ff ff e9 89 fb 3d ff 0f 0b 0f
> 0b 0f 0b <0f> 0b 0f 0b 48 8b 33 48 c7 c7 88 47 84 af e8 07 69 00 00 b8
> e4 ff
> [12066.632133] RSP: 0018:ffffa97d4114fd18 EFLAGS: 00010282
> [12066.632929] RAX: ffffffffb04806ec RBX: ffff98d640277eb8 RCX: 0000000000000000
> [12066.634051] RDX: 0000000000000000 RSI: ffffffffafa11810 RDI: ffff98d67b1df000
> [12066.635108] RBP: ffff98d6403e6d80 R08: ffff98d668d48e50 R09: 00000000473bf681
> [12066.636188] R10: ffffa97d4114fd20 R11: 000000001473bf68 R12: ffff98d67b1df000
> [12066.637229] R13: ffffffffb008b5e0 R14: 0000000000000001 R15: 0000000000000001
> [12066.638296] FS:  00007f26a5fcb740(0000) GS:ffff98d67bc00000(0000)
> knlGS:0000000000000000
> [12066.639533] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [12066.640371] CR2: 0000000002290008 CR3: 0000000103a46005 CR4: 00000000003706f0
> [12066.641403] DR0: 000000000042c9f0 DR1: 0000000000000000 DR2: 0000000000000000
> [12066.642467] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [12066.643712] Call Trace:
> [12066.644114]  <TASK>
> [12066.644433]  param_attr_show+0x57/0x90
> [12066.645036]  module_attr_show+0x1c/0x30
> [12066.645599]  sysfs_kf_seq_show+0xac/0xf0
> [12066.646221]  seq_read_iter+0x126/0x460
> [12066.646819]  new_sync_read+0x112/0x1a0
> [12066.647418]  vfs_read+0x169/0x1c0
> [12066.647951]  ksys_read+0x6c/0xf0
> [12066.648460]  do_syscall_64+0x5b/0x80
> [12066.649055]  ? do_syscall_64+0x67/0x80
> [12066.649605]  ? do_syscall_64+0x67/0x80
> [12066.650190]  ? do_syscall_64+0x67/0x80
> [12066.650777]  ? lockdep_hardirqs_on+0x7d/0x100
> [12066.651453]  ? do_syscall_64+0x67/0x80
> [12066.652041]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
> [12066.652852]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
> [12066.653640]  ? lockdep_hardirqs_on+0x7d/0x100
> [12066.654315]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [12066.655088] RIP: 0033:0x7f26a5d05742
> [12066.655828] Code: c0 e9 b2 fe ff ff 50 48 8d 3d 1a cf 0b 00 e8 f5
> f5 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75
> 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89
> 54 24
> [12066.658663] RSP: 002b:00007ffc0c869f08 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000000
> [12066.662974] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f26a5d05742
> [12066.664041] RDX: 00000000000003ff RSI: 00007ffc0c86a3b0 RDI: 0000000000000003
> [12066.665101] RBP: 00007f26a5fd3000 R08: 0000000000000000 R09: 00007ffc0c8696a0
> [12066.666167] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000042d790
> [12066.667208] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [12066.668278]  </TASK>
> [12066.668611] Modules linked in: vfio_iommu_type1 vfio vhost_net tap
> vhost_vsock vhost vhost_iotlb snd_seq_dummy minix binfmt_misc vcan
> can_raw nfsv3 nfs_acl nfs lockd grace fscache netfs rds btrfs raid6_pq
> zstd_compress tun brd exfat vfat fat vsock_loopback
> vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock
> vmw_vmci can_bcm can n_gsm pps_ldisc ppp_synctty mkiss ax25 ppp_async
> ppp_generic serport slcan slip slhc snd_hrtimer snd_seq snd_seq_device
> sctp pcrypt crypto_user algif_hash n_hdlc tls rfkill intel_rapl_msr
> sunrpc snd_hda_codec_generic ledtrig_audio intel_rapl_common
> snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec
> snd_hda_core 8139too snd_hwdep snd_pcm joydev virtio_balloon pcspkr
> snd_timer snd 8139cp soundcore mii i2c_piix4 fuse zram xfs
> crct10dif_pclmul crc32_pclmul crc32c_intel qxl drm_ttm_helper
> ghash_clmulni_intel ttm drm_kms_helper drm virtio_console virtio_blk
> serio_raw ata_generic pata_acpi floppy qemu_fw_cfg [last unloaded:
> ltp_insmod01]
> [12066.681725] ---[ end trace 0000000000000000 ]---
> [12066.682447] RIP: 0010:param_get_bool.cold+0x0/0x2
> [12066.683197] Code: 3b ff e9 55 f8 3d ff 48 8b 75 00 8d 51 ff 48 c7
> c7 60 47 84 af e8 2a 69 00 00 b8 e4 ff ff ff e9 89 fb 3d ff 0f 0b 0f
> 0b 0f 0b <0f> 0b 0f 0b 48 8b 33 48 c7 c7 88 47 84 af e8 07 69 00 00 b8
> e4 ff
> [12066.685965] RSP: 0018:ffffa97d4114fd18 EFLAGS: 00010282
> [12066.686804] RAX: ffffffffb04806ec RBX: ffff98d640277eb8 RCX: 0000000000000000
> [12066.687885] RDX: 0000000000000000 RSI: ffffffffafa11810 RDI: ffff98d67b1df000
> [12066.688958] RBP: ffff98d6403e6d80 R08: ffff98d668d48e50 R09: 00000000473bf681
> [12066.690037] R10: ffffa97d4114fd20 R11: 000000001473bf68 R12: ffff98d67b1df000
> [12066.691165] R13: ffffffffb008b5e0 R14: 0000000000000001 R15: 0000000000000001
> [12066.692288] FS:  00007f26a5fcb740(0000) GS:ffff98d67bc00000(0000)
> knlGS:0000000000000000
> [12066.693506] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [12066.694349] CR2: 0000000002290008 CR3: 0000000103a46005 CR4: 00000000003706f0
> [12066.695417] DR0: 000000000042c9f0 DR1: 0000000000000000 DR2: 0000000000000000
> [12066.696486] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [12066.697557] Kernel panic - not syncing: Fatal exception
> [12066.699020] Kernel Offset: 0x2d000000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [12066.700938] ---[ end Kernel panic - not syncing: Fatal exception ]---
>
> [1] https://datawarehouse.cki-project.org/kcidb/tests/2924662
> [2] https://datawarehouse.cki-project.org/issue/1078
>
> Thanks,
> Bruno Goncalves
>

