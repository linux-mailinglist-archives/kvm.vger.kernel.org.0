Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5077B1BB794
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgD1Hdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:33:53 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57156 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgD1Hdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588059274; x=1619595274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=fS1pOZ9tSgfBg3vFDRjMcFP/v25WbM3UcpHa2814axo=;
  b=Vda9aIQrTkmB4STDcykj6fXOiPAJBhOzFSFU+S6QahCYqQZ8fthbbBj/
   N/ZJEPk9/gW//V1Po4ghzhcSqkREuqN+r0LmoZn14Kcgo2d3vFcIW4Ky4
   72D8yOPzmq/vu11RHudhgqUzfkyGhAfOFw2z0b5aY9wKGR7t8ZfRT2c/r
   e3tJb7u4DLNSoROV7KBvq4Ubzdaqwg8TCwKSt/BqOoaOenU7BOvs/2M6Z
   IWsBxbtN90zQzdH5JwrCQZS7PWS3kQI7GQkknDcwNLwFOjb65HOOgC9Qn
   J637g+fFj84ZIKMTfHqQUFbt6uyRiDE4sdIJ2eFpMgA1hrJGP/AubEtCQ
   A==;
IronPort-SDR: 9pT1nIlVYvyayynuD/4J4rwjUnig2Uhf4RaPA6D6uBWvfjo25+lCh22FcWGiLXGZEKK4t8KObL
 dJPyHSBkrNB9cSicK8Hx46SDVpYNI1vo/Bj5Y7k6Fu7su6oZHqCEBxq1UdkF8EESTnkQci3wxg
 xqclhHKjVccMneoNp0txwMlXS12rEQXEwXyGXGlip+52faZTP1OpL30asz7INYK4MqlrDynY1b
 iozY9zzBwmD5ghPPjxuS1o1zATXrR5+ACTjva3vsJxnkg5vVjoR3sTlkozl9vpGgUoNDRKO6Qt
 OuE=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="238865794"
Received: from mail-co1nam04lp2056.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.56])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 15:34:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MumHdT1JKCiCbNM1lragTrW6S1AJxgwgsN7HDBZzAkqG/5iEAQWtD1UldFvHH+j2jz2fWGFz/P3pC0urMQyhA28AS/dnOTXd6JDXMAGFEN/PWggHWX6LEnzaS7jWDDuiOz7zm9n3FGhR/j52T5YG8c1z3fBQRfzLkVx5QQmuW4+yt6pbQESmOjJnbwJ9HM0nVX2ZPeobCcf7l6mSJOSZxI0BpfbHdqcpCQSbp8G6OpuXy4481LS7uf60QOd0S318Z3CeCdQQ5SnDVEnSF2tMcZMJprY+zfCNXpGDVLT38+up4qhcUXADrOJyFPs29OShdsmBNax/3SUqrUxwHVgvaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cM5zvagwwwCQPQYhTln098aGMAhEwWyhhwu44uXGfs=;
 b=PAFEd1ulqr2sH8UIuz97oU/g2A4sVlKe6usFF1V6ngPnMLhyXLG9aJOCpbvwrvgMOqfmgWQdhjz1LG+RwNH/1GeDBPwidANZhZJP87AGOzbGLAbIudpEek4gD62Z7KFXIXjg57oiphoIx0wyvc9YDWPY6pEWTouNeeJqJg+L/ZhgNEYTwpePBCAsE/lkG30BwIYKdLE3Q7WwmuqEcCfZUROlH2M0L4NzTjeNOkm6f5CzV6bhIbCwD1qommUz9VQPx3qwWFmWPmUFZbFfB7Hnih3woPVMcefoKwoylTKJ4wK5VtjwoVdL/a+yEpIqmPxm2VkvaMHoOIgvquq3bKDNWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cM5zvagwwwCQPQYhTln098aGMAhEwWyhhwu44uXGfs=;
 b=XISfYNaoR2VW4JvllJEkWtLyB9ECGW21CnBE6ysrk+FqlSxxWKNnjCtoF6eyYNUubFabONNzngUxBClOS26o+cZXzhx1pgjWdEKU/6e2lARhbDSi+qKDdwXtW7OEG4NhewrHVINyIR3tRXt7BEuClyQ+3IQ9E/4GUhfitUQhnaU=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4538.namprd04.prod.outlook.com (2603:10b6:5:21::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 07:33:50 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 07:33:50 +0000
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
Subject: [PATCH v12 01/17] RISC-V: Add hypervisor extension related CSR defines
Date:   Tue, 28 Apr 2020 13:02:56 +0530
Message-Id: <20200428073312.324684-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428073312.324684-1-anup.patel@wdc.com>
References: <20200428073312.324684-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (106.51.31.156) by MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 07:33:44 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.31.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4e47d305-d850-4021-01e2-08d7eb467e77
X-MS-TrafficTypeDiagnostic: DM6PR04MB4538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB453898547E856B50ED7AAAF58DAC0@DM6PR04MB4538.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:11;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(55016002)(6666004)(1006002)(8886007)(55236004)(956004)(2906002)(1076003)(2616005)(44832011)(86362001)(8676002)(5660300002)(16526019)(7416002)(478600001)(36756003)(66476007)(54906003)(26005)(186003)(4326008)(110136005)(66946007)(66556008)(8936002)(7696005)(316002)(52116002)(81156014);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mk6dp0pv9o4jRAhISKvJ5viqXAS+aPV5lCJUg70kX7lXruQMqYl8ne6U+V6x/Wq0Sx7j9He5OM6wkznM4OEcnnuijTxxMxqAI/SJHiqqdXYVn8vxV3yBTvyNDcqtY9Ss5yrHp0xabSbwvZMaYWesiIvAZIDnIfTS9EP4MnZqYLnXdJhDHoFYd6RsPXbyNuQGDWR4JQhIICGteOQde6YmF/P1KoemIfq5wOcEJ1qZ6oHRJqtlRUYlBo2+NhtaDZ67aBW4+MtKfvAJtg6pPPVXV04tWfIdX16JrDh0QcNGQvdJaer7UIbylsdpPq/3LsI4S1Xl6qLRXx+r0Kii9hs9dcJNQQb2TA9GcnMYXy6QLTbaMXji0K65d4Xk01k/AnJe848CL8/BHFvEkzZ8c0OUCbpheZiUL/Wv1M41eDlmOF/cyKuh+UncEttPKbyLH30x
X-MS-Exchange-AntiSpam-MessageData: bq1nsOzZivLxG8FaPBgm26aHhLD+wy+4f6ihl9TWBQ6n2W8ORL9xLPDaPnaFDEyO/Eiuj0jjgjfnkoB/WhkLNJU+Mqknpjr5yo/m/Vs15vKXDRDu9zNbSbclJGlI/OFHUD71nnbAYrJ7hP7OY9dFqaHX2qFbE/zFQ+lvTY545P/aTcaPr3UCYyxrgjZ7cq6rY67qPzCuu1KPe+lfkz8kvLLc5VaHhN6Zt6Ycatu0iDR4/rlmlZbE+rDkY9YxpXwS8FqZrX9/OAVzXzr52Yjzef7DK6QK2eYHoFafoqTG+0r8X1GCFAEAWO8RcCt87k1FiawtlIxWWwa6P7puX3zJtPi6vJwckzpkyFjDAnyHjUJtuK13oWA1tnVKG7VSaICbiDQuBzNEvOs5sC1ZaeWHqIB7NCUC+QHCgfmHGYmNKitjBsLe6wYV5XTJuSmjhx8r04dKLc6Cx4xH+mYmcZWZPct/JweuppIKkSYqr+08fbwtxynhd/ybii3pE36xlRfN2PXRhiEmDidlwacVCVjCZm+2/K2uMmaBXcvWvnlc0UqEE/BlnGs9oMJ7O3TZ6n+1r3s5PPIt09nHWsIFZLuBLlPesBEEIKRXC5GnXXeuSNSiwYbZTrOvE6PnAxhBUJjNF5kyrZf1X+WwszHCkyKUfRLR4Q2kWbbAFcy3GxoErhJ2ED2J5uZVu7aMB+OaV4Tg6vhqtjk4tAr2aawlCblbVUBTJRNBRN0zBuHEp9hQnx8ou8orP//7XiWSYlozkHjFS30Wbn8xt8OADxNwUmD5cbE/pjHDTePWWdlt5SDR9YQ=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e47d305-d850-4021-01e2-08d7eb467e77
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 07:33:49.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TcHj9s54Huykl7XaZQ01YjKOhXgAV/nzbUP4QdmYrfij9iO2UehOt8/4ILExVmWXXDcciLeD3kj9k0fMQR342g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4538
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
 arch/riscv/include/asm/csr.h | 85 ++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index cec462e198ce..ec6a1917bb0d 100644
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
@@ -79,6 +90,55 @@
 #define PMP_A_NAPOT		0x18
 #define PMP_L			0x80
 
+/* HSTATUS flags */
+#ifdef CONFIG_64BIT
+#define HSTATUS_VSXL		_AC(0x300000000, UL)
+#define HSTATUS_VSXL_SHIFT	32
+#endif
+#define HSTATUS_VTSR		_AC(0x00400000, UL)
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
@@ -98,6 +158,31 @@
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
+#define CSR_HCOUNTERNEN		0x606
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

