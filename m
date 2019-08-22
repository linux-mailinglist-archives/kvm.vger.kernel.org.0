Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1643D98E0B
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 10:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732520AbfHVImt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 04:42:49 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:10665 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfHVIms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 04:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566463368; x=1597999368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gh+268eQRrXht6C2BWr7/3xmFSKe5PjeBZTxlMFqdy0=;
  b=aR1WHZsUATFAZV8Xvyn5Wl/JtZzqhA+mBbs5T5r2yykWh4zInmlrQuqp
   j0rm/2mrOJ5SEuiGJB2ilfZkvZcTIKHcj54meCuL88fAhpoU5nAGFqUFe
   XhB4TfGuD9WoigV4hNwdSeP//BUHrBp0lBtXSD80MlcXA3v7ZmzGPVW87
   UIdB90sHPV6bwVqqofUAgS5lew4HRmH++WfqUkyFYQ1Q98Qv7kazukSE4
   EZGADrBxCE4hPosPJpsD8xHDT51CvF+bGrlknFOgF7U6Bhs100ptluogB
   QigyAtCo6Dz6BG4C1qIjr96YERikkub89xrc1WBxiTkfF64ciepJAXc+e
   A==;
IronPort-SDR: WTEwKtCLtrRpFF2Mj5kNnwLySqCZtMZmkWbUo7Jqvkw0YgVZcshurYmwSPgQbDcLKijjI+Krmb
 RAo+0lg7yrGI25bJT1KXp0ZXi5sCdxqksYwzivBcfzOuBa9TlMZF+g3we1OohCjlr3a88Q93bJ
 JDnME8kwPcQIcU+zTasp2mB3DFtWGkxSXZBXBYr2dVWXHaLQvrXHb72my0lgveWAJhcTqoJ1WV
 OOWay2ZETKo14LKLcUL88/QFOj/WoVHans76Tv1gixtSR/tLg1thXj9CFxJA6bxZWWy84SzNH/
 yw4=
X-IronPort-AV: E=Sophos;i="5.64,416,1559491200"; 
   d="scan'208";a="222996883"
Received: from mail-bl2nam02lp2055.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.55])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2019 16:42:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npIkjNKzYTTnX6P5YOt1kVX1oDp/9kZ254s/7Q+jaNLW1/T5uduSrGUuwGqmWbsYoGgHHryPexrj0lz7fU50LR5RA72H4rTOHjo87UShkfzxgJ3m+KyYrrX+rcc9zagwrqyFfS+GCQtOsh9Rs27sL6jCBMBLesVYy/mxj7NNVLwzQzUqcf8Lw+LuJQtBEW5iBSRE2CO8AszmTcnb7jLt5IC2YYLzqmr1YI0GvVhsuB4o9y1hKmfjSFZI7HM7gHOVydekVlbwZEqlRYBXFcqz94nx6q9O8lvv/qocmGfPyo1q6268L3WFWJA+s/xWykbcxZm/GYN0hffmh0fhpSRN5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vv8nXZoJjS5sMpY+qxnbQkeuY2smjv4KTma2aiBeTns=;
 b=CHaTwAHpi/4ub4SeiMLlYJWGLOWodnjggqSs22EpPlIrVeJlbJ0GIhXwZnyH0ygkNboKZxmuLvi63dmjFUGTOHgBZAHkX1ySjpwKDb8ULN1DBkpoFG6q1VLPZnbfXAZll3BOFXYDn79t5rXH8zSlR8h76Gf4GqzNOHAxKnNkauZp2CCtQMW6g/mYgFawExq8N7FdcxIevP+gTtjmXU541SR83zZsTfhHq6yY1M366HVHrx9wo/i7cHiaKcAAg0/jjjYyylo0TkOETzWEHpIeB3DDQ0OIoxZ84DBy7plBms//4eJS4JzP47ok4FEErp18HHn9LswOPKhzo6dh2G0t+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vv8nXZoJjS5sMpY+qxnbQkeuY2smjv4KTma2aiBeTns=;
 b=YAosbQ0629MshDThqbXWxrlT2k028K4N7LHikA3G2KZXo+opfnbyMAD0Fxcwuvwj0L4uCrarDKVCHxpFTDzhEdDmqFMttUyuy2IZZWdY9FrcDT0F86ZuPSacqtL8yQrU+zhqgw8sI9ED6G/EyoHoFun3hm8kjGgZsclCVR1uB9U=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7070.namprd04.prod.outlook.com (10.186.146.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 08:42:45 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 08:42:45 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v5 02/20] RISC-V: Add bitmap reprensenting ISA features common
 across CPUs
Thread-Topic: [PATCH v5 02/20] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
Thread-Index: AQHVWMWR9LVkivHCeU+yKxy3T1RSlA==
Date:   Thu, 22 Aug 2019 08:42:45 +0000
Message-ID: <20190822084131.114764-3-anup.patel@wdc.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
In-Reply-To: <20190822084131.114764-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::34) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [199.255.44.175]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 182bec79-4eb2-4a50-e8f3-08d726dcb3f4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB7070;
x-ms-traffictypediagnostic: MN2PR04MB7070:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7070BBD0687DB04E6CD4AF298DA50@MN2PR04MB7070.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:274;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(86362001)(25786009)(110136005)(486006)(316002)(52116002)(446003)(54906003)(76176011)(476003)(11346002)(36756003)(14454004)(8676002)(44832011)(6506007)(81166006)(256004)(386003)(2906002)(99286004)(2616005)(66446008)(81156014)(66556008)(64756008)(66476007)(3846002)(6512007)(4326008)(1076003)(305945005)(7736002)(50226002)(66946007)(53936002)(186003)(26005)(478600001)(6436002)(102836004)(6486002)(5660300002)(71200400001)(6116002)(8936002)(66066001)(71190400001)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7070;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gcJf5wediclZELe6QR2ewD8XLWYYZyP/lhKemAYlyKGIwEHMLwiKUdrhCB2dle7v+zIopwnNjH3/xE4Vg4JjgJ+38GNjxHe1Lea9Jp5i4YoWhv5yV4j9hDkVSQ3gJ8N4Zm4VryAXaJoTTIXb7QjZdhGclAb2R5Ot+OFr48NpnBpXjVrYQ4Efk5c57W5UfxTpVxSTjXWKzslJZOqGdfkvSHGYSs4RhXr971Gi5+9UuONcMZnokGfesYB/bC3wMMgrhsVs93pxiMnZMHxpLPwPgza+tae4vl2JyYeqg1VpraP4RG/bO/yx/28s6gxteEn1dc1mAM1UsMYt8whYqLgbszs54akE268qaJ1XVlZIs28dNnWQ+sjegFcvB3/M/aDnm9rQLDTzCZ1bc0IDSiXfy8ugdwUgQbXWmOUuzLD8vgo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 182bec79-4eb2-4a50-e8f3-08d726dcb3f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 08:42:45.8052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h/ipkH0INnQT5G/iUoxeKLPv1a84qAf3p/2Ohp6r5Yyu70gcnAVLD7nA6cuQnNM5gjJYbpuJyf0Kob4VESOw9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7070
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
---
 arch/riscv/include/asm/hwcap.h | 26 +++++++++++
 arch/riscv/kernel/cpufeature.c | 79 ++++++++++++++++++++++++++++++++--
 2 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.=
h
index 7ecb7c6a57b1..9b657375aa51 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -8,6 +8,7 @@
 #ifndef __ASM_HWCAP_H
 #define __ASM_HWCAP_H
=20
+#include <linux/bits.h>
 #include <uapi/asm/hwcap.h>
=20
 #ifndef __ASSEMBLY__
@@ -22,5 +23,30 @@ enum {
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
+#define RISCV_ISA_EXT_zicsr	(('z' - 'a') + 1)
+#define RISCV_ISA_EXT_zifencei	(('z' - 'a') + 2)
+#define RISCV_ISA_EXT_zam	(('z' - 'a') + 3)
+#define RISCV_ISA_EXT_ztso	(('z' - 'a') + 4)
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
 #endif
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.=
c
index b1ade9a49347..4ce71ce5e290 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -6,21 +6,64 @@
  * Copyright (C) 2017 SiFive
  */
=20
+#include <linux/bitmap.h>
 #include <linux/of.h>
 #include <asm/processor.h>
 #include <asm/hwcap.h>
 #include <asm/smp.h>
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
+ * riscv_isa_extension_base - Get base extension word
+ *
+ * @isa_bitmap ISA bitmap to use
+ * @returns base extension word as unsigned long value
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
+ * __riscv_isa_extension_available - Check whether given extension
+ * is available or not
+ *
+ * @isa_bitmap ISA bitmap to use
+ * @bit bit position of the desired extension
+ * @returns true or false
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
+	char print_str[BITS_PER_LONG+1];
+	size_t i, j, isa_len;
 	static unsigned long isa2hwcap[256] =3D {0};
=20
 	isa2hwcap['i'] =3D isa2hwcap['I'] =3D COMPAT_HWCAP_ISA_I;
@@ -32,8 +75,11 @@ void riscv_fill_hwcap(void)
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
@@ -43,8 +89,20 @@ void riscv_fill_hwcap(void)
 			continue;
 		}
=20
-		for (i =3D 0; i < strlen(isa); ++i)
+		i =3D 0;
+		isa_len =3D strlen(isa);
+#if defined(CONFIG_32BIT)
+		if (!strncmp(isa, "rv32", 4))
+			i +=3D 4;
+#elif defined(CONFIG_64BIT)
+		if (!strncmp(isa, "rv64", 4))
+			i +=3D 4;
+#endif
+		for (; i < isa_len; ++i) {
 			this_hwcap |=3D isa2hwcap[(unsigned char)(isa[i])];
+			if ('a' <=3D isa[i] && isa[i] <=3D 'z')
+				this_isa |=3D (1UL << (isa[i] - 'a'));
+		}
=20
 		/*
 		 * All "okay" hart should have same isa. Set HWCAP based on
@@ -55,6 +113,11 @@ void riscv_fill_hwcap(void)
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
@@ -64,7 +127,17 @@ void riscv_fill_hwcap(void)
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

