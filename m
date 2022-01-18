Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834DE492449
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbiARLHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:07:15 -0500
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:65024
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238749AbiARLHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:07:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4L5N0Lu4lNiPn2gm7V9tsmh/LF/8FS8R7Frh7tOtAxxUc4O0IIN5Knb9eAGlWaLJbLeteUJSfGtKukzXVjAdmrU9JHja5sd8tHiud7M7lEFVLHrhb9wBWOi099dNxJMBZeOmzr/VVNplWo2n7Ugs2SGVZ+P1SBu5EzmdHTdMhzWit/V4ZSowx1f3Xg5xpWggmzuM/a8DpjTZ/fH9YmPF1nU2lMOEZKGf+3pnPdkACBLk3p+EYzWfrc6fmijEHtK4ijW4vz7LdrlV0AUikcAmvrr35lMVwgr38p6TqWZYw+SctReT8EycgO9EOWSJIdteOMWZKbrYoxGvkbfhyr6qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4O1BTxQ+0AQpz7nmibwZM6cMfnh2ovbuPEI8zFPE9M=;
 b=DFYOutrUDSzWkSnFM8CQWQwPFfIHJsqcZU3qKVBfmcXt3SEB3sZzxj2VApQscu4hDdr4/hWrgMFAt4LOWybyMsRLtT2wvEMPtpQouruVsyOIzvw/2pJnwhz4h5LDx29BXb+Dx3C19y6BbkA9Ik9E/HQAbFXR4w7TP+rEekAHP+xCSMrc34vhFEV/rpepNwE2iH54003vYkST4qXT4f0f5qEdSKGVfdT1Wm+mh1l7O2FF5hwOpQ3Yw7YqV8q01n+hsnqLYw71Bxuge8n3nFRQ2y9geMpDuHZG+Le6OTydVh0j4mnMtIM05Wr1HDfkK0GMRPhHDcfTx41M+xXK86fMXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4O1BTxQ+0AQpz7nmibwZM6cMfnh2ovbuPEI8zFPE9M=;
 b=PecZ6LYBhDeGvSsfIkK849wCug4oLeHbWzVQAkEYPTxTV39PzIbu1dyH56St9/rO+hOsJlKv3WEBHzC1DmKJcbLH2Rl/FYAzggoAq8+kAzuprTRXFTWnZCMmWSg24iWl6ISrbziGnXIHhcfRN5L1A0wyJg5KDw5I7IORnLPc4ak=
Received: from MW4PR03CA0152.namprd03.prod.outlook.com (2603:10b6:303:8d::7)
 by BN9PR12MB5354.namprd12.prod.outlook.com (2603:10b6:408:103::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Tue, 18 Jan
 2022 11:07:09 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::3a) by MW4PR03CA0152.outlook.office365.com
 (2603:10b6:303:8d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Tue, 18 Jan 2022 11:07:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Tue, 18 Jan 2022 11:07:08 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 05:07:01 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [RFC PATCH 5/6] KVM: SEV: Carve out routine for allocation of pages
Date:   Tue, 18 Jan 2022 16:36:20 +0530
Message-ID: <20220118110621.62462-6-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118110621.62462-1-nikunj@amd.com>
References: <20220118110621.62462-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d00adf51-1c0b-4767-7c75-08d9da72ab31
X-MS-TrafficTypeDiagnostic: BN9PR12MB5354:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5354D20771B9652190E838C0E2589@BN9PR12MB5354.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RXDzO2PzS6cDcOOlApQeJPofK2rXCvNNbcnjUXnlOzXO18FESbiHuyOTUTyXGI6OFy4jFaCjd8htRRsnf42+7m4p7cVK2WAmFBTiJy1ZfO4XK8dM8W0OkoTWu5gyqPvqQgzBeE3FqTq7KpIAQRKK9Z3v+qdacIyVHbgZDZ2MyCr4l6fXUYMiLJGOSDi8gX4cVodyZG9wB8snefzutHHl1gGp2caOB4CGGoHg7hcz1Je/czkEGcu0rxhMvof3kjbhcNy33kIGe2r41kJm39e/+6oueqxO79LGZPbbuewoASvcRtVf7L/pmPRKoiKCNUWEnlTM2umt8aQmfv7HPqpDsGNmXiDrEXYSrrvnRm7hSCy8RWSTUyLsz96X0Bb13p7JE+CAyq/TWZu9qX4zDGOmEUtOyeb2joVNU9K9YLvrdijwznjsV3JZsjAI2Z3EbwQcuuzwSE/XOX8iEYPLH7W91sB6XcJMgwYebK42K8SkWatMnWuqTtpceMx4Cm9duch566yWN3NGxdkTqi+NOCk94QBxXXbRuQ23TaiubrHzoQRCAdTbVQSKgpMLMy8OfBaKg+oxiDDYYkvTpUo4ljjWWiu9hZ0uMdGSeXhF6ydj8p4zy9A4rCG7sDOBFZPL8F1C5KfHAca9VGiremS2l3Aa6qzjAQGEDtlp0l+O8N6m2DSz2X5qfC7NqOgFoqsqxBnc381XRFMC5GGku2foo11UdlXUdgQ5qkJpB0hS3XD9G3NhD7cDwqFDHMZyF7n28Xe6mKKrZJOIXLOLj09QQr8YzASRqFgZiA/Cl0JnCgqkxbI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(36756003)(1076003)(40460700001)(16526019)(70206006)(8936002)(70586007)(508600001)(6916009)(2906002)(4326008)(8676002)(82310400004)(5660300002)(36860700001)(186003)(356005)(426003)(54906003)(81166007)(6666004)(47076005)(336012)(2616005)(316002)(83380400001)(26005)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:07:08.1347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d00adf51-1c0b-4767-7c75-08d9da72ab31
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5354
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a separate routine sev_alloc_pages() for allocating sev pages.
This will be used in the following MMU based pinning.

While at it, validate the number of pages before the RLIMIT check and
use kzalloc instead of kmalloc.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 44 +++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a962bed97a0b..14aeccfc500b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -368,19 +368,13 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
-static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
-				    unsigned long ulen, unsigned long *n,
-				    int write)
+static void *sev_alloc_pages(struct kvm_sev_info *sev, unsigned long uaddr,
+			     unsigned long ulen, unsigned long *n)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	unsigned long npages, size;
-	int npinned;
 	unsigned long locked, lock_limit;
-	struct page **pages;
+	unsigned long npages, size;
 	unsigned long first, last;
-	int ret;
-
-	lockdep_assert_held(&kvm->lock);
+	struct page **pages;
 
 	if (ulen == 0 || uaddr + ulen < uaddr)
 		return ERR_PTR(-EINVAL);
@@ -390,6 +384,9 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
 	npages = (last - first + 1);
 
+	if (WARN_ON_ONCE(npages > INT_MAX))
+		return ERR_PTR(-EINVAL);
+
 	locked = sev->pages_locked + npages;
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
@@ -397,19 +394,34 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (WARN_ON_ONCE(npages > INT_MAX))
-		return ERR_PTR(-EINVAL);
-
 	/* Avoid using vmalloc for smaller buffers. */
 	size = npages * sizeof(struct page *);
 	if (size > PAGE_SIZE)
 		pages = __vmalloc(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	else
-		pages = kmalloc(size, GFP_KERNEL_ACCOUNT);
+		pages = kzalloc(size, GFP_KERNEL_ACCOUNT);
 
-	if (!pages)
-		return ERR_PTR(-ENOMEM);
+	*n = pages ? npages : 0;
+	return pages;
+}
 
+static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
+				    unsigned long ulen, unsigned long *n,
+				    int write)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long npages, locked;
+	struct page **pages;
+	int npinned;
+	int ret;
+
+	lockdep_assert_held(&kvm->lock);
+
+	pages = sev_alloc_pages(sev, uaddr, ulen, &npages);
+	if (IS_ERR(pages))
+		return pages;
+
+	locked = sev->pages_locked + npages;
 	/* Pin the user virtual address. */
 	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
 	if (npinned != npages) {
-- 
2.32.0

