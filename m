Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD6733230
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 15:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241782AbjFPNar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 09:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjFPNao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 09:30:44 -0400
Received: from h7.fbrelay.privateemail.com (h7.fbrelay.privateemail.com [162.0.218.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7B93592;
        Fri, 16 Jun 2023 06:30:42 -0700 (PDT)
Received: from MTA-08-3.privateemail.com (unknown [198.54.122.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by h7.fbrelay.privateemail.com (Postfix) with ESMTPSA id 32AFF60605;
        Fri, 16 Jun 2023 09:30:36 -0400 (EDT)
Received: from mta-08.privateemail.com (localhost [127.0.0.1])
        by mta-08.privateemail.com (Postfix) with ESMTP id 0A23818000AA;
        Fri, 16 Jun 2023 09:30:34 -0400 (EDT)
Received: from [192.168.2.177] (unknown [174.93.80.116])
        by mta-08.privateemail.com (Postfix) with ESMTPA id 330F918000B0;
        Fri, 16 Jun 2023 09:30:30 -0400 (EDT)
Date:   Fri, 16 Jun 2023 09:30:20 -0400
From:   Hamza Mahfooz <someguy@effective-light.com>
Subject: Re: KVM page-fault on Kernel 6.3.8
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     kvm@vger.kernel.org, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org
Message-Id: <KILCWR.RYN9YNJ7Y2UK@effective-light.com>
In-Reply-To: <ZIxaRLIfCQ6IK8S1@debian.me>
References: <L2ZBWR.TERFR10NPZ281@effective-light.com>
        <ZIxaRLIfCQ6IK8S1@debian.me>
X-Mailer: geary/43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Fri, Jun 16 2023 at 07:49:08 PM +07:00:00, Bagas Sanjaya 
<bagasdotme@gmail.com> wrote:
> On Fri, Jun 16, 2023 at 01:25:33AM -0400, Hamza Mahfooz wrote:
>>  I am seeing the following page-fault on the latest stable kernel:
>> 
>>  BUG: unable to handle page fault for address: ffffb4ff0cd20034
>>  #PF: supervisor read access in kernel mode
>>  #PF: error_code(0x0000) - not-present page
>>  PGD 10002a067 P4D 10002a067 PUD 0
>>  Oops: 0000 [#1] PREEMPT SMP NOPTI
>>  CPU: 7 PID: 2675 Comm: CPU 7/KVM Not tainted 6.3.8-arch1-1 #1
>>  a1d299e746aebdb27c523dd3bd94aba6f54915c7
>>  Hardware name: ASUS System Product Name/ProArt X670E-CREATOR WIFI, 
>> BIOS 1303
>>  04/27/2023
>>  RIP: 0010:try_grab_folio+0x14f/0x370
>>  Code: 83 f8 04 75 6f 44 89 ee 4c 89 e7 e8 6b bc 0b 00 84 c0 74 60 
>> 4c 8b 63
>>  08 41 f6 c4 01 0f 85 b0 01 00 00 0f 1f 44 00 00 49 89 dc <41> 8b 44 
>> 24 34 85
>>  c0 0f 88 f8 00 00 00 41 8b 44 24 34 85 c0 74 58
>>  RSP: 0018:ffff9fa98504b948 EFLAGS: 00010086
>>  RAX: 0000000000000002 RBX: fffff4ff0cd21480 RCX: 0000000000000000
>>  RDX: 0000000000000003 RSI: 0000000000000001 RDI: fffff4ff0cd21480
>>  RBP: 0000000000000000 R08: ffff8b2edb510980 R09: 00007f5624253000
>>  R10: 80000003348008e7 R11: 00007f5624253000 R12: ffffb4ff0cd20000
>>  R13: 0000000000000001 R14: 0000000000000003 R15: 0000000000000001
>>  FS: 00007f548a7fc6c0(0000) GS:ffff8b35f83c0000(0000) 
>> knlGS:0000000000000000
>>  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>  CR2: ffffb4ff0cd20034 CR3: 0000000113e70000 CR4: 0000000000750ee0
>>  PKRU: 55555554
>>  Call Trace:
>>  <TASK>
>>  ? __die+0x23/0x70
>>  ? page_fault_oops+0x171/0x4e0
>>  ? exc_page_fault+0x172/0x180
>>  ? asm_exc_page_fault+0x26/0x30
>>  ? try_grab_folio+0x14f/0x370
>>  internal_get_user_pages_fast+0x883/0x1150
>>  __iov_iter_get_pages_alloc+0xdd/0x780
>>  ? kmem_cache_alloc+0x16f/0x330
>>  ? bio_associate_blkg_from_css+0xcd/0x340
>>  iov_iter_get_pages+0x1d/0x40
>>  bio_iov_iter_get_pages+0xa1/0x480
>>  __blkdev_direct_IO_async+0xc5/0x1b0
>>  blkdev_read_iter+0x127/0x1d0
>>  aio_read+0x132/0x210
>>  ? io_submit_one+0x46a/0x8b0
>>  io_submit_one+0x46a/0x8b0
>>  ? kvm_arch_vcpu_put+0x128/0x190 [kvm
>>  711ceda1c40511ce22d1f99f4e9e574def76b25e]
>>  ? kvm_arch_vcpu_ioctl_run+0x579/0x1770 [kvm
>>  711ceda1c40511ce22d1f99f4e9e574def76b25e]
>>  __x64_sys_io_submit+0xad/0x190
>>  do_syscall_64+0x5d/0x90
>>  ? __x64_sys_ioctl+0xac/0xd0
>>  ? syscall_exit_to_user_mode+0x1b/0x40
>>  ? do_syscall_64+0x6c/0x90
>>  ? syscall_exit_to_user_mode+0x1b/0x40
>>  ? do_syscall_64+0x6c/0x90
>>  ? syscall_exit_to_user_mode+0x1b/0x40
>>  ? do_syscall_64+0x6c/0x90
>>  ? syscall_exit_to_user_mode+0x1b/0x40
>>  ? do_syscall_64+0x6c/0x90
>>  ? do_syscall_64+0x6c/0x90
>>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>  RIP: 0033:0x7f57ac0912ed
>>  Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 
>> 48 89 f7
>>  48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 
>> f0 ff ff
>>  73 01 c3 48 8b 0d 3b 7a 0d 00 f7 d8 64 89 01 48
>>  RSP: 002b:00007f5427ab97b8 EFLAGS: 00000246 ORIG_RAX: 
>> 00000000000000d1
>>  RAX: ffffffffffffffda RBX: 00007f548a7fc1d0 RCX: 00007f57ac0912ed
>>  RDX: 00007f5427ab9800 RSI: 0000000000000001 RDI: 00007f57a9d24000
>>  RBP: 00007f57a9d24000 R08: 0000000000000001 R09: 0000000000000001
>>  R10: 00007f54740044f0 R11: 0000000000000246 R12: 0000000000000001
>>  R13: 0000000000000004 R14: 00007f5427ab9800 R15: 000000000000000e
>>  </TASK>
>>  Modules linked in: hid_playstation led_class_multicolor ff_memless 
>> tun
>>  snd_seq_dummy snd_hrtimer snd_seq xt_CHECKSUM xt_MASQUERADE 
>> xt_conntrack
>>  ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_nat nf_nat
>>  nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables libcrc32c 
>> nfnetlink
>>  bridge stp llc vfat fat snd_hda_codec_realtek snd_hda_codec_generic 
>> mt7921e
>>  snd_hda_codec_hdmi mt7921_common snd_usb_audio intel_rapl_msr
>>  mt76_connac_lib snd_hda_intel intel_rapl_common snd_intel_dspcfg 
>> mt76
>>  snd_usbmidi_lib btusb snd_intel_sdw_acpi edac_mce_amd snd_rawmidi 
>> btrtl
>>  snd_hda_codec btbcm snd_seq_device btintel snd_hda_core kvm_amd mc 
>> snd_hwdep
>>  eeepc_wmi btmtk snd_pcm asus_wmi kvm mac80211 bluetooth 
>> ledtrig_audio
>>  atlantic snd_timer i8042 sparse_keymap libarc4 ecdh_generic rapl
>>  platform_profile serio intel_wmi_thunderbolt i2c_piix4 wmi_bmof 
>> pcspkr
>>  k10temp thunderbolt snd igc ucsi_acpi macsec soundcore cfg80211 
>> typec_ucsi
>>  mousedev joydev typec roles rfkill gpio_amdpt acpi_cpufreq 
>> gpio_generic
>>  mac_hid dm_multipath
>>  crypto_user fuse loop bpf_preload ip_tables x_tables ext4 
>> crc32c_generic
>>  crc16 mbcache jbd2 dm_crypt cbc encrypted_keys trusted asn1_encoder 
>> tee
>>  dm_mod hid_logitech_hidpp hid_logitech_dj usbhid amdgpu 
>> crct10dif_pclmul
>>  crc32_pclmul crc32c_intel polyval_clmulni polyval_generic 
>> i2c_algo_bit
>>  drm_ttm_helper gf128mul nvme ghash_clmulni_intel ttm sha512_ssse3 
>> drm_buddy
>>  aesni_intel gpu_sched crypto_simd nvme_core drm_display_helper 
>> cryptd ccp
>>  xhci_pci cec nvme_common xhci_pci_renesas video wmi vfio_pci 
>> vfio_pci_core
>>  irqbypass vfio_iommu_type1 vfio iommufd
>>  CR2: ffffb4ff0cd20034
>>  ---[ end trace 0000000000000000 ]---
>>  RIP: 0010:try_grab_folio+0x14f/0x370
>>  Code: 83 f8 04 75 6f 44 89 ee 4c 89 e7 e8 6b bc 0b 00 84 c0 74 60 
>> 4c 8b 63
>>  08 41 f6 c4 01 0f 85 b0 01 00 00 0f 1f 44 00 00 49 89 dc <41> 8b 44 
>> 24 34 85
>>  c0 0f 88 f8 00 00 00 41 8b 44 24 34 85 c0 74 58
>>  RSP: 0018:ffff9fa98504b948 EFLAGS: 00010086
>>  RAX: 0000000000000002 RBX: fffff4ff0cd21480 RCX: 0000000000000000
>>  RDX: 0000000000000003 RSI: 0000000000000001 RDI: fffff4ff0cd21480
>>  RBP: 0000000000000000 R08: ffff8b2edb510980 R09: 00007f5624253000
>>  R10: 80000003348008e7 R11: 00007f5624253000 R12: ffffb4ff0cd20000
>>  R13: 0000000000000001 R14: 0000000000000003 R15: 0000000000000001
>>  FS: 00007f548a7fc6c0(0000) GS:ffff8b35f83c0000(0000) 
>> knlGS:0000000000000000
>>  CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>  CR2: ffffb4ff0cd20034 CR3: 0000000113e70000 CR4: 0000000000750ee0
>>  PKRU: 55555554
>>  note: CPU 7/KVM[2675] exited with irqs disabled
>> 
>>  It seems to appear randomly, so bisecting it would probably be
>>  difficult. Also, as far as I can tell it seems to be a recent
>>  regression (i.e. it was introduced in one of the 6.3.y releases).
>> 
>> 
> 
> So v6.2.y looks fine (doesn't have this regression)?

Yes, I didn't see this issue on v6.2.y.

> 
> --
> An old man doll... just what I always wanted! - Clara


