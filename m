Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCBA199450
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbgCaKyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 06:54:06 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1490 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731003AbgCaKyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585652046; x=1617188046;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=8NjGO2zEjzVhqWRimhrXKVoUlyiLoSMwgTQbyhOfgNM=;
  b=L3GnqzdAHZC6VhB30Z+oZFcHX+Jtmbnm3jJThggyEW3LjIB3jyEPRlb1
   XpulybVPXb94BZetrZ53X6iXbG7SrBzZLWiVRs/zQF4rSko2Qe1ed2foV
   D/FASAZ6DnjfRju1AakqtBGnpJm7i0p4oDz2o4+L96JipgGohDV3zfqU5
   UWmGqOeFqmTjaIz0POFvUHddjwVwB0ns75QSsWL1K1Qx1nVQo2lJLP2ii
   FbFBXbviX7jg2+TM8td/LRFSkGqbj6cp42fH9L67uIHIopbKNYON3mA8A
   KuDENNVvzJPMbHcnRcZUlSYPi/wRGQ3/ohd9H60KB4MHv77sxr6iORDDp
   w==;
IronPort-SDR: bDGeStc4yCh08TRops/bC9mwjLCkVOZfxgeb/5E+tQF7BOLCWGuSUTV+a40oScZtGprsgBNyUO
 ONhX7hmi5vwKpfjeoTkVyaL4AjRXOBqCZ0gueh8asHbzg9mbRbcFlC3kouWq+QVLxTm+nOuE4/
 a7Q15MrBj7PDaTzD2/5hNmx5xt+wF4OPuGC+JPNgW0yQ/zIfC1nTQp/gM3CvpCK1LpnvWCGcTA
 hdOoBEGPkCSCD444IPnigll7BHSypUOrRbFwnrOavHisUgdS7wGCBVQD6rbJjqI8Y9Q+rIWe3C
 xx0=
X-IronPort-AV: E=Sophos;i="5.72,327,1580745600"; 
   d="scan'208";a="138377087"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2020 18:54:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpGT3Jbw35JHGIWh6UeDZXHpF44ynDQjxPcmO38iaJ+Hy4elB9nlwb5QjI1dJ2mOIE290gMLU5yGim5ECZuGiyvyG1A1ZBOmLZuht+FEZuPQNja6Omt8qjWZJEHju/fR5t8u5i9QQsMMSuvkEnY4iNFRGKH1x3ozO2YrvfYldNHSV2bPIwR2Im6CEQSCZiQrEMWINjKWoUj1c1DZy6EldT7MgLs3srPtXN3oWGq2zCW2QcR3Ilj/uxE6otsHaW4w1fARe4hA4X2PzPkasTyLaO1Vj+AGCNoRHzVfSNUxTti2cjjr7Xu1NEspXc+Irz+4atRCbUeP6Io6LXDvsYKnQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Bel8HatHqQkfbApVlPLcXsm11/bPRJ0SSuXIba9Sow=;
 b=FAzBNIpXCjbBXBefYLVJ5MXtuP9ZYZnuLA5NiAighHRGnr63XLbw4/4u7IsAz0JFa1hC9/OKY3f9J+YeUa/6jIY4Ksggcs7vHqkCNNnE6hwCB3bjtvLGVik7a7PmVWVjAk6ZiBQil9JYT7tS1wGvwCF6yOxXBczfXdyD8f4t1qCCp8iosKlILoSQSrhS+/SL9q0Zzcl0qs6a35CEJ47hQusfJrqAm1YtWKgVdXuU/+HrqcOK+Jka+ZmmmkSQBWw4LN0737/H0/GbIW8OOnoiCPYXgcdcehVPElsanHrlwm5u26XC6yHy01r1P8x6+Yv7PUpYRxo4jjBflP1dLOal2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Bel8HatHqQkfbApVlPLcXsm11/bPRJ0SSuXIba9Sow=;
 b=IisP3za74+jbOXpYxZ/Gm7oyN377mr0Epuc1t6LyA6jUcX7J+yMgrCC7jh5qoTmGrpRaMcPxkt9+uMIb41GHnFPj1yAxikLM65ie5LmQps6RWEAtWdUZ/cjq86r99ZeqPv/JPiFSzwgUCG70e4xApWhm0Da+q9Zeh1TYssQbjrg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB7088.namprd04.prod.outlook.com (2603:10b6:208:1e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 10:54:03 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 10:54:03 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v3 0/8] KVMTOOL RISC-V support
Date:   Tue, 31 Mar 2020 16:23:25 +0530
Message-Id: <20200331105333.52296-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.117) by BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Tue, 31 Mar 2020 10:54:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [49.207.59.117]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 72e1e799-92fd-45b3-2c10-08d7d561d369
X-MS-TrafficTypeDiagnostic: MN2PR04MB7088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB7088D5F10EDACBA3F3FD0E138DC80@MN2PR04MB7088.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6061.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(8886007)(1006002)(6666004)(2906002)(966005)(478600001)(316002)(7696005)(52116002)(36756003)(6916009)(54906003)(16526019)(81156014)(8676002)(186003)(2616005)(81166006)(1076003)(8936002)(55016002)(44832011)(5660300002)(956004)(66946007)(66556008)(86362001)(26005)(4326008)(66476007)(55236004)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+JRVmboCHisD87i5R4fzAXLB7iodeMlW2nVxW8UIe6fgKJqYMO/y4yjAqEhsep2lVcCoVdWfTZ9Ox1+TpqrrhuxGt8Izw22+hQgfqZ8USasekNH4h2yT7j+d560gNlWiEdleD7Mor6DJS/YYKw3JGviU9JtG4yexF/igmMMXeabM7Nf/HaAfEPuP+0SZWvZUSPNpGr9OGhWawXo6YXhAzms1y+LJY0x9KQTgZA6cZonJaewHwee1MA00F0vgEw+PaDLhCwD99EHzoQBs11fFfAxQ1ypJQcH9HYAq1e1lT+60B9FYEmLHzRhDRsAILSh3ke1LjILq0jK8zDqsDeJey3KcJkBrJLIpId8Lntvosz7PbzE0z85pIMz/Vl5tRnSH0P5J4dXRYlmG97EptfzfwHhT1MLrXMIP4Gmc723gdliZI9bms5MTCpYW/uwYvk3eR1W4vRm/KYNB+PII/UlpRdeOUzB7mgh1Zi74GF0wkz+s+ZXWTPmRJQTkf4QQeEadl427KMWvotEhQzGq30va+8v0lwhAqTfu0dlyyGasnixob7jUMErXwreH1BYIqNWNFiEviWyDknjoyu0seP2bQ==
X-MS-Exchange-AntiSpam-MessageData: e6pnTMJfq7fh7qq8tGImKR9/gxjr9ZHlThFOXdCH2IciLKAj3nzvJV5CKsyKegwaWysid0hGzqar2TmQrRCmOS/92AfusiaC3JQMUhdnUgsF0LGQVvgtUFYGadpxu9HXu856jMa06f0uoCkyyG7IUw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e1e799-92fd-45b3-2c10-08d7d561d369
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 10:54:03.5181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: krA2y2Ui+SMVCxvbmnhl8l/qaH8Cb/zPQEVfMF02c4xGjk1MxnsTQ3nRCIz3NG58PJsS5c8DBzxcQ8hwirKMng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7088
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
available in mainline/anup/riscv-hyp-ext-v0.5.3 branch at:
https://github.com/kvm-riscv/qemu.git

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
  update_headers: Sync-up ABI headers with Linux-5.6-rc5
  riscv: Initial skeletal support
  riscv: Implement Guest/VM arch functions
  riscv: Implement Guest/VM VCPU arch functions
  riscv: Add PLIC device emulation
  riscv: Generate FDT at runtime for Guest/VM
  riscv: Handle SBI calls forwarded to user space
  riscv: Generate PCI host DT node

 INSTALL                             |   7 +-
 Makefile                            |  24 +-
 arm/aarch32/include/asm/kvm.h       |   7 +-
 arm/aarch64/include/asm/kvm.h       |  21 +-
 include/linux/kvm.h                 |  30 ++
 powerpc/include/asm/kvm.h           |   3 +
 riscv/fdt.c                         | 195 ++++++++++
 riscv/include/asm/kvm.h             | 127 +++++++
 riscv/include/kvm/barrier.h         |  14 +
 riscv/include/kvm/fdt-arch.h        |   8 +
 riscv/include/kvm/kvm-arch.h        |  85 +++++
 riscv/include/kvm/kvm-config-arch.h |  15 +
 riscv/include/kvm/kvm-cpu-arch.h    |  51 +++
 riscv/include/kvm/sbi.h             |  48 +++
 riscv/ioport.c                      |  11 +
 riscv/irq.c                         |  13 +
 riscv/kvm-cpu.c                     | 408 ++++++++++++++++++++
 riscv/kvm.c                         | 174 +++++++++
 riscv/pci.c                         | 109 ++++++
 riscv/plic.c                        | 558 ++++++++++++++++++++++++++++
 util/update_headers.sh              |   2 +-
 x86/include/asm/kvm.h               |   1 +
 22 files changed, 1900 insertions(+), 11 deletions(-)
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
2.17.1

