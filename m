Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D89F466E12
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 00:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377702AbhLCACr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 19:02:47 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:53569
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1377687AbhLCACo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 19:02:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUAMkag9qMdDPDoAnwV8sZfxfLfCIkyxuXTXND2eiXdHlZdTj4fGltlO+diFnSJ4i8s/8cCHTrEkThH2fvXF7GsOfweNHtXqoEaZtDQm+Fi7P+Ea20X3ULR5Xlnj5Unpk0ABimlCX/DAPY0unsO0Ld19kA9skMWX7YbKntxeK7Y2MYohc3q8yNUKGgZBssVf5lp8W8tIZ7M1tH5P8kjreQx2eDqX8Qp2QOTTuKYN/zCq3/NKX/q34qce6nExyykUyXPvmltJRv2CGLCTqyLIvMQmjypuqppTkFP1dXut96KMTvRe4Su3UEesd9pPNeTIVwWECGkmR4pe+OqpGq/60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urH6GitdpxxIeiWTqkJA4MM7m/iuRDyJEtfkSrJk0dQ=;
 b=LdhtTDm91VSHFP5/1ZWaQWOLGDf1wQ5NwQppg23UO1/BJI3QFYu8Ztd0YIVlveS1MSn8Pp0CyoLXaOScDHHVWsq/zLUOtFvmKwASt/iwevkxybSxQ4yx2TJcIbb55PuTGU6QCPGBqpxSOtRjy+QEwduPCnJzLmbfGzt1q9Og3PJBqa1P51wUObNvLIlPYXKjPS8IUlpYOFECpnq7MU4BxThjYFTAcQqlDiQzm0oDMnuzBYAf7yvMK95svFMF3lBXYgecq1YnoxdqvbSojJuICCsnYpfJHoR5Bynf69kDjZDbRCR04+XudXh3ktRdvTqgyiT2Ln9F278ummH3bSKphg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urH6GitdpxxIeiWTqkJA4MM7m/iuRDyJEtfkSrJk0dQ=;
 b=ByQArP0oYBNdv0Lkyo1/3PPBcrtG4XQ1aGC+zxamGf5kYv/sdiYL6jh6O5EjDVrGnCStte04z82c7heiBNGezl8Em7AgG3sWe8XQK6YBuPgh1z2hrqplyndwOUDiWaOAyIdgYP3Qm0OItEZo9G2zkauYDjLxlT5yAqrR131lN90=
Received: from MWHPR17CA0079.namprd17.prod.outlook.com (2603:10b6:300:c2::17)
 by DM5PR12MB4662.namprd12.prod.outlook.com (2603:10b6:4:a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 2 Dec
 2021 23:59:19 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::38) by MWHPR17CA0079.outlook.office365.com
 (2603:10b6:300:c2::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend
 Transport; Thu, 2 Dec 2021 23:59:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 23:59:19 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 2 Dec 2021 17:59:16 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <seanjc@google.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <peterz@infradead.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
        <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 3/3] KVM: SVM: Extend host physical APIC ID field to support more than 8-bit
Date:   Thu, 2 Dec 2021 17:58:25 -0600
Message-ID: <20211202235825.12562-4-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
References: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d84b3865-4865-4444-d366-08d9b5efc12e
X-MS-TrafficTypeDiagnostic: DM5PR12MB4662:
X-Microsoft-Antispam-PRVS: <DM5PR12MB4662A8C8B71038E2BDAE4D9BF3699@DM5PR12MB4662.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0lr/t3wSEl9bLxJwgdIws2/cK+FWw5ziegSSDHXCgv7bDwR0N8gibwxayhfuDCPTPNnUFNhs8LmcGx+X/ttGFVbltjf4scNako94Xx9qxc1D5+Irm5d2hKSG6/fPF4PbWnwZr6GQFYJC4zuRZQsdy3ZhAm/oZBPt+FU38GdYsIip6zPqFrkqeC2C3HFyQzn0wTuAUQeAbNlTem+U8tN49I9UbWsQCsuY4y0RPsz+yhoqxqj/IfzEdqBx9AuGJlf5wJhrDTS/eOw1YyXTGBydqKSdWDjyV1avtTuk2rt9Qj1z/Ky1gWu2qn+bsx88H/q4awgOPP2YCHPdfaoE0hHTTjGGdnfZ87JMynxfMOn4boRQv/29TtOPhd1JPNTa2lb73zAMUye41zJjm+JTYZTwEGYyJzX3njRU1A254NBGcepjyI3rLEp9SOe0DGuQJaQ3y4yhYUIBycZk3Ujc3G/aD2aQKshfYO0Kb4l4Q5prckiE0s+02mcHNk9P9iwAhQIJdFJO+XAAumXWX6DJTNztNYUHuHpYNGlNh/Cgc6HeEkBjPPbpkmYwNkj3OSvuIKXU84XkBt18kBoFkVaGUh7FM3IHKUxhEXoILKL7VbvUgtw0r5sHg36ZW/UDkqWV/22vNS33gjkUWjXL0Pxb+xjCM7TQ7R+F8GBvbwwyq/KkIGIPVMyZU1rIu7ucG5V+mh9ATBQBjS2zBtkI0FJCMHaFj4NM0xI9qsNV3ZGk5oeAdEBDw17N7BiR0W8oHoQn9qlKXYp5Qbsc3B58R2HdCYLA+KwFaZLlwssk5o/hqiIjaGM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(70206006)(508600001)(70586007)(36860700001)(16526019)(7416002)(8936002)(356005)(5660300002)(8676002)(82310400004)(83380400001)(47076005)(186003)(110136005)(44832011)(7696005)(81166007)(6666004)(40460700001)(86362001)(54906003)(2906002)(26005)(1076003)(426003)(316002)(36756003)(2616005)(4326008)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 23:59:19.0881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d84b3865-4865-4444-d366-08d9b5efc12e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4662
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

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 28 ++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h  |  1 -
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6aca1682f4b7..2a0f58e6edf5 100644
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
+		avic_host_physical_id_mask = BIT(count) - 1;
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
@@ -1018,6 +1029,7 @@ bool avic_hardware_setup(bool avic, bool npt)
 		return false;
 
 	pr_info("AVIC enabled\n");
+	avic_init_host_physical_apicid_mask();
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 	return true;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1d2d72e56dd1..b4cb71c538b3 100644
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

