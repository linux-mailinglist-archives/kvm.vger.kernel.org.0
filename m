Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EB34BD3A7
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343625AbiBUCXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343573AbiBUCXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:17 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710733C713;
        Sun, 20 Feb 2022 18:22:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+qNs+2BmnUhhDxVTjAg9kzUShsXlOSVENGV9rGzGxw8BzXgO5RchndAdLzjQ9w4YSAU48f5stsTX2IX0v5oNFc6pmHcEMFDh2QKOhW8C73rOfc3a0/fT/NXw09Z+Zw8AC0Xj1WoH/E009RV/Tnhl/2WFvg28EXnuT3QLk4Dl7P+frjVEk1nwHAiZVHpZsiFiQAXOZV19fVGXZZjnCU4ZtKj3NrTH6DmevZGj5z2A2p28YHrZZJzWtZWukV2SLr3IjOTiEf9p9e4nIZ/SKt2zVX/PEnWgJLUOk7FkwnDiMAYWRilBASZzi/3/TLpcOfwucIWyacEtEvKWPvpfu+byw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipZmHZnMDLkBUxZtdK4Ql2niACe3/mVEzg27v4CvFmc=;
 b=NH/sVitHJ6dX0dzbYwQ2wA75qhN+Me8/siE2VY517ieJ+Cm0Wyg57ETX8DL7JQwTwyeJFG9xKGFsGRuYj3VILlX+Vhnlj6dEdg7Ji3OnhBOHwu8G56vV2rDU77VdeyfXaHafmjCS361CmAyW8Qma/yzf/xs8Whj3nPykzFYO83b7OzkqGxaAOCI7JU2nwEYy2N+Bc8KdZp5Zu+Qg9b0w1u4zjGt5Kkgy1Q354NOc6fMpQwxY5tvcG5ZhK0ty8ia5iO+YQilh6BKyoRSviLfH3Vc8lbrdMI/N1jmZMudXlUeuMJ5ld6v6oetOFqKkGkv3w/4WD1NGHYjS8row3aCGMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipZmHZnMDLkBUxZtdK4Ql2niACe3/mVEzg27v4CvFmc=;
 b=Oj1/0gVUyLmH+xv1I1HRJgeeqFDu4wJ0OF7E1GEeHlej4rXEPs8zX4ZEoNIyhLgsv06hXgGieqDk2GhE5H0nktYBprgctcV9v+9lkaU7LoQgRruyqKGjJAKk62JkjOwT8KEj2e3tQ90lvtLxtSJU9ESe1zfD4s5ozD6rvk+5Lkk=
Received: from MWHPR1401CA0004.namprd14.prod.outlook.com
 (2603:10b6:301:4b::14) by DM5PR12MB1418.namprd12.prod.outlook.com
 (2603:10b6:3:7a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 02:22:49 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::5f) by MWHPR1401CA0004.outlook.office365.com
 (2603:10b6:301:4b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:48 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:45 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 06/13] KVM: SVM: Add logic to determine x2APIC mode
Date:   Sun, 20 Feb 2022 20:19:15 -0600
Message-ID: <20220221021922.733373-7-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc7161d1-131f-4f8b-b8a3-08d9f4e10e0d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1418:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1418B1FC35F74E7CBE6E89C5F33A9@DM5PR12MB1418.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Szmk6DHAT9himBCYJ6uc0PV/Wem5HCzrCIq57J3iX7FS770yiFNrJRmKAHb/BstamKLR1/oC/UIzjO5DylO7HkgZwxuXGEqI8VeAXkTe3IcvcUep+EXeoDCs49KVXF7hr2B7ifXYWsiM7Np5CkUC0+UDZXx5fxSL1MGqAkKFFeMiCsckJTpjM2ViAm95MDzjNG0oVWk4QFgnWpcw0nGR4GfEAfmXfm06w1kGdG2HyXp6a1deKvXkFw6mf01fFBpR6mf9mEe7aQesMhCuOBw7uUAXG2umoDS6hNRYCH6jD3yV4/ONeaNAy+sRE1ySqmsSH+TpmLltU4bNUyqs+mW71V2KOCCQh2y0lXVd5uweFCYSORHsWDyINnffDsOpheJnAA95ZrK3GYRnhUoMqUmZXnhANwoe/1kezKxo6Jjydba6z3mNZAqn/Z46kZfkytEHk264EPy/cAe1453S2zNaYMpRjoGg02QaWWkxG9xJEIM3cvQagih3vqtkymaur7nDebrQswqb4g3NyguuDoeXoXaOfARxXq1ggxL70hd6RbGtL4teIVhwnVhWvOJJcTR+C5+DYojFdWIXdfvwTfVLt1JJYt+/fWwiiFEfW6qn9RbYZZWcYLR7NNBdZYborUYBBU+cslQ1xwFlIbDMtMpX+kEETU3x9VgXZRfa+Z0ZeLGEBwIz/JqFDN4sxbu29T0o0Sbd2tb9TfGY2sa5sREGw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7696005)(8936002)(6666004)(44832011)(2616005)(5660300002)(4326008)(316002)(54906003)(110136005)(86362001)(8676002)(70206006)(70586007)(508600001)(82310400004)(26005)(186003)(36756003)(47076005)(36860700001)(336012)(426003)(83380400001)(356005)(40460700003)(1076003)(81166007)(16526019)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:48.8516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc7161d1-131f-4f8b-b8a3-08d9f4e10e0d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1418
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce avic_update_vapic_bar(), which checks the x2APIC enable bit
of the APIC Base register and update the new struct vcpu_svm.x2apic_enabled
to keep track of current APIC mode of each vCPU,

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 13 +++++++++++++
 arch/x86/kvm/svm/svm.c  |  4 ++++
 arch/x86/kvm/svm/svm.h  |  2 ++
 3 files changed, 19 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1999076966fd..60f30e48d816 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -609,6 +609,19 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
+void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
+{
+	svm->vmcb->control.avic_vapic_bar = data & VMCB_AVIC_APIC_BAR_MASK;
+
+	/* Set x2APIC mode bit if guest enable x2apic mode. */
+	svm->x2apic_enabled = (avic_mode == AVIC_MODE_X2 &&
+			       kvm_apic_mode(data) == LAPIC_MODE_X2APIC);
+	pr_debug("vcpu_id:%d switch to %s\n", svm->vcpu.vcpu_id,
+		 svm->x2apic_enabled ? "x2APIC" : "xAPIC");
+	vmcb_mark_dirty(svm->vmcb, VMCB_AVIC);
+	kvm_vcpu_update_apicv(&svm->vcpu);
+}
+
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
 	return;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3687026f2859..4e6dc1feeac7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2867,6 +2867,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->msr_decfg = data;
 		break;
 	}
+	case MSR_IA32_APICBASE:
+		if (kvm_vcpu_apicv_active(vcpu))
+			avic_update_vapic_bar(to_svm(vcpu), data);
+		fallthrough;
 	default:
 		return kvm_set_msr_common(vcpu, msr);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1a0bf6b853df..bfbebb933da2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -225,6 +225,7 @@ struct vcpu_svm {
 	u32 dfr_reg;
 	struct page *avic_backing_page;
 	u64 *avic_physical_id_cache;
+	bool x2apic_enabled;
 
 	/*
 	 * Per-vcpu list of struct amd_svm_iommu_ir:
@@ -566,6 +567,7 @@ void avic_init_vmcb(struct vcpu_svm *svm);
 int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
 int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
 int avic_init_vcpu(struct vcpu_svm *svm);
+void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_post_state_restore(struct kvm_vcpu *vcpu);
-- 
2.25.1

