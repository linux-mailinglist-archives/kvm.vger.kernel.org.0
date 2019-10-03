Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB7FC979A
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 07:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfJCFGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 01:06:48 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19358 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfJCFGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 01:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570079207; x=1601615207;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZmzTfG5qj0/ShH8NlNjNMPphgeVWAziCNJJHP4F1jcg=;
  b=iEIaZ9yLMQmy2M3AvD2H9vqCCpwXfakdcHS3zowJMc91d4ywY78Qcqzb
   g6rpFCrgVt65wk8K+cVP6mVuUhJRSaRIWK3LQqf/ZbsJPhA+iffmS/3gH
   lkQtdhVuNXvBtUq7jh0Ffx081/wYXNRvLROZxEq8xGSBJfhv1N857e52U
   GzdFU3AXIIBwPu/A7Oe6ps+OUMzJjTbUeF0/elcLmxj7XVJvjIf3p2UC0
   0F78LfzppTfkcff3pKPbwKZ+X0JhAemrO7yZjVjMR+K0eQPa7lvebc978
   VxV8+Ua5FnQGxa90x+0dflCU3/R1IiMsSHg52rJCoBmeX/n1y1mJ0avpJ
   Q==;
IronPort-SDR: VWs5s1WIBcnbAUE9UimAgCTRBiZ5dgoZqOsC4p/UtXI8PdRy/+ywEo5cuFhbklEQgfM+bo6Kkl
 hTZyh80xWuSe95Iq5LUfZzIRIPS3h86V2Ji0gcbTgG6gmhECe7Z+wX0mFUDEjOqS9fcM+JlTlH
 c+Sk6FegnCwxXM94nyIqMgVcBuMkwUhaoFvCCZKWR255jwed7T5RerrQ0n7b0wHTC4088++MuR
 sgw6ptk8ruvCaUpWTbZwrc1UinTwsOTKJH0QCP+eLhh1cb+MM1JVrVAW4iMvyat2qEuIYNS4py
 WYU=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="226621541"
Received: from mail-co1nam03lp2055.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.55])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2019 13:06:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMmfYskzTtIgiwPIM5gPhUZCh5ekM8kZ6NC97H5mY44D2wdArodDTfkoZaMWU6r+2ujlFJszlOjcEICaCak9bZPDkRHFz/CRXd2k+dYkwMA+3aHN/KUbPZBMuoWYt4MT37PzcgKmFeapRy81s9xR4vXuVq+M/RTEKFDxxATZwsCWZiJlsS4ojxgCNH4T6cvRYA8X+hUF33ZFtRyUXfOz6/w6afH7FIMeeIvJNgU9bVqSvvSPCXCoI34uADNoxbsf4ZHnxsHiCjcXkyK9ZbLnHN4Q60qnoXdaMmBHLR8zz4Gl2Ak6yxIf5Wggg28uJM7WkxwPZh7kKL5JpvOM4mST0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sd8iv6eUevGkw+GvTJYLdZ1DAx6Bzra73a6Mzs1JQDE=;
 b=A0S/yYz7520Iqcjh33FyL6ThNaxhb8UNX5VNlAQhyh6QT7qfxbq35H1NBFZ2Kn4brLWoZbQ8glkg28nIq2kGpAJ/24NR7ISk1/OIh5xzXNEJld8tn6KbpJFNEpVY7reW1+FMQk4dlNU5DnZLGIsxh1wA8eIqdZdLiMrK5IgADdI1wSF+MO27VkwtyMtaONy+uKSgBdq35/TOvwqxmnXqp6y6zo9ALShR9q++bnenI5mvP+tDnXV+OtClCA7qwJ5x26DPn5OuyAJVjOdJYXBArGpkiC7xUJndOw6U2tSMQ82PUmnk8rbODST4QZPHKYl40jFgHknlNazNsedZqViCwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sd8iv6eUevGkw+GvTJYLdZ1DAx6Bzra73a6Mzs1JQDE=;
 b=gC9eXgHH2g6RlDLJwd6iLdsniXrJKCsJMAqoMZs70dv5fZj9RKKcqyUNz4hgk2jD+leLM1i4phB6E/tYolVa8AYPqwQyRH/T026+n2gwgbM9/ZAj4IYnBal46Jg7ObQ8NgOB4C82tOcmO5zexM6PGlfdGrIXLt8rss0ls05mFjg=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Thu, 3 Oct 2019 05:06:44 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 05:06:44 +0000
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
Subject: [PATCH v8 02/19] RISC-V: Add hypervisor extension related CSR defines
Thread-Topic: [PATCH v8 02/19] RISC-V: Add hypervisor extension related CSR
 defines
Thread-Index: AQHVeahZFXaJUz1wFE6Q5kz/rSOTjw==
Date:   Thu, 3 Oct 2019 05:06:44 +0000
Message-ID: <20191003050558.9031-3-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: cd6c0d28-2bcb-4d2d-1797-08d747bf7c1d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB69913F18C17C5E44FEBD61328D9F0@MN2PR04MB6991.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(189003)(199004)(7416002)(52116002)(25786009)(102836004)(76176011)(54906003)(6506007)(1076003)(386003)(7736002)(44832011)(6436002)(486006)(66066001)(71190400001)(71200400001)(11346002)(446003)(6116002)(3846002)(476003)(2616005)(26005)(305945005)(6512007)(36756003)(186003)(14454004)(110136005)(5660300002)(6486002)(66446008)(66476007)(8936002)(66556008)(256004)(64756008)(66946007)(86362001)(8676002)(81156014)(81166006)(99286004)(316002)(4326008)(2906002)(478600001)(50226002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6991;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1yP2or5FIqIMN5EEhO54HOca2pS0YTMRlcKHuezojpV8okmWF3/LQZhbcpQBxKiv9nt5Yhked8t1QfX/PlYn+ug0aKa0i6Xw5RoNLh5cxAr7Ul7VkMR6dFUOsgyt2q/pmH9tcw4N4mcC7CnqfXHXtyjOPWeS+8kc325XA5q6CthL+5omGz7QNM0HWm+B8AbYPjyPN29EnXyE7C+ZDxCVjb+bjWVQnItlYWMupWDqg3gzYuCTKG3VoL1jat1cHoIJfIetwWuik6xxzYu4CvbS5Y01lRVIoWFWXXW+QgdamYMP5z/Mt1W8Yn1f109HsIRp6laMFOYBotv7bdWQ1QarOMVOikaEypo80HLVjQy4t4sQ795jna3j2Qtvnao/5ko3PziwnqqMJj8kZxxHoZ83N1KE8XWzG9c+gwUHzPCFgIA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd6c0d28-2bcb-4d2d-1797-08d747bf7c1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 05:06:44.6339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vnn23MGWRZbJivuYQZx66taWAVwnwMLoMT9RSil+srQCJG0ja6g9wYPkQC1uj+VDVtAVw1CJkz+iXzwJF3/CKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6991
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

