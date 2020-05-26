Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540131D222D
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 00:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbgEMWjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 18:39:21 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:6245
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbgEMWjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 18:39:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jh9mi38oWdT4qaNoM7t/TDW819utlCnX/S9DiWm9rX4ke3JC9AJ7jsJ8tvp+KLypdXFEQap+/6LnG+k9drkC3Qqb8xwrzx1iv/YMWwPLOggesiA1vf/UJGvlKoDbkM1qNNc4Gb25Nofy2Pa2p1ixQUpN0kGAJ3bo70iGbgvNyTBWTvKZxrjVbqZd2cxKdAcgB4wMa4LIAHHDlDnCS5uEVC2mUlIivM92eD2oucFM8DqXMgsb9Mlo0hkgK6Rp3GrAY7QkPtnBUpPvIrefKYrhryhLkAfPTl/zn+6fFycIvaARepG0JsKQvsJ6ygvYwT0z2+Pf3JWCj6uuc/AXMUIfAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOKQEhjUABWFW0n7d4Bj/cCmFjo0RfDzIO2VOYgMYJg=;
 b=nzxFJg34BJ6qjMv8YrQqyVusGM+mOi/Oi8XLZxJ+QFGGxqDUHKDWIlyzDdoEk3OFiK8+w6GqShwW6XtiPmFsoAmE9qrGJ1648T1q2XjI41G0v512hGpGoWN3H3tfpngsrfPjM6naa7T0UvNGQX6AdHB3VhbZlAQHYc3PCeEqgj/S3ZZmTdDlZvQyRjlxAA9QkhrkUNZRxMIqveYWMG7oI0URY2k9aBb5el1bUFpwRX/lVzWjjPvoQUkHMJZSILDFvbbOFIRJaWaSxOKZekMnmaFthSg97YftMXy/7pbqFPOzxpbk2yS36zm1O0E2RMioQEPdxSJCSFOF4f6PyDtfoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOKQEhjUABWFW0n7d4Bj/cCmFjo0RfDzIO2VOYgMYJg=;
 b=UGAI+dBGjqv72x7I1RgKJBi8kcnvqcH8qVNMMr/M8GQn8Memf6LFoFcY3lL+4VDO0NZqq8nCk3j9nibHDozNhB61CjIOtAngsd8uhO+5zlk0ppO6emQTV6z7FXLLDeiouZK4Wk1fWBccrE49SNru/n0rcIHcwOcvacPDDz2sknw=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2446.namprd12.prod.outlook.com (2603:10b6:802:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Wed, 13 May
 2020 22:39:15 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.3000.022; Wed, 13 May 2020
 22:39:15 +0000
Subject: [PATCH v5] arch/x86: Update config and kernel doc for MPK feature
 on AMD
From:   Babu Moger <babu.moger@amd.com>
To:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        babu.moger@amd.com, changbin.du@intel.com, namit@vmware.com,
        bigeasy@linutronix.de, yang.shi@linux.alibaba.com,
        asteinhauser@google.com, anshuman.khandual@arm.com,
        jan.kiszka@siemens.com, akpm@linux-foundation.org,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 13 May 2020 17:39:12 -0500
Message-ID: <158940940570.47998.17107695356894054769.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0065.namprd16.prod.outlook.com
 (2603:10b6:805:ca::42) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by SN6PR16CA0065.namprd16.prod.outlook.com (2603:10b6:805:ca::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Wed, 13 May 2020 22:39:13 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2c6196de-9975-44e1-3326-08d7f78e76fa
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:|SN1PR12MB2446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB244660428B3C6562C0B2B51495BF0@SN1PR12MB2446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eqOKuYx8zrboFNiWL/Jq4C0N4bswDZk9pOyqZrue/JtGBLiJjCHzTwnNFeZW+RyqRJCs9aJf0cprJi+bpZEbGgrS9Wz8PGS3Szd/JCc1ZAG56mZT16sr25gmmW6Aj8SHMZGNtiwhdYeh0ikd0iE7ht6ObFQ2p5EwJp1k/K8wuQrQdkKBlOFtkH8KXxtD00XRBWDwDNtfubuEODddJK3ewLcpIwzY9dZ5eZB14i5KHKmhrNoi7lSls164XyvUrWjsFsYU83loqzv7TomZHoRdQzwxJA3ECRG7jC9R6qHwQ5DAIr/uJuE1F6jptF2dG9KbfXKTy+ga+/nAuILFmpDUTAjxvgPQydETL303heoLt44znbY45lGXSj5jJcjgQbsgFHroqlHKiTjsurWnbvPrj6+H0UmTyQv701kOS4MDofP+gzi8iDhMyPQotGamWelcafeJaI444eh9DERxrQo3uwxtdtT2YxpbwCxrAHnESj5QBMK0j/xoT8NVkSDEAPbPBtqh5eV0BeGHapqwwVTur+uUTVQJtksiDjSkmOPAmQz+MGJy48N/671gmozFtogiK7gPFe4rwfgDAd3inMv49ia1lfUR9AmiCuixql3SYYo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(33430700002)(86362001)(956004)(4326008)(66946007)(66476007)(316002)(15650500001)(478600001)(966005)(7406005)(5660300002)(55016002)(44832011)(103116003)(16526019)(2906002)(66556008)(33440700001)(7416002)(52116002)(186003)(26005)(8676002)(8936002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Te2c0w/UONxt+i/vwCA+gx9uoCZ4HHZnUeR8OobVhuTLbGSvU64u/gASYGPdM5iM29bNipVIhsPTL9lg/lxWVvM7RBrIRUvSCi4FP/3dUDDRq4XCVfIeR0upin7XtFayYVKcTjWr6D5B50FaCWLHm5+fBmHdzhZosUTXTs63yYddE3+zMwQaEU3HWPcxmlLH4AhLXI8jiJRJPyfOw2ANidt2Oqgy+MWnYipkM5Sj1Db++ZB4GnHKg8/P9EOL9Uj7wPSrz4Cml9uHmYC3Kx+nd2mpjEz31nY13erYRZTOE7tGi1H1cTUwHii12KurJ4vW214I9AIkyI1w92E3UGQmAQ/NS/oCl8w9w3B/3eRbe+8rKKgPg8o6X9ELK/2mmkWr6I7y36SfN5lYQLecuE1C/2ENmO6fkUB6nIxmAUkQDT0fvbqvkZdDfVeunLlSo/r0bSPRIQv37rxk8hdSl/0MbXF/ycB/VtNaoP1gR2b0QXQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6196de-9975-44e1-3326-08d7f78e76fa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 22:39:15.2488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +jcWV/2sScrmsSCKzStOuzo+vmY/EDf8oMCu1U53TQe1v9gbmXh19eWR1xMxTiXu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD's next generation of EPYC processors support the MPK (Memory
Protection Keys) feature.

Add a generic X86_MEMORY_PROTECTION_KEYS config shadowing
X86_INTEL_MEMORY_PROTECTION_KEYS and update the kernel
documentation.

No functional changes.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v5:
 - Just submiting the first config update patch. Paulo said he already queued
   patch 2 & 3.
 - This patch addresses the few text changes suggested by Dave Hansen.

v4:
https://lore.kernel.org/lkml/158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com/
- Removed all the source changes related to config parameter.
    Just kept the doc cahnges and add new config parameter
    X86_MEMORY_PROTECTION_KEYS which shadows X86_INTEL_MEMORY_PROTECTION_KEYS.
 - Minor change in feature detection in kvm/cpuid.c 

v3:
  https://lore.kernel.org/lkml/158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com/#r
  - Fixed the problem Jim Mattson pointed out which can cause pkru
    resources to get corrupted during host and guest switches. 
  - Moved the PKU feature detection code from VMX.c to common code.
  
v2:
  https://lore.kernel.org/lkml/158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com/
  - Introduced intermediate config option X86_MEMORY_PROTECTION_KEYS to
    avoid user propmpts. Kept X86_INTEL_MEMORY_PROTECTION_KEYS as is.
    Eventually, we will be moving to X86_MEMORY_PROTECTION_KEYS after
    couple of kernel revisions. 
  - Moved pkru data structures to kvm_vcpu_arch. Moved save/restore pkru
    to kvm_load_host_xsave_state/kvm_load_guest_xsave_state.

v1:
  https://lore.kernel.org/lkml/158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com/


 Documentation/core-api/protection-keys.rst |    5 +++--
 arch/x86/Kconfig                           |   11 +++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/core-api/protection-keys.rst b/Documentation/core-api/protection-keys.rst
index 49d9833af871..ec575e72d0b2 100644
--- a/Documentation/core-api/protection-keys.rst
+++ b/Documentation/core-api/protection-keys.rst
@@ -5,8 +5,9 @@ Memory Protection Keys
 ======================
 
 Memory Protection Keys for Userspace (PKU aka PKEYs) is a feature
-which is found on Intel's Skylake "Scalable Processor" Server CPUs.
-It will be avalable in future non-server parts.
+which is found on Intel's Skylake (and later) "Scalable Processor"
+Server CPUs. It will be available in future non-server Intel parts
+and future AMD processors.
 
 For anyone wishing to test or use this feature, it is available in
 Amazon's EC2 C5 instances and is known to work there using an Ubuntu
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1197b5596d5a..6b7303ccc1dd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1887,10 +1887,10 @@ config X86_UMIP
 	  results are dummy.
 
 config X86_INTEL_MEMORY_PROTECTION_KEYS
-	prompt "Intel Memory Protection Keys"
+	prompt "Memory Protection Keys"
 	def_bool y
 	# Note: only available in 64-bit mode
-	depends on CPU_SUP_INTEL && X86_64
+	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
 	---help---
@@ -1902,6 +1902,13 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config X86_MEMORY_PROTECTION_KEYS
+	# Set the "INTEL_"-free option whenever the "INTEL_" one is set.
+	# The "INTEL_" one should be removed and replaced by this option
+	# after 5.10. This avoids exposing most 'oldconfig' users to this
+	# churn.
+	def_bool X86_INTEL_MEMORY_PROTECTION_KEYS
+
 choice
 	prompt "TSX enable mode"
 	depends on CPU_SUP_INTEL

