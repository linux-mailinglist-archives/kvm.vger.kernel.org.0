Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C18B63FD14
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 01:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiLBAbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 19:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiLBAbR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 19:31:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949BE2F03C
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 16:26:56 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B20PFiu024873;
        Fri, 2 Dec 2022 00:26:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7hTQ0KulW8fHzyfyXunHYyE7lIpwH/xtHaTskd5eFAE=;
 b=BJgaAF7LrYkSJtrOXj+NFSa5JD/bynCqOL2abgw5IJ1G4NspxXJHl8nQtVdvNIhMAceh
 eAZVpfnNaNzAbxpLJm2XHY1Lp0y14SR2brS857YAAUKCoy+r9ptIytzLD2lOspQfAxqt
 YIoWIUyQEeU3BZn7q9fdhfvj6Yp0mKLgOe1uiWJF3g6Y9VpGGED/ng74KC1aVE2MRNei
 xicYyJdgo07lwViOu/aB0DEbFMM8PsXHOSbOYlkgTZvfK0hB+7sD1HqAcQt8dEfD5zTc
 lkPC+IYXgEuZbxZs+OVgw6NjzvwAZLlNBivaeBRHkw4pMC7Iel9PxcUYYICXA0gpTE+1 Ng== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m765w01uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Dec 2022 00:26:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B1NOMM0036602;
        Fri, 2 Dec 2022 00:26:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m3c215xms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Dec 2022 00:26:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQvB7AY54EianZZeSSuMSmazDuL7Y3MZeU1r3tFg5r2H91Qb88NsnychazmnPOX7ILfQAwtpBANp0e0Ep4Qeu2WPmrmblmh8iFBhMpAyygWtIDQtyVo16mG0cjduMuXwUHnZxwUmMVk+PEw42EF3eP74qIzzIxqW/iNZfJN3Un1r+3Og3hehri7wUFvV0/JbA080SkvIgLD853gOY7iyfe6fL8W+H7upWfPj+GdQE90laRUjlZQ1XjMJylnSBOrH+ayMKTbJEqsJUKGeHOwvEFM7WiR/c3XI6ueaWptpRklEvSLdjtAN/B1E6gZAcyFNwhUf8uvox3jUN5f8AkFzDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hTQ0KulW8fHzyfyXunHYyE7lIpwH/xtHaTskd5eFAE=;
 b=S95gm7D5O1QwpQiqZRoS5dFPDyCHLhU7zFwlK7t6V/U0hiPgmuwl1Oq064mNwJxr9+SIk7KF7Nvu6o2VqHR88vG1f2k5KAa6gQbov741mp9JQu9K6YtVBQDEbDMgDZC/+UlqBrpezfjSsfNuU9qXZNPOfWK7XFbL3OCzDcgBIb74hcZGGzGSsJq9ranYD59xJGVq1otwnAYMZUbNqfaQ/+29HQaiePIDyW3tji1in6SUs+2IDTCWSL5Mic/V4QqdzrzQkoHZf5pQn5btKK4puS9O5xJoeTfnxWkMc2HOPCATq9C20z2CJPUUSNQ7rOvFKu12LpV7xzDCEosGO3y6Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hTQ0KulW8fHzyfyXunHYyE7lIpwH/xtHaTskd5eFAE=;
 b=yDsz1iL3Q2687Ly78Max6jzNfGcwcKQD3WAhjVzGDQYqldl3aPcqaEKlgmjWQ67toa6wrM6rIDOKHE/dvLYZN5iOoLXMVUAKd5uyOrzBuG74Jw3sLK5y+vaqimW/9yzttFJeptkysi9pppCouPt4F7IaL5rAKKH47iaN3I2oEvI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB4396.namprd10.prod.outlook.com (2603:10b6:5:21e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 00:26:02 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7%7]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 00:26:02 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        likexu@tencent.com, groug@kaod.org, lyan@digitalocean.com
Subject: [PATCH v2 1/2] target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
Date:   Thu,  1 Dec 2022 16:22:55 -0800
Message-Id: <20221202002256.39243-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221202002256.39243-1-dongli.zhang@oracle.com>
References: <20221202002256.39243-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0181.namprd04.prod.outlook.com
 (2603:10b6:806:126::6) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DM6PR10MB4396:EE_
X-MS-Office365-Filtering-Correlation-Id: 09d50109-8c88-4b6a-57c0-08dad3fbcb15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LiUhAcVa8BdXa04OAdqMQN9GBI2MJrgNLC5zQvF7pahcKAiVRpU5QV2ESVzCU+yRUuDgT/xsF1q1Ukh7WJlDCE1npIxcU/vaErkLcps/fxEEC4HPvUqTN0BIQm1cQBWFspfvBNVwp4bqhINTPDGiKKR4KFH4bru65Z7i5J3zWYdV8pfb42CvKdPRSsIWy2Ql8PDOb/srwjcfyPKZ9bicsmmFaYGC+pU+N1TSKwOv3Ez/oGArgzjJitlt2ATqH3pvgOel2RMC3D6vBJ6vEUFGQO9QqeCpR1B3wPp+j6Nc4qm5saJQPRdlV9btsCVsYADuf69aYXO022zH6+QaIZhZjPaBnYfKRBpjC/jt68YCxW3aONg1JSSb1xYJwCKKQ1RwgP/2oJRu5fxdXCHSrYqf9NEJedhFS8OsANOt4PU3fLxUElWt/3vfVQ5N0/APt3BCIqIRqXpIfHpO3DH63OfjykpKW3nowIB9yZVd8WamB7palR1T33zEF42LR5tCDhjVfGZfzcl5ld8AT+nC/qGEoiSNRccYtGOvU5k+ZrPh3yTEXmU8LKNskybLbCTaTl89ybUa+9zm5UT7ua4c8RShzIKjkHMNASztlE4BhiYOmSemaP7t/ubal7fqVYV3BSL0vgFID3bvH0+XzXu+1ShvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(36756003)(86362001)(316002)(6486002)(44832011)(8676002)(66946007)(4326008)(2906002)(5660300002)(41300700001)(66476007)(8936002)(66556008)(83380400001)(38100700002)(478600001)(26005)(6666004)(6512007)(186003)(6506007)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UvpR9dQFvsMUDcStRLZM6eRyHwhgtE2vxoGKHv0R3Cp9dZioCJ9t8vAdbBpa?=
 =?us-ascii?Q?T4jV+jTlSFJlzi0Ynlvx9cHLkpjgXG8mfc5+F/mb3RLTkQMFq2QlOGHC0UiH?=
 =?us-ascii?Q?1AFuSrfZl1mGTMSruEybjH/FIQbp6qMfUpaRbQ0qFN5mH8xPnyj4gcRr9lOK?=
 =?us-ascii?Q?o7lXGcSW3jJgmAAj2JEGxqbtOwO6Ff6hfCHRj0KeRG/9UftCSLx+c5a0Ox1a?=
 =?us-ascii?Q?Lqpd/o7di0OB5MSuokxpoPF9seIpmcfksyj0sXKKYA6p54vwm7lpfQZPmH8B?=
 =?us-ascii?Q?l1jWwPYIzUecnYaTt9/u5XKrhKxGoWfJ8HBLB4TL7HwofCwkdHRk9nMjMiyN?=
 =?us-ascii?Q?897ayyidvL29FxJG6sqJ8z9TkB0uIG4jNLOHnslLBXU20SsfKpNxZyFp00Jy?=
 =?us-ascii?Q?kkUlWx/CsJoukbYzj1zLz8u/UBYnuUHNns0BzAOudw2SEv7mKcCM3IOyr3EP?=
 =?us-ascii?Q?4yioWy+eJNbPxhaEWxG5JglcOwGg3poBEEJjpu7iKCbilXroFfIMfAtyhqTd?=
 =?us-ascii?Q?xK4ylfL6fUd9Qq/tF6DkEYHkUmJL71LZPr2RFYHxLsIa3z/7gdSRZ43eE30g?=
 =?us-ascii?Q?MlZ2xLeKrkTB7QuRGuGSBhvzd2yfuvilY6nryHxSzxx/ye0RetJrjKjlDpvF?=
 =?us-ascii?Q?tq8tez6ldEQybe7OqCOGnQx73Nvh1OyEqjw4f8IRvJFpPJQ/1KnORBfwIHcv?=
 =?us-ascii?Q?vN2+enM6PAhgjFDM48j507GnYTiZ47y93QyqT1mibBBnBWCOfQEtJLq4Vy+v?=
 =?us-ascii?Q?a5T5E4v375BBgvTK7ollBmE4JlTEFEK/KZo2W/lBz7ZklsMTDGgZdjPIiuR3?=
 =?us-ascii?Q?PCGkM0Iy/g6Q6gyEbgrJ6GL54iiDq9jIfAephQTojWu1HxljBJJgeQ/s0aLy?=
 =?us-ascii?Q?IHQueGDK7aBBCy39ZmcTk1tIj67rRDO+EsS0XXA5rhraabuSyMfBneKXU4/r?=
 =?us-ascii?Q?OYt5wnh/IguxyaV24eEgAdhxs8zyTJ/vOQG88tj28A2FR6nbJ7QPvc0YqDLC?=
 =?us-ascii?Q?WCqf0TMS5KCKwbaIoj4fQAqCBT5EkCx3zLPJ5qruidPp8HiDtwlDJ7s0/ZgR?=
 =?us-ascii?Q?sTZq6u5WQ1dhQfUphy9RDYBD07zsogjEXGHTNIdE0FZwAxXUP39trid/JyU5?=
 =?us-ascii?Q?EPbZUFV21j6uaEWGMd1jh9ITZ48AtMKZ6zx4/eOWL72pZNw5CNuwVSp9n4H0?=
 =?us-ascii?Q?DuxVZLv+ky1wKtPNzZod/aU6lYM4lyVzNefRkZG4znDWv1o2+ASGWN1IxKUv?=
 =?us-ascii?Q?1Loh1v34h2hPItKQt5NSOCsWOGojOBZdldBGOAkYym2nAOowrW+E3/A+0N3d?=
 =?us-ascii?Q?QcxMvlhUo3EH2RZ+JQ+S8lDXsKScmVMpLbG37a1Uqr22AwI0FM79DqhXgujn?=
 =?us-ascii?Q?hzMHlx3biwVpxw4CKukMtRgxQgtD9C6O5kAJiJ547zJKDn6qH9aQChDEQXfN?=
 =?us-ascii?Q?dM/avTH92XDY80U+TWyUEO/TZq47v6CECAa9e4vEFma/DXXE61ZajYeYAQo5?=
 =?us-ascii?Q?58Ih2QTR1fcL0Hv5Dj8/e3SjRlNQmUs7ez4PCFVj4aaZUfXhJxNr7nHFjxOB?=
 =?us-ascii?Q?eaXkkVqZn0fvAvo+1ZhL0lksdS8rD0mKro8GLw5t?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?cCA7pxiHoopARJi+NejitNz+pIL6lplUEzvJ5z2ktPuYBdsMcFnXErE4GRia?=
 =?us-ascii?Q?9I+fr7unsDE15Qur4zPx2NnAwYbsQMwi4AaCnrSPuM/K2M3RY4qG8TL1szBj?=
 =?us-ascii?Q?yLfjzfi/gLx0K9kRoH668clphiMCxl+rsws+Qwiy+WtgBTa2TG4VGvQI9BEc?=
 =?us-ascii?Q?cUo1Dwml7yuWvq639VlhDJ9LAC/QQNjlcg50hXh/1w8+BRwGJl+oGIwzxq2a?=
 =?us-ascii?Q?SvMuf1ehydMTUC2LiR3DvhEJRMiO/JKTr4rZrZRdPj0Tep7INhcMgCeJTusI?=
 =?us-ascii?Q?qR3+tl/kSV5bzI4d3uNNuW607bndEoDIehwUZv5NzOhViB1bb19sOlHpQbAX?=
 =?us-ascii?Q?s2hYibHnDY0gui2LU1edzudMHo48af6s+XP56ZSt1jAMQRxP0+aGc6y5tTwe?=
 =?us-ascii?Q?ftWT7UgnsdLeKKmkZfipebxsrB+Fl3c4pYwgof4zhcc5G1RHhs489B7U6vbD?=
 =?us-ascii?Q?vqZpjqwyYUX/TsCyotXoKQqn7147FIjNtq5sFGBZQwRjmU1RrpXCZ07JWSGP?=
 =?us-ascii?Q?foS3mAoLuFvbWPo5mjjWPuqO8SlJ3LScmnQ3iso3XBMhnVHEPYhlilNKZ98R?=
 =?us-ascii?Q?RExvJ/SmMl+9Ti9l4pioqKY/elaSv2mLWP5QXeOe1qnM0DnasB1pGsmHpbR/?=
 =?us-ascii?Q?iw6KQy/v5snHJlev8bg2uI2jQYVR1MZdzbRR4GbaZ2epo6XQ6mm4IT5o5pbm?=
 =?us-ascii?Q?7wJ1yNUNcSsqB/5acmQXJ3us+emZ5UrLCVWdx5ifpKuIeXyMkbx5WHmjH5KP?=
 =?us-ascii?Q?mm6bKW62tiOEHhIBGqAbewLIsWNkBtk8/yLwBlxjgcod6lg4GNSdHR3csKKv?=
 =?us-ascii?Q?CU600SJYpyAmhJPtT2XtmgzbSF61uN9LOV/0pg/gSDiCxGK2nP9cRm5BlNVp?=
 =?us-ascii?Q?egfudqvgg95Rpgpolqd94sWr+NCzZlxYMaEXkCRT0na3VRCH0hOkBTAUqp23?=
 =?us-ascii?Q?l+R4Gsdez9DZGWhghVWOzQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09d50109-8c88-4b6a-57c0-08dad3fbcb15
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 00:26:02.5646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZbJcD6Z5Sqni6zdNoK+AjQgkL0JjXCyMbDewDK0RweUTYSW+vcXm+SE76SRfew85NaFBsOjvACppj05ZAaDRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_14,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212020002
X-Proofpoint-ORIG-GUID: gNxDslJ99jxP3cN3kATvoVzoInWQR3fM
X-Proofpoint-GUID: gNxDslJ99jxP3cN3kATvoVzoInWQR3fM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "perf stat" at the VM side still works even we set "-cpu host,-pmu" in
the QEMU command line. That is, neither "-cpu host,-pmu" nor "-cpu EPYC"
could disable the pmu virtualization in an AMD environment.

We still see below at VM kernel side ...

[    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.

... although we expect something like below.

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

This is because the AMD pmu (v1) does not rely on cpuid to decide if the
pmu virtualization is supported.

We introduce a new property 'pmu_disabled' for KVM accel to set
KVM_PMU_CAP_DISABLE if KVM_CAP_PMU_CAPABILITY is supported. Only x86 host
is supported because currently KVM uses KVM_CAP_PMU_CAPABILITY only for
x86.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - In version 1 we did not introduce the new property. We ioctl
    KVM_PMU_CAP_DISABLE only before the creation of the 1st vcpu. We had
    introduced a helpfer function to do this job before creating the 1st
    KVM vcpu in v1.

 accel/kvm/kvm-all.c      |  1 +
 include/sysemu/kvm_int.h |  1 +
 qemu-options.hx          |  7 ++++++
 target/i386/kvm/kvm.c    | 46 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f99b0becd8..5d4439ba74 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3620,6 +3620,7 @@ static void kvm_accel_instance_init(Object *obj)
     s->kvm_dirty_ring_size = 0;
     s->notify_vmexit = NOTIFY_VMEXIT_OPTION_RUN;
     s->notify_window = 0;
+    s->pmu_cap_disabled = false;
 }
 
 /**
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 3b4adcdc10..e29ac5d767 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -110,6 +110,7 @@ struct KVMState
     struct KVMDirtyRingReaper reaper;
     NotifyVmexitOption notify_vmexit;
     uint32_t notify_window;
+    bool pmu_cap_disabled;
 };
 
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
diff --git a/qemu-options.hx b/qemu-options.hx
index 7f99d15b23..15a2f717ff 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -186,6 +186,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                tb-size=n (TCG translation block cache size)\n"
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
+    "                pmu-cap-disabled=true|false (disable KVM_CAP_PMU_CAPABILITY, x86 only, default false)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
 SRST
 ``-accel name[,prop=value[,...]]``
@@ -247,6 +248,12 @@ SRST
         open up for a specified of time (i.e. notify-window).
         Default: notify-vmexit=run,notify-window=0.
 
+    ``pmu-cap-disabled=true|false``
+        When the KVM accelerator is used, it controls whether to disable the
+        KVM_CAP_PMU_CAPABILITY via KVM_PMU_CAP_DISABLE. When disabled, the
+        PMU virtualization is disabled at the KVM module side. This is for
+        x86 host only.
+
 ERST
 
 DEF("smp", HAS_ARG, QEMU_OPTION_smp,
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a213209379..090e4fb44d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -122,6 +122,7 @@ static bool has_msr_ucode_rev;
 static bool has_msr_vmx_procbased_ctls2;
 static bool has_msr_perf_capabs;
 static bool has_msr_pkrs;
+static bool has_pmu_cap;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -2652,6 +2653,23 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
+    if (s->pmu_cap_disabled) {
+        if (has_pmu_cap) {
+            ret = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
+                                    KVM_PMU_CAP_DISABLE);
+            if (ret < 0) {
+                s->pmu_cap_disabled = false;
+                error_report("kvm: Failed to disable pmu cap: %s",
+                             strerror(-ret));
+            }
+        } else {
+            s->pmu_cap_disabled = false;
+            error_report("kvm: KVM_CAP_PMU_CAPABILITY is not supported");
+        }
+    }
+
     return 0;
 }
 
@@ -5706,6 +5724,28 @@ static void kvm_arch_set_notify_window(Object *obj, Visitor *v,
     s->notify_window = value;
 }
 
+static void kvm_set_pmu_cap_disabled(Object *obj, Visitor *v,
+                                     const char *name, void *opaque,
+                                     Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    bool pmu_cap_disabled;
+    Error *error = NULL;
+
+    if (s->fd != -1) {
+        error_setg(errp, "Cannot set properties after the accelerator has been initialized");
+        return;
+    }
+
+    visit_type_bool(v, name, &pmu_cap_disabled, &error);
+    if (error) {
+        error_propagate(errp, error);
+        return;
+    }
+
+    s->pmu_cap_disabled = pmu_cap_disabled;
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
     object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
@@ -5722,6 +5762,12 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
     object_class_property_set_description(oc, "notify-window",
                                           "Clock cycles without an event window "
                                           "after which a notification VM exit occurs");
+
+    object_class_property_add(oc, "pmu-cap-disabled", "bool",
+                              NULL, kvm_set_pmu_cap_disabled,
+                              NULL, NULL);
+    object_class_property_set_description(oc, "pmu-cap-disabled",
+                                          "Disable KVM_CAP_PMU_CAPABILITY");
 }
 
 void kvm_set_max_apic_id(uint32_t max_apic_id)
-- 
2.34.1

