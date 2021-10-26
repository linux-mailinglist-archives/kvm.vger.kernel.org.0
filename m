Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A1543B74C
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbhJZQic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:38:32 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:25098 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236093AbhJZQia (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:38:30 -0400
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFdZXU007385;
        Tue, 26 Oct 2021 09:36:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=yY2vRDOhbV47BhTOWos3QtvtmGb2vlKYk/kPL6z+C8c=;
 b=Pcv9okMrPMDqY0T9L9wDtNWKeDCP9FjxeKExC1zprp4+7cXNE3jHHbNy049C3flezeZt
 46OYLp6m20dsi29yPnaAVvVIFIjlcvX8zp+S2MnSca041yGjj+t80FUmvvHcW58KAYKR
 si8px1wySjNPy3Bu0bn+DaQVlcGIp47TweW+/zGfFk08HmtCjYxhKjohwmA1+r19lupK
 2Y+zI2cBOTTNurIesY7DA9omfYu8jP2kNzZmU3mDC3otUDYktfbXQ+9RDZWzIwq8uilD
 XXJjQeFmUyd2qXnkUItHlAgARMM7eYPoE1bTHdxsyefrhIEPX/Oeig9+ONMDPwN9os51 jg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3bx4dwhvbu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 09:36:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNhEq7yNPFsF8c08TF+iCpiQ/mSZPnFjUQHfUwc36m0I4quq5WVN+qMNBQ2mhCbnWsz+Mnp8IKxX1HM1lH6UuTTXNJIXwsYNBQIil/aQAtfH55pZ6EIAn8hZHhemvNGjsLZclE+SeSygSxRZAAhPFR9YvP+mq0lijlOhUVjtre2TJH2WMAtZZOKg/YG6Rbmo4xCQ4N2bvi/zZPtMkxGedwU1vstvvYUjDvHm5LMxEpUQPa5jcptDLNsgFvUuTAE4eW18VFMzhJhyiQZdjscks0SzYRmLUX12YdJ/EOoUupYN5eGF+v7fZUsNX8xiGFNQGiFkCD2+TJc9qjF+GPsJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yY2vRDOhbV47BhTOWos3QtvtmGb2vlKYk/kPL6z+C8c=;
 b=hjSnd+xl6pUtzBu46XOWpCdwQAj/zLYoKri9qAYfDwhK/iobIi4g1GeTtFpuvynO6Nr0fWVbRdQIJvFcpCjaIpRYU83iqD0DQ1xD302EtYTzoSjUuK633JUAzDiy1y2rjLk6rJ8mcazvx60ZCtmj2ParH53AeyS5f3fTmlFUnOK6Z6+gxtUJP3IQ/hj0Keg7zV8SvZi+DdS3mJCpj9QQ1G2Vaeskq9ms8Mxkg/IGCmmziDMbH1EJ80jo841Gx/ifzeB5rR5n4P8X01CdEIWoWbZWYY4MOkMD03vomV1zC9dc5mDrcoMmqSVuYdCG0t6QUMxnfHjU9PnqRLWVQSWUcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3772.namprd02.prod.outlook.com (2603:10b6:907:3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 16:35:56 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:35:56 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 1/6] Define data structures needed for dirty quota migration.
Date:   Tue, 26 Oct 2021 16:35:06 +0000
Message-Id: <20211026163511.90558-2-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
References: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by SJ0PR03CA0369.namprd03.prod.outlook.com (2603:10b6:a03:3a1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:35:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e986c7e3-fd85-4f54-f722-08d9989eaf45
X-MS-TrafficTypeDiagnostic: MW2PR02MB3772:
X-Microsoft-Antispam-PRVS: <MW2PR02MB3772127782446FF2B51953DEB3849@MW2PR02MB3772.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dL8e2YCC9I3J9R2wBL5KtImwF299UWrDLoUs4NckWbiVclwUn7NSI90yVplQhznun+9gzz8uFcjE1WxuLueoYWvVrYLnvJiw34B2nyBiWGTEWLANgPxgorAdfPc+0uXOokX0jpslL/YX7enodyvN/CCeT+kKXemkwjdE/WZVU9mIv49cvS/PIa06EKXvFxONwoxxWF6bHA8EcBnIYVbIeRpLJsTPWH5JsRV1Cx/ui815BlMLK3yroslMI5S1c7/1I47JIeKmq1s+V2KuHIFDxrS1DpwYs+LF7uUXR1BVAonBR+M3oJ8pmi64kZD6SLz3n77gQSPBMwaOud8TEeWV3vJGv8Cw8UxPUZW/YoY1Nk2ufNsQc5ezAsZcE5dLqsL1sKbMPr0rzrIrCfg18engC3urmIYzl6VXdfNclElfNDrqwTO4NwAkNrpmI5GpCApkv1WNFMKn//dFWw1fmfLgE9/85YnshTLY7UOYAgQqTA2xhvB4OhnJxWoqm+7J09DXiTb14j1HaiT2YZASl2fgn0c/SfHE0Eh4P0WJMKGKIRcxL3ZqO9ibxFmyZbfnSr9YiQ673GviDtzO7vwS22+pu9+GQ6+VKFzwJigCxB5wGBOPHSe/N7E5nxguspVDNZ8MWG/j+kTgCA6Y/krnoOz6PjeJAFfY3oqWqa4vXP0Y0e518vl4ROVB1SNx6RJZmQqdozhwQXp3gww/FYSof9eO5iKT0/mBiYe/tCHs37plJ9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(8676002)(36756003)(66476007)(66556008)(956004)(66946007)(86362001)(6666004)(2906002)(38350700002)(6486002)(5660300002)(15650500001)(52116002)(7696005)(107886003)(54906003)(1076003)(6916009)(508600001)(2616005)(316002)(38100700002)(8936002)(186003)(83380400001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?stp0kZ9gfoYrqOmg2m5SYgNqK/7QSzkm0uOf3m2KsZ9GQ7GAGqGc8LeKyWhf?=
 =?us-ascii?Q?k27U6AZkriTCLliNC4QVqz5vrnVE0vlv1GFsk4OB8l9axrixfnu3GdLvX2ec?=
 =?us-ascii?Q?ADuUl0gZDYBYfeXmAurp6y2eaYY9c7uIx+zwMdXt1NVD2Oiu97fXmBtEZFGU?=
 =?us-ascii?Q?cba3UVlGWZbxtOBjFpSN7wzhxJ2BTgF8BqlUKFgmhnBEEGHrzt0r4T5xBQxr?=
 =?us-ascii?Q?ud38Jt37dnNWWqH02g1FEeUAtnEYEh7SPkAfil+YRffC7JMIqzz6Am39lFB/?=
 =?us-ascii?Q?MecI64KySFAqN7ZplbyawUy/laoYRhnNhkWetVUQP8FPhtpEUxByyqyy5Tu1?=
 =?us-ascii?Q?UnYKaX9r/Dyu3tAGZTzIMp+Qb3TBXdgQ9Kib66TvoNY56F1v5f1LMIfPbB8u?=
 =?us-ascii?Q?r5tqrWZSDNbcUsZw8jJVqJmf0lYtdyXPt5znvmuRnXE+MKCOEoiPlNNpEp4d?=
 =?us-ascii?Q?R2eaKoig3pCJtfCYOpWOMMojCU5wvktoKbVyF5vkyJ8YybG5qzvtdy3qydo8?=
 =?us-ascii?Q?nmu9DxY9GvOZYpKmIkvLM9ijcPobe+EeQnWQuTz930Jl3R7rMqFmNjv+S8Lf?=
 =?us-ascii?Q?TeT8u1QNR8Gij+jDHEbPfE6JbDa/k5NbQB/EdWTZhRinEKNtCuhINxWxJurL?=
 =?us-ascii?Q?2EJ15jW2tU8ZoL+UBjw4D2i16iTUT2eCtRrU0q1sUqD7asWvHVx78vBy1UCZ?=
 =?us-ascii?Q?/hUb/cAKb2JAd0/55FR3DopERzz/zxhlT2hfeJBXyrzsC60V8zt/LNk5ekfE?=
 =?us-ascii?Q?aXFeMMKJdN2akQXEL3owhMF7hJUR/v/LjCH3to+PNnVq7WeJU4GQ1In9anN5?=
 =?us-ascii?Q?AInqiZWZ0fkLb1atGFqiEglHDrcsDy94OmLvaFETP/r2eJ52zVd54CCvx0IK?=
 =?us-ascii?Q?A7a36FXCcEB3FqwH/vs2+lWmo3A+dPxPoTTm6G2Y++3vJjR01NCQEp2e1w7V?=
 =?us-ascii?Q?wbbTTB0y6vpvXp3p9V6AZVaZdxAglRzAGC0DBoNGChLN8rT35L8n+00z9g7H?=
 =?us-ascii?Q?rLPVZUkaA6o0Ax9ugefNf3Zkv0aZVlxEvjq+00Kc0I1vCEgSMwwbXTe6NQGE?=
 =?us-ascii?Q?Lqe3oCVyQKesAdSPUSU8k0S1ENK3k6NL8Q89MrOu7GdoWx1iuuMaf5fssKgs?=
 =?us-ascii?Q?3gDrnK2luCDF4mU53YFbZ31uWW+pHHVFvPM3rYLOL3B6s6HycBs1VZwHzGmD?=
 =?us-ascii?Q?9gCRDWkM0F2lXFRjooBbEwcm+k0S7OsJau1iIwvkgf48DQdJ4K3Fmf3L9nke?=
 =?us-ascii?Q?5vGg5apCi5DOhXd9aNFMeMhMQph2puQlqC3UUIK6Gt1nEmow8YmmhIO9ImMb?=
 =?us-ascii?Q?fUGPK5NbkNH71oCC2S+vQ//hZhkOJWEjtXCemM/CEjhxRzDH7/jwEWThjvcM?=
 =?us-ascii?Q?ldGY4ju+o4lPsIkfR/NoUJVo5n152VrHCDL3ZekfbTrThKSRf6e1mg/+DRvD?=
 =?us-ascii?Q?21nxWPyMtjneuYJ3Jhbhwx11OwaxkYPLEepNkKkAtUquwslhd+yGKO7ivIW/?=
 =?us-ascii?Q?GSoSGP6yU/VNmY/xdOqd/enCuvFDlHSekH5fHiGaNHOANs7XVRE4MMXUNeNM?=
 =?us-ascii?Q?T3gsjvS/ihlTHGKbE2rBoqPTIvSYWllhXpJa4rhMg3lAyivpkyUr9fFNac0H?=
 =?us-ascii?Q?BXB9jQmZDJNHfkEKrr3sKcMGrtP6MjjRSVY6LDcn2FTM2zAi1Csiq7GpgBhO?=
 =?us-ascii?Q?Kzkrc22OG4JB5ZTd61YQRLQTkQE=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e986c7e3-fd85-4f54-f722-08d9989eaf45
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:35:56.4240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yczPatZhr4DuLAVCjSZNNEU4TZarjLW8x6CaS1ft/HLPSRtps1vvjdt2NfwXA5QhiNMirsKQk43B0jX+BDdUeA8KjzFGSHS0yO0svFJj6ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3772
X-Proofpoint-GUID: XSM3KFTflY7VZFejAa60GsRmFnffMmbl
X-Proofpoint-ORIG-GUID: XSM3KFTflY7VZFejAa60GsRmFnffMmbl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
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
 include/linux/dirty_quota_migration.h | 11 +++++++++++
 include/linux/kvm_host.h              |  3 +++
 2 files changed, 14 insertions(+)
 create mode 100644 include/linux/dirty_quota_migration.h

diff --git a/include/linux/dirty_quota_migration.h b/include/linux/dirty_quota_migration.h
new file mode 100644
index 000000000000..6338cb6984df
--- /dev/null
+++ b/include/linux/dirty_quota_migration.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef DIRTY_QUOTA_MIGRATION_H
+#define DIRTY_QUOTA_MIGRATION_H
+#include <linux/kvm.h>
+
+struct vCPUDirtyQuotaContext {
+	u64 dirty_counter;
+	u64 dirty_quota;
+};
+
+#endif  /* DIRTY_QUOTA_MIGRATION_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f18df7fe874..9f6165617c38 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -38,6 +38,7 @@
 
 #include <asm/kvm_host.h>
 #include <linux/kvm_dirty_ring.h>
+#include <linux/dirty_quota_migration.h>
 
 #ifndef KVM_MAX_VCPU_ID
 #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
@@ -361,6 +362,7 @@ struct kvm_vcpu {
 	 * it is a valid slot.
 	 */
 	int last_used_slot;
+	struct vCPUDirtyQuotaContext *vCPUdqctx;
 };
 
 /* must be called with irqs disabled */
@@ -618,6 +620,7 @@ struct kvm {
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
 	bool vm_bugged;
+	bool dirty_quota_migration_enabled;
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
-- 
2.22.3

