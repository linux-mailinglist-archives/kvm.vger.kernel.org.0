Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1C536C4EF
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 13:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhD0LSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 07:18:36 -0400
Received: from mail-eopbgr750082.outbound.protection.outlook.com ([40.107.75.82]:21193
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235696AbhD0LSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 07:18:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IP0ze23WMalcywNpDM/4hm09gEzTkGveMRN87KTi/beWW3s2fRuaYCn8lZ81fTzExru2b7zqkAY2AxwZvtIKt+KapD6x3dTfUXdLIoDVK+AXh0UmtnBygPcIyXkMHBr3S5aryo4vQXPcl4OIeh8bnzhD+dR2m7z8nqB9X8a16NMPX7TGKiOf2ump0J39iviUA3//gY+q9Wto17yWF/z7eF+OREaH4GrAt4gxatUN854MhFrcyWNZ/GqmQhSKI7/6xVGt9vifw+3y0sBCnyeGH1zmI0G0GsIkE6f0h2pmJ6wEMyqIhEkw63RJNHcoSlAy2XHazTe7pggsDLxOO8ecXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCl31Rqoor+M3PDzB0Y7Ve184sxj8wbd7YObd03wgWQ=;
 b=WOxUUibjJ8iuGWUlsRIzx85tgPnZZjlKQSkzefYRkJaL+oBJLql4P8SW4LRC6jDrycQBOJNN7bTNfX8MADVe46+xWbPvwgehlj/fXmPVTZnIIADHj2HaVy/TDf63HKA6rhz0H0vWLZ3dQxw9WZDCZ6zhwm1w0P+efXgYv07wbowjL/QwEmhQkYqoKcl3N9tN3+KKMfWguC6fRWUxdANL68ngoch5Bgl8rcPCzMFKlDJWnoLX+pz5OInMDqgPgJAm2EGTprti21Vj17t3HRFoQJZtl9XpEc5fiBZEsWMk/u7/8JmbAJ0bNS8Eytc/rPuc4fGCnFI1+Q1D/oKt2QjPDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCl31Rqoor+M3PDzB0Y7Ve184sxj8wbd7YObd03wgWQ=;
 b=Vc36aOlEfXqeXhm2OSK89qjdyFSG8EBSDP1k7ebOe/ZffuOpeJ5MNTRA8jume5YJhqmOiCWqOoXyzP7Wu7wjSzENgc1G7vJhb5VYvlZnU+3ur3M3NTUHic+U39AOhJC4TmPoj5WtLg60C5EGHTs8gqWmWEaEYj5vLxzuD4WmEaU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Tue, 27 Apr
 2021 11:16:51 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 11:16:51 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 3/3] x86/msr: Rename MSR_K8_SYSCFG to MSR_AMD64_SYSCFG
Date:   Tue, 27 Apr 2021 06:16:36 -0500
Message-Id: <20210427111636.1207-4-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210427111636.1207-1-brijesh.singh@amd.com>
References: <20210427111636.1207-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0054.namprd02.prod.outlook.com
 (2603:10b6:803:20::16) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0201CA0054.namprd02.prod.outlook.com (2603:10b6:803:20::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Tue, 27 Apr 2021 11:16:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 699fd2b7-7110-485d-c7f4-08d9096df488
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4432CED519CAC63694FC6FB0E5419@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k0aXD9GDIUJfR0+I3rNfQzls6aNCtFyy6zWUMpXtzOU++rghfwEeUZel+KNvM+VQZi4zlVtW0mOUUSVNm6Cv1rsY1HZ79aFq4GG9WQzgt0H2P2CuFEhx4Fm+CIhh6fCpy7WGVQKX38PAG2SaDDiZCAeR3NMXBVvkBgHj2EqqDeh47UQHr7EUmNUu3mpFN61d2xZ7ttz7pESAcuOEfkzNe4Xl45XIp3Sr9Q4KY8NQlSLVG8dFZitWjRyu468HCAWP2uE6iRv1YSzfsAC271nkU+duK4/KQ48GAUdeo244Yc61NZORRwauH6TdVAZDRfKq412PWpQ6EwSR6vUfUHyeKIjlohRBL6dLibPaqlpSsqpwjUy4qBMMDNeFCLZ42WVvA9c5Wa0MjLm0JPXAeKOSEVPp6WUwO8bXlQcEsXK0qJXHBx5MsXGQtS6OPPpopoj5YFQfaWDBqL02AOmJllHX3YnfhimeuY8VipzsYntVvkPAkwjcLMSnLMJQ2cGC9nF49Vhi8koBEnOnaFuxYBVqmuJSxSbRWaC0QX6/tkaTKa3yaleeGS4WMnIvcP1NVtaN8ogXRvAbyI6espPtCfkyl4OlTZq8eiYKiPGru3f4U4gjwY+OdQHjgFt0WnMWRWyImdNa0IRQSRQ5LQPIJS/Eqj4FRd169Ij5sGSqijMHAnU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(66556008)(66476007)(5660300002)(2616005)(956004)(30864003)(478600001)(316002)(6916009)(66946007)(6666004)(44832011)(52116002)(86362001)(7696005)(1076003)(36756003)(8676002)(26005)(8936002)(16526019)(4326008)(2906002)(6486002)(83380400001)(186003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/Cyh5nDpT7Ga4JjAkL9t9oySMYD+ckkbfffj5rsmfpBt0dX4jEsvdpmqyJuE?=
 =?us-ascii?Q?s85x91abC5L2u3VUecun1K5QdR7Vs2wRI4sm1AdILaSJGYdUe7UcofZn1Sj4?=
 =?us-ascii?Q?CADpUy9+PXOEhUMFSPv+MUDAb6DIJG0hGkV9JBVWBomMnp7Hg5RBNhv0Uaxj?=
 =?us-ascii?Q?dj0PsbxRXBamE52TWhQRw4Cg4Pn0jfSl19HRSJt0vPdJNj8BVfeYvQJSglbp?=
 =?us-ascii?Q?o+h5UQgASij0NEc927t/mGLiwsXmGeLY4y2eiKKB365nOVXmLQjiJVgkZe9c?=
 =?us-ascii?Q?DrzxhO3ZsAeR5fKtNu4B3H+K/zAw1FQyixqJWTTKY59omgVusVjMD9slYev3?=
 =?us-ascii?Q?spMRjP0oHTxs22OKteZpYAR5d0CS/1yveK5Xt938VvVs9rAKkb5r6oB7+Y/y?=
 =?us-ascii?Q?Ui2cfhPvTdD8OMzSuu1GkBMw0/vFO2rMr0gQBOmh1Z+9NtAEU6b0Da/Gp4sz?=
 =?us-ascii?Q?F4xBcTPsB1I+g/NX6kHth5UwV6G6EZlQCb3x7xZKAoGPD6vYcwONOQP4mW9x?=
 =?us-ascii?Q?VpqD7r1+nr/Yrz835DFvaOicSBatxY2hD2hWsrxyiY0MdKWzbUa6Jhi30RpI?=
 =?us-ascii?Q?749oF5sAA64jOgw8FYl+bd53axWwOvIq/cyQs8TyVT7H5xAuGKGwMfbWHX/C?=
 =?us-ascii?Q?mWb8sEcnRVUQY/sRsTe8N9BHkJXFglxCPKxYDdayr8OvT83RfvKdKdloZvBO?=
 =?us-ascii?Q?6FQgmXUvqGb7ZmNeA+HCPMqtILNPV4spLSR4uS2rVMCGN3kkqw3PBbxqoChG?=
 =?us-ascii?Q?j6g+fbeYMpTmi51g6lEQD+3JH2v1SLJCKCTzM1C0nV7y7Io59LyG/ysulE0Y?=
 =?us-ascii?Q?yy/hV7tTZaTJ9KZXeO7tGuAXYcKez4hv+lMd91xA8fKjd/77mMllN3JNSW40?=
 =?us-ascii?Q?sEylaEyhMzhSgpOnHecCUBjk7iaTHs6yqfk0Ifg0PrK6Dp28/E+DPlCbbGFv?=
 =?us-ascii?Q?XzIrYpDbumzPb7KuxgwLsnVV7ZxD+SDFBOK9kXnDGrDRiUre5aAomiYNcHxO?=
 =?us-ascii?Q?+ML+o91TnFIFgnI53erPt2M1nhH90RC6yK5/CrPsmt9031nRj5pAIVeodAZ2?=
 =?us-ascii?Q?WDt27EI5Mrs0kxSlZE1i7SFwdecs6LXqdGhQHz7ig8PoO81+lPPD7C4S71QI?=
 =?us-ascii?Q?BKjt9vTvfmx4dqN26kp4egg8ay17Bl/9WUeN8toCKb6kSc6MPWvBrBr0Ad//?=
 =?us-ascii?Q?F1f0iQEylU53Mx3DzGmHGcBS3TFdoWTlTtYW1h0ruM64JOkfnzryefQPS1NF?=
 =?us-ascii?Q?eXr/mUXXCXPHCZ7O5GbLdH137wmUPKu2AHdhRGj2I/yq7D9T3yZpIbZsml34?=
 =?us-ascii?Q?Vf7kcnnPdNRDrVlpOnBxdvU5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 699fd2b7-7110-485d-c7f4-08d9096df488
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 11:16:51.0514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OVkPSbT1DkpTHLMFw4Qz+1bVsVlOx+0N24ZmyYvMGNpCKRMm5FVvOcF0evHyAHaGRYSKuS6WOqc+9Fie56/vDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SYSCFG MSR continued being updated beyond the K8 family; drop the K8
name from it.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/virt/kvm/amd-memory-encryption.rst | 2 +-
 Documentation/x86/amd-memory-encryption.rst      | 6 +++---
 arch/x86/include/asm/msr-index.h                 | 6 +++---
 arch/x86/kernel/cpu/amd.c                        | 4 ++--
 arch/x86/kernel/cpu/mtrr/cleanup.c               | 2 +-
 arch/x86/kernel/cpu/mtrr/generic.c               | 4 ++--
 arch/x86/kernel/mmconf-fam10h_64.c               | 2 +-
 arch/x86/kvm/svm/svm.c                           | 4 ++--
 arch/x86/kvm/x86.c                               | 2 +-
 arch/x86/mm/mem_encrypt_identity.c               | 6 +++---
 arch/x86/pci/amd_bus.c                           | 2 +-
 arch/x86/realmode/rm/trampoline_64.S             | 4 ++--
 drivers/edac/amd64_edac.c                        | 2 +-
 tools/arch/x86/include/asm/msr-index.h           | 6 +++---
 14 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 469a6308765b..9db260f015ae 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -22,7 +22,7 @@ to SEV::
 		  [ecx]:
 			Bits[31:0]  Number of encrypted guests supported simultaneously
 
-If support for SEV is present, MSR 0xc001_0010 (MSR_K8_SYSCFG) and MSR 0xc001_0015
+If support for SEV is present, MSR 0xc001_0010 (MSR_AMD64_SYSCFG) and MSR 0xc001_0015
 (MSR_K7_HWCR) can be used to determine if it can be enabled::
 
 	0xc001_0010:
diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
index c48d452d0718..a1940ebe7be5 100644
--- a/Documentation/x86/amd-memory-encryption.rst
+++ b/Documentation/x86/amd-memory-encryption.rst
@@ -53,7 +53,7 @@ CPUID function 0x8000001f reports information related to SME::
 			   system physical addresses, not guest physical
 			   addresses)
 
-If support for SME is present, MSR 0xc00100010 (MSR_K8_SYSCFG) can be used to
+If support for SME is present, MSR 0xc00100010 (MSR_AMD64_SYSCFG) can be used to
 determine if SME is enabled and/or to enable memory encryption::
 
 	0xc0010010:
@@ -79,7 +79,7 @@ The state of SME in the Linux kernel can be documented as follows:
 	  The CPU supports SME (determined through CPUID instruction).
 
 	- Enabled:
-	  Supported and bit 23 of MSR_K8_SYSCFG is set.
+	  Supported and bit 23 of MSR_AMD64_SYSCFG is set.
 
 	- Active:
 	  Supported, Enabled and the Linux kernel is actively applying
@@ -89,7 +89,7 @@ The state of SME in the Linux kernel can be documented as follows:
 SME can also be enabled and activated in the BIOS. If SME is enabled and
 activated in the BIOS, then all memory accesses will be encrypted and it will
 not be necessary to activate the Linux memory encryption support.  If the BIOS
-merely enables SME (sets bit 23 of the MSR_K8_SYSCFG), then Linux can activate
+merely enables SME (sets bit 23 of the MSR_AMD64_SYSCFG), then Linux can activate
 memory encryption by default (CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y) or
 by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
 not enable SME, then Linux will not be able to activate memory encryption, even
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 742d89a00721..211ba3375ee9 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -537,9 +537,9 @@
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K8_TOP_MEM2			0xc001001d
-#define MSR_K8_SYSCFG			0xc0010010
-#define MSR_K8_SYSCFG_MEM_ENCRYPT_BIT	23
-#define MSR_K8_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_K8_SYSCFG_MEM_ENCRYPT_BIT)
+#define MSR_AMD64_SYSCFG		0xc0010010
+#define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
+#define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */
 #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2d11384dc9ab..0adb0341cd7c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -593,8 +593,8 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 */
 	if (cpu_has(c, X86_FEATURE_SME) || cpu_has(c, X86_FEATURE_SEV)) {
 		/* Check if memory encryption is enabled */
-		rdmsrl(MSR_K8_SYSCFG, msr);
-		if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
+		rdmsrl(MSR_AMD64_SYSCFG, msr);
+		if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
 			goto clear_all;
 
 		/*
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 0c3b372318b7..b5f43049fa5f 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -836,7 +836,7 @@ int __init amd_special_default_mtrr(void)
 	if (boot_cpu_data.x86 < 0xf)
 		return 0;
 	/* In case some hypervisor doesn't pass SYSCFG through: */
-	if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
+	if (rdmsr_safe(MSR_AMD64_SYSCFG, &l, &h) < 0)
 		return 0;
 	/*
 	 * Memory between 4GB and top of mem is forced WB by this magic bit.
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index b90f3f437765..558108296f3c 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -53,13 +53,13 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 	      (boot_cpu_data.x86 >= 0x0f)))
 		return;
 
-	rdmsr(MSR_K8_SYSCFG, lo, hi);
+	rdmsr(MSR_AMD64_SYSCFG, lo, hi);
 	if (lo & K8_MTRRFIXRANGE_DRAM_MODIFY) {
 		pr_err(FW_WARN "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
 		       " not cleared by BIOS, clearing this bit\n",
 		       smp_processor_id());
 		lo &= ~K8_MTRRFIXRANGE_DRAM_MODIFY;
-		mtrr_wrmsr(MSR_K8_SYSCFG, lo, hi);
+		mtrr_wrmsr(MSR_AMD64_SYSCFG, lo, hi);
 	}
 }
 
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index b5cb49e57df8..c94dec6a1834 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -95,7 +95,7 @@ static void get_fam10h_pci_mmconf_base(void)
 		return;
 
 	/* SYS_CFG */
-	address = MSR_K8_SYSCFG;
+	address = MSR_AMD64_SYSCFG;
 	rdmsrl(address, val);
 
 	/* TOP_MEM2 is not enabled? */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6dad89248312..0503f8c3b09a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -859,8 +859,8 @@ static __init void svm_adjust_mmio_mask(void)
 		return;
 
 	/* If memory encryption is not enabled, use existing mask */
-	rdmsrl(MSR_K8_SYSCFG, msr);
-	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
+	rdmsrl(MSR_AMD64_SYSCFG, msr);
+	if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
 		return;
 
 	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index efc7a82ab140..cdf37a0b247d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3357,7 +3357,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_LASTBRANCHTOIP:
 	case MSR_IA32_LASTINTFROMIP:
 	case MSR_IA32_LASTINTTOIP:
-	case MSR_K8_SYSCFG:
+	case MSR_AMD64_SYSCFG:
 	case MSR_K8_TSEG_ADDR:
 	case MSR_K8_TSEG_MASK:
 	case MSR_VM_HSAVE_PA:
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index a19374d26101..1fef10825645 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -529,7 +529,7 @@ void __init sme_enable(struct boot_params *bp)
 		/*
 		 * No SME if Hypervisor bit is set. This check is here to
 		 * prevent a guest from trying to enable SME. For running as a
-		 * KVM guest the MSR_K8_SYSCFG will be sufficient, but there
+		 * KVM guest the MSR_AMD64_SYSCFG will be sufficient, but there
 		 * might be other hypervisors which emulate that MSR as non-zero
 		 * or even pass it through to the guest.
 		 * A malicious hypervisor can still trick a guest into this
@@ -542,8 +542,8 @@ void __init sme_enable(struct boot_params *bp)
 			return;
 
 		/* For SME, check the SYSCFG MSR */
-		msr = __rdmsr(MSR_K8_SYSCFG);
-		if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
+		msr = __rdmsr(MSR_AMD64_SYSCFG);
+		if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
 			return;
 	} else {
 		/* SEV state cannot be controlled by a command line option */
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index bfa50e65ef6c..4875084da4c0 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -284,7 +284,7 @@ static int __init early_root_info_init(void)
 
 	/* need to take out [4G, TOM2) for RAM*/
 	/* SYS_CFG */
-	address = MSR_K8_SYSCFG;
+	address = MSR_AMD64_SYSCFG;
 	rdmsrl(address, val);
 	/* TOP_MEM2 is enabled? */
 	if (val & (1<<21)) {
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 84c5d1b33d10..cc8391f86cdb 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -123,9 +123,9 @@ SYM_CODE_START(startup_32)
 	 */
 	btl	$TH_FLAGS_SME_ACTIVE_BIT, pa_tr_flags
 	jnc	.Ldone
-	movl	$MSR_K8_SYSCFG, %ecx
+	movl	$MSR_AMD64_SYSCFG, %ecx
 	rdmsr
-	bts	$MSR_K8_SYSCFG_MEM_ENCRYPT_BIT, %eax
+	bts	$MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT, %eax
 	jc	.Ldone
 
 	/*
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9fa4dfc6ebee..f0d8f60acee1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3083,7 +3083,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	edac_dbg(0, "  TOP_MEM:  0x%016llx\n", pvt->top_mem);
 
 	/* Check first whether TOP_MEM2 is enabled: */
-	rdmsrl(MSR_K8_SYSCFG, msr_val);
+	rdmsrl(MSR_AMD64_SYSCFG, msr_val);
 	if (msr_val & BIT(21)) {
 		rdmsrl(MSR_K8_TOP_MEM2, pvt->top_mem2);
 		edac_dbg(0, "  TOP_MEM2: 0x%016llx\n", pvt->top_mem2);
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index 45029354e0a8..c60b09e7602f 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -533,9 +533,9 @@
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K8_TOP_MEM2			0xc001001d
-#define MSR_K8_SYSCFG			0xc0010010
-#define MSR_K8_SYSCFG_MEM_ENCRYPT_BIT	23
-#define MSR_K8_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_K8_SYSCFG_MEM_ENCRYPT_BIT)
+#define MSR_AMD64_SYSCFG		0xc0010010
+#define MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT	23
+#define MSR_AMD64_SYSCFG_MEM_ENCRYPT	BIT_ULL(MSR_AMD64_SYSCFG_MEM_ENCRYPT_BIT)
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */
 #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
-- 
2.17.1

