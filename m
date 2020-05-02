Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD8E1C25F7
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 15:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgEBN6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 09:58:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41739 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727992AbgEBN6c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 May 2020 09:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588427910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ESS5rOuW2BzSw9OBT5+3Gc3Aet+QYHhLhgxUjYGmRL4=;
        b=RmMIvHbuEFuhZQatJfSbhh6VxtHyQ2tjQW/m3LD6mxrvP5d8aP8mGF+nzbaGXSYjdndLJY
        eoiRTGdnNLCf3IJOAOKdkwRW6IGDY6tVEUFDW1ug9xNr3YRrJPx+/AHb83cMT3SjE3zAVD
        a4ZXmbAO6yyt7Rea6Kvh+56F1glx7GE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-lkSPadkdMESp93m96k5qoQ-1; Sat, 02 May 2020 09:58:16 -0400
X-MC-Unique: lkSPadkdMESp93m96k5qoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC03F1800D4A;
        Sat,  2 May 2020 13:58:15 +0000 (UTC)
Received: from starship (unknown [10.35.206.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8380538A;
        Sat,  2 May 2020 13:58:14 +0000 (UTC)
Message-ID: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
Subject: AVIC related warning in enable_irq_window
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Date:   Sat, 02 May 2020 16:58:13 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

On kernel 5.7-rc3 I get the following warning when I boot a windows 10 VM with AVIC enabled
 
[ 6702.706124] WARNING: CPU: 0 PID: 118232 at arch/x86/kvm/svm/svm.c:1372 enable_irq_window+0x6a/0xa0 [kvm_amd]
[ 6702.706124] Modules linked in: vfio_pci vfio_virqfd vfio_iommu_type1 vfio vhost_net vhost vhost_iotlb tap kvm_amd kvm irqbypass hfsplus ntfs msdos xfs hidp ccm rfcomm xt_MASQUERADE xt_conntrack
ipt_REJECT iptable_mangle iptable_nat nf_nat ebtable_filter ebtables ip6table_filter ip6_tables tun bridge pmbus ee1004 pmbus_core jc42 cmac bnep sunrpc nls_iso8859_1 nls_cp437 vfat fat dm_mirror
dm_region_hash dm_log nvidia_uvm(O) ucsi_ccg typec_ucsi typec wmi_bmof mxm_wmi iwlmvm mac80211 edac_mce_amd edac_core libarc4 joydev nvidia(PO) iwlwifi btusb btrtl input_leds btbcm btintel
snd_hda_codec_hdmi bluetooth snd_usb_audio cdc_acm xpad snd_hda_intel cfg80211 snd_usbmidi_lib ff_memless snd_intel_dspcfg snd_rawmidi snd_hda_codec mc ecdh_generic snd_hwdep snd_seq ecc snd_hda_core
thunderbolt rfkill i2c_nvidia_gpu pcspkr efi_pstore snd_seq_device bfq snd_pcm snd_timer snd zenpower i2c_piix4 rtc_cmos tpm_crb tpm_tis tpm_tis_core wmi tpm button binfmt_misc ext4 mbcache jbd2
dm_crypt sd_mod uas
[ 6702.706146]  usb_storage hid_generic usbhid hid crc32_pclmul amdgpu crc32c_intel gpu_sched ttm drm_kms_helper cfbfillrect ahci syscopyarea libahci cfbimgblt sysfillrect libata sysimgblt igb
fb_sys_fops ccp cfbcopyarea i2c_algo_bit cec rng_core xhci_pci nvme xhci_hcd drm nvme_core drm_panel_orientation_quirks t10_pi it87 hwmon_vid fuse i2c_dev i2c_core ipv6 autofs4 [last unloaded:
irqbypass]
[ 6702.706640] CPU: 0 PID: 118232 Comm: CPU 0/KVM Tainted: P        W  O      5.7.0-rc3+ #30
[ 6702.706667] Hardware name: Gigabyte Technology Co., Ltd. TRX40 DESIGNARE/TRX40 DESIGNARE, BIOS F4c 03/05/2020
[ 6702.706712] RIP: 0010:enable_irq_window+0x6a/0xa0 [kvm_amd]
[ 6702.706759] Code: 0c 10 48 89 df e8 56 3c 00 00 48 8b 83 c8 2d 00 00 f6 40 0c 10 74 31 48 83 bb f0 02 00 00 00 74 0b 80 bb f8 02 00 00 00 74 02 <0f> 0b 81 48 60 00 01 0f 00 c7 40 64 00 00 00 00 48
8b 83 c8 2d 00
[ 6702.706804] RSP: 0018:ffffc900073fbd48 EFLAGS: 00010202
[ 6702.706847] RAX: ffff889f56a51000 RBX: ffff889f6c4f0000 RCX: 0000000000000000
[ 6702.706871] RDX: 000060603ee37040 RSI: 00000000000000fb RDI: ffff889f6c4f0000
[ 6702.706913] RBP: ffffc900073fbd50 R08: 0000000000000001 R09: 0000000000000000
[ 6702.706959] R10: 000000000000029f R11: 0000000000000018 R12: 0000000000000001
[ 6702.706983] R13: 8000000000000000 R14: ffff889f6c4f0000 R15: ffffc9000729e1a0
[ 6702.707034] FS:  00007f8fa96f9700(0000) GS:ffff889fbe000000(0000) knlGS:0000000000000000
[ 6702.707090] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6702.707114] CR2: 0000000000000000 CR3: 0000001f5d236000 CR4: 0000000000340ef0
[ 6702.707173] Call Trace:
[ 6702.707217]  kvm_arch_vcpu_ioctl_run+0x6e3/0x1b50 [kvm]
[ 6702.707273]  ? kvm_vm_ioctl_irq_line+0x27/0x40 [kvm]
[ 6702.707298]  ? _copy_to_user+0x26/0x30
[ 6702.707332]  ? kvm_vm_ioctl+0xb3e/0xd90 [kvm]
[ 6702.707374]  ? set_next_entity+0x78/0xc0
[ 6702.707407]  kvm_vcpu_ioctl+0x236/0x610 [kvm]
[ 6702.707431]  ksys_ioctl+0x8a/0xc0
[ 6702.707492]  __x64_sys_ioctl+0x1a/0x20
[ 6702.707528]  do_syscall_64+0x58/0x210
[ 6702.707553]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 6702.707596] RIP: 0033:0x7f8fb35e235b
[ 6702.707637] Code: 0f 1e fa 48 8b 05 2d 9b 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fd 9a 0c 00 f7
d8 64 89 01 48
[ 6702.707722] RSP: 002b:00007f8fa96f7728 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 6702.707747] RAX: ffffffffffffffda RBX: 0000556b7c859b90 RCX: 00007f8fb35e235b
[ 6702.707788] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000022
[ 6702.707845] RBP: 00007f8fa96f7820 R08: 0000556b7a6207f0 R09: 00000000000000ff
[ 6702.707868] R10: 0000556b79f86ecd R11: 0000000000000246 R12: 00007ffd9a4264de
[ 6702.707908] R13: 00007ffd9a4264df R14: 00007ffd9a4265a0 R15: 00007f8fa96f7a40
[ 6702.707951] ---[ end trace d8146ba85c79e2a9 ]---


It looks like what happening is that enable_irq_window sometimes disables AVIC and then
calls the svm_enable_vintr to enable intercept on the moment when guest enables interrupts.

The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
kvm_request_apicv_update, which broadcasts the KVM_REQ_APICV_UPDATE vcpu request,
however it doesn't broadcast it to CPU on which now we are running, which seems OK,
because the code that handles that broadcast runs on each VCPU entry, thus
when this CPU will enter guest mode it will notice and disable the AVIC.

However later in svm_enable_vintr, there is test 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
which is still true on current CPU because of the above.

The code containing this warning was added in commit

64b5bd27042639dfcc1534f01771b7b871a02ffe
KVM: nSVM: ignore L1 interrupt window while running L2 with V_INTR_MASKING=1

The VM is running with SVM nesting disabled (-cpu svm=off), x2apic disabled, hv_synic disabled
(but I will send another mail about this soon), and pit lost tick policy set to discard,
to make AVIC actually be used.

The cpu is 3970X running latest mainline git head. I also tried 'next' branch of the kvm tree
without noticeable differences.

One thing that is curious is that this CPU (probably bios bug doesn't advertise x2apic, but it
is actually there. I added a hack to the kernel to pretend that the corresponding CPUID bit is
set and it actually works. But AVIC doesn't have any support for guest's x2apic thus I disable
x2apic for the guest completely.

Best regards,
	Maxim Levitsky


