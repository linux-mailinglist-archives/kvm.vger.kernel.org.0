Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2764D1D7F
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348502AbiCHQkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348469AbiCHQkw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:52 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C765B517D7;
        Tue,  8 Mar 2022 08:39:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yef1yiYcj495023eMqaho8d2sOdfL4PsbN2nK4SrJT08GMjdhjKAY4P2wIUNVu8AIuQOVKZq9IZ9r1NDC8QOsvDjDZc2fGsRHy3Q+FqVlDDMe+8eQXNw11i4gnUPMtGhpsLERmBwUN/Q+gveFRm8Wbomvv3dvBtONmikoRUggX/17K1C8b9rkYmKIKVRCxUvkBH/pdhhKrLVPF1ezpepstY1IFiqvn34QwhOLkGzQgAnZIuMZ/DKixY18dK63n1LSytlhSWP6se6YCghIt3DIqhONixI7OV/DjQPgPOKXS6VJc9jo0YRbZy52aKQCTv9R/SuoY0Rrvld+Z5aFLZDKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HIz0qYgdLhzqha9SJoWKM3UBVlaBGI3PcSEWagWFWY=;
 b=hs2iF59IDCRLN3b8+37c9Uh/q+Mg6zVO/2ZWbyv85bIMX/dGJupxm7Ouk3B6+iPhpew2T+qSK4hQ+FQ8Ym6Kvo0WDBu25zVMLbGHqvOjOI/L+gxGtJMIq5ceurhhh3BYVWcHL7AvNQtaakXV36iZy2VC3o+TjeAR4qVQlitJLTFsnzBsHOiDrlsPpxwdHatbZjh+8mfOptArTv0ToeTlO6+x7gvyTWuLhOv2nqItH1/DkAn0QxTZbr5g/kvQrzR42ICzan43ru9ZG9iFEE5S6edUldj3yqQNWcMWBoTvF7KE758Ci+MHybtMo6ZQXnWC8p2jtcJF4lKISzc6p8kl1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HIz0qYgdLhzqha9SJoWKM3UBVlaBGI3PcSEWagWFWY=;
 b=q0KmgC2xoXYUnQkg116hbNgICHFcio5hs0EYHUnOq78iXyYFSTwUbRnu7JBYKWd51/zcoJdVx1he8ZvmvyHA13gpA3kavl/K35zzLYioFbLUIZ5CVsDzuAgyo0i4MjrEwTPErotkwm3R5mj/muVYAkMPo3zc38N5XGK5cJ0ImUI=
Received: from BN9PR03CA0321.namprd03.prod.outlook.com (2603:10b6:408:112::26)
 by BYAPR12MB3046.namprd12.prod.outlook.com (2603:10b6:a03:aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Tue, 8 Mar
 2022 16:39:49 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::d7) by BN9PR03CA0321.outlook.office365.com
 (2603:10b6:408:112::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:48 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:45 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 06/12] KVM: SVM: Do not update logical APIC ID table when in x2APIC mode
Date:   Tue, 8 Mar 2022 10:39:20 -0600
Message-ID: <20220308163926.563994-7-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8768b5e5-ad56-4b99-05b6-08da012242af
X-MS-TrafficTypeDiagnostic: BYAPR12MB3046:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB30469EC8E020C8BBE287B092F3099@BYAPR12MB3046.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yY24P5nvbGFR1jnz7KfuzrkCOIszo4zlHWuL7bzobd7SBlAJ2haIJMDKr6oRuhThWfMMFbU7Oy5ZhU0Y90g64UOcmHB8wkdjIiJWBE1z9NaQIMlqdU9doDLt9bj3SVF2o2gSwRiDVdlb7OHlCK/h2h8Va3Dqwy4S//CvAdZsufisxl3R9XoTzfSn1/NJaMTZBsEW/BCy4yiLVsFfbCe4p5Xv2z8rB6QpuTC/6lGaecdd2J7+vI8Hbg2jUkIkYrvFUZJv5DBpEQv7Qfeolgjy/WJUj7LpAYgJ3c6Ga+Rjw4udAc4IS8HlreULyXg38WlqfiicobgTseWGKj2Lwjv4dru4+/hHP7aXMjvGKFpdYcWCd3vTJ3Cl9ffkXSiMfvLm1DQ5PWeOScKI34uIyto6fqtisTYaFAyzYeA3w/FRpiLkYhi+wSMxMEoMvh2I1A+lLjXvNciF6VP9+8drGN76PUiTsFVSYyB/Dje9D/9Ge5G7EiBApTPG6D7qX/EyNzUEjVmCtHaa3oCFZY2CGR2PSd9zr/rNtmSojletBsby0XzJt9RbzcwouEEianJcjS3xTPqxZ1OqAy3aw0ysCOXwPREEha3e5ImPWzgvVUbQeeStpcUTnK1ZyG7FvR3voFdc3Bk92wgKaCfhyFgNYzRNJ8E3Yt1ymeCpGqOmHBgBaTqy5eh+Fu6NTLpWjFIlMLDVDXsFl7qBo8rAPJDCziaQjA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(16526019)(44832011)(86362001)(40460700003)(8936002)(2906002)(82310400004)(4326008)(36756003)(47076005)(8676002)(70206006)(70586007)(36860700001)(5660300002)(356005)(81166007)(110136005)(83380400001)(54906003)(316002)(7696005)(426003)(336012)(6666004)(26005)(186003)(508600001)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:48.4847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8768b5e5-ad56-4b99-05b6-08da012242af
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3046
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In X2APIC mode the Logical Destination Register is read-only,
which provides a fixed mapping between the logical and physical
APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
and the processor uses the X2APIC ID in the backing page to create
a vCPU’s logical ID. Also, when x2AVIC is activated, a guest write
to the x2APIC LDR register would result in #GP injection into
the guest by the hardware.

Therefore, add logic to check x2APIC mode before updating logical
APIC ID table.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 5329b93dc4cd..4d7a8743196e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -406,6 +406,10 @@ static int avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
 	bool flat;
 	u32 *entry, new_entry;
 
+	/* Note: x2AVIC does not use logical APIC ID table */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return 0;
+
 	flat = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR) == APIC_DFR_FLAT;
 	entry = avic_get_logical_id_entry(vcpu, ldr, flat);
 	if (!entry)
@@ -424,8 +428,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
-	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
+	u32 *entry;
+
+	/* Note: x2AVIC does not use logical APIC ID table */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return;
 
+	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
 	if (entry)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
-- 
2.25.1

