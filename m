Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F326E64D0DC
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiLNUOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiLNUNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:13:51 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7832DAB3;
        Wed, 14 Dec 2022 12:04:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcKuM5j5YFDCdqLl92inJmcuyfRUfl+v2sfewlyfr9A6/MMAJjL7pUgKu3eP58I2Cq11NCR9IgUnT9oLk5u61wc5uwoyUqoztZ1TYYLRQ2/0kXV8llcX8zitihrkwGbiFdTpwjUWgylK8RCdYjQUz1Hwd7rkD2cS25S98+99rwkVS8bilEWXRWlVRqpbN16LJWr5jA0r9fkks5NC5XUluaGgYrzevNuD1+k9tqUfHTc7pE6rKZyvnqZmVom5VLiLs6utzqgSpsTy2Zy4fNaCUO/LtQb88jLqrEHlx+Z4ReJMCjKAFcDHcwyt99Q4HJVFw64bVDpR+DFNaZ8hL5A5Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdFV0whZydjkEkUMB3fvnv3WDNrdWPRikxIjb+Jw6Mo=;
 b=moqoiGlNCA/m7nJ5hlhiqxYvP/Zc/Py2eBAADvdtqoCQiSvENk39YvXjQwyg813rl7bfEYDc+d/4RFOamRVSlfeYaVi+7IQ5eH4cme2rJ7iVtDQ99kpkcfdQLNdrn+m20TOHNBXnVPUwKv9I+u3MXav9o82wwxZq8flGdK2a7y9LVZE5BPWE7pRCOXdwy3P+8cdMCVsV8rWem63zR8ptkwsBGeW6pvA12nxhNp9jwFSod4nkA7UHKChHhPGOW8fj5mfT7+YRIHcIsS4K4NChT8kjcKmMSLwrMtueIrsX12WveHcUcIIzNi98Mu+oLloNUbOW2kiiA09MMvA44DgdKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VdFV0whZydjkEkUMB3fvnv3WDNrdWPRikxIjb+Jw6Mo=;
 b=Ds3YocRQWIfYpbAEHhD8te0koL9WdvXfvVhslOM448dLZHI3ZbPahwQC8r9TlZKvKR+C34KgEi4Gyq/zsJg1jSTeBU+Qd7S7+n0lioYaGok5xsetHs7WF7BTsOyPcR07iLytIEexuWJEEEzFZXylEMqnuaFyFjhJW8kxSi1PjtQ=
Received: from MW4P221CA0021.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::26)
 by PH7PR12MB5904.namprd12.prod.outlook.com (2603:10b6:510:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:04:57 +0000
Received: from CO1NAM11FT107.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::55) by MW4P221CA0021.outlook.office365.com
 (2603:10b6:303:8b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:04:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT107.mail.protection.outlook.com (10.13.175.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:04:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:04:55 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 56/64] KVM: x86/mmu: Generate KVM_EXIT_MEMORY_FAULT for implicit conversions for SNP
Date:   Wed, 14 Dec 2022 13:40:48 -0600
Message-ID: <20221214194056.161492-57-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT107:EE_|PH7PR12MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: c4a67f0b-5239-46a7-ec86-08dade0e793a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zk3MkAaPPMkQ+VUyCTDwmYxwIBeFVs1VuJYW8UkrvbPQKJT4Ec8uXWa+ndJWwQD6H1JLcZ6nNPQfuZA133g3v7o3BkG0NIRxlXD0jIiL31FmVej6AGIggJNofojZNsp9kRduFJj9TSAWdjJiX2p0bswZNq2N3MQ3KPPRrj/bJUjMKSVE4Bmv2CIbgR24cFNyFMZR8qlTmRNzYCf9t5KriTICu3su2qNINB3REr9A4kBsjucuRX6XTzKG7GDY1dWkwYbDoKsXVGnWchMGMxifJ4UJeNxo9vZUIQDNUzIvLHf6b6s7LlF1sj1n5dKzceSQWAV+3jTiqPJkvS+Q94i2ew4RVygP9MtfoyyXb4aWaewiojFReYMYvToKZelNTWLRTNDZ0WtIRG8jE66CLIO/anbImS2U4iQhKfTprFEgmupBBLk7bla8+j5F9ZHFZbAYhRkY4s1TDiSbGJlOg1+JSA/PisdOsU4qhtKCbwdws/5QSUUV5BjxNZpVaziG1EuQyhkPZoRsVGyR3u0q5BUWI9kF3uU6RbNaaHC8x1as1oCQ/0DpsRytsgwFCk8OPRt2DFwabjcAYKt8pFd3yjZr9A7JKSFoQQUtIwXv4AlpO0K4XThPx73EUvjWjnUPdaGHuaLMXbafagFGSgbDu3BMoqXdI6pQjaJtaOaCWYdtvhgTd7NLWmJPwOP8rdMYplSkIGpOV0j1pYRcpyd6jE23BBxw0rem0O6vugfRxGYpMZ4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(40480700001)(7416002)(356005)(81166007)(2906002)(44832011)(36860700001)(478600001)(186003)(26005)(6666004)(8936002)(5660300002)(70586007)(70206006)(8676002)(4326008)(36756003)(7406005)(47076005)(336012)(40460700003)(426003)(82740400003)(2616005)(41300700001)(82310400005)(54906003)(86362001)(83380400001)(16526019)(316002)(6916009)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:04:56.9284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a67f0b-5239-46a7-ec86-08dade0e793a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT107.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5904
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP will set PFERR_GUEST_ENC_MASK for NPT faults for
encrypted/private memory. Generally such accesses will be preceded at
some point by a GHCB request to the hypervisor to put the page in the
expected private/shared state, so the KVM MMU wouldn't normally need to
generate KVM_EXIT_MEMORY_FAULTs to handle the updates at access time.

However, implicit conversions are also supported for SNP guests, and in
those cases an KVM_EXIT_MEMORY_FAULT will be needed to put the page in
the expected private/shared state.

Check for this PFERR_GUEST_ENC_MASK bit when determining whether a #NPF
should be handled with restrictedmem pages or not.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 885a3f1da910..0dd3d9debe48 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4446,7 +4446,10 @@ int sev_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 error_code, bool *priva
 	 * source is the only indicator of whether the fault should be treated
 	 * as private or not.
 	 */
-	*private_fault = kvm_mem_is_private(kvm, gfn);
+	if (sev_snp_guest(kvm))
+		*private_fault = (error_code & PFERR_GUEST_ENC_MASK) ? true : false;
+	else
+		*private_fault = kvm_mem_is_private(kvm, gfn);
 
 	return 1;
 
-- 
2.25.1

