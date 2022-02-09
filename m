Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1013C4AF522
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 16:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbiBIPXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 10:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiBIPXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 10:23:01 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBD9C05CB86;
        Wed,  9 Feb 2022 07:23:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwhiSResrggktMJyjrOvKHOg8VDQppjcaxTMy+DfMm9qmXz/nmLnEWhmGyv4OU3D3bg7s5cz//JWkN5klHKHjZkJXckueqWUEoDajrGbbgoHPljWf3ZdmABiXCe4PW3tg/o3TiOwKL1rNLXa12LCJNciEL5ArrwEOMr55t1fd8yrHrrfh871IFnTVypky7QmZNlj8jC8riJ6l8q1vJfP8mcrQmeBz8SdHvXEV82wmb6dd7PKuEYtyp50jSKIMqMJYbtZKMFFdEX7BdndTA92jybdVetG65YWIwkSh3/Txua2vLh+Bw6IbxRLfQHYw7KwPQyVXCuJnb/Pb7nvNMkDkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJ7ONnk0TLdhlVL5b9RWLdTrzo4diA46HHcN4K4CP/c=;
 b=kcQpjaFQ494fjkW5/RiTxVHeJ1XjR2U6ZOGVePnwSCRYkK3IVZiOS+u4fgPosn0bjjnFd8FOa6FvOOAuF2DcozEQoBgKfeyUzmWWOnRKlhJQ5USkaDWhKvfgG2kmk5A+RuzsDQTd2pje4SQOLXZji1uIivCHsmJwSt2mqZ7hyYgtfxbrPyN9Qwy+4x45IuNsNNAoEvwiAjVkUYEBmBlOXJMzMHyo96DUFvb8JQTsibZOhLZCCQej+5XRR/sqlYtkj5xsRS40nGdEqfzXKn9MUL8i2g2NLekzZt2wtgiGHSszR5EC8b87BvLg+pwqJKTJXUbHOe0n1pX1Zd0HQw/AcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJ7ONnk0TLdhlVL5b9RWLdTrzo4diA46HHcN4K4CP/c=;
 b=vWQYUqwhoA1WQIct1gKRGsvYpt8uKq4VM00Sf1ugAog4rK0+pk+p0uy/FQea11L+sZSxrk8vUonbgMa9RS7o7NkYXdDEW0BSYo+VLRQIbEYh7CZbfRPRJxycBVCg8E7hPTz/wvvIhTXakkmVsHlvv28muvEe4XNMbaq4AJsPUQM=
Received: from DM5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:3:12b::16)
 by BL1PR12MB5030.namprd12.prod.outlook.com (2603:10b6:208:313::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 15:23:03 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:12b:cafe::dd) by DM5PR04CA0030.outlook.office365.com
 (2603:10b6:3:12b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16 via Frontend
 Transport; Wed, 9 Feb 2022 15:23:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Wed, 9 Feb 2022 15:23:03 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 9 Feb
 2022 09:23:01 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <seanjc@google.com>, <mlevitsk@redhat.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5] KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255
Date:   Wed, 9 Feb 2022 09:20:38 -0600
Message-ID: <20220209152038.12303-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5a7c7e9-41ad-4ea0-cdce-08d9ebe0108e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5030:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5030891D0654D48F398B591FF32E9@BL1PR12MB5030.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8y0XKDRfijKlspS7HK9fj06T688etpa7yPyKvIvfdUi5iq+Q2SuPCAjqH8F8EFCyc5OUG4tJzu/aO7ZmUtzJSGjLXA5iFjieU7SwYbh8xcELBfXVddAo+gYda6/42YC/UOjjy+p5I8T8SbIFnAsvvRdqUgL5UD3/qKNRnhvr3meqX09cmIe5rmzHzJ0XDiSs8JwgwRVWuQIDgNVeTWpbWULSdGRHpthi8MIFtYdEJbHpo7FPgLIF0vVvHZgZtijWqsCTsDWDGATQG8DUDHL0xqxfDQW3pvXJKEogYRLlODalkMCRPVreJ+8QvRKunjwQc8H+Y6o/3bzwQ1GRRMqs/tfR8Z/HSTHOKjI3eNRZ3A1d9S+vtxjnUczv4Gz8rUH39ij/SSgpcif9Q/ewt6lTRN1FraqHSUBaZK94/inPPOnHmPCHG0SKTNZmGJAbjf4FI9QQfYMGWBT+Nk7SXDrRpIgfyD4pZu7NDFznuLouudT99KrTdAsOqlKxF25woIJYFp7tc/n/Dl6rnc3FGe6dONRVpYOd6iPqomJElrOmyB6mmxGJKQsa55whYzSls6UEByrNvwm1OqjCRyQK6TcroD9I3QfmEqHe0jUM4io4/dQU6aoP/9tXPTVOx1UaWUj+nTZpVAjRo8LxSgxxEQvkNr/yJa2fXVupynysguaVZwKLr7YcsGGWfEemlbHXCi8t/unqPPjYnS8cOUdpk8eLeQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(70206006)(8676002)(70586007)(81166007)(47076005)(5660300002)(8936002)(54906003)(110136005)(316002)(36756003)(7416002)(2906002)(44832011)(426003)(82310400004)(336012)(7696005)(508600001)(186003)(16526019)(1076003)(2616005)(26005)(356005)(83380400001)(40460700003)(36860700001)(86362001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 15:23:03.1538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a7c7e9-41ad-4ea0-cdce-08d9ebe0108e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5030
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVIC physical APIC ID table entry contains host physical
APIC ID field, which is used by the hardware to keep track of where
each vCPU is running. Originally, this field is 8-bit when AVIC was
introduced. 

The AMD64 Architecture Programmer’s Manual Volume 2 revision 3.38
specify the physical APIC ID table entry bit [11:8] as reserved
for older generation of AVIC hardware. For newer
hardware, this field is used to specify host physical APIC ID
larger than 255.

Unfortunately, there is no CPUID bit to help determine if AVIC hardware
can support 12-bit host physical APIC ID. For older system, since
the reserved bits [11:8] is documented as should be zero, it should be safe
to increase the host physical ID mask to 12 bits and clear the field
when programing new physical APIC ID.

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 8 ++------
 arch/x86/kvm/svm/svm.h  | 2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 90364d02f22a..54ad98731181 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -19,6 +19,7 @@
 #include <linux/amd-iommu.h>
 #include <linux/kvm_host.h>
 
+#include <asm/apic.h>
 #include <asm/irq_remapping.h>
 
 #include "trace.h"
@@ -974,17 +975,12 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
-	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	lockdep_assert_preemption_disabled();
 
-	/*
-	 * Since the host physical APIC id is 8 bits,
-	 * we can support host APIC ID upto 255.
-	 */
-	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 47ef8f4a9358..cede59cd8999 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -565,7 +565,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
+#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-- 
2.25.1

