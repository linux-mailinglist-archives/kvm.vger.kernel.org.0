Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDC8485D90
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 01:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344019AbiAFAtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 19:49:55 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36832 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344020AbiAFAsL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 19:48:11 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205N4Pe3011251;
        Thu, 6 Jan 2022 00:47:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=cCbrdYZgZ6UluuxcuP5hy0i/kaxaqvMKbPFuo+vDN5k=;
 b=p7Ltb1O0oB6PPqBa5shhf4mxrHyj8Etgmh5mi18+mutwzaPOrG5/144ONY2MOSS1Yav0
 JIx5xrQeQ3nuVtaPLK8sZsdgFArtQkW17yjVj8HTFbfgpev9ilK+OPyMBGf/VatWbCBZ
 IU60K3qDBuOPj2q8y4xGHx4hkifzof6lZiy+FSob7bKYm6gEwIYXehikHgqgi9iEja/1
 JLRECHvf+Fw7Q6hJSvM32Jbb13UATuhVEam3h3Wb2r//gVOGf9tdjuF0MoAqysnE7y5B
 EaC3g01h1u/39eaIMDHMZQ4Y2L4PjbFSaiF5ig1dTbunF6aEZdZk7LD+MGhVIe97qVxo vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpdg446-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2060VfEo076239;
        Thu, 6 Jan 2022 00:47:42 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by aserp3020.oracle.com with ESMTP id 3ddmqa3deq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 00:47:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzwLIhKo9U1psrS64MYjNuIMfLphsihky8sOkH73eeZNDV0ekSkJUtEryHsSsPB5/Oqt3a6uwR12m2GVM6420546la9EHnoJrl+OFnxlaZruEl98aTOs3CCTxH2grm7vLYmW2D/UuHobab22lT06679yp5CIjs83r8Qsv6jEiW7rOSzGOx5L2Wm5/pR688r67HiZeW4aZlwVNbLGO9SFE01Ru0mOvWRAcujo6WFFSTA+S8rRyhIZXwqdZ77sv/DIeoqMkQTKpdAdCOg6QOgnBFaBNIm4ysWckslxeu6cD7T0bS+dDO17Kc3InJzo5TseR4an5vJOJeBtQGXM94i5HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCbrdYZgZ6UluuxcuP5hy0i/kaxaqvMKbPFuo+vDN5k=;
 b=bor7OVN/TjyBd+gepoj3YafyU/7qT1Dshl58zS71L3P1Pz3U52H74kI2D8CTtVHqqOPdXDoSi536Yaj7XPjTSADjz2SuMsuhD67UOi9aZdleu6DDnVFSPKDt6HUyl3OrvY45w/2OzquTB7l5byqTESlhErBHhBKuz9D710hZ/GiYHWs1OGc7TwunMPpuOEDKf0RO3E4U22kak6KrKUdAIVAFmw5QFycfysAne9xYgfnZbdOrdobeVraOb3pAJIJrt7hNr850snS4CkY0bh41E/9+SIrrUSMED4HO89FJIgEXi3pD2Ot26Q6P4evuQ7ZiRQP9x5kG9M8Yrhii39RKgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCbrdYZgZ6UluuxcuP5hy0i/kaxaqvMKbPFuo+vDN5k=;
 b=RkEhl2uTPAokylOxomREwDP+QdAfnk/g29IEPKnaKKRMVIz/UOG0JKR7xJ1pDZPo7Vy0L2E5XP33dZhGSlICcwdTSp+OH9QAByTPrq77NKD1NDA2mxdxMe8OtOx6KRnBB1kS4uSc9L7iSwHB8i8dSwp+CuThi1Q49MHg5HmFyIs=
Received: from PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 00:47:40 +0000
Received: from PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3]) by PH7PR10MB5698.namprd10.prod.outlook.com
 ([fe80::85a3:23bc:dc92:52d3%9]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 00:47:40 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 10/16] padata: Helpers should respect main thread's CPU affinity
Date:   Wed,  5 Jan 2022 19:46:50 -0500
Message-Id: <20220106004656.126790-11-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:208:e8::32) To PH7PR10MB5698.namprd10.prod.outlook.com
 (2603:10b6:510:126::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 832d7028-1e3d-4ef8-dd04-08d9d0ae247e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB44229525E40698B4E7FAB7AFD94C9@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e+5k+nIwZLDyOARby2mW1NAU36kRWV/XSgMA1QiCbdpRSmQYzf7TrZDZ6qn1i/aptkxV/bnEAE59dYIROD967edl3wO2EwXymMnnz7dpcn3HFAtGJRXHDVr72vsbu2eldfwGBS72EPospv1K6CxI4O5lMyVQmzd+Y9mPWZk2zGugdHCDKXizEbGPY9A8rm+QGG1PvEnGJViHZ5c7K1wZE/NjNoc2mcRibfcZ6hCwrfS52TAzfSGjM+/lwnKCR3AQQpQYapbK7plWAmajHDEhO0qDIbyl41TdcdcvgMESEYdWuzbwAsVWwcb8gy/z+0MBMcgdp9xOWL1VMCEtO2XcWIhSiK2AVeG1vuCsFrh6B04c8mhVbWp8hWLvF/8iePcF536iypWaEUbWv70pBv2JI+cqwlK7ARF6On19WJ0zXC+O6pJKKJWbaDfXXM5MjfhBnHDVj3KRtcqduP4nZnRpVK4c0xjk75eo64x+/9dXls4hnPqUbXxS51PJ+fxNv2sGCYuFlH3w11RTFSUhpqtmsaEjQbSua562xVXMerzR7rhGEca47TKHehWT0FfoAhWiVKHhlP8b/4B6hDlGmFLOPinNlr2jRQb7iuu4jHETbIHIuqXROgezBOfgweNk8hy8LUrbI3ZYDBC8rsg+T5IqGbqMyVSj588s5ksTfk5Kr0bBHYtjcBazyggvmc7h2wUyulSCv3cZiRiqdlYJCi7IRswoXNobM1Lkcq/qU2G4MIE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB5698.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(316002)(38100700002)(5660300002)(38350700002)(6666004)(83380400001)(508600001)(66946007)(66476007)(66556008)(26005)(52116002)(186003)(6506007)(7416002)(8676002)(110136005)(8936002)(921005)(1076003)(6486002)(2616005)(36756003)(86362001)(103116003)(107886003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NRExe3wAwRz+UsnBYwurA8xtyw+EH+tQVmtmCsHkamACQi5oF10T2vwW3GhL?=
 =?us-ascii?Q?wP4EKLRcTR/vIZ1VBJIoMyhvhDi24tJtRikwuSEqYlQzwXTRe0yVQ96kkUnv?=
 =?us-ascii?Q?pLpLRFAwuc8RggV/WkOo0wiaz176Trvm/jPwmx8VHyFsKD39YXt0GWPqomMU?=
 =?us-ascii?Q?Ew9uiW5W9ZamBOXD+Pp06tAuXF5LSMaKrq/HcSrZV6SEqzdYhKyDOjMs0JYQ?=
 =?us-ascii?Q?ndaJ8jqUQxQgjOWECdxBsVO4pkm5WcR5nMVZLfu+FU7Novv75Kan/5ZRdOHS?=
 =?us-ascii?Q?z9NVHAlr7X7jRCygLrcDz91lYZNhl8i57/pkDSj/MUZtPiq3lIJ2mqXOmQp5?=
 =?us-ascii?Q?VbmYEsqB0yPYbaQNT6Ub2K8t+0cAFgnxmiKJ4FjzzJmuawbptKqnDC8rTrxV?=
 =?us-ascii?Q?ucRzcZ6krUAl31iLS2MhwNJRCQKWJVeBVQ5fdAFFCAqo7DMN/96v0fFRmNya?=
 =?us-ascii?Q?LMkchs4I7ZwPTTtb3CSJeskVKcXa5uTI9AFT7W8pEfaafLR5rDAJiRCG0B3s?=
 =?us-ascii?Q?UCTXL1ynRSJ4p0BdoCy6f0QysNzxf8vqKZOhk+Ag4+IFifCvVdsAlmOzKppy?=
 =?us-ascii?Q?LhaqnEzY9wRhUJkMd1A07UUiPHiys12A9uDE24aGqgqQnG9f3goS8tbQ9gdz?=
 =?us-ascii?Q?N5njbYrLVlbkIE22q9Skn9LBXN8AUM99UQNkwFVu7nOuWO14JH8LO7+yOkm3?=
 =?us-ascii?Q?CSgcEJGm6mViX/Om/otJ2phbI9ES318I0XsJNDjD6iSUwlvlaTuo+0rqt58+?=
 =?us-ascii?Q?1OADbtAxv3chsyN0lGLbDPTPNtoiWK1wK4xOhuZPNG0Gbl6ekEAOJBCrqnva?=
 =?us-ascii?Q?Kyg77X9Q317fMMNCrbfGf/EKaE+8OZBq+XQ5qVkDhNfLhRBWO1kaW6gyciOh?=
 =?us-ascii?Q?XXQiLOwlMf1r3UKJFHcu9xVSmQkeqlVZ/swCJ5B3DaCHwWYA6Aly/eWszYL3?=
 =?us-ascii?Q?9DQn3fggphk5dqD7sL1XpYgUvvccB7qz+7rOdbail0KjBQYFDjJjF6mnxRbL?=
 =?us-ascii?Q?cfp2XVKxBmUw0tQYdGaRUxU5wyRpcfYF4aatoiWovl86UKo6LLO9XZHbax8c?=
 =?us-ascii?Q?yOFEJI/Vrr9FAgFOleCsF720ybHs/awNIrlmLPeu2nq9LBflaHXoUuEDkwED?=
 =?us-ascii?Q?NnoYO2CKTTVYg9Ys4T/g9reNnLOrJonJu3lj2AgKKCbPRYmUA1keCAaIrt+g?=
 =?us-ascii?Q?j1a2FqjXAweUkLdxSbEK63/20OrKhHuF0/GPTw8VwLG04VjL0co7uPf9L53G?=
 =?us-ascii?Q?HobDAN2IbXFeny98UThGfN32KoEUi5TLUNfk1LULrXMuvdwmvDSXkhQP5Iql?=
 =?us-ascii?Q?UC+pEtX/WwAQeb/zH+ITLkGS59AxYuT/Ao7rtff0KpX+F45hR4/1IUXZkNMG?=
 =?us-ascii?Q?7R0vxfoHQLHJFsOqmsF8XMT88r5c6N6ueOOWjKl97nTEz1anDt+uqzlkL75+?=
 =?us-ascii?Q?3xmu7f+NF9V7hOqNuxArHJPDCOkDqpOkCrK0osz7sb2wNm5UB8u9Y5ep5vlO?=
 =?us-ascii?Q?jFLQYXXyeiUzUi9gjOME9M/yAJNpKk166t30ogOpyv50kKOOD1LVG7kJjxBJ?=
 =?us-ascii?Q?KUyQoV1Q1nFnK9d94P1oTXWlZtwh2AoG5/ukZHUldLcrXjPEh6gdwg8IBJKc?=
 =?us-ascii?Q?Rar95FTyXcqSH8Hi3MEz6EiMGKPgijlqakuRr24b9toS+B6mCnGPMeeX4Y/w?=
 =?us-ascii?Q?TTDrTT7pa0NLedr7nWqj67fpVHw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 832d7028-1e3d-4ef8-dd04-08d9d0ae247e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB5698.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 00:47:40.6409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BMhRk1xVuZ/wCjrLjOmGiCWAR6A6i2T+Rb112dGQxpelsFqHXwV55TSNoIuWj2fwZCfbUvRT5nPU1OoHOxulIZVcnlmxzxHwn35hy7KcpNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060001
X-Proofpoint-ORIG-GUID: lzpHyArtG1QT8-PtdatUOz9Q0EwJn3Ma
X-Proofpoint-GUID: lzpHyArtG1QT8-PtdatUOz9Q0EwJn3Ma
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Helper threads should run only on the CPUs allowed by the main thread to
honor its CPU affinity.  Similarly, cap the number of helpers started to
the number of CPUs allowed by the main thread's cpumask to avoid
flooding that subset of CPUs.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/padata.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 00509c83e356..0f4002ed1518 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -571,6 +571,7 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 	/* Ensure at least one thread when size < min_chunk. */
 	nworks = max(job->size / job->min_chunk, 1ul);
 	nworks = min(nworks, job->max_threads);
+	nworks = min(nworks, current->nr_cpus_allowed);
 
 	if (nworks == 1) {
 		/* Single thread, no coordination needed, cut to the chase. */
@@ -607,10 +608,12 @@ int padata_do_multithreaded_job(struct padata_mt_job *job,
 
 		pw->pw_data = &ps;
 		task = kthread_create(padata_mt_helper, pw, "padata");
-		if (IS_ERR(task))
+		if (IS_ERR(task)) {
 			--ps.nworks;
-		else
+		} else {
+			kthread_bind_mask(task, current->cpus_ptr);
 			wake_up_process(task);
+		}
 	}
 
 	/* Use the current task, which saves starting a kthread. */
-- 
2.34.1

