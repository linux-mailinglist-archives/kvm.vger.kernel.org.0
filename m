Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5DD5A46E0
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiH2KMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 06:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiH2KMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:12:24 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2083.outbound.protection.outlook.com [40.107.102.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6151E4E84B;
        Mon, 29 Aug 2022 03:12:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqlFirZwcyh//hlYfbywXXIOsRngDNX5lvGN2Ctoqz3qTLPXN/5z1zJiMcNb7/3cF3Hnp4J7gM/3gLNNQryqBVGCvXXrSgihm/n0ZgV/kgBymtgv0o7VQEHidL2aYgv5ruRTPrqRHW7xb6p4iJCC+PBZLfTW8/WRFex5dG5CX79rg9PjLZotgqzxZBc1wNQPMtowgE2FWm1SgclT2dchA7GkTPQqfRJgLHqGODmojZOuvFrF8o8FiTana0pFPvTBnh15Fns7RutbhsRWRrYjliaCq6BwW+yAFaBPCho9IqAlxylIKVu1gSFOWhVsRuvrPDh+GsCTP8BdBNAzJMSSVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=av/DJE8D6kP2/Aub97o2cS1hU4kJbUl90ppjiJRXwhk=;
 b=W/HEtwDxpVrmpPl1IM5E6XfkQ+3VuG6s4UwP9SylZz/ApzvGw7dbNTDXrK7w1RwMTMU16UgAbq1oHTD7gBbRwoOQHTomBmr1P+75SIL3oTcrrZ7aeDXH8dQGEjXaREGjWmSY5l2T8wMyJs5mqWj21B8dq+inUooIycXxnB1wYWL63f7DOQY1KPDVn2hfXXIV2q1RX/3yDsf2y0OVguaHQQ55BdYMfLtPern799bVk/aMJPOiJLwwRF/oMYgG0V1JFnx/5gtt15dk1HF8b19PctiSCGTWEgVmKgjmXC+Mh1XIqBBTzQE7WBQdKpbxIW+UzqIWWWVQCGChfLQ24xdSgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=av/DJE8D6kP2/Aub97o2cS1hU4kJbUl90ppjiJRXwhk=;
 b=lXxI+CClxWcTTZv/e7z39VyG7ZO8YpYfv4OtXsSGmRHD18SAHeR9OaSfJhfbFZ6LB51dvqiOUKegLVThNNKft9uY4tTsIyHJ+tLDi1f/hYTvQcfkadFT/rt9t0EOZJSTe4Gsiz3BDiPMBaFQFMfc/elcJr2yRuM+kV+5nlS7ZaU=
Received: from MW4PR04CA0176.namprd04.prod.outlook.com (2603:10b6:303:85::31)
 by BN8PR12MB3635.namprd12.prod.outlook.com (2603:10b6:408:46::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 10:12:16 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::e9) by MW4PR04CA0176.outlook.office365.com
 (2603:10b6:303:85::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16 via Frontend
 Transport; Mon, 29 Aug 2022 10:12:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 10:12:15 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 05:12:10 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>, <mail@maciej.szmigiero.name>
Subject: [PATCHv4 7/8] KVM: nSVM: emulate VMEXIT_INVALID case for nested VNMI
Date:   Mon, 29 Aug 2022 15:38:49 +0530
Message-ID: <20220829100850.1474-8-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829100850.1474-1-santosh.shukla@amd.com>
References: <20220829100850.1474-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6575e4d8-b06b-4126-a767-08da89a6f2b2
X-MS-TrafficTypeDiagnostic: BN8PR12MB3635:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q2Hz7Cum2+XKFlcgd/0RJB2Vi+Dk3QS5+N6L53Ajj8l1pZCf1MG6/LEyYiLxGiOd6PIuL0Mwtqz/NEUyEYm+Xa5NCiRk4SWqCxa9XlqGJ3A2pVi0uuBKbft6FAtbJqGK9wholpq6BYzOL7HJ24goS4lvAnx3D0eej10kc3i4c4jSTFrK+sfIxM/9JlLAPcbSzN6FFItnNnQdqJdGXUDUAZ8w/uVBgFgtzOdTeeJVDfr0sAg2sxQTFAiT4YlAsbJoLHDyA6vS8leOtO/shZQ64BgQ68mxRXnhUk/kECjNZHeUd7bhMNFPrjNoQp0IWkTiDhBYMOwpPTOXwIxQhIELhdd3aNeZM9UjJhovyhQ1KyJm8/QGdmKGB/XehOHWYFCRCzMlyd1VlXIeze3YbkZ0J9Gi//tSTnY57KWQPhr8DcVuamV80mtWTnPRiH/72+vOX+shd5kpSkGkBi3dceJmhs/ctPEQ5IckX6xXKh2GQDowKDRbSr71Rw/sugFAw0Dwkqma9G/ldG/dfuAXJAr+hU2BWm2KlxBabYYU66OR/z2vY1UHe+fJI6WvzmlFPZAEWB8M3alq0ZpYtrvDJY12BlKlugqoBZF7NoE4fdfndJ/bp9qtX8zDgetqOSdJBX4XV9vMV9Tjl7hcDskc2bcH948IsT7fXNlNh8AkV+u6/bTWUCAFff0xgaxRQf63kMyqL9BFXfc8/q0oqetXP0n7LUzw2CLMDbsJC49jR/6k18NH219pWz/nOYr2o5+TlCSndv/V5/WjBGZeRrtjEv/VVz/+FsagB2eb9KrncaVnfSuY0apluGw39cXFKtvV2PrC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(376002)(396003)(36840700001)(46966006)(40470700004)(1076003)(316002)(81166007)(6916009)(40460700003)(8676002)(70206006)(86362001)(4326008)(70586007)(54906003)(478600001)(356005)(36756003)(8936002)(41300700001)(5660300002)(4744005)(44832011)(6666004)(82740400003)(2616005)(82310400005)(7696005)(2906002)(36860700001)(426003)(16526019)(47076005)(336012)(40480700001)(83380400001)(26005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:12:15.3842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6575e4d8-b06b-4126-a767-08da89a6f2b2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3635
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If NMI virtualization enabled and NMI_INTERCEPT is unset then next vm
entry will exit with #INVALID exit reason.

In order to emulate above (VMEXIT(#INVALID)) scenario for nested
environment, extending check for V_NMI_ENABLE, NMI_INTERCEPT bit in func
__nested_vmcb_check_controls.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/kvm/svm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3d986ec83147..9d031fadcd67 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -296,6 +296,11 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
 		return false;
 
+	if (CC((control->int_ctl & V_NMI_ENABLE) &&
+		!vmcb12_is_intercept(control, INTERCEPT_NMI))) {
+		return false;
+	}
+
 	return true;
 }
 
-- 
2.25.1

