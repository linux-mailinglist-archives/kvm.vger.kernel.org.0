Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DAC347EC4
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhCXRGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:06:08 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:33120
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237067AbhCXRFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeQYem4d57KvWE9n9sgFuyKqBP0tAN9Quv8V8fsfyTVK1J0N+r6KF8j4OSMnnsPvFwkCQa4t33XRqclUJrndlfldOGxd2fmD9kZWKbTSqHQKHQnrJ1huH09oyY7qIzy+5C7sdx0UqliXnL0XEXLQvtDC5UKsVa3NqqDnRvkPrg+fO6IXrJycrC2HKaHIE+gxmR8t4rk7xfkzojAu2zLUZOSgSDqxRhLsF7X2U5iuai9+WQXatPMsbIUjSxK3gNKzsprt1R480CwPZR+Vpj2QGKYZ3u+LIKfp6sKmbAX7oLjp3fvBYS1cFLetxI2UOZGi4kj7JEJEApvFu2Wb1d+xpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyMcfVc4mLhnGDEYlXoyasE1fLuujpYl7sOTzIFVynU=;
 b=VgwQGwHFjbgQi+C8klLRQG7Ks1bZWqNY5rOSOm/uJ9kg4iNA5UH51wKuXvEUIUJX0ZHCwnWJQI/8RnyxdlU68uikQgEPegC6hL5zvCHitjeJZmdch31qPAr5OJLqjp2pmdglAZ5ZhB970bBfoac+KrpbA28baBUToKwDUcZLSPg18R2E15zlAMQJ0wopGZOxfy+JlQsAPGavuboRu9Ynx8tSSTfIjFbsLp57O3QQhOH0hkYGX1TfHqaw28As03OZLw2nI/kFHGaxMVBY6V2iSS/LMRHWc2HktJhD72HRqHF4wgGvHmN/fSU+37YnfpYHo1DzDQPzvgqMRJ8NO64uMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyMcfVc4mLhnGDEYlXoyasE1fLuujpYl7sOTzIFVynU=;
 b=N9oTj+SdoWZVE8h+/2K4+uG2JEDsKtR5fcRTmWq7rHY0XCFajy27pyHdZKNJ6cKtbW66dPP8OOE58UPZeJutc4xTiwPMpONaDGBviK7npmbSw5uEjRWoKgCAEQxIY+unzQ2mB2nB2JVaox8xYw/adcJpt4CDvYipUzo8zLnnzzM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:13 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:13 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 27/30] KVM: SVM: add support to handle MSR based Page State Change VMGEXIT
Date:   Wed, 24 Mar 2021 12:04:33 -0500
Message-Id: <20210324170436.31843-28-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ce5ce69a-4367-438f-f2e0-08d8eee6fd5e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4382D7FB4DFCB2C2D2DF9DBFE5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVcNxsea4WxxZikEJsPibpSwnHWw6qqHjHK4TINFBrADxiCM6DiLxmRonZpEPhBJ3+EF3PsrZfXEbkw6nXyJniOkrEUkoQ2N7+w4IUQCcBOwOQL7iJRNx+nJ90e/OSp360mFaivuCtAeTPHNBb3TOuvgU6XYrjTDr0jD36Q3ULrweEv5mw8qyW5ShPxRldBVwvVTOrsENK7jCByShKlDkoP2UOHyQai7f6nsnFI2D2mTMQvRSOmTr6UdpxXjpCCrj302XxaH8D98qudvgxh/DeecoufZvColk72SRN1hChpmawlqCdkQBsOCiKrFPQJJAeHsRuw44Kk/6nd4JTCEIjr4dFF3hHR7vDds0Ka3GUl3wQ6O3NYGCPHM6umC+JL98Ak0vSdzdwOAWT4EKMNREBsXJqa49BNyrltbXagqWLGtIJVTPHMYGkTCrBNPG0VzO6jve5MmsadX6BtJqHBKHkjhooY6QUo8yHiygZ4WqjLMTaSwUvt65JiM0QTSif82KiTv2Og2hNdUuj9bCvZXL/SAvkqKyQCj8jgA4j4fxG9fOH0ynYmO8/9neZwVANKh012AI2EFKJJU29/HgmyOj2YYLoc1CByr9t38WQgVLEwBLJYA7f3XilDphD5sPLgYcIcXUI2+dZptpPi/WmmdTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tkbBDBqaD/pZXYXk2Ix7MkqeB0yz3njJt/aYizMRPU11nGHKLU136KycLe3B?=
 =?us-ascii?Q?mZr3EAQncjmzxzXn8IpI097Co0TDtmKDUNEFISyaLvV41MEKTlHB3OdlSDRf?=
 =?us-ascii?Q?Re+xCGCG2CIuNVlcjWQRcMkr0txVu0Mihb2+0xQe1sK45FTA5lLKRrLED7mA?=
 =?us-ascii?Q?AFsQx2L3NezXGSeoLCR4HFu3ekGas9JFfzZKx9YWvAfQ9BniMA9Bi9xxxZEQ?=
 =?us-ascii?Q?D+J56v2wksflq6JyfgNCfsEoO6GwxGGWKnTQMrlUgW1ckC7+MRtCU2IY+DYT?=
 =?us-ascii?Q?n8xx0XcN4PVCRl4bca2kcWEG9Cx9Ra4rzjQgjcW9tmmdghLyQquABGSscvXv?=
 =?us-ascii?Q?LtVOTmojcF9jXSGBxkB2TdzmPU40VVfhnK33EO2dexhL363+jJaZRNcJ2lUR?=
 =?us-ascii?Q?Y2pITbhHrHDEuoDeJqfoAJ8FqoUEVI6OiB+p+2kefTKFRVow8VSw5pmMZ3xS?=
 =?us-ascii?Q?olG1XGxk9xhskSzcK1cSCqd5gpbnqug+EJjmYVlFo0rq+IcStya/5o7u1Zl5?=
 =?us-ascii?Q?u9O3zTV99dheaDtTSVZM/4j6s/ZQY4LdRKuaLmPN0zsB3RfJ17JcrDfvTokp?=
 =?us-ascii?Q?HUJqQ/ydR/wXgybl6FR0eOJZVjgQG9PI9nGxCddAxGYkWGX+P6f9mKSkcrMM?=
 =?us-ascii?Q?5vMuZX/lAMmV359i5VqvyfMQqdanLKNdRbkksu9uVqBztZAP+g0gFIqUneoV?=
 =?us-ascii?Q?SBarigWXcYUxigPzS2adqnHho81EwT/zIUvdgR3FIC966UEDyVGUNnPWk4gR?=
 =?us-ascii?Q?JZAM/9z6HVRFaccueByQ6Zsl4WhldAYYpOCs3XNONgKi6bLARQqhLDnpGl0F?=
 =?us-ascii?Q?ktmrSUst8M7HLE1/bMQ6Zq+SzbvDA9KCSKPHWBhOVDFSihht9sre3kLo0tuq?=
 =?us-ascii?Q?yOkETjxSDKRZ5hOy2WC3mrvGF7rY/yoTQvSoHG4bW3cVsp/ZJ0xFJAJOF3dY?=
 =?us-ascii?Q?VJkdvX2oDCXc8ZL8D/4hoco0EVgcqoe7KgH4Et/4NzK3sUnbjNwCyjX+Ec96?=
 =?us-ascii?Q?V920NOtdd5ap0mUVVk9hHg8jNE8s5oxGtuUw9CFKH0YxjJh44xw39VTGMBDY?=
 =?us-ascii?Q?aA69oqA0BvTZ5thp8gkCX5XBEMv8OYWZC7rhlY8AGaKyUV0I/oJ91VApZUL/?=
 =?us-ascii?Q?W4g074KpVvxr3CegIorxYSmpQQ06J/lOb7fS2WyiWQOoNfwEG05gBvrZFSmW?=
 =?us-ascii?Q?VgS0KVR0GwlGTkmUfKSfALnf4zVMM6uP+9MkgqaFxuBRert6HzNRQUHT2vKS?=
 =?us-ascii?Q?kY3vme1xK5sv2rRcB9MrJUk2k9zbu+Jq9nfY2/EAiotQ9g0SwyKOLYwVBfJ1?=
 =?us-ascii?Q?EZONdrmAUf2ULB12bpk/5fi+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5ce69a-4367-438f-f2e0-08d8eee6fd5e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:13.5631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3V4YG/6w5wAO8AarvZqgrKT3JyGdcJhACyLBG3dTE7KCqjGtVy2j2IOeKLCDF1rD7wVYSFkg5XIlVGFhvJxpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification section 2.5.1.

Before changing the page state in the RMP entry, we lookup the page in
the TDP to make sure that there is a valid mapping for it. If the mapping
exist then try to find a workable page level between the TDP and RMP for
the page. If the page is not mapped in the TDP, then create a fault such
that it gets mapped before we change the page state in the RMP entry.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 148 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  11 +++
 2 files changed, 159 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7c242c470eba..8f046b45c424 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,6 +25,7 @@
 #include "svm.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "mmu.h"
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -2322,6 +2323,128 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_rmptable_psmash(struct kvm_vcpu *vcpu, kvm_pfn_t pfn)
+{
+	pfn = pfn & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+	/* Split the 2MB-page RMP entry into a corresponding set of contiguous 4KB-page RMP entry */
+	return rmptable_psmash(pfn_to_page(pfn));
+}
+
+static int snp_make_page_shared(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
+{
+	struct rmpupdate val;
+	int rc, rmp_level;
+	rmpentry_t *e;
+
+	e = lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
+	if (!e)
+		return -EINVAL;
+
+	if (!rmpentry_assigned(e))
+		return 0;
+
+	/* Log if the entry is validated */
+	if (rmpentry_validated(e))
+		pr_debug_ratelimited("Remove RMP entry for a validated gpa 0x%llx\n", gpa);
+
+	/*
+	 * Is the page part of an existing 2M RMP entry ? Split the 2MB into multiple of 4K-page
+	 * before making the memory shared.
+	 */
+	if ((level == PG_LEVEL_4K) && (rmp_level == PG_LEVEL_2M)) {
+		rc = snp_rmptable_psmash(vcpu, pfn);
+		if (rc)
+			return rc;
+	}
+
+	memset(&val, 0, sizeof(val));
+	val.pagesize = X86_RMP_PG_LEVEL(level);
+	return rmptable_rmpupdate(pfn_to_page(pfn), &val);
+}
+
+static int snp_make_page_private(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn, int level)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	struct rmpupdate val;
+	int rmp_level;
+	rmpentry_t *e;
+
+	e = lookup_page_in_rmptable(pfn_to_page(pfn), &rmp_level);
+	if (!e)
+		return -EINVAL;
+
+	/* Log if the entry is validated */
+	if (rmpentry_validated(e))
+		pr_err_ratelimited("Asked to make a pre-validated gpa %llx private\n", gpa);
+
+	memset(&val, 0, sizeof(val));
+	val.gpa = gpa;
+	val.asid = sev->asid;
+	val.pagesize = X86_RMP_PG_LEVEL(level);
+	val.assigned = true;
+
+	return rmptable_rmpupdate(pfn_to_page(pfn), &val);
+}
+
+static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, int op, gpa_t gpa, int level)
+{
+	struct kvm *kvm = vcpu->kvm;
+	gpa_t end, next_gpa;
+	int rc, tdp_level;
+	kvm_pfn_t pfn;
+
+	end = gpa + page_level_size(level);
+
+	for (; end > gpa; gpa = next_gpa) {
+		/*
+		 * Get the pfn and level for the gpa from the nested page table.
+		 *
+		 * If the TDP walk failed, then its safe to say that we don't have a valid
+		 * mapping for the gpa in the nested page table. Create a fault to map the
+		 * page is nested page table.
+		 */
+		if (!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &tdp_level)) {
+			pfn = kvm_mmu_map_tdp_page(vcpu, gpa, PFERR_USER_MASK, level);
+			if (is_error_noslot_pfn(pfn))
+				goto out;
+
+			if (!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &tdp_level))
+				goto out;
+		}
+
+		/* Adjust the level so that we don't go higher than the backing page level */
+		level = min_t(size_t, level, tdp_level);
+
+		spin_lock(&kvm->mmu_lock);
+
+		switch (op) {
+		case SNP_PAGE_STATE_SHARED:
+			rc = snp_make_page_shared(vcpu, gpa, pfn, level);
+			break;
+		case SNP_PAGE_STATE_PRIVATE:
+			rc = snp_make_page_private(vcpu, gpa, pfn, level);
+			break;
+		default:
+			rc = -EINVAL;
+			break;
+		}
+
+		spin_unlock(&kvm->mmu_lock);
+
+		if (rc) {
+			pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
+					   op, gpa, pfn, level, rc);
+			goto out;
+		}
+
+		next_gpa = gpa + page_level_size(level);
+	}
+
+out:
+	return rc;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2400,6 +2523,31 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PAGE_STATE_CHANGE_REQ: {
+		gfn_t gfn;
+		int ret;
+		u8 op;
+
+		gfn = get_ghcb_msr_bits(svm,
+					GHCB_MSR_PAGE_STATE_CHANGE_GFN_MASK,
+					GHCB_MSR_PAGE_STATE_CHANGE_GFN_POS);
+		op = get_ghcb_msr_bits(svm,
+					GHCB_MSR_PAGE_STATE_CHANGE_OP_MASK,
+					GHCB_MSR_PAGE_STATE_CHANGE_OP_POS);
+
+		ret = __snp_handle_page_state_change(vcpu, op, gfn_to_gpa(gfn), PG_LEVEL_4K);
+
+		set_ghcb_msr_bits(svm, ret,
+				  GHCB_MSR_PAGE_STATE_CHANGE_ERROR_MASK,
+				  GHCB_MSR_PAGE_STATE_CHANGE_ERROR_POS);
+		set_ghcb_msr_bits(svm, 0,
+				  GHCB_MSR_PAGE_STATE_CHANGE_RSVD_MASK,
+				  GHCB_MSR_PAGE_STATE_CHANGE_RSVD_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PAGE_STATE_CHANGE_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0de7c77b0d59..31bc9cc12c44 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -589,6 +589,17 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_MSR_GHCB_GPA_REGISTER_RESP		0x013
 #define GHCB_MSR_GHCB_GPA_REGISTER_ERROR	0xfffffffffffff
 
+#define GHCB_MSR_PAGE_STATE_CHANGE_REQ		0x014
+#define	GHCB_MSR_PAGE_STATE_CHANGE_GFN_POS	12
+#define	GHCB_MSR_PAGE_STATE_CHANGE_GFN_MASK	0xffffffffff
+#define	GHCB_MSR_PAGE_STATE_CHANGE_OP_POS	52
+#define	GHCB_MSR_PAGE_STATE_CHANGE_OP_MASK	0xf
+#define GHCB_MSR_PAGE_STATE_CHANGE_RESP		0x015
+#define	GHCB_MSR_PAGE_STATE_CHANGE_ERROR_POS	32
+#define	GHCB_MSR_PAGE_STATE_CHANGE_ERROR_MASK	0xffffffff
+#define	GHCB_MSR_PAGE_STATE_CHANGE_RSVD_POS	12
+#define	GHCB_MSR_PAGE_STATE_CHANGE_RSVD_MASK	0xfffff
+
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
 #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
-- 
2.17.1

