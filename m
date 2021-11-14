Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5147144F8A0
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 15:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhKNPAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 10:00:47 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:2544 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231264AbhKNPAo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Nov 2021 10:00:44 -0500
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AECuxJV022116;
        Sun, 14 Nov 2021 06:57:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=dXyByt2g8ErNM06zgs4JxmFUlLxtf//NQ8921p5QPq8=;
 b=UcapppDEHr+eLqx1HOflYEOdeeFeTbv92QNgq8LcVg0SOoHzaK2yTWL7uEwRyppGdWgl
 LtjySMMKGSPIwGckAvbv8tVdJGeziLfr5TUVgc6jdAjJJVyw3OG9Cyj5sp4ohgip8pBE
 m8wG2LopFIjn+CrV+zRaPl2WTjAYqIohOe3Z6G6BT3GpZlmsFxQeN55syjCayhdx8OJB
 lA7sWMqgBYmJvqWEMsySHQ+kOqJP9F6r9zF0Tffc40EBeDY/eRZGCg5/sT5Nis+5790X
 Kj3nAP83J36JYH0FDXNNo9Qa565hB8+j3m88bok7PpAut6b+50jqtgbx/MPuk4hqNLgB ig== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3cads5hkdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Nov 2021 06:57:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIuRxA2l0JrWNQwGRjqHW0nS8+ZT7G8b7s8WPCFokmTCz/gmqlk08zSU3/eM3lPDF/PXy4ujILNFY/c7yEtHees+GUZ8Ru7Vs+hiHSDO/yiozWKnAgBM2tFtrHrttN4+P42FkufWoriWgmO3aAXUYjyLy8eO5vuWSPfJROjc6koBxMtsr7YpnY9NHFdTABmFWcZTkPwAKGlMif9vZ0rBx3jAyU1lnYU6NrnIG1Y+zh3LZAYLGhl4KY76wLfaYeE0kO1yoJATo1R1ICA/G3vsAX+mv+LyLt6FrFDfYKo1girJZ3C8IqSOOsjPzMk9fY+E1gUysCvOeJth8+a1Zncl7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXyByt2g8ErNM06zgs4JxmFUlLxtf//NQ8921p5QPq8=;
 b=jsUPUEDhJ3hx34J9dx9yAmt4dm9G29ktVis3UcT7Z/vWl2s3QftCqM54QE9Y/hPMFm+dhLTrlF+R/aFqAtlDrfJw1Z/qX70uetyGV9Yj36p1uU2154KMkbQKhEJr+kMLzZYwxkh/Kdx0JHJx+6tqbgNRPjiqmi/jcDOfH/1NmsffqnRj0YHQG5W2CONn8iYpONbH47cxJCLWTlgaIqVHk4oPZMSs74MOInqU7W58Xvos5aTB0WqMM/SQktH69wJjLRoOirnvyJpYDVUk5jyROkTvwOzwW9PsoRaskKCJHQ6SB4UtHqCZDDQLNx5Ugoh7ftE1jwArTDtBrB0EkJzaIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MWHPR02MB2528.namprd02.prod.outlook.com (2603:10b6:300:40::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Sun, 14 Nov
 2021 14:57:47 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%9]) with mapi id 15.20.4690.027; Sun, 14 Nov 2021
 14:57:47 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 3/6] Add KVM_CAP_DIRTY_QUOTA_MIGRATION and handle vCPU page faults.
Date:   Sun, 14 Nov 2021 14:57:18 +0000
Message-Id: <20211114145721.209219-4-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Sun, 14 Nov 2021 14:57:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58861d44-7bab-4fa6-adfb-08d9a77f1eb8
X-MS-TrafficTypeDiagnostic: MWHPR02MB2528:
X-Microsoft-Antispam-PRVS: <MWHPR02MB2528F68F1B18CC330088342BB3979@MWHPR02MB2528.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6tLTpBEjH5vihOlyAShCPrb3wXfukAAH7ejXuA3mVzR1v3B1CfuwQD+X33uOng6t8s8kYhjEFt6C5VBDct+jHOUtMCWUYRzrT3xgcpA378MSfwnMumJ+nvGf39fJxu6C5d7mRrlWK0uJ1UH2ZYQxc5GOaXKFrM3/aplUmgEv/6eddCRa3+WEFXsnWj8MXX7C7cBHYVCKh1PA7fH02R8nO/LHwrQJAx5f4dEX7ODJvpvTVInEYPTmmgS7ewGZWpQnT99OyzexT6rNuwyTXy4L1BVbQtrEFuIs09W2AI4ErFx2WPG07Q6vdOM6+QZQUxO8TT7QIlQlw1h3MNsoZS+kUqAX8cOKxl9G9YAyBnzvV7D52xWh5h3rFok3bZbmZ0E/phchzA9z0ElvSipw6mRseU+nQFjwVP5rq+0Y25z3v5buKT05l7ADUOwtaOErx3UqUphRoXjAl3SXWHN0Wi2p8mqeubumDZiracGCMVe02H2/rZ5dRXdMhrg3WINYBdmVBo0RsZtdaUnEeSkPjW89JkiqlEon1hFwIYMWaPaGxQjaILC0xmW2bjFHFg/2ctgW8A6WFhFrIuxP6PuW/cyTBq2A99IXgDnYSqiGV+pValq/cejnzHK657GinOUd+mFFk4+8vyUsv7edpLxyyUplcNaQtmzu5W3Li/5XSUONxkcMTV4fGrIjardxuNVbTO7tcDNIhbS4GOKs4Pri6pWgh24ym4H3CaK1Qf+yBq9vSAw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(66946007)(6666004)(6486002)(316002)(26005)(38100700002)(107886003)(1076003)(186003)(6916009)(83380400001)(956004)(36756003)(66476007)(38350700002)(508600001)(86362001)(2616005)(8676002)(8936002)(5660300002)(7696005)(52116002)(66556008)(54906003)(4326008)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/MVlLWXLNPDwX0aibVPORORBXsRK4JSez4G9w2daHfYOSwD+31NhL+2foy8S?=
 =?us-ascii?Q?7QU2IjYs4JIFJqifJRZtFKyg4+ocRQKOFQ07H/hcgTHSP1RImIR+M3v26lK6?=
 =?us-ascii?Q?zbemnt9SDKCwxz4Fs2f/pC+3YqTD2LI2vV/MetXgmNRyN1Gd0MJAVdOo6ShP?=
 =?us-ascii?Q?kyO2KB2+EanVVcqRNp92hVjdquhaES2fcEBe6ppw4XlxYEaVZJd1KdEkyeQg?=
 =?us-ascii?Q?Lz0wq7PTzxSwNaSgRsOXu6zXE1oPw2pp566vPQgDSPIzs0FrvNEhHBkKOY78?=
 =?us-ascii?Q?+Ddt9CG8LntSRjWdY5cpZaYcsr4JOIrG2e0hStHO6LFQKIECSKWzXsbf5c/n?=
 =?us-ascii?Q?eKwvmMIvep0L1ghRF7Pwl5KzU9P1mwMqVL8XlOrymtDHGMruj3rhaPFjsmSv?=
 =?us-ascii?Q?HqMpkBViULaJU83lRmCmW+69leLcVjSeuMI7nW7MLPT2AMaf6IQR+oadb7V/?=
 =?us-ascii?Q?2u/ezroN0BoVRcuv38gUZdvMFLdNJFeiWNQ8WpXZ6FrJD2HjRs0O6V3y+mKf?=
 =?us-ascii?Q?TQN4gOTAqwok2VLH/C8MuUMzpeO/Jx+HvYPTqYb8zhhKSWIShQhcSdkQ72wl?=
 =?us-ascii?Q?9vUfGkFbLWZ83QnOq2BP4sgACvso2sOWJvn4OIlO0hZXZNhhnw0SCBzIw/gu?=
 =?us-ascii?Q?1yYp7hhiVUSLgNvNQoiHWDJwlr048t2XrUJGjx2d07WIE30U2TYnX5OnGD2F?=
 =?us-ascii?Q?Tij9quxZgG5dUphgI4esLn9JChVg2PYfiNxCkA36ifasm0rq4TJ/8JksXdrd?=
 =?us-ascii?Q?IpuxsSGIngi2vly8iWA1TCnagNEaPeVItXxGw1sQ3e63lnbvGu5fb/T5xS5J?=
 =?us-ascii?Q?OgSXppWzi0SwYRgcsm/8kVvGPROduAqBUubTh3MNgcnWQrKChX2m4vHtkS10?=
 =?us-ascii?Q?fTcLP9YiSjqPyJxEz7DESWNqr8mS7l5fQX6zcaWrrAf7/8jrxkd78cGXoJRd?=
 =?us-ascii?Q?puuL9Y1wF3U0EQwFuNClLwwtj3cTMUIWffOv9Xtu5iXzsVuc+58gSwIXtGZb?=
 =?us-ascii?Q?QrWWuY2pG1zO+lPIcVP8vxI6iPPoMddhXSr8kOeCC3jHK96ttNq90XxHzzJV?=
 =?us-ascii?Q?n3nbGxbEfR0c/1y6Vr7/Q38iONDlu3M74Kbs4ukkuROgZ5dl/yk9/36pjmlb?=
 =?us-ascii?Q?YNv4qilg8IJuf900TPOx5DaMkggdkdlm9ieUgrOEoLYMjMNTys9hXHuwPaCB?=
 =?us-ascii?Q?qOU5BLn3AnVIG2UdwSNaYIK6t+mDyESE70uDV5Xg94q3lvk6ynRGZM55u4qm?=
 =?us-ascii?Q?fUQpEVq9QXSlqXJfKapJF582TRZMAJt/KARt2Hqu5EPgH1y1rL58yoJ6ABLb?=
 =?us-ascii?Q?9M3pfiTJVJ4nKhyNLZTLB33GWRUiiYNKsh8SXOYcNs1nXJ+8eidIWU8GvQK+?=
 =?us-ascii?Q?yztAhFGvZieIuywAvzqw2T4KhSj0FxUOXeXm4eZelWMztuVOh8eXzn90eUWn?=
 =?us-ascii?Q?RyYpGYXOELHMtpYkTHyY3EE0SZcIE/gbShC0JdjG1RsM/+SEFLiDnt4FXOtC?=
 =?us-ascii?Q?oVdvn5THMtUoQ3wE14T0evMw3idqjctvNRTJIkeg7S34Veczjhhu7xBa+ayu?=
 =?us-ascii?Q?IUrXRVqmeUr4nxgzuWjiysbTENk2l8De/vaQVe4BdE8ElxWZlmYDg42mokMW?=
 =?us-ascii?Q?Z1l8290KotN79OUJqfpnofMYntf4PiUhZwu3HGdzq5mwprErCfqufzEw1K7B?=
 =?us-ascii?Q?EIuMye2HMR+QdXc+RHYYOvRjfHI=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58861d44-7bab-4fa6-adfb-08d9a77f1eb8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2021 14:57:46.9970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3NZQ6m0uC6wCRGym3TSjbtZ6fyyKm55g0q9ly1gqt8aYT4A2RapwEOCTkV5LX8IIFqfYHwmJ2o3KRZEC5Fg0s4C0OpTucR3lBVRoEygw4p0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2528
X-Proofpoint-GUID: ZKskdNqOXyVLuFzjMU0E-WHk7WZHHak8
X-Proofpoint-ORIG-GUID: ZKskdNqOXyVLuFzjMU0E-WHk7WZHHak8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-14_02,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a dirty quota migration is initiated from QEMU side, the following
things happen:

1. An mmap ioctl is called for each vCPU to mmap the dirty quota context.
This results into vCPU page fault which needs to be handled.
2. An ioctl to start dirty quota migration is called from QEMU and must be
handled. This happens once QEMU is ready to start the migration.

Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
---
 Documentation/virt/kvm/api.rst        | 39 +++++++++++++++++++++++++++
 include/linux/dirty_quota_migration.h |  8 ++++++
 include/uapi/linux/kvm.h              |  1 +
 virt/kvm/dirty_quota_migration.c      |  6 +++++
 virt/kvm/kvm_main.c                   | 37 +++++++++++++++++++++++++
 5 files changed, 91 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..6679bceee649 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -277,6 +277,10 @@ the VCPU file descriptor can be mmap-ed, including:
   KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE.  For more information on
   KVM_CAP_DIRTY_LOG_RING, see section 8.3.
 
+- if KVM_CAP_DIRTY_QUOTA_MIGRATION is available, a number of pages at
+  KVM_DIRTY_QUOTA_PAGE_OFFSET * PAGE_SIZE.  For more information on
+  KVM_CAP_DIRTY_QUOTA_MIGRATION, see section 8.35.
+
 
 4.6 KVM_SET_MEMORY_REGION
 -------------------------
@@ -7484,3 +7488,38 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_DIRTY_QUOTA_MIGRATION
+---------------------------
+
+:Architectures: x86
+:Parameters: args[0] - boolean value specifying whether to enable or
+disable dirty quota migration (true and false respectively)
+
+With dirty quota migration, memory dirtying is throttled by setting a
+limit on the number of pages a vCPU can dirty in given fixed microscopic
+size time intervals. This limit depends on the network throughput
+calculated over the last few intervals so as to throttle the vCPUs based
+on available network bandwidth. We are referring to this limit as the
+"dirty quota" of a vCPU and the fixed size intervals as the "dirty quota
+intervals".
+
+vCPUDirtyQuotaContext keeps the dirty quota context for each vCPU. It
+keeps the number of pages the vCPU has dirtied (dirty_counter) in the
+ongoing dirty quota interval and the maximum number of dirties allowed for
+the vCPU (dirty_quota) in the ongoing dirty quota interval.
+
+  struct vCPUDirtyQuotaContext {
+          u64 dirty_counter;
+          u64 dirty_quota;
+  };
+
+The flag dirty_quota_migration_enabled determines whether dirty quota-
+based throttling is enabled for an ongoing migration or not.
+
+When the guest tries to dirty a page, it leads to a vmexit as each page
+is write-protected. In the vmexit path, we increment the dirty_counter
+for the corresponding vCPU. Then, we check if the vCPU has exceeded its
+quota. If yes, we exit to userspace with a new exit reason
+KVM_EXIT_DIRTY_QUOTA_FULL. This "quota full" event is further handled on
+the userspace side.
diff --git a/include/linux/dirty_quota_migration.h b/include/linux/dirty_quota_migration.h
index 8c12fa428436..b6c6f5f896dd 100644
--- a/include/linux/dirty_quota_migration.h
+++ b/include/linux/dirty_quota_migration.h
@@ -24,9 +24,17 @@ static inline int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPU
 	return 0;
 }
 
+static inline struct page *kvm_dirty_quota_context_get_page(
+		struct vCPUDirtyQuotaContext *vCPUdqctx, u32 offset)
+{
+	return NULL;
+}
+
 #else /* KVM_DIRTY_QUOTA_PAGE_OFFSET == 0 */
 
 int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx);
+struct page *kvm_dirty_quota_context_get_page(
+		struct vCPUDirtyQuotaContext *vCPUdqctx, u32 offset);
 
 #endif /* KVM_DIRTY_QUOTA_PAGE_OFFSET == 0 */
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 647f7e1a04dc..a6785644bf47 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_DIRTY_QUOTA_MIGRATION 207
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/dirty_quota_migration.c b/virt/kvm/dirty_quota_migration.c
index 262f071aac0c..7e9ace760939 100644
--- a/virt/kvm/dirty_quota_migration.c
+++ b/virt/kvm/dirty_quota_migration.c
@@ -12,3 +12,9 @@ int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx)
 	memset((*vCPUdqctx), 0, size);
 	return 0;
 }
+
+struct page *kvm_dirty_quota_context_get_page(
+		struct vCPUDirtyQuotaContext *vCPUdqctx, u32 offset)
+{
+	return vmalloc_to_page((void *)vCPUdqctx + offset * PAGE_SIZE);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5626ae1b92ce..1564d3a3f608 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3519,6 +3519,9 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 		page = kvm_dirty_ring_get_page(
 		    &vcpu->dirty_ring,
 		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
+	else if (vmf->pgoff == KVM_DIRTY_QUOTA_PAGE_OFFSET)
+		page = kvm_dirty_quota_context_get_page(vcpu->vCPUdqctx,
+				vmf->pgoff - KVM_DIRTY_QUOTA_PAGE_OFFSET);
 	else
 		return kvm_arch_vcpu_fault(vcpu, vmf);
 	get_page(page);
@@ -4207,6 +4210,12 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 	case KVM_CAP_BINARY_STATS_FD:
 		return 1;
+	case KVM_CAP_DIRTY_QUOTA_MIGRATION:
+#if KVM_DIRTY_QUOTA_PAGE_OFFSET > 0
+		return 1;
+#else
+		return 0;
+#endif
 	default:
 		break;
 	}
@@ -4273,6 +4282,31 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
 	return cleared;
 }
 
+static int kvm_vm_ioctl_enable_dirty_quota_migration(struct kvm *kvm,
+		bool enabled)
+{
+	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
+		return -EINVAL;
+
+	/*
+	 * For now, dirty quota migration works with dirty bitmap so don't
+	 * enable it if dirty ring interface is enabled. In future, dirty
+	 * quota migration may work with dirty ring interface was well.
+	 */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
+	/* Return if no change */
+	if (kvm->dirty_quota_migration_enabled == enabled)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+	kvm->dirty_quota_migration_enabled = enabled;
+	mutex_unlock(&kvm->lock);
+
+	return 0;
+}
+
 int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 						  struct kvm_enable_cap *cap)
 {
@@ -4305,6 +4339,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 	}
 	case KVM_CAP_DIRTY_LOG_RING:
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
+	case KVM_CAP_DIRTY_QUOTA_MIGRATION:
+		return kvm_vm_ioctl_enable_dirty_quota_migration(kvm,
+				cap->args[0]);
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
-- 
2.22.3

