Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B2A2F78A8
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbhAOMVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:21:09 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:38938 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729635AbhAOMVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:21:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713265; x=1642249265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EK/5efwN5ctponF7YeDfvp60Cq6LVz8yReJHQCaEMVs=;
  b=U9fSlhZjvQFXKsVqk82LB6qhtQszgS4IJXWvKUACxcXrz1dr5NJO5BB+
   DuejPKjtWishrZGlKzS8/DVR40j9CpSyMrHwWT7tFuBKxoWDLszijpwiU
   o31ewLv0CIv7/uRT8+uqfYKT8me2+JJUSXSZcpag/k172yY8xlhfAUtWa
   Tgb/AJLvxd59ANgCP00tVdH3mPzmTTqDNDK3HYrRzf9lknkUobn3e0BzO
   P412TCypPh9gn2z+ie9R3oY/YoywP2RmXBZ4rSI5bYbInOt8Ka+mqdqFz
   XCiJwxemXwhrsO3jrtQ+uMgxXrk2lVfu0AtylQobYEgyf+KWtujKPgiEa
   g==;
IronPort-SDR: 9zftEn3V3tzAh30fceNg3ZPLbO8BYYo29z/uA+UpDSkQBl3eOnnb0MqxRhp7c4pinX908c7aW6
 kdhlku42Lk5JbTp5fODcZSnXw5kgRfBm+kqAQ6QUOmX1JHvhYo2QPl2pMrW1pDcb1hcADkRL3D
 8f7TXq5upBZ9Xx0oFgMnQ+tB5KKHD3chT6wzKsvQ/XcgyVLnMy/uanA0ahLErovFrhU+6g1lJH
 bp0PyuJvCpPalW0bToZhnaSXlnN/Nd1c4eu5in2yRzmUMVvJTxKbYxIBQLFkFnlFlYqWBIxPnv
 jSM=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="157514087"
Received: from mail-bl2nam02lp2058.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.58])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:19:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Icplgw49VxPjecKhiwrsZVv1GmwF8N5dYWmBx+3Qen3haLfbtwYw+TOCZaoDFvfqaKDJB8LwUdkKrlU4WRBDQPRnSqk4ImCnUWB1Jx/3VG/AzAFK7JxWJK4J3PKAJSO8QTSxdFnBisnLz2sR73Ae/lwiKEPQxUqnJkovn4ftW0BYT9E39BViJSao+XvPH6TOeQEJgXRmgT9KB3aCgJj/fTQGRPmEFO9LWGaBB3hvCoR+rx+Juo89dk2BSSSDHxxLkcDuiWWW5l3nDyPhfRca31/GQXEpcMuZZx+R1VU3/KY5ac1GdHhhHPkWcKp9bmcF+97jQcj1nnQuydhxvDHFnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHs+gj89i8AEy86hjmH6iBGFS+byJUeIDojUGHCPg8A=;
 b=irNFiSkJu25dlsZjIbFwjDJ9G5RJKyNh39vsd3T/W4hjmlssF+ehS5IWONW5DyJQt7ScEWQm7TPwaKjy102GR783h0bvEMqeOAYKFcLIX0UMemo1wxt+oguT17hAr+3ZgcscER1R7SxVaea+3EokxfyqUVlz0knf8iaG71wZwni2qxLlpchgRUsSKrnUNiErktjDShhsMch4LisNlEQrAF8WsXjwFzcDkRZPJldnPU7mWt6G5iKFxHosGWmlbUmb9ujEOVVwTegYimJIAr8wAFg7jyq3evCgw2GDXhq6mRFOuh0cnu8E2Cjb0YbGXR7KaC88Q5jQpwpqTZWk6dkdOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHs+gj89i8AEy86hjmH6iBGFS+byJUeIDojUGHCPg8A=;
 b=zAUvQg8zLdkUTSOg++apmAAblKjnikmW93XDwCXwWwZFZVVlI5tzDIdKgdNn4IK92dVXAqDIFKjedTRsXzZRGtv1LYkHrQHuLMfb0JIfa66tCpb99we74VsR0lrGZRqQh8SgacSy5/wfPHzl/lw/E71hmx1ELU7FcBgUOQyIAew=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB3769.namprd04.prod.outlook.com (2603:10b6:3:fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 12:19:20 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:19:20 +0000
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
Subject: [PATCH v16 01/17] RISC-V: Add hypervisor extension related CSR defines
Date:   Fri, 15 Jan 2021 17:48:30 +0530
Message-Id: <20210115121846.114528-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115121846.114528-1-anup.patel@wdc.com>
References: <20210115121846.114528-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::34) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:19:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d573e2c9-f162-490a-24b7-08d8b94fc8d9
X-MS-TrafficTypeDiagnostic: DM5PR04MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB37692F49C79B995C68D715008DA70@DM5PR04MB3769.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:11;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZiWRh2n7KzNb9GHMQupnEwe+heOb5YLQEcT9czc9s/5hmXVa2C4vTnXHhZC/jaVM/wcupl5PoUyZSb6RPun59RpaRDC/SH6/2HUpPeOBoQFV8iKpSg9tiNFNSSPDB+zuVws5lXt7UTlshnUREwFlgDkqe52bpBYbGx1U6o8DjN22ksztWzmEbKwFvmXMYOb4oFWR21unhvR2NMxUnG+XFcnh4DqNta2v6WX/D3npILA8PDE3mvWelUW9rb4IMytJgxIQ+w+JJhCBeBcq4EPLprhuKrwaNDIV1bTgXESRbXKCMeVmENGyyiwR26GlawD1aSrVVOUhTiKFY4cEZPidRKXdTsGtxJydHjJ2+pR12JCU95xYffBB5jI19la/ZUG77+bC4JWUALMpGpGMOyKcsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(66476007)(6666004)(55016002)(7696005)(54906003)(66946007)(110136005)(956004)(5660300002)(2616005)(186003)(52116002)(44832011)(478600001)(66556008)(8936002)(26005)(86362001)(2906002)(83380400001)(7416002)(16526019)(8676002)(316002)(4326008)(36756003)(8886007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cnZXS1B9nNaHnETMZpPoSdTGA9Hssdga7OqayLZaF5SELN3cKw5L2kTYTQoB?=
 =?us-ascii?Q?fMJfhucRBIh/JowKhouHPmMGxEq7nG/yvwBdf9TT/ZLApbt0GWmf01LNZzRD?=
 =?us-ascii?Q?bNQcwaIDpKrC7Qicn8XlSV1ac733lFKA7ODlbEG3TYjkT9OvHbHIaAlP0TrY?=
 =?us-ascii?Q?79cJTELvC/Lt1z5fy7+VnamrYBBW5tmb9URQvJkN6SUg8L5TDS25mTMHgSQJ?=
 =?us-ascii?Q?TNstOtI8CQ4MeWlQ+Q47v1xb8864njunUGSHI1NH14Iz90nMohzpBldoqKdg?=
 =?us-ascii?Q?CYlXS0ZZrjq2QlGSLfOaJorLd+N+R83kKq25si0vAo5WxSDRAIb6mIsfR7ey?=
 =?us-ascii?Q?ny8wUc7zX4zyIqyzDiEmFRt8j0PlgJ2sS3nmVpmVNHOca9BqX6BWTq2sVHhW?=
 =?us-ascii?Q?6MtokYLirY0Aaiaunrutk7/5Nx+3sn+lDL6ColirwcUscV9Fd0IbWDLNRXqZ?=
 =?us-ascii?Q?46CCG6DP68407ybs0B1vPHsMyqniOsZzOrp28zUwcm7hKhRA7L5NDtW2isti?=
 =?us-ascii?Q?Lv/Ga3lztSnh4wuaYdz0x1MMj7eByJzAuGwkHpcOi3mUNFWMRbPTEW4XfRBk?=
 =?us-ascii?Q?e9A8smDGI9Ly0g2P3LlQQmh5ZA901nDC2QgQLWRcITuEuxksRGNasRdnggE7?=
 =?us-ascii?Q?rNWDv96dX5sxGjPAci9IGgZ0pNv5KKjs//Nw9mOaYoBOvBCuv/gbVwBDgI+t?=
 =?us-ascii?Q?UBcWgiZXUs1USYiN+2BhpEgKjKHTOV50J7IguX60CBdWC2Vb5SpDYmobfIxB?=
 =?us-ascii?Q?WvGuxptV9HNbBSmoO/GEuoUNSCQAjDnxjyZuPoF+OXZznFpujsBPsJ9gE5Aj?=
 =?us-ascii?Q?sDOB8pWB5uvVTRzg38xgeCpRvovuPd7kx3u1kVvEaoHUPpzRSGVtTQde6EtG?=
 =?us-ascii?Q?qBjJY3hFnI/HslR5JpceT2rkWNUAXkgKjhzVnhw0uEg6zeFqek3JQvSJFn4E?=
 =?us-ascii?Q?ExSVgv62ycK3G8yYWGOCjy5CohO877L4SelNBHy0vQQXb0297JCyiJoZDFJy?=
 =?us-ascii?Q?6gS5?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d573e2c9-f162-490a-24b7-08d8b94fc8d9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:19:20.0851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n2kwh1VwUBUZNtpvwodcZ65f6ngdxbQMm/u2F1rsii5QmOIZrRmeIn8pnZkFh/niU7ZZzcXDqxHtqFpNJaBR7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB3769
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

