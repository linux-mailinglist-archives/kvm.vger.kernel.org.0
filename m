Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E8584B64
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 14:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbfHGM2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 08:28:14 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37725 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfHGM2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 08:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565180893; x=1596716893;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gh+268eQRrXht6C2BWr7/3xmFSKe5PjeBZTxlMFqdy0=;
  b=L5ziGQm8NeB7w7R9YwBftd/TaR5JSvC335m/XPwcS52XX+ZPwvtVLCD+
   mpwkazG8nc6Cre2bQwFEoMBw6JdjgmUFTGFJv1iZA30JeP0Rcq6PMh/ar
   Pad0isYyfJvZIMS7uM3pHvkfwobcCMOUIFJzKMqjgje84AzFxD2Q1kNOd
   3zwz5XuWwPW/cO9RyKZ3YI+/NHwWsY1AkaTWjvCHhDSmmMfo5j2Y0byly
   bfXhSG0iRuxjviOkSZQwNkEHU2jeoxYh0NE+9CQpoR3maiv+w5kZI7L7O
   X6Viz4/HIBhjAKlIf/iwQMsN3Q+mnQ06N4gZYen4kL5nh85RjcV4lVJDj
   w==;
IronPort-SDR: NYEg1ZZ7isxcmyEnIoiJ122c6mVj6QQ5H69UV0XDSzMvNkkLNmfDFOQQlO2Ivc8yqeGs4SDr3m
 gjviZI0yD0IWxAf+y8mhrsEOFjksu/UYU1BLIlAzedolyHjumYGyyLKnhEvh3dI+KV+8xAe2nB
 1hrLFWj9UnLccCg6P0adfa6ft4t2N0f13UVtVqDt0KytR2IqEiHdBQEaIBT/pXWM7ozVpebpnr
 JZT3h9Fx7CIxwJCAwsIuzhPS0xpzpxUkcJSxxSxOalTFowL3brvjWD9GPiRHgp9Y30P/JqJBgO
 WEY=
X-IronPort-AV: E=Sophos;i="5.64,357,1559491200"; 
   d="scan'208";a="119865512"
Received: from mail-co1nam05lp2050.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.50])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2019 20:28:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atVotWRQ3/eunulHlO/+S041e2DzskGAenkhqu0KhZySZKnXzKIb0rOOVjmi4sroPAqqlVnjKQpgol6t81fzlib3ZuGPYRUUwZ++CddJXBZmOFfW2gI9nUwNoWyd08ewG8jiHT/nMlcL+ubGpXaY7vi/gqD+Ig5v8jAQCQI82vcY8ONp0IJHbUvahgOJmRW9D6VtpkTltLwoZJQl9+IGpCJ87wryO07QEmZtd8wGMNwO6WSB6HFy6ZRidYPE/ZyQl1RSxAES/xja868LIkdojq4CfvkZT2cLpA1Ozem80yzsiv+UGItOsFJEbitP/9G9mHILeloKQJv0zICHsiyiPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vv8nXZoJjS5sMpY+qxnbQkeuY2smjv4KTma2aiBeTns=;
 b=icwHPtqkBP8IEeg2MoLmDy81YC1lGTIPt8/uGr7PL5tWSKnYE4/i1DCdLigmvIUUuDjSHprBqKFeCwRRxdOIr7A65QIrGJk3OlRnLg4HcF838lYT4AhVWtqXeAXY9hpTZgSyoz9QrnTNAMeQZfDi81w4SCdeDkodnIxiPUZ1A+nTPZHjrC8rrXkhEads4P1qnvGV8aEzQZ55mBcgj156hjESMcrZpLUzF/vwTpb+a3rFjKx8Kjgwo3FKh177U1Enfj/9Ji2Mpa64hxkqZhe6aOzPOmJpQsBAgdzuIS3JEAmET5YHimNX8KvdrDupKTxG2QyZHL70/V9SsVXU2vTLGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vv8nXZoJjS5sMpY+qxnbQkeuY2smjv4KTma2aiBeTns=;
 b=sAuLTmUa+4d6xRZgzCC0NIjjWeiJ28slGmmzea3l91dERIMFNy1L4JY6YimhPJ1TwmZoZQ5Ki4XUJ3kRsUrK5BZZREZFOT9DWCp0cnthvkaX/JRZg/JAji/pIRCG3DlYCxcI0N0Hfae1UDHftK1FKh9upTsYdzkM/W0OEQeKqkc=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6736.namprd04.prod.outlook.com (10.141.117.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Wed, 7 Aug 2019 12:28:09 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2157.015; Wed, 7 Aug 2019
 12:28:09 +0000
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
Subject: [PATCH v4 02/20] RISC-V: Add bitmap reprensenting ISA features common
 across CPUs
Thread-Topic: [PATCH v4 02/20] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
Thread-Index: AQHVTRuSGkwhbEMmPECxVe/X4X9Haw==
Date:   Wed, 7 Aug 2019 12:28:08 +0000
Message-ID: <20190807122726.81544-3-anup.patel@wdc.com>
References: <20190807122726.81544-1-anup.patel@wdc.com>
In-Reply-To: <20190807122726.81544-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0097.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::13)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.52.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d951dac-5a1d-4371-3f8c-08d71b32b481
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6736;
x-ms-traffictypediagnostic: MN2PR04MB6736:
x-microsoft-antispam-prvs: <MN2PR04MB6736011F370F1797671232C68DD40@MN2PR04MB6736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:274;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(199004)(189003)(386003)(1076003)(3846002)(446003)(86362001)(186003)(26005)(11346002)(76176011)(52116002)(36756003)(54906003)(6506007)(102836004)(55236004)(2616005)(478600001)(44832011)(66066001)(110136005)(7416002)(476003)(486006)(8676002)(6436002)(6486002)(6512007)(4326008)(81166006)(81156014)(316002)(66476007)(66556008)(305945005)(68736007)(2906002)(53936002)(25786009)(256004)(5660300002)(14454004)(50226002)(7736002)(71190400001)(99286004)(66446008)(6116002)(64756008)(8936002)(71200400001)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6736;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7JLRp7NFhcQLAnDX6uOFsI0AjxUxce/zBkh7b1M7lhmHNX8OSOrdLjiwh2QnFFmjcgn30WzTdVVyyPQy5NXyxQUBDFlcRuizXB93R1PcKbuzSBUwqVyh2fcUxKTZkTXe9hmtuw6AV26GLEuAHvYtmqJrP2xDc5Br69QHNBUQNEi7sdCXKomKjiWGOS9vznYR2W6/8/eTkr1E0uymCe4pmcZsYdWHA+C+TtDn7jfrXPdPJ/4abAXhAsyQuhjvNPptLbbnksfvFLN1n98GvEMc820jsGB/y7nArxZHv/fyKHcFW8y1yARkzTDS4G+gWtwuRiOYdCywS+lFcBQzJcQ9cxq/GsJn1snhofjk25Wvdx7BtP8UQJ2cnTPAnO9YXHMgUXuLCgyZ4r/EuSUnB1mHfo1ET+BJPx1ZhciIxxX5cLY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d951dac-5a1d-4371-3f8c-08d71b32b481
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 12:28:09.0576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7v6+5LNmDPWRTB+exerQ3kp938W+I1lCEeyHenGiaxu9Pm0IcI0r4+erEXXDjSngnmRNGU2npNOcdOrNue0N1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6736
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

