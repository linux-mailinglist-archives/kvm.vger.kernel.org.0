Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F345B5301
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 06:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiILEMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 00:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiILEM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 00:12:29 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438CA17A96
        for <kvm@vger.kernel.org>; Sun, 11 Sep 2022 21:12:26 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28BFtwCS010580;
        Sun, 11 Sep 2022 21:12:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=2ruFcqmhurpAOnfoBpr0QPVZrCJT/wNpd0j3CjSIO1k=;
 b=HqTJRUYpksA4IRycwDCdJplraZ2hTXMIhXMtIuWEhcWj7JzJ4RfAwACFhiMG/3W28Iet
 yKhAMOg4CJ0DtxolhNreuB+WIpPRS8PmUr6tCdGOxM2jUvoIcHVu60n42xKdLsIKrcru
 WaodV7EMc8bj9OJW0kppuTfKcq2Cfr7qwSv4moR1Wnvu0FRVaegQHqN5REzZi8PHku1p
 USP4YbCUmvkIxqA9FIEw//ws5d87EcXujBcIyD98gi4mNhpyiGYH77Q6fAzQMTDG2Dng
 g5hvmewbVwaMpAPpyXiVTZzJLcmtJL9k+2CKs4yNqtvvUra8ZwL7yMPYiDgXkK8ZkvIL PQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3jgpwtjwk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Sep 2022 21:12:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8IYb/5BF/bzrpq3gFbCFINwMdw/L1Eo+A3T08oUgf/N4hwnJdr7/K9OU7EJK2Ig+q6bZeDy3KT879wHdJf+PR3L0yBVEBWqbxk1WP9hN3bQGGg010+Y7fGqjzj0jcyLT5sfOPz7rGZMMF/9OuppkXYGfbXC4D7gIr+Z6ggpbYpIkrsx7XDdodYAVic1pWt3WH03eDElgmh1AWHodT1fG4aq3RcgrTHIeG2UfFaedFM7Zdrh0DkUbZGUcPLfKIeFUaKhL2fZWPQ+9+srEqTSNhcY4J+AUjimGsFvMPizy7l+CWpH9jhVlHH/ZY0cy7ulR1v8SqmUXQt4rekT9rMdtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ruFcqmhurpAOnfoBpr0QPVZrCJT/wNpd0j3CjSIO1k=;
 b=K7O3pKFX2lI7iuHpM4K7lqGTg3s4oUu/0UGHFPLgPB3Y0e39anjqBEG4wFP1U7UxUK10oGsWGyW7w84WOPYKFOLQ0Gab4AfmpxYQFiKheXPPZF4UDB++8QxgoYWqRj7kDk0SGCVNP7RGDDj/WgCGvy9ZflFr6xpUjacwX15Po+33b5VB9+WgNQHVSffn2NeYW7rJzlc4zVFy+yDCg8kWkggEfGeg85ek2lASefeJnzj4EQQ8SciX8YA2YzxSWDLBdeJ61HMUgZ8zcQEW1gq5vM7G8qYBKbvGTirUHVu5+lybblltcLcfft+kaG6qGmyjm5jpM6ve5hzyuHc0Fhk1Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH3PR02MB9116.namprd02.prod.outlook.com (2603:10b6:610:144::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 04:12:11 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 04:12:11 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v5 5/5] KVM: selftests: Add selftests for dirty quota throttling
Date:   Mon, 12 Sep 2022 04:09:32 +0000
Message-Id: <20220912040926.185481-6-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220912040926.185481-1-shivam.kumar1@nutanix.com>
References: <20220912040926.185481-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::35) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CH3PR02MB9116:EE_
X-MS-Office365-Filtering-Correlation-Id: f9ff0ae6-bbef-429c-8771-08da9474f753
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56NK1rJI/+TpeWxhmZFpHhLYhB6tgqZBwZEzpXkT6CdlH8WBsDPV0SWNv5Nu3+zsnOxQwgVhQYZ098KXKRTJXX1DZDqxMcP+t7slNjLcSQ5PlQOlHQLuKg4bIYrKTtUBrPWIVGFlFJF4z0IkWMaksi4CxJn156dAIjuL4CpkmLLucQbm+eaJPTz2XfoybWRAsMQNqYa492OB/kDGcljr1A4uwWNAxGvLnOGjJwKBqQIJD3OcltdjfdY89lnDMwZlYl66woQ7/yUnxv4eEjbPQcoHcbMPfjATifY/U0EaGE9zJgb1pJbMk+oQhE5yOAQxjnth3Q1R1kwpNXJVbtcu3xK74rARmNiygwtL78b1qwMC3y9OBKyzPjLNNTfNjOKH98xE9qJmbW+ZRZSFxpbNJxmSBMC7cdXEUh1TtYgJkXMFI3sRrCvE4N+EKk8RUfVoGGoxMB4546GBgHeBOXZTrjtfCAcPHsT0NV/Lnlj4UtYqv8aQULQNN4Y7jITvnw7t/6Qoh9iKtBcmhx9g1wwWHdr1ILNttI4mVAfCOipccUXJ0tCX2+Mk+zkA0M3gk/08B/cb/RrbVlH6Zh8c4XfGWLijU341/jIYHepGgvn4uQbgr7NwUsYOW07qtPGUnoZEb6w+BfVDfpyRRHlZTQQ/VazlcN7tBlF6OQAYS315KYMv2SH0boBzDfT/VJ3PleYgw4sP4PlejtEHQEWLARmjViGtlXF4zHMjS34ydkiFTL6xF+eGFZ1pZbdKjuWp2Sap+HBWzhVZ1J0NA0liG2j83W++tW24q++c42sUE9nsIVU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(136003)(346002)(39850400004)(26005)(107886003)(6512007)(52116002)(41300700001)(45080400002)(54906003)(86362001)(6506007)(6666004)(478600001)(6486002)(2616005)(1076003)(186003)(38100700002)(83380400001)(2906002)(15650500001)(38350700002)(36756003)(5660300002)(8676002)(66946007)(4326008)(8936002)(66476007)(66556008)(316002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ZyeCGuDelBgqYycE8blLEKX5xKRa9eI9cHcDGrnsn0Rpa+05B2K4/UQ0UI7?=
 =?us-ascii?Q?EdDqwvyDX4U6c4kXlhQmHTrA1Roajup0aDeDfZIFeECybryx7ExM4JoygwtM?=
 =?us-ascii?Q?rxYtqNc/lh6J2/wyc4g5kaSloXpMIoiYW1Vnzi7TWa7lhn5Hash2i0OO9lB6?=
 =?us-ascii?Q?h5wxgrcdvkSSCgdgFwFZdB+ofJGR0so0qwqdet1H5ydKMO7eJ1Jinjm/b7Iu?=
 =?us-ascii?Q?/VJClrRStB+XK5ThgIxN3xKdYTwmoKpUtAzWdWnwwhd+hRNB8ns/5DEc4dng?=
 =?us-ascii?Q?sMRyA68n3DYV6x9sBf4Q2cKF9lcZorTN4c2+yqxLnqnQ5pyFJkJaY33YpXXQ?=
 =?us-ascii?Q?Rt2B1q7BDXTMImo1zfaM8hTFAV22OHy9M1HIOn4N2uyFYzkRNEY4dALxJvhx?=
 =?us-ascii?Q?yeZX7TefmT41/GJxzwrZ4pMzhB4/WKD6Tz+N1tfIPCbBNmZX60fljrQS6EcR?=
 =?us-ascii?Q?enNdCrfuQtTugVv+yUq0PCGqAeAx7zcYptlkugAPwx2pVUEFSOyugQGDbeye?=
 =?us-ascii?Q?MEA+O6ykABzbPfh3DwTJ8R8NeSb0IBrjGRhUEUuvZdBEBRM0zUzgx8v2HFdq?=
 =?us-ascii?Q?3KtTWc+pOnk0j5nSNMZg0FK5qp8Vmh5rarquO/TUSM2HBxv/weQOWggr5Ifa?=
 =?us-ascii?Q?EagbxAStXh49TehyHbgJwIS2BPPftv9mUtQ+AoObFxDXNWu5h0uKhewrMTWe?=
 =?us-ascii?Q?e5l6dY14YISh/C4RvRE/biews/wRCodSZNlhpKQ/LCSJM1NlACqMYQLC93yO?=
 =?us-ascii?Q?GiKLmjIHFmqCVF9djeCSi6v56ZF5n3a4dGre5nBs35q8vX0L30Up3kMly2hr?=
 =?us-ascii?Q?X0VeC8jqZEYm4+3qSGdYG5XGV1hG+84QZ21irN58XqS8LZchAIKGKemD5iS8?=
 =?us-ascii?Q?H1GQS9issXem3CPmCkqHGpXpRRUt1N6W6xb7p3j4VmKbGCtJ65slpQgc4rCC?=
 =?us-ascii?Q?Azhd6N73OuJchlv2vdRwTnwcuAtKsy83WX5RZPCw0AAT+FkqEbiUd6CHqjjs?=
 =?us-ascii?Q?ifrPKtkAaFctONaFUCQkEYwKicuQoUOPQ3hw/a5S4rbxLD4Sf0Z8UmuRKgFp?=
 =?us-ascii?Q?7eTD55HPAzDY/SiAe5ONa0XKgKzoJtHX4J04ZbxXhv4Hcwr0IEleBuN3hjIM?=
 =?us-ascii?Q?AejGtnHCO44mjrgVziNkRViAEXDyHruuun6mqTg18B9zqWgtUAXYtY/OtVSX?=
 =?us-ascii?Q?zeuYzD4IgHTMa09eQkRDQX7gYCNeh9ExNGbYCC2VtEgNa+/CWNvKNTOjVysM?=
 =?us-ascii?Q?DI28hULhuLTkW8+ij3oW2nZCJ7NTylJXc5dA5mrewSmxfDKH8JWuhukmmGqz?=
 =?us-ascii?Q?c8/uEV0e4B4285FavJnNAllPAbxNdZioiuLgAJ9pWNHXrWEi5IMHDAv0s8Wk?=
 =?us-ascii?Q?eblq1n7xhaZEmYRynueJe/ms1CfAuABQ/YvBY63U7alBZnKAK1WGkS32Qhdv?=
 =?us-ascii?Q?1QvKCbK4e9oYfStCI9AbPbopcDZOhLKfvRaP9kkp+McmAnuhT7Tac1KyKZWM?=
 =?us-ascii?Q?+4s2BbNDb8x+rvUZyJ2+454/IfbOOXWnQMWjSLtJsO7ogn8R+Abe116aEpRw?=
 =?us-ascii?Q?gqPGGH57Qz93xfOkvgfQQXilGTnshF2W3Myhh7NXx8Z925rhV0cTbO9Ci6g1?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ff0ae6-bbef-429c-8771-08da9474f753
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 04:12:11.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPkKFO5E++TYPF4fqqq4uYbWj5Wq5HBsCApzPSuLVMzNLXHbEVjuN6JKELaNweZo6rbmfkfveIbzfI/+tloM/knewm+2nd49WKrrwEX3Ikk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9116
X-Proofpoint-ORIG-GUID: bwyTLpS3fizwa5N1klk81J71yf18Zsgf
X-Proofpoint-GUID: bwyTLpS3fizwa5N1klk81J71yf18Zsgf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_02,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 tools/testing/selftests/kvm/dirty_log_test.c  | 33 +++++++++++++++--
 .../selftests/kvm/include/kvm_util_base.h     |  4 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 +++++++++++++++++++
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 9c883c94d478..81c46eff7e1d 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -63,6 +63,8 @@
 
 #define SIG_IPI SIGUSR1
 
+#define TEST_DIRTY_QUOTA_INCREMENT		8
+
 /*
  * Guest/Host shared variables. Ensure addr_gva2hva() and/or
  * sync_global_to/from_guest() are used when accessing from
@@ -189,6 +191,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 static enum log_mode_t host_log_mode;
 static pthread_t vcpu_thread;
 static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
+static uint64_t test_dirty_quota_increment = TEST_DIRTY_QUOTA_INCREMENT;
 
 static void vcpu_kick(void)
 {
@@ -208,6 +211,13 @@ static void sem_wait_until(sem_t *sem)
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
@@ -255,7 +265,11 @@ static void default_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
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
 
@@ -372,6 +386,9 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 	if (get_ucall(vcpu, NULL) == UCALL_SYNC) {
 		/* We should allow this to continue */
 		;
+	} else if (test_dirty_quota_increment &&
+		run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED) {
+		vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
 	} else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
 		   (ret == -1 && err == EINTR)) {
 		/* Update the flag first before pause */
@@ -762,6 +779,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	sync_global_to_guest(vm, guest_test_virt_mem);
 	sync_global_to_guest(vm, guest_num_pages);
 
+	/* Initialise dirty quota */
+	if (test_dirty_quota_increment)
+		set_dirty_quota(vm, test_dirty_quota_increment);
+
 	/* Start the iterations */
 	iteration = 1;
 	sync_global_to_guest(vm, iteration);
@@ -803,6 +824,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* Tell the vcpu thread to quit */
 	host_quit = true;
 	log_mode_before_vcpu_join();
+	/* Terminate dirty quota throttling */
+	if (test_dirty_quota_increment)
+		set_dirty_quota(vm, 0);
 	pthread_join(vcpu_thread, NULL);
 
 	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
@@ -824,6 +848,8 @@ static void help(char *name)
 	printf(" -c: specify dirty ring size, in number of entries\n");
 	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
 	       TEST_DIRTY_RING_COUNT);
+	printf(" -q: specify incemental dirty quota (default: %"PRIu32")\n",
+	       TEST_DIRTY_QUOTA_INCREMENT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -852,11 +878,14 @@ int main(int argc, char *argv[])
 
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
index 24fde97f6121..68be66b9ac67 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -834,4 +834,8 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota);
+void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
+			uint64_t test_dirty_quota_increment);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..4c7bd9807d0b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 
 #define KVM_UTIL_MIN_PFN	2
+#define PML_BUFFER_SIZE	512
 
 static int vcpu_mmap_sz(void);
 
@@ -1703,6 +1704,7 @@ static struct exit_reason {
 	{KVM_EXIT_X86_RDMSR, "RDMSR"},
 	{KVM_EXIT_X86_WRMSR, "WRMSR"},
 	{KVM_EXIT_XEN, "XEN"},
+	{KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, "DIRTY_QUOTA_EXHAUSTED"},
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
 #endif
@@ -1979,3 +1981,37 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 		break;
 	}
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

