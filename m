Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54C3129550
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfLWLfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:35:32 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:62253 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbfLWLf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:35:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577100930; x=1608636930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YfkvSlrFo8+dkvi8BfrNugml3fQOpZJv9yZG/Bi/1gY=;
  b=Iq8n8ko/ngugkFt6A57i5NiT2NMaccz11fzWigPPTM8ryqx6G3GT/zG+
   lEy7/5lpiizz7ovcZqvZ2Amljj4Wf+XpFJ+0rzqVle4F+vA3wV1Xu9mcK
   2UuH8jPemo1l84KRSM5FJRGoQxS1gBESRzBGQLccfXBHA0zJoxQQjWiPP
   QiyzbVZIG5Ks4KEIu+YZLoHZ5eF7g36nqcjbK2qL/E8dxJOUKVUMlTTqU
   IalCTkTtxOJMJqYs0ls9IpLM7U7+85pLaRuAcsgnHwIPurxRLfiZ9fmmb
   jqLKdZeOHoA8IMFgY/f7IJsqXcbQKqbxvT5Ppt90lkHQxq98UdSHxfhYR
   w==;
IronPort-SDR: QsKppJyX53Zz0XtJ3PxOXeLsEQPwJYG9TBreyIENS84tiwk8IuvPDlc04eQtoMbLsfBcT387g9
 mnErdS1W+nhP4s9ISEkALGXjAypu/Do7WvFmXCofAGg1vuQWpkqo3qCgzXb7WR2ZMAHYL/7i3b
 tvrMQXL3ZazCZndD7aFh3XinMCzr09ZJWxC8lYMUaTLgGoLPB6DoAvHrZbCIIDExSj+XO3Vke3
 OxxJlzTe9OUja664enw8qnqK52byYwv8hKg8RisGSlm/ayy2dw7tevic29OCpbchpnA7pvVj2a
 YlI=
X-IronPort-AV: E=Sophos;i="5.69,347,1571673600"; 
   d="scan'208";a="130393043"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2019 19:35:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/u5cAEYyazPiQVSdEB1TIgqT2sbcCTlz0sccQ0hE82K3YQsjAipLYA6BqMKUs9UWxC2FoUgbYD1XQhartu1Jfwsg9TvzAOHQ//uVDieFwC4oYF1FcoxI/e8pk4HQm88n0X7H3nxOU4qOK9euOtMyJSZPpTn+Z7iHQZpAef9PM8G4BIUy2xPeSXpHPdcFZd97SFrszYRo2Aq+g1dN7Ej/B4veSqtEfeZbaJudE4JF6oO2IKHbsVhFTi42PkGB/73JOYP0sVINARehCSu19mDNLHAfgfxtvHs68J28DQ7O0NWXi/2h5QQdqARVILHbPs/gUCqTKQFUO3KkNRCbmVwqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgP4fczuBLo2CI8YTwAbM3PJ6ZNFJ1Jat9p2cOz+BIw=;
 b=NWWQRz0H0KLmBDeoE5QWl7GYbPcFA+i9TuCrx0n7INWIx249wrWJyxKFQsr5FFkoYIfQqQRGEyer7DXo2VrmviM5lHMa7xWZkyd1Bt2PVo6vPRCSZ9sWkkzr1/ePRDQcerlkkLRhY6lrXij20u7NAawkhoTI8YJ59/6ksn0q24OZKL5wi4icTIlX/yBB5zJd5uFLUTfbG5MFK482b9hNcW/ys+gzJcHWRfRGhexDDS0d7c1wL2kKotuXTmyOewK3XelRFdsEVQTP/tMWFCLTGolV1cMkxXAZficiWJzwZaOUhsnaW7tfdHXe7eRh+Ub96Djhx82yOltq7ylaJUOY1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgP4fczuBLo2CI8YTwAbM3PJ6ZNFJ1Jat9p2cOz+BIw=;
 b=ll0sEb4A8dgguyT03aDyePT5JrEUq9ybTUEDCylX6Fu4OiWhgfNxXMrQQ5Nq0EygSpDV96Q53NPGYfUtnkZHL2IOOzD+F70flXqT4vQ4f1AZ3XEHOtMCUp8bAEcAB+qarWPBECz964URFdP1XjSQY4t4Se4ql3UkqsLx4PFK7AA=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7072.namprd04.prod.outlook.com (10.186.146.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Mon, 23 Dec 2019 11:35:26 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:35:26 +0000
Received: from wdc.com (106.51.20.238) by MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 23 Dec 2019 11:35:20 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v10 02/19] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
Thread-Topic: [PATCH v10 02/19] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
Thread-Index: AQHVuYUS5IbGQwTUD021jPt6po1ITw==
Date:   Mon, 23 Dec 2019 11:35:26 +0000
Message-ID: <20191223113443.68969-3-anup.patel@wdc.com>
References: <20191223113443.68969-1-anup.patel@wdc.com>
In-Reply-To: <20191223113443.68969-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f4fbf9c-8726-400c-7ca0-08d7879c348b
x-ms-traffictypediagnostic: MN2PR04MB7072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB70729864BE3D36C5B5638B548D2E0@MN2PR04MB7072.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:317;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(199004)(189003)(8886007)(478600001)(52116002)(316002)(16526019)(2906002)(8936002)(1076003)(7696005)(36756003)(66946007)(66476007)(86362001)(66446008)(26005)(64756008)(66556008)(4326008)(5660300002)(8676002)(186003)(7416002)(81156014)(2616005)(956004)(71200400001)(55016002)(44832011)(55236004)(81166006)(1006002)(54906003)(110136005)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7072;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tJ0J+AUEf/LZGYy49KY8FJPO9w4RDtllAk5F82/D0k3gAmK/0vpsfO0YsSOZqvwxLE7xyHyYdQqZcB01JmQgRpGYewY4Q3h6gS5CJa0excbBrveNukqdW1qA8mTlf1RagMO5uwjUOkHfbLpBH6COmI3AvUGPMsmHFo06wRBv4tTYMkPO/IytC8r+28xxp3WmdHTPQAbxH6819+Hpbgr4q39F3DNynWdgy+yGpnBRT0X9ENEC47XUyXZCfkMNsvpBshhxYSTUiCcmc7QFtFI2tfGZtcokM6PfPU8j1cH0DOAKjnTROALRYs8mJJtYBS+uE1RJ5QZYyBVlHfO0n6iUfMfq+UJfT73fAcnx1TE2QuySwvvwASMRdItrHevJwLDaYGgvKzT9dy+pYaqx7L/gpJ6UYjkgYf4huiPEZ322fvD5gIJFYRizLPjuAB4R/r5vkY07Ze8ZOmORkIyrjw1Dle9oMdPANNkHUdrv04lf2FX+UG44Rju05i9vCQ1wBFix
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4fbf9c-8726-400c-7ca0-08d7879c348b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:35:26.7756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1pJ57zsIVhBbfFjMONIjzF3e1VqAs0tYv4z7962gBT0nRLbQ7Nx2nVsDI+WS9D4PaTyGgtRYVv9xrl/DQRdDMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7072
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

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.=
h
index 1bb0cd04aec3..5589c012e004 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -8,6 +8,7 @@
 #ifndef _ASM_RISCV_HWCAP_H
 #define _ASM_RISCV_HWCAP_H
=20
+#include <linux/bits.h>
 #include <uapi/asm/hwcap.h>
=20
 #ifndef __ASSEMBLY__
@@ -22,6 +23,27 @@ enum {
 };
=20
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
+#define RISCV_ISA_EXT_MAX	256
+
+unsigned long riscv_isa_extension_base(const unsigned long *isa_bitmap);
+
+#define riscv_isa_extension_mask(ext) BIT_MASK(RISCV_ISA_EXT_##ext)
+
+bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int =
bit);
+#define riscv_isa_extension_available(isa_bitmap, ext)	\
+	__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_##ext)
+
 #endif
=20
 #endif /* _ASM_RISCV_HWCAP_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.=
c
index 0b40705567b7..e172a2322b34 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2017 SiFive
  */
=20
+#include <linux/bitmap.h>
 #include <linux/of.h>
 #include <asm/processor.h>
 #include <asm/hwcap.h>
@@ -13,15 +14,57 @@
 #include <asm/switch_to.h>
=20
 unsigned long elf_hwcap __read_mostly;
+
+/* Host ISA bitmap */
+static DECLARE_BITMAP(riscv_isa, RISCV_ISA_EXT_MAX) __read_mostly;
+
 #ifdef CONFIG_FPU
 bool has_fpu __read_mostly;
 #endif
=20
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
+bool __riscv_isa_extension_available(const unsigned long *isa_bitmap, int =
bit)
+{
+	const unsigned long *bmap =3D (isa_bitmap) ? isa_bitmap : riscv_isa;
+
+	if (bit >=3D RISCV_ISA_EXT_MAX)
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
 	static unsigned long isa2hwcap[256] =3D {0};
=20
 	isa2hwcap['i'] =3D isa2hwcap['I'] =3D COMPAT_HWCAP_ISA_I;
@@ -33,8 +76,11 @@ void riscv_fill_hwcap(void)
=20
 	elf_hwcap =3D 0;
=20
+	bitmap_zero(riscv_isa, RISCV_ISA_EXT_MAX);
+
 	for_each_of_cpu_node(node) {
 		unsigned long this_hwcap =3D 0;
+		unsigned long this_isa =3D 0;
=20
 		if (riscv_of_processor_hartid(node) < 0)
 			continue;
@@ -42,8 +88,24 @@ void riscv_fill_hwcap(void)
 		if (riscv_read_check_isa(node, &isa) < 0)
 			continue;
=20
-		for (i =3D 0; i < strlen(isa); ++i)
+		i =3D 0;
+		isa_len =3D strlen(isa);
+#if IS_ENABLED(CONFIG_32BIT)
+		if (!strncmp(isa, "rv32", 4))
+			i +=3D 4;
+#elif IS_ENABLED(CONFIG_64BIT)
+		if (!strncmp(isa, "rv64", 4))
+			i +=3D 4;
+#endif
+		for (; i < isa_len; ++i) {
 			this_hwcap |=3D isa2hwcap[(unsigned char)(isa[i])];
+			/*
+			 * TODO: X, Y and Z extension parsing for Host ISA
+			 * bitmap will be added in-future.
+			 */
+			if ('a' <=3D isa[i] && isa[i] < 'x')
+				this_isa |=3D (1UL << (isa[i] - 'a'));
+		}
=20
 		/*
 		 * All "okay" hart should have same isa. Set HWCAP based on
@@ -54,6 +116,11 @@ void riscv_fill_hwcap(void)
 			elf_hwcap &=3D this_hwcap;
 		else
 			elf_hwcap =3D this_hwcap;
+
+		if (riscv_isa[0])
+			riscv_isa[0] &=3D this_isa;
+		else
+			riscv_isa[0] =3D this_isa;
 	}
=20
 	/* We don't support systems with F but without D, so mask those out
@@ -63,7 +130,17 @@ void riscv_fill_hwcap(void)
 		elf_hwcap &=3D ~COMPAT_HWCAP_ISA_F;
 	}
=20
-	pr_info("elf_hwcap is 0x%lx\n", elf_hwcap);
+	memset(print_str, 0, sizeof(print_str));
+	for (i =3D 0, j =3D 0; i < BITS_PER_LONG; i++)
+		if (riscv_isa[0] & BIT_MASK(i))
+			print_str[j++] =3D (char)('a' + i);
+	pr_info("riscv: ISA extensions %s\n", print_str);
+
+	memset(print_str, 0, sizeof(print_str));
+	for (i =3D 0, j =3D 0; i < BITS_PER_LONG; i++)
+		if (elf_hwcap & BIT_MASK(i))
+			print_str[j++] =3D (char)('a' + i);
+	pr_info("riscv: ELF capabilities %s\n", print_str);
=20
 #ifdef CONFIG_FPU
 	if (elf_hwcap & (COMPAT_HWCAP_ISA_F | COMPAT_HWCAP_ISA_D))
--=20
2.17.1

