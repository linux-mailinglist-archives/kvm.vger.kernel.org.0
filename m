Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F8B7B49C5
	for <lists+kvm@lfdr.de>; Sun,  1 Oct 2023 23:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbjJAVkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Oct 2023 17:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjJAVkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Oct 2023 17:40:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3623C9;
        Sun,  1 Oct 2023 14:40:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 391LYEkQ021871;
        Sun, 1 Oct 2023 21:39:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=2RlcX5xRoWECOjQUyLtUtoGf9mD0ijduDwCw45zUdJM=;
 b=v6qJ3BuindB91l0q9vWJ0IfsojNaC6thF8prF8lhX4z+Xc0eeW0sGNNF4fXMTnKxrHNO
 F0zIGogwqanmUswAKd4/c6KP5UhLAdrsl94qEJtkcYqqoXjGPTsaYVA5XMtl/O0lQ22x
 Dwj+iOglwRZATRfv1+esQgWtknr6F8Vql94EYz0HB6urSVdnc8o5k5zsy89g/nrtHnES
 1MNp5aixf0hZ9GpYsV7M7Mq/1TipfyIj3ud7ZW6iHByLV5hUprKQ4FO+7xEfpxAGN3/A
 5HEFnzkV4sqg6UrKH31g7wMFuhKzRN0nE7Z6foWt5g+wGExLTD1QX1hjo0OQfbkakJhJ 0A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teaf41jea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Oct 2023 21:39:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 391JfC34001409;
        Sun, 1 Oct 2023 21:39:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea43vwku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Oct 2023 21:39:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjxtpZvE1hNOpmCKyVEtIlup9ZB1jjMvJ7CyCSIlvYr/FQu1fiDDQ3NsRylooJ88AjTBtR8vH7T6P5lIp2vks/vWtZo2RcRPrK15m+Ezz3SBdM1h0xkOuD5no0Mc3NludBUg9TovAH4wtU0ofRGDv4vFrgvqCsf9nfQjulETWZ+/icIgHk1b+eX0rcunZ0B1tHVyHUPFJGzr+S/mSt9cbQ8s4C05dLzjOQ8PmNRkCvBJVX2b1wR8RajaAmiHF6Y4nQcYgKGV1Qb+j1ctpEq9wzUKx93C4eP9mpXc6Kdy8TK/effBAFRC9D52JxQIe5bS9ZoW5LY18AxYsoZbSuwrZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RlcX5xRoWECOjQUyLtUtoGf9mD0ijduDwCw45zUdJM=;
 b=jlaqnjkL5c5JQMjS3RlGlytg3/Q3s3k6yAzk2oxOVcCjalBdaA1biPJ647pG4NAeA0Wgi0qnRHkJDkx5pHnVS5m4nzW6Ip8B3tvr4WWmWZSeTvpKXmH2VTBoHMViRkZ2bzUEDgWqxVqPz5MhQcWnH/UMf0LuFz45lbpPOuyT3g6RKk4papL59tyTwX5dfeyiDZt0edwrjnxUizlk6/RWCRJz/AlWi4sQjFiKKtQIATz8skEMH2oQF6cbRpcb6judEVkYF2/tZ9w3R8q1ehgs+A7hhzXtzWloqs4M5xTwdCJ1mZzd6v1rxDQFo8QCk0CH1fnTdZh4kb28HXjdFUTSpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RlcX5xRoWECOjQUyLtUtoGf9mD0ijduDwCw45zUdJM=;
 b=CSVD+kiQHPRZjwn5khX737WNIgakhqkQybZG3/QXm+By7uavn/Z7iX5pY0xrQyoSu91qwesZhbO2nfeO5zjv7mCsKFj746HnfBOxsfIyxtK8UoBMu/n17qT+UgXw3MGc11yDoB38sndUcXicEMi2eZESVmGqvt+5w4lIKX3GAmI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH0PR10MB4613.namprd10.prod.outlook.com (2603:10b6:510:33::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.26; Sun, 1 Oct
 2023 21:39:56 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6838.028; Sun, 1 Oct 2023
 21:39:55 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Subject: [PATCH 1/1] KVM: x86: remove always-false condition in kvmclock_sync_fn
Date:   Sun,  1 Oct 2023 14:36:37 -0700
Message-Id: <20231001213637.76686-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0021.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::26) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH0PR10MB4613:EE_
X-MS-Office365-Filtering-Correlation-Id: 30c633ce-1145-4d14-66e6-08dbc2c6f3f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/ZwTSB7RVVsix8Nvqz3AAcOz8NbO1J+P+OtXOj2/1E2aiWWURzFdioLxFE4+cjnWdQWelP1vNPo1RYD3hWgdMxMSXJR4+sZPydlhuy2qZ+PMjPdxGpVkww/z95EVoJXqvDqBRwUHF4FT6hp/ialDDmjOizDn3CakhP4fm/rRKPsaxV6c7/SWaUQowKJ+vMHCmUZfl0I4wQFiZv0AXUub1hDL40Y3+guPd0NlYZ0FYHdIy8bgpX+YBbv9KBJ3Ub5h522MZfQgfd1QT3j6K8k/THfuSL4kreWKmzNX68Gt3ki3J/kSEFV/BsYOEN/uWdBDZQiAvjcKyLYaJFtL4OlCN7N9rG6O8K2duLvHCLnFzhd1ZhcTsS/dOVXCtxz4LRWDA+N64IO4MQn4lxjaikCdblNvqxZCA0mMPx+6ocOmQhehRqhUW0Clp2sr+h1y6JtBOH8Dto5D3n/mBcFrKYM3r4hF52S7BGGI2D6H0RDBgRj3eSKHxpcqLKBSbtCuEshsot64KtjRmoJvKAIJleLS9Afud/+t/nJpw9cK8eaPMo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(376002)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(966005)(478600001)(41300700001)(2616005)(1076003)(26005)(2906002)(316002)(5660300002)(6486002)(6506007)(66946007)(66556008)(66476007)(6512007)(8676002)(6666004)(8936002)(4326008)(44832011)(86362001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jpBFl8gLSCNo/jH9EWLf7PDyZsbv9cQn6Elp54c/kLyxStgPveiWjPbQq7SD?=
 =?us-ascii?Q?TKUmKOUplLUtht72FSYXQ4b/vH6HMbvN2D6JKGoALAil9xaClGp8Um1Pv7DC?=
 =?us-ascii?Q?KmN8AbxS3ey91I50kYeKWa7XyVAwnRtt4hWKlP6sVtxYsS9n/PU8p11Jy6Ha?=
 =?us-ascii?Q?EKOYbRo+NIstjlGYeuCERpIU/cs4qqPhisuP9hP3QKpaRsGCruo3VpbyADCm?=
 =?us-ascii?Q?RDx22WCG5ZNnDwGejid1dLHwRUZm1mDdaBv5iX/JKez8Nr3nZloSvvI5x0/0?=
 =?us-ascii?Q?1NafIKETlCRfFkQJsCIHZO6V8E3YRoi14DSdjsx4ZsFszSOHpeYTJO8ZlRBk?=
 =?us-ascii?Q?YhrqlCJH8+itWPIQtPOzQ9X180nUzV/0IgDbZLYrxJO/yBQx/T87/lnXOKtY?=
 =?us-ascii?Q?hH0+X9mGr+rmhZrXy1HX4pom69hC0wY9igZmTXY9a/NA3oJaVUfmSTMDqjDt?=
 =?us-ascii?Q?Iv0Zr1A0Mp3ZX1evZPRDVY0cWXSK8JQ73BP0XGzEFmv/S8wtENhe5XAbOqDR?=
 =?us-ascii?Q?Zrhzdr1tQN1fW8kF1FFgot/NVAsCSkOfkvkEp/RxipiGOkoGqCvq3Gf9euUs?=
 =?us-ascii?Q?ZJVgbqd0gfYp6acvGLyrq7XZg5xJ3E9A2tI3uDFRpbcqmrIMn7r5EIjg6JN8?=
 =?us-ascii?Q?Cdwwo3sOQWO/X0QMNj4Q72lt5Y6f1rZe/MOyT/MgNn+A3fxZ6uZ4FxwNhOwA?=
 =?us-ascii?Q?7L8SSZ7cZH7ytd31fBKH9scb9nq3o1T4fNrvUD/gyiNB3mOxox29pc3ZSCHo?=
 =?us-ascii?Q?enbX21wSXUr9CJ0enLQHSFFYdb0dXQu+OpawnuOH5ZwAjmunDD6d82Lp3ZWA?=
 =?us-ascii?Q?GCfu95jTARne015+5u3wvOrDNu4FxFvCJmTUUk8YxyBBPaxdFeLuah2cGoEi?=
 =?us-ascii?Q?/LxmuonWPZodFwDwH+awm5XdmdhBgdCTpo0QUyGcHwyfR7dInnKBfh3Jxm0c?=
 =?us-ascii?Q?LlOB+VxcO0TZEemwTY2f67YLvYvpL1mUoEuZBVFdHiKn46jBcgwkTY5V3qSD?=
 =?us-ascii?Q?sEEOwOmEFO8ojMpFcO95Ei26QD01I+4edlG/EbYyhtotNNUiVce/038IqQhG?=
 =?us-ascii?Q?Dw85n982B0nNgv1isuaa9/d405PIO2kHibwbQn2Th45881Fw+5tG+1y08OvF?=
 =?us-ascii?Q?45mzYBBQeGMSLLB1ZEQ8PL74/9cpD4CAdxOeqzWVWxSOpQTGwICewOUY+u8i?=
 =?us-ascii?Q?F8V6pFl0Dm7c8/diNEzHOyh4zIeKnGc+LixLLhipzoH5vuVAStKzzRTfWTns?=
 =?us-ascii?Q?mUqG9YAP/sifP11lLJeG7wQn9jzmnOn6Cq7l52jjvDfiY2z1WsFxN1j2d66S?=
 =?us-ascii?Q?ljeQYWI/hrZ3mHMgG/bL42tpRAxBBa+K9VA1KV812Ozntw21Rua2kIHzXy6z?=
 =?us-ascii?Q?XvZND8xSbUSHUMqKP6sDDXwb9rpKUxGXHIaWPzUy9EREKkL3X5tOCETM3rWi?=
 =?us-ascii?Q?tCvIBNfdK6JbSahxtPACedNZyTcmwpUnck80aJ43TsTqLzhtyUSr1ZacKRbM?=
 =?us-ascii?Q?JoWu2Rr1Jc8OJq25d3ORlMUDEmvl9ukJnlWtIBp4PdG+zCDUrxbVHhEuVt0L?=
 =?us-ascii?Q?nlroQRt/8sg9csd5E4FJ/ffMglOS88arteXVnXuz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?DgBhDAevOrSr+6CgS60bUXs421N/CZfeIVLljtb7X8mwAM1XcUhr02DB/h3M?=
 =?us-ascii?Q?DKmgn3GDOQ9gVOC6ffrGZgWzYpbMRqI6kPxP9WZVD7YlgqlZwQjSjvzE7k0G?=
 =?us-ascii?Q?aXQ5rVq1FvIKredsmQNG/HySLyfiDopiDvfXBQ2oK2EKnHuTYIdDMLgDsYdK?=
 =?us-ascii?Q?uMI8rH/B159hx1wg9o1ytk0SEb9nsKgQ6ZnMjZ0o11RUJ2kKBo73KI0cEwkV?=
 =?us-ascii?Q?2mrCfAkeWe0CgZnT2O0XMRY8LEr3szz1y1L7w5dqJiiD59bTQ6ggqnzEF+P4?=
 =?us-ascii?Q?FKj7HB88WKSiwKj2emogWMP/uK6jo4m7ZoD6SERs7NfecWoSoH0653ZS2vZd?=
 =?us-ascii?Q?7Gmz3ib48ss+GYM7VowqRmAMC4ehI6Z7m3owh4w7BYxy1JMb/63D2ek+hW1i?=
 =?us-ascii?Q?qvF3zLFThvjoQJnnLt1mWCbHbgnUGGl2QRotY5JbIvCWn+DiD2Ti8KzLHlQt?=
 =?us-ascii?Q?CjW5tD08IJiXBdKEpGjUK0Te8LpQp1PN7dqdgZNfC5obyNB8o+T7DcOhMxJV?=
 =?us-ascii?Q?NH4+33cnqHMbOn2ZtCS6pcyfyoC7Na+9wEjrH6Pf/8TiTOytEnQSTtMxPHu5?=
 =?us-ascii?Q?fwQBhqaoqlxsW1K8Sfw//v549j7hML2e5P0JTiof3KgtnDobbsF0XgzoZImW?=
 =?us-ascii?Q?6WhlxScV4JLUwO1pSw3v2ViM5Hx1YcFweS7NBI/sV7LM1l7zBeZfBbmVKBz1?=
 =?us-ascii?Q?kpAXlIQdp4Ld9R9gu2ETojOIImD2LO1TzXGdX7z7eoxh23AxUxu7evr925RS?=
 =?us-ascii?Q?1rqOl6PxeuxdsX748UxUOsHMScHh+Esj5rTMHaNutuchEtb+ho213na94dQq?=
 =?us-ascii?Q?RPmLU+1RoORJBP/FIWb3GK0nhcq+fJZRmLXrHhDbErZiiuLurXmqh07+19rj?=
 =?us-ascii?Q?6vtbCizDk8EZpMMTa4HPupBL8NA3aqGoG2LU+RHVMIeFVZZ/Lr5sTLHZb6cp?=
 =?us-ascii?Q?u7pS+fTAIKZ479SgeawocQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c633ce-1145-4d14-66e6-08dbc2c6f3f6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2023 21:39:55.7958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYOiOTKlcpEIvVzDG+LjuBkSmhtmXGWrkwGGsm1vC72f9csyCByu096W8CZxNqDN+yXaYOjM+BV+6OvPEefcNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-01_18,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310010174
X-Proofpoint-GUID: a7yzKAR8WWfZFUx_4J9ZqcsqEUsXzF07
X-Proofpoint-ORIG-GUID: a7yzKAR8WWfZFUx_4J9ZqcsqEUsXzF07
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'kvmclock_periodic_sync' is a readonly param that cannot change after
bootup.

The kvm_arch_vcpu_postcreate() is not going to schedule the
kvmclock_sync_work if kvmclock_periodic_sync == false.

As a result, the "if (!kvmclock_periodic_sync)" can never be true if the
kvmclock_sync_work = kvmclock_sync_fn() is scheduled.

Inspired by: https://lore.kernel.org/kvm/a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com/
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/x86.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..38fd04a286c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3290,9 +3290,6 @@ static void kvmclock_sync_fn(struct work_struct *work)
 					   kvmclock_sync_work);
 	struct kvm *kvm = container_of(ka, struct kvm, arch);
 
-	if (!kvmclock_periodic_sync)
-		return;
-
 	schedule_delayed_work(&kvm->arch.kvmclock_update_work, 0);
 	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
 					KVMCLOCK_SYNC_PERIOD);
-- 
2.34.1

