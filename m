Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB44F551C
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1457457AbiDFFaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451618AbiDFBQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:58 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF4E5046B;
        Tue,  5 Apr 2022 16:09:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNTzlyUiCsABqJ/F7AaA7b7SFieV8ofEITtfYUWLOZC/e16dz5W/AtBqEwpnq4JVOddRuxfa67BVOJqvRk7mnSbn0XPrjnZLUJImrVcyaJt+WsSl+NGZDfniqOlwZmiM2+p15OOuoftyny/5T1P7sH8yakcxnz1gJrl5YgSxm7aPgPIUL/SGoqveFjq7DlDWvgyEHIe/2JbOV7JBlXqqCnA08bVmt6iBjgTbnRddBQscz0XXMpDWZKCGmkUL/ecaxuolVoAmFy+mXrsbesFwD8w1Q2OMetyEdmofV9xcychx/1Q3QBBi3gQMRxsejZ8aVcA1X03mGk7AkdTdRNJxjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+cIZM44K1A6L6EhrP2lWOUKZhgxGlxlqZ/u4F9HDVE=;
 b=eDGrPgoTMOWhjq17sbxP5EY8Kqg1kr383T5/LdLdDs2x2p396rJ1UnepbeDF8Orr2ILvikLguYw0j5sP/u3hrcTshPEjNdkEeV1LTm6K1C3gRRC/azkaB77vvWgmjziqcE+EeeRf/Px1A6GmgfMuGPGtVtvTI1Nd//670V1aE2CWUS+ByTxIHoLTb0L+vnkxy/JLkthrrMCrG3Jr6JvRtKRT9CbXvmxxGiO2Bi4fWcGLB5qJPQ56oUc3UVHRjoc+7d+dsTXBYki9Ic8gn85sf9XhryCXKuxeQyjNbc9gsJfDkc2MzeDRoAem9mxIV9BTNwc7H5BZX0ebiPNeAUiAzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+cIZM44K1A6L6EhrP2lWOUKZhgxGlxlqZ/u4F9HDVE=;
 b=f6q64Ija4Pe7xMtaOZCW3JEke2u1fek4idzox7P6igBuEndNlrbZkEOVD9ypfyFLGIiSvtXTVdCjmAsFqtf2q1g4eknHb2DLE+PQWbFHKDUYKsq3IzcpbaVKB2f7Ni3VDxjJ5XyFrnFR9R14k1Ao7+pwPjZvFmjuuIqY8gH7Ku8=
Received: from MW4PR04CA0073.namprd04.prod.outlook.com (2603:10b6:303:6b::18)
 by BYAPR12MB2630.namprd12.prod.outlook.com (2603:10b6:a03:67::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:29 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::ef) by MW4PR04CA0073.outlook.office365.com
 (2603:10b6:303:6b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:28 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:22 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 06/12] KVM: SVM: Do not support updating APIC ID when in x2APIC mode
Date:   Tue, 5 Apr 2022 18:08:49 -0500
Message-ID: <20220405230855.15376-7-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50654199-fe32-4507-5787-08da1759562b
X-MS-TrafficTypeDiagnostic: BYAPR12MB2630:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB26301CD624B2C9BF9869EC04F3E49@BYAPR12MB2630.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5pbSeH0RYPFKLvSvhRXrnUBaSHwm0cmkhiaEQArQFUB4C27zcdPR96x1kpbn6VNcArD3V96zGR3pNgFi1hwGvOArRZCBAsvkQXkc1orATfwin1TOWVjlm1ZwWCRu7bF+B15wCk8XtYzFzf46cUOTfhKSPVpHO2E8Bu29Oa9EbiorsPCclxfLJlZCM50C7zMwsvN76WoWcC4T7oNqOiOGNEDa0zWb1Pu/EAZ7+DRO49l4bZfo2sPcXimD5SEQLMlDGynUCwOrhBmW3Vv8n9Q/+xKSAHks9I9ZoL82oXPfG9arY7GOxhl5laoJL/TunxeUk0H9khKzyNOmVmJoSbyLPXsWnCRMa809ef1kXF4PU9qQlloDudWfytCp9ckUR3vFDgZJ7OSzaWTfwNqgcUeOvqi+PDF/VzUnlul6JTLECJSntOBmBVREGb8/43GL2GYjNE/y0Hmh2ibWNf1rjnfyR+VhK/ZQHVt5NkEA8eyM5Gndep69QDdG4oUz8DzE/TZp9UrHDvyNYMbJHw8+SdPp4LLf3cdCS7bsF/zwrVVvQSHuhvmc7dgUULcHlkNJGlWbDuGNqTtD4f//G9Flc4qJg1Vf1eJ2ibFckXZOS/ixJM6/r+DrmL2UCATC0ZV559VtKqvcy6XTVxb5RIWx6OAM6bwO2pHh687vzEnoj5HZSg9+k8Cbfts3erwKXm80KQNB3jJyqtWgHYbinCcz/L57AA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70206006)(70586007)(316002)(110136005)(54906003)(86362001)(82310400005)(6666004)(1076003)(356005)(2616005)(81166007)(8676002)(7696005)(4326008)(8936002)(508600001)(83380400001)(47076005)(40460700003)(2906002)(36756003)(36860700001)(44832011)(7416002)(186003)(426003)(26005)(5660300002)(336012)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:28.9212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50654199-fe32-4507-5787-08da1759562b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2630
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In X2APIC mode, the Logical Destination Register is read-only,
which provides a fixed mapping between the logical and physical
APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
and the processor uses the X2APIC ID in the backing page to create
a vCPU’s logical ID.

In addition, KVM does not support updating APIC ID in x2APIC mode,
which means AVIC does not need to handle this case.

Therefore, check x2APIC mode when handling physical and logical
APIC ID update, and when invalidating logical APIC ID table.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c36a236e1e8a..f378f7810db7 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -424,8 +424,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
-	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
+	u32 *entry;
 
+	/* Note: x2AVIC does not use logical APIC ID table */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return;
+
+	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
 	if (entry)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
@@ -437,6 +442,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/* AVIC does not support LDR update for x2APIC */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return 0;
+
 	if (ldr == svm->ldr_reg)
 		return 0;
 
@@ -457,6 +466,14 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/*
+	 * KVM does not support apic ID update for x2APIC.
+	 * Also, need to check if the APIC ID exceed 254.
+	 */
+	if (apic_x2apic_mode(vcpu->arch.apic) ||
+	    (vcpu->vcpu_id >= APIC_BROADCAST))
+		return 0;
+
 	if (vcpu->vcpu_id == id)
 		return 0;
 
-- 
2.25.1

