Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8223435D35D
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244727AbhDLWpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:45:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56768 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbhDLWpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:45:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMdhOb017999;
        Mon, 12 Apr 2021 22:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YGXCCLw7OFf7O/CtEm69QSDmw5u4ixNLwGc7y5OQFDI=;
 b=wCmOfs5uDCP24XGdyGcZ1ukEY0pxxQ6UUD43Wn4P/f82Zxa6KHXzkBikRC1Vp7/3UxfP
 SY20F6IGkW60ypjFb5IUDUwWyDhkBspnKu6ZSmVPQxzMpH3NtoHt0lm7HECti5ERmdX7
 MTufDzuEoeJ0XiFHBy4MzTgMwGhRP2sFLbwr6qOpaVJpdO1r3T6MzDCXKFfIz75lvmPq
 zlsXFyOzUf7mYxG5VVhHJnqdzagsEj6RtRSPna6yNv74YWp3DBNQQwTRBySXAP+br/lg
 w5GjfshkJ4FlEjSVvkJ2bYMlsYAUT1ccPL//cRX2mS8Pv/VgfCVTe5TbaHVkrSBW75MM Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37u1hbde1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMeLjO153578;
        Mon, 12 Apr 2021 22:45:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37unxw0q5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsXC7XaoVDib2w2et5mKvJ8FigRxB87iQAOaBMwTetZY4Yqi7J0Jp6MZ82m5AdbLcrZrfupa7UASR49UeCj64L23IFfr553MSEANgbOjQC7NAI82VLwRIZzMXm6iKiZo6PsFR02tnFkt3jUF2rzMBE2CEEKi2qRzAUD30kCkU3QRuOUJUo9jYgUUjOhdXdYl4/vO/rhDdg1Lc8CgNsq5nVdjmZxmUvJu6DibjLAFiVbPRGVZeWuIjYpNkgCIbU3DMKwyiZ25fLmfvYg0LpOFUeF2vamUU+SXcmXrcOQhT9nslcLMBvzFX+ct8Mq56eHm6bHfW4nStv8SF8obfeBTyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGXCCLw7OFf7O/CtEm69QSDmw5u4ixNLwGc7y5OQFDI=;
 b=CtuiTePQos2LWJbYXn/2oU4YDT94K4Dg/wZbqOWlFifPLlYY3LSGVrcNHuafqBQ76872YP8MSvJ4rFKH2z6SsAP10D3whJ6hLoqJEneMUTrTTGFzUVyDThU1Rmrq784rWlGoKHfZCni/LGqLC1w6+rBWBkceK5vZIXWI/NwfUCOk3RuGLKw3DsO2EffoUEUm7x6d5K0gEurx8wuBlZZoXiD/WUb+pQ9+f8eb5csTGcUWomBiqrd8IMEkpphpJSpEEqtA61S6CYhZdW9R6nk5JAMsfU9NcDY9WDI3CzG36YoOVh29RqG96pzBfANc9kwzhsPa1YZLZ9qy17Wh1gYQhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGXCCLw7OFf7O/CtEm69QSDmw5u4ixNLwGc7y5OQFDI=;
 b=0AF3CZKDp3TFMLO8p6/0gqDW7pguk84IepP5MyrCuM9f6TZ7SQ8XffTaVArgwD+qPgcFv18Y4Y2ftrUmVb6Iio7PGFH3dqjwz1W2U+dyY5kzATUzFykQdoBCvuxrSSMJUDfLKfPrtMyInxY//PRQVvHRw5qoW/qXmE1r0uUYh8w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 12 Apr
 2021 22:44:58 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:44:58 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/7 v7] KVM: nSVM: Check addresses of MSR bitmap and IO bitmap tables on vmrun of nested guests
Date:   Mon, 12 Apr 2021 17:56:04 -0400
Message-Id: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR06CA0058.namprd06.prod.outlook.com (2603:10b6:a03:14b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:44:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63802c67-863e-445a-558c-08d8fe0499b7
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:
X-Microsoft-Antispam-PRVS: <SN6PR10MB30220956799411B1F8E0737A81709@SN6PR10MB3022.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: egJHEC4aIQAzjODUdGq1nVYuJ2O6uFi1ZYdaTxjgVizFzNakkQqy6xX9NGCBA3ISz2sYCo+wqVVl0Hs6h7D8SN7sulyWMlhQxqaY5cTqQUXkw/dmqjELjWcSeIepbPuZuKDsnWev99Qq5oeo6tMnGG+0Sc2kcxaUlWWwR06Jh16V1T0o36+L1KRgZHfQR1jBFNic0GKppczhxBPc9B4/OVNU7DLhdeyVwrNmhGSPha7BUOKuJhH4xjHqz3tiPuGVGEV+V9ZKYb67opAhMilA2hEpI8dv+RFbX6SEANxBSDfj3DxiURBeiXVR99AelvI9Eiu8yi3Wb1FkIKjiazIyLd1lbHTSTez0H853+z4L0hWrEy7aYssQpDhSPy4poOZ1YI0/wdSWVagLauIpkWM5fOb6fEoAdWPGBUIxvSxyq1BywjbljAtAy2Qs9Jjo2rbvgvHW6a7s8NzS2Tzd8lD287mxlitSty1VHVGcb+zRMfVWxU3TuGXlRgXDC9btD81ua7LzEalXDOPvdTwksCTxyRSbDHP/ULyim3EGe8fm5wRIn+AyKqmMv0uqdqQQbOcq/wDwdtnKcbeAgFiFE0T8L65EIbvzrJqpDT+zhYmt9CQNjqXo+X7UNf5LSr1Jvf8yhWyIzT6OMseXvGokwUdzyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(39860400002)(136003)(66476007)(478600001)(66556008)(83380400001)(2616005)(66946007)(36756003)(86362001)(8936002)(1076003)(44832011)(6916009)(316002)(4326008)(956004)(2906002)(7696005)(6486002)(52116002)(38350700002)(6666004)(8676002)(16526019)(5660300002)(26005)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uRkMB7iko7e5DyEmzzNsHxX0V5F+gvQzBiODFmC7DG8dp38KlplSYjXzlyef?=
 =?us-ascii?Q?qxi/XwmtEl/Omk/kctc5SNcolpvdxtI/Bma9J+h3PbnVwJVB4FRmOCInTPEV?=
 =?us-ascii?Q?DO9REeC2VYIkTLLkbJovrPRKMwHKYVhRlqAE3++mtf0LtjEraSHUikyV8AxC?=
 =?us-ascii?Q?h4pxd18VS275oM+OxR0wStdRiL2C2EjOjYwYEAI5sSfxdA8kA5mV4mYutPAn?=
 =?us-ascii?Q?xCuwZqCs+U4+lpGAGHuVraFQs6xtYRBr30iWkZzzN2Xt6oL3fOi6ObB7DLqR?=
 =?us-ascii?Q?+VMvocY1LUScDgkfw/O49sJ1yh2o4bSSdeXOcXbqxGgFLRcM2cVHD9GKifJl?=
 =?us-ascii?Q?qSkjok4hgyLW3ZGbVZsD2kOuIniPk4QGgFRAiMGkaygjapCVhmxOYzsL5SHq?=
 =?us-ascii?Q?MRnDpwoPd74OuiT+SrCz68m7E30fpPLlX10iTH4viOJe3KKarvvfePBR11Z4?=
 =?us-ascii?Q?vQyF9d0M59sVEgQZF8/8/Od/bkFbHYVtzzGCBklgKXdOmG0ZcT0VaPf3asyN?=
 =?us-ascii?Q?ACGphfZRfZ2Ii7unfKB0orrdUSpUJTCW0+zR5o/N/44ztxpEgVuFnWQVoxDN?=
 =?us-ascii?Q?pDi+Uj6Zk8zZ3BSg5NxtIue01L2m4JDYcJJWWiLuG6qwGXBPOvE4T41EXRml?=
 =?us-ascii?Q?MCWiiJWrvyAB70AgeOaQWHcQwf/b99zyFKgQlDWKJBKHCYKdRuWHUv1ZVBBK?=
 =?us-ascii?Q?YbGd/HiPs99xB3IQ/45seYHEWZg9tbbOda9Pq81LOAgee561Y/Y7LK8pZk5D?=
 =?us-ascii?Q?ifX1YoOZyDPeK676Fjj5sbbjKbrJHy1e/4Yee2VHpo52bC1hukc5NMNMS3W4?=
 =?us-ascii?Q?zuOskOHEUDgwh/Z4hrRvFj5aNSRKOb41hxKt+TG1LHWhoMHV8bJcgRKjapPk?=
 =?us-ascii?Q?O/it4yGK1YEvq7aaurlTnBEJM9f7CDogomddPBTRYwsQH65pjL3Edk3zpgKY?=
 =?us-ascii?Q?MPn4LR/77pW9cG+Zo6YnXa6U1ojgBMvbbKUXJGZ0nTVZW+BNESAnYmu2CElM?=
 =?us-ascii?Q?KR5c/1zlmTr9oNKYn5YswmM+JAQvz0PX9xpqyUXT10H5kyz1ONIkeufYnXyr?=
 =?us-ascii?Q?dVIBBNlQV8Nkl+PSpLGn/nDEcyY6QPSWQ2xJ8ag+9xC2ljQQHGcIbR4bn9jM?=
 =?us-ascii?Q?zfbCvvEF2uO+QGXb+kSpkNxB17VcCpxawG5WCUjAhENeCblL8YQKehkAGHVe?=
 =?us-ascii?Q?m+yHIMthccDWskox0dgD5E1p6HHVKGq7AEOrRm8GzqUzKvDL+wTmzy4Qy6uz?=
 =?us-ascii?Q?vv/tSjDHWIwExTw54S7tMWSVysZ4FuPtQp0/L2gY3AvG+klgF+EQaXfPEijb?=
 =?us-ascii?Q?Z7WDFQp+O/qPHtfCtNwBVEXe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63802c67-863e-445a-558c-08d8fe0499b7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:44:58.7317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 465Q9BRZScDM5mNpYDVJqIVu25Z7CacVIp6b91Jh5Fs1eGWOZ4a71Vkg4WUpaV/V8gzC9SLfUuUvLLlxdCqOnTUbXlGEFlhW8eJyTC8PglE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120146
X-Proofpoint-GUID: zKy70qTvd-4xENiApMx_B_onl_LScGId
X-Proofpoint-ORIG-GUID: zKy70qTvd-4xENiApMx_B_onl_LScGId
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v6 -> v7:
	1. In patch# 4, the logic in nested_svm_check_bitmap_pa() has been
	   fixed. The size of IOPM passed to nested_svm_check_bitmap_pa() has
	   also been corrected. Indentation has been improved.
	2. In patch# 1, the names of the #defines have been changed.
	3. In patch# 2, a new exit code is defined to differentiate between
	   consistency failures and failures after switching to guest mode,
	   because tests need to know the exact failure instead of
	   SVM_EXIT_ERR. This exit code is similar to what nVMX does and
	   appears to be the best solution to differentiate the above-mentioned
	   error scenarios.
	4. In patch# 3, code that unset bit 11:0 of the MSRPm and IOPM tables,
	   has been removed because hardware doesn't care about the value
	   these bits. Also, tests need to verify hardware behavior. So if
	   these bits are unset, the checks in nested_svm_check_bitmap_pa()
	   do not work as expected.
	5. In patch# 7, additional test cases have been added.


[PATCH 1/7 v7] KVM: SVM: Define actual size of IOPM and MSRPM tables
[PATCH 2/7 v7] KVM: nSVM: Define an exit code to reflect consistency
[PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and IOPM
[PATCH 4/7 v7] nSVM: Check addresses of MSR and IO permission maps
[PATCH 5/7 v7] SVM: Use ALIGN macro when aligning 'io_bitmap_area'
[PATCH 6/7 v7] nSVM: Define an exit code to reflect consistency check
[PATCH 7/7 v7] nSVM: Test addresses of MSR and IO permissions maps

 arch/x86/include/uapi/asm/svm.h |  1 +
 arch/x86/kvm/svm/nested.c       | 29 +++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.c          | 20 ++++++++++----------
 arch/x86/kvm/svm/svm.h          |  3 +++
 4 files changed, 37 insertions(+), 16 deletions(-)

Krish Sadhukhan (4):
      KVM: SVM: Define actual size of IOPM and MSRPM tables
      KVM: nSVM: Define an exit code to reflect consistency check failure
      KVM: nSVM: No need to set bits 11:0 in MSRPM and IOPM bitmaps
      nSVM: Check addresses of MSR and IO permission maps

 x86/svm.c       |  2 +-
 x86/svm.h       |  1 +
 x86/svm_tests.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 79 insertions(+), 2 deletions(-)

Krish Sadhukhan (3):
      SVM: Use ALIGN macro when aligning 'io_bitmap_area'
      nSVM: Define an exit code to reflect consistency check failure
      nSVM: Test addresses of MSR and IO permissions maps

