Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CEA537272
	for <lists+kvm@lfdr.de>; Sun, 29 May 2022 22:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiE2UWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 16:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiE2UWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 16:22:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B62D5DD07
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 13:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C75D1CE0E08
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 20:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10AE7C3411E
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 20:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653855737;
        bh=yioL5xkZNGp0qQnf+2TbfSATuhdp+kWw29JfOWx10cs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lmYQ0uw4j/foEM5gRoWP22m9IK5wGPe0bgwmxAuPpM1jgq1PrZpvHaMsq+xFuufX2
         j+yY6RJ5EQFxOgO4GS2bP+bOTsD/WFD24n7HTu2atusdjB2P+yytxczeLi+7abFcZ8
         34MgsiklJ/vfy9QmMqJF/ffp9jgXk4X7rLnhSIdSFJ9/doBkmsGoiWlOOuWCQVh4Ck
         xbadlMmtPTfYxFZveR6Cra3MaAlmr4+1oAqCoya6y23R4NyFjS/7SOP9Bi5aVKyKVo
         LyyMn+Bd1Z0NdnqlSmqbwJh6+Acam02D+1OjDmaOxbLQNV7FSHCY/UDGRrStKN5zG1
         OLMOBCI3OE1iA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E96EECC13B4; Sun, 29 May 2022 20:22:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216017] KVM: problem virtualization from kernel 5.17.9
Date:   Sun, 29 May 2022 20:22:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: opw
X-Bugzilla-Severity: high
X-Bugzilla-Who: ne-vlezay80@yandex.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216017-28872-ZsaZNqs2kA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216017-28872@https.bugzilla.kernel.org/>
References: <bug-216017-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216017

--- Comment #6 from Alexey Boldyrev (ne-vlezay80@yandex.ru) ---
(In reply to mlevitsk from comment #2)
> On Mon, 2022-05-23 at 08:48 +0000, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216017
> >=20
> >             Bug ID: 216017
> >            Summary: KVM: problem virtualization from kernel 5.17.9
> >            Product: Virtualization
> >            Version: unspecified
> >     Kernel Version: 5.17.9-arch1-1
> >           Hardware: AMD
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Keywords: opw
> >           Severity: high
> >           Priority: P1
> >          Component: kvm
> >           Assignee: virtualization_kvm@kernel-bugs.osdl.org
> >           Reporter: ne-vlezay80@yandex.ru
> >         Regression: No
> >=20
> > Qemu periodically chaches width:
> >=20
> > [root@router ne-vlezay80]# qemu-system-x86_64 -enable-kvm
> > qemu-system-x86_64: error: failed to set MSR 0xc0000104 to 0x100000000
> > qemu-system-x86_64: ../qemu-7.0.0/target/i386/kvm/kvm.c:2996:
> > kvm_buf_set_msrs:
> > Assertion `ret =3D=3D cpu->kvm_msr_buf->nmsrs' failed.
> > Aborted (core dumped)
>=20
> This is my fault. You can either revert the commit you found in qemu,
> or update the kernel to 5.18.
>=20
> >=20
> > Also if running virtual pachine width type -cpu host, system is freezez
> from
> > kernel panic.=20
>=20
> Can you check if this happens with 5.18 as well? If so, try to capture the
> panic message.
>=20
>=20
> Best regards,
>       Maxim Levitsky
>=20
> >=20
> > Kernel version: 5.17.9
> > Distribution: Arch Linux
> > QEMU: 7.0
> > CPU: AMD Phenom X4
> > Arch: x86_64
> >

OOPS message from kernel 5.18 in KVM:
[  598.682995] BUG: kernel NULL pointer dereference, address: 0000000000000=
00b
[  598.683020] #PF: supervisor write access in kernel mode
[  598.683031] #PF: error_code(0x0002) - not-present page
[  598.683041] PGD 0 P4D 0=20
[  598.683053] Oops: 0002 [#1] PREEMPT SMP NOPTI
[  598.683066] CPU: 2 PID: 13004 Comm: qemu-system-x86 Not tainted
5.18.0-arch1-1 #1 b71a70fe104889aac2f32556bc52f649da2881d2
[  598.683086] Hardware name: MSI MS-7715/870-C45(FX) V2 (MS-7715)  , BIOS =
V3.1
04/16/2012
[  598.683097] RIP: 0010:kvm_replace_memslot+0xc0/0x380 [kvm]
[  598.683315] Code: 04 00 00 48 85 c0 0f 84 3b 02 00 00 48 89 d9 48 c1 e1 =
04
48 01 c1 48 8b 71 08 48 85 f6 74 1e 48 8b 39 48 89 3e 48 85 ff 74 04 <48> 8=
9 77
08 48 c7 01 00 00 00 00 48 c7 41 08 00 00 00 00 48 8d 0c
[  598.683334] RSP: 0018:ffffbe0bc851bd50 EFLAGS: 00010206
[  598.683346] RAX: ffff96da40977a00 RBX: 0000000000000000 RCX:
ffff96da40977a00
[  598.683358] RDX: 0000000000000000 RSI: ffffbe0bc8509110 RDI:
0000000000000003
[  598.683368] RBP: ffff96da40977000 R08: 0000000000000200 R09:
ffff96da40977000
[  598.683378] R10: 0000000000000000 R11: fffffffffffffff0 R12:
0000000000000000
[  598.683388] R13: 0000000000000000 R14: 0000000000000000 R15:
ffffbe0bc8509000
[  598.683398] FS:  00007f52ef16a640(0000) GS:ffff96da6b880000(0000)
knlGS:0000000000000000
[  598.683413] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  598.683424] CR2: 000000000000000b CR3: 00000001003e4000 CR4:
00000000000006e0
[  598.683437] Call Trace:
[  598.683448]  <TASK>
[  598.683457]  ? kmem_cache_alloc_trace+0x16b/0x300
[  598.683480]  kvm_set_memslot+0x2a5/0x4b0 [kvm
db3c7a88bf101c39d9e215d66cd0ad42c132fef6]
[  598.683666]  kvm_vm_ioctl+0x33f/0xe90 [kvm
db3c7a88bf101c39d9e215d66cd0ad42c132fef6]
[  598.683852]  ? __rseq_handle_notify_resume+0x321/0x480
[  598.683873]  __x64_sys_ioctl+0x91/0xc0
[  598.683889]  do_syscall_64+0x5f/0x90
[  598.683904]  ? exc_page_fault+0x74/0x170
[  598.683920]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  598.683935] RIP: 0033:0x7f52f0d07b1f
[  598.683947] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 =
00
00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c=
2 3d
00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  598.683969] RSP: 002b:00007f52ef168fa0 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  598.683986] RAX: ffffffffffffffda RBX: 000000004020ae46 RCX:
00007f52f0d07b1f
[  598.683997] RDX: 00007f52ef169140 RSI: 000000004020ae46 RDI:
0000000000000008
[  598.684008] RBP: 00007f52ef169140 R08: 0000000000000000 R09:
0000000000000000
[  598.684019] R10: 00007f52d8000c00 R11: 0000000000000246 R12:
000055d6f8080810
[  598.684030] R13: 0000000000020000 R14: 00007f52ee800000 R15:
00000000000e0000
[  598.684047]  </TASK>
[  598.684054] Modules linked in: act_mirred cls_matchall sch_ingress
iptable_security ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat dummy
nf_tables dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio loop
vhost_vsock vmw_vsock_virtio_transport_common vhost vhost_iotlb vsock rpcrd=
ma
rdma_cm iw_cm ib_cm ib_core cls_flower sch_htb tcp_bbr ifb veth ip6_gre
ip6_tunnel tunnel6 bridge stp llc tun ip_gre ip_tunnel gre ip6table_raw
xt_NETMAP ip6table_nat ip6t_rpfilter xt_DSCP ip6table_mangle ip6t_REJECT
nf_reject_ipv6 ip6table_filter ip6_tables iptable_raw ts_kmp xt_conntrack
xt_string iptable_filter xt_MASQUERADE xt_nat iptable_nat xt_set xt_LOG
nf_log_syslog xt_mark xt_TCPMSS xt_tcpudp xt_connmark nfnetlink_cttimeout
xt_recent xt_dscp iptable_mangle openvswitch ip_set_hash_ip nsh nf_conncount
ip_set_hash_net nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set
nfnetlink btrfs blake2b_generic xor raid6_pq libcrc32c snd_hda_codec_realtek
snd_hda_codec_generic ath9k ledtrig_audio
[  598.684264]  ath9k_common ath9k_hw snd_hda_intel snd_intel_dspcfg
snd_intel_sdw_acpi ath snd_hda_codec nouveau edac_mce_amd mac80211 kvm_amd
snd_hda_core ccp snd_hwdep libarc4 wmi_bmof mxm_wmi cfg80211 video kvm snd_=
pcm
drm_ttm_helper irqbypass ttm pcspkr rfkill snd_timer r8169 snd rng_core rea=
ltek
sp5100_tco k10temp soundcore mdio_devres i2c_piix4 e1000e libphy drm_dp_hel=
per
wmi mac_hid acpi_cpufreq wireguard curve25519_x86_64 libchacha20poly1305
chacha_x86_64 poly1305_x86_64 libcurve25519_generic libchacha ip6_udp_tunnel
nfsd udp_tunnel auth_rpcgss dm_multipath nfs_acl dm_mod lockd grace sg sunr=
pc
fuse bpf_preload ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2
sr_mod cdrom ata_generic pata_acpi pata_atiixp
[  598.684545] CR2: 000000000000000b
[  598.684601] ---[ end trace 0000000000000000 ]---
[  598.684613] RIP: 0010:kvm_replace_memslot+0xc0/0x380 [kvm]
[  598.684824] Code: 04 00 00 48 85 c0 0f 84 3b 02 00 00 48 89 d9 48 c1 e1 =
04
48 01 c1 48 8b 71 08 48 85 f6 74 1e 48 8b 39 48 89 3e 48 85 ff 74 04 <48> 8=
9 77
08 48 c7 01 00 00 00 00 48 c7 41 08 00 00 00 00 48 8d 0c
[  598.684846] RSP: 0018:ffffbe0bc851bd50 EFLAGS: 00010206
[  598.684859] RAX: ffff96da40977a00 RBX: 0000000000000000 RCX:
ffff96da40977a00
[  598.684871] RDX: 0000000000000000 RSI: ffffbe0bc8509110 RDI:
0000000000000003
[  598.684882] RBP: ffff96da40977000 R08: 0000000000000200 R09:
ffff96da40977000
[  598.684894] R10: 0000000000000000 R11: fffffffffffffff0 R12:
0000000000000000
[  598.684905] R13: 0000000000000000 R14: 0000000000000000 R15:
ffffbe0bc8509000
[  598.684916] FS:  00007f52ef16a640(0000) GS:ffff96da6b880000(0000)
knlGS:0000000000000000
[  598.684931] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  598.684942] CR2: 000000000000000b CR3: 00000001003e4000 CR4:
00000000000006e0

CPU:
model name      : AMD Phenom(tm) II X4 965 Processor

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
