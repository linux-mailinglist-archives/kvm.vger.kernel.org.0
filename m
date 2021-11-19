Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33D456EFE
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 13:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhKSMsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 07:48:50 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:16408 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbhKSMsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 07:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637325948; x=1668861948;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=dGh4sEoh8cdk7eyR3FnbFsDZsD4lo2RQSxaoILth3iM=;
  b=FFqlj3ta02IcjfROdzHhwz+sguHKpAPVn+XuSHQSEEfZGnQsFYiR7j1d
   G06kX11pngRQat4OlU2t42APss1xa023wtDkos3pEw8UBhbgrBfor7Z87
   05aRWMRIZjwwTF93ZgsR3uA65yUxyANxBOyXxO3Fxizg2T+4K5Ggx++gK
   ngdixLV9ljGdr3dsox7nIQYajLYdJTXJn4tnlrKvkwIWpLS3Y4km1DVGD
   6Yq21nZwXp+RB3uiRT6oWyiomkKKQKT/C0ty/rj11jn9QX9w/VcCtv0Jj
   pAZMrOm/sbm3Qa6zHyTAtNUZOwjUpsZ2NUsz5+/UT7L61Tt51a65uQoX5
   w==;
X-IronPort-AV: E=Sophos;i="5.87,247,1631548800"; 
   d="scan'208";a="185086359"
Received: from mail-bn1nam07lp2045.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.45])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 20:45:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzDo0Ba8jclj+4h0sgFghKFqlDvJJiOjnukgg7hjmTNfxMpcc2XGuZ8PVEVM7LRS+2CKAhhfh0bkZBZy4zzCtwBdsOG7HlGxLjg9nCXPcxm8oCti4glWcnkOTq+OW/HoHRkOdPW7JhgkEAyVOkNegSZ2zzH6vI1/tm4OIDKRIAQoAbI+nCAnvdPi8HnxpKOlHVW0lFlFFsGY+7HokH6+KhkZAFGmm1lSzyWp4ePu8O1GKrsfb8UnwycW4sxROqb0GFXYEms/JuRJoDfbTKdfRoKdPB3uewi8o81jnebADnmia4LOwanqSohTvJc7CJnNaWd6v306TWgDpe3o5lQBcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4jSE5Ux00p5PvUK7rw/8OCBPAQnvb0iq/SbBnIA7iQ=;
 b=IHfhB/G6om3i+1ZVfm2hfOX6no2y1FuHb25UJBb+F5N1T+v8WZ9L518/y2MYVqwzQ5YxHcNUFfVu5YRQYFOchFyiCBms6RraKHRd2sPgefyG7nF5jFiUTV0dEf8ubPz5urNgABc09AyB1cQ6QzISxcLWQbvKG/1ZsnaOuan17ANb4UMRkYgZP2ptj6J7W+QJrzFeaaLgJ6ybtEtzzS4WBGwWjURRnvNHh5bREmHob5eMI5OBZkxWQkM2D5oJBrt8G9m7NvLUw5bmOaGP28zWOix4eSqdsmIm41BSv56p9dtjWdqAZQuSnycSK3+BTmryj4colqA5i5YZXHUz6f4VMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4jSE5Ux00p5PvUK7rw/8OCBPAQnvb0iq/SbBnIA7iQ=;
 b=qlDZLKgDhZf7KBvvcnRqPyH/pJFANjJ+15VkJOaWGQAW4pvuLGCC/JVVXLCIcpEkDQY5kkw3GOSkw+5hTJgxFjzjktcM5FN8QsRAGB5P9dOigGWEQ7kkP2yR1q6wq289eBzYU7w/fpE1ZyuuU8R9cQPKILxCWIE4Y9xRNiXjaqA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8444.namprd04.prod.outlook.com (2603:10b6:303:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 12:45:44 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 12:45:44 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 kvmtool 0/8] KVMTOOL RISC-V Support
Date:   Fri, 19 Nov 2021 18:15:07 +0530
Message-Id: <20211119124515.89439-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25)
 To CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.171.140.195) by MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 12:45:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc115403-fdf5-46c4-db67-08d9ab5a803d
X-MS-TrafficTypeDiagnostic: CO6PR04MB8444:
X-Microsoft-Antispam-PRVS: <CO6PR04MB8444DFC753AE5D54CE2910B28D9C9@CO6PR04MB8444.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ldCG8/FPgAVOsXeYbafy4AhkXE6ttRl34utwE7M9xyVlB56qnocu6q5hJeslEpePksp8tJ4HpKaQ3JvGAzhgJxsnhJwajCMfAWGu27NXDeydLkBZjQ+QoOJ00wwcHLkMcwG8cSCF6He9jzfmln7vlMf0XODl0a6ednOGbkdoaKHZnsrRkLOW4VqVh7iq6zbX3QxD7K5YGxY26Ftjl93q2IIJQXy/xOxQNRIh4VTMqiGw/uvMl5QIIdaU6V3PXCMeccB+LP1KxHOZiuv7CKdBR6NVbI1OfxhVBcKc3jqWJBirWOs5C3rytnMzSHsrgWy05aw20DTMu6qEGLzLyFigBUo12f/uz87W5YvZ+BnnFDA/h22jVqoXoe+LkfwvG69F+zKryz/RBiHhzZ0iemwJNP33heuksEcomw410TAYke7NcFjUAY1/dv7CpDb/dQ3365JVHnkuQtlxJ3Im+FLykkckncyE3jXOZpxLdJkmWUVsuSdGxI86TINM99RIu9YVFNY2FPbZxedDZpMQaun2VrqYVy/2Kn4AL4AtrylNuCt4z3hJRk0yStXENyBZ+pTsMNpF94NtVwTYx4PzRZjeBAhr0MsJHmaauqLU8nHkumDs4atDJopnc2iOE/aZLtx9kn/P+Vy8E93yyRti2oygWhzgvSYGwYuxr/vVygBuUJh0lxQak9wCcuG0YB5VkFQzYi6jHwXUu1F/duWmRctkJeF6XZL8oHrPGKd+Nlm1xww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(1076003)(38350700002)(38100700002)(44832011)(66946007)(4326008)(8886007)(2906002)(66556008)(66476007)(956004)(54906003)(83380400001)(55016002)(2616005)(6666004)(52116002)(7696005)(82960400001)(5660300002)(508600001)(316002)(26005)(186003)(86362001)(8936002)(42580500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+m4cQUbQnHbp2Lh/qTul7AbQ1OZDtIYyr9cvFZFbYZ8P1ndHsIgsm9lXNPI1?=
 =?us-ascii?Q?T/5h9IaZxJUutUuXrnRvoWRyDn1TjFbW1lXr4TEKA6RKEOBHVRTgK815VMJd?=
 =?us-ascii?Q?Ttc3h6OvuLQXzVghGr1UXwKS4djUNsnqkmakIj9m4Zdd9+fEfWUtM/4Wp7oX?=
 =?us-ascii?Q?TBRFOJNhSWj0UworJg5qWXcHn54BDlfNiV2FSK6vTD5nzQAzjBVjRoUxBL+O?=
 =?us-ascii?Q?fpcQyy3BRyWSYInNxl96Vn2HN8C3+dLVAGGMs0iWF9FABeIkLKvEyTkYZJlU?=
 =?us-ascii?Q?Glrbxp1/VNn5KJkn/fr/36pDtt6R+HxMPlU9L/3V2fBRSbAiFMP5uLJhl7Zu?=
 =?us-ascii?Q?RN3iaX4dL5O0K36eV0lG45gIXFb/7PIXtg3InwrmQTuP9qkL4OQIcBlXOGNB?=
 =?us-ascii?Q?Y1rZJ/9POB4ja3BLBL4nHwMoeUF4wrYgQkK+5v9pq7Q+FYp4YmmenSXW/cRy?=
 =?us-ascii?Q?jMYPSZS0RdIIVbwNz90kwMG1FH0blsweV1W9VVU5NCIMVuINIGdtdRIXFrSP?=
 =?us-ascii?Q?1nTMARtr0mVvAPEZs1/fdavVFiNkFytb7w23WO9ZbFi92MIB9MfWMcOsY7JZ?=
 =?us-ascii?Q?+oIqPNGmNqJt+PNe1kJ1NS5UegIxeTHhtodn5ViCCtbxlsUC8twrDNVdnnrS?=
 =?us-ascii?Q?I/CJWaYLhKkhvntOLZCfHRDYCW/TqQCg/Dvr2N4yF/iAYz9sszV0Vm297tar?=
 =?us-ascii?Q?tt3PJpdmICGrd5/fxBkjlq59d10TY7jpibb0+Q1/XHm5aFGeNfiqT5Rx4mHt?=
 =?us-ascii?Q?h6wrmoMADYSUqUe+Ge1h04646P4nIrzEvmC82wq5LSvuiLgrTA+IpxFlHw1u?=
 =?us-ascii?Q?vGQ2SRAK5v1Z4Bt61UliBzQq8vXX3fATJFiF1YRZwU0H7+5ji7SU7msyAECd?=
 =?us-ascii?Q?WDODpBsMkctmdjt9/7nDV5DrxGlrhfoQcy+pvCC4xG+17UGK4IF2FyGw73Ah?=
 =?us-ascii?Q?wvr9L5SM0yIZKIb780oThxkt2w4MYJ0p+EVZD20WA2v+J0GmlkC9IIiAy8Uf?=
 =?us-ascii?Q?TtY6Er6152XLQCVuhBe9qgT2rYXZcBnCGSHxhAFn41uv7ulvlqFqsVoemyhK?=
 =?us-ascii?Q?Z9mj7dHGHBak1wuZMi4Oj8WtiIdc24XmtWHM+QFUKNlsBfAReg2hW6X1hnbV?=
 =?us-ascii?Q?LaOk+OkTzUhX3CGy/Nql9xbXlHNCfmjA0wF5Is/KdVbO4wD2UmeiqHUWBLr0?=
 =?us-ascii?Q?QmB2yKWcpVNmj54UzjKOlIKCutQh2Bja3gaRdqSgH2pAWxdPlJuNFlncajC/?=
 =?us-ascii?Q?DKwElS3z4MjEK8FcwJMA0CbCR11kEVOVoSYI8Kd3lLRnZgjiRzt9mHvQHjM0?=
 =?us-ascii?Q?uLrHvEHMl0bmiEn1UvRHu6JcdvNjagUYb+FidgjuLbS0yiEzyZhtKNIvPKuw?=
 =?us-ascii?Q?Ahgp27ExzEUwcvEObjYozBRXe55XhrdkrPcZrze46i2bRh/Xa+FONyQ7wsFH?=
 =?us-ascii?Q?rv0oddCwqI8Cd/s+H0NeZmB5V8d+9MHUFSn+hT8r1fgNgdhZa9zDAhlXve3S?=
 =?us-ascii?Q?VRS99jt7/hOZvH7No45pmh70L5X1uUmG5Jxk1xRWXrdcbhgQyoIPRmRFlnhi?=
 =?us-ascii?Q?v6w/mMNuxs5Jh+69Boh2tdbEAskiJmwRJ89JSiOJTd8jb7FW6vT36Didh5wE?=
 =?us-ascii?Q?Qvzxnw5K/1jHh+ExeHXzFoY=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc115403-fdf5-46c4-db67-08d9ab5a803d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 12:45:43.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1vqe+B0+JFVf24rpugLoLe28k5Kc/o6wmrZAHL1SKIVua7MurW5iRSJDjfPGfLBuw0zr8LSu4ulpbKL9AASEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8444
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds RISC-V support for KVMTOOL and it is based on the
Linux-5.16-rc1. The KVM RISC-V patches have been merged in the Linux
kernel since 5.16-rc1.

The KVMTOOL RISC-V patches can be found in riscv_master branch at:
https//github.com/kvm-riscv/kvmtool.git

Changes since v10:
 - Updated PLIC CLAIM write emulation in PATCH5 to ignore writes when
   interrupt is disabled for the PLIC context. This behaviour is as-per
   definition of interrupt completion process in the RISC-V PLIC spec.

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
 riscv/plic.c                        | 571 ++++++++++++++++++++++++++++
 util/update_headers.sh              |   2 +-
 x86/include/asm/kvm.h               |  64 +++-
 21 files changed, 2497 insertions(+), 19 deletions(-)
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

