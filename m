Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E6F3D6E51
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhG0FzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:55:25 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33012 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbhG0FzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:55:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365322; x=1658901322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=aOcYxu+Msx9m+l81J4mC4xbxYGAdCONZvAoGF5T7Wkc=;
  b=nFE/gsAvfQcOSz4cK2KvO4ik4Xm1JamWF8mamwhC5gnT/hOIP2pmz58V
   JKnpXRZ2YSZvem5S0qaqJZ+8tIepQgUGqbY8BVNYtfbG+06bZDMN08m9t
   LXA0k0NI7qrmUAKmcqN3+/cbZ4/F4Tnhk4aqs6w3rPE9B+8JNpQejd2DL
   uEZyjR4TWAH4b6sRuNiR48kLlJfw4qapwVvoNdvy4RK6zNDXF1gABjsjV
   uhKKc8g2dxe66Lmagq+08KlorV+cjU93do9fZOOOnYJq4v8R0jiCpAsxI
   ZC0EeeCsgznM6LMyvb6KIL8PPKKmkXWLWke0uVyYc6rdxXbI9K2vWQKr/
   A==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="180385853"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:55:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOLBg02QBZx7CKfZpO5/Jv7jslcUW43yO78Xt3Gqb9KwVsHKtz+o6bNFOOmL9h4V9Kn94iCr6L0QHnrBxhG6ee0RPgABggewQZTvNpzF/XC0LIUB2ZYn2qSh1+4HHdQBTSaYGzW2hwUvxozFL0YYSRYn2Z6qcv12IyKdEecr7rdVjLR8KfZXD873xRFP+/OUbQHpw2qkrlTtTzZd1CaJU3Z3/qG5FwtURWDYkAVKmMRZzkRg5Z3KTOBv2Mu95P8guCSAPSRA3VY2x9CN261dvb/JEAgh00rGNToTXQbLAIe+jy9uct6qY62nObfZ0h0s4y6phxkALGIyX3G5IOGH2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hm11dnMYKBuR0sDHfdIUdsNZir8WEhAf3DB8AptOzp4=;
 b=UfYJpH4KQdsBWVojurX0j4uM4OfvLA8+QtTVX6GquY1d8MaaVDipqO7itSQsefC7y9Bo3lEu65mPU9wif+SI6PWNvSosoxvEJ+lmppQF3XUxE8tHMAJrnoDJ2Vy0ARCttDh771twIBsYfb1ynnWne1AkUbx1E4cTfvjMVsvsOnrAaeM0tzC497yxbF7z3UsUifmHkzxX+miNjv8W14Khx36GNceoGXTKyQk5+7aglyeTlKce9RHlYaA1OZvmBhy6OspUq+/TaeySZmjKgB0pNF1godGTvmlg/EqHCHNg3LHBRqHZYGsqdGoDvAnLcMZU34aa5QTfY4g6J+oFmvrxKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hm11dnMYKBuR0sDHfdIUdsNZir8WEhAf3DB8AptOzp4=;
 b=Hwu9zwz0PQccTLJ7hTfjZOn2SxBgS1cu0Afl+azCTeRqoIviq1iNpaZrmUjQ+ROchEeA3lphWOrAWoaorwG5sZfpyj64GwnByXUOZVgfL3AOs7+5mYVxsf1jM9wphnZl058g7ZCEw7IYRowW9Rj1zPs/xQ+mFNlXMfV29KJDiEA=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 05:55:21 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:55:21 +0000
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
Subject: [PATCH v19 01/17] RISC-V: Add hypervisor extension related CSR defines
Date:   Tue, 27 Jul 2021 11:24:34 +0530
Message-Id: <20210727055450.2742868-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727055450.2742868-1-anup.patel@wdc.com>
References: <20210727055450.2742868-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::16) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 05:55:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f06ac9f4-d83d-4b49-797b-08d950c31ea7
X-MS-TrafficTypeDiagnostic: CO6PR04MB8377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB8377340DA0DB13634C82320E8DE99@CO6PR04MB8377.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EbhGrBfXwXK53xl29XFvm2M/44KX8xEa6Fi8XhEoGzpkpsLUYyQ+Wmj+XsFJ2XiBYo72zV+8MZRfEuRmnaSPvmoXPWPvejimuoI6DhLF5TP4vmZaV07IWCDicxrP5rgPJdAHH4fU13CruXq7Bi+/bOqxdE4nhqTezdw0vy+vgo6/7eQ/uqfHL9xYfVAMv990lC8/UMnpup1SG5YIEqSQNE/OxGdnQ9GnXFyLbjbreP9rBqhef+TrWep1FNzXtQpD7pG/AN7H3YOXGfRmch/BN3f3zbItyPFGXzvlIIjWOWADDELW8ZSzfUh/TaQXZmc5uXKKjM45DNaMQMdwAf+7GrHPGq7GHEAGzO2Z0LPNMwd1ge8ahlweQqKqGdOKjE8QPwjV+HbHjGaW6oEvGpJyZ3X2sroamNjdu9KW7J2YQteNOuYW4Flp05qBi1VRmgLsQD4OvLwe16K+/XUnwTEvVx/9K27FYlgu/EjYZoDLsxE9rr8JIutzAOqZFn6OUIhz3I2v8fpvpvScwFeLInE47ufp8m1FHXBykxJFQf2Qg+kpn9l2lAPpuhTPLmURkTQtBk2i8TjkOXJBKrjHKOY8ScUfZ1yeHFnovpZM49YlRWWTi2tLgegmCS2i5lnNnoCg4CpmZdf2cHMtRc8AB855U5y08Ia/n0JMi9RSR2/dieS8AFsiTQcj7eoYjW4ilV11pMJ/U6cltU2OWSz77UJ2Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(52116002)(26005)(66946007)(54906003)(5660300002)(6666004)(956004)(2616005)(8936002)(186003)(38100700002)(316002)(36756003)(508600001)(8886007)(7416002)(66476007)(2906002)(1076003)(110136005)(86362001)(44832011)(83380400001)(8676002)(4326008)(66556008)(55016002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SvggH7n6xchOXA/X1XgNSBNFKII853C631YQFLnwo1LFb37+Z6cxEqtt1Mz3?=
 =?us-ascii?Q?gJmRwx678ekRD4DbjVZRucwy9vWly3ITEf/qHmfi7+tW9vyVh5y+11LRcUNk?=
 =?us-ascii?Q?KkIno4r9NnwS/mI9o0hu1+YQw3E9URVB8Kgrz/4qtZQMPFVhCUKi4cc6hGX9?=
 =?us-ascii?Q?Kw946PhZfOtoxSWeaz1057sFyOiDMEApD5EqbN0pbqR5z+XTFKJn8PryxUhZ?=
 =?us-ascii?Q?uljBcv0+drJzILOkvUuqFtiVMkd3ss/54w3vrQUpleauZPkGel0XNIq46IJ0?=
 =?us-ascii?Q?2s2wVIsAsUtfQxVbCX7OtB3GUj3NHnUU5r93gOtqjSfZZNEVOfFPCabk5415?=
 =?us-ascii?Q?IvD7MHp41y6wGtpqD/PvJOTaguQMnS+NO1eXay52QHi6CP9HlrwUOv4LqSd7?=
 =?us-ascii?Q?9+cIjgn9ViIvEGgWQv8lPNpQ24G9o6wznXhWSex9PTF9pbAP2VwM8AeGIg7j?=
 =?us-ascii?Q?RB1byVvK9r48Cs5ZmM9Q6z6I7PUBfUSLxFebD4WgJKoE1B8WAEJld99KyVa4?=
 =?us-ascii?Q?STAVnj8ykIG9H9zNwLpLxOhypbsjlfYOZneqzAwQFU1KWvMVd+024128mqje?=
 =?us-ascii?Q?s9Alx95ydYHqExioJCSAQ/wQJJ/1qzBEEfo8LMBFO6jn5enmp3F7Npsn1/qO?=
 =?us-ascii?Q?jih78xMst9LI5WQzrz1lZQfvQ7LdX+VhyPlLmxs9oPDR+77BkcuO34OhS/FS?=
 =?us-ascii?Q?VIs/ITK0G02CMo7wMrH4q2h3fozi4XSRZBKoLMi0Lf1OZj3qD47urHvTm8c9?=
 =?us-ascii?Q?dZf/Ml598yqg6VY6LurBtlnaVg87gz8FJOcQCFUEEAdAoGoQ0PKRsbl+QHGa?=
 =?us-ascii?Q?8yR4SE7X1hF+1Zz1hrfcRL6tZ72/v60U1WMyZd+/URK9hLlsnBQn/E66TtJr?=
 =?us-ascii?Q?8vf5LJUVhLIiGMpCQndCQamzSntd7w/FerXIA3W/4B5STfchnPOzAnUwFSIc?=
 =?us-ascii?Q?0zSHtNPkgAbQgJJr2/TDhn4/8MEFeQ1m7JjFaoy4qTzdG1ABnMDKAX3xX6ss?=
 =?us-ascii?Q?zvheSu3/6pQ31ZuPv87L699kFzL1J1iBe23RvmnMbo0KZc/2OeCX5g74aGR5?=
 =?us-ascii?Q?4JzsIiHVmWEb6MNtHljhPPlfxnpzTd4mBsq81YuLttC3gUW8/xaVUBOLRIdC?=
 =?us-ascii?Q?LpB+3uOaN5PxShrdrQVG8xy4c7t5tnR96xxipxfXf+U0eAu0OGX5dbQwKEko?=
 =?us-ascii?Q?5zfpq4fgIaqmph1hndXLFjZp1CppxWTQB5Az5OWwTh2YMX71hiATipEzPINa?=
 =?us-ascii?Q?xJrpM+PEWbbL385GBoAZjRmUi7HZjpyymClbxzDgumeHvvsE66ZiNreWgepH?=
 =?us-ascii?Q?mI7PgZwa99ixi3s+9NwutEJv?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f06ac9f4-d83d-4b49-797b-08d950c31ea7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:55:21.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yt8QfjIM/koQEJoXLjNJN5pZu9jcdIMeL1NboOEtzMEv4XqyKeKjR2Sk4kFyvunotQ963D+z/bunjoKPB+HDog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds asm/kvm_csr.h for RISC-V hypervisor extension
related defines.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/csr.h | 87 ++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 87ac65696871..5046f431645c 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -58,22 +58,32 @@
 
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
+#define EXC_VIRTUAL_INST_FAULT		22
+#define EXC_STORE_GUEST_PAGE_FAULT	23
 
 /* PMP configuration */
 #define PMP_R			0x01
@@ -85,6 +95,58 @@
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
+#define HGATP_PAGE_SHIFT	12
+
+#ifdef CONFIG_64BIT
+#define HGATP_PPN		HGATP64_PPN
+#define HGATP_VMID_SHIFT	HGATP64_VMID_SHIFT
+#define HGATP_VMID_MASK		HGATP64_VMID_MASK
+#define HGATP_MODE_SHIFT	HGATP64_MODE_SHIFT
+#else
+#define HGATP_PPN		HGATP32_PPN
+#define HGATP_VMID_SHIFT	HGATP32_VMID_SHIFT
+#define HGATP_VMID_MASK		HGATP32_VMID_MASK
+#define HGATP_MODE_SHIFT	HGATP32_MODE_SHIFT
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
@@ -104,6 +166,31 @@
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

