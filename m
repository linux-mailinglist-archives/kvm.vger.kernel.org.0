Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0FF3D6E64
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbhG0F4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:56:20 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33058 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbhG0Fz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365356; x=1658901356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=MWr5rrI8jNn37iU2MrQe64a92+sTKiOpR90tGJa5lZ0=;
  b=V7bu8Zie/ZPqIxzfPTuT9R4YmZijTzwqaR+6cQMQWdD9UmJTqLCEw2rH
   tHs+tT9/8PNg0EC5+GZgVwTxkcol79Z3FIacF7xlrpkm6sugH+F/KesEW
   SbtMN79uUfEbl3aGvhErf8zoRgAIpSGFSxGvqWpLTnfgMQ9WFAyoUuhD0
   P3gtJbwZmNMz5G49LnTiZAEinvLwG/HcPfcVJM7jz1MvyiQXohsLYzoTx
   23JT3LS6PbXdogmayw8sZqAXSQwWgV0vaCloWM+mduazXyBBKaA/E4K4C
   GTTQM3o82h6N/JbPbiVnoK+vlnd1YM0n+EyhzS51WKdISJxo9eo3r9f//
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="180385906"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:55:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDY9myPUp+b0Q3WgvH8FsCC0evklnBH1uxKt7MsXIueFRtSNVzFLxPFEReJPc1LZ0BMmIsEYeictw7T0+xYy9SDFmmv+JJXoQe8znnVVxMM73HTyl8FF+hPzvSWM1ZnSJPo5cSuW/X6Fsq3BzUiXG4+leRBnhraggxTVv440Z+mQt2y/XRhzq1yGT7bbQ1PgZFHdIovLut6PvbMGlQmFbOPLMM3915EhYxJ4udZBtX00gBQnKfQfRZRO6Eet22w2WDiV1u+GHYbefZ9K7RmiwQcsvK3Ml8h0tP8qzlzfH26logc6xMClQXZKnl8qWop9YeytN0mghPe9tzLgpMmThw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qri+TduEj/yllXokPXLDtqp8di8LwcB9+HLFiYxELM=;
 b=lShWcemM0VCuEVztAFihl4CtJyDBex2gwr92+en+d+2GSCtrHYC0/6g4DLJh0/2x922AWgycfhCRBEWxkAe+UFUh+fesNoXYgGlKZX6WQ40/tJObyoLW6pi0UM031xnb+QCaCnslrGgdxEMXx2DqsrtBdQwsPldPGTF1rhrFSP8sqBXqE3S2XUhyHHmDTMl19BjwN0i8qaLeFCYXxYnquFM3mRWj3uaQO3hoAivbit24HYHIGqCAtLDdqqoR0XIgumlGsLar5CtunNkE/KXy9cdH2nHGA0jE0gKcQLPUYdZGZZnqa92r0RI5B5Q7UQ8I7BsMZCrHEvAyIks1lLQJww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qri+TduEj/yllXokPXLDtqp8di8LwcB9+HLFiYxELM=;
 b=clQlI/BFoElnBk3diZcgwzgFtVZIQYFuJmJa4b+AMlcYsjHd/oLve9xQnwcXvNeCMa6aT+mAJoxldA4I27tAwGCTFMF9itwyJELibsveDHBopOz9L49bk/XI6tL58g3DtNFDUUopgTtRZGkKZ+QQ52GbtikHu4QTVZIU3I/ogiA=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 05:55:56 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:55:56 +0000
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
Subject: [PATCH v19 09/17] RISC-V: KVM: Implement VMID allocator
Date:   Tue, 27 Jul 2021 11:24:42 +0530
Message-Id: <20210727055450.2742868-10-anup.patel@wdc.com>
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
Received: from wdc.com (122.171.179.229) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 05:55:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f6fb120-17f7-42e3-5f88-08d950c33378
X-MS-TrafficTypeDiagnostic: CO6PR04MB8377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB8377BD828995D85BEBE45EF28DE99@CO6PR04MB8377.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u/crpgIkZfK1N0AUWXykuNoFbhrPTqkqZ5J68hHZbA9CSJ6jGM83OCjQHxyZnnqpAN9E1UR2WjKmlv6+EIgvzcz3y5zfpvgrx3HGDIL0jckfVkZqG/N19VrnYG7BfzijgBohHwaf8DHfORuj1fquaDPezCGB384maImcJOt4fIXUtPBdNx+07hITgkkxXFsCFKr0BGTjO4AK3VacoeLfdh6iQn8+SgobDBOWJ5fPz2U0F1rcSGhAtAIanl7Tkipwp/yOmYRrp4i5MHO5i3M3YijC4AlkfdhE7oRzMQAHJQwQJ9/8gz7eLjTHoi+zAo/p+RZPSMY5/zcNpzjXmwpzTf+h99AQo3EBl2wAk2sWNneUu6ZTe6PIDWv3kxOlcvEQkqDSL3EENmpHezxkmTe9qetmbaPcdE7qN8zJGuU8NMKQ1O8dKPP30v66iL/4tnNBlcY5OY+i584f1TaNd3+j8zuP/DFoBXUqL/5TZoAi35IvYubcog2gbRg1rCMDB0r1NEewJMkdjSBbWbdP/v9jKn/mVeeb+cANveOEbOi61PM4d3jSH4HASPj1IOSiGe/bLNlV4bR8ynMRWakeFh+GdN2EUYCoiQSSu5u0Q7SgWk13DKrM4Ypu47upqWCqc8Rtb0uECSKHXWNFbIz93ZgOEjvKpt1TtXl8Q8BCThp8K9b300ekevN/i8EvWQwxJ67f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(52116002)(26005)(66946007)(54906003)(5660300002)(6666004)(956004)(2616005)(8936002)(186003)(38100700002)(316002)(36756003)(508600001)(8886007)(7416002)(66476007)(2906002)(1076003)(110136005)(86362001)(30864003)(44832011)(83380400001)(8676002)(4326008)(66556008)(55016002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3ErhBvqUC6q1hA8qnf76Pok2DsVeNsUqNlCZj2OLZsYQhXCca/Raqo0AYFdn?=
 =?us-ascii?Q?EsUCfOgGgg+dOvk+woxwTXm9B0kmg3qqGaWZXBpz/m6ItCoBbiMeKP5fP4Di?=
 =?us-ascii?Q?wPxqRmcIRLneJBWFonLmjcm3ZJdKW1BcbhVguDjzoXtUGMfIK9eo8j02lMSV?=
 =?us-ascii?Q?j8lwqbVV+Z4jgruAzusIn4l91nLFPoC3qq0lCJNwm9XLX09rwhtD+igKd5ER?=
 =?us-ascii?Q?m0eD8ZbaAeaetDz4fNubNiwHSwGalIyEr1KVnIbxg8nywf1YOe2vqQT4gO8k?=
 =?us-ascii?Q?wvw8gMSG+pk0U2IUg7Pkz+r9E5v49DuqaVuQVihbMPvnLBumWOwLKLeBLFw1?=
 =?us-ascii?Q?k4Ldh8vG3aKTJKAwqG/Gg2+FENcCbOge5G8dMBovj25LeivqvAPZ2Jt1dxlC?=
 =?us-ascii?Q?MMztGMb1YcyUeGl5mHdKx0xHilSbRksabMpyZmDLzosFhjJrAI/vqO9Uaxzi?=
 =?us-ascii?Q?heZ1fN3UFOA2mJkvoinCj+S0/6aknVF6qodFx5vYx85h811AVBehZPOltfC+?=
 =?us-ascii?Q?8QekX7zwoWQ3/vCCRvNc3ZUGY025YKr6SD6vv+Zo3kHlo4z1j6pKL2FK0ZJN?=
 =?us-ascii?Q?pCjZdL3A16ojBRKUpJvfji8ZCOZkCG5NpbJS7sn2Agz0LS3cED5LWmkS+P8z?=
 =?us-ascii?Q?kL52haLkM6tdYqYXnsBJ3OqpO4htWndeJwcZr0kiGVEMtaKKWbayvSZLkTyZ?=
 =?us-ascii?Q?810OygxxMOv58Mo+7hEjzclU6Cd/btOILmW3JhZamuHqqxCimPh1a3HZs3Cp?=
 =?us-ascii?Q?IZl9IAm3DPN06fA38A1QvEKdabtdcgCHyXIh1lKKHDMEbhHhBQOyVCK2oFlR?=
 =?us-ascii?Q?9VoH3RMS3sOjA1E+cWAXMJ6dWjaersUD7t6b9CUMY58WG2oBsS57DjtIb6Zv?=
 =?us-ascii?Q?hg4Dhr74NWeDOrGxgzPKxDGmV3z8DlVzqJRERde7Cr0J+gP3SuxG/IgQIVLs?=
 =?us-ascii?Q?h62ESA34tW4zb2sGLmcTIeUI8EAU5uc+UhfbYveobH9wR9P67xKMNKE+fg9T?=
 =?us-ascii?Q?iwUZ9w05XhkahdhPDY5uMA4514kyRsUz1TTiWZUPitlCxyQ8//DbZBoNujD/?=
 =?us-ascii?Q?gy1jmaVrhS5RJMYiGFaRdSZb/5jI/3ektMHsSAmNBGdBhzIovGcm4QEqANMd?=
 =?us-ascii?Q?f4A3iPvrYi7eoNLHPPp3loiRpquiououlzjwCjwuihiN7fp24lnsIOgsxxoh?=
 =?us-ascii?Q?AnG+jVV14tF/xV0w+Oi7O5Ii3HU+efcshP4BDum9S3slh7eHVkhEMENZCydl?=
 =?us-ascii?Q?sb+nqSSQViax67m46CSnYmcsa/R4IgXNpxrQl5COQmA5jcnfor1qDdQJ4BGO?=
 =?us-ascii?Q?Uh/lidc0mSfOydcYkpy2GqJJ?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f6fb120-17f7-42e3-5f88-08d950c33378
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:55:56.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UynqlrQWC0NWGRIDf7lXO75M9/+jndfwan1e8d9CSS4d5dGxMSXPq9lIeBKkM3ygmEz1c5TzfB/i/YN9ImYRBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
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
index dc5ea380178a..51e48e70522e 100644
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
index 91135e12caf6..e565bb158172 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -627,6 +627,12 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 
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
 
@@ -672,6 +678,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/* Check conditions before entering the guest */
 		cond_resched();
 
+		kvm_riscv_stage2_vmid_update(vcpu);
+
 		kvm_riscv_check_vcpu_requests(vcpu);
 
 		preempt_disable();
@@ -708,6 +716,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		kvm_riscv_update_hvip(vcpu);
 
 		if (ret <= 0 ||
+		    kvm_riscv_stage2_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index d96d8d0f1ef2..a42559ed48c1 100644
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

