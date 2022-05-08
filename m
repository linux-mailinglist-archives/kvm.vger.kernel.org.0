Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86A751EAF5
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447123AbiEHCoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381040AbiEHCnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:47 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2051.outbound.protection.outlook.com [40.107.102.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A361114F;
        Sat,  7 May 2022 19:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Suy/gLDa4rEYoDYNRBnnmLqHdHsFTjCNKQJqjJAn10cYkbhmKgamdWxRGh3TdMKwv7KNSQJPnCFn5Uqi+6WbZJkPmTxg8krUHmB2UNIMQ0alp1vWwKOS+IFXleqgrcUL46+YQRZ6HCYOaTDyHXTU99IWogHVrXXVza8rmCMmlOpR8ITFRw1IuFpjexdq7abyBCl6dlbuI9U0ARE2aeSTnCAdxSqWBDupfNKk6seTi6cNMoHm5duNWLgvsTfgw+uVj5Fi7XzJDlVNPnLbHUDm18oPCTfanvluwPndRCcOdVe3Q6xIhH1LP67fMUXIwpwdwW1BjvE8gHpXW2fOx1NP4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yNXbnocgwJ+rLBpyNRjzgKvGtFIifrpZBYkXFb4wac=;
 b=I0u5tRHWu9xajoMDfQD4KBE56qEC35V5xeEI2Qe1c63B/wQ6n6f/194a2OZDHr7S4OT20INgzz3/r3nAyHz0/mmfngcycTR0J+es13gcJPPsB5m/uSixz+44LaS6VV0y+sMz+PHzlxWLGaa4RLpodWRnUoZ1+pvuyLUpJEGo5wtre5fGeq4Aj0EbBbiUfKNW3Hxh9k1wZ0X34J1Z3EW7fy5NrJge9IX6nL3gG+kkFKocQ6WmpbdHGie3SWBJhOVRXYUgPRjY6wqW/Yy54TLvRApe6shRDCb0hZjAXWcK1VaRytODRPOGUGBZGdm0Q7exEDIqxIcE5muVUotTrKUBeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yNXbnocgwJ+rLBpyNRjzgKvGtFIifrpZBYkXFb4wac=;
 b=t4gu6Cs+Os7inNYXXKVa3axsxh790dMd9vK2saHz6Wf/drjchYNu/l3UGx5m4pWkWogkASOhKa0sZx5YtPYhVggkEvmPVPfHBrLg4i6cxMpYrPahlnbImMkzsxNZj8SSYJmgVdbFnUVVCupj2dVv88KKh3FBuOKXNH53Qn2/YRM=
Received: from MW4PR04CA0050.namprd04.prod.outlook.com (2603:10b6:303:6a::25)
 by DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Sun, 8 May
 2022 02:39:53 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::c6) by MW4PR04CA0050.outlook.office365.com
 (2603:10b6:303:6a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Sun, 8 May 2022 02:39:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:52 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:49 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 04/15] KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
Date:   Sat, 7 May 2022 21:39:19 -0500
Message-ID: <20220508023930.12881-5-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8dc6466d-e3f2-469a-cef0-08da309c0760
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB50408780BF9D11738D5BF8EBF3C79@DM4PR12MB5040.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpKyh3aTMjjslSONaIXvLlWLxO6K8YvEh+WrHcMA0qHH40kBIH2yxymrY7pALEVERMNyRlN3Cof3nvyp+kRaQ22bgvc4TO6JpynDb6928lE2CZZHjjp1FqmQHFaPXboLdhSjkguXmQ9yCKAOGTlyE2b8mucmixvBVzdqRnAVesVeAkqi+pJX5WkuvmeK2lj0zFaXYI/yPldX3cSVeptuM9vEeRJIFCbLNzf+Cpt+SVNodyZSfaA/j0H2U1S5cRvvblZ1yjDxn528GhgXY2rNwPzX9sLU+p04s28IANxGS4yOqjJwVqBo+STc/OfxEnR4bED+OII0FQ3zoD7Q1oDK60uoTAiMpMQuZS3wzMDbW2Z9fDA9W1ol2of58KUlIOM7wZLx6XVCvO5jvb3MR7TKTuNCAtIqjbUlPIzPq606Z52bpKKo78qJ6BsywvwhCO0oFtX/qOws5xBlpPtIN13XvdlkAIHaCnFBM5u+bwEAzd11bQdQ2nVATmK8oxL7KJShtSRvKOo3KLRo5d12wQwu1s2TcXeTInD4fl9npJS1jjqUfJUW95DhAms1D0QZ533AfTn1TXqvXrYWsABJcOYdCsODRIzxJVQcIaO1tuMj5xN0HlpX+EurP80AojCPDtLCA+6VwG5rAsN0P/FfxblByWsKN1Ee/v0DAmVd+H/7oKApaHO9b9jt/mseWQnjfNoytQusJh/CIHoKGX55hWtOSA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(1076003)(186003)(16526019)(5660300002)(86362001)(82310400005)(26005)(2616005)(44832011)(8936002)(426003)(336012)(47076005)(36860700001)(2906002)(40460700003)(83380400001)(4326008)(8676002)(356005)(81166007)(15650500001)(70586007)(70206006)(508600001)(6666004)(54906003)(7696005)(110136005)(316002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:52.1287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc6466d-e3f2-469a-cef0-08da309c0760
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

xAVIC and x2AVIC modes can support diffferent number of vcpus.
Update existing logics to support each mode accordingly.

Also, modify the maximum physical APIC ID for AVIC to 255 to reflect
the actual value supported by the architecture.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h | 12 +++++++++---
 arch/x86/kvm/svm/avic.c    |  8 +++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 2c2a104b777e..4c26b0d47d76 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -258,10 +258,16 @@ enum avic_ipi_failure_cause {
 
 
 /*
- * 0xff is broadcast, so the max index allowed for physical APIC ID
- * table is 0xfe.  APIC IDs above 0xff are reserved.
+ * For AVIC, the max index allowed for physical APIC ID
+ * table is 0xff (255).
  */
-#define AVIC_MAX_PHYSICAL_ID_COUNT	0xff
+#define AVIC_MAX_PHYSICAL_ID		0XFEULL
+
+/*
+ * For x2AVIC, the max index allowed for physical APIC ID
+ * table is 0x1ff (511).
+ */
+#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 95006bbdf970..29665b3e4e4e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -185,7 +185,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
+	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
@@ -200,7 +200,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	u64 *avic_physical_id_table;
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
-	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -247,7 +248,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
-- 
2.25.1

