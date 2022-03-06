Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F9B4CEE3A
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 23:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbiCFWoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Mar 2022 17:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiCFWoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Mar 2022 17:44:03 -0500
X-Greylist: delayed 1914 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Mar 2022 14:43:10 PST
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF83329B7
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 14:43:10 -0800 (PST)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 226KbxBp011928;
        Sun, 6 Mar 2022 14:11:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=2se+xk3aWAhcZZ2B2hIF5uaud4QQgZ/Fchj7rN7SAgA=;
 b=C8CBVF9ABdZHxkfSeA9rMAxNSDaCpXm4IhbAdWnft4eOGkhJ1TlBdKotWB/NA1KylJqH
 jGYGWbbSHsjOoY5JgMbdOqBPkbqucwXkwdQbrOU2cJlaCl77gJhNuKDQ6TZdZsU93YJC
 7DlvBjL7ZYOUE+CnJ/KjL+d1qanUJg2Og/AlDCX5GkL6Il3+9/KX8nhmrmGMfcJ/MZVg
 bZT+PQZJPXH5RhPSNBeVCoSmJr7JS3G13EugwKE0ohNte7EHKGsqMv6M4FIBKCQ1d29M
 pv8tBXDzOdYTZCxkomMOvywRHIuMepfu0mqz0sWH7Q5Kfn6BtI+U6GvLHAKQyOHq6wL+ OA== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3em894hwhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 14:11:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YViYwp4PGZ7Hqz2pddvcFTcc9QJOLiGaF1TvNPoVU5A3z+T9HX32AWPP9M/ccgBQSDK3NHYwVDEC5/9CHUamxfLRUUUyEB99rBOuPNHq1ttoS91iAkXsY2Y8KWCHHj3y0+kNG63ajU8m0S6FER1zrLAYTjSwBYcMvd/W/e3yNZJwg6FJzLPcHbLIPE/9HRTc8o7zqA0b58bQi5PKNm+4QXJ2Zog78TtltN+yt/e0+eQ/F3dM7aZwvqHahT5rxDh66xhY7SJw36mPKyvWahkh3bDhYVdbAwTzyupVBdWjJaama2uu+6Ovqogl2Ew/0YDtMkiu8epP/BQN6IjFfgM86Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2se+xk3aWAhcZZ2B2hIF5uaud4QQgZ/Fchj7rN7SAgA=;
 b=f6F5z0y8J9EsDH/NmyY5wgBJcSC9jDUarJjUUyQqo5WiW/opYjXK4Df6aQNZOvupe5T9YDREvPi60S449XYU+tUTjk0GDYJzEX17wVP5kkoDhBX3BnNcZE6j+axIARCVY48eG9OSKYyaQ71OcVHFAOcO5vZ8pODL0z37dkMKwDmoexEttygCpI8IpbUb8vpTuKZrojnt4VdP++3Mg0B4JzKztQUdc1fCjxy/Zq/uhScxG7FeZGsHkpSecvqOBbQYbp2ziS3UsXiRCCrGFrvynj1gZLtFVIeFlyqvwWtbYKqaj42Bx1bWdex1BSNMGUUSkoqKp+I9RqGPSJ4/+k5l/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BYAPR02MB5495.namprd02.prod.outlook.com (2603:10b6:a03:95::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Sun, 6 Mar
 2022 22:11:11 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862%8]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 22:11:11 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v3 3/3] KVM: selftests: Add selftests for dirty quota throttling
Date:   Sun,  6 Mar 2022 22:08:52 +0000
Message-Id: <20220306220849.215358-4-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0155.namprd05.prod.outlook.com
 (2603:10b6:a03:339::10) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d64c25c-27ea-4acc-2209-08d9ffbe38d2
X-MS-TrafficTypeDiagnostic: BYAPR02MB5495:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB549576C709BEB3FC2393658BB3079@BYAPR02MB5495.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MFpcS0/+TOm5flceujpWuBivBtX/pVsWwv3eDacxFzGkv+iZz/ABO0S9OqpZ66/ZH9wEZQZyQ1kNilTAnKY86HxRGShPtMOislsJrycE98IfO0Zx7qSPqlfPsIjVmpqEI17LPr4nk/lTaNwMP+x6PRKy7E8zRM08Vtq/gr+m6j+KlMm4S9Ibdu5VXYaEdlh+uOj6+4Bd/BjcQMacdsztL5ZUvzwa73077pKGN9muNgpKyOEY8fKw6vfs8aH6D5ZReO9DBXoPNPx3YLFAdouPQCBmKKobFlExrkKAuOyGWa5bETjP1C704rY6drnpvjm4WPdzSIRoozCURxB8OXf+/tOW1UYdINybwBcg+plZKAkgjTI4mTjFkeTaDjQLmiIROmqpw0ae2fInlGGWCH2OazsXGXEmOZcuJUcUcNiPcfKLCgBCyFIEC28XihI+IRKGNQv2RPBfPoflLvRHQa6MXgijwwOIlkugEYfAscMSnFAJtQ13rj1B8PF5P4TI59BfaNyEzUAGufevegQIrFwMrvfK4JXBy1LS8LZNgmYUuGXGQ5ljc/BN51G52+hCVID16C1Qvg+L85WG9//TLYFM50HnlM1Ylcbk/anfpAB8Z9wi5T7WLQcJMewHPAc5be+y+O0VRCpAInXzsbS761J2xGb1d6/OFlUJ3aaE63VecT/ak+zFeqYTo9IVVw0Q7tQyUsj3fHmiqO4UCjXCd9xoG9ZIKMrIIv5dn5uoDj77FM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(45080400002)(15650500001)(86362001)(2906002)(508600001)(8676002)(66476007)(66556008)(4326008)(6512007)(6486002)(6666004)(8936002)(6506007)(66946007)(83380400001)(52116002)(107886003)(54906003)(38350700002)(1076003)(186003)(26005)(36756003)(2616005)(38100700002)(316002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8JnxwxITW+ATFsHicuUC45nyzaQ78iCqYeuacKvjnSfOv2co6BJ3lRdGnVXt?=
 =?us-ascii?Q?gorOLBdbX5yxWWtarIrX2y7KJLzSzi4yO7CMFLuT3C2mWgzHxkb1qBdKWHAC?=
 =?us-ascii?Q?MGPn42XcXR9s/OSu2xIl/8mULUqT/yCxXC2Jb1fsD5Y43SnVcSmvddFkvGPW?=
 =?us-ascii?Q?ersA/5mHW/3CN78d1gW4sIYz4JTz1JvIsS/y4CXS1Ljl66SEnkEoo41MMVlZ?=
 =?us-ascii?Q?woWfOQpjqzgsnUi7D7VlBbE0HxoakL3FRFfoBDp+9mROYWh/YBoif2374Hei?=
 =?us-ascii?Q?0bcR/l+tkClL9VFQ9QyZRmIcmZLmR0dSfY66fL8rbAjmcf6A7IFO95845c5m?=
 =?us-ascii?Q?9HVXX367AgjmcNi+CGJpcP8rkUo5Hytju3gOgMah3hQ+7fRrAdrioSBrADrq?=
 =?us-ascii?Q?08Sea8M76g4NdBtktl+OhFwDYg5vMpcMSwl+hpLN4jZEhF9gOGARtBbWNe+w?=
 =?us-ascii?Q?TE+ee0AaC0dziDIY22gTzLfpdtyWgYfiP8UDrpyHNSLoBR3juDM57R4cCiFP?=
 =?us-ascii?Q?ptXkjISYE/Pitnzek4Tn6SbdsFITfgBuffSkcl0mL1HRcXd9+kNNsHXwJZ2s?=
 =?us-ascii?Q?w4LNtKuc0GmkJJNa2XN0eMkbuUUCQJa7nD9BjYiwDFlAPxqKSLtZ4vzMY1by?=
 =?us-ascii?Q?Oj81mEK+xXApp3mMcpLDX5smeLSJ923wpq2xZrbQUVPqJmv7naon1R4iDV68?=
 =?us-ascii?Q?b/DJ3RbkmZpKPjf0nS+C8cHNQm8heZSDgJw/VOnSxH/OyQtboISDn5w0Ulmb?=
 =?us-ascii?Q?d1GvzbZ68q8HRBo9CXGq0fvtDjT4bmns3xGWI/cBGVdrfvEm8tmBsxb3IioA?=
 =?us-ascii?Q?smEEco0Dk9Yu4uWRGARnWUvXurknMXYZy4NFchGo+ROVYOhV0q3F0ZTE67b7?=
 =?us-ascii?Q?99uBPjvO3CLv2klTU5YXE4OUrZC1D7kCYBnkLl9uyFwAYOCgEldSxVWk5qO7?=
 =?us-ascii?Q?9rQPCRLgAU8O4mCxcrO+jlBMrQl7ZybWpb8V+8lY3evdBiUFwY4/5pnGfCyu?=
 =?us-ascii?Q?1wIFpi2K5lufmVliR90PgOLMFhwQKtFhMYjDGK2Oc8U82o511yE8kYztQCeC?=
 =?us-ascii?Q?ueJxOg572fRmWCeXk+NQspWxUDK9YNILZjbOM0uFNxfP2nadfY2qgo5x6fH9?=
 =?us-ascii?Q?rJINfdfgjoJvzBB4bQyyEbFukn5yt9Btwfu93PIEDmLtn1RZK2jCmJNA72VC?=
 =?us-ascii?Q?WAZ0cbQS5XZvhD8muTIiV12dPUpYCWJ0AQFL+X8ioM+WRkv4mmGqm2Cm4esH?=
 =?us-ascii?Q?tRKEFD/11QnnIcUXm09rxIVeNVgC+ewAUUOL65Tl4QprJ3/urZcTgIDLynsc?=
 =?us-ascii?Q?1HaLLVgy+ncPs8PenuzCX22/FXFm7HAj3j7O6yT0ucdZjDFT53kbSrwHGa7v?=
 =?us-ascii?Q?yBlWx5VXCOP0nltdZfXqkz1t+fYW91XynovUHOiUD4JR1WS2tB+3M4K4IN14?=
 =?us-ascii?Q?hxPee6hfbflimDKKN4pk8qkX0+woYkaFkKEKBwfgLbxa4WGRqBSraOLVeq30?=
 =?us-ascii?Q?Qb+RfjdzVwAzNVXTFFn3Nsw6ISa2IxLiOnfynMwyTQdYYSKJV3tuncfli/Hy?=
 =?us-ascii?Q?EfAwZyVKjB6sPf/kv34JJelDBVB8NRES+l+3zf/RR/MU7dJCsXOX3wXWcQql?=
 =?us-ascii?Q?XAkZwRPDIJI1CAHQOREumlzYmjydi30As6W5kg1spekTVb7wToZiZD0xRn4Z?=
 =?us-ascii?Q?PQk7+HwbKXoDqaycubzYN0BKshU=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d64c25c-27ea-4acc-2209-08d9ffbe38d2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 22:11:11.2893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /7e6VYAzviWyAst7GrkijCVtb6HfglPSPVQlYGO20u8WuvmmSKP9XewoUWZTmwlBE1dETYUSW8hE+y/dXqbXH0VF4e7UvbXt7+y6mAHxa5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5495
X-Proofpoint-GUID: EV9UlTZfEI1VCYI9VkTdN-kdf4taSDL0
X-Proofpoint-ORIG-GUID: EV9UlTZfEI1VCYI9VkTdN-kdf4taSDL0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-06_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 tools/testing/selftests/kvm/dirty_log_test.c  | 37 +++++++++++++++++--
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 ++++++++++++++++++
 3 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 3fcd89e195c7..e75d826e21fb 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -65,6 +65,8 @@
 
 #define SIG_IPI SIGUSR1
 
+#define TEST_DIRTY_QUOTA_INCREMENT		8
+
 /*
  * Guest/Host shared variables. Ensure addr_gva2hva() and/or
  * sync_global_to/from_guest() are used when accessing from
@@ -191,6 +193,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 static enum log_mode_t host_log_mode;
 static pthread_t vcpu_thread;
 static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
+static uint64_t test_dirty_quota_increment = TEST_DIRTY_QUOTA_INCREMENT;
 
 static void vcpu_kick(void)
 {
@@ -210,6 +213,13 @@ static void sem_wait_until(sem_t *sem)
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
 	return kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
@@ -260,9 +270,13 @@ static void default_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 	TEST_ASSERT(ret == 0 || (ret == -1 && err == EINTR),
 		    "vcpu run failed: errno=%d", err);
 
-	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
-		    "Invalid guest sync status: exit_reason=%s\n",
-		    exit_reason_str(run->exit_reason));
+	if (test_dirty_quota_increment &&
+		run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED)
+		vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
+	else
+		TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
+			"Invalid guest sync status: exit_reason=%s\n",
+			exit_reason_str(run->exit_reason));
 
 	vcpu_handle_sync_stop();
 }
@@ -377,6 +391,9 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 	if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
 		/* We should allow this to continue */
 		;
+	} else if (test_dirty_quota_increment &&
+		run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED) {
+		vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
 	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
 		   (ret == -1 && err == EINTR)) {
 		/* Update the flag first before pause */
@@ -773,6 +790,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	sync_global_to_guest(vm, guest_test_virt_mem);
 	sync_global_to_guest(vm, guest_num_pages);
 
+	/* Initialise dirty quota */
+	if (test_dirty_quota_increment)
+		set_dirty_quota(vm, test_dirty_quota_increment);
+
 	/* Start the iterations */
 	iteration = 1;
 	sync_global_to_guest(vm, iteration);
@@ -814,6 +835,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Tell the vcpu thread to quit */
 	host_quit = true;
 	log_mode_before_vcpu_join();
+	/* Terminate dirty quota throttling */
+	if (test_dirty_quota_increment)
+		set_dirty_quota(vm, 0);
 	pthread_join(vcpu_thread, NULL);
 
 	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
@@ -835,6 +859,8 @@ static void help(char *name)
 	printf(" -c: specify dirty ring size, in number of entries\n");
 	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
 	       TEST_DIRTY_RING_COUNT);
+	printf(" -q: specify incemental dirty quota (default: %"PRIu32")\n",
+	       TEST_DIRTY_QUOTA_INCREMENT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -863,11 +889,14 @@ int main(int argc, char *argv[])
 
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
index 4ed6aa049a91..b70732998329 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -395,4 +395,8 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 
 uint32_t guest_get_vcpuid(void);
 
+void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota);
+void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
+			uint64_t test_dirty_quota_increment);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d8cf851ab119..fa77558d745e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 
 #define KVM_UTIL_MIN_PFN	2
+#define PML_BUFFER_SIZE	512
 
 static int vcpu_mmap_sz(void);
 
@@ -2286,6 +2287,7 @@ static struct exit_reason {
 	{KVM_EXIT_X86_RDMSR, "RDMSR"},
 	{KVM_EXIT_X86_WRMSR, "WRMSR"},
 	{KVM_EXIT_XEN, "XEN"},
+	{KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, "DIRTY_QUOTA_EXHAUSTED"},
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
 #endif
@@ -2517,3 +2519,37 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
 
 	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
 }
+
+void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota)
+{
+	run->dirty_quota = dirty_quota;
+
+	if (dirty_quota)
+		pr_info("Dirty quota throttling enabled with initial quota %"PRIu64"\n",
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
+	 * Due to PML, number of pages dirtied by the vcpu can exceed its dirty
+	 * quota by PML buffer size.
+	 */
+	TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of pages
+		dirtied: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
+
+	TEST_ASSERT(count >= quota, "Dirty quota exit happened with quota yet to
+		be exhausted: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
+
+	if (count > quota)
+		pr_info("Dirty quota exit with unequal quota and count:
+			count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
+
+	run->dirty_quota = count + test_dirty_quota_increment;
+}
-- 
2.22.3

