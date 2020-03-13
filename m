Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BAA1841C4
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgCMHxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:53:40 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:9726 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgCMHxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086019; x=1615622019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=xaxXPMrIsfuL0yrFV+LAnWNnEsCUOjyQn8sL5gmqPg8=;
  b=DDbUUeJPupaY9FILQ9bRQCo25KGCr3HOpMz2TYTtikjDNpvsDI5Oq/3p
   g1hFpdToUHIpYHnfT/GUgQTsI+EJC9aV8RY8N0FDsxv9srUtKCc9chHxU
   VG+YlWi5iHUQkO2FtfxTOQQqtzElE3Hpcmt8lPJ+iXvonHNkMCiRa56CW
   2yDNYgqMHWbmB/jZGvF7D3Z6Fw44KG85NYSGVkbkJvisAj+YdVcz0bc2e
   E9wmIDY7WFbfjOHUt8q5QqBuECR6AhWIZEq2xQ+ushHg5YcDGH1vRWheq
   Fd+R+ElvkgYPYvjlFCSeqtcrDBNv1CCTmAdVrV2fGDSpWD2u1bzc+dFuY
   Q==;
IronPort-SDR: Kk+Ayjx7zEU9gRgmn4u6DoFJjzl/2pk1OF4kgIY+AS3QBTEL3TPlT5cxo122NHMjesJ1Cj2F1/
 A0l2kX2ut+eqyZVgqNM8YufqqzCKmc86x0+2LcECl1mTVMFDW6JOmcscnWGUz8f6KJuq3xy4tZ
 XQ3TVbe7m3tapq01XTfOdX1dvcR8nOEigJ9BbT8C7zNnARvAHbMRseangddSohuxmp9tn5CETN
 7r8057UnZRgNFcg6C5/hbHWTJtuUtHk5kHIKkyZzSvMTHqkmIVSXvLVQpN3EGuF5Dae/SQCABn
 DQk=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="132374563"
Received: from mail-sn1nam04lp2055.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.55])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:53:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSZFOn8ii1aI6vUEI93woHtkHXXL8t34gkv05FBPYRArFf2605Dczxc5R70qKYgy4dmZebOkkr8e0J/q+ejfWLMZT+WDkaZbt67sWeNTS2aeBVY3WpGWf65YT/lUFSeLmoy7WjJveALlxFsl1RN2jsUy3VJvulgDIEphGaYQUGVvapWf9Uv2WkzeBU5o9ce2KbjP2LMaaaDSl51YZ8FJT1qsRtprNT9gqS+WVUgCQc6cWHx4/h3PfYmrLRM6SQW7+VI02phRbgLVqELzQpXQ+AVda9J01Y03nwKxg4LVC9f+SVxprNvRffTu/elJ61UOECKa1Ph1Muzc5VtbZLnNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeupZ5za/8D4buwto3UqZ0ChAeK7XLNkBlF6aE20YoE=;
 b=EmRpmt4y3QdP2SJbLYWtAEyFbcRLiCAzc7Wl7YE5qmyWqGu7lOlm9zHZwa4difi5IHD1f0uucPBAOrnOiJK8mt+btJ+v+RkI3L0n8+M1GYcQldllCel12QJFaUY5cqFE/I5CopISfTjobub8p9YcC8frrptTL03U2tTQZ3+TjhS7sC3m6PcvhzufkeMG9n6YP/TwgrIkWGxzKdBMUpqPB8qh7G2hHEpq+uqjm9TkQsd/X0ti3NuAGXXRdbl7qrQFuAoyWBo8dXJ1lyc1o5cu1G9fw7AWf0k/MGsAmzFhTClxdTMuo0txPgdg458hwDSlw3PDpv268sZTuqg+v6Xs5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeupZ5za/8D4buwto3UqZ0ChAeK7XLNkBlF6aE20YoE=;
 b=LviXpm3eQfhQNtepEFzoc3xFOIgIe6YrNN6svNZ2c8wNoIgxN7uMCuWMsi/KHEVwr3Zq1CDa+j7lmTf3dPxuy/nzB9We1lkT6MOkO+APiGwF5kBwvJJrGIUE4iYrcpvGggBQCXUNAeFAJbdo8bnTGNrAAd3OUJ7MHBzxukjapSk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6637.namprd04.prod.outlook.com (2603:10b6:208:1ef::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Fri, 13 Mar
 2020 07:53:38 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:53:37 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 02/20] RISC-V: Add bitmap reprensenting ISA features common across CPUs
Date:   Fri, 13 Mar 2020 13:21:13 +0530
Message-Id: <20200313075131.69837-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:53:29 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4fcd1629-db75-4365-1bb7-08d7c723a2ad
X-MS-TrafficTypeDiagnostic: MN2PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB6637515788C7CB4AA57756C88DFA0@MN2PR04MB6637.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:317;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(199004)(6666004)(1006002)(4326008)(8886007)(8676002)(81156014)(478600001)(7696005)(5660300002)(8936002)(36756003)(81166006)(52116002)(1076003)(44832011)(66476007)(26005)(316002)(66946007)(956004)(55016002)(186003)(2616005)(16526019)(54906003)(2906002)(7416002)(66556008)(86362001)(110136005)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6637;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qH5IzVpVtHKe+/rtD0T2Gmzxy0airvWiks6q6z+Xg8jCrTp+w7BlgXKCJ+E6AYpjYYli7aY5n+dgDL13wUwmQfynDRpvrxsu+3aoLIQ0hY0Da0v6tSM2XP+Ws2EhNaIX+24o+eRkBpsLhjRZBAb3EUNEliWnP/eMMwqvgPLp8rH8Hk73mC+ydHSeZpboyl+eheO/hTy0pZZ5snQMwerSc597lVOtoLle5eD71hGYB8act8MKgXqiLAKp8HhhNBnObTMwQ8BSFkr1hzf3Jdy01V5w54uRSwLzVON96jwXhXM2PGt6NmEgURpzyleNA/34q1bomtP7inE9RJMBEmn6mOTOsxflrtdqkW+NDgH7MOTeRVElKnvqr6u2tpkJNweCkjRyJT445gjLS9MDRx62IBRvBBreI6IFS4oS++E+ZcdUS7FRPRreU0/Ww2pj78khXg+Nnp+7y0IE4ekGflQjQ8WBbL+aayMZDA9d8pfcCC8ev831jOns9i2iltELZgK06ug0jPkwWvNuALFi+uK95g==
X-MS-Exchange-AntiSpam-MessageData: ba8E/mohIVsdSwp57srm2MqF4FW+W0jp6TyE1RBrYEcmUKx8hEi8825MHj+G6jTAhYCFbQiZCLbvBG0hSZljkEq5KydIoK1O9y++uSZUsdx3ancwAEceyutx+zC3OmXl4XGQM7DBRYRRR41jHbSxuQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fcd1629-db75-4365-1bb7-08d7c723a2ad
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:53:37.9022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dy4OtL9f4fFMG6tbU47jYSwBfWSB/UL6g7dvNa7fsaXTRs3t5syot1zKUCfekuNffeHsqUqBZpx7oNAL1mMyqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6637
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds riscv_isa bitmap which represents Host ISA features
common across all Host CPUs. The riscv_isa is not same as elf_hwcap
because elf_hwcap will only have ISA features relevant for user-space
apps whereas riscv_isa will have ISA features relevant to both kernel
and user-space apps.

One of the use-case for riscv_isa bitmap is in KVM hypervisor where
we will use it to do following operations:

1. Check whether hypervisor extension is available
2. Find ISA features that need to be virtualized (e.g. floating
   point support, vector extension, etc.)

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Signed-off-by: Atish Patra <atish.patra@wdc.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/hwcap.h | 22 +++++++++
 arch/riscv/kernel/cpufeature.c | 83 ++++++++++++++++++++++++++++++++--
 2 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 1bb0cd04aec3..5ce50468aff1 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -8,6 +8,7 @@
 #ifndef _ASM_RISCV_HWCAP_H
 #define _ASM_RISCV_HWCAP_H
 
+#include <linux/bits.h>
 #include <uapi/asm/hwcap.h>
 
 #ifndef __ASSEMBLY__
@@ -22,6 +23,27 @@ enum {
 };
 
 extern unsigned long elf_hwcap;
+
+#define RISCV_ISA_EXT_a		('a' - 'a')
+#define RISCV_ISA_EXT_c		('c' - 'a')
+#define RISCV_ISA_EXT_d		('d' - 'a')
+#define RISCV_ISA_EXT_f		('f' - 'a')
+#define RISCV_ISA_EXT_h		('h' - 'a')
+#define RISCV_ISA_EXT_i		('i' - 'a')
+#define RISCV_ISA_EXT_m		('m' - 'a')
+#define RISCV_ISA_EXT_s		('s' - 'a')
+#define RISCV_ISA_EXT_u		('u' - 'a')
+
+#define RISCV_ISA_EXT_MAX	64
+
+unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap);
+
+#define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
+
+bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int bit);
+#define riscv_isa_extension_available(isa_bitmap, ext)	\
+	__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_##ext)
+
 #endif
 
 #endif /* _ASM_RISCV_HWCAP_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index a5ad00043104..ac202f44a670 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2017 SiFive
  */
 
+#include <linux/bitmap.h>
 #include <linux/of.h>
 #include <asm/processor.h>
 #include <asm/hwcap.h>
@@ -13,15 +14,57 @@
 #include <asm/switch_to.h>
 
 unsigned long elf_hwcap __read_mostly;
+
+/* Host ISA bitmap */
+static DECLARE_BITMAP(riscv_isa, RISCV_ISA_EXT_MAX) __read_mostly;
+
 #ifdef CONFIG_FPU
 bool has_fpu __read_mostly;
 #endif
 
+/**
+ * riscv_isa_extension_base() - Get base extension word
+ *
+ * @isa_bitmap: ISA bitmap to use
+ * Return: base extension word as unsigned long value
+ *
+ * NOTE: If isa_bitmap is NULL then Host ISA bitmap will be used.
+ */
+unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap)
+{
+	if (!isa_bitmap)
+		return riscv_isa[0];
+	return isa_bitmap[0];
+}
+EXPORT_SYMBOL_GPL(riscv_isa_extension_base);
+
+/**
+ * __riscv_isa_extension_available() - Check whether given extension
+ * is available or not
+ *
+ * @isa_bitmap: ISA bitmap to use
+ * @bit: bit position of the desired extension
+ * Return: true or false
+ *
+ * NOTE: If isa_bitmap is NULL then Host ISA bitmap will be used.
+ */
+bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int bit)
+{
+	const unsigned long *bmap = (isa_bitmap) ? isa_bitmap : riscv_isa;
+
+	if (bit >= RISCV_ISA_EXT_MAX)
+		return false;
+
+	return test_bit(bit, bmap) ? true : false;
+}
+EXPORT_SYMBOL_GPL(__riscv_isa_extension_available);
+
 void riscv_fill_hwcap(void)
 {
 	struct device_node *node;
 	const char *isa;
-	size_t i;
+	char print_str[BITS_PER_LONG + 1];
+	size_t i, j, isa_len;
 	static unsigned long isa2hwcap[256] = {0};
 
 	isa2hwcap['i'] = isa2hwcap['I'] = COMPAT_HWCAP_ISA_I;
@@ -33,8 +76,11 @@ void riscv_fill_hwcap(void)
 
 	elf_hwcap = 0;
 
+	bitmap_zero(riscv_isa, RISCV_ISA_EXT_MAX);
+
 	for_each_of_cpu_node(node) {
 		unsigned long this_hwcap = 0;
+		unsigned long this_isa = 0;
 
 		if (riscv_of_processor_hartid(node) < 0)
 			continue;
@@ -44,8 +90,24 @@ void riscv_fill_hwcap(void)
 			continue;
 		}
 
-		for (i = 0; i < strlen(isa); ++i)
+		i = 0;
+		isa_len = strlen(isa);
+#if IS_ENABLED(CONFIG_32BIT)
+		if (!strncmp(isa, "rv32", 4))
+			i += 4;
+#elif IS_ENABLED(CONFIG_64BIT)
+		if (!strncmp(isa, "rv64", 4))
+			i += 4;
+#endif
+		for (; i < isa_len; ++i) {
 			this_hwcap |= isa2hwcap[(unsigned char)(isa[i])];
+			/*
+			 * TODO: X, Y and Z extension parsing for Host ISA
+			 * bitmap will be added in-future.
+			 */
+			if ('a' <= isa[i] && isa[i] < 'x')
+				this_isa |= (1UL << (isa[i] - 'a'));
+		}
 
 		/*
 		 * All "okay" hart should have same isa. Set HWCAP based on
@@ -56,6 +118,11 @@ void riscv_fill_hwcap(void)
 			elf_hwcap &= this_hwcap;
 		else
 			elf_hwcap = this_hwcap;
+
+		if (riscv_isa[0])
+			riscv_isa[0] &= this_isa;
+		else
+			riscv_isa[0] = this_isa;
 	}
 
 	/* We don't support systems with F but without D, so mask those out
@@ -65,7 +132,17 @@ void riscv_fill_hwcap(void)
 		elf_hwcap &= ~COMPAT_HWCAP_ISA_F;
 	}
 
-	pr_info("elf_hwcap is 0x%lx\n", elf_hwcap);
+	memset(print_str, 0, sizeof(print_str));
+	for (i = 0, j = 0; i < BITS_PER_LONG; i++)
+		if (riscv_isa[0] & BIT_MASK(i))
+			print_str[j++] = (char)('a' + i);
+	pr_info("riscv: ISA extensions %s\n", print_str);
+
+	memset(print_str, 0, sizeof(print_str));
+	for (i = 0, j = 0; i < BITS_PER_LONG; i++)
+		if (elf_hwcap & BIT_MASK(i))
+			print_str[j++] = (char)('a' + i);
+	pr_info("riscv: ELF capabilities %s\n", print_str);
 
 #ifdef CONFIG_FPU
 	if (elf_hwcap & (COMPAT_HWCAP_ISA_F | COMPAT_HWCAP_ISA_D))
-- 
2.17.1

