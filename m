Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5BC64D10D
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiLNUVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiLNUUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:20:39 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::61f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D9FBE16;
        Wed, 14 Dec 2022 12:09:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3Rel/P9Z7OJE5kuAliew2w7FhMk+r8EKcRnU8EL43mhB33HiGwL4d5x5QQlEAnyPM/Sbjim7h427JWmha45fsFJzRAjCAWLrbrMWRS3nc2jCZOzlTueNoWKe2C5tgO4i80z+pKpTysClweyFgwnluf6dsf+KITDF/zMGiL1Sw5cMM6+LKKQaVhk3mucDloQT6hcsCTaWiW+7q21tMKZj/VFPoiHUHVEuMS48RJAkIoC3hpO/decTb8lxsjn6jzugMXpkn4OAJ4z21gaUmMdV9fx8OG6twQ4UpyaImGMJ8IT7txvRCAf9mxRu7T+P5TbQQjXuvcQ91iqxYcKZgHV1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UoTE+fiW10Y+o7IhpGUW/8psStYG4PWgFyeDWrTWepE=;
 b=EjXpi+4MgfZPBrGGgDPg6xKlV16lmK71ax7vF6jPh4K+/YMCPgN2KDeOEedEfmUoz35ZH/b5kDLa5lu5D9QhAs+s9yntugnusN7X8tPeJ63CXE1TCzvJI3u56eLsQ13F+PdEG1VjrYfIl5N9uONT9qqPj/QnFh0XYG5Vphxnp3hClswLAts19KMRV85A/k70HAa9UBL0gIZi5NeHVlJO1CL14eTB+C7B3VPCray3x9XUjnT7xovZKJh/BMxjNVBHaRAhsK6orR13Np8Xb8IO7iQMk7Gd1YCsF2TovZ9urTup3vAaUcqoissfifh6xsvI3WlHSvSIZ/1CCqlXJh6ZaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoTE+fiW10Y+o7IhpGUW/8psStYG4PWgFyeDWrTWepE=;
 b=e2JrRsKdrZ+X4ETw96wMApa/EFuSQ6W9rmfP3g0vSfbTIZ3mdYj1gwIN3I11d75Zg6WCS3GVIdo8wtk8Z8NXlHKC99CsMHEEv3LwM297kYt64AMqXQpJfD3WHMY4IIv/xaUq12MF/D0AOi2nm+2oclgr+uRNsv4XwKzzcGF3UPU=
Received: from MW4PR03CA0303.namprd03.prod.outlook.com (2603:10b6:303:dd::8)
 by PH7PR12MB7236.namprd12.prod.outlook.com (2603:10b6:510:207::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:09:13 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::67) by MW4PR03CA0303.outlook.office365.com
 (2603:10b6:303:dd::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:09:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:09:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:09:08 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH RFC v7 08/64] KVM: Move kvm_for_each_memslot_in_hva_range() to be used in SVM
Date:   Wed, 14 Dec 2022 13:40:00 -0600
Message-ID: <20221214194056.161492-9-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT061:EE_|PH7PR12MB7236:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e62d8c1-447c-4880-10a6-08dade0f11da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lg3YP3RpLL5TvffTChCRCg1QLEheUULM+s3Z6rqU1KnzhHb4mXNifSg74d6JT94BoJTVWQAQrmA3GaxcKkIq+w5xfZW0Hhe+obxXUYIUtzvBvymat+biqLpAeb/t4huem+uUfkhx1Fn9t1y2lj67Pr7OrUt8IctrWQhzq/INworfkf7EGmDH5WHo/IqpRo0fKYbzlRYo6Bw0jQbPK0FY5j8RbcyPDUDYA3jpSwgKFliq2aOzprMfX2Z5BAyw3qfaeoX5HK5qnPAkclGD1ZqPYuGaea6ECqtZrl47rlyN4D++E4BXQOjVNjojYilLGHwpMYPiN8sbU9S4D1abPr8KH08r3hl9lSAu3UJ26wvox5rEpEFLsaNwYuESHSHM3hXx6mFfalb001VdGqB8VbceKtHYsgTWTCk/hzXsqYdjDpl+nIuOnLvPRJ1f3je9GD13sXUU6Uzj1hUzJD3Gv1azLKVTdztGlg7Kk7NCdgC20/rCtEMZZ7aNXIarWx/zglNiI7FGzif6JncStwCiOJYBhlEG3X/FcXx2XkzIBjRIPPj0uTvKGV9Jhp8Gt0VEieWFJeuu92BDRfInjt8qSizFJxgEC5NU0asRbPQjq+821ADS68lxM/+Lp638+uauEZazAsNMeB2qktvpGNLslfrgfO+aQ04QYPw63W1IiAw5gk6RpkdXW2hCe22WoDbS1pipaoBdn8FzldenPm0qmYR7GcQ9K0CSkalDshWQr+SWGAU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(36840700001)(46966006)(40470700004)(70586007)(6916009)(70206006)(82740400003)(8676002)(316002)(4326008)(5660300002)(44832011)(356005)(81166007)(7416002)(54906003)(7406005)(8936002)(40480700001)(186003)(1076003)(83380400001)(82310400005)(16526019)(2616005)(36756003)(41300700001)(36860700001)(2906002)(40460700003)(47076005)(426003)(86362001)(336012)(26005)(6666004)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:09:13.0319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e62d8c1-447c-4880-10a6-08dade0f11da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7236
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nikunj A Dadhania <nikunj@amd.com>

Move the macro to kvm_host.h and make if visible for SVM to use.

No functional change intended.

Suggested-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h | 6 ++++++
 virt/kvm/kvm_main.c      | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f72a2e0b8699..43b5c5aa8e80 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1116,6 +1116,12 @@ static inline bool kvm_memslot_iter_is_valid(struct kvm_memslot_iter *iter, gfn_
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
index 73bf0bdedb59..a2306ccf9ab1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -623,12 +623,6 @@ static void kvm_null_fn(void)
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
2.25.1

