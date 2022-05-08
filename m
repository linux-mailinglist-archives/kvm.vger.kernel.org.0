Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F09651EAF9
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390636AbiEHCnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiEHCnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4C811144;
        Sat,  7 May 2022 19:39:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORduTvm426e7XobvZLyrvPoVlHzIHXLodgdJOaHiFICDIpCorshsYqPUaFvcmDORcwOUa/ZUGzE9KbCrmW5/vi4OfZ2EMvdV80ojQQ/+z5C5ZlC5+8sJsC2fbv/aRrVB/TpjRlFDTgbyA94hyLGtkYNpxBj2u+tb9AX9jviTMaqLLUUacfTEzvqj5DFa3Xk+2sWh97xdg9aeLSX+9X6bNIDgxx3/lZ0f7CnBGRhbFUr9rJVoNeisKI6PMbUBgJjiNFWGsRiQwBmh8kkho3gjN8X+t1lVAiUmingmX1Gw6j1A27yfn2hdYXgJPi7BulyauU0aQxc0pL79houFUOMJXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUwb6mBBN0KdHYBzaBuzqhj1XLsjUZTpdqob3bf9pHg=;
 b=a97SUbEhorIrzD8tmuAdW/p+6RKBrFF9v0lFrIXF8MsGTuZe56WmULq4u2DzUr/CQpZ8VOxyjOSUIqEVQt22KKvQC6PuSCO/O5SklNOiR6jWPcNHfrsvYWn69TjLMMGgFOEV+AFgLKf2a/X+LhQgCY1BZ68ENrr7xB6v5gVFf2w8edbn8iOIGftdYVOTXhCuRDEnWqJaQzVtfjiMgDEwXvAmHhO7Sr2LijcIiS8EUvv3rs3cLXBaeE58CalWMfJfwypDnYl1PW3tyxBr2QMs7N9p3qqr3bL5sfHls6YKS+G7plLJ5pvYYNXASciZ2mz02T6pK79ZN2K15Y7sRu+bEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUwb6mBBN0KdHYBzaBuzqhj1XLsjUZTpdqob3bf9pHg=;
 b=hsGjm+i6SBV3ykQv4mG/xKHQP1BBZn+FL/U+ugNjNhBtluPSdJ/hKwJwDRnbIZGYJZ5Gzt0i3yg9GLqZBxGhafJpAq3wCj6KrkWSqX/Ru6ZjCvVUw94rNBIoKEqOyY6Uh8e3b8UPOSD9c43zQdqwiRIJ5aR4RywPx9BW3cATFA8=
Received: from MW4P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::17)
 by DM5PR1201MB0106.namprd12.prod.outlook.com (2603:10b6:4:4f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 02:39:50 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::42) by MW4P222CA0012.outlook.office365.com
 (2603:10b6:303:114::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Sun, 8 May 2022 02:39:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:49 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:47 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 02/15] KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to [GET/SET]_XAPIC_DEST_FIELD
Date:   Sat, 7 May 2022 21:39:17 -0500
Message-ID: <20220508023930.12881-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce877c3c-65bd-4272-0b06-08da309c0613
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0106:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01069F0FBDBE7C4E6FD5F316F3C79@DM5PR1201MB0106.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xcH+3dImAKbfeDCwhXOySqr3u25/AwKkbNetPRHm/K02cTzFoKAMXyz+vNczHUBWandMwUX8m5yj7X/+vIrk7aUC4EzMD+OxuzliD2csW6bMqxuIPEMcy1akD0y5w5vU77sqB7Cer4frsVXPU8TTeokZ3x3QGwLOHK+OmPjP9CWFWlvZepP+Z5nLmYB7p5kaJMIuqoMtwI+udrd2in4X/UUlBMxgNySF/DRRTdKHecWuqXKg6Yu/YuNp4mAH61rsi9je+V93N2eiaKDym4n4eNEq1RQhowMQn1ZRU//3jZ4L7+Rxjc6URNHjXwDhbczOFLpAH06awOQH2/+i6ghhDFeccx4Egzc4jFz3CB+7bZ1F98VNKyYMjp4RwadnCNaFsuisGC3y4W5dEhXsQXOcfoi6meHyZ4AiHtZCp3Rx7SDk5TzO7aacZu3fJh32668KKj1zx81cxtNuLBWRCCTfDV3PTAItasdc+Y9yTaEXi8M+yE965hWTPmIvag5amjVZM7FK1R4LChVS8B+fc/U1+wNOModPrvXc0DopdXV2kCtUrVmOJzOk/QLoJ6ToWzwaIJdSAYyEIbGnmvHwldo3voH+mQ5Hd0YLcTASXJzxigVCmWVh06MQv+ZuAW8J/ZK6PUL8bUGwLAw3SKu+ZO+pR/+iEN9BCDOPI6HkwXCNcZNdte1ldywe2wAEh8ybAgn1f2TbxUO2kbrkbtAs4S4Fl4xhgCfmFICeMKLhVJwKPvZJY+mHWXlpyiI5nRZOrIOO4ZGW0vTbNplMkIXkrKkqEA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2616005)(1076003)(47076005)(336012)(40460700003)(426003)(36756003)(44832011)(5660300002)(36860700001)(7696005)(26005)(16526019)(186003)(6666004)(8676002)(70206006)(70586007)(54906003)(2906002)(82310400005)(83380400001)(8936002)(86362001)(508600001)(81166007)(356005)(316002)(4326008)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:49.9414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce877c3c-65bd-4272-0b06-08da309c0613
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0106
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To signify that the macros only support 8-bit xAPIC destination ID.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/hyperv/hv_apic.c      | 2 +-
 arch/x86/include/asm/apicdef.h | 4 ++--
 arch/x86/kernel/apic/apic.c    | 2 +-
 arch/x86/kernel/apic/ipi.c     | 2 +-
 arch/x86/kvm/lapic.c           | 2 +-
 arch/x86/kvm/svm/avic.c        | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
index db2d92fb44da..fb8b2c088681 100644
--- a/arch/x86/hyperv/hv_apic.c
+++ b/arch/x86/hyperv/hv_apic.c
@@ -46,7 +46,7 @@ static void hv_apic_icr_write(u32 low, u32 id)
 {
 	u64 reg_val;
 
-	reg_val = SET_APIC_DEST_FIELD(id);
+	reg_val = SET_XAPIC_DEST_FIELD(id);
 	reg_val = reg_val << 32;
 	reg_val |= low;
 
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 5716f22f81ac..863c2cad5872 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -89,8 +89,8 @@
 #define		APIC_DM_EXTINT		0x00700
 #define		APIC_VECTOR_MASK	0x000FF
 #define	APIC_ICR2	0x310
-#define		GET_APIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
-#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
+#define		GET_XAPIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
+#define		SET_XAPIC_DEST_FIELD(x)	((x) << 24)
 #define	APIC_LVTT	0x320
 #define	APIC_LVTTHMR	0x330
 #define	APIC_LVTPC	0x340
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b70344bf6600..e6b754e43ed7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -275,7 +275,7 @@ void native_apic_icr_write(u32 low, u32 id)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
+	apic_write(APIC_ICR2, SET_XAPIC_DEST_FIELD(id));
 	apic_write(APIC_ICR, low);
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index d1fb874fbe64..2a6509e8c840 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -99,7 +99,7 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 
 static inline int __prepare_ICR2(unsigned int mask)
 {
-	return SET_APIC_DEST_FIELD(mask);
+	return SET_XAPIC_DEST_FIELD(mask);
 }
 
 static inline void __xapic_wait_icr_idle(void)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 137c3a2f5180..8b8c4a905976 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1326,7 +1326,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 	if (apic_x2apic_mode(apic))
 		irq.dest_id = icr_high;
 	else
-		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
+		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
 
 	trace_kvm_apic_ipi(icr_low, irq.dest_id);
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 54fe03714f8a..a8f514212b87 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -328,7 +328,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 	if (apic_x2apic_mode(vcpu->arch.apic))
 		dest = icrh;
 	else
-		dest = GET_APIC_DEST_FIELD(icrh);
+		dest = GET_XAPIC_DEST_FIELD(icrh);
 
 	/*
 	 * Try matching the destination APIC ID with the vCPU.
@@ -364,7 +364,7 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					GET_APIC_DEST_FIELD(icrh),
+					GET_XAPIC_DEST_FIELD(icrh),
 					icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
 			svm_complete_interrupt_delivery(vcpu,
-- 
2.25.1

