Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2876A126E94
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 21:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfLSUSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 15:18:15 -0500
Received: from mail-bn7nam10on2083.outbound.protection.outlook.com ([40.107.92.83]:4216
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726884AbfLSUSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 15:18:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hT5havNwrHD1RDGlNWqFXyEQIkEtksFKpFFqS8n2s70TaQ8lkMalnNL50iw2wtsIvXkuwtQ77wLwi0K98DwnFUmrFD0kdrUXpDYr/CsjuKr5SECXARBwpbNcGb5ZReRnphDGYsypESx4uLzYABxIrJgOF3fFFcgMApYLiSVHHGU+a/dxi2JGj21XgRuczSLaa14wmx4y8U+u1IFyLV64866YShvCrFKwnCWwE6lp5rHnkSO+lgPK9hJETE7KINF6KjEtdCUX6xsbDNsSek3euOLU+wtIntxMZ7vwrpESLS+By6WxQ1riufvqHxzOJ1tXjXS3jKJCdwGzIIVRAm4SPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pwm/ZNYhK49hcRhzLjPeDVSBTZseA94Kn46DkUk/NRk=;
 b=nPkDlOSOuD5JxsxbKr8DG6AwhfIhdoeghAxilASRJBrTPsvSZsm5mO834YPd9YUYTYAkCGv5yebxcQBdVZhBJiVkGp8J8qxcfzGRgX9+lamYBRIZ2cxPBz3OL1UUjQB8jEfU2xkjCeXXx6y0TPKiAR4L6F2ivAKNNd3SP1jWMnCERVvUYIZSN5Nw93IikFHhBc2lMuc+A8rZM14POd3OYtIxQcvpMH/Y7G5IzEzKdzBd/6ky0sNFJo7XnSjnNflLWWvCLyPpBCWVsQVcubL78AXJ1MahVtxemoTp3ah1Lx3F+htIiJpsM2MutCwOs5hSAkfRpr7QZTCL7YQFXjj56w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pwm/ZNYhK49hcRhzLjPeDVSBTZseA94Kn46DkUk/NRk=;
 b=LHNNmDUm9b4sYeOKAhgwFyVpbApqmcISW27hebx1ZJPNkXt5CPxsYdHjU6WwCK5cWjaNMqgcL7Ixud4lK4lTiqZvKNwQ89PHRhbQEJa/2AjLqcxW6pGfBOPhDi/cMmV2dS2iyjA7+AA0rOiqjIWDpSf1LtPGVm36teSZzz+SF90=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=John.Allen@amd.com; 
Received: from DM5PR12MB2423.namprd12.prod.outlook.com (52.132.140.158) by
 DM5PR12MB1834.namprd12.prod.outlook.com (10.175.87.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Thu, 19 Dec 2019 20:18:10 +0000
Received: from DM5PR12MB2423.namprd12.prod.outlook.com
 ([fe80::84ad:4e59:7686:d79c]) by DM5PR12MB2423.namprd12.prod.outlook.com
 ([fe80::84ad:4e59:7686:d79c%3]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 20:18:10 +0000
From:   John Allen <john.allen@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, vkuznets@redhat.com,
        John Allen <john.allen@amd.com>
Subject: [PATCH v2] kvm/svm: PKU not currently supported
Date:   Thu, 19 Dec 2019 14:17:59 -0600
Message-Id: <20191219201759.21860-1-john.allen@amd.com>
X-Mailer: git-send-email 2.24.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0018.namprd04.prod.outlook.com
 (2603:10b6:803:21::28) To DM5PR12MB2423.namprd12.prod.outlook.com
 (2603:10b6:4:b3::30)
MIME-Version: 1.0
X-Mailer: git-send-email 2.24.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c8a936f5-ad6c-4e25-0f9f-08d784c0913a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1834:|DM5PR12MB1834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1834BAE4AC326DC2B04F37A09A520@DM5PR12MB1834.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0256C18696
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(396003)(366004)(376002)(346002)(199004)(189003)(4326008)(1076003)(316002)(6916009)(6666004)(6512007)(6506007)(86362001)(8936002)(26005)(186003)(36756003)(6486002)(478600001)(81166006)(44832011)(5660300002)(2616005)(66946007)(81156014)(8676002)(52116002)(66476007)(66556008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1834;H:DM5PR12MB2423.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IEdg5eAxfEtFDhfnSDCmtnBwudl0A1MHgbQf3kXLndo2Q2WVWwWDO7xdbCvenkcrnVud0j8DIPi+S78lSuzsDgs+nskvPaW4paDUlbl1zrMTx7DDdYhxa2sb8sO3uppwqZuU+lZH4gUyI9BKGD966L50PRirJFtF+n5U7D6iLSWLwBt6J0hPFpsvK51l1HsYME0LbWsoyysdkgd6hnfC7MBPGBvUheutHKW/SB0Tn+DXE+NVKk3qTXuQL5cl+Z9xnb0A9Kg/akf/2d7XhXsknCXgC3dEgvXhLw+rGXdLbAV0xZorMtMqy56ySar4EDvN4vbIh6tS2uyJCGAH//XAMNosjn0FVWtQ6bGRcCaWPERBBMrQD5DfCm9yEJU6pDr61pY8XSNoKR7am39J5vHevBmUiOFJF8doAsTtv1fN7fSTF6o0z54MQC0GbU1HAJmV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a936f5-ad6c-4e25-0f9f-08d784c0913a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2019 20:18:10.3172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HfgKrOIaXHhMgVE8LT61ZhBddgpBLAPiG+MZ33EM7xa2OhH6r3DNqJ74KH8+Q44bqYJj3MaNZ5QUHboVjULW6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1834
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current SVM implementation does not have support for handling PKU. Guests
running on a host with future AMD cpus that support the feature will read
garbage from the PKRU register and will hit segmentation faults on boot as
memory is getting marked as protected that should not be. Ensure that cpuid
from SVM does not advertise the feature.

Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  -Introduce kvm_x86_ops->pku_supported()
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/cpuid.c            | 4 +++-
 arch/x86/kvm/svm.c              | 6 ++++++
 arch/x86/kvm/vmx/capabilities.h | 5 +++++
 arch/x86/kvm/vmx/vmx.c          | 1 +
 5 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b79cd6aa4075..4a9d869465ad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1145,6 +1145,7 @@ struct kvm_x86_ops {
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
+	bool (*pku_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cfafa320a8cf..ace146d663db 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -352,6 +352,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
+	unsigned f_pku = kvm_x86_ops->pku_supported() ? F(PKU) : 0;
 
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
@@ -363,7 +364,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 
 	/* cpuid 7.0.ecx*/
 	const u32 kvm_cpuid_7_0_ecx_x86_features =
-		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
+		F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
@@ -392,6 +393,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		/* Set LA57 based on hardware capability. */
 		entry->ecx |= f_la57;
 		entry->ecx |= f_umip;
+		entry->ecx |= f_pku;
 		/* PKU is not yet implemented for shadow paging. */
 		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
 			entry->ecx &= ~F(PKU);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 122d4ce3b1ab..8b0620f3aed6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6001,6 +6001,11 @@ static bool svm_has_wbinvd_exit(void)
 	return true;
 }
 
+static bool svm_pku_supported(void)
+{
+	return false;
+}
+
 #define PRE_EX(exit)  { .exit_code = (exit), \
 			.stage = X86_ICPT_PRE_EXCEPT, }
 #define POST_EX(exit) { .exit_code = (exit), \
@@ -7341,6 +7346,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
+	.pku_supported = svm_pku_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 7aa69716d516..283bdb7071af 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -145,6 +145,11 @@ static inline bool vmx_umip_emulated(void)
 		SECONDARY_EXEC_DESC;
 }
 
+static inline bool vmx_pku_supported(void)
+{
+	return boot_cpu_has(X86_FEATURE_PKU);
+}
+
 static inline bool cpu_has_vmx_rdtscp(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e3394c839dea..6ba72440b3e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7870,6 +7870,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
+	.pku_supported = vmx_pku_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
-- 
2.24.0

