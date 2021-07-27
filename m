Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61093D6E81
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhG0F7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:59:06 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34223 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbhG0F6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365535; x=1658901535;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=kSMUPQVgs3+dK/nNNdHUp6Zg0TkyiF3d2ry1xssMstI=;
  b=gHVv9rxkS7fNKkNEEYyXXDDTG85KuGzfOoPtf2OB0lpMY9MSsQwzZ8DX
   4rBufmwp+ZaPvZdXDKcEvQsUKuPj2rY48BkjzOErLvj1G94vmmMhP5n5y
   vlA75G6G4KOnr0LKTbMA0uETJR1q5GCeEjh7ORm49ShWlUz2mjfX6BEE0
   FGIYW+MDFgPPGDQY6hrVRwtPre9C1IhRU4pCnvB7cpib543xGUKdgo9KR
   xZgQhSEBcwJFK4Pizmg9o3hC9b3ciK/Y/MEzrj2iD4YKB0IYqnSPD/WB3
   Yb1CE7gUT4mzMRGg+UWA1NSQ4kGSVW6tL55W7cKqpJ1BwIBoSouh2GSW0
   A==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="176146292"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:58:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WB9nWObZZqzm375mabs+X02FNympg/+mD1fQRl0dRM0tOmUh3Jfi7//eoPM1FWSL6u71pq4PwzQfTZHm8gV6KWUjkwk/t00OiDTvAyPIAYVB8g0qfXLTnk9am7KxHy2j9kEe55mHI8tpw3pT2MTI50xcp/n6SQG8Rzf4pFr/pdzbZ7kLM1G0MXnzAKO1rrZQAbr+f++6pUoXTZLI5vy2c2XfBRj4gavqGmNTwdrF1gpMHcuBxlsoe44/3XwjdW5Xuhzl+O7rrquemq2ED6zGOoWq5NWaROJQravnM5LhsZVIueQIrQTYSHbpAm1TFivgAF0hGbHgqwUAFXxmVlbAtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lwv1FV+u4YBIwJYCMguphwDok1pw5k9ToPWfZBmHQ8Y=;
 b=eOm3Ev8A91A652dOXAPUjEfoJJ2hmAJlU0zhaAlvf6EUGg/HXOGnzyaXGbcPHydcPWcNX7D2PLNbzUcM3pBckNhnXdDBvh5yhjNh2SJIc7y481uBdDfcdQ/zWqfnbm+F1RkxxQdGgtuXHCEc75NtVy6HYA2nPSUtkNS2BOEdF671LUjBv7j/HtYa6wwcz6N4SLKi63znyVUXmkXa8Hp5BfWM1TR+SUgj8eOdvOcgW6k8Z/v/p6oU2VVX+mJxEgRQkpXp2noDaIvlLZvVasUSevtlA4QGpybwSLsAVlvqbXzwiHpV4vpnJ5w8H1eX2cO1Jod+Q6DTIFuq243s7vsN8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lwv1FV+u4YBIwJYCMguphwDok1pw5k9ToPWfZBmHQ8Y=;
 b=gUyU5gYqBDUlG7jkqlA83l/BsZecL7biwb06soeJUo2JHHSCdTpvhbmKmm2OnO0CKi5q2ClZaPEldW++6H9RH90xiyC0trpUQYXmRTCptdr++js5Sn3qwdB2XxeTaXYk9vbcM8SrCmi2FXDLssN1lnP3sEnD3n9XxWC/3vz6iJk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8267.namprd04.prod.outlook.com (2603:10b6:303:152::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 05:58:52 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:58:52 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v8 0/8] KVMTOOL RISC-V Support
Date:   Tue, 27 Jul 2021 11:28:17 +0530
Message-Id: <20210727055825.2742954-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::12) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 05:58:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17ed8be6-c503-4e0c-2374-08d950c39c75
X-MS-TrafficTypeDiagnostic: CO1PR04MB8267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB82674C87B2D87211D083D6CA8DE99@CO1PR04MB8267.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IEtiLub11djR6g0aONd1mvdbHo/BCinJUyPvIPGnYWTAId9Xs/kmUVaMEuig4MlcuQwWSC5J3JSD8RX+eItEgjFzz4ACfsho5ullqqRObAJ/xIk3v1tJeFvM8OWQ3xbbLym+hrKd8lMVCMlqAvCZuQ9YLa1OPM1Poy4Hfuap9euWAhyJyyS13MFGvN7yGKOWU0xUwaFvRydDylTRhfp51i8jzmX9ueE0Nb1E0+HUOs21+Qgn7Lqoa0gIEjU9Hxg8zLcEkzGLfn9kMW7+AHsQkIkvBkwrod9KkWUjM2UEnN5qS/nyt2ZTA+O41tAD8WIlO0kmOfrqLzg+U4V3u3+jZW46hkLDZpxmQ/XP52cJ29v1BiUYm2KTi3mQz3VxDIQBjnas+y2BCV86ErfzBmHu19Gcxkt2n5EPAO/1PFk74Ua85/AbxFX6ajL8MlT2GbgXOcHLyZrolPeQCaJl3vyzMpAJv7l1hOHFwJCa/CBXrfXYEywSD12HGgwRdytQSskOLfy+97IqiTvdbEVfWb9jyz05u4zdCBQW6tnz6MKYVbnBe7XAiodPwNHYUN0hw2Dwd/8kkBYH5S7B/sjqBvPeLAA4BriYVu9JVk/5F40ZldsNyptC6VSJBmm0TV5dhhDKMrJpe/i8n0yPtNIjhuPteL29EuQ9n0eflqn28XI8MWwxA+k6pResNhSap6KVeNvb9IfLBuFiRRAhiFy/fB/aG0W7DBacna4FPjp3G8BD2ao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(5660300002)(36756003)(6916009)(54906003)(8676002)(83380400001)(8886007)(55016002)(316002)(956004)(2616005)(66556008)(4326008)(66946007)(66476007)(86362001)(38100700002)(38350700002)(7696005)(52116002)(2906002)(478600001)(44832011)(26005)(6666004)(1076003)(8936002)(186003)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tav23grLKyfajpcSQKbI8Ii2XnBGB3674PLXoAd+pRst32xdkyZP/NYu8C5i?=
 =?us-ascii?Q?TgvpZScVFxtpDITvYhb+0ekUKk9hEyfqo3ytTC8PSPoDZ99JY0jAtycDGsgm?=
 =?us-ascii?Q?Ik2kdAKma7K7+UbVbbiyhsLDkag6EqtWuPFT/SGM4NqvlF2tZ5LBgBuQsdDf?=
 =?us-ascii?Q?Yyzs3rIRg6ud4Ax6AfIoG3RND+0EQeodJwiJNe2iqc3rfRWux47pLaCY27vD?=
 =?us-ascii?Q?gJqsHbzG/JxTj+AX3/rrG0SzViF2MSa34I4VeZYHWVel9VUFS58TtRu7Nrzh?=
 =?us-ascii?Q?lCv26j03YiNuyCRh18SnLPdCgmLrK6JMIVD3AAUjnhOg4apnSrOer4yt02Kw?=
 =?us-ascii?Q?5ZnjNPTModoTjQoyQ5zfCD01tFPbRcuZyGfDhnR2YwtwwfAVpvn5N8EEprjm?=
 =?us-ascii?Q?cDi9RcKpEr23BLiXpJN6Z5TJY8cpFzN4BurGMJuTDJ1/eD2vBeZpasP4FJZY?=
 =?us-ascii?Q?Nng8Ee+SktFgBK6Ceo42j1iCAArGNn0UA4kjsdkzBPd3PzsNGgaw4oLt3Wdl?=
 =?us-ascii?Q?PSvRZ+ZuP4t1gufC+pzDBh0OQ4A9Ccfy72Gntg4C8EtylNEIuMbLbyhbe2Tg?=
 =?us-ascii?Q?crkzACIgmHwurkrf0T/g/q9To7RaCfMD77e2y0YgWE8JAvrhIxQrxDxBwpTh?=
 =?us-ascii?Q?8F0jUm+yLAmNZdzDRGA7fD7wvzIfrKSb1aenLE5onEoDqUi6A9GS9Ctf1pp1?=
 =?us-ascii?Q?ng/jHnAYKbFTypIfMRETMCLYIoHG2hbBOIiuY5SxdhWxTWZ0aFIxXoYgTTLg?=
 =?us-ascii?Q?BGd4E6lpTXXWW1m5hd//e/Q/hUwAY2Trse5cHOZuGE/ed7GD5HI+R8mXZbff?=
 =?us-ascii?Q?kfUuq5EwtHHUANAwh8eMy0WLvrwausrh9E/kl6bOOafrhTlG4FMTYXRLa9Il?=
 =?us-ascii?Q?CK9o2xyLw5xS1/rx5KCQNOoPBDNlKXdI8sTgNLLGwX0oXcql3JRVdcIzJzQ9?=
 =?us-ascii?Q?VKwlNzSZG5rAmlovZJUpUCwOW+IZlpYwxfrAGsbcpVwyn6KV8N3n5lpJ33bZ?=
 =?us-ascii?Q?LkTKTZAamEaWpKwybsrizeG5DXK/PajD5mICW6yhM0mbK+Zdp3FUBNaOFtqr?=
 =?us-ascii?Q?C666P6H3zZbBB0i6F5tNXxBtCtGYgc9uu3Ap84kNPMOQrar6LyXVwdLh3TZx?=
 =?us-ascii?Q?GE+G0olpxfGS5in4FQMaDQUcE0yQVQfkIJpezvugXmSIPrkXGKjN/CH4bK+Y?=
 =?us-ascii?Q?/djd5kfa5LGGCnaMkVEWGja394tm+QQyNFKaN7SUpc1yslqnnjx1Z5WSmbhW?=
 =?us-ascii?Q?E3NHwLn2Uel7VI8gxSn+FJjaQ87M/HIIupWvy8YjeF4xngKWenVk5pPoepme?=
 =?us-ascii?Q?Wlp4aKFf9Q4wjoS+kMvUZ1IM?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ed8be6-c503-4e0c-2374-08d950c39c75
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:58:52.6658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZmGb7Ubg1rktiU+Nk+oKlPPj6bEYPeDTBHfzqYCB4vaSvPFq+D503I4UPRINcr/Bd0KQsWC7gfgTGaJPT6XwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8267
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
  update_headers: Sync-up ABI headers with Linux-5.14-rc3
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
 include/linux/kvm.h                 | 420 ++++++++++++++++++++-
 powerpc/include/asm/kvm.h           |  10 +
 riscv/fdt.c                         | 195 ++++++++++
 riscv/include/asm/kvm.h             | 128 +++++++
 riscv/include/kvm/barrier.h         |  14 +
 riscv/include/kvm/fdt-arch.h        |   8 +
 riscv/include/kvm/kvm-arch.h        |  85 +++++
 riscv/include/kvm/kvm-config-arch.h |  15 +
 riscv/include/kvm/kvm-cpu-arch.h    |  51 +++
 riscv/include/kvm/sbi.h             |  48 +++
 riscv/ioport.c                      |   7 +
 riscv/irq.c                         |  13 +
 riscv/kvm-cpu.c                     | 490 ++++++++++++++++++++++++
 riscv/kvm.c                         | 174 +++++++++
 riscv/pci.c                         | 109 ++++++
 riscv/plic.c                        | 563 ++++++++++++++++++++++++++++
 util/update_headers.sh              |   2 +-
 x86/include/asm/kvm.h               |  59 ++-
 21 files changed, 2460 insertions(+), 18 deletions(-)
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

