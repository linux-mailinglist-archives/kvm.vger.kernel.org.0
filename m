Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165F935D362
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343848AbhDLWpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:45:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44596 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343836AbhDLWp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:45:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMewFE083254;
        Mon, 12 Apr 2021 22:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=P3l0o2q8uHM0C97YI5Wc+JWEWcEFjZX2qoPwXMKbZrs=;
 b=fExadP8HwzqzQ0qyAGKfFtaaBfyjLXHAnFpvHIxqEICRxnXYFgyOhI48QM7UqH8cbqEl
 foPwW9obbd6C1HQeMkeNMl88wvpuri5/DroidMc34g8Kp94vtFPvOZMVkiLn4QAxc4W4
 FCcINxV/5vbutUPwM+e2OWVaKNqZnzVwcY03h4glOIA5f24XUIrsaEfoyltFcIBgKtsW
 X5LEy5kEvZ59V+CF1bRSAIpqJmBOj88MTR4FHJkWDk5mOlYALBLqheiPwMu8c/fNPkHe
 wMZwCx8SflECXYmBbBOGyOEcSrRG8J9uRGAxFoBzHPVZXChS9qqTER57N6DM9UCl7AcC EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37u3erdbdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMfR7C009071;
        Mon, 12 Apr 2021 22:45:05 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2056.outbound.protection.outlook.com [104.47.38.56])
        by userp3020.oracle.com with ESMTP id 37unsrhcft-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTHLLUuSe98IDr5dRHMFJqFgjncTuW+PEd8GDIN0IPpEolEx8Nz0i6B9Z2wh6XW4/o7PyOFU4PuXi6wCMYOTsDvGptlmiSKz9i2diy/NUDT1NSjsRF6Uuyke7lJUAhH54OI8oM/Dhg7IgV7ATrD8Dh9Ex4jVZI+Nn7+AMboZpXj0/MAeI5bvELOfXpmA7S1Z6AvEWFrMsC7tXWvFLWOF13cUHzU24Hh4WXZAMq/3wi2PrUZ9IVjfRqUq5WiWzZDQ6MgIPhkHncfmM9Li4kPmDbFrdrBLZi4YG8Ug58RJXo1ZuVEpo7OjbP30VVp4ZPXiORWGgmlc6GBN/qSlJZes1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3l0o2q8uHM0C97YI5Wc+JWEWcEFjZX2qoPwXMKbZrs=;
 b=IQM62Q6Y840ouBKJxlQuu5gl+qLp177x4MNhAfdd+Go5gWlSDLjESEA0nNEzqwR7z2SOTsv7PXQKuRhvBl2KYzjVg20lkMfyTFOqdOhgzAwmd42Cz4fWJpsF7QAXzxSY4a/jYRe/RyriuA9RAJDRcVunhCUAgrp+RxTuB3Oo+DPEI5PgpL6BrGnqeYU9vWLWzyFBTX1wjr1mTWodxOq1GheOGebzV+xvIm0VKk7KusqViAAoNy3ITIPxMqm208i8proMsAXcBurdIc9XBLsRrvI7RrrhS82QdlJPQYkfrMi3G505bPp/pZQTk9J4nKua1OWu/hWdC0XwDibj+E1Ulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3l0o2q8uHM0C97YI5Wc+JWEWcEFjZX2qoPwXMKbZrs=;
 b=ApJdx9brfaOO65e0HrYkArgWwgZ9B+31v2c7F38WDqjGubjPeIqHiH8Pd2UWTwcF9Pj2Ab7QZD0b04FS1M5icRWvpMgS5Lfcrum/4iqpmovuZOl97xULBCitYiYBviuOml2TEaaPf2sXHkonOL1wOTGpuJtp0rzReYVox/+NtWE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4683.namprd10.prod.outlook.com (2603:10b6:806:112::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 22:45:04 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:45:04 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 5/7 v7] SVM: Use ALIGN macro when aligning 'io_bitmap_area'
Date:   Mon, 12 Apr 2021 17:56:09 -0400
Message-Id: <20210412215611.110095-6-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR06CA0058.namprd06.prod.outlook.com (2603:10b6:a03:14b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:45:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b0f3b61-bd1a-43b1-5fdd-08d8fe049cf7
X-MS-TrafficTypeDiagnostic: SA2PR10MB4683:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4683DCAF653DCD30A00ABCCE81709@SA2PR10MB4683.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rtgC2b9/yP9o8T3CrFJnOviWnKJQ3NWV92LxRoiPyQbHwqDBoxNrGOfP5S7al6fXNrKlc+A0AZ42sUNT7PNLHF1FjqT4WLs8x/7bwW8rmlEkU+HGc6DXETcSsYHUTUmUelmOlxpKdQvgDks+AensOzizs+Tsw+FhVeEPXaqQRKKFmfAxUJ10+lvyOatXXQhBLMeNzms8PzLWGIj6smL6m0P4dRVTZdbN2AwkUHlHMRWIoZo0urvmXT8NGQ97AoutkUw6X3kedpfNm2Z4Wm6lHM4MHeaf7a9mJXAFtgEdxJrPQ6/b9gpbUbGBHYr4xUQkpruXWETV6sdUJebC57npWXmvs460o0+O0UPIvx8GVl4rdxG9Ia5oBipnXvUme+Pal8e892u/syCpTvrlfeec/w4lES86+okIYVmgrgjvdWY8RpG+3hV8ZMiypT5yD6AWzf2M/me9jjLpyEtJYF4iB53jaJCCZKXLjSOlJ26rhjNH5gNFjeDDJNhaY8TgHraXGxbi8crlS8tVEQXOvXpROSgXVG6ZvRnTPkEV5q0o9LeXTU2N69NQXMfkBs57hJhMCuvAYYHliUbjBM0zrF92OYxyyxsi/IAAEgQQtER9t6i21hEXm2QfSOLLCQ6lyQNvT5Ji2foseJOijRyAs8thFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39860400002)(86362001)(1076003)(186003)(478600001)(26005)(6916009)(4326008)(8676002)(956004)(38350700002)(38100700002)(5660300002)(66556008)(66946007)(2616005)(4744005)(66476007)(2906002)(52116002)(16526019)(8936002)(316002)(6486002)(83380400001)(7696005)(36756003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?J9kwUOxkwiVxMPKgyO5klojIud0mPjG8SdES3XN2CYiwp85WwufZ+I4wFDuU?=
 =?us-ascii?Q?dHMkhvWNFqhEqzElNQs4/695odJRN107Oqx9Ty63lRlpvpeka56EiitHQX7B?=
 =?us-ascii?Q?e2fLmL+rkbeoTzZcwyqCG6MHxBa7J/vBrIkaAgJbsUWBydzV31BRowQL87M0?=
 =?us-ascii?Q?/PRy3t/1RPJ7ys2bSp5Mod4Hw8L9SwMQ2f+fJpyahySF5ATwEtvvJZ5ueIAO?=
 =?us-ascii?Q?WqaXG+I4Kj4Kq//4G5at/fDaXXQd+dDfYqr4PLpmD8M6mewzy3Xzcphmpp8K?=
 =?us-ascii?Q?xHrw+/tyFv0DGLrUyaWt6M4bEB2BB5PZkQbryGvhFhzTf8rnzW2Hj24Lusc3?=
 =?us-ascii?Q?3iJQxRvlrKzzfyCKee68J2165ilknvnGMNc8VdeniadNZbiYBEAE/cG152/F?=
 =?us-ascii?Q?yG4YrYpH6pz+jtgndIl98kAz+YcmMUNjSOiBkNcdtPWXcYo3MQqGm+gkdIIr?=
 =?us-ascii?Q?bsAZQtTeiwRAGEVbuoFWA1BpVOoZjcO39qq2Ox9u3aJocoGQS4kLzghnV5Ds?=
 =?us-ascii?Q?RtBsQ2TWxpsHgWyDMbFjaxBdCEdGj7BvYEdHaN2Pdcl6caT73BDmf6X0m9ny?=
 =?us-ascii?Q?jb+XQKlny5mZ5CxetZZsKGrTiomzTQwbBY8kklIHyIr6W6GeE4sBf8CdHO58?=
 =?us-ascii?Q?9svWtAeriT1O+nPIunaOkxW+D+G32MgAv2EJZ4ouM+1fzsokRAfxMPb7pN5m?=
 =?us-ascii?Q?Mst+iQanEumD/IOq/x+isT0sS3lOOoy3dw2SfpdtCusJA/OUvC8qqVCmp04k?=
 =?us-ascii?Q?28EKQ5r/1W0zoWvFN7CkmAJACQQ8zXJPL22Q8Hrfb0B7ApcaCwzsj2SfAayo?=
 =?us-ascii?Q?Bs3BhucOmUsBEZGwn3ME/ypraejNNfNT2UC2xDoKc2WaeeBkkKAsoNtpDsiT?=
 =?us-ascii?Q?wuILXlPM3ElanOYAml0U9siBTKxelb5Tctsk0AGilfPvQ1wpmi89Cb94i/Ad?=
 =?us-ascii?Q?8GgzAZ7iINtMahefdvNg0JBmwbmkJuudNM9D+JLS8qIe5yH7Fml9+bG7zn4N?=
 =?us-ascii?Q?b3XYjQAyxU/ffD75GANfQzymvCMUgW7s4DIu+piL+kP+Bnn+EpelvFxbMz6W?=
 =?us-ascii?Q?aSLZoD33ppMeEZQEPPAhWbg8ctNbpQQWd80WB0GptZnjFLHf4rKS1rcAfOyy?=
 =?us-ascii?Q?2Cu6DXsc0/hRPsi4jUx0KUFv2OH1ZKdcG9NPRhxZvIDKBh+QdD3rPlhVx626?=
 =?us-ascii?Q?qruCo+jj0cQ2tHPx/Amv2+SmLdVTu6+ET6lvJXJ66tFHkRtnnlE5E2NVG2Ed?=
 =?us-ascii?Q?nXRzrU5Eh08H4QJhIHNJMBw6ikgqVzLmLqTzhrntNbo6+OKlDU/lpv65/wUt?=
 =?us-ascii?Q?0Vr5MbSlrIUdnf/ezb71Ru4W?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b0f3b61-bd1a-43b1-5fdd-08d8fe049cf7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:45:04.2435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JjvEUa5Tqa2/bqcrwZpD3AAE6URUXjOA/W1LfJPoX+4SkLrR7I8xpkgUTe1zb51UdajMY7LJMK2TZCYubK/UabMtYRwPJ9y6vUSLkBh8U+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4683
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
X-Proofpoint-ORIG-GUID: h8Zi2MfAybOly2jnJQWNg-m2oVUVP0Jg
X-Proofpoint-GUID: h8Zi2MfAybOly2jnJQWNg-m2oVUVP0Jg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index a1808c7..846cf2a 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -298,7 +298,7 @@ static void setup_svm(void)
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX);
 
-	io_bitmap = (void *) (((ulong)io_bitmap_area + 4095) & ~4095);
+	io_bitmap = (void *) ALIGN((ulong)io_bitmap_area, PAGE_SIZE);
 
 	msr_bitmap = (void *) ALIGN((ulong)msr_bitmap_area, PAGE_SIZE);
 
-- 
2.27.0

