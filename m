Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8022B2AB742
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbgKILhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:37:40 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28154 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgKILhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921858; x=1636457858;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=6zoCEcDzBlY+MvJa96aL5yOujWiEDYlPehO+wFsNorc=;
  b=hevjU/u+6zCNc97OV7pKCCKlz/SnAMTbHOHOuILoDp0KFRFf0aJ2DopZ
   JazU+lrTVJPCDNa6urwweXskYQmsFVTABIHCZcWFclHbg8K4lv+PScTvc
   nyS+a9NLzn3bWBJ9DvtkSvBX+zJ4YdlgNg1a2D+o/LJ8uaWM3StZ8UuZ8
   G9Mq2Bbc1by4o+IbL4X4NK6K3EydlIEC+oSnBS37W+ZiV9ZbWHSJHDHN8
   63bNfSfssSP9M0zLeRjgsU21EUKVOwEwC/NbAsCoOipYxzTKytXuRfpsi
   kxfGc5twmkviDZknRWsmH0dEBon5L8276CGNfmiHwedN6OqU9+/Vz/UDz
   w==;
IronPort-SDR: vkx2gM2mchtyTRkscw+OpuoZLLDxDBNswlGwmItV+CdhDtuRRH53KJl8286SgUYJrtMpTO3Ao5
 vzd4/M4hFu19Kp6e8PpuvM3WjFaG+pwZFszcAVkKK3o2asueqxCT7tC+eOiP0tnkehNrassbYL
 D4/AfNkhxy0+O58Dr1P7fZj5HAdREdeHu9If5tcPbbb+EPqSM8cWbkAGIHk2ebt85NQDR6d30a
 sQby+AcIVBZUBXUucKp6hgdLa9mylyAHFFtMLlfet0phBtuZTccBdnIGeg/cvN4d76PbwxqdeD
 tr0=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="153383025"
Received: from mail-bn8nam08lp2044.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.44])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:37:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foPfai0gYDUw7BaKcKlxcT4ETcg2Qj6f52rCIZUhKkN+FbONcVLCAU9VnPtr8qzaAFgEWqGoHyfloxYHeGNdoVhqnqdYGBiPja/+HbOFF8Ev62E0GQP5iknKNNNrN6pnzxxRFu9v4ferbwieGjDNsQTtuuNVpQtXb1364XAAo7fPaeoId7WZ0qQ2rAHUUS72JD6Ik05MaNeg4C+J0/Lf/ajuLMPKtTWKs8fveGzIPXHdKK8l3VNSx56klQnfEOtmK77CO5dnR28sf5Cz9DifRho8rKMznbiTfuHPPb7MrjIDpy6tJvb0Z88DERRb0Mc+HNFGcjiH8EKB+qZVExDlMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVcfIdSKGzkhE/vCyHpFBUrtvaEP1YMRFNO3518V/30=;
 b=J8nrt4+lTpkRy0m63IgIFimD9vcoPRPA/p3i+9WIH0nK19o1RZouRHFq8j5db4yeCAZvjjajC7Ht/qK+9RoTtrURCMPxDO7HI1cuMEFR2tJcvyEKw7aFN4qI/Y1emHNPm0aJlmeDkuakuNgLeP6EzUjNfvT+flJgIbNnJ3jXIEvceXela5+lMiaerh++KedO4gIl0QyeBSna7JrrabfFQ42r+2ViMtHlTyBMxR5AEpKIHtMxUQqr58SljQw8EphXfWCVtuHtTZ7UqmOQs/a9dpmfZY9Jc3q6RQaBko1VgDUjdUsOxqseGNXM+kWRywZSN5YjghbC+uq7guT2YdPQBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVcfIdSKGzkhE/vCyHpFBUrtvaEP1YMRFNO3518V/30=;
 b=xkEUu3ovdXZ/qHaZRQGvm3zkdJwkrI/weOHnmXj+ecshX9HqStIQwiuhioI+DhJFeRUIfSyQnjS6QXYtcGLiGB+N0d/uas/FKgiAH5OTqBT3XAdWMj2n785PlL7pO9ZLo4uKIWmHmYb0D9H4LJEuyOyAGy32/lVJT9ALSd5lYEo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3866.namprd04.prod.outlook.com (2603:10b6:5:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:37:35 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:37:35 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v5 0/8] KVMTOOL RISC-V Support
Date:   Mon,  9 Nov 2020 17:06:47 +0530
Message-Id: <20201109113655.3733700-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34)
 To DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:37:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf9113e0-4911-484f-be47-08d884a3da81
X-MS-TrafficTypeDiagnostic: DM6PR04MB3866:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB386664B8737F2936FC7538A28DEA0@DM6PR04MB3866.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V79NtzZ/Yt4yEEW/BKzg9WgZIbwirmtQZaXDdnIIyH9uHFL3vYPScLKqvgFgLXOQZjjAfrjuhkJv+cahen4su+WvsqdzXVxfIpaeyPyoUty7OTfYzLge0jEEK9mVITMnf9FaCC5QhdM6e08lQIRseHBNV/Sok+rP/4AcSbdY9SG/WBJWm235BAYjNHVZcuY4L96uqzHm3H91UnjEUOpiNSSOfjYfGblMUBABqZvp/wzIsuBkJLcWvs1cB8OtIkluoKB6JuXrXLLfsEkM8+yhJn1O/aJn2EhVzx/5d2mWDS+yM91uJYuPAY0YUEdrvDno6fuhYWHTuv/I997TXJ1eEU9hB+li6vWKpCDicmItysiFPZZY44VIfVO9ra9Bp0X2GnO2uDa7Q6qQsL5CVVLskWwTcIzsQvjKjZrKrOguLdiVhvXHT52QbV6/9+FbGYmoaeRKhvFY3sb53aStsSm3nQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(55016002)(83380400001)(6916009)(1076003)(44832011)(16526019)(186003)(316002)(26005)(8676002)(54906003)(5660300002)(52116002)(7696005)(956004)(966005)(2616005)(478600001)(66476007)(66556008)(4326008)(66946007)(6666004)(2906002)(36756003)(86362001)(8886007)(8936002)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9p2NB2/NsOdmR71b3pUxzCfDJZ1yVGCCW33eBbEZDj54l5+5qiRoxExrFg5bIuPl10xkCIgm7u+Ir6p5fPo/n9AV3m6rJuDnyV7xQsRw9ls5lPFUO/hpQYsDoUYQTQlV85GapGhBYouA0zJlS3HMfcJiO/k6HCZ5OZjXcaAnQPgF6L/jPjDBAlFLNNZ/2Jwxaa5MY977qT+8X4QiEJKZkGrsOrs5cyTSyrnGcU9AIpwlFZ4hlzcVOdpuQ53bYE0PaRl2k3oLDafzArwlIvrDdiZwkqaxob1uVU5Nv1C1BXsIeUjdb/YmIKBrbmcuxTMeM9BDpNLX1h2nhD1OHYhdiYbiDJGRv+OrNzERfBJnBa+nPBDTeyK8Ih4Iy22nJEB69LX+o23+6s1j64jWQXSEEHeAmp4L8QCGCPreex3vlhIXjGHFKg4XVE0+VpcHYtkGRi72WTmZKRCmfVl+4e8OFSAPvSYxj4xtwBuhysKowP/VCyuSZZxdHYldPpjeis+b5lxIicB3A6kJsBuurGFidlNQ+a2XTJUHVyjRhHQ4KWi2vt6JHECqjvcvntnmo39sKEx0V/u0PNjUdu1Ab+wWHOB9bzp/lXRIAguAFmJkrYJuqIaVf99ktmm9fsfgkV+zw7KQ2RzgySSqQKIRi0Ra8A==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9113e0-4911-484f-be47-08d884a3da81
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:37:35.4805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrm/pNPhiE4qSZuKVguaSI/Z74wKbB5yVzWCJJNdNpPU86qQXbFz1EqEpEpMlLXX3V0HfkIR7/azvsDbnpd1XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3866
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
available in master branch at: https://git.qemu.org/git/qemu.git

Changes since v4:
 - Rebased on recent commit 90b2d3adadf218dfc6bdfdfcefe269843360223c
 - Sync-up headers with latest KVM RISC-V v15 series which is based
   on Linux-5.10-rc3

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
  update_headers: Sync-up ABI headers with Linux-5.10-rc3
  riscv: Initial skeletal support
  riscv: Implement Guest/VM arch functions
  riscv: Implement Guest/VM VCPU arch functions
  riscv: Add PLIC device emulation
  riscv: Generate FDT at runtime for Guest/VM
  riscv: Handle SBI calls forwarded to user space
  riscv: Generate PCI host DT node

 INSTALL                             |   7 +-
 Makefile                            |  24 +-
 arm/aarch64/include/asm/kvm.h       |  46 ++-
 include/linux/kvm.h                 | 124 +++++-
 powerpc/include/asm/kvm.h           |   8 +
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
 x86/include/asm/kvm.h               |  42 ++-
 21 files changed, 2141 insertions(+), 16 deletions(-)
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

