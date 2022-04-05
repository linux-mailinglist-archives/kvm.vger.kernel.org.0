Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77FF4F550F
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381992AbiDFF0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454381AbiDFBRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:17:04 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B352532DE;
        Tue,  5 Apr 2022 16:09:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F50uqU9DKc9YGqID271L5+1fNmDaPE0OuvgjQNUdg1MK+wTi5BaNds1IEIp/kqZ2i6hlI465hWpKwJ9wOAmxiL3+S27/KyJaK8+wvjuRMfE8G7YrkU4JusxEKqRnv6vXnn0+GsHyWmF2S6dBjtI3/Hu+riG0zNw+tWGXoTXdsjBYuR6/bHSxl3cHS9aKkZBJplkvq/osv0dbJ/Hp2zlxXy5fjpjmqG4K+xL/8kMvKgSR0XVkjTXT231JAhxOqCdjsHYSFMh/f1uw3bTQxywoxnsh6EX50ee+RwMN3L6vwH8y0fwZq8ylJo/Vcemlb6UB57wqu1vopbOv6OaSanPhrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vnSXMMxNha/AoZNb8nuaK71b8vyuJmMNqps3irgxFwA=;
 b=DYtoN3KD88IB4JEXHbmmA7NLLL/prpHhS6YHljlLA8abFb8lInOaULYvDZy02Nz4tnVAvF5l6e15rR5kvlq3aiZz83AocMTJHbt9zLP9kZvGH33GCtbsXbpD1pYNtLQZlz4tiHdaILjsBDtk3H13CR/wvjgR2yOY4onpSBOPzYPd9vdgpC5XuTNZbj5zttTW745X6qvDMgEC+lGDBK9W6W+MRaoI0U9P5ovP7wlGZWZz43sU8VUKezo8TsP9z5P3cnoN2t6b5G+HLQp/IHhQOzl8Y0dq5tg0ylUOs4yU9vXSE+KGh2X3iFp/mHYgkg7DRKPlD9HI/mcP/4v0LOciWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnSXMMxNha/AoZNb8nuaK71b8vyuJmMNqps3irgxFwA=;
 b=q5SQL6VER1C+jVmS9nJhW79aOkz3rzSbpd9YEhSMO7eC3SGizM9DD7eqpau+1Q/P9PaBJG55AhIguj5V61FRXPD9ZCuLiRI4JU1kgkMOytkR+Q0/DZRhRp4QzEJIcwyeiv44V0sWsxFNbbgeapnHPnJcEd9JEwAQ7yt6jDGEtjQ=
Received: from MW4PR03CA0080.namprd03.prod.outlook.com (2603:10b6:303:b6::25)
 by CY4PR1201MB2549.namprd12.prod.outlook.com (2603:10b6:903:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:35 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::2e) by MW4PR03CA0080.outlook.office365.com
 (2603:10b6:303:b6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:35 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:18 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 02/12] KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to [GET/SET]_XAPIC_DEST_FIELD
Date:   Tue, 5 Apr 2022 18:08:45 -0500
Message-ID: <20220405230855.15376-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 468260a5-f925-4217-85ef-08da175959d0
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2549:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2549D60C7CA2C6492787B3E9F3E49@CY4PR1201MB2549.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/4rO/58GqaPYhQ9dHNSV57MO2j1hyNJewTGOBAV0UP20A+/fUMaEtWFIdA/wbts1Adpfs1QDE0Ztn2BovzrmO/wGxrCzUt5/6K1w6jynElDkqVedIdilHhM0UuPbVfTV711cmErVZNVj9pVvqZoi+W55EXx59MXR/KUdOc9sgU9rAWpXyLD8qz986QzXhYA6GEXNC2owlfJ6uNHl0QTnvVuXe/8ui8X77XxOkawMzyKQRCRsXTPgSBievv8BV0EgN/M2gVVS0P9TvVFqtU7a1Z/ICUsWog4b1YFVywaDWwsJrZPCcM0YHGVVyEJ/YRGhPWrEHSNDJ0rQ0cgPaPT8xXpQsABvKuI0JfUhg3Ahd0VRrTzNmFqNLe6jfpvC9MHHUO7wk5WO8r6/s7hY9ddD1uXKJ3LAeqW2Np4aFOla0yBircsRyKTSwhpF1JD5YA4eCoeCDUw7xGJPZfFd8tRDvAqoUyKTIMNNNmln9eL4TE1vcSMVMidn2U2tIKxxI/hPxG3H9TM1DP9rg+r61BxIWbPAh7T8QYG5lN52ifWAmMay9e//LjSFKJJv6D/GH5Mc8+S20JLh8QARMMmAJnHNXAEN8BrlmlWsuz72LcU8+x0RaTT8+oRhgsmIDxIej/lOf1TdZDy0g0NWSTPESzkbxydW4IbSth8c8esHkCOU3ZSAieCAPwoX7w8jhqrncPn0bTuc4YSHEIlIttycpZsZg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(6666004)(2616005)(7696005)(81166007)(110136005)(54906003)(70206006)(47076005)(186003)(86362001)(26005)(336012)(82310400005)(83380400001)(8676002)(40460700003)(16526019)(70586007)(316002)(36756003)(2906002)(426003)(1076003)(4326008)(356005)(508600001)(44832011)(36860700001)(8936002)(7416002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:35.0056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 468260a5-f925-4217-85ef-08da175959d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2549
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 arch/x86/kvm/svm/avic.c        | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

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
index 9322e6340a74..03d1b6325eb8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1286,7 +1286,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 	if (apic_x2apic_mode(apic))
 		irq.dest_id = icr_high;
 	else
-		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
+		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
 
 	trace_kvm_apic_ipi(icr_low, irq.dest_id);
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 66ca952fc2be..70a8b67ae800 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -299,7 +299,7 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
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

