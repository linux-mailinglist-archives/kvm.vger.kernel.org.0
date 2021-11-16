Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3C845298C
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhKPFZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:25:43 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41796 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbhKPFY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:24:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637040123; x=1668576123;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=rIKvnIeIzUXYTl12+uy0gb+NFCL9CaDxsw6HIRzb1lg=;
  b=XzYkCE783EsZVmvnekMqpeV9a+2TjhZIlrGtcwLAJYwxyaBMLHbsIJOr
   xrTSAvshWpPq+YTEj9hEe+g2AjGZzXXrMQkz8YIAVyBHnWFKYOKvdQFZb
   7kmI0PERbJYzxkPmphByr4//bOXO4ekATVZHfTyM+t0n2gfJHYxhESYAv
   XP96CKc11P4vokv87lKokkutBlrhyxVmTMkCegoHU7jfE8naGwLk77q7m
   CP/p5ddUj//gR/XgCJ1Xguupryfw25KvebuRFt8SzwhkhBcgA/gM42aOh
   I14quGK06qVCm+oWS0RhxaZbRF3B7DR12uv4DPiRSTwi/65/4XugO6cmO
   g==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="289638103"
Received: from mail-bn8nam08lp2049.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.49])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 13:22:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pum7MkVmjhHr07HHHK04q9aEuJL7fe/yglQEYcEA0OG4r+1VbaySJqP08WmAhaEZ1cqfFEHpQ2vKqnC4FCDK/M3ygr3jIrVmjBctng77WswSuFxszjV8ekakkY/otLHDBQX9B9iS6Mc+6N/sQrzcEQ1nmQmmLH1cQgc4s0qGgHpRbM20X6s2ChkPs2Gdv1F1/oQfnfkpidfpSNWfQbH7NnQvu5XiM9L/LAFEevgbde2x4kpfPUlCJd5u8M/HG0RkqLg7Ak1Gr8BmWmZWd5Phc1M6nBC66tB0jxYo+cPBRtfPlQLNN+FEr4X2JSdDQ2wX2P6Fo4a9820r34pF4utbhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ummkn/3l8KzoQKDLo7A63orQtEvs7y2kxPxbSZ6mKz8=;
 b=A9NTaOFsGi3+6laSovp1h60ZmMqH78ZEYsmsP1kw0QYG/h750x7fsM62cwEnTXADkuHkRqGPYfoLXqx6DYiXyN2fwqcQHumH8eP0yKxRbvQNOwk5Ua8DtuhVXuKqojyaD6mr4NMr5QvDTs1+0DKHu/lHqMSIy6QvVSoR8AjKdV2iqviMzFQJ6j1OfR8Ss/SWWH/GxT91D/ePDemsbsCmWWqy4ug7NmZ0vR1qRCWVizLR1ep9/zKCYOrsoo01K8wUkcfs4snWdqV2wtpsuOOPO+t2vOGZP2ivkK2mWyGEdqox7idM5r1gJaf0+aR9uTBDwhFEKNKHNNXJBrrTLJH3nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ummkn/3l8KzoQKDLo7A63orQtEvs7y2kxPxbSZ6mKz8=;
 b=AyUpUF+v1QvlDo6B/ce7QQLPYSJrBIKLyeAgvFBZZgUI9bd5sR2iHT2Eh9JpB2uJVy5DjUJTsCcnHcojGOcLxdUVcn8KdH47JSxKIil7LWMp9Tv0Ob9hbWI7xBAvoPEOzCTu7Hm1d1A1kfDIMhkINaakf7barVFhHXVOiewgnxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8347.namprd04.prod.outlook.com (2603:10b6:303:136::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 16 Nov
 2021 05:22:00 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%9]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 05:22:00 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v10 kvmtool 0/8] KVMTOOL RISC-V Support
Date:   Tue, 16 Nov 2021 10:51:22 +0530
Message-Id: <20211116052130.173679-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::36) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (223.182.253.112) by MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 05:21:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6c1da14-5018-4a38-1902-08d9a8c1043a
X-MS-TrafficTypeDiagnostic: CO6PR04MB8347:
X-Microsoft-Antispam-PRVS: <CO6PR04MB83478F4FF28D73EE6CD4A7DC8D999@CO6PR04MB8347.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEysQdOuHHKYLDw4KRXNYlWNBdaRDQqWYuq/PGx5Q26gyNbTEBUouj6Q4rmQeHxsGq2g0n00fnQW6B2f0ojhMx+4xZI9eBtwlE3G8jW4dgVr1RzB3326HBGHManEEz6Bm+igu/1Sy86tqMcBsucLPdcM3xHuTjLCwswq4bf0vKz+NHhak+EINaO46IhPjLHH+ygi2mmTy0lNVkmPvVaKa3Qdo+h9XdobQpeLvEovGR9YKTj1y27pVYAMWMZ8sCHwevIZjWiAwteUbb3BIs1jJSdwR2iq86UhxrFK5IbIHzog6VyengtR+vjtP8hPkQGHwPX6051abaI2SRjTJzH7FrEMsHa+UZYiu7LUtI39AqcnH8QmpnjXzPpIztS60LOrqz7IIaxGCFh+2l5nRdnSJzKlIhRAiaBRJTL2jC56nMQKoren2vW5BpOdMtIdJ0oAPPxK81xclUetChbgXGojREZEMCGRt72eNkYn3pdOExX8i9zJFEhkuHFmpT91HfCKoS/7l2cS6VAHXPFR6btz9ithX0AKDzwAhCru6d/e0Eswb+mMxh1LRzxEKaLXK6laF0VukkU1PfQIJn/9lfMapVt2aLcx41D5BWC2Zmf2IMN+vH4sZMSsOcLaRg3lp1435E4CypegjoEiT7ZTV0W70qt5mHKpGgFAaOMbBJz1KSgpeDtL8TiU41OJOhL3oSDlQqsKJYj+Vi6wxMJ+HlSVKV8zlLLY6O2NaJX/W46RkaP2q45DlpIIN2Mm6zqC+tFSfsAymukmknAEsgIIWjKQ3oKwWcSFlw55it1qzPfnb+7+cRSbo74k+EHYAwprqAFNZrM73+ZovhAO45g95k5PNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(186003)(4326008)(54906003)(956004)(6666004)(1076003)(2616005)(26005)(38350700002)(508600001)(86362001)(38100700002)(82960400001)(36756003)(52116002)(7696005)(8676002)(66556008)(2906002)(8936002)(83380400001)(5660300002)(316002)(66476007)(66946007)(8886007)(44832011)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DP0Cc+/ioCeUEsundg9r81EUwygJ2w4gS2e13z4PEpl+zWOVs1Hl2MLT+muH?=
 =?us-ascii?Q?eyS1CAn4zVwyR+F0NmD8EW0hE0YEHTg5Bv5s4EY0VmygWqw/1WnaJNqNQ/sg?=
 =?us-ascii?Q?74sqeXmkTwizBxhVzhkpdnPNmUMWcRiXVSJlS9NFunNkm6MYVAmX4UKR+W+E?=
 =?us-ascii?Q?WuJmXQtJ8DZPX9HdWsPs+K+FS2nZ8dYy1eAuSRTtW6RKHt2Ks1ATrQoRgQnS?=
 =?us-ascii?Q?gEbcGzJqO+dig/HRsGW7ZnbdmQUIm1Wpw0R5XId3dqLnhUm/7o+RzGFwt1TE?=
 =?us-ascii?Q?qnbxXqaFat6uXVlT/NBWllKOk1JfaaMsFaOBe9f0mgEpQ4D9hAuh7acB22T0?=
 =?us-ascii?Q?NtGuvL0dzBZBiaFT/OS1VW9mXqgmsFTB5R9i9dwbwNBpFR2mgQoYerTDiGfj?=
 =?us-ascii?Q?SIrWvXtw1bdtGng5pIewpcrku1KMTAcB1Fr9/Ik0KVvIoWdkSmmkI2XwR3KR?=
 =?us-ascii?Q?YqiogTVSPDUV9V3FQwG668aSfSxHIT73KObVL5PXR9YaSKCiUOF3/Nwykxu4?=
 =?us-ascii?Q?TGVsPHwJ281ZQRhjkZIv3qtGJNI4ZeD5LpihF8Z6PBFln70m8JZbVNY2bGz6?=
 =?us-ascii?Q?4v6iP1+JqhRqnlD478Ph7heQnbHOD0UlyrQc3wMpZLQJsJh71euAYcGS4f7x?=
 =?us-ascii?Q?ZZu3w0XD6Q7GUEIf8Fyv19HmaFpQOZKG/moO8uKg00vuh/wftKf1PSZoj8nz?=
 =?us-ascii?Q?gwpBhPpReXMgC5MB6cg92VnZBjWYTVYadElnEhGYfReeF320W8wpieEA/xS8?=
 =?us-ascii?Q?LUn/EYS5VJbi/4x3VKd9qDoY+k9f8H5RRG8p9pqHFNEPasPXiPNRhjPGi2kF?=
 =?us-ascii?Q?EiS4WaLDUGTpbn8BSvngWdg7jk1m9be8u0nWeASopBGFl8+TgJeM6NSXSvrq?=
 =?us-ascii?Q?g5CVDgITkPxmEl90Sx7+wpkGoTEFnv3f/2QPZ5DetEG89Lz1I2W/Nd7GKS8Z?=
 =?us-ascii?Q?8J52I+jhQvJFXZb+zp/sEUhLpfgM1WtC16bHZ2rXJN5y8xLeMt8a/0iliycM?=
 =?us-ascii?Q?uxKOeLQ/knt0PkcJgIfErph95WLsRYSxnEg5uHNnltD/IXN9O+NAlYgaImrF?=
 =?us-ascii?Q?EzHPWSpFvo+YQvjTsVIBdMndj1/bRo51onRrzCPiAxpsR3M0jvh9KGY76qmD?=
 =?us-ascii?Q?VZBgRHfqaSIoTZUZJopEJNBy2PQErCDl8WzlbijL9TnOHKMECi61rqyQFDBn?=
 =?us-ascii?Q?Lju+DpXbeVWuGJ0VZCQOYjst2RJ2aaWRblEdayqYMFIilXk/v6gryr1m8bwf?=
 =?us-ascii?Q?Zxf93MeukMKVopy4bYhbiAF6eCZp1as7YLvve9LgHrQ00qY6IUhnVn9SH6qu?=
 =?us-ascii?Q?qoIqwKuWEpIg7e3ydrSQKQOoRnLjdGfxIbarGJRuCYoAxenGaci4rfYCibVS?=
 =?us-ascii?Q?3RkIr6YS8oPjwIMHH7SRcXm4fFgO+XLmj9qsiNcLIy5VmksgiPuDHjlEuieI?=
 =?us-ascii?Q?abSOWAV60gVte/pWoM7oiqy0t76FWit+SomN7rt/W+86TtrDLu+J3Zvq5HCr?=
 =?us-ascii?Q?auJAskQUOPpOj57SCmn8VyCfvxHKAuhHUXp/u5wDxAoBYc6P3y6/4KVkEaNJ?=
 =?us-ascii?Q?TTVOY1CmmjxEMyoSPkawXmyHKJ3tZLb4eTOWwiSmpK59c0GNf7x/A6H9Clf9?=
 =?us-ascii?Q?vzTJGv7AiyiphtjzOzz6Fq8=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c1da14-5018-4a38-1902-08d9a8c1043a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 05:22:00.4926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0GDClaFRADHb50rQDGiJTXu7wPjdIDXjR2+8BJVNnbQJXQDvnUdJLM/7GGYtICs8hrQihyFlkmoHYUMxE68EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8347
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds RISC-V support for KVMTOOL and it is based on the
Linux-5.16-rc1. The KVM RISC-V patches have been merged in the Linux
kernel since 5.16-rc1.

The KVMTOOL RISC-V patches can be found in riscv_master branch at:
https//github.com/kvm-riscv/kvmtool.git

Changes since v9:
 - Rebased on recent commit 39181fc6429f4e9e71473284940e35857b42772a
 - Sync-up headers with Linux-5.16-rc1

Changes since v8:
 - Rebased on recent commit 2e7380db438defbc5aa24652fe10b7bf99822355
 - Sync-up headers with latest KVM RISC-V v20 series which is based
   on Linux-5.15-rc3
 - Fixed PLIC context CLAIM register emulation in PATCH5

Changes since v7:
 - Rebased on recent commit 25c1dc6c4942ff0949c08780fcad6b324fec6bf7
 - Sync-up headers with latest KVM RISC-V v19 series which is based
   on Linux-5.14-rc3

Changes since v6:
 - Rebased on recent commit 117d64953228afa90b52f6e1b4873770643ffdc9
 - Sync-up headers with latest KVM RISC-V v17 series which is based
   on Linux-5.12-rc5

Changes since v5:
 - Sync-up headers with latest KVM RISC-V v16 series which is based
   on Linux-5.11-rc3

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
  update_headers: Sync-up ABI headers with Linux-5.16-rc1
  riscv: Initial skeletal support
  riscv: Implement Guest/VM arch functions
  riscv: Implement Guest/VM VCPU arch functions
  riscv: Add PLIC device emulation
  riscv: Generate FDT at runtime for Guest/VM
  riscv: Handle SBI calls forwarded to user space
  riscv: Generate PCI host DT node

 INSTALL                             |   7 +-
 Makefile                            |  24 +-
 arm/aarch64/include/asm/kvm.h       |  56 ++-
 include/linux/kvm.h                 | 441 ++++++++++++++++++++-
 powerpc/include/asm/kvm.h           |  10 +
 riscv/fdt.c                         | 195 ++++++++++
 riscv/include/asm/kvm.h             | 128 +++++++
 riscv/include/kvm/barrier.h         |  14 +
 riscv/include/kvm/fdt-arch.h        |   8 +
 riscv/include/kvm/kvm-arch.h        |  89 +++++
 riscv/include/kvm/kvm-config-arch.h |  15 +
 riscv/include/kvm/kvm-cpu-arch.h    |  51 +++
 riscv/include/kvm/sbi.h             |  48 +++
 riscv/ioport.c                      |   7 +
 riscv/irq.c                         |  13 +
 riscv/kvm-cpu.c                     | 490 ++++++++++++++++++++++++
 riscv/kvm.c                         | 174 +++++++++
 riscv/pci.c                         | 109 ++++++
 riscv/plic.c                        | 568 ++++++++++++++++++++++++++++
 util/update_headers.sh              |   2 +-
 x86/include/asm/kvm.h               |  64 +++-
 21 files changed, 2494 insertions(+), 19 deletions(-)
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

