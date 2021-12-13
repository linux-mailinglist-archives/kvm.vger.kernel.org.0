Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08640472B74
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 12:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhLMLc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 06:32:27 -0500
Received: from mail-co1nam11on2059.outbound.protection.outlook.com ([40.107.220.59]:47648
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232749AbhLMLcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 06:32:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DR2Ps2MpT5NyigLyTzE2kwdaStqMAfQPD+86ByocFhi5ukn6cuRK/F7ZVbBPXTg+yzaOD44MwDLY6vosTzRuZVdSG2Zs3lGh4+/jw36kdOSqPLd7AgYq+ka04x4D9HnZamgjCuXLhRYeBqtpClcutu0r6E1UJCmx/H25JmJee+bbY5kLYx2lSdvYJhF3k1mLo2MnTah4ebBr5iGN/DHM3GKURj1gHmMRhQhddEwV0LgGcX50j0A9/yzobY6vl1PRyZi3HCeFcka9UuV9BgfyWaBlw36M1ofdrDbkuz1J/iTDikDQeD536jpRqcUac6n7UOV1/pbUQghMPPN02IeF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kPwuqZluklZDSy5si7Iquhv2AuUSMJjWRathjXjSnQ=;
 b=I4C4jMRrdp8sJzGBSsq7/x3CLSf4vqUH+8kKGZ0nuCB8i8e/CiO7vKXY2Q3JY5eIS9iDARG2B5+5LtHmT5L0lTiG0rPoi0JciL0TAQ1heSr2hZ9eIpFCAV1fdu7EBuIGKNeSLmu2ssuBPZ7Dblhx9fPUUdR7qG87Z6jplEg3tAZFiM7q/YvONtZQkO1tePwKoL7fQ0mIdqBQhGAxcUbG0SnGsAAb0ldzXh6RkRNeMC9S31rCnjegMaCDsJmJBK84o40GJHPB/SG7112VVaen1ihnZMR5SAPKOw5q3RloTDn7G3kvjc2ctsUAt4SwQk7PhbK5dMXjNp8AaaoRBv31rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kPwuqZluklZDSy5si7Iquhv2AuUSMJjWRathjXjSnQ=;
 b=w0crFPn1s+HNlhPWrNG6Rp/9INZx3JDzBN7m19Jq2sPtVkoFdgp8zdwmAT+HGGyTg6mf/D2/rg/aSlopx52OgEbF977ItQlMGDk6T0J8Uq+omCSk8ewr1xdLnJtiZTBGiaUt/X6ExNdYoJZCGcCBzCuiH0lx9PyjIp+aNcWB8aI=
Received: from DS7PR05CA0033.namprd05.prod.outlook.com (2603:10b6:8:2f::20) by
 CY4PR12MB1319.namprd12.prod.outlook.com (2603:10b6:903:41::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Mon, 13 Dec 2021 11:32:19 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::20) by DS7PR05CA0033.outlook.office365.com
 (2603:10b6:8:2f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.13 via Frontend
 Transport; Mon, 13 Dec 2021 11:32:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 11:32:19 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 05:32:17 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <seanjc@google.com>,
        <mlevitsk@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <thomas.lendacky@amd.com>, <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 3/3] KVM: SVM: Extend host physical APIC ID field to support more than 8-bit
Date:   Mon, 13 Dec 2021 05:31:10 -0600
Message-ID: <20211213113110.12143-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12ae0fde-6c5d-42c5-35e3-08d9be2c38f7
X-MS-TrafficTypeDiagnostic: CY4PR12MB1319:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1319A31D5EF91B67E80489B1F3749@CY4PR12MB1319.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F2/VarkY+4+OS68h8Y6XqkzgAUrjZtoJ3Wa3jeMA5LxKyD3qCQTdQF2hmrkGQDaunn6sfm8IgHRQwEx59NWVdZIGcGS2QL3FvN28gWCkeb619HylFL+SYGN7YhhKBvFrGN1GVYrAB1lv5Xnu0q4B9mA0LUFCFUQlsrEfx51xZAG6NW0kfpkWzwkHmzCaVKrWnWYvbUjBmw0d6cqBGtjX83pwLwgW9FE7WGiqIRmwSvG7L+edctrX5cMCnVIUlg8t0r89bg9J+Ewiet1eviT+9yRXX4RC2GR7aBRoO65Gq1Ssuu8n0WnHF516wjj+zNXCdR3W9ypOgyY3nm0WPIZT8nWD2ozY7ksJk4qkqOY0SmATvlp3hFMdwgcxjHwAjRSyGn5BIIObt61Z2pMZW41H5wNYG6d4qbFE7buMjUc/pOaiS6jDSGbtzo9eUJVnBSt/EsF1JpJAdbH40txL4JkefsmDTgX6Ihgpzr+vi4VLy9oDKJurkJB7gD1tjuppDjwSbhQv2W5OEe4fl7+HitEHgV7cgRPp0VDK7TCmDQjT8HWiWbEEnGATYF2hBO19HQ1y/UghKzyftOS+Ymvd6nJv8lRZkY6ZMwvHbjFZ+MGCKPwaXsmBcpLXburpnTwjk8oBFT7ZLbn4Nar5kx4bjRtTeugbwOMM4HpLdSPNXqMGJZO2nW117cziKDz1AVp4If3HZS5mwcPcgozlaRTbhuSXyWOW2MyGBcARi/xv1JzFFMNYZteP83Vg19xGhH13dUg3n4jC1clheW1EB1UJrWIvoz0XwypgugEes4thsoJ/ILY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(81166007)(44832011)(356005)(8676002)(36860700001)(508600001)(336012)(8936002)(4326008)(16526019)(7416002)(6666004)(2616005)(186003)(86362001)(26005)(2906002)(316002)(70206006)(426003)(54906003)(110136005)(36756003)(82310400004)(83380400001)(1076003)(40460700001)(70586007)(5660300002)(7696005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 11:32:19.2406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ae0fde-6c5d-42c5-35e3-08d9be2c38f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1319
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AVIC physical APIC ID table entry contains the host physical
APIC ID field, which the hardware uses to keep track of where each
vCPU is running. Originally, the field is an 8-bit value, which can
only support physical APIC ID up to 255.

To support system with larger APIC ID, the AVIC hardware extends
this field to support up to the largest possible physical APIC ID
available on the system.

Therefore, replace the hard-coded mask value with the value
calculated from the maximum possible physical APIC ID in the system.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 28 ++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h  |  1 -
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 63c3801d1829..cc6daf5b91d5 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -19,6 +19,7 @@
 #include <linux/amd-iommu.h>
 #include <linux/kvm_host.h>
 
+#include <asm/apic.h>
 #include <asm/irq_remapping.h>
 
 #include "trace.h"
@@ -63,6 +64,7 @@
 static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
 static u32 next_vm_id = 0;
 static bool next_vm_id_wrapped = 0;
+static u64 avic_host_physical_id_mask;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 
 /*
@@ -133,6 +135,20 @@ void avic_vm_destroy(struct kvm *kvm)
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
 }
 
+static void avic_init_host_physical_apicid_mask(void)
+{
+	if (!x2apic_mode) {
+		/* If host is in xAPIC mode, default to only 8-bit mask. */
+		avic_host_physical_id_mask = 0xffULL;
+	} else {
+		u32 count = get_count_order(apic_get_max_phys_apicid());
+
+		avic_host_physical_id_mask = BIT_ULL(count) - 1;
+	}
+	pr_debug("Using AVIC host physical APIC ID mask %#0llx\n",
+		 avic_host_physical_id_mask);
+}
+
 int avic_vm_init(struct kvm *kvm)
 {
 	unsigned long flags;
@@ -943,22 +959,17 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
-	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/*
-	 * Since the host physical APIC id is 8 bits,
-	 * we can support host APIC ID upto 255.
-	 */
-	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+	if (WARN_ON(h_physical_id > avic_host_physical_id_mask))
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
-	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
-	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
+	entry &= ~avic_host_physical_id_mask;
+	entry |= h_physical_id;
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	if (svm->avic_is_running)
@@ -1018,6 +1029,7 @@ bool avic_hardware_setup(bool avic)
 		return false;
 
 	pr_info("AVIC enabled\n");
+	avic_init_host_physical_apicid_mask();
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 	return true;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3fa975031dc9..bbe2fb226b52 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -497,7 +497,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-- 
2.25.1

