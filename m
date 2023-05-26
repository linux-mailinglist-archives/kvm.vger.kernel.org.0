Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85568712163
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 09:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242179AbjEZHoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 03:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242347AbjEZHoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 03:44:01 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6834510F6;
        Fri, 26 May 2023 00:43:31 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3078d1c8828so348003f8f.3;
        Fri, 26 May 2023 00:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685087009; x=1687679009;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=twYef5JxzOYWdFtDJIvI+imxLb6P+iSjJpGmWBNbdSU=;
        b=a+RCJZ6u48THGZkfG+L3RtSqWxnNYPQt2gfPnZaSyovQTyaCb64YYSYbdSHxETdEtN
         DrVEfY9LWUW6mVr5kxVCNh7EpMy7ZGniztEXSv7N7NKpNDjLvfO73ktEy57r3SwMrAxS
         lo5NP1CaFL/6nrNaV4YHPoAx94rcO3AZ1eYwBidgS4qYX3QWbvDWMJIojs5u79RswEvT
         qUCqI7jf+6X3xO5HNW47Hsccz82wmdmiR8/e5qZ595VUfxnErnLKhoAg9my5WAJrjrgE
         aWAoLR+dNKJsUY1yXTaQ2H2CcnehGkJzST//luoH3DPPvKeGmCz2rTCPYCVso9lNMFTW
         lzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685087009; x=1687679009;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=twYef5JxzOYWdFtDJIvI+imxLb6P+iSjJpGmWBNbdSU=;
        b=UMydGBHlu7J7cTqh5PpFcvmLywIGnDQL/CowNeknPH3UYbaP3nNuevLJoZwmPCK8dl
         MYgUwb4GFe/V1863Qf/PnpOrzJIQMCbBMeEMVEP9i2guopakokyCaZCOaNCZdeUHeRK1
         XOcywMseG5rzwAk7yJebRlkU5D6ZbXcXNXTU57klsG1obT6TDRZoV29selRvR1YoodA/
         RsSKaUJFD2qiX5h1udlV68cM5bbf8f7C0djzmvkvdAlQSlV7rQnrWCPMJ+9Sw+PAcoGz
         Sm/hhIoY4ai9M5wh9l9sOdayj5CKZEW/QGLETBiBSBYwC9LtteDT/Wf1OcHv5Yy/S5SI
         u9Cg==
X-Gm-Message-State: AC+VfDxUB8oBa8JBchqy4DM6DM+c4hoZKRxZCmMXR2kvfgUMinni5fOk
        zRLW18iOSTg4iai+rSB6jhDTYtMSCy4lbULvYOcMGoPnzUhWUw==
X-Google-Smtp-Source: ACHHUZ4F355jBozpMw3/OEJ8PW+sc/pObMm5c/87PQjFnU9AqE6jA1CUem6RiYdym4DwbLSP+XdFma7xjpqk5EiHJ4k=
X-Received: by 2002:adf:ee0d:0:b0:309:3828:2bde with SMTP id
 y13-20020adfee0d000000b0030938282bdemr653832wrn.60.1685087008551; Fri, 26 May
 2023 00:43:28 -0700 (PDT)
MIME-Version: 1.0
From:   Fabio Coatti <fabio.coatti@gmail.com>
Date:   Fri, 26 May 2023 09:43:17 +0200
Message-ID: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
Subject: WARNING trace at kvm_nx_huge_page_recovery_worker on 6.3.4
To:     stable@vger.kernel.org, regressions@lists.linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,
I'm using vanilla kernels on a gentoo-based laptop and since 6.3.2 I'm
getting the kernel log  below when using kvm VM on my box.
I know, kernel is tainted but avoiding to load nvidia driver could
make things complicated on my side; if needed for debug I can try to
avoid it.

Not sure which other infos can be relevant in this context; if you
need more details just let me know, happy to provide them.

[Fri May 26 09:16:35 2023] ------------[ cut here ]------------
[Fri May 26 09:16:35 2023] WARNING: CPU: 5 PID: 4684 at
kvm_nx_huge_page_recovery_worker+0x38c/0x3d0 [kvm]
[Fri May 26 09:16:35 2023] Modules linked in: vhost_net vhost
vhost_iotlb tap tun tls rfcomm snd_hrtimer snd_seq xt_CHECKSUM
algif_skcipher xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4
ip6table_mangle ip6table_nat ip6table_filter ip6_tables iptable_mangle
iptable_nat nf_nat iptable_filter ip_tables bpfilter bridge stp llc
rmi_smbus rmi_core bnep squashfs sch_fq_codel nvidia_drm(POE)
intel_rapl_msr vboxnetadp(OE) vboxnetflt(OE) nvidia_modeset(POE)
mei_pxp mei_hdcp rtsx_pci_sdmmc vboxdrv(OE) mmc_core intel_rapl_common
intel_pmc_core_pltdrv intel_pmc_core snd_ctl_led intel_tcc_cooling
snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal
intel_powerclamp btusb btrtl snd_usb_audio btbcm btmtk kvm_intel
btintel snd_hda_intel snd_intel_dspcfg snd_usbmidi_lib snd_hda_codec
snd_rawmidi snd_hwdep bluetooth snd_hda_core snd_seq_device kvm
snd_pcm thinkpad_acpi iwlmvm mousedev ledtrig_audio uvcvideo snd_timer
ecdh_generic irqbypass crct10dif_pclmul crc32_pclmul polyval_clmulni
snd think_lmi joydev mei_me ecc uvc
[Fri May 26 09:16:35 2023]  polyval_generic rtsx_pci iwlwifi
firmware_attributes_class psmouse wmi_bmof soundcore intel_pch_thermal
mei platform_profile input_leds evdev nvidia(POE) coretemp hwmon
akvcam(OE) videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videodev
videobuf2_common mc loop nfsd auth_rpcgss nfs_acl efivarfs dmi_sysfs
dm_zero dm_thin_pool dm_persistent_data dm_bio_prison dm_service_time
dm_round_robin dm_queue_length dm_multipath dm_delay virtio_pci
virtio_pci_legacy_dev virtio_pci_modern_dev virtio_blk virtio_console
virtio_balloon vxlan ip6_udp_tunnel udp_tunnel macvlan virtio_net
net_failover failover virtio_ring virtio fuse overlay nfs lockd grace
sunrpc linear raid10 raid1 raid0 dm_raid raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx md_mod dm_snapshot dm_bufio
dm_crypt trusted asn1_encoder tpm rng_core dm_mirror dm_region_hash
dm_log firewire_core crc_itu_t hid_apple usb_storage ehci_pci ehci_hcd
sr_mod cdrom ahci libahci libata
[Fri May 26 09:16:35 2023] CPU: 5 PID: 4684 Comm: kvm-nx-lpage-re
Tainted: P     U     OE      6.3.4-cova #1
[Fri May 26 09:16:35 2023] Hardware name: LENOVO
20EQS58500/20EQS58500, BIOS N1EET98W (1.71 ) 12/06/2022
[Fri May 26 09:16:35 2023] RIP:
0010:kvm_nx_huge_page_recovery_worker+0x38c/0x3d0 [kvm]
[Fri May 26 09:16:35 2023] Code: 48 8b 44 24 30 4c 39 e0 0f 85 1b fe
ff ff 48 89 df e8 2e ab fb ff e9 23 fe ff ff 49 bc ff ff ff ff ff ff
ff 7f e9 fb fc ff ff <0f> 0b e9 1b ff ff ff 48 8b 44 24 40 65 48 2b 04
25 28 00 00 00 75
[Fri May 26 09:16:35 2023] RSP: 0018:ffff8e1a4403fe68 EFLAGS: 00010246
[Fri May 26 09:16:35 2023] RAX: 0000000000000000 RBX: ffff8e1a42bbd000
RCX: 0000000000000000
[Fri May 26 09:16:35 2023] RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000000
[Fri May 26 09:16:35 2023] RBP: ffff8b4e9a56d930 R08: 0000000000000000
R09: ffff8b4e9a56d8a0
[Fri May 26 09:16:35 2023] R10: 0000000000000000 R11: 0000000000000001
R12: ffff8e1a4403fe98
[Fri May 26 09:16:35 2023] R13: 0000000000000001 R14: ffff8b4d9c432e80
R15: 0000000000000010
[Fri May 26 09:16:35 2023] FS:  0000000000000000(0000)
GS:ffff8b5cdf740000(0000) knlGS:0000000000000000
[Fri May 26 09:16:35 2023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri May 26 09:16:35 2023] CR2: 00007efeac53d000 CR3: 0000000978c2c003
CR4: 00000000003726e0
[Fri May 26 09:16:35 2023] Call Trace:
[Fri May 26 09:16:35 2023]  <TASK>
[Fri May 26 09:16:35 2023]  ?
__pfx_kvm_nx_huge_page_recovery_worker+0x10/0x10 [kvm]
[Fri May 26 09:16:35 2023]  kvm_vm_worker_thread+0x106/0x1c0 [kvm]
[Fri May 26 09:16:35 2023]  ? __pfx_kvm_vm_worker_thread+0x10/0x10 [kvm]
[Fri May 26 09:16:35 2023]  kthread+0xd9/0x100
[Fri May 26 09:16:35 2023]  ? __pfx_kthread+0x10/0x10
[Fri May 26 09:16:35 2023]  ret_from_fork+0x2c/0x50
[Fri May 26 09:16:35 2023]  </TASK>
[Fri May 26 09:16:35 2023] ---[ end trace 0000000000000000 ]---
-- 
Fabio
