Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29381E671A
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 18:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404843AbgE1QIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 May 2020 12:08:34 -0400
Received: from mail-bn8nam11on2075.outbound.protection.outlook.com ([40.107.236.75]:18040
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404666AbgE1QIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 May 2020 12:08:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZZHpA3+iXfVbi37N8Y62HGjbt9VMwBSloMK228o8mS8s1peFH93VzYJ5ayaAtdLII1ORnJS3ZAD1FAbM64uHgS2FYlpkKOv+gq1Nxf7Py+LHRCV3Ral/lSsyqdYQUGwsAT0oOoNOM6TIhqYt4SrYJThgHYwYGE9hyEtkWgPSlTEL3DthSTJvBIIyWqJuCXIRBu/Bk880jRKlCqQJV4Inpcudw/V7H8JjqHmLo8uiwRg2zyBZFpuotH+bUBlVXoDJfnzV4+ORr1g/mcd6YYNgKWkhyEoKwUc11h84H8wjNKaRM4tfm9/UoZVGtov5cbjIFvE8oNYQCsRLjYhc0v64A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CU/GTBcHcycOvPgCFYA1JDgb9C2f8ST1Y0nRkW9FPRA=;
 b=UWskvldeJby6BOMhFEdYjggPoMoIkEktJAP7+VwknkKQVbjAh/8ndfW9md7mXYVJtIhXlAwgEdlFy/0DrjPrZPiT2XI3ZQZOnVIw6i7x0o7j1d7jA90oh1bIamVSd9S8COhrLaAGddxbmLssdQvKhJx7UCKt1rfhVw9zCYju+2qlfycKkMhXEjtt5WO+3Mu1VvWb5l/jV8b8fFPFieEXlvJpPTdYeFTEUUslspeCOP4rRU4p/gE9F49mQXmaZWuK6sIzpxSKOhs3y3oUg4tKG8dVyO/1Kno5swMG5D3ywBWnR258u8M0q1LbavVjhbb8YxIM3oJmRUoPX2D7LDa+CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CU/GTBcHcycOvPgCFYA1JDgb9C2f8ST1Y0nRkW9FPRA=;
 b=dSehkjzMbWjWBHNDE7Jsppnhzs9KtcmC8MrgFGhQdoaIANwYdkXp6NLpe6+BvPDh7w8WgUwm9fyJnLFzQXQ029d7ELXLevB5MlKdZmtLpxPa/oEAHPUZRBAW/aX7YRROyusAyMryJuVw8i9XSioRxhmtAJ1TublQUXH1O7X9lew=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2527.namprd12.prod.outlook.com (2603:10b6:802:23::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 16:08:25 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 16:08:25 +0000
Subject: [PATCH v6] arch/x86: Update config and kernel doc for MPK feature
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
Date:   Thu, 28 May 2020 11:08:23 -0500
Message-ID: <159068199556.26992.17733929401377275140.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0071.prod.exchangelabs.com (2603:10b6:800::39) To
 SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by SN2PR01CA0071.prod.exchangelabs.com (2603:10b6:800::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Thu, 28 May 2020 16:08:23 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f31b1e7a-6ace-41ca-19ca-08d803215a23
X-MS-TrafficTypeDiagnostic: SN1PR12MB2527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB252781CA1FB5AD36027350CB958E0@SN1PR12MB2527.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sZkPz0IDkSFWo7Q3RJXpkeeiLJaq7T5KlqxdMNHL/PGc+AEhZmQTtMb7Sbb0Vre0uNKw7JFv2SPjlmll9rn3n/Os3c0AFMiLxhbT+RA80YsVoauvoOVrCBGe+wyK+D1YvJBRbZT46iHyEx1rMSjx9V4dyKDk5RwTQBLbUPwBLlyHiP8e7x+7as0tH+7+Ks4R6n6/pYsE0U35ilH4k2VByiasYpfSPe/xIo6NHEax22e8lb7wJ/VnXmCoEm55mJvDW0TPjw6oYljppX+dx04lsr+q7NX9NQ7QiB34KbyUOL64kNoVxJUw2decYNO9BC9QoQW939Jm1cQNZi8ovNgd4o+h3ujPZSTyuPY+VHt8VzQTUdV1mqD0e+SS+NZzUFRHiGTYKvE8rqbmQzcJ3t7avw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(8936002)(956004)(8676002)(83380400001)(5660300002)(316002)(7406005)(55016002)(7416002)(66556008)(26005)(478600001)(15650500001)(4326008)(2906002)(86362001)(66946007)(103116003)(966005)(66476007)(186003)(52116002)(16526019)(7696005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1QZXQTehOneLmFJ9KyeyiJPVJ6s/hzwND/7otIYcqHSWZokpOXT5c800NX7LNQblmMZNoYg0H3TV7aZ9CpTrWe6gBEyEoTBMryP+e9A0V3WGctGMp/mzIEfipi99JVfkQ8AyHGlWrOC+HmqMmSI/xchwZ2426vkSC1jFAAfpStzmzDufoaxQbSOUtiEvNE2CH4NhtM8SzJA0+ZMjb3eyJSclWctVG2RWsFyEglw7ZftvF/RJETEUa273C1LqZaBczAQ9SLqVWAEUJxIAk+7THaFa2hzfT8EZB3XoRsENQwdxBooHkYtrsKecHjpxUeYi0F7VjreQhMDd4FessywsmjtwUpTrKDqgpUmqz6v4J3FwDkZQ63OiDyaobWLQRaHDit1iw5cp0cY7/qJyPVIYHGBo8asrtsnvILrbuPfjcTiNNcMtR0rT4Osj9fHoGAdFP8x7e5FIM+AffRLs2cYExbK14SEYMNUgLzAsyLS6PRA=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f31b1e7a-6ace-41ca-19ca-08d803215a23
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 16:08:25.5018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TuSpuutpI5eP+1oIGFR8cQ25MS8BuWu6217iDjKOcaLbK9I0lvexQqT78RS+JLGJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2527
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD's next generation of EPYC processors support the MPK (Memory
Protection Keys) feature. Update the dependency and documentation.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
---
v6:
 - Removed X86_MEMORY_PROTECTION_KEYS. Just keeping the dependency
   and doc update. 

v5:
https://lore.kernel.org/lkml/158940940570.47998.17107695356894054769.stgit@naples-babu.amd.com/
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
 arch/x86/Kconfig                           |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

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
index 1197b5596d5a..db248baa829a 100644
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

