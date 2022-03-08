Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0081B4D1D8C
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348518AbiCHQlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348479AbiCHQkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B087517ED;
        Tue,  8 Mar 2022 08:39:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmTfsklWAHTHhhStMHr+7vWN76P9bcPoARb3x+9WzRcb77j/BYVnoDARgFMcGkZwnBc48sHitrqzg1ExsArunSdxT3ypp4XlawAaObUXHTzWixKIpp06d5OeoMLZ09hV6ra4K9N4YSm4Mdijca+ZTvkxrudy/fkl0cb3OGEgLlC6nWvgn/kWFFDBENriJ3PYwEzskOibPQkSn+Ut4UJzu0rdxTWa3q0o9Ny+GxUZMowbGcbfjtbwvpGXpf9BmkVi2bZ9AvYLJyNACjngtsCzs3wjmQf0lTnHkryXw0+S34pUNH79Tdk73GSYGVBoqHqciC433AmND8oSoIg6GL/Y9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7baV/MSJ9hz4jZx62DxXN+rlD53rHOXeGJvdA+Bv1Gc=;
 b=hgjX+n/MoMRT/KekQ7DIiglifOsbExgcoC7X6qdIJTO5wkJRG3Lidwv9GaK90TDs5tALqnUm7SI1uX9sYS6E5kgsa5wicWMAhS78LkUCYEHaYppRBZbj0nrDnlse04oDUvNg6J3bV9iuu1ytSou75OhqaDmuaW1Z6fMh2fGHoK19VGApVwojSXjwPTYTOy0k2xT1Wp0u+Vcfmx6OWuYN0s5NhnevyBVBRAtv5+DRj3N1TIBkVgzujwta/UcmBfXupBSmqaAGeuqciDC41ZXpVsqW9hQ84nUHEEDbZIRG8kq6rsdN0rSdyHkezF0m3sIW4g6HHLcELCHkdYSM2GCv1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7baV/MSJ9hz4jZx62DxXN+rlD53rHOXeGJvdA+Bv1Gc=;
 b=l7B63YWsdt/Tm/a2E1DSlVeWGUf1Mr20q0H29h79Bm173l4u7Rb+CjUFhaVfqgRP/3AgkFXW8jvT7rVS2RO4zQZrEWpAW2kxrNPLy0tzHlvcX34sUzCB/I7+y/jQTXQYGyWM24YAkMDjHlKlpRFrXJczTMsVGo5A4JTVKDztCjQ=
Received: from BN9PR03CA0846.namprd03.prod.outlook.com (2603:10b6:408:13d::11)
 by CY4PR12MB1477.namprd12.prod.outlook.com (2603:10b6:910:e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Tue, 8 Mar
 2022 16:39:52 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::68) by BN9PR03CA0846.outlook.office365.com
 (2603:10b6:408:13d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:52 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:48 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 11/12] KVM: SVM: Do not throw warning when calling avic_vcpu_load on a running vcpu
Date:   Tue, 8 Mar 2022 10:39:25 -0600
Message-ID: <20220308163926.563994-12-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0b0695c7-d18f-4c8a-1732-08da012244cf
X-MS-TrafficTypeDiagnostic: CY4PR12MB1477:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1477FF2203B9255AF1114901F3099@CY4PR12MB1477.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uc9RofULCHjuGWEBrhGl1wabvlrzpbbogm+GdgtmsCKQUMRSUGLrAnZ3CY0zIRHAkMDblvl/fz8c3cB6TvkRaKX9zgOzdXlkMT5ZwzH1gNVlt1KkF07JouMmMvoHgGzkbKeXCc9oi5Q5FBjmMqU0KcyXydSiASmPDGz7ne5QwMgBDHHUc8b5c7P+YdyMsjyrJnQGpKeul52Ll0552cgdbhgsEvntWmT//LWr+73Sh7KfRgf+d72iqp0ZAMzfRp96ds1dl6pvyE5jIW/TUtWZRo77zaJQuZiE2ghojcuZwZRO7hfdS5v6EeflFbpy9HgUHrTN194g0PE0/MevkFzKu6YeRAShX+Xf+WZXIGWD7EDMlF2PESnLk6D2ZToarI876PyfBMhLif0lHo+MgInNh3NZDPy3Ju3/d/KcQwkqFfLGMmb5I5NFQ6ioBEFt1kWug5hKoQ2FKNnTHxZFyJpwZLeNW5q025mZASO7Y5UnVXx+cdwoly+7+4rONOTiJ6fMu0JQ5w+4mOvNS3Wry1vDQGlQxOajTn2TyrcQW2EyunjF9NmnUWgCfopGeHCFJvrnj2mWiJQ7haX0CPtoAyHCr9Zq4IsmlrM71yeBIRNocDrUbuTJeV0CHbU0kQtu+hlT6Wf/2T8IeSoKhWYdLBP56tlh2s1eKt48Iipnxf6CEy3FFGi05tusmNAgZq5gCtc4QgL8RfInXHPt0U2pVGO0vg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36860700001)(70586007)(70206006)(47076005)(8676002)(4326008)(36756003)(26005)(336012)(426003)(1076003)(54906003)(186003)(2616005)(316002)(83380400001)(6666004)(7696005)(5660300002)(40460700003)(44832011)(110136005)(8936002)(508600001)(16526019)(81166007)(356005)(2906002)(86362001)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:52.0659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0695c7-d18f-4c8a-1732-08da012244cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1477
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originalliy, this WARN_ON is designed to detect when calling
avic_vcpu_load() on an already running vcpu in AVIC mode (i.e. the AVIC
is_running bit is set).

However, for x2AVIC, the vCPU can switch from xAPIC to x2APIC mode while in
running state, in which the avic_vcpu_load() will be called from
svm_refresh_apicv_exec_ctrl().

Therefore, remove this warning since it is no longer appropriate.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b8d6bf6b6ed5..015888aad8fc 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1038,7 +1038,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-- 
2.25.1

