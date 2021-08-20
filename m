Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3CA3F30C5
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbhHTQEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:08 -0400
Received: from mail-co1nam11on2048.outbound.protection.outlook.com ([40.107.220.48]:10816
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233061AbhHTQCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bI8vRySsxJBhFDn7y4R4lHOWXV/x4+it1C4NgwIGMXSGEnr8X18pntHFaphumfTJTkC9zH8L/XSTg6y8rk8DK65oyLVPNaZPL35WvmoOXRZO3aKdSUEZRuYzWXqRRMAmqTdfpeR951gvyTrur8mv79zmxnaUDy8GdgYltqzcuHMeABAfWQnGsRk3LI6rLqprZehfOnnBJRBms5lw2kfeGahmuaVeraFpywMqenYHvogltTr+HzMSOxJIb6XsucX2x6JJnhpy6GBQOd+WR/DLf0EKKYUG2KSuKjNJWPxv3Krm/IjK7Aw/+akFpWVR3B9UE9tFiXnTMJ2Ex1dulFwjEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jm4K16BACsEOPk7/e6IatfOFpVEUQZsSmG7us2qKtHo=;
 b=mCABOKVjE5Ibh4XJ489xBatBEAkI20oWMh/SvsNY581/eMfNyJyFJfECP1fXMmQuWbt0cParB6dLW5/eZkP7ZYp8UF70NOIvu3zgNg1mw0qy40ScNR59QjdaTkCdm1SOxrRCz0JP6AeALrF5Nbe930vBj44G87wgKEbfYJ4MydQwEusUskkAIgn++4ymw/GbpCjJEBMxx+CROuXv1NE3gHdb36HA5drB0S5Jqq/H5Aw0Ym9vR7C91gJwJeotsJlVVjYYQoQmw1hmQLufcsToJh2UT2wGpcsR6V1QmDGLhWpYxSWMuL1c0v5aqk5dfIH9HZEf6WSLm801V5nvwqmXUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jm4K16BACsEOPk7/e6IatfOFpVEUQZsSmG7us2qKtHo=;
 b=UhaCnaa0br+YE0jLPtsSd2asue4dJRTqK/NCFmJLPrpuKYeVBI+ThQfvWwn8d7uviL27tUzzxU05lSLdjgjlpU8rReoeG6N/LXDJ24qSiskZEJF34oQq22xG3KJbt8Rfn4ip0WbanSVq3Dv0LizSAgxZrcV08d56gbnAlG8t9C0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:31 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:31 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 29/45] KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
Date:   Fri, 20 Aug 2021 10:59:02 -0500
Message-Id: <20210820155918.7518-30-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcce6a3b-6040-41ec-dc34-08d963f3a2d1
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45748B39EF8556B4CB27F43FE5C19@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9att/wIobPuR7DMZCp5wjc2+dPxDsq79PFLFu3tPKHQVDqT7HcpkiovzC7ufhPukshDAC0tC7dMnSpji/fOvLrfgAF7mBgoOUAUYTBUXlGmcExlHRnWyDTdHba4TPJlWj6wF8nizQyK3qBKvLC9pQU6LmeMnYyANwM2A3k9e7AZPCNhEM+wUVdsHi/0dctrloCY236I7jMeevi9bZ+wIP1G1tvAGlqkPaypOnCdCSZsA8p0n5GWH+Y6SBRIIeUJ8r3+rgROcQZ4BaF5TSHj5I3woLem9xgWkykf40lZ7KWCK07fBJ8a4sLOGqgxr72mJ+3mzw/qO64Ae0NhojP/2w5qrLpxjErCutJingRIK6ZuFy0DYv2Msvuva/WGelb5LFQMRfVi/pwQbCGKqIzD3ua5nAFHaQQEXNJ5146D+/Xshe+ldwa5SYxC42GwXZm7dGAbO9wjS/DpminESaKaIbj2jtuD1tLLGtAYn0bauXCT9cV5c8temRGP95zXHTrOECczBrF6dWxlBmvqFBJvxU9y9b8DLdpkq7JqwUJQy8ffRaeVbOfLqVhChTMVQjZfvjrE09+OxhpmGQrSskN1l6MqnuqAzJFWqgGfywqnqK2LPJqGA0gyrHKDzCOvqXzX5lEbLDSL4Tfen60WpKUC8IhIeq3sB+RiPh7WcO3OQ5rlKLG9RrIQ3mBGsEWOKjpW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(38100700002)(316002)(38350700002)(5660300002)(26005)(44832011)(4326008)(66556008)(54906003)(7416002)(7406005)(8676002)(66476007)(86362001)(66946007)(6666004)(2616005)(956004)(8936002)(2906002)(36756003)(83380400001)(478600001)(6486002)(7696005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cIGayO6VQWZMGOSwyEpX5qYlxiBNC/LsUkdz+oa5sbNJQQIBXLl1vvAUxVE9?=
 =?us-ascii?Q?S1VamTYxHf/4GUOLZ6lGbjxs8WajPWcwR6sFyEbpI4QP34FBrAJ/1eF1wgiv?=
 =?us-ascii?Q?+wZBDFv4Q0qRA1IT5Mtd7lm2lw2CIkhRMD94t9qS70fNEOWjUBi6x8+B8vpY?=
 =?us-ascii?Q?r5VBQxtQmHgnC5+DswhvUXzVkZOXzj6f1zA6zM78JDfF1KOlPCYBU2X+ZQmO?=
 =?us-ascii?Q?SvKxO6TNPw/IE4w+brZOmWeSTaYGRBq4iFvrVx0r5YTgljbW0yCMFHJFh4R+?=
 =?us-ascii?Q?6jg2SUWXtONGXMD+i8uRBHaWSAR8dILohqkDT4cBbMJ2KIBGGDmwJTiOY2LL?=
 =?us-ascii?Q?ppss22vbTYU2lK0e7bx1YwfuIZXboLHrNh2ZUrOdwjAmOf2eOwWBbjeZj+4q?=
 =?us-ascii?Q?SVdqezlA3F4OzR0hWS2j5JmplpwAj/tw4EgaCVj07fz5g4+WYmd2Qw9wcj87?=
 =?us-ascii?Q?7K5vD1JTuEysc9x8iVCwFsi5hESMby+XHI0d2/nc22LBz9n/+sboQ9plQuYt?=
 =?us-ascii?Q?8jKnvWp4EHXubUmO4wtfC8VAjophWEpru040gZo5B/MxEpf0LStFchsmooLi?=
 =?us-ascii?Q?CeMXFS85qSgriWM8PvfhcgXaTCNXQFp7JfCBqfqOD3CpHZLYRvR+AO9EBM1O?=
 =?us-ascii?Q?+bHNeACWoZbVEhQMarL4OMFtqXIRkVC4xhfVKsvGRtVOZL9+8PK1cUPbCi2e?=
 =?us-ascii?Q?IX/hWefa2aSaqc+q/ty6l95twcrDlo/yTcc4OpKcGkPNBYZqvTnHqiRejJxu?=
 =?us-ascii?Q?ry3qFBSKOAzO0ibS/OMIFisIfw1QY1bjDOcubK+kxgYJdaplGGnQVj0cx2o8?=
 =?us-ascii?Q?Brdztu8bPjVjj+4/Bt3j3TczQXVr6eUMMxKUhJ89fOQ1jva3qks5RsknW8rt?=
 =?us-ascii?Q?HbS94wTQX06B4y+i3SH8SWrVGRsTXKRhxGRdR6awl2GR4YsNvWpNAVTQ6peK?=
 =?us-ascii?Q?AvxviyFxlOee7fqVshzEjnZg+Kl9ZIGaXu/4vtIOzCy7+azP5AafAiHUznmx?=
 =?us-ascii?Q?wN/kKeSWLvj/8ZXm2p244d1sfxnccUGVqCBroYW54dT4R+BsTeObbfAgFBC8?=
 =?us-ascii?Q?3GqRoKZdbURZXCPxhha60c2FNee4WH03U7I5swzOo9UgLhNBf4+9Uts3Nftk?=
 =?us-ascii?Q?Rmz18TSlQqtF72Dxw2QbI+kw9woTIz9F9S/aqxTNANN6arMYmbM+Nxv6SkDW?=
 =?us-ascii?Q?vXp06UQWBrv44hFtoHJe5wZDQ4/nn8iP1owD/JgzHA4mk2TM/StlIbld3cGn?=
 =?us-ascii?Q?4iF1XlMQS3XMOFTMMkgSOnWXbND9spc+YGrkindCq2PJXH7Vf0dyvO9kwRT2?=
 =?us-ascii?Q?g4UT6bWhjgmPsB4Fqacoj2pv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcce6a3b-6040-41ec-dc34-08d963f3a2d1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:31.1349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trFu30FXbzrDJcFnyVcV320V8F4Hd0w0VWgyD4CfuopFLhhbv0GmPQgZRiIK+lzKTTo9cScAQztgHcJakPK0Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

When adding pages prior to boot, TDX will need the resulting host pfn so
that it can be passed to TDADDPAGE (TDX-SEAM always works with physical
addresses as it has its own page tables).  Start plumbing pfn back up
the page fault stack.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/mmu/mmu.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f9aaf6e1e51e..5cbcbedcaaa6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3818,7 +3818,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			     bool prefault, int max_level, bool is_tdp)
+			     bool prefault, int max_level, bool is_tdp,
+			     kvm_pfn_t *pfn)
 {
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	bool write = error_code & PFERR_WRITE_MASK;
@@ -3826,7 +3827,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
-	kvm_pfn_t pfn;
 	hva_t hva;
 	int r;
 
@@ -3846,11 +3846,11 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
+	if (try_async_pf(vcpu, prefault, gfn, gpa, pfn, &hva,
 			 write, &map_writable))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, *pfn, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
@@ -3860,7 +3860,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
 
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
+	if (!is_noslot_pfn(*pfn) &&
+	    mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
@@ -3868,9 +3869,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	if (is_tdp_mmu_fault)
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
-				    pfn, prefault);
+				    *pfn, prefault);
 	else
-		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
+		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, *pfn,
 				 prefault, is_tdp);
 
 out_unlock:
@@ -3878,18 +3879,20 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_clean(*pfn);
 	return r;
 }
 
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 				u32 error_code, bool prefault)
 {
+	kvm_pfn_t pfn;
+
 	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
-				 PG_LEVEL_2M, false);
+				 PG_LEVEL_2M, false, &pfn);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -3928,6 +3931,7 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault)
 {
+	kvm_pfn_t pfn;
 	int max_level;
 
 	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
@@ -3941,7 +3945,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	}
 
 	return direct_page_fault(vcpu, gpa, error_code, prefault,
-				 max_level, true);
+				 max_level, true, &pfn);
 }
 
 static void nonpaging_init_context(struct kvm_mmu *context)
-- 
2.17.1

