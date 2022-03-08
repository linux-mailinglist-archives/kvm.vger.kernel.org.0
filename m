Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445A44D1D84
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348542AbiCHQlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348477AbiCHQkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:53 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F89517EB;
        Tue,  8 Mar 2022 08:39:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihD5vV4NNxNIsNnOcp1kRxR/cY9kHvcZbn6P2yrCrya0AOWUml2u6gb8R22m06DyfOHLNlA5ZzKJ8dJxRtm2pH3cz+jLGMo1DDCHux0fNqrHd49sHwpraEh88Bi0DUOAsruoazS3l4CV+5RrbS/4ZF7yXnfnaWz7yxbYEQdnpzFfHEl7OclshUhRVGPn9dF/aq7ZeV031WPJ7S3nitvKmphSxPt6zylJDn8WFWhfJrIIWXJ5Sew0OpBsaeTWQY4Nk541sKcSnV/eepZ5TVWOb3crJLAAhUvFAjum2Ae1d073SDVSX3Y3dZEVygh/mQ713jIIN0Ky/Mjos05dpbmv/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Jlxww9AZ38FkwptDw07Qq2qcu9/6qYcFIx/ENpXtGc=;
 b=FTaqMKdtfPo0QF7Wt8mKaqkdTt1DY1tMe8IS+aj4shxNDyNMgBXCZmVRQ2Ey/LAcMtZJ97a1Ubg4m92rs78EoPLVZHEnPUwNG45uVNzj8Ek12nSO2sgJ8YWc/1/dwlU/VwzzvvcuIiXX5VQ+HYdDr6/D4o6geJvuXH2kHgqacMiUWsO0bWHs7kPQ29zAU/6OVEBteJPEZwtVDL7DC8ofedDBXZXqykRJscRoiatIruH30lASfoz80h48eHaEkSIvfV7AhW8ZO1yclRd6e8ucV4RN0QuImuX2v5r5DH3SSrR/TRFBkJt3OMPHWp2U2JGWVknWT+ItzZ+QKZSAPW3ynA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Jlxww9AZ38FkwptDw07Qq2qcu9/6qYcFIx/ENpXtGc=;
 b=SySFDvf4uHHFhaPpr7+ATILPmzehDNcFlqUTRa0VX5q5BU51yDhsFW7KtMbrOJzjaodZMxZI6HuFRYOdtMSxjaaii6a8QbrbCmioXws8KjWNLkkGuMq17OyqNErGP9DJF42HruQKt4EwPZBBqpqEY2qLAGwSWS17b8AAMt/re2U=
Received: from BN9PR03CA0327.namprd03.prod.outlook.com (2603:10b6:408:112::32)
 by BY5PR12MB3730.namprd12.prod.outlook.com (2603:10b6:a03:1ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 16:39:51 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::60) by BN9PR03CA0327.outlook.office365.com
 (2603:10b6:408:112::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:51 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:47 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 09/12] KVM: SVM: Refresh AVIC settings when changing APIC mode
Date:   Tue, 8 Mar 2022 10:39:23 -0600
Message-ID: <20220308163926.563994-10-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: fc411b15-97cb-4900-fe09-08da01224454
X-MS-TrafficTypeDiagnostic: BY5PR12MB3730:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3730F5519E65B6984DD8222DF3099@BY5PR12MB3730.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FWMYKs3ilbbvFprCUQo/a0r2y+jpi/13USBh7/xAQhVT7BzL90NsbBwNY3NUHsOylU9Br4rp5avSGz1apzON4S45cyBWEU/g21jhbutHCV4UvKcZmXGIhkpU68L26KKwHd4b2iMn4RlzAsg8JAbhDyBf7oYIgr9Ra3QioEPWrqTpPrrhqOqQTipaNZxT1VvDVZkb7tdr327TaUf379HvRd/3JbQIMcFlcO4JaLgSKLPYcVh0QURRy/Igy1cSDcTsARJAkFlm4BOY43IuorRcfly5qUysNm6DLfZRDmfsRh8vkKh4U6gH7cRHuEfYbdQv6gDC12y9rJ0qbE/KCb/v8G9CDIt2CI1Zd05C1DxbbJkpvtQr5HJKn0K1xo70Uvt+ZQxZK3+WmAr6B8dZ438MSMxW8877RzR0vbCjCSbdoxgj+x5bb0fq9EdlIkTNKgjs/jbuYZPKr/QaPHVZs+FIEwZYjGbN95YHG/gG/hR5rqgt1SpsyH/+61BAeIsNuV1L7tSzivg7Rgi9XrnlcGrR93AETvrSozqKyTHoJUIy10/wm3p13F+VXrlKFrd65nLgmqPOyl4z+rz0ROVYelx9P+aX/GH9HY7EHJ1VZoo3//DggnfJGiBOGvjLZp+GpSeXmy6Vr4ExM3OcJsFUPP0ZLRE/ABxBNX5BR7jEMUolbxVIoNO+y+U7DAkWn2B/Uy9JZH4M1gnGkoDsb1DwyGT91A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(70586007)(70206006)(8676002)(8936002)(4326008)(44832011)(5660300002)(2616005)(1076003)(426003)(336012)(26005)(186003)(36756003)(47076005)(2906002)(83380400001)(40460700003)(16526019)(6666004)(7696005)(82310400004)(36860700001)(356005)(81166007)(86362001)(110136005)(54906003)(508600001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:51.2658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc411b15-97cb-4900-fe09-08da01224454
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3730
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When APIC mode is updated (e.g. from xAPIC to x2APIC),
KVM needs to update AVIC settings accordingly, whic is
handled by svm_refresh_apicv_exec_ctrl().

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 7e5a39a8e698..53559b8dfa52 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -625,7 +625,24 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)
 
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
-	return;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
+		return;
+
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID)
+		WARN_ONCE(true, "Invalid local APIC state");
+
+	svm->vmcb->control.avic_vapic_bar = svm->vcpu.arch.apic_base &
+					    VMCB_AVIC_APIC_BAR_MASK;
+	kvm_vcpu_update_apicv(&svm->vcpu);
+
+	/*
+	 * The VM could be running w/ AVIC activated switching from APIC
+	 * to x2APIC mode. We need to all refresh to make sure that all
+	 * x2AVIC configuration are being done.
+	 */
+	svm_refresh_apicv_exec_ctrl(&svm->vcpu);
 }
 
 void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
-- 
2.25.1

