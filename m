Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A2F50055A
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 07:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbiDNFOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 01:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiDNFOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 01:14:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7041E1F60E;
        Wed, 13 Apr 2022 22:12:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R79G6clEWdMWot1l7aH+IulULJyS2S2AbCXYR7AbpOmJBTUh3Xibc8OWT+OO7tOi7IUl9UWKpeK7cEC54zl9B7O7wYfKniGP0Ds54FBBWq6DaGh9IaZlgWTJlc5ptYwtVEFG2bLSI+oc9U/jpn4nI12b1WpSF5vm0ByCN2f+lAsLV2XfN3qKAz0xt2xY0if5sVMBZeMTBcO/waiPEKhzVXL/n+74uaqqoafbLoJyLIVUubgir3YlIbvQMQua0749OS8LlYIjoYDCFoyeL7cNm/b2PwleBW5OQU71hhUsS33Av+ly3/Ac1B6VRuuwoe2edQonYfblMux4tV9W44vZnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLSsYGn6y0bFiHoejhHo6Iu1yjge2PUTymWV9fs1kX0=;
 b=LdeZ2pGtItV35DzHbnfi1Z7fPw9lfHbIYRjF/7oyF9HVeyLyVpiRAOMIeZ7SIlZ0Ws5EjwT2k+LYwGwI6aSbg2+tShdGSvV9NCc5Q3Z239UONIVlMwctcH9vkjWu+6J2JFw6xxET6TmBBBIU+86Ero6xt1w3OVVS0TAg8JL8BVV1OPrZPbH+wO/jQK/8JemmGpHeoitH4L7LgU6dgETUnZH5d1szLHXNlBYNoRXhm+jQ36gGWTEeEUyqkvZegNvxwA740L9RxIHdmmFq1YqMMlTx++bC9YRQWkrSwoiLSDToB0b9oRVoAbzL5kK/ufMULL5cWo7I7g87KrZYuTvSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLSsYGn6y0bFiHoejhHo6Iu1yjge2PUTymWV9fs1kX0=;
 b=gdsbWo92XtTcB+w0IzpeiPv1VhvLrfBS0Xfb79xqxrORcurQP7UEJApm03GAWe3bsaLnSyNBKKYmF9QR91BSG2pEIexu+fMPjmSHjC+RFYgFtqJav76u2MwotVKeLRZw0TClywSALcwSfUH7i2EM0QVVIMmQWCixDNnT24rcYag=
Received: from MW3PR06CA0022.namprd06.prod.outlook.com (2603:10b6:303:2a::27)
 by PH7PR12MB5853.namprd12.prod.outlook.com (2603:10b6:510:1d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 05:12:10 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::25) by MW3PR06CA0022.outlook.office365.com
 (2603:10b6:303:2a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26 via Frontend
 Transport; Thu, 14 Apr 2022 05:12:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 05:12:09 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 14 Apr
 2022 00:12:06 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/2] KVM: SVM: Introduce avic_kick_target_vcpus_fast()
Date:   Thu, 14 Apr 2022 00:11:50 -0500
Message-ID: <20220414051151.77710-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
References: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76db8781-5ea8-4262-8f7e-08da1dd55392
X-MS-TrafficTypeDiagnostic: PH7PR12MB5853:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5853891BA51F7311FD08332DF3EF9@PH7PR12MB5853.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWOnGacNzipLmvmShSWpI7PHOOHgEStTJTYhIKkKHNfT4LovCcKVDfiwF/Z3wIwwq8jqrpd89zwnXZiBVsEdYe7ddgDLHU3wl4wesg55lG7cENftACCb4qgMn/41Ma9RvnsDa1JvR3TFbKJJw+YTkpPiPe7WF+i3Kez/aUH9YCQlmmRxKl4QMjz1Pw5dntl+Fkcus1LMuZJJU4mixvwo2cW3qPMRcMK7UajqcqeF7qCr5zkWyaFFaJnIv8+oYn/8MOzH77Uf0LHvDYnvc94q4D4IhK3unuQsrndhruxu8BA75mAGgownKLhaYGs9X20zQtl6f8Xc5wnkPHsphiE4NrgYr7hAGZzskoFFHJnU9Mt4EJ6FcBupyfwomu1L/y1WQ5uuZQ69uiGh6QdGm0aUqsjwJ7V+eYGmyj38sP5vkjaFUwLszqcfSk56qUqu4rfb1/6RXJMQ9Axiti4o0HOQ3/2TZZwqgALvmJe25/ogLXA6tGQDYRFT6Y0qxbVCB1iIjXjxTxSElULa5GOLac0rltaPZFmB7i1kZCUxZRzc/kZweZr2GkQSm8XzRgmcCubUsCCzc8PDhtwfWW3RkVd1TEsSet6+t3MEMwyLUNLGvhPLE5lqqKQWbDbo4ZAk3OV5Za3piy/sqqo8cTuLiNNVyNgI1CBIog+/v16D5sk8eMMnJi6bCCg+habbyRGDVXEYaA8MCR3irLTji5+mm4PxGQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(2616005)(82310400005)(40460700003)(1076003)(70206006)(8676002)(110136005)(336012)(7696005)(316002)(6666004)(36860700001)(36756003)(2906002)(86362001)(426003)(16526019)(508600001)(186003)(5660300002)(54906003)(26005)(83380400001)(8936002)(47076005)(81166007)(356005)(44832011)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 05:12:09.1825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76db8781-5ea8-4262-8f7e-08da1dd55392
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5853
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, an AVIC-enabled VM suffers from performance bottleneck
when scaling to large number of vCPUs for I/O intensive workloads.

In such case, a vCPU often executes halt instruction to get into idle state
waiting for interrupts, in which KVM would de-schedule the vCPU from
physical CPU.

When AVIC HW tries to deliver interrupt to the halting vCPU, it would
result in AVIC incomplete IPI #vmexit to notify KVM to reschedule
the target vCPU into running state.

Investigation has shown the main hotspot is in the kvm_apic_match_dest()
in the following call stack where it tries to find target vCPUs
corresponded to the information in the ICRH/ICRL registers.

  - handle_exit
    - svm_invoke_exit_handler
      - avic_incomplete_ipi_interception
        - kvm_apic_match_dest

However, AVIC provides hints in the #vmexit info, which can be used to
retrieve the destination guest physical APIC ID.

In addition, since QEMU defines guest physical APIC ID to be the same as
vCPU ID, it can be used to quickly identify the target vCPU to deliver IPI,
and avoid the overhead from searching through all vCPUs to match the target
vCPU.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 91 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index abcf761c0c53..92d8e0de1fb4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -351,11 +351,94 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
 	put_cpu();
 }
 
-static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
-				   u32 icrl, u32 icrh)
+/*
+ * A fast-path version of avic_kick_target_vcpus(), which attempts to match
+ * destination APIC ID to vCPU without looping through all vCPUs.
+ */
+static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source,
+				       u32 icrl, u32 icrh, u32 index)
 {
+	u32 dest, apic_id;
 	struct kvm_vcpu *vcpu;
+	int dest_mode = icrl & APIC_DEST_MASK;
+	int shorthand = icrl & APIC_SHORT_MASK;
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
+	u32 *avic_logical_id_table = page_address(kvm_svm->avic_logical_id_table_page);
+
+	if (shorthand != APIC_DEST_NOSHORT)
+		return -EINVAL;
+
+	/*
+	 * The AVIC incomplete IPI #vmexit info provides index into
+	 * the physical APIC ID table, which can be used to derive 
+	 * guest physical APIC ID.
+	 */
+	if (dest_mode == APIC_DEST_PHYSICAL) {
+		apic_id = index;
+	} else {
+		if (!apic_x2apic_mode(source)) {
+			/* For xAPIC logical mode, the index is for logical APIC table. */
+			apic_id = avic_logical_id_table[index] & 0x1ff;
+		} else {
+			/* For x2APIC logical mode, cannot leverage the index.
+			 * Instead, calculate physical ID from logical ID in ICRH.
+			 */
+			int apic;
+			int first = ffs(icrh & 0xffff);
+			int last = fls(icrh & 0xffff);
+			int cluster = (icrh & 0xffff0000) >> 16;
+
+			/*
+			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0]) contains zero
+			 * or more than 1 bits, we cannot match just one vcpu to kick for
+			 * fast path.
+			 */
+			if (!first || (first != last))
+				return -EINVAL;
+
+			apic = first - 1;
+			if ((apic < 0) || (apic > 15) || (cluster >= 0xfffff))
+				return -EINVAL;
+			apic_id = (cluster << 4) + apic;
+		}
+	}
+
+	/*
+	 * Assuming vcpu ID is the same as physical apic ID,
+	 * and use it to retrieve the target vCPU.
+	 */
+	vcpu = kvm_get_vcpu_by_id(kvm, apic_id);
+	if (!vcpu)
+		return -EINVAL;
+
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		dest = icrh;
+	else
+		dest = GET_XAPIC_DEST_FIELD(icrh);
+
+	/*
+	 * Try matching the destination APIC ID with the vCPU.
+	 */
+	if (kvm_apic_match_dest(vcpu, source, shorthand, dest, dest_mode)) {
+		vcpu->arch.apic->irr_pending = true;
+		svm_complete_interrupt_delivery(vcpu,
+						icrl & APIC_MODE_MASK,
+						icrl & APIC_INT_LEVELTRIG,
+						icrl & APIC_VECTOR_MASK);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
+				   u32 icrl, u32 icrh, u32 index)
+{
 	unsigned long i;
+	struct kvm_vcpu *vcpu;
+
+	if (!avic_kick_target_vcpus_fast(kvm, source, icrl, icrh, index))
+		return;
 
 	/*
 	 * Wake any target vCPUs that are blocking, i.e. waiting for a wake
@@ -388,7 +471,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
 	u32 icrl = svm->vmcb->control.exit_info_1;
 	u32 id = svm->vmcb->control.exit_info_2 >> 32;
-	u32 index = svm->vmcb->control.exit_info_2 & 0xFF;
+	u32 index = svm->vmcb->control.exit_info_2 & 0x1FF;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
@@ -415,7 +498,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 * set the appropriate IRR bits on the valid target
 		 * vcpus. So, we just need to kick the appropriate vcpu.
 		 */
-		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
+		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_TARGET:
 		break;
-- 
2.25.1

