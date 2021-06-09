Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9C23A09CE
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 04:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhFICMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 22:12:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42206 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhFICME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 22:12:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1591AK1V036131;
        Wed, 9 Jun 2021 02:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=rNwt9UOOm0/cE5NjYsCNNcoaSz4DNRBm+k1CVihfWZY=;
 b=L20/VKuqLM9qPQEmUELs4hYzAsCwiccmDxhAYvwyNa2cu2IKlrxK7qBugsPdZ636QAAK
 J2pMVx2pWtOtBWOy1ZlXs/tT4UMqVf18bSWvb6KAY0EPvaA33crglouyGnrq24SMBHAC
 qjZ1HGhLpU1l5HKamy4Lx9mAe2QyyfgbHwFi8Li4ZT63klAW26JGz77aebd/n8+TEuL0
 9KBobhBSoU6IcdaM2r3h+gqJsbPvSX5H6vVZJ41dfVS/lL0pOz4bz7m5BXMxNe6rhhyp
 DQonDigED9YnAjFSmTvgiZUdMAnkhKvYEhsgSfBgU/oNNOYEbEwHZZDR6eRPlUb7oxjb 9Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3900ps7nbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 02:09:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590aNco129799;
        Wed, 9 Jun 2021 02:09:08 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by userp3030.oracle.com with ESMTP id 38yxcv89a1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 02:09:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Avak5SovD7DnAJcNmLIO5O2uezGWvVXOsKvb5sMKsMd6dFb6NWrS7gq+q/HBR7yfvbpgah9g9k/ViPqYZQ6Oc2NBo0nWQfC/COl46IWc5sDVQCU4Fi8IXdxTK+GplVCWkvNilwl7NKorWUJmozO9DtIe3IXfHjpZV3rrxHdr3hX6iPO06+boUt8N1D8KbTQZDfelOmf2lrYWn5jxDyBdOk67+tzSJbXUr9ez3w+XP8YbotKFIwI0AVnyTj8zq/UtwbkDOoIFKhJIWyTtHX0GkMioAQcyD9xxhmlzCdNbIoktTwkrfNIsSxABMf/OAZHxj0AN0+8K85UNtOturekgfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNwt9UOOm0/cE5NjYsCNNcoaSz4DNRBm+k1CVihfWZY=;
 b=ezKN4416G44S1jeBKpMUE67TI9yvXHwk7AqEJncXvhBUQ7Shc9ZWawHjThTP5XpAgXv5yj75iPEDD5iJ4S33RhfDSp5JTchAtFMkt4D4cz5hNhwJ7utDf33wUuel1tLR8Rhnl71oAohJBC+HZ5AS6R51nG9PUh1DDK6YMF+1imUGn+xQviBCFXbZDLK0J6D9vDqARN9KEpmac/EsownS0DDFe43I3isvvxPXxnskWYbltuGU1VaHrHZHiVt6srl+SrGolgbedyNsEIMQCVrYpFs8RHJiTi6C8s9RtDRz/TWge79V3JFvsJpKhxa6jYaGVsLxw+C5Afgq9C2oG4wrtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNwt9UOOm0/cE5NjYsCNNcoaSz4DNRBm+k1CVihfWZY=;
 b=gxbVqrvg8a9bQnvmuxIv72hHwm3AS4flDWIG94oLbWJILQQHYapjdtxnuGVi7J/3SMrNTK3I61ooB8rArVRcJaLyY4hMSIEAeOkXcH0YjstMC/V+sOYuvE6kGe1eZQ1C5Hk5I6pwOIklgE1zyol5mCNei5kspd5DYX1A5l2g+PQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 02:09:07 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 02:09:07 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 2/3 v3] KVM: nVMX: nSVM: Add a new VCPU statistic to show if VCPU is in guest mode
Date:   Tue,  8 Jun 2021 21:19:34 -0400
Message-Id: <20210609011935.103017-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210609011935.103017-1-krish.sadhukhan@oracle.com>
References: <20210609011935.103017-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA0PR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:806:d2::19) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA0PR11CA0074.namprd11.prod.outlook.com (2603:10b6:806:d2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Wed, 9 Jun 2021 02:09:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06908134-9a36-47fd-a01b-08d92aeb8fdf
X-MS-TrafficTypeDiagnostic: SA2PR10MB4524:
X-Microsoft-Antispam-PRVS: <SA2PR10MB452453C05D6F9D576029059D81369@SA2PR10MB4524.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QeO2x2psDsgEezqQbmovoQIcV1dxI1y3//MlIfNK7hS1G7fiugBTAP12m2TGd6rqTRXqnpcdKQMAUJQCXORrUiltxc8BShT2raOWxH4fPVJM6YQXrZRmCxYST817/Twa9vyMye9xVJmb2XxiymRIde22UHGZHNNrQGHoxo0zIPOegce6vn6uLb55E2JuK39/2n76UqmbQLsEFgNCOrvAlQXvv+0fxziK4Si2xd78rP5bVSGkEzSlo9i3y/QsHxklRcJofBo0/UigN/w+G678/V4iyOwqeynppsm+RQAnfBv5vsYiQDChJAFQkjMRi1LY1iuOc/BK2887pzhnYk7upGVRUY20JeOPf3Dg7GA6aNv8blxguBOoJlVMJFKVeDOLt97qhlVagA93URG0rWV3UC61JPpRSW8U1XC7Av4KLvkNvKWz/8XUjVfHFnTyU1G5jTaSEsUZgLuNVn9TLonHDhZP7Y1iQjEzNlxBs+HSXkRVeFpNj6EDOoWy+gqzwA2peU+0hkz74j7WNabvPIzACByghpW+/2sPbJP2gotGdnXTaoGmE1Il41FwtuljKsGTiJnyQda4L9KNKmY1HCja2ejxp64VqHrPardh5/IfPwtnUIO5XaAc4Aj7qBndoqMWFRiLBNUJlMgwEqr3/7frVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(52116002)(38350700002)(16526019)(186003)(83380400001)(38100700002)(7696005)(478600001)(44832011)(1076003)(5660300002)(86362001)(66946007)(4326008)(36756003)(26005)(2616005)(66476007)(956004)(66556008)(8936002)(2906002)(6916009)(316002)(8676002)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ufZPVbD7D677Rrqjl0OpQzC6BLp8tuRFTPEM/8K5hg70J/qkX0+N+U7iIHNu?=
 =?us-ascii?Q?mxKdkq4IJwXYYQdQjcYlGmTVP+tAN0nSgeTjv361UPS0tb3Z0uIL0gpIoVGJ?=
 =?us-ascii?Q?NgcM/QjpKb6r2NMpoD4OQIEQJNBbIBPgsket6pBkdzMNg6/co/R+Wj1tYjYf?=
 =?us-ascii?Q?j20VXVGWPbo+znlrUS3uVqHTpMPHB1dh2ECEQNAklE4UjoOeD+17CuZxM92i?=
 =?us-ascii?Q?L24YKifyhjVKhi0AvSWXNWCE7exwSAHvCG82e7kjSOwaTzq5+3YJLXphLg2C?=
 =?us-ascii?Q?kTB/GRkq2hajCk5uNpFNTSpr1cHrUP+LwTWVWpYVRuXizGKTi5MlNMydO/FE?=
 =?us-ascii?Q?n+ZNIGo77KTKPuN3l5KwpLDhFhILkWFTX/aYRg/y0ohLjQdbDfhqKAQdofPW?=
 =?us-ascii?Q?NOUUD8SUoATJcSs95hXeLGFp7CVOiJUax+eE0p7nwIwxQ2dIovCTtMWiCejA?=
 =?us-ascii?Q?5wJg/MJb4k5wd1oIGFBgptmW+6x8cIODAauKw3svHgEykEKyA4CWnvkzVcnh?=
 =?us-ascii?Q?rLaXvPTEWd/Z/7u3TsUUjFlMjcPbeFTEL6zVzs1iMCD/VfFWAvayUoPGH316?=
 =?us-ascii?Q?LkC0l8hhQvq0l8vBQg7fRV4QmaOWoA6bD3BokmCosGO0X3N7Q3JTWkWipwdl?=
 =?us-ascii?Q?eNveXRCFUS9zTeceuTSz1VEbkUUTB7O9gJ+V84vXFx0wGOyb1giOmVyEKljE?=
 =?us-ascii?Q?ZyhKelqEzCHpQOT5XxEpXGlvN17mhWXlg3AJeoRnShPdgsG1bMEZJXCDxbPs?=
 =?us-ascii?Q?fDl367fFUhkrVgyId23vROgA2ChzDJgGReJdztwpXyDvOYspVaAtjorSwDxa?=
 =?us-ascii?Q?NIrYW8yDHX12srzoyxrWayWHn+Tz6FEF6ESN5l5Y0zGW82wYMKl0ZD85fg3V?=
 =?us-ascii?Q?giepulwSNDRkTgO61gzNni8TIjrhimlltIt9gaPq5bFlmHO1w/c/GzH/ZzPf?=
 =?us-ascii?Q?cNEy8LfP7xaRCukcamKnmC3fBf4DnY6d3YW85p+Bhd7ZQPpGqHuwPmT05PIw?=
 =?us-ascii?Q?jWzS1PjwXxtRkQE729eOhxo4XCAl+wFsUUKeAgzg+mxdOiFcnj5oVlQTxDYJ?=
 =?us-ascii?Q?NV0h4zB+IgA++JiXrCgrsXZVOmf2BtIp9H21aiSFcBw+DBW3sIybx/WwkT3R?=
 =?us-ascii?Q?zQyKTUPOQLUB9AZ/TmEoeU0sO1d6lJKr5bgxAi5Dhe6YdHYtwunJ2PiEt8AS?=
 =?us-ascii?Q?onU+IPP059bzH7SmL0FOjMQST7e6F9Yyos/EAdS3HDa23x4YtJRKSnPa805K?=
 =?us-ascii?Q?I8WwiGfRSJLG6or96cBSb1OhxW51JIqjOcVRQqtI6Dc/PRpZ+JXoyOQ+gon7?=
 =?us-ascii?Q?X03MkGxg6SD/9MAhniasFpXS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06908134-9a36-47fd-a01b-08d92aeb8fdf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 02:09:07.3451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhLkdWR2/Pf2f1yTUvOSOZbNChWELWEMsWFWaBQ3nm9rgGgTpjqEBJGwXC8rkXZtsFBXG1kJA2QBEohJgAs3P+W2R5z2Ur1WJvThi30Dt2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: 4Mw0I8TRsc0otHU4NYn0FBrl_kmfi7lq
X-Proofpoint-ORIG-GUID: 4Mw0I8TRsc0otHU4NYn0FBrl_kmfi7lq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following per-VCPU statistic to KVM debugfs to show if a given
VCPU is in guest mode:

	guest_mode

Also add this as a per-VM statistic to KVM debugfs to show the total number
of VCPUs that are in guest mode in a given VM.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/debugfs.c          | 11 +++++++++++
 arch/x86/kvm/kvm_cache_regs.h   |  3 +++
 arch/x86/kvm/x86.c              |  1 +
 4 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cf8557b2b90f..f6d5387bb88f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1173,6 +1173,7 @@ struct kvm_vcpu_stat {
 	u64 nested_runs;
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
+	u64 guest_mode;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 7e818d64bb4d..95a98413dc32 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -17,6 +17,15 @@ static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
 
+static int vcpu_get_guest_mode(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+	*val = vcpu->stat.guest_mode;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_guest_mode_fops, vcpu_get_guest_mode, NULL, "%lld\n");
+
 static int vcpu_get_tsc_offset(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
@@ -45,6 +54,8 @@ DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bi
 
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
 {
+	debugfs_create_file("guest_mode", 0444, debugfs_dentry, vcpu,
+			    &vcpu_guest_mode_fops);
 	debugfs_create_file("tsc-offset", 0444, debugfs_dentry, vcpu,
 			    &vcpu_tsc_offset_fops);
 
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 3db5c42c9ecd..ebddbd37a0bf 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -162,6 +162,7 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
 static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hflags |= HF_GUEST_MASK;
+	vcpu->stat.guest_mode = 1;
 }
 
 static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
@@ -172,6 +173,8 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
 		vcpu->arch.load_eoi_exitmap_pending = false;
 		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
 	}
+
+	vcpu->stat.guest_mode = 0;
 }
 
 static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d1f51f6c344..baa953757911 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -246,6 +246,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("nested_runs", nested_runs),
 	VCPU_STAT("directed_yield_attempted", directed_yield_attempted),
 	VCPU_STAT("directed_yield_successful", directed_yield_successful),
+	VCPU_STAT("guest_mode", guest_mode),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
 	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
-- 
2.27.0

