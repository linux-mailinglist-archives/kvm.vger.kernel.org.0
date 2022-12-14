Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A63964D093
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLNUCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLNUAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:00:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724212BB3C;
        Wed, 14 Dec 2022 11:57:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jC63+ppZ9dPdWNHB9gmHX/CMvEh1hvSTN6i6mjeIajEBQE0AEe16MpSOsRpicKBQDwsy7W/t56QczcMIl8QPLcb8EYPflTi2gyu0jwgDq57HMTQAwTFomE/lAX+pOm8IIrrQIBozPRcJ2wOEczHjs8rKjjhuj/pJe++GTS4g2/0Fliu9gdkhQ+Yr7+3Z57iIB7dz9WZGKeN7FyOaR9BgkzlOHACHA+D+rDzp6UbpVyYcCTN29aHp/NxwwrbzqDoCH82US0kjU7oim1njsnANm3EMv/nygiqIwXkL/l+gSd2NXYppK2FHYrdtzf2UQkTsj+FR+8/hGg/56/dN+aRkOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3oFK5H6oMp/qtECE/tp0Qc0iKoUNBA67OdiIc9I814=;
 b=j4Cp5lHBvd9gsQDzIuXuT0kzNO+ZEFBnTUk66Mk61BnUN4Dv+8UBIp4OkkeFREDN2i2AQ7wfPTtPgTPdEQpWtGjYDkuDz3qx+lwXRpM9ueztCG3iYyeAV9WB1HAOIfAAdTEd1Rs37tOQpitg/urMU39Ug8sQ8JiXjwkwUDtEMdTN0uCVs6SZt2TfEyqz6GtG8paHRwtyPUYPg13HYC7oqQpJEbCfbY3zYQe6bGpF/fQju23SmW/e21Wuog/Y+VWFjiAf1GWA/DWLCx0Gwi9FRwY6WFFmB7wgUBz2Ng6kyYVqI250a8OaCuCnAyKNsBS9JGP1pW1b4q8QDQdb63ChAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3oFK5H6oMp/qtECE/tp0Qc0iKoUNBA67OdiIc9I814=;
 b=EIa3CCEkgmSapx+POOE6WCgpcpK9/7XYfWyUU7H9ANOgllZzkGegBdfDDL8xe4KQUDDpjZV3xI9K9j0nResujnMm6v0oBYfgb82z9Kd6zzb76f2hR6YFOZ3GZ7s/feaEmJuKt8J3ut3FuVxYlQurL9IEhGWNjUubYFvoLBNXXCY=
Received: from MW4PR04CA0032.namprd04.prod.outlook.com (2603:10b6:303:6a::7)
 by MN0PR12MB6247.namprd12.prod.outlook.com (2603:10b6:208:3c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:57:15 +0000
Received: from CO1NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::d9) by MW4PR04CA0032.outlook.office365.com
 (2603:10b6:303:6a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:57:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT104.mail.protection.outlook.com (10.13.174.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:57:14 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:57:13 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 36/64] KVM: SVM: Add initial SEV-SNP support
Date:   Wed, 14 Dec 2022 13:40:28 -0600
Message-ID: <20221214194056.161492-37-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT104:EE_|MN0PR12MB6247:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a5b99e5-40ab-43a8-bd7d-08dade0d65c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l8aTcKZg+y88+cZMNS2xwhwnqoAkNwcsiQCD9BTGzvYDpshnlINFJN3NundMLD2mdIrmhEFXKC8aQfHIiGDHNEze94QcjkPdyOoNMVAQZtUrgfReA4Mf86N5O+DrYuhZV1gmZXAK+z6bnhOBwYqFEPD21ziPSQaZX6NLeaYtIwa/3oQLvNFWyV/Ar+FPCXvbOs0s+zzqzoXDQiTRDIi77WVIakAXKTo23sFlpSEw1W4WGJlbv6ssI89j7AwJgkLd8dF8H9t5kJM+kzarLUVqJ72ESo+Z8/iGVEFKT54db+A4j585Wv32FDJtGO0ZxJIr4sm0EOtPrZE+wrAhz8t62/HHvrt3xpIpF+t2XIx8fxtxfs/YQwdcyfNpVQfy+6rxZ6A/teNMhWxWCZsxloB9NNo+zmceL3ocJ5LVBbw4jAPhGoYdMUMgr4KRLQnBufQl1qyblYo/jgR3bsBjmG8vkqwe6D1ScJY+Kw97KHjkTBo3IVrEfCBjx+ypYptOYV4QFgWqqTwwyFx9HZJpv/qhWYhLyS4MvsbEpOS4rid4/oPPvqqKfGidNVk5/pthZkeHSeQOwekYOGqwvJexYcC+bRD3XPGK1jukiMqBm/b6DzuwSXXV5QQVQIsI9MJ22TQpNBGaVn3AKkEM+PXBCRpcVXRc//lTcGjv3bKNj6cdZ9JOUI91mIPW5k5fpXafppzDrnej7A5RhD1xj48wtVb/7RJDW9xsJVMzR7wLVjnf1rI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(316002)(36860700001)(36756003)(40480700001)(40460700003)(81166007)(356005)(82310400005)(26005)(82740400003)(86362001)(478600001)(54906003)(8936002)(6916009)(6666004)(47076005)(83380400001)(44832011)(426003)(7406005)(7416002)(5660300002)(2906002)(336012)(4326008)(41300700001)(70206006)(186003)(16526019)(8676002)(2616005)(1076003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:57:14.8470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5b99e5-40ab-43a8-bd7d-08dade0d65c7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6247
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The next generation of SEV is called SEV-SNP (Secure Nested Paging).
SEV-SNP builds upon existing SEV and SEV-ES functionality  while adding new
hardware based security protection. SEV-SNP adds strong memory encryption
integrity protection to help prevent malicious hypervisor-based attacks
such as data replay, memory re-mapping, and more, to create an isolated
execution environment.

The SNP feature is added incrementally, the later patches adds a new module
parameters that can be used to enabled SEV-SNP in the KVM.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 +++++++++-
 arch/x86/kvm/svm/svm.h |  8 ++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0e93b536dc34..f34da1203e09 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -57,6 +57,9 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #define sev_es_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -2298,6 +2301,7 @@ void __init sev_hardware_setup(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -2377,12 +2381,16 @@ void __init sev_hardware_setup(void)
 	if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
 		goto out;
 
-	pr_info("SEV-ES supported: %u ASIDs\n", sev_es_asid_count);
 	sev_es_supported = true;
+	sev_snp_supported = sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SEV_SNP);
+
+	pr_info("SEV-ES %ssupported: %u ASIDs\n",
+		sev_snp_supported ? "and SEV-SNP " : "", sev_es_asid_count);
 
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	sev_snp_enabled = sev_snp_supported;
 #endif
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ea9844546e8a..a48fe5d2bea5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -83,6 +83,7 @@ enum {
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
+	bool snp_active;	/* SEV-SNP enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -330,6 +331,13 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool sev_snp_guest(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_es_guest(kvm) && sev->snp_active;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1

