Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13B621B12D
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgGJI0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:26:30 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47933 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbgGJI03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 04:26:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594369589; x=1625905589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ojHfcW9Gih78EJlqriXyMmYTKPT1xmuoIW6UQJAU9nU=;
  b=B4G3Uox/DGYsAsduC031W1Pz0JZbLXnD0H2RdL5HNRMqgKItHd+RUOU8
   qmXwSU2wnZyMElHbo6ub70ayNK3uGxSrXMLcD14YoK8ybaVFmhKfPLnek
   1MqaOS8XbrTm2f4oSnUvqsg0S9KeJpw6V7/O8boYELro5/C1ko/nCHIMe
   rGbezWoGKqqoagfBF2AeKrFO0IP5YlX4F1llV6/jUuMqqm/AEdBRitqIH
   392xJgT8onNQ+UEixFZTZr37JEVg2DXQUql1YVz5sWiuFUlzURDT1zN1u
   qmp5b3bmg4j3Ygng0ixKtDaUpMmdkx6AEmWmyCZHfw7TsWDRemxohUBpR
   A==;
IronPort-SDR: d1hT8AHPZl85pxJf7cO1DeZ/mTF2ItLlq5DJhJXvU9yRZOYQW2MzK2AcpRtgKy9/AmyVguzlC0
 +MiW+8b4gMIVfpvt/wC4w2huNSuRzt/55VB+aEMgAUh+eJLcOewJcMr2LVgt4dczuRuGHKdmwK
 FCcOFFx9JFIzdLBtklYUboxQSvgRMC0TDmKdYZAeXPFA7WkxN+t1SNav2ujAC4HHoY5dkDSrHW
 BDnbDxE1PaMkx5BLQ/mJ4gKA1T71+AR0xQzFdLIE9kg9G6aZMKCC5d4Wc3rKwWOcBxKpDHK7fG
 v/4=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="251355477"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 16:26:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kp/JU4uIDv0LZNAoqGvMAxA6Jw2Un4RaymBfqCBvTFftgdc3B8THVQQAEJa5yqnlglq2JAA7nzy/slud7Lbismq75lisJyMi1PBEUs79gJnhAGqJhO7UvwkpqM3FQHXAAPmVJedZNQRtCE51wzIUvG8m6sdsBxdZK4wSDkm30pX5HPxIEb+1HKedDenLTioV9I017aWtRkSfcBUy9Y1SEnmO0hKd8BoTszvRg32KE/kuQQRJppw/rAqoUKllhXixp/Ndw489aWI3fsxBjzoFhaFKEVaiTHWt4YvRnFu1I3CuGxbBYZFQrxqrei54QvWO6y9SRnCosCZfM3W3PQVghA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6yCZpgrKYLXHvQFIUlHmHasOYuJslISWAqG8lfny/E=;
 b=Y0RutgLazRUEPmiO5r/AnpprnIgSHNH1CdsrrUinC/UVjaA3cf+WdGVmNW3NA38TOxAsZ7EIiI2gk+bG2NgKef/Jvxor7MERYvhclaFvwN1y6fNtOPKvz4HQBUewv7akehMd8/UTMj/GnhOObD74Sn9FDEZNQNeLoU6I/Qfqfq0fUjHXPAmviRUQ9eHdFelFc8HqAXgDa9D6WIMYBODvTeB+PzPV1T9t1A8/bED9huf1a1c7YAKRYAVMtL4MCNdd2OBKeUQqBcoeGC+vO9/AEAdu1bYUb79V4Xlgt01DW6OYMctbS/q7PmF3aYQOoxbmvX3fE2t3gsSg28tDGlFGGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6yCZpgrKYLXHvQFIUlHmHasOYuJslISWAqG8lfny/E=;
 b=B4sYlP7e0q30d3ISRX4RBdCOc+IUQtc2h+zo4vjXnV+MhxYErwegQM5lmwJ1+Gcywf0M/6a/uHL4TvW0ykd1f0/JAlD4jo+Xoq6+hDFFst5Y5vRgiLVttO2koVBzUXjKzZ+xk3Ih2wgdMaoKt/WIM0CL+5anjWJGBYLJ/E1K3g4=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0461.namprd04.prod.outlook.com (2603:10b6:3:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Fri, 10 Jul
 2020 08:26:26 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 08:26:26 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v13 01/17] RISC-V: Add hypervisor extension related CSR defines
Date:   Fri, 10 Jul 2020 13:55:32 +0530
Message-Id: <20200710082548.123180-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710082548.123180-1-anup.patel@wdc.com>
References: <20200710082548.123180-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::21) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 08:26:21 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f636482d-0b28-40ea-085e-08d824aaefb9
X-MS-TrafficTypeDiagnostic: DM5PR04MB0461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB04616C61F1EC276A950B61C48D650@DM5PR04MB0461.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:11;
X-Forefront-PRVS: 046060344D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V3JbZePIJqyMPOH/PTI0oEH2UIJCybkNUsRxY+n+KIEbkbDuNyV3Ahtt0JPSm7sFjRcHNqdsTcr8VHJVoQJIealKZBb7rXc9Dv93InHS2iYXFaf01X45PoehhG3gm/Xm285jitb6J/UJWt33zW9jw5EyeISP/NkLlAyGK/CYvTVYoX2doa6iJkNaTzPlBCdze+XNDqLiibYfwk983+u/k0/c+U9D75bMGBUPTjoY7rF1HqCdtDM+cZk5ZMTT092h2/jWKquMwX4tA7rxo6sSu9VrQjqW336pm9AoiOdjVThm6CKbSZwErlrqtq3KsHp1l7TdqUF5Mwf4XVxV4fl1xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(2906002)(316002)(83380400001)(110136005)(54906003)(7416002)(478600001)(6666004)(86362001)(8936002)(5660300002)(7696005)(4326008)(2616005)(26005)(956004)(52116002)(8886007)(8676002)(186003)(66946007)(66476007)(55016002)(36756003)(66556008)(44832011)(16526019)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9OxbczUIEUOwubo6JRAmUo7rPbAVbegbVbj22edBqDMCdst6t3XxZpoSXyLZ29etNM56G2wH6S1neZIVaktDn/46pcVmSVGX8P9jNArDPGqOFTAvs6WKQuiJcfgt4EHiRI8jGZDEbueYEGKBJ/rOeAVefRz6Ta0jf1vbUA3HKvncGkrVsx4KnI4ut8sPI3Z893DmeUlE3tNK+DlTAMSJ0yGDfTmOQjBaUXChOQmf2mNr1cDlKtGw4fGFiHMd9zeZ/x0i6+9IGNztpHM2SLnbD2ZO0J7yHEcDCZ+DzJyUogzQGXBLk0i+gI5pd8ag0wbLjZZCjTZD/TtkdkEemuLUKbxbpR1lFOukSznCGj/6mrUr6Uw2ZMbjweFwUcyBkyuOGJRl8vf1m8ll8gb2yTdVb+xf1IHIfVMowWDgVzMNq/3Ed2g3xi7KdkaP7jTxKquN7LuHw6Irt1/CDkwMzUna03HUnTm1/UJrvkcaNWKJsf4=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f636482d-0b28-40ea-085e-08d824aaefb9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 08:26:26.0834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDIYImKHMxh64XxJkDq1atJR50B1Hm7qWaI2WPZe+8f8UPBJvu8SjaFuW2Da6lvamQgCxqxJv7IUdsbyjzX0kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0461
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
 arch/riscv/include/asm/csr.h | 87 ++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index cec462e198ce..c647c581a902 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -30,6 +30,8 @@
 #define SR_XS_CLEAN	_AC(0x00010000, UL)
 #define SR_XS_DIRTY	_AC(0x00018000, UL)
 
+#define SR_MXR		_AC(0x00080000, UL)
+
 #ifndef CONFIG_64BIT
 #define SR_SD		_AC(0x80000000, UL) /* FS/XS dirty */
 #else
@@ -52,22 +54,32 @@
 
 /* Interrupt causes (minus the high bit) */
 #define IRQ_S_SOFT		1
+#define IRQ_VS_SOFT		2
 #define IRQ_M_SOFT		3
 #define IRQ_S_TIMER		5
+#define IRQ_VS_TIMER		6
 #define IRQ_M_TIMER		7
 #define IRQ_S_EXT		9
+#define IRQ_VS_EXT		10
 #define IRQ_M_EXT		11
 
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
+#define EXC_VIRTUAL_INST_FAULT	22
+#define EXC_STORE_GUEST_PAGE_FAULT	23
 
 /* PMP configuration */
 #define PMP_R			0x01
@@ -79,6 +91,56 @@
 #define PMP_A_NAPOT		0x18
 #define PMP_L			0x80
 
+/* HSTATUS flags */
+#ifdef CONFIG_64BIT
+#define HSTATUS_VSXL		_AC(0x300000000, UL)
+#define HSTATUS_VSXL_SHIFT	32
+#endif
+#define HSTATUS_VTSR		_AC(0x00400000, UL)
+#define HSTATUS_VTW		_AC(0x00200000, UL)
+#define HSTATUS_VTVM		_AC(0x00100000, UL)
+#define HSTATUS_VGEIN		_AC(0x0003f000, UL)
+#define HSTATUS_VGEIN_SHIFT	12
+#define HSTATUS_HU		_AC(0x00000200, UL)
+#define HSTATUS_SPVP		_AC(0x00000100, UL)
+#define HSTATUS_SPV		_AC(0x00000080, UL)
+#define HSTATUS_GVA		_AC(0x00000040, UL)
+#define HSTATUS_VSBE		_AC(0x00000020, UL)
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
+/* VSIP & HVIP relation */
+#define VSIP_TO_HVIP_SHIFT	(IRQ_VS_SOFT - IRQ_S_SOFT)
+#define VSIP_VALID_MASK		((_AC(1, UL) << IRQ_S_SOFT) | \
+				 (_AC(1, UL) << IRQ_S_TIMER) | \
+				 (_AC(1, UL) << IRQ_S_EXT))
+
 /* symbolic CSR names: */
 #define CSR_CYCLE		0xc00
 #define CSR_TIME		0xc01
@@ -98,6 +160,31 @@
 #define CSR_SIP			0x144
 #define CSR_SATP		0x180
 
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
+#define CSR_HCOUNTEREN		0x606
+#define CSR_HGEIE		0x607
+#define CSR_HTIMEDELTAH		0x615
+#define CSR_HTVAL		0x643
+#define CSR_HIP			0x644
+#define CSR_HVIP		0x645
+#define CSR_HTINST		0x64a
+#define CSR_HGATP		0x680
+#define CSR_HGEIP		0xe12
+
 #define CSR_MSTATUS		0x300
 #define CSR_MISA		0x301
 #define CSR_MIE			0x304
-- 
2.25.1

