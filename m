Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E7643B74E
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhJZQie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:38:34 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:24340 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237428AbhJZQib (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:38:31 -0400
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFdZXX007385;
        Tue, 26 Oct 2021 09:36:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=HQWt8iTt8WkXpnCI9U4Ke8PdOg3rtyIe5zsiJs7Qg14=;
 b=ZAUv2X9xJrml0B6IoMOag3tLT40qbqPWPML5YEBEEehKUrLkHk40j7VzIc+sZIBiHV/W
 NKIHMh3H8lWZOFlLJYRol8PThdX8AAWBNGuuhRS3NbxekwK7QYNPwtTTQy9dCOlCatxe
 Ol7YimVxnMa+5RS55vhb36yR0AA5NFtI6PRwfmnANS53i+tybzmmwJEWHzlSUDfXVGil
 MKiKgdnK0OHjYzhjper3BXtyhYiWKafweTs4wM4VeJMkPxhZK5wNC32YthoH2qidv130
 51t39fZ1VCXi63dxLD23RRzECDIW3NLIYlh3vHLEFBnwceaYa8FQ30+lgLfkvIZwtdlF rQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3bx4dwhvbu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 09:36:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cH17eyjukF8B3FerSiTwQoI7NYlhbFV9622Prnds+XpBB1mq4Ostb5BopT4UAgsUBIszCivKLohG+FD0cKHCw8WkXwaklV5udSysvWOtDW10dbaoBn3do4KN23VgwGxgqBCLDciaMvr4K0p1I6fCzpNpQ1vWcYQ97qytBrueY2UAdD4dTdGUt+GdTBe6B6d5oAKkWShWzmKwPieNOxM8BeXUVcOaNi9DLyZwDNuRKEPbhbbEX/Ck3wjzPQjv/KYK8aTlVs0pJYee9xB1ohkQ23NccUCZCqAHVv6S06kJ/7SORoCLZC415AtbU4JueLvYK0lABlNbTuIK/m7BVDHmPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQWt8iTt8WkXpnCI9U4Ke8PdOg3rtyIe5zsiJs7Qg14=;
 b=SriENMLg7/6hXsTzhn+RajYwiX7MfAs30qM9giAhGhWhItuOn26F7S+gXmKjUmdpo0dTUh5PDP6NWkixsKxqa24x4DavQ0kYIgBnLCApsS5P6VlNHI3KxeqKE7OgquLAjO3XLK9PSthtlqKvDfdyJw0CLJSZNg6Q2t+3vVJF0skU2TLHTEFmm6ZiMoUEX6kaFw+cX/UCNE2zFUFSuL+Dt5f771PW5lwYM1F4PTYT1LrX5GJ//3poglqibjG5B7AwQgQ8UUWSnYLxrUdmTzRv0qp+X5wjbdnjMURu2IwNokF0nj5NkZdBwKufngn+T/xAJCRMHYBg4qUwbCsX0cqKdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3772.namprd02.prod.outlook.com (2603:10b6:907:3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 16:36:01 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:36:01 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 3/6] Add dirty quota migration capability and handle vCPU page fault for dirty quota context.
Date:   Tue, 26 Oct 2021 16:35:08 +0000
Message-Id: <20211026163511.90558-4-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
References: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by SJ0PR03CA0369.namprd03.prod.outlook.com (2603:10b6:a03:3a1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:36:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90e50981-5d3c-4bcb-c793-08d9989eb262
X-MS-TrafficTypeDiagnostic: MW2PR02MB3772:
X-Microsoft-Antispam-PRVS: <MW2PR02MB377273AF61E64589DCD35288B3849@MW2PR02MB3772.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxvC5a59Y31J/mYwPzvjoV92xOdTGk/FDw8M8tpGF0BqCIM74ZSi+cfMtg7rFM2zbgspFOPQQ/YvuUyVgnmGDlcbWhz+eTCueQt/Xi3QZBVa4lEOFYqM+mvIQembMT01yau5dGOkuGTOJiXMnFpWFNge8HSbAwrr2UY9okPfL4MrSvKLWj/hkUyXFOqrtH0JY6ZAW2SOcHiE3t8f1fRSQEWAOhlKPxqxaS1AVfH70VPuaoAhVfhR9I6cvi8nbjQBeXDm25KVZYkD2j10vYoOfjA5kM3OnY6x0Iv1PJ5Z+8jqiiKSvWaOBM6FcZvcToOCNf3GB0Lr5CP9g555Vd9Psqvq0AhwGkauE7AJ20lxwN2O6jf/y1JjO7CkbP+Cek+4nQyTFg1wZbzoXHCzshRTHr8rvXWuXJL9BMHVDwv97imVqmCtiBLvcQ11XYflYgkOWNiwMdkZnLO4GQEIMHe1PCIY1iQtgHnR1+P2G7qa1ZQCbI2mKmV9dLOTxhE5XHFABP7MnkY/0WpaE6LfRkgnEfveaaFgOxtMiGF3sI4PYNxNtr1M65na/Im6A/so6HghAnkiWOW905eA1z4K+jriVjptidZ/41del9Lp5jcqBRqSTbM/VI0rXlBSbTWQ7GYg6f/FjkJc450fOuF52Qsdkrf1N3ukNahkTrx/mrFR/h45grZ4kyZIEJKZcNdwBH7M3pMsbyGC4UCMvCcKzmsUA1PJ1gxyiVLUa4qhQmRf7jM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(8676002)(36756003)(66476007)(66556008)(956004)(66946007)(86362001)(2906002)(38350700002)(6486002)(5660300002)(15650500001)(52116002)(7696005)(107886003)(54906003)(1076003)(6916009)(508600001)(2616005)(316002)(38100700002)(8936002)(186003)(83380400001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vfr4iGgdrN3lZ0hTKv0+VGk5vnnMtnSxCpFp8s1iG+hxB8Qi3mEarzt/gnYu?=
 =?us-ascii?Q?0HDvu85LPodtgkTZdfZ/lhLoEe1yu4W2VHuh+qiVOKST1znPx4CVaY5rzksy?=
 =?us-ascii?Q?U9/FDPYcWK6feLh0n6In5YvjM5e+yHXtriRygqnPWID3pYM8zY0i2Eys2F5C?=
 =?us-ascii?Q?UlKmKilhyNOlHU7FKbHBlbDXeVD0uev5o4ZmzIZ9ibwRqH97A3DRhW8qVm4K?=
 =?us-ascii?Q?Ga3knypyOLVnPPys+6pcWrPec3CBD2bgXpFRM3Tnn+rHfcgl8qfbdO3HsVXD?=
 =?us-ascii?Q?dFX6gA6xbsDlGRSNr+puUJeg5/JX9vbiTLa3E5uXlePd1+A2WgwbbepwX65B?=
 =?us-ascii?Q?5nC/GKAgfDVsKJJfHegYg1PCJ3bq/RJ/kg/P1DfIJKE2B+HptOFFUDZSdNrM?=
 =?us-ascii?Q?mbwasX7mPPRCyVzazukAgqR2J/wEf6BFONt29JK1/iiXNZU4cBkUi7lQizL1?=
 =?us-ascii?Q?u5MSj6jdTTZVrg36vzsjNqoMBlrsN+iVwOEK9qPaBbkRXVQg2lRyJM5foVQk?=
 =?us-ascii?Q?57a2yuOXypKWITxSUd8y9FOmbNGDIr22MvmzVoP+jmTm7YFPN74pwxT2aPPM?=
 =?us-ascii?Q?W8vF4hYzMvq+HV8hJ6RrLtm7+6Xl/3U59upWhqx4Tu1d4It5/cnVwi93vdZp?=
 =?us-ascii?Q?3Isi4YXOJny8Ta5I4SFOEVw6iUKPv+HWIaoCuy7Fnoennxby5RrSTcQOQ5A0?=
 =?us-ascii?Q?K9jvn3gM43EW4n7QpbxClkBzlE4Pwl5C1FO6KG+s6Ma87TgUlrk/lIW5qRht?=
 =?us-ascii?Q?GbxPbjlH9sfeby6AV9ZmHBckmAxReHQibXelyV5R2Ec5Enczj2bz8/UcaVG/?=
 =?us-ascii?Q?5I5CRIkRIv9EprqKsw5Y+jm6dS5j1pcL7TgcBgQhhoJQm42qxP2fwv160CIC?=
 =?us-ascii?Q?bRyO0DZY2qxW6nsWQH186Diq+XmQ3agYz4aL6ldTLbaspwMAUMNP9HwR+UTF?=
 =?us-ascii?Q?jK0NSeGFkM9fc14/iBFU8kSctCSnOVcLwWlOkapAkD3tglkZv7YmKj97G2JH?=
 =?us-ascii?Q?W+LXhndjTuBqJD3uBdtgW6K+LMj2JgdL+v6FsolLH+mX6iqUuyGqutm1ZQdE?=
 =?us-ascii?Q?Grs82KxOf7Hf6BDYs1xvTCNQ8Tk5USACGMKZhWzJHVUfDIe7GzqdmI9lII9H?=
 =?us-ascii?Q?RNOl9/UyBBEEYmSAh0MmLjzU0wzFwQyK2GP0SrJnIUMo4yFhGG0J7afJPXb1?=
 =?us-ascii?Q?KhcyEQFzpIa1Egg3usdG1Nc6yIOi699Vmj9JWZOed2eQaJ4jwNe+vBC/eMCU?=
 =?us-ascii?Q?CgzyAG0/k5YvFj5tlnNE7886EctjE5IohRxnRnNTrxpzDHIfH+rJ5BFSTR71?=
 =?us-ascii?Q?lSF9tdR/ilDe6zAMOuta6O9vnzp0JjLpvJIy6fCUbfMrZs9o2Bv4wDn0Ud+4?=
 =?us-ascii?Q?gXPT5PkIS/MFaEIdswzkPtvuvHLrnaDXZF1hzTwSo56HvVR+E9Wa7XKLVqUn?=
 =?us-ascii?Q?sko6E1Gra9zudq/PeLElxx+t/aLatNMlwU47naQiqVckh5IAiA3qWAVZuEt3?=
 =?us-ascii?Q?kkRbjC1UeIEgJutj04vK9Zd8OYt+L8ByoM1g/+vz/2HptaIn4pmH/77zuTNJ?=
 =?us-ascii?Q?CYrTnwdHArqk2K+9ua7bRJlmUdYiP1JDXV71HPnMIaC5NPXgyeQ5wiFa7xOK?=
 =?us-ascii?Q?XyMFBvyoPc+eK8MWuJg4bskNMvXtK6oHby3t7oFpfwtsTUglLCX/kJZnmxg4?=
 =?us-ascii?Q?yUvkcCrvi1391hZlX5DoE3Z6Zt8=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e50981-5d3c-4bcb-c793-08d9989eb262
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:36:01.6351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rj3wL5ye/bDmkLguAZ/tgclP2czHVEcOGF0GlCxacROW3kN7UKlEzUcVAaj5L+CPlpoR2P5ECfwHOA9oOdhr3X3U4R3DAlQqIhcdSD/nusE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3772
X-Proofpoint-GUID: x02YAILxO0SYoPvwJwa6YXFdh_ZkCBar
X-Proofpoint-ORIG-GUID: x02YAILxO0SYoPvwJwa6YXFdh_ZkCBar
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
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
 include/linux/dirty_quota_migration.h |  6 ++++++
 include/uapi/linux/kvm.h              |  1 +
 virt/kvm/dirty_quota_migration.c      |  6 ++++++
 virt/kvm/kvm_main.c                   | 15 +++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/include/linux/dirty_quota_migration.h b/include/linux/dirty_quota_migration.h
index 2d6e5cd17be6..a9a54c38ee54 100644
--- a/include/linux/dirty_quota_migration.h
+++ b/include/linux/dirty_quota_migration.h
@@ -3,11 +3,17 @@
 #define DIRTY_QUOTA_MIGRATION_H
 #include <linux/kvm.h>
 
+#ifndef KVM_DIRTY_QUOTA_PAGE_OFFSET
+#define KVM_DIRTY_QUOTA_PAGE_OFFSET 64
+#endif
+
 struct vCPUDirtyQuotaContext {
 	u64 dirty_counter;
 	u64 dirty_quota;
 };
 
 int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx);
+struct page *kvm_dirty_quota_context_get_page(
+		struct vCPUDirtyQuotaContext *vCPUdqctx, u32 offset);
 
 #endif  /* DIRTY_QUOTA_MIGRATION_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..3649a3bb9bb8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_DIRTY_QUOTA_MIGRATION 206
 
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
index f232a16a26e7..95f857c50bf2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3511,6 +3511,9 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 		page = kvm_dirty_ring_get_page(
 		    &vcpu->dirty_ring,
 		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
+	else if (vmf->pgoff == KVM_DIRTY_QUOTA_PAGE_OFFSET)
+		page = kvm_dirty_quota_context_get_page(vcpu->vCPUdqctx,
+				vmf->pgoff - KVM_DIRTY_QUOTA_PAGE_OFFSET);
 	else
 		return kvm_arch_vcpu_fault(vcpu, vmf);
 	get_page(page);
@@ -4263,6 +4266,15 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
 	return cleared;
 }
 
+static int kvm_vm_ioctl_enable_dirty_quota_migration(struct kvm *kvm,
+		bool dirty_quota_migration_enabled)
+{
+	mutex_lock(&kvm->lock);
+	kvm->dirty_quota_migration_enabled = dirty_quota_migration_enabled;
+	mutex_unlock(&kvm->lock);
+	return 0;
+}
+
 int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 						  struct kvm_enable_cap *cap)
 {
@@ -4295,6 +4307,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
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

