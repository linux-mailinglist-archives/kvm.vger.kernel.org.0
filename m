Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB91143B7DA
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 19:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbhJZRGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 13:06:22 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17062 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbhJZRGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 13:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635267836; x=1666803836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=PA7GDKwlJLasY2W15B0xa6XkFtxK+ChuG2avB4JYV78=;
  b=pUX3wKUO6rqkoD2u6RCptsgnAxPu4k8+yV4fPbM0vgi2MGw1q8zVG67G
   TOWIjzdrPXXFrNku1RPcDlSlxcphSgQ5/4MEM2Q+JPmU9tC2Gj1u4wkfi
   aMoetn/wyGl/VB4mSfgXt+cRxAYDIo7B3AsblfmxceyGNf5MMZDZzk6XV
   uUl9U7kcWBYpzPNe0Z29NSkMDa8DrDhjDPp+KtfoD6GVOojlY2oVheLmC
   ILdFLukYzanID7XdO7JyICA4VfKvjZ401wT3puOH80dLMDiAvmQZNciEU
   I+9DdROjgYcONTaaFTcCA4Eq+vBq2df4xX29LWEqqmNgTfBuvT3xX9Mmi
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="295633729"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 01:03:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqVKOLNu+CzxnVINFJNTSbxv55zc+tuKvnGhISvEYbJouCpFmM1tkQ+X8cpU2pvezWCFSTismw0BwQdfKLySkkhkKxHqy26EiOFfl70bW7KKjyfY9OQgq84EHROriF4XUh6awc2BJgzR1Wf2LIHAeOSgI5CmINReqI/WivmcQKFQX67W9NCXy8DK8+weH83wHiweCFidPuC/fqA/M68wll/ZPVB/4x+DZJrn4LanGk3QPjsIPxyEEvvnaPVpAzIVLgs2foPVgYzzS1fVTfH2FVQQCG/pJkjwsBunefiK03wQhBSBY4HcPGkrZKzOa77FfQinSBeqsbQg96Vn+/S7EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDvVFN0WnJt3ekSdSDQMcdfVH2f3SVMHcPQS/onQ5ME=;
 b=e4TTAMAIITw5DW8r0sBJz11oVnxfUtGRiLFMLcF+OO0ZwsHzQIYstHZjhM/5bE5vOkSuBAawAgObaqd8d44JGHFXq7IdElmFQhjQQiGjUfcVyz3W5HIlPHe9n/QgOO2ffAQ/Oya4v2KSpBPzjsp1Whj6TqJ6xVTDH8bsSZdoW9GMx2UiQ5LX4wnj6dsCBkDrJH/2ElQlqf42NhALGrs0cPtUi7XOcoL8J2nlYLhumZPGKLv7pBHV7BqdSA69bW9MU3npzp8keKDh+91PyCQbmZNiCGvPUzBz14vFOXaPlmU2QhU/Ql9m93L2x4cwUcF6T92hm4n23CPefwtiPASAIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDvVFN0WnJt3ekSdSDQMcdfVH2f3SVMHcPQS/onQ5ME=;
 b=u/MJxyqKtB52sz0ScIQEuAUbW7qcDg76bjmJr07ycXYOPSHgwvOZdZivevjwQR4NMBhXx9+5asj/srEdAlLZHN6/lx30JFbesuPaTeRsNqUsXO6LsBMskoOaN+e59Jt3Bqyb3r8VhylxDmg6ZrNlMmyfKt7hufsdrVGM0ZcWKQ4=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8314.namprd04.prod.outlook.com (2603:10b6:303:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 17:03:07 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 17:03:07 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH 2/3] RISC-V: KVM: Factor-out FP virtualization into separate sources
Date:   Tue, 26 Oct 2021 22:31:35 +0530
Message-Id: <20211026170136.2147619-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026170136.2147619-1-anup.patel@wdc.com>
References: <20211026170136.2147619-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::28) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.162.126.221) by MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 17:03:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f37afe9-468a-4f17-93bf-08d998a27b38
X-MS-TrafficTypeDiagnostic: CO6PR04MB8314:
X-Microsoft-Antispam-PRVS: <CO6PR04MB8314B048AD72D9B199C72DB28D849@CO6PR04MB8314.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s0vqPY3xWOZJ8JeWg9bQrLkDX+ktL5LU2LOx7JNPMOTsJHUicZT/7ib7ckeZefKsyKbNfdELi1oM2PZzyRxIoHLMjSV03mIQi+M11VLoEnrNKdVXD6fVG6u6I5tH7PSJKEcJxAqlAAhCsOGvpF14j20NqQNYu5cbcrBaGtyYmsg1tpvv7UcZxvbSLdzcIa+ronqy5IRCJV1xUReL6oJXgimqMKplL5w7oD2VN6fv5SB2qQMS7Y9EfdI7inh0KFQOxXqUgGgXyIEvke73gL0bIs7mYJz/yaOEZkYISUz5HU+LqDhce6R5Z3D786gi8uXXLJeA5rr1agtyYVmRjZWw8OKgNcl0izv/dXl9q3JaAeeyNXT9Bu+idoYxlqTibXIyezvdbu9cjtXeLnVy2c90kPLx85EyPC+EgkY0kvE4urjulWliQrKKnfvM64/cDnaGOOqY3A86yRxp8PvhcqTcv0MAaWqxYahuQSh+4vpQ56Ung8AKGKgt2ZV8V96dBE1WnuYzbwG6MiUoc52JrB7I+YouXAlYDBHyPldxmsQhTmMq8xWYan1K2vaI3yfC8xGkSQjfHZuR1NJdkJqjEx+qOyazNx5iyNwkes/7z6JyN14tifDWV/vX+xC5UPM0GZIWJAIiWz3q5ydD5qAebx20l5pOc9+UJU+kpFnH7nG+HbwPb1xPZbMLn+tQHXn0tdPQdlPtWmwxfIETc/tq98LgXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(4326008)(5660300002)(26005)(44832011)(2906002)(956004)(52116002)(2616005)(8886007)(38350700002)(7696005)(55016002)(83380400001)(186003)(38100700002)(82960400001)(30864003)(54906003)(110136005)(316002)(8676002)(8936002)(7416002)(36756003)(86362001)(66556008)(508600001)(66476007)(66946007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S3QqgXJGcOavHhc/55lWN+pOd05nD8ZGWHE0QiteCEw4unEsEcqIykYmaThk?=
 =?us-ascii?Q?xXEBM3F9r1aWkFiypFy7TKBFZzoPMLa15yW6hJ63LWwpIVIXxfkzntw1gePM?=
 =?us-ascii?Q?hscaZR7p106lH5/PBq2JhSGyjbXEARJcUP+IhavYjQuN3GWw1FqiEh8FoymN?=
 =?us-ascii?Q?5NNmxCnZ1e+Zf/YJSBF7kKuApmtuz7fWQmX7AqR64c1NPj9alHK/4eMgU4y8?=
 =?us-ascii?Q?XalP3oFmlwdrg3xRtouIQT3FU9lddQiNzTjLtnCPX4983BAvIs9EPX07zqMC?=
 =?us-ascii?Q?zokP9UTax+zk33gxzyt8IEwR/ndDTWdL2zjlwxoyAShJYVik228+708MouEb?=
 =?us-ascii?Q?ZiYbHKVdS6jll70CQXe0JSiAccymz56iITlA7otZmWAiQvg0iMmZLoUcfGof?=
 =?us-ascii?Q?RrkMFnyXNaYxwfyEuhfnrbTVYOI9d7pPZeMAoimoIGnn0e/QIlYfSSUjzoqw?=
 =?us-ascii?Q?pAr/y+mY9oA40gkP88FZEqwI1WwuWy7jTHHJpUplyhfExdPOZxx2Hm67snQq?=
 =?us-ascii?Q?cwptqdcnJC2daetbZBnOhdKoaiw9upytjzWjyZaMucJ9fTFZAbWGxzsHRKDs?=
 =?us-ascii?Q?as85BfjqjAeoiYRHkkUOly5KB1g9qNdof8azxQWroAFtyQjIS8rD6FztXG+a?=
 =?us-ascii?Q?d3P/DdnT5n/AbPX7GH2PQ4wme0KvOz/eh0E97c3Ey9ZdqpjUYaMVspd+THjt?=
 =?us-ascii?Q?LD76ruMYokJD96MdKB2N5zriSNSzaxpWjtp4Jh+dt9CoQkbI3lO4YW4/Coe/?=
 =?us-ascii?Q?jEk5IzkHK+c/D/YhnIPuHOj6xREvXxcCBWfVzloDHhcndEYdAI+j7ioV3LXo?=
 =?us-ascii?Q?Kz2RNvyg6IOicEzYnzBPsLz6WTwTA7BKsaXG9EtUOcG5PJnFKajay+IF+mOW?=
 =?us-ascii?Q?qJrFjViMH2i46NRxE54zo25Zz3CyJTX8l51QNbc/YrPKMmsadhiB9vHHkp8p?=
 =?us-ascii?Q?Nt/ddfdEFWLgyqZ9qdLFPG14wHnd4MSfC1odxqtQSfvUynrsqv9zbgIDHXqv?=
 =?us-ascii?Q?73lkkESJLVZLvNmOOvxfTslCjnl1O6JMh43krMBeT+1qwzCUopwKFFEGhcHV?=
 =?us-ascii?Q?yL3ilcNHJxKHK3sPlbZUIwwwxZf2R6XpyQWrnKKXfJloyg0oDviNgS10wHmJ?=
 =?us-ascii?Q?prEokUootVyZYpTp14B4zUmSO/YXpQ2b7PK8NWZnz7eeQe1lPjXEHlnqL2YV?=
 =?us-ascii?Q?x6UBz6uHads2fz7w+BhBP3oQkCfPoTPz+mlxOEScc0Z/My+UPU3WVHY/np1z?=
 =?us-ascii?Q?aM/9llynWzJQ/q9V//TUCR9BG7jJdv2UpnECrBL4IITjeU1J6nzLHAyBOOst?=
 =?us-ascii?Q?Jbdwv9KO3v5P6I9WSnU2NmPU4qiKf2P+VYo2l8iShd9eO1En2hAAcZR4b3Aj?=
 =?us-ascii?Q?0GmKqS4M8w0Wv/7WMt2zXAoo5mRE5MQNsVVsEPcckiGgEjafX1Qig8Bps1mV?=
 =?us-ascii?Q?KGBV83/LPBR3wYD8cdedc36WR8onpdItRUJkfwR/p/Vlo8W6wuMl1EPXf10I?=
 =?us-ascii?Q?9RnjEzqI5ZLNZEX8/rR75911GAl/uGCd64aJYwN/mmoXGrVow1mGqigeQd3P?=
 =?us-ascii?Q?VVrKGHSKDaIKO9lsWCDfribyoOxQuO5pcIM49FROBj017586P4T4R5Tk7K17?=
 =?us-ascii?Q?xIJpKb4VYTq7g1WCyxe7RLE=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f37afe9-468a-4f17-93bf-08d998a27b38
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:03:07.2629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B2AvkFkvFSuZtxPTw9TDbt4Zj6zzMcEZswTtAj/7LTH7/DhQMiyLb9ARjZIi7ZVt125jROnJHefsW1SlWUBO9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8314
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The timer and SBI virtualization is already in separate sources.
In future, we will have vector and AIA virtualization also added
as separate sources.

To align with above described modularity, we factor-out FP
virtualization into separate sources.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h    |   5 +-
 arch/riscv/include/asm/kvm_vcpu_fp.h |  59 +++++++++
 arch/riscv/kvm/Makefile              |   1 +
 arch/riscv/kvm/vcpu.c                | 172 ---------------------------
 arch/riscv/kvm/vcpu_fp.c             | 167 ++++++++++++++++++++++++++
 5 files changed, 228 insertions(+), 176 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_fp.h
 create mode 100644 arch/riscv/kvm/vcpu_fp.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index d7e1696cd2ec..d27878d6adf9 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
+#include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_timer.h>
 
 #ifdef CONFIG_64BIT
@@ -247,10 +248,6 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
 
 void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
-void __kvm_riscv_fp_f_save(struct kvm_cpu_context *context);
-void __kvm_riscv_fp_f_restore(struct kvm_cpu_context *context);
-void __kvm_riscv_fp_d_save(struct kvm_cpu_context *context);
-void __kvm_riscv_fp_d_restore(struct kvm_cpu_context *context);
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
diff --git a/arch/riscv/include/asm/kvm_vcpu_fp.h b/arch/riscv/include/asm/kvm_vcpu_fp.h
new file mode 100644
index 000000000000..4da9b8e0f050
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_fp.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_FP_H
+#define __KVM_VCPU_RISCV_FP_H
+
+#include <linux/types.h>
+
+struct kvm_cpu_context;
+
+#ifdef CONFIG_FPU
+void __kvm_riscv_fp_f_save(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_f_restore(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_d_save(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_d_restore(struct kvm_cpu_context *context);
+
+void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
+				  unsigned long isa);
+void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
+				     unsigned long isa);
+void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx);
+void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx);
+#else
+static inline void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
+{
+}
+static inline void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
+						unsigned long isa)
+{
+}
+static inline void kvm_riscv_vcpu_guest_fp_restore(
+					struct kvm_cpu_context *cntx,
+					unsigned long isa)
+{
+}
+static inline void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
+{
+}
+static inline void kvm_riscv_vcpu_host_fp_restore(
+					struct kvm_cpu_context *cntx)
+{
+}
+#endif
+
+int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
+			      const struct kvm_one_reg *reg,
+			      unsigned long rtype);
+int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
+			      const struct kvm_one_reg *reg,
+			      unsigned long rtype);
+
+#endif
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 3226696b8340..30cdd1df0098 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -20,6 +20,7 @@ kvm-y += tlb.o
 kvm-y += mmu.o
 kvm-y += vcpu.o
 kvm-y += vcpu_exit.o
+kvm-y += vcpu_fp.o
 kvm-y += vcpu_switch.o
 kvm-y += vcpu_sbi.o
 kvm-y += vcpu_timer.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 912928586df9..e3d3aed46184 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -38,86 +38,6 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
-#ifdef CONFIG_FPU
-static void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
-{
-	unsigned long isa = vcpu->arch.isa;
-	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
-
-	cntx->sstatus &= ~SR_FS;
-	if (riscv_isa_extension_available(&isa, f) ||
-	    riscv_isa_extension_available(&isa, d))
-		cntx->sstatus |= SR_FS_INITIAL;
-	else
-		cntx->sstatus |= SR_FS_OFF;
-}
-
-static void kvm_riscv_vcpu_fp_clean(struct kvm_cpu_context *cntx)
-{
-	cntx->sstatus &= ~SR_FS;
-	cntx->sstatus |= SR_FS_CLEAN;
-}
-
-static void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
-					 unsigned long isa)
-{
-	if ((cntx->sstatus & SR_FS) == SR_FS_DIRTY) {
-		if (riscv_isa_extension_available(&isa, d))
-			__kvm_riscv_fp_d_save(cntx);
-		else if (riscv_isa_extension_available(&isa, f))
-			__kvm_riscv_fp_f_save(cntx);
-		kvm_riscv_vcpu_fp_clean(cntx);
-	}
-}
-
-static void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
-					    unsigned long isa)
-{
-	if ((cntx->sstatus & SR_FS) != SR_FS_OFF) {
-		if (riscv_isa_extension_available(&isa, d))
-			__kvm_riscv_fp_d_restore(cntx);
-		else if (riscv_isa_extension_available(&isa, f))
-			__kvm_riscv_fp_f_restore(cntx);
-		kvm_riscv_vcpu_fp_clean(cntx);
-	}
-}
-
-static void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
-{
-	/* No need to check host sstatus as it can be modified outside */
-	if (riscv_isa_extension_available(NULL, d))
-		__kvm_riscv_fp_d_save(cntx);
-	else if (riscv_isa_extension_available(NULL, f))
-		__kvm_riscv_fp_f_save(cntx);
-}
-
-static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx)
-{
-	if (riscv_isa_extension_available(NULL, d))
-		__kvm_riscv_fp_d_restore(cntx);
-	else if (riscv_isa_extension_available(NULL, f))
-		__kvm_riscv_fp_f_restore(cntx);
-}
-#else
-static void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
-{
-}
-static void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
-					 unsigned long isa)
-{
-}
-static void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
-					    unsigned long isa)
-{
-}
-static void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
-{
-}
-static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx)
-{
-}
-#endif
-
 #define KVM_RISCV_ISA_ALLOWED	(riscv_isa_extension_mask(a) | \
 				 riscv_isa_extension_mask(c) | \
 				 riscv_isa_extension_mask(d) | \
@@ -414,98 +334,6 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
-				     const struct kvm_one_reg *reg,
-				     unsigned long rtype)
-{
-	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
-	unsigned long isa = vcpu->arch.isa;
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    rtype);
-	void *reg_val;
-
-	if ((rtype == KVM_REG_RISCV_FP_F) &&
-	    riscv_isa_extension_available(&isa, f)) {
-		if (KVM_REG_SIZE(reg->id) != sizeof(u32))
-			return -EINVAL;
-		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
-			reg_val = &cntx->fp.f.fcsr;
-		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <= reg_num) &&
-			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
-			reg_val = &cntx->fp.f.f[reg_num];
-		else
-			return -EINVAL;
-	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
-		   riscv_isa_extension_available(&isa, d)) {
-		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
-			if (KVM_REG_SIZE(reg->id) != sizeof(u32))
-				return -EINVAL;
-			reg_val = &cntx->fp.d.fcsr;
-		} else if ((KVM_REG_RISCV_FP_D_REG(f[0]) <= reg_num) &&
-			   reg_num <= KVM_REG_RISCV_FP_D_REG(f[31])) {
-			if (KVM_REG_SIZE(reg->id) != sizeof(u64))
-				return -EINVAL;
-			reg_val = &cntx->fp.d.f[reg_num];
-		} else
-			return -EINVAL;
-	} else
-		return -EINVAL;
-
-	if (copy_to_user(uaddr, reg_val, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	return 0;
-}
-
-static int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
-				     const struct kvm_one_reg *reg,
-				     unsigned long rtype)
-{
-	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
-	unsigned long isa = vcpu->arch.isa;
-	unsigned long __user *uaddr =
-			(unsigned long __user *)(unsigned long)reg->addr;
-	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
-					    KVM_REG_SIZE_MASK |
-					    rtype);
-	void *reg_val;
-
-	if ((rtype == KVM_REG_RISCV_FP_F) &&
-	    riscv_isa_extension_available(&isa, f)) {
-		if (KVM_REG_SIZE(reg->id) != sizeof(u32))
-			return -EINVAL;
-		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
-			reg_val = &cntx->fp.f.fcsr;
-		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <= reg_num) &&
-			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
-			reg_val = &cntx->fp.f.f[reg_num];
-		else
-			return -EINVAL;
-	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
-		   riscv_isa_extension_available(&isa, d)) {
-		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
-			if (KVM_REG_SIZE(reg->id) != sizeof(u32))
-				return -EINVAL;
-			reg_val = &cntx->fp.d.fcsr;
-		} else if ((KVM_REG_RISCV_FP_D_REG(f[0]) <= reg_num) &&
-			   reg_num <= KVM_REG_RISCV_FP_D_REG(f[31])) {
-			if (KVM_REG_SIZE(reg->id) != sizeof(u64))
-				return -EINVAL;
-			reg_val = &cntx->fp.d.f[reg_num];
-		} else
-			return -EINVAL;
-	} else
-		return -EINVAL;
-
-	if (copy_from_user(reg_val, uaddr, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	return 0;
-}
-
 static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 				  const struct kvm_one_reg *reg)
 {
diff --git a/arch/riscv/kvm/vcpu_fp.c b/arch/riscv/kvm/vcpu_fp.c
new file mode 100644
index 000000000000..1b070152578f
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_fp.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
+
+#ifdef CONFIG_FPU
+void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
+{
+	unsigned long isa = vcpu->arch.isa;
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+
+	cntx->sstatus &= ~SR_FS;
+	if (riscv_isa_extension_available(&isa, f) ||
+	    riscv_isa_extension_available(&isa, d))
+		cntx->sstatus |= SR_FS_INITIAL;
+	else
+		cntx->sstatus |= SR_FS_OFF;
+}
+
+void kvm_riscv_vcpu_fp_clean(struct kvm_cpu_context *cntx)
+{
+	cntx->sstatus &= ~SR_FS;
+	cntx->sstatus |= SR_FS_CLEAN;
+}
+
+void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
+				  unsigned long isa)
+{
+	if ((cntx->sstatus & SR_FS) == SR_FS_DIRTY) {
+		if (riscv_isa_extension_available(&isa, d))
+			__kvm_riscv_fp_d_save(cntx);
+		else if (riscv_isa_extension_available(&isa, f))
+			__kvm_riscv_fp_f_save(cntx);
+		kvm_riscv_vcpu_fp_clean(cntx);
+	}
+}
+
+void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
+				     unsigned long isa)
+{
+	if ((cntx->sstatus & SR_FS) != SR_FS_OFF) {
+		if (riscv_isa_extension_available(&isa, d))
+			__kvm_riscv_fp_d_restore(cntx);
+		else if (riscv_isa_extension_available(&isa, f))
+			__kvm_riscv_fp_f_restore(cntx);
+		kvm_riscv_vcpu_fp_clean(cntx);
+	}
+}
+
+void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
+{
+	/* No need to check host sstatus as it can be modified outside */
+	if (riscv_isa_extension_available(NULL, d))
+		__kvm_riscv_fp_d_save(cntx);
+	else if (riscv_isa_extension_available(NULL, f))
+		__kvm_riscv_fp_f_save(cntx);
+}
+
+void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx)
+{
+	if (riscv_isa_extension_available(NULL, d))
+		__kvm_riscv_fp_d_restore(cntx);
+	else if (riscv_isa_extension_available(NULL, f))
+		__kvm_riscv_fp_f_restore(cntx);
+}
+#endif
+
+int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
+			      const struct kvm_one_reg *reg,
+			      unsigned long rtype)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long isa = vcpu->arch.isa;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val;
+
+	if ((rtype == KVM_REG_RISCV_FP_F) &&
+	    riscv_isa_extension_available(&isa, f)) {
+		if (KVM_REG_SIZE(reg->id) != sizeof(u32))
+			return -EINVAL;
+		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
+			reg_val = &cntx->fp.f.fcsr;
+		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <= reg_num) &&
+			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
+			reg_val = &cntx->fp.f.f[reg_num];
+		else
+			return -EINVAL;
+	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
+		   riscv_isa_extension_available(&isa, d)) {
+		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
+			if (KVM_REG_SIZE(reg->id) != sizeof(u32))
+				return -EINVAL;
+			reg_val = &cntx->fp.d.fcsr;
+		} else if ((KVM_REG_RISCV_FP_D_REG(f[0]) <= reg_num) &&
+			   reg_num <= KVM_REG_RISCV_FP_D_REG(f[31])) {
+			if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+				return -EINVAL;
+			reg_val = &cntx->fp.d.f[reg_num];
+		} else
+			return -EINVAL;
+	} else
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
+			      const struct kvm_one_reg *reg,
+			      unsigned long rtype)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long isa = vcpu->arch.isa;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val;
+
+	if ((rtype == KVM_REG_RISCV_FP_F) &&
+	    riscv_isa_extension_available(&isa, f)) {
+		if (KVM_REG_SIZE(reg->id) != sizeof(u32))
+			return -EINVAL;
+		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
+			reg_val = &cntx->fp.f.fcsr;
+		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <= reg_num) &&
+			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
+			reg_val = &cntx->fp.f.f[reg_num];
+		else
+			return -EINVAL;
+	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
+		   riscv_isa_extension_available(&isa, d)) {
+		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
+			if (KVM_REG_SIZE(reg->id) != sizeof(u32))
+				return -EINVAL;
+			reg_val = &cntx->fp.d.fcsr;
+		} else if ((KVM_REG_RISCV_FP_D_REG(f[0]) <= reg_num) &&
+			   reg_num <= KVM_REG_RISCV_FP_D_REG(f[31])) {
+			if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+				return -EINVAL;
+			reg_val = &cntx->fp.d.f[reg_num];
+		} else
+			return -EINVAL;
+	} else
+		return -EINVAL;
+
+	if (copy_from_user(reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
-- 
2.25.1

