Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C8D41933C
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhI0Lmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:42:32 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:64529 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbhI0Lma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742853; x=1664278853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=aOcYxu+Msx9m+l81J4mC4xbxYGAdCONZvAoGF5T7Wkc=;
  b=oMhI4cBeMz3wLZZN/OMD5ZS8RNyxFeEHCxhlECflSlulg8ENWjsJVTji
   799PbKkFvkadFDnCzjqePmnBvBVqPlHDEBl6UEdncJE0ObKndzAGcTsWk
   CRKIiQHqG89QuiX9+yH7AFxnYSgA8A8JbNCphz9O76hbhVciXGBlRlVlB
   zpKJ/bNvySbk21otFzo/2/iovuoEdvouM01W1Ux8vKEqkNojx48FAuNGe
   UOmLWmsI+jKDf1t+avcGnODbBDywdy1yBfr8H2qr6Sba0+NXLldL5iv2l
   1SzZOB50/qH4GNc9s+7EwslGRN0YdOvcjEKmArjyZE4kFOG37pyhsq4dG
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="181070323"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:40:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqKROxFwSAwBVrtOJ+7P8OogCU5VaKmDUc16fcNgpYxM5hWjqnf9Oqjb2LePKyf/8pSfM9+D4U1PgxG2ZFdcweVhEqCba92BfJa6ZZJf+gSiukl3tL5h2y6gNj5UQpSN1nua2/23MK7YEAcjkG9x3EjpsJYptKi9IaVnaXTjpDRvX4xkBPwdu2xoh6k5qwS48vSeRtZNBQRskV8QxdVLkvTQkYPgg7I6KwRxmBao8fGz87ioZZy87dkvQI9CFAWRJn13hXClqO31psTxPicSl0G7swAqkXyVKwHBgy7cj1wVzjvWtV78jhpzj/STnhXXPNleVbyDpw32P4ATy7oEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Hm11dnMYKBuR0sDHfdIUdsNZir8WEhAf3DB8AptOzp4=;
 b=A/vnRWs9nRLduv/pI6IQp1X6cY3DO6r/xXEPMrzpTzbWH6uJSrSPlr8cMIIXggv+WFHNEt+OfjoDjJp8Ril4vZ7+CSaApTOezIeJlS3ekhoZbClVflxlJnUFb5yPoS+SOgiIl7ZLunbsbe1ljPazaIhXGdU9s6Ju6/y1NHsGETZgWZcvt51XJs9n0UJ4bVdCVBdVUekwz9xybvcQvctlFCYQti00AICll6mmaw0w2QswkTSgp8XIJSx9HdCox01jNIYEpybRKDkRoHn9aGGltBaTKQ8kJg+qHqb6JZe2poIR5bUrLXZiHxEkpaHt+bT2oF7AOwgtz4kstkoYRqeu3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hm11dnMYKBuR0sDHfdIUdsNZir8WEhAf3DB8AptOzp4=;
 b=PkWwoRCkIwcfaGckAHLrduUzt6pm5tOI9EU3Pa2Sj6cMRCs1ZokdseECUmIcAGhMbqPnsnvcMrXHdny0Ba+cYxp4J4vJViqm9hFWTP7SsueBYzhocwFUO3PQlPzDWcTBO7UiuzpzbbCfdK8VaPiouUkLcnw+IjwxkY/kHBfur+E=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8345.namprd04.prod.outlook.com (2603:10b6:303:134::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 11:40:50 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:40:50 +0000
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
Subject: [PATCH v20 01/17] RISC-V: Add hypervisor extension related CSR defines
Date:   Mon, 27 Sep 2021 17:10:00 +0530
Message-Id: <20210927114016.1089328-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:40:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 826cd3d2-c356-40ae-66ff-08d981aba769
X-MS-TrafficTypeDiagnostic: CO6PR04MB8345:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB8345E07C5787C2D8F801B7178DA79@CO6PR04MB8345.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QI8VtskP379fNrOyxFlEwvSwybln9Mw7Rb6PqPfWqOrtRH6C37WkEbsjTfnUPBs9kSQR1yU3InhR9IFEpp9hck3FS2Epupmw4ZvwwYZNn5kbM6Yepb4O00BA5gnB0L8HS4aist8WfC++bD7e4u/B9LjuKv3t6R9Z30G6Btj5oOT6qANvD/RD67m4eI0LNNSAkwkko9QW0/+oGvHgubV8mJP96xh1vvErxGBJfJs1n0guUEh7kOHUufIZKeElZDr8wlkcDl/TzsqJJzIGV51/lRj2ztKaa/Da4Mw0DKTm2AK3GONvaRy9P4w3D8TblCSuQCXD8KI/67HYmOLMG68FZ85guJUrD0E3i6oADoJ71IRGDSRbfqTOg6wIdd+TNx3A0SOqP242kiHF5PRe4g399dHVrPQMhEJv7IMEk7oHxejJuCNa53N4W/BAlvEy85V9jiXLkCRuwYFCMICjJ7Hg4Eqa2QLCQzzJuORla8HxvztcEgvgz/Uz/THDjDq1bcRNWpj/oV8DiWYHE7OlbKXw8BMkHXh1kWs30F1XJi1vsb/BfJpew6nVWDt5AYMyN750/zGpRiSA4F60CTmCogubTy5SYJLcUKEnkkMJCE2YwmKvYq1bW6hAfkA2wGsDy3/PiPC6K6Lnn278yRBf91LTIAL881DrVGraAc59rokDB8Mh/Ln1CXFAn2XVEWzO/zW0p5bRcw4vSjVDpJmPbq6QBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(508600001)(1076003)(2906002)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(38100700002)(52116002)(110136005)(38350700002)(186003)(66946007)(8886007)(54906003)(36756003)(66556008)(7416002)(86362001)(66476007)(956004)(2616005)(55016002)(44832011)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dcbFbPODsVBZNr6iMmCsOdjphxtU+acxJ83O0Ug06Myt/vYhoyBSnlwOr7Cc?=
 =?us-ascii?Q?6bIRToBA5NhL2Szgzx+mNJfmex7JxFyHn9zU/WXKp692urDD7WQSVIkb2LwS?=
 =?us-ascii?Q?EO2spa7bSG4NvfVanRGhKokOkfeI4ybVt4RhJyK6hEYo+kEUW85r8nIwF+2d?=
 =?us-ascii?Q?RkMTTPkLyzMK++2OZwvsQDlMZ4ZGHVF36E7ma6yGWtn06Bb2yLk3thmCJpNU?=
 =?us-ascii?Q?t3tuQXyWjh4lzQmU58Ru1XO5K7WIKOWrwiekoOeOeWnvQGAhN16XSVyKHJIK?=
 =?us-ascii?Q?HaNHFZ2rWJnBW6lW+CUBhYCd+bd1xWwHBfaoswH2SLn/acUO0Ok1b43Xs+dV?=
 =?us-ascii?Q?hZ26BsGLmLrUZ6VsMns1dvVgUAS7DkslcVt2eY9d0TlwiDhEhPufo9TTBI0X?=
 =?us-ascii?Q?IXJW3TNgdFxvWvAezr2wOdy2VdhGQIauYz4oOiST40xipmZaihPzxw8YC40i?=
 =?us-ascii?Q?7LU3C+TU/UZ9F152qiDJ1X3BdxMNDHhmr8bCcywm4/1bEZwyeWfsWCTKhvy/?=
 =?us-ascii?Q?WmP7Xs9jMFn6aHKNbzh4GpcoH3qO9WD7XGf0sWHyXZrAkMltT7ccImG98h7W?=
 =?us-ascii?Q?pP1NGT2dVy/UKFC1m6FUM8AhX7idmeS97Hk/tqGQC/N8fTr75cVFKfHRTkD3?=
 =?us-ascii?Q?Ponwbw0OAJRRAnaT1mJfgh0wH78umYc1z+w8pz/wZtbg1PeugS+qE1RwP2vb?=
 =?us-ascii?Q?NPqD5F30Rt/Q+7toJeyCmCGuipqAxuegbdrKZSwJwOIvWJecbIKAazSIoyJZ?=
 =?us-ascii?Q?PC769miV1jO4ZADqPU8tUfcP1UEG9p7lsjes8Ob/BgDIDn+iSINTt//GmVX5?=
 =?us-ascii?Q?+VebNp4AlC5IxOgrrFxF5fCQHJBcnjTGKY/IFkIUgX5YvyfV6PTa4nkNrBeA?=
 =?us-ascii?Q?kiCgV0DCP2p4Iq2vt1nBZ60tHQHHilQwpmVWs/7vH0G0tBAvM1PUoDlMKIcJ?=
 =?us-ascii?Q?Llw9pGUV8w2XjNJHzMSSeM8smffFHwiwhfOYHNthUfkM34fKjS3UjDvPajLs?=
 =?us-ascii?Q?SugQ0wdfx/JTj1xMvHtCBGDxV+cFeeVI88K5AeKrXL5dlsn1csvoG7gNb1uw?=
 =?us-ascii?Q?PppzmvsnhhSteRJWWlo7IWvfzRLLJUaeh8+7bA6dVtEd53YfEwP7Su2vs31A?=
 =?us-ascii?Q?KH/O8gCo2b+u46X4m+FqF/MZ6H5/HH5Bb+HR3Lv/++mDoPhIfiUIhIbRVwbl?=
 =?us-ascii?Q?nk7IPIil1FtbZ7SSda91BItqDvTBl0C9WA/Ta30ptQaMVENu9ksr5VTVvKQM?=
 =?us-ascii?Q?TVTnawAVO2ve6ec75ddU0D6AbSgQi77fldbcyfW8c+9aeFDg0vm8erobMii9?=
 =?us-ascii?Q?PeaWsGMjgYT/9X7YMr49Btkw?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 826cd3d2-c356-40ae-66ff-08d981aba769
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:40:49.8983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0kj/J2TUgBc9FMFmZHnmtZNgXEj4MqHipl3ZwxpV9ax7x1Q8rXRMgvUCA5AvAzZDYjF5lsogXwp8VO1leCEDrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8345
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

