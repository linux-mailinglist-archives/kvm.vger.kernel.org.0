Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F67C23E55A
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgHGArf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:47:35 -0400
Received: from mail-dm6nam12on2084.outbound.protection.outlook.com ([40.107.243.84]:14497
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbgHGArd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:47:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvL6Hq1ZE8XXf4+wAgQa3hF3QLtrkSiAYiD5D3gtMVPfvcKvnNEnd4JJaOcEyzV3ZnSJaDxHr5DEsMOnCc2WiCclkjyWPbT9IU5bF4D5pzvV+em/BOLK1S3ZIThtrxoBZSpNYFe3V44BdNXNeOH/G1xJXEk4bYy7p5UXlgpL0V9G5GCr7dq1Tma2M448Wws3zC50Zpb7gRATFG5HEix+KTD3Ws7G6l65IBTXAJE+RQCypIJOd9C2UDoJyEVf+SfIIjCeECFw4CJjIet2pfAQtCAQU7GW9H4ct/atNnfaKEjy3HOV8HpoV93v65WVeoEUN3hBVX95ESJxSrQQTkhPJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JAO9IwuArf4iNlvGYie7oELfhsQUOp2WXm/dj6OfnE=;
 b=obt3XHUJAgc6+t/13bV3GiNCInZmu8f6BNddU5Ubs1XPmuO08cCbU9kVBW4RLqbPNo7MaF14kt5yggbIG+4q9GBuZR6Jvyu2zbJ1v6RAAyyw5GoJekmxFAa/ID1hRp4BUrYFEvDa4KwmpTUtGBA8vqvPDGNYct2NUw6VEqGSieavMKohKGLjlE8jvBG/xp87AAAaQA2egWfoN+xUrvIKuvSPs/5haHl+ErThM3WL+G16jTeSkic9Y5Vrf8AY3W4eW+TqONsWAJ3HkYDc1uxvHSyrAvt+ooSYzPJRP2Ae25I8f9HNzXkj/Wpr9vHmYF187HI8ml1ltihBc6FXMKoGlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JAO9IwuArf4iNlvGYie7oELfhsQUOp2WXm/dj6OfnE=;
 b=omFEPVcZ90dR5bFa9pzFpm7bM+5giEcccV3H0nOUqlhrS+jHkASzHAv/F9hHTBuqwQ3+rX8L6lDeNnwqrtKWHnfACkmhBnKNh2CguDQAmckTSQWyAdd61Wr+6OEc//8G3cbzMwOnEwt4ifE0NsFqJ285wFRWbOKmZOg/Ja0zFs0=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:47:29 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:47:29 +0000
Subject: [PATCH v4 10/12] KVM: X86: Rename and move the function
 vmx_handle_memory_failure to x86.c
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:47:27 -0500
Message-ID: <159676124786.12805.2925649566619758811.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0084.prod.exchangelabs.com (2603:10b6:800::52) To
 SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN2PR01CA0084.prod.exchangelabs.com (2603:10b6:800::52) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 00:47:28 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b582a267-5ba5-4834-1cf3-08d83a6b7612
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4479EB1A1AE1A95C37C4599495490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqoqLb8TIZGbZvVlkibggfJhTYERvf0wVvDLAVBZ35U7RaOJp+jcolJSITT1fh2WVh2J0ujdl19pK9VbqclnfAF1cQVBwjrO+qBP0M3BwuLJxSxt7T+mTEuNR3YnBUApVk0W+7SSUK9LZaAi5+WT99DE4k9UrQUIXoFOMLsNt024GWRB8SGO6PyTYVhBvNi7e5X9WE2KMlgkDY6Fgout9BY7YLT1MIo/MyEndwrXJzTHCyVl5N8zoeH0piJCmKWOMqApTi5q+px9nV6l06hLml4sgM7UOTZJ7DzpO0b2CELfyoW9KVxjpI/Mpjsaq5Cs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: t1xg3c4BfAeXvSX4lmMmAuWzitBrqxXYbOVz8jw28utG/Yb4YbGRO5zEjH7G0ixpgqfxwTy46Pwk1l8YC8GoRU96ezRRbFulHkW8dy8DH7JwYTMHL9Q2swOcD9c4EvSx/qXBM5c0kC3iYSSjRVWQ26z9/jzLWXBZq5O6sYAG3rRi+3PgCw5zbTPBPAXUhHsI11x1ryNanSo3Xd0EToyOjzPrVZqRVJC4BQkUMQ9wstTbJOSUaSvlG777tYe0PtPEwsxPQjHcLI36lfFi9cc7ARfbgGIZBMm+FBV8i6HDTp4qjGNUGguyJrMnTfZZz4WuY0bLSiwPqIQjCoZV9cbIMGdAzndzmixVOUjb52kYCu8AnbZP8YVE+YF9IWP3TBnZKkfRVciS0LF64QkSMhSHTN7lNa6hSs14N+mtrkpxiiX+i7+giXlr6Ho0I/Wpn2kd/vMAgSbhVQFEIobh6RI8Lin0SgIhLIIYmBi4mfXaygxZo1e2yiYU7RGqhm3yS5Wi3rgLv0SqJc0FCBAY84LelA/2G+hVzVcKRalCcnxhHvBFXvzOU+cSUvuuo9/KE84LXkg+1fl6iXfAyTD6MN7eUTWrjKnYZaW3sKldQFel/HgORDTP5htE2FCpEclwAuhmA4nNdQtj36ZDqW5ksBeRwg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b582a267-5ba5-4834-1cf3-08d83a6b7612
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:47:29.2014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7l6P09MHePrPByys7ZQO0YkDymO2/UzLf9bcDuWqoP3yXSmQ8Xf5IGqk4SoeKmt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handling of kvm_read/write_guest_virt*() errors can be moved to common
code. The same code can be used by both VMX and SVM.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/vmx/nested.c |   12 ++++++------
 arch/x86/kvm/vmx/vmx.c    |   29 +----------------------------
 arch/x86/kvm/vmx/vmx.h    |    2 --
 arch/x86/kvm/x86.c        |   28 ++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h        |    2 ++
 5 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d4a4cec034d0..32b7d9c07645 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4640,7 +4640,7 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
 
 	r = kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
 	if (r != X86EMUL_CONTINUE) {
-		*ret = vmx_handle_memory_failure(vcpu, r, &e);
+		*ret = kvm_handle_memory_failure(vcpu, r, &e);
 		return -EINVAL;
 	}
 
@@ -4951,7 +4951,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
 		r = kvm_write_guest_virt_system(vcpu, gva, &value, len, &e);
 		if (r != X86EMUL_CONTINUE)
-			return vmx_handle_memory_failure(vcpu, r, &e);
+			return kvm_handle_memory_failure(vcpu, r, &e);
 	}
 
 	return nested_vmx_succeed(vcpu);
@@ -5024,7 +5024,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 			return 1;
 		r = kvm_read_guest_virt(vcpu, gva, &value, len, &e);
 		if (r != X86EMUL_CONTINUE)
-			return vmx_handle_memory_failure(vcpu, r, &e);
+			return kvm_handle_memory_failure(vcpu, r, &e);
 	}
 
 	field = kvm_register_readl(vcpu, (((instr_info) >> 28) & 0xf));
@@ -5190,7 +5190,7 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	r = kvm_write_guest_virt_system(vcpu, gva, (void *)&current_vmptr,
 					sizeof(gpa_t), &e);
 	if (r != X86EMUL_CONTINUE)
-		return vmx_handle_memory_failure(vcpu, r, &e);
+		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	return nested_vmx_succeed(vcpu);
 }
@@ -5244,7 +5244,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 		return 1;
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
-		return vmx_handle_memory_failure(vcpu, r, &e);
+		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	/*
 	 * Nested EPT roots are always held through guest_mmu,
@@ -5326,7 +5326,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return 1;
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
-		return vmx_handle_memory_failure(vcpu, r, &e);
+		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.vpid >> 16)
 		return nested_vmx_failValid(vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 13745f2a5ecd..ff7920844702 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1597,33 +1597,6 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-/*
- * Handles kvm_read/write_guest_virt*() result and either injects #PF or returns
- * KVM_EXIT_INTERNAL_ERROR for cases not currently handled by KVM. Return value
- * indicates whether exit to userspace is needed.
- */
-int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
-			      struct x86_exception *e)
-{
-	if (r == X86EMUL_PROPAGATE_FAULT) {
-		kvm_inject_emulated_page_fault(vcpu, e);
-		return 1;
-	}
-
-	/*
-	 * In case kvm_read/write_guest_virt*() failed with X86EMUL_IO_NEEDED
-	 * while handling a VMX instruction KVM could've handled the request
-	 * correctly by exiting to userspace and performing I/O but there
-	 * doesn't seem to be a real use-case behind such requests, just return
-	 * KVM_EXIT_INTERNAL_ERROR for now.
-	 */
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 0;
-
-	return 0;
-}
-
 /*
  * Recognizes a pending MTF VM-exit and records the nested state for later
  * delivery.
@@ -5534,7 +5507,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 
 	r = kvm_read_guest_virt(vcpu, gva, &operand, sizeof(operand), &e);
 	if (r != X86EMUL_CONTINUE)
-		return vmx_handle_memory_failure(vcpu, r, &e);
+		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.pcid >> 12 != 0) {
 		kvm_inject_gp(vcpu, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 639798e4a6ca..adac99d9cbc8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -353,8 +353,6 @@ struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
-int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
-			      struct x86_exception *e);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..5806f606dd23 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10699,6 +10699,34 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
 
+/*
+ * Handles kvm_read/write_guest_virt*() result and either injects #PF or returns
+ * KVM_EXIT_INTERNAL_ERROR for cases not currently handled by KVM. Return value
+ * indicates whether exit to userspace is needed.
+ */
+int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
+			      struct x86_exception *e)
+{
+	if (r == X86EMUL_PROPAGATE_FAULT) {
+		kvm_inject_emulated_page_fault(vcpu, e);
+		return 1;
+	}
+
+	/*
+	 * In case kvm_read/write_guest_virt*() failed with X86EMUL_IO_NEEDED
+	 * while handling a VMX instruction KVM could've handled the request
+	 * correctly by exiting to userspace and performing I/O but there
+	 * doesn't seem to be a real use-case behind such requests, just return
+	 * KVM_EXIT_INTERNAL_ERROR for now.
+	 */
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	vcpu->run->internal.ndata = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_handle_memory_failure);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6eb62e97e59f..a8995806431d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -365,5 +365,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
+int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
+			      struct x86_exception *e);
 
 #endif

