Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457B847A4CB
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 06:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237493AbhLTF7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 00:59:32 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:8298 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237486AbhLTF72 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 00:59:28 -0500
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BK2S7E7032284;
        Sun, 19 Dec 2021 21:59:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=6tLNW91aJwO+bW0kLOPEioWVS0HlckvFGK/hJdFk6Iw=;
 b=tJzR/9y5CrFzzc7t0NN2LETcEDbWJ7S01Anayt5X94231QpKBs/UoYsuz8G14PjdRUHl
 XFKhRmKtP8uJTWNzMhei/qKjWECbQQOkaUk63pzQQTW2M965Hb4nguHRMpUrC7ez/2uA
 HE5O5Knfvbl1KuRK9tg08LrdAAM7rSUaDlS4fsj44TNt9mK8UUz7p7sVfFiS99J7EqU5
 pw++aF1PrKcxEzYWGVBIJtDiAvlFSHpwX1qoXVBpMqDL3cB3E/T4rZ+yPtzee92+/NPU
 FNoOjb5eVodWHv0/xaS11pl4yYbuDF13BC/lgPWudyywg1bp62wzkGn4QyJg2ZAxwnq7 rQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3d2h2r0846-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 19 Dec 2021 21:59:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwU9PndLVOQz5uTRXI8Xy1BWQbET9w663xqTHLwNEM1WtDuwdnCnNmi6QqZP9hsWQHzWukiUevXGf+UeCuA70hB5uHbhEmGJ6rwuO/9VtuskCImCdXwfSmMYylFxXHlaBVAe3uf+Ftth2UqJjtXoBX5xTzvNW2l9em7G8FVlNWR0+cxHUlBgkRj8HINAHOtE6puCOc6aMjG1nvlhVw3IYi75F5bCRD1WaI3gFFO9k1bYKCi/+pTQj9srTYtU1y31Udzex6MW2hbmsyilmDglIZxhlc4aPjsoB1oKHJSsrt1zogcucFC/ovPePJi9xOGGJc7nR0wkfCuhn0umbhwCPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tLNW91aJwO+bW0kLOPEioWVS0HlckvFGK/hJdFk6Iw=;
 b=C5SI0yEERgSJcFNxXIIDs/oW/ZqZuMOGzdZeWnSwu15VWKENez4JuRzhFiFzg3fde8nNnhP/m8t2WSvJCxUB0IC5y69/MWOesLC8mr/ke9fjG+zeKXVhItMIwuMNDbEJFjVOJpo1T0q5nki7ThdNzadgICcLF6vy7hBzI1QEe9f7e73jCOBanmE58L6mn1dJhV5Tr1jK4PJ3a0hhx+qn+nCUWU7947OX8haOQ3Utv03bjV6Q2q+3eGNW0JixRtYo22OE+QdYLrEVLiLnk7R6HMXRoMzbaIUNrp4eIhfYVg/PEvICo0qap4z1ykAeFIkvk53LADBtE5AMvobbImgp/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MWHPR02MB2415.namprd02.prod.outlook.com (2603:10b6:300:5a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 05:59:20 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::586c:4e09:69dd:e117]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::586c:4e09:69dd:e117%8]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 05:59:20 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, agraf@csgraf.de, seanjc@google.com,
        Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v2 1/1] KVM: Implement dirty quota-based throttling of vcpus
Date:   Mon, 20 Dec 2021 05:57:23 +0000
Message-Id: <20211220055722.204341-2-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e7a791c-5c9d-4cf5-53cf-08d9c37ddd64
X-MS-TrafficTypeDiagnostic: MWHPR02MB2415:EE_
X-Microsoft-Antispam-PRVS: <MWHPR02MB2415BDA3C269CF7938DCB93CB37B9@MWHPR02MB2415.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:469;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1T+b+XvEAklIUmeQhHhbWIdeVuZ/UF6GX/BW6/pOGTdCIyiMGY/I47bHVK+54KWZpLo2SigNiemPt8kkhFF0OY8yB6/cLDW4OpYSV8YB5nJpDVgu5kSoVDbtuyHg1zt+AsDi/ola9BgdegTw/Lv3Z74W33VR/vOgf+Hcysh2cUYKg53j/Hf8pn/6cj5SyOIuTzIxi7UiAGqZ66ZZ4Xzm+F5w4Cs0vsSNYvstoiMSk8u1rOch3NQFfk4SXBK9lyN1JarjgoW696F0YnoFGXK07hqFE0Ih5UZSPwKWJO4FGXXEy5kJh3suqPLyXv9KtTspbb/7y7K3QnLDDW/pVXn4BAaZ2LTfT+/hO2nIOI7XEdY+FlNBtBDnCv58zrpwok1bJYR+PzfSDuQGzjY1CWsTzKmS3UopuWAI4+DnDKzWZw2Ddh6UFmsBkrT8UotinyAE3q2pfkz1tBN3UcP1U3UkLropMowHtLVdxhhsgkiuN7Bl5qm8xFMHX88gIpST5CKhMJ0PLZ3mFmSoXIUcL5xcbNOG2cyj76aLuHjzO+Bp5L/WFpn2Xa7F7ja2XTA8PZz7krjH4Dlyvo9dIKPjc2Lu23xLS5LEDkXtvuV5r1shP2aHjXb9muxJMBEjQi89RdYVx2BvsKgwJZTJRnYX3O83cktVuE/pU+GIMNt+BtHerL3zHY89cav1jberSzAY2nuOY0ueBZ7mdI/GwbSzKwqicPix1e1UYwAZna3yu30sT45hRcYEhScdPGftzdKphVR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(508600001)(1076003)(6506007)(8936002)(15650500001)(5660300002)(86362001)(8676002)(2616005)(6512007)(4326008)(36756003)(54906003)(316002)(52116002)(26005)(6486002)(186003)(38100700002)(38350700002)(2906002)(66946007)(107886003)(6916009)(66476007)(66556008)(590914001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VqbYNIZ7nfX6DMY+PwyGkdJG/6rZY207Cb9RTKPfxdshhQqQYAiK/njuuosq?=
 =?us-ascii?Q?ttBJAvnwXRA4j3HowteddYT7YymLj71hTumJKynVu5cDcWRNP4lcwJIYIZt7?=
 =?us-ascii?Q?9++7y6xdkeQcEZm/ou+uhAzsL0OJnHn2XvDCd5eZUgD0NjVtJ8YXC9qTJOCQ?=
 =?us-ascii?Q?7wz6hg9/yr0nk1ynjWo60Eed6S1Uu74IlGTJeuB2Oc8Qtl+tJ7b/2hfwLIdK?=
 =?us-ascii?Q?nhIuGxuHprKaZC+MrhESoBSAbscwaS2RJuPlJCodc+DAFIGclN6SPnGad5q/?=
 =?us-ascii?Q?kdnlgffdvCmjAL+eFMuD1hyrnKzboVCQgDML5YbliM2W4hxE3m9HysvA/Nx9?=
 =?us-ascii?Q?CtGaLamR5qEsskslr2a0khm7iIRmXzY0mapk/Fik6S+b053/6D8FFK5V7ALB?=
 =?us-ascii?Q?iwAq0dWJFRhWEOhGK3NFgopcS5aZIuQQxMVeW3E3K63r+HsnFvsyB1jSW+MZ?=
 =?us-ascii?Q?qBouPjqRtv02+ibHsDLouzWz+ykMi7CRykwIZZ0lQY1B5QkbadqoqzQ+DZMi?=
 =?us-ascii?Q?eSg9TEXVnfMiAQNlcwFcUhccttZXzuo7wAHrpktJmLpMYIR8aAH92KZcBRkU?=
 =?us-ascii?Q?HRhLHeZUXeEYsCrg/2D82cpbXkcmXN9zBI4bLWyb9cIw2oFHt81+G5oddxhV?=
 =?us-ascii?Q?/BS/PYZg36byl85E7dnXaBbbyt3/aRnImp2fwtkwynExvPSVFttCSV8tmKQQ?=
 =?us-ascii?Q?OV1CNHp3yJVnIAZAijuGCAdd1bPTm78O72jmgdDqXGYebfToYiDpioQg6MXZ?=
 =?us-ascii?Q?foBn1FA94i9NodKovUO0dlmcE3+m8C5WYjGJ912zHGLGZxgxiqMxuyuPV2e/?=
 =?us-ascii?Q?shiQfYTlWh2MjY3tBp/XWLCyzv9Z+6/O7n8CvINCrHY7SRQnvpxq2UNGTS9C?=
 =?us-ascii?Q?uhjrDnMB6cIS2CION/ABlg7SQXabcZOdiO6x4GkspxXWV8v0QGlMhp1WECBk?=
 =?us-ascii?Q?DCN0/cQPj+fUYIt3+rSrN1yT8XHW+GVrjjCipj+Xf276aT7LC4LyhJc9jweJ?=
 =?us-ascii?Q?l2r5zDL1VsqqsuA0np7u2zMbcYxcH2sqKo/fbIno3bliAvbekNPECadtJppd?=
 =?us-ascii?Q?Bryct1FhV/RKIhiL4Wn2uyNrj6DSc6NSUj76RQFGO8ZSKLuPO4hS/oiN+IQV?=
 =?us-ascii?Q?hGfV6GOmsV0/jrnv2ssZFQ0BvOSxO0MSQTDAGA69QydyHDXFLYdHquySfxQT?=
 =?us-ascii?Q?R6aNTQ5cgn7LHBvzUy+q9t3/8COfLWbUX1T8Jn6xj9lMuZl0ReN/2KB2ZJHu?=
 =?us-ascii?Q?hvEuY1sMkk/uugy0+J11eRXEYfcd/6gsu7DtcSiWgCmZMBVlOl+M1Ph5LbLL?=
 =?us-ascii?Q?MviQOfyOTw0GHcQ+v8lgIO8rSCiUu7tC4AHm370dlC545T/bd2bzOX3C7C3F?=
 =?us-ascii?Q?TrikUzHhIq4QIxZvyFiRiydkjY7pB3QCaLfAa6mZF5w8n0PRCSMjLM08AacD?=
 =?us-ascii?Q?huW1YDbLYXjQBiOPUAaVTOY71iO5L2SSsVIXHIHvN54JpDcmEEd7d56ImLIZ?=
 =?us-ascii?Q?wHRrFcYo7fbD6DBOhG58vhBk5FQavEAmjQpICwu9Klmt42wGNj7NDWt5Y/iF?=
 =?us-ascii?Q?b7tjj9BJeFHswwu+QWOtXTtj+I4V/03jVVMbDuFl3/DRUpAT93GDc0VHIukj?=
 =?us-ascii?Q?8Kc3fFQ1XhDPmClCA9tSxu57X4K4uLbhw4CyqW1ryDxw+q+0JUPUzUB0YQVN?=
 =?us-ascii?Q?NY7NIyxTMge8qIsSTruEtlBVwsE=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7a791c-5c9d-4cf5-53cf-08d9c37ddd64
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 05:59:20.3397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0EpIvVXsOicz3CMmQK6snaS8GYjISHx3YTNVk4rWhUqimBHnu+4hkEC3i1xl/NPrkqbrrfeNJR+VoIgMtMnMNa4YOdWaoq5gPCSSDVSzrkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2415
X-Proofpoint-GUID: XMKrnQPZrkZ0iMe6Y37U4HTTiZeiaEDJ
X-Proofpoint-ORIG-GUID: XMKrnQPZrkZ0iMe6Y37U4HTTiZeiaEDJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_03,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Reason: safe
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
 arch/x86/kvm/x86.c        | 17 +++++++++++++++++
 include/linux/kvm_types.h |  5 +++++
 include/uapi/linux/kvm.h  | 12 ++++++++++++
 virt/kvm/kvm_main.c       |  4 ++++
 4 files changed, 38 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a2972fdae82..723f24909314 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10042,6 +10042,11 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 		!vcpu->arch.apf.halted);
 }
 
+static inline bool is_dirty_quota_full(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->stat.generic.dirty_count >= vcpu->run->dirty_quota);
+}
+
 static int vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -10079,6 +10084,18 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 				return r;
 			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 		}
+
+		/*
+		 * Exit to userspace when dirty quota is full (if dirty quota
+		 * throttling is enabled, i.e. dirty quota is non-zero).
+		 */
+		if (vcpu->run->dirty_quota > 0 && is_dirty_quota_full(vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_FULL;
+			vcpu->run->dqt.dirty_count = vcpu->stat.generic.dirty_count;
+			r = 0;
+			break;
+		}
+
 	}
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 234eab059839..01f3726c0e09 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -87,6 +87,11 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
+	/*
+	 * Number of pages the vCPU has dirtied since its creation, while dirty
+	 * logging is enabled.
+	 */
+	u64 dirty_count;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..632b29a22778 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_DIRTY_QUOTA_FULL 36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -307,6 +308,10 @@ struct kvm_run {
 	__u64 psw_addr; /* psw lower half */
 #endif
 	union {
+		/* KVM_EXIT_DIRTY_QUOTA_FULL */
+		struct {
+			__u64 dirty_count;
+		} dqt;
 		/* KVM_EXIT_UNKNOWN */
 		struct {
 			__u64 hardware_exit_reason;
@@ -508,6 +513,13 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+	/*
+	 * Number of pages the vCPU is allowed to dirty (if dirty quota
+	 * throttling is enabled). To dirty more, it needs to request more
+	 * quota by exiting to userspace (with exit reason
+	 * KVM_EXIT_DIRTY_QUOTA_FULL).
+	 */
+	__u64 dirty_quota;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 72c4e6b39389..f557d91459fb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3025,12 +3025,16 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
+		struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 		if (kvm->dirty_ring_size)
 			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
 					    slot, rel_gfn);
 		else
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
+
+		if (!WARN_ON_ONCE(!vcpu))
+			vcpu->stat.generic.dirty_count++;
 	}
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
-- 
2.22.3

