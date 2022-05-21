Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7ADC52FF65
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 22:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345647AbiEUUbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 16:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345413AbiEUUbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 16:31:46 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146A1248FE
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 13:31:45 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24LHUFdN002715;
        Sat, 21 May 2022 13:31:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=MzhJAPRznR4BIFwcVWKv4IfRzNLX1j/kg0pXRnodaMk=;
 b=SdS8tgJBzshue2rOc2z1kCNY4FpQCdwp8KcdB/91A2BrgD5/7/SE0nWucDCdhzKWdwGh
 Z5BdfVOGsNXisuty7HT0PGFSfekAcdCnSQphPvQeiDTNS/4RUiXAWr7q1OLTmic9cWDm
 ApiWq8OVYVg15S6oM8xYxOo3Cp3EWZLWWtgUbNe/2vlHwvWa7fXEnI+4mn1vQEoV0HI1
 Z6K6I1/heeRytF61cmnKdO+Xs3ocTMJhZbJ+W70iYk2/6xQABylGx5MQNVv18+ztCSAD
 BCMrbhyMBPMr3iYvBCvHmwy0DPw58azui9GCHh57CxuWHkdz2n/9+HzvxSwlzAJrHNCo vg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3g6x6h0jh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 21 May 2022 13:31:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKpWoy1g2H8SXO3o4c3mbXdMNQiwXwF39cAcUvpxfy56rqvfZZs2Mrt0X9mCcZZcx4QHn+hif6G0jlIyPtgdDMVETzYsFTNyM7dFUSC0ghD9KnpMT1SUKaLS8lx6el5B6EF0LbYYZ/TGUQ/0LlK5A1feRf3XpwHWPgByPett7hjNVq6iS85rqGpF0IDJDxlvdfn3J0mz9Qr3+skp9AbO23gmp3myiioAZUDqxqUJQ/GbaBMUrkV7W9io+R1/DW/UE/QcdS6QJUIHlpNNwE90e2jddxwP93LuGl1a1RugUvHqMmMde95AwrEhOEIuD36CKXdz6mmRip8dhGkxehiMXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzhJAPRznR4BIFwcVWKv4IfRzNLX1j/kg0pXRnodaMk=;
 b=LHUBDxOU0X7ynpAj13r/EOMDyUlifqNiCWHJVjtIfw33d6wdtnV5In8eZNd33a6KDQ1sVWM+/2IaLAALKsvAH0K6se4VYgLF/K79eX2SAMVYSWNGIEkwHWPCTiMa4zbDY7DCUyzgOOPhO/0wAejNAr/R+PVICFKz7aUwcvGqAUmG5IlyoalL9wEd8zWg/ayXbtmiPXDsnL31/3Osebtlsd3nDvvLi2ZyKlyqTa9LjjSJNibXX8NdPXuv1teLdrHEMmjjnrLCSHvNDI/e3Lq2EZWPkjr/S/3sz3mwXWP9j99FsrGCYkPmlLfke90o+woPr5/7F++03KwmjVzcr7YNAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SN6PR02MB4319.namprd02.prod.outlook.com (2603:10b6:805:ac::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 20:31:34 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%6]) with mapi id 15.20.5273.021; Sat, 21 May 2022
 20:31:34 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v4 4/4] KVM: selftests: Add selftests for dirty quota throttling
Date:   Sat, 21 May 2022 20:29:42 +0000
Message-Id: <20220521202937.184189-5-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:332::9) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78a86594-852b-458a-b910-08da3b68e56b
X-MS-TrafficTypeDiagnostic: SN6PR02MB4319:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB4319B21F2A50A68C126BB3C1B3D29@SN6PR02MB4319.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FmHH4YsPrwBKEZYZ4326W/wpJn5nxTyQkLHkdsYWClUY5G6OvoBcD9GRoXvOduicu+MSknfodgT0MZ+ENAmIdGZLBFZ8r2y1WYstkCRH2Cuh+djqfD6iwe4/RsPe4cqff96MorbBJmcmxnelVKidx3gPVhnYqm1wBISktmrH1VdK2AkEs360LC7StYI1vq50vd+yevklHqypGV6Clt9iGF4+eBrqoouYvoWOszc1wcJlkWSWWxZKOnz/dpwtEIiAnEeh4kancnipokncLz4XdQhc0shhc0CkjG0bQHHYWESlBkzkkvXwSdokuE5PO1C8D9oaW/bsrk/pDlKKyEc9m6jCSgPg8fvJNEtnad9qVMgrx5jCRU8pHP5JgTmOr7IpKLymLXlOyX564iwBm7p1WPFopwoFN2cEQhA3rTQ3jiL0trw2ZDZ2cql3W6C/MU7KuELxtqOjfIbWzjyTk5FseJO5vIM9iIaelQn9PIR40ngCw4cYAdghx0RgqoyN1ywis2odd3BlCTb07SwbhN8wuYJ1NhvD3AdQiV+LLu//DxPMYfukyjmP2uO6UplGPTB6+TvLU6Utg/haQXkUAvTNPxsQ0OxJoA5zRPsgHHTLJNId8JG6NhcvRn1iK0qKLVue9b8KC0pRqp/0p5MnS0RglJLDNA+acDNvA4bKnye0HC0l4G6PQTSgWstedRnFttjRJQ/t6RyCxCfxZ1eXpSyi/EVUB2E1fnv5S8+/Hh3ht94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(15650500001)(45080400002)(52116002)(6666004)(66476007)(66946007)(66556008)(2906002)(8936002)(5660300002)(508600001)(4326008)(6486002)(36756003)(86362001)(8676002)(6506007)(6512007)(316002)(54906003)(1076003)(83380400001)(107886003)(186003)(38100700002)(38350700002)(26005)(2616005)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y1rj9uHqw+a5zA4Wa3hVtkEtPFhzcohItsludW8nEZVsgjVdRf9TBcD2me/R?=
 =?us-ascii?Q?Li/PpzNNa2yCH0aOQ8goY4DBdtR5Cf8lT+WecXcZRWv3CbCYsB1zOsDd+qAc?=
 =?us-ascii?Q?C+URjNEaRjPmgTow2eyIWwi8vhy9uRXrytOyKN4G/4eTmN3XBH+YTEzeZQyw?=
 =?us-ascii?Q?mkTq0VTIKblIZiXD21E167OhZD2dyuiODJLHQbp3kv1hcLg+/3GnKuvZ+hJt?=
 =?us-ascii?Q?dsyMCk8Ehnnt25HN+Iua0jXk/hp9FlT/xrwPAQGqqFjkvqZmRujs83Adi3Y0?=
 =?us-ascii?Q?tpJqIFk8cOXPOCgwwC2Y4BLewmAPN2t9etfzzAnOAbN9AXwRm7zkp31+ztWR?=
 =?us-ascii?Q?7p+ScLEXyh8keiBc96j8h/W8VSP0nLCiLalpsM61PXhwkvsc1yAA62W5UH5f?=
 =?us-ascii?Q?waoJ83gjN8xRuf3d3kZsakVif2zm8Da/hQSczWP0DbvK55gMylvFDuszuOOV?=
 =?us-ascii?Q?Bhfioi5w+xRN3IDWMPBpiRh6O8vuh21bkLgLGcnaVoEKlu2grZD5VNUMT/mq?=
 =?us-ascii?Q?uo7rh6W1FEtjoEnwoStzHtSykSDMeGvMz3wC/xjpn8LCUrAFSgvXM+Z9HelF?=
 =?us-ascii?Q?zDbAz4Yy4CtdXko6BvZ0O94kGFab4I5IJaom6DPKS0JzDS1MYVfaBsCsmAMv?=
 =?us-ascii?Q?LRTFe0qPC8ZYC2Fn8Eeuh0M8Kt2drJ9OnAugRSHpJbgR2TSruOAC/y8vbZpd?=
 =?us-ascii?Q?d15FVQzr9t+dwr7j3dEyWUqEe4rR9yY3Y20JICRfUDcMxGhjiYt+ZBpWZuDl?=
 =?us-ascii?Q?mn8OQvnCbMK/u/dzxqn2bbxIfLXpNtqSrjk1+J8f0ULpfwH77fWIgDx23Gp8?=
 =?us-ascii?Q?lzIgajgBCCpKmWNDcITZlktRt6P4MXjXuqPaaHAcBvmncw7okwgTSINpyAX8?=
 =?us-ascii?Q?ejeN+zx+22pLtvxawi1GnMf6TWwp1Dp/fBYTZsjBEJ3LN+R3d5tOM1zmqeKa?=
 =?us-ascii?Q?pWqkykHHyA3TZDslb6CdkxRKSxYCd0b5NiVpL9hPuCyN7Bbnr1jViIUrPV4l?=
 =?us-ascii?Q?Fp6UlwbC6i5E8nODPtFChcF/T92ZM8cmSCWVK8t2ChO3xTuWaqMHhoXOCMSV?=
 =?us-ascii?Q?F/J2+IhNHR0rm6rw97L+kMUvOXB8xBK8K/ss7lWHkDhmF/VQ193dSbmtLLFM?=
 =?us-ascii?Q?4c1fSGhb9iRT8SCxU+dGTHT55u620sB04viDIC8ZjHjmAFAIyCD04VhmY/d2?=
 =?us-ascii?Q?mlpZD6UOXFfEpV61Gq609OzO4fTNMGbz9RVY+tsFJNqRFz/DxBzu0gRuwdEm?=
 =?us-ascii?Q?ovDZdfj0vXDYZRmBPaZMw0ftcBl4WmQW/3qfvTt5VBV7aU7Vu4ciLhQMbHgi?=
 =?us-ascii?Q?GyozOQPZzfRDoRSkWTSZE6uoT2fPrjPwBW913XvvhLPPuTQFiHitys/OZnWb?=
 =?us-ascii?Q?5ilE5mrYTZxIKLMEfbSYLmBysU0VCHqt0Y94WhxuNmS6/pfUxst2asCBJMf1?=
 =?us-ascii?Q?D4+zs4iiS56lSD4c4DJ78wn+9XM4J21AiVv9j4RBmuI6CNvv/9jRx0Qmdt3j?=
 =?us-ascii?Q?D5kvR3lTKZE3Y4eAI5chDscpbPBh2k/Ypv5jxRNYxda9GgiN3m7o0raBsgW7?=
 =?us-ascii?Q?2sZTezItjXAYNszhuCyH5z/esei9N/gC1ZKGzxskwcTAoEs2++7CWqQWV5X3?=
 =?us-ascii?Q?KTPuR4zI6mSXBkoevtIPPKbk8kkxNm0pVepDxUJayjPznIKIvp3+JAiH5Eav?=
 =?us-ascii?Q?6HP4zycx21UCfGS2L81wsI+J0/z/dVbBypCRajdkRv2USBywZ005aZRsqttc?=
 =?us-ascii?Q?PKXFRhvkkuFLZyyn+VxcY3Ka91fGUUI=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a86594-852b-458a-b910-08da3b68e56b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 20:31:33.9744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACxoHa9ZtRua6E+YqXRB/Q7nkBjbjPts1zUzWZ2qMlIalSy/2f5FLOA+NgT3mzT/MlCH2WeTp8Mo48FtOwMwHvQoOytsnLb0Om5k4cqfwHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4319
X-Proofpoint-ORIG-GUID: emPQALzkLRYByjWfTLSVjO5LICMvFFXZ
X-Proofpoint-GUID: emPQALzkLRYByjWfTLSVjO5LICMvFFXZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-21_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d8cf851ab119..74a354dea8a7 100644
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
+	 * Due to Intel's Page Modification Logging, number of pages dirtied by
+	 * the vcpu can exceed its dirty quota by PML buffer size.
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

