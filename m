Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05CE4CEE1E
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 23:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbiCFWPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Mar 2022 17:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiCFWPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Mar 2022 17:15:51 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160DA3B570
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 14:14:58 -0800 (PST)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 226KgSL8001313;
        Sun, 6 Mar 2022 14:09:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=if/hj+iTraekyQCiKkXtNZ566c2zsWNGmGkqJ8r+njw=;
 b=D5+wIvp3CHJLOktOK5XMl5G83TAp6aHiDnx2nGLrIYhbUAkfXO+S2BBQGgkt28WVjt9y
 4UPs0cu0Dd8gyjjvd+S1+mju/1Eu6RsZAQ1AHNy70Wp9Niqsh+9ofLZBicM5IaXlpb1s
 IDb+rdI369rxTi0Mq3xYOYeczQNA6TIfOYJSeGn/MsloATP7ppNKRSZhXDhjpuqhg8yn
 q5dqpckLEwotRSK+0iuzwuAYN3NCMqHH7PC5EdkTB78iNC8cq3eA6lkG7gd17bCZc8tt
 vh0nMm0SCaQjn47ueXUZI6ZsvTBe6/aHe8Hc00GDh/BQxXRwHDfUZGKD3gFu+e9JNjb0 nw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3em8a31w6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 14:09:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOteJ8cGLc1DEfzH4UhvILH6Wv9q7qtQntCKg7isLqnysIvt3MH3S+PaxJ2sqMw9kgi+BRwb7Mw6Q8Bt7ynHorqnecXh79+t91BmrZbI9Jci/mMznRwWzBowKYp1PUIIou9gr0PBveExLQ5BQaTiM4arRRR2VJm1SXCNIPoDzueWWXpZaQtl7yLQ6dGLoUmheUfIr8iLqFFSo0H+/R9RwlERno7xlqbmowV+aKCBLHyeqGeyu1NH61kd1PMDLPj0aUBuqpixXG6e+DqocVnuCNepLOsZUOK4UjBjceMpUHZKBWGka/r6Y2lTMIK2UR0zuGOxaPH06dtTw1urVvKOOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=if/hj+iTraekyQCiKkXtNZ566c2zsWNGmGkqJ8r+njw=;
 b=iBFSAv92r5Wld08p7B5X7FWgTVObMpyJDz91JIkzbLmcaP8se+cQWKtCKM5k1SXfBJoOZLIIeTnnMVLB/z2ER9MnCNSE+VdCLeWo02XhVJtpawa7pdn0uvvvmXfYWWtHNrhhXZqli7GJ11IMnMJwwrnMxfH68JER+UvX1fCOV/DSua4rEqWBFON8ORLJC2IbTwNTtwXIT5K5oPwHba0BVex20eFL/2ZaS6dwLV0cWq0KSnQlI77GQ3gmGcoVYfC3ooEWdglk+3J4N+oQHVCpcL/DvzOD1bX+6eZcWXKTAc29S5DB2tw/WggMv3h1GUrjzirGD7wClI6nOWLkcoxJ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BN6PR02MB3234.namprd02.prod.outlook.com (2603:10b6:405:65::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sun, 6 Mar
 2022 22:09:39 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862%8]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 22:09:39 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of vcpus
Date:   Sun,  6 Mar 2022 22:08:48 +0000
Message-Id: <20220306220849.215358-2-shivam.kumar1@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 399f5e3a-cef6-4c46-51f0-08d9ffbe01d0
X-MS-TrafficTypeDiagnostic: BN6PR02MB3234:EE_
X-Microsoft-Antispam-PRVS: <BN6PR02MB3234AC867361CBDA9508851BB3079@BN6PR02MB3234.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULKw0rRkJQ7BamKsFZcIe4CAqkjNa3otV6kKV/LT5NJCIhTBu60M+EmsWoJAod/CUWE9v+JrDMj4LgRb5iCKg3K8vSc6TgvblbInj+ROm5B2OjcFzNZUQEIJFDlcZqInfMOh9Sy9LSp7FzaqTRNW7bwQLwyyTc3AYp+n6e3Ge+f2zcIhKSh9P0VSmmIfM8QyE0HrWhRNLAo/oe+EsTYT1yl7MoWDImOdb2GQu5C9belZx7WgNsdSyeo4YTAzrUAsI1thyI69GzZFhrpqYIqkqmPH3liUMNH3lXJba02MH94azVMHxEwqnhOwB5bGIzB/LnpctpL5g7bTHqQC0X5cfzC1nTE3K4ktbdkMVHo3/ejmqjNBZ5/QkqFtPUAXX27GQJjS1qGyJaRf3+d62LPWOrFrbybUscoDnTlQxUwVkfVpKex0AYrXs2hEVb/0UpB+A73/fLO0lrSa/8IKU8R7WuoSv7DMYuLIeNgYqOtuW3S4bP4s0elHnSoxlVE88aeL+czo171cjVMdmbAYN98J4FQJAvxzjbf71HD0bzCHZsDEfMC4yZZgAsT/BAEaofto7buCmTRG5f4Iwn79V+4Nl79IiWYwQaUSJvys8SCE3xppxrXcBV5t/lyF6NBFPVIRh1cLQahFtCRxmhQ/TD3m00hA+/xWHi/xjZRzLz+O+fTjAPgG9CNV/EXHplA7hOQMLXZA0a3iAVLhMMoSHd+QjMXqtAfT50Mg20WJRODJXmw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(2906002)(2616005)(38100700002)(1076003)(316002)(54906003)(8936002)(4326008)(66556008)(66476007)(66946007)(8676002)(508600001)(186003)(26005)(5660300002)(83380400001)(86362001)(6666004)(6506007)(52116002)(15650500001)(6512007)(6486002)(38350700002)(107886003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zkwek6/Uqd05gMLGbJU+7Q6ZHV1jtfuob9qYAJXQw/5z110vZN+woxo3jruE?=
 =?us-ascii?Q?++qsel6Mdp0S+d8EgH537JfqL86Mjj2yDtO21gh4DU9n6llVlaRk0k2LV3Qs?=
 =?us-ascii?Q?lnAgg7Pe9+P0oJwA+c1dgQ3i8NRc17J5UdmBplqCIS1FowPYsoCEiuu9FjoO?=
 =?us-ascii?Q?WCW8l+1D7yNy7N6RD9cLFzJTqdaxGEAGeU8se3kZ3T0VaikEizeZf5gI1ysT?=
 =?us-ascii?Q?EXU0N5VWRCUxP0ArkXBXlhHqNf3txtpXNvYLqjWr8iH/e5awSyznxUx582A9?=
 =?us-ascii?Q?eQ/96nRecOXf/NWeCQDyF6+hu296AgdIMpaxFubRUIq4QjKGRNvu27kSwdPR?=
 =?us-ascii?Q?hJUyyIutVpRYAmrtRSix30QPz1V7G6ql36Kqr5Dwh+2lgdtNvNWuGAhCpUIT?=
 =?us-ascii?Q?E2TMFfhgg8FpQ5GfIk5GHyWV3T0iFmkUptRtYtDn58s5ITz++/6A0OK/+KzR?=
 =?us-ascii?Q?X85K8FEj5g9El1UXLiniNXItoQhUJfh/JqBusaU6H1wPayFEMZOLF+FvjwXB?=
 =?us-ascii?Q?TUlwia95b4KXQXhP84AQ6f1KnUFaWJqsl8YHPQTWjqE/4CNDXgNwqxzQhJic?=
 =?us-ascii?Q?cVzwTAMYRIgRNCxC16lQLOvMGxkqD9rXhXEba1KDT2E0AEgJTOkEDjPcuEzC?=
 =?us-ascii?Q?yUBYS7WqvwUZs0QveS/K/ho/Jj2dWtu0SmIYy+gkv+iawn0LWXpxHPIoeSwg?=
 =?us-ascii?Q?UzSTCf0s4kWYYbZBACLT2/MMJKDXWA9iH5qy0VHIeobW25MhQXMAA+u/Eo/w?=
 =?us-ascii?Q?Pfcmrjtaw1zAGTmY5RzwtQHatHRJW0NhNHl1uxB1gG94xPszV3LePibZVXB9?=
 =?us-ascii?Q?tsXhriMnFMvcA5vf9Tjn8Pqrw4EYcfbG4RSvKHcCfaNiCarUNRAc2IkPEB7J?=
 =?us-ascii?Q?phwZImqcjx7SCWO3fbe9fNJKyaexKZFiO5q2mt0liV2wKqvCBzhFC1cCoL2r?=
 =?us-ascii?Q?5xSsy2+azAph6StV7fUAnBFtTDGmbN7k2E8zcmaO20jVNBImqDLhpFyFDx7M?=
 =?us-ascii?Q?89R16O65pz572tKxJkcf/QWcKkeHgorOBmziHn02e7a3kr4AvAFibwq1LLp9?=
 =?us-ascii?Q?keZ9iiOU6wehEOVkvPvVSme6IAr1W4hFPDGCtG8MnpuTBBeM0/HC/ZRluI+W?=
 =?us-ascii?Q?dA8DhVT4ohCcWUDuooBznT5Eeot539VVVpaE+0OgmGr4i0D/NOaIAYEOqt6u?=
 =?us-ascii?Q?3Q201oMcryz25Jy5ai4itbmB4yG+a/tTr/m7mmQpDUGv83xQ5emvuGY6hX3R?=
 =?us-ascii?Q?VTBSsm1FuPXQ0jBjKHbrbCdxwhcLkdiG2Vl7/G/pfTOKh+isPnd3maqz9JiC?=
 =?us-ascii?Q?7NvRCE7d1qgCmUP1vKeoirx48YB5hhImdLkOS0Rt4L4+Bn+llpcZ0+PJXvrr?=
 =?us-ascii?Q?dLl7fcr7MBzNq+ea8OexUsZIloBW0tEHdX73iOdzrULcDWPH8vBkccx6bWda?=
 =?us-ascii?Q?BzKN5C0dnG2esmhkxpQoL6343gioLHC2qGf+prJP4a4NZRDyTZaGleQXrXAR?=
 =?us-ascii?Q?u7EoG9+Z9D7LtOErsN3/+ONCO9Igshc75ReseYRpLO8u08tsnARd3ImC73Yi?=
 =?us-ascii?Q?RkerTNJhnbwMHCLu93oa2Tw8PAJgZE4VBS1VHc+6eI+rMy+rnTwnXVUc7tWA?=
 =?us-ascii?Q?S5MvSoFK7ABswDwsbUR9MujB10aRtJ5l0aqhCiw2jKsqYk/VfnAsApUq3AIX?=
 =?us-ascii?Q?krDBgm+BFw1n0E34DTAW+eA7Nck=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399f5e3a-cef6-4c46-51f0-08d9ffbe01d0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 22:09:39.0184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KdHpFjV69b6QcDMNhZW8VjG80907dcq8F0VyGOLgKZnbWqje0pw0blmZBYJxap5aQS32wA3RbtQFvTZ0xbPl/8EAJzPdf1Xvkwpajuvxeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB3234
X-Proofpoint-ORIG-GUID: xcs6jnIv7YK4-AvSs04I0v-mRxs7PFpU
X-Proofpoint-GUID: xcs6jnIv7YK4-AvSs04I0v-mRxs7PFpU
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

Define variables to track and throttle memory dirtying for every vcpu.

dirty_count:    Number of pages the vcpu has dirtied since its creation,
                while dirty logging is enabled.
dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
                more, it needs to request more quota by exiting to
                userspace.

Implement the flow for throttling based on dirty quota.

i) Increment dirty_count for the vcpu whenever it dirties a page.
ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
count equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/arm64/kvm/arm.c      |  3 +++
 arch/s390/kvm/kvm-s390.c  |  3 +++
 arch/x86/kvm/x86.c        |  4 ++++
 include/linux/kvm_host.h  | 15 +++++++++++++++
 include/linux/kvm_types.h |  1 +
 include/uapi/linux/kvm.h  | 12 ++++++++++++
 virt/kvm/kvm_main.c       |  7 ++++++-
 7 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..5b6a239b83a5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -848,6 +848,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	while (ret > 0) {
+		ret = kvm_vcpu_check_dirty_quota(vcpu);
+		if (!ret)
+			break;
 		/*
 		 * Check conditions before entering the guest
 		 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2296b1ff1e02..9cc0e0583ef4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3994,6 +3994,9 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu)
 static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 {
 	int rc, cpuflags;
+	rc = kvm_vcpu_check_dirty_quota(vcpu);
+	if (!rc)
+		return -EREMOTE;
 
 	/*
 	 * On s390 notifications for arriving pages will be delivered directly
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb4029660bd9..0b35b8cc0274 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10257,6 +10257,10 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
+		r = kvm_vcpu_check_dirty_quota(vcpu);
+		if (!r)
+			break;
+
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f11039944c08..b1c599c78c42 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -530,6 +530,21 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
 }
 
+static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
+{
+	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
+	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
+	struct kvm_run *run = vcpu->run;
+
+	if (!dirty_quota || (pages_dirtied < dirty_quota))
+		return 1;
+
+	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+	run->dirty_quota_exit.count = pages_dirtied;
+	run->dirty_quota_exit.quota = dirty_quota;
+	return 0;
+}
+
 /*
  * Some of the bitops functions do not support too long bitmaps.
  * This number must be determined not to exceed such limits.
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index dceac12c1ce5..7f42486b0405 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -106,6 +106,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
 	u64 blocking;
+	u64 pages_dirtied;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 507ee1f2aa96..1d9531efe1fb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -487,6 +488,11 @@ struct kvm_run {
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
+		struct {
+			__u64 count;
+			__u64 quota;
+		} dirty_quota_exit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -508,6 +514,12 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+	/*
+	 * Number of pages the vCPU is allowed to have dirtied over its entire
+	 * liftime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the
+	 * quota is reached/exceeded.
+	 */
+	__u64 dirty_quota;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0afc016cc54d..041ab464405d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3163,7 +3163,12 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		return;
 #endif
 
-	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
+	if (!memslot)
+		return;
+
+	vcpu->stat.generic.pages_dirtied++;
+
+	if (kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.22.3

