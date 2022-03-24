Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CF84E5C75
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 01:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346914AbiCXAyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 20:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346883AbiCXAyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 20:54:54 -0400
X-Greylist: delayed 428 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Mar 2022 17:53:24 PDT
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D4E38A0;
        Wed, 23 Mar 2022 17:53:24 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22NI3M77032434;
        Wed, 23 Mar 2022 17:45:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=xvw8oFGXK2FX+zdktznVnyYyeB2EtcWItboE2A/aqQs=;
 b=xgox/49gDpaU0en5Q90gjikwiI4dye5c5VszljT0oZIL1F+hSjSTP+f6BB4b1/ImpP06
 ra/MFVB2n85yNXdfJG/EpPi2M8kBeFsH5Ve9+uc0bokcV90jSsESRQkEyHh3cFb5z8Jj
 pocudMX+ySrg6Z+c1I6LJHmry6XTE0oV3Be/5puPF3nuQzTXkYkBqXi6b4l3ZpDfhSME
 z9Jse3kfkZMuOuYyaEiSMxpc0qiGt3ewhWzI/WjAMPxTviMaqIgkcfTi527sDg77MkIg
 T8EHKBJmCLNBOhdy8KpYs6Vj58SVs7ppLx2sC+un6D54Qn2TN4UGBqZ0vfB7UeCKOJEB 6Q== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3ewd9h23ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:45:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUENNJd7RisfdsIUZV7S5/IvamOw73vzT3gnuKdeob68h7LVa1kcHj6M108UCGwtnhAondeUrn/sgGi4BxSfD2LgFlcfRTuUdmgkBYPelWtUN1mgfjdHzdCQZv1acoZrq2dbDQ6XOTGWJV4GU7poXDyonl7yUhwQeXoQR0ld4COj5VCbvbsglVzgC0AgW4i/03N8Ex0a3dEdjt823Za7qkwhw2EAqSVKyaBmEIbQJvpENMHIDg2onO3PydWKulnYpFaLX47fUAPMxW2g3aZ7S5kIJXd2psn+rV7YXldBXI0JaGBYsnvNmh2bIqUfpPKHV9i7vxO1tzmx+PPTPBvTIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xvw8oFGXK2FX+zdktznVnyYyeB2EtcWItboE2A/aqQs=;
 b=cjGmZdnzK8uALN8YJhhZ8iIbDNouVl6AzJHCxzf7YdX4d0sPFABBvW2ncLb2SM2gcWfhk8SuRny2lsOkIFheG5m3iG8dUmp1VRC4pHgR2YjfCw0AhQS6Sk8uoQZXKsfzLIBUkCZgLCauZAg1JTdA6A+w8gIDX9KWzv8gaNtnLAeCEzKdOabSTsbMeQhwS8fNQ0e0p9GQ6i7o7pVpxlCMsPS05BSQq0NCjJaIJYNlpftnDm2MjAvqnJA0mfqcM6PL0yZ5S65o0HbWZBIYu+PeT4FTsNxhMycx2UalffMkcpWftGUE/g7sZIUH6E00nB4JYqSFu0NroEdFAN7IfNQCxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CH2PR02MB6328.namprd02.prod.outlook.com (2603:10b6:610:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Thu, 24 Mar
 2022 00:45:06 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5081.023; Thu, 24 Mar 2022
 00:45:06 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jon Kohler <jon@nutanix.com>
Subject: [PATCH] KVM: x86: optimize PKU branching in kvm_load_{guest|host}_xsave_state
Date:   Wed, 23 Mar 2022 20:44:39 -0400
Message-Id: <20220324004439.6709-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::8) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93fb9380-cde2-441a-4c2b-08da0d2f8a3e
X-MS-TrafficTypeDiagnostic: CH2PR02MB6328:EE_
X-Microsoft-Antispam-PRVS: <CH2PR02MB6328A7F01ECB8E9E3E52B3AEAF199@CH2PR02MB6328.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Iz+bIYrfizXQAZmbqiTTNLze8FcsD59l0uFduiXCxeK3aT/HHGqt6QFr70ueKw3+ANbFbQfsNHi7sFfZLxE8v6kBJ6fcilm+CP9undf+mJCArruhCbGCP8EcU1iArK2PqO51Ytj1mnQQcsFkHQUJJoOgWH5qf0SKcdggDG+A8w2Yo0J6GsVW53ZlAUwnP4sBrDxRE26z98FnChFWJFpLxDSMjJ78VN6bJnCYBreOMrcuNZGGt0PWgC0+lW2gyN1NUO8wXu4y0uUK1EpK3zuohmG6pSKt+z1WWO0YTlZxdg4XZUaDItJ26AwJm8rrSMdfdshpdTUHXIE71LerrSoIqdbJjt0StNCB61sRSRxkEN4kZCcn+HYzxO88ZQtueqkMLRJiFBeA3w1XP9Ur54psS4uE9FNkEezndUEt3vf+l1KSq3H0nEuqTqBYBPgsbTFt7iPB2SP3+T6VNu5KXvS6DHXstRWPIbP7bLP/B40Zblysj3V6YaiDvgJCfdVaeHe0rDAqExqO8GGx28aqr0ZhuglefDvF2wHrr22GLQ5joJELnRFtn21KSHHPqldgUiBMDYow93xtJleR6/RujpHuvP3pffqBdfARhXnFBIOAlTmxEB7YQ6Rio0/NxkAT7CpSEayZ6+HqfnhxgU0UgZSsIMrjsf7ddUihLZ+DFHWEC/Gb+qInBtT3lASUy5UjHTK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6512007)(52116002)(2906002)(921005)(8936002)(6666004)(5660300002)(7416002)(508600001)(83380400001)(86362001)(186003)(107886003)(1076003)(2616005)(6486002)(66946007)(36756003)(8676002)(66476007)(110136005)(38100700002)(66556008)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V649NF+yUK2SBtBegy5a9gJTaad9JYeqQG1ni12eGfa/b7j9TE2QooORi5KX?=
 =?us-ascii?Q?IEW1CKPaUukIwUl4YQMgzbHglOk/Yn1oGjY7/7CCDaayJL1UMsyB7UMIkfZ5?=
 =?us-ascii?Q?vd+RjubCX1uOECXrvVd1OpBe+Y5sP+YaWDoeOny08mYSiio11dQQXClQVidm?=
 =?us-ascii?Q?j8lY6p7Rc9tHsQ3rvIESF2+f/t63twB9CchADL+lYfV+o7Llkpbduvyo/r+E?=
 =?us-ascii?Q?3qqUJughKD5drq42t69pB448BugJimDoV0lznibI5aIHV4Wft6oF2gn21VPs?=
 =?us-ascii?Q?iTBJPlTY/j1kEGciavDE6XDR/9ZeSDV7QMQFTnxUfiX1hhU8JY4oda+crWyy?=
 =?us-ascii?Q?w5CGAXuoyysecMjvBQRBUEnNaSblRJaZU1dwInBiCV52Ru2RHsKJaGynrduw?=
 =?us-ascii?Q?ExVIB8ExCjCFrcUF0VVt0vS2yext/V1b+D4shDT9ZYyqeuReRQ28A6L6I25S?=
 =?us-ascii?Q?oUQQMhVL9QlnShzuTMNFThxpSrfgGdcPlENmpmp8SQhPHfyIgxuzH1dpZgNT?=
 =?us-ascii?Q?A3GRsyFtjTz4hOLNpSuvU0JoBmPnTK4CaPGwuEIwNISC9apnW6YpgQzc97t0?=
 =?us-ascii?Q?j+6qAI4s60QlrmW4u4aQUL9MXxkD7cLF5vr1ym77mVm8lbP8Cxt1+8XH/bmA?=
 =?us-ascii?Q?0wkAsMBP/nf0Gvhqti0gh/R7d7/zb+Jv+wuMou0kQ2dVBZOpPaTWxI2WDYro?=
 =?us-ascii?Q?KzgWxBF7lPqEpGK636Lh+Mxb4lrXkD4Nva21vJJYFQ3dn/PNAxxmbDZSGIav?=
 =?us-ascii?Q?ZwF7kCXJoqt+y/kiRlPaXbMGlXYYY7TrGN2CkEM511vBeZf+Wjg1/OEQNKSo?=
 =?us-ascii?Q?y3ejFfLc7rmQNuvtj/OQRHzh8h3lBeGGy9qJWI4kYTSWEYhcsy8+RiO9hgff?=
 =?us-ascii?Q?vQcLTx4Vtde4JiH1k1LIHZPOobbZXiOgaIFSiv9iDKEezUBuOXUhfOR002fT?=
 =?us-ascii?Q?vLyJXQPPgWGGvzSMEqVCxgqcrJwojmnbEPJvST9UbRSg+LIfMgjZ7UPt3Nyn?=
 =?us-ascii?Q?xFIiBpYnWDwh5T0UKks54qCcNeSsPblIaFQuJHPtuoYrmx5wAMcCuG5WXRps?=
 =?us-ascii?Q?WNGQtSZa0MIPKK0B47jG0jwxbFrSoTK0QnZmMOrHFuIsM9rkBgV45ENgzwri?=
 =?us-ascii?Q?yI/olP9JZlbP/LGRfrDc7QqUJ9n8G7+6lYBODMBczGNinOMTa1A9MiuCEzQU?=
 =?us-ascii?Q?7jOSrLszm08cbkef+a/Tde1952p+1UvDJRLG4rOU4qyXhSWm78m1xwiE76c0?=
 =?us-ascii?Q?7LQ8EVethlRwXldS+CucG4ZNWGvDqwqm9O6aNkezWtaOQwNd4htt4HvR1Qb6?=
 =?us-ascii?Q?JMiYeNkak2dVdvIbZGDFC/6nr897ZjmUPKIZGyi3YzbQZeifaAq0Q4HPoGdX?=
 =?us-ascii?Q?ip1rIQm9P06Ft7PVlDlFssmFhn0WLG6eArFsEAMNXqIIFqp2KPyhVjJwIuOp?=
 =?us-ascii?Q?8AW4CC1VK3SN2KtMffmS10oxAl9RXOnK15BDHr/5P6B7OYUtXaE8aFDrU0YE?=
 =?us-ascii?Q?KodU+pmXylCZ6c1Z+GYe/YXJTcsggYS64xs7ryJXVpTXScpSkiQI2BPy04CQ?=
 =?us-ascii?Q?9vCayO6uxv9OqbL1lS4=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93fb9380-cde2-441a-4c2b-08da0d2f8a3e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 00:45:06.2965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwISqhz+SrBy2dlrcPJEQV61V9YLGDUug+tVLc/zy3T5emPhvea8aak5j+E4ShXkS2usVzl2Cgv0N/8yakcHQoKn68z1qnZ/96kZ4Vaoe3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6328
X-Proofpoint-ORIG-GUID: lab09Vizh82JyJ5PXnkFBUIjmp9yCZoi
X-Proofpoint-GUID: lab09Vizh82JyJ5PXnkFBUIjmp9yCZoi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_08,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_load_{guest|host}_xsave_state handles xsave on vm entry and exit,
part of which is managing memory protection key state. The latest
arch.pkru is updated with a rdpkru, and if that doesn't match the base
host_pkru (which about 70% of the time), we issue a __write_pkru.

To improve performance, implement the following optimizations:
 1. Reorder if conditions prior to wrpkru in both
    kvm_load_{guest|host}_xsave_state.

    Flip the ordering of the || condition so that XFEATURE_MASK_PKRU is
    checked first, which when instrumented in our environment appeared
    to be always true and less overall work than kvm_read_cr4_bits.

    For kvm_load_guest_xsave_state, hoist arch.pkru != host_pkru ahead
    one position. When instrumented, I saw this be true roughly ~70% of
    the time vs the other conditions which were almost always true.
    With this change, we will avoid 3rd condition check ~30% of the time.

 2. Wrap PKU sections with CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS,
    as if the user compiles out this feature, we should not have
    these branches at all.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/x86.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6db3a506b402..2b00123a5d50 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -950,11 +950,13 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
 	}

+#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
 	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
-	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
-	    vcpu->arch.pkru != vcpu->arch.host_pkru)
+	    vcpu->arch.pkru != vcpu->arch.host_pkru &&
+	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
+	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE)))
 		write_pkru(vcpu->arch.pkru);
+#endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);

@@ -963,13 +965,15 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_state_protected)
 		return;

+#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
 	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
-	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
+	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
+	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE))) {
 		vcpu->arch.pkru = rdpkru();
 		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
 			write_pkru(vcpu->arch.host_pkru);
 	}
+#endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */

 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {

--
2.30.1 (Apple Git-130)

