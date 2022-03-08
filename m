Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B671D4D1D80
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348457AbiCHQkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348444AbiCHQkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:46 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41624BFDD;
        Tue,  8 Mar 2022 08:39:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2MyiIv0yVEseJUSQTAooOnNnLQpQg+hmwlKJYDZMZRhUFKjv4m9VDFUeUBrQV/cYK1kmPy085iHgky7CVhgzBprfIJ4W+FB3XKP+BnFHc+1oSEtb8K7baUxVBEhptoAd9iZCRuvn3AB2W6EoITK8M691fU6C54Ll/X2EwU8udijtJUmHanB5ZJPuT0HRuULr/QjGF2X7Tdn7vYkT8QrJBZ/oqUXHhUCgxNEW86W6sAHeYARCzj6D1fCl6Gohqfhi2bAsJOxCQONv9eCgxHM4r5Oj6y84jd28GNahaa3ClYolipsV4SRn3XOb5fxWdxspAfwE3vzVGIMwtDZ1iOuDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EF3F/eXn99wcO2nft34mQ1TEmvoRUoFSqYcVgPIVGlA=;
 b=JMROCVobUdqE2mdJ9QP8YyXqEySZkamSAd/OakzTJJCyt8diB6FXH4YhBRzInVKFluuBIjieM9PF3Q291sqOv2YyclfZPiQXzwatKTnU/Wq0v3z0IOMGj19hBWQe8LX+lkJdvf+PUOqbQ9fn28SC0BzhF2P8CDFXfeCXxDGN4MhrTuXg+nJS5JSizRR8bY6hZUtiXzK95a8lDut6KXsQL3J/GiGVg6lXV1otc+YE3coJ9haqLIr3g7JYVQ3kVW/yixxqwH/KNiwKM9zUNCEtICk0+P/JBmeuZl0zqPy3JSk8OY0XhiFk9OORt3afclBW2Ix57BkFe7SocusP9LTJFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EF3F/eXn99wcO2nft34mQ1TEmvoRUoFSqYcVgPIVGlA=;
 b=Ha2AHNxLPOR+4FALp5sN1Jjg7dY7wFMGurUzo8F18HtVcPkHuurVCHifAtzIE39jbr36aJuB2NMz88wx220DqtGORbRtPZO9J5DWFL3HXvLee6e9fAJr6IFijr5tD+8UuxPvCpZyruokCre1ig5pw2jbs5daLYGGaMzGqg4vwuY=
Received: from BN9PR03CA0310.namprd03.prod.outlook.com (2603:10b6:408:112::15)
 by BY5PR12MB4836.namprd12.prod.outlook.com (2603:10b6:a03:1fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 16:39:48 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::e8) by BN9PR03CA0310.outlook.office365.com
 (2603:10b6:408:112::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:47 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:44 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 05/12] KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
Date:   Tue, 8 Mar 2022 10:39:19 -0600
Message-ID: <20220308163926.563994-6-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: dcb41e45-b34a-4f0c-3aab-08da012241dd
X-MS-TrafficTypeDiagnostic: BY5PR12MB4836:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4836B7C03B3FCCFF18230763F3099@BY5PR12MB4836.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsfz2KkHqMHnAQ7L0Nn/12h95Yi1k8fajrnTL7PBsE0h5oC5SRCsgRyegj4Rif3wyvJ1yvoaSulZLKkYEaSoqUfNqiRvM+BHz4hFO8BZtu9kq5vN0qYgu+znnxubzLLQDzZOl5NqPxaSBGPMdKdISWmkTWucvjsyr1/1hyDWVJiLNi4ZsKenlolThuYh7qBSp2eZgqcvoIWmNwVlZD8uK10pql3w3jw/VW8pW3oWtKiPjjSjH2+DliUAqEGbRVBR6/vtC/1/gNy1QOB6lwfpVb/C5ivmxejW4QOOCdlp8kjY2FXoX3BkK+bFebXvumsq8OGKZCpnb9urMLKyN/SzmvH3KCvaI8ik5DJM59wNsUJqYwF8ktdzYfm7OI7oA/GHOw+dItxAFDkJHC1/1cnGQEzaVQXTIUmDTpeBsazPKAV6f7kLK9ypwIrkHabp8d5PAgfGAwwezJZlzoB5j8SD3UpadeyyqUGImSdE3VjmeTe0KUNmumwpkDnaBuP1L317RGSjJchLvxAcR21UeSMmxwCVGCnMf6qe0s+DfkljEBPeQuBCiGWDYeZtkTO+haGYQRIvlOjgkBXtWSbUQiYLRwtQzQd6jK8WLhLKQ4MPpFAfwDlWyFzOfea9Dab2PTXAkiyzmz6OBmj5PP51pAzXwlsTszAs966W+WgV3BPGHi4Ct46PgZqQYir0/EU8jSSfe+qE5iE1ddEx7VeL9eRMbA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400004)(316002)(4326008)(110136005)(54906003)(336012)(8676002)(70206006)(40460700003)(70586007)(86362001)(44832011)(426003)(8936002)(356005)(81166007)(2906002)(5660300002)(15650500001)(2616005)(26005)(186003)(16526019)(1076003)(7696005)(6666004)(508600001)(36860700001)(83380400001)(47076005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:47.1254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb41e45-b34a-4f0c-3aab-08da012241dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4836
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In x2APIC mode, ICRH contains 32-bit destination APIC ID.
So, update the avic_kick_target_vcpus() accordingly.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f128b0189d4a..5329b93dc4cd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -307,9 +307,15 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		u32 dest;
+
+		if (apic_x2apic_mode(vcpu->arch.apic))
+			dest = icrh;
+		else
+			dest = GET_XAPIC_DEST_FIELD(icrh);
+
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					GET_XAPIC_DEST_FIELD(icrh),
-					icrl & APIC_DEST_MASK)) {
+					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
 			svm_complete_interrupt_delivery(vcpu,
 							icrl & APIC_MODE_MASK,
-- 
2.25.1

