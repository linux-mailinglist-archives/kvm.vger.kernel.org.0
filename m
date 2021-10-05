Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7B24234FB
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 02:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhJFAbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 20:31:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12276 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236909AbhJFAbN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 20:31:13 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1960Otrj022641;
        Wed, 6 Oct 2021 00:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8OUDivESge3zhc3uClVm5XkmFkBc6tB7iemegtCVHHw=;
 b=FXGCYSCCBdd229GiMPiD7Ec3dnry+ohpbcAUGzcYohqiVyAdZ8F5wC0jqIVApmijtPtT
 3iUI5tFsIwiz+sqCRv+qAcIz4exdYg28zsMGYDoU8NzTODdvgm8oJ2oHO1pwhkVlTTN8
 CMtrc6NJkkz1Gwq/6iF7IBYzLlHNC3tqXeMWMcresa/c3+at5xa1hTrESPsg+VxHEzot
 qFdzqJZQ1iv6KMrxFEqpFyC9ezkhWgkTgE1Y5h9MqDvcEUc/7pE+9x+NFJRFE5zdCy7j
 h5kUWwgP/r9XACj4OwMLGN7Nb/XSwuNshLwgan+Z8lrxYIPrJpMVViwPrXA2epD/xDy4 Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg454m5eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 00:29:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1960AKeP144842;
        Wed, 6 Oct 2021 00:29:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3bev8xjfjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 00:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ng1v7JYI3BZyozVltBP5rJiDFao8VWolJCA2syeL0ZnUYKD4amyo0YkDFC5bhsWfSHrl1Zi2ITQH+0STxZjRnDbBxrQzFLPCRz5y1SNW+f1ywLI+cGPA8MD3WyOR9+pS5sAlHmZYfrj89ZiZN2XhI87VC5f2n1oddUplJqHFS9UpVEwLPm6Qck6vKgRCZu644PR+7YLwRwItz89YxVmt4U89MLQVyBqgT5f1s4IsdwsDAr1L9i6TT1JKMUpW0Eetp6u5QbyLEekWhAmhBicnjjo2sVBHlsA1YEs3rP16jblXiJkKecpam+7zVtaX8cFRdA5Qwd/Y7Fldt2RAB+E96Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OUDivESge3zhc3uClVm5XkmFkBc6tB7iemegtCVHHw=;
 b=gprcUpUYzOBE7yVioimKhW+dMy2XX+KWl6u43S/4c7MfDrkY+SfYBlmGIpzrSPiGWflBwwNApDVOCXtWF/V1nWiQr2C8Ard/XMpWLR381R5KwfbrsLeTPECxcjWa04y/uOHxRd+SJZUqHjUOXUZ4GGSEdAlg5P23gzIuI2SbzoAW71mj7uCqw3bv/z6Gw/CrP8xNJqzhjJ0G3IhAw9nHSmWACUZ3atlnVMVV6tSVN26XmcHoDb+vcgHHaMBWcBQ+Eyb8Hu16iUO07N31NilDtk5tOtkhprlZ3xS2cnUTZYRA1EvRoZrYzc04pEqIuXUpfnagXUc3sWnj+D5bEHxjRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OUDivESge3zhc3uClVm5XkmFkBc6tB7iemegtCVHHw=;
 b=PCA18hRlmYNFDcxUr2IcujvRM7Z2clMKp1rKdn6IqV4SAL7kbpLsezSA96ARGwaaoQ4FFP1X+Gb7UrLlCmFwYXR6Koi7p6j6XUKDXtfHVmxkmDh+KZ7BmaZLnGCRKsrRL0kXFgP8nT5eC5siDANOLvRqO6aOVw1JqcRPDvrsf48=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA1PR10MB5512.namprd10.prod.outlook.com (2603:10b6:806:1e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 00:29:18 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 00:29:17 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [TEST PATCH 0/1 v2] KVM: selftests: Add a test case for debugfs directory 
Date:   Tue,  5 Oct 2021 19:34:54 -0400
Message-Id: <20211005233455.127354-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0007.prod.exchangelabs.com (2603:10b6:805:b6::20)
 To SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN6PR01CA0007.prod.exchangelabs.com (2603:10b6:805:b6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Wed, 6 Oct 2021 00:29:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 544a0898-d244-4427-016e-08d988605532
X-MS-TrafficTypeDiagnostic: SA1PR10MB5512:
X-Microsoft-Antispam-PRVS: <SA1PR10MB5512544459768E7661ECC98681B09@SA1PR10MB5512.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ssap0oOTtfjPL9zLU8y8prJa5BsaUSijBxifukUln9ZQPFqhkPpOyxvJIejEL01O3THw5UUhiv+mC2cH2ZNDmkTOJ0W1QqdPwA2cLtWyIkg7SKbA1bDkZ5E/tl/e8f+OkIeB2M1K1UohreSqYk+mrIJgD3kBmH65v2BH+k5siBNhI9sG7XvvXzze59wAbcs5quGmMdbxrsKfh8pGCtEN/y7fgVjLqvJKoFV5dvKbbnslTComeBkmOZ2VGWaCq6n20q4fUgquEJzf7GQqSwnVF7pMU5AUlzPXBCWqMQNnoELEnkDtSrTGRtKx92hixG0UotLWcbA2fjjnTi4NRUL1QnZb24GMG8xz0p67ij1PrMT43PNYsAic/O95u8hYtKR4uDGB63xmNUB834genSx9u7D77Ze401YRFGkLqDOq4/d5Zsday2PVcievN67eEjYYrOZe72x6hJulwpyIsHWQwuACSqH4m4wGgrTc3spyzagBn0CLSQ+1/dDxE43PTC/kP+fQvYVHbRfPbN0jI4NuVeg56ujd2emsJGcUnWPE7hBMJ4gFktLkWzAkWnIqhC9UPA2Lhvo8cnynM3M5Hd+sGtIyMUqbEVwK372WHV4rWOdBvU15cQyLXGxwRZeYAT4bO/CagyBVsB6YlP/0aMxOe9BGq/NwgPC03ciFnYZwCiE7BFvtcXk9otS6Lx6rFPnz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(8676002)(1076003)(66946007)(66556008)(66476007)(44832011)(83380400001)(2906002)(5660300002)(86362001)(6666004)(4744005)(6486002)(2616005)(956004)(38100700002)(26005)(38350700002)(4743002)(6916009)(36756003)(7696005)(4326008)(8936002)(52116002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yx1bcpnXOR0r0K27VgYdvjk9+izXCa3898RvbNIonfp0mwwzUNKu+MSE6s8T?=
 =?us-ascii?Q?Nd6FGBQCkHBSWaZowE0kwb6LfCYyfLbDz1uBF9LWGH0I+OsFEQMGRB2DPGBK?=
 =?us-ascii?Q?vU/+eKHhA4DDEw6SrcjhpU9dsRmG+BBzvjytqMG341CByMUcK1CtzJeiC+VI?=
 =?us-ascii?Q?h+b/h5NbDouNdpSfZniITTknaGEgH6MQh1NdOgR7X9n6iR7VZOF6bp2qpf66?=
 =?us-ascii?Q?ZdvZYKNAUB0/K4Dak3JrlVaiJTEjQiOqVWgXI/9oD4cYGuBWmZsaO00X8A24?=
 =?us-ascii?Q?mX0RJLO+CegpKTpApLUkBZhQTSY0lP8jBpdvHcios/x3CDmx6Hnxxv/j5gZk?=
 =?us-ascii?Q?OOiOyiFKGwlxHHP4C4kmyKeX8jljKdI+jxW7NK9SSv5xlKRAeC8fAbAaHo9l?=
 =?us-ascii?Q?LVOtlMQ+4NVAM7/JoRHBqRpVYbZaHNQAUSXsqPKQ6yG7p+9rQYRB1e3nO+9j?=
 =?us-ascii?Q?DbizAyWSv/whXFth0I1WAwVq805vsh5qK1VBIhPjvsJBvqclbTwYhoih2wgr?=
 =?us-ascii?Q?3mTSdvZESfz7sqkoCFZv6jVF7V26ihv7XLJKCywjWp/qiFu4WmCAxGGTdSO2?=
 =?us-ascii?Q?PsFHzlcuvCgqb0wNFYcDhv9fuX0QcrAx7GpAzZh291kQAuEGvUFNFRy65I4Y?=
 =?us-ascii?Q?TxR1cB3rVAdgnLGnF12pYJCBxg4ve4PITNpe+1HzngUz8rZuZ9/2u/pxLQ8l?=
 =?us-ascii?Q?wzGlKbGQ3ucvQnBahwctfU/OAnslrsL1PDkZetV8OBpwDVsjznoFgjKOSQFq?=
 =?us-ascii?Q?LFbgZwLg7mjFy3k1qSRHN4mbpZpB4fQGUEoVctQrnnNSUbfpokBeHKtfNopQ?=
 =?us-ascii?Q?Mql4RaO4owssymIqHZn0S1tb8cgSsGViDT/itEGtuN17k/6WEe++OxeYdiIB?=
 =?us-ascii?Q?sOqQ6VvJKcEXn+/87A8MWk5Umlec68Be/6/kAFb1hscizGhoj1Fm7lqf2ENB?=
 =?us-ascii?Q?RCgK9krEvHsacWfEiZapitzoHbJ5p06BBMJBLsj0GNWxaVjI3cuDFTQwPeLd?=
 =?us-ascii?Q?3rpfxZbs3pDPYGNC6Fx+76L5W+lptFuz5mbGsbSsEZWcET9x0HyA56z/wNDG?=
 =?us-ascii?Q?C9UgpEG2apDL6NTlMZKoXyhg9W6aqOMDr45Z3v18ea8QoC4JvdbXiY7zt5k8?=
 =?us-ascii?Q?EbHT1/67FoP2+DQpVDMsXBhLas5F1fMlRVC6k9s4TFPvSdTPXwa4aw9TumGy?=
 =?us-ascii?Q?Rnvd3GH5PZ22mHtWh3EeKnJWGTT3Jn96kbyIhslRhXqya/iISUN5sMNz74Vg?=
 =?us-ascii?Q?lI/dFe11JI3++Nvgau3a/1z3nrqLxeDq/sdvvxRKlNn5WBrcfzya5D9MpcEE?=
 =?us-ascii?Q?L8FDmoNqMrXkZlD6VB+xFK0n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 544a0898-d244-4427-016e-08d988605532
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 00:29:17.9023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExC27vwjWlWpmrahpKCromq2XKb9SwD5Q3MrKlWqus6EE2A/wwDN4SU96Sf4oPe7Elbi8vNeRNZx9XBsoKMfHeWFST0Y6cl4Lv1VvS5acSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5512
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060000
X-Proofpoint-GUID: HqGeyLuMizrSYzqaZNX4HVMwqnm2SbWE
X-Proofpoint-ORIG-GUID: HqGeyLuMizrSYzqaZNX4HVMwqnm2SbWE
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	tools/testing/selftests/kvm/.gitignore updated to reflect the
	new name.


[TEST PATCH 1/1 v2] x86: Add a test case for debugfs directory

 tools/testing/selftests/kvm/.gitignore             |  2 +-
 tools/testing/selftests/kvm/Makefile               |  6 ++--
 tools/testing/selftests/kvm/include/test_util.h    |  2 ++
 .../{kvm_binary_stats_test.c => kvm_stats_test.c}  | 32 ++++++++++++++++++++++
 4 files changed, 38 insertions(+), 4 deletions(-)

Krish Sadhukhan (1):
      x86: Add a test case for debugfs directory

