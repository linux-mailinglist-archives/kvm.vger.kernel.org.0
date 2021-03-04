Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203DF32DD1E
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 23:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhCDWed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 17:34:33 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39996 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbhCDWec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 17:34:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614898133; x=1646434133;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=K+rLXlqQJrzFIwW/Xbok6b95xFjfUdFzUSAt+qDdd1E=;
  b=PZhwjRFSbVRk3a7NDkjXjIjr844Pb420ycGF3P2vHQTcXQvI7eEhkNw7
   da4oFzNIEx4ypJhEY+zgdYK/vc3Q2brvqobRRISOXE+oLCnJtHSlUHjRh
   deqn3sf8+g7qzRGmprdMIWH+yvXO0gQCjrJf9Vt2j1IQ70Hjsm22qSyIB
   S7lIQ8WheKDJ6PdM+7rE9uynuT50DiG6gD7Su/5CTl3bJVOmAqCdjdZam
   oW3KVST6giCO5mJIM+XWGQY+80wukuhabCep1zRskBopayf2l1y/LKyey
   gDY36Ohoqe9CSR+vsAWLWq8gFxnR70rRKalagIoPjgBSBdQg5gyCp7LC6
   w==;
IronPort-SDR: ogHsTYH1uRwLL3DoSyPkrjbQuh3o2+Yys+JBhAKOycISPeJvjyYl/kwrayaqwyEdFic/+ls4Fi
 sfiVljosmUeDQ5xgG8LTyPheIO1oPc8ni59/nq1J8GkXkdHYp6ZtfvLFfw/dN1kpZM1GW77qNb
 xsut394PN42MZmYdxqxjUeRvctpg146tjZ4ZaT6Cg84JauK1KvPCXYZBtf/bahnEVr5/O26imo
 O338k8AOyaebiLymva+NxK3LdaGXPMzdXHhoisp1YcqXsKtTne2cvBIiymeR24V4K9PJcbQ/mU
 AZE=
X-IronPort-AV: E=Sophos;i="5.81,223,1610380800"; 
   d="scan'208";a="265701950"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 05 Mar 2021 06:48:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibSYRw2NUJXogHQl4s4WCbC1YKY1/U7GowFIrFG/EvkJM84dmOugD6IYQwlJ7LIq+rll8rtI45Gdp84RWDsYNIB+Dhp/GDD5BeJJE/HZgXfFIxqnQJrxSX8YulMh+jnU2kQTXMU/q5bLjttpEVMFgZ0pWzUPFIkDlInhlyIzYTWW0MG40yAmVamOI7tKN55pr4wvPkqs6iupXuIlNKVv+WKotKfbYjqHKb8W5sQkC15Lg53yqFoQPsTyBeBI14n/fuZBdvs3uvtVaF14GmhmQiVeUq45Zw+xZRVvC3vB5snwnacgP9Rx8mB5Zwc9W1D/u08jvd33NJQA4km65tKtzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOib9pjvVjawP9LJd0if5Im6lO7wn15SK2nyfHSlawM=;
 b=mYboRHaNkfFC+8UKkFNu5J0Ih5jOCKPYshJNCxtfgviG8YvKaPXVpDVy1aCQ5OlI6Ead2mJEoTojLTqN9IoVtGfUfWfXhmAqZUGwounvsNwXi2k2ibtBAgZxUTmv2TUaJ/+DvWtoz8geyWeKHjiIamky3jLTy9W766fMHwmbrJ4+F17YT2spVHGb8uNjS9eYmMU5b6evSTEFtx0ga3jQVWJexe0b89bH4Ly8fBdS2PrbxyhSyZPMHJTTuhHUZ9O2kfQBnWxoaQSbWwvWlMVDfVhtCwS+Ccf6iDuKVqEWfYuYBJ4zJWWYgzm6iEJ/htoW4ewL5XJiiREI+zOJnNWaOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOib9pjvVjawP9LJd0if5Im6lO7wn15SK2nyfHSlawM=;
 b=xy3vHMNR2CTpJWzlUtDLeivskhJEfm3G9j7/KWybELOwi/gqGVqH90J1VuPKyOoRLAa61Ic57yDqGLOyyERS9DMjbcA620CLPdnebL5kvdi3MWlHvyMyDCAsb/pomWdnq4VTAdDsdMHiKf7+dDRG2zjaq2bBEwAdPXrQU5S+HnQ=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6881.namprd04.prod.outlook.com (2603:10b6:a03:218::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Thu, 4 Mar
 2021 22:34:29 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.031; Thu, 4 Mar 2021
 22:34:29 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Problem With XFS + KVM
Thread-Topic: Problem With XFS + KVM
Thread-Index: AQHXEUaJ81+kylbMeUuYIeYf5OnWpA==
Date:   Thu, 4 Mar 2021 22:34:29 +0000
Message-ID: <BYAPR04MB4965AAAB580D73E3B03E7E7886979@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e3262bc-502f-4886-a172-08d8df5daca0
x-ms-traffictypediagnostic: BY5PR04MB6881:
x-microsoft-antispam-prvs: <BY5PR04MB68819DF6105D410101A2346E86979@BY5PR04MB6881.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /3fKr4J+Fp3OMNnmoHcMqj6f4XWLTGWHYsvfiy3DAFjSmm/dK2PWATPGq8CmuFRQASfv29gRRdKvjjB2Ke/Eo6ykG2yUCWdxj8P7h2mXN3DwcHBvy1EOTc1oi27T+lHxwK5XrOAJAiSIsPvFeLh0nIlVafoFgjbPW5DwPd99b2KoQ1qEDBgg5WdG0HzEVHww3sSsep3mR3X3D36X2poqPMORgcoq6VKXJzr4E7ysYTBTSaLgHZCSWrQHn0n3QGy2N/NH15DlTKXf9xNqyCzt7aU2gRYxaAKAJqvBW7AAsjweAZzWr6BNoavGUacaIg6XBdIfFPB1wiPnUHv6U1TeqGR11w8STW0l8926NBxYcENvVk8AIEkPDX9TYhe4HqJqSplcQKfmNEFKKyjuH8WgOxy8Zubp5bGNlRMzSCuS5+M6MVErZ+kzbyfRMh7C5IpKEcT+wWEs3/Pv25oUfqRwocHeR6VAR4syBgNh5mhpC97nso+AVpIkaCK5sQTdWeYbcpS/BKWsPHwTN2jiGFyKWGV0Ip1KUKgxgXzvZPoKyP4W1kCvt3zBLsMv8Eg29DwM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(26005)(6506007)(66446008)(83380400001)(186003)(76116006)(4326008)(66946007)(64756008)(71200400001)(66476007)(7696005)(55016002)(8936002)(478600001)(45080400002)(316002)(91956017)(33656002)(86362001)(110136005)(9686003)(52536014)(2906002)(5660300002)(66556008)(8676002)(473944003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?oxII2EBp9X86HWnvwjXutBCDzfjH9mThCzsYiO6GMQe1udhjNdmdUUw8W9ht?=
 =?us-ascii?Q?52D9FK8aOV2e2Gh5F33Px9zDzablUKI0RE6OoN14vnZ5/wx1lfhia2L93Ety?=
 =?us-ascii?Q?uLEisQtSKHbKY26KdoYyDBoSk+H1lTH0Sv7nVv3znGoIw65Bd+mxuzDLcFd7?=
 =?us-ascii?Q?rUK68qpt7d8ClcjrsQuvQ+5ov/lkmbT/hMBfm6CV/xRiE560wVp28v9usj/p?=
 =?us-ascii?Q?4MIMVJK5MwtHlFXv1Uuq2UOeZaKsExwDIvaeZqbfwnuqU99AaNJMHX4Kd7k7?=
 =?us-ascii?Q?QITUgd7Jo8Vmz5tVZ5TJUEr/g7mzyn1S67U6eBBDgKNW4q02fID5cS2Ip3UW?=
 =?us-ascii?Q?GJB4tsqpHLQtHVYrGyyIJeF0KKFq2O26/zgJlgAnPTINd93rVOi8RIcekCtL?=
 =?us-ascii?Q?NaqxWLUvV1fBX53IHxs7F/9bIXnye//D8nKz/d/qjZgyu332oWfvzZq4XyFN?=
 =?us-ascii?Q?0lhJ9HkvFrZsAL3FR12RxQRbZcTMdtbOCk5aMWOUMxLqKBLp0qRLRaqcL5hX?=
 =?us-ascii?Q?SX1xEfDNGPMTjYl87IFzdzMDdELpYn90Kb7r4DY7Sknc36Z1VpVOqzSFO3PV?=
 =?us-ascii?Q?tEbWoCUcpsM6S56exFhnGnBz1igCUeAlXcHbgJcjNxvAQM9VCLTIcnaV2LYD?=
 =?us-ascii?Q?/gweayJrakIqW+NZq0/TueLliLkQ2jyWFIGU9b15cIY7ng36aYdtOATC/MQ5?=
 =?us-ascii?Q?tf2vICecq4oVSYuhFNFj1h5wYt9/hx1DDQtUfhXQzoZoNVvclFZXOKvk6ua5?=
 =?us-ascii?Q?0eJ+fc4esAW5rv1Ex13535vdu2y0XdaJ0oyWw3RKU6icWlKJHK/2ticlKONq?=
 =?us-ascii?Q?ddivBoisx9MPRz2peNKw7pjzwwO3n+slNRm3iJO8cDGgbn9kISxF/yiogtl4?=
 =?us-ascii?Q?2z510elxo5e+gAX0EBYy8QC/OtcfHJP/CM3nVnzDCLy91vqRTTpGoWaooeoB?=
 =?us-ascii?Q?Y/tjhXOzcBw/DJS46q82nm9XxsguZydz/WnwEHI7eaWFwV1MIA8mZCxrb7Ae?=
 =?us-ascii?Q?Ep7FWOnPQ6zZKw/Sgii3T+Uu5EuXWDYSx2Rac2TtOgHBxPF72lzEA+Bw3F4L?=
 =?us-ascii?Q?refC1dCh2zyUBTgtBBx/ARLIlMEG59mmUAzyQ+4uegUqlOw0QNX+J25bBqpc?=
 =?us-ascii?Q?f7tqiEWnRm4FsfdN4TJMdQCmBbxrSkjuN6iTN0FUQyowT5Ttyu2yXtVnx98R?=
 =?us-ascii?Q?wOwPmjItGlo6fVnLxmmsQfwg9hRHzaYh/kZzOYsWScGvt2MnF6XzfVMglLjb?=
 =?us-ascii?Q?7ZRHeJQlOGrRXc/Y2+aT+MfwrxjYrq6lzWPWSDMjY7kBcw2nOZ27GN5/rMps?=
 =?us-ascii?Q?do73h3Oy5dhaJ7absGEgmsHX?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3262bc-502f-4886-a172-08d8df5daca0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 22:34:29.3486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MAETez4d7pbhfPVkMe+W0OZDRmnbAJ5c1AV9nCUgrbL0jPu/PhONBP+mXYVcMRScXz2CUV1Wl3sn/sv04rtyEnm3jp+LLFn+s+yRaLoStkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6881
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,=0A=
=0A=
I'm running fio verification job with XFS formatted file system on 5.12-rc1=
=0A=
with NVMeOF file backend target inside QEMU test machine.=0A=
=0A=
I'm getting a following message intermittently it is happening since=0A=
yesterday.=0A=
This can be easily reproduces with runing block tests nvme/011 :-=0A=
=0A=
nvme/011 (run data verification fio job on NVMeOF file-backed ns) [failed]=
=0A=
    runtime  270.553s  ...  268.552s=0A=
    something found in dmesg:=0A=
    [  340.781752] run blktests nvme/011 at 2021-03-04 14:22:34=0A=
    [  340.857161] nvmet: adding nsid 1 to subsystem blktests-subsystem-1=
=0A=
    [  340.890225] nvmet: creating controller 1 for subsystem=0A=
blktests-subsystem-1 for NQN=0A=
nqn.2014-08.org.nvmexpress:uuid:e4cfc949-8f19-4db2-a232-ab360b79204a.=0A=
    [  340.892477] nvme nvme0: Please enable CONFIG_NVME_MULTIPATH for=0A=
full support of multi-port devices.=0A=
    [  340.892937] nvme nvme0: creating 64 I/O queues.=0A=
    [  340.913759] nvme nvme0: new ctrl: "blktests-subsystem-1"=0A=
    [  586.495375] nvme nvme0: Removing ctrl: NQN "blktests-subsystem-1"=0A=
    [  587.766464] ------------[ cut here ]------------=0A=
    [  587.766535] raw_local_irq_restore() called with IRQs enabled=0A=
    [  587.766561] WARNING: CPU: 14 PID: 12543 at=0A=
kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20=0A=
    ...=0A=
    (See '/root/blktests/results/nodev/nvme/011.dmesg' for the entire=0A=
message)=0A=
=0A=
Please let me know what kind of more details I can provide to resolve=0A=
this issue.=0A=
=0A=
Here is the dmesg outout :-=0A=
=0A=
 ------------[ cut here ]------------=0A=
[  587.766535] raw_local_irq_restore() called with IRQs enabled=0A=
[  587.766561] WARNING: CPU: 14 PID: 12543 at=0A=
kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20=0A=
[  587.766571] Modules linked in: nvme_loop nvme_fabrics nvmet nvme_core=0A=
loop xt_CHECKSUM xt_MASQUERADE tun bridge stp llc ip6t_rpfilter=0A=
ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set=0A=
nfnetlink ebtable_nat ebtable_broute ip6table_nat ip6table_mangle=0A=
ip6table_security ip6table_raw iptable_nat nf_nat nf_conntrack=0A=
nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_security=0A=
iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables rfkill=0A=
iptable_filter intel_rapl_msr intel_rapl_common kvm_amd ccp kvm btrfs=0A=
irqbypass crct10dif_pclmul crc32_pclmul blake2b_generic=0A=
ghash_clmulni_intel xor zstd_compress ppdev bochs_drm drm_vram_helper=0A=
aesni_intel drm_ttm_helper ttm crypto_simd cryptd drm_kms_helper=0A=
syscopyarea sysfillrect sysimgblt fb_sys_fops raid6_pq drm i2c_piix4 sg=0A=
parport_pc joydev i2c_core parport pcspkr nfsd auth_rpcgss nfs_acl lockd=0A=
grace sunrpc ip_tables xfs libcrc32c sd_mod ata_generic pata_acpi=0A=
virtio_net net_failover failover ata_piix virtio_pci=0A=
[  587.766786]  crc32c_intel virtio_pci_modern_dev libata virtio_ring=0A=
serio_raw t10_pi virtio floppy dm_mirror dm_region_hash dm_log dm_mod=0A=
[last unloaded: nvme_core]=0A=
[  587.766819] CPU: 14 PID: 12543 Comm: rm Not tainted 5.12.0-rc1nvme+ #165=
=0A=
[  587.766823] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),=0A=
BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014=0A=
[  587.766826] RIP: 0010:warn_bogus_irq_restore+0x1d/0x20=0A=
[  587.766831] Code: 24 48 c7 c7 e0 f2 0f 82 e8 80 c3 fb ff 80 3d 15 1c=0A=
09 01 00 74 01 c3 48 c7 c7 70 6c 10 82 c6 05 04 1c 09 01 01 e8 cc c2 fb=0A=
ff <0f> 0b c3 55 53 44 8b 05 63 b4 0c 01 65 48 8b 1c 25 40 7e 01 00 45=0A=
[  587.766835] RSP: 0018:ffffc900086cf990 EFLAGS: 00010286=0A=
[  587.766840] RAX: 0000000000000000 RBX: 0000000000000003 RCX:=0A=
0000000000000027=0A=
[  587.766843] RDX: 0000000000000000 RSI: ffff8897d37e8a30 RDI:=0A=
ffff8897d37e8a38=0A=
[  587.766846] RBP: ffff888138764888 R08: 0000000000000001 R09:=0A=
0000000000000001=0A=
[  587.766848] R10: 000000009f0f619c R11: 00000000b7972d21 R12:=0A=
0000000000000200=0A=
[  587.766851] R13: 0000000000000001 R14: 0000000000000100 R15:=0A=
00000000003c0000=0A=
[  587.766855] FS:  00007f6992aec740(0000) GS:ffff8897d3600000(0000)=0A=
knlGS:0000000000000000=0A=
[  587.766858] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
[  587.766860] CR2: 0000000000bcf1c8 CR3: 00000017d29e8000 CR4:=0A=
00000000003506e0=0A=
[  587.766864] Call Trace:=0A=
[  587.766867]  kvm_wait+0x8c/0x90=0A=
[  587.766876]  __pv_queued_spin_lock_slowpath+0x265/0x2a0=0A=
[  587.766893]  do_raw_spin_lock+0xb1/0xc0=0A=
[  587.766898]  _raw_spin_lock+0x61/0x70=0A=
[  587.766904]  xfs_extent_busy_trim+0x2f/0x200 [xfs]=0A=
[  587.766975]  xfs_alloc_compute_aligned+0x3d/0xd0 [xfs]=0A=
[  587.767027]  xfs_alloc_ag_vextent_size+0x18f/0x930 [xfs]=0A=
[  587.767085]  xfs_alloc_ag_vextent+0x11e/0x140 [xfs]=0A=
[  587.767133]  xfs_alloc_fix_freelist+0x1fb/0x4c0 [xfs]=0A=
[  587.767201]  xfs_free_extent_fix_freelist+0x64/0xb0 [xfs]=0A=
[  587.767262]  __xfs_free_extent+0x58/0x170 [xfs]=0A=
[  587.767317]  xfs_trans_free_extent+0x53/0x140 [xfs]=0A=
[  587.767391]  xfs_extent_free_finish_item+0x23/0x40 [xfs]=0A=
[  587.767493]  xfs_defer_finish_noroll+0x222/0x800 [xfs]=0A=
[  587.767553]  xfs_defer_finish+0x13/0x70 [xfs]=0A=
[  587.767607]  xfs_itruncate_extents_flags+0xd4/0x340 [xfs]=0A=
[  587.767673]  xfs_inactive_truncate+0xa3/0xf0 [xfs]=0A=
[  587.767735]  xfs_inactive+0xb5/0x140 [xfs]=0A=
[  587.767796]  xfs_fs_destroy_inode+0xc1/0x240 [xfs]=0A=
[  587.767858]  destroy_inode+0x3b/0x70=0A=
[  587.767868]  do_unlinkat+0x280/0x330=0A=
[  587.767881]  do_syscall_64+0x33/0x40=0A=
[  587.767886]  entry_SYSCALL_64_after_hwframe+0x44/0xae=0A=
[  587.767893] RIP: 0033:0x7f699261dfad=0A=
[  587.767898] Code: e1 0e 2d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f=0A=
1f 84 00 00 00 00 00 0f 1f 44 00 00 48 63 d2 48 63 ff b8 07 01 00 00 0f=0A=
05 <48> 3d 00 f0 ff ff 77 02 f3 c3 48 8b 15 aa 0e 2d 00 f7 d8 64 89 02=0A=
[  587.767901] RSP: 002b:00007ffd1f7ea248 EFLAGS: 00000206 ORIG_RAX:=0A=
0000000000000107=0A=
[  587.767906] RAX: ffffffffffffffda RBX: 0000000000bcf2f0 RCX:=0A=
00007f699261dfad=0A=
[  587.767908] RDX: 0000000000000000 RSI: 0000000000bce0c0 RDI:=0A=
ffffffffffffff9c=0A=
[  587.767911] RBP: 0000000000000000 R08: 0000000000000000 R09:=0A=
0000000000000000=0A=
[  587.767913] R10: 00007ffd1f7e9ec0 R11: 0000000000000206 R12:=0A=
0000000000bce05c=0A=
[  587.767916] R13: 00007ffd1f7ea3b0 R14: 0000000000bcf2f0 R15:=0A=
0000000000000000=0A=
[  587.767938] irq event stamp: 771691=0A=
[  587.767941] hardirqs last  enabled at (771697): [<ffffffff81121db9>]=0A=
console_unlock+0x4e9/0x610=0A=
[  587.767948] hardirqs last disabled at (771702): [<ffffffff81121d32>]=0A=
console_unlock+0x462/0x610=0A=
[  587.767952] softirqs last  enabled at (770516): [<ffffffffa0249ae7>]=0A=
xfs_buf_find.isra.27+0x657/0xb90 [xfs]=0A=
[  587.768011] softirqs last disabled at (770514): [<ffffffffa02497c5>]=0A=
xfs_buf_find.isra.27+0x335/0xb90 [xfs]=0A=
[  587.768070] ---[ end trace 4eaf6d15d7cbe576 ]---=0A=
[  609.672358] run blktests nvme/012 at 2021-03-04 14:27:03=0A=
[  609.745797] loop0: detected capacity change from 0 to 2097152=0A=
[  609.764592] nvmet: adding nsid 1 to subsystem blktests-subsystem-1=0A=
[  609.800956] nvmet: creating controller 1 for subsystem=0A=
blktests-subsystem-1 for NQN=0A=
nqn.2014-08.org.nvmexpress:uuid:e4cfc949-8f19-4db2-a232-ab360b79204a.=0A=
[  609.802545] nvme nvme0: Please enable CONFIG_NVME_MULTIPATH for full=0A=
support of multi-port devices.=0A=
[  609.802909] nvme nvme0: creating 64 I/O queues.=0A=
[  609.823959] nvme nvme0: new ctrl: "blktests-subsystem-1"=0A=
[  611.525467] XFS (nvme0n1): Mounting V5 Filesystem=0A=
[  611.534398] XFS (nvme0n1): Ending clean mount=0A=
[  611.534715] xfs filesystem being mounted at /mnt/blktests supports=0A=
timestamps until 2038 (0x7fffffff)=0A=
=0A=
=0A=
-ck=0A=
=0A=
