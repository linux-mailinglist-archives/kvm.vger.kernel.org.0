Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EA13480C6
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 19:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbhCXSjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 14:39:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbhCXSiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 14:38:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIOSX3185704;
        Wed, 24 Mar 2021 18:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=c4blUcuuSmQz15sANkHEu0foKNP7C5WJLmcC6oNN6WFKq6kFXuf5ClNyzzE8IudXJLB4
 xZqh8QUHGWR3IaMCIBLgNdU20IXjk3+XgE1m00kDd3QXLbM6H+DUsPSe/x7F7fPUnAUN
 OhCr6Is90uZS8bmsbJfMNvxpB5g10ti4Ocaj4RqAqvjz7k5GAtLQsvDp0YZ+cmEb0K+d
 8WaGMa5x9fiWHNZI8NuDU60k8SGfXz0VFZbF4L9xPIGcHdRX9NZL3/6enWC50ZfXZvQl
 Tj/gMpfEinXJl/GyIK+80QSXaudnf6DFkRHdJNEDrOd1oLO7S3wFKRIwT26HmQecaLgx Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37d9pn3sfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIOsKC053055;
        Wed, 24 Mar 2021 18:38:51 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2051.outbound.protection.outlook.com [104.47.44.51])
        by userp3030.oracle.com with ESMTP id 37du00675x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWDrI4X3NbmReJegVlKIdxRbSlT/yrxXa71D0DEj+JLwV1wKPpWWEKCXCTpAuQ0j8orfLELV39qLTBtekcwgaoyEjI7fHSYpHbBdK/eXYyknxSgU1/SpxpXPNjgJavOklkj98blWb1fuGKrXJPOl28BPIP5iA8y/zzDzVYXzwfK21w/HGOLtGqbQ8qQFtUw6eDDiSwlSb2YvCUheVNHrTR3/HopPx951khWD/FfuN5+pNjbD6lHyL+BcDgC4jleyjRY2JoYjGSZ2RvuK7epP4s0DoH8PLX4Bd3U4f2W8WKuJaOrJZtByk1nlJLsbDSGcV4xNEcvlxFA/HkDDJHcnaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=R03Sw3gqdh7MR2eGkc1ZR2VcK+WNnurx9ok4vflqF7UI6AN4QD51ybKoALFr4bEs15GSbIpEX96jVn2FHXQA+LlIpv/C+fHCwcZ4+6z9LpJWKYTUnRLKuiRR1dqkgwxDYsyv1xvw+1rCA06+5aErAH6OW/7pdk/iiqEvDjXIqz858ID27I1xQXoKhIT/ahyfEXCJQvWmLphbnpjbitLyI/h/6fr9lZ0fP9mZ6Gqu9b3Xuidg+5MQ9kXYCj/6KF0U5TKi0XvNneK52enyHI2hSr6WXi2CSrq0fe+fqjtpC09a09HIQDVQabNl7fKX89RjM4e5Skuoxh8abNGiAelNRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCHR/kvHlyKbKvUjMwXY42SxTz0rqXup5nfnNHN3YTM=;
 b=XrZ5LwKvVJw3KYGqE/h5RzRy+oIdCxjTTj/UcAbmTs1NLvb5tDyCvHhnhfYpDhUGiHcAvjtpsJizR1DvO9sWCB599alJ2vDvwM4EHYbpLLPCWeBH0j+soyxhseHrjcORXtgeeWcL2JwgoLwZWqwh6QtKsmWecFa/msL88J4C/BY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2991.namprd10.prod.outlook.com (2603:10b6:805:d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 18:38:48 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Wed, 24 Mar 2021
 18:38:46 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 5/5 v4] SVM: Use ALIGN macro when aligning 'io_bitmap_area'
Date:   Wed, 24 Mar 2021 13:50:06 -0400
Message-Id: <20210324175006.75054-6-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
References: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:c0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Wed, 24 Mar 2021 18:38:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: feb939d8-3219-464c-c9d8-08d8eef40f12
X-MS-TrafficTypeDiagnostic: SN6PR10MB2991:
X-Microsoft-Antispam-PRVS: <SN6PR10MB299131EAE546A5DC66DCBAE081639@SN6PR10MB2991.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8mtOZk/cVtvtlF430l66SF+ioI8qZ6dYgjeTefdITFcFwTNzASBOXh3Nl92KD9zMIfPszxNWA+JuyP3b3FAU6Pbo2Z0/q56FQAYw0H8JF2BDgc7WKvo0D6OOEs8FyspXKNSGzNY4kmgSoH9LhSrC4pZSEDh2ZNEAqF09tGWqRuKwSljH/GX2X1lHRbzu29GsPg2gC/c7zkZ5zUhAUu93JMlS2TCRQ3OAcb5oC+iDIpK3jFQy1VeXi1+vGgW355OwvbJ66wSNB2aku2MOBc8Oz5lDCwI/DIy0YGK2ft/uRAThAUeJR/mX9p27j/GsyvizAWsrkUbmXUZZyX1nEaWTPoMaxYD6wqcV37jkT3QDNEoonqu5ei50jscm8y0Y2Kg2LfvKDTQk7PPYDmSix6o+aqMPPWt8BXEH0yJah06775hOqFf1ht+CVNYXK4gKH6wnge1nEtBHPRV48SFPyq8hL3+mhkUoQP0nZta9WRqPZbJ8Q8FdFIJCyC0pf55zIP/mQsnMVA7L4yKJbBf4tmM4aHh3++2F889X3KKiExNZC5GICTuP4JXeoD1WewBwA1DZnzkzyWexGdg/zLYeYAB0aoLym5m0Nmy0cyBg8CkYju8rUtpGpwcA22IT3WwgiwfdJPAtKBPN9L+VWQvRchYM2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(396003)(366004)(52116002)(6486002)(38100700001)(4744005)(36756003)(6666004)(478600001)(1076003)(7696005)(6916009)(83380400001)(4326008)(956004)(66476007)(44832011)(8676002)(2616005)(186003)(26005)(2906002)(8936002)(16526019)(316002)(66946007)(66556008)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VHBAbqP6+eNsOX2gsiVSw2KA5z/XqWFy2qHYPVjvsY/KPOYyH2w84u0tRgsm?=
 =?us-ascii?Q?9RXSpETXAzSrLn3OzgcDHwCgbVUcocgMUyepwvUCi0tW5oGpbYJRUCzXTY+m?=
 =?us-ascii?Q?2TGrhSv/T2YbrL/TJAlF9lgj9ZFgti/Fq02BdtkOcs71aQSdIYkOjkvrKQnL?=
 =?us-ascii?Q?1NNZ32WSvOLbZ+x9IgXOf69n/EyyyBSPeg6q+Ifmcu06CjOFjge/92B5Upff?=
 =?us-ascii?Q?ALPIabNXACxArfPloPcqgMtvrz/2R5sCWzClo0kLtWR3AbsJIt5sa3L+IPCY?=
 =?us-ascii?Q?bt2IBHbUjSMVlJl/YguTXg23PDfBm3aCCguG/vRu+pE2jQms1PCzP9/ItgIu?=
 =?us-ascii?Q?zsJnd01UwA0qDndvy4wah+tRSdf+UaEFwLf5lDUKwOzlOFmDr89JWdRM0OG/?=
 =?us-ascii?Q?VzOrcaxAEttnDntRV9oKv4cLh1Y6M/WHrYnZx2Sgg/xh2+Je0Kih2AjJpryh?=
 =?us-ascii?Q?xqdUqoOEjztyF585jkL2Do4MaYitfYSQtyKf6VLfbOv0zU3FFsNPwKHSkaJS?=
 =?us-ascii?Q?M1BNdH9pXXrXgFXGfkioTsWGtzTG02yjsehKB1kWbt+McYprvqdU3z6LEMvC?=
 =?us-ascii?Q?QH2tz0UjbcbY03RoXTCqvFIIPSSs2FeXvT/H7Cy1QbGTsDQIciSLp6OB+K68?=
 =?us-ascii?Q?7/KfKvq/p1W8u6gkdpdWb5qhDco2yLDmwYXUdTpANT8TO34gTeL8+/8OqhQA?=
 =?us-ascii?Q?gf40G2vmDN8ILRggP6eGPrAVDwDo1fDzPJt0tL1VL3+eWsToRQeqK29MizJy?=
 =?us-ascii?Q?NIA680xZ8qkYVN0Llz/qnkfeciZUzbi+w7IuPQLP9aRGiaUfl/P+I82aS9iX?=
 =?us-ascii?Q?F112xZxEntQ6pMRugYe2fVeCUGVJqmSdNJ6eqsgI5Hr5RxbwjBU7ME7gUV38?=
 =?us-ascii?Q?8Mf7/rRrC2OJn//ogEfajdcpZRLD7g2M0Ce7x40evkgTecj8MYVy6PIT1I9+?=
 =?us-ascii?Q?Lb315y52tS+QkTpQtxuXiGAjs+8K828pywM/tvEpws78mgLVmcSHgctb3wBO?=
 =?us-ascii?Q?3cyYaQ87yx9FNm/NJmNku6W3Q7X4lvVRZ03CALYmYWuOLYT5g0hFc4auzf4Z?=
 =?us-ascii?Q?bXj2vNsx7+Z7kqYBcFRxYUaoJl0CMtsdI8LAUs1JNiDY40K5G6p2Yu48gPpK?=
 =?us-ascii?Q?yqVhtH8PFdW3E94Uf9DPFHtn3Du2UlDSS5XMVUdYIg8n88hhBvz1ILXQbidk?=
 =?us-ascii?Q?Y3pVyEWG9uYlLBjTmqFsxg23FnhtISLWZaaZ6cCS2PjYPQ52aS9hJyy4KUi2?=
 =?us-ascii?Q?4GKLZrMZn32Elgis1fgRzIuG5CWqZ5oQQ/o1f2jOEVZ2wSatRxsGLtkOxN5J?=
 =?us-ascii?Q?u5G6IVmb4f4xrQyRYJqAOhLR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb939d8-3219-464c-c9d8-08d8eef40f12
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 18:38:46.7694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wbEFnzWaysjIVTCOb1RkDiQa8B22mP3X0SXuAQIDFr8XNbXqpkLfM2LeHeoo8vwv0tvxcumq6dCCPm5tYZFkgSrJ6smnPpb8m8F5oFC7H8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2991
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the macro is available and we already use it for MSR bitmap table, use
it for aligning IO bitmap table also.

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

