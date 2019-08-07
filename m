Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C036A84B6A
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 14:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387830AbfHGM2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 08:28:24 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37725 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387813AbfHGM2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 08:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565180903; x=1596716903;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E1j6Pb427CcQeVW7c3luwWNPehcIlXqi1Wpyb7HstMI=;
  b=BHrVK7LPXbB5A75QhoKIZ23d4whgjFw2CVHe43H1WbaPD+ez0QMvzdYB
   /XX2jK8OSM7ZAJGMgysYlD0hOXqr4C/9aCd18QlzhBmZe4UCmrReANhHm
   ui9bC99IPPaScItTP6I9z4/SQBN9VjFdxuu8Npxwmctqhf4Imk6+vsFWx
   mnkw9uXkZULdiA3GSTIaIrZlpR06mYECLGVRny9Fp+DSlX2AHn2za5p5P
   MeAMa+vILejVK0OsgBe0Ku//wEniFv9M3L1h1UpZBHB2+7wIt1Hiaa5zJ
   fUmVnUfjJWbO+dthWsiTj+TBdOiFW/nKBDg3w5ke0o8nNrJYFglMdyZhl
   w==;
IronPort-SDR: WWvv7Iva97vHZ1jt6FUWg2Y+95DsqFWLrxeyQ5YfHPhx1QgcP8KPB1G57gP9GvypNf6I5moock
 s9qqk9D4XRbdXZdWuioQ1mciJJOozL5tjhbGBdHgjvVp23jAjPGkNis8/uIlYiKZgVEu22seNx
 aX38T197jBgTOLQlKWG2QomCKoii7zEBYpERfElaQ4buVfZJj8hBU9Jaba/No1GteBjjwgzVwj
 +u5vqDSu2cd8D17LaMY8riswGP78Kj6LYe6QS/1D1a9nS12ufKdXaW8etzfavn2GjBjxjw4ae+
 8Fg=
X-IronPort-AV: E=Sophos;i="5.64,357,1559491200"; 
   d="scan'208";a="119865523"
Received: from mail-co1nam05lp2055.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.55])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2019 20:28:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnbIPM0AkxJG3v81x2/JOCd92xnVmSbdPU2o4SlxxnDRMDJkyYnHtGl9O1SP9wMYXvv2AOZMBsHXi4IKF2gydbPPPHEPbGVZHR8yNH38Rqj5zniJGtAWJQ/aWBjKYDZEcF5Q5SnLtpqdc02wfiTzvudhTL6IHhr2xYYxrjWc4gkxY70K1PnDoZmTQ5HK/Cg8W5JNs8UAr7sX1d3qg39IrV2cHPxyccCJS6U+JIv3A+qrvdypXtZD30UYVd4zNNLq49oNhPgs9GUBWH2jV1WbFFZTWjfU7gPG2DnVgQ7DpIupdwdHJe7p82e/45PW2Jhzs5c3tsrYwBS7EVi88afAEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caRpajzSVpBPjhqMi2IoMp9REmOb3dOIVMidSRAcrxg=;
 b=Udq5MdF7mjOFsZsPSOtFNMmlulqNgr6fRVG9bSEKVV+sZkn2RfwoC/rklx2MI5EaZQWeE6oIr0tHPSEPV+DLJpzvhOPV3mvzTWHwPTMDN9qwkHHVNgZS+yrXMmVGa/oxnQhZanx9TaZjbFlpY7z1yVP/MwE2wQfyO+hwujgb3cx1EvaYffXmGskwREUDWDyF5wlFPyZGZWhQNGZFVjYdt6YU3PFbW+46Ub+MsJebRfjKK0uBlrlf1nziP98okWujgM7FVlSgKd1eEe70k7uiSSR/a6c0mrlt10LHpCfJg3rOEeWQoR03w8ONFvNQSPGeimgIfFDMh4qroZo9/j4u0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caRpajzSVpBPjhqMi2IoMp9REmOb3dOIVMidSRAcrxg=;
 b=JCRtKqpTMw1/44dhLvCDMoAaqn23uYTZdnQS5GzE9acq7KsD09r66sq9x+it5dUXp8ISb7II3ZHlbEj0fcZ7pv4cLydVVfWHZDMg+kUy5+awzt9xC9lAOfeSalIjFcBEK8S4D1qRqXSnofUA/ISQss9QI3K/C36yobP+3ZvJn/A=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6736.namprd04.prod.outlook.com (10.141.117.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Wed, 7 Aug 2019 12:28:20 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2157.015; Wed, 7 Aug 2019
 12:28:20 +0000
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
Subject: [PATCH v4 04/20] RISC-V: Add hypervisor extension related CSR defines
Thread-Topic: [PATCH v4 04/20] RISC-V: Add hypervisor extension related CSR
 defines
Thread-Index: AQHVTRuZzXtsydI2FUS79AT6fSEFmA==
Date:   Wed, 7 Aug 2019 12:28:20 +0000
Message-ID: <20190807122726.81544-5-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 1aa914fe-f1d9-4b48-094b-08d71b32bb72
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6736;
x-ms-traffictypediagnostic: MN2PR04MB6736:
x-microsoft-antispam-prvs: <MN2PR04MB67364F1AB084B5947F2801938DD40@MN2PR04MB6736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(199004)(189003)(386003)(1076003)(3846002)(446003)(86362001)(186003)(26005)(11346002)(76176011)(52116002)(36756003)(54906003)(6506007)(102836004)(55236004)(2616005)(478600001)(44832011)(66066001)(110136005)(7416002)(476003)(486006)(8676002)(6436002)(6486002)(6512007)(4326008)(81166006)(81156014)(316002)(66476007)(66556008)(305945005)(68736007)(2906002)(53936002)(25786009)(256004)(5660300002)(14454004)(50226002)(7736002)(71190400001)(99286004)(66446008)(6116002)(64756008)(8936002)(71200400001)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6736;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5vg7S1KGyeLsUKTEXPvzBgkGPOJxmTNMKBgTs3Im5Hsyp/Le8WuxtE/VjPMX+FZjBbxXuHrRBBHcth1nHlJ/z0sCDCb2sjIVc4/g74UyTWBN7qSqQLXB4RFIdMcn045kS4WFDe1LwjpwySua49A4JCMfTjNfN6i1L4cI7seagazwS8KCLPD6Ea48jrFKKwXpp2+gMKtByBAPnomtgLKjvm26mWV8nrlEhIi4pFEN3aXIlVCJmLEtERv1PSTSKvkceFKMzIrLDAS0V7hS74bhK610mYh1T2XLLuFCJWll8MvRoAZ2LhmGFChodJYw+xQrQE+1EaS9JFf/fqb2SYauEhz84z5ZuG7kzFKByG60dhgqq17LB8xT2ALs62KBB/AWCZ/vqVKWsU4WXpHnqebdZQVvFMn2MKk/4q5kf5KBBJs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa914fe-f1d9-4b48-094b-08d71b32bb72
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 12:28:20.5900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pVsR7AuqWXxRKt87Bev6eX/jgWo9OinTgF/nERW/vgs2chggLb7tCr6Q6OnSBdo0vbeznQrkY50BjgagTgS9Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6736
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch extends asm/csr.h by adding RISC-V hypervisor extension
related defines.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/csr.h | 58 ++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index a18923fa23c8..059c5cb22aaf 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -27,6 +27,8 @@
 #define SR_XS_CLEAN	_AC(0x00010000, UL)
 #define SR_XS_DIRTY	_AC(0x00018000, UL)
=20
+#define SR_MXR		_AC(0x00080000, UL)
+
 #ifndef CONFIG_64BIT
 #define SR_SD		_AC(0x80000000, UL) /* FS/XS dirty */
 #else
@@ -59,10 +61,13 @@
=20
 #define EXC_INST_MISALIGNED	0
 #define EXC_INST_ACCESS		1
+#define EXC_INST_ILLEGAL	2
 #define EXC_BREAKPOINT		3
 #define EXC_LOAD_ACCESS		5
 #define EXC_STORE_ACCESS	7
 #define EXC_SYSCALL		8
+#define EXC_HYPERVISOR_SYSCALL	9
+#define EXC_SUPERVISOR_SYSCALL	10
 #define EXC_INST_PAGE_FAULT	12
 #define EXC_LOAD_PAGE_FAULT	13
 #define EXC_STORE_PAGE_FAULT	15
@@ -72,6 +77,43 @@
 #define SIE_STIE		(_AC(0x1, UL) << IRQ_S_TIMER)
 #define SIE_SEIE		(_AC(0x1, UL) << IRQ_S_EXT)
=20
+/* HSTATUS flags */
+#define HSTATUS_VTSR		_AC(0x00400000, UL)
+#define HSTATUS_VTVM		_AC(0x00100000, UL)
+#define HSTATUS_SP2V		_AC(0x00000200, UL)
+#define HSTATUS_SP2P		_AC(0x00000100, UL)
+#define HSTATUS_SPV		_AC(0x00000080, UL)
+#define HSTATUS_STL		_AC(0x00000040, UL)
+#define HSTATUS_SPRV		_AC(0x00000001, UL)
+
+/* HGATP flags */
+#define HGATP_MODE_OFF		_AC(0, UL)
+#define HGATP_MODE_SV32X4	_AC(1, UL)
+#define HGATP_MODE_SV39X4	_AC(8, UL)
+#define HGATP_MODE_SV48X4	_AC(9, UL)
+
+#define HGATP32_MODE_SHIFT	31
+#define HGATP32_VMID_SHIFT	22
+#define HGATP32_VMID_MASK	_AC(0x1FC00000, UL)
+#define HGATP32_PPN		_AC(0x003FFFFF, UL)
+
+#define HGATP64_MODE_SHIFT	60
+#define HGATP64_VMID_SHIFT	44
+#define HGATP64_VMID_MASK	_AC(0x03FFF00000000000, UL)
+#define HGATP64_PPN		_AC(0x00000FFFFFFFFFFF, UL)
+
+#ifdef CONFIG_64BIT
+#define HGATP_PPN		HGATP64_PPN
+#define HGATP_VMID_SHIFT	HGATP64_VMID_SHIFT
+#define HGATP_VMID_MASK		HGATP64_VMID_MASK
+#define HGATP_MODE		(HGATP_MODE_SV39X4 << HGATP64_MODE_SHIFT)
+#else
+#define HGATP_PPN		HGATP32_PPN
+#define HGATP_VMID_SHIFT	HGATP32_VMID_SHIFT
+#define HGATP_VMID_MASK		HGATP32_VMID_MASK
+#define HGATP_MODE		(HGATP_MODE_SV32X4 << HGATP32_MODE_SHIFT)
+#endif
+
 #define CSR_CYCLE		0xc00
 #define CSR_TIME		0xc01
 #define CSR_INSTRET		0xc02
@@ -85,6 +127,22 @@
 #define CSR_STVAL		0x143
 #define CSR_SIP			0x144
 #define CSR_SATP		0x180
+
+#define CSR_VSSTATUS		0x200
+#define CSR_VSIE		0x204
+#define CSR_VSTVEC		0x205
+#define CSR_VSSCRATCH		0x240
+#define CSR_VSEPC		0x241
+#define CSR_VSCAUSE		0x242
+#define CSR_VSTVAL		0x243
+#define CSR_VSIP		0x244
+#define CSR_VSATP		0x280
+
+#define CSR_HSTATUS		0x600
+#define CSR_HEDELEG		0x602
+#define CSR_HIDELEG		0x603
+#define CSR_HGATP		0x680
+
 #define CSR_CYCLEH		0xc80
 #define CSR_TIMEH		0xc81
 #define CSR_INSTRETH		0xc82
--=20
2.17.1

