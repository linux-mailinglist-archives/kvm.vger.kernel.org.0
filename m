Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDFB352525
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 03:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhDBBdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 21:33:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49888 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbhDBBdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 21:33:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321VdPv051973;
        Fri, 2 Apr 2021 01:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=vSFnUOcVxQ7ReIJxsjGeQiIWjRDiO+g01+LJBKN13XM=;
 b=yr2fV2LySfei8LxDfnlVc5Rgt4sJeSSrQzF4n1TQmm8K1vtlJa8Y9AUJyFncY20DX20+
 ClsOaFoWDNesAk6SNxt1kwI4b/EkdllvqljudQlNACLk85KOkl0TE1Eal7EuA8gmFOEJ
 RcL8AQEWIdgczGi7VXkc/YJr7LI23aouIsIKGN4PlPupE4PIGu//WqRiAh9uNtlPQzNr
 Swg2zk/ni0mJLxb8qCNMO3JrIJXvwpJL3nsMoPUnnIUYfY7k2Pt4Qvt47zz0ClFuG0Hd
 3lmdHyerLrASRKyhmI498u4iH9LkGNKMnizbfZRAuAtPur+IuWJHspj3iCcITQjq9l/t jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37n33dugmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:33:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321UwGO018834;
        Fri, 2 Apr 2021 01:33:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3020.oracle.com with ESMTP id 37n2abyywc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:33:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVyH6iqLlE0oW/B3CrsmeQp7X0Y7j28yxuG1YhVz2RFCSyZePfW0bNeBd6clf2416AhzP1sovrbx9JEwsr4iNihekMl6cCTIUhgugTPpQXnuDQqUXZNqCpW/CZgh6B+3oxDcMNrM21/dBhWZVTCGtAVwxjePWhboyos5A+Pn56Gp3JPxDS9ywlIg0t1d5B67TDkEIY8kcStjBnU1Y+yFm7oLYWdXeQId8cYCAm/ymMCFzr5oNy+NexKRY8Q29aUGcYKNc/42cnW8LqFWz7/04YvxDeTEqv8DKWqe49Lt+DVmUf2ljJGz2SoXoMB5ip3PXQwvqZae6CGlE66EYvsl4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSFnUOcVxQ7ReIJxsjGeQiIWjRDiO+g01+LJBKN13XM=;
 b=dgnXWgupSbzFRLQuVpY5fR8GcL4EDS7ZHhGUWo65ebqo811XnQQMqbFZw/xgs96VMsvfO+nPfUn9D1Hq3zYE+SUoKaBhFhJyOcijmHz/ikcs6bW/iefraiAGgOvMoW7LUYryS1KPggcEIizMDCubrbk/2dSd2PGjukdSRdtFvxbaEO0mnr4WIsyiJ+kWxQBKeYSez0FJacJ9K1wf3BU2cGCE0mCYqlH6TG+fplptgdeee8sU1UYIhK7rcrxyQTuec1j7/WADjImsPuM89W84/0NPw6KJ02gzKa2gTUYm935MT98/B3bYkefIZixJlHJ9g4RZ7u5sP7kxhOXblLawfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSFnUOcVxQ7ReIJxsjGeQiIWjRDiO+g01+LJBKN13XM=;
 b=tNCwTHZA7IYjtf2olDRTyLyLfCl4Y+w8r9Tp2pkfuwDAWaV/AopfSJD52KsTHFIiTWNQLHQd0XrGmj0r7Mu3HjOzyingNLysF5VsEv28iEqG1VrZVSlhVh2nkiTBtVP6MarHVSg5nJ6CN045lMmbBe5BkC8WUd5E5VLc4SQHFL8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 01:32:58 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 01:32:58 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 5/5 v6] SVM: Use ALIGN macro when aligning 'io_bitmap_area'
Date:   Thu,  1 Apr 2021 20:43:31 -0400
Message-Id: <20210402004331.91658-6-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
References: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SJ0PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SJ0PR13CA0024.namprd13.prod.outlook.com (2603:10b6:a03:2c0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Fri, 2 Apr 2021 01:32:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8d8341d-c877-4da0-f242-08d8f5773f0b
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB47958B39C287341DE4BAC193817A9@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:305;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2aR9sJw5OxmK0B/yupHGgtyvmzNdNb26TMQwbIz6c/J0bka0H5BxE4jXJ2NWh4gbu2cPGzxJKJMOwcEJLUvK5nRziaLtVd5mlYtQBMDr1JieP2kwDUKlnl+mYLZ5Cqlz8c6mabKZpMB5vevCAATY+RQxU2TDV72GKoV4PvSTjjNIFPf9J+dEir6Z7dlfmNwxebE+2DOolm2Hweo8Bw6KgoDHmzGfS2238x6qaQi55RhafyNZdDkUBARJtwmKqRbroA4Zdwh1/4pubpV5TJFKz6Wqa1lOj+5QCljWERkAMIzwZ69EVJa2/5HgiUAqgHsMn9TqxiG6D4Z6uNg+mTZSuW9V69wPvRRNQv1FXANctmGrmzV0ACmAd9PQWRcon0z6kBo48sWJ5amU6rRsO5YkI2ECWmfE/M1Rij6TJV4nxDbe3bQkAx58aRMmPOk5j9SzYGOVaOwaq8UPR/9298pwJtuVPJrX3MjGkmOd1q/PQsQisOc2xSjgnKhqS1vaOfaJ7E2t1LZidtAX1z9epycOs4N/abjAcsFkkJ3fUTyiJxE9f2c5spyMSHEZc5oN+NTjZpoErVAajUaheq2Vuojz8Y3lPDZBrsLWstexMlQ+KEiiAdASsJUhtcU1SZJPn8rPx6sKbBhwZfeMS8ItD1P5iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39860400002)(136003)(6666004)(26005)(36756003)(316002)(83380400001)(1076003)(66556008)(5660300002)(16526019)(66476007)(186003)(7696005)(6486002)(2616005)(44832011)(52116002)(956004)(8936002)(38100700001)(4744005)(8676002)(6916009)(2906002)(66946007)(86362001)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EY5js1MFva3vyzBj2kvC/E0YPavm83URm2iHdUKqoI8SpctRyq7Hnmwenr7V?=
 =?us-ascii?Q?7MAbA4714Ni1YAp7UsxtP7q7l0aYB81qnjMSp1/PkwQw47b9b6ClALrnqim6?=
 =?us-ascii?Q?xcUqZt00lR1awHRRcJo9ZHo4ix07sBkpfnq3cseCP/NBXqFok4pT6fpwQmeF?=
 =?us-ascii?Q?5huh50ZM1L3Hlk9md493THarUPvh6NiHaVQl1OutsVZYXsICRYlar6ITuAUG?=
 =?us-ascii?Q?5xQIpXDRit8yLFK3n9GypE192+oQjAlmHzW4BGffmpj5HT9SwzY5OtF5+0B4?=
 =?us-ascii?Q?IL6Qq2EOEzym9+m2FFbn7Q4ToRuZgt/eTEbgveLL9M78A9qcCnhRgmFmVBKI?=
 =?us-ascii?Q?slxe4u2LkessG5M7/BQFeFFnunIxFa73Kthz7ZDVkgzHYwq1sC9XKiFb9vMj?=
 =?us-ascii?Q?eUaW3SKFS91t7N2wK/Ut9HH1id3Ad5iq+GVR1CindVxBagTujY2LdcYNXCms?=
 =?us-ascii?Q?YCr83F3EmAsbkzMai0PbbY05pbMUtZNQbvYD0tf02YAVlBT3A+93CNV25jAn?=
 =?us-ascii?Q?jYPkcu/YRAdRO4T+cui8mPFjL63Ym9vKP2QYeKxb9OE2wvcEj6uDiok+1W1o?=
 =?us-ascii?Q?ZeD5jlzMMy84WkSmpVXjtjiHRWJ4scctpK2b8E9HQEb1q6gMpH2RX2BUuiV0?=
 =?us-ascii?Q?8yk7WT8khSeVYnt2XLQf30eoLkpWpr5Hy1X3tPpAuNHLvF4K6k82mpw1d/+N?=
 =?us-ascii?Q?S3EIcQVzdOF9vYpoQcl+rUnYJFSdc278DW9XUsXLcMaASEDV7J2QgiCylmu8?=
 =?us-ascii?Q?rDd8qabI5mrrc/9fjZDgAVl2Z1klldn+9bcqxbP8HFOk+f/5dX2CUvff/2cC?=
 =?us-ascii?Q?L9mkNUWj8wkQ1hGNRJhGfsQ6H8XnAxW5eBbOXwAPDm5FCiC6F/j1ws4lOwlo?=
 =?us-ascii?Q?/Co/KfW+9TOlK/gEvk+pcBBS56ZPjtfits3MrBw8PvAgRRyb28q11vbtRVRV?=
 =?us-ascii?Q?c7JIGAqKDONXaa7XNCO8DsS/yqplnkBTGvMo6Ip9Udd+3/0vWq3HKgkC/tdD?=
 =?us-ascii?Q?nm6EGgAGFujQZeqYBhOzyEjIws7vN889lT89Ohvhgy/tzmzpCF/NhCc4OASt?=
 =?us-ascii?Q?7mOviDbmND+eOQaIHEps0gBugXPtmW5Du8ANSKEvOOtrLqBG3C2xzU2IkfGY?=
 =?us-ascii?Q?2uwanmxjNGUxOe0Ah9ISTbXsM9ZzrFE8LCIDP42sZm/vCiQqBt9+yidXtV9x?=
 =?us-ascii?Q?GKiN97NcLguZP0HY/VkHpTYsWcJZyAm+lLBi84pWdExMEZwGtL87ZSDhW5Qb?=
 =?us-ascii?Q?CpXmNsrPL0OEONI+jzB4p+fUQGanngW23lDCu0Az5lWXu8xhJJDr8U+z2Xxl?=
 =?us-ascii?Q?9JgY77/5pBzEuBk3KnJXB9Iz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d8341d-c877-4da0-f242-08d8f5773f0b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 01:32:58.5213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKQ2gfm5tKOhshAUR8lWk4u7OFtKwYmTvOuJNr7FiMzSuSVUpD83BsojLiLFMYABw5VxycoKr8OkYMTWUHtUKCZGwQaqfw24Y15dAg4D14o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
X-Proofpoint-GUID: yELN4fiCMznSoy3RQKVyybAxwmXbbtue
X-Proofpoint-ORIG-GUID: yELN4fiCMznSoy3RQKVyybAxwmXbbtue
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the macro is available and we already use it for MSR bitmap table, use
it for aligning IO bitmap table also.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
(cherry picked from commit bddbbf66215b4fc0076d1391296f11ce3bee7c63)
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

