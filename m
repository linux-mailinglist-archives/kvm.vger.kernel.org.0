Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26342696BA
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgINUd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:33:59 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725920AbgINURz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:17:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdwUGqaD5SpylCrZ7C46Wcwn5EnZ/OJYk7SteW0kcu+T5SH+Pe3OGaPJfkT6X4ahyRYL3H6Ind6eqceSFHycUx9B30MjZMd7X9ABhnYpDEYdgoHw7LnQqnIJoUv+cUcITnqb5Bm2/sOtF3+upuvF2srgFbDu2St0oivFR4wJKBbSsv6fZaxpEFatcg6lve7WAmCgnK1uIBoGltIiw3uJqhAdpLuaoMuP+UZxxPjXzdMXm4CN2kborHh5dvo07BPTmH6J/E4Dx6G2DDWc956kzPSADFLwCYzuOaiYDq2y10qKhRQWvpvQ/oA1WD+qYvmHFCtl3Wtx8briiFD9O6qWKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ8GNZcP0Md0CTxo2DMH36cP/64mZuq4WsY9nNNz9vI=;
 b=baUdtFjUcJAIfBdrubqfYxxPh26c1JVE6rdXivj0dwF22hSRl0PyQshMURCpT8o2neatWvPKdbxmvV2oKnlTY159MtmJjM9mh4SjJ+iEQaBfNMTwI0Gzo1k/O9dQ3Xqdia6flIj+sS67alkxf0SQz5ST9fopFX7kRcfL5nk2aafjsY5DqB0fxcORlVJirlMuakcP7gquJ+StsYRPgXDt0GV/9ryWcCleeIZorokvjBS7pro8j6Gh78KDgs4a4AV80iobsTYmBKE0vpo/5+s4xwxU/e930rgpHcjMcwgMcszv+yNUw1YDDOOgfxTqcev6/3u7HTiFoXVfdqJqJ1YWDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ8GNZcP0Md0CTxo2DMH36cP/64mZuq4WsY9nNNz9vI=;
 b=36riDGn0VLWqJmXv27cCxJr/5A4+dck/uSaTL4dbADrSDgAKcOJrJhvWFq3U+tankCk2U7dwFpmSmOacDur78QdvwirlW6E5TGgcOfZig6Lt+jgMDidk5pRboBw3C1smVjCCK6jbn7JtwofbTBHV0PHu2RaTeQv+lYb3cwOBnPU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:17:18 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:17:18 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 10/35] KVM: SVM: Cannot re-initialize the VMCB after shutdown with SEV-ES
Date:   Mon, 14 Sep 2020 15:15:24 -0500
Message-Id: <79a8f9e03580f6cd45ffd02492fdf236fb14a88f.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR14CA0072.namprd14.prod.outlook.com
 (2603:10b6:5:18f::49) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR14CA0072.namprd14.prod.outlook.com (2603:10b6:5:18f::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:17:18 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab6dd264-3aad-4d42-add6-08d858eb2e0c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11634A024E16F5C94C8BBC73EC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rAIicv5oGp25sZIl4oy6eaSwmXkHxBjha6wKw6HnWLxU3Sfz7EwSoLPIA/4dS2MuBcXohi3P36HofGkxFYdx1dGS/wnhY45VWmWoSboSAVKDxx5GheSA9VPVprdDLKV+lRR3eMFAb6OmbKZh6Te4NPbe7FS1jDz+VXdvHpU8OvTTB7YwsV1VoBkm/Lj/ZsVZw86j6qNUzjigKez6UH+KKqla4D5lHrA5zRpYpTdwDVqMGMT8DrSoSeT0cygKu826UOiBASvOoY91UENjefH4GpPqXbEXSN4EBED+93uRY+m01liWF9yWfGEkllG156GQEVfWpeO67LuQax35wzCuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(4744005)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tJmR7n3etXCdiSgfFHmnjb3qJXRJH393e7/1lYarmCSPNO3r2Mhg0+Bt7WjQ6Ac3GBthc9i05b6kkKCuU+nY7hHbw67eXBWdtK/+9SlEE9zObk03+rhWF8CZJfF79KzSDK0ue4iamCN/dXB5va4tiErVmddFwXL5WL4Eg4bhzkR4a8ZOiLASeY9ZPxL3rk3bSKHRLdrd4cjP4u5s5eM1iKMhra2aDUpWKZhC7Z2BkE+p0mWxi8nkjDZqlYZbDMlaUQ8h+PVKpoZIiLPFPAoWVRL7BuJKkS8Gl5lYRYwHY4PAUQ2IsoxPTibRPhoFqEFPERpKapJaBhFaBqKYW95LAte7AsIsulGor97Wx1kmt0alSiRj110otc+gh9vVdCScAPqZH2wGfMKtH+GRu8J0Yo5rZnS+8JcVnKull8Tr9eRemPznSivNO7QFOgo/QhjZXAstB9dV32P+hJ4aqeZJ4+a+G/Bsl8mdUS/+Vxjwc7/gMLFAWGxthBVvQVlgPZLuTTQLz78QTk9SrDKxZz19j0hHw4DPh6eEqJTSQ/IiXZ00+4atT4nFcIPaNWc3ljFSai7N6fNSzcCZm7i9GfEUr5bLjytdkhOCPnp8pazC6roXsTZT4/8eySr4K3UCcUH3HcvloJdKdJXdyMndv2pkEw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6dd264-3aad-4d42-add6-08d858eb2e0c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:17:18.8086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VuwcN/7RayRCjUBzI3FI37ToieuUPb4GztUXcBHpKXSDR+T2Fgbebgp9QogDbo+/XmAPuJ/H+i1ZHYw3OCf7bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a SHUTDOWN VMEXIT is encountered, normally the VMCB is re-initialized
so that the guest can be re-launched. But when a guest is running as an
SEV-ES guest, the VMSA cannot be re-initialized because it has been
encrypted. For now, just return -EINVAL to prevent a possible attempt at
a guest reset.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 47fa2067609a..f9daa40b3cfc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1953,6 +1953,13 @@ static int shutdown_interception(struct vcpu_svm *svm)
 {
 	struct kvm_run *kvm_run = svm->vcpu.run;
 
+	/*
+	 * The VM save area has already been encrypted so it
+	 * cannot be reinitialized - just terminate.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm))
+		return -EINVAL;
+
 	/*
 	 * VMCB is undefined after a SHUTDOWN intercept
 	 * so reinitialize it.
-- 
2.28.0

