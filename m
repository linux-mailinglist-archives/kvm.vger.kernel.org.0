Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4F644F89F
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhKNPAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 10:00:42 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:20634 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231264AbhKNPAj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Nov 2021 10:00:39 -0500
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AE6wp5Y019791;
        Sun, 14 Nov 2021 06:57:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=Oam9lbGvRweP0t9ni5u8rbi7KrYiJhOkDfDEsdPNXGA=;
 b=MHkNG975cnou8pn6fAsuWdYL3fX7PaPSn7hyOnbAMVmcAXu1roRZU0dNL8sK3cehVXGT
 wtzYZCrZbHKekB6JNagTChbrcDO/4gssGabp+m7mqIrGOkbb/5qI7mxPUd7Gf8yFNch2
 /nsFefnC6BOYDuCZKnSkwEyuLJAGLKCd+bcB3DBsQPGbd2mbWN45jRpH2QNrrnQSwhT7
 JxfAQnJKeQXBJNwoUcyafNPd8LX7B6p1s7voNQB63xrD30oH8adKC0Fti4TUd700ezyZ
 Y+LxW+FE9+HvaCWP5DIgm8NxpMVaWwft+TVIpoESEfD5JdLeBiPiNUAf+jDAjdInu9hG 4Q== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3caa5d1u42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Nov 2021 06:57:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KajH24Qfr1f75C0GZ5US7Hlc7zP6Sg7Buw2IcVYAXqY7E8Wd+L3xMBEzz3iY6RanTsKLxQvCdAPt3S02QPMH0/+Q8+lrcnrnumhEGDUCx92hGs5zNozmP/6PpeRKBy/GoOOJsbQ1lK0uo1AMKxVqn5VupUlHtJPqSXNIRrMlLnzuv/NoPyubuExfpjWzhFth8O8ChN3am48TJixszUmYkVwEMzvfoylhTciFs18aQh2wgl8fVBM2FzfzNZn4rll9fe28y1LwwpSlDxREKzUcZWroyIyDmr5hKliF5i6u7T8+GM6SYQKBN4r++TYpcQBrZmrN8s6ch26ecydok9Py5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oam9lbGvRweP0t9ni5u8rbi7KrYiJhOkDfDEsdPNXGA=;
 b=K5k2dUT/tCggulpdA84HNToeQQWqgEpXs4gRXB7T6L/k7uxb7llOvfoL97ECQ/NzXfuMtqUJsTI0Q9i53sSI4as/D548qjXb6s+aL5Cies15KpsTJt1RlTYU1q9ff/2U02D6EFNiSI3prQGqt2IIfhdPk8hF5+RhxDoFFhQ7iLff5ouvcgSGaR2IZY3vQU8+VpYEoVdOf7jqaay1fa2ayqAwvOnidqrayJqSZf9y/1M4mKbSjuvzs5h99hdSbwy5udbY6DihMEhMnmmPtF8K3fXFxTG/VEp9TEzakCJ/gvwNHMCDadNowxhxtxVSNr9izmqKYm2/kNsIOJKKQ1TK6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CO1PR02MB8618.namprd02.prod.outlook.com (2603:10b6:303:15d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Sun, 14 Nov
 2021 14:57:42 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%9]) with mapi id 15.20.4690.027; Sun, 14 Nov 2021
 14:57:42 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 2/6] Init dirty quota flag and allocate memory for vCPUdqctx.
Date:   Sun, 14 Nov 2021 14:57:17 +0000
Message-Id: <20211114145721.209219-3-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Sun, 14 Nov 2021 14:57:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4d2603a-cad9-44ac-f3b0-08d9a77f1be9
X-MS-TrafficTypeDiagnostic: CO1PR02MB8618:
X-Microsoft-Antispam-PRVS: <CO1PR02MB8618BD5188E3D10EFA5BB3EAB3979@CO1PR02MB8618.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIkETJu3OrmY3IlSCpoqSV6Rz5TMY4ko4UwYVPjeAN6g5ui/UChIA4PCSUaEqoiKdOHQzUif7ZPaTySBIswjHg4q8E1rma65fDJ7LoUb46sMdu2lHfe5Vj/3rtabj9T6s8ptxekkxaUDWcAZCoJlOqPeT727FbgX3P5nervgG8EkqY+ijwLkulh7vr1TSVuL/L1VqvLDmVFXvIrZJnKhgXTgOn2NyqU2/XNRLtHx+5gi8UPnd7bmdcdpR0G79AATx22Bj/aOc64ufNnfZmxGgmaTk+eECKSuYV+o5V74NI9tvAiyFnXLwE7QwtmwdAnwA9u+ZGkocODPBoNLNbxY9ArQuPbFOkOehlMP9sBf6nxYglmfqYQJsGgYIshcVRIRyJz/D754Jwi3Ov3N6Bb0YfDmLGc0TUKSl6nDVuAQaaK3UZL7S49TJE7Mdl/Y8LT+4FgrLo4w8iqqHnwhKyisWuyS91HtDPbipuV32FJhIQzHiUXoYInwASZIgvYVIWKV6VU0dfiWLuecu92tr1lXIN9tzdXBBs2rWrgC/RJXx6LCATBeEPM7cQetZ1ciYJEyOvHxvOO+QyIaHJ37tcbpb4XTaTjQ9fSTrtOKsnP8zHAiE+InO1UMMyilKE8kf9XvGpeUpNkfEQjygKcC1SRiIhQ8wDT9HFdBgXzIaQljtUeAIVDt+55F3SCfydJLsprnBPuYkTgP6DqfB25xFsxWGx7eWdv+SNCwDsHbXuaLNAA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(38100700002)(38350700002)(7696005)(26005)(36756003)(15650500001)(66556008)(1076003)(6486002)(52116002)(5660300002)(186003)(2616005)(6916009)(2906002)(508600001)(8936002)(86362001)(66476007)(4326008)(66946007)(316002)(83380400001)(6666004)(54906003)(107886003)(956004)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jb3PxGbH/lWOa94KavnwjkxW8bQMKbXBRvrms3vqNTr2s3fXaitV1CthNOd6?=
 =?us-ascii?Q?6UoWNk4oigjE4YOQqlI0F73jddn9RWxWb/3SWrJIEHNXVL7GDZX8zKEy+qg5?=
 =?us-ascii?Q?CVsy70GFCbhQO67nUpThxFwXM/EXEjLCqLZ82DqhJEhrCtSpl24yr7O5RI0O?=
 =?us-ascii?Q?dBttCAiC2X2YVGyR1k9GYhPyjK2m2v2W3s0zF1FIB8hIRPxhRV0iwZB6RUlf?=
 =?us-ascii?Q?2X62NXGk2VaZbakYulgazn6cFBhgVQSc9ZHpQ/5JSrCoDXa541YHDsly+Wxa?=
 =?us-ascii?Q?nnThxmlSkdGiKVc1mOCebasl9j3oc43yK7EB0prKentozwdPgyAhF6Tnw/Y1?=
 =?us-ascii?Q?gERZUkC6x/sjPPX7e+ua78XF87Txp+M/GFC3iDh+d5um5t8b6UEefF/XNgmc?=
 =?us-ascii?Q?hIsHmSCCVdIi+D+utZf14sOghPVk23ZOz0cKdrhANevsWK7PdSAEhFurfyKJ?=
 =?us-ascii?Q?jgkMO22i2bOY4xI5byThjTP6ciT8uby1QfwwdB9UDUNUF/lHGKB3GyeaTT7+?=
 =?us-ascii?Q?okVRIIUwXle9hm/TC/frASzjcpXc+W15SW5cHw/WXBu3QvatIF8tqXWSKImn?=
 =?us-ascii?Q?DrucWPobP7M2j+LXTLaJBDyuynxJ77D+MVpRK7/RLTyO6aboGLErH9hcgPKz?=
 =?us-ascii?Q?szbEX5VQL4rekbUfxexTzhRe7mOgoSYVPvRLXAcJgpyFx8AkbcACqWSafV3i?=
 =?us-ascii?Q?IBMxSsHg+EFLBLGtcz1r8q0JFMVeILh6lmxwl0flqifU7CTz/GlD4La6SMQI?=
 =?us-ascii?Q?P1J71/nIjS4QDDkxYxwUk6RH52NCdiV0+kD+6uktTCGSDAtW+o6lICk0Ouv8?=
 =?us-ascii?Q?FoAaxBLzclenrGkHtwAMcfB1UMOtez3YI9PY40rtQMnDGx8nZO6AufB0a366?=
 =?us-ascii?Q?lqxtrnMh5U/OIohmXsBaDQ4sL6Z08w/3Y+UHqW/R7dOn62TbDqrPgDjt3DoR?=
 =?us-ascii?Q?wDCXSOVzR0ocRK80oXdKbQb3vGU9vdzfZs7CsK4LM2upv6/FsOzgZMZPzJmP?=
 =?us-ascii?Q?ob7udQXKssv+I5IR5pKiIJ0NR1wz53RSErJMfMmlQq5njfj62/bJA0194DHd?=
 =?us-ascii?Q?Yx2iziw2Hr96Va1OB/Tx7WDonYE3eoMMk5Yu6jEskIgmurVrXDGJIKQ1BCbQ?=
 =?us-ascii?Q?9uH08yTh8TDfVX1fZLHcvAQW7G7c1O3/nRC3nDNBF+qDLuQhGM/pThvzKnfz?=
 =?us-ascii?Q?ibAG9g5liNSF/obstYipU0IFPVNVA35L8zyb9HKVQ8qFTrBPVjdkubjEnE3m?=
 =?us-ascii?Q?eLpsBQwR15WVBfX8Gt02fvmRpgeh1TMDS3cTI22+VgqZR0/H4Bz1Gdb4qPcF?=
 =?us-ascii?Q?zsQBCSm54N45HX6MfTJneLE//zLUAOrLU+TTHDkWg9fL4scYijRtqNdAociO?=
 =?us-ascii?Q?SoMuvHA2JBH+Y0AHGDO1m2Yn8WwLZq7v4KpyGRVCkL/6fwCrVPDs2XCGsBG6?=
 =?us-ascii?Q?dxVSLN1ttKuRp0PxDuoWj99Lpc1nG2ncaCs+EcNaiIUsHUL6oTgMRxFd8NkZ?=
 =?us-ascii?Q?eeREHBSyGTNUBEvUwCdyI2qTeA/dp0//ndQYC3oTK1wdfQFds2XgvjPGQaXe?=
 =?us-ascii?Q?fmc0NksYdFxaPqJG+fMs4eo4q3YY3icaGEMU/XpLVwK6skc0KbLv2IBoDyc8?=
 =?us-ascii?Q?yzSDJST5OTh1XltKjVbDk3JxuUtVQj4ffEfB7Gtuj9qEfQDNwCXAxwCQLwNU?=
 =?us-ascii?Q?2n/PSHQV4sY+ncbUP0PPy7+jOMU=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d2603a-cad9-44ac-f3b0-08d9a77f1be9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2021 14:57:42.2181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r1GOnYbtXPhWD4JOWSU5xkMNk16el/grYaeJXxm5g4q92zKARbgvaiByDEovXIiR1XsuX3wCW7NEnHx69Ra0LOzgZ3mSOsZ+f0PRixSUzD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8618
X-Proofpoint-ORIG-GUID: w69JDDy4_9mkGHzWR1v0C5LgCL0k2xBN
X-Proofpoint-GUID: w69JDDy4_9mkGHzWR1v0C5LgCL0k2xBN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-14_02,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the VM is created, we initialize the flag to track the start of a
dirty quota migration as false. It is set to true when the dirty quota
migration starts.
When a vCPU is created, we allocate memory for the dirty quota context of
the vCPU. This dirty quota context is mmaped to the userspace when a dirty
quota migration starts.

Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
---
 arch/x86/include/uapi/asm/kvm.h       |  1 +
 arch/x86/kvm/Makefile                 |  3 ++-
 include/linux/dirty_quota_migration.h | 16 ++++++++++++++++
 include/uapi/linux/kvm.h              |  9 +++++++++
 virt/kvm/dirty_quota_migration.c      | 14 ++++++++++++++
 virt/kvm/kvm_main.c                   |  8 ++++++++
 6 files changed, 50 insertions(+), 1 deletion(-)
 create mode 100644 virt/kvm/dirty_quota_migration.c

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5a776a08f78c..c4270dd9219b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -13,6 +13,7 @@
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
 #define KVM_DIRTY_LOG_PAGE_OFFSET 64
+#define KVM_DIRTY_QUOTA_PAGE_OFFSET 64
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
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
index 4f4e0d80a04d..8c12fa428436 100644
--- a/include/linux/dirty_quota_migration.h
+++ b/include/linux/dirty_quota_migration.h
@@ -14,4 +14,20 @@ struct vCPUDirtyQuotaContext {
 	u64 dirty_quota;
 };
 
+#if (KVM_DIRTY_QUOTA_PAGE_OFFSET == 0)
+/*
+ * If KVM_DIRTY_QUOTA_PAGE_OFFSET is not defined by the arch, exclude
+ * dirty_quota_migration.o by defining these nop functions for the arch.
+ */
+static inline int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx)
+{
+	return 0;
+}
+
+#else /* KVM_DIRTY_QUOTA_PAGE_OFFSET == 0 */
+
+int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx);
+
+#endif /* KVM_DIRTY_QUOTA_PAGE_OFFSET == 0 */
+
 #endif  /* DIRTY_QUOTA_MIGRATION_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..647f7e1a04dc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1905,6 +1905,15 @@ struct kvm_hyperv_eventfd {
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
+/*
+ * KVM_DIRTY_QUOTA_PAGE_OFFSET will be defined, and set to the
+ * starting page offset of dirty quota context structure, by the
+ * arch implementing dirty quota migration.
+ */
+#ifndef KVM_DIRTY_QUOTA_PAGE_OFFSET
+#define KVM_DIRTY_QUOTA_PAGE_OFFSET 0
+#endif
+
 /*
  * Arch needs to define the macro after implementing the dirty ring
  * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
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
index d31724500501..5626ae1b92ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -66,6 +66,7 @@
 #include <trace/events/kvm.h>
 
 #include <linux/kvm_dirty_ring.h>
+#include <linux/dirty_quota_migration.h>
 
 /* Worst case buffer size needed for holding an integer. */
 #define ITOA_MAX_LEN 12
@@ -1079,6 +1080,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	}
 
 	kvm->max_halt_poll_ns = halt_poll_ns;
+	kvm->dirty_quota_migration_enabled = false;
 
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
@@ -3638,6 +3640,12 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 			goto arch_vcpu_destroy;
 	}
 
+	if (KVM_DIRTY_QUOTA_PAGE_OFFSET) {
+		r = kvm_vcpu_dirty_quota_alloc(&vcpu->vCPUdqctx);
+		if (r)
+			goto arch_vcpu_destroy;
+	}
+
 	mutex_lock(&kvm->lock);
 	if (kvm_get_vcpu_by_id(kvm, id)) {
 		r = -EEXIST;
-- 
2.22.3

