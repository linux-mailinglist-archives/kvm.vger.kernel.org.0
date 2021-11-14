Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA5A44F8A2
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 15:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbhKNPBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 10:01:09 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:9808 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231264AbhKNPBD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Nov 2021 10:01:03 -0500
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AED098b003466;
        Sun, 14 Nov 2021 06:58:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=sqxGsmfS8LmYdZhfO7AUXiDADVJ++CBE09c44YgkT+w=;
 b=jYevNvs2+6l/FhvMVsNNClrjbtQwMrxi/d2ehLMpAmym5yCxQXvKWMySi87SjmiVkuwz
 A8G6Lh9O4E4sx3py8PnpdlBgG1iws9VYTfcejPPP4QgNXv0ua99eDXA3si0pi/sFeoM9
 J6mCcO8k6ivEhpt7zK1uXc+3XjEyeU0l0IpSch2LqG1ZOmDT0xhyybcAvTvqrMb5jeXS
 c9H0lKZgt9yfynOqV/GNwnSjGrkmx9ga55JffmAoe53lWD99gJX4s/6kXz6xAO6UF+AA
 hvpcWYs7NqMQZUY9P1w1N1HkHZyi+JbsDNP9+rntiaDY97CbrkeDkHo3rzH5j1wL3K20 cw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3cacbpsp4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Nov 2021 06:58:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SF/1Su90rLv8HPayHXdmcp0vnjY69htwvtEuGo+u2UweKDdttiMKNQ+39JSmIztelFt3FktrASJGUZe32Q3rZk6vWxQObuDFqsEkbDdKzZP8v8/c27mOsiRdzUi58tfmr0MwrKibQX0F4RVruSpXPaPGTbel9TBU1bO3WigB8rv5wtnRKhY+gaRpfKy7Z4trbyl3cg+z4DCkuQIKT67KdtbtkOw+8HdYDf2losK+XWPJpUubAZxLffeTC8v3ZdV231ZEBq9MdPua2tuZGrVqolPC0Y9woIphyuCFJN9hSIDP9pPWlTkw6olQSTihKLxr0OPry9CC4rD2W4OQ3sisQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqxGsmfS8LmYdZhfO7AUXiDADVJ++CBE09c44YgkT+w=;
 b=X0y2LWkeLT/ZFz8TnU/PjfXrHG2BFwb4YA/D9zaSLuY+6lCUZtyS+jcEpPYq/yp+0H4QaIgRBJxy9LZ6+zVAXiNeT2sQpv+b/JQHv0ID18owrKlDTKBcmdweFZ0kavmgR0U4Fc+Nqf6vmeGFnmjnZnuGGDV+i2ST91zOw45q5coUFCTGBWyYszgGH+FLQUPNSKo9YR/lCyQj2KqQG5CFJPf5ZTU0CQCRf7f0R7P+RyWBV5Bizxx1HxAMyhzLUm/h38Rm6d3S9XRTtdYCKw30b0OmOKbve5oaB6zOUdZWhGqakNlHFL6C28Cm3aoRD/yshTjgY5cSjLZgMZKhz6Jl9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MWHPR02MB2528.namprd02.prod.outlook.com (2603:10b6:300:40::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Sun, 14 Nov
 2021 14:58:06 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%9]) with mapi id 15.20.4690.027; Sun, 14 Nov 2021
 14:58:06 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 6/6] Free vCPUdqctx memory on vCPU destroy.
Date:   Sun, 14 Nov 2021 14:57:21 +0000
Message-Id: <20211114145721.209219-7-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Sun, 14 Nov 2021 14:58:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96422351-0a3a-4d91-1573-08d9a77f2a52
X-MS-TrafficTypeDiagnostic: MWHPR02MB2528:
X-Microsoft-Antispam-PRVS: <MWHPR02MB25282B1C9BF0845DF2E1A8C5B3979@MWHPR02MB2528.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jmXWCdxMIHC5WcfGt41sBdCzzjUexerHLcQbvBo/Wl8Q0wgqGy93VrTl4MFygvbjJ6YMQPznIKF8RwlmJFyxqsHWHudNC1SM94/Zs9H32My3nYgE4rs9jw4u5y3jwcacgKjkKW2ngQzzx10gnbO0vnPnY/mdKym2iLGeH1l3qiM6aCf1pKqfVQfpKu8/JxUvj6lQCCNTBazPW3UZU8tSCefL7hTCE4KT06r5iSv+q4ie134TV+JJq0LDk5UxbbInzmRHmOxhQUwBfIcBci4lrsC50O5kVShqExqzt9fmqsMsN44jO+gxJ0ox5aHfvtftUgOSP0QDzRpj4sWwPqw7IjyK2m9UcNPTWzLE/SmwO7yJ+pYE3jrgSUOVqg49BBzzPu6oAzIaC85N0HdrcUe5XlBdNquvBs4VPCq+R9SPhOj9mU4S1eSxFzwPf+TcSWes22wbtVCdCEiYptPZmNwCXm97xrgUf+R1VDPzsStivIgd4YDSJmMjW4EqIjFHuWFY1YkszXTT60Cyh9q0Woi57lcIRYbNadt5Lx5CTa3PcKO7gAQKitXjhxwp3ze+1oVBDWP+LYbKMxn8A2pLzJNIrEbaIIYtVfHeG5bwHaOP1jbQwQt7bfkPC4pjCqpOlbs6fiRa7kZkGAbMkbyvPsj0oHdiNrGlORtmK0eYzsxn7DPtQD0Zmn1X+/658yXjiH+MctVz9TK0GPJCcvpdM8p/jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(66946007)(6666004)(6486002)(316002)(26005)(38100700002)(107886003)(1076003)(186003)(6916009)(83380400001)(956004)(36756003)(66476007)(38350700002)(508600001)(86362001)(2616005)(8676002)(8936002)(5660300002)(7696005)(52116002)(66556008)(54906003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hpsy1quWwxcO547P1Fkliv6oPQsrE4v3sA7zO4l22Jk6tQVi/WR0/6RH7QYt?=
 =?us-ascii?Q?GklmRBdRRP5Ie5dek6P56oYVbUxPA/mG49l7cwn3PLXi7LFgmVfhAbD9UbyX?=
 =?us-ascii?Q?0xOFpIRGNg25ys4M6pd8/hgHKyutpQ9d5jA2+fx4KBXLW490zUmv0MRsqUlp?=
 =?us-ascii?Q?D9yDx0libP2SdRokyyST/AYuAJAm9TS2O3WuUfwjr6OdmpTq3YUJMMt/6XzT?=
 =?us-ascii?Q?Z1DRliquJrDofifG5NdUaGpFrgyIflZbjw3rZhcMQnE862khJTdJT/KElKVs?=
 =?us-ascii?Q?dig7osM306x9+UqV63FgzAIgoyFhcDlcncPSAsFFd3PxzqFRUHb8k7WFobxk?=
 =?us-ascii?Q?94e8sQSd0ZGhQw/N+g94KApnKXOxCt1QQfLKisBW+ZhJ21zNwP5Qk3+75miT?=
 =?us-ascii?Q?HnD1+U0p8Mje+YY7g7jea5SjzsRxvvU9+5gaFR7G8J+AILCRZ+epkC/M5+Sy?=
 =?us-ascii?Q?2y3ezUJzes4gK1jKMbvqnYtVrKRX+Pvw0qOki4F0VkJ0G/MdHYYTgTWI3Q3p?=
 =?us-ascii?Q?FNZoCXs6GqTy/d2xvOQwKiI5aEL60imtG+nh0Kpw/N6neJe8AGKU4eM1XTf9?=
 =?us-ascii?Q?0Eq3h5p2CSd53bXFhKxO7jYx8KnzxM0V065qcBL4q98kgVcyba3iME7HgNDo?=
 =?us-ascii?Q?kHOMFSaUUqRZjVeSbCYNMzh2zYkCIi8V+RIsDJ/gssdm44YURnFVAGOIcrFN?=
 =?us-ascii?Q?HK6FsyKnqdRV9CH0/H2cD6sfmScTkqjXZCKafqmgeh0UlKJfZS4hnCzuglPZ?=
 =?us-ascii?Q?GrIy0bWKEkHBO2fIyB2o5ornKMXWsZZ7Jj37FB70wRBJueOhiOJS9+WlmkCp?=
 =?us-ascii?Q?vEvPWiCtF9tbu73Iy8aNGK6yYpIWpXrq6uTBRxWW0FpASKShfUcOga2kJuw0?=
 =?us-ascii?Q?6Opnri0ZSUgauojTh0hubChJLdN38Xu3jm9bSLVvX9mpTGxBF5YRVU8QZ9Wf?=
 =?us-ascii?Q?dOBnAhoPjtIeN87VacNWzeP9xWWscBr925SZHO9m+DBjbDkZeKZwlh7kiEx4?=
 =?us-ascii?Q?+6YCl8bGymQNGr6gY9n4mLHA1fbYh9fDhgytPq4htR/b9B/Aou3hXd1gSkUo?=
 =?us-ascii?Q?R0rD93HQEbaAYKB1fVAo+L14GqYuw2xL82Xdp44LOUVdpx6HiVzExRo9U7pj?=
 =?us-ascii?Q?sEsPgL1AvQPL7R6DW58BDsq5hhjQzpZvhUyp9vCirhEgwUb5WKjtVSHeNBzI?=
 =?us-ascii?Q?GRK7oLaRPB44W8tDBD+Xpzj8FXbLNhMFVhHFPPPVaNBFt4RXg2keRyGlgR8x?=
 =?us-ascii?Q?/Beg45SYv07FMNcxjdWv6oGQIzBdy3+lu0/UbhkXLMGT44C0ud/4ImGw3tCB?=
 =?us-ascii?Q?+ormrWeI2+rNHHt81OVXgqtL3XWMfzmewZy0l7j920yTIIiXSPI6DFa0GVog?=
 =?us-ascii?Q?cG9kHxR8/JiIWh0dxe/JWMkQCXEZB+3OPPiiAw4jC/woELuQoGw+mxRWSnM2?=
 =?us-ascii?Q?qsDhtHKuKFfbWUszM2F2HxImxCnSFF9pLp9GWWY8z1L8sUc7OnNPlW0mJBCH?=
 =?us-ascii?Q?TeMsoMwHlGg4SiEWCuRqQ4neSO3sb21qvJgtBOPEAfpzdKQG9Q9GYj4HoTsy?=
 =?us-ascii?Q?SRLbt0r6RnemiG1oqO4NqR5F5+W8mHMwFc91+yMRiRNWe3/i3I80Hw62VfqO?=
 =?us-ascii?Q?smfzgu2B4MQN5j4JkCE1JgCkIrzsSMpisqIIuPI1Ft2792gTQcHqmNLvTFYK?=
 =?us-ascii?Q?X8OxQKEAhT8wry5Kt34sNpYM4+8=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96422351-0a3a-4d91-1573-08d9a77f2a52
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2021 14:58:06.4294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrlj9Sn6CzQ/lXsKsm2ZQpvD6rrYU5yhD2mTzxxAtmx8+GQxlpWAYjaUQOImHtx7CkCVESgCpOguZTCsWglRLGVXfMwA2Bta58ZbchMn1Hk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2528
X-Proofpoint-ORIG-GUID: w_2AKNX-FR0m9i6N8kk7n__HZp8zPGlr
X-Proofpoint-GUID: w_2AKNX-FR0m9i6N8kk7n__HZp8zPGlr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-14_02,2021-11-12_01,2020-04-07_01
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
 include/linux/dirty_quota_migration.h | 5 +++++
 virt/kvm/dirty_quota_migration.c      | 6 ++++++
 virt/kvm/kvm_main.c                   | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/dirty_quota_migration.h b/include/linux/dirty_quota_migration.h
index b9b3bedd9682..a31f333a37bc 100644
--- a/include/linux/dirty_quota_migration.h
+++ b/include/linux/dirty_quota_migration.h
@@ -35,12 +35,17 @@ static inline bool is_dirty_quota_full(struct vCPUDirtyQuotaContext *vCPUdqctx)
 	return true;
 }
 
+static inline void kvm_vcpu_dirty_quota_free(struct vCPUDirtyQuotaContext **vCPUdqctx)
+{
+}
+
 #else /* KVM_DIRTY_QUOTA_PAGE_OFFSET == 0 */
 
 int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx);
 struct page *kvm_dirty_quota_context_get_page(
 		struct vCPUDirtyQuotaContext *vCPUdqctx, u32 offset);
 bool is_dirty_quota_full(struct vCPUDirtyQuotaContext *vCPUdqctx);
+void kvm_vcpu_dirty_quota_free(struct vCPUDirtyQuotaContext **vCPUdqctx);
 
 #endif /* KVM_DIRTY_QUOTA_PAGE_OFFSET == 0 */
 
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
index 55bf92cf9f4f..9bf0c728f926 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -438,6 +438,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvm_vcpu_dirty_quota_free(&vcpu->vCPUdqctx);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
 
@@ -3693,6 +3694,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
+	kvm_vcpu_dirty_quota_free(&vcpu->vCPUdqctx);
 	kvm_dirty_ring_free(&vcpu->dirty_ring);
 arch_vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
-- 
2.22.3

