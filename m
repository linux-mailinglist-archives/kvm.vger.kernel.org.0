Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57F67EDC4
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390051AbfHBHq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:46:58 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64637 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfHBHq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732018; x=1596268018;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=ySrGdBz8+mepbRHPgMNAFkoede7afn/0rhlkTyMV/ko=;
  b=IHZEjHYjHTOIaOnlk73nVgIb6DnwCjd1zVf/qWUAER0R17L5JSH5wT7e
   mSLN2YHNE2AXAS2aC6qA5E7ztIZTNn7HQNRqzYOi8iiR/eQMegm8Llm+0
   wXPOQq77CKodcMDgvUmlJrxB3WJeqxtoXqQZzoLgtjBuNHneVHut3Nv1M
   dvDOGoTKZm60ZjzR9ljdUKOyva6bmWhJtKO+AZBUlJs434vcFbxv+PdjO
   EoJHM1yUHFMo1THLnPa8KL6FvrXvf67yAAqq8Qc09fUuiwrzIbys4RnnQ
   BqhAy4tuR7LDv+E9XfL3ob9ugH82GVpI3lnahfSI12Cih4vnoCKa8FZ8d
   g==;
IronPort-SDR: zrxWfLSjCrBfIT+QTz5dPlsQwgqfLhWExkXNQZflLXc+96z8McEYuh5ldoJpGCnBlGX+T3q04j
 dgdB2w7BGX6vmRqviemzJiUDYM6B+b12V8ntb3I9sFQN6t2LlCvikdklzYSSp4Ys15nWtrqBsh
 GOCNmPi8Ib+NbPznGcrk3Ksg20Ini+RuIi4QQhPBsvZB9pJVy+HmiczMJx6axgPfae2/YOUu1V
 6iNAiz0vdvpsg14GOBsfc5tdNnuNBaPUQB8WBKvlHCu/NLnP5nhGlmWzDK5ARlZBE0h8e+xm5e
 prI=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="116382430"
Received: from mail-cys01nam02lp2054.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.54])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:46:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpKLabwnepj+mv91c4TzeBBIs2tRvsnPTa4jG06dXG+5R0zNNVI1hxjXB6pwsSfIWhCsezPQ6CMHdtXT/VzgUK8JrdUHdyqH3urETuge8GjaCXVLN5zMZiSiMKUrk2dotz/AaQqa35Pfv21MFjdZv11DqjRnLgNidU4dnv02QofntXwoi8eCcBlB/CQGtXHtXk9BqlCPFpG6q9vbOd/MCTKqAS/Z2+BUmsGrvWf6wpGbxbWh7yK2NX1/9IbIwWbSrAn0EjVU51guzt7M7jUX70LVGGzBj0gpB1AJm4USO1nJf/suBgAjySbBcOtAvs34Z8e817cdfGZCF28+Iouebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83/1uV1MBJ75j22TCDvsq+vhFkRSloCFZYxmLBm/DVY=;
 b=jeiPlUGTH1SIUtO/s/U1dI7Gpcs1yQNcsTnNaQKfwL3O1LVuSL218vvqZiO44ezDxxDa2bfK7a5ztR2940g57BJc4DCjg0zsKOPbPooEfB9vDv7U5q1KxMmVGkBCguY4QFtyaBaW/cHV66UqtkGwTwxkGAZJomHIx+ZwwKi0SxzuTsli3sjdjzk7Xzd7H9AH7DNTcUSzuThdy61jjGSUsGnEquLB+lkY4psqMY/5fGDNb4up/U2yHRldHrk9Webe3mihYWszRUaXhkADMJJRTpZo1fIYyiCD30AjP+7RZgQ8cDI9QikeoBdUesz3TqlVQxWdWZLeORaZiBuBbZEx4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83/1uV1MBJ75j22TCDvsq+vhFkRSloCFZYxmLBm/DVY=;
 b=eNpuMMh43B4v3Mdn+dNYCUqPVZT1lpC7sen8xQrSYhEfZd/Ndoj1Aw2k6r+7wHZuRN80/xfQBoR39/4lFvuwc1ZuzBTJUYF0SHXR3r+nJMqn9gnMhmn+mXe2ogr3OFY1WHEvZQfox83q813CGQO05u/rrovGKvSDvOBTXyx41y8=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5566.namprd04.prod.outlook.com (20.178.248.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 07:46:54 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:46:54 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [RFC PATCH v2 00/19] KVM RISC-V Support
Thread-Topic: [RFC PATCH v2 00/19] KVM RISC-V Support
Thread-Index: AQHVSQZ0LiMZv8p/N0WUPDIsIAdXhQ==
Date:   Fri, 2 Aug 2019 07:46:54 +0000
Message-ID: <20190802074620.115029-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0111.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::27)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 777e4781-e879-4e0d-9397-08d7171d967b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB5566;
x-ms-traffictypediagnostic: MN2PR04MB5566:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR04MB5566A53AB5F33A3EBCE084058DD90@MN2PR04MB5566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(189003)(199004)(36756003)(14454004)(7736002)(54906003)(6116002)(102836004)(110136005)(71190400001)(966005)(4326008)(3846002)(5660300002)(52116002)(66066001)(2906002)(25786009)(6486002)(6506007)(386003)(55236004)(316002)(53936002)(6436002)(305945005)(9456002)(81156014)(64756008)(66476007)(78486014)(86362001)(66556008)(66946007)(8936002)(476003)(68736007)(81166006)(2616005)(478600001)(486006)(26005)(1076003)(99286004)(50226002)(14444005)(6306002)(256004)(71200400001)(66446008)(186003)(6512007)(44832011)(8676002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5566;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NV51pMzEdrZj7/6CLhsV9ldR8286dmPPZlmsGZTYvFFKAdUxQ4VoY7mVKpURwXinAe9Y7OBNzhHhq0NODtkwthv9idCVkIM9M95SC0jiH4lNUnD+O7cPggOdOswOvcbZj3DKaYQ+jQo/seQop6GgVgsQSlV7fa1VQ2TlumauVv1QnHZIWet+G/3q2W/9TvRj0e8qoCIvIAvnKVC5M/C9d01TkfNmqnstL716nduH7ITehe/AOE0UH49TQt2N3fvdBvYtizQCljtllr25n3yQBwrZG5z5VnzsEE3ZX+aUdo3tkJK3QodsP7WRzdjR3lmzzyy++PiCn24ErsT0GyXRDArBl9hFsvlMkoBWd06ROcvNnWIRYw6R+7PxSeHEv+d4S5tmypY9i9DNjAkhmqwZJh+2yamoq1LJv3EJA07y/ew=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 777e4781-e879-4e0d-9397-08d7171d967b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:46:54.4255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5566
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds initial KVM RISC-V support. Currently, we are able to boot
RISC-V 64bit Linux Guests with multiple VCPUs.

Few key aspects of KVM RISC-V added by this series are:
1. Minimal possible KVM world-switch which touches only GPRs and few CSRs.
2. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure.
3. KVM ONE_REG interface for VCPU register access from user-space.
4. PLIC emulation is done in user-space. In-kernel PLIC emulation, will
   be added in future.
5. Timer and IPI emuation is done in-kernel.
6. MMU notifiers supported.
7. FP lazy save/restore supported.
8. SBI v0.1 emulation for KVM Guest available.

Here's a brief TODO list which we will work upon after this series:
1. Handle trap from unpriv access in reading Guest instruction
2. Handle trap from unpriv access in SBI v0.1 emulation
3. Implement recursive stage2 page table programing
4. SBI v0.2 emulation in-kernel
5. SBI v0.2 hart hotplug emulation in-kernel
6. In-kernel PLIC emulation
7. ..... and more .....

This series is based upon KVM pre-patches sent by Atish earlier
(https://lkml.org/lkml/2019/7/31/1503) and it can be found in
riscv_kvm_v2 branch at:
https//github.com/avpatel/linux.git

Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v1 branch at=
:
https//github.com/avpatel/kvmtool.git

We need OpenSBI with RISC-V hypervisor extension support which can be
found in hyp_ext_changes_v1 branch at:
https://github.com/riscv/opensbi.git

The QEMU RISC-V hypervisor emulation is done by Alistair and is available
in riscv-hyp-work.next branch at:
https://github.com/alistair23/qemu.git

To play around with KVM RISC-V, here are few reference commands:
1) To cross-compile KVMTOOL:
   $ make lkvm-static
2) To launch RISC-V Host Linux:
   $ qemu-system-riscv64 -monitor null -cpu rv64,h=3Dtrue -M virt \
   -m 512M -display none -serial mon:stdio \
   -kernel opensbi/build/platform/qemu/virt/firmware/fw_jump.elf \
   -device loader,file=3Dbuild-riscv64/arch/riscv/boot/Image,addr=3D0x80200=
000 \
   -initrd ./rootfs_kvm_riscv64.img \
   -append "root=3D/dev/ram rw console=3DttyS0 earlycon=3Dsbi"
3) To launch RISC-V Guest Linux with 9P rootfs:
   $ ./apps/lkvm-static run -m 128 -c2 --console serial \
   -p "console=3DttyS0 earlycon=3Duart8250,mmio,0x3f8" -k ./apps/Image --de=
bug
4) To launch RISC-V Guest Linux with initrd:
   $ ./apps/lkvm-static run -m 128 -c2 --console serial \
   -p "console=3DttyS0 earlycon=3Duart8250,mmio,0x3f8" -k ./apps/Image \
   -i ./apps/rootfs.img --debug

Changes since v1:
- Fixed compile errors in building KVM RISC-V as module
- Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()
- Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are implemented
- Made vmid_version as unsigned long instead of atomic
- Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP
- Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_hgatp(=
)
- Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()
- Updated ONE_REG interface for CSR access to user-space
- Removed irqs_pending_lock and use atomic bitops instead
- Added separate patch for FP ONE_REG interface
- Added separate patch for updating MAINTAINERS file

Anup Patel (14):
  KVM: RISC-V: Add KVM_REG_RISCV for ONE_REG interface
  RISC-V: Add hypervisor extension related CSR defines
  RISC-V: Add initial skeletal KVM support
  RISC-V: KVM: Implement VCPU create, init and destroy functions
  RISC-V: KVM: Implement VCPU interrupts and requests handling
  RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
  RISC-V: KVM: Implement VCPU world-switch
  RISC-V: KVM: Handle MMIO exits for VCPU
  RISC-V: KVM: Handle WFI exits for VCPU
  RISC-V: KVM: Implement VMID allocator
  RISC-V: KVM: Implement stage2 page table programming
  RISC-V: KVM: Implement MMU notifiers
  RISC-V: Enable VIRTIO drivers in RV64 and RV32 defconfig
  RISC-V: KVM: Add MAINTAINERS entry

Atish Patra (5):
  RISC-V: Export few kernel symbols
  RISC-V: KVM: Add timer functionality
  RISC-V: KVM: FP lazy save/restore
  RISC-V: KVM: Implement ONE REG interface for FP registers
  RISC-V: KVM: Add SBI v0.1 support

 MAINTAINERS                             |  10 +
 arch/riscv/Kconfig                      |   2 +
 arch/riscv/Makefile                     |   2 +
 arch/riscv/configs/defconfig            |  23 +-
 arch/riscv/configs/rv32_defconfig       |  13 +
 arch/riscv/include/asm/csr.h            |  58 ++
 arch/riscv/include/asm/kvm_host.h       | 228 ++++++
 arch/riscv/include/asm/kvm_vcpu_timer.h |  32 +
 arch/riscv/include/asm/pgtable-bits.h   |   1 +
 arch/riscv/include/uapi/asm/kvm.h       |  98 +++
 arch/riscv/kernel/asm-offsets.c         | 148 ++++
 arch/riscv/kernel/smp.c                 |   2 +-
 arch/riscv/kernel/time.c                |   1 +
 arch/riscv/kvm/Kconfig                  |  34 +
 arch/riscv/kvm/Makefile                 |  14 +
 arch/riscv/kvm/main.c                   |  84 +++
 arch/riscv/kvm/mmu.c                    | 904 +++++++++++++++++++++++
 arch/riscv/kvm/tlb.S                    |  43 ++
 arch/riscv/kvm/vcpu.c                   | 936 ++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c              | 554 ++++++++++++++
 arch/riscv/kvm/vcpu_sbi.c               | 119 +++
 arch/riscv/kvm/vcpu_switch.S            | 368 ++++++++++
 arch/riscv/kvm/vcpu_timer.c             | 106 +++
 arch/riscv/kvm/vm.c                     |  86 +++
 arch/riscv/kvm/vmid.c                   | 124 ++++
 drivers/clocksource/timer-riscv.c       |   8 +
 include/clocksource/timer-riscv.h       |  16 +
 include/uapi/linux/kvm.h                |   1 +
 28 files changed, 4009 insertions(+), 6 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_host.h
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/include/uapi/asm/kvm.h
 create mode 100644 arch/riscv/kvm/Kconfig
 create mode 100644 arch/riscv/kvm/Makefile
 create mode 100644 arch/riscv/kvm/main.c
 create mode 100644 arch/riscv/kvm/mmu.c
 create mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/vcpu.c
 create mode 100644 arch/riscv/kvm/vcpu_exit.c
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c
 create mode 100644 arch/riscv/kvm/vcpu_switch.S
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 arch/riscv/kvm/vm.c
 create mode 100644 arch/riscv/kvm/vmid.c
 create mode 100644 include/clocksource/timer-riscv.h

--
2.17.1
