Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB2E4D1D83
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347586AbiCHQk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348482AbiCHQkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2265133E;
        Tue,  8 Mar 2022 08:39:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcqVYj71CZYWCY59XE+35WNQsph7o+x1+az/S7EMeCZoPYE7g7NtwHOI8wz39qSndnSVD7ymI/jLTyCLvqtXCFMsCLBN96PITAUvYdxnUKBfWgU9adZPMrUHqKWX9KL9BmvrDusEXPnTtbOBXDiYgGdpdZYPlAh+RhiSgEM/cTWDU+WAkZOgFb6PLLCNiuwCo49711P1cpeLUMkvUh707xUnmTItxF9Lk7E/6O36b8wZamTuQ+O6hD5vwjFAcIExebx8rxcPqiMUkh512n/hI0b+6qu00+skbUukO2UmXOEQLyRe4PPlAz8zCrX92jlwl8uG8onYoOWSREp6ZDm4zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UnRT10K4/m2wKs/lYEl5wl8ZQ6X3t9KgM0ydPfTSg8=;
 b=JjJgor1R9GPIMzRfQJ19LGIh5Oj38Avl51TJGmAjjigBe8ZLygNN0STzNBbpExhrG0gXvSnw+/VMjdIV5oE4hDoB4crIaLPkdkAP2QlabV8H4sxJLqdngleZTIBk2rvLiEIuUULDEDLRs8EIWY21iXVFl4m68ftk1zFvxKUWFa6E8lKswFoExNGVYw046yqrlnX3fUTpMIwKL3kQz/V8YtlgnkKVj9/EcnO6q4nkNepFiRr1EIR48mzUE+HAtYCCiwW/RcSNiAY8+uvB5/7KdKDRP5VMqMlYExeqzdpf0+KlwNLhtBZbIJjkVhb8a/AGto4w8pJhsi5OjEbNNM230w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UnRT10K4/m2wKs/lYEl5wl8ZQ6X3t9KgM0ydPfTSg8=;
 b=DSZ8LD0YP10Mf1WoK0ThuE/NjnR/Jacg012Lt8kjjEbC8NThRbBm5Ou6tSbrCGKbF+chh/5ElsX4ic0OIJGaNTnRkoUNTK4gz+XBnbTtJWY/Wn2VRGtH/CN3batub3g3KR9vUl63pmWxB8UY1UD8tcuxmmXApZ/R/rHc4OxDw8Q=
Received: from BN9PR03CA0858.namprd03.prod.outlook.com (2603:10b6:408:13d::23)
 by BN6PR12MB1682.namprd12.prod.outlook.com (2603:10b6:405:4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 16:39:51 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::4d) by BN9PR03CA0858.outlook.office365.com
 (2603:10b6:408:13d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:50 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:46 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 08/12] KVM: SVM: Adding support for configuring x2APIC MSRs interception
Date:   Tue, 8 Mar 2022 10:39:22 -0600
Message-ID: <20220308163926.563994-9-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: cfe410ba-aaea-4363-4af1-08da012243fd
X-MS-TrafficTypeDiagnostic: BN6PR12MB1682:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1682F0356F549F2799420B0BF3099@BN6PR12MB1682.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: svyK5FsRt21vUvk13M7y08A8E6TC7LaBV2ZvKTEieZCDU2u1b8fx0BkMJatTdvmRSUEZfdrEgFpsG85MMqXRjSItN0oe4vuMDtqyqzld6d7wrXhm1oOdZIb1tWXYm3hP0t9TWjYPSgeMHJOefLflbTgBtelufB51TNHC5SthwQoW3PbXld9e4a4PdJvYDcWPDqEwJc300n+hmwlybeI2EAz1Wuy+6skFNKf1b28jmxGgmoKxemhiTBPOWmu78gN7TALG+9Cx5RjpNMm4xKRE+s003qLhiE9uVSLGOYIZZCQdJaq/8U0xlLWjELt6l8PF97Xv88gKd59UizxaG6spODaC1l2ZQcIVrFOFtyn62hOK6PY9OVNR8kNYs7T+9Dobm64zoq3VEOcpJG3xz/g4l17nnzpavElydhUpuNWM91O1eLWLLa6HwXk9Q324ONoLyLqXL5uiW0GFL+4qwdolPL2A2a18jonKhSwb3VBETBZjwsrOBdTViI/z7Iu4DGKmKFx6qqKxzrrYntLCdENmpmGh86wBSdTqoa2Nz5FLpLFqA2lfM6RHDJCXYIzJJBRBFxUYhHNtqskMir+XoCUuASngab0ERgt0I8XXcu4nfcNbSD1cDSSnMlVnu5UKYbgvbglV+pUmVRIPdtFTmnwvsIs0ytRzSx8ThLM9isWvHcobPI8JddNnbbr7ugDAz4vRE5dqNynNwgWKvNVr5lEvVg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400004)(70206006)(8936002)(70586007)(4326008)(86362001)(5660300002)(44832011)(1076003)(2616005)(336012)(426003)(26005)(186003)(8676002)(36756003)(47076005)(83380400001)(2906002)(40460700003)(16526019)(7696005)(6666004)(36860700001)(356005)(81166007)(110136005)(54906003)(316002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:50.6754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe410ba-aaea-4363-4af1-08da012243fd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1682
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When enabling x2APIC virtualization (x2AVIC), the interception of
x2APIC MSRs must be disabled to let the hardware virtualize guest
MSR accesses.

Current implementation keeps track of MSR interception state
for generic MSRs in the svm_direct_access_msrs array.
For x2APIC MSRs, introduce direct_access_x2apic_msrs array.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/svm.c | 67 +++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h |  7 +++++
 2 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3048f4b758d6..ce3c68a785cf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -89,7 +89,7 @@ static uint64_t osvw_len = 4, osvw_status;
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 #define TSC_RATIO_DEFAULT	0x0100000000ULL
 
-static const struct svm_direct_access_msrs {
+static struct svm_direct_access_msrs {
 	u32 index;   /* Index of the MSR */
 	bool always; /* True if intercept is initially cleared */
 } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
@@ -117,6 +117,9 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_INVALID,				.always = false },
 };
 
+static struct svm_direct_access_msrs
+direct_access_x2apic_msrs[NUM_DIRECT_ACCESS_X2APIC_MSRS + 1];
+
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * pause_filter_count: On processors that support Pause filtering(indicated
@@ -609,41 +612,42 @@ static int svm_cpu_init(int cpu)
 
 }
 
-static int direct_access_msr_slot(u32 msr)
+static int direct_access_msr_slot(u32 msr, struct svm_direct_access_msrs *msrs)
 {
 	u32 i;
 
-	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++)
-		if (direct_access_msrs[i].index == msr)
+	for (i = 0; msrs[i].index != MSR_INVALID; i++)
+		if (msrs[i].index == msr)
 			return i;
 
 	return -ENOENT;
 }
 
-static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
-				     int write)
+static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu,
+				     struct svm_direct_access_msrs *msrs, u32 msr,
+				     int read, void *read_bits,
+				     int write, void *write_bits)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	int slot = direct_access_msr_slot(msr);
+	int slot = direct_access_msr_slot(msr, msrs);
 
 	if (slot == -ENOENT)
 		return;
 
 	/* Set the shadow bitmaps to the desired intercept states */
 	if (read)
-		set_bit(slot, svm->shadow_msr_intercept.read);
+		set_bit(slot, read_bits);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.read);
+		clear_bit(slot, read_bits);
 
 	if (write)
-		set_bit(slot, svm->shadow_msr_intercept.write);
+		set_bit(slot, write_bits);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.write);
+		clear_bit(slot, write_bits);
 }
 
-static bool valid_msr_intercept(u32 index)
+static bool valid_msr_intercept(u32 index, struct svm_direct_access_msrs *msrs)
 {
-	return direct_access_msr_slot(index) != -ENOENT;
+	return direct_access_msr_slot(index, msrs) != -ENOENT;
 }
 
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
@@ -674,9 +678,12 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 
 	/*
 	 * If this warning triggers extend the direct_access_msrs list at the
-	 * beginning of the file
+	 * beginning of the file. The direct_access_x2apic_msrs is only for
+	 * x2apic MSRs.
 	 */
-	WARN_ON(!valid_msr_intercept(msr));
+	WARN_ON(!valid_msr_intercept(msr, direct_access_msrs) &&
+		(boot_cpu_has(X86_FEATURE_X2AVIC) &&
+		 !valid_msr_intercept(msr, direct_access_x2apic_msrs)));
 
 	/* Enforce non allowed MSRs to trap */
 	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
@@ -704,7 +711,16 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 			  int read, int write)
 {
-	set_shadow_msr_intercept(vcpu, msr, read, write);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (msr < 0x800 || msr > 0x8ff)
+		set_shadow_msr_intercept(vcpu, direct_access_msrs, msr,
+					 read, svm->shadow_msr_intercept.read,
+					 write, svm->shadow_msr_intercept.write);
+	else
+		set_shadow_msr_intercept(vcpu, direct_access_x2apic_msrs, msr,
+					 read, svm->shadow_x2apic_msr_intercept.read,
+					 write, svm->shadow_x2apic_msr_intercept.write);
 	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
 }
 
@@ -786,6 +802,22 @@ static void add_msr_offset(u32 offset)
 	BUG();
 }
 
+static void init_direct_access_x2apic_msrs(void)
+{
+	int i;
+
+	/* Initialize x2APIC direct_access_x2apic_msrs entries */
+	for (i = 0; i < NUM_DIRECT_ACCESS_X2APIC_MSRS; i++) {
+		direct_access_x2apic_msrs[i].index = boot_cpu_has(X86_FEATURE_X2AVIC) ?
+						  (0x800 + i) : MSR_INVALID;
+		direct_access_x2apic_msrs[i].always = false;
+	}
+
+	/* Initialize last entry */
+	direct_access_x2apic_msrs[i].index = MSR_INVALID;
+	direct_access_x2apic_msrs[i].always = false;
+}
+
 static void init_msrpm_offsets(void)
 {
 	int i;
@@ -4750,6 +4782,7 @@ static __init int svm_hardware_setup(void)
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
+	init_direct_access_x2apic_msrs();
 	init_msrpm_offsets();
 
 	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b53c83a44ec2..19ad40b8383b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -29,6 +29,8 @@
 
 #define MAX_DIRECT_ACCESS_MSRS	20
 #define MSRPM_OFFSETS	16
+#define NUM_DIRECT_ACCESS_X2APIC_MSRS	0x100
+
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern bool intercept_smi;
@@ -241,6 +243,11 @@ struct vcpu_svm {
 		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
 	} shadow_msr_intercept;
 
+	struct {
+		DECLARE_BITMAP(read, NUM_DIRECT_ACCESS_X2APIC_MSRS);
+		DECLARE_BITMAP(write, NUM_DIRECT_ACCESS_X2APIC_MSRS);
+	} shadow_x2apic_msr_intercept;
+
 	struct vcpu_sev_es_state sev_es;
 
 	bool guest_state_loaded;
-- 
2.25.1

