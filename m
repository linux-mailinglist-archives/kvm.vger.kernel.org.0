Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776B058E732
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiHJGPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiHJGPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:15:50 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1655813F3B;
        Tue,  9 Aug 2022 23:15:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6DRhY6ozXlbQMvshrS65XOw5a2B0elPMSdJXE6nklbzwLoGN7I4bBH7iZJv2SqavQK3S19xlarXmG1AtRg6gK9m2ZcEi3o0wJUsrfNEoYTMgnVcZjGZy4V3KO4HjqIhJDqEKVCwCXYc9IP99w88J33tnUW9CluDlDwFR6W9TYVjhCeRooAUEgn55WTFT75QNBBNTQ+Ixju7M+ZX/pDU57mNKXqrPVpE+Jjk6JOMTebgRZzyB0o5Pjl5bGzK9KpbagLmD4AIplq7MxF9oaBmYa7EhUCQXnBGpgOSy4OvS4n2mW9tkLBw4Rby/YF5Fh9ye5joUFapSyV7ZjaDb8gAMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/Oh4S8RoMKO3zD+uy2c7MW79/v4N5JzTGiWH2cKENo=;
 b=bHexZfI99qVdy/6dkhjKPFHxtIREg4zOnIqlfI3H8jg+ZyTAQ4fPeAobBM3rFiUbdhd96MBqhLa6NN/fE624Ib7RwYjeZ0ViMM3gMJp2060Kgxxz+pWsAuJCdQujpxouj4wqe60bHxY8v2kvwtfVwnL/CUZNvsdRjAJKcHfRAG+cjPMMScq2p9RIRKT8Lzf3oyHYTavLcg6xAksQgQsDBS1+WOI60JkN6R5rPz2+/EcSZvqcNMTLJRgUO9/IALjceL1I9aCg51BiRD7SWZmseVWP2XoGIMLO8WyiRws3fSjeKAMj24xkadPTm+8viwFfHwlZ+3LqWJa1VSTzjh2v9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/Oh4S8RoMKO3zD+uy2c7MW79/v4N5JzTGiWH2cKENo=;
 b=nwAm9T2FXAtjG8oKd1kZnaOMnwo4i8rppoC4hOb0aXTQUUpszy+QpK+JjtSAlOKY/Jvupijaj+J81Zj/G/sWJslzr+2eWs/nNSoE0KMcuQr0/jO3fNRJy/mTO1Krxyc2rvV7tGc9zwyuWHjpXMZQPVlCXAFRnvbyyC4To8DUZes=
Received: from MW4PR03CA0139.namprd03.prod.outlook.com (2603:10b6:303:8c::24)
 by BY5PR12MB4644.namprd12.prod.outlook.com (2603:10b6:a03:1f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 06:15:45 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::bc) by MW4PR03CA0139.outlook.office365.com
 (2603:10b6:303:8c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20 via Frontend
 Transport; Wed, 10 Aug 2022 06:15:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:15:45 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:15:39 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>
Subject: [PATCHv3 5/8] KVM: SVM: Add VNMI support in inject_nmi
Date:   Wed, 10 Aug 2022 11:42:23 +0530
Message-ID: <20220810061226.1286-6-santosh.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3ab54a61-a281-4244-aa68-08da7a97c307
X-MS-TrafficTypeDiagnostic: BY5PR12MB4644:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7DPDe+vQfWnuhsb+bLt4/YGXzUZIUW2Lb9R4eN4XZ0bylLx4N/Ex4Zqi9JIhYHidURoXUmfugJFX+XDEN3ejJfK8QIjUv4mRlZ9c64FIGEeSufTxLf0c8nnmEYbcmkph2bn3PPEILdpmNPsDvc6CyVAiPQ7IA4DyS+ipK21E6YO/6VGPEK5uJOm0A2i/igAL0ffcInXpuOa7IQ7H0bsr3hZzuoHlRnPrpTnNdJvR0A0DEaCepJ+ZTLOL1OoXP4GYg1dBp2KrLerccvCiK92gL8TY+5CFVEYqSLoGd4DGzE1n9m2KMb/PVkqnYqOL+R0kwYfAV7Bjky8QVnBCaD4nqvDDYUhTqEy4FDT/dmvV8TjgkXOZS4XEOiIaOcCJ2cRWD1u3LPWM6c/zNMVOFvUSc3UFduk92X2l6g9qL/99E0LNVzBPz8I75Mbq3TOJPnHPvnzeJAOT5u4ERhrUXsYqZa7QA9cBslFHtjGYNA9UBfzPpSSN7sgNNbJvvyJMsVs43dC9rDUBwglaOmwOci0R0p0uCFADn8TgDkm36fxbPww6kr4CYpgIV5DCXKzszXWJSv+1VUkureoC6K6whmF3Ozd/iZ49UAamuYIyO4e+sTU3MVWhyskNWgINODd9CjGJ8WMRUiOZjGbBetUob6WeEIaadiHYM/nuBKU4Ku/pIfOnDF71W1HOyiLWt5Q/dc8DntnWptTgiaQcVH9SQ/DmOn0wx/MIqHWXQn4brDCjlFzLdMYpRg4C+JTu0bxNRMv52t1RryVI3G/ZGxa4FLMz+zmqmssB65o3cscfG+QOooggPcyxc+D9RJt4DEDj9e1pwWZqrD4IrF7ZlPVSF8NlZw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(36840700001)(40470700004)(478600001)(41300700001)(26005)(7696005)(6666004)(86362001)(356005)(81166007)(16526019)(2616005)(1076003)(426003)(336012)(186003)(47076005)(40480700001)(54906003)(82310400005)(40460700003)(36756003)(4326008)(8676002)(70586007)(70206006)(5660300002)(6916009)(316002)(8936002)(36860700001)(82740400003)(2906002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:15:45.4869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab54a61-a281-4244-aa68-08da7a97c307
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4644
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
will clear V_NMI to acknowledge processing has started and will keep the
V_NMI_MASK set until the processor is done with processing the NMI event.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v3: 
- Removed WARN_ON check.

v2:
- Added WARN_ON check for vnmi pending.
- use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.

 arch/x86/kvm/svm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e260e8cb0c81..8c4098b8a63e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3479,7 +3479,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
 static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = NULL;
 
+	if (is_vnmi_enabled(svm)) {
+		vmcb = get_vnmi_vmcb(svm);
+		vmcb->control.int_ctl |= V_NMI_PENDING;
+		++vcpu->stat.nmi_injections;
+		return;
+	}
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 
 	if (svm->nmi_l1_to_l2)
-- 
2.25.1

