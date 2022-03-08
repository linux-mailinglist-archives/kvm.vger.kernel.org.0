Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE0C4D1D74
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348464AbiCHQkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348441AbiCHQkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:46 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61BE5133C;
        Tue,  8 Mar 2022 08:39:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBfeQOmgHoRkhBkA5+olTcrvp/QcGNmocbD3JaZhHo6FvNl4Rk2rhUnjv7jdAZzIuyeTvf1D54nWJGecpSx2VBFuFnxBsLzrZajejDR6Fdo8M9xjNUfDr5qPYNrKRpuv06LHbNzcrVX/v6sRM/Uo+XYsEtA+YvE890yFExwd7u6zMWAFEyCqCFrSTK5fVoHxATzMlDedFUeuNkHahG52nsn1NHjqb5PcE3G6ah2adkKXGMb2Iwzxjo75XKjLqaJhtWiNpVSJz8ZNnmRkkjZ7C74NY1RNhUFp9ZNMJL4GcFDgmm5Wu0HwzFnKazCZvBXP13r/yDACidZmcY1nJncwhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V66ErFfKv6TfmDG18FO+4aFbngL402LiIcl2grdwZ5Y=;
 b=CHnpfORuyMcdEmuA33i/sSz/WbHaC1/8ge2y6t5SBIJov6adwj2M4IYZQpNu/h2gfyxCooxGcNwnWvkMECGPxfGP9l3TG0/gYffhHjHoWUGSwS4LrIBk0cj2jZMnraTBbMkfruAEl1hnSYE01VaEd82WOpifaH+sMCc90Qvg0bYUpyFq+FOQPWsUX8hShTkAAcWP2FbQ4Weuy/EfrxyTKRuCiCYJgjaZ4rzdm3N8mQkpX77ngXpnINM7rw2miDOoNy4LePED2o5r6rM0SCJkFFruEFxT/EVZFv8p+PBEhFSqlr6q7f4jnu4olK1LZjuI8PEQ7Z4Px6ytdc2gDNSOUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V66ErFfKv6TfmDG18FO+4aFbngL402LiIcl2grdwZ5Y=;
 b=psTSZuWh1MsdOPby/Zv4l1+4xBOU1BPHiagoAivZczivW8PDSBhHjVeFJQDBXBoKwjXo71ioEfIpwVOB6JRUT9jIsdvhbE21NGJGkA3qmljceV4YFRsWeY0s6m2hEpZpyMdxAsXGsJ831Ardk5u+Y9J4Z7d1bzqmtkqs6HLg7oY=
Received: from BN9PR03CA0302.namprd03.prod.outlook.com (2603:10b6:408:112::7)
 by MN2PR12MB3838.namprd12.prod.outlook.com (2603:10b6:208:16c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 16:39:46 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::d5) by BN9PR03CA0302.outlook.office365.com
 (2603:10b6:408:112::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:46 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:43 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 04/12] KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
Date:   Tue, 8 Mar 2022 10:39:18 -0600
Message-ID: <20220308163926.563994-5-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fa30fcc-abf6-4d22-0752-08da01224166
X-MS-TrafficTypeDiagnostic: MN2PR12MB3838:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB383879B284F438CAFFEC62A6F3099@MN2PR12MB3838.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X5GKNs+mHWa75lUqcYlZzFRyuT1/G4fzZ09lhJuZoAFNfRwf7jFIfu3HIcvAGPq7ygOOpVzWXTNml31YWX1UHGKC1TXuVgPpCmGsLGsUewFlH4pp9gT7S89+iLsv7zf75ADErTIU0OIhpJIQsXIHOv5fYlEXcCj98Vk9QerMmwrWTyNexuBRL8nZe++MdR6UVNsby2uiNIUEXMbgFim3T/5fbkaABdU97vLsgOTEPJb2HS0/Ut2Hq5WGElHzbRu9rODyJI/6nZNGFqL4iMLSHWPkzge95dnxcIAA7zO32bmRq113TeiszJfVJ9H0zqeYXbvKZvJ22qUfMxy3hM5MyY4r6cejfpEiuboGPE1Y8H4+zoItYylPzSJts16L3jHJgftvTVR1KJ//yHJddaElwwxED4Gb4UAUd99bSR/XAjwp+ZSpv04PTeJ6OcMdAazQk8UEeSQzimzHKSFvdfTlW2QqZc1xU5Sy9GvZj9fUFioomns+uH+J89TkQEVsosKrGReUN5ToxLf1FaInbKapx73RlK4hV6yoFBV7BsKc+vfiTpT5rdrR+asEzqzXvfXiW9afHY1Wpfl/i5vsGSqNyUrF49da3Bk71Ugzpil0kM5sWEPj88yTtwSafVTaR/wZ5vYyLURNSxmRbyyBZvNXS7hCG7noC6ZUN1rSzT76/HtCFfpC3OawEmQUctuvqs9q4lvbprqN3K1a3CM246kU6A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(356005)(110136005)(70586007)(81166007)(2616005)(47076005)(36756003)(54906003)(426003)(336012)(70206006)(83380400001)(316002)(6666004)(508600001)(86362001)(5660300002)(7696005)(44832011)(8936002)(15650500001)(186003)(26005)(16526019)(1076003)(2906002)(82310400004)(40460700003)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:46.3442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa30fcc-abf6-4d22-0752-08da01224166
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3838
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

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h | 12 +++++++++---
 arch/x86/kvm/svm/avic.c    |  8 +++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 7a7a2297165b..681a348a9365 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -250,10 +250,16 @@ enum avic_ipi_failure_cause {
 
 
 /*
- * 0xff is broadcast, so the max index allowed for physical APIC ID
- * table is 0xfe.  APIC IDs above 0xff are reserved.
+ * For AVIC, the max index allowed for physical APIC ID
+ * table is 0xff (255).
  */
-#define AVIC_MAX_PHYSICAL_ID_COUNT	0xff
+#define AVIC_MAX_PHYSICAL_ID		0XFFULL
+
+/*
+ * For x2AVIC, the max index allowed for physical APIC ID
+ * table is 0x1ff (511).
+ */
+#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 49b185f0d42e..f128b0189d4a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -183,7 +183,7 @@ void avic_init_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
+	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
@@ -198,7 +198,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	u64 *avic_physical_id_table;
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
-	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -245,7 +246,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
-- 
2.25.1

