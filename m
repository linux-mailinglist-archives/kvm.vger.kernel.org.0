Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8574FE03F
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbiDLMkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355041AbiDLMit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1A826CB;
        Tue, 12 Apr 2022 04:59:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6EtZ9UMrU0m93L9jtIvYJaKFts5FinpdQeY8HLTWthAFKoUMM4kGManJSt2RBxxfvNC1XFr/xdaO7GnAFgHeqnooDQV9U8DTYzkp8Ai6sydN9wQNKFEbLNByTdf0CazdW9ALNZHUmz4dm4OqoslisBRYVLlOqGdvLO+rhSfJQVbOiPFbpeSa0S7Mz/YVWK63O5L6pmWkDdjvydfO9jke9JkqXrcf2GVZG26oPvbpoVlDcj0nwO+IGkJPprNB3NhkGWo4xSf+yzDlDohp8eOeMhazFBLCFa7vlISBLc9yK2DyhmfvByo/DZmx8IuEqHt0bZNZJGmogxB6AFCKcKlHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6ezI+sdBFI1JUW9N4WnWLck5zvep2A6efwj7NrkX3I=;
 b=l0V37w0vdo9qzmBwr7l9ng03wtBsgiwFF2n3kivsVoAoUo8Yn3fAU6pqaw/T8sEKl1HpqwnsNlYepdUlJ5qs7mG6fQhgwP6DbaNGuFwLHsGe49eLIAAx2kLB0zjU0ClAEy48h/e6s/eujcdGY5gUucTm2CACAdA0k8ze8c9RYpKoPwOU8p17Vn4MUI4yFBDgzytrKazhFkgLD6RfkG3PH6KNbmhku19Qo96mpU2NE9NQnw53H+bf/OL4GCIUiIKCKZmZcde7XnSo2+xLUSzN15dGXVsm9x5OucS2aeooY5g0Q8vphU9If/jC4Yn9CFxxdxQFwrUpC1ID8YonOIRRbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6ezI+sdBFI1JUW9N4WnWLck5zvep2A6efwj7NrkX3I=;
 b=THDfqhhwaXNQWcq/V8itEmnm/VDhvqE3UO2qWKQ4ePMkO5PXJidmyLQ2wtImr9Q2p0IwlR000luO5xevuA3qLnlKGuTtN8kOfiY3NmmpUI2pQzdi1Zwv+lUNI1vfcXjOFzdcyyXSLNg0QFOU6h9uynj0XqiuIyHnSZVaM7fCNUQ=
Received: from BN6PR12CA0038.namprd12.prod.outlook.com (2603:10b6:405:70::24)
 by BN8PR12MB3588.namprd12.prod.outlook.com (2603:10b6:408:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 11:59:16 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::a3) by BN6PR12CA0038.outlook.office365.com
 (2603:10b6:405:70::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:15 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:14 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 10/12] KVM: SVM: Do not throw warning when calling avic_vcpu_load on a running vcpu
Date:   Tue, 12 Apr 2022 06:58:20 -0500
Message-ID: <20220412115822.14351-11-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb72fc55-f2bc-4e8f-e35a-08da1c7bddec
X-MS-TrafficTypeDiagnostic: BN8PR12MB3588:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB35880647308882D4E1CDA499F3ED9@BN8PR12MB3588.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziW4IlVoQrWWJa4bVuhdvgSI9L5HV9r8HFAlBn0BcPV3FpkPQXDutYSW9LbhgxybL+6lSPil5TRnsBg+ySsoyMD8PENUPekTOSRvQuS3LreQBfZXY2ExZcjbQoaAomrbv/4pALfSFLubI/8Q6cdVxICZjkN14e0Sv8yDDRD2KZLHYcFHBY/AGNFmoFMBgoDYvt3AKjIEi3P26f+uZuo7QffUqtG4AI3SKow20S1bEDCHcb5fgDca6oQHUr7dm7qihQ09uzjwYPpOy88QlgsB1oS8Wh95zIOxwwa0vNCDoVtilj/BWeItfes0Kc3+eXhgQ/MxCcKmePy8gdn72jUFj8IXagzfXYAimi7EbFCCtPRzdK3yacfMNKQDL3l9Yfr3BVrDiLRW5U2lDcnUmt6cXQPal704C3cVeLTLF61LAgZWWdjsaDieqB+bcl1fPVKgJ+JgsXFC7ruOHvJEbBLrJgGa4IIHO2LFxzXUm89zLs8rtroS/wl3Ep3r2q2uI7QxzHGOtO2YwbiwyDU8i7FEG3S8+t2wFOiPxkNDjABkoWk/9NLWzJYF4yn1P0axr7fxa8TGMdY4dJcYehoGa8SP0TH61IIU0JbW4TZ1mUyZv9yGdQUn7B6aVbKPs7+29/G5tWsDDHy2Vxu/tCTfYNtVaB9BzRMcimyhgRLjNfhBNFvbwZJR/bxL8OGypez7h8AdN6F9ldZ3WCAriPwtwsiklA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(6666004)(86362001)(8936002)(508600001)(54906003)(5660300002)(356005)(47076005)(70586007)(336012)(36756003)(8676002)(4326008)(70206006)(83380400001)(36860700001)(316002)(426003)(2616005)(40460700003)(82310400005)(110136005)(2906002)(44832011)(186003)(16526019)(26005)(7696005)(81166007)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:15.5566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb72fc55-f2bc-4e8f-e35a-08da1c7bddec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3588
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 462a1801916d..085a82e95cb0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -980,7 +980,6 @@ void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-- 
2.25.1

