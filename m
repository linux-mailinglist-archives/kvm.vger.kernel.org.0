Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04905352521
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 03:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhDBBdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 21:33:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33962 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbhDBBdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 21:33:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321V0GR002164;
        Fri, 2 Apr 2021 01:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=A9DrAPFRME0EFjpPvd3tD1m46PApLu8MrhvXyOLkS8s=;
 b=J0YJBMi6bfkm6a8EgXd1y5IO6bAf3c8iqH4o8LvilXknyB5AaY4tXuHn5VXihPN3+/Tw
 DQDvp48oV4SwpftxnZji5cGMgSHRRnn51EidxmXDSD40UJhJMqB4Bd1P7zn7U9pttdH3
 OcmT0ZVFqCktslJjiU45Lz2Z/OJs3lbBv8WpRnMjMwaR9mbNaLoa9gibwGJBDdOqM+TB
 AU5y6Kx0Ernuj8RIrI606o8cd7/uRbY/r4UK7X19SGRCiVRiTfPdgCOOvJcSwXcy1SSJ
 /LXuKMHm6YuJxN7MdGoh9tXdisUyB+7VwtbkvRj4e9x6RGEoN+DjlGvUsDHkK3TlNC/3 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37n2akkk5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321Uw7L018855;
        Fri, 2 Apr 2021 01:32:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3020.oracle.com with ESMTP id 37n2abyytf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBiqd+bB+ow6mZ96MM3TZMkKnJwVdfFz81df5e8dYOWGYo2HPXaD+9waa2RSUnMWZp30muYyZQbzO42KH6rVVngCmOMqlNuPo5h8XpieWIPn5GWYUmTC5vXr5zBUFDB23AecbH6xkWyI3+22rVDwF5OqsthwP3eBOWxbc7dnTwgRe+OOFmfiI7R8AuoaRk3r+yG9Lkt6dV6+I6w8d3Y4TR9W0cFVofF+tm3sfBbO6TZBikclJPNUTQ2AmwFNEHpRhIlgpP72ZFPLb2/UvNyWT1dXikmr9d5h8n74afacBgQ5nWcOhDwXvQUcu1e8xo+AAOCrxPcxSMj4XVbe+3f7/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9DrAPFRME0EFjpPvd3tD1m46PApLu8MrhvXyOLkS8s=;
 b=oI80pSwtzGM+qaGW5XbSM9fxajTU+22zXlCvTBycv6czvvC4Ls92uoFiUwfQDpAKPtkap2CB0yBavRI3NaozLTtHwZlss/FLOS+6LBSI4Wn86C9LusiiOE9+Tz/OJnrJlfeXw4pwb1pXSPAbxhNrPk7m9T9yMKIVjtrqc6lQANvG59GvlIn9sZYyf7cmxn0OATL6nL7R5mKzlkv7Iqo87GjzCKlnV5M2c1vfnh3Vk48O75PfJqL1bxU3w5E6TiqPeymgrWwmFn0HvQYDeRUcJ30d0kA1yE501vt+4wfOr1riqe+hza/j1+qE4jT4qa5RrlGZEgWwccpYk7I/OY3C5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9DrAPFRME0EFjpPvd3tD1m46PApLu8MrhvXyOLkS8s=;
 b=VIvKG1JC5h/w/rnalZcaEOqBjVFNakvuiBxlSbXS3KKL+CXYGnjJqAQIu8bJh6DR0ePXNnsP5ukqLzb17eL3xNkWAjH9a7r5G4VQ6+welrmvXMUCE3A9BxoMBrrp9om87OmfcVQAa67aiWkv5Ys1yRK+akYcolv3F9q6Lh/WHnA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 01:32:50 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 01:32:50 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/5 v6] KVM: nSVM: Check addresses of MSR bitmap and IO bitmap tables on vmrun of nested guests
Date:   Thu,  1 Apr 2021 20:43:26 -0400
Message-Id: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SJ0PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SJ0PR13CA0024.namprd13.prod.outlook.com (2603:10b6:a03:2c0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Fri, 2 Apr 2021 01:32:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bde9b43-911f-4fc3-a913-08d8f5773a79
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4795DAA2AE18686A56971041817A9@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 61eUQLrSMnw0X5NoEn2WMk+tkgCodU+HriKNDYPheyjpu3tICNEmq8PlwobwvVw6X1p0oJ4SW6dE38jyhp6vBiF1GICYrulYG74842C70YlNJzCqUCKrQnLV1ovqWQI5fkTAYKwZuNDxY5LDSV1uNt8aw8Iq9BXU56GinG6UTKe/3Tjhc8YcIC1o0FindE/G5zt/2agkXcWz7lc3IAoMm7opnOVyCnSy1bbAQ+vwN0muxQ9UffwI6Pb0q75KjXwi3vffL+EMxEQk7WvfAwpwVnQ0i1BA7YovDhwdPFU6SA4jMQ0Jd0J7hAvQx/MtnqP0yI5uNegsf0Am2CDGfMOYxWbfvcEH5P2ZNstMd3uaDHCA6x4LJazUHUV9YiQOSUD3Cz3Vba3T4dLQCyERZW950r3CsMHoq2q8d0fXVJSzwz7pKezLZx6L04gaEUmS4tg7GO9tRiNq3mb/a0Td0JoO127P32iKMqgSn3FJ69+RCRmJHHZstWXa5H6VT5d658faHdAchRyLE4viX4wKgIS47eA/HBIGjujeL+OuM5QUI/5zJVm48Sy51cya26/HQ8CeY1vPcpsFoFA3FFew690Fi7/0a/AdTJB/z68Fl0U0Cw21xKNsuMaQNkeBiEvJ5oMUcrZhXqJV8KAndfb9JskQ7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39860400002)(136003)(6666004)(26005)(36756003)(316002)(83380400001)(1076003)(66556008)(5660300002)(16526019)(66476007)(186003)(7696005)(6486002)(2616005)(44832011)(52116002)(956004)(8936002)(38100700001)(4744005)(8676002)(6916009)(2906002)(66946007)(86362001)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fFmz3bycadulDdDm77FaFJfv7/SyMEMkxXNclsS4LJSb0ytNwR9EWlniSUiK?=
 =?us-ascii?Q?znKoaBq1xogrz0JPkylemUF7fJXLEv4ACodAOO/7tmjcdpmXubiOi4/8cSnN?=
 =?us-ascii?Q?xV57V1QWgZJI9cTwJGLjf0oDrkQ6rjoz6QPJRYQIO+KJuSAdlrlUDegCgQnC?=
 =?us-ascii?Q?u5xmjbHXqlCbI3tOZvLe1SMj90gzqrm6AUJK9854n0SWxVTz+xevj5BJUKgL?=
 =?us-ascii?Q?nhj0ikFRN2zADT15xzx78rN4SYgXdt2y3usN9bHRRl7D8mKpuzxpI11NQDbW?=
 =?us-ascii?Q?nVHSCoz0QzCLf2zWuWfBP7LpQPADfKNcQJqZBjbOc0jwpgJVCA88msY2PWim?=
 =?us-ascii?Q?eRxpcBPGdFAm70JlXYkJKkQ7z9reU3U1uCuacgWLFjYf0pf17GSKKOAoXrq5?=
 =?us-ascii?Q?5IRvqyn5aV8xWuUJ2xtwF6KK1gj1Enj7eYkmbvjiuyxD0fWi/FXsctLQYr53?=
 =?us-ascii?Q?N5LxzuI9Vx0AW5cCUiTvkAnLKntON4he8+OlQuUX6yI+st9M8VJIfBtg3LiQ?=
 =?us-ascii?Q?tqOXOFs5oixLIC1S2l+HKAoQFLzc3E+KhiCh52/1pmWKaBcoHEu9tq/gSw0u?=
 =?us-ascii?Q?KZSjhe5QxgrOp93i/eiY/3s6BYp9Z1jbjPn94+XGauE2QfIUwaRWA3xtbFRr?=
 =?us-ascii?Q?Emo3GfFgklAGddXQMpMSrOoKxBqdUVQ8d8HasWHMYvABj19hR5WDxaZXHAdQ?=
 =?us-ascii?Q?7D52V44RNL7ABDCE+ryfiY8ZDs01rsHivqkmOFDHDHbPOZHL7GRBCcK/Ltqp?=
 =?us-ascii?Q?aP/FcbknPYPpVVbESbS6VgwESKF3S2VZX/EcQ13Q20XbewwyV0zhVqzZtmnX?=
 =?us-ascii?Q?VIU5kDP4LyTuwqSaw7hEyQGUYJHV67EzUNStxxMx84HB9UG3yVjYUu2kCq5C?=
 =?us-ascii?Q?x4M4zkHo9iZVgpkdgaTxMC48bvYRug0qlPo7WENtgDxkQv/gWy6V7f5ICzuV?=
 =?us-ascii?Q?nV/i9CsnVlQ5Tc878ELegEYJrcBMHFEjokx1kHhdHXWMnB9TyVDz99ZjHbeX?=
 =?us-ascii?Q?cchyoXefnEOJEf3GoBjSnnrwm473noVN2+YyS0oZGqAsUiRJ2cTd5pOWcwcs?=
 =?us-ascii?Q?Gwf66NYqIbolEBML7QX6si26opfnPuYUV75UdqvAYJHuuhEy5PMDAlWK/MSK?=
 =?us-ascii?Q?pYcv+p8tbObBAyDj8enYjIcNoSm8pDI0N11U8zL7zf03HDFAl/bjW/iIBkBv?=
 =?us-ascii?Q?KgnEk2Zku2HPOlVza9rVQb1PEFE4um0BBHuRIrRxXWOCqo9d0jwjpZ7kdQGl?=
 =?us-ascii?Q?7vOhnvZJizZpjStXHu80z9vRcmyZ+/Omkg2FIt/6GV/o+T0S8oiM3OHog2nf?=
 =?us-ascii?Q?9iO0E08/hVo8KPVUq6+CuaQB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bde9b43-911f-4fc3-a913-08d8f5773a79
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 01:32:50.7458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fic7n4QFmiRH4XYM6BIksdJUV3eoXaUCdwuVQCC408nnwE0qUBG3LzQMukF3jnQmGDjkadZS1mPRbmndg8fEizypbMYQ41ZyAaBTsp3quX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
X-Proofpoint-ORIG-GUID: rHDyIgTZUBQKVB7uHmn6sMzM-7UnWyV_
X-Proofpoint-GUID: rHDyIgTZUBQKVB7uHmn6sMzM-7UnWyV_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v5 -> v6:
	Rebased all patches.

[PATCH 1/5 v6] KVM: SVM: Define actual size of IOPM and MSRPM tables
[PATCH 2/5 v6] nSVM: Check addresses of MSR and IO permission maps
[PATCH 3/5 v6] KVM: nSVM: Cleanup in nested_svm_vmrun()
[PATCH 4/5 v6] nSVM: Test addresses of MSR and IO permissions maps
[PATCH 5/5 v6] SVM: Use ALIGN macro when aligning 'io_bitmap_area'

 arch/x86/kvm/svm/nested.c | 54 ++++++++++++++++++++++++++++++-----------------
 arch/x86/kvm/svm/svm.c    | 20 +++++++++---------
 arch/x86/kvm/svm/svm.h    |  3 +++
 3 files changed, 48 insertions(+), 29 deletions(-)

Krish Sadhukhan (3):
      KVM: SVM: Define actual size of IOPM and MSRPM tables
      nSVM: Check addresses of MSR and IO permission maps
      KVM: nSVM: Cleanup in nested_svm_vmrun()

 x86/svm.c       |  2 +-
 x86/svm_tests.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 2 deletions(-)

Krish Sadhukhan (2):
      nSVM: Test addresses of MSR and IO permissions maps
      SVM: Use ALIGN macro when aligning 'io_bitmap_area'

