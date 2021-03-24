Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3706F347EB0
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbhCXRFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:48 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:12961
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237051AbhCXRFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgF95gNb/Tca5Gtibzl2up07k6PDDuHSbblTFpsIyqC4MvfvKGJJO3efW+PMODmGHIkZiCqKWWQXQ0+UEw09PSkyZXtpu1gJEgkZg1MdKeVlSedL1F8DE0txNvO0lPuMp+fDm9xuTi476y6SZcChSyGjaM5KcLC8NvNdDPvY9scRngQGTYOLUnW+W+N+xjtFjJ6ICgCjPhW7CJhLdgaNGo+VuO8Z+6WSDFZwTZMeuBpCzHnuWzj9HyfSubNf5SPHlJtXPVX0R2e81vsCVJjKn+0LlL0SwD3eHbahY/2IsCJdgS2ZipIANsCp4S47nmzICCtQxROSvemrsImIXHLPjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onz7IFNSkbYQBgnOp2uPu5Ik/9kXiYPCYwVrWPc74G8=;
 b=h3G4eSzf6yyn8uTes8W2ag/zAOo4tWeMgJfIddYOtFvp5pkBliiRePS9KFe3GPSE8TmZmdQzBQfRXbplwYZnm+TIDNWUIjy5r+SEWC4dFn4Vzn8OxfP4g1v65bl0VTIREtv/eWDkBy45QLPZ3Jwr4Kj7ID7AxcK017uJo+Q3TSeAIuBlLx6NZCqwNBLRYJvLRT0UXgs5rUsBLOg3n+q6HKkS7AWLLcv/cd5l5Tojy0ha69+wuIskP8koFKgGpa8D087L7lYgJwucnI/c79fkSAEgyt8aO0IagsW5n3jzEpVspgNu48G8drFGcCPPYkfRbrzTN0qj59AWriBU/h+TLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onz7IFNSkbYQBgnOp2uPu5Ik/9kXiYPCYwVrWPc74G8=;
 b=I9rHiedJYSzGOFltFtBUVf089w5nRS1B1WvW9R12mOlht+2ryPydIrX4mBwpsADB20MdIYVtUb8R9vLnT+Xn5oHKAAlfxRrdSFA6Q8dpUgzFViHpCQyx8FqFmPQ6xuV/lr6iDTfoZa7fL/LChDbj0eWZ8te0RqzFiqdCV5Zlv7o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2768.namprd12.prod.outlook.com (2603:10b6:805:72::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 17:05:02 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:02 +0000
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
        Marc Orr <marcorr@google.com>
Subject: [RFC Part2 PATCH 14/30] KVM: SVM: make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date:   Wed, 24 Mar 2021 12:04:20 -0500
Message-Id: <20210324170436.31843-15-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fbe3b245-49d4-4e16-ed30-08d8eee6f680
X-MS-TrafficTypeDiagnostic: SN6PR12MB2768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2768EA315C0B26C301D30E84E5639@SN6PR12MB2768.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBcseBjLvH+srAw9FwWNzQGViBHIaoj98s3AbaJluq6TO4Vc52oI9sh8mxaJJrXNulKvuOTmGw67eBo5WBMltnlUt9WA7yoWtHy+JTHcKKAJrsAI03sV4m59fIPuQKfiSnSzcuKs7KuiP3NTBHuxIdGbVpO2quLj0BrTyacXcVxp/KZzYk7V4DTzgb0iuVsVqHMdvmX2SXRrWPzN9oIzfrU4Gg8D0ZevKRoCiUvSNCpS23Osvthx8qFfzib7KwALffFHBEQT4Q/2W8iEdVMYO6Ii0G4XlmXkS86RdxTZwHE4Z99IeupnRVUlj8KfskBtDsP7cfeJvPvtttb5wFpqYk8UJQxxanmq8g35/Npt7qxbXzCSjNOByXCLTSorWVNWn/C8rT2L4dcUrhkZLctzOQr90B2JA8SbxnEFRzEbZ+9cBikzZluMn6LlC2jpHhO/yfmPOuu+A6iWKFhFRoVI4c9YzIAy9aAt4DPlwLkZe5MZIUq6BYCnRes1XU5uGGee9SnqEvLmajCbyyOg8lS8TMnskpOi70MO35rwVeInV6lqUuBn7CebF9bWB10DJmVsPeqr6sdbzG8TBxENFdiIU8BHgaiCBpnjE+xkeV1bkE68KGNS/rtoyGqOI7nxNTRGLPrtH41+eXAIBD+8bi40Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(4326008)(5660300002)(7696005)(66946007)(956004)(66476007)(2906002)(1076003)(7416002)(38100700001)(52116002)(86362001)(44832011)(6486002)(2616005)(66556008)(36756003)(8936002)(83380400001)(8676002)(26005)(478600001)(54906003)(6666004)(316002)(186003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VpCdt+TdqwThJ/ATQIWRNfwjTGAFjleVs7KC+53J+TJgOeFWQ5aWD5x23MUA?=
 =?us-ascii?Q?Qus8Ko2QlUmfQy1uj8Sswfxt1m/+kChoI3pexLc0iMrR0gmK054LMnFvenp3?=
 =?us-ascii?Q?2VbgjcUx0FZoOlyHRZg6ez5C5dyANWAobXTQTHlcPh6x4bHx4X4zyNfas8i7?=
 =?us-ascii?Q?Rg04WS1m0LrNA0DM2Sv3k5MS8HDno8nG3erWMBnWfJNvCZhYlD1hSEzMYp4I?=
 =?us-ascii?Q?Ugoowrk9IKqr6fcv563ggFZInwx6MgkokVulurF7cuRUheL+lPpkFfX/iRY1?=
 =?us-ascii?Q?FxEA0Bce/E9YYL6B7wsQ/GsZfGwW54KCQ1OVjXQ9SEzjIrKE71nAhItSn+I+?=
 =?us-ascii?Q?eIcswiFOisXXaArb43jBE271fnSHgNfzF7RDwaYodkq1e74JFrDedFi2FlE2?=
 =?us-ascii?Q?Mfs68Big+n4a/v+iA8umWfUmSJIHHZy0XQ7e5rJA2hZLPbUdGV41Yk++NxQk?=
 =?us-ascii?Q?X4BgN5dDWyGq4BIu0wrIJA3kGXPSRicynMwPUez2+A0qwFqL7cEWIec5Evtj?=
 =?us-ascii?Q?U0BGiPrfMAOkRQLUpRzVt/hml+HLoRcw+wVJgpWVwWPxUhRrRRnzbL2SRaGF?=
 =?us-ascii?Q?80l5rvZI196HGZ2VPIZsD7AYiUnqs3mLdGCIwMYOLlIzV+CHBuJ3jq2MYi+v?=
 =?us-ascii?Q?1fTNCOYJj0XuRRWkJjVdRQMTASwm3Ora2FhacY/yNQQurjFq2SJxr3D6yk/P?=
 =?us-ascii?Q?D5rAyoZvGq051LvYwbWL/gtl9MwouYTQfwogPlM9hGNloyk31EfbzDayVStv?=
 =?us-ascii?Q?CGMkSUE3Yuo/ajJSwmoVERgIJO87D7VElVCHIMjJt+yBrVPnqzufs5vZkZkY?=
 =?us-ascii?Q?EjOoVY0xtXTkuQLB1jvp5jIQrk2ACrwIlzgAWVGAWDk2rkii9nfS2/xwf8Rd?=
 =?us-ascii?Q?fybla97Om7mE0lyJf9UJFwa4mMA9eARLNF8mFTw66D1iSJCkEcOOXKTIYJB8?=
 =?us-ascii?Q?GWT4bPP5ec5InDtxW/67gB4StkPC1ac9ne1E0gAVav5CJ2xo2+8Y9qjoGRke?=
 =?us-ascii?Q?h+oNYqQt5iWDB92p2nfK62NnpeP6/TBwBMoinAdlb+0qFDVyfsiAnyAHER11?=
 =?us-ascii?Q?j9QmMy3m1bVasn0vQdPQNARlFctu8yugMN7B1zxmHxhF1FkqncU/yKyr+06q?=
 =?us-ascii?Q?CI+NoYoDKTSl+LScxtPjfe0WPCXiterWSBYOpdHVChCfldKRNbbNsAPzyGjg?=
 =?us-ascii?Q?BU+3ttD3kXxTcFL5rAWYxnm9uK3ryQskB2mM9qXi7gfUuEis3cnNxW10EHHK?=
 =?us-ascii?Q?+C5xPqrvYroL33n+oYFoqBq6O2NUlkokyW8/kjKEJqDS8TnMTXNlH6ED21S2?=
 =?us-ascii?Q?B0A3kfuKiBSbJeoxU8crJoji?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe3b245-49d4-4e16-ed30-08d8eee6f680
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:02.0936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfS+VSRYtkdQcEB9Gd10Nm500x1fPDXgzuF8JMaJvzOufqult+SUmIZ0U9bJuY6Emeq82l0nyjBg5kc6obxJ5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2768
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is globally enabled on a system, the VMRUN instruction
performs additional security checks on AVIC backing, VMSA, and VMCB page.
On a successful VMRUN, these pages are marked "in-use" by the
hardware in the RMP entry, and any attempt to modify the RMP entry for
these pages will result in page-fault (RMP violation check).

While performing the RMP check, hardware will try to create a 2MB TLB
entry for the large page accesses. When it does this, it first reads
the RMP for the base of 2MB region and verifies that all this memory is
safe. If AVIC backing, VMSA, and VMCB memory happen to be the base of
2MB region, then RMP check will fail because of the "in-use" marking for
the base entry of this 2MB region.

e.g.

1. A VMCB was allocated on 2MB-aligned address.
2. The VMRUN instruction marks this RMP entry as "in-use".
3. Another process allocated some other page of memory that happened to be
   within the same 2MB region.
4. That process tried to write its page using physmap.

If the physmap entry in step #4 uses a large (1G/2M) page, then the
hardware will attempt to create a 2M TLB entry. The hardware will find
that the "in-use" bit is set in the RMP entry (because it was a
VMCB page) and will cause an RMP violation check.

See APM2 section 15.36.12 for more information on VMRUN checks when
SEV-SNP is globally active.

A generic allocator can return a page which are 2M aligned and will not
be safe to be used when SEV-SNP is globally enabled. Add a
snp_safe_alloc_page() helper that can be used for allocating the
SNP safe memory. The helper allocated 2 pages and splits them into order-1
allocation. It frees one page and keeps one of the page which is not
2M aligned.

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
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Co-developed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            |  5 ++++-
 arch/x86/kvm/svm/sev.c          | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          | 16 ++++++++++++++--
 arch/x86/kvm/svm/svm.h          |  1 +
 5 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..ccd5f8090ff6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1301,6 +1301,7 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 43cceadd073e..7e0151838273 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2425,7 +2425,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	vcpu->arch.apic = apic;
 
-	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (kvm_x86_ops.alloc_apic_backing_page)
+		apic->regs = kvm_x86_ops.alloc_apic_backing_page(vcpu);
+	else
+		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b720837faf5a..4d5be5d2b05c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2079,3 +2079,30 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	 */
 	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
 }
+
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
+{
+	unsigned long pfn;
+	struct page *p;
+
+	if (!snp_key_active())
+		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+
+	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
+	if (!p)
+		return NULL;
+
+	/* split the page order */
+	split_page(p, 1);
+
+	/* Find a non-2M aligned page */
+	pfn = page_to_pfn(p);
+	if (IS_ALIGNED(__pfn_to_phys(pfn), PMD_SIZE)) {
+		pfn++;
+		__free_page(p);
+	} else {
+		__free_page(pfn_to_page(pfn + 1));
+	}
+
+	return pfn_to_page(pfn);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aa7ff4685c87..13df2cbfc361 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1324,7 +1324,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb_page)
 		goto out;
 
@@ -1333,7 +1333,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4423,6 +4423,16 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
+{
+	struct page *page = snp_safe_alloc_page(vcpu);
+
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_teardown,
 	.hardware_enable = svm_hardware_enable,
@@ -4546,6 +4556,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 3dd60d2a567a..9e8cd39bd703 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -603,6 +603,7 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
 void sev_es_vcpu_put(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.17.1

