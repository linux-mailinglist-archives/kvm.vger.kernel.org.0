Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451A352C003
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240151AbiERQ1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240197AbiERQ1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32436AA62;
        Wed, 18 May 2022 09:27:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkRYQNYBdNoZXNcsswzhSw7nyOMXiCmXwU2MAXXIHFDlfErZCKVSd7FGhpSQwohSvE5Mza/NuDhUPSA6HyCZyCE98Iz/unr309xIAFNelghBQ4OM+LXTFlsi+UFbbAPzd6/LJE0ED0+7AOfg/cjs9ezLc8oFE61+eZPV219Ydarq+EGKNmN55C0Nm1vAzZFp1nm4dC8vvOAHsQGsGV+EwQ6OFWnAGvX3Psm2P9HCQdR5hm8hoKwYPw16iCePf184E0bAm/w02nPlMhgSrOyRWU9SuiKdoLoO0lpKKfgtQSFLAy6lFZt3NzqyQsD+djw8Not+bk9yINEFtYgbbwgCkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsGI/LukaIQoq01Bz/uzHMwv/M362sY2YQ14Oxc9OVM=;
 b=f7/SHYoCZjMER24t7vza2D5wbjHCpQMj/cAA+Me3h4p1w5PZLVa3y/eUrUWtypCYEhXZDZxInmpMKCFtvi9lZiXhcGWof0vzuqVGEf9eLIawY/YeisScsgp2Xc5EEqyCdD7wMV3rZwBGGDWHaq/L0xTDQwh1p7atqHuACdU0h5+CIOH5r7YZ8Iqtid7nOjyig12rzXOEwlTo7L+gD+EPlD1oMUES6QtAuSsXPfqEsbOYeg3s7zOCN4qtFurTnIzYHcw1+eYVPVYze4gr+kSAyZfoteeVFNoscwYi2A76TQfG0b1NP0jiZ43y/4Xazqqe/gHHJbcnCi6tAIPhzF9/gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsGI/LukaIQoq01Bz/uzHMwv/M362sY2YQ14Oxc9OVM=;
 b=DydUGUlTQ+5xrtIuUtKhoiiHpJJZkPCNztzrH9vPvm8Pc/RH8CbGAFEi/12EmZcI/7lA9T2WPdRovT9YVpOAnJ6RU+0nYU0UWvS3VF/4jlS/boMqBM5xyCdl0krLzcoy0bguadc5iKyq/OAG8B1yui04xn5QAmJeoxUmL0L5Ag4=
Received: from BN0PR04CA0172.namprd04.prod.outlook.com (2603:10b6:408:eb::27)
 by MN2PR12MB4319.namprd12.prod.outlook.com (2603:10b6:208:1dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 16:27:13 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::c2) by BN0PR04CA0172.outlook.office365.com
 (2603:10b6:408:eb::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:13 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:08 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v5 04/17] KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
Date:   Wed, 18 May 2022 11:26:39 -0500
Message-ID: <20220518162652.100493-5-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c63e222-228d-4470-9f27-08da38eb4421
X-MS-TrafficTypeDiagnostic: MN2PR12MB4319:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4319DD8F8B0D98F2A93791EFF3D19@MN2PR12MB4319.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QbaGUiHcBpoxSY/H7cRlKOv6Z/Pv0nQ7kTnjSSs5rbvbAvRbpArYAJqKDUQeBoLaMrT8h2S3gXmHkJGeZPy1KswIglbWSBT+BKoL+YYEkBs842GvABTvzI2+CBfuH20kCun9Ol+LW5zzkLnCSnqOJTQ/5J2/bq5UyaYH3qDn4yV4KJutWLRXibOq58uQoSp/jvt9T2If0RbzXW//Z9JLUSTH2Sa60wJ6aEFgGUvbFyEXHUE7erLzFJtDVamTplklNbObRYBnKWJMKgA0ftPkqsz7abVRxR92t/c/+mjLAcOOP/fIW+nKrnNSZp2aJ8HRufJXGQ0XH60QYvT3n+RL0rEno64kSMcnMWjsfnzHF1ySvYKEEG7l+DkNFv3EhaWAdh1QJXlFfeGScpz9vgIvDMUKDnTcxVTqsf6NpItaN7U/Jmvo3/KcKStJFOi4ogHc1PocSzqevOHwmQr4PO0IRjD5WWQqDFtlICEKDImgPixK8Ocz+xCcoUEw3uWbeohBnLK+JaybQlsFk4hbAdQqx8dh6crMyyt9GWDJTfZLm6IFDg+hCt2mP+JaiBDsXjY8vdU8xo6f+AeZqGqJ8C+rFTj5Bb4ifAmmAURd3RyuxLM67+7jUGHV9CEQ4pzATPQbK7+qlbq5cLpPijq4noz8clSHBLMgxq/jgMewjZ8q/4pQFgPXhcPViMUSBTMKr6fa6fSqtpH0mLyM/+5TQdv3ig==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(426003)(81166007)(54906003)(4326008)(110136005)(356005)(336012)(2906002)(1076003)(508600001)(186003)(47076005)(15650500001)(26005)(36860700001)(16526019)(6666004)(7696005)(8936002)(40460700003)(83380400001)(70586007)(316002)(5660300002)(2616005)(44832011)(36756003)(82310400005)(86362001)(8676002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:13.7089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c63e222-228d-4470-9f27-08da38eb4421
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4319
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

