Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA3E37B5A3
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 08:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhELGF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 02:05:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38408 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhELGF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 02:05:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C2Xvsx028854;
        Wed, 12 May 2021 02:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yns43+Cdy4SfJMq2HB6L/MW6Nm6xGP/To3F46na3ONg=;
 b=RtS5zRRv5WFGfZUwXxDIefwgmzSL9OXd8r40zvAMmsQgHb1ErzuALJVwQyJMsagWIgQF
 Y/4B0/u+IzawP1RwwGqAIS51h+3LAXbi2WHGL+rnqDOnSY/TbheqC/t+CccOT882f36v
 TQctUZotZ/KP+mthzTyzZoAEx7/Xc29molqpQfrC80LKttBcd7M1XXIm9jqNbpTXHWCs
 ujXHzHNbMx6GcWtZWOJaOTjhc7Upu6PZ47D7ARUBnkuQqkePgZ8BwIXdT6DDhQzU/3q9
 Iys1piVskK5ns2lf3BPfkns8MhmOgPZoh+2KwedZeprMVabkfEtQscjcvNvJRzDZPHn3 zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38dg5bgrn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 02:37:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14C2a2jq028938;
        Wed, 12 May 2021 02:37:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3020.oracle.com with ESMTP id 38fh3xnkqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 02:37:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mW1J/2M2xsD44JAcVgv8ezgrxF6c3N2EQPNGVHych4r4BkWamImSxOZQEw70lQZkSM4ere7gmEWJHmd6HFMnITPhtYWYnArfr3cIMel0DJoeZj/7eCloimv1eNU6dDFNswQlH8+iQ3dRfgM3EdKlo1VXr2SgRpx0TzaTwGR0P6+Y2ln0JKlxR3hJVdJcL7nCojdmOrXixF9hXQGnDyo6m+uYM4UewbitS+W+1EOoHPukToEZxrMZY+ByacYlhXfycmndBEr1jVZGCJgIVRjrlRxm4EcL7OLNpyvPUxU/Mw5wJO/uRzqy9gSuBVWGumSbD3Wfuo6ZrZ5v9IO5216pQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yns43+Cdy4SfJMq2HB6L/MW6Nm6xGP/To3F46na3ONg=;
 b=TnnLoC8SoZSORirbKW/aUM6fsM1Dk/fn+3y0tY2nZPBzgtpCGXPGFRhEpa2ru4eOjCtE46Cq0A5FReaCtSXVDosaGwXmdk6PXUAmbMeqdj4VIti6K1JiKvZpUkVZa3/7D1ueh6s49sZ9vOpB55OC/TNnQMSEGkKvJJdowA0/gYBeseJ0sjhFGLAtvMDlWSrkE1XTMdJyVzdjPR9CSootnMslhdy6+fDfenxVFTEYXfXjs0+keXyelMLi7nfif1VbOJrwoQkj7DFfFG1Sqt3XQ3IRU5rKYa8yPixKKquZMdiEd+cTBmGO/BXhwLgN/5Gnm8KeGXk7XRACPl5gcALTiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yns43+Cdy4SfJMq2HB6L/MW6Nm6xGP/To3F46na3ONg=;
 b=OAOc/5n1+DPAn4FmSmFbur+gdaYq5Q/1nPnLbmntQ1kxsVnXy3GhAJqLEd6ViurLXo7TV0PyvoLdRK2IjTXq4dE6JTtjVDHJwjeJVC/1jhFVAbLSfNSlkRJCmXLncFrCwi0kHSssKalwr6t+B+00GWX4WBFjoKmLwnO7q8+ov6k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 02:37:12 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 02:37:12 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/3] KVM: nVMX: Add a new VCPU statistic to show if VCPU is running nested guest
Date:   Tue, 11 May 2021 21:47:58 -0400
Message-Id: <20210512014759.55556-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
References: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR03CA0016.namprd03.prod.outlook.com (2603:10b6:a03:1e0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 02:37:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 250bc023-dedd-4881-c6b5-08d914eed902
X-MS-TrafficTypeDiagnostic: SA2PR10MB4425:
X-Microsoft-Antispam-PRVS: <SA2PR10MB442528F31C8D77C3611CD22C81529@SA2PR10MB4425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hlUCCR/JAC7T+rCLrEqNY3loJ4/o/I3ZnfvDW+55njs9siLYnU7fmGkfwukkwgSTbVaNbbEsJC5tbecAr3Ok8Up9Nr2K/1CJImFiW99lv7QsUcUPEPyn7jGSnu+HwC4M/dySx83u6bEmogLygIJhg84AZHjae90LitjICwBBIjqm/YjgRRL4py1MTzJrZUT7u+2mOPySGdcYnKjo8NvQCtk3mSkbLsWTZ5I5s45Pbe+haoghhM+HIcX7GbuT+BY9Ra6VwB1xtA4ie7YPHOj9OcPOTAtOV1xSEdccbH4GkW39iTnUVw4piVukyf1ba0K1V4SJ1LvuxRYzPpSW6hdSs7m6uWqf/grl2Sovqf91zPwlcCWEYpgAfx+Zfew1DYC5rY4D0F2eqqGULSh5ebbaact5tHwUz0iKsoLtvSarn5dWmYaTfPR4Z9T/8xtEzGQbuvn8/m6t6XeHRNaeR2bAFb/FiGTbyr/oA/EKvJt7UNHzdrX0QWXuQGj30hp8xpmhxXcHeXvCV83mpPG2KUjrY8TxnVbHhq+GACGU0nFUoCVqx8za88oT/KJgv351KQfwvWQgubiiNYciHfGBfl9ZqiaPBLYUuYyEXtwkv4qSrWM++kfBbD8NvnX4pFKijaC+R2JS16haS6n7ciVKGz5BtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(66946007)(8936002)(66556008)(478600001)(6486002)(2906002)(1076003)(36756003)(5660300002)(83380400001)(186003)(16526019)(66476007)(316002)(86362001)(6666004)(52116002)(38100700002)(8676002)(26005)(4326008)(38350700002)(6916009)(2616005)(44832011)(7696005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XEETZBqXFuiXpAZ+cfacH+NRdn641h7rbSAHY+wRDL0DOy6yghXFzkk1Mjzb?=
 =?us-ascii?Q?N3dTbwrUUsVY8vAlGe/Xrc79cOpxlvR2yol2mP+K23VH2JEqNaOcZiT8qEHR?=
 =?us-ascii?Q?oBoXWKtMbeOKfmI6q+atH5EayRR8JqyY80haH4NayTSJCIiHzqjVfYycKIYh?=
 =?us-ascii?Q?RPbCUhNsLRtHzP5YOpczxGfelFlECPsYeUMFzPjZgN0ECHkMP1ZpXpzVpYbW?=
 =?us-ascii?Q?2N4imX/pv7gJFbGCtSHOlC25Zg1hqY9gtroCNIDu7l1CO5KrdbdacLuqA2Xd?=
 =?us-ascii?Q?d2Hj1Xjjw0psvgeC3C8oRSTls2xSNjLaxX/8wRFJp9UjSGcxq3mbYfG/gJXR?=
 =?us-ascii?Q?yiw7vfUyeNq0cKB2/d/viU6QGJ1o8LFnW0o8sux27ApqeXo9bnZlttv3dovx?=
 =?us-ascii?Q?r55ZMpua36Dbz4lY1AjCvr2b/Bnmi3KDVXZsu9K8ndfml7tVMKu9AfHtSan1?=
 =?us-ascii?Q?Da8sgC1IpF9IzfIJ2Jf9fFFnhf0Ri1c3UrDEDzOZs+NSY54z1i9aov14rVBq?=
 =?us-ascii?Q?29d+l9v2gytRThZNhjQvWIOVM1GcoPuO+wvPhx8YcpxVifskVrsZs6Oh5G50?=
 =?us-ascii?Q?0uYrS5xwB7c3xSicV3gPWl2iBz14xknS7tSluhZl/UV5aw5eiWqxTUBbw4Li?=
 =?us-ascii?Q?MzlUdWuCrMSQFUTjiyDZmXeYOyxUr3nvpnwQitxo9MLmHMW/bwALunkSlox1?=
 =?us-ascii?Q?dgNWCAQUzI7YrExP2SzYBFCWZJr0jUEA+nz3WrucH/MKfDjhE3i14SHJ03a2?=
 =?us-ascii?Q?Au6SyKv6RU4SN9gD3s5ukw79LvV1I+DNLemVKHkpFN0ejSmDZ/A6lxLud//q?=
 =?us-ascii?Q?7A+nLGq8TiNTUJnUlx/nFWS/dXqLUjHqnLVe0wpkkl80qJjM65YlRvG/Tlh9?=
 =?us-ascii?Q?hic9p+WyghU5LVL5mwNYTw7hBPjHiXVqoUJor02vKJbjZ9d20nlT8sYqAD2Y?=
 =?us-ascii?Q?9DQiPJA5EruQqRW1ZRTcV82Tcb2cgvWCAub9xZJxi5lvQQftQApSjBWvgE4v?=
 =?us-ascii?Q?OEJJvOncTeWYzBTijZdkmu55Nrc3oo5Q72RwMETI6+rLm27C1EcnKcfM46bN?=
 =?us-ascii?Q?QjFg96XsL3ITt3zr8IzUcF80Zpywc2Hxfrr+QPGZTMCV+jUSjSz+dkmUE6vV?=
 =?us-ascii?Q?BESnOf7vJQamkMzCNvYUgaR6DDjSh3sYGn2Y7JQoSeJsiJGupZeCfrHBP/eu?=
 =?us-ascii?Q?sDzKkD3FsnmjrYrfc4264djiPUEDUZ0pzYhT2N7HI7b778I2UxCXnjTKF7SJ?=
 =?us-ascii?Q?2hRQNTWm3f9l+cLUoHkIFpXLWKiNR7dBbr7oWvLMRA2vzyHOetFAEO2JsCQ2?=
 =?us-ascii?Q?jOLvVgLLYOfvpsbyLuM9+utr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 250bc023-dedd-4881-c6b5-08d914eed902
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 02:37:12.7104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFz0k+lST9vF48oz+J3/M11jMauOk2uIj+uIdC8Hr3AyWqeHBpG905Hg207/pdjX83Ac+BK1ROyP5vtQjgP5ymaFH3FasA41lJfKLBgG6Z0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120018
X-Proofpoint-GUID: j-oglSDhHeDuAOVlbWAEqCSh9P8j9t1q
X-Proofpoint-ORIG-GUID: j-oglSDhHeDuAOVlbWAEqCSh9P8j9t1q
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9981 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120018
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following per-VCPU statistic to KVM debugfs to show if a given
VCPU is running a nested guest:

	nested_guest_running

Also add this as a per-VM statistic to KVM debugfs to show the total number
of VCPUs running a nested guest in a given VM.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/debugfs.c          | 11 +++++++++++
 arch/x86/kvm/kvm_cache_regs.h   |  3 +++
 arch/x86/kvm/x86.c              |  1 +
 4 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cf8557b2b90f..884f6e5ba669 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1173,6 +1173,7 @@ struct kvm_vcpu_stat {
 	u64 nested_runs;
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
+	u64 nested_guest_running;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 7e818d64bb4d..465d243afaac 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -17,6 +17,15 @@ static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
 
+static int vcpu_get_guest_mode(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+	*val = vcpu->stat.nested_guest_running;
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
+	debugfs_create_file("nested_guest_running", 0444, debugfs_dentry, vcpu,
+			    &vcpu_guest_mode_fops);
 	debugfs_create_file("tsc-offset", 0444, debugfs_dentry, vcpu,
 			    &vcpu_tsc_offset_fops);
 
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index cf52cbff18d3..348ef98c6199 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -163,6 +163,7 @@ static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hflags |= HF_GUEST_MASK;
 	++vcpu->stat.nested_runs;
+	vcpu->stat.nested_guest_running = 1;
 }
 
 static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
@@ -173,6 +174,8 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
 		vcpu->arch.load_eoi_exitmap_pending = false;
 		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
 	}
+
+	vcpu->stat.nested_guest_running = 0;
 }
 
 static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d1f51f6c344..01805b68dc9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -246,6 +246,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("nested_runs", nested_runs),
 	VCPU_STAT("directed_yield_attempted", directed_yield_attempted),
 	VCPU_STAT("directed_yield_successful", directed_yield_successful),
+	VCPU_STAT("nested_guest_running", nested_guest_running),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
 	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
-- 
2.27.0

