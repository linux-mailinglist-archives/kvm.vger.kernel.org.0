Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08684A1BE9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 15:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfH2Nzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 09:55:45 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:35069 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbfH2Nzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 09:55:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567086944; x=1598622944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZmzTfG5qj0/ShH8NlNjNMPphgeVWAziCNJJHP4F1jcg=;
  b=S5dr06FGsfRl9NwPAOkY5Zzpp3DC8eyM0mJ4lXDTOzHlgkEwu1dXocg0
   as337eQ/VdnNahkNRSXP13Q0muMAS4xe633yJce0+g4V8gAhfNkDeuSNX
   xDv8MqhUSlPcHxdZRU06IUsMEiida89HfZCRMpNrpj7p75XoDih+Gt2aB
   KG0PWvOT3lVGG3+2qz+TaR5jcTu4O+JRLIKLXmRHGX/9KvhIW0XTSeVPM
   M7qEQiPGgVcGP+7n7yGLkByjvFdsMIBkzrEPKiqMeNV7dEYyhOlfoQ4hB
   W+Vf1DX18qrQdLZ+6kNPYyiPsp6/ZDA7wTQ2uZSjeulNwODW++YpLsHHW
   Q==;
IronPort-SDR: 1v8C42aJG1jMPzSKW+QNkBdChfT/3oTxTdJiAjQ5kjxd0VisTWq9r91wZ1qqAKtW8+dTdoiLIN
 Xnumm0L2a9NQYw82n3Fu+0g0feCkPNM0u3pnB8RSlopSSQeUIwBIzVNnSaMDYj3Gf4V9IuaEZr
 A/89gD0xWqs7ZH6gwa7qnEq51mNEtHVBlkWA5aX6bc0fTpDkFnrGSFsabq0818IP/LU218H2pU
 EnuDXn8xSpI/US9WYJX4YhoulA6fFU9UAq4ErZblTATa4ZKf/uMAGyDbXpGtv6NLGjPe/Nfciu
 B1w=
X-IronPort-AV: E=Sophos;i="5.64,443,1559491200"; 
   d="scan'208";a="116951611"
Received: from mail-by2nam05lp2057.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.57])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2019 21:55:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PB8zSrPo1rKcDZzdqGW5xyrzsx5/wB0rpD/KRKiP4Ii1iihP/22ithckl/apP+Y3VVnMiER6iKK6Wf7I7prv4bFpU78kIxxb9xjPErmqCRdZ9785HMGKbEyTGvnuHZdV3K+YjTc4jjKJ1Zu/aMBdFh4EqpmO929WAzmWOtdll1kDX8X79tP3xazcxpyoK4X2xHWHQxmx+QOWO+LW97lpDWpKsyg6vquCJojasnSoN2wQxtImByEz7Kq6ou2q7mzHJqwlN8GUvaym2TE8f2Fv+hoKdElAsxA9ItgZnYbFY6WgC4doWNYL2BTfW0BzK+nnkFy0TyieZdqizyhtbelkBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sd8iv6eUevGkw+GvTJYLdZ1DAx6Bzra73a6Mzs1JQDE=;
 b=bYlHywCB8MbwHCvG8l/Q10Hu1NZrGEXTc4Um5mjSXv7gXsoxounUUrWgodLcFiR5ldUBXi/UilAxSPuEqiM/JKwUx0rXGOsBkqp31199e0u50W0dzgEol4lOyGmdZmy+WSYYnsxTxj9YaRQ4hWFggQYCItgHgxfU7yxkSLOcBkz6h6zzuAxfmkMsxS32y+PZtmaehcCKo/yBbK19upuPkt1fmqvc5R486hckpCgWLlBSv09iYsgJXwxvg1S6j/jnajZc2hZOLhiZTDdEo5k5CnMsvIltwkln/4bFUalS+5s4XzI3tS3vzXRhYJNvBmrDOd5vHlOwJycwiay+JZq5zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sd8iv6eUevGkw+GvTJYLdZ1DAx6Bzra73a6Mzs1JQDE=;
 b=HUKBEPrspKDzmg6YnIYPu1DCjm1e7qPemTDArd4EOtRGF70FjhhGJ5vl/O7vvg5xlDIv8YZV9Ky6w3KCxQs+pkVnAxo8fM6P9c1hIbKT48bo1RKNeJr16oFCLeZaUg8IZOYW164gFrZXzLE0Ytc7BZb+xsmmoNkky2EANXgZ2R4=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5616.namprd04.prod.outlook.com (20.179.22.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 13:55:40 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.013; Thu, 29 Aug 2019
 13:55:39 +0000
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
Subject: [PATCH v6 04/21] RISC-V: Add hypervisor extension related CSR defines
Thread-Topic: [PATCH v6 04/21] RISC-V: Add hypervisor extension related CSR
 defines
Thread-Index: AQHVXnFwOzvmSEEC8kG0Ft/5U6ZZXg==
Date:   Thu, 29 Aug 2019 13:55:39 +0000
Message-ID: <20190829135427.47808-5-anup.patel@wdc.com>
References: <20190829135427.47808-1-anup.patel@wdc.com>
In-Reply-To: <20190829135427.47808-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::34) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.51.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc62598b-f4b3-4b2e-f763-08d72c88934c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5616;
x-ms-traffictypediagnostic: MN2PR04MB5616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5616A6F48618C46DC12B3C768DA20@MN2PR04MB5616.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(7416002)(52116002)(81166006)(316002)(6506007)(386003)(25786009)(7736002)(81156014)(305945005)(2906002)(36756003)(71190400001)(14454004)(99286004)(1076003)(256004)(4326008)(66946007)(76176011)(66446008)(64756008)(66556008)(66476007)(102836004)(6116002)(50226002)(55236004)(476003)(6512007)(3846002)(71200400001)(5660300002)(26005)(186003)(44832011)(86362001)(66066001)(6436002)(446003)(8936002)(6486002)(110136005)(54906003)(2616005)(486006)(53936002)(11346002)(478600001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5616;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SeX1t5OduXESZKSzD9VUPmEgCK/+YBIygqa74OEcu8sErthsPispqGLAqAcIJEuXQIvHrdymS/KN7QSw2hemy2V51MszXNGiQ4I9xnOVoOqSFgI9wVeVcdOoMckrKXDzMq33Hbj3yYp3yYvkr9rr6L0EjBQca1WWDOcZvafIkQ4LtdXXWTMpLx7Oc05NBTIa4GcL7iUxvvA4yl9VT/gB8swVnIH3X1qJNI/q5ex8m9a0eKMrXJqMO69aiB8LovECccZyLs744DLToMvdX23Qku8kWuijRzFJ9ix6b6ELwug6EknNC8a/pxRnsUHTaqNPFAhOkPSuHZ/Uvawrp8/htU3JOAvNaiqs5q53GGsl48xpGJBymbLOclf+dBR65i2FaFSsVKr1J7dcDu5MejuSAELyo5dMxr5RnO3sivOAgC4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc62598b-f4b3-4b2e-f763-08d72c88934c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 13:55:39.8031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oBZsMudk9tRULfcxvRDhEhmO6ExsD5cZnotuRvjy1Sfp6MV4NcZdsFwllluaNe1TI+/pR5uAJkg4vsFwhtX6Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5616
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

