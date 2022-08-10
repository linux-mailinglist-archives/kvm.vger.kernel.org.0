Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0489B58E72B
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiHJGN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiHJGN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:13:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7095642CC;
        Tue,  9 Aug 2022 23:13:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2+r9yluFU1K2ISYAd8nH1sC9E9ks/Gq6IJMAgGdZ8Yt1LG1AeBzGkDKNBw0rlY+KJDnpi6gWDEmujsRBBUszb5Lo2qdsesmRVRPshJXWdcfigZ9pet+J+7genYbSU5cnOzfTLwbiRRJqNlgKWW52QwIwbU11/37wExUvUFJFuPFjJwj0FOmbMCtq0kmRQX8VOX8AGiq40T1heQQL3g/rZpWvqRT2wOrl2b+Z78KNHA+FOLs/ecpxJqY3XDeGOXWytAqkw5gdUoss1YN96o9oAZ+T/abqp8fa7qp8i7YIZwPBTxnGG05dzlQJb6T9FLgQhQvtX7hUewIR7Jx/wkCEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6oV4hAHpWP/Vz1gxeXYquk7m1U1CsrZ2Hiuj57enKLQ=;
 b=AMVjQMTmUCHBg/sRNivoHFzk8VU5uW8qsoFaXy34BziSNRIDnfTTOwm5BYAOgHLZEBSkPQg2oDFXlvs+Lw+13l9gvZBKIXk8VIKdQixL7zyPDMO0z5gfNkCQeHLkH0WTKYktOCwS2KS6J3ApTG8z3JQ34n/I2vwEKD4eCc4RncVhaIFtfKUS5AAVhAq5mkXdj3/ym344fNPVo2DTwbcsEr1SQQ7IbdlDAkgBNSAPjNEwm4v4t14lSvu3p5GUxjFRUr4pl6lE4enOO8maC/aiwZR15rc+Wtr4M7lPWEvxW7mLwH6lqMYz/ep/2Klo5I+2LarO1wjCc1D49QioBFMJVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oV4hAHpWP/Vz1gxeXYquk7m1U1CsrZ2Hiuj57enKLQ=;
 b=CHLeYB3x2uY471N51a+qD234RzPhWgZZUu6nfi2VpK+8QpXxzPdcBzgFjL5zzWRX3Bbq/tFH43Nh26YGRfLScLyBhtVbGQhbQDDE9fTI8QALsHK2jGrcUXy63TzbxVotQTYtJrFonQ/PgfYEO5gO+Qa+8wt0XAJFMumjpdfWYf4=
Received: from MW4PR03CA0090.namprd03.prod.outlook.com (2603:10b6:303:b6::35)
 by CY5PR12MB6204.namprd12.prod.outlook.com (2603:10b6:930:23::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Wed, 10 Aug
 2022 06:13:53 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::20) by MW4PR03CA0090.outlook.office365.com
 (2603:10b6:303:b6::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14 via Frontend
 Transport; Wed, 10 Aug 2022 06:13:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:13:52 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:13:46 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>
Subject: [PATCHv3 2/8] KVM: SVM: Add VNMI bit definition
Date:   Wed, 10 Aug 2022 11:42:20 +0530
Message-ID: <20220810061226.1286-3-santosh.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: e093b420-b434-4ee5-8bd8-08da7a977fe4
X-MS-TrafficTypeDiagnostic: CY5PR12MB6204:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVy57DrA9rkmxweIPmLirbg5vj2he9XjhET+BEy+M3AIkZnBlXutcg7sFXl428Uhm90viKxfam8hT6Nsw17OlOJsqM0ELoFaVRVQkYLOAhLC4GbwOPdpNFKKQ8XF3SLtE/Pxa5VhbNUUrut2BIx3gRCRUuUqvPN+iX9wl6qMpWuL6k/PkT+7nx/VMxzbuU18OkmouE4mVg9n+W+qze0GGB+vfkOlvnTfvCkGQsGrmlxpX36JYZP19JSJFbWgzZohNB0lQpxXd6FLuH2Ol611ajPz1N+/M7O3PPCccAVzjtTsT0Lx9h84kuSMFUhsZzdql5PzQhYbzCvH91GLSqx9uKo0rVncdJefveK+XmQqzGeQZjKlrCzRtGdVl11c7EzX1QYkxgdu87brGmSc3HJN48yIPTpQKHwFY7XtTTsfiXAfvtofwRt+3S0v8hAa9gDnuz23QQNsbjt6ssbdMCvF90017Clbg0ncyyknlFms7II9LA4XKU2gSv+/PNaYW0Y7h95nlMjGlPrNoGzZ9p31Es4IkUMzYU80dMulj8dfZSPw/x/STUjurDWw8ef1FAKJp8whaQb5Wh4M5Jh1MObs7zwwzemZwMZvb7YLIybRitnfGAqRDbTd4BS2DQj4aKNZzuK0tcByk8Rz2ZtEXZCiwIrrXE8DRnA+lSjWUjbFdLMeKg/Jo5CJkEJM94Bs4tzUZgsiZJjI6JImGHSE9hnBJRW0HCcVLD1vy8YtqoBtUROAhM9frxdlbPINRsxjiow0iQAJu/a5PMworqtlt4dvSP5MA6xzz6eVDxdWCsefBItFwdsrorzv9uPEP51yEK0+DHZFNpRoHqPtXIN0eSj4Qw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(376002)(40470700004)(36840700001)(46966006)(8676002)(70206006)(8936002)(4326008)(186003)(36756003)(426003)(478600001)(40460700003)(16526019)(1076003)(70586007)(336012)(54906003)(6916009)(316002)(5660300002)(44832011)(86362001)(41300700001)(26005)(7696005)(6666004)(356005)(81166007)(2906002)(2616005)(82310400005)(82740400003)(36860700001)(40480700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:13:52.8650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e093b420-b434-4ee5-8bd8-08da7a977fe4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6204
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNMI exposes 3 capability bits (V_NMI, V_NMI_MASK, and V_NMI_ENABLE) to
virtualize NMI and NMI_MASK, Those capability bits are part of
VMCB::intr_ctrl -
V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.

When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor
will clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
handling NMI, After the guest handled the NMI, The processor will clear
the V_NMI_MASK on the successful completion of IRET instruction Or if
VMEXIT occurs while delivering the virtual NMI.

To enable the VNMI capability, Hypervisor need to program
V_NMI_ENABLE bit 1.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/include/asm/svm.h | 7 +++++++
 arch/x86/kvm/svm/svm.c     | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..73bf97e04fe3 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -198,6 +198,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define X2APIC_MODE_SHIFT 30
 #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
 
+#define V_NMI_PENDING_SHIFT 11
+#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
+#define V_NMI_MASK_SHIFT 12
+#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)
+#define V_NMI_ENABLE_SHIFT 26
+#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)
+
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 38f873cb6f2c..0259b909ed16 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -229,6 +229,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
 bool intercept_smi = true;
 module_param(intercept_smi, bool, 0444);
 
+bool vnmi = true;
+module_param(vnmi, bool, 0444);
 
 static bool svm_gp_erratum_intercept = true;
 
@@ -5060,6 +5062,10 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
 	}
 
+	vnmi = vnmi && boot_cpu_has(X86_FEATURE_V_NMI);
+	if (vnmi)
+		pr_info("V_NMI enabled\n");
+
 	if (vls) {
 		if (!npt_enabled ||
 		    !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
-- 
2.25.1

