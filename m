Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7396A2BBA
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 21:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjBYUtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 15:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBYUtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 15:49:08 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB66D53D
        for <kvm@vger.kernel.org>; Sat, 25 Feb 2023 12:49:07 -0800 (PST)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31PJO1Wn017048;
        Sat, 25 Feb 2023 12:48:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=qX3mLvPfEbTiXd8MXXCCVIucbJSUkZK7mCExEfWGeYM=;
 b=wYIE/N+fsFe2EiuKkYt9snF5r2CEzoB5tFTB54xw4YtF2GT3L22ZXzGFAi1dlm6R+3Q9
 pCfX6RYlCp7Wht84HlZdatsSdo2avGyDn+vYz5LCsSkPBI8D3oNJ1p/thXQYFY93bD8V
 /jEPebcXBf+MApvsCzk/zLDnGSDGK9pWw2CDLOq9+IR1illGhnT4nHtSUaj4Z+MICtUC
 qqpwXvzCYkKyqPxYGQMMUf1vZT+qkAwEThiXaadrhqXoaw3kEo8HmTbeYdjWWWC5Xjb2
 vu+TESCjIxJRhGpBVkqQ1WhJdgR3+KjYAYiX9HTAGDYa2bR81O4GZZ8wkBhoLeUF4yK5 AA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3nyjhn0fv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Feb 2023 12:48:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJ8pf8LueoElUIq6RPfATh8HHsmvmBp/bkQafDf0HTr/xQcGaFXu2SnQuP0kchpXOi5ulimn4K2SOPMmKmuVv8iLJv+LGTg9f6rG1H67tUp3ESFyzaJ5vRsYPSjJJy6BbD+Lqpe9QEY0U4TT67skM4+6O4ybv9n/MTHEv1wE+YZS4jiTWwpeSovxhUnB9foXOoBzNzPta0+yN8iOYFgLvHH4CWvWxMBgS+PKZpi5gBG1F4lDT1mkvz4uFHBxKgKD43GSgeAZsodQwdsfc3+F02u3H33h3Ee5L4rtf1uYs8abRnAEiMTrZ6CxbLjKh/Zm0DaItJNLkca96LNn9JLKFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qX3mLvPfEbTiXd8MXXCCVIucbJSUkZK7mCExEfWGeYM=;
 b=joK59SRu6xO2wDhr/JL+n2QkKqXUz2YttTsUmVTwh6eaXHJxMvZ2klXBDrgrS7oZdktLh4Q7p1JVSJiiVzzIW7PBangZQfftbmykrsFHqglcGWd5c4eTeufSbpWsk6IiU2/uu5RBoTqvB0kPMJ9Z5ZpsvC1aaqP04IOKt+1GmAXJip1ejoGZOQOwLoZmLcGQ0RDe1euOb25lSt8MCfapOtUX6NZwItvI4kuikYcK1xAcKQFVtjR9BhuoPq+x1FqATEBdUjHv8lYqBdAzXInd/3bjEarv5leO4FH1VBq9hNsykqwiaCuf1MdY5uK0hjP4e8up26v7XFYapqIhsfQY/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qX3mLvPfEbTiXd8MXXCCVIucbJSUkZK7mCExEfWGeYM=;
 b=dwRZ/+Vl+bJj2uaf3xV3n+lb3VChb3pcdt8YWbb1CKLRS/6lgEKwQdbe85nDg2Cei7KIfyCIsWeXWQXQjK6770rQjU4B37PPkEQcgu6GuwSppnaokQF2QoSdqOwWqf3pNJfy9c59DxNpmRhrGHQ+Uhj/BavT2IJsZaR0pObkAxvlPYNhrWnMdcXNtoJm9lPh5bePz8ZePIPdlIv6uGKkidmhhwrVpdjpISVu6GE2rqzRkNpYU3LiTzdL5FhNr3syftCKcYr9p2VsF7fT1cxk0t66shlh3ejqPeMsKcuAy+gXhVFqiQF0L7nHN+UBgaAaxdCxntM3iElBwv9kiIPnyA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BN0PR02MB8175.namprd02.prod.outlook.com (2603:10b6:408:163::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 20:48:55 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 20:48:54 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        aravind.retnakaran@nutanix.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v8 2/3] KVM: x86: Dirty quota-based throttling of vcpus
Date:   Sat, 25 Feb 2023 20:47:59 +0000
Message-Id: <20230225204758.17726-3-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
References: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BN0PR02MB8175:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b20936d-c35a-4ba0-25c7-08db1771b57e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2n+YT9p0vrS87V2fZ4n63SxS85uhr9hE1GO5kedA6PIsRUlSaPBy9e6oaDtRzt7s28XZ7IFEDZ3Jt7y4rsV4yWVFIQrp0KWZpm5MeHAOV7T+IqE97aZaoe8O4KNlssFyvMB3zdPmaRe1y76u6iatUVRiYLIiV5DVaoZhhlEf/IGbX91ONdaOr+OykIV3AVnaYknGTrvdEB2QLT3EryqU5v331sOA/3He9rnLLofGAIep9VIqiEBcBBZDNkMStQw0sSWfsrjoR9ZpxlkZujkg4UAsMetWUSaPdgLWYrtEtkK3OrGm48jpKZePDlP3b9V/rJONj4Fz15desrMeEgK8pau9Ar55tNGB4vEQHAyNWHM1VdZHHrpq1ZxD9hPnBWSFS3U0ICQG1D1dI3u6FzTY1m/CeAsqWY1oznTrtU9RULNX3miIRdP/GLp1wuYMFbKW1SWM2RDXfCsF9hwhSNx49s/ZtQArkIdCft/ND6Gvg0yKHXAYuHGbkQ4vz3vudFqlv+irF7I2vbtRoPe7PG5ItpLMbuIiSQahBOv6U+mUi+2gC1BqxsMK6SdUkmYj7OCPeAOjckK/pVyd+KU4emecjmOf34RFx81tW8Z0EcUx7f8uDrGxHyO2mIivnC5ZkfwGXTOaS6WA0L5qpbrTrUHNA0kyDP/7iGee1BDQyix/lc1KpMDZtgN3MafXZdNXfHOEC4b/pwltCO3lUK3cHeb2t4DwebA6Bp/s1ZU/PLuBO6Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199018)(36756003)(86362001)(41300700001)(66556008)(66476007)(8676002)(66946007)(4326008)(8936002)(478600001)(6636002)(54906003)(5660300002)(316002)(15650500001)(2906002)(52116002)(83380400001)(38100700002)(38350700002)(6506007)(107886003)(6512007)(186003)(26005)(1076003)(6486002)(2616005)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jfIopU3jvpPcb+E/pnpoqn7916cYHUQrpso7YFD7RrjGhS2o39OCMrKyquIx?=
 =?us-ascii?Q?yoM3YMPiZbv0E3TJbD/8t9zQP+/PbuHHelm6XRiW7VoykSAtnUljwk5EfYjI?=
 =?us-ascii?Q?N3Y+f+sZTnE7D0M7s1B4QJ/GTINfgGqfIIzecdSRpd9YlLevVcHaU62Ih4eL?=
 =?us-ascii?Q?wgbGuIi/Ikm8lyLa1LEzkp0OkLgJub4XSCTG7EPXZz1oIfSKFbVuwcNzRzRr?=
 =?us-ascii?Q?A9kpVYT8M5Vq+imKdRyKdNplnBMDUYTpGfG3TjGtBytKQIiXPypj/T1ju4Jv?=
 =?us-ascii?Q?P3pHv+UfmtOPnQOuPr7tMQD/n7/OVs14XEJ8J+NKQ7cT3unAjL4zanvLr/K2?=
 =?us-ascii?Q?GDSutciJf59j0CdZdnF7f+tnns0CItYYEfs2KUiGb7yzB8Ddq2j8hZ7TiFIX?=
 =?us-ascii?Q?YkSVzHxKvkXS9gcL5I4x6lE7quD/E/g0QfmAFWQsWTCip2dFq9OxZeyf8BIk?=
 =?us-ascii?Q?Y3DF7PZilRGejfmb7H84ghMndaNU/qyA+kC9g6mV3ACAt3ZVFZXem9gdQd34?=
 =?us-ascii?Q?KWcQpkNRZ+GTBjPuQyX7ZdaTd/kJOHpW+zBjTPHK7ePe8bNm5CC3AXgSFY4h?=
 =?us-ascii?Q?VdCqAhWq21uLCJzt3jJlSMqZBFo7JKS/vcH5rDNaSP8NBGvYjPAshS505/H4?=
 =?us-ascii?Q?HAEbp+j4nu/CQqakud4agiCiT1V3rbhMValX1Vv28OfUwY7kxH2OtTMymtHJ?=
 =?us-ascii?Q?IvWloAW8sycyIPFr3a9zX7YdlbaneeDDBhZDKzpocEmHmH2ae2AFLSK/gaqC?=
 =?us-ascii?Q?14c7eBdwZp+Kmtygt6eNu48jspNUFF6QErxXPHhchc/V5V21QWD7G/CsYeok?=
 =?us-ascii?Q?7HIYy5VyORvXoe2BxD1/W3rihK3oCYvZ7WWbobPa0mb+TFpno4eVNvcSrOzv?=
 =?us-ascii?Q?r6gqPL8M9DmDZ8u3UOMDvAvGd8BrT0RVFlsg8gseP20n4wbgLpPaH0aBeIqE?=
 =?us-ascii?Q?dIBzzz6nu7wLg+4gLXhYPbjHxjT3c7THVT7sTRWaUbYrz0MyKUZJmIzV3rfl?=
 =?us-ascii?Q?aRspxEtAOnIqITFanz4edIDQQQDsC9c+95eva1Bk/ouenwT0q26ixcWWjwzA?=
 =?us-ascii?Q?DJTvdYyMxowHZEmsZ9jfq08GzzGtex3MgE/2+MsFn/z1qMVDVFQagZu8xT02?=
 =?us-ascii?Q?marsOUdlWAlqy+/ZvMLhmdI5sHG7eRevBLB3yT0bACj1YGe1t6vkGAs+O1cx?=
 =?us-ascii?Q?7p4t0zKlpWS/s36FaJF51Tq0WShOTL2FutBAPqEAPZpkX+q2V4E5Z0YPC5/9?=
 =?us-ascii?Q?vhFw04EhPaKKjse8Pp2gstZ3hxN5rPWbGlNPmgNon8pqo1Gm9/86QHPyWYxv?=
 =?us-ascii?Q?e9VXHAMIAtBh8QEbYNtEGNbw4CJIFYSp+zYm8eoVdmwsfwxGwAcrLJM+ZmFd?=
 =?us-ascii?Q?yVoKCo3FzVQQ6rHvkrhk4zk39zbxSTjUIdK8cKSp42jC6V3EZzwa5WB2AssO?=
 =?us-ascii?Q?g0UMbXYc0md1lx6grHu5CqmHaPBemsbRrEK9iCIGpYdfr+I/XICEFl3zbFhm?=
 =?us-ascii?Q?PY00d3dxsE1s4IqvOTM7AgUk7qbS8ztfq5uFyIaespwlzgofxOxyNmquMa2/?=
 =?us-ascii?Q?K9mp7ybgarvAGzaAJRoMS72DBc/kj6Gc+CyrOjNO6XUvJ102gGH6X0VnUh8E?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b20936d-c35a-4ba0-25c7-08db1771b57e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 20:48:54.8305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QamD2utSFTe6O9JJ3/Rae6KxV6ULSxN/a8CFNDFXPuaI0y8j0LI+mfXa+itXz4kL6aNp9jKexCXfdC+/coB6OISBwCOmfHLLpobL4Y+DdDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8175
X-Proofpoint-GUID: pI9xQFsESxSoAUitrAL-xCEjFJV17gi1
X-Proofpoint-ORIG-GUID: pI9xQFsESxSoAUitrAL-xCEjFJV17gi1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-25_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call update_dirty_quota whenever a page is marked dirty with
appropriate arch-specific page size. Process the KVM request
KVM_REQ_DIRTY_QUOTA_EXIT (raised by update_dirty_quota) to exit to
userspace with exit reason KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/x86/kvm/Kconfig       |  1 +
 arch/x86/kvm/mmu/mmu.c     |  8 +++++++-
 arch/x86/kvm/mmu/spte.c    |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c |  3 +++
 arch/x86/kvm/vmx/vmx.c     |  5 +++++
 arch/x86/kvm/x86.c         | 16 ++++++++++++++++
 arch/x86/kvm/xen.c         | 12 +++++++++++-
 7 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8e578311ca9d..8621a9512572 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -48,6 +48,7 @@ config KVM
 	select KVM_VFIO
 	select SRCU
 	select INTERVAL_TREE
+	select HAVE_KVM_DIRTY_QUOTA
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	help
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c8ebe542c565..e0c8348ecdf1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3323,8 +3323,14 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (!try_cmpxchg64(sptep, &old_spte, new_spte))
 		return false;
 
-	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
+	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+
+		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(sp->role.level)));
+#endif
 		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);
+	}
 
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c15bfca3ed15..15f4f1d97ce9 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -243,6 +243,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
 		WARN_ON(level > PG_LEVEL_4K);
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(level)));
+#endif
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c25dbf32ecc..4bf98e96343d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -358,6 +358,9 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	if ((!is_writable_pte(old_spte) || pfn_changed) &&
 	    is_writable_pte(new_spte)) {
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+		update_dirty_quota(kvm, (1L << SPTE_LEVEL_SHIFT(level)));
+#endif
 		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
 		mark_page_dirty_in_slot(kvm, slot, gfn);
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcac3efcde41..da4c6342a647 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5861,6 +5861,11 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		 */
 		if (__xfer_to_guest_mode_work_pending())
 			return 1;
+
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
+			return 1;
+#endif
 	}
 
 	return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7713420abab0..1733be829197 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3092,6 +3092,9 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 
 	guest_hv_clock->version = ++vcpu->hv_clock.version;
 
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(v->kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 	read_unlock_irqrestore(&gpc->lock, flags);
 
@@ -3566,6 +3569,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
  out:
 	user_access_end();
  dirty:
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(vcpu->kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
@@ -4815,6 +4821,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
 		vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(vcpu->kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
@@ -10514,6 +10523,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+			r = 0;
+			goto out;
+		}
+#endif
 
 		/*
 		 * KVM_REQ_HV_STIMER has to be processed after
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 40edf4d1974c..00a3ac438539 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -435,9 +435,16 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 
 	read_unlock_irqrestore(&gpc1->lock, flags);
 
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(v->kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
-	if (user_len2)
+	if (user_len2) {
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+		update_dirty_quota(v->kvm, PAGE_SIZE);
+#endif
 		mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
+	}
 }
 
 void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
@@ -549,6 +556,9 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	if (v->arch.xen.upcall_vector)
 		kvm_xen_inject_vcpu_vector(v);
 
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(v->kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 }
 
-- 
2.22.3

