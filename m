Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF38E3AF779
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 23:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhFUVgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 17:36:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41592 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230331AbhFUVgH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 17:36:07 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LLW4LK028690;
        Mon, 21 Jun 2021 21:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=pUgbX3Xw1hY3+q4OPZr4Q47SwQXfJDH4wrFqMCFitt8=;
 b=oIQiFUpSSVpG+hjYNQXkNB+IMsdG0/8T35roevZi/Kkm+3JD4n/0qPXhEWZgr8Oq8yBW
 97UyCCSnaI2w60fgUZu2WCC8LwMCjUAFDMuVTKsFpWArCs3rBi8EKdCyuXapJc0H6kvP
 9Qn2apQjodpjz5ge1bT42V4GsbW/sVKmkr051dnJka1uGRLUe8guHk5zVD3TH/fD+6KH
 lcC8inQGWszUDPLEjlkA5YrPH3gAzpebxltiHsERQOhsUxAuRckkDTPooUMzPGwQ000U
 b1xuYADk75IlYYgSCaWQNIL0gfw0Rp3CrlmHrP+AfE/ZOHGBwoMnMGAv6Cw79RXpLZ9C Gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39a68y2mu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 21:33:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15LLFO7B011182;
        Mon, 21 Jun 2021 21:33:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 3998d6efup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 21:33:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmFRafxmQalO+MlEEQz08al7H945j0xoO4DV1QY1CeqPt68cYFDvX5Z447r1RgteXFKAgZOS4vQxhFcA4obMZ3DEqyqq4Ya//XYWbUAl0YpQd0QYO6e8HLO3RHPP1BtKh4Y45V+lU1tO3260hkLzNLiQu23uoYQODlk6d3vEkbOw/PvUA0iQj178hxX+XcSq9X5WX83ojWE+XhoeLS3RKm2CE7vjOeMR5+IOSCaXdC79vSWZnTWUgHmlWdX3f9alI18yvVxHFZvwr2OzierXYGCWkYXnw8HxIw1tIxRWdmZZsZhLEW2pU9hPBrYfSvA1kEkARw9s0oSG33DvSaThdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUgbX3Xw1hY3+q4OPZr4Q47SwQXfJDH4wrFqMCFitt8=;
 b=BaPMSqLCpSe18ZsoNrlKLYf8hylS+awZOxa9UDHFXFOAu8zt6GeuPyD6emAOJP2urVNIvUvPoq/DaBe2tduGNSBrmsTsHDqp6r364Oi20NqoliSw/w38v6SOFD92VVpTww7qcgMOipG43d/CIPITe9uBJvWkKI/8FR99iZ8g35ULk+wu5MLxRWPNcrK8PYnmBp2SAWyD6fPp4xySngbPDVyPYWM0iYQ4+/bsxKhPjpY6uRU3DGLW18nkZ34MrjbTT4DxbTSykBCmF8l65YVHzHx7Wknl689JgqFGHYmfx4uhlYj/ptYTQI/y2xM2Z6qNZVSb1FyQbZCGVMQC4tQDlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUgbX3Xw1hY3+q4OPZr4Q47SwQXfJDH4wrFqMCFitt8=;
 b=HhLnhhuYtRvsCuxBMrhIfXg2tCuq9FXRYA+AOTqA1iV9+535XwNbK3g/ZVhrJtwcqP9X/M/VWJAgg578etvp5dJinaQtPdfXdoTWdKaUdECg9BKzBdzIUKBkvNXDViyaAsxhDaQIOtpCIgHnpfa01iT8F7dtva0ZOhpeMlEmHQw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3453.namprd10.prod.outlook.com (2603:10b6:805:db::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.22; Mon, 21 Jun
 2021 21:33:22 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 21:33:22 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit} tracepoints
Date:   Mon, 21 Jun 2021 16:43:44 -0400
Message-Id: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SN7PR04CA0186.namprd04.prod.outlook.com
 (2603:10b6:806:126::11) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN7PR04CA0186.namprd04.prod.outlook.com (2603:10b6:806:126::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Mon, 21 Jun 2021 21:33:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 948effa0-b95c-46dd-f6cc-08d934fc3198
X-MS-TrafficTypeDiagnostic: SN6PR10MB3453:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3453EB9573A6A45C681D3FFA810A9@SN6PR10MB3453.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C99IXP2ilCK47buOsFHFjtk/wwrvPcPomk6x3XW4O24X0J3P7Q72hzU/7xFsfoA1iQJQfanqz0uODo0pL4BR4BzFN7jof2CJxMbGRjhdXXwtf0+W4hbRjpjeel3rNwg03qCGGcsvsl9TdIGnIltFnOw+YlNDu2l0nYSc84vy+40IWR9ITjBAdn7IRP4PKhIGRNX6FwZKM8dbCrlXb/dMdM1eMeNO8vNw2T1M9JRf9lazaRDeEXLviedTaViGcqQUKJ+WoF7DF9/TGzK3H8uCfGrwPYJ8ROOEashmEayVdEsFwKIF40nL0WRAqnZnV0ewoZWy+VJgf+QFRiEXqidYsZ7Fl6hROMYeJzaVRXsvp2n3Q7rL1AHr4ZPbwnnAKsIe5QP7fyzHjYUletWeQJ7tZL72/0n8NlvCrJyfgfk9FL9mhc1RyrLUTMx3aqe34wFcZlKPt7Ll4/jZxDK3URNrdPyE6GtdFrIpGdtWuPpFqV9DD9LFeULeDtu39XbuAQdKwjzWRT9KmAL7AxEWPYxgihu7LDz8Ex9jVN/pG+CG/v3YRWn7wE+EdnD/MtjSmjC5lt8BiQh7G35Xo3MQXiK5QQzbn/oHzk3b3LSvD3jTZCE3DPIxs/OvjUWzfhUJNlKlsDDqT90Bcoaqwl5PAuW14A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(366004)(136003)(376002)(2906002)(86362001)(6486002)(16526019)(8676002)(478600001)(6666004)(5660300002)(66556008)(52116002)(26005)(7696005)(38100700002)(186003)(66946007)(38350700002)(66476007)(2616005)(4326008)(8936002)(36756003)(1076003)(558084003)(6916009)(316002)(956004)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bIdahKyc2FxHJioC9Y7k5gL/zNsqxHd2Gmdyp4LZexLgGVtu9F8frefQ+Y7b?=
 =?us-ascii?Q?/Nk5fpepSOQTywJ9U69Mz511A74vXmKA2AADDwBF0zPyK3iqhxutWmGjFqG3?=
 =?us-ascii?Q?4KSeyVKD62/iXInwmHn3wogW1KenjspkBgN2bRn63zoY2yRv4aKREv0GF6Rt?=
 =?us-ascii?Q?wfDKNuvcggtlbMFvqGzf1BWedjKCRiJRnYaA+5ka27hBn+XnM+V00WLdFJ2L?=
 =?us-ascii?Q?ilvs7GmrJJ2F3HNIdfm0nw6p8/u9xx0OUwDWz42NRXDZ0Pr+Tmp20FdckBA8?=
 =?us-ascii?Q?kFusOq0kGo3yIlQ81Zs93bhay6EALpcJ87rmHFT4YMnNl4zKuw5lTT/YHxI0?=
 =?us-ascii?Q?6ew4ilOmDcW/v8vtLX6j5MzYZ+/7z5fhTvyYve8b/9+IPcXkLRO1aF/+Ve9G?=
 =?us-ascii?Q?8a2IA0KpS6cu7DNuDz23pwT2RrPYTzwSPBLJm1ohT52M2XfICMgsOtlz74xw?=
 =?us-ascii?Q?ExjeS/xxVZd6MNpJyGgIf4qCCiPtCGWv56aL6xF2ggteVTH7hnTaIgRA41aC?=
 =?us-ascii?Q?eJvEpjnZ3kasLbXpGpGA5V7JeQMcHzscCEi5/BZySmo+bgvrPjL4b0W0Rj8e?=
 =?us-ascii?Q?6Ws/Qa+5d0m9OYYRcnVBQplmCNTJzJybxHM11hjAeRHLtaVREFGDFRmjT2vw?=
 =?us-ascii?Q?EbnO4H8zTo+wpRYe2Y1luKmV0Oe51zn5MF+WdZ73GDrM1rKjycGjt7lYg1Rh?=
 =?us-ascii?Q?flhxicA6W46CRUVrnIEuVBNYnS3MC/hP5SMPPrTE79lbBTIVJfDdGorBY43U?=
 =?us-ascii?Q?7hCWuRe7EFoxBXoODHiLC9dmDiC8/r8yt37jZy5NBT7p4GXqYXwa1rPDh8aJ?=
 =?us-ascii?Q?eBtsCVPAzK9OYQJc2EZpkSVJq98ajsyrHxT+1oeCHcRbnCH7x3r+TbUyJTbr?=
 =?us-ascii?Q?SSKv/OFU/Cer+0fHZZF+JCsQc/WVwYYYYHSRTqe9uVnqNr/lbX1E09jXa3nW?=
 =?us-ascii?Q?eaHh3aIUT8oCJ1WFRe8eTTsqJsh3WPAatJ4kRr/jCQDNeBM5otCL8uLeytw0?=
 =?us-ascii?Q?X2FVUXzcG6EiKEEtRfzXLZqk/aj9+CDN5+t+Bb2UwDizUOtS+ZWtzCKs24mZ?=
 =?us-ascii?Q?hTHDegOTxg0jLS0rMSes1gYKM72uEgb+eWcrq6gTiElfGnVwt57fKGul2K+p?=
 =?us-ascii?Q?pd9wT7t5CBCJ58K6w/6frbbst16z1Am4tGZZJRzD3xa1OzgItlXXuTHrPKQK?=
 =?us-ascii?Q?PFc6Ex1WNJpfD2AroTNfl+1D5m5lvIG9p+jzibO3ZpeYOepf0yPaROuGw9I8?=
 =?us-ascii?Q?68xAZZldHcKTzMPuUlyrcLX3W/PqFottOwpNCxbT76JIbEjiWlvhzz06hddh?=
 =?us-ascii?Q?ODbprwzVf9IxTnj7zhZOunsW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948effa0-b95c-46dd-f6cc-08d934fc3198
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 21:33:22.0265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rm0iAsK41DLplhluMQ7LsYNxn6XC11OTuqPA1EpWE1rHOzuWNmBS8hu63//p3QgPZ5I2gbrl4ZLcDbYUXZlJJvifIVKHtEOvKbLkIWDDOh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3453
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10022 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=810 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106210125
X-Proofpoint-ORIG-GUID: hG3fCyVDeQqhmyY2Lg_UdJoKUm0Luw_b
X-Proofpoint-GUID: hG3fCyVDeQqhmyY2Lg_UdJoKUm0Luw_b
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit} tracepoints

 arch/x86/kvm/trace.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Krish Sadhukhan (1):
      KVM: x86: Show guest mode in kvm_{entry,exit} tracepoints

