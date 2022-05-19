Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EB552D07B
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiESK1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236602AbiESK1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABBBA7E1F;
        Thu, 19 May 2022 03:27:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPhSwjJ27aaVUmKazl1DyXXMRLLNbGFuxQwqtRgcxer4VbQRiDG1NElFUxk/XHzPb2r8nhDXOuNaEawWLQOAvPcZKGs4IOM8lO8k/28yCLrqt4rd5veJVbGoirnE72dgWZtV5gSp1n3JfMMNZBp4eyBHIrMogCN29dKLGY6POgLaug11hEw7Y0gzXQQfcKPtjP4kiT5yKdxkwwjSEI13avmaEWgZ26E/6Kmu2UdAeCNZ359VqvvtPEwq/+tahmkVxmvoauTtvpbUFNYI4JfcH9/6L7uLZ2sqmjxwxGq0EUT9t76FENqWfJwvlRZsIrFSgF5mStzOEKGLBFdk6ZvFKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsGI/LukaIQoq01Bz/uzHMwv/M362sY2YQ14Oxc9OVM=;
 b=ZA/FdhJVk+bzMharVhatZWODc1YuHAXfrNeWEBnfiu3EvDxiNY0zWcb3HRHcKJrK7kYqZvinLIqRYLpVi99cdJBoV/NXfUrRUpPXJQ6lIz6H+ZkPc98Egrfwmw9F03NgY/WNuLJsavq8OZGm+sBR5BVk0Oi9ucVUvwFDSqSFjs3OQfQtY7BZQAFL8tKt2phwzVBkEk2D+eOjT6bHPc03egSxpKl/I8LFqEXZWyvicZjKZ/0VeB08NsUYX40jSM9+4t/Sv29kzUWALPyndad/upPyatkh8TzFozkrqCjIyeaCe6iknl6XuD7Ny7EDgrv42qwQOPrkjXfYaTOxtc+K+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsGI/LukaIQoq01Bz/uzHMwv/M362sY2YQ14Oxc9OVM=;
 b=0znO+sk8c+yucGMY/TZMbIHBxLMKcdHkAQpDr+AeZGzPfmlL/Mumu8Ymm45AhHnSpIt0Lcyi03VpCad8Cvtjirsed9nHtTO9eE/2+q3f3qUrqXZdW0uhR5OBhBDWJRUJz5srwprY5ezfRKJsTCCTQksVu+Gjpkwxpwtlk8sMpOs=
Received: from DM6PR02CA0130.namprd02.prod.outlook.com (2603:10b6:5:1b4::32)
 by DM6PR12MB3882.namprd12.prod.outlook.com (2603:10b6:5:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Thu, 19 May
 2022 10:27:30 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::31) by DM6PR02CA0130.outlook.office365.com
 (2603:10b6:5:1b4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Thu, 19 May 2022 10:27:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:30 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:28 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v6 04/17] KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
Date:   Thu, 19 May 2022 05:26:56 -0500
Message-ID: <20220519102709.24125-5-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff89e4d5-ea88-4482-2177-08da39822dd2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3882:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB38821CE5EEF761F4ADC98369F3D09@DM6PR12MB3882.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0sJ72E/qNA8Gv8/lZDT0gdylZkqA7n7xOJTMXITDFHClzstOmWAlL4iKYj1nOWoddZp/X6RFw/OsgtZeuYG2Nl6wSLbeNaYrk+BikEu/fvkbzsvBwaaAXZqnyrlB+X1vTXwamZOSm+Q94QA0cx418TG9597wA8VaqUf9zWViU5KjFCUPsa0p6aVZtWR1NCY76FsWVmaMHw6zLqNH13N2JJOg13OeshqwLk/5LGqj1HYFhJCCacHPNvGzrDNzer0qK0SmgylbjxcGk5QTGhDdOUveKTCR/T4alkOyYjUXpxn0zZayaJC19reuwnjhisGwuEDlafQSMp3+vg99U0xcO/5bXejGYud9LXV9ePsSqKpMJheItUNmE0EJs1i3GRXRCmHIfhwPKOf9QVKXpZglWsDOaPJICtOjdcsayA9r4CpS4Aiia0gABvu9qkptKmLePS7j3QdRH+BZDfe6T6jpMlhFaQD73j02qBEjtx3TxyuKQWG6Os9TIs6ld5R7mK1JrvHNPv13O4q53VQGnh5pJ+DS4v3PNYTCIrscu+14gwPGIYbt/dB5cOGDczCm5L6+g0Vh+UUNZNEdUbKB44mjOr9x5gItyrx47rVFUEa2B+aGYyfV6p0eZ+wX3kBsHejhKC9WnSa16EfJkKAZavChKVmZR61gICHNRvkEL/y3c9L2jOwVUYWrUgbnaI0nAjuhGWwUcVKY8uEOu8ECSN5lrw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(7696005)(16526019)(2616005)(40460700003)(54906003)(336012)(47076005)(83380400001)(2906002)(44832011)(426003)(70586007)(70206006)(5660300002)(186003)(4326008)(82310400005)(6666004)(8676002)(15650500001)(8936002)(81166007)(356005)(316002)(36756003)(86362001)(1076003)(508600001)(26005)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:30.2530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff89e4d5-ea88-4482-2177-08da39822dd2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3882
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
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
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
index 7d4e73e95acd..6b89303034e3 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -179,7 +179,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
+	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
@@ -194,7 +194,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	u64 *avic_physical_id_table;
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
-	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -241,7 +242,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
-- 
2.25.1

