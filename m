Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAEA2F78CD
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbhAOMXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:23:36 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48743 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbhAOMXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:23:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713414; x=1642249414;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=pYSeM6HCZ1tEDHzJmPc7xFWn3Pwv/Js36rYOgKihgZI=;
  b=hMB1NXkb1zwX31cYDGlaSUaM0XfG6Ya6cq8cfh8RTcEW6H9/nwanU1nC
   jZfx235sCdtGDSUiaL9iJAT9F+L8lN4nbgwN/Hb0dFx8S7y/qZ3jSFU5l
   qfKe/WV74QgRNMzawe8LW0cKAmo3wizbspLgHv5bTGJVPyA4E6g3wSN/u
   oa/P7tI5ly4f6hp49lrZUyNkQJvUuw63ikhsKgGZpjMQiJcO1CI2ZPtuX
   TtnORhf9rC+sUsex5S5rTyc9HK/7MUx63opQXif5S0i2z+P0Tm+3DRGI5
   PXzC8MzT4DpdgYvk1r0ueDaHSB3EJSOuCPL2wUbfyoei6d3WXuOOskynD
   A==;
IronPort-SDR: IPaoweSqlXKTeaZSZhBmm67U6DVbldooeJ89aK52mrPkIs1QnTGXmW5Rm60tarygLa/d81iv83
 HNLofWQ+9FOdmYekpJq8zofh4NIgcgx61sSWMZju9znBlhgWAdnqffX+TJ4K9uBwLwSi82mvTk
 O/q4RwM8cBhR/T3kJLooM01pPEMaO+Rly6h3GQV4Smp9on976ynP1d8VfGIe6kAokS49ztYuBX
 n0cKVhZCcjnyWdnueqI97+dKScSe/9/n4aXDOCE+LqlDvkZ0RJw6Nr8ojI2uA2zlfsyzhfIOs4
 z80=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="158687532"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:22:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqoXNZDGK/FfbE4OkHrArx2Fs8+HUGF7PtqLjAEheiFZnFMPOSUhVK046Eqg4VioscwoyqrAO6xt5y9zKxux7PBvmgDh4xsdJvW80nDGN+Hdbt6u966SOHdxwnFavbFvnpVzosW1pPaqNVG+EK316VKdWiMrCJOpPmK3LWc9Ag6l6UmSNJ5TsGVL9HKrecuJHa28ALF7Rour5eIDSP1zPdc9bH5ZaZgOUsWs+XndzGb5hlXVG5n3xWV2F7J9nMX3gZJWu42SIJfJql916tbGLRXtnFt1V3XY76AbeJnNdaWWchPABxV2KSrgag6pxKCkthPyIBVxuZIwq0d78PejsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KruYcEbb5cdiO74ZOYvYL3cCWz3qI5JLsssmLn1Qgys=;
 b=UogV0Tz4FmSXEq7VNRlgmQM+jH0K0aCmSO/4E34+XzI4m3TOuojq5+2/AV+ctI59rCYfwN0Hnc5AQMfzWiOqP9dmPFRuEZhdXU8/GByPc5sSIN2bfzHri3ot7v+PvOEZ+xRqnKNebjFKlVmeT2Qx5Py05edsbw05d3o/LLIgzjuxEnyHg9s1TM77F3yiHyshQ9UGQ1ee8Mef7vgDb4pTTYI+iKesHMWWGW1AUBBcbOAvkVuYZyh9Xtu15VTySrlDXrziclJTKVOAWcPlTZDA4ztLIonw4anv7ZV99isQaB0HCZsrvnlmXaVRuwqiNL3JQPG0s92pS2VRgSked0+FZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KruYcEbb5cdiO74ZOYvYL3cCWz3qI5JLsssmLn1Qgys=;
 b=tZEuUMHfHILq63l2v/MdO/rdAArmDDsd78BOLOXv0g5nYyczH2K4U/+SZ0wtMDVk+u4d2txYoJqGZKsnvoTVUN0rGjvIZWhTYYhrN2BIuL/dCH3f9JuSJSzbwC1ZNFrLw2nxEb0HgiWxK+IJswGL06tbXKoYbdqXEOxUapktiM0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:22:25 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:22:25 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v6 0/8] KVMTOOL RISC-V Support
Date:   Fri, 15 Jan 2021 17:51:52 +0530
Message-Id: <20210115122200.114625-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::17) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:22:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23f81e71-4239-4561-c5e1-08d8b9503738
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4330B196087ED773366B19638DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eqPET2eEjyboUvFztxcn3ZbfMGM2fN9pFw6mqiXFnSozbxS9DgY9IGkyHQ5SoFYKhV/rWzpzN+L3K5LnhZlsAd+pf9WAWibQKkr1OblpPbt8TxotS7Qxeug/xWYqfYY6rQsuWqfKOTrN6MO9b8o068qONUshqKeVnc18fnaNP7eZJX43UDKmhiWEir22wmufITrnoN3elthOLXDokMzJ9Qq5j/2XBzV/6/G2b6aTCWX8ukhZlbNRJHu3aSxzMlFW1AYbzv5nAjVkVkRJqMLwLnXoMdywR6J+YC54aIiSpVRsL0FGE0M4yCJFfwE5LLSXqa0/DJSdmUj8k/6lt+v0LNXzKsvIVqtCx/GascG/f6N2XqJDZW+DvuYTkGCAsTvbhO82oEmpO619AabWfFHt1L/zSQMskdLHDAOsjtyp4fEN+VkNMBvaCIDun5Uo7sWPLWOGynzKW/3l1u+maiquaT5WLP/f3ifSu06xevqIrowJPz3FL15vmk51i4klWzb3+mEh5M0SNGuvSXQG6sxK1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(966005)(66946007)(316002)(1076003)(66476007)(8936002)(186003)(66556008)(86362001)(16526019)(36756003)(6916009)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LPJU25ZT/BuRih+1MxXopxQRMBnPcrxNf8+q7gsig0XcxAi+GjOxM31rFz1S?=
 =?us-ascii?Q?Vss7OtEczwM7e1WcvJxw/IFO0Y89Z0C5oGpyblqsAwkx+/aPOwDZmjJvtzzB?=
 =?us-ascii?Q?YIWXvFvEHIhkf7kIPLb4Lj+5XOJ+LoTZD+APW+T1YmK2uHi2vBZ1yT25miOi?=
 =?us-ascii?Q?kD6TGs7/8xBC3qxThxmQGfMxUlXMj9r0mg5B3hnlNqE2DjpnQcXWa2JEVZ6B?=
 =?us-ascii?Q?l3UR0noJEfzfTspSs3xRtbjNJUewMMKhIWBm0RRrd1JlaxYTcT83UYs5NBHQ?=
 =?us-ascii?Q?LCxIhoSFqMe98OAGg7ME9a9CwGdJj+gofsO9RlhyuE5S5WEjkY1dPbubV7pY?=
 =?us-ascii?Q?Gsn/AuCpjMPEtT8VmTspq/viqsM99pLW+cLFOmEKqoR3dArbZhDD/c5LHk9P?=
 =?us-ascii?Q?E2wWf8oL8n8nPdw0qzz3nfbSjIGMsk09NsrxWEC3vq0QzHlGiB/txwIMC9pf?=
 =?us-ascii?Q?8gW0cOaPcKiIOvAdfdXjysvJF8UPG6HtSI7sI3qMqbx9iWPVUsXyOzsZlC5p?=
 =?us-ascii?Q?xGa1TI51QodVrMqkK94LcBBV/NIcTih9srFKXSzwykzih7/loMEX+mTarBBK?=
 =?us-ascii?Q?mHYMJazi9v/zY2JgY6UwoBfIjVWijv4lKbuFoDkgF8pDGHYf3wO6tLpw0D8m?=
 =?us-ascii?Q?soci2TmrQ2mghTJ5jwmemmGWglOdJP4V+Kf8iexX8bAZnz+G87FN60aE8IeR?=
 =?us-ascii?Q?q+qiAsds/iGW9QW6grfWiDcROhzKwzzCTGY6xeIwIyYsrK/USzsiXc93ZN9x?=
 =?us-ascii?Q?w2qwYYtoBjGjFUMQ80gCRAniH/g82tQjdHa8sW6fb4CouphfySAn+/B0DC9y?=
 =?us-ascii?Q?PMTJXZzsgkzJwZSDiuy59HLi9lkGv4/fYqsoeop8C25ZRaAzA35AEIHR+ktX?=
 =?us-ascii?Q?bvBCy3DDrPmkI+C0ZEgcYpI6dslKfBrx1ngDSGF/eULSUPIgfHsSO5PST0fj?=
 =?us-ascii?Q?iMiMEZ0jMlDN+0l0jshxPPEVEvkPzlwWmPqtpROoWn4ToT+/9B4Tk3TYrGKD?=
 =?us-ascii?Q?BwiZ?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f81e71-4239-4561-c5e1-08d8b9503738
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:22:25.0863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QG6n2KGH84HNjolcZGRFYb6K8xhjdXo42T9apHlxR0OOq8o2u8ulfs3LDkIbotEqLFwE4IYEFWrcERQ1F2B6sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
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
  update_headers: Sync-up ABI headers with Linux-5.11-rc3
  riscv: Initial skeletal support
  riscv: Implement Guest/VM arch functions
  riscv: Implement Guest/VM VCPU arch functions
  riscv: Add PLIC device emulation
  riscv: Generate FDT at runtime for Guest/VM
  riscv: Handle SBI calls forwarded to user space
  riscv: Generate PCI host DT node

 INSTALL                             |   7 +-
 Makefile                            |  24 +-
 arm/aarch64/include/asm/kvm.h       |  45 ++-
 include/linux/kvm.h                 | 182 ++++++++-
 powerpc/include/asm/kvm.h           |   8 +
 riscv/fdt.c                         | 195 ++++++++++
 riscv/include/asm/kvm.h             | 128 +++++++
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
 x86/include/asm/kvm.h               |  43 ++-
 21 files changed, 2198 insertions(+), 18 deletions(-)
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

