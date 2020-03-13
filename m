Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8510C1841CC
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCMHyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:54:23 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:9801 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgCMHyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086062; x=1615622062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=x9OBWyagIRsk9OH9W69gNn0SZv/uqjxhsA0WHdLT+dw=;
  b=BsgoQgTV7TMS6oj1f4phGBQuowD6agqnx5HV/f3b3Tnq+FyBUH0d5d2c
   g2fc40dIKo98zeDHYwR1LnRXb/d2iyVIjK8ygAuQe13w6Cx/uwxo/Dhi+
   La6/J0hXR/Sza/Iu+y5OS5no16LDRkXlQ0iMOHwvLY+XQQrGtFCcKmhvs
   jazRQUPcs9EFPEjd2+Z3WBHlKFIPruWP5GGoCgywbyh/B6KQfhK0Tku0y
   yTqN606y+yZ0W+BRruCcfqKisUkaeDmCndEcgkUOXITo2htyIWCIRoMIL
   SPgCBSvK84/jDJTELNdWBhFz9ZY6rhIp5c7R7dIbKu4gU7K1dj3k3Q7eE
   w==;
IronPort-SDR: ulDbzAv4OMGxOjnEgtUF86xzDT3IYAgaECuIXRe8qWHqq5OuL4l8OYm5Utf+9ATrAQeKrdVpN6
 A9XUyakVdaIk+WZ4ASvmtIl8Q/EYGRFemlH+NWCmcsXXFOh2a9AbM8kCanwMLpBj1cEY5nfzPG
 YLVoGdKJ9VoZT4jq5igb7CLpp3fW5RbJRe5f6nP/SFzm5o1XNpcufHIHLFXWH6cypNSEC0yERz
 y2SWWnsc8n5zqOyT7Rwrm+xhro/FS49aGP4P2vKk27R1LjB61B86GPx0MJq+c/nSlNFu63VLKc
 Wm4=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="132374598"
Received: from mail-sn1nam04lp2053.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.53])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:54:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFqV+Q2CL0hFMixileKuk38CrSSTlsNsJtoKIIDLsAy5NjErKsjP4vX3EaYDbtH4fvLaDZ/r7Kva/SzWSnABP9WfNGBoizVU42BklOzieiHltmILn+Sm26DYHMTiWb8Q6zikse256Hf/FowFKWMQvfPFSqZqRXs5ehyHcub7uK+DbX5QEOpNi5Xx6QJvXDIo+H/i2V4XvT5yer5Nc74Vm7dgwzCdP52UJOfHocmIv36imCvoUuoMFTazkMynq5pT7e9H+D0NCczlGZ/fkto3X6UoDnDKOCar0coZYJXHBTl6B6sGXWu7Inqj2G8IKahbcyPSzRx6JFoJ1Zqcw1y+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6WJedpidnASbw/CFSQgYofg4C49T5JbAH/vWurJIhE=;
 b=KgDNjLaf8PdCDU4lSPa5F4LklH2oMjliXsBzNuj+Jxt2KpcYHbsvKtdm/PhPfsOcEWWZKKyb0OA4BIQWR+q078UMwbiWgUfPVsmNc4fThB4FUUc2k9s8TFzEWt1bXinxwDakpbPSOY6swzxVBL5BIq9jY6df+qFIe7b8Cbw2S9NAufGpd/64b84rOq5nmEOvGxRivwTXayG7ED59M1u6c8Vvd1Z75tjY3ogIWCUCpFz5tXDBzJGT0OPwReYd0YcDrhEnZWJWu19xJo0FlwBmBrYKDGSUqKyDi6RTpcV2b/ek9Ab57Nj3RrPKhOzd0VQ8NCta9P6YZLzBgLqXjlfI5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6WJedpidnASbw/CFSQgYofg4C49T5JbAH/vWurJIhE=;
 b=qQezM86gYQvIt/KYqbbNhhdcXbZfwjQ/odBeL2a5wwDAdkkgj9IYuXZ81lBbpoiE+NdTpFZjcNbnjiNJ/yuDhAnxfxaaFa2u5162WMlmq1BVcaJm9mBKhrEhxDE4lrZDwSMhQNYoJFD8gSRQcNlq7nIcCbPhj8CMuLgPf3yoqP0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6637.namprd04.prod.outlook.com (2603:10b6:208:1ef::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Fri, 13 Mar
 2020 07:54:19 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:54:19 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 04/20] RISC-V: Add hypervisor extension related CSR defines
Date:   Fri, 13 Mar 2020 13:21:15 +0530
Message-Id: <20200313075131.69837-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:54:12 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c99cf808-c33e-42d5-bafd-08d7c723bc2e
X-MS-TrafficTypeDiagnostic: MN2PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB6637C3EE00A6A3C0CE4E27618DFA0@MN2PR04MB6637.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:11;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(199004)(1006002)(4326008)(8886007)(8676002)(81156014)(478600001)(7696005)(5660300002)(8936002)(36756003)(81166006)(52116002)(1076003)(44832011)(66476007)(26005)(316002)(66946007)(956004)(55016002)(186003)(2616005)(16526019)(54906003)(2906002)(7416002)(66556008)(86362001)(110136005)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6637;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QH4v4lIizGclzFalDIV01FG6zEcvcKQWHN8BcEtwhJWdhJlFKTJncEguC+mtYRQ1Chr1hW6DA65B4C37euexApvDtnWG7/JPq6rSxvauMuT1NkIs/h5caMZCcd4og9u3aH/9B/spF8d651tlVMmlD418671SBkPErFBeu74YBw3VNJYqGSeJ6w4e1uQE1idMwLg0yrYa3xMRkdyuOyA6k/JR+qTj9cAwcbvP3Tlf8Vt+kQPOR6+hfr6/+oBGDkTc0nxASQwi5NfNvLmOteoEem7OL5lO4XUrnUy8TyhAe5lHMTQDazWPSue8YrdaEtZ9amlVUHqz3Y8a7cfbzWSRu2vyRd1qwzoIbZk3u6L3K14Yw3qhT92WAoujsyPpRHwI/5kYWaUQPjKv8iAGLlSjI5eEMJB6N18zhPiApoFd2RnLjAEWNSsK0GjIvJa3Vo91NI/gpklEsVnxWW0mGhu/gtUKklxKwrK8kKnng5N59zg1T5oeU57HesflI8EpMe/Uto7CUrjU+BUTCVVRbPlvFA==
X-MS-Exchange-AntiSpam-MessageData: Ayubs++f5l2bJZtBYbk0CW6HxlihQBdpEy81+Q41X2tGCHnIFpy0x9tAV/sJvIsXUraxIbKyGRuBh7gRrln43NGkQtKCjUgT+hUYUxICtV1M8a3QTbGh1VCT0IRyZ23hNEoMmEes/jBc9UfQ5fF8QQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99cf808-c33e-42d5-bafd-08d7c723bc2e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:54:19.7622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5P/cHo13Vi1QGNfnsFtbu5DjNqH0WQFg14sDkL/h2Bql7XBvGnHK90BhJSWURrQBy0ZvrrlCAHNfBgv1ruXgnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6637
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
 arch/riscv/include/asm/csr.h | 75 ++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index cec462e198ce..dc4d70a211cb 100644
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
@@ -52,22 +54,31 @@
 
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
+#define EXC_STORE_GUEST_PAGE_FAULT	23
 
 /* PMP configuration */
 #define PMP_R			0x01
@@ -79,6 +90,48 @@
 #define PMP_A_NAPOT		0x18
 #define PMP_L			0x80
 
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
+
 /* symbolic CSR names: */
 #define CSR_CYCLE		0xc00
 #define CSR_TIME		0xc01
@@ -98,6 +151,28 @@
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
-- 
2.17.1

