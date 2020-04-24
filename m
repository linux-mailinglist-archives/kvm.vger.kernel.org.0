Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25501B6CF9
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 07:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgDXFA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 01:00:29 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59918 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgDXFA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 01:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587704446; x=1619240446;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sfZu6yrM8VoTeI6/Bi9Jex8NFBkD0hSINfutrwDKQtE=;
  b=GsybU/P59InpXRg7BsUxk9kgYVM+TJhLVYUbJdaGaTpJ3C9oHgAk9u0q
   m0jETenmzDNDVb/ygi+wghoSWiuDPLh31XdqqLNgnVxTvtaqnykIbZ1Kd
   pvoWqroPEggrNQexRUONh8WFdy2x/XqACk6aYPh74dHv1m31H49T7B7Ge
   Aj2HjCtjYzKLaabEF0iS/RvPj+Uqv1/Afe4pE5VgewUk0N56Vk9CE/s2Y
   WhE4KQbW7HFh95E6WEB1cyXi4cT8oE1QNvgg3Zjj3aAHsA28NENx2an+D
   QWgFsz99niG4ubFWxWtVSHodxqU2thTWff3RuSwqtY7zQIjirFnjfOaWT
   g==;
IronPort-SDR: uICNRq5niBSP5GDgnsOklYUCCmHdFdZ+PDrHqgzZalWDHSXHW9q+DEv55hkksf/juBdcuMt2A9
 nW8ZBl7N37lNNKH96ggggv5sx9z8xASbGWDP+MROuXVEwRyNKmhtR2hmD27o3Y1eS5/k16YnJ4
 SGJ150SS5zfwCGR2wEdcHJgnR1aVtD+OUZ1lCg2BpHgXh+3OfE+Kqx8BWZU2BxlEEhb4sAB7p2
 GZZeds5xXkRjERD+J20sf9lapOfoyNqGDAV5zlZXsCM9fx3GL6cMYH/DNSzop1xZLE9M9kJ3gd
 1xU=
X-IronPort-AV: E=Sophos;i="5.73,310,1583164800"; 
   d="scan'208";a="238539735"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2020 13:00:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6qzUUs/J3T6jgcjLc/I+aSysy7DQUH2BiQHoVLnm5N3nGirjamErOe7nDZIRp9jUAQllnHjdsM+j8NTKxJSpMinJukLxXHkLc0LgTUVCcHH68jbOFERiDtBp7fkkGehAPSZfJfXI7wjOko+WROnvqMhIw31h/voEizhgdW3SuoeJe0vYWAYidNuEZGqmirPaq3y3WnXq/1/lwfLlhO/yA0gAqrkHH5gO93AGtZoJ97MXcnvqDRy6pgZk8vhr8bDbHWGCTpdks8NL3M3AJOmdqfWc9bsyPBArerum4q8DmsFrazwcwGZ3942dpGVqyAKJnaN5/qDTLmpeBwtEnP7Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wI0APD+SY5wiVNkFQl6Upr0Yo48WXhB76pMK7RKFqk4=;
 b=ZmbK35E7IRE2EHa3AlAthSoVGY4dQLNdCSzDaXD5FrzLBKIqK41UUqifgkv68bqkacx+16Em8u5XtAt4RbWU6k1Dq05sQsQPHfPIuMbaIC74vizzjCMwMKL/xplezzaSlmX6jYByIbD2/f29OUUgJchC/c6voZMbuvtYnEbdKSv9FgME6tSbVLEZox08aBgQFvmOWxOSQKRcMyrINhF2GxTgyLKFSeXRF0dTohGL5h+fDrgYzk5vjXu/bqHcaRdQMbFO0NcjVtwiNxdgoIX3FqRLvd0ooouXW7i/J2tSYBW19i8U9y5PPBxEKiJdUCFTF/ZAPSRF5atwtYdocx70Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wI0APD+SY5wiVNkFQl6Upr0Yo48WXhB76pMK7RKFqk4=;
 b=XZ4XkGwsM4gLnP/S8xLlBVWKHMQq5hD2THYZEM4JTlOYMHU2JJwbDQ+H6HyqPfp2R915wlnWsQ531kgaGAGo4MtD/8nBPDFyMIMlcDQkmAjAiInBcSpQV3Ve5llUO6Ds2QSf9WoDRRkVbfc43aqtqkuL67Pp0eXP6wqrrniL23E=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (20.178.225.224) by
 DM6PR04MB5467.namprd04.prod.outlook.com (20.178.25.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Fri, 24 Apr 2020 05:00:25 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 05:00:25 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Alexander Graf <graf@amazon.com>
Subject: [PATCH 2/3] RISC-V: Add bitmap reprensenting ISA features common across CPUs
Date:   Fri, 24 Apr 2020 10:29:27 +0530
Message-Id: <20200424045928.79324-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200424045928.79324-1-anup.patel@wdc.com>
References: <20200424045928.79324-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0130.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::24) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.136) by MA1PR01CA0130.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 05:00:19 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [49.207.59.136]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1a7942b8-0f7f-4348-7003-08d7e80c6658
X-MS-TrafficTypeDiagnostic: DM6PR04MB5467:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5467A03D92DC198755BD55D78DD00@DM6PR04MB5467.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:317;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(54906003)(110136005)(55016002)(52116002)(7696005)(16526019)(8936002)(5660300002)(7416002)(4326008)(2906002)(8886007)(6666004)(81156014)(478600001)(1006002)(186003)(316002)(1076003)(55236004)(36756003)(44832011)(8676002)(2616005)(26005)(956004)(66556008)(66476007)(86362001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HaHngytDr3W7yL8EQGmuHhsnrADQu6CaqSKwe8MjdflJj/WrlpNTHvb7lg1WwEns+t3gDwQvInE0if4sulWSkz4iYXkM5tW+7CoWWv/OiF1pEta1OZIt7bAk4U3vs4xiDoEmgkTDk0I//7wFjXvghwAHfX3lkGXl3iegVzHLqYxb9ArQu0591KfvAwd6L4BKTaehuBMKme6Y4/XrgKgQbkYSdiCg9aMHB80sPRn/ZmkQjaRut0/AKoyPJL4K37Kx6G6yYk2u5x+ms/bp5vUny/9SIH/p8s73zGzaigvE3RaISwrhcsujgNSwY8QMayQ8HIexkUyHB72tbOMWAoZBW6zEsf3VXadTOYYubnVsvwkUQZ6xqG0a1fq19wLlL9Zj42lxXqgovqsRB12cVs8ePHs4uYqE5Dy2WvaslxsqZLUnL+//aFArrCitrMpiFr48
X-MS-Exchange-AntiSpam-MessageData: 2sitiZQnptFraAOGiJ+7j1SIGexCJ/K+T0wLUDEThCw0PRFZL5LbK/9nhTpMwRf2exPoezs7aBAjjEU28Q5NV3U9cYvuDVSNebGJWycoXzQkd3OvvK+ppyP31nGLso7Cx/Fdr1G5BfY+u1r7c16cGA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7942b8-0f7f-4348-7003-08d7e80c6658
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 05:00:25.1657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VnhetGthr6EhIrv7fWSOySBHfypdPHQ/1OfbRoDcE2ZRploWouAc/n1Q/+WWrOuKhXsGRZWjPbQIsPf72yyoCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5467
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
2.25.1

