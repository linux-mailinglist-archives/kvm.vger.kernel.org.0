Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F109388592
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353223AbhESDjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:39:24 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8548 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353258AbhESDjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:39:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395469; x=1652931469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=i+O/YPObDiBYsf09FLSyCzU90L184/CeH4fVrBOD2Nc=;
  b=AaJXNOprVN9j0qosJkFWK371tayHnFpqq8I1aM6tUIFLJGfe0siCAZei
   lG9fZLkSqHkXF2ekACrkbGcuCR13mGBuUYzaPtMePGvyXyn5SXnIMH74K
   VGog6WFUXgQcXokfTmkHnI5Q0+lAD1XzWmB5ZUxLggDDu1OW8c+Q8sL0v
   WtyAy8JnqQpf8mVZRKwgn0+0sZUYTGcAo7k/BvNQ1szUIBeI74Pqh4xs2
   icBhAfHYTky9it7y9BmN5McWaoXpdv5r6IPdH7zgAc8EFccgH6q6lZria
   KDAMQXzc3rZ/T5RiuEhUFmALjWmeXndlQKstmcPv2EoaxLyJpfhMFXyIP
   g==;
IronPort-SDR: KMjlhCjzULzFUz/lxEH+xCoW3CO0pOWSZWaHvhg4pRWWJoQLG2F05HmLX4y1nUN0+6gQrXdgc4
 bdmy/PUygouCGmsxBBvxNN2E0HcLAmnsmPDnAIp8UlKqAI6/MBbyB1jys0946TQH9yNpliNbTa
 GmdKEEQ6TRGnk5Rk1HaSUC+a888EsqMazvHtQTy2R1gG73nDfOLC2Ohqn/0NJ4/twfVtQ9I3vT
 E1p5cX+zgJStuK8+50hDo4j/HYD1pOxF5nY0Z+NneYLpjMPzoD4HORYKfqUA8ZsQAVWqrnpwSA
 CVg=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="173270052"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:37:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyx0pGc2ZCPouahyRWC9VI1EQOhIcnI06LU1JLfF3h36CM7nJfiHK3p0gPO/BHO28uJBTUtK4n9RIb8dtcVzW004iwbjrgAj8tvTcLAMqj2yPArw1ajSsELmPq3Tv0hC0YtWjz48rBTfUtEwNPLPrY3uX1bfzmzvqGJfkvEsQJ1Vw/JoeuSwQshBLtmFYBETse6qkjUcuHdqs08koV5Hm6dyKXkk8sPw4L7GqyiWjq1XYi+tssd28BlQFJWhOs4zjn680F3WdilsEFwKw8g0GBDJWYO3NG56Fz4Trvy1jRXxNF0WD1f+IcQd+jPLZ1ZgTGCk6O9nDY35vPnqnyEwbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+4jHCn/uRLGeKeT4nLLkdgSTPUWU48BGBb8PqAzFgs=;
 b=fgbQ+NP2JjsxA4Y+GW/rdikYjCHTraY9FCdEQqt6t5dvmUVbN58GQSvUlCcMbKSjMFoQYzUJWHPadg2BS9n0rzjY5zj3IpDFKHOg0gvmTPB3sCS9B++R0TlONkw3KInPhe+q7ckoHmafhwBT8AH02Lp9fLl/C9Saa2AVTfBgjC57fjr1Ws1WvZb8716HkM6tVyT7WUQ0UkHq7YnulrrmG48PitUQ+Z0peYYs0MgGZ0TwEHEcNIx1rdDwr0iIWoV+4Qmns6bIYFwpc21mPoNEj/uNsFM/tRpBhsndjBfxJ6VBiyWH0cjPmNeT/LAVTRXc67Z26AxP3HhCXutM+Thi/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+4jHCn/uRLGeKeT4nLLkdgSTPUWU48BGBb8PqAzFgs=;
 b=XkswKiOfDDu9ig63tLV/CaV+0AyDfW2HkEcVYufWp2wFdSkq0C95hHJVgIXaGhC42VSQd/vQziQR4u8Z/x6xeExmHWf8PGBR+fqP0xenIm/tSUzqMc1atnxbOI0cbybmv+sSTZYZRlyUbhJJ1og3vk5RdbX1HTDsOvfd5bafbhI=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7745.namprd04.prod.outlook.com (2603:10b6:5:35a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 19 May
 2021 03:37:42 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:37:42 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v18 17/18] RISC-V: KVM: Move sources to drivers/staging directory
Date:   Wed, 19 May 2021 09:05:52 +0530
Message-Id: <20210519033553.1110536-18-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033553.1110536-1-anup.patel@wdc.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.32.148]
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:37:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 683dcec3-0742-4ea0-eb79-08d91a777511
X-MS-TrafficTypeDiagnostic: CO6PR04MB7745:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB77451D49C6A28877051DB6728D2B9@CO6PR04MB7745.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:323;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g2UsPfx853pxUefRLo+ieL69/Tan40q98atLr0R4RgBwL1AbjsHpqTZNjsedGys3Zssdav3uooVXH/NPdCUXkPMWJ6irpOxqLkuc+V90uZUa41rhPgwDOz41TN3lxp0aTKbEGz7++vihX/MuLYsOLzmp7r0A5l4oo4qze+7uVVmH3lkhTiE9CxQMqwfjq0RsNr86AKNxj7aZoDPjmBryQtIOqVl0zikr8IBvRX6ULCwoMS4oqPE/XJI7fa/KPulXjj8LXxbd6sTq/RZSfvPR3BxhWkRrdIZ2yUTPaTDpkuPw/YDYZoTDCPCqgN9nzQmuc24yNa5ZipcPIsW1PJrW/jvB69L+W7z3orp2jf3u9tFNWQgN5f1dNfCQQHbSKhwhIiXdQlhq+UgcRJmaM9w9+N+UpeGFUhTLLI0wgAaDcy4mSk83EqVW3a1kF77LtJmt10WEG0o7zLOR1Of9twYyaGVYfFLJ+UpcQA20sKJO4Pv6M5mMd2MAdNz3nfAV0ODEYMvjNoVEbkA0ZM+SqosgZPJL8y3WnkeW/awHo20GQEQXynx7bnlLAifRNAFNbLQwDUCGyGSPFWs8E31T/twQ/fvP6X+CQULkdniBJlq9KLBpy+EEmnhUFCUlqdN87Wf9T6k/Z2akNc9rQa5dLpXakg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(7416002)(1076003)(66946007)(478600001)(2906002)(186003)(956004)(2616005)(26005)(16526019)(36756003)(8676002)(44832011)(6666004)(55016002)(7696005)(52116002)(8886007)(86362001)(38350700002)(66476007)(4326008)(54906003)(5660300002)(110136005)(83380400001)(66556008)(316002)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JUYOFhDMKCCSB885saMw6wB4hlekTeLhpHPF61pTalF4JQOkbxfXmFcpytAV?=
 =?us-ascii?Q?8/nCEsm1rgQMeDgIOMjEv8LpgLX+LKMMBMd4SzFWEvjxuwiiStEVlRPEoPaA?=
 =?us-ascii?Q?2W8cThW6nLFPQU4kbLJUawq969Kgu188CrSpncAH4+PRJzk9SSwZVWyGjaLG?=
 =?us-ascii?Q?Cl4Jaej+zXPIwYuI3EDbUdfUMyPmR3amEvRHQLokUeNxw58OkVDVzTFD8df1?=
 =?us-ascii?Q?b7KYNKL/cBtYzU9weAXLpYWXKYQOo5LS7Fs7KYpsByq7RGF9jOEjycRwQxjL?=
 =?us-ascii?Q?oi9f/qfj05h4nwmSMocoWQ+F45HmGY3PvHBASZDaI0f0lXn0TCNCzJoa2fKA?=
 =?us-ascii?Q?pPc65j8wAgvqVHgwfU29eNxKagIXPFHoLBXkY6hjKqkoTTDxxIrjJDLif2Nx?=
 =?us-ascii?Q?XsMh/8r7aZNpwNymhrw5H6bvgz22zrGLGfqzIkJr83mZlONb9sGUNPK2ilba?=
 =?us-ascii?Q?NarPkNYdcYn5BgGXYIOHxupt4nxd+itmwW4sf3AhxM7RKqB9tjTmPJ2hNAHr?=
 =?us-ascii?Q?Y0TM1uHuAQQvXDz2s2ZJgQSOVpIDTDZ4uoqa7r5TPCBHrLtOgThlVZT1o+uo?=
 =?us-ascii?Q?6npF74WlIL/reXDJ1G88sd9uWSORJRJV8gnIrjVjTuNOnRXLZn6dIIyFKw1f?=
 =?us-ascii?Q?IhikcJ4DQ2KUpRKcL8csI4vsOZhciDdxqu3UfxdETcR4ce244e7wssKUIYab?=
 =?us-ascii?Q?Ca5GO9CAlzSgWfX8j69cVSmRaww5r7+wNWg/gHYANGht5JBgwIiWB9bWOqxB?=
 =?us-ascii?Q?2ie2LFCSeqqblzH5RF5DHe17Wh550klGR4ZT7GoW8wB/SeuSHtzS285GIdLN?=
 =?us-ascii?Q?GY7JVnwug4uLhBBDWc2+8Y2a4t43OMPbsaRgnDSinar096yc5/NGaaj2YT/E?=
 =?us-ascii?Q?M/ZvUHAu1FKyjyF8tL3yePd9nivto1QpoUDlOC+1WWfR2w8+7u0u4zsQaM3l?=
 =?us-ascii?Q?GzkQXkcyZ4xiyZLZwKxrQtuOIFvBY5bZH9vf9omnwi748wqMGpOqchoRaKkf?=
 =?us-ascii?Q?RPM1+hLE0pd4LFQTOvXdIFrYKsNrPQwkSwq/0kC82fiSIww4KOY21McS6Vt3?=
 =?us-ascii?Q?MaCOj7A8v1sxe+bHQ/ZY8EoXOJiyVYnGXNAopmwaY92DR6sGInC28nhC9AuH?=
 =?us-ascii?Q?pkHVstyTuItFqI4btQ/v0ypbPeK1l1JGp8uK5Bf/yjdeOlUz3WQrMj8/VkPF?=
 =?us-ascii?Q?BTipYESx1nBowTB+o0CYEWCskKQZ7OPG21awJdE54PwTDY4cQJiWBVY6XC+0?=
 =?us-ascii?Q?GfsE4Yq99EnH1LIRkF850AwJZhX+eTz6E5o8hhKDr2DUCYZFVtRkCIzVHX77?=
 =?us-ascii?Q?EQ0Mbwlf6qWG2Ptr7hYDK1iT?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 683dcec3-0742-4ea0-eb79-08d91a777511
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:37:41.8499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1RMc4D2UYfqaM1zVWXRjRjrbEfdNq5G9qyyx2nE7ttTs9rpw/ZM7EFivYgtNYrqP5393iqySEQL0TKknO+6Hdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7745
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As-per the Linux RISC-V patch acceptance policy, patches for unfrozen
specifications won't be accepted in arch/riscv directory.

To unblock KVM RISC-V development, we move KVM RISC-V sources to
drivers/staging directory. Only arch/riscv/include/uapi/asm/kvm.h
header will remain in arch/riscv directory because this KVM RISC-V
UAPI header is compliant with ratified RISC-V privilege specification
hence also satisfies Linux RISC-V patch acceptance policy.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/Kconfig                                          | 2 +-
 arch/riscv/Makefile                                         | 2 +-
 {arch => drivers/staging}/riscv/kvm/Kconfig                 | 0
 {arch => drivers/staging}/riscv/kvm/Makefile                | 6 +++---
 .../include => drivers/staging/riscv/kvm}/asm/kvm_csr.h     | 0
 .../include => drivers/staging/riscv/kvm}/asm/kvm_host.h    | 0
 .../include => drivers/staging/riscv/kvm}/asm/kvm_types.h   | 0
 .../staging/riscv/kvm}/asm/kvm_vcpu_timer.h                 | 0
 {arch => drivers/staging}/riscv/kvm/main.c                  | 0
 {arch => drivers/staging}/riscv/kvm/mmu.c                   | 0
 {arch => drivers/staging}/riscv/kvm/riscv_offsets.c         | 0
 {arch => drivers/staging}/riscv/kvm/tlb.S                   | 0
 {arch => drivers/staging}/riscv/kvm/vcpu.c                  | 0
 {arch => drivers/staging}/riscv/kvm/vcpu_exit.c             | 0
 {arch => drivers/staging}/riscv/kvm/vcpu_sbi.c              | 0
 {arch => drivers/staging}/riscv/kvm/vcpu_switch.S           | 0
 {arch => drivers/staging}/riscv/kvm/vcpu_timer.c            | 0
 {arch => drivers/staging}/riscv/kvm/vm.c                    | 0
 {arch => drivers/staging}/riscv/kvm/vmid.c                  | 0
 19 files changed, 5 insertions(+), 5 deletions(-)
 rename {arch => drivers/staging}/riscv/kvm/Kconfig (100%)
 rename {arch => drivers/staging}/riscv/kvm/Makefile (69%)
 rename {arch/riscv/include => drivers/staging/riscv/kvm}/asm/kvm_csr.h (100%)
 rename {arch/riscv/include => drivers/staging/riscv/kvm}/asm/kvm_host.h (100%)
 rename {arch/riscv/include => drivers/staging/riscv/kvm}/asm/kvm_types.h (100%)
 rename {arch/riscv/include => drivers/staging/riscv/kvm}/asm/kvm_vcpu_timer.h (100%)
 rename {arch => drivers/staging}/riscv/kvm/main.c (100%)
 rename {arch => drivers/staging}/riscv/kvm/mmu.c (100%)
 rename {arch => drivers/staging}/riscv/kvm/riscv_offsets.c (100%)
 rename {arch => drivers/staging}/riscv/kvm/tlb.S (100%)
 rename {arch => drivers/staging}/riscv/kvm/vcpu.c (100%)
 rename {arch => drivers/staging}/riscv/kvm/vcpu_exit.c (100%)
 rename {arch => drivers/staging}/riscv/kvm/vcpu_sbi.c (100%)
 rename {arch => drivers/staging}/riscv/kvm/vcpu_switch.S (100%)
 rename {arch => drivers/staging}/riscv/kvm/vcpu_timer.c (100%)
 rename {arch => drivers/staging}/riscv/kvm/vm.c (100%)
 rename {arch => drivers/staging}/riscv/kvm/vmid.c (100%)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index d0602ea394bc..e79a73ff86c0 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -555,5 +555,5 @@ source "kernel/power/Kconfig"
 
 endmenu
 
-source "arch/riscv/kvm/Kconfig"
+source "drivers/staging/riscv/kvm/Kconfig"
 source "drivers/firmware/Kconfig"
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 05687d8b7b99..e8706c01733c 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -92,7 +92,7 @@ head-y := arch/riscv/kernel/head.o
 
 core-y += arch/riscv/
 core-$(CONFIG_RISCV_ERRATA_ALTERNATIVE) += arch/riscv/errata/
-core-$(CONFIG_KVM) += arch/riscv/kvm/
+core-$(CONFIG_KVM) += drivers/staging/riscv/kvm/
 
 libs-y += arch/riscv/lib/
 libs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
diff --git a/arch/riscv/kvm/Kconfig b/drivers/staging/riscv/kvm/Kconfig
similarity index 100%
rename from arch/riscv/kvm/Kconfig
rename to drivers/staging/riscv/kvm/Kconfig
diff --git a/arch/riscv/kvm/Makefile b/drivers/staging/riscv/kvm/Makefile
similarity index 69%
rename from arch/riscv/kvm/Makefile
rename to drivers/staging/riscv/kvm/Makefile
index 938584254aad..3b876b6263e7 100644
--- a/arch/riscv/kvm/Makefile
+++ b/drivers/staging/riscv/kvm/Makefile
@@ -2,10 +2,10 @@
 # Makefile for RISC-V KVM support
 #
 
-common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
-common-objs-y += $(addprefix ../../../virt/kvm/, eventfd.o)
+common-objs-y = $(addprefix ../../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
+common-objs-y += $(addprefix ../../../../virt/kvm/, eventfd.o)
 
-ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
+ccflags-y := -Ivirt/kvm -Idrivers/staging/riscv/kvm
 
 kvm-objs := $(common-objs-y)
 
diff --git a/arch/riscv/include/asm/kvm_csr.h b/drivers/staging/riscv/kvm/asm/kvm_csr.h
similarity index 100%
rename from arch/riscv/include/asm/kvm_csr.h
rename to drivers/staging/riscv/kvm/asm/kvm_csr.h
diff --git a/arch/riscv/include/asm/kvm_host.h b/drivers/staging/riscv/kvm/asm/kvm_host.h
similarity index 100%
rename from arch/riscv/include/asm/kvm_host.h
rename to drivers/staging/riscv/kvm/asm/kvm_host.h
diff --git a/arch/riscv/include/asm/kvm_types.h b/drivers/staging/riscv/kvm/asm/kvm_types.h
similarity index 100%
rename from arch/riscv/include/asm/kvm_types.h
rename to drivers/staging/riscv/kvm/asm/kvm_types.h
diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/drivers/staging/riscv/kvm/asm/kvm_vcpu_timer.h
similarity index 100%
rename from arch/riscv/include/asm/kvm_vcpu_timer.h
rename to drivers/staging/riscv/kvm/asm/kvm_vcpu_timer.h
diff --git a/arch/riscv/kvm/main.c b/drivers/staging/riscv/kvm/main.c
similarity index 100%
rename from arch/riscv/kvm/main.c
rename to drivers/staging/riscv/kvm/main.c
diff --git a/arch/riscv/kvm/mmu.c b/drivers/staging/riscv/kvm/mmu.c
similarity index 100%
rename from arch/riscv/kvm/mmu.c
rename to drivers/staging/riscv/kvm/mmu.c
diff --git a/arch/riscv/kvm/riscv_offsets.c b/drivers/staging/riscv/kvm/riscv_offsets.c
similarity index 100%
rename from arch/riscv/kvm/riscv_offsets.c
rename to drivers/staging/riscv/kvm/riscv_offsets.c
diff --git a/arch/riscv/kvm/tlb.S b/drivers/staging/riscv/kvm/tlb.S
similarity index 100%
rename from arch/riscv/kvm/tlb.S
rename to drivers/staging/riscv/kvm/tlb.S
diff --git a/arch/riscv/kvm/vcpu.c b/drivers/staging/riscv/kvm/vcpu.c
similarity index 100%
rename from arch/riscv/kvm/vcpu.c
rename to drivers/staging/riscv/kvm/vcpu.c
diff --git a/arch/riscv/kvm/vcpu_exit.c b/drivers/staging/riscv/kvm/vcpu_exit.c
similarity index 100%
rename from arch/riscv/kvm/vcpu_exit.c
rename to drivers/staging/riscv/kvm/vcpu_exit.c
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/drivers/staging/riscv/kvm/vcpu_sbi.c
similarity index 100%
rename from arch/riscv/kvm/vcpu_sbi.c
rename to drivers/staging/riscv/kvm/vcpu_sbi.c
diff --git a/arch/riscv/kvm/vcpu_switch.S b/drivers/staging/riscv/kvm/vcpu_switch.S
similarity index 100%
rename from arch/riscv/kvm/vcpu_switch.S
rename to drivers/staging/riscv/kvm/vcpu_switch.S
diff --git a/arch/riscv/kvm/vcpu_timer.c b/drivers/staging/riscv/kvm/vcpu_timer.c
similarity index 100%
rename from arch/riscv/kvm/vcpu_timer.c
rename to drivers/staging/riscv/kvm/vcpu_timer.c
diff --git a/arch/riscv/kvm/vm.c b/drivers/staging/riscv/kvm/vm.c
similarity index 100%
rename from arch/riscv/kvm/vm.c
rename to drivers/staging/riscv/kvm/vm.c
diff --git a/arch/riscv/kvm/vmid.c b/drivers/staging/riscv/kvm/vmid.c
similarity index 100%
rename from arch/riscv/kvm/vmid.c
rename to drivers/staging/riscv/kvm/vmid.c
-- 
2.25.1

