Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCBD41936B
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhI0Loo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:44:44 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:8734 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbhI0Lo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742968; x=1664278968;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=Dg+vjYUSddVIoq58bizbRxW9CzidheFzy9rXBDOB7KU=;
  b=TKi+Mw6V3W9Zb0XPaIEAulIaVb8n4PAw4yRAXlRFzckC6lrhd1kf+5PE
   XWAh55eJGnUqGL/d/e4DtUkZcARkCZn7K1GYibnb82c8k+4Kg2ZIaqvux
   w31oytB93dSFgTETZCBqqENu32wGYHMXgjK+9C4d7eG7K45KkpVsdUdYF
   J6etR4dfLbZAtLNzUlMGIjugsJdnNE5vh3VA84Ys+yZaEoo2fyVwsB/BR
   CbfwCFHkzJhhp4JJ1s8Jwo3Mzz11ea6Hphgckzn6yzVPZ08yKF/nZwlHb
   SeBIU/iq+46y71TiTwH/myHo132jdfTlrx/4f+Ok7sIffgwZfbqX0kSpY
   g==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="284861953"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:42:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B006Q7sNgd7rt6Potbssv/i3TsPFIdNOeY7Z7eANUOdNxHJ8WQwbEr2w1fCGXtJT1MyWexdnilTbl4BIlreLcrTNnB95m4AGqxablXSaqj2wKqfhlQ4poViIcPlJyMAeHe14P1oO/rkLByUplw6FHwPDwz+iYbRR+EdLG+d+bUAyWijCF/1W1ZI5Sf9+NEQx9xCzUu/fy/QP7+hKQAGkxyp/QW1pVbdsVzSOEpjRqISrmjUN+nWt4M4kaz2Op+Arl1EajFPbrgO5YAZsPQAoGYpguRWjDQqxwrm9rwBk19X33Blc8avh64kBc84J6GpjBAhyxeZIaEv5rfDOSslo5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oG3NDlI/pb4MSyagO59muUzHWOOVHSUCUHHksxzfcD0=;
 b=mNvcSyRKPI6jQNOWIyjkGW7QJ3CwCCT+M3anQCF/mExfQRRaCzqOZ664k2cmKzqOq6//eavFopzOnfw1v9zx1N9gqRMY5pVJT/dqWaTfKjCYMRncMWu9wA5u9sjVAd4korbfwcgYVvZ2CGZLB87QMj9m0yH4oaXGPDNa6NWmTTSALRwRkQUKkWrTbOt57egrXmwE0aDCWvWea2wGydh+wx9dFFr0YfWeWOAHz7WuROr/vU7NbM+okft2ByIHfEz+0nEEDriHLC/i3ZohY1xXqoNPxZse8OtAFDnmNBwnDsaIuKOBdLCTqSWaiRZYersgUwD8aPaSpYpfUCLr57R6ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oG3NDlI/pb4MSyagO59muUzHWOOVHSUCUHHksxzfcD0=;
 b=XcuFfs30FEFiJPIANDClKX4Aw8OosoV4XSgGz8b2JDCQpKqp95au+dk5vXRgtscCZBN9UVD+z6agXEuTsVRhCSny56mrO1ujwx5ahnyjAxSM1UkaV8egInv0uxsULmSV+gZFOH27uPZkZypOeopWrgfATa63llAqdhtDX10NQrU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:42:47 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:42:46 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v9 0/8] KVMTOOL RISC-V Support
Date:   Mon, 27 Sep 2021 17:12:19 +0530
Message-Id: <20210927114227.1089403-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::14) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Mon, 27 Sep 2021 11:42:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8d17d98-f16e-4a99-2a37-08d981abed0a
X-MS-TrafficTypeDiagnostic: CO1PR04MB8236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB82367C14BDEF163E838589018DA79@CO1PR04MB8236.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fR17TEmtYTGbYkdCHS9y/peRNQfIFsMzTlPd5y6PaKIFq4s/0R0w/AYxGnxf9FDVNi8pVCnQBw+ZhiG4S7iBEe2ioKhRR7c0XnX0RtB+96rvlbzQ7CAIDiErpg67lAeGT0AVttmWcx+kVxRfjfqxl4qesT+6mAewGj1FlTAxaSZoijrpDnN6aQfxjnEn9Jdj8m2Iv+nm1BP9bAA0DbhZUhtM2vlGvorMnM80iG5SQlu/EdcQqoMuCTOxf1j1PuBhCYWJLD+OyJNodCSDt9JgE6SR8RJnhqK0lNyBI36pZ6Cj4dXD/tMrBbfvGWr23OaG3AqVy1dSEW3awpcmr7TKKMOeRY0aS4Rbkhh3Kly5slP5K3k6aTL4l30LXHbQf1ES4N+IuVZ6c1osthLXezzrOOgUfJrqe6eb33PnJLKG7p7HpAUwOZG+5xMK5HYqovH2YOIbE+Yd0tfG+XY1sIz6S9ttOxH+XqfoRVR4VYQ2W4qymjGefCMZljcnRT0an5enhWGkp6Gcdy2xrQ0YvaQCkp+wGwY79rbQzfeacILUbCXJGQsaFjjMzLX9tFrQOe9bj1g67TE5gtkeyOh1W5iujheX02mhUC7epvi+25/WWqq1a6n6gaf1gPraKLN9SFDT+R9iTJChwvwfHx5K/OVUDmbK/2hoAzl03KFkhQ9E4sfC0R+raUKhPRPe1gIRbDOWeZdF966IEBttx3ZC64x3zT4cJJ2mMcu15LfI+vi+h6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(316002)(66946007)(44832011)(38100700002)(54906003)(186003)(55016002)(38350700002)(8936002)(508600001)(7696005)(6666004)(1076003)(36756003)(66476007)(66556008)(4326008)(2616005)(5660300002)(86362001)(2906002)(8676002)(8886007)(52116002)(26005)(83380400001)(956004)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YN1hmIQNYmF9ZLmPk88QMh8uTpISNyEn1xZNw5kiyMSjpXSMSvb18MVPt1s5?=
 =?us-ascii?Q?i/DV+KJS8ByKwzBwvscTgTqfoWFkbo18s6hyJ3M6pDGa32BDLWpMKu35qcvG?=
 =?us-ascii?Q?AHLS3n5GZfONRyclC+uIkmjzTykNYEpFJIBIisvoSy9RDbgqAHaBeEAHq5ar?=
 =?us-ascii?Q?oOPIituDWEqJmsgpKcVvSMXGlODztD86pQnlFhURsSic2EL9WoVnct5cJy/4?=
 =?us-ascii?Q?Vod8omfP/e54n9sGPHz4jGcrbNBEFjgC626DwTh4aSUGJgscZIwIVOT53UaE?=
 =?us-ascii?Q?5KyaVzN5+xGakh06AVpggTAESHNGmct7gSyJPgkzUCvopbL+YriAoWlP5m8N?=
 =?us-ascii?Q?+jd6zDKabQFq/ti7Oxvf5y3JM0EcsT87pW0PWFnrv/YJG7C3r5LsOv3qI1qR?=
 =?us-ascii?Q?X1RpdmH4OHZpED+RrvxFQG0l+VsnlO1nkEdn7MDnQgJmmZEgv9Dpcg4haXnt?=
 =?us-ascii?Q?kA6R+0c8dHFbjyhKEQPgB063dCjoSpgnlePQXnfjcCgfjnyoLi3D934AENof?=
 =?us-ascii?Q?sh1kMgTtpG2ifeiIB5VMOyrnxWvBGMi2kCqRacnSoY3Vr1h+ZoeVgI0y6wuH?=
 =?us-ascii?Q?/LLgU0ZCUFh0PQ6k0cUp5JK92APf5dZwuQ08JgO9b/Cms4bXJI/88mZvD0SR?=
 =?us-ascii?Q?2FOLzzuYqlMuev0Y4K2sS3VwjhRqXUnR5s4p2kke99HCyDY3DJ8nCc4L+sXu?=
 =?us-ascii?Q?zD5OkbxWXkBECHvmOFwgxDj3LS6uF6F5OR28XmtjrTEkvhDBeI7qo8/GnTYK?=
 =?us-ascii?Q?YcNYZSjW2dXAT0qCNMvXTTAmYBTgYUrc1AAJbu511g/JYubqoH566PnoErVX?=
 =?us-ascii?Q?IthUZKd8P6ZzuPcEu6xh5CT9UICjZ5U64NeSHMoKFkgxVIPtVr9S+73lOUlp?=
 =?us-ascii?Q?G12TSYXX7an/0FBiwDgguGbLFXxU0zBeIJT40YQEhX/SFGX4b8FT0+wNvCPJ?=
 =?us-ascii?Q?5fXja3fu5+RpcbRrh5XC9nLqkolEjFFuwm7yYyjUgra0n4IRZNggfGZvgIp9?=
 =?us-ascii?Q?/bH+DxUzmSMv6cx75itBzTHo8VofKi16TBk/VljzBBKvUprOMQ5VGjUEmynt?=
 =?us-ascii?Q?kbKa/yfnvUZdRV3jhVRLDKPaCqLqnvbuXfK1TJWbRZVeUP0UZ2GjEUnmIrso?=
 =?us-ascii?Q?zPYgfWuV0hCJu5fOd2WPdxkFv9y14730z47UDav3pjVjL7FfCBwNAh9iNeog?=
 =?us-ascii?Q?E2yBkjpGZodMyAt/V3ZVqy9mXaW7jh+OqpO1RSMTs5Sk+FxpdYhco5uPuL1s?=
 =?us-ascii?Q?kuh4nOgmUAZnYOfPrLx0tPLrlTI1DKrJncD4KkHZ9lzkxn63qiAeI9KIJeC3?=
 =?us-ascii?Q?DG21sEgG8N2NtEY4MHOFYzHu?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d17d98-f16e-4a99-2a37-08d981abed0a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:42:46.7187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8iLDA8WYo6PBNZzjw1TJ+19vEjoSAhMZ0nW219uR34FNhw6QOhizp/OX0t5sPKU+dac4eenDyX7NW901zTgmuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds RISC-V support for KVMTOOL and it is based on the
v20 KVM RISC-V series. The KVM RISC-V patches are ready to be merged
in Linux kernel.

The KVMTOOL RISC-V patches can be found in riscv_master branch at:
https//github.com/kvm-riscv/kvmtool.git

The KVM RISC-V patches can be found in riscv_kvm_master branch at:
https//github.com/kvm-riscv/linux.git

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
  update_headers: Sync-up ABI headers with Linux-5.15-rc2
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
 include/linux/kvm.h                 | 423 ++++++++++++++++++++-
 powerpc/include/asm/kvm.h           |  10 +
 riscv/fdt.c                         | 195 ++++++++++
 riscv/include/asm/kvm.h             | 128 +++++++
 riscv/include/kvm/barrier.h         |  14 +
 riscv/include/kvm/fdt-arch.h        |   8 +
 riscv/include/kvm/kvm-arch.h        |  87 +++++
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
 x86/include/asm/kvm.h               |  60 ++-
 21 files changed, 2471 insertions(+), 18 deletions(-)
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

