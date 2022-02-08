Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D054ADBD5
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 15:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379095AbiBHO7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 09:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379094AbiBHO7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 09:59:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06358C061577
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 06:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644332369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=J86ypeOONv0Z/QmidYn3mFLaTIvo8XVx3s92r5ldD0E=;
        b=dADPMIL5UFTOwSLDU3Q2JYLSrlFxJ+Qc2ATdphSnEV7y+3KRgsAE0X+Dzh8za1tbSLFy/Q
        Yjk4eotze65yuvTbcOUEqer01HvWbLZpmc969vV8f8PgxxzL+KobNjqvIbYIY7U289AOqj
        j/51U8rxska+gIteIYV+LHg2+xXAiC8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-OIwE7eN2NRuTp33PDO0oVw-1; Tue, 08 Feb 2022 09:59:27 -0500
X-MC-Unique: OIwE7eN2NRuTp33PDO0oVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F07D01091DB8
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 14:59:26 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D8E36128B;
        Tue,  8 Feb 2022 14:59:25 +0000 (UTC)
Message-ID: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
Subject: warning in kvm_hv_invalidate_tsc_page due to writes to guest memory
 from VM ioctl context
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Tue, 08 Feb 2022 16:59:24 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org





[102140.117649] WARNING: CPU: 10 PID: 579353 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:3161 mark_page_dirty_in_slot+0x6c/0x80 [kvm]
[102140.118063] Modules linked in: kvm_amd(O) ccp rng_core kvm(O) irqbypass tun xt_conntrack ip6table_filter ip6_tables tps6598x wmi_bmof snd_acp3x_pdm_dma snd_soc_dmic snd_acp3x_rn regmap_i2c
snd_soc_core ftdi_sio snd_ctl_led bfq snd_hda_codec_realtek iwlmvm btusb snd_hda_codec_generic snd_hda_codec_hdmi btrtl psmouse btbcm pcspkr btintel k10temp snd_hda_intel snd_intel_dspcfg tpm_crb
snd_hda_codec snd_hwdep snd_hda_core snd_pcm iwlwifi snd_rn_pci_acp3x i2c_piix4 tpm_tis tpm_tis_core thinkpad_acpi wmi platform_profile rtc_cmos i2c_multi_instantiate i2c_designware_platform
i2c_designware_core sch_fq_codel dm_crypt mmc_block hid_generic usbhid rtsx_pci_sdmmc mmc_core atkbd libps2 amdgpu drm_ttm_helper ttm gpu_sched i2c_algo_bit drm_kms_helper cfbfillrect syscopyarea
cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea nvme xhci_pci drm sp5100_tco nvme_core rtsx_pci ucsi_acpi xhci_hcd drm_panel_orientation_quirks mfd_core t10_pi typec_ucsi typec i8042
pinctrl_amd r8169 realtek 8250_pci
[102140.118133]  usbmon nbd fuse autofs4 [last unloaded: rng_core]
[102140.120708] CPU: 10 PID: 579353 Comm: qemu-system-x86 Tainted: G        W  O      5.16.0.stable #20
[102140.120971] Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
[102140.121206] RIP: 0010:mark_page_dirty_in_slot+0x6c/0x80 [kvm]
[102140.121441] Code: 21 00 00 0f bf b6 04 01 00 00 c1 e1 10 48 89 e5 09 ce e8 17 aa 00 00 5d c3 c3 48 8b 86 c0 00 00 00 48 63 d2 f0 48 0f ab 10 c3 <0f> 0b c3 0f 0b c3 66 66 2e 0f 1f 84 00 00 00 00 00
0f 1f 00 0f 1f
[102140.121990] RSP: 0018:ffffc9000078fcb8 EFLAGS: 00010246
[102140.122152] RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
[102140.122363] RDX: 0000000000108607 RSI: ffff88810a264600 RDI: ffffc90001e55000
[102140.122571] RBP: ffffc9000078fd08 R08: 0000000000000000 R09: 0000000000000000
[102140.122789] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88810a264600
[102140.123001] R13: 0000000000000004 R14: 0000000000108608 R15: ffffc90001e5e8cc
[102140.123210] FS:  00007ff0d9519d80(0000) GS:ffff8883ff880000(0000) knlGS:0000000000000000
[102140.123447] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[102140.123618] CR2: 000055e6c099a0d8 CR3: 000000010a7f5000 CR4: 0000000000350ee0
[102140.123834] Call Trace:
[102140.123910]  <TASK>
[102140.123976]  ? kvm_write_guest+0x114/0x120 [kvm]
[102140.124183]  kvm_hv_invalidate_tsc_page+0x9e/0xf0 [kvm]
[102140.124396]  kvm_arch_vm_ioctl+0xa26/0xc50 [kvm]
[102140.124585]  ? schedule+0x4e/0xc0
[102140.124701]  ? __cond_resched+0x1a/0x50
[102140.124826]  ? futex_wait+0x166/0x250
[102140.124946]  ? __send_signal+0x1f1/0x3d0
[102140.125072]  kvm_vm_ioctl+0x747/0xda0 [kvm]
[102140.125264]  ? do_futex+0xa7/0x160
[102140.125370]  ? __x64_sys_futex+0x74/0x1b0
[102140.125493]  __x64_sys_ioctl+0x8e/0xc0
[102140.125612]  do_syscall_64+0x35/0x80
[102140.125738]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[102140.125893] RIP: 0033:0x7ff0dd6b72bb
[102140.126001] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3d 2b 0f 00 f7
d8 64 89 01 48
[102140.126548] RSP: 002b:00007ffe28d41158 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[102140.126770] RAX: ffffffffffffffda RBX: 000055984440d610 RCX: 00007ff0dd6b72bb
[102140.126975] RDX: 00007ffe28d412a0 RSI: 000000004030ae7b RDI: 000000000000001e
[102140.127175] RBP: 00007ffe28d41250 R08: 0000000000000000 R09: 00000000ffffffff
[102140.127375] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ff0dec1c3a0
[102140.127574] R13: 0000559841ba2847 R14: 00005598442b03a0 R15: 0000559844077b10
[102140.127792]  </TASK>
[102140.127863] ---[ end trace b8a3ae7a8a53d467 ]---


This happens because kvm_hv_invalidate_tsc_page is called from kvm_vm_ioctl_set_clock
which is a VM wide ioctl and thus doesn't have to be called with an active vCPU.
 
But as I see the warring states that guest memory writes must alway be done
while a vCPU is active to allow the write to be recorded in its dirty track ring.
 
I _think_ it might be OK to drop this invalidation,
and rely on the fact that kvm_hv_setup_tsc_page will update it,
and it is called when vCPU0 processes KVM_REQ_CLOCK_UPDATE which is raised in the
kvm_vm_ioctl_set_clock eventually.
 
Vitaly, any thoughts on this?
 
For reference those are my HV flags:
 
    $cpu_flags: |
        $cpu_flags,
        hv_relaxed,hv_spinlocks=0x1fff,hv_vpindex,     # General HV features
        hv_runtime,hv_time,hv-frequencies,             # Clock stuff        
        hv_synic,hv_stimer,hv-stimer-direct,#hv-vapic, # APIC extensions
        #hv-tlbflush,hv-ipi,                           # IPI extensions
        hv-reenlightenment,                            # nested stuff
 
 
 
PS: unrelated question:
 
Vitaly, do you know why hv-evmcs needs hv-vapic?
 
 
I know that they stuffed the eVMCS pointer to HV_X64_MSR_VP_ASSIST_PAGE,
 
But can't we set HV_APIC_ACCESS_AVAILABLE but not HV_APIC_ACCESS_RECOMMENDED
so that guest would hopefully still know that HV assist page is available,
but should not use it for APIC acceleration?
 
Best regards,
	Maxim Levitsky

