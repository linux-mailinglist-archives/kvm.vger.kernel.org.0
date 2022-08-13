Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D367E591AA0
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 15:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239447AbiHMNaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Aug 2022 09:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiHMNaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Aug 2022 09:30:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0B85C9DD
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 06:30:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC79CB801B9
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 13:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FFC9C433D6
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660397405;
        bh=/MbVMEtpSr0YtR2RKRBrO9qWjk7eG5551gI1T2QT698=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fgz4eOYuvkoOQWYaRIJZkQjFkt9KKVyFdJpTFn6VPoBCfTms8Dwm9kh+Vp5tW5En9
         fZsALq/frMJo8MWM172wbjOjYp7oPsGU5vvmSEVnC66zeud9RjI5hO5gLTjB/HMG3Z
         SiYh7zl+CuoENBJIEBqvyD4ffP/BjkhLRte6pR6Nz9jF+BQM+LnGRUsRKlm0pVDLem
         5l+UGosl0kwFRsgKNz3TipVpo4dXISxIwVHAQVRmuvTSIhVrJwfT4stygz3ZcUQpQw
         TZVSae6PntJ0p0IW3b37+sZeSlX8LEjHP/4SDUh6QJ2lgI/e1XdUHoeSSX4eRr7nFI
         tIidG25lC/obw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6B29AC433E6; Sat, 13 Aug 2022 13:30:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Sat, 13 Aug 2022 13:30:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jdpark.au@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216349-28872-FKkd5elcW1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #10 from John Park (jdpark.au@gmail.com) ---
I experienced another panic today. Log below

---

[38049.665307] traps: PANIC: double fault, error_code: 0x0
[38049.665352] double fault: 0000 [#1] SMP PTI
[38049.665362] CPU: 1 PID: 3295 Comm: lighttpd Not tainted 5.15.0-46-generic
#49-Ubuntu
[38049.665388] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[38049.665395] RIP: 0010:error_entry+0x0/0x130
[38049.665466] Code: de eb 0a f3 48 0f ae db e9 21 fd ff ff 85 db 0f 85 19 =
fd
ff ff 0f 01 f8 e9 11 fd ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 <fc> 5=
6 48
8b 74 24 08 48 89 7c 24 08 52 51 50 41 50 41 51 41 52 41
[38049.665471] RSP: 0018:ffffb507830aa35d EFLAGS: 00010002
[38049.665480] RAX: 00007ffe5be0c194 RBX: 00007ffe5be0c1e0 RCX:
00007ffe5be0c194
[38049.665484] RDX: 0000000000000070 RSI: 0000000000000010 RDI:
ffffb507830a3cf8
[38049.665487] RBP: ffffb507830a3cd8 R08: 0000000000000001 R09:
0000000000000000
[38049.665491] R10: 0000000000000001 R11: 0000000000000000 R12:
ffff91c59f1a9880
[38049.665494] R13: ffff91c4d1be2d80 R14: 0000000000080800 R15:
ffff91c49d517700
[38049.665499] FS:  00007f96e38ef680(0000) GS:ffff91c5bbd00000(0000)
knlGS:0000000000000000
[38049.665503] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[38049.665507] CR2: ffffb507830aa348 CR3: 00000000090c0000 CR4:
00000000000006e0
[38049.665518] Call Trace:
[38049.665542] Modules linked in: cp210x usbserial cdc_acm tls veth xt_nat
xt_tcpudp xt_conntrack nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netl=
ink
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter
xt_addrtype nft_compat nf_tables nfnetlink br_netfilter bridge stp llc over=
lay
sch_fq_codel joydev input_leds serio_raw qemu_fw_cfg mac_hid dm_multipath
scsi_dh_rdac scsi_dh_emc scsi_dh_alua netconsole ipmi_devintf pstore_blk mtd
ramoops pstore_zone reed_solomon ipmi_msghandler msr efi_pstore ip_tables
x_tables autofs4 btrfs blake2b_generic zstd_compress raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq
libcrc32c raid1 raid0 multipath linear bochs drm_vram_helper drm_ttm_helper=
 ttm
drm_kms_helper hid_generic syscopyarea sysfillrect sysimgblt fb_sys_fops us=
bhid
cec rc_core xhci_pci hid psmouse xhci_pci_renesas drm i2c_piix4 pata_acpi
virtio_net net_failover failover virtio_scsi floppy
[38049.687192] ---[ end trace e501d4c27d1b1728 ]---
[38049.687196] RIP: 0010:error_entry+0x0/0x130
[38049.687203] Code: de eb 0a f3 48 0f ae db e9 21 fd ff ff 85 db 0f 85 19 =
fd
ff ff 0f 01 f8 e9 11 fd ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 <fc> 5=
6 48
8b 74 24 08 48 89 7c 24 08 52 51 50 41 50 41 51 41 52 41
[38049.687227] RSP: 0018:ffffb507830aa35d EFLAGS: 00010002
[38049.687229] RAX: 00007ffe5be0c194 RBX: 00007ffe5be0c1e0 RCX:
00007ffe5be0c194
[38049.687230] RDX: 0000000000000070 RSI: 0000000000000010 RDI:
ffffb507830a3cf8
[38049.687231] RBP: ffffb507830a3cd8 R08: 0000000000000001 R09:
0000000000000000
[38049.687241] R10: 0000000000000001 R11: 0000000000000000 R12:
ffff91c59f1a9880
[38049.687242] R13: ffff91c4d1be2d80 R14: 0000000000080800 R15:
ffff91c49d517700
[38049.687243] FS:  00007f96e38ef680(0000) GS:ffff91c5bbd00000(0000)
knlGS:0000000000000000
[38049.687244] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[38049.687245] CR2: ffffb507830aa348 CR3: 00000000090c0000 CR4:
00000000000006e0
[38049.687249] Kernel panic - not syncing: Fatal exception in interrupt
[38049.687476] Kernel Offset: 0x34400000 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffffbfffffff)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
