Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE48C50DF2F
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 13:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiDYLsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 07:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbiDYLsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 07:48:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342E117063
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 04:45:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWNl8SZV64PYoUwCq5v9oh3/vLw7iQHKnPd93WX7wsMeK14wkZNmCFdHj023lT7i5c86mVKSjS3zDMTeLmZ9u7IS6UFrgoxXA/LoWufnBV8W8Rsnbm5bw3HKUYPH0WTGUn8JVGJNT1iKUXhardDdvMY9XIpr76F5Ge3wQRByyeiX0f6Jjlxp+pC9V+MFFIVm9K2JQPuuXN5zZT+Efrmrm0tE4uIcm7UfalOt67mnEIO5nEsbPryoUF+qx8tgXYOd01pk9YXwKDnqOe2Ne9t4hrh8ZD0EFt4EhgREEHoxcyzyX5bUUcFaDw4lDYUj4nNK5jnCObsVC37vjm84dXe6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQoMxsKRWvk2zoRApzSmN+kwdM16YC7UU2Rv6UIx/Sk=;
 b=h4sEwNO/nT9YQEE3Y5Wui/Vo4Z5mGg30Mf0y4VCdUDgGU2zLxXWHn2fXYoYP1evND8fKPIJW9YW6NOrDidW42veVKYtF1Zg1+Cb6+4QVUG8+/Z0a8RThfpC9fZ1EtH71s3lVeCCtd/09efd/GMLQy1k9Dyjr9c3bYRO7SnxBIxAYOFB/hfcdW83nu1yRkwKUdWiTBUWzZxfk6rSeKtONs9p41mGp6B1j5Q5jj9sRoj9u3cFTq1wt5GkM9e9Gj1F+gWGsnFcle+ZGwNs3f1watGLDjvffTCQ+7U/pG8dn+gb1AYzcuTdfxXG87Rg+J2uf2BJ6craCavbRBc/VKfynVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQoMxsKRWvk2zoRApzSmN+kwdM16YC7UU2Rv6UIx/Sk=;
 b=tYGiARy/Z0KahtiAUTZOFaJkvkvzsinfIAsz6pLtFFCl1X51G7yrzr8igwluIPm8LxyB5ToQmoNKfj2Ztqcs1aGKHFOnkzRGyhHxoVaNvCHfzAzB7cIBpGw/ofVZ/aZpyN5DmPU/GZcKJTVwlP8tcWrphG4zEXpLECSHQJk6UH0=
Received: from BN9P223CA0028.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::33)
 by BN9PR12MB5050.namprd12.prod.outlook.com (2603:10b6:408:133::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Mon, 25 Apr
 2022 11:44:58 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::99) by BN9P223CA0028.outlook.office365.com
 (2603:10b6:408:10b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Mon, 25 Apr 2022 11:44:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 11:44:58 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 25 Apr
 2022 06:44:56 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests RESEND PATCH v3 1/8] x86: nSVM: Move common functionality of the main() to helper run_svm_tests
Date:   Mon, 25 Apr 2022 11:44:10 +0000
Message-ID: <20220425114417.151540-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425114417.151540-1-manali.shukla@amd.com>
References: <20220425114417.151540-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b42b35f9-52d0-4363-f5a6-08da26b1066b
X-MS-TrafficTypeDiagnostic: BN9PR12MB5050:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5050ED3E88D7FB2E027281F8FDF89@BN9PR12MB5050.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Ovo51GFgiNKduw01P2yve47ai2cWQrZZOdiptxRdoJU5Txm48K7LFrvB7LpNrfHYBBZlJn/ROygfL1S48si3rhYbFAu1h1Q5pDossAM/qwISrW8H/0VFmisy5kowbY4gQOWl7EIE6nDumGQumF1Su/OKSAg3lhpX9IG6K3rDcPNVloJYGfuQoyKFKlNJ3XCAIR+moFSQE+4yPKcvKSIC2whgPCSXJewgSQ8oT1shX8syKaTwvIO6oeSIt79RPccl783RowM7F6QysiHlptk4FnBuYjvOJCqS1M8MajelPDP4aTfGWMEsSfWBS7lYVu5mmp5xkkZD0Ol7hwHjMRd+YSLwOQ7hys64LAf5uxIzR6cHFJsUbsDIVkIaelrYeWVh90wDhX7CtG+KpC0fL39XHYrVhG3MmRpjwg4JrHupqwjjyAjOtA6+k51IpkASfgcbvY923vr0gXEoaxJMkQEM4+Wr0mA0B7Gldw57nBrSwDNdnouQ0nWKV0DZ/7Kg2bAjyeleuBHp8xy7YqsAfrvni45mZabjHmCAcTGLFJF1ZPDqGmlytgF+Ql8rWWe6hWFyOdnC/4MpJL6hdhYr6FSZh/jQEUoW25Ets2zhEQsalBdiS/2PH3RSxhwIUljvE7IhOJzPXDU4PmJXDiBTLyboRssnBDbIA1kCbRKr0T1ULW99KyHcJcSX69FTaSXsCn5L2Pkv+UzDMCZGAQn4n0ZvQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(86362001)(36860700001)(508600001)(26005)(36756003)(426003)(83380400001)(336012)(47076005)(2616005)(1076003)(186003)(16526019)(6666004)(7696005)(81166007)(82310400005)(70586007)(70206006)(2906002)(110136005)(44832011)(5660300002)(8936002)(8676002)(4326008)(356005)(316002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 11:44:58.4526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b42b35f9-52d0-4363-f5a6-08da26b1066b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5050
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nSVM tests are "incompatible" with usermode due to __setup_vm()
call in main function.

If __setup_vm() is replaced with setup_vm() in main function, KUT
will build the test with PT_USER_MASK set on all PTEs.

nNPT tests will be moved to their own file so that the tests
don't need to fiddle with page tables midway through.

The quick and dirty approach would be to turn the current main()
into a small helper, minus its call to __setup_vm() and call the
helper function run_svm_tests() from main() function.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm.c | 14 +++++++++-----
 x86/svm.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index f6896f0..299383c 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -397,17 +397,13 @@ test_wanted(const char *name, char *filters[], int filter_count)
         }
 }
 
-int main(int ac, char **av)
+int run_svm_tests(int ac, char **av)
 {
-	/* Omit PT_USER_MASK to allow tested host.CR4.SMEP=1. */
-	pteval_t opt_mask = 0;
 	int i = 0;
 
 	ac--;
 	av++;
 
-	__setup_vm(&opt_mask);
-
 	if (!this_cpu_has(X86_FEATURE_SVM)) {
 		printf("SVM not availble\n");
 		return report_summary();
@@ -444,3 +440,11 @@ int main(int ac, char **av)
 
 	return report_summary();
 }
+
+int main(int ac, char **av)
+{
+    pteval_t opt_mask = 0;
+
+    __setup_vm(&opt_mask);
+    return run_svm_tests(ac, av);
+}
diff --git a/x86/svm.h b/x86/svm.h
index e93822b..123e64f 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -403,6 +403,7 @@ struct regs {
 
 typedef void (*test_guest_func)(struct svm_test *);
 
+int run_svm_tests(int ac, char **av);
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
 u64 *npt_get_pdpe(void);
-- 
2.30.2

