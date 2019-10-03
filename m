Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02FEC9799
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 07:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfJCFGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 01:06:45 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:3936 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfJCFGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 01:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570079205; x=1601615205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+A2ZJ1+Du23SnbGIDSEykGTOoe9pFTwS8AcSw1fUgkI=;
  b=FXyVLmWny9WWsOwjHMBzWu8kdP2Z02R7NbmDIwl8+idi3SSvz5AQbIY7
   iUSCMhyXgkEokn3zYiUQDy6NREceY+2bLbhN43ebXDYHo8CKTZcYDuIHj
   FkNxHtk0Vtockwwiof5vuQ0LKOwGe0fbJszwpgeUj5LynWR+pb9iUpgFG
   bGhjgEBugPFUfKKW2YFyZWAs7jkr+MZvD6q3qhVL2itgcAYCBbozdnJ2R
   HD+LX2xxaXKclYO5pS3dQT7ULqB+kBkj/CAt7XoWmQ1bbvIG8vmngUpJV
   X2JbNnTGaqW9yuRaC1OtontZGu+N4L0NCdOBprMFe6vwPhqSBAkC0pOSh
   Q==;
IronPort-SDR: NdMo9tYXvIUOwn5GdJKOHwb/IkEbwxFCaG9hIQZqkWF3xGCuk0+LYS6zIYj20t+h82YzINjMo9
 +OVb4hEhB5LVdnDwdUsxClqw8teYPuWz/f/99YAictx42OqH8t2L8RYhx4vyslgIgny9PC05CH
 VvELTlk97o9WZdR+KsRiDyaUm0UXSzq8OHaN3gorXiRv6K+S4xq9j0Xia/O3SmozgaIpzKdxuj
 EGNNHq6i1kSGYZvPbVrTAEhKAveGgd56S62aahF4rF4UT9x81sVbdPuNzIvYQR7onsk+lgD5YJ
 gCU=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="120461283"
Received: from mail-co1nam03lp2059.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.59])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2019 13:06:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXw9EQS4+CA2cM93mraUGxxOVcpxS/UV4ROvy4vhKGm406Lg2JT0A1zXI8JpFDHhhs6mvlwp8A9E/1NCwrPomSv2r7QJqwNr3mw4ncpGOvZBwHSwAHozhvWX4CCqRW0a/1ZcNGEZwCOmQV96DF4LrtG/RDyL4QSubu9DhwOGWHFUiowI418CsdnM4awDC3mt2KJuMGVeSN6eflc+JCYHKJ71Vq3intq7e5VtD91/lpMEhlaOCFw398v4rQu5Eucsos6eoOUk+Ra/n5i63HB6Umj5paoikLd6uFehxIUkFCLN2dHT/nwxVcAVO63MF574m2/smojUet/hcow0b0hNfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ng04hoOzq57TGmSmTLrnTpV7rjJVazlrDmWeCuRHiw=;
 b=QklvUWOmKZen3q1vc7gG0b7xdLw69dpzbFE4fkiTw6Sb+DVk0MCHtHy7mv99SJBJ3neGpLvUz01HlvQsaVKtdpwQvN91w8UXZwQSa060amj8mQpAtJ1VLFujgd60psIZoYy/Q/HNG/8RRB1buBH6kKPRwQLuXY1JDfjTkUVwxw+2Sob7j7lj4P896jSUqry1qiJzCc6SW2wmyzcnKM1Sy4EWiCA1uVugLb9Aa0wno8xdd92WJfJJLY1+LU2oC7p1Y7Vzzi9MAQaFW1ZBeyQkPmDEZjNFGSPWnwnBR9tuVBjTXeTXkLfGuEtDGbygL0qgzLhRZOcTcyymP6Huoex8hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ng04hoOzq57TGmSmTLrnTpV7rjJVazlrDmWeCuRHiw=;
 b=OO2JwJgXUfvKTdxiyb7HxIS7QNjqKDx/Wj2MrQXtJBKzQf/8+0CD1sDN9yMsJFXn/qiumGOr+DQ/QEMbhI7HT8mysilxin5o6jUQ2ZYCoWOHkGKpIUfMBGmjk5fHvvsnV4lSeViHAT31UWYs3m6FLNkNVEUF/IHepbUtv5bZom0=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Thu, 3 Oct 2019 05:06:37 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 05:06:37 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v8 01/19] RISC-V: Add bitmap reprensenting ISA features common
 across CPUs
Thread-Topic: [PATCH v8 01/19] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
Thread-Index: AQHVeahV15EOT3PPQ0aY9a6zOfeW3g==
Date:   Thu, 3 Oct 2019 05:06:37 +0000
Message-ID: <20191003050558.9031-2-anup.patel@wdc.com>
References: <20191003050558.9031-1-anup.patel@wdc.com>
In-Reply-To: <20191003050558.9031-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [111.235.74.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c53c98c7-807a-4444-1645-08d747bf77ca
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6991C30CDF392F653DDBC81F8D9F0@MN2PR04MB6991.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:317;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(189003)(199004)(7416002)(52116002)(25786009)(102836004)(76176011)(54906003)(6506007)(1076003)(386003)(7736002)(44832011)(6436002)(486006)(66066001)(71190400001)(71200400001)(11346002)(446003)(6116002)(3846002)(476003)(2616005)(26005)(305945005)(6512007)(36756003)(186003)(14454004)(110136005)(5660300002)(6486002)(66446008)(66476007)(8936002)(66556008)(256004)(64756008)(66946007)(86362001)(8676002)(81156014)(81166006)(99286004)(316002)(4326008)(2906002)(478600001)(50226002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6991;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 47rSjwKH9seA2/WYOnTe9bSYjQc85Q/ZbCi35nyYr1XKnrd385UtwTTD7L3PcRJTtAdlFRZ80Jr8dZMznBwD2F67quyYfqIXvXLaqjL1yaFXQ8fBB6iNRrN7iRVzMnEoAvcJHwZUoOcfShOEI8dN9KMJVF6GSTEAWW5jigOqDSRpKrvjKix2wvZcwtuT3tyiKsrdRtpc1wWaF/qKiA2c3Nh3rK4Rz9EHYmWe836MRHJylRTEefWDWq/Dj8is7zza6ms2/L5lycWTk8+R0j8ETG4GQ3gVEsc93xbaldolQmAvmEIqm9UX7hN5G7oqJaD8FOZ40dv2z4fnmmRL0RF2joIC3W1YVIfLnuRiPQdqLvdYF0DTX6zkmxSFJWF6wShLFZ36h4JayxBeCKg6XUs7tQ/iAWvnLKVN3mLuHxMVWHM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c53c98c7-807a-4444-1645-08d747bf77ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 05:06:37.4060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npHe2RquDDEhjV4eYQXEvIbzFmemdbA2lw6GCf9TvegjqQfCPSYe5gP9askCkZoKterommmSdWHlIm41Sim6zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6991
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
index 7ecb7c6a57b1..5989dd4426d1 100644
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
@@ -22,5 +23,26 @@ enum {
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
 #endif
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.=
c
index b1ade9a49347..941aeb33f85b 100644
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
@@ -43,8 +89,24 @@ void riscv_fill_hwcap(void)
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
@@ -55,6 +117,11 @@ void riscv_fill_hwcap(void)
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
@@ -64,7 +131,17 @@ void riscv_fill_hwcap(void)
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

