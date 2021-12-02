Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE49466A0C
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 19:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348512AbhLBSzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 13:55:50 -0500
Received: from mail-dm3nam07on2065.outbound.protection.outlook.com ([40.107.95.65]:61889
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233228AbhLBSzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 13:55:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMYG098rm23FmUAA1JTQ/Mdm7dYQ+l3lGR82JccO68fSv1/k+YuNn80hdLXfRl5FUEpYR07VJBCjnM9nkfHn3/iyF1ud4IdWhLdSGUyIQQS3l+cXeD3BODOywoziQYcYEHz2VCQzC4IZDSGOE4Y2iaZcCqirkG9gINwJeupJ7y6XE8jXl3z8azk1RadKacL4sjpMGoGYCgNzuQtbMY2RdJKRAqWXrEIRlipb7OWdcKlt6mP6ilTakK34ExUsBJlzwfll+8+WJz7PqFb2Za7e0q1jC2xr6SaDnZKuEh08eUQmYrJgn8Qe0STNRT6H8ukAr3T6OOTtfARqVYaBkqGQsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9ocMtBKNzNIbRMPwMGNRs3nRJ708FZK0jAM8PWbOdc=;
 b=dItitIyL649KX+Am5scm83knFI8hQ0VtWpOJn1plIXPT9IIo1sk44+qhfsUVVmUBwZH/VL1Aut6Xxf+2RGFPl+bbLM2UMgn+M/9LI7AqPvBYnCDRkB4T8+L1WhHN556Vl6KbPbr3eQbjTvOe/+EqrO0bM1c+GnBUabjlNxYVEM4XOBXR6Hb7ErE7r52DBGzBjtJSPXTcAzc+fLPDQePfTmHh0Db4msdJCnlD0j8+9Q1fHd5OSAyOtpBBr0gdk8IJVOHT8GSHsQA2BXWMk7e4udCFBbyKNBuPNJMjp/XhlEAFnAoe7goHGsfWbdgxkyF/sUGPhkZgo9zDSfXky6cyTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9ocMtBKNzNIbRMPwMGNRs3nRJ708FZK0jAM8PWbOdc=;
 b=PRDmCi/MTwsR5mRF3nFglqtuXXOQ4me3zl1+hw8t+ty1rgLXA/5GG4i/n3appMXE6nv272nzWNbW4nt1XJYG/cUqESobBiU4oJx5F/yaAlFFQaDyPJWhc1htaiX7vGb7igE9JhyOEtDHnXZkkau17x51kRpAtmg9RcyDNf047gM=
Received: from DM6PR03CA0084.namprd03.prod.outlook.com (2603:10b6:5:333::17)
 by DM6PR12MB3529.namprd12.prod.outlook.com (2603:10b6:5:15d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 18:52:23 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::e5) by DM6PR03CA0084.outlook.office365.com
 (2603:10b6:5:333::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Thu, 2 Dec 2021 18:52:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 18:52:23 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 2 Dec
 2021 12:52:22 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB validation failure
Date:   Thu, 2 Dec 2021 12:52:05 -0600
Message-ID: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80c85bf5-3e75-4fa1-5e22-08d9b5c4e0a0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3529:
X-Microsoft-Antispam-PRVS: <DM6PR12MB35292B81756D9DC8947647B5EC699@DM6PR12MB3529.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8pPAhlX5KCkJBjRO4pOGTMs0nj9U+p5u88IntQUlhL81U3/HjtnqVoDiV46COVjVNQDi2MCnkt+iGN5JgXXnlzRe4qg723ufb5YLIJE6GBnXIEDbiwYNPmSXozDXEIRE+MRNNkAarZd0uJaVBegPxEx9D39oisveP/iAJuCrv4YNzeVEZoaDwvjown5n+tyV7N2Umr4408XCN6Y5M+VH0CO+wNBJ1TOe+ESY9oxPjYmfOC/ZrelaLCMeADYlwxHOlCs/5vpUyyEHHOqSA3Pb/QkUJxlXd3JqcGZE4oCwoPe67A/tM8MBIzAPn1KHwzabZ8pcCLUDjs/Y+xxTaP8rAQWZovBWV1LvH6IcAT1U4EANyPHiCXhgtb8gMUFpE4auvaC6GZbzHYouLycDoCOOY7Yq2q5IpgBwGCnM48f5P3ET0EsCMNP5tOS2vx+HoxYnq7mz4kGJ9MAOzvC5DPhYhEAcaB3Cwn8D0xljDvpZHF2ZtAmrpXpIPXXwJEO259luqinAMO+9miZfSKsKxrDClcWr/9q5R+64nZWmYeE/h9XZDTABc/L09F4HTK0fEkBKUke7wqcTQihgIKzNSGd6O3QFZ1f37pYSAQlykuIoz7diLPXvGr2e787iKSViHgpue33hAgqWfDHImigZtsqmhe6Z3uiaUWo4joLDM7ZOs/m9gnrJhFvhzn0bHMwNwukK+A3cWYvYfHIwDxosgdDEzCDP/Cc6PeWtVNIASnDHzsJBGbrubkObxdwkp5ONNY4yvLOSr4cI7RADqRiJ7LOdHAj0Ay2/2jYQ7o97oHfeO/g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(2906002)(6666004)(110136005)(54906003)(8936002)(36756003)(316002)(336012)(356005)(36860700001)(7416002)(2616005)(426003)(508600001)(86362001)(83380400001)(186003)(16526019)(82310400004)(47076005)(7696005)(8676002)(26005)(40460700001)(70206006)(81166007)(5660300002)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 18:52:23.5661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c85bf5-3e75-4fa1-5e22-08d9b5c4e0a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3529
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
exit code or exit parameters fails.

The VMGEXIT instruction can be issued from userspace, even though
userspace (likely) can't update the GHCB. To prevent userspace from being
able to kill the guest, return an error through the GHCB when validation
fails rather than terminating the guest. For cases where the GHCB can't be
updated (e.g. the GHCB can't be mapped, etc.), just return back to the
guest.

The new error codes are documented in the lasest update to the GHCB
specification.

Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev-common.h |  11 ++++
 arch/x86/kvm/svm/sev.c            | 106 +++++++++++++++++-------------
 2 files changed, 71 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 2cef6c5a52c2..6acaf5af0a3d 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -73,4 +73,15 @@
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
+/*
+ * Error codes related to GHCB input that can be communicated back to the guest
+ * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
+ */
+#define GHCB_ERR_NOT_REGISTERED		1
+#define GHCB_ERR_INVALID_USAGE		2
+#define GHCB_ERR_INVALID_SCRATCH_AREA	3
+#define GHCB_ERR_MISSING_INPUT		4
+#define GHCB_ERR_INVALID_INPUT		5
+#define GHCB_ERR_INVALID_EVENT		6
+
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 713e3daa9574..322553322202 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2353,24 +2353,29 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
-static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
+static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu;
 	struct ghcb *ghcb;
-	u64 exit_code = 0;
+	u64 exit_code;
+	u64 reason;
 
 	ghcb = svm->sev_es.ghcb;
 
-	/* Only GHCB Usage code 0 is supported */
-	if (ghcb->ghcb_usage)
-		goto vmgexit_err;
-
 	/*
-	 * Retrieve the exit code now even though is may not be marked valid
+	 * Retrieve the exit code now even though it may not be marked valid
 	 * as it could help with debugging.
 	 */
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
+	/* Only GHCB Usage code 0 is supported */
+	if (ghcb->ghcb_usage) {
+		reason = GHCB_ERR_INVALID_USAGE;
+		goto vmgexit_err;
+	}
+
+	reason = GHCB_ERR_MISSING_INPUT;
+
 	if (!ghcb_sw_exit_code_is_valid(ghcb) ||
 	    !ghcb_sw_exit_info_1_is_valid(ghcb) ||
 	    !ghcb_sw_exit_info_2_is_valid(ghcb))
@@ -2449,30 +2454,34 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		break;
 	default:
+		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
 	}
 
-	return 0;
+	return true;
 
 vmgexit_err:
 	vcpu = &svm->vcpu;
 
-	if (ghcb->ghcb_usage) {
+	if (reason == GHCB_ERR_INVALID_USAGE) {
 		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
 			    ghcb->ghcb_usage);
+	} else if (reason == GHCB_ERR_INVALID_EVENT) {
+		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx is not valid\n",
+			    exit_code);
 	} else {
-		vcpu_unimpl(vcpu, "vmgexit: exit reason %#llx is not valid\n",
+		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx input is not valid\n",
 			    exit_code);
 		dump_ghcb(svm);
 	}
 
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_code;
-	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	/* Clear the valid entries fields */
+	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
+
+	ghcb_set_sw_exit_info_1(ghcb, 2);
+	ghcb_set_sw_exit_info_2(ghcb, reason);
 
-	return -EINVAL;
+	return false;
 }
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
@@ -2531,7 +2540,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
-static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
+static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct ghcb *ghcb = svm->sev_es.ghcb;
@@ -2542,14 +2551,14 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");
-		return -EINVAL;
+		goto e_scratch;
 	}
 
 	scratch_gpa_end = scratch_gpa_beg + len;
 	if (scratch_gpa_end < scratch_gpa_beg) {
 		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
 		       len, scratch_gpa_beg);
-		return -EINVAL;
+		goto e_scratch;
 	}
 
 	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
@@ -2567,7 +2576,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		    scratch_gpa_end > ghcb_scratch_end) {
 			pr_err("vmgexit: scratch area is outside of GHCB shared buffer area (%#llx - %#llx)\n",
 			       scratch_gpa_beg, scratch_gpa_end);
-			return -EINVAL;
+			goto e_scratch;
 		}
 
 		scratch_va = (void *)svm->sev_es.ghcb;
@@ -2580,18 +2589,18 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		if (len > GHCB_SCRATCH_AREA_LIMIT) {
 			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
 			       len, GHCB_SCRATCH_AREA_LIMIT);
-			return -EINVAL;
+			goto e_scratch;
 		}
 		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
-			return -ENOMEM;
+			goto e_scratch;
 
 		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
 			/* Unable to copy scratch area from guest */
 			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
 
 			kvfree(scratch_va);
-			return -EFAULT;
+			goto e_scratch;
 		}
 
 		/*
@@ -2607,7 +2616,13 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	svm->sev_es.ghcb_sa = scratch_va;
 	svm->sev_es.ghcb_sa_len = len;
 
-	return 0;
+	return true;
+
+e_scratch:
+	ghcb_set_sw_exit_info_1(ghcb, 2);
+	ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
+
+	return false;
 }
 
 static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
@@ -2658,7 +2673,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_CPUID);
 		if (!ret) {
-			ret = -EINVAL;
+			/* Error, keep GHCB MSR value as-is */
 			break;
 		}
 
@@ -2694,10 +2709,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 						GHCB_MSR_TERM_REASON_POS);
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
-		fallthrough;
+
+		ret = -EINVAL;
+		break;
 	}
 	default:
-		ret = -EINVAL;
+		/* Error, keep GHCB MSR value as-is */
+		break;
 	}
 
 	trace_kvm_vmgexit_msr_protocol_exit(svm->vcpu.vcpu_id,
@@ -2721,14 +2739,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	if (!ghcb_gpa) {
 		vcpu_unimpl(vcpu, "vmgexit: GHCB gpa is not set\n");
-		return -EINVAL;
+
+		/* Without a GHCB, just return right back to the guest */
+		return 1;
 	}
 
 	if (kvm_vcpu_map(vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->sev_es.ghcb_map)) {
 		/* Unable to map GHCB from guest */
 		vcpu_unimpl(vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
 			    ghcb_gpa);
-		return -EINVAL;
+
+		/* Without a GHCB, just return right back to the guest */
+		return 1;
 	}
 
 	svm->sev_es.ghcb = svm->sev_es.ghcb_map.hva;
@@ -2738,18 +2760,17 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
-	ret = sev_es_validate_vmgexit(svm);
-	if (ret)
-		return ret;
+	if (!sev_es_validate_vmgexit(svm))
+		return 1;
 
 	sev_es_sync_from_ghcb(svm);
 	ghcb_set_sw_exit_info_1(ghcb, 0);
 	ghcb_set_sw_exit_info_2(ghcb, 0);
 
+	ret = 1;
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
-		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
-		if (ret)
+		if (!setup_vmgexit_scratch(svm, true, control->exit_info_2))
 			break;
 
 		ret = kvm_sev_es_mmio_read(vcpu,
@@ -2758,8 +2779,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					   svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_MMIO_WRITE:
-		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
-		if (ret)
+		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
 			break;
 
 		ret = kvm_sev_es_mmio_write(vcpu,
@@ -2788,14 +2808,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(ghcb, 1);
-			ghcb_set_sw_exit_info_2(ghcb,
-						X86_TRAP_UD |
-						SVM_EVTINJ_TYPE_EXEPT |
-						SVM_EVTINJ_VALID);
+			ghcb_set_sw_exit_info_1(ghcb, 2);
+			ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
-		ret = 1;
 		break;
 	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
@@ -2815,7 +2831,6 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 {
 	int count;
 	int bytes;
-	int r;
 
 	if (svm->vmcb->control.exit_info_2 > INT_MAX)
 		return -EINVAL;
@@ -2824,9 +2839,8 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	if (unlikely(check_mul_overflow(count, size, &bytes)))
 		return -EINVAL;
 
-	r = setup_vmgexit_scratch(svm, in, bytes);
-	if (r)
-		return r;
+	if (!setup_vmgexit_scratch(svm, in, bytes))
+		return 1;
 
 	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->sev_es.ghcb_sa,
 				    count, in);
-- 
2.33.1

