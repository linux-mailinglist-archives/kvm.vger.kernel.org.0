Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492296D857E
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjDESBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjDESBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:01:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4D772AB;
        Wed,  5 Apr 2023 11:01:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjNMwqRdGLxzODoF40zrVzQDI4XjC45frrIYPX89CqRHScyfeBhO37Aw4WIRXDJiMEbw9kAF0OzdzxtNupsh9NI+tEWXhcCwHjDXYr7q4b30T1H1FBKyO5lx6susZokR4ZGoAwTMLWmKZyMwSg6JC3PIGTt0xCzOTRtgbZDJz+0gWEW/R60SAj7OnA0XvVsYx2oE1sW0mAtDkza8a4Dng1oTfOcKNUTAEYzDQX3mGk6LrAzs/1vhBv8FdPfg5cItN89o0droKcVpBO7wb08rnrUv7DSu8fHF0Keh7+VWWxRMWo5mV+Tws2FZ9ShT8LdoQ6GBev6Hj6lGtu6ij64z/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixyjebktJREJsrnkZvwgfBAu2SPMa3QRXMAWKUw88R8=;
 b=X2fVm5gI7a+F3xVsXtxPCpbTF7gig3/5sOn8sTBnnbmDucS8JKWJ+33cd8mMgGyop2xU1twW7Q1DbkPitW29xqnwl6iiR3I6W3NC10xH1AXCZynvUT+GM8QSycjseVhUlmOvlmrFL8pTOpC2J5QaN6CRuxtSWPJxPGJ9jm3vFlCU1xJfjgD3h2IHxRR1mPnx5/03dgZL2QUXpAaXBcDQjtZLj4F+cLuOEDvz3mg1NmVbZks+ojdE6c9cLgmNQscDl3yUET83rMhsme6XpJp4MK0dobjvIhBGsUz8s8SAD8hzRcp8B2W+Z63NPeVnn79lSqVSm5qeP73mUXULzf5l5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixyjebktJREJsrnkZvwgfBAu2SPMa3QRXMAWKUw88R8=;
 b=AUky1adre3hnadQ9CFkTpT1NqUR3h5h3O3DB0hxmlprqknWBhJTefWIHvml6SkkfLfbZEA0t2Sh5rjVK14e/GBmQa/1Syp+0/NZJGGIrXV17rMltuTTfgUl/HbH0Pmgse3oZ0NOXpqkgYrYzmyRP0Is7lnXmw1JJfWGT4CaFYndbJBnYGj5M8QGSwOkZoa0/190RFoQ9L1aZNYTs8JwNyTyRIv7t7P/J4N9JNOzBw8Bhi+yYuFlah+Izbwy1GIX7JLS+zdXgntylD6QPDbBxPm8y1CxXQPbtRqcZrQjjbWDpp7j5xxx30wEjfv3X8orbYXDxFs22wNbaiDIsc+pzZg==
Received: from MW4PR04CA0252.namprd04.prod.outlook.com (2603:10b6:303:88::17)
 by DM6PR12MB4169.namprd12.prod.outlook.com (2603:10b6:5:215::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 18:01:46 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::40) by MW4PR04CA0252.outlook.office365.com
 (2603:10b6:303:88::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.29 via Frontend
 Transport; Wed, 5 Apr 2023 18:01:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.30 via Frontend Transport; Wed, 5 Apr 2023 18:01:46 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 5 Apr 2023
 11:01:35 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 5 Apr 2023 11:01:35 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 5 Apr 2023 11:01:35 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <naoya.horiguchi@nec.com>,
        <maz@kernel.org>, <oliver.upton@linux.dev>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
Subject: [PATCH v3 1/6] kvm: determine memory type from VMA
Date:   Wed, 5 Apr 2023 11:01:29 -0700
Message-ID: <20230405180134.16932-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230405180134.16932-1-ankita@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT045:EE_|DM6PR12MB4169:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c10b3d6-9f95-464f-6103-08db35ffd250
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cD44gJ8CMfj/RP+gPq48x8AgtnGDcgbMvl/HPyIaRDasHrowVD2SMju+1vMCWU1iFpEH0LKsAM67a7/a3vbaP0N5actqFMXfAQ3EMBkp6DuOW0OYeYgdNSREiKtYT7Fgw2IZrhNPIkw2ZNKStVWSM1Cd45p5YHjSNkn3k2Ric701jN6OpmY4nUPJPX4AGOqTXiaQI6qOMi0i419J2B4a7qqCvEM3Ow2TKWHx//0man6rNe9ziwKwa+U+YjHMBStWfPQQgoicpvapStHr/BpwU1yRifkEmGABwc28TFJKc9xgZh8HU1EHTfosgLR/m486x9nhYujtdyrttu+Xz/YIm+weKCrexQ/VieMZy4npAoVj3pLfKvvTjBkIZF3v3A8nXtxlK8KrWUFpUj4gFLjKvj577ln4htyWqlfDTo27JqQfGZCkv63z/99BoipfVANZkgxmD/GLtO+TnyQSYtsz/ApMu/heYKpDA6dERuDNPLiyO67ADfv9BDIAzbnuXXzCgI/DHtPoUZVRtnRBFxQKLOZ6rs7yFRtzhk3TEbj1fLmxMrl3Y5CInutsX5bF5IDZk7E4HSPUFrgEmLaW5IQjR6QLNufm1a90U8c+UEtmMTrSly+gMhWj8slhTsID3Jae3rPpwlf8Wi5LJMkqX6gVPNGk7WF04FLlwsfRl+/0DfTJZvpG1UopDNki5F6HKN1FS53vVDSmq0sND1QBwoNbgVEDq1EEjg6BOUwtPP14TIYgJimOXFqSEBiM9luPj0j4eqiIh9J15NeyRdSyfoBNv27N6ZsYH8Yvgc/rqFXRLkItQ2xsGzcfiuI4gh3meKVBv0vQsIA2GrKd1fbsp9S7rw==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(36840700001)(46966006)(40470700004)(54906003)(41300700001)(8936002)(2906002)(316002)(19627235002)(70206006)(5660300002)(4326008)(2876002)(186003)(8676002)(70586007)(478600001)(110136005)(966005)(336012)(6666004)(47076005)(7636003)(356005)(40460700003)(26005)(1076003)(426003)(40480700001)(2616005)(36756003)(83380400001)(82310400005)(82740400003)(86362001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 18:01:46.3535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c10b3d6-9f95-464f-6103-08db35ffd250
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4169
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

Each VM stores the requires pgprots for its mappings in the
vma->pgprot. Based on this we can determine the desired MT_DEVICE_*
for the VMA directly, and do not have to guess based on heuristics
based on pfn_is_map_memory().

There are the following kinds of pgprot available to userspace and their
corresponding type:
pgprot_noncached -> MT_DEVICE_nGnRnE
pgprot_writecombine -> MT_NORMAL_NC
pgprot_device -> MT_DEVICE_nGnRE
pgprot_tagged -> MT_NORMAL_TAGGED

Decode the relevant MT_* types in use and translate them into the
corresponding KVM_PGTABLEPROT_*:

 - MT_DEVICE_nGnRE -> KVM_PGTABLE_PROT_DEVICE_nGnRE (device)
 - MT_DEVICE_nGnRnE -> KVM_PGTABLE_PROT_DEVICE_nGnRnE (noncached)
 - MT_NORMAL/_TAGGED/_NC -> 0

The selection of 0 for the S2 KVM_PGTABLE_PROT_DEVICE_nGnRnE is based
on [2].

Also worth noting is the result of the stage-1 and stage-2. Ref [3]
If FWB not set, then the combination is the one that is more restrictive.
The sequence from lowest restriction to the highest:
DEVICE_nGnRnE -> DEVICE_nGnRE -> NORMAL/_TAGGED/_NC
If FWB is set, then stage-2 mapping type overrides the stage-1 [1].

This solves a problem where KVM cannot preserve the MT_NORMAL memory
type for non-struct page backed memory into the S2 mapping. Instead
the VMA creator determines the MT type and the S2 will follow it.

[1] https://developer.arm.com/documentation/102376/0100/Combining-Stage-1-and-Stage-2-attributes
[2] ARMv8 reference manual: https://developer.arm.com/documentation/ddi0487/gb/ Section D5.5.3, Table D5-38
[3] ARMv8 reference manual: https://developer.arm.com/documentation/ddi0487/gb/ Table G5-20 on page G5-6330

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  8 +++++---
 arch/arm64/include/asm/memory.h      |  6 ++++--
 arch/arm64/kvm/hyp/pgtable.c         | 16 +++++++++++-----
 arch/arm64/kvm/mmu.c                 | 27 ++++++++++++++++++++++-----
 4 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4cd6762bda80..d3166b6e6329 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -150,7 +150,8 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_X:		Execute permission.
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
- * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_PROT_DEVICE_nGnRE:	Device nGnRE attributes.
+ * @KVM_PGTABLE_PROT_DEVICE_nGnRnE:	Device nGnRnE attributes.
  * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
  * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
  * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
@@ -161,7 +162,8 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_W			= BIT(1),
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
-	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+	KVM_PGTABLE_PROT_DEVICE_nGnRE		= BIT(3),
+	KVM_PGTABLE_PROT_DEVICE_nGnRnE		= BIT(4),
 
 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
@@ -178,7 +180,7 @@ enum kvm_pgtable_prot {
 #define PAGE_HYP		KVM_PGTABLE_PROT_RW
 #define PAGE_HYP_EXEC		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_X)
 #define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
-#define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
+#define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE_nGnRE)
 
 typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
 					   enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 78e5163836a0..4ebbc4b1ba4d 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -147,14 +147,16 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL		0xf
+#define MT_S2_DEVICE_nGnRnE 0x0
 #define MT_S2_DEVICE_nGnRE	0x1
 
 /*
  * Memory types for Stage-2 translation when ID_AA64MMFR2_EL1.FWB is 0001
  * Stage-2 enforces Normal-WB and Device-nGnRE
  */
-#define MT_S2_FWB_NORMAL	6
-#define MT_S2_FWB_DEVICE_nGnRE	1
+#define MT_S2_FWB_NORMAL	0x6
+#define MT_S2_FWB_DEVICE_nGnRnE 0x0
+#define MT_S2_FWB_DEVICE_nGnRE	0x1
 
 #ifdef CONFIG_ARM64_4K_PAGES
 #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3d61bd3e591d..7a8238b41590 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -355,7 +355,7 @@ struct hyp_map_data {
 
 static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 {
-	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
+	bool device = prot & KVM_PGTABLE_PROT_DEVICE_nGnRE;
 	u32 mtype = device ? MT_DEVICE_nGnRE : MT_NORMAL;
 	kvm_pte_t attr = FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX, mtype);
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S1_SH_IS;
@@ -636,14 +636,20 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
 static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
 				kvm_pte_t *ptep)
 {
-	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
-	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
-			    KVM_S2_MEMATTR(pgt, NORMAL);
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
+	kvm_pte_t attr;
+
+	if (prot & KVM_PGTABLE_PROT_DEVICE_nGnRE)
+		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
+	else if (prot & KVM_PGTABLE_PROT_DEVICE_nGnRnE)
+		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRnE);
+	else
+		attr = KVM_S2_MEMATTR(pgt, NORMAL);
 
 	if (!(prot & KVM_PGTABLE_PROT_X))
 		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
-	else if (device)
+	else if (prot & KVM_PGTABLE_PROT_DEVICE_nGnRE ||
+		 prot & KVM_PGTABLE_PROT_DEVICE_nGnRnE)
 		return -EINVAL;
 
 	if (prot & KVM_PGTABLE_PROT_R)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ff..8d63aa951c33 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -897,7 +897,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	int ret = 0;
 	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
 	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
-	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE_nGnRE |
 				     KVM_PGTABLE_PROT_R |
 				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
@@ -1186,6 +1186,15 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+/*
+ * Determine the memory region cacheability from VMA's pgprot. This
+ * is used to set the stage 2 PTEs.
+ */
+static unsigned long mapping_type(pgprot_t page_prot)
+{
+	return ((pgprot_val(page_prot) & PTE_ATTRINDX_MASK) >> 2);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1368,10 +1377,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (device)
-		prot |= KVM_PGTABLE_PROT_DEVICE;
-	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
-		prot |= KVM_PGTABLE_PROT_X;
+	switch (mapping_type(vma->vm_page_prot)) {
+	case MT_DEVICE_nGnRE:
+		prot |= KVM_PGTABLE_PROT_DEVICE_nGnRE;
+		break;
+	case MT_DEVICE_nGnRnE:
+		prot |= KVM_PGTABLE_PROT_DEVICE_nGnRnE;
+		break;
+		/* MT_NORMAL/_TAGGED/_NC */
+	default:
+		if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
+			prot |= KVM_PGTABLE_PROT_X;
+	}
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-- 
2.17.1

