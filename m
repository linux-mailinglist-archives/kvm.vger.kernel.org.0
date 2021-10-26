Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB33643B750
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbhJZQih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:38:37 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:17404 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237465AbhJZQig (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:38:36 -0400
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFVTAV002819;
        Tue, 26 Oct 2021 09:36:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=r+9ob9GAaw/Ct0X5a6c8nspQz4pZc63o+WBoopL5Anw=;
 b=D6myO+z6dPSq4z4x9tZg3+JT+lUaOKqGEqCH2ObjC0evM0rQP1Up7SpmAQIJIcK81SBd
 4OmlhDVYTF8dnHAMirX2uDbUqf6GT3L/btp0s7XYebMa9PkKuX8L3tBN1PJkdZY+JJa/
 56Gt8KC0Jqgvwza1NYT3OVsWleJ7+DmtVpnV3i3Eq03bWKM+4u4lu+fWb+QuOOTmEwjT
 KufF8PteUZmIjBODsjMScM51TQfUURH/aeKbrZuOWMw1bLIHDAzeWvRnQInr6akfiOje
 Kr8OjNtHHA5vsFOjXj181IJExwv4oZGTv8c/4ByNS1NrrrZKXM/x2EDXS4WSh+veJBfm yw== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3bx4du9v5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 09:36:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzUlj5oXByUC5tNCaFyQ8HQV/sW8jjMMsD0MKhxH5xl7UCNohB06KASimCXN/jDyoBt4z6re00x9hFpl8IdlwzFK+wy3+W/ENaCnI4cRzorj9n4sxy5C+ycLNptzgkr5G/mCVhCv/Rj2RePI2CsZZZK69sHCOO6g9XsBJpZhREOPybTAAMXsWInSfLJhaKugXgqQ+0UIooA0dl4VcdAFuIaeJXrPQWXZ5N/u7Gwo1Q158sxghx7ZsFKDAlBSTYxslT/Dng2m83TtoaoFDB0Ss3Qv6j0VX0RHqzYA/Jvm6Kik4GlnOCaPntuVtkhY3z/S/fgA1ghUtbRLWPMCQCf9bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+9ob9GAaw/Ct0X5a6c8nspQz4pZc63o+WBoopL5Anw=;
 b=bOFMH1CQwD0zW2JEA9fVsOENkgmtCSg34THtyqc157zAzxSm6idw4N15FF8OL02hGDp8Bpef48Spec1ic7nDkHJxK3WnBnat1yfvwJ87maKdkOoERcIhs3P0mMlDikUd/fqSthzybitXn89czN3vLluKnhBnQM+cILwhMMq1d22gXRt9ew8sFQOpGQppR/TUCQGyrugKH2zD0QjG4w4lf8kL9UhimIpLhWBsL209ReXQc/WqdNHMz46Ly7VUlS7o+vymunqJenaHVihGXa4u45piGwYvPsalT8dgxKqR3E6veg3Ks5sgFwyZFdHS2N+4YoHKhEsnf2QNF66bHnQBdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3772.namprd02.prod.outlook.com (2603:10b6:907:3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 16:36:09 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:36:09 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 6/6] Free space allocated for the vCPU's dirty quota context upon destroy.
Date:   Tue, 26 Oct 2021 16:35:11 +0000
Message-Id: <20211026163511.90558-7-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
References: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by SJ0PR03CA0369.namprd03.prod.outlook.com (2603:10b6:a03:3a1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:36:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d8ae1b7-7964-4552-66a7-08d9989eb6e8
X-MS-TrafficTypeDiagnostic: MW2PR02MB3772:
X-Microsoft-Antispam-PRVS: <MW2PR02MB3772D722B96C2AB643AAE6D9B3849@MW2PR02MB3772.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzv+u/PiyGoD8qio0kbTgTOu+NcK22jG69J7IBD1L5yR5G02FsX96axBKhi6cao/lptALGkImSqmJPpKO2M/S+RCvYOd9k+LqYlwPbLzU1GMjOs18tJP0ykwE0Lui59bAHbmzaMh8gxZ2cEyLhp1QTH+KEKBVRuV8EXWckqFEQo6NjTap5QlIstI06zkxcxxcqvc2SzJfXoSC8b/NslS5iZtoO0AMAZmqcdWGpHArzTEjBIeqJ8Jg8J3sX0/YlMP/thJqiXJuIb4TVjKTVPnwuLUKkSfR30AnDsnXQUTGBb3x8Dq1iAQEgz9f7651QukXCrnNdkFhYMh2LrDd+cdGPQ6tFUVoEj6iVnzD1nU2wU5X7ztkJ8GjITFveepmIJeD3oF1sVlrUTE9gXJL9DS9OFnaXarSTd6hdtVJA6JUhK5Ecx5FXRroi4KYpmLHvfvdbSxL1yXsbacSS1MdyJ8ztqHg6+Gh0dK/EtCJG5Ce4mzVwm7rSG+DCMmlX0wh11X59Si55vmuXpWPLwVltRv1uTloexkskGYNgz3OEnvWZhUuyY0Gp8TNS5/K5gscIeXHpUsDx7jARik1bkgbr5FlTsiX/HM6UEcc52Xqbf/LymNLrjJTkoZtx5wJZCLjQAtObtpgM8ELBK0pAYGvUlBz/PbDks5krmK9cAUCF214jSmfC3bE7zwKZVUUycWrx3RdpB3gOX8kpF7RGjB0Ay1/C0FW5rzWLSO3qcdj/IRJWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(8676002)(36756003)(66476007)(66556008)(956004)(66946007)(86362001)(6666004)(2906002)(38350700002)(6486002)(5660300002)(15650500001)(52116002)(7696005)(107886003)(54906003)(1076003)(6916009)(508600001)(2616005)(316002)(38100700002)(8936002)(186003)(83380400001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wl9RQdCil4ZedE1hNapgMmFBScq78k7azkBPW7CcM1PTST0jvdCSdU5MaQ75?=
 =?us-ascii?Q?E47SwGVCMHixTvq0q+eb1rllxt4GXJ8LilqK0gD57h0/BgHYTBGaBSjcAfoI?=
 =?us-ascii?Q?HxThiyVH0mehpEn9Ud5FqANDxYA7px0xPhEGB/iEyxQs2ER9278+l1PpWjKF?=
 =?us-ascii?Q?2SOY2wllSBWUb5LUy8jSlMRq8l30ghZBkLxm3CFy6gPe+Wl2BH0qo8psNQ8q?=
 =?us-ascii?Q?eAadTOaEyyyX2EIFwFBGGrDTXrnSKmncTTNXnoyajYHAnPxn5KvXDk83irA0?=
 =?us-ascii?Q?zZLBqrYWL+N+cZ/KKUPUTo0wa+eGMg1dCrwGVyLm6r3cN/ueMbRi8DRkijyy?=
 =?us-ascii?Q?wm2lYu1hNRl82fuqAvb135EjFX6xQP7KgDFc2caZMzLxVej11VChreRMwf5/?=
 =?us-ascii?Q?OZ2Fs6fii1yPs3RNGYEJmLrfjn0yW8R6meeS8iQssfBx3K8BeMVI9LR5YmAe?=
 =?us-ascii?Q?RTMICNBBX70qpRXe7+g0FOMsDF12NaIOBuro3nH06H5qWDnXLjYcYNap1Q7F?=
 =?us-ascii?Q?BI+0fiREO2cb/wW/th69i/59nYOSHROTdqDAYkK8Eus07c/eDyTJkFRLkZdV?=
 =?us-ascii?Q?BB+ccH/SWWKaHvxAs7tkGQEgHk3IJWnSXtEkYSmQnmpciQ/Zk36GeAGmFkfV?=
 =?us-ascii?Q?sSbVDL8Jjdh0CdCMM0DZZcOXVF6pfVeu6qiA4gL7kpjp2QGoTqHTgAGqwTeZ?=
 =?us-ascii?Q?tsITRaKpsr00R7NlOqYhz+X9wpuJ55H6/qzFVdi/cpdP7sG0eC4nAep+X0l0?=
 =?us-ascii?Q?9Rc8rErkRaCsYEEnSdWYgQ5kwuA8awAcmjHYuPIJaDCO7OTWaa0PJvNpoog2?=
 =?us-ascii?Q?QCt02kS+L/wQ0oRJo9tE2xuG18NBK0kpApV0mL+HnuiV/sTOd/ar67fUwV9O?=
 =?us-ascii?Q?BdzIWZV1/FBBwarnFEsXh58SlyA5+tdY3vDS+tMIcldNadszOzsg9sRmILkc?=
 =?us-ascii?Q?zH6VQKjJd+GKwDqVebnAEeFkmW/fZhSt+AwTB6zp3U9Rg2/h+QMQqmqDLMFC?=
 =?us-ascii?Q?fpsxUr/2BWZ+XX1p+59jpmOgdgauP/4kRhfgmbcJVktAz4QvA53BQSdYhXSv?=
 =?us-ascii?Q?yGyVBN+xIzSJ3BU8mAETsbl5D00jG3oBi+Ww4D5g2L1VkveUWGOkpZ+HOgWB?=
 =?us-ascii?Q?kIJmW0ZcFOxwS0r0dNWs4LKUblaQ6nNMgn+48vUd/v01rD9+WcSlwmt0N25a?=
 =?us-ascii?Q?GOV0MapnK6NlRpIe/+1ah6GNjZHxRj62eki+j1bTai8slz6jQI+0mte0BBrU?=
 =?us-ascii?Q?lzpgvY9X+Z53BzgNVi16l/sRwQZ1HQqA+JCXT4FNFvW4dYgFEwQ6vB1QSEVE?=
 =?us-ascii?Q?p7kYNYUpdD7csAYhqCnMeU+mAnn46UYi5naObm3myA5HzL2rVacjxtHDsyUj?=
 =?us-ascii?Q?96Ni4xdNxL2dDmWcW8QLvDi4AKL4U8A2eJ9y8Bz1Sq4d+bGNVHG/XJ/VvLgR?=
 =?us-ascii?Q?JKommI5WiIWFLFNjUJfL4Zox6XXDewaviTBAONAf0CNpWwUFWuPlpb3DpQ97?=
 =?us-ascii?Q?flYDBoJBhqN39ziHKlg+G1i7A0KY+vSJ2BoPns3jYT3QOh5HJ3Ya7HWzVzmM?=
 =?us-ascii?Q?X32NtqcJExlYq1b/TnUwwc/r9ZCtV2WpKTmg3sDERF/f5FUaU7oqXRbmmqM/?=
 =?us-ascii?Q?NSlnUWp6c2UaTokeyfNKyr2Ljao8Wb55kyKFocMoo2xZWPFCscMcwlEFF8xR?=
 =?us-ascii?Q?yPacExnqyybEpRiuqvnLpaeP71g=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8ae1b7-7964-4552-66a7-08d9989eb6e8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:36:09.1928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3GnEOGkjsObQZjtNUiK6vTwQrFYVdPa9P6HWjodLpJotEuc86FWr8kOaQ1VUTET+5rMobRZP50ezVBEzNMchPOQcKMr49u0pWuH2DuwsheA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3772
X-Proofpoint-ORIG-GUID: _YVCejzQkP5_BYN8_1RZe9b31avrWu7o
X-Proofpoint-GUID: _YVCejzQkP5_BYN8_1RZe9b31avrWu7o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the vCPU is destroyed, we must free the space allocated to the dirty
quota context for the vCPU.

Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
---
 include/linux/dirty_quota_migration.h | 1 +
 virt/kvm/dirty_quota_migration.c      | 6 ++++++
 virt/kvm/kvm_main.c                   | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/include/linux/dirty_quota_migration.h b/include/linux/dirty_quota_migration.h
index f343c073f38d..d3ccab153d44 100644
--- a/include/linux/dirty_quota_migration.h
+++ b/include/linux/dirty_quota_migration.h
@@ -16,5 +16,6 @@ int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx);
 struct page *kvm_dirty_quota_context_get_page(
 		struct vCPUDirtyQuotaContext *vCPUdqctx, u32 offset);
 bool is_dirty_quota_full(struct vCPUDirtyQuotaContext *vCPUdqctx);
+void kvm_vcpu_dirty_quota_free(struct vCPUDirtyQuotaContext **vCPUdqctx);
 
 #endif  /* DIRTY_QUOTA_MIGRATION_H */
diff --git a/virt/kvm/dirty_quota_migration.c b/virt/kvm/dirty_quota_migration.c
index eeef19347af4..3f74af2ccab9 100644
--- a/virt/kvm/dirty_quota_migration.c
+++ b/virt/kvm/dirty_quota_migration.c
@@ -23,3 +23,9 @@ bool is_dirty_quota_full(struct vCPUDirtyQuotaContext *vCPUdqctx)
 {
 	return (vCPUdqctx->dirty_counter >= vCPUdqctx->dirty_quota);
 }
+
+void kvm_vcpu_dirty_quota_free(struct vCPUDirtyQuotaContext **vCPUdqctx)
+{
+	vfree(*vCPUdqctx);
+	*vCPUdqctx = NULL;
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c41b85af8682..30fce3f93ce0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -430,6 +430,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvm_vcpu_dirty_quota_free(&vcpu->vCPUdqctx);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
 
@@ -3683,6 +3684,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
+	kvm_vcpu_dirty_quota_free(&vcpu->vCPUdqctx);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
 arch_vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
-- 
2.22.3

