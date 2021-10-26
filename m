Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16E643B74D
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbhJZQid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:38:33 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:21892 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237426AbhJZQib (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:38:31 -0400
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFdZXW007385;
        Tue, 26 Oct 2021 09:36:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=wINwyy5S1GvOGvOrr7klj4vxD4nLz2KZ5L6CCD9F5ic=;
 b=OVG32C5cev3CUA+c9zbJ/80l14NipYPW2akiHyolP+lQ5iGVIq0uRElhg8bu5ors8Au9
 jdkHra/Ql2bQR1w/mhVQgRE2ufztargMFW2egCIUS3XCsj7Upw+w5rBH3jZ2Pa9LbvvW
 adAxkuyBmxM5AqsdjZT7qgWK+N5RNfZOXBE1irY1ZQdDQREIY0KlbhXf7hjCtRRsoFia
 ExRfATIpriiv+sLFhZN2BaY4bHYJEQYo0tVwLWDtvautXGguB/EB/ClnzTc2v8zFdstb
 Yq49KnUCxlAaHckwrdRHskMSsY8hO5zz0xr9QrfIvaOoQoNEy+IhhXnaLE4na6+Gj78o tg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3bx4dwhvbu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 09:36:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhdF2JYwXfySE0ZbVbf3eazn++DQhYHfQBHQuHKsmwKY7b2+PwsysEYixi/ULNBwIdTaJQFLhK+QiPV2S/7gzHviqHUkOKGUiCVz5agFSXL4ByPghvO1j6shkACdeOm9pG4Re3y0d/lKOBQBtrF10zKZhYzb7z0t3QlOVMYcxIxBlmQnMiI8KFEsqFSkLc9rTk1XyANZ8mwfbUtxnUy25V7t7c4gp/dLRZQGio+AGhNtMYeLBcwPooAPPwTV0ye5yTal8vAtWCr8JRAF3CMfbmIPKICDtkkhUxqH25VxES8vPQATuVe42ANZC1ZiAxeiq5VskCJDvCsXMmbnleueDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wINwyy5S1GvOGvOrr7klj4vxD4nLz2KZ5L6CCD9F5ic=;
 b=oRMhc30TwzkHbdsqtckFpFHydiNcm4WVHSU17CAE8NaRMhtjMk5g5yDY8MSIso8GJNTH+mngvzDgrjRl2rohJNNp2itzOjNPMAOqV50JoGc2JdjzkT2Q2NIJbF7YxD0Q9HOow1CEk0VOWtonV+NkhSY+bvr+TD0N/h/LnCA2KchU4cT10gAclKKwS/eK34qs4olEkQ7wXv/Iu89DbceeqNG2SdvLFNRQte+pfhssrR/4FmaBKjig+OMz1pIGpdAX2w9Jau4luh0su2eSzMhSWxfDY6PyzgJRRlsEye5bMDK3Uw9fDtDq4+tOQSQMKlaZTofndtGG4Jy8dGL/42lQTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3772.namprd02.prod.outlook.com (2603:10b6:907:3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 16:35:59 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:35:59 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 2/6] Allocate memory for dirty quota context and initialize dirty quota migration flag.
Date:   Tue, 26 Oct 2021 16:35:07 +0000
Message-Id: <20211026163511.90558-3-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
References: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by SJ0PR03CA0369.namprd03.prod.outlook.com (2603:10b6:a03:3a1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:35:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bb11eef-a55d-4ae9-3e12-08d9989eb11b
X-MS-TrafficTypeDiagnostic: MW2PR02MB3772:
X-Microsoft-Antispam-PRVS: <MW2PR02MB3772C3FC9E4DB399CCA779A6B3849@MW2PR02MB3772.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:246;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mcidw/YjlwDeBg/sM/rBweUyWYxkxLKaQxVl2oV2e1IOYvK/YbI3j3k748ZHZRCIFMP4NS2Go2AgRPmVlr+viiFB18n45W/VDyysydUHujdi/B1Zyorf5vFZ/PzTPTv8BXJKNRRXjXk4dqRV6r9UZJDSFR+b+Qtxhz4J/muPME73XvP6E921pcDwv4A7SkycBh5jb9AKgbRAykjcJvXmGkyaxkD34IKR/ce7PFGppzpmMofYs4sz2RcJ3UQx5Rnwxtvt9NQ5w4p7KPZShgqzbN2ZAqGboYK4GTH+rKy8SagFpZupFm5qAsyIWvCUmEQSgEWf35AG3YnxzPuzqiGUfk8T8mVo727yhfKL0N5glAA1L2uzNJWZ6073eyL5tUgdALXyazeUojYP2ztMVqzpuG1gYLdDLN8yNEZfIXhw1wsHWZ/Tg3QkzynmZC4ioNfOVciQY4R3MTFlv57AgOfdu6LKud0xRqNd14F8VAtJe5w+7sRvaoCNyVZ3R9zHfEYuUSFDiznihaO70r++o/vx20y+1eFdfVgc32bLQWZDRpW3cp0cyhMl0hik7ZAFUuIGxkgShI55tp1ZxNEmP9FM5eB/g1zaH9NBlUcGLGObE5k2IzxSHNMlmqQgQck1nYPu7HWSlg7Z4ZVj6i32Kj3LBHzq9pZbMnBojn+v4+96DCLH/w6MZU5cK1xw0RboyMullQRSoUTiZAaO4DPPpi3KvBpmAxpiolqYG9yqMcsSKL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(8676002)(36756003)(66476007)(66556008)(956004)(66946007)(86362001)(6666004)(2906002)(38350700002)(6486002)(5660300002)(15650500001)(52116002)(7696005)(107886003)(54906003)(1076003)(6916009)(508600001)(2616005)(316002)(38100700002)(8936002)(186003)(83380400001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E1Cq3PnOphKs21Ah7nHElZSvI1ERIMEHEtGN+8R3ftJ08VBQYoOUKsCgEgFp?=
 =?us-ascii?Q?G3duKUAFnGjPG7PEFxQKuAo8rVjxt9IUNCA36t2BZwG2AobrAi/Ue0fIJpSD?=
 =?us-ascii?Q?xWGxWHMiISiPJyRAH8jt8YCDparXJ/rn/LE2aYVYJL2Ah+2DscWfndItXpfu?=
 =?us-ascii?Q?3/DUJFbTYhtoOI1eXgnTSoryJicvyPD2Ogn46rOVVFmg+D09gSMyEtnORfx5?=
 =?us-ascii?Q?nwQ5bqff8reSfC6PUvUf4hGDMVhPiUpx/7hpRWVwZQYgu+ysjO3dquqzJzYV?=
 =?us-ascii?Q?We7Ur3ePBk/awXoEUOAZZATUNW07q4z1RxWuDNM74lFX3UJszusHpR338xdI?=
 =?us-ascii?Q?M3f69DR4pm4E67hxJuicYSpUqQzOWGWILtL6XLRKVkZOFINh/OkPYl3MNsIP?=
 =?us-ascii?Q?QxACEX4111xwntAxZAaw200Afjaj4VuGhlqCXCYXiRBTf8bz9rHdVT6dAfVc?=
 =?us-ascii?Q?nr0Xi6xmlR3t9ihDN0EiNZU2gDO+3ytP6NSMIQm8oD46SJobAdMGYFS7kgd/?=
 =?us-ascii?Q?vO9AJBfkL//I+OE1IWfiDJSzYVjmDvOhM8SqfIXexGKH2iqc8x1iY0FNQCwm?=
 =?us-ascii?Q?f13G3KksWZZ1v606Jjoz9MYjfBmHgoFyCCoxO9+bVzdvVZc11UcVPV05pKZQ?=
 =?us-ascii?Q?1BDa3gODvmOrOQuWGj4CcaXHKQopbSpf9zqF3Vf1DQnUhFCKJWHJAsF6SxvX?=
 =?us-ascii?Q?bMJbVtg3j5Dsk7Qd09AJm9AHSgHiIHY43MLlYleq3TreemtNspbHZlsc6qB3?=
 =?us-ascii?Q?A5LpTD9F4HOno5ZtBtRNPUaDYIsm9zHM1RqZKmBuEvcxHsjUexqQlkV9j57d?=
 =?us-ascii?Q?nancjdSLvuAVzbEuXDWq25QyDCA8pSJd7cfC0sxdb6z5if1BDV1/y369tFWt?=
 =?us-ascii?Q?05zgyMUYrHGg8sh3DRSKVMFP/hHUTP3RxedWI9Dkp0/wGcQOBNfLQcHHSB1z?=
 =?us-ascii?Q?MeT3mzcJcHluHjjd2uAPigJGrMjiXXYxvIhCSXIpSk0CoM2vA1KZz/C2ma6D?=
 =?us-ascii?Q?PAQMTU9XBafZwPDZwSqGGMAdO2gdXRlPpsmPCUXLVDftaICHD5jkZHDSOVYw?=
 =?us-ascii?Q?PiGZu3qYYVoyuFYEVJ52AoEW5rJAuGP0HlVxFbc9VQso5Ce9rFyIZ4yIme4P?=
 =?us-ascii?Q?cssDsWNuTITiks17tcwKa1T6JOCc3qRRE+5IBMdT8hRHMrTIKWn+4m6PpFSo?=
 =?us-ascii?Q?R4sLNbXE2g7IxjTkvheKS0Ubm94slH/hYTK3jrvGUNoR/DQzSe/rv4OxD1a2?=
 =?us-ascii?Q?NSy8aFJNP2xDs8gfoWrHxVcTwXZ6au33grGk4kQHz+BweeW7aUd0FKVxp3o6?=
 =?us-ascii?Q?hrbuVQBJ5L9+d7EASZooFYoHdm1DSP1FD/jskTXtoQQfbw0P0t99I2u9+eZY?=
 =?us-ascii?Q?0XLw0aNiG4aw3l4kCk8Y6nrGxpGuISbluGeq1z/ag85Yc11hGuqf3J2GPAPQ?=
 =?us-ascii?Q?EZiw3mAGQdWGlA365IpRD8lnGq4HYKMbah23tWxZb+KCXDjZJtZnHA94J2QI?=
 =?us-ascii?Q?rt7KcJJVCAQ1F2KoBieRg3qFbKsvWiuZszRn5ArbynD27Y24aQbdC/2c9PND?=
 =?us-ascii?Q?jp6Z7xRwzDW+RkZ18fNBcMLc80y9ZHHUP9acBdF7U2HSali+cOu3kNyVe/O6?=
 =?us-ascii?Q?nRnqn8USgcV22go1VmOoCIRDb4SGrxjmKh+IL6oO+N8axIr87FAL0Iv05MxH?=
 =?us-ascii?Q?5PuKln+7P/+7Sn1TjcbxSSeslQg=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb11eef-a55d-4ae9-3e12-08d9989eb11b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:35:59.4547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HUN2rSODZzw4NAr83V9OWSdd1O1+mLGX152Dgm2yvjSwzJIblBkDAOSbqrqw9Adk7wGtpgdODoHCVHSh5/Vp682z02yQ8Q8920lWsC5tmhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3772
X-Proofpoint-GUID: hPz0qcB155pTRfxH-dU1e83YdNN6SwMz
X-Proofpoint-ORIG-GUID: hPz0qcB155pTRfxH-dU1e83YdNN6SwMz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the VM is created, we initialize the flag to track the start of a
dirty quota migration as false. It is set to true when the dirty quota
migration starts.
When a vCPU is created, we allocate memory for the dirty quota context of
the vCPU. This dirty quota context is mmaped to QEMU when a dirty quota
migration starts.

Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
---
 arch/x86/kvm/Makefile                 |  3 ++-
 include/linux/dirty_quota_migration.h |  2 ++
 virt/kvm/dirty_quota_migration.c      | 14 ++++++++++++++
 virt/kvm/kvm_main.c                   |  6 ++++++
 4 files changed, 24 insertions(+), 1 deletion(-)
 create mode 100644 virt/kvm/dirty_quota_migration.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 75dfd27b6e8a..a26fc0c94a83 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -11,7 +11,8 @@ KVM := ../../../virt/kvm
 
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
-				$(KVM)/dirty_ring.o $(KVM)/binary_stats.o
+				$(KVM)/dirty_ring.o $(KVM)/binary_stats.o \
+				$(KVM)/dirty_quota_migration.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
diff --git a/include/linux/dirty_quota_migration.h b/include/linux/dirty_quota_migration.h
index 6338cb6984df..2d6e5cd17be6 100644
--- a/include/linux/dirty_quota_migration.h
+++ b/include/linux/dirty_quota_migration.h
@@ -8,4 +8,6 @@ struct vCPUDirtyQuotaContext {
 	u64 dirty_quota;
 };
 
+int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx);
+
 #endif  /* DIRTY_QUOTA_MIGRATION_H */
diff --git a/virt/kvm/dirty_quota_migration.c b/virt/kvm/dirty_quota_migration.c
new file mode 100644
index 000000000000..262f071aac0c
--- /dev/null
+++ b/virt/kvm/dirty_quota_migration.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/dirty_quota_migration.h>
+
+int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx)
+{
+	u64 size = sizeof(struct vCPUDirtyQuotaContext);
+	*vCPUdqctx = vmalloc(size);
+	if (!(*vCPUdqctx))
+		return -ENOMEM;
+	memset((*vCPUdqctx), 0, size);
+	return 0;
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7851f3a1b5f7..f232a16a26e7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -66,6 +66,7 @@
 #include <trace/events/kvm.h>
 
 #include <linux/kvm_dirty_ring.h>
+#include <linux/dirty_quota_migration.h>
 
 /* Worst case buffer size needed for holding an integer. */
 #define ITOA_MAX_LEN 12
@@ -1071,6 +1072,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	}
 
 	kvm->max_halt_poll_ns = halt_poll_ns;
+	kvm->dirty_quota_migration_enabled = false;
 
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
@@ -3630,6 +3632,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 			goto arch_vcpu_destroy;
 	}
 
+	r = kvm_vcpu_dirty_quota_alloc(&vcpu->vCPUdqctx);
+	if (r)
+		goto arch_vcpu_destroy;
+
 	mutex_lock(&kvm->lock);
 	if (kvm_get_vcpu_by_id(kvm, id)) {
 		r = -EEXIST;
-- 
2.22.3

