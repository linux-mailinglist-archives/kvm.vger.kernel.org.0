Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35E135206A
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 22:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhDAUJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 16:09:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33416 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbhDAUJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 16:09:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K95lo079517;
        Thu, 1 Apr 2021 20:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=g/bAPbCMF/Z4Lz2SNWKdtbXw24CP9UYeQVRph0uJqGM=;
 b=SJDSipNUKlGf7+RdY9PXvTCuMm75HSlku9meg9qs67sjc7AyuAuFuW4jZq2OIiZ+A/o7
 SGGVclrAhXcFhRLRVI5JagY8KeRCPk8uwL5YPo15w6EK5NDWakyjBkjpDbKTs3phh1MU
 ERTHKtpBe/vmL4feP/YxtxhrJ16H2ZYFK4dn7phUj8qS8L6rOxnBRe+rAV+2QCAXkAsM
 NrhscL2OmCF/D9VpPa0Q0mTpe3qttbCXPwlfK1QCtPPRDMRp55ZMGVLydwL0chBNDBdc
 C/8sxBAEibmyZY0AbL3GdMVUyS6xZW3qMPf7VMhdniuTI7rge6KLn4rtm8/dqIyCLC76 xQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37n33du0ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K0x0e178319;
        Thu, 1 Apr 2021 20:09:27 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2059.outbound.protection.outlook.com [104.47.45.59])
        by aserp3020.oracle.com with ESMTP id 37n2abq9vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldLGKjiBKEO++UmFsglsYpcbHwtKDDvspowT6gxmI0WX2d7x3yBS7zEl+my0cp/5IbyTGdO9xD2xPBrqF/mswG0eStiWSbRSUOF9h3m0UH4wAaDAS+27XWum86Z3BwVop8IxBtxZcbS7yr7lEXBqQ3Us52iMhe3X9gyuUNoFx29BxRpyqKZkckY9/QjW4SGG/HjQnomRGzracI1+sk5NPE8IVIWikGAyDYhPk86zR7Ostzjnw0ME5bqXYgpm5l5KFjqEA2MR/c624y1c6vC++t61E6RAmPXWyADHv8NbNTpN1uw8e1U2rl7cv5YcrpG5qV8vVj9lbA4sCRmUSxFynQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/bAPbCMF/Z4Lz2SNWKdtbXw24CP9UYeQVRph0uJqGM=;
 b=QUjMeYZmGWkY/B5sVUctmWGUwdFYAlMFqPXKfp8rsNOeeGUgwAMM+7NjnLK4eni8fS9odNb7NkJuMt8D82trsJfoRa+65OatVUtJ5QGeu/YpGjKXMZ9wNL6UWlpkPLxotARNX9E65our1S/UsoEQMByFAr5zfFdHnBhuoOizNahxW5M0ngBwtdUkC1bmGVMH2I8SbsdYhjHA8PvEXkcwO7TqCn8/GJT9tqUXQn2l1gX5jzegsnZNJzMNIG2oye4TMi2Q/LuM2Hvps1AXIMR/9LXqPQGEcAFlISktyT1N/5LwZvXdLq3QqXoQ0R/meSZc5AXAQ4VdhKNmeEX6JU6v9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/bAPbCMF/Z4Lz2SNWKdtbXw24CP9UYeQVRph0uJqGM=;
 b=qkgIu6GMEyGLUTmY8H5wHao1cP9SipsPPc+lcwu2mCf9ToO2d2IPQM89ajioDG86/YNY+yqF0g43N6n8zMrkKibAlxrjBQcZ4hSTonpyr9Y9ZT9+C+j1h+SvBvvBAYOqe1bV2sYkMY7JC+dvVTfeEtfkb2H2l64XgnKbwoaxq5E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM5PR1001MB2091.namprd10.prod.outlook.com (2603:10b6:4:2c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.33; Thu, 1 Apr 2021 20:09:25 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b%3]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 20:09:25 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 4/5 v5] nSVM: Test addresses of MSR and IO permissions maps
Date:   Thu,  1 Apr 2021 15:20:32 -0400
Message-Id: <20210401192033.91150-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
References: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:a03:114::25) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR21CA0015.namprd21.prod.outlook.com (2603:10b6:a03:114::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.0 via Frontend Transport; Thu, 1 Apr 2021 20:09:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e42f08f-86c6-4494-75e0-08d8f54a0c4b
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2091:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB209101E03C9DB7A0EEA8736A817B9@DM5PR1001MB2091.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0C3NKWHZ+MtypumBZahyslwrsI+uxWG0Mai92eJEdgQ1lCoRo7BAr3/hqv8JnVkW87A/FJAGWwAOTffjlAeTIbnR4QtFwCTtF7ESveCGfX1uFQYMfDSzXccHbgnw6QFUzDSqL7VWQQ9kMYJdJQXZOjXYe/j6EvusGH8pavPlQytnEcRIvq91NiLf29a1ne5S/vUEqUqJTleNkiBCot9ZQxmQ4gGm4TTw1wL03+WqrEun2inSCt/C7DLuTQVwVX3Actx5JGFHJDW6xk3Em3AaTQVSonBF5YUc4LGey5jLLC4IVYpJuBkxNCsaGOR2vkDBIqa0UhjXm8Xm7re9w6vFuf/+LlcHtsxfZhVO38Wo833SfZzj5sl5yc6vaWiHiE90b4eIY4mRNbk9ab10mJhUhSaZyu3DPA/Ln9/8kf2+s4SG7awb7sSR1PowQP14/bxRmaADXzR+9TJfx3ilFWthix2RxpQDJemDMj9AsWaZrgrQnm4VLms3Y0VBnfa3p6d962z1nMKf1AyOJyj5IXdCygshRQQBAKaoEWnD0z5jaY6pBAMhYbegMGsjRQsojyb5i808UdcRvQ9plkHI/zO6BSsGcSbAVnCEW0Q+UQNL004euoH9FTt+aFGwsCuVslGfCLQnBuKAXtvpEarAJQNhsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(66476007)(86362001)(2616005)(66946007)(4326008)(2906002)(186003)(6486002)(6666004)(36756003)(316002)(38100700001)(8936002)(7696005)(478600001)(5660300002)(8676002)(16526019)(66556008)(83380400001)(6916009)(44832011)(956004)(26005)(1076003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gEMVh+P+H5mljHovVhBVgq392zJ+96jiJBQ5JYS9E2JitT63VvbM2CIxwdEn?=
 =?us-ascii?Q?oX8QUHNX6M9IWLtdHkYNQMHp02apELYtv1O/1nVLPkgsfnRnmvkTnRZ9r7JF?=
 =?us-ascii?Q?62AubESSTefoVUjbRbCk1k6JCwCEuWOoCKfQuVC/Nbc9ZzjwVepOMSzuLryL?=
 =?us-ascii?Q?NpEQ3NkD9Rv6eR9xLd/gmzuu+CfjtOaMnYOsmiI1YwfUogO9Xg5UW2hIjFaJ?=
 =?us-ascii?Q?dixxkXWi59qxq5iZfGHncHh8/c/cBpqevMMRp/V/YFGN5aHiWi4fdAx52CSl?=
 =?us-ascii?Q?iZQI8UlOyFkpunh93T8kUXbdNb3+7YAOJZEpwsrYmTn3MEsB/A4TrHfxVcx1?=
 =?us-ascii?Q?yG7h6q1GQFGd6RL3NVbVyJkib2eW9bNu1HM7CmlKPD4x7BS4v7UYLYPojgA6?=
 =?us-ascii?Q?Gt3q4cFx611Nnfavb1tkwd6mAvoqNgOViQfbg7gAq36GIPL8vCWlcFJEWZKc?=
 =?us-ascii?Q?4xS6lqz7262IFCXw4ln4A48BAyTNx1HkmX826gpd+ZbxX5qiMWKHpm27iA1V?=
 =?us-ascii?Q?CuKapX0uAN/qBwT/WOaN/GnkNBAEw1greDyDg8Q0Yjp9i2FMbIgPIkeH5pjc?=
 =?us-ascii?Q?ShtwUGO8z9RsEOQhfhaiPhAdPDUW39cNnZhPr+zQgLjOutIqaNug2UKD7ChK?=
 =?us-ascii?Q?dKk0HO3xJrhQkQKBxPBkffATbElPlUDpEWiBF+Vmo3Jhl0ssG8gTuATtwbs0?=
 =?us-ascii?Q?eoHnmfcvfqHkdXEWK3AdFzdEEanKPzIQVdv+rQDkFkXwNNAA9Xmfje1Gq0GP?=
 =?us-ascii?Q?TsDj3zdUAbdGPu2wScRcLU/cWrJs1c6iYcDAKYGJ/y8qpyTOnRnoE7G/eXwR?=
 =?us-ascii?Q?gS2Nu9yUQh2loav8ozuaoDpxXs2aYvxMnU1dkYSVbDCgGuFjBr6BSkdbBF/t?=
 =?us-ascii?Q?HECbtmGD03M9ZcFXIHeE31LJ6ABqQDxICMVoEBsoM4QpqNcW0Y2InIhZz5vb?=
 =?us-ascii?Q?60teXqvzh3N/S2S68y82agyTPCSxAGytsjdu7n8FqZMs4KA22X7oWBsz+ZWx?=
 =?us-ascii?Q?81KTBbIvdEKKBH4EHtuwpgM7RY/473N2eNwAjSQdfze+KLR6Wp0hLpM8ExTO?=
 =?us-ascii?Q?ThCa9OQ6Lf+xMue6XStUuQARsnk05eYFoope6dTnf2V48GVl55cYw3geRYna?=
 =?us-ascii?Q?oQ+SH3qCUgA8WvZc7ECzfhJz2+3lH0arZVetLwB1mhKVBy9XIoi57LdFi4lh?=
 =?us-ascii?Q?2JBhyXBLYWIsi2lNt/Uyyy1KrvDDuyMQfwYAj1nWlMOd9/+jear6Fs/qNWCO?=
 =?us-ascii?Q?cfv0/wyHZT009kxG/mFJ9BrorWY44ZdPP/wb239aJ+pDQRx3pcYrRkDyBuPp?=
 =?us-ascii?Q?rwKNKAIPhRx4MtmQ5dq+A2v6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e42f08f-86c6-4494-75e0-08d8f54a0c4b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 20:09:25.7960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mA3WX0mkpDxFKMeQCBXVj/pmUQOK31ECznisPSCdT6NmX0D2LzFqj8ORBQwbFtX3yeY33rWX9Q5urtepxPF7X9EeNdhY6q9+yIBbCsOJsjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010128
X-Proofpoint-GUID: 5MYc6m1zfeCMxJKCV9rcFi6RqgjgIh5O
X-Proofpoint-ORIG-GUID: 5MYc6m1zfeCMxJKCV9rcFi6RqgjgIh5O
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..7014c40 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2304,15 +2304,55 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+/*
+ * If the MSR or IOIO intercept table extends to a physical address that
+ * is greater than or equal to the maximum supported physical address, the
+ * guest state is illegal.
+ *
+ * [APM vol 2]
+ */
+static void test_msrpm_iopm_bitmap_addrs(void)
+{
+	u64 saved_intercepts = vmcb->control.intercept;
+	u64 bitmap_addr_1 =
+	    (u64)(((u64)1 << cpuid_maxphyaddr()) - PAGE_SIZE);
+	u64 bitmap_addr_2 =
+	    (u64)(((u64)1 << cpuid_maxphyaddr()) - PAGE_SIZE * 2);
+
+	/*
+	 * MSR bitmap address
+	 */
+	vmcb->control.intercept = saved_intercepts | 1ULL << INTERCEPT_MSR_PROT;
+	vmcb->control.msrpm_base_pa = bitmap_addr_1;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test MSRPM address: %lx",
+	    bitmap_addr_1);
+	vmcb->control.msrpm_base_pa = bitmap_addr_2;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test MSRPM address: %lx",
+	    bitmap_addr_2);
+
+	/*
+	 * IOIO bitmap address
+	 */
+	vmcb->control.intercept = saved_intercepts | 1ULL << INTERCEPT_IOIO_PROT;
+	vmcb->control.iopm_base_pa = bitmap_addr_1;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test IOPM address: %lx",
+	    bitmap_addr_1);
+	vmcb->control.iopm_base_pa = bitmap_addr_2 += 1;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test IOPM address: %lx",
+	    bitmap_addr_2);
+
+	vmcb->control.intercept = saved_intercepts;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
-
 	test_efer();
 	test_cr0();
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_msrpm_iopm_bitmap_addrs();
 }
 
 
-- 
2.27.0

