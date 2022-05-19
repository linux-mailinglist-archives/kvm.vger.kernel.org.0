Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CBA52D081
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbiESK2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236744AbiESK1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED4EA7E27;
        Thu, 19 May 2022 03:27:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkKSr2xMCP5SzpXQPIh3NWUUO6S8Qj4DHCNH1Of/U9AUKgVgDtqvv+WEa/PejuOUYPJ2LD/gdSjleso+U+PEahaDm8TElpy89C4rqU5YPrqTO7pfMDzNb4NaJM0LwEeP/gls8+rhckAfXt8dWf1LCQ75UHy7Sop8snl2myxOngX5ECi+WqE5uehuPpKB9GjehJOYLFMBzjolkZQLC7DjkmqpcrcWqprqCc3dqVxPAHxCh3neNhTc/JrXxDPNtBSFpz5SRoCh1Keiz6Aud3P7t0BHYwF6SI/NdE5kaZBaw87JYJ9jlVizMWAA7LypMlISS2t2L0qfdERCItCWNWDA5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kga6IgM/p/p5hs5qDWDbxRUoEkdYgZejzKFw01ko9qs=;
 b=Rt/ZBbiAvOa3z9GnfSIZXir0vOYYYR9qVqyj9c3LRp9NQvS5Sv7+3bRgE9s4+sVtWwGcAeTD1FNM/h9a2LYbgjykHyUthgJhj+3zDzO76yW3dguKqnI5TttwL962A8dBAjcxrJbQfEVJD/oWA6LGib7bxtjGcCTc7TRbNDaK98GaqCZhHumDdqN1v1j8VFcTR2hJwuU5RElp5k4a0MI+CQCkvYW40ZBxSrAJ4nCH8sKUG5hgkpR7aILCdXK0nhBI7+FkBchSnKgAWqbigEvzP4alz7firHudrqeK7iG0+a0URs+uHQrDPx+tWY2f1pvAeA5Zjaj5GfPDUsD4SZxATQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kga6IgM/p/p5hs5qDWDbxRUoEkdYgZejzKFw01ko9qs=;
 b=MOHNps39OkH4Htb419omtq+HRRjwF9M1GcH1TP5DDxLorrdDu8DyZFgPeG9L1pK8D4CYZ6M8Ikrj5y/IRDpSetAb/mEicTn88mKBhJ1rpm23+qXQfTsPM+ntartyvFdSVSfcm7w6dRVI3uKe0VOvrfwlRfRP838TwTS+jz3INrU=
Received: from DM5PR12CA0069.namprd12.prod.outlook.com (2603:10b6:3:103::31)
 by BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 19 May
 2022 10:27:35 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::7f) by DM5PR12CA0069.outlook.office365.com
 (2603:10b6:3:103::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27 via Frontend
 Transport; Thu, 19 May 2022 10:27:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:35 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:33 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v6 11/17] KVM: SVM: Introduce logic to (de)activate x2AVIC mode
Date:   Thu, 19 May 2022 05:27:03 -0500
Message-ID: <20220519102709.24125-12-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: da23a182-2661-4aec-5d51-08da398230b3
X-MS-TrafficTypeDiagnostic: BY5PR12MB3763:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3763B6F3962F9F9D7AB34C7DF3D09@BY5PR12MB3763.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F8IsAKxfVSsSSLxOJ4NzR+KL2fgPkMWZEmfqC1Eu0iNyrMELnR/izUMCY8Ls+yqrb4GwfeTFho27yPgp9CORB407Rb2j4UJuMqXezv/ZjynjQpzMAGKh5Avdq7+w/GvG1y688/iXG92UR9ZCunbPemcwMt3jWy3LDIzlqGjO+UuqLXIU5830A+M3gXTiuIp4MsoBwJ3+vo0Iaewh0J8QB9F5DWW97GdVtA8hzuaz8v6kywh7aNKk7FUM4ogy287nC3DiBijuvZ9VX7t/zx4rV/E91lBEisqLiE03Dzsn7+vhNg4El9BuGWfkSwGj4yzdutDDG+EtirmtcFPP/YVy32iSckA1rtSQHFGsQIMmWHxw7ULVjzFCUAsNwP8+l16KcZZ+8vo6s5sCTm4hiJnZ/ByFluKQuM3lzn6Wz4deEZR6PlJW5vzOTZZFs9WZadWO1LNrEjKt25yfpjiyFRgFFxqiOPt5xBPJ+dJCOzmv2Psc+rCagYQadBAZSpi195KDgkse5rCQbSLD8i5lyUcPVdDjpgm+sWrMTDop2KY3BCzqkaZ1fgxfgfaYE3Qt3d4fJVa5KzFWhd7yT5kDy8LSbqfw23gm0FKLnny32iSoNM39GXjQy9+7FXeN8ePv7N92AbNS7NG6MjYkIyt4h6wQoFAwXbusB91ul8F6TIJ3BsKibNVJw6ZkopBjniqBKFHuNQBK6Hul+1GQAYximmnV+w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(40460700003)(36860700001)(186003)(54906003)(26005)(2616005)(16526019)(82310400005)(110136005)(316002)(356005)(426003)(36756003)(508600001)(8936002)(1076003)(47076005)(44832011)(6666004)(70586007)(5660300002)(8676002)(2906002)(4326008)(7696005)(81166007)(336012)(86362001)(83380400001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:35.0845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da23a182-2661-4aec-5d51-08da398230b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3763
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce logic to (de)activate AVIC, which also allows
switching between AVIC to x2AVIC mode at runtime.

When an AVIC-enabled guest switches from APIC to x2APIC mode,
the SVM driver needs to perform the following steps:

1. Set the x2APIC mode bit for AVIC in VMCB along with the maximum
APIC ID support for each mode accodingly.

2. Disable x2APIC MSRs interception in order to allow the hardware
to virtualize x2APIC MSRs accesses.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/avic.c    | 39 +++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.c     | 18 ++++++++++++++++++
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 4c26b0d47d76..13d315b4eaba 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -256,6 +256,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
+#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
 
 /*
  * For AVIC, the max index allowed for physical APIC ID
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index aa88cef3d41f..d40170082716 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -63,6 +63,36 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
+static void avic_activate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+
+	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
+		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
+		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
+		/* Disabling MSR intercept for x2APIC registers */
+		svm_set_x2apic_msr_interception(svm, false);
+	} else {
+		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
+		/* Enabling MSR intercept for x2APIC registers */
+		svm_set_x2apic_msr_interception(svm, true);
+	}
+}
+
+static void avic_deactivate_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+
+	/* Enabling MSR intercept for x2APIC registers */
+	svm_set_x2apic_msr_interception(svm, true);
+}
 
 /* Note:
  * This function is called from IOMMU driver to notify
@@ -179,13 +209,12 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+		avic_activate_vmcb(svm);
 	else
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+		avic_deactivate_vmcb(svm);
 }
 
 static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
@@ -1076,9 +1105,9 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 		 * accordingly before re-activating.
 		 */
 		avic_apicv_post_state_restore(vcpu);
-		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
+		avic_activate_vmcb(svm);
 	} else {
-		vmcb->control.int_ctl &= ~AVIC_ENABLE_MASK;
+		avic_deactivate_vmcb(svm);
 	}
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 31b669f3f3de..0ec2444c342d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -746,6 +746,24 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 	}
 }
 
+void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
+{
+	int i;
+
+	if (avic_mode != AVIC_MODE_X2 ||
+	    !apic_x2apic_mode(svm->vcpu.arch.apic))
+		return;
+
+	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
+		int index = direct_access_msrs[i].index;
+
+		if ((index < APIC_BASE_MSR) ||
+		    (index > APIC_BASE_MSR + 0xff))
+			continue;
+		set_msr_interception(&svm->vcpu, svm->msrpm, index,
+				     !intercept, !intercept);
+	}
+}
 
 void svm_vcpu_free_msrpm(u32 *msrpm)
 {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7e53474c8834..309445619756 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -551,6 +551,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 			  int read, int write);
+void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
 
-- 
2.25.1

