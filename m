Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD3A456F07
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 13:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbhKSMtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 07:49:07 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:39917 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbhKSMtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 07:49:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637325962; x=1668861962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=hcjqiasq7K/WxzoSS0XQ9kt2VEPNvW0wheNcD0cfHo0=;
  b=iOh7giIpvlJKd1MGq+kK5aWmza2boLMOxTeS4/b8r3jKEEEP8uGhgNtt
   JFPbp++PCMGLGjjNEaQ9ClMu9gYviLVP0trtTxIwm6u1vxEG8p6qLmmbw
   2cONDiUCesmJt6t2hyf7mlQ8hrUSGsLuvskjCASRiu5qhr+LD5usmufys
   4qHqtQKkkZ63Lcu1CKsbGIZOgjbkijSTLoqSK1GFqtxoQpPPkSjh++AVX
   HmO/qXi3R8uNwzvuqfAg0ZwLzhYRv2DjkixLPBRvK5srr5xJ8GtEVNFWC
   y+hm+vp7P4rebdzse1OrTjCzK29TgTzBNx8z+OHEM1IM9IDxGic4KZKMU
   g==;
X-IronPort-AV: E=Sophos;i="5.87,247,1631548800"; 
   d="scan'208";a="186094605"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 20:46:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEfRCCaNdTMI/6uThR/E+IGnLxswo7zQjZ7MxTTxvkhtvyXVbhlbFkFg3aiC1PGhMBAUhpzlsYZKxwAVQeMPxubQ+8JY2Q8oFPQADR+nahsBNI6XcsRRxo7dPYqWAqDhTKfceo1IYc+v98tZCRhzvJtakzMEwdmdFuE/T438UV9OAnVrnwnyrQtsI/4lPl2WcNMTHetEoVRLsZMBXN8XfOsuDfXZ6Q0cuZk9bs2akVnp6QYqksm9U5bVBqOhXmYdhwJ5GO2fM5BrRykSxSXZu4R2z3IwGrL1LTPUKolnRI1wsGJidlVgl8pfNwOW0r2JjOyNmsmVtpXN/btvir4eqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIlbmmbK6u8/3DZbKYDFFypq1MGpSoQgfLLKJcR32M0=;
 b=GS/MSafWbydF9/dcNZRtWdNPw8Dwu/s/nUf7O4gVf0ofBvzIae+g8jOjw2TMve13UGHEjc+yiyzoYNFcSYplp1DJGYxJa3GM3e0oK8y1X57PuVW3pGQaKnfOjZUQfygj3uSyTzm7toPRwHCj34zocawmQtlOJqkYR6d5WeUaCX1D0AR37S2+FwoHaGEsw7OlzAPpoH9fYQs/oub8VWfnVODr4v6xJ8u1YYle98V+9oDXbOP+ZKmwllUGTTpS1za9uXzwa7Mpd5Ogzjgn6edLaIFR/R0rXUX8PRjipj3oxgP8ZqHtMA1x38yj01QJ6Vg/xSRZPU0+vOFRmQORobukRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIlbmmbK6u8/3DZbKYDFFypq1MGpSoQgfLLKJcR32M0=;
 b=G2gl4bRsKhQtNdTAQISDXnXmrm5tShTlHd6UBYiGxG9srZa0z++6qTS3NT1OrN11jgjbozc52KT1ZWe5FieMnTQm3EnOg8ATSVUBMZc1wznd1cG9lZCyNFhnma54EIOg00L6ok2qQOn0YsZEQJ3KG7BClBJbCAqsaPGte1qVr3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Fri, 19 Nov
 2021 12:46:00 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 12:46:00 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 kvmtool 5/8] riscv: Add PLIC device emulation
Date:   Fri, 19 Nov 2021 18:15:12 +0530
Message-Id: <20211119124515.89439-6-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119124515.89439-1-anup.patel@wdc.com>
References: <20211119124515.89439-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25)
 To CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.171.140.195) by MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 12:45:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa58123b-f131-4e16-4ace-08d9ab5a89fd
X-MS-TrafficTypeDiagnostic: CO6PR04MB8377:
X-Microsoft-Antispam-PRVS: <CO6PR04MB83772D7B6FA7F53D830BBB1F8D9C9@CO6PR04MB8377.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7nMGuK8BcnRMS3TjU1uwPgzUhpoMNC/TgzeKJnkdHsbKCyxdkTjgfcdVmLWFCKgclnhZ6TQGaGC6CDNTR16U77iNLFz/vQzWIHvaEnZ0ENLjQdg5qAh0jo+PkwLp+G1jChlLHeYCVbWKB85o2BZDJR03hvsrK4eu4DYyi85GL14dwp9d+QYdJDPGBZseO7bv2kvlnSalEUkiAGytNuxAOEDCCFn60b000BE/SMGXDYPrE8wa5oIEZy84bAi9sVQ+Q/ZmqtBvjem1h1IIVEwdAv3inv393rmzPsd/7ThF4bvqC/cS7DjFy51kIjeUpI0+w64pOUqFgabpkapqzAw3P8i+tO7/+Zay0Mlg7dU2lRKISsNDDWadlt4OTII0Iof3ih9gMl132IyibxLeyt7o03i5B3BkzdQh/KPDcSmpuc0mWPBa53qWMHP3Q1d5o0m8NtGNYJ6R5ZNxncTROdKUytKC6r5+AJ4gikxym5fNZa7OakyJ9BkP2xV6dCtsXJrf9nyKaBFYSj5mn2gL6PhhHfWeVYrIopU9nMJ4TlR/iv4AlL/UPOxDlHMIUT1pMZ76xE7GywYahzenk+aB6gBRB1BD19DmCVxShoKzLl71HZVpW7yDwVrVNZ7gSGX1cD3uwvK131aDKzRmzMVVH5aWy2dSlUB0xedbXDq8o9KK8zzA5tOnb7XVZhQiF1SlPrBKdcVqREhuYslSBP+/D4+kxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6666004)(1076003)(54906003)(66946007)(508600001)(8676002)(55016002)(186003)(82960400001)(2616005)(956004)(7696005)(36756003)(2906002)(4326008)(5660300002)(26005)(30864003)(316002)(66476007)(66556008)(8886007)(83380400001)(38350700002)(52116002)(44832011)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/1mgwPlqdqnk4EdUliJFqM4aW99orXOYCjaHHwxS5Oi5bD3RuIl8YEptHSq0?=
 =?us-ascii?Q?jByReN+TyYAxN+7ieK/xtE32g66Z5XU8ocFurLrLiRT0vqjilyrc92ROIXh1?=
 =?us-ascii?Q?KtvuwOQdx5DftoJn8AcDdf1qzAeQkr8m0C5IWOaAXwanqFzx5zAebVukqo7H?=
 =?us-ascii?Q?vHjrQ8iQfhHk1zZwCBYWCbrpbl7cXKBPdCcX5qqEkZSeVjwbWDVDpH0xGdax?=
 =?us-ascii?Q?Q1oD0o/m+VLZOc6HjWWpDJxCXer6sFw6eF9OoMZ1GIH+i/MKnHWhwkKW6osT?=
 =?us-ascii?Q?al6ec8wd4sWFCZD5bFfoZqcehsviIVKKDIbrJbhFUGh3qn4OKsW996ACJAct?=
 =?us-ascii?Q?dUWLrHdM7lECW16jagSQni1mPwChXWbvplQwmVmwYtFt0obGpDFpT0JIm5jr?=
 =?us-ascii?Q?fZEPiysh6GyLJn7ZnwbmDG2DOSTUaVjO5+Uvi1TVtHCx87vo3dvFDhDj1d2D?=
 =?us-ascii?Q?on0tFB7EHguXXu8gBhOj6n6BWWM3lYSkN2QqHI/5HvFQqeuh0MefPNFh9vCg?=
 =?us-ascii?Q?BAYB8u1OdrCu8oaYBQpui7MAC0azMb1F10k2oHebb06QIFmnjnfZEkPBWraf?=
 =?us-ascii?Q?jiq5A6tBEM2QMb7KhBFFZ16fo8S0DPcXFqzkmd7DXjzQE01vA5090bbWhKig?=
 =?us-ascii?Q?1JrnduoINqQvmlwZvUGTYM0IKLvG2E0WARUUi+Ij4WsRv0jaeJcfCBXnNIzj?=
 =?us-ascii?Q?wkV9RxCcMeln53LDRZzCYP1pw3Mfuhrm2JCf56tDqRg6c38vjqLwAq7JcXgl?=
 =?us-ascii?Q?nWLoP9phXLX/3uquS1BoHWQqqPn4OkU0pp3COyWf5GLvI0TOyUrB2DrIp9yJ?=
 =?us-ascii?Q?0uVm6YVIpJXo155w3wnwtskiwNftZuJ+MAXjaDIMOSCrur/asDzfMcgaTq5R?=
 =?us-ascii?Q?4SWWW2XbydnnYgSR9NfNH6sqZIvDBnlgSeaj2YIgSQMPuE2rnuhMslopIkfD?=
 =?us-ascii?Q?xi44DEGaVAWK+9EIW88VFsgbem5WpRsjR5Vk+q+HcHGWfPsYz8/X81/xTmqR?=
 =?us-ascii?Q?HHZVbcsfKy+LRBjrWRrDjT2YpzV4H9CBmTO8sYH/PI+16gt6fysofZZja5aM?=
 =?us-ascii?Q?O+m0CejXwi8ag2Yrc49z9q7XqkJ2vgsmONACfwb5iOOpL3sbqQeJ6FMKWOZB?=
 =?us-ascii?Q?TsR25eSgAmGOhd8mmMSbitPTsufzlug2HsAgXEPlHSmsiKr5ShIxCg8uVTja?=
 =?us-ascii?Q?eSm8rRG4vtRGZFKGitte2367AKBhjlfY4JbA1h1Dakw+9US/pcWk7gazqjUX?=
 =?us-ascii?Q?iCWNzn6QzAf0Chtcxx04sg3hAhSbkAZoNSFFCEaAoIkxFKcmLbi3ODj6w1oE?=
 =?us-ascii?Q?XH/Rp6z3lhT/otN01N0H8AqO2kTj30LSBI5B/CI0N09egCeN27ZikEv7N853?=
 =?us-ascii?Q?MogUw7wBrcW2RK1BtDzlBb7+9KvHvxRL2Mfv2cdzXSJ2e1ACw85MEmIlv8yy?=
 =?us-ascii?Q?SHI9XYvkMCD05aAwy5wtAfAoOczg8NDiKEfsXo2ql+HXRIsgDe/nbmo08QVq?=
 =?us-ascii?Q?lKBww8P+XhFGdObzw1OfW2n5ViG0mzUhrwGArjB7bv3u2ZInwTxpFrZXEv6z?=
 =?us-ascii?Q?J19SqGKw5buA2+0/UjcY/mIDK+PIEr7naQUZwyKveUMZhZy0lthNvk6heqEn?=
 =?us-ascii?Q?8nELWHUAc1j5ZaikR2/oUWI=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa58123b-f131-4e16-4ace-08d9ab5a89fd
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 12:46:00.1673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+Dn2WLncmNsUDgODvgQ8gEY/hJpSUijWHgBT/Lno1NFwx7oWRfRXNkD+yGgN540Kh0ao5X73rCzf8s3jDE9iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PLIC (platform level interrupt controller) manages peripheral
interrupts in RISC-V world. The per-CPU interrupts are managed
using CPU CSRs hence virtualized in-kernel by KVM RISC-V.

This patch adds PLIC device emulation for KVMTOOL RISC-V.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
[For PLIC context CLAIM register emulation]
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Makefile                     |   1 +
 riscv/include/kvm/kvm-arch.h |   2 +
 riscv/irq.c                  |   4 +-
 riscv/plic.c                 | 521 +++++++++++++++++++++++++++++++++++
 4 files changed, 526 insertions(+), 2 deletions(-)
 create mode 100644 riscv/plic.c

diff --git a/Makefile b/Makefile
index 817f45c..eacf766 100644
--- a/Makefile
+++ b/Makefile
@@ -203,6 +203,7 @@ ifeq ($(ARCH),riscv)
 	OBJS		+= riscv/irq.o
 	OBJS		+= riscv/kvm.o
 	OBJS		+= riscv/kvm-cpu.o
+	OBJS		+= riscv/plic.o
 	ifeq ($(RISCV_XLEN),32)
 		CFLAGS	+= -mabi=ilp32d -march=rv32gc
 	endif
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 300538d..25b80b3 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -80,4 +80,6 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
 
 enum irq_type;
 
+void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/irq.c b/riscv/irq.c
index 8e605ef..78a582d 100644
--- a/riscv/irq.c
+++ b/riscv/irq.c
@@ -4,10 +4,10 @@
 
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
 {
-	/* TODO: */
+	plic__irq_trig(kvm, irq, level, false);
 }
 
 void kvm__irq_trigger(struct kvm *kvm, int irq)
 {
-	/* TODO: */
+	plic__irq_trig(kvm, irq, 1, true);
 }
diff --git a/riscv/plic.c b/riscv/plic.c
new file mode 100644
index 0000000..6d64e8b
--- /dev/null
+++ b/riscv/plic.c
@@ -0,0 +1,521 @@
+
+#include "kvm/devices.h"
+#include "kvm/ioeventfd.h"
+#include "kvm/ioport.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/irq.h"
+#include "kvm/mutex.h"
+
+#include <linux/byteorder.h>
+#include <linux/kernel.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+/*
+ * From the RISC-V Privlidged Spec v1.10:
+ *
+ * Global interrupt sources are assigned small unsigned integer identifiers,
+ * beginning at the value 1.  An interrupt ID of 0 is reserved to mean no
+ * interrupt.  Interrupt identifiers are also used to break ties when two or
+ * more interrupt sources have the same assigned priority. Smaller values of
+ * interrupt ID take precedence over larger values of interrupt ID.
+ *
+ * While the RISC-V supervisor spec doesn't define the maximum number of
+ * devices supported by the PLIC, the largest number supported by devices
+ * marked as 'riscv,plic0' (which is the only device type this driver supports,
+ * and is the only extant PLIC as of now) is 1024.  As mentioned above, device
+ * 0 is defined to be non-existant so this device really only supports 1023
+ * devices.
+ */
+
+#define MAX_DEVICES	1024
+#define MAX_CONTEXTS	15872
+
+/*
+ * The PLIC consists of memory-mapped control registers, with a memory map as
+ * follows:
+ *
+ * base + 0x000000: Reserved (interrupt source 0 does not exist)
+ * base + 0x000004: Interrupt source 1 priority
+ * base + 0x000008: Interrupt source 2 priority
+ * ...
+ * base + 0x000FFC: Interrupt source 1023 priority
+ * base + 0x001000: Pending 0
+ * base + 0x001FFF: Pending
+ * base + 0x002000: Enable bits for sources 0-31 on context 0
+ * base + 0x002004: Enable bits for sources 32-63 on context 0
+ * ...
+ * base + 0x0020FC: Enable bits for sources 992-1023 on context 0
+ * base + 0x002080: Enable bits for sources 0-31 on context 1
+ * ...
+ * base + 0x002100: Enable bits for sources 0-31 on context 2
+ * ...
+ * base + 0x1F1F80: Enable bits for sources 992-1023 on context 15871
+ * base + 0x1F1F84: Reserved
+ * ...		    (higher context IDs would fit here, but wouldn't fit
+ *		     inside the per-context priority vector)
+ * base + 0x1FFFFC: Reserved
+ * base + 0x200000: Priority threshold for context 0
+ * base + 0x200004: Claim/complete for context 0
+ * base + 0x200008: Reserved
+ * ...
+ * base + 0x200FFC: Reserved
+ * base + 0x201000: Priority threshold for context 1
+ * base + 0x201004: Claim/complete for context 1
+ * ...
+ * base + 0xFFE000: Priority threshold for context 15871
+ * base + 0xFFE004: Claim/complete for context 15871
+ * base + 0xFFE008: Reserved
+ * ...
+ * base + 0xFFFFFC: Reserved
+ */
+
+/* Each interrupt source has a priority register associated with it. */
+#define PRIORITY_BASE		0
+#define PRIORITY_PER_ID		4
+
+/*
+ * Each hart context has a vector of interupt enable bits associated with it.
+ * There's one bit for each interrupt source.
+ */
+#define ENABLE_BASE		0x2000
+#define ENABLE_PER_HART		0x80
+
+/*
+ * Each hart context has a set of control registers associated with it.  Right
+ * now there's only two: a source priority threshold over which the hart will
+ * take an interrupt, and a register to claim interrupts.
+ */
+#define CONTEXT_BASE		0x200000
+#define CONTEXT_PER_HART	0x1000
+#define CONTEXT_THRESHOLD	0
+#define CONTEXT_CLAIM		4
+
+#define REG_SIZE		0x1000000
+
+struct plic_state;
+
+struct plic_context {
+	/* State to which this belongs */
+	struct plic_state *s;
+
+	/* Static Configuration */
+	u32 num;
+	struct kvm_cpu *vcpu;
+
+	/* Local IRQ state */
+	struct mutex irq_lock;
+	u8 irq_priority_threshold;
+	u32 irq_enable[MAX_DEVICES/32];
+	u32 irq_pending[MAX_DEVICES/32];
+	u8 irq_pending_priority[MAX_DEVICES];
+	u32 irq_claimed[MAX_DEVICES/32];
+	u32 irq_autoclear[MAX_DEVICES/32];
+};
+
+struct plic_state {
+	bool ready;
+	struct kvm *kvm;
+	struct device_header dev_hdr;
+
+	/* Static Configuration */
+	u32 num_irq;
+	u32 num_irq_word;
+	u32 max_prio;
+
+	/* Context Array */
+	u32 num_context;
+	struct plic_context *contexts;
+
+	/* Global IRQ state */
+	struct mutex irq_lock;
+	u8 irq_priority[MAX_DEVICES];
+	u32 irq_level[MAX_DEVICES/32];
+};
+
+static struct plic_state plic;
+
+/* Note: Must be called with c->irq_lock held */
+static u32 __plic_context_best_pending_irq(struct plic_state *s,
+					   struct plic_context *c)
+{
+	u8 best_irq_prio = 0;
+	u32 i, j, irq, best_irq = 0;
+
+	for (i = 0; i < s->num_irq_word; i++) {
+		if (!c->irq_pending[i])
+			continue;
+
+		for (j = 0; j < 32; j++) {
+			irq = i * 32 + j;
+			if ((s->num_irq <= irq) ||
+			    !(c->irq_pending[i] & (1 << j)) ||
+			    (c->irq_claimed[i] & (1 << j)))
+				continue;
+
+			if (!best_irq ||
+			    (best_irq_prio < c->irq_pending_priority[irq])) {
+				best_irq = irq;
+				best_irq_prio = c->irq_pending_priority[irq];
+			}
+		}
+	}
+
+	return best_irq;
+}
+
+/* Note: Must be called with c->irq_lock held */
+static void __plic_context_irq_update(struct plic_state *s,
+				      struct plic_context *c)
+{
+	u32 best_irq = __plic_context_best_pending_irq(s, c);
+	u32 virq = (best_irq) ? KVM_INTERRUPT_SET : KVM_INTERRUPT_UNSET;
+
+	if (ioctl(c->vcpu->vcpu_fd, KVM_INTERRUPT, &virq) < 0)
+		pr_warning("KVM_INTERRUPT failed");
+}
+
+/* Note: Must be called with c->irq_lock held */
+static u32 __plic_context_irq_claim(struct plic_state *s,
+				    struct plic_context *c)
+{
+	u32 virq = KVM_INTERRUPT_UNSET;
+	u32 best_irq = __plic_context_best_pending_irq(s, c);
+	u32 best_irq_word = best_irq / 32;
+	u32 best_irq_mask = (1 << (best_irq % 32));
+
+	if (ioctl(c->vcpu->vcpu_fd, KVM_INTERRUPT, &virq) < 0)
+		pr_warning("KVM_INTERRUPT failed");
+
+	if (best_irq) {
+		if (c->irq_autoclear[best_irq_word] & best_irq_mask) {
+			c->irq_pending[best_irq_word] &= ~best_irq_mask;
+			c->irq_pending_priority[best_irq] = 0;
+			c->irq_claimed[best_irq_word] &= ~best_irq_mask;
+			c->irq_autoclear[best_irq_word] &= ~best_irq_mask;
+		} else
+			c->irq_claimed[best_irq_word] |= best_irq_mask;
+	}
+
+	__plic_context_irq_update(s, c);
+
+	return best_irq;
+}
+
+void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge)
+{
+	bool irq_marked = false;
+	u8 i, irq_prio, irq_word;
+	u32 irq_mask;
+	struct plic_context *c = NULL;
+	struct plic_state *s = &plic;
+
+	if (!s->ready)
+		return;
+
+	if (irq <= 0 || s->num_irq <= (u32)irq)
+		goto done;
+
+	mutex_lock(&s->irq_lock);
+
+	irq_prio = s->irq_priority[irq];
+	irq_word = irq / 32;
+	irq_mask = 1 << (irq % 32);
+
+	if (level)
+		s->irq_level[irq_word] |= irq_mask;
+	else
+		s->irq_level[irq_word] &= ~irq_mask;
+
+	/*
+	 * Note: PLIC interrupts are level-triggered. As of now,
+	 * there is no notion of edge-triggered interrupts. To
+	 * handle this we auto-clear edge-triggered interrupts
+	 * when PLIC context CLAIM register is read.
+	 */
+	for (i = 0; i < s->num_context; i++) {
+		c = &s->contexts[i];
+
+		mutex_lock(&c->irq_lock);
+		if (c->irq_enable[irq_word] & irq_mask) {
+			if (level) {
+				c->irq_pending[irq_word] |= irq_mask;
+				c->irq_pending_priority[irq] = irq_prio;
+				if (edge)
+					c->irq_autoclear[irq_word] |= irq_mask;
+			} else {
+				c->irq_pending[irq_word] &= ~irq_mask;
+				c->irq_pending_priority[irq] = 0;
+				c->irq_claimed[irq_word] &= ~irq_mask;
+				c->irq_autoclear[irq_word] &= ~irq_mask;
+			}
+			__plic_context_irq_update(s, c);
+			irq_marked = true;
+		}
+		mutex_unlock(&c->irq_lock);
+
+		if (irq_marked)
+			break;
+	}
+
+done:
+	mutex_unlock(&s->irq_lock);
+}
+
+static void plic__priority_read(struct plic_state *s,
+				u64 offset, void *data)
+{
+	u32 irq = (offset >> 2);
+
+	if (irq == 0 || irq >= s->num_irq)
+		return;
+
+	mutex_lock(&s->irq_lock);
+	ioport__write32(data, s->irq_priority[irq]);
+	mutex_unlock(&s->irq_lock);
+}
+
+static void plic__priority_write(struct plic_state *s,
+				 u64 offset, void *data)
+{
+	u32 val, irq = (offset >> 2);
+
+	if (irq == 0 || irq >= s->num_irq)
+		return;
+
+	mutex_lock(&s->irq_lock);
+	val = ioport__read32(data);
+	val &= ((1 << PRIORITY_PER_ID) - 1);
+	s->irq_priority[irq] = val;
+	mutex_unlock(&s->irq_lock);
+}
+
+static void plic__context_enable_read(struct plic_state *s,
+				      struct plic_context *c,
+				      u64 offset, void *data)
+{
+	u32 irq_word = offset >> 2;
+
+	if (s->num_irq_word < irq_word)
+		return;
+
+	mutex_lock(&c->irq_lock);
+	ioport__write32(data, c->irq_enable[irq_word]);
+	mutex_unlock(&c->irq_lock);
+}
+
+static void plic__context_enable_write(struct plic_state *s,
+				       struct plic_context *c,
+				       u64 offset, void *data)
+{
+	u8 irq_prio;
+	u32 i, irq, irq_mask;
+	u32 irq_word = offset >> 2;
+	u32 old_val, new_val, xor_val;
+
+	if (s->num_irq_word < irq_word)
+		return;
+
+	mutex_lock(&s->irq_lock);
+
+	mutex_lock(&c->irq_lock);
+
+	old_val = c->irq_enable[irq_word];
+	new_val = ioport__read32(data);
+
+	if (irq_word == 0)
+		new_val &= ~0x1;
+
+	c->irq_enable[irq_word] = new_val;
+
+	xor_val = old_val ^ new_val;
+	for (i = 0; i < 32; i++) {
+		irq = irq_word * 32 + i;
+		irq_mask = 1 << i;
+		irq_prio = s->irq_priority[irq];
+		if (!(xor_val & irq_mask))
+			continue;
+		if ((new_val & irq_mask) &&
+		    (s->irq_level[irq_word] & irq_mask)) {
+			c->irq_pending[irq_word] |= irq_mask;
+			c->irq_pending_priority[irq] = irq_prio;
+		} else if (!(new_val & irq_mask)) {
+			c->irq_pending[irq_word] &= ~irq_mask;
+			c->irq_pending_priority[irq] = 0;
+			c->irq_claimed[irq_word] &= ~irq_mask;
+		}
+	}
+
+	__plic_context_irq_update(s, c);
+
+	mutex_unlock(&c->irq_lock);
+
+	mutex_unlock(&s->irq_lock);
+}
+
+static void plic__context_read(struct plic_state *s,
+			       struct plic_context *c,
+			       u64 offset, void *data)
+{
+	mutex_lock(&c->irq_lock);
+
+	switch (offset) {
+	case CONTEXT_THRESHOLD:
+		ioport__write32(data, c->irq_priority_threshold);
+		break;
+	case CONTEXT_CLAIM:
+		ioport__write32(data, __plic_context_irq_claim(s, c));
+		break;
+	default:
+		break;
+	};
+
+	mutex_unlock(&c->irq_lock);
+}
+
+static void plic__context_write(struct plic_state *s,
+				struct plic_context *c,
+				u64 offset, void *data)
+{
+	u32 val, irq_word, irq_mask;
+	bool irq_update = false;
+
+	mutex_lock(&c->irq_lock);
+
+	switch (offset) {
+	case CONTEXT_THRESHOLD:
+		val = ioport__read32(data);
+		val &= ((1 << PRIORITY_PER_ID) - 1);
+		if (val <= s->max_prio)
+			c->irq_priority_threshold = val;
+		else
+			irq_update = true;
+		break;
+	case CONTEXT_CLAIM:
+		val = ioport__read32(data);
+		irq_word = val / 32;
+		irq_mask = 1 << (val % 32);
+		if ((val < plic.num_irq) &&
+		    (c->irq_enable[irq_word] & irq_mask)) {
+			c->irq_claimed[irq_word] &= ~irq_mask;
+			irq_update = true;
+		}
+		break;
+	default:
+		irq_update = true;
+		break;
+	};
+
+	if (irq_update)
+		__plic_context_irq_update(s, c);
+
+	mutex_unlock(&c->irq_lock);
+}
+
+static void plic__mmio_callback(struct kvm_cpu *vcpu,
+				u64 addr, u8 *data, u32 len,
+				u8 is_write, void *ptr)
+{
+	u32 cntx;
+	struct plic_state *s = ptr;
+
+	if (len != 4)
+		die("plic: invalid len=%d", len);
+
+	addr &= ~0x3;
+	addr -= RISCV_PLIC;
+
+	if (is_write) {
+		if (PRIORITY_BASE <= addr && addr < ENABLE_BASE) {
+			plic__priority_write(s, addr, data);
+		} else if (ENABLE_BASE <= addr && addr < CONTEXT_BASE) {
+			cntx = (addr - ENABLE_BASE) / ENABLE_PER_HART;
+			addr -= cntx * ENABLE_PER_HART + ENABLE_BASE;
+			if (cntx < s->num_context)
+				plic__context_enable_write(s,
+							   &s->contexts[cntx],
+							   addr, data);
+		} else if (CONTEXT_BASE <= addr && addr < REG_SIZE) {
+			cntx = (addr - CONTEXT_BASE) / CONTEXT_PER_HART;
+			addr -= cntx * CONTEXT_PER_HART + CONTEXT_BASE;
+			if (cntx < s->num_context)
+				plic__context_write(s, &s->contexts[cntx],
+						    addr, data);
+		}
+	} else {
+		if (PRIORITY_BASE <= addr && addr < ENABLE_BASE) {
+			plic__priority_read(s, addr, data);
+		} else if (ENABLE_BASE <= addr && addr < CONTEXT_BASE) {
+			cntx = (addr - ENABLE_BASE) / ENABLE_PER_HART;
+			addr -= cntx * ENABLE_PER_HART + ENABLE_BASE;
+			if (cntx < s->num_context)
+				plic__context_enable_read(s,
+							  &s->contexts[cntx],
+							  addr, data);
+		} else if (CONTEXT_BASE <= addr && addr < REG_SIZE) {
+			cntx = (addr - CONTEXT_BASE) / CONTEXT_PER_HART;
+			addr -= cntx * CONTEXT_PER_HART + CONTEXT_BASE;
+			if (cntx < s->num_context)
+				plic__context_read(s, &s->contexts[cntx],
+						   addr, data);
+		}
+	}
+}
+
+static int plic__init(struct kvm *kvm)
+{
+	u32 i;
+	int ret;
+	struct plic_context *c;
+
+	plic.kvm = kvm;
+	plic.dev_hdr = (struct device_header) {
+		.bus_type	= DEVICE_BUS_MMIO,
+	};
+
+	plic.num_irq = MAX_DEVICES;
+	plic.num_irq_word = plic.num_irq / 32;
+	if ((plic.num_irq_word * 32) < plic.num_irq)
+		plic.num_irq_word++;
+	plic.max_prio = (1UL << PRIORITY_PER_ID) - 1;
+
+	plic.num_context = kvm->nrcpus * 2;
+	plic.contexts = calloc(plic.num_context, sizeof(struct plic_context));
+	if (!plic.contexts)
+		return -ENOMEM;
+	for (i = 0; i < plic.num_context; i++) {
+		c = &plic.contexts[i];
+		c->s = &plic;
+		c->num = i;
+		c->vcpu = kvm->cpus[i / 2];
+		mutex_init(&c->irq_lock);
+	}
+
+	mutex_init(&plic.irq_lock);
+
+	ret = kvm__register_mmio(kvm, RISCV_PLIC, RISCV_PLIC_SIZE,
+				 false, plic__mmio_callback, &plic);
+	if (ret)
+		return ret;
+
+	ret = device__register(&plic.dev_hdr);
+	if (ret)
+		return ret;
+
+	plic.ready = true;
+
+	return 0;
+
+}
+dev_init(plic__init);
+
+static int plic__exit(struct kvm *kvm)
+{
+	plic.ready = false;
+	kvm__deregister_mmio(kvm, RISCV_PLIC);
+	free(plic.contexts);
+
+	return 0;
+}
+dev_exit(plic__exit);
-- 
2.25.1

