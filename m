Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7FE21B1DB
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 11:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGJJBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 05:01:03 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:30265 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJJBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 05:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594371663; x=1625907663;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=RSbpFKTbhMk1mgcdtZ7aUuAgwwNIh281CEDooyKHlHk=;
  b=mOkXZ+Nff1fyZY8Y94mXupAajzAQuntsEjB6jdfrgsCYDwfREIfVB7qR
   q1GKldS1dRLJb4UawNWTfciBmu47rOa+3qbQ9cwERq0YHU2mhKXzrzmJ5
   sJDHX5zIZXfurCAstwyLD4PxtVKXH6mzC+LbT6cqFCGr8PpIyDC25DkCh
   dp4dCJZJiod9NA5wEWmtiTSsrqPf+l0I7U/TjrbaYMJvQRMgKMyl1RqyP
   h/rl4X9TxJ0kfTNNt2ONPwZd53uNIWHKTbFT522xuzsVOmpoyAegHNs4/
   bXtKSzCaFGtMw1adBVgn04ligO7lYRzqZfZWcyO5YXTXNreoYjTwOEYFZ
   Q==;
IronPort-SDR: AD1b/wugxXYq00kuxSwE9QzjeLtmBaFrcxIRj5CNNA3d1i4gQpXfHia2hvM5qSrKkP+3K+Nzja
 h8mXXVv3NKtTTwkys9D4q+v5LIvip3USf5NpaZoBwdie/gMDbwra7qKb716ybmG8/5RpTj1qx8
 U0rmhKmd6F6WwK8oAMhPhyyerM5uuj5R5pJlhI/dz80I/CxX2PNBjCl6KjATICSx/ZZKU8MdKV
 f05OJtdVShBOOYDEto/mPcwLwNl5KZGyYFORAZAvi81p/l5fHKG0z1oSf2+cqbPDmOn81qx48B
 T7E=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="251358817"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 17:01:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0qIOOBvGOWCwwmPEzcBSznZ4CvP/MpdzbwfEWUo7wDm18AKclOJttxd3AcU1Qw9d+XM5WmN+iWgnq7SEHAOS38h1xXLk0yVfNAc3vvUfFco/ziKivYdKvoZ62Q+kySgjtFiG4oAAzHnWezl0s+m/6u4NtElxent+2pxQqClgvlnKG8TdQhdLlO28hxi/tS0+Ofv3yE2NGtAy71M/fZMojlzStksSVQpC/BqNfgj1nDk/Hzf1V2lsjmnjVvC3Kaz9NqyDVwe3JuQsnoujjlzsC98ltv+rutryQMQX1vd6c2FTjG5PPL8I6mkjhHOJUbBRvUL99bRX5twoxsxHYrCXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIrRnDBpWIEWDJSQzVVYi9a6Hjp93fx+7cTzMfzIE6I=;
 b=LBJrEs3+WoL3FcZOldskL11URCD2fT/H8JEoh2PpDjKqt+N8VmVesux5GWbBCL0KXARmmFDi56VggL6JmRetm8eQN19R8hlwnsfC5agXdJsBhyn/UoirP4/6PRewWDj6sbfx2oQXMxIUBwxxEoEYFdDYavmoD/maFKGmRku6DqlOBI7t85idvPHjS/vuH/5REtjyt8BgscDYnq15r2nobtlAO/1Y8WMPaF9mn+AFDhZHqoIg6zR+joq+HiJbhQ/KpMDlku5glzt+uOR6M2nM6CAOvkxgGMWSWeK16GJEcznxRsf+iEjOOCLHdx+FtSgW/DleiSmqYyWDUb+Ezaw88g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIrRnDBpWIEWDJSQzVVYi9a6Hjp93fx+7cTzMfzIE6I=;
 b=oGBzH4hCSpPlttyvUOi0UL+uxiXmdEXXYuspeMEEQv4STM4I2yybonTSlizhHjBQtFBs+x6rZZi5J4dIIcTHXlZwA8XrbI0qviSnpR0e9H2dhZVzpXzAKkzfB0hLj9/R7WdaqswZ47CRYO2KPCe3bD0dWqLX20SKs1WkqdzVwQo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0346.namprd04.prod.outlook.com (2603:10b6:3:6f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Fri, 10 Jul 2020 09:01:00 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 09:01:00 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v4 0/8] KVMTOOL RISC-V Support
Date:   Fri, 10 Jul 2020 14:30:27 +0530
Message-Id: <20200710090035.123941-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 09:00:56 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dde5dfb7-479b-4ff0-f147-08d824afc3b8
X-MS-TrafficTypeDiagnostic: DM5PR04MB0346:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB03468F46C8F0D40943DB39D98D650@DM5PR04MB0346.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDR7/UOuL/BhHllRsOFZMmzuvIshge7sVQ6OFJ/MCziRgliYHzXegwBDtQk51GvZmaWxsF5jiFfjSxc4ZU4LLMh/yeDDaSJI+ifHF8h+c8Bw36AMDWYI46TVs6eEMaMp8kccBOMjOI9MTHupzQ6vlNAuyXtzjOLqxjytWUgodB+nCRGZf8SAFKVfG6gE9zcKMD3eofe8Z2E47yhAnDyKFr+3APPYVZo+Z/RygwMWFUP+d/Wg7qojTaBN36j3v/pgK1l1TdciItFf2He63ScqO0i2yHdLNQVFTtXS1cQkeo9OsdSebvMAI4mRvyVigLQfKPjzeeX0RMyPxqUtbnjpAKSECkEy60rGdfj0AUe2H0ZE0GRLI6X7CkCzrUgybFqUFDVTVTDwY5g1Re8D1fWm2kY9YqWfDkS2xBBbTyJtMM8hD2zA1PR2p9Nbc5G/NyciTgXKR8PldnTN/vCuOSxuQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(66476007)(186003)(66556008)(16526019)(6666004)(52116002)(8886007)(1076003)(6916009)(86362001)(7696005)(36756003)(26005)(66946007)(4326008)(5660300002)(8936002)(956004)(2906002)(2616005)(83380400001)(55016002)(478600001)(316002)(966005)(44832011)(8676002)(54906003)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: efFxrTiFN7sFHaPItsuG48sDwq3iKTGN0Yj+7tg34UnRzjqSU3UvlLBz0+OGALqa9T+YcCC+vxrEQyf9WPWKIza27ocAf4X/45hPaqIIvWKp+PYM9u5DDH3DJnCGmbIUB28gqZYeL9AQmJQ4UK/cStUsAcbQG0sI/rLhIOOZL1XOrUbTD4ennZ8bqqNde0iQaqlyop1X5iTAOkya0uR8EE6X/5xgsy4cCJskown4R984pbH5v0pCa74PhZWKnhV99WnoU2q2u38F1+wTlAKytwQSOn3AU0wpkHd9cCOl4eZCRVDFSr96h2fMaWbSXk3SQn8tdvqRUkcA5gV4Fp/cH/gZU3Y1n5zhFo2sneMOlcyPVj2FehUY7oE6MzTaQ+qdEIdN7mQrdQUCNVjdfTBCjB0/2STtOSlbkY7bWVST/tQTl8V+O7mfi3AOWUxxSw45gK9RLhzQzaWXrXZrW6CIC9nNg2BgKlyvvy2nbc6ycPY=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde5dfb7-479b-4ff0-f147-08d824afc3b8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 09:00:59.7707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mETqDGuLhm6YkXvBDFf4FhILbINxnkqDIAiCERHIF377IlOFMjEelWibViDry0SilEyX9ZLvfggzC2phrwPNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0346
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds RISC-V support for KVMTOOL and it is based on
the v10 of KVM RISC-V series. The KVM RISC-V patches are not yet
merged in Linux kernel but it will be good to get early review
for KVMTOOL RISC-V support.

The KVMTOOL RISC-V patches can be found in riscv_master branch at:
https//github.com/kvm-riscv/kvmtool.git

The KVM RISC-V patches can be found in riscv_kvm_master branch at:
https//github.com/kvm-riscv/linux.git

The QEMU RISC-V hypervisor emulation is done by Alistair and is
available in mainline/anup/riscv-hyp-ext-v0.6.1 branch at:
https://github.com/kvm-riscv/qemu.git

Changes since v3:
 - Rebased on recent commit 351d931f496aeb2e97b8daa44c943d8b59351d07
 - Improved kvm_cpu__show_registers() implementation

Changes since v2:
 - Support compiling KVMTOOL for both RV32 and RV64 systems using
   a multilib toolchain
 - Fix kvm_cpu__arch_init() for RV32 system

Changes since v1:
 - Use linux/sizes.h in kvm/kvm-arch.h
 - Added comment in kvm/kvm-arch.h about why PCI config space is 256M
 - Remove forward declaration of "struct kvm" from kvm/kvm-cpu-arch.h
 - Fixed placement of DTB and INITRD in guest RAM
 - Use __riscv_xlen instead of sizeof(unsigned long) in __kvm_reg_id()
Anup Patel (8):
  update_headers: Sync-up ABI headers with Linux-5.8-rc4
  riscv: Initial skeletal support
  riscv: Implement Guest/VM arch functions
  riscv: Implement Guest/VM VCPU arch functions
  riscv: Add PLIC device emulation
  riscv: Generate FDT at runtime for Guest/VM
  riscv: Handle SBI calls forwarded to user space
  riscv: Generate PCI host DT node

 INSTALL                             |   7 +-
 Makefile                            |  24 +-
 arm/aarch64/include/asm/kvm.h       |  21 +-
 include/linux/kvm.h                 |  95 ++++-
 powerpc/include/asm/kvm.h           |   3 +
 riscv/fdt.c                         | 195 ++++++++++
 riscv/include/asm/kvm.h             | 127 +++++++
 riscv/include/kvm/barrier.h         |  14 +
 riscv/include/kvm/fdt-arch.h        |   8 +
 riscv/include/kvm/kvm-arch.h        |  85 +++++
 riscv/include/kvm/kvm-config-arch.h |  15 +
 riscv/include/kvm/kvm-cpu-arch.h    |  51 +++
 riscv/include/kvm/sbi.h             |  48 +++
 riscv/ioport.c                      |  12 +
 riscv/irq.c                         |  13 +
 riscv/kvm-cpu.c                     | 490 ++++++++++++++++++++++++
 riscv/kvm.c                         | 174 +++++++++
 riscv/pci.c                         | 109 ++++++
 riscv/plic.c                        | 563 ++++++++++++++++++++++++++++
 util/update_headers.sh              |   2 +-
 x86/include/asm/kvm.h               |  21 +-
 21 files changed, 2063 insertions(+), 14 deletions(-)
 create mode 100644 riscv/fdt.c
 create mode 100644 riscv/include/asm/kvm.h
 create mode 100644 riscv/include/kvm/barrier.h
 create mode 100644 riscv/include/kvm/fdt-arch.h
 create mode 100644 riscv/include/kvm/kvm-arch.h
 create mode 100644 riscv/include/kvm/kvm-config-arch.h
 create mode 100644 riscv/include/kvm/kvm-cpu-arch.h
 create mode 100644 riscv/include/kvm/sbi.h
 create mode 100644 riscv/ioport.c
 create mode 100644 riscv/irq.c
 create mode 100644 riscv/kvm-cpu.c
 create mode 100644 riscv/kvm.c
 create mode 100644 riscv/pci.c
 create mode 100644 riscv/plic.c

-- 
2.25.1

