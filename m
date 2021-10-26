Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC13A43B74F
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhJZQif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:38:35 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:28604 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237426AbhJZQie (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 12:38:34 -0400
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFrT30016411;
        Tue, 26 Oct 2021 09:36:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=Mlzqw7OME5ejWEt6P7rg0UMdLXqkxAUMt2YIrxQfcD4=;
 b=DK/t47KgaWnARWIWqBZNslfU6JYXUyIur+INU/GiIy1RPOLGrm0dW0cYgQbD07/CAZpG
 yxZRLsK+AtYOmuQGdnO7jS53SIlhFJWu8P1g8ujUPWLAMr+WumB5WJW1kBw56y3MU7Ye
 GU8uvVSU4l6XM3sN16RCORrEGWjv+UtgsJyZarMtDPLVM05/JTFz0/5w04a7lAO3Fkvd
 mIwJWGlAcWc3XWLMavg7GANID9GlqvtSV8ZlhH7DqzUJ1D/CUaXmDgNtm8Khv8isdCtL
 Im3GhA+cUPJH+HKiYsAvG2u5Q734HlJ3Ikc6Cv+A8hs4uWaL3vqdo3X45M3oh8Ylubrh Og== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by mx0a-002c1b01.pphosted.com with ESMTP id 3bx4dssv5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 09:36:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRhsXr88CY54ixJIZatP7KstuoiJ08EPnxxDYZPucxltHw1EWqqP+6VY0eiGexflkJYRVRF5RHKSAWBFk3nIoMB++z8fenkxHhrJpaJ/iYECPfR++Skxoy2V1v9gf7MaEuGcioTvFD8SetXJBMbWt8FlwrmF4tGWEkBfdxAespiJBRQBFP5iIXv62JVEFqqnx1V41cvzuhK7R/ooMuTkTE1O7j8hWOW6PtfS9z3+BL5Fq5miwPvUFfenp5IdtEcZmyvplRakFpbf9U/gnke9e6bRhF6bHwYU9gxiPrsEJEMtkXKe7Em/696726kEmfAYZIAO0GhRXV4K5uYyhsOxOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mlzqw7OME5ejWEt6P7rg0UMdLXqkxAUMt2YIrxQfcD4=;
 b=nMIa0zm7ariYFNLpWbGW7s7PTpXLuHQwwYL1kDWR5rKMFAY20bkKm6mLgA5qV2ksjEtnY9SdtRBK7yqSlvnuCxogdjmRFX30gz84wkGkOQVaCk28Y+dXggg+mcOls4aoBopadeGeankxY6mz8L82T430uqFwzjPMTHADRZOgGi6cOa8tg8OqEaHU7uecC8vVT1B0Ae9Jts5bOOlwzXE0FGE5xChloGzBzTbvS0UlI1yBrglmv522DUWTpszPdHiQVWBwh4bgB4OeKA5pKJrjrd1OjHjpWEbxcpP7VdqToLF2OF+9i4LcGVn/gCJ0XY/mjA/II24TVbirJQFOBUtx/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3772.namprd02.prod.outlook.com (2603:10b6:907:3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 16:36:06 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:36:06 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: [PATCH 5/6] Exit to userspace when dirty quota is full.
Date:   Tue, 26 Oct 2021 16:35:10 +0000
Message-Id: <20211026163511.90558-6-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
References: <20211026163511.90558-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0369.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from shivam-kumar1.ubvm.nutanix.com (192.146.154.240) by SJ0PR03CA0369.namprd03.prod.outlook.com (2603:10b6:a03:3a1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:36:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85cbc3cc-5a04-4d64-ae63-08d9989eb517
X-MS-TrafficTypeDiagnostic: MW2PR02MB3772:
X-Microsoft-Antispam-PRVS: <MW2PR02MB3772BAD61342C562AB367647B3849@MW2PR02MB3772.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:392;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sbJpY181WMUwj7TwfHyaXOAcue+FOAGxyB4WyitWnwnTG2AbD4m7GUPXvb+NsLb3BK5WxrsJC1ywuWi2G75xyDhDd9VCCsx3N1plVzy/2Yr9skGG2yIqyxTI1x5L/XkOIBJqSRo9Tc0cAhvXmAwTu+zLiQsiacVrX4ix3uepEBhPqNrfBvdX6ucA/fnXsYszG/JtZlKxQuwizEh3U3bdHhSieCeJLlJMryO4zNQR6awcW0izeZN3JgyCa/nUBeFekK4hPZMWdR3ASNEbtZPKgfoLMP8iO3XWYfctacdKpK94/n1wc6OoEKSinu3JGvVDQF1gnaVB8QlROy/XKijmiqk6lF+3lABcsNWPfGqMHVALrOJoiEdQqTPiX029EXv/SjXh3412shFwy+R0/L2rxLMuTg+bt4r30594s7DmCtewIxuIOHARj1uTrNfNC1pE99CjHrq666UuVdIfUke6GbQAgJP7aSDSH9dUkGctPOjdC2SCYrks1vARuu7jMWIKIjmORA75Ukp/d6KQ+jzZHeBi1rSO0KMQn36PG2YHof9L7ra240+mwCSMC+I8/BbDh+fq354UJ/kEQ0vGVrXWj4TCL1FOjMbaPqnQqEgi9mp6smGCUaVcsMXlm6SEiJmxJehj4gqnRGO7FzAw3CU2O+qmx3oFw6YQA0gma8MBUcs11jRDdKZy3xmiXPsJfFN3iBI8Wd8cMA+lkKGlvMYyjEAxlpecvq49L4losGNwPWW9BC5apDbupH+3pC+OKALs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(8676002)(36756003)(66476007)(66556008)(956004)(66946007)(86362001)(6666004)(2906002)(38350700002)(6486002)(5660300002)(15650500001)(52116002)(7696005)(107886003)(54906003)(1076003)(6916009)(508600001)(2616005)(316002)(38100700002)(8936002)(186003)(83380400001)(590914001)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HuVEwmEx6Y7N23m5KMglS8nUiIuaVAK+SEaUbToPWXpVoG9ZyjKHMtGPqpyB?=
 =?us-ascii?Q?+qONPLVuDsQfKlHGMltDcO/vAgk3wFjAEvehqfHMoOJD4Zky6QOfRdNIaNw4?=
 =?us-ascii?Q?7DpN3FJYAwjUGZyttsy7kstsOf1KEOm4vgj+Xx7Y9vqdm9UuESo128PtyDm3?=
 =?us-ascii?Q?yAJqk8RAIJGwO0hQzNsD45Rt0fChPcL0sg45FSceqIn0tmu+CE6C2s2sNT/E?=
 =?us-ascii?Q?D7pxFsCxodWy06BDa6x30AzVHXetjp6xWDMYh1OxnnBd8OSLPIbKM2GfzZaL?=
 =?us-ascii?Q?dbRJ3oNT5dvvZvd4JhO22aByUWnxyVz4MmLxJ7/2sSKKtqWnwQ1+9cC/+CCU?=
 =?us-ascii?Q?k0Q8YaLFY7NMY6oxW3pTswdn6QZUn8sFWyBOuc86uVTtCJYCiFv8BIHevY6J?=
 =?us-ascii?Q?6ueaJXc12eLxc1g/YhRv1Rkpu2xvGxCyW2iWJFVKVZwp7glNkx7SKUgNCJGY?=
 =?us-ascii?Q?PSMiPoH5zl34E9nooiRP5IQWfVJd9EIEjn2jm6YYuTF4y0c/CnpBAliPbY1Q?=
 =?us-ascii?Q?RwrGerFXYlSGRB4SCh3mijClejR7aJ5Y5oxbPgspWVbwseMuJJ66kuaBgp2d?=
 =?us-ascii?Q?3h8PqTL1uohsbBvwC1t7eIrsuJYuvQnj3F/6+m4uz+7Skfdi9xrLPP6xJx1D?=
 =?us-ascii?Q?yJjl9hOLd5VfXRbIdPQDIUXZBsRFzDbdxAhGHydmNEb2hqzmD5y11vdVDwDG?=
 =?us-ascii?Q?KD9QD+WZFOr/29GtBpDqwfZIA+HhE2DnvAJa8GPGM8zhlKnm/Y9UnhgWJRnL?=
 =?us-ascii?Q?rljDBdRuLQul+c0h4lYaNoAMDd2T0onhgz23wMRKz5gn9ITzIeyH+SLMlmFD?=
 =?us-ascii?Q?5CGW4pRpMBLZdC5/EvLFX979mVqZ5bP7EyH7eYOuTcYAOpKr0HgjZGcfwUbX?=
 =?us-ascii?Q?ImPy0RVchoijRxg7k7opdl9p3nP3qPcks8pRoS6AGqgNTRgkTeAgSEVqItah?=
 =?us-ascii?Q?5ZwptUkcx+EnWh7tfj7hVQBcqroqpMysdR5+HmRlfSdHKp6epwFbmM5Uz4To?=
 =?us-ascii?Q?beIiwr9eBFp32+RETR7GFkAvYuNqS45cwceC/EwFaywCUmd0lwMwoH0pT0Bj?=
 =?us-ascii?Q?JvpNFjtUDOWjDVCewfFSxLj7No341D1JUui9pIfJqxm3yLydAke/fGGP3X5w?=
 =?us-ascii?Q?h8+c4ZSnu3s6E9kZKd6NYeQ1nPPJY2lnxVTwjqiMCNqrXZ7KVZDgDo0dFbcd?=
 =?us-ascii?Q?UE2oPl3I4H9mvQFDNKZZQRSzkkmUhsqaiIG4eWw05+7QvnOHQ42oE+JrN7mY?=
 =?us-ascii?Q?3FeGjVkvK34+I31q5rRLQPXI0DyUdYYsEbvFGfEh4kO6IM3AQ58ydEpks6lN?=
 =?us-ascii?Q?xcWqs3mu/DW60m6kO7GKZ9jmQizGQNl+5Ng8qgaWndrQvrChGmsbWtXHEHdN?=
 =?us-ascii?Q?17ZmiY9yrK1kdJBXMoJhRZPb6xjj1Ka8c4T4qNey9USlNs1popltiYKFfviH?=
 =?us-ascii?Q?a0FXRcDZbS4iwqJDJpBq0siTOROEd0WNauEzxnDmcvhtwxhdS4yO+1b2H8Is?=
 =?us-ascii?Q?W6zIkh6RWTT3DqfRj2G61F77gd8pomAAxveMrI47bB08abcgFHgOjl/VhrJV?=
 =?us-ascii?Q?s0fD2XFOJUiybo/bNKbwXRRaCmby+oosJUdhf1NmgPiSGxdBquUOGG13UuTP?=
 =?us-ascii?Q?0kbdwXnXYIpjGvm/LdShUQHwBJPRw3Jf+QhHO/z8tWCnFv6QTaJ/xQazNPLA?=
 =?us-ascii?Q?kHkalbFjstfCOA1x4/XyIn3y9b0=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85cbc3cc-5a04-4d64-ae63-08d9989eb517
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:36:06.1622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fLGtBuGUjlmZoseh2Xx7dS91vfH1beyPaytkmAPRwUa71QIrTiVYIIv3NizBM7fx3liemKOJcsY5GhJFyPaxF9f/TIPBBLHMMk8TV4mhjVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3772
X-Proofpoint-ORIG-GUID: deAMvV3kwaa6GxCXIGucbwV8amh0lZeb
X-Proofpoint-GUID: deAMvV3kwaa6GxCXIGucbwV8amh0lZeb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
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
 include/linux/dirty_quota_migration.h | 1 +
 include/uapi/linux/kvm.h              | 1 +
 virt/kvm/dirty_quota_migration.c      | 5 +++++
 4 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b26647a5ea22..ee9464d71f01 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -59,6 +59,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/entry-kvm.h>
 #include <linux/suspend.h>
+#include <linux/dirty_quota_migration.h>
 
 #include <trace/events/kvm.h>
 
@@ -9843,6 +9844,14 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
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
index a9a54c38ee54..f343c073f38d 100644
--- a/include/linux/dirty_quota_migration.h
+++ b/include/linux/dirty_quota_migration.h
@@ -15,5 +15,6 @@ struct vCPUDirtyQuotaContext {
 int kvm_vcpu_dirty_quota_alloc(struct vCPUDirtyQuotaContext **vCPUdqctx);
 struct page *kvm_dirty_quota_context_get_page(
 		struct vCPUDirtyQuotaContext *vCPUdqctx, u32 offset);
+bool is_dirty_quota_full(struct vCPUDirtyQuotaContext *vCPUdqctx);
 
 #endif  /* DIRTY_QUOTA_MIGRATION_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3649a3bb9bb8..0f04cd99fc8d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -269,6 +269,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_AP_RESET_HOLD    32
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
+#define KVM_EXIT_DIRTY_QUOTA_FULL 35
 
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

