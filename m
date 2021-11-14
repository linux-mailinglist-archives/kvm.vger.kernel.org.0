Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404E344F89E
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhKNPAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 10:00:39 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:38484 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229910AbhKNPAd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Nov 2021 10:00:33 -0500
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AE6wp5X019791;
        Sun, 14 Nov 2021 06:57:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=XzH01JkvTnUv7vhjzETS65wF2D66bqxYgomLb0AN0ZI=;
 b=g5m+oCJVq0yF5UDShf5QpLVom2a+/PL6+auGhyHWIX9oE2QtLatpYLPrBthbWU5sSuaB
 rvQhfuQHn8vZjcTSx4jH4twdcuazBmWoIEfzCuFeQ7tBmipG+JkLe4YVypAwNXw1GDZ0
 NExHzSCwRAAC3JAM3YZIYXILxv2U2EdlU0w1RxQPwtofE/DxXivc8TrGRfnb4ywNcc3Y
 9U+pHWAstngOgCWUSbZQbkwqIgFTfN+xlqsGghinQusSzN1CD4+57GOR9FL4ZJdHGE3g
 vXp2u1xq1/dkBDODTIxs4NeKk6ruvFZSdPRud0PLJuYfEL1EgLZigA/qcCYXw6PATqM6 Gg== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3caa5d1u41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Nov 2021 06:57:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etULVI8wWjLeTQOs1YTeXbjIjyZtsqHJLdPQfQUpcNJo3tPSk4KCXu2KmkasSsiQUZvxKOk/dzyXiMs5Mi7XxJb/VBSJpAr7MKR2H8BE1KduAsDkqvjL6uZClGJTFMiTa8MxRbrDgCtQR7ghB9TQ4QpN5GJJ2ZCxzBlCyANUGP9mpSXsuIuT7oh4V2n9Pzg2++ntu1UAcPJPYtT1pkfasAOsuPineyphX7yw2UJSSoWKXPhUW6sKDqGNJAwfi5aZQ7dE81478aR2dlW0O/jBH6qWXl2FcRXQBbXHlpAcbEi5FBHMoBcXqbcFB16vjGxD3RTQFfts5J5ZuHsLJZXXrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzH01JkvTnUv7vhjzETS65wF2D66bqxYgomLb0AN0ZI=;
 b=TwJxw1sM9Nz0XTJeGzhAXGHD/s1zpv9ZtU7aTJCjy2sybDgZ3GjoSHZP03nevKkhlnUDimJ01uV2Hbc+u9uj9vgoEbaO44NjcH/N9PxpP1ovEf+f71Iko2hC5qn7GChmeTZZoLGRqzbyQVl1Mtnd0H4r9JDivwidvp9i1l92IM5eqC5NE+f8jIlqKh1arQpqbDRbdxZcK9aVXlMO7M2sxcFOLT6eSamFuqPOrqlk29/TvJ485bCznH9LG/6IVPNx10CrYbVgSDqSU5cUc0nWQ7YMTLtg7jx1wvL3/wCpj3Nh+5ZtpVgWWI4oGDdD19kNoIXb8lHZ3dGnmoIWOQh2PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CO1PR02MB8618.namprd02.prod.outlook.com (2603:10b6:303:15d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Sun, 14 Nov
 2021 14:57:35 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%9]) with mapi id 15.20.4690.027; Sun, 14 Nov 2021
 14:57:35 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 1/6] Define data structures for dirty quota migration.
Date:   Sun, 14 Nov 2021 14:57:16 +0000
Message-Id: <20211114145721.209219-2-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Sun, 14 Nov 2021 14:57:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cefec033-22b5-4604-90b7-08d9a77f17f5
X-MS-TrafficTypeDiagnostic: CO1PR02MB8618:
X-Microsoft-Antispam-PRVS: <CO1PR02MB8618E115CDD980DA828CE69DB3979@CO1PR02MB8618.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jc3Rr+O0kATwgyKofnr90An4PUHd38FnZq5k94RSycJ2qeLtl6E63uDGZvZVz2i4ArvzK4KniPaNK4HGCBnKPYP/qI+yrl7JGn08i6z151w6Twz4Qvq9OYPHn0CVM4VZVYdxG0easJJlt3tqeP+BjL6SdkxXItL3IMSee8n85+lm4+eaNqtmJufYsnB1eib5JkMPWXMVE6UEVIAbv9/a4QI9Qbt/qJBgOIZbOHY6eFiV+h0c+HcfECVnQVyvMwnuq1s3GffCuMICKvR4gIRAqjhth2IkUEepeAxTt+IKf44mUUYEL7xTKdMOKZsKoOcIsyhQXKRQ4M95A9qVpV6+6gLVh2ZqG3zxiHhdCYsnZvhZ9Kz5K/K5e7cCcX1ZN3w3uthvkgbf4yUwPleriOg01wuZoY7BC9eDfxBQaSa/m1zgYVKT25Cp81HxdCN8enFz+wzjHIH9UFhw3Km0dinCXFixogIEs4MsE94OwK7JlA+rLD8BkMlHGl4U6S+83G91i9Jw0fq+cnMwyldfF+HeBdZviLdkXDJ+2rt8CybaBn/gFMfmrMxDH4rkBQoehCEA1SBl1dtrMp8WM7bCACQwLZAUd4414nJ7eXqpGzkvdtLKtSc+0cFhyttWU3tz89eJRgoInu5eqTViqTcjSjuCHKsCx3P2t8cDNNarmaStsYN5o3LAg0IgpP5+ceg+cgNk4A3PESyrgNZV1iHy0ECyVWGRTFmJcJwaRB7fhrLFgz8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(38100700002)(38350700002)(7696005)(26005)(36756003)(15650500001)(66556008)(1076003)(6486002)(52116002)(5660300002)(186003)(2616005)(6916009)(2906002)(508600001)(8936002)(86362001)(66476007)(4326008)(66946007)(316002)(83380400001)(6666004)(54906003)(107886003)(956004)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ePm5Bpc7LAtB+VTzP6XdmH+8FR/kax9uuaVy2s0h2ZuV1oRrTY+dlGcPOKm3?=
 =?us-ascii?Q?O+/KlAMrf1T64v1zpw+33yxWr4fcGjcqBE8jGcIjLW91dU+M4DOEFSpFDsI2?=
 =?us-ascii?Q?exYsEjfn0sw7XPaWHc+Tg30JaQcmxbVxjxix9w1Uld1j1EZ9s7w7G8KdunE6?=
 =?us-ascii?Q?87EtaRB6vw3NcWfJcc8d03aI4WW96tSs1x1dyeAbXZZyD1xokivPSGb0AwM2?=
 =?us-ascii?Q?aEIK/5mk/0+1ud+A7/nmhzwBvRSLWJP2a/dp8IXqPrsUna5R0ahVkruhVCYm?=
 =?us-ascii?Q?/Sus7int3DF+P24saYcWQD+Z1cbPP7pb83bFnotbthr94UJ3smd9mPh4J3xn?=
 =?us-ascii?Q?6OVL7G1OrG8SPsCjNccEgT4Rac6VLqpfeqnsKm+/fdjmnOkHi4e9HEQgqKTN?=
 =?us-ascii?Q?mfB/gXNIWUoWBl8vAqkIMgJIQMbul9oAMpu+FtdPtHgeVJdwrdIduz0eXQwj?=
 =?us-ascii?Q?M7qqZmi8n6W8y+M9RxB0z/I+Drk+Rzk6ZmbPFPBlmpH6KyO5OsX+DUizsNF+?=
 =?us-ascii?Q?GwV+8kDnZSs+TQHlF2uhPa3JZ/eV6q+wNYf/xzt5XxODDmsv+DNA54AyJaI2?=
 =?us-ascii?Q?Yxul/JWDXTvJJR2VM7AyFMjKKMeqKMmZfeiwnaIDXkbcIb7AEqLCkyPDsir8?=
 =?us-ascii?Q?fmxAGXEm60sTYt7AxazredN03sZJ2j51AMZckD4D1W6lQ7agoYgefRUx49fL?=
 =?us-ascii?Q?/S7exVPenDLOyGaUXvVWKEqoeamBUEaVjbLbUMYabTR+r10QnKXTDwq6zBE1?=
 =?us-ascii?Q?uNm1BxzOis7otBNVB9gM1QKF+GajUbA4v1Smm2dkzn1gf+0Gcc/fcqKuWzlq?=
 =?us-ascii?Q?r5uuBJlvHYeH2tRYRzWTf2NMNwYsn5JO5IYxCqUUNiPbL8v1NhKe5L+UTUGb?=
 =?us-ascii?Q?+GDd4PfokdPGx1q6PgQMMoKDHWOLOd6BG33+UUoXrOtt+cODRETn+qI9/VYw?=
 =?us-ascii?Q?cR9AjyEPAaXE8aIU6MvwW0XyMbJYhlfSLEy9OpfZiAk++BrKHqAzMmznIr3o?=
 =?us-ascii?Q?0eCTcZsp/CtSX2OKaNYZPAPqT3B10CymBCy9jXx880+BlS8Ddohlo2HEOGvU?=
 =?us-ascii?Q?NIHTJKqwEigN6zEAC+6PlXDEwT4xJhSRTVlypbldB2C1rkOF07ihzpMg00p+?=
 =?us-ascii?Q?03t46RFKLW/pJsknqqZdChwcDQhPaBQzFlJBJcU79glprc2DFnFYykB6dFjb?=
 =?us-ascii?Q?TtiLhBdiMGVPCDPsDXmAN5XwFJhLyV/NBuNNqRiOWuPdwiDibOui1d1A1wBd?=
 =?us-ascii?Q?mQMyq7CUnZQkZIXdzlQkaWIXRpcOz7MXvqhvej5PcJ9EN+1MehPMIOuHskil?=
 =?us-ascii?Q?dXAwTdl2LiQNbPRo8OwRnebUeosxzHxolkkxfsNWO3D5reubC4BeTh7yShRu?=
 =?us-ascii?Q?24iw0VXk41ATPqMiD38gLzwhnDG4MTP38o6xUNkrsIWLIbWEqzGX+vHp3ReF?=
 =?us-ascii?Q?Q3To02NU3x8xUK+Ud+sgBxgJ2cgYlcsrxn/yR62KewqWwgP4G6P2inhUUYva?=
 =?us-ascii?Q?iL8DWdTb7WowdF+ySRR+LDetdLrPddvVc7CSRaG3IZtilpz8KQ/ynilZOiqZ?=
 =?us-ascii?Q?9H7EV96gmeFdoqDft+PNG8RqykuNfIkiFTRLNm7CWPmK3UZN6M5PPrh+xFxP?=
 =?us-ascii?Q?MA+b/Qv45ICmu2kG6tPJkcckhxhAsikTxB4pmRi2dH6FpuAk+nTRp6/M85GC?=
 =?us-ascii?Q?PcexenzA4AXjID88sm2651kRpEs=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cefec033-22b5-4604-90b7-08d9a77f17f5
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2021 14:57:35.6102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gp+sZtLy5nPpsMF6k06eW0wgApXc5Q88b0U5oStEdIRvPXZ2CCFBfEbbElYjiLFcq4jg4Jq+xM0gDZICvc+4RRSXBuFMjs2Hi5m81WzB6/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8618
X-Proofpoint-ORIG-GUID: iucjZTQQ4Qm3KpZ_MfHIXblfO2Bt8yPN
X-Proofpoint-GUID: iucjZTQQ4Qm3KpZ_MfHIXblfO2Bt8yPN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-14_02,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define the data structures to be used on the KVM side:

vCPUDirtyQuotaContext: stores the dirty quota context for individual vCPUs
(shared between QEMU and KVM).
  dirty_counter: number of pages dirtied by the vCPU
  dirty_quota: limit on the number of pages the vCPU can dirty
dirty_quota_migration_enabled: flag to see if migration is on or off.

Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
---
 include/linux/dirty_quota_migration.h | 17 +++++++++++++++++
 include/linux/kvm_host.h              |  3 +++
 2 files changed, 20 insertions(+)
 create mode 100644 include/linux/dirty_quota_migration.h

diff --git a/include/linux/dirty_quota_migration.h b/include/linux/dirty_quota_migration.h
new file mode 100644
index 000000000000..4f4e0d80a04d
--- /dev/null
+++ b/include/linux/dirty_quota_migration.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef DIRTY_QUOTA_MIGRATION_H
+#define DIRTY_QUOTA_MIGRATION_H
+#include <linux/kvm.h>
+
+/**
+ * vCPUDirtyQuotaContext:  dirty quota context of a vCPU
+ *
+ * @dirty_counter:	number of pages dirtied by the vCPU
+ * @dirty_quota:	limit on the number of pages the vCPU can dirty
+ */
+struct vCPUDirtyQuotaContext {
+	u64 dirty_counter;
+	u64 dirty_quota;
+};
+
+#endif  /* DIRTY_QUOTA_MIGRATION_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9e0667e3723e..3cb6a43da01c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -38,6 +38,7 @@
 
 #include <asm/kvm_host.h>
 #include <linux/kvm_dirty_ring.h>
+#include <linux/dirty_quota_migration.h>
 
 #ifndef KVM_MAX_VCPU_IDS
 #define KVM_MAX_VCPU_IDS KVM_MAX_VCPUS
@@ -360,6 +361,7 @@ struct kvm_vcpu {
 	 * it is a valid slot.
 	 */
 	int last_used_slot;
+	struct vCPUDirtyQuotaContext *vCPUdqctx;
 };
 
 /* must be called with irqs disabled */
@@ -618,6 +620,7 @@ struct kvm {
 	u32 dirty_ring_size;
 	bool vm_bugged;
 	bool vm_dead;
+	bool dirty_quota_migration_enabled;
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
-- 
2.22.3

