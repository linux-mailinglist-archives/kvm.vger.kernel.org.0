Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0896E1D0352
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 01:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731798AbgELX7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 19:59:08 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:6102
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731660AbgELX7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 19:59:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyAfCc/DTOJJpJhB3F4RZNwF1boM/xIUefml0M19/bHFikEEENIpUiM6jowGZabe5pGJkdhpZ7fFcdc9n8aMDZL8AwC1h6Yh5vuq7uibjagbfd78AbtKsmZWNGnaR+nMLJRZu8M1nAfY4UV2AQ/whzCEhmvleXb/YggOFIRVubxnwF9G6/lNenAdPxO5lbasFvDruI8m2hByabOYJs9eKkiESjTbYDSk7LU9GpGJ/mQZqbkYNeuI+hk2P2CrqgF+Hso9FSvVhatQGSSxwqzLeH4Sq3XJKsXpra8sRUSpjBaQykL4O24lPr9ilzedJEhDazVDSxM4iD890wBxkPOHUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMZUVX3ZqhJQHCw5uQ3/ZEfIgNnVzw2K9kZ47HJn6jM=;
 b=jSBC1u0pijRclk6VagsxitA7Kcyxvk8Wvw9HTHSEya3k2uQXRxwespenzkzhEum1o859cqqzMW5HrZQ1xdsWm9znPj21k/LL21ZeIcLEXpl/aA0RdVYEuQbI4+I2OXF9vld/bzFj8Wu1CTRAGdB7sY9i3h9Mmq9hp5R4C5O5SGCFde5rCLCpa+vLeU3iDhQPIeMXpbaJoAKlPCFSgSvVOTX6MpqEYkh1fJQesE4HdyLzPy9xDvvlBsMpEcTbtBF8tz/sZUtPvQi3/V582nrwATeu55FHp8B2CfzMJ+LdJBhBUtNyEgCpR9AlvP8Am13eV9g8KjgASHN+vCP5G0U1VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMZUVX3ZqhJQHCw5uQ3/ZEfIgNnVzw2K9kZ47HJn6jM=;
 b=bqmpTVK2h4g0UcK9EAxCyFqliXl1tgZoafY38dxr/neJgDY8PWYV8FCL7mnuB2n07f3m3A6hSELBUvV7nzSGQWxwOACr9MYRsnbd+cZHI9wrSC7bCTq+q6zOfzGw+Jriv+ylGtTPNTyHnAVqp0oTmJXKrEHCBih7EJATUpLl6Kc=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 12 May
 2020 23:59:01 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 23:59:01 +0000
Subject: [PATCH v4 1/3] arch/x86: Update config and kernel doc for MPK
 feature on AMD
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
Date:   Tue, 12 May 2020 18:58:56 -0500
Message-ID: <158932793646.44260.2629848287332937779.stgit@naples-babu.amd.com>
In-Reply-To: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
References: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:5:14c::48) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by DM6PR11CA0071.namprd11.prod.outlook.com (2603:10b6:5:14c::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 23:58:57 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eca43666-d2f6-47b6-f3f8-08d7f6d07104
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:|SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25121E20CD8E283970EFE64895BE0@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4vsXpBljR3F2lKU87kweOaMQ1dH+hbuk2vSOTyIna2XMHWimTvG49ZIqQ3m8QYe5QesBod7FGA2KulPzkuzoMwGSnj/8j2XawlKaMhT8opTG9EBNLpg2gnuBl3iNm8JBw60eGm2Y3R+elgGN1CEtuJrhQ0YG4UR+tehWvRkiEUimJu7QHM1+VweUWijILsJfgg0/vC0l4RAcxmIe3FZsbJGn+XlS/GNkFEylMQyesOVGyUwsp4iOVvi5HL4oXfua8SPTNg2HUwY+7xqC9OyzN5jcmh0dnGc1Mdf3BWMTuh3YzdIZWwKkfusiaOPFwGmHCyksQ207t3E5yhRos22Pa3sXvt8eB0GzYBYPqbWO1X2aiiOZxuXfVSrvflnT87AS4UFDCbcTY6EKk/HQEG8ggsZmRhYZIlzVRBURg64xIS/eEQCrg7mUMoeypPacKUp1SCDzOxOFaFXz6kJlzRoStDsBFrFKkB+245HrB1i//2rktiM94PT9fVQcPjUXxh0SPCKA/M/GVJtzBF3SN0f8BA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(33430700001)(52116002)(26005)(8676002)(7696005)(66556008)(8936002)(5660300002)(16526019)(186003)(2906002)(7416002)(103116003)(15650500001)(956004)(316002)(7406005)(44832011)(55016002)(66946007)(478600001)(33440700001)(4326008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9gTfTriU6Cl8kWWfqhv68uZxwrEeuTapphWFZquH+ghyRPigNpO0VSsIBXZKhr4luhTXYoJxjy3JDY1+2lx3MP2bwSBYhRM3eVKev7KwOeU4WcFZ3l++LQUwoJmOS6o8TC0L4ZEADFuBzzD37TyouAnMBJG4I3Ycm994sb+gI28dUBuXA+ZBAPXvrw0WhPzPruZ/egHNrtCzpfeUtVpzw8UZKK2FQUIuajyGRhbjqsj12NbX4DDl6Bv4DBWB6lscZQMzim0QHVqsywVlv43pxgJAQ8MHHbxiYjscjjlgR3xk+0Ov6SLm0qvSYmWWsOltz63W3FLfpPULuRrOrRhwd8ZHJ1ng3MDWmLmURO/dKpsNIfPUwuhh9QE/A1eEwBWu2B663OXYMCCJOfcPSrsODpVC+MJ/imRkKXHywd/Aw3e7zF/imnAkhfAqRQCeoIDJBfvAaBPDLpDTPalGb5cEx5m3prP32pdTqqkusMRNLUI=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eca43666-d2f6-47b6-f3f8-08d7f6d07104
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 23:59:00.9263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TK94tmugXx3/1mNf5SJLqbEGpDbeLal3tmMboRpHFngQ3O2/CV51USQwBtVghKP2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
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
 Documentation/core-api/protection-keys.rst |    3 ++-
 arch/x86/Kconfig                           |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/core-api/protection-keys.rst b/Documentation/core-api/protection-keys.rst
index 49d9833af871..d25e89e53c59 100644
--- a/Documentation/core-api/protection-keys.rst
+++ b/Documentation/core-api/protection-keys.rst
@@ -6,7 +6,8 @@ Memory Protection Keys
 
 Memory Protection Keys for Userspace (PKU aka PKEYs) is a feature
 which is found on Intel's Skylake "Scalable Processor" Server CPUs.
-It will be avalable in future non-server parts.
+It will be available in future non-server parts. Also, AMD64
+Architecture Programmer’s Manual defines PKU feature in AMD processors.
 
 For anyone wishing to test or use this feature, it is available in
 Amazon's EC2 C5 instances and is known to work there using an Ubuntu
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1197b5596d5a..15bda3a60c1d 100644
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
@@ -1902,6 +1902,16 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config X86_MEMORY_PROTECTION_KEYS
+	# Both Intel and AMD platforms support "Memory Protection Keys"
+	# feature. So add a generic option X86_MEMORY_PROTECTION_KEYS
+	# and set the option whenever X86_INTEL_MEMORY_PROTECTION_KEYS
+	# is set. This is to avoid the confusion about the feature
+	# availability on AMD platforms. Also renaming the old option
+	# would cause the user an extra prompt during the kernel
+	# configuration. So avoided changing the old config name.
+	def_bool X86_INTEL_MEMORY_PROTECTION_KEYS
+
 choice
 	prompt "TSX enable mode"
 	depends on CPU_SUP_INTEL

