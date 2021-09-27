Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9318941934B
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbhI0LnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:43:24 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26946 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbhI0LnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:43:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742887; x=1664278887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Be3UnVTwmPovNIhVXpkWx6vxhtvv1cRgrA6Qaxq5NYQ=;
  b=U40n+bEtrcjQflcbYEUi1ib2C9O0Omn7YQR/KbPoLzRg7lJcjr5B4qz6
   L4v7Pj6Wo5rrplcGfc1/u2GSOjsE9dzY4CAW74RdLIVmoLSYAzS0N9A+T
   mbxfzo54rgtLRNl5Qw0wUJs2I+s6lRoJ0d9wsI6smggLp3GKBY7LbAJhe
   ERAYe+StT5M32FwWYV8WXLrcqSHsZQnR/U7GXwmFyyjUVtbvga3ik7Vqf
   Pcrsw4Wvf7DTab7mMQ7k/pkkf6dEO0YPTB5aIVH1xJllav8d/rjqFS4Kj
   yB8fVOmOUiCdHXboXKyJIVHkCdPAcVCNX44pZe5zkslWNLJT3RXUWIKSC
   w==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="180126825"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:41:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9pEUMDeCjbD6/YJqAnjSl4MZGsmWNL276VHKff1p9xBnvjGJdSM5tu2KQLLNbTr7NgEY1qct6MJ7k5nFgCmV3ZWTzMOBhv49JZTe5NE8M47BikY89DvCoiMMbiMFFYCIO4knkkPG6e+7IjPWMDTLshHtBId9ihyPl442kagjjOSBktxw/KCufKz9Rhw/IGFvOIc/+7Jw2SQ6UKzbY7ufSuqB6Z4GFnclwj04ASBD+3xnybb3p+79+3IIxRXcw3gjQ2joDPSY1vK8XhhH76P8+a979S7hVu4WBQ2ybwqz2JTIPJf+1TXu3ac56PdCcSOzn/C56H/98yMqaFOAZaC4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PMKX5kznHeFFOgqGVXRu29DpueXOMn2ZjVDoW5mtCCU=;
 b=kR/9SwFWRoArROSE8d1+fD5fThMlqTQ7o9HRcDOWSFY4KL/4MHJ3POEanhyy0+F2ZvlUBM3DCuGajZ8MVFIoAIM8W8vDS9ugjwQTrTPnjmAPuGLegUDnE4Y1+nqCAuWK1gXGmoIycnuZZc9FLKq3NXx8nprRNe1FFn9qvCBfDjXrDh34eI/LYTJa8oYSJPOW3OjDCKeGJrbu9qHBuPIz8DRVa/9ckk0atemAp9bjbVcid/QFdQ0JqDjyQYiH+kVBqRirHY4igH477L3b+MCyAAt9nQ7RC2FhS6vT/eqSwjxcQyNDONRjrTSjUGbwCscAP/pPHpxtjP8e90u/jMvUiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMKX5kznHeFFOgqGVXRu29DpueXOMn2ZjVDoW5mtCCU=;
 b=vMhcdj2rb0Qpr6PC2T9DiQwJAz5NhIzpJPAonDqTWS1YdlmOBKcPVdbsR5PmiKEfopgshI/81AdUHHyVAk4Z1M/+VdV+KsvIyRDgU/1tm08B6rxhs6kWY2+PtstRXIUrfs70hKHtI8sjHpRwbQZStsThJB24pBolDWtwvpY8zqg=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:41:24 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:41:24 +0000
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
Subject: [PATCH v20 09/17] RISC-V: KVM: Implement VMID allocator
Date:   Mon, 27 Sep 2021 17:10:08 +0530
Message-Id: <20210927114016.1089328-10-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:41:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdffc372-04f0-4185-89cb-08d981abbbea
X-MS-TrafficTypeDiagnostic: CO1PR04MB8236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB8236A3476599101C6CAD13F88DA79@CO1PR04MB8236.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zzusqJgtzi2cxgt1Q6n0RnaeO8X3Bhk9cXmgnJ2vCmDSNO2MHkiY639thuGf5+UJYsfLjxcoX2MVwPDk6T9FNwHDv9mF/k3L4ibfs5cLXbrrRh+EqWNCcEiAwrZ2KpowmaGYxQpX3Y9fkina3rGiLJci2JFvar+mL2QpWlcYvdmrHHXFIeWue/NQsa01IvtOxdR0uwB4KE3uqBz4V6ABXADeBlym6hKbRLlE7BbiHurp7nqzoAmA7mAbwqrGdW4d1rH1t40hT1Jwo4LBXfQD0hK3zuWirXIUnd5WKTl25ygDV/f7poENzUfXilb8nsOZTFUzMHDbPdbUwQCNNKRrm0fHGsiUXtYx2/3oF32sQHXvkex9iVSb/mutZU7PH/rXnib66eMVuD7biXhH+l9mEk4t4cKemnrWuiFUQUTsaqJXhyJlBaZ3obu/Ch/VeCgu5azyx53nUtMQRgyvd7S93ZoN9TG+5/AGmf/WYpN7T1sZVszRtAlcVSILInffQh7cDoQ+dL8Rdqc7HXKPPLSjla4Iy/QzAeTltUWAEBKA8XvXdeWHwieaKfPkH2nPhLIzDJXCs+FL8v6A4XoNrKnSI2W/Q4M7agm8KB9qwUe/wYK5dhm/8UWf8hdHcaqiD4FRqylFXpkdfP14K9jIzguKgt49STQfdZtVcylAT0hRMq1cqy72OMqXJ6/zMS/iDkml
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66946007)(44832011)(38100700002)(54906003)(110136005)(186003)(55016002)(38350700002)(8936002)(508600001)(7696005)(6666004)(1076003)(36756003)(66476007)(66556008)(4326008)(2616005)(5660300002)(86362001)(2906002)(8676002)(8886007)(52116002)(7416002)(26005)(83380400001)(30864003)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nlyxmBVUsNkyUgNrbFbHTTINQUG6r3s/PSmlqSw9wQwT8mubzs9DMAu+8xhS?=
 =?us-ascii?Q?vg2hYM2fmgdPYTyILMnYw0zanmZ0omWKwXiIiIxV7wFjsDMjvEOND4Mcb3fX?=
 =?us-ascii?Q?5nGFBfyR7o6Xie1/+U2O+Jew2ZTSpbCIanpdK9rHKCSntqA0zsk2mpK8ZYhT?=
 =?us-ascii?Q?+RGDktN3Wg3BUT6kiSaUDDKcODz5hCi79zqlx3duqWDjyCUFTt4X0scKm7gH?=
 =?us-ascii?Q?NBkjR3smvl9Af4CaBgatkEe06eTlmE/zc4Lk3NK4IUl2L1xBLbbJUZitdM0J?=
 =?us-ascii?Q?V2hv9pWP+Wr5oXAIK8cKwtnXq/qtFMHl0kpIZbE09ubQo9qIlvOdEN3FFp4w?=
 =?us-ascii?Q?8muLoNtUBKBBTnWEJfCTdOXn0GuFVTRO067cthpIi3QpPStDUjf/OzbOPNCx?=
 =?us-ascii?Q?xmZkt7rrZzWVRnddLLNmMbZNDOxYtTqSIt9/6+rIMeeB0NyBnIa6PnSYLiMd?=
 =?us-ascii?Q?Ci/YEvkySMkpGj7YyT6QUjgvILXN5juN69pRz+jQ3weh1puDJj5Grmq0R9fo?=
 =?us-ascii?Q?fWp+Kmv+O28fNSLk63KcPQ+XPnYw9213gcWH2J1rL2KQqyvK1/ybHokoxVAN?=
 =?us-ascii?Q?2FDn82+j2QyWgZJ2zf1m6VjqzGxS1PqyXxgUOAtf/a6NNKzRbUV6y7Ly/yfV?=
 =?us-ascii?Q?IQjJNkObVHNU9r3qhNy/7j6wP5ASFjYhOrWpsGT9BeZAD7cH9U7rrIS3SHl4?=
 =?us-ascii?Q?Zh0fOSa9PQMVt4RehtTM2m1V7eWHt7a8dPVm9Q97S2ovy+ZE0DCDyQ67vTc0?=
 =?us-ascii?Q?ZcYWrOtPIIFn9KvF+XBCmXoyd2QeDQgbvne6QoO53W8mGG/VVCATwn9Mgfmw?=
 =?us-ascii?Q?XjiMAs9m1udFX2fVNkD3X/AEr1kMrooKLXaw0cbDjEgyFI+grahVStzASXUV?=
 =?us-ascii?Q?YIlA1nRW3GRpYoDKa/qyom9cy9DD46K6IGABcJFBOvAwngXGQGTG2WJRzy2c?=
 =?us-ascii?Q?ImFppeSI41pCr/K5lNp4G1FPQW4GuiQHKg3WRg9WZe6uvbQjZv/Sq2ouOoM7?=
 =?us-ascii?Q?yDydSrB79At7WTAG9BC5+KOCTOQARm6APUQZDmtOzLS789nda78tpBwallFX?=
 =?us-ascii?Q?zObRQ8FkTDxZ3nXPD5W9zwS404yLpz6cKsE10fwWxUv589YoCrPiFIzNbNei?=
 =?us-ascii?Q?uolbxaUQuogTI27n/MX8xqstqDnvF2/uNWG2x2DTmcgzhVRWn4Lg+vxzMZ5Y?=
 =?us-ascii?Q?9OzJlcMDmaJaDNnziX7zWxi3L05WYV79mqDkkOtm7+65LfkhUAqYNMfBn2ah?=
 =?us-ascii?Q?DPrxDvLXJDFxAyPU+Q4CmnUVC6aTcEms7BniN6ETU9i90WywMRm7b7uSBy0y?=
 =?us-ascii?Q?RIOpxvwLM7D6QKODN+cIikqA?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdffc372-04f0-4185-89cb-08d981abbbea
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:41:24.3459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5vGdoqB238g2lb7FoLm42jRT4r9E860+UQf0CO9KtnQWvHVTEAlBLYdl0S7hQ1ClBiSYBlsylWWKdxE7T5hlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement a simple VMID allocator for Guests/VMs which:
1. Detects number of VMID bits at boot-time
2. Uses atomic number to track VMID version and increments
   VMID version whenever we run-out of VMIDs
3. Flushes Guest TLBs on all host CPUs whenever we run-out
   of VMIDs
4. Force updates HW Stage2 VMID for each Guest VCPU whenever
   VMID changes using VCPU request KVM_REQ_UPDATE_HGATP

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |  24 ++++++
 arch/riscv/kvm/Makefile           |  14 +++-
 arch/riscv/kvm/main.c             |   4 +
 arch/riscv/kvm/tlb.S              |  74 ++++++++++++++++++
 arch/riscv/kvm/vcpu.c             |   9 +++
 arch/riscv/kvm/vm.c               |   6 ++
 arch/riscv/kvm/vmid.c             | 120 ++++++++++++++++++++++++++++++
 7 files changed, 249 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/vmid.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 88b2f21efed8..69c342430242 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
+#define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
 
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
@@ -43,7 +44,19 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_vmid {
+	/*
+	 * Writes to vmid_version and vmid happen with vmid_lock held
+	 * whereas reads happen without any lock held.
+	 */
+	unsigned long vmid_version;
+	unsigned long vmid;
+};
+
 struct kvm_arch {
+	/* stage2 vmid */
+	struct kvm_vmid vmid;
+
 	/* stage2 page table */
 	pgd_t *pgd;
 	phys_addr_t pgd_phys;
@@ -173,6 +186,11 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa, unsigned long vmid);
+void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
+void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
+void __kvm_riscv_hfence_gvma_all(void);
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write);
@@ -181,6 +199,12 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
 
+void kvm_riscv_stage2_vmid_detect(void);
+unsigned long kvm_riscv_stage2_vmid_bits(void);
+int kvm_riscv_stage2_vmid_init(struct kvm *kvm);
+bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid);
+void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu);
+
 void __kvm_riscv_unpriv_trap(void);
 
 unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 1e1c3e1e4e1b..a0274763e096 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -9,5 +9,15 @@ KVM := ../../../virt/kvm
 
 obj-$(CONFIG_KVM) += kvm.o
 
-kvm-y += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/binary_stats.o \
-	 $(KVM)/eventfd.o main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-y += $(KVM)/kvm_main.o
+kvm-y += $(KVM)/coalesced_mmio.o
+kvm-y += $(KVM)/binary_stats.o
+kvm-y += $(KVM)/eventfd.o
+kvm-y += main.o
+kvm-y += vm.o
+kvm-y += vmid.o
+kvm-y += tlb.o
+kvm-y += mmu.o
+kvm-y += vcpu.o
+kvm-y += vcpu_exit.o
+kvm-y += vcpu_switch.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 47926f0c175d..49a4941e3838 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -79,8 +79,12 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	kvm_riscv_stage2_vmid_detect();
+
 	kvm_info("hypervisor extension available\n");
 
+	kvm_info("VMID %ld bits available\n", kvm_riscv_stage2_vmid_bits());
+
 	return 0;
 }
 
diff --git a/arch/riscv/kvm/tlb.S b/arch/riscv/kvm/tlb.S
new file mode 100644
index 000000000000..c858570f0856
--- /dev/null
+++ b/arch/riscv/kvm/tlb.S
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+
+	.text
+	.altmacro
+	.option norelax
+
+	/*
+	 * Instruction encoding of hfence.gvma is:
+	 * HFENCE.GVMA rs1, rs2
+	 * HFENCE.GVMA zero, rs2
+	 * HFENCE.GVMA rs1
+	 * HFENCE.GVMA
+	 *
+	 * rs1!=zero and rs2!=zero ==> HFENCE.GVMA rs1, rs2
+	 * rs1==zero and rs2!=zero ==> HFENCE.GVMA zero, rs2
+	 * rs1!=zero and rs2==zero ==> HFENCE.GVMA rs1
+	 * rs1==zero and rs2==zero ==> HFENCE.GVMA
+	 *
+	 * Instruction encoding of HFENCE.GVMA is:
+	 * 0110001 rs2(5) rs1(5) 000 00000 1110011
+	 */
+
+ENTRY(__kvm_riscv_hfence_gvma_vmid_gpa)
+	/*
+	 * rs1 = a0 (GPA)
+	 * rs2 = a1 (VMID)
+	 * HFENCE.GVMA a0, a1
+	 * 0110001 01011 01010 000 00000 1110011
+	 */
+	.word 0x62b50073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_vmid_gpa)
+
+ENTRY(__kvm_riscv_hfence_gvma_vmid)
+	/*
+	 * rs1 = zero
+	 * rs2 = a0 (VMID)
+	 * HFENCE.GVMA zero, a0
+	 * 0110001 01010 00000 000 00000 1110011
+	 */
+	.word 0x62a00073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_vmid)
+
+ENTRY(__kvm_riscv_hfence_gvma_gpa)
+	/*
+	 * rs1 = a0 (GPA)
+	 * rs2 = zero
+	 * HFENCE.GVMA a0
+	 * 0110001 00000 01010 000 00000 1110011
+	 */
+	.word 0x62050073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_gpa)
+
+ENTRY(__kvm_riscv_hfence_gvma_all)
+	/*
+	 * rs1 = zero
+	 * rs2 = zero
+	 * HFENCE.GVMA
+	 * 0110001 00000 00000 000 00000 1110011
+	 */
+	.word 0x62000073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_all)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 64f74290a90f..dfe479d9f564 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -622,6 +622,12 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_riscv_reset_vcpu(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
+			kvm_riscv_stage2_update_hgatp(vcpu);
+
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
+			__kvm_riscv_hfence_gvma_all();
 	}
 }
 
@@ -667,6 +673,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/* Check conditions before entering the guest */
 		cond_resched();
 
+		kvm_riscv_stage2_vmid_update(vcpu);
+
 		kvm_riscv_check_vcpu_requests(vcpu);
 
 		preempt_disable();
@@ -703,6 +711,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		kvm_riscv_update_hvip(vcpu);
 
 		if (ret <= 0 ||
+		    kvm_riscv_stage2_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index ad38c575c0bd..42e75dc8ab06 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -41,6 +41,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (r)
 		return r;
 
+	r = kvm_riscv_stage2_vmid_init(kvm);
+	if (r) {
+		kvm_riscv_stage2_free_pgd(kvm);
+		return r;
+	}
+
 	return 0;
 }
 
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
new file mode 100644
index 000000000000..2c6253b293bc
--- /dev/null
+++ b/arch/riscv/kvm/vmid.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/cpumask.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/sbi.h>
+
+static unsigned long vmid_version = 1;
+static unsigned long vmid_next;
+static unsigned long vmid_bits;
+static DEFINE_SPINLOCK(vmid_lock);
+
+void kvm_riscv_stage2_vmid_detect(void)
+{
+	unsigned long old;
+
+	/* Figure-out number of VMID bits in HW */
+	old = csr_read(CSR_HGATP);
+	csr_write(CSR_HGATP, old | HGATP_VMID_MASK);
+	vmid_bits = csr_read(CSR_HGATP);
+	vmid_bits = (vmid_bits & HGATP_VMID_MASK) >> HGATP_VMID_SHIFT;
+	vmid_bits = fls_long(vmid_bits);
+	csr_write(CSR_HGATP, old);
+
+	/* We polluted local TLB so flush all guest TLB */
+	__kvm_riscv_hfence_gvma_all();
+
+	/* We don't use VMID bits if they are not sufficient */
+	if ((1UL << vmid_bits) < num_possible_cpus())
+		vmid_bits = 0;
+}
+
+unsigned long kvm_riscv_stage2_vmid_bits(void)
+{
+	return vmid_bits;
+}
+
+int kvm_riscv_stage2_vmid_init(struct kvm *kvm)
+{
+	/* Mark the initial VMID and VMID version invalid */
+	kvm->arch.vmid.vmid_version = 0;
+	kvm->arch.vmid.vmid = 0;
+
+	return 0;
+}
+
+bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid)
+{
+	if (!vmid_bits)
+		return false;
+
+	return unlikely(READ_ONCE(vmid->vmid_version) !=
+			READ_ONCE(vmid_version));
+}
+
+void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_vcpu *v;
+	struct cpumask hmask;
+	struct kvm_vmid *vmid = &vcpu->kvm->arch.vmid;
+
+	if (!kvm_riscv_stage2_vmid_ver_changed(vmid))
+		return;
+
+	spin_lock(&vmid_lock);
+
+	/*
+	 * We need to re-check the vmid_version here to ensure that if
+	 * another vcpu already allocated a valid vmid for this vm.
+	 */
+	if (!kvm_riscv_stage2_vmid_ver_changed(vmid)) {
+		spin_unlock(&vmid_lock);
+		return;
+	}
+
+	/* First user of a new VMID version? */
+	if (unlikely(vmid_next == 0)) {
+		WRITE_ONCE(vmid_version, READ_ONCE(vmid_version) + 1);
+		vmid_next = 1;
+
+		/*
+		 * We ran out of VMIDs so we increment vmid_version and
+		 * start assigning VMIDs from 1.
+		 *
+		 * This also means existing VMIDs assignement to all Guest
+		 * instances is invalid and we have force VMID re-assignement
+		 * for all Guest instances. The Guest instances that were not
+		 * running will automatically pick-up new VMIDs because will
+		 * call kvm_riscv_stage2_vmid_update() whenever they enter
+		 * in-kernel run loop. For Guest instances that are already
+		 * running, we force VM exits on all host CPUs using IPI and
+		 * flush all Guest TLBs.
+		 */
+		riscv_cpuid_to_hartid_mask(cpu_online_mask, &hmask);
+		sbi_remote_hfence_gvma(cpumask_bits(&hmask), 0, 0);
+	}
+
+	vmid->vmid = vmid_next;
+	vmid_next++;
+	vmid_next &= (1 << vmid_bits) - 1;
+
+	WRITE_ONCE(vmid->vmid_version, READ_ONCE(vmid_version));
+
+	spin_unlock(&vmid_lock);
+
+	/* Request stage2 page table update for all VCPUs */
+	kvm_for_each_vcpu(i, v, vcpu->kvm)
+		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
+}
-- 
2.25.1

