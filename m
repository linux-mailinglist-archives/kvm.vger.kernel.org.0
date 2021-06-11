Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2593A49A5
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 21:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhFKTyu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 15:54:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhFKTyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 15:54:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BJi2wr089873;
        Fri, 11 Jun 2021 19:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=rNwt9UOOm0/cE5NjYsCNNcoaSz4DNRBm+k1CVihfWZY=;
 b=ZQL6J7D2XoDn3pWFRFuGs9N77ubdQZn2AABeYcLp7AT1AalDc5ntQutGqZyLcowtJiO7
 tciysrywD29zPZNGv73yUNh+aUyj7YmmdpdkNSd62b+hBuyZq0ohZAtuYqxAKQ32Miro
 uxc1t3+ou1JDbgyBIO2PbyP8H4ePUIQysHJcRUMh//4VoDu1NkNz+19O/9fkhnnALPUI
 bggxeIcGSFoLfl1snIiZxRr4/5hcgzmL0MZwj/wSrlIE32almR7yHVFR1QyLbCmuRNa9
 YuxAAU1+9YPPVg/FieFwJGE8CA1C+1LQciCRRNuv32YKH8PN2yQY8HVhJbB71K3Mkak2 jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 39017nqjd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 19:51:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BJomsR048061;
        Fri, 11 Jun 2021 19:51:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 3922x3ecgr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 19:51:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9WwbCOpoSmI/Tg2dBOJUYRbtKlawWBk71ICD8H+wLSBIvubQSLGa3JriRYi327ECzGGea8yADGc+gZ2BWood8/jBZYWWX3C75yP8jN9CU+3T+qk8ROWcDAyvgOnd15yoTX18jDhVo8CrwtjaihNjWr8bvWFQOmOdR5GYkpahuEuqwniDu8lc6bXocmXs38tRT+oQ5cDAWKRzW9xNfUjQwBeUs0gVUo3SpTrBVtbUUyDqFF7XOorgZuQdQUMN/bNoajVf9N4l7NgVppta3NVr4ErBV7AyVVrQiExPv5TUVEQsPnZej7EOIA8kix4rs2PlDKQNE+nrAWBUogx7Ecg2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNwt9UOOm0/cE5NjYsCNNcoaSz4DNRBm+k1CVihfWZY=;
 b=Y8UvbgiRONW6oKpqYyfo9glbiYhGLKavvAb+VdbndLntOt9i8vls8uolHYEgRj03501DWJlet8pLixLtC7H8dr5QbmmzLTK8Z1/q+hHQpY8qTKUIsF1tKKMZxEb0Ji6pWpmKABv+uHMz6vVab6AhMnNaH67ufjcCeSI7H3Ri5l1IgpAH5FXWdZopoRb54SnDtHC08R96N5exK3Tw+9bLiLU1uGcDpduienhLECp0I5ScuMgkJcXBP1v3yWQIbxtLaJ7qPZcmDvojeD9endUC8sUT3TYGTn5GbdSJemV9C3B2pNcD4nNve17i/d1A+zMxfZRkAJ/NZIeXoEIPM3+XCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNwt9UOOm0/cE5NjYsCNNcoaSz4DNRBm+k1CVihfWZY=;
 b=C02ujOvEU6Zpn9pNFawMVdl6QQyYK9whgI0Pykc9jnhEAe23TaPiWWf77zMl/IOb8cAKkxJ7Ll5zqkbuwY8UTP2XK+0wLV7I0NZBOvjxeMDpJLGgUK4bNKJQP0US/9t6qnZvU0TnbE0HWU0l1tV9XLB8mF57OnxjTeKvJgT2b8Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2944.namprd10.prod.outlook.com (2603:10b6:805:ce::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Fri, 11 Jun
 2021 19:51:20 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 19:51:20 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 2/3 v5] KVM: nVMX: nSVM: Add a new VCPU statistic to show if VCPU is in guest mode
Date:   Fri, 11 Jun 2021 15:01:48 -0400
Message-Id: <20210611190149.107601-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210611190149.107601-1-krish.sadhukhan@oracle.com>
References: <20210611190149.107601-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SN4PR0201CA0040.namprd02.prod.outlook.com
 (2603:10b6:803:2e::26) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN4PR0201CA0040.namprd02.prod.outlook.com (2603:10b6:803:2e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 19:51:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48aea4da-e099-4255-c419-08d92d1248ac
X-MS-TrafficTypeDiagnostic: SN6PR10MB2944:
X-Microsoft-Antispam-PRVS: <SN6PR10MB29444AB98067A52D5AB70BB581349@SN6PR10MB2944.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KDBjbM/J1TyxQPWpqeG/HbKZyNuwVSHcj4AdLfuW79cq45qf1jonzfXBvwlkb5C7L4ZXRqSQytEkWCCNd8dxCXUzOZst6ZivFevyONkG34dlS+V8UOfo8DeYhoOH7LYFXXh3hw2o72Dx5Ihg4/uU9U5NLzJScfdrFaqmFeuQdCqzqkVw0iOnSZcmg80+oOtkhb17r1XXrzHPrSnM3cKWri+W6rjxD2Rujq5aD5TEvttv/CEswOr2yG69dXhcayAIPMwG8Z4kmTR7wCQ3f2PMd2iK34nplE0IHDWqfWKaHOFMtsqlTXUX+VjUQ84YSyWL0MtXkYsT6/FUkR5KRNJBKdahgIPOYOeAFCdchKrvfmqxuYEVaXNPiYNAW/oQPi4j4Zb6v7HzdIMe+Z22/vtQ1lstssLrso9GT6DPO4dxRK91VD5i1Wwoe6ci2uCsbVyn6RdqHb2z9rpAq1RDhcG2mXw+t3pyEWjbNFc+CoWph6sB/jy37rnmk05FFLiLSOlq+AWGsNpVDZIuNJxCc8TIigPgEZWaiIyJmctjnmFh/U8XSm7tt4lmgEvQBRFG3oeD3inA4zeoWhvZi4bTNpVaqJW9M9IeLXOOOTAZLMc3eq97H1ejK36t4AwIi9x2kiFr0FnT3Qf4InUHJ/AEVIzq9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(366004)(396003)(316002)(2616005)(956004)(44832011)(66946007)(66476007)(478600001)(66556008)(86362001)(26005)(5660300002)(4326008)(186003)(38350700002)(38100700002)(16526019)(1076003)(6666004)(52116002)(36756003)(8936002)(7696005)(6486002)(8676002)(83380400001)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?01o2Af5cucwlip+a87SmYZI7j4z2k3fp/9nHZwDtSNXH+yH1h5zmsMAw2EJE?=
 =?us-ascii?Q?WcxCVqAbD7x8gKhxC6k9arHw5O+6uo6Z1AH9pJk05Ce2gMxU/GNRVnaN93Sv?=
 =?us-ascii?Q?djTWA64WHUZmi2TDTe9vKgZyIzNmxK3B0zuIUR6H5XMN4o1sKV1j+v8ln1ly?=
 =?us-ascii?Q?yLuSAbZ1Wz7G6ziV1R8cfwH7i0foFznUlPpy5T9lAQtYUUVmorc9wxyFiV5a?=
 =?us-ascii?Q?BxXuNeL7ztQRjdYdCsmWTm3K4pNIF+ItBn3pyh8eaVa5RUGEpRug8X7O2oid?=
 =?us-ascii?Q?5KmRlhXaVR/BNQo44SmoZ60NO82GzpJjXIWXQu50/V75BGMWgaOxGjxIaz+Q?=
 =?us-ascii?Q?yTzbl++B6Epra6qjzS/FydwgTjB66FSbHtznlanUxUeMygf4N8OFbDdSEsJl?=
 =?us-ascii?Q?Okqct3mbZ0nrqfcNv9SZX+9zW0jTRqDQVqT6tUaHFduoVos6nYNgJTdZS4b/?=
 =?us-ascii?Q?P/ZpZLi9nN2NpGJ4MJIeJPaCpSANsNR6HKTVMW4twwZBdN1ac8hyIHzOJ8jf?=
 =?us-ascii?Q?o4xKE9Co2qoa5IQE+ty9wT/QBFjy/jgjLoUHZAAxuwxkOcTQqNkvO/hCA8jg?=
 =?us-ascii?Q?VBabkkhDd6mlciGEuf6WrdCW5veIHItfsBWD2Y+bWtCGq7xGUsDyts4lInZH?=
 =?us-ascii?Q?jK1PPSh8chb1csxlvQ6hQTFrLrirN9rw6Ww1HVwror2WmHi9/jxyoQd2HKl7?=
 =?us-ascii?Q?a4YaPjW55y2z4dJB4AXPXP1K8kKZ6LVXIdiyR62lrA8dXVbEygS9b8zWxdNv?=
 =?us-ascii?Q?KFR3yBX7sWoyoKGDdJiy+pjO4nRupfR+ZVhNmsONQxqx4M+/fXiI69p1BynE?=
 =?us-ascii?Q?1M+aWeJUKA5gaxNUmvCis6GTDzg0d7ogxfjPxTx7rbc/v2g0jAtMWXKmuCNv?=
 =?us-ascii?Q?ScEf5AAtxpUVnL5ywtobp8GMnrvf12xuhsKTFjW6SY20637eQCf95loaYbQA?=
 =?us-ascii?Q?agjas3TuEVgJkQu9VtgLYMMMmjh0Qy+6VyH+iHLvHDSR19zrnwU8WNJmDYan?=
 =?us-ascii?Q?YcdjrLY8bpefV5C0wU1TuDET0Kxi4xxRFjjc6YVTTIliBVGC9So4ZI8M5FhG?=
 =?us-ascii?Q?FHzTC+IGWIWWBfey92eIKoaaGzW+Hph3n2LhKqWZHkrKT4JAzlEqB+QMi8qx?=
 =?us-ascii?Q?C1Tk7WQ7F4dsjdn80fscd1GhV/+6leGuQEGfF29J/zzgQRUNaj/hNH/jxaiZ?=
 =?us-ascii?Q?Osv9hv6Ys21NYXq2h1Hix4fm+uJyJReXrvau0x5IycIMlwK459nnKsPdrUq8?=
 =?us-ascii?Q?ALwTVChRfCvhJL73re8Zh6lzsN84+/odN7ZSUWucsf46Z5l3Io7RDMDgYtZI?=
 =?us-ascii?Q?I98FYg4edfhWIoW5JTDhtvS/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48aea4da-e099-4255-c419-08d92d1248ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 19:51:20.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fjbi5kd4qAdTwSVKo4J88FxwC7MB6IqYszRt3tud8lCJ46RtT9jQpm2BtWND9F5c+mYqAswnIQfVZJF/x+GhFzB7AVP2uJK5HN9/9ow+aww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2944
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110126
X-Proofpoint-GUID: nZSZ1LtfdzbZa72gZ2jcLzRAGjB1yCsY
X-Proofpoint-ORIG-GUID: nZSZ1LtfdzbZa72gZ2jcLzRAGjB1yCsY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110125
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

