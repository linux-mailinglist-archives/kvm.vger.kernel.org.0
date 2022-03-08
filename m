Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065E94D0EC8
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343554AbiCHEly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343649AbiCHElt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:41:49 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2046.outbound.protection.outlook.com [40.107.102.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1497F3BBDD;
        Mon,  7 Mar 2022 20:40:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hW7uVqO0/ELvMhe3Kz4I/p6udTh2mu8SCq//JARvQBU3C//05TfgPK4VRfqRT3LF1IqxW4EI7xNRfbPJXnhdCsrT1S7XXH/w9X7BEw/9nwnl4b8UDOfQRGUYS7xvKJ5r7HJOKj9i3lRvL1L8cVOvMkXTQPDHnD87e8F1xc92uvxT9Uv2mzsBXRFVCyzWV1kdlAjn/Cj74LNe9hd3DVwaUHQCwP9f4xjrXCQkN0v1mZpKdMUlUnPRzop/D9hWujssnpOs2GTM39hsM2QsZY8TmHtFzVZXLrJ9XJwxG+Q5FLJdBYJM7YlDp2I+a1px/ZeScjM1bksg+Thi0QSGzdkOgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BySD8ekJIeFpP166KxGk5bnzjfRJ5WoLQobkj5r3ybU=;
 b=jK8sGjiCeMd5V+DH3vwWOAXtZxyuk2QgD5R30oGJ9Yxr1bjZbscy2M1zFipS4Yaq3y6c7BOeBreVRS4ikfUwtS7GuuTHP0QrzEhc/QH54V6xz8LZsQLs71f4/SrV+xSjk7j3APsB2kZMSs7+/YZ+6Drt1AmBFReMnaKsqgNVwAK4CcAT/AHKvLUihxD7Z5RwfvUvLyrVdvyapOEZ8iI+I0dn5KyUpZccznJTriVR4HDQdBA5Wz3dTSKbSy9SlOLhO7eRuNhLFaVbo9PfJzo65gacTON+84lbjXL69JZyKhtWFZQxWbvImLj3+PXubn4kSu82ZObXF2LcODPot3Cq+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BySD8ekJIeFpP166KxGk5bnzjfRJ5WoLQobkj5r3ybU=;
 b=KvrJLpGUS9gYgzvnHpOUIyveNyAASA8vHofDQawj4Hydwae+hKmyBLUwRXMQkoRXrfkawilLd2gQOgyExdy2G1hlyPL1mHRy1zE4iMEJb2Quf8ToFJ3/X8qWsE7Q4tXS69Ar5L4ADkZOF0mbUWOKt7CCGiiX2k3ZVxTIvwDa8Z8=
Received: from BN9PR03CA0271.namprd03.prod.outlook.com (2603:10b6:408:f5::6)
 by SA0PR12MB4399.namprd12.prod.outlook.com (2603:10b6:806:98::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 04:40:44 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::73) by BN9PR03CA0271.outlook.office365.com
 (2603:10b6:408:f5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:43 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:40:37 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v1 8/9] KVM: Move kvm_for_each_memslot_in_hva_range() to be used in SVM
Date:   Tue, 8 Mar 2022 10:08:56 +0530
Message-ID: <20220308043857.13652-9-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220308043857.13652-1-nikunj@amd.com>
References: <20220308043857.13652-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2eb7985d-ed0a-4c29-0af2-08da00bdce32
X-MS-TrafficTypeDiagnostic: SA0PR12MB4399:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4399C35276889270B582FDB7E2099@SA0PR12MB4399.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EAwtEjWKykSCAm1MDYEYZaRLY9njk8mEw5ETcPp3ZnWNNoHCi73DvVdUAByiNWWU9rWCMnVzF7al9mhIlE8X+o7dlyCJUZ97+jkTVqKpmOgBy/L9kjOFBmDT4k574Ov7n7P403J0Giz4mAANyriM/oPlT7oDcQ+V+nsnCHlhu77fmyWh5xBZxTTPX+fQ1muV3kf/lcgQSNXVWb/KOGPa69EjApfsFiQOgg/OQKderk54Hat63exxX0EFEuULSZZ7xrH4b9aZTQ/G2wNyq0JgTkPr8j5cpJ+3lcRw4bTaOP+szYmFZn8ySsQUr87fjX1ovmjpL1EQ22pspR/HqkbatoSdIoXMTKLN6vXWUlBxkkRDWnAtfYbBXjwnwNiUd7sZ3u2Abn9s0tM6juEaOKCL0yQpspbFWW9JxQcUFLKfx1UL+yNBOyKOqiXx+0f/VYS0ArZIVcE6ecLpnWOAtYKeFWuLivA2pGzmIlgbBNux5DRcRibxuhQgXMdiZTH2bDLDt64/RVCRqcnjaGzEpTA7ONvJbhC51bb6Mlpu4ExJpZypuaB6v8FlnOnnSpDwYSVlDp+4lBOefQSUzbrMkzDcdTdYZznsGygxM1F5ixuZ1BoEmNlfplRC4a3i7Qrct0uyM3BCD2HsBw5yQ1R03FaiijaGOeJd94LJqHbIuUmbmStBm/4N6fSur6rxG7YlU8iXn1bpdFmB3ICNQCziGldrZg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(40460700003)(336012)(47076005)(7416002)(508600001)(2906002)(426003)(36756003)(6666004)(36860700001)(7696005)(82310400004)(5660300002)(8936002)(26005)(186003)(16526019)(81166007)(356005)(70206006)(8676002)(4326008)(1076003)(70586007)(2616005)(54906003)(6916009)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:43.3770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb7985d-ed0a-4c29-0af2-08da00bdce32
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the macro to kvm_host.h and make if visible for SVM to use.

No functional change intended.

Suggested-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 include/linux/kvm_host.h | 6 ++++++
 virt/kvm/kvm_main.c      | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c23022960d51..d72f692725d2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1063,6 +1063,12 @@ static inline bool kvm_memslot_iter_is_valid(struct kvm_memslot_iter *iter, gfn_
 	     kvm_memslot_iter_is_valid(iter, end);			\
 	     kvm_memslot_iter_next(iter))
 
+/* Iterate over each memslot intersecting [start, last] (inclusive) range */
+#define kvm_for_each_memslot_in_hva_range(node, slots, start, last)	     \
+	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
+	     node;							     \
+	     node = interval_tree_iter_next(node, start, last))
+
 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
  * - create a new memory slot
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c035fe6b39ec..ff890f41c7ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -511,12 +511,6 @@ static void kvm_null_fn(void)
 }
 #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
 
-/* Iterate over each memslot intersecting [start, last] (inclusive) range */
-#define kvm_for_each_memslot_in_hva_range(node, slots, start, last)	     \
-	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
-	     node;							     \
-	     node = interval_tree_iter_next(node, start, last))	     \
-
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 						  const struct kvm_hva_range *range)
 {
-- 
2.32.0

