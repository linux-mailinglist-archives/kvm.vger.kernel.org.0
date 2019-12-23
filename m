Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1669129552
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfLWLfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:35:37 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:62253 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfLWLfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577100936; x=1608636936;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FrD4amZEcFw8iaN1+0NUEcUG3ZwQyllLsByRPJMsahc=;
  b=Z5emoikFB7ykd3X9AmhD1ZTG8Gy7D4nLO6BJ7o3Dl2cNQ2+EKDaizu2t
   YCi15TkIMe0PuWKHxLFMQQToWj+ZBsTzKCQxcnxVvxuEL0jKay5wVuHoS
   BvYMPhgoqv1D1IgWBZKUl0JiBKU6zlzUbWglvFqQ3F9nyoTHLZFN18yo9
   90AxET4YG6GkUzNcaOHgA3iq5YrWn/wBBIWLARWUGjp7mTBC/dAbiwg1M
   c7LhDOx4e9TDk4JAck/XJ3vWhYYl30dlOlJvSzj600lqwrmO9k3G7Tra9
   mGVBrLdIu6FXh+UyYZTRudn1qM3yaKbjp3huOBu2MXLawmxQN/DgWVGHP
   w==;
IronPort-SDR: LeU2Bdl8S9U/NEtw4j69/IF9lBtCoqEcbNdjIyu9dl5uJuBPsKh2SJru2YIInwrXGHG4Xz0pz8
 osXsxOF5G0rjz+M+LKOjMVUlq9JtEEI97e98dqkTXjJjTZzZ0rHLMw4T6yf+WkTfso5lBTghYB
 XqvUBgecxuxz7gPqpDSmh3Hjg2BoeCcMTyUR3jziVWQQVSkUczKu/0HxNClBRv3qLeXeEexuSm
 ljpqNXuc0aLOYZH8XUNP2DYfQ2EkTVBtI6CgyhDSR8542OLKvoBoFMPk8Y96ZlSln7jFky2rfG
 zro=
X-IronPort-AV: E=Sophos;i="5.69,347,1571673600"; 
   d="scan'208";a="130393049"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2019 19:35:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSGI+AHD1BQvWyDY5IvgWOMfP0OjsiMapJsN/hF3W359IF6TmFFEjRd9jNhB4JwAfbU8bqRX0tYZCD8ENVcDmwXFceb2uZGuAXIXEaCuG0QyuexdoN7tda1cq07Cj1teu4+mLnzoEylfj1dJRIkEw+8djfBsAg8JKNoZW33CDKawnPZrrDs5fQTo2/dUTd7z0sAHvtmURT9AmsBdbfqDRsOFNh+GxUTTuu5Lr3H6HD9U7Rm7L+4EUB4kCENy3ppfk4nvfJ6SQzpNjscnn5ylsGkutS5W4sP/9v5r0us/+9+eY2/QD4ab61Hi0uvkmUCgnIfUPYuN/MUkdjsNx7O/pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2GlwM3NJCdHayRvmK7zMtQzbRG+INq/cm1F/Y7yImY=;
 b=oOaRxBmm6WQxSQxvrjE/uFbzDPrPKptN58UFgXhGcYWzzx5z4zvYm5Wd6RBTRcZ0aQZIVabONj0bagCM61HMr4sthoc4vpj4MjCZvuPFfbPSYEyyfYKIZ9CM4r0MNZnNzbApIRb33IZsuqzdrJNdYYPaY0UerSJjpYL5VIBucvqTPDMwvtZtKzYtbPsPrhi1jxPhjU2OUM4tBOAFmKRaLNLq9qj65wuv5Q8K2q951T6rmUj4AJJGFyVfR3dDUXRd4ktHCoLgdcq0RCFiDDIn3mEK7fLlDCg7XJ4hSwFH3uMfP9x/p+MJe+LBxXzbzB6ptwVkF1ciHhhqPLysTNh5Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2GlwM3NJCdHayRvmK7zMtQzbRG+INq/cm1F/Y7yImY=;
 b=i6zgYrE+TSPrh+6A5FupYEwZI8UlwQTOjJQ1M7gT+EUPtDTybuWfPhfzEHds/1ukWdzcsDlrhJV26TPo0fAzSFKKey4VHll3m9qpZldjkMhFDy0HUXyPWFljPb++uwIf1qPD8zf5kOS51iCQGU0CF0ELcSMJ3MixByRHLWvL/3c=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7072.namprd04.prod.outlook.com (10.186.146.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Mon, 23 Dec 2019 11:35:34 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:35:34 +0000
Received: from wdc.com (106.51.20.238) by MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 23 Dec 2019 11:35:28 +0000
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
Subject: [PATCH v10 03/19] RISC-V: Add hypervisor extension related CSR
 defines
Thread-Topic: [PATCH v10 03/19] RISC-V: Add hypervisor extension related CSR
 defines
Thread-Index: AQHVuYUWuAl0bGS/2kmM52YFKQM1zA==
Date:   Mon, 23 Dec 2019 11:35:33 +0000
Message-ID: <20191223113443.68969-4-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: c3458e2d-08a6-47b1-8886-08d7879c390b
x-ms-traffictypediagnostic: MN2PR04MB7072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7072AB417481514FA254CD618D2E0@MN2PR04MB7072.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(199004)(189003)(8886007)(478600001)(52116002)(316002)(16526019)(2906002)(8936002)(1076003)(7696005)(36756003)(66946007)(66476007)(86362001)(66446008)(26005)(64756008)(66556008)(4326008)(5660300002)(8676002)(186003)(7416002)(81156014)(2616005)(956004)(71200400001)(55016002)(44832011)(55236004)(81166006)(1006002)(54906003)(110136005)(6666004)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7072;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RQSMlrfW4TnClij4p6/2Hw8AYxLGNgRj+eqQoRUwzzNGGoXFINy05V5h1Kt63Nyr2rc8uQNOB4wqEl5xVFDA7/J25BdqsD6OLLgSx2oaEqX8DWMyd3pHf9B7agRpUtvw0Mgm+sL5jrhOA8+51q/TkRg/JsMqETUPE/nCLxGJnkMHfQ5hI7GhbCtF7Q7IQP2EKzdLyeQkLoojNqzvbHwe+5tsTxncBCy1xtZ6K6swg+SUbfU0giqezLIB+neheu3afj7t0NQ4DvV20XLdu1TKSNurj+YLVlPUUiddqwXod8+7Tvb5fvndErAk+qt/3FWIEwQXROC3F6FF+B8e4wFOsb67NxbJ7GIpa4vTh5H9jD6QrX/IJM3H3jKhAqEMHsm06vI188Fs6a+xW166yFROqC3uGNHzeB2e0WB/iiopyQG5XkQ4ylGT80eU44h3swDdqmQ2kSmJJ68czUQq7lgtPN8yYoh51jPAeSjdzNpy0LNxvP+heccYR9tWArUxPDQG
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3458e2d-08a6-47b1-8886-08d7879c390b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:35:34.0258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zdwyl4P5wgaqxxEdcWB+Hau9TFtIFwFiLzrN5N0NXmP6XnS2PSGzLu6G3eZ2rJuZJ3xznegNVoXkXVAb1ii/EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch extends asm/csr.h by adding RISC-V hypervisor extension
related defines.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/csr.h | 78 ++++++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 0a62d2d68455..afb6733475c2 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -30,6 +30,8 @@
 #define SR_XS_CLEAN	_AC(0x00010000, UL)
 #define SR_XS_DIRTY	_AC(0x00018000, UL)
=20
+#define SR_MXR		_AC(0x00080000, UL)
+
 #ifndef CONFIG_64BIT
 #define SR_SD		_AC(0x80000000, UL) /* FS/XS dirty */
 #else
@@ -51,26 +53,74 @@
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
=20
 /* Interrupt causes (minus the high bit) */
-#define IRQ_U_SOFT		0
 #define IRQ_S_SOFT		1
+#define IRQ_VS_SOFT		2
 #define IRQ_M_SOFT		3
-#define IRQ_U_TIMER		4
 #define IRQ_S_TIMER		5
+#define IRQ_VS_TIMER		6
 #define IRQ_M_TIMER		7
-#define IRQ_U_EXT		8
 #define IRQ_S_EXT		9
+#define IRQ_VS_EXT		10
 #define IRQ_M_EXT		11
=20
 /* Exception causes */
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
+#define EXC_INST_GUEST_PAGE_FAULT	20
+#define EXC_LOAD_GUEST_PAGE_FAULT	21
+#define EXC_STORE_GUEST_PAGE_FAULT	23
+
+/* HSTATUS flags */
+#define HSTATUS_VTSR		_AC(0x00400000, UL)
+#define HSTATUS_VTVM		_AC(0x00100000, UL)
+#define HSTATUS_SP2V		_AC(0x00000200, UL)
+#define HSTATUS_SP2P		_AC(0x00000100, UL)
+#define HSTATUS_SPV		_AC(0x00000080, UL)
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
+/* VSIP & HIP relation */
+#define VSIP_TO_HIP_SHIFT	(IRQ_VS_SOFT - IRQ_S_SOFT)
+#define VSIP_VALID_MASK		((_AC(1, UL) << IRQ_S_SOFT) | \
+				 (_AC(1, UL) << IRQ_S_TIMER) | \
+				 (_AC(1, UL) << IRQ_S_EXT))
=20
 /* symbolic CSR names: */
 #define CSR_CYCLE		0xc00
@@ -91,6 +141,28 @@
 #define CSR_SIP			0x144
 #define CSR_SATP		0x180
=20
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
+#define CSR_HIE			0x604
+#define CSR_HTIMEDELTA		0x605
+#define CSR_HTIMEDELTAH		0x615
+#define CSR_HCOUNTERNEN		0x606
+#define CSR_HTVAL		0x643
+#define CSR_HIP			0x644
+#define CSR_HTINST		0x64a
+#define CSR_HGATP		0x680
+
 #define CSR_MSTATUS		0x300
 #define CSR_MISA		0x301
 #define CSR_MIE			0x304
--=20
2.17.1

