Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A31347E05
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbhCXQpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:45:03 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:48321
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236553AbhCXQor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwZQWtJiLVnuY7WJEHkBhvzvSCJobITSD/zDOXjFSFvnVOXAjAM51tUCwVJwrplimPsY6sMjMJiPacMDoYmG3e6nIZA+Fu1k5R3qbf6TalyH+ou7VmkzkBX6YJZgeWsVDG/HveWSgmQGl30YmbiimDqyMlchuWu9eM6O0oVko0V1ERFbAitwcOwLljg6vU1uuh66rwi2HBQ9/ZRv+Yhhf0JeVOE0T/LbuNxpyeRaUUBSL7d1DAW6rs0Z81QoicpBDmqZ0/9wXJv/YEputfV3ZeFeovI/89hgRO8ccneTrkR2+guM8+SRIr7DWkQ3ryroI6x6KlZjue9qDCYapYXeIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnP60fE2gy7y2piz8SX2c7qivOiO3fgPtq1TQh2z2tQ=;
 b=g2j69NX6WpCkZtV50J4+A1EGhzqHj1ePjEvZvqLlQFiaWVUu8lUFVT1R0FOLYX8Po91dfBIzBnlsU9Nm5XyjS+lDV5ksB6B1PE8TPXX29N3wm5PSVA5X89puDp/TJ5CcT4Jn85PZ8944evfuWBBPBoybv74uhXuLvJiCtSm1Rwl7q5qqTsFofBUFltz1hQunM624wjVEUadvQDXEmLXume2uFo8+EiMj+yU84eiKinsV4TzgfmntqHVwZBWWhTsNZl92x+/HIIR5+cepKd8CfY+fGOn4Rnx2S8WaHfEYlfmMa+EPwQ9jq/6PxfFgSjnA3dDguaZ03KHy42RCW4JuWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnP60fE2gy7y2piz8SX2c7qivOiO3fgPtq1TQh2z2tQ=;
 b=CMlih/hKluY1TEg5sB9qtNtXC2U8p/+2g7Ug/sXa0+tE+miri7n15nM/wQhAgTljfaFaidhSEg5MJd/dI8WE9N7PPHP+K+4ln7xxlIq0JJaIk+4fyG2XMzLt0cBk6M/2RgUtaod/Q3o7/QSM1CI18u79/ElSJ74/exFoofj8jZ4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 16:44:45 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:45 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part1 PATCH 09/13] x86/kernel: add support to validate memory in early enc attribute change
Date:   Wed, 24 Mar 2021 11:44:20 -0500
Message-Id: <20210324164424.28124-10-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ebc63b1-5c3e-4bf4-7415-08d8eee4210d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44463A752C111B198FCDE584E5639@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6VnGAP/Mv6dgzE3cB6R5VnpN6sOOwuU6uHf43OaA3eyrH/wVEL4+geOkn6iu2LyXV/PfdDvuWirXu0fujsPaxdOFLPI0S8pPoggqWJil3oOYthzvuANFxwH83i/HncXRoZwcNvwkrBnAVSiqKGO5Zd0OMCRYdV/4kpmz5FrtbmXImxXngGan/AtNh/CF9iu0pzJeeUANw5GndTWjK1yCob9n/x2bRiMxGYISRC5HSLnenpkUL42bjsMhlJPoNdqybQiT9SIBGnOM+P/DpRiWj1DJJXtBEV7Xnuxrl44Z/M+FgASvGcoqctI6wVNZ8VYDmZikTsKM5ZjiYTxdsyNS/O7qufw7jNQlaL4+zP/3H07N4TGf4SKFMl9f/X/m+qvqfjj4tdXt0XsWnl/hNzrkHvYN5croGiBF93GpJZksoUdhThwF88B+1bPugkGrhRuu0elth6/5ochqroQjrOaVEJudLtsKNojDDmlyhOQu/4wx2MTzC+JakOigKHeIAlBkOu89q0EicBFPUL7fVgxbVgZOg7cZ1DIFw2AlGDuBm86J3buHaNuKNE4iMbZGuo/IcQjvJkzvm7VOHtcAGMzAgQtlhDM0jtLUqBOa1XMoqiT42uQ+3phdlt9MRzgTvz7xIeieRZ+4WeM9JLhSVa7/yADLF50ilGqeM3dBZmfPTGA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(8676002)(1076003)(4326008)(6666004)(38100700001)(8936002)(956004)(2616005)(5660300002)(186003)(66946007)(86362001)(44832011)(36756003)(15650500001)(7696005)(6486002)(7416002)(478600001)(66476007)(66556008)(52116002)(316002)(83380400001)(16526019)(2906002)(26005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wyvjI4tvQrnfcVoBpix7Rp+U3g+24F/n7cm5myU9Yq65t4zEB1bV1CeU/eh8?=
 =?us-ascii?Q?TWBYVIaisaQxiBswmfKwCimRYqNJFBmTm8x/P0HIIl0ZqBY3OHgrHgppsJhR?=
 =?us-ascii?Q?m1yjBSw7mhGpYEYzyctpzkvsgfTAGz8TN7mW1CSbHIapQO1uHKm7QPmAOOyI?=
 =?us-ascii?Q?+pWcJD3akcPqPIyxWfDn7ZEXmvYj5CmriMWo9A9eCjKaKBGAMWGcJM9zW14z?=
 =?us-ascii?Q?iPl7gvNT3Pn4mc5pgpN6B0sbHHeNUyxHBPyfsnrRWONiKAP0epu0q056kHQQ?=
 =?us-ascii?Q?E4J+UbXVLUjG/SRRwIVse8KZ5eEy+LJPSA0+5QTh+JQiT0Qkuv/HjnYnVfPE?=
 =?us-ascii?Q?5moZbL+mypMbCUz1TWY+5gZiSSGylCP4tWvG3hJ4Ima/+LGCZ02h3mQkMAIE?=
 =?us-ascii?Q?JrXgLdwKxO9u1ESnRXJ2DnkQwNjG7n9HFHT2wCNVaEOT5+QId8xB5R00EiUE?=
 =?us-ascii?Q?HYIlLor4ABEkYacAyg/VhyT+/yap3l+WM4qZepzipQyZSDxDhDvSfe92EJNZ?=
 =?us-ascii?Q?AvXBL+/kReJ4zWuNRdPfkdD8pevvvPw72+RwRr3PR9yY2zdMSiSME9bAuHrQ?=
 =?us-ascii?Q?6PDqgfbRx0oTKh/Ng2GlTVkGDSLHClTFaCmrnl0yGJIJjhqygKaKZyeW7vVl?=
 =?us-ascii?Q?+YSqXNTZ4D1S8R0Y/5FE0QIfyjmQrPv6jYHCNxYyP7mnovkIQnEekJGSBNNC?=
 =?us-ascii?Q?84PmEkxLIJSX+IUPevBV1oMyFgDVjEbni3k7May5Cmn+6GvsmAZxGrcxfaML?=
 =?us-ascii?Q?BWgIOVbg25hRH+b8R1dKtZ5XPjPDPKOynwnU2kMAnVDEzbVUERruXk9jGlqQ?=
 =?us-ascii?Q?L+qMlVUkEpvGBb6C3PjaUrVzRyOgUCAku1sNslpk81TK5ZinjEdRxbtWb0tA?=
 =?us-ascii?Q?QZrgpgCBrZLJrnmPtc3OLatQ7eJhe2cfiohPRWloL2YV8BK7+m7JtWwLan1S?=
 =?us-ascii?Q?zUo5mL5w2W2MJE/4bPDMyoUMIFcOfPCYLLifEMfmbOZ2ynjagPYy2Fkfm0cX?=
 =?us-ascii?Q?IjHlTDt0ukKk3WYyM6oUhFTqT3bDLWrpTfXX28rCgV1p1ERXV89fPwW3wJ7e?=
 =?us-ascii?Q?VyLjKrK0WBkwUZSKuc47j3dSIVbqhzAx2iVlIHo1IhuXbUavWTerGCHD/ipi?=
 =?us-ascii?Q?xJQh3QaFSiqPD7K0gei2KasVroZDTXqg22nWK35IWeCSAcwSXTCTN4wVqj9t?=
 =?us-ascii?Q?4vIudSfTeZtmkcwVlWLm4LJ5GxpswjGL8DyJmahl/2XFjdPtmVMX56oWAoPy?=
 =?us-ascii?Q?y06hg0XYzB09OeT5LpSCqMY5HilMwCDKw1Qovlat2WAXGtseRNKrdX9wfU0U?=
 =?us-ascii?Q?KxBmFCz7X9+OBydeYRAClGMb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ebc63b1-5c3e-4bf4-7415-08d8eee4210d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:44.8898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tjxc9px0Ll1kBGB2oXXc1kBKbTfUD6Pv4POE8b/hiyzwZ654bg7j5eGPq2LDpbmitNq8Dsti/OScJxjfz081gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The early_set_memory_{encrypt,decrypt}() are used for changing the
page from decrypted (shared) to encrypted (private) and vice versa.
When SEV-SNP is active, the page state transition needs to go through
additional steps.

If the page is transitioned from shared to private, then perform the
following after the encryption attribute is set in the page table:

1. Issue the page state change VMGEXIT to add the page as a private
   in the RMP table.
2. Validate the page after its successfully added in the RMP table.

To maintain the security guarantees, if the page is transitioned from
private to shared, then perform the following before clearing the
encryption attribute from the page table.

1. Invalidate the page.
2. Issue the page state change VMGEXIT to make the page shared in the
   RMP table.

The early_set_memory_{encryot,decrypt} can be called before the full GHCB
is setup, use the SNP page state MSR protocol VMGEXIT defined in the GHCB
section 2.3.1 to request the page state change in the RMP table.

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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-snp.h |  20 +++++++
 arch/x86/kernel/sev-snp.c      | 105 +++++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c      |  40 ++++++++++++-
 3 files changed, 163 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sev-snp.h b/arch/x86/include/asm/sev-snp.h
index 0523eb21abd7..c4b096206062 100644
--- a/arch/x86/include/asm/sev-snp.h
+++ b/arch/x86/include/asm/sev-snp.h
@@ -63,6 +63,10 @@ struct __packed snp_page_state_change {
 #define GHCB_REGISTER_GPA_RESP	0x013UL
 #define		GHCB_REGISTER_GPA_RESP_VAL(val)		((val) >> 12)
 
+/* Macro to convert the x86 page level to the RMP level and vice versa */
+#define X86_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
+#define RMP_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
 			      unsigned long *rflags)
@@ -82,6 +86,11 @@ static inline int __pvalidate(unsigned long vaddr, int rmp_psize, int validate,
 
 void sev_snp_register_ghcb(unsigned long paddr);
 
+void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
+		unsigned int npages);
+void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
+		unsigned int npages);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 static inline int __pvalidate(unsigned long vaddr, int psize, int validate, unsigned long *eflags)
@@ -91,6 +100,17 @@ static inline int __pvalidate(unsigned long vaddr, int psize, int validate, unsi
 
 static inline void sev_snp_register_ghcb(unsigned long paddr) { }
 
+static inline void __init
+early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr, unsigned int npages)
+{
+	return 0;
+}
+static inline void __init
+early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr, unsigned int npages)
+{
+	return 0;
+}
+
 #endif /* CONFIG_AMD_MEM_ENCRYPT */
 
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/sev-snp.c b/arch/x86/kernel/sev-snp.c
index d32225c2b653..ff9b35bfb05c 100644
--- a/arch/x86/kernel/sev-snp.c
+++ b/arch/x86/kernel/sev-snp.c
@@ -56,3 +56,108 @@ void sev_snp_register_ghcb(unsigned long paddr)
 	/* Restore the GHCB MSR value */
 	sev_es_wr_ghcb_msr(old);
 }
+
+static void sev_snp_issue_pvalidate(unsigned long vaddr, unsigned int npages, bool validate)
+{
+	unsigned long eflags, vaddr_end, vaddr_next;
+	int rc;
+
+	vaddr = vaddr & PAGE_MASK;
+	vaddr_end = vaddr + (npages << PAGE_SHIFT);
+
+	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
+		rc = __pvalidate(vaddr, RMP_PG_SIZE_4K, validate, &eflags);
+
+		if (rc) {
+			pr_err("Failed to validate address 0x%lx ret %d\n", vaddr, rc);
+			goto e_fail;
+		}
+
+		/* Check for the double validation condition */
+		if (eflags & X86_EFLAGS_CF) {
+			pr_err("Double %salidation detected (address 0x%lx)\n",
+					validate ? "v" : "inv", vaddr);
+			goto e_fail;
+		}
+
+		vaddr_next = vaddr + PAGE_SIZE;
+	}
+
+	return;
+
+e_fail:
+	/* Dump stack for the debugging purpose */
+	dump_stack();
+
+	/* Ask to terminate the guest */
+	sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+}
+
+static void __init early_snp_set_page_state(unsigned long paddr, unsigned int npages, int op)
+{
+	unsigned long paddr_end, paddr_next;
+	u64 old, val;
+
+	paddr = paddr & PAGE_MASK;
+	paddr_end = paddr + (npages << PAGE_SHIFT);
+
+	/* save the old GHCB MSR */
+	old = sev_es_rd_ghcb_msr();
+
+	for (; paddr < paddr_end; paddr = paddr_next) {
+
+		/*
+		 * Use the MSR protocol VMGEXIT to request the page state change. We use the MSR
+		 * protocol VMGEXIT because in early boot we may not have the full GHCB setup
+		 * yet.
+		 */
+		sev_es_wr_ghcb_msr(GHCB_SNP_PAGE_STATE_REQ_GFN(paddr >> PAGE_SHIFT, op));
+		VMGEXIT();
+
+		val = sev_es_rd_ghcb_msr();
+
+		/* Read the response, if the page state change failed then terminate the guest. */
+		if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SNP_PAGE_STATE_CHANGE_RESP)
+			sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+
+		if (GHCB_SNP_PAGE_STATE_RESP_VAL(val) != 0) {
+			pr_err("Failed to change page state to '%s' paddr 0x%lx error 0x%llx\n",
+					op == SNP_PAGE_STATE_PRIVATE ? "private" : "shared",
+					paddr, GHCB_SNP_PAGE_STATE_RESP_VAL(val));
+
+			/* Dump stack for the debugging purpose */
+			dump_stack();
+
+			/* Ask to terminate the guest */
+			sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
+		}
+
+		paddr_next = paddr + PAGE_SIZE;
+	}
+
+	/* Restore the GHCB MSR value */
+	sev_es_wr_ghcb_msr(old);
+}
+
+void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
+					 unsigned int npages)
+{
+	 /* Ask hypervisor to add the memory in RMP table as a 'private'. */
+	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_PRIVATE);
+
+	/* Validate the memory region after its added in the RMP table. */
+	sev_snp_issue_pvalidate(vaddr, npages, true);
+}
+
+void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
+					unsigned int npages)
+{
+	/*
+	 * We are chaning the memory from private to shared, invalidate the memory region
+	 * before making it shared in the RMP table.
+	 */
+	sev_snp_issue_pvalidate(vaddr, npages, false);
+
+	 /* Ask hypervisor to make the memory shared in the RMP table. */
+	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_SHARED);
+}
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 5bd50008fc9a..35af2f21b8f1 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -29,6 +29,7 @@
 #include <asm/processor-flags.h>
 #include <asm/msr.h>
 #include <asm/cmdline.h>
+#include <asm/sev-snp.h>
 
 #include "mm_internal.h"
 
@@ -49,6 +50,27 @@ bool sev_enabled __section(".data");
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
+/*
+ * When SNP is active, this routine changes the page state from private to shared before
+ * copying the data from the source to destination and restore after the copy. This is required
+ * because the source address is mapped as decrypted by the caller of the routine.
+ */
+static inline void __init snp_aware_memcpy(void *dst, void *src, size_t sz,
+					   unsigned long paddr, bool dec)
+{
+	unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
+
+	/* If the paddr need to accessed decrypted, make the page shared before memcpy. */
+	if (sev_snp_active() && dec)
+		early_snp_set_memory_shared((unsigned long)__va(paddr), paddr, npages);
+
+	memcpy(dst, src, sz);
+
+	/* Restore the page state after the memcpy. */
+	if (sev_snp_active() && dec)
+		early_snp_set_memory_private((unsigned long)__va(paddr), paddr, npages);
+}
+
 /*
  * This routine does not change the underlying encryption setting of the
  * page(s) that map this memory. It assumes that eventually the memory is
@@ -97,8 +119,8 @@ static void __init __sme_early_enc_dec(resource_size_t paddr,
 		 * Use a temporary buffer, of cache-line multiple size, to
 		 * avoid data corruption as documented in the APM.
 		 */
-		memcpy(sme_early_buffer, src, len);
-		memcpy(dst, sme_early_buffer, len);
+		snp_aware_memcpy(sme_early_buffer, src, len, paddr, enc);
+		snp_aware_memcpy(dst, sme_early_buffer, len, paddr, !enc);
 
 		early_memunmap(dst, len);
 		early_memunmap(src, len);
@@ -278,9 +300,23 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
 	else
 		sme_early_decrypt(pa, size);
 
+	/*
+	 * If SEV-SNP is active, rescind validation of the page in the RMP entry before encryption
+	 * attribute is changed from C=1 to C=0.
+	 */
+	if (sev_snp_active() && !enc)
+		early_snp_set_memory_shared((unsigned long)__va(pa), pa, 1);
+
 	/* Change the page encryption mask. */
 	new_pte = pfn_pte(pfn, new_prot);
 	set_pte_atomic(kpte, new_pte);
+
+	/*
+	 * If SEV-SNP is active, validate the page in the RMP entry after encryption attribute is
+	 * changed from C=0 to C=1.
+	 */
+	if (sev_snp_active() && enc)
+		early_snp_set_memory_private((unsigned long)__va(pa), pa, 1);
 }
 
 static int __init early_set_memory_enc_dec(unsigned long vaddr,
-- 
2.17.1

