Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8760344F8A3
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 15:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhKNPBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 10:01:12 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:31650 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234572AbhKNPBE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Nov 2021 10:01:04 -0500
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AED098c003466;
        Sun, 14 Nov 2021 06:58:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=4f/32J1fksnl8kA3s/LNoacgQ6HubFL5/MQAs0zjPeI=;
 b=wE6/Ul26KVdYbkooKJI5rADrooQuUun9JRbY798TMLgwMv6tmIdyGUKNouVVEFgE8NrM
 ex9lSvbVHnvg0QH9jZqSycUc6OdvJ3qdqK10hgZKt08FfckaydUKxiVUCeOCAnPj2g9/
 WkmzAtebCIEpA2OygwlEvnBavwvUh3SgLvj0PfbjLAjkSSX/ru22ueq0N9uVCVDejEht
 ejgt3v5rgOd1LwQrjKYuGI9S6HSeyS1RbaGYqDH3nA/AV+VE0DVqSBQwt2d+7keLcp+b
 3+drpYDxNeGZqaORFxGuMM/hCxjOaeeUXJud/dulJ775W4PjvgGEZftSRr9VMbzJ2ihp 4w== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3cacbpsp4f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Nov 2021 06:58:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erFSY0ycseONy6s4Cs8012dbY7rpN1eWnmhamtfogMuFR3eBwXBgiF5wsAWl2tsebQvc6jvUAAjy7vD9H3pqxZ6q+euTAbiHzJMMfDMts2CU48/Rf2Lfg27gINY1s3qfPRmWBnhhnv5/+D3Vk+hKFKrjPlHMbVUBidxKlfhFX+5ZhF5YZPv3EAZnav5XuaKYAmr5/UZc17i42VX8vBdttBMIWhwrvsEbKVvRYW4mqqjdTPHzGm6JuONSH31CPT3lK3sjtvYw8FBo4keJycNob8KMWYJFqsHv8gD9CEszKSnNR/vf73bABy34IvzvRJUtntcNYQuyNN42eXlhRCMXig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4f/32J1fksnl8kA3s/LNoacgQ6HubFL5/MQAs0zjPeI=;
 b=NaI8o2WVFSocsODsq4GMpfqCsyG8lPXu+/NDqL1k2fIx+Vuq0vYCaVzts0FUBTRlK6hJ5l0gikhbGQWmQYB2UWiPI5TIGeDeh8Ggscr6KFCTPLRyl0ntjhh08a0p0eTuoQmQwPJ/w9EiXgjaZUAXdqV4a20Rgqbjpxz6SFAhTM56IpVPOutOd7S07Z+8J4b/khN8KbOJ+QGaebkwzr2An2p1UJaTQzQxalv7kX1CFVy2j3iE3R2wttPjOX8uudfd1Sfu201CTTYEvf24ldkyY71RHoRoDkcL/qTcE+uFIPGYwMcWc5vs6D+zeAN3+uYT4Qq04r1rIyZwvDi1j6Cz1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MWHPR02MB2528.namprd02.prod.outlook.com (2603:10b6:300:40::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Sun, 14 Nov
 2021 14:58:03 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%9]) with mapi id 15.20.4690.027; Sun, 14 Nov 2021
 14:58:03 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 5/6] Exit to userspace when dirty quota is full.
Date:   Sun, 14 Nov 2021 14:57:20 +0000
Message-Id: <20211114145721.209219-6-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Sun, 14 Nov 2021 14:58:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 088ea714-d081-479a-a73a-08d9a77f2870
X-MS-TrafficTypeDiagnostic: MWHPR02MB2528:
X-Microsoft-Antispam-PRVS: <MWHPR02MB252843E6E41AACBA11A40EECB3979@MWHPR02MB2528.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:392;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXJp//fvXanGwIqn8+0Dy9TkttjR8w3I/5w8okTdGc0mKVGKZ4NbzXx3XKz/YHYu9I/0cA5FS0jmo0yOMl/gg+kcXGX8V8MiYXwXoBG+5YMg8+CvCggiPXie4QQ2bSOFjaLv324gCi66EK0uWLcLnc+w6l/Qz4KaXBIEEsyBStL6T/38OIV5/CkiqBWILvL8UU9vDgjxMgi8okJFhGef21s9l7wXo6W2mfWCqTCEX5rdzvBwJmrufgxyi8MW7lBR+eqxRWCbIXl1oVQHeZ6Ze0dOeYKwZkCXk5Za+fRRsjCqqKqiwuBSUBsAEOR5sQh7ZjNbVPoEzSjdVC4nKMtsm7l+gRCFxCyxY2VT4yGj6ZnvLqZscSvynHvwwsWx3VTEkpNLKAiOAnaEBUorKUixQ/4tfy3Omkfy6zuEyLBeAj12x2BxH4fB4QqWcOhggpWnlE+IT5gEppXBss844oI74qL1hBODlvi7CdfBdyqhw7UCrMtb92J+QXrIEwoGrBOcRzsSmSA1g2mxPvtmu4+G7LBPlNxm1BVM3KugqB5y7DcE7iiVn9zLMMiJpFDWWCjykKhi52wXXc2VjxhqoWZ+ExIcEQfCu7kFSaXeThFPQwhNNiROwhwbIUZSf6PZScg2/yPOiUAmP3S4rFBi+FI+fdC/t816+EzlTWQyERySvV2SYRDnlEIblJ7igiRADeIaDxGgrie0IwXiacquJRZJDktQfS79kDngBJPhF+Apj8p9d9HVZzOmf6B5+Zn70bFY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(66946007)(6666004)(6486002)(316002)(26005)(38100700002)(107886003)(1076003)(186003)(6916009)(83380400001)(956004)(36756003)(66476007)(38350700002)(508600001)(86362001)(2616005)(8676002)(8936002)(5660300002)(7696005)(15650500001)(52116002)(66556008)(54906003)(4326008)(590914001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PoZ5tTUYZfAfeADRwVpDltS2J0dc22Or1HaFF5Fw+d2kBeaOEbEogm3HC7Ce?=
 =?us-ascii?Q?SIVjag7RNz+F6F1x8TQS9EfPKVSxjA4I/8alHXA+CaHuKcik27SCFfU7s8g6?=
 =?us-ascii?Q?6vQoJ7mX6rFLPmRrMw+fGAT4hGvoKjHdxVfrneNkycahwR72r1lNiebqKfDN?=
 =?us-ascii?Q?gHrrd88ZW0vwnhGVaWPuvYc8Lq+K1apMecXCybwEWOMKWFlhZMReTHyrdpme?=
 =?us-ascii?Q?SBNgn6JlQRRd+pH+zpRnpnqHH222JuXDdpq2zvgdNTqd3V5xHF5mFPYh7TBS?=
 =?us-ascii?Q?dE34Et2C5Cs3EhJPB18052eioNsyb3NAkCW6Cjx/E1IRQ5/QJIPFaeZv9iDw?=
 =?us-ascii?Q?PARXLwky+s7/wAy/nHCK9PG5LQ+JwWBP0dr3Bvj7bau876S5JErglp3L1rqV?=
 =?us-ascii?Q?fjGVQhheHkXvB3DIYixa/3OaYqTJKvfYAezGSxxudMsLvVuElQJLfTQvqBQ4?=
 =?us-ascii?Q?qVlyuyUnxPSHz4iuAWg+LYnsWoDvUIlSrzn3jxeEELYnNPUr8+J1NXJ8RmO8?=
 =?us-ascii?Q?KsLdEf0DLEXyfeksq9zNBZsOIjTYgpWkt/qRXTMGPH1yZIJn40RbPywRIy9m?=
 =?us-ascii?Q?Y3sCYW3h14XJOev7oa4G39u9eqaqLgLHGhCFP12EoxZG2fUAQmyLxchdDu5D?=
 =?us-ascii?Q?srHf2sea40C1ZMBORyuAvaps8ThcDNX3nWy5z3bbArpvwjlYojx9Xxj0pAo5?=
 =?us-ascii?Q?GpsRnS/AKBy9pVUIbl4jKt8NaV8rJfIIamJaEiYo72pFw91DdLqN0JDLsb48?=
 =?us-ascii?Q?tGiF10sWwg4nxBLX4ZFk63SsgYBfslINgSguJi7ghumPMrhgO6qDAaSOAnWw?=
 =?us-ascii?Q?S4q8LI3LiHwcjjgIx5l9CuVY9NrW0jHQERL64gLwXGeMX7IcGgxaijbgfgBw?=
 =?us-ascii?Q?m0+w0CqQF+sht6Zwn7WPLtctlL6vPDvB4pUTXWmr1kU+xCksWFF2iBtj0iQe?=
 =?us-ascii?Q?QwE+4mBDwjCXWule8djXM2y+OyjogZrHHEcbbAqZ/bUIvp83EwDqTpXhVQRL?=
 =?us-ascii?Q?0/5cAIQ7eGjsoeV/a3nK5hS/oFiNZM2iw6qGmgOCkqMHQDrFLoEa35Xc98Wy?=
 =?us-ascii?Q?ha0dDyOFP1LxnH+E8SoOIAYTSUwmBMq0DEfcmglwfpMerwEFBJv2xkIF3Iv/?=
 =?us-ascii?Q?jrPb0NgP14O4BZeKDmPwBlIeiXQhOWcibyBDYdnSCEhNs3cQ7rIgXRZTmQj/?=
 =?us-ascii?Q?JKvMYT6W4Yzm7gQ55ecRHGsGfhB4FB8IiYmD1F+VFyYnFWQrwTfjEyuwVgjg?=
 =?us-ascii?Q?Pvc6BK1ORHM0FZCY7QbDpLOqIgArRyNRdKkwabA1T+YxdtHlV+kfbxV6YeAb?=
 =?us-ascii?Q?ZwDE6i5Ofj30mbj5rkbBlR82HonGsSUQ69Id9Cho7m5g/ski9dYrhIHxOBb3?=
 =?us-ascii?Q?+1v6P3o1LVVl/niHvT+UUSi4DdnPL4oBkEMN81/aoshgWReWoKUKYHQ+13kJ?=
 =?us-ascii?Q?XOyWh360P1R/suElYUTVWlghlJ/r1E1MaxMm1ZZbwvPntfJpMqJNQxiORXDQ?=
 =?us-ascii?Q?A1+EyDx8UHK8uqxJDhOEawr/Ezvvy4RaSR2vjquAIvWB/n7DH/0yjwv16ESY?=
 =?us-ascii?Q?QtKk0einmjWoJ9r0OdIN9d3yjcyL4EIKqS/O5GTmEOfLW5GSLCBpjluE8Ugp?=
 =?us-ascii?Q?CphDf0/eCqAbi0icmYzFwH5sjk/M/dxEVCxwf277Y8Anit8vZ/g+gbDtZFdm?=
 =?us-ascii?Q?YrT11Z8kD3GJLW5Cg6wHZk2jpEk=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 088ea714-d081-479a-a73a-08d9a77f2870
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2021 14:58:03.2295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTu8CrzdguwB/W7GqQUWyLLzGeIfu/2Z+0AGVxYJPeiOhtE5BR8KtjSZkRUXN5L9ur8j16Nzycm2I/l0tDreUSePWcRAEAs3QmDYgiUCoPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2528
X-Proofpoint-ORIG-GUID: BbkvQ49lCnB737-UkV2YBNFJL5ufzWQ2
X-Proofpoint-GUID: BbkvQ49lCnB737-UkV2YBNFJL5ufzWQ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-14_02,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Whenever dirty quota is full (i.e. dirty counter equals dirty quota),
control is passed to the QEMU side, through a KVM exit with the custom exit
reason KVM_EXIT_DIRTY_QUOTA_FULL, to handle the dirty quota full event.

Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
---
 arch/x86/kvm/x86.c                    | 9 +++++++++
 include/linux/dirty_quota_migration.h | 6 ++++++
 include/uapi/linux/kvm.h              | 1 +
 virt/kvm/dirty_quota_migration.c      | 5 +++++
 4 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc7eb5fddfd3..32fc7a6f8b86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -59,6 +59,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/entry-kvm.h>
 #include <linux/suspend.h>
+#include <linux/dirty_quota_migration.h>
 
 #include <trace/events/kvm.h>
 
@@ -10028,6 +10029,14 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 				return r;
 			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 		}
+
+		/* check for dirty quota migration exit condition if it is enabled */
+		if (vcpu->kvm->dirty_quota_migration_enabled &&
+				is_dirty_quota_full(vcpu->vCPUdqctx)) {
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_FULL;
+			r = 0;
+			break;
+		}
 	}
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
diff --git a/include/linux/dirty_quota_migration.h b/include/linux/dirty_quota_migration.h
index b6c6f5f896dd..b9b3bedd9682 100644
--- a/include/linux/dirty_quota_migration.h
+++ b/include/linux/dirty_quota_migration.h
@@ -30,11 +30,17 @@ static inline struct page *kvm_dirty_quota_context_get_page(
 	return NULL;
 }
 
+static inline bool is_dirty_quota_full(struct vCPUDirtyQuotaContext *vCPUdqctx)
+{
+	return true;
+}
+
 #else /* KVM_DIRTY_QUOTA_PAGE_OFFSET == 0 */
 
 int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx);
 struct page *kvm_dirty_quota_context_get_page(
 		struct vCPUDirtyQuotaContext *vCPUdqctx, u32 offset);
+bool is_dirty_quota_full(struct vCPUDirtyQuotaContext *vCPUdqctx);
 
 #endif /* KVM_DIRTY_QUOTA_PAGE_OFFSET == 0 */
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a6785644bf47..6ba39a6015b0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_DIRTY_QUOTA_FULL 36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
diff --git a/virt/kvm/dirty_quota_migration.c b/virt/kvm/dirty_quota_migration.c
index 7e9ace760939..eeef19347af4 100644
--- a/virt/kvm/dirty_quota_migration.c
+++ b/virt/kvm/dirty_quota_migration.c
@@ -18,3 +18,8 @@ struct page *kvm_dirty_quota_context_get_page(
 {
 	return vmalloc_to_page((void *)vCPUdqctx + offset * PAGE_SIZE);
 }
+
+bool is_dirty_quota_full(struct vCPUDirtyQuotaContext *vCPUdqctx)
+{
+	return (vCPUdqctx->dirty_counter >= vCPUdqctx->dirty_quota);
+}
-- 
2.22.3

