Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE9358E73A
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiHJGRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiHJGRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:17:14 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60953A4A6;
        Tue,  9 Aug 2022 23:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJAz8mE9wfkJg1TE8O7WSeixLNj376XKIxzYDcx+H24dVXRBk/AMzLyBS1WehIUzHuUt64TNXGCRLLx623HRINFr1tTT5hbnwURtp1zk5EhrfiGe8so6kgjnkqp0Jf+OadKA2mcPI7rrDUueZCT80svevoEHVgd80F9ZNTZmwB3OL6G+RjFWz2lwcnz2ANEisgpOkd4bXuecNu1tA5w7tXPVlvejWHVpEJMfgZnTLyTLkPMfiaK/ueso6tQASgi3UptXnBcX/L/p5qNJif3yjATRxJTTNR2g0al1zxMz8AccksWj29yEiNHdBDFVihII9dXSDRVd2r3z/nlYOjVXYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=av/DJE8D6kP2/Aub97o2cS1hU4kJbUl90ppjiJRXwhk=;
 b=R3fC4UiYpAUEtyMTCPooAkV581ehaa9zRdNJLoPZoSXvIhzrZxg4wJFzaFoBBt22VD91choyaMRErB6xwgnVep1Wsxut/f0GdDO0O7sriOr8yUVVYyDmYJg56pE4jKs3K5WX+/vT8Kyean0poUH6N5xxwjR9xGjrWjTknn8T+Yp6IxVYctl7otnYeVmQypO+kFDDXc+hYTicZRV9u0nkEjH1K/EWnKz1Bf/DOPi7EnTy6uYjU2IsdVA1GdL077X8k3X76NvjzOVhc05QyY7/nhZeJfRjYzCRH/3c6Bkjcl4LHOYKWFxqyjlC9rnVhth3eigDrq3oy9pTGJ2kHkHlLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=av/DJE8D6kP2/Aub97o2cS1hU4kJbUl90ppjiJRXwhk=;
 b=kQSUxUobI4+3jNHPxVbvNKe0M+IU86kgEsG2fu8rqy0LRMQKmZG6ftclymz8vh3Tw0n4uWt/AkeUVEv2Rra6mo/OmW7oAKxMyfLGqA/ckPdZE1AlZm/DP4p1XnDNlszzTMHcmXIfacVsRmRvD5Ue9jVeI1F6v6fqffgTNve+h40=
Received: from BN0PR04CA0024.namprd04.prod.outlook.com (2603:10b6:408:ee::29)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 06:17:11 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::cf) by BN0PR04CA0024.outlook.office365.com
 (2603:10b6:408:ee::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Wed, 10 Aug 2022 06:17:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:17:10 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:17:02 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>
Subject: [PATCHv3 7/8] KVM: nSVM: emulate VMEXIT_INVALID case for nested VNMI
Date:   Wed, 10 Aug 2022 11:42:25 +0530
Message-ID: <20220810061226.1286-8-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810061226.1286-1-santosh.shukla@amd.com>
References: <20220810061226.1286-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0275ab3e-de7d-45df-4991-08da7a97f5c4
X-MS-TrafficTypeDiagnostic: PH8PR12MB6794:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: crEV3+RaY+CJ5zT+u+hxRlqhl3KPSgdS4daO736sBN2fxHlvWm0mqnVz59e3tFRflMoCKVE9s0D8GZDuq6n4PEcZV9ybrPH9qkzo5zplUvRTJncFghopsJdKu9ctup2ERZOOh42Xrj/0CFRf/Tf5K0YhM72cGIbvtMPxUWZx410cCgI2Ona3bKMjgczs+KUjXj9tV2QseIYpchLC0lvzoy+JVcBiRXICv79COEdXw+HzM3Trd7piEM6fx4uwcQC9xfns1S+ShkfuTDXrtD2GVSf4Rxx6IhAOfq7IKKRY86q/SdjzAjvTz7ndwjBUfRdnNb9oXjCts94VZ8lXbqnsuwa/OcXC71+DQuPKJ3BvkOBQBaVCLjd7mPZ84kUHxRP+hRGIiQSe2QadOZt9q+zv39TXP/1h136J776L1Ys+zElFUE8kn5qNPfKRjHMlTo3eEP2CikI/VaeIEyD7Hf5Ln/QgvB5Zjn6RWzN70zlzhdx5WSKLK1/9WxTvl/FEwe8zav4Yivo9VLlg4lhoOL9YR6quFhGf7lPm5nC0SMXYR0AYdXtfYym1KsYVU54+txqyrh9GopKDACrvyc2X/mty35OnwsnYjURolH4vEeRiLqaPir4I6m3afkl07wMTTgQKUobHmiG+SNsgFr9jeJ4OtiRAA3Jdt6JRzxOk1cvKVIeDxB8iUsvBmdkYaivv7Nkj1J3Ib7Ba3YTui5vPxuos4L9i0de8xW5Q1kLIliQpSsZ8NZAVBYHYkbIiGoVucfrOVcf97GZ1b4cb40f3MUARGrlZ+9YDOWkzzmDN6FnTxohfO5Pv8xaUYbEf+/N2OfM3/hb/s4fDBbVmHXkRjl09fA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(396003)(46966006)(40470700004)(36840700001)(426003)(83380400001)(81166007)(7696005)(478600001)(47076005)(6666004)(82740400003)(8936002)(26005)(2906002)(186003)(16526019)(5660300002)(4744005)(40460700003)(336012)(41300700001)(1076003)(316002)(2616005)(40480700001)(44832011)(36756003)(82310400005)(54906003)(36860700001)(6916009)(356005)(70586007)(70206006)(86362001)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:17:10.7653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0275ab3e-de7d-45df-4991-08da7a97f5c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794
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

