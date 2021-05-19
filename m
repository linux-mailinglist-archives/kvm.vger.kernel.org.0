Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7722B388560
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhESDho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:37:44 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:13857 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237662AbhESDhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395385; x=1652931385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=S2fFIWw5p5IOD0E/nP1OdlY0BHyCpMdiGuq37tgZXX4=;
  b=evkRufbDq8f+RbRjIBvydkOiwssIqa/NdyoYMFjils1wP89lzPPxAWkG
   WIEdrbxtRsuEO7r6GR+9v4RUbDwBLVL9W2rBxDhgF7Dq0CWmnG+oWbRIs
   YwH+z1F++koqeR/wlCEJKvML7s3FC2Rjgs495/anSO1wecY5SIvKmgFXr
   uJC9G7NUP1pWl5q8fnE2SGevQtHHsqYkdgUuwDsD4qaUWTeenzPcJMLbY
   h+uFnq160RX9gAQOfwxKO3EiA4XKHEelKJKoL48oQJcVJNnTZV6wZqLQi
   A6W2VbosTx4UoF+PS9DsNHbnqCiWIBxOJOx9aDYGpzd5vvFDHlngakvXN
   A==;
IronPort-SDR: C9L6lpsfnc8g1r7whvxbo4JfOwO/J1/rKf56EQg2b3XeSLb04+xYBWg7f2buFw8MZkrxjQ0HHC
 COsmshYcRLEXrMDNb1kvCxDuVX6J61uJv0EY+xw8bYC5YX/E628HI7OqSfCXk8QRJRdkMvwMWZ
 d2ywAumL/T9tmcjDcE0aKNItOw/GUy5Wdd4kjj7Ebe+lC5PYmHWy4F+MJR7WwrNRr9jYhDydB+
 aYP04upUlIszIGY3uHbvvm9VTjHhm5POS9yo5HyloaFEKF1PFRePaRUr/+0xDwQRko/v78Z/+R
 q10=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="272597123"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:36:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzDNNqYXnUbmkKk0J7NYBNdHybMYx1lFOSyAiecbk+CkbgLiAiSygaC70NjxENrzp1cKfP3um3DMhyT/Ah13OA+rw40e/wqqkO/5nvLGgOJox+4Z0gj9cNR2ZAb9kH4n9+fSYuf+43Tj/LUwVB8wG9XfOtaz0oJ0UvySIVvZc7z8vAsm1Wloj9x8POZ+GYyyzfYEd4NI+ydOoAwnkTVsaWJRgfc2smqapjTkLtrvD1yW0LTOYIf5HzaS4YaHF63Q+YJMIoHF8rXslPyAhnNCH68ExT/+EsHzgk05ovLqG5rKc5G+rOZ/wKdo0SgmRN619CzWmEojuCth4S6uACdN4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sk8XpE13dIHDod3PMQVNO/6aEAf+gNs78hGIAdi/9cw=;
 b=S20f5K/sHEU4ca5PgXaEsRV+QGScHoozIGLl2Z9mfRQO13hCfObbLxKdoo4oRhDXzUmJV5C4wJ+a9nNALP2FPE8UGJh7xmdzBapDMrTxvO8slpvwodJM+aSvWABWXmDYpBOaOta5avXsqswDufHA7pjlTmXpaWt68fcY+YOFD5L7br0iojaj5KHM8V+JdnXI4ySDzVZoxGzdlJyqveSl90vsmK/FGdfUg9hugGFs5OF1s5Tn1LolNYFLOwjBr3JSVBUyt5rLWKlfaxWIi59MjCUmO4KGr7XejQ7JN5C+XXES+9IDsbz+Yf8Dl4JnJhLWz0CkOfZD+aVAz9hKDHwl0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sk8XpE13dIHDod3PMQVNO/6aEAf+gNs78hGIAdi/9cw=;
 b=tB/l0ITpWXv4MazsbWZnjlNm1jGTVirSKMT1gJi+0f0Dz2IRI9J4zO/xbLPFYP1w9KEjr9YBpsBDFoht0rZhUqqgpuw4gStLSmE/Qc32jRElDilRjMxkx4CMa7N4YI9905g36qTJT79Saw6Sl3cquAOtbDE4op6MmUVEaA1CPFc=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 03:36:22 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:36:22 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v18 01/18] RISC-V: Add hypervisor extension related CSR defines
Date:   Wed, 19 May 2021 09:05:36 +0530
Message-Id: <20210519033553.1110536-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033553.1110536-1-anup.patel@wdc.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.32.148]
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:36:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d701162-f522-4caa-28c2-08d91a7745a8
X-MS-TrafficTypeDiagnostic: CO6PR04MB7761:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7761E1219DAC3C39EF5D77B38D2B9@CO6PR04MB7761.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92NPoQ8pmIw4k14dRzPL3ZRjS/YXiuQGAjC/NnEzmsQa/pybYIAB35Yo0QtGpCFAnmsgNJTs/YKi6OqUs71fa+gOEK8hcvksyKiOu8sbZzm3dz8APA9nh8Q0iqvskV/OCKMx9bDQEmGcKBpdf3kBNGFfKqOSEPEOko2RRtG2YTfINy5lRBg13KRw8180KvVtyPwKv6hQysQGeqyfJiHjyDidS2BtXwwc4BCLlWzHw3EDcUZjO3X0zYQ9wDhIvTdVvqcRwvoONw3gkJABt25/2XLHPRbfa0iKMcdmQyIo39Bcl8Uj86uMth/ewg2MYOFwHzvxjD6Sh7Aa7JzSzBpRQm//5mBy5ovkiXoTDlpgATesYZJJKfAkyxwCEnyXSnTFvIA2aoSAbo7cxD67gXdMrBKGPPKM8fpLcZyFJq0XMJflTiYiYh2ueOA8/jKHUCRbGAztB1bQfbtl+bfAgpOi3p2XAhzJQaBKMfIWQcha4r8ILIO86cwEY7KbmgAo3G1xLkju29wrnTyS6oWWPwjT4j59n/PjE2jtmPOq969t0LQ5c5BlqkT2jOo4BUZ7ZVURCc5j0woe+2O++Qbvvd17G3ayodLmXo9KjJUK8DxslPt/4peev+9ExVjUscXoDVQA8nBeVv5Gv94+jBurVZm2Vnr7D1ig9QLVRWPh3xSefGk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(316002)(38350700002)(55016002)(38100700002)(66476007)(66946007)(1076003)(2616005)(186003)(5660300002)(4326008)(26005)(8936002)(478600001)(86362001)(2906002)(52116002)(7696005)(16526019)(110136005)(8676002)(6666004)(66556008)(36756003)(7416002)(956004)(54906003)(44832011)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/nxSsT7H60HXmxk132lWMjpXqx5dYxl0Z77yNJx1ehrhAG+CiBq8SeyAOZkR?=
 =?us-ascii?Q?bdnQKF869TwjUZLwo3YCaFWGr3LhmG1JTyF/IPObDLUlkWCCldd22CWri4Rj?=
 =?us-ascii?Q?rnHYFxwJ0JKx/TpsK3JtWH2SKaYLjHWRJM74qcwTI2M557rBI9npiYZlcNVr?=
 =?us-ascii?Q?OOQu8v2VKqn6EPxSjMThJUW7sPlGeEZp4MHPXSWkOsXFKZfK7PrMXYmr56ae?=
 =?us-ascii?Q?jQ9ETWpxlRg3YAn+X86AX0ySPHsG0xL4PhuSgZYT22FEl+uao34TJAU6PDI5?=
 =?us-ascii?Q?bD56jrIrlb9i8m1KrTKRd97Y7/ZDpHBoXJdr4X1tRHRmqqS+rGnjLwLb7DHz?=
 =?us-ascii?Q?/xGkHro5z4LwsUhNjhmvPuuxnUrU3OipvlpqqDOKNP23fCAgWzqN2s7jeYq5?=
 =?us-ascii?Q?JnEfDJQ09m8jUpJV6AOOz2yyl6pqeMwoxUhS0N9Sd/QnOsPBFf6uBlTa7EKj?=
 =?us-ascii?Q?GCQShlrZ/ZIgkwWXoj1u+ye4Msl4q9UmOiy4UMoIziaIszvuavEGIVjAryyf?=
 =?us-ascii?Q?8XbrdgDJYjeIqwG6u9/cSt7b+7Xc2NTWvr6yjMJ3Ranmqr6UHBsHv/cqiO6o?=
 =?us-ascii?Q?bWfZhvUOkyy3hpBT4cgG4CMV5CNz3B+0BcFAf3seh4rdC4i4lKuTu9M1p4iZ?=
 =?us-ascii?Q?gf/2Hn45bN+5987bwabCBKbT+UBK0abDi0eAeuq9n2JKEP/BP36p815TUNrr?=
 =?us-ascii?Q?W7FPMJHfGCrjrII3DaSEa0XviB5PH3HT+p1Vnq0t/9/Hapq97Dgq7XcBmWaV?=
 =?us-ascii?Q?ix7y6EwP4r0oDJByFMG00iWo8s+c+ewam2cYgI7A7pnygTtBDvcNPq3/4CXj?=
 =?us-ascii?Q?q+ldpGLe5Wjtlyh6fYxBSEr29csMUhEiJrJWeNxtaFUet6DzaSrghfKFw8be?=
 =?us-ascii?Q?QixrpDLySiXKZywxKkyOHNBL3AJqNh8P2yjHSrAt7QEpHKaGBoHllDM0VMlV?=
 =?us-ascii?Q?DUES8BCPKScGu037nz5oZMdtxkJ9L0YjcN1kfuzo2EHIinjYnpY7Qy06RQBq?=
 =?us-ascii?Q?f69HqZ7euv5p0G0Q8z97abzZQEQmVrjJTI1Jz1zkydQlTd43xMotVwDSOYlk?=
 =?us-ascii?Q?83Gq9BPI6vo/p/80UbXa33edKYy9lEO52e4w2EgLZ0dFRiE+hjGJV807zbkU?=
 =?us-ascii?Q?V78sTJQ2IZrnELjn4DDeBTuJj+em+fwCO7vmpUlf29qC7bYIuEa2p4YGoAq0?=
 =?us-ascii?Q?DzEWRfuC+1WbfoW6KExm//KLvjBxm8+ENSLaadEza76oVtRF0lZGe7vWnJt4?=
 =?us-ascii?Q?ImX0TUonSySDGGqTdvLM+0rqqSuOsfOLHp4gyu8YzQUfnF5gP/5tBsPHKE/2?=
 =?us-ascii?Q?0zeKeyUsUOsfdg9M9vfewC6Z?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d701162-f522-4caa-28c2-08d91a7745a8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:36:22.2899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XFIJR0L1DbRDRGJIWwj6uIHLw3GteXgGkMWEQlFzYN35UOyxEGYLareKhhob6iPkb+zeiCRB2i7vLg5oiYyFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761
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
 arch/riscv/include/asm/kvm_csr.h | 105 +++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_csr.h

diff --git a/arch/riscv/include/asm/kvm_csr.h b/arch/riscv/include/asm/kvm_csr.h
new file mode 100644
index 000000000000..def91f53514c
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_csr.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#ifndef __RISCV_KVM_CSR_H__
+#define __RISCV_KVM_CSR_H__
+
+#include <asm/csr.h>
+
+/* Interrupt causes (minus the high bit) */
+#define IRQ_VS_SOFT		2
+#define IRQ_VS_TIMER		6
+#define IRQ_VS_EXT		10
+
+ /* Exception causes */
+#define EXC_INST_ILLEGAL	2
+#define EXC_HYPERVISOR_SYSCALL	9
+#define EXC_SUPERVISOR_SYSCALL	10
+#define EXC_INST_GUEST_PAGE_FAULT	20
+#define EXC_LOAD_GUEST_PAGE_FAULT	21
+#define EXC_VIRTUAL_INST_FAULT	22
+#define EXC_STORE_GUEST_PAGE_FAULT	23
+
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
+#endif
-- 
2.25.1

