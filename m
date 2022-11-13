Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7E5627121
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 18:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbiKMRHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 12:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235317AbiKMRHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 12:07:21 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E4ADEE6
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 09:07:20 -0800 (PST)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ADH37BU023444;
        Sun, 13 Nov 2022 09:07:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=Pvvx0nte5vYUH5z6zmOXZp5jM66q/QE4kRQOttYkTes=;
 b=oOfxqSnYhOOUDHOVPxLkOtJI244RgwS2F5HnUBQtZ+LEFYhBXlx+cSF5ZpKiTg/C9kdG
 eue3tXFrfRb5i8ow8PsD9oKgKGrCpBsOXL/6EzL2ld0Ur+XWvcYWn5148fRni5fjG/fL
 CZ4b3ubVDgL9dC0WMMMC8BO4OsEQ5oaa7hacTAhplWPmUI5Ft9lSl64/5rUCEpdJv2yx
 8Ca4hkOqlcfL2SgqHnCF6citYpMJIpg2jAbg9e5EehcEYzNFYvwcjnwANa2mQNKoNsag
 RgB09i+/BEqxQrqMTHOvA8EYgSwZyLaYPu/BycAarRGAXTLZtRGrQ9a8x4b7fkLjlT2V pw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3kt9wdt6tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Nov 2022 09:07:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZCNsqSYbo7hiwcqTEvrf8e/R/6/6fyfP/ZkOEEFzxwJIQiZBpKk7AzRjfS4S5cIohlTNr3TjHtmgJOWkfeYpA7VKvufzGRGB0GqD5KDxIAecnGZ7Nrxj663m2JNh2ecEkd7oWXbi7YkZ/OwvRP0NyJ8HCjcMI/4u6MABhKPkVhz8NVsybt9PjGz+G/EA2X0cwjyyHGaCKYOn7Lb0bV2liygf00JUrK4y0RV7hFAo7r8IlATV3A6pbPhIwLl9a0OewwjyN2USs79BKHJLiG7Fw9Eu1RaBKTV5j7h6t/pC8OXhXs3z9N75OYotEH3J12X6CylK/qJuDK57ccZvKas4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pvvx0nte5vYUH5z6zmOXZp5jM66q/QE4kRQOttYkTes=;
 b=G7ySgWE2brwp69b95dgw81hgQxYKNditCB/sJyRZ17Byb/qZ01gzncEsOg3JsQFwPTd4RfeE2B9DfDjSuOyZWVkyRGxgu5+/akwYrP0ASdgtLhLsZSi8vS7Od2P7IdnjluJ7xiMbkxoCmb3/LZuT1CtEyWNlxIn+BYB4mnQaR+dqJDLaRlZQpvgHc3etHTWlXgcvssDq7QJ8RgLz/xqvew95LI4qpX9k27+FTiyCu2Oy81EucX31p9AAKNYV+IPHAYM7yLRBGOQy3HjZB/ura0idlFepu2DWAlW5mYA+pN6aVXkk3FHq2QVS4BQVxxxYLF/nj3r1nLRGY48qPg0bcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pvvx0nte5vYUH5z6zmOXZp5jM66q/QE4kRQOttYkTes=;
 b=yjjFLONW08dQXLroCAoxNcLjlQRGt1v5ECjTLSFQ5gFpCWSpncS8r2bFQGgWaik06Dsw/OQwOa+P7uVqtC8V03cWv6BNRDId0Uz2KSrOjhyrgU9KDAUdwrImwC0NFjp6oQwuXfOJQVbghHh/oHmMpmmYOs2iQc7a3g/qFcUpTRyldJNcQGhMbhWcAj1Wm+NR4tSZjELb3+zdDZMI9h5++o1xwTjWKcL8FPG1VtmkYc7QO8MC6eoICDf6SbakeZ0Kex8lQiVks3t0KM1WOmTtcl+1eZcB/lk420uxcpjxaCP2Vs6eIV7cgN7+DGCplBPi890Ohvo29RgDALG0icxBqg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6723.namprd02.prod.outlook.com (2603:10b6:a03:213::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Sun, 13 Nov
 2022 17:07:08 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c%9]) with mapi id 15.20.5813.017; Sun, 13 Nov 2022
 17:07:08 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v7 4/4] KVM: selftests: Add selftests for dirty quota throttling
Date:   Sun, 13 Nov 2022 17:05:12 +0000
Message-Id: <20221113170507.208810-5-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::20) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|BY5PR02MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 562f6f75-fca4-48d7-978f-08dac5997f14
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MLIFKy2jTk+a0wFkH5ZZ7MWtP7WGEeKCpIHcq0HQZRrxRVfuLs8kUX2G2wJsMPG5FqM622RnCeZGquGvAa7gSFrFgtTWxSaNB1VNzkm8mfXT44dmWKBOGEA6pgfzQh9OPpF33mptcn9bAQfgk05e5atAziucazpDOPMYLBxBt3eVxkZCTb9pxn9AddkVHihkRI8LPWrIk9SuYcqjkSdnGwoohtN8y/LUkPyztpU0jagxbkGdX6Xmh4r908xIJjA6BuMt7OyxyWhfnGmmTnakZSWybEON9V4qAgYZoi3SvcwNwKm4h2rvQDlNNi6Zih1kyBas1hD2n57SGdg1M38zIpdwCKfEHEpez9g1cO0Q8QnjRwTYKsVmPWJd+RhmxhUbnq3GY5qQo8drYBARCQ7HKzlHWXjczG3GTrfC4FwDo2wGgaFrN+oNzU1pkA91GMiSt3aH3+2kbjUy+9pm5FFvWXUB+SEBmNNVmPhPNERYA0upRNFkrGE4qhOCwRrM4vaTtE03cRm0HomXOd57qRhJXprJw9g7FwPSYS5sTTGmKE12UQo2GR7bw5m7Ha+xgOugpBL2BI7wsoBjKSieL0/qrt5v1s4ZK9kfu5tcLcQfhxGxlmKZOraKtnMGlxToeSCKVZsUak3+cem/Ng5gyAgjZJ6xRJMNZiCjC19izJDcxB2Bl6mFE2sx60Xw96YVO1qXVepUB9dl0A3DReDHIROoRadN6j7prq18Z9B/mpqkPesKnSmq+X/QOGOZoZqhsKfa1fGKjim1DE35eOZAGf9iS/NMRVHoGnyru+9R9t4NHkQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39840400004)(136003)(346002)(366004)(451199015)(186003)(2906002)(15650500001)(38100700002)(38350700002)(86362001)(83380400001)(45080400002)(6486002)(26005)(2616005)(6666004)(6512007)(107886003)(478600001)(6506007)(52116002)(41300700001)(4326008)(5660300002)(8676002)(66476007)(66556008)(66946007)(1076003)(8936002)(54906003)(316002)(36756003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9ZjpDx3ihK/J6nrcwyumZOFLOjhTAoNAU7GxdQaosur1f6UJDnVNaJKmswbr?=
 =?us-ascii?Q?9CGNLvoi3UpkL0Is/cR4As9O6yNXMT4Gb9gEEl0ufdyQmePylsmwB//q7Alv?=
 =?us-ascii?Q?xgUK/0tK4MKG+eAT1zHI+ZCL1u0HT/JfMhsRoFqIY6oZqiwXq/uQSpHvDTN0?=
 =?us-ascii?Q?TSbBbxRsIuVoyayy5rLqpGgZaOR/yeBalL92A6y4d/eTPQrobbocYB6JkWFA?=
 =?us-ascii?Q?eh3DtB+ikU5fqaQ94UtGvk7DpU332zVSepUkG5qQwN+ft23EHHwDUIRULL9T?=
 =?us-ascii?Q?ufdwdt4vxsns859ocf/AcBmD9MJE+E2VoXfTc+6S8LU/WOCUzcskqub4Zbyv?=
 =?us-ascii?Q?EwWqxHVwmqwoteNFS2xd+Y0QJo519LAgHA3MKgT/XX6s6rP/Kh8sQQkh89BI?=
 =?us-ascii?Q?LK4oxxtzDtDmwADurt+DlP3EbiWuW5NUXc/cHzN/RrZyy+fGCgYEOQDyC/ir?=
 =?us-ascii?Q?a6Tyu6z68Hab+Np7IXaegKJ9QX9Xb/6jwEBEThZkV5/RyP2UKahTOymi4GcK?=
 =?us-ascii?Q?DqDojSY12doFEXhiAgt1UnOxNWtVRJBKklYB0TCKmY6N1h4ONlKyoW1HXrOb?=
 =?us-ascii?Q?QhbAiZ065nt6RqWWouuFXUADlZTsBpuYumhyehDu9jN4ZFdIRB09Ym0NTh2b?=
 =?us-ascii?Q?o0yNo9L6InfsZoaWbr79kMt1mJ0RPl1SoD74oVm1FdwfQ58K7Yv+k6jt1AIP?=
 =?us-ascii?Q?5iCJGBpMt0IfPZjLW8/y+8m6+Ox1eMaXHGOMYu1gkjWtVnuFDGOaLOn2z7pn?=
 =?us-ascii?Q?/V8EjmgB4auizUow58FBoIQta3hKyhwEVahXlMA9CYvYkuR2AYPvre7aSQTH?=
 =?us-ascii?Q?/xYMig2jJYAfLxMFm0PQyr+/RQARTTz/komTUaNxohrJ4KsutpQzZtyer2re?=
 =?us-ascii?Q?KwYaNEkGf38kxH42RaEvayFjUlZ7CLxVuLzMrnoz0E478nIPF7LPLOYhzBPn?=
 =?us-ascii?Q?9oVnFjpyr/Kw3FudukYSZ3TGf5OvD6t5KcZ1kINpz8ksjk9DMU/t2KF0tCpz?=
 =?us-ascii?Q?MQE0PWU7dmgJ09RXs8hGIIArPpU0xyXqv7x1MOFA/IndBFqPcOJ6J+le5xCo?=
 =?us-ascii?Q?Lk8w1T9CQmiFOLpOiZqrl9Pmo/D0MPWc1DuNwG5M1/WcTdM7XaDCXGjjOeiu?=
 =?us-ascii?Q?U6r1H2oqg81ELHyOmxrDC0DLf1W719+dTX2jijebhlDA9kfOuoZI4jM8zY8F?=
 =?us-ascii?Q?VvB2Bqu86cN4r3x/0wiHZO2c01hyZCneLgf4dmcV0qTfIDL4VEXa2sfHPsdq?=
 =?us-ascii?Q?2ou4McPUQuOzu/bR8jnYhXNcN/c9xGz4g4ymbE8qeI49y2Biyq+e3+1KB6a/?=
 =?us-ascii?Q?Cvpi3IjqBmYK2HVp0G5Jqt/wup9rVVB8hqQXkvDuUiQZ8K3ZYjVzzMC/mNM+?=
 =?us-ascii?Q?jY96QC776jUw7+le2nI9GSvNdLySNSphioAcEy1ETyJunsauj4xbioCtOOsQ?=
 =?us-ascii?Q?DhQugm3dS8fJJNwrZwinFLRaX+YrWcx+b1u6PS+oTyiTmc39uLsLT8cgHXGx?=
 =?us-ascii?Q?KpBvqxBZaz2pQvRnD7fZOlNbp9GKswVB5oZI1DzUx3OSnUnWn7t+aba2ZoHq?=
 =?us-ascii?Q?f7Z0D7pLOKu56fOyvsKsU3f+M78gOCLku1qFEud5nOsCoO8Kbry0+BHLl4WT?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 562f6f75-fca4-48d7-978f-08dac5997f14
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2022 17:07:08.0320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXyaK3fSNwRr/cfpVJ9+GJqtyjSdzTToprQ935G8px2xsHbX/rzxIFG0898N441mORPW2OxX71PowqUBHUUOZk3UdWKi0lX3PAb68zwpxKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6723
X-Proofpoint-GUID: W4SKAKVvTp4WjXnXnlakcpPWGUQNlV23
X-Proofpoint-ORIG-GUID: W4SKAKVvTp4WjXnXnlakcpPWGUQNlV23
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-13_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add selftests for dirty quota throttling with an optional -d parameter
to configure by what value dirty quota should be incremented after
each dirty quota exit. With very small intervals, a smaller value of
dirty quota can ensure that the dirty quota exit code is tested. A zero
value disables dirty quota throttling and thus dirty logging, without
dirty quota throttling, can be tested.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 33 +++++++++++-
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 53 +++++++++++++++++++
 3 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index b5234d6efbe1..a85ca6554d17 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -64,6 +64,8 @@
 
 #define SIG_IPI SIGUSR1
 
+#define TEST_DIRTY_QUOTA_INCREMENT		8
+
 /*
  * Guest/Host shared variables. Ensure addr_gva2hva() and/or
  * sync_global_to/from_guest() are used when accessing from
@@ -190,6 +192,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 static enum log_mode_t host_log_mode;
 static pthread_t vcpu_thread;
 static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
+static uint64_t test_dirty_quota_increment = TEST_DIRTY_QUOTA_INCREMENT;
 
 static void vcpu_kick(void)
 {
@@ -209,6 +212,13 @@ static void sem_wait_until(sem_t *sem)
 	while (ret == -1 && errno == EINTR);
 }
 
+static void set_dirty_quota(struct kvm_vm *vm, uint64_t dirty_quota)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+
+	vcpu_set_dirty_quota(run, dirty_quota);
+}
+
 static bool clear_log_supported(void)
 {
 	return kvm_has_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
@@ -256,7 +266,11 @@ static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 	TEST_ASSERT(ret == 0 || (ret == -1 && err == EINTR),
 		    "vcpu run failed: errno=%d", err);
 
-	TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
+	if (test_dirty_quota_increment &&
+		run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED)
+		vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
+	else
+		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
 		    "Invalid guest sync status: exit_reason=%s\n",
 		    exit_reason_str(run->exit_reason));
 
@@ -374,6 +388,9 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
 		/* We should allow this to continue */
 		;
+	} else if (test_dirty_quota_increment &&
+		run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED) {
+		vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
 	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
 		   (ret == -1 && err == EINTR)) {
 		/* Update the flag first before pause */
@@ -764,6 +781,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	sync_global_to_guest(vm, guest_test_virt_mem);
 	sync_global_to_guest(vm, guest_num_pages);
 
+	/* Initialise dirty quota */
+	if (test_dirty_quota_increment)
+		set_dirty_quota(vm, test_dirty_quota_increment);
+
 	/* Start the iterations */
 	iteration = 1;
 	sync_global_to_guest(vm, iteration);
@@ -805,6 +826,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Tell the vcpu thread to quit */
 	host_quit = true;
 	log_mode_before_vcpu_join();
+	/* Terminate dirty quota throttling */
+	if (test_dirty_quota_increment)
+		set_dirty_quota(vm, 0);
 	pthread_join(vcpu_thread, NULL);
 
 	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
@@ -826,6 +850,8 @@ static void help(char *name)
 	printf(" -c: specify dirty ring size, in number of entries\n");
 	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
 	       TEST_DIRTY_RING_COUNT);
+	printf(" -q: specify incemental dirty quota (default: %"PRIu32")\n",
+	       TEST_DIRTY_QUOTA_INCREMENT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -854,11 +880,14 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "c:hi:I:p:m:M:")) != -1) {
+	while ((opt = getopt(argc, argv, "c:q:hi:I:p:m:M:")) != -1) {
 		switch (opt) {
 		case 'c':
 			test_dirty_ring_count = strtol(optarg, NULL, 10);
 			break;
+		case 'q':
+			test_dirty_quota_increment = strtol(optarg, NULL, 10);
+			break;
 		case 'i':
 			p.iterations = strtol(optarg, NULL, 10);
 			break;
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e42a09cd24a0..d8eee61a9a7c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -838,4 +838,8 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota);
+void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
+			uint64_t test_dirty_quota_increment);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f1cb1627161f..2a60c7bdc778 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 
 #define KVM_UTIL_MIN_PFN	2
+#define PML_BUFFER_SIZE	512
 
 static int vcpu_mmap_sz(void);
 
@@ -1745,6 +1746,7 @@ static struct exit_reason {
 	{KVM_EXIT_X86_RDMSR, "RDMSR"},
 	{KVM_EXIT_X86_WRMSR, "WRMSR"},
 	{KVM_EXIT_XEN, "XEN"},
+	{KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, "DIRTY_QUOTA_EXHAUSTED"},
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
 #endif
@@ -2021,3 +2023,54 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 		break;
 	}
 }
+
+bool kvm_is_pml_enabled(void)
+{
+	return is_intel_cpu() && get_kvm_intel_param_bool("pml");
+}
+
+void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota)
+{
+	run->dirty_quota = dirty_quota;
+
+	if (dirty_quota)
+		pr_info("Dirty quota throttling enabled with initial quota %lu\n",
+			dirty_quota);
+	else
+		pr_info("Dirty quota throttling disabled\n");
+}
+
+void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
+			uint64_t test_dirty_quota_increment)
+{
+	uint64_t quota = run->dirty_quota_exit.quota;
+	uint64_t count = run->dirty_quota_exit.count;
+
+	/*
+	 * Allow certain pages of overrun, KVM is allowed to dirty multiple
+	 * pages before exiting to userspace, e.g. when emulating an
+	 * instruction that performs multiple memory accesses.
+	 */
+	uint64_t buffer;
+
+	/*
+	 * When Intel's Page-Modification Logging (PML) is enabled, the CPU may
+	 * dirty up to 512 pages (number of entries in the PML buffer) without
+	 * exiting, thus KVM may effectively dirty that many pages before
+	 * enforcing the dirty quota.
+	 */
+#ifdef __x86_64__
+	if (kvm_is_pml_enabled(void))
+		buffer = PML_BUFFER_SIZE;
+#endif
+
+	TEST_ASSERT(count <= (quota + buffer),
+			"KVM dirtied too many pages: count=%lu, quota=%lu, buffer=%lu\n",
+			count, quota, buffer);
+
+	TEST_ASSERT(count >= quota,
+			"Dirty quota exit happened with quota yet to be exhausted: count=%lu, quota=%lu\n",
+			count, quota);
+
+	run->dirty_quota = count + test_dirty_quota_increment;
+}
-- 
2.22.3

