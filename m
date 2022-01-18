Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FF0492F02
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 21:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348831AbiARUKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 15:10:30 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19518 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348680AbiARUK2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 15:10:28 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IK8KqW005474;
        Tue, 18 Jan 2022 20:10:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=MiMtAkvFHrVUE2yjmkjFlz6qsYrFZUDe3s8BH+0nojI=;
 b=RACetixA8LLYxNGaq68SmbTD5sRIE0KCXv/m7PBbpxpDpmH268GA/H7UsyfDQbrolM5W
 vu+z7cYFc3ReQ2bDKw3KyP37zSYzLqq+bGvxOZJr8GGHKRgJCz8qMaHLLFhQ3grx1Yx8
 GVfVQ33OZ/FmrQGa7onSTpRCTxdk0QF79A/hHDRG5TlabZ/9Mw3y/7KPaNBDdp3HaiBu
 TO6wEX7aNOufs4k+8gAL86lwoMk4EJ9jTOQ1o6VSlgqaIsmsoM9OPoIuJ+I9u/17c9Gw
 j68aSs1fcVWdTGaEzJVuW7675/5+2AuUK4K7mLWiNVxw7dSNCTTgHPIz47QimYBBs3Iq 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4q33p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 20:10:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IK0PbV180361;
        Tue, 18 Jan 2022 20:10:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 3dkp34rapw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 20:10:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPGy42RQHbSU2TfqFr0OaLmoy9Jm1WMA6tRlRYEtsTG97WIESbiE7ad3uFFaHtudkqF0q67U+6wqMnSvzwL/c+cm86emUgd8rqbqFRrdF4wL4y31IPZgBJeU4QQphVNjHFs8wzYQh36gyRH4ItsddG/rlDgQNy3SXUdd3TUqY8ULeCzwoOAx2ia/Vu05Vk2Ch7ScYpmURIm5/VeLnXc0EvL5T4LtQKSmVCqV0nvzYYza1fgevMKiKtKUS5ue7nBdn8XXgXoQJNgJSMCjhn7QvjJUyl3wC3oVT3D2rfpIJ3OK2tnzzeOMAUz5cgaJBqkuVSWMZTkwWC4B7cVlBVUh7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MiMtAkvFHrVUE2yjmkjFlz6qsYrFZUDe3s8BH+0nojI=;
 b=VQF7hbxT0ox9UlNMt1iuXmreNt4UQxRA0F1iVqgFwkkOqeVcJKNgTKWQUwqJlKrDyE6gH6Cj5a5//Pe7eJj7u+BfLeCmEaPpAk6c9Z6yohP2kuQeBSy553yIq5CQbGxDdUS309vEWoYB+Byat5k8TwKB2vdlih5xOKLmz4eTvK93GywpIbuCCTgwCCT+on9exmTmQQg4jDMVpkZ7jqAd0dRXccApcrB6Y3A7R1+T1nRlYcQnsFxawVs4WQEUYijenX9NHTGPyqZpx5wHfBz7u8q/MHDiiIbMEdU7TCPVvAEt3h+x9+O/VTCn50fNw2Ss6xZ8EWQA9yaIZECRPckCpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MiMtAkvFHrVUE2yjmkjFlz6qsYrFZUDe3s8BH+0nojI=;
 b=YEkm3NdYs1ZBptIVne7ELRYBSEf3BMu49aNKJpzQ4nMgwzulxRYp8d1hypBmxvWbGnrhwPUMC726ZLlZJlK3iqi46WrRCIalGtw8aEuQXIAvya4amTuE99wyK6BH+Dwt613FBh2T6aIBSgqAVEoaqxWBr20Dd2J5R9IzvSXCSFk=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by DM5PR1001MB2154.namprd10.prod.outlook.com (2603:10b6:4:2e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Tue, 18 Jan
 2022 20:10:22 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c83b:812a:f9d6:b70e]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c83b:812a:f9d6:b70e%5]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 20:10:22 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, mlevitsk@redhat.com
Subject: [PATCH kvm-unit-tests 2/3] SVM: Add a helpter function for checking if PAT is supported by the VCPU
Date:   Tue, 18 Jan 2022 14:14:48 -0500
Message-Id: <20220118191449.38852-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20220118191449.38852-1-krish.sadhukhan@oracle.com>
References: <20220118191449.38852-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7912640b-f62f-45ac-8923-08d9dabe8ef4
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2154:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2154CFA1ED4CB46EB860EE7281589@DM5PR1001MB2154.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tE17rurjSvXx4TqD0ldHtYex97zp9CI5MWf+WuiUS91QSzGqfZ7iv396WHhK0BTm/OhjcevYHEHBFPZJYvpiz4ByWUldNPhP+SqGGmdaxTKwIS2rDEMa1kDnkmImVjiamawh828oyQui9NKS5CASdYLtcOBI89aZ/nM79wHcW403hRf+sH7k51/Ht5UhLpaZTFG5PpU2Q+RR+ZrPOuGn6zhzP2/i0VlS8gjTXTmdaxnWv0H2AFyI9T4lFe+P+HtXR97bG63L+rSMG0kOpm/JHzTcZ63EIsZ+oX7Epj5EzolP6wLQmj+2nQCEbTEbfUQTiAI4xnMhN/mKX52io61LSrzYjPpeHQDnnhSK0YLURx3qFOCNcj6aFzwqonzopm2ZexTsL6fNpNiw3xRlr5+XL7r/IItRrWvjm3nJ+x6KHN0kRqSZd0Rgb5WkbB/sheZ04GcVcQ7T0gdEyRcz9F3SyvgKjdR2tnefkgXyMhF9Dq+JaIcsul6uisQGb2QG5mZtsDXERIXVtbLrxYqidrbwyp8AlMzNHoAH1+DpwTe1k8w76enWHeEzeQhY4Az9vgoHvFjlikjgG7v6xbqP9lTMz+EAQOQCPpccniAyl++c1U4tGJv7Op42zyUI0LfgpCqWlNyYJXlXeZmNdhsNAeY4X7Lx4GZ9IOleV1Z5XQoSA90/IVY1rm1+yR+QYIUk3sU4gNuWT7TBFw6nbOabhsMsaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(38100700002)(38350700002)(4326008)(5660300002)(66556008)(8936002)(8676002)(6512007)(86362001)(66476007)(66946007)(6486002)(316002)(2906002)(186003)(26005)(6666004)(44832011)(36756003)(508600001)(2616005)(1076003)(6916009)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n1Y7lOuwHjMNL4SqMK3xUayLLcNqDExuHutBCxZORE2AcHDxC5n9K6WIwnt5?=
 =?us-ascii?Q?OCfH3y8l4Kgv2OVf1+FqUuIqkEEs4BwI2mU8FIIc7r5M3A2HJMTDP7CenMBh?=
 =?us-ascii?Q?wr9XYf2QfHlEQzSiONyMAD+ckKycq0q4dGmeBtBzFZ6/qWnLuulbl83wlPLk?=
 =?us-ascii?Q?Ca/6fl9EUJM0Ka/ijLZOepiERBLzn22p7WJj/cvKu/0dmtb5l43fMPc6/SAI?=
 =?us-ascii?Q?pkYLKyEhHhgBiOwDSov0g95i6xBH2BvOLdrZaMpaZ3R4Rm3eQ9rnUkEPQD5Z?=
 =?us-ascii?Q?4JweAgizHSC+/TNeXPCUq5+QxLFbPOwyfKMS+BrL3h+Bm85x/4GPVhW7MPSd?=
 =?us-ascii?Q?4zGynvlMQ9c/qrjehxs6g0Uk5TdJ/2yKA4uZX6EKOuJjNLQqvmDjvIcmq/eY?=
 =?us-ascii?Q?cj7COCAju7YVVSy7+0ev7eYDugOgy4TL1FykVe6zsemWAQXsdyrFBryjKlDR?=
 =?us-ascii?Q?mMCTDdrq1hqk9G4+pXaHiX5ve2jILFyDp5XvGKUOJCTddvibB4YU4PlthkdI?=
 =?us-ascii?Q?vKQcHjdPmqMPoX4EtfWKbqbv3/5NJA1ZbFNk1RSH/Z/K9oeRYoURnrfvi5Gd?=
 =?us-ascii?Q?VAu5oKme6LtN9Wo91m0woX3E/isXmiHggWRq765zzcviinh5HoiwE7PFRzCm?=
 =?us-ascii?Q?jenIudgps1t6LqO3LMnCWA1rhTmUp4i9wH9qmIZ0Th7RugZee1CH4dJ6ehYi?=
 =?us-ascii?Q?PrdIveUZN+d2avBqEFJwOSGZxjCW1cSjr13ZP4NXap+CXLXKwfVzRWt7dIIn?=
 =?us-ascii?Q?aLneE5gtvTRzz8nzo1ei+ySWkZ42IEyaQA2IMbScwHwMYqL+/82FEFfws5Yl?=
 =?us-ascii?Q?UCTnrdEvOMk+lHTWGkbRtixbtnyGiqmYvkX1S7bYSDdZtE42TiSlniCrVxmO?=
 =?us-ascii?Q?5+soThTPkqIW4Gq6/u2MC1gb6PP3X8SEZvTTIImtAQZi+Yy+ntsxTAreOISZ?=
 =?us-ascii?Q?pvCT2O4En6gPMWOgvc1iprluTO86ZDycuetBz7zDDxkCn8vF4+ouKw3iwSnP?=
 =?us-ascii?Q?vHaqo/fUHXnhYTnYv3fN6iCG/buK5s8yozgwvGonih3nRqrEBeUdaIrQL4ms?=
 =?us-ascii?Q?e5NC/GmZf9XAeqXSR5YDVXb/9y7cvPd8IOW9EaShImH3dKA7YHYJ1V6R8lPa?=
 =?us-ascii?Q?gMTqXGCiZTvUemDlMlWi6+77CUn0u9zIus328wVs520ZY0vUsQXZsKSsJjs3?=
 =?us-ascii?Q?rfNOYDpa73puTrFGYt6A8zfXRjniOb6wdDvDqsH9z5RdjszQS9hHYWSqWU4M?=
 =?us-ascii?Q?Vn30QRTLGLjiUD/YhFR+7idFhhz5azSUAvVdxyrRrc6sj9grTWFPsHyKtmSF?=
 =?us-ascii?Q?uAwisLYBlpX78pnq8JJGM/XMnS/uD3T+KwkRtkCAWrHcuvq19dlfTzeRDf6/?=
 =?us-ascii?Q?1UCCvQD8mBGudbpZDGkAIV9hpyNFLm6zVDYTvbLhYyESUaaNeBKjLLWKcROy?=
 =?us-ascii?Q?3LaZcV7MWCPdTfdNsbyflNUQICt7NiQYukmB4nWAckHIG2t9hbEbsfPHv93e?=
 =?us-ascii?Q?Nyl7I3tFEi1pppanlR49cBBGUXU9A2TkGM5r6mZkLniwAbW4Met2mMjCwhK9?=
 =?us-ascii?Q?AwQpFKwfP8w6bmaQzIdyK2HPZfbzJqMHBvG4lnXW6FALXlT/YOkCi5YQih+C?=
 =?us-ascii?Q?2Haj7Tnd9rHcCTcfJjqYpV7Maxkc+PRtEMZiLykNxH+yBg7NwUqoobozYAcO?=
 =?us-ascii?Q?XqAPaQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7912640b-f62f-45ac-8923-08d9dabe8ef4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 20:10:22.8855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZGGJfJHOlgy0iWO1+z/OmEJMkwv73dEzaiXGz1DSmZJY5yPR3U7Xt+f/heEEtoOkrMatwPj81h9tl7gfjdMdZ/p7rxG+MMW45S5tWUziqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2154
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180119
X-Proofpoint-GUID: a2lFAhpQvkIF7pqA_76pBso2u1hQ4MgU
X-Proofpoint-ORIG-GUID: a2lFAhpQvkIF7pqA_76pBso2u1hQ4MgU
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/processor.h | 1 +
 x86/svm.c           | 5 +++++
 x86/svm.h           | 1 +
 3 files changed, 7 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index fe5add5..ad892b7 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -180,6 +180,7 @@ static inline bool is_intel(void)
  * Extended Leafs, a.k.a. AMD defined
  */
 #define	X86_FEATURE_SVM			(CPUID(0x80000001, 0, ECX, 2))
+#define	X86_FEATURE_PAT			(CPUID(0x80000001, 0, EDX, 16))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
 #define	X86_FEATURE_GBPAGES		(CPUID(0x80000001, 0, EDX, 26))
 #define	X86_FEATURE_RDTSCP		(CPUID(0x80000001, 0, EDX, 27))
diff --git a/x86/svm.c b/x86/svm.c
index 3f94b2a..d03f011 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -89,6 +89,11 @@ bool npt_supported(void)
 	return this_cpu_has(X86_FEATURE_NPT);
 }
 
+bool pat_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_PAT);
+}
+
 int get_test_stage(struct svm_test *test)
 {
 	barrier();
diff --git a/x86/svm.h b/x86/svm.h
index f74b13a..d4db4c1 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -409,6 +409,7 @@ void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
 bool npt_supported(void);
+bool pat_supported(void);
 int get_test_stage(struct svm_test *test);
 void set_test_stage(struct svm_test *test, int s);
 void inc_test_stage(struct svm_test *test);
-- 
2.27.0

