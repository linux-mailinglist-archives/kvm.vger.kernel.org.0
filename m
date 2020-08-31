Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC5325793D
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHaMau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:30:50 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55064 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgHaMat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877049; x=1630413049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EK/5efwN5ctponF7YeDfvp60Cq6LVz8yReJHQCaEMVs=;
  b=hr+5a2aSQ/UhuS94Ts/sJqqKRhr1Cdz6I8AZTHOprK11Y39g0OnaXlJt
   kAAjBb7jKgBMXCTd5QdU5DjGnInvU1yt+8GkONcMwUSgZMb8Lfg0Zlqy/
   fKD0HJegYrZnGWxuzNUVg5SYg1A0w2cGVpwt83+hZAMHOpp5dlKH/f0tA
   UZL4sOGN/xSE2W9gLAdfzAUigN1ZGbaFeXT9LY/qqlvH4rBHlhfhkBIbi
   Vjl35FqGNIYWp0mJCILw6MX4E0EwYib67zUsL27BHdFpndQbKzoMqY6W6
   KVnUHMl18G8rTe9uuTWt7viry+VFlUrvhhPynK+Qfdt7WeBXXl6Uxe3Mq
   A==;
IronPort-SDR: vJoK5tXk82fIl3IGUZDJF4Jog4PhSpdrVY0roLtULV88kXV0qsIy/8RqlJGkP5woXBj3mtvEHA
 Qm0cWPiATGdMECteutlxupMD9OXGEh8K1xp1tBAqvw+fBdet3BNzJpwil8KdPAsYOU5+Na6eWv
 nbVOq/p4LIOaqc/Mfox4u+QEFB2cwYz2QbvztWmPYrjHe2Ug1vlWNa7RIlvfCc1ysCBsoxWDp3
 0QG7e/eq1hP86Dl5aIDnQxek/94DmM9BYY9cxEm3+6T/tWxR7h7ydPz1HpvZ7NV6gmVpCpZ9G2
 ZE8=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="146216609"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:30:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOZGULF2E4kwWbgNtkSuxovjyDHhqXO9bOonUxNTDxhQgAKm4pLiL2+2NZ1G2Zs5VEPS72TYhZ5YSAnl78Q+AZmdDu0By2YspWxhTY9W+J73AlibrI68fJQ4kL3EFxxyWg6SLs80xk6woHn+dVdT6kz9D7xV0XelLKlzC43l8bFzgbYz5pnvFgrEl0wrU5PtpZjnsjw51hDvSRPTZZ1pI4VBlpY4IT039cvEz1jyyvftRZJTqpAIrqaYonN+/uHU8K7J2QjSd+gZuRcPyEyiM2fvXN2KHqnCBMKs3wfUU7sSUagZJX7wazxumAfwykaN9cHBPdiPKNXI8gVNwYTePQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHs+gj89i8AEy86hjmH6iBGFS+byJUeIDojUGHCPg8A=;
 b=YGdHaF3ApP4LiytUu5xCwY7L9Rysh3KUYQjuIUHSHTQC/96r76sJ3WZ7Nset9XuAO+giJA4JKiB1rzsNLGlbb+rA39auriDlXoyw3xHXzGf3bMSQtKd8pSywEar05MEXTDRXpFgCVGEKt2l7EFSQHv8xKN2RWwRLdzq0akXPeFgmhFtYr8te7Z61C0dBh8v11qKp3Udpa5fi7QIiSrfck/6IPGbG6fDmxTkWJAPezflLuTwjU80t745TYspUwPZU0dvLTqTQ9G8e72KfhkAf768wK7m2h/PR3vSj34AZWrbZP/J8NZEXEi9dYfFsg4csCwhhmK5tr0TX3/H3ozsFcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHs+gj89i8AEy86hjmH6iBGFS+byJUeIDojUGHCPg8A=;
 b=dBezeKVmpbQe1gDmXG/u4dgBvFHhxHbdRi2B1jLOVTnz2F2lNb1vujXn7YxS/4dtbdafuU0J7mBpfoJpL25Cz7GMdw5YTYkHBUXXW1De2Y8EOgJtkDFKsDt3PGL6tlPmV3ayGmxmJXZbN3+2k7vfUjdFt5GLKwtyyxzDm2KbyCA=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6124.namprd04.prod.outlook.com (2603:10b6:5:122::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.24; Mon, 31 Aug
 2020 12:30:45 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:30:45 +0000
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
Subject: [PATCH v14 01/17] RISC-V: Add hypervisor extension related CSR defines
Date:   Mon, 31 Aug 2020 17:59:59 +0530
Message-Id: <20200831123015.336047-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831123015.336047-1-anup.patel@wdc.com>
References: <20200831123015.336047-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::32) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:30:40 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 111eed40-5136-4444-2561-08d84da9aec2
X-MS-TrafficTypeDiagnostic: DM6PR04MB6124:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB6124126E9DFEA9F91B141F528D510@DM6PR04MB6124.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:11;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yTZiYn+oYgl1FaJawd3WSM2ZsiQsKBp2usOUmsG9uZzLTTjM2rCJQN+6gze1sOROSigsC0IIrcWe43luy+XskZ3Wdd1fFzip3NqsW07rtEDKdXsFw6ef2FiS41uPdedzsLd2et+FLHnYSAm4kip90b0e8R74G4H4+E7zzbwrH3Q5c/Z3CTgsgSxSNTgxubU9CG7i9a+OrG2SKTVVz0qnXazN4eZRnKaCPNAwZhD9eo+bb4ALdB2aci0WQJAYxGjQQ7LYYse9lUE9pLYhDQioH2hnsAIWH0zDhgq0ySYSDxDdzZItj/NgpuOUp+wn38I0iwgSxg8J8sYVk1U9s63nmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(8676002)(8936002)(478600001)(52116002)(86362001)(1076003)(54906003)(7416002)(110136005)(6486002)(66556008)(36756003)(5660300002)(66476007)(4326008)(2906002)(66946007)(2616005)(6666004)(26005)(956004)(316002)(83380400001)(16576012)(186003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JcEwOlB7mfrWzdfIbavMmV3iwXYzkfrGflaTTsvmZ7EYqxsllh04fJeOxGF056e+Infwp7ouQxz9CXZ/GnsR5JXy6qGtvyK1un6Uq88VtyKBuQ94jLgLK/Q9oJMuHYcL41+2vw6oHub4b8GO0Iv9LjgF1w5TklXWnYv8xZmARTD8ELq/QDL9LOEEL0YvJeUDWogUT+viCCLu/OILpgmjoimAhNV/Jnwkw1TCpiEEupLsdWmOI96ukYLEwlpwpZSUUkTh3zaBWvsomKG3UMVxYePRy/dwJl6j3r+57S2l69Ag0yk23igsXiAuEgbc6iErF+VhdS0+WH5rggBmltojHl4TJSPKCfFM8pRNO15D7xxId8VFv535fSKKdIfvtvKdAIvXX1ySs7FCcnc6Ptbm/SVnLsxVJYX33PfzAKOKsK+1WeLSB+vGvEy43yDkyQnr0fPxN5sg2kg7RvBFYfzB6SEawgrFcP+Tf/qJ80CHjjt0lR7MOaC0loHuwIaNuTR0dMMRiOJohefSCx3UsFJgqOfEf1geLn30KzJNdObi3oYXgueUVAepuTX6XctQxahQuiDDeg4VM5S4SIwsPJU5P4KcRc0ZateiB/YbLD6//8mFt4gwfyB5jzFJ7e+i7zb5Vj4gUbTAfFEOW04oN49TVw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 111eed40-5136-4444-2561-08d84da9aec2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:30:45.1474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6WE+azM8qOSZ3tvOQbuSob1gWsdMw8BOtC07ix21x+AI2UKC5P8h1gr/J4lyMZZ2b4wsiFX67Zv10Y/Nq+GtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6124
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
 arch/riscv/include/asm/csr.h | 89 ++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index cec462e198ce..bc825693e0e3 100644
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
@@ -79,6 +91,58 @@
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
@@ -98,6 +162,31 @@
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

