Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38B363B22A
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 20:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbiK1TW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 14:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiK1TWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 14:22:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D0525DD
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:22:32 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASIwt8C008650;
        Mon, 28 Nov 2022 19:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=OIuISjYZ/ot5wHvnH/Q0Om4ZzLushh+eRMzhu2QhT3A=;
 b=W24b/OiZFJb1/izFZoiic/I8rWPqfL7bgcwX/7PQWYS48QH5ozgCBGKNr8WYgkO0pCJx
 ubf/zgjXQvIiAO1gHvKO0F0xrsUHANYkd5Thy3kW3kbQp0voxl3XUt8fxKESxjRooj6P
 dch9Ocor/UJbnCDVBPHsZWhlKRvqVEDlxNXMP713TPTtrLdZh50/xiFOjqAVlW4xUF9r
 DXO6mJ4Dlawhc6J9wRgQxc5HdED9M4SLmW3rXoCKzDoCDlc+CrvU7aT4AADwvfuPmxmB
 cFI48KYzghGwngSuCY+OZsG7yMYqy9vS/fI3jhYJQFd8eMO76OQYZvgv0Q76g//8Dd69 aA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2mkmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 19:22:28 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ASII1Tp031677;
        Mon, 28 Nov 2022 19:22:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3985gub1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 19:22:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be+1QJfsQ++4PY37lx0O0JJgpqvPjFBaKzZUeanqJG/AHLMNRDtAEaHBiV+mV+cQnriFEksPvs5h0LVfaPMu8RBAW55c7YF2+coJ0hQdsuhUa4XtVJqM2gb/A4v7KWEEn4exyID/XAqt3aqjubImBbcaf/R0a6kNQfOI/I3zlxUx69JDW3FtfgYRzY3zOyy7YWwkihRV5GrucgjVHrhg9mX5ZejlrZQf/A1DdgfrC6HDY/AXqWdI8cugXCi4GaLP4N/WO6a+7Uc68Y4uJ0d9e39jh2uwsQrLse6k+oCrzlwn78q2mDsaTb7MQO9PYrh9sorRlrmFuZWzqi8Dt4ZuRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIuISjYZ/ot5wHvnH/Q0Om4ZzLushh+eRMzhu2QhT3A=;
 b=VXNZlCAUDxR9NsGNqpQbPTKC9/PtYAzuah8cZ/PIkRWeJfIG5OC6jcRHCy9+0eVFuZKnupwTqLj5cCF7WPXrXACc87qILllHgMcBlup8a31TfKIDFBHYRM4kJv2BywPGg4d7mPuB+6nN6bgUXL/VRPoN4/DvCb+2bafy10abn7FJy+fpTh9Iz30SNngHr0qUm6j07opAeDXH/YBz+2g6+F2LKlSndYa+exKNE8CAmtkMJtG8yjk/mBwzXZ5Em0eSeWNqo6mFugVJP8SjkXn2zaONvoczOBEzPwsYXFG8j2LQz+0QCA1X8NK4JBvATCpE6c+/KnQE4oORARhurPqUJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIuISjYZ/ot5wHvnH/Q0Om4ZzLushh+eRMzhu2QhT3A=;
 b=bzL0eyx1vv/TWvb4P09Qon2f6GEsLcGn9s3lw7RA5vgua0yUeF5roLblA7n2dRbhQhNtOAgU58colR/dF1xbhqMKZZjGxH6SDeleod6oDMgv3SXwJI13xV4TcS2tvs7XewgNxU9De2fGl3Bdm8nuyglsxrgS976u9BHeBmUE+Y0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA1PR10MB6342.namprd10.prod.outlook.com (2603:10b6:806:255::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 19:22:25 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40%9]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 19:22:25 +0000
Message-ID: <77c2ba5a-2b5c-9a47-32ae-13e5a6960d05@oracle.com>
Date:   Mon, 28 Nov 2022 19:22:10 +0000
Subject: Re: [PATCH] vfio/iova_bitmap: refactor iova_bitmap_set() to better
 handle page boundaries
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20221125172956.19975-1-joao.m.martins@oracle.com>
 <20221128121240.333d679d.alex.williamson@redhat.com>
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20221128121240.333d679d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P192CA0021.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::26) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA1PR10MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fe73725-4547-48c2-f916-08dad175e077
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: znR68E2QlZK9MBibqegGXgrXSX23gQtFjHO9GcvMIod64bMvU+sOPeRfWxDOamcyl0kaEUKF8rhsSujhmyJJSv63XvaexYp77IdWJ2SudcL9t8+hbsJzN0PjPw4rqQKNY82doj9BVtNVCSAY9nKE/SRyUK8DHCAm+ss/+ik+mUadvxdrRjD41rMmehhY1YV/UkgFShR6atNnGVhX3HF2x88mycheVwb7Hr7YYnuVLSfZMCiIyVGQxa6HTaOQy3piRtB61DRQDnAExY3eBnd8vd67LVCAuE2Pf34fyrHd5TbbAsz8lNbqDfUBdL/3bD4OyzhPjNdRK97isNGb6SvR7D2bSWFESH9jp15bqXLY4GttmdI2jSYclosM1rvaKBkVzngkkiWYnSzk4lo55YTANGNU1gvUT/x/fMXQHYZWj/+gf8wGBKVtXoPCwuxycdq0aQ45DwydeV8SXJydSU2/I4EPbc07uBbTNsWljmQGbRT1t7Cu7JJK9NbhLOUGnufbSeuuJtxZpG8L6gW/uTLD8aui0OLl6YJl32nNkYazfpCY4w1Se2MlPDRMK8ZrVlHEg1WRG7ppUv1tq9aM8r69zsEHH2x6OplEwKnyNM7c/h1s2vkMCmQHz6TmwGO3bJmPVVtHiUplbmTR1E/WiT7c1av0VUR6vbFsduQE2pdHK35jjerZdZGeKKFb49qK6WKX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199015)(2616005)(31686004)(2906002)(83380400001)(38100700002)(26005)(66476007)(41300700001)(66946007)(66556008)(8676002)(53546011)(36756003)(6506007)(6512007)(478600001)(6486002)(6666004)(8936002)(186003)(5660300002)(4326008)(31696002)(6916009)(86362001)(316002)(54906003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFcxMFg3VjJqUEtpaE1JU0gwektGQmhKZ2pBb251eE5haVBkZ0lpdXNCcWVl?=
 =?utf-8?B?VEFKY1JkaE9LdERGbXB3QXZrSW14aXY0ZDdlRjREVzZMRUZGRVdwd2UwcHlz?=
 =?utf-8?B?M1ZPMHFXcjB6U0Yydzl5V29YdWJVOUxEODRIZWkzUFdFRzVlZ0x3OG1WdzVP?=
 =?utf-8?B?ZzFzV3l6blREbjFSZm5QOHdqelNLY0V4L0FMRHc0dTFoUndsLzhlc2x6YmRB?=
 =?utf-8?B?RUtWZ1QxcWVvc3FubXdidzMvdE5MMkVXQU9xTE4yVHIwb0wxSVo3YkxDOUMw?=
 =?utf-8?B?Nzc2SmRLSGpEQ2w0NnVUSnRrL1pzdzFFcktLeFBXNFBramtKeGZqalJUN0ZJ?=
 =?utf-8?B?ZTZVV0R2WjI1UmFVRkh1aTNaWEVVcHBQem1WOHFHdDF0eTdQbjRrQ2trYkVY?=
 =?utf-8?B?OUllQ1gzVDU2TmYxZGVzMzByM2QwM1lxdG5TeUhLRVpzSUtNaDFDaitQU0tF?=
 =?utf-8?B?c1RiZlBQRUFiZS9qdG5NQjE0bE9uUTFOZnpzTS9iR284b3BSMHpzYnRJQkhr?=
 =?utf-8?B?aVFPbHFxMGk3dmFXdDBQTmZkbjB5SFRlbWkvTzV4bjZjcFphdVNpNzVqbXps?=
 =?utf-8?B?OUJMZlRDajFJVGpLaDh5THRsbmcyWWJWTE0zVDhRdXpHMDRVcXIvVFdHczNC?=
 =?utf-8?B?L2hVNFhCQlJqUVVTMzlCL1lzeVgveFNxTDBIVklYMHJsVVByaTJlUURhWnBU?=
 =?utf-8?B?WWlMenluanMydk1nMW8vRll0c2FtbEVxdmxHV3NRcUc0bVI1ZSt4bk5oc1lF?=
 =?utf-8?B?OFNxd2lWK3UwQW9KU2VhemhmSFYzUkpzM0gxRkN3Wk9nNmQzbEl1cTlHZDVE?=
 =?utf-8?B?ZURmaHcraExhdURzNU1sbUt2V1pQVXMzbUJDQmR0YW4vS2FPY3h5SHU0WXIv?=
 =?utf-8?B?dm94a21tNXJVTjlMQncwaFhBNDh0OEc2VU1QTDlOS3VwSWVSYWkybUNwNHNy?=
 =?utf-8?B?OVJUY2QwWGxaajJOWnI3SDB3WTk5MXg0OW8vYkI5T0RSelJSNDU2eG5wemh6?=
 =?utf-8?B?VWVTWDAyZUgzcnc3ZlBiYlFwalp4SlRWZWt4QUhPNk1KTUFIZWhJblgybFB0?=
 =?utf-8?B?aHJ1RzZjVjZsck82ZGVYSHI3ZUIxUnpwQnViWFpranhPSnM1MkFGNHFzaG5C?=
 =?utf-8?B?SXk3cVVNajFJNkRTTVdDeHFvRFlPTnpxaWRHOUZMN2Q4TUlHaWQ2WjBSWXg3?=
 =?utf-8?B?L0FWZmhIVXRoZ2lKR1F0ZzU2MVZ2RVZ4bTI3b0Eyd1VaWlZ3NllhNXRZQkVQ?=
 =?utf-8?B?OFhPZjdTdCtUdlBhMjB6T3YvV3BBZnJmNDFTYlpiOFgzaVJrTVRvUG1DT3NL?=
 =?utf-8?B?K05RcEo1YjBMaUpEYm1wZjZBMUtQbXJkUEphcXp2UndUMXloOXJleWJOODdV?=
 =?utf-8?B?ZzkwYjlpUTlRc2N0dEUxcWdOWlpBTXJsWUI5T1lUSWQxK1FZMUlxMTBjTWJ0?=
 =?utf-8?B?eXIwR0xCV2d0ZlM3QzhRUnJOZm9uR0JyeHVtRHUzaTlqTmNEb0pDQjFyVkpE?=
 =?utf-8?B?aytZWmsyMUVRb0tGYnM0QmRoSzNlZEhxUlhoT2VCQWo5VUxWU3dZQ1RCT1NW?=
 =?utf-8?B?SUhRNEtPY3VqRzdtVnc5TFBKd3hOTmY4UFQySnJKa0dqWGhKeThkWnhaQWdw?=
 =?utf-8?B?SGNpTmp2NTljV21EcGRoQmE5V3JoN05CSzZ3c2J0Zm5sYWw4WklESytKWTNM?=
 =?utf-8?B?YW9iQk9QblB4VGsrZDlKUmpiYUhQUE5Qc3JwTGhaN0RHV0xrdFJtRE1IcnBu?=
 =?utf-8?B?cFphcDJaK2gzZGZpeHY2ckR5VEhqWURYSytxTXh5N3pIQllvS0gwWVdyZlZF?=
 =?utf-8?B?a2l3b1NWQWJzVFVZenNtNVFkUFhvcmVoaWs0QksxR2M3TVl0SGFWTDZwRURJ?=
 =?utf-8?B?MU1Uejd4TElKeXBhcUVxQ0JtdlJnOENOSnFUODIyVm5IaTdKUVliWkdDTmxz?=
 =?utf-8?B?eld0REIwVWMzeityQVJvUStnbzFpSnVsbUdyMHZvT2N1TnE2azZCWFJqOGtM?=
 =?utf-8?B?RHpCeUpPM1BHbGtodWNhRUtRODZFK0poaTBVby9FN2h1RzlSOHdGZSs2ZjJE?=
 =?utf-8?B?NmFhY1NrM1dPWndBV3VoN21nc3AzYWhJNDJCeE16bGNxYlh0cXRBL2xhUjJl?=
 =?utf-8?B?VE9uNTdSaXVuN21iU3YyOU9IbmpmS3hGWWtpN1ZaNWtnRTV6dzdIeWVsUElD?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tkl7HiqjRJUTbo+1FBIIso09C8jn29QVPMOqLGLu8BkgGGkjRwdVTrCVaLVubhDRHyZ9/44rsyvwvwdJS8iY39VuKeA82UGikoQcZr0f09alHNkFThEalyMbWeAIcLO0Kkiw9OiuMw4gOBh2jtL8w4wIgOOM+o/g/96iLWBSBOH0XLU1O+nyFnAMqAoxN3eRB8ZtAX5p8e1Huso1RSChbet9pY/CPcyMXSWUqXVQYYCCxdxCvTq1TVsn9I8NagRVrpZXFcesZLv1mXU/ARU0xJgdyhrlPQj7G1QIQryyaS/i6hwoWFDd83IZajW+ogx4nqYLrp+PjOsZjwfL5TR5seUEdO/2g3rHnLleHW1m2KGt44RzP+fO+EuUa8lq78fYKP+6i1dFGFMunLxgZ8fpV4S0Xq51aD8Ba/YHPPaxfxBa9ZXPqoeCYDHmkL9+N6wSzUTL+z3lBJU+vkxO32pNcGFbWS5Bvlg1wtyyl9HTgjrS/BJVTxPchu1QPtUikirE7Bk6DuYum41RziO38sD+Ywkhk8itJdyfdwGanfCb1a6CkVUEAjeHi6uswfJ/yZeYWAWZvLBI8CX0uVCWHo1xlA6eAOCVcnBOJ6DftMwfR6st5DOVZL78s9ziZ+Zu5FkRl7aSQKRvDahL4gSXh3pmxdq3m6yarN5v2p9pr9VHm6lh+UnxwnsswdTdySs9b79uUcA7+FSpU8fC7sY9bZY2dfY606t9VINc3O5A3N1mTu9OUh6MlGzGXW0fk1hzkQK9SE1/Y6BkpMFnXuTKpDJPqCVBd8FwRg2990jplhVFJ0+2eVO8DtcGt6NAHUDbHDZnrtr8Xe+oIRxAWgc1TQHxnpC44sKON1euPZNlWakKtihHfvKLp/ueTqPbhApEYipo
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe73725-4547-48c2-f916-08dad175e077
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 19:22:25.0411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uiUo8tRVv7VgFsWGNGY7VFv7abdrDqDWXqCX9QmgG368ABe9HB1P/K60ONcPj1wi49JskI8/csOx42EBU+BH9paelP8YADI6FQhsAM5xiX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_17,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280140
X-Proofpoint-GUID: hXKLekzkdQ2MblxfgBYQATkDWv2tsYA9
X-Proofpoint-ORIG-GUID: hXKLekzkdQ2MblxfgBYQATkDWv2tsYA9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/11/2022 19:12, Alex Williamson wrote:
> On Fri, 25 Nov 2022 17:29:56 +0000
> Joao Martins <joao.m.martins@oracle.com> wrote:
> 
>> Commit f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
>> had fixed the unaligned bitmaps by capping the remaining iterable set at
>> the start of the bitmap. Although, that mistakenly worked around
>> iova_bitmap_set() incorrectly setting bits across page boundary.
>>
>> Fix this by reworking the loop inside iova_bitmap_set() to iterate over a
>> range of bits to set (cur_bit .. last_bit) which may span different pinned
>> pages, thus updating @page_idx and @offset as it sets the bits. The
>> previous cap to the first page is now adjusted to be always accounted
>> rather than when there's only a non-zero pgoff.
>>
>> While at it, make @page_idx , @offset and @nbits to be unsigned int given
>> that it won't be more than 512 and 4096 respectively (even a bigger
>> PAGE_SIZE or a smaller struct page size won't make this bigger than the
>> above 32-bit max). Also, delete the stale kdoc on Return type.
>>
>> Cc: Avihai Horon <avihaih@nvidia.com>
>> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> 
> Should this have:
> 
> Fixes: f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
> 
> ?

I was at two minds with the Fixes tag.

The commit you referenced above is still a fix (or workaround), this patch is a
better fix that superseeds as opposed to fixing a bug that commit f38044e5ef58
introduced. So perhaps the right one ought to be:

Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")

	Joao
