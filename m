Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD7D398C4A
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhFBORF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:17:05 -0400
Received: from mail-dm6nam12on2058.outbound.protection.outlook.com ([40.107.243.58]:12928
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231994AbhFBOPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:15:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blHPFbEERjgERwZcxiIKtzeylxFTwhNZMt4dJ5L9yU59AKbTOmmI5rA1R/8hnhGPRwZWdNZ3BzTEboWlKQt+3tgr+rnqVWrnkcD2gWFVfhtGMQcblMuja+jSQiHKgEnIuUtm4wDLmpy49f+Dq9AHCvkxL/uvPhXCPZ3615wAytIHdxnk6oBut19gnp3b87X+Vhmvdlo1HInI9JhqHzBgzSGThhCi//FkSahu6lj2nYD7LFZEl4d/3goMmeHL0YjbQF5NRJ4385rpF2nEzrjXTVxBh+vMuVe8RRxge9rSsHpbnu3cPcC/YbqiPY5tJzxkeELFggvDfW0WOGRR1QfZbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ctf2ZME0dCzsd2GPR85K3/wNdSfar94NNCdQynI6vjY=;
 b=m6unJd3J8DuMx+RYNI1hm1xPu6pCGJAiytyvUkVkT5YaucLVSSOZjcujh0oZuCt+okgaRY5gciJuB2VPiZDNvWcogeEt31hugqARDVGP1hhzKNohQjNceOOMH/ZV5u+8quXdycu7Jr2Sz+FV5TqOJgfz8FskjthdUgxC8T1cVBtelEICisX4Q1A6FdUHFM4Omwoda/ix34m//iXlF5PYrKdpFUNFvU3UnWrA6Uu24m3dKrGZA72bvsMph6iSH83/Yi0YouvL49BA24UQU4Etmd6Ldg+K0NRhq6RPR1Q0Yn/TmjmuvOGkEqfQPUcDA4x9QwJ2gerkzjtlHkW7jhZZcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ctf2ZME0dCzsd2GPR85K3/wNdSfar94NNCdQynI6vjY=;
 b=TR57PGWJmxjuEQ+Z01+FWtbwJoiZPEe8v6+o5Qrs9hX/0GeoFn4dSAHFe9MNgErBAHAjB+4SiEeCTDXAimf+Rrc9Qm2/Pb8d0FiY1J+f9aZOBNyX4zyiwtt0PSTrAfllueJiTI+xf/xb7OSKAeUgck6G7buwndtCPeQ4q34Ac4Y=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:11:59 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:59 +0000
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 24/37] KVM: X86: Add kvm_x86_ops to get the max page level for the TDP
Date:   Wed,  2 Jun 2021 09:10:44 -0500
Message-Id: <20210602141057.27107-25-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02bc59a9-9ed3-4db4-44b7-08d925d062e7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592714804CF52D3EF72E340E53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJdz4BdUbH6aeN100rx81FQ86UFRd2LkMAbOJmY5FqErvJC10UoIy2x1IxwkZ/9yTdRptE9I315LhtxlS4v7pElQhh8SXmM4klZ59LXXXV0PyH63KFHMvitEBUA8R4YCQpclTx5B8G4qJFMQHX2OJDznyQeD2mBp8DAnCRJNb8cjtoEQvJbthhauxCVn86ox17ffVRd+Ymw/w5P71hK9a1AjWYOsRztVVJWhcTO/WfRFHrtO3Av6VzlQNMQVmLg0GdfMdjvjO/+biFX4GCZOK3jJdj0305pUtVjntwCfjDmFUW01etHltR1Cwfap6VYw/32zqYjSbsEH8OlcUizgTW6QMRRUIoy9s1daXhcHkAnMo/J6NMKJBXyVH4Mj8Lh9wliwOUptkbcSyjWWrIChI8vrhZblDEJ147vMbY9wg/zRdvPFMaQP9yAt+017MCjUAkJWOGFhdoujCDmAHLJ4b1sQS4opk3esapvq7TMJlfkKfAQfIcdzHw1KQ2935tZPgw7dnoJVayzfrQ6nO9TXQPAodYoLr8/1UDbi4TJEDJrNQa9QmAkh7jJskC+UAWjZ+YIhNxp5JC+TmMYG+f5QaQ0gYq3xixhzNGndyOgXB18RVHzCZYYjNbx5mbWNhiUfhQ0q9nv2DxktwbccfBbpXT2kCmOftnvm1kimNLfl0OI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(956004)(8936002)(8676002)(36756003)(478600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002)(316002)(15583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?21Cq4EYlOJVA2gCTxwAQBtrMpQ62h2gIxuew0tnUhJmk9M8EBbsF7Imb/HWP?=
 =?us-ascii?Q?ZZNkp/0Tk36sJWS2+QMXLzqIFmaTdhdPROf1avEcUQZMDW/nmtfJrxvrd4H/?=
 =?us-ascii?Q?mvotAGUarYd1lbo+J5F7fxhRgVpwCTOZESemajMy9AxvGFlnqreONJl//gxM?=
 =?us-ascii?Q?LNy2DAOzfKq2qXjYHPDLPghMbtmxbeNht8hWhnwf3j7iyu9tumUPDi7SBR5d?=
 =?us-ascii?Q?ct+weBpm1hXT/b5J7UI9UBEYtM60njJquls349N0jlSwp7FByWo5/iD0YpiE?=
 =?us-ascii?Q?hDp9BZMp0tKpXQ27ukZb6PObpqVW2NiQ22PZ/52azQ2zEyVeW+V3psUnNw8Z?=
 =?us-ascii?Q?4aaYRKt/Qp06QeMyxcEN4XPDmO8vSkXX+Hdj9DiyV89R59qXgORp88buhySC?=
 =?us-ascii?Q?L+AqAxGST+lQ2bId6ts1Rf7NDQVKDRcCy5E4SUKRQOWenrnSC+ua7x/40mB6?=
 =?us-ascii?Q?6SChHAnWJ4F1lZ3GvOm/UVD3CXfkTrv7sMvle8pn/PyF/nlY+4zFJdgzjUm4?=
 =?us-ascii?Q?4Pz68O7LnwAhRKI/iDxmYGGeFY+sLIG0y0pSor1oopRbrMSq52VJwtnV+joN?=
 =?us-ascii?Q?oIH/sL9GBtfpmLBb2eWOxZo6hfydUlByL8ac3ytrcweSMGPOK5qZmwzmTOL2?=
 =?us-ascii?Q?XUY5HOw3Gtm4pmR83kDHLX00NSyAMLS1HqIqtPOz7duL6VDiGvhk2Z74WurH?=
 =?us-ascii?Q?wtz8tGn1f95iWGkUWFfcJq6+P9B8mnRSrv3nAZvpiOjKNkHH3y9hxd190UK4?=
 =?us-ascii?Q?qCDOaKxrNyNNg4aMlWv4eKBoo49lImjKiA3zQg+zDh84YUAxMyrJ2SqAjkd6?=
 =?us-ascii?Q?P4VSGMKwHk6gW2Xa7i6y6SzI3w9Vg0d/Er0b0mqJrGaLDdut79BTJkwfnFT0?=
 =?us-ascii?Q?8FyjoGbK6ahdK8AGTXRhaiAhR3EWUn7DBro7ZViLiMxe3GQ3jfpp5UTLzolU?=
 =?us-ascii?Q?PwLaIO0UVrVE9omzrt6Yj1O+IZOlBD3u0owqDL/17ABNvMBkKv7bjfrpAg9p?=
 =?us-ascii?Q?YaqorR8zmUPhWt2j3zlhXYEdpkLuJXBdP8wYJdUADh+IEe6dMSVh1AXgat3n?=
 =?us-ascii?Q?g8ARkYMrNrDhvFFoUldHZhrSP8TUrD8GoF2l6p1etcEN3vNTSiVRupBJqshh?=
 =?us-ascii?Q?fsy1eYundg7kPnWmQWojCihLXfRx5xwx6ZlUfFsWtnip5/VYjhQxKlSfgVHn?=
 =?us-ascii?Q?lf109ixoXPheN3/RjXYuhac+BzHHHH5ZEM0ed3ZmEyF/5joIJVMiLhGxetPB?=
 =?us-ascii?Q?MAAbGHB7kO7E9sRRQOZDrciTEYHQ16XuTzZgutVaq+lkYkCQRtLQbmC8BPaB?=
 =?us-ascii?Q?esIuObPF7I2/PogEqvoKTQql?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02bc59a9-9ed3-4db4-44b7-08d925d062e7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:59.4053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jp0j+92dG90ws8sU/tQ4rCz7uv+dikIfte4bVarrfJeiwfv9psP6stmGQ4nFbRxeGaR/ztFyCtgf6E2NZTI0Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running an SEV-SNP VM, the sPA used to index the RMP entry is
obtained through the TDP translation (gva->gpa->spa). The TDP page
level is checked against the page level programmed in the RMP entry.
If the page level does not match, then it will cause a nested page
fault with the RMP bit set to indicate the RMP violation.

To keep the TDP and RMP page level's in sync, the KVM fault handle
kvm_handle_page_fault() will call get_tdp_max_page_level() to get
the maximum allowed page level so that it can limit the TDP level.

In the case of SEV-SNP guest, the get_tdp_max_page_level() will consult
the RMP table to compute the maximum allowed page level for a given
GPA.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          |  6 ++++--
 arch/x86/kvm/svm/sev.c          | 20 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/vmx/vmx.c          |  8 ++++++++
 6 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 188110ab2c02..cd2e19e1d323 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1384,6 +1384,7 @@ struct kvm_x86_ops {
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+	int (*get_tdp_max_page_level)(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0144c40d09c7..7991ffae7b31 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3781,11 +3781,13 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 				u32 error_code, bool prefault)
 {
+	int max_level = kvm_x86_ops.get_tdp_max_page_level(vcpu, gpa, PG_LEVEL_2M);
+
 	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
-				 PG_LEVEL_2M, false);
+				 max_level, false);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -3826,7 +3828,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 {
 	int max_level;
 
-	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
+	for (max_level = kvm_x86_ops.get_tdp_max_page_level(vcpu, gpa, KVM_MAX_HUGEPAGE_LEVEL);
 	     max_level > PG_LEVEL_4K;
 	     max_level--) {
 		int page_num = KVM_PAGES_PER_HPAGE(max_level);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 856a6cf99a61..6b0c230c5f37 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3184,3 +3184,23 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 
 	return pfn_to_page(pfn);
 }
+
+int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level)
+{
+	struct rmpentry *e;
+	kvm_pfn_t pfn;
+	int level;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return max_level;
+
+	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
+	if (is_error_noslot_pfn(pfn))
+		return max_level;
+
+	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &level);
+	if (unlikely(!e))
+		return max_level;
+
+	return min_t(uint32_t, level, max_level);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a7adf6ca1713..2632eae52aa3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4576,6 +4576,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+	.get_tdp_max_page_level = sev_get_tdp_max_page_level,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bc5582b44356..32abcbd774d0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -568,6 +568,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+int sev_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bceb5ca3a89..fbc9034edf16 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7612,6 +7612,12 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+
+static int vmx_get_tdp_max_page_level(struct kvm_vcpu *vcpu, gpa_t gpa, int max_level)
+{
+	return max_level;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -7742,6 +7748,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.get_tdp_max_page_level = vmx_get_tdp_max_page_level,
 };
 
 static __init void vmx_setup_user_return_msrs(void)
-- 
2.17.1

