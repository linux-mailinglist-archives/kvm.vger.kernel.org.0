Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEF65146C6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 12:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357415AbiD2KcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 06:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiD2KcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 06:32:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB565B1887
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 03:28:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TAIdiw003700;
        Fri, 29 Apr 2022 10:28:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xrOouc2LmL54Z/gmCQb/IvxtgBUapSWDu7uDqHveyxY=;
 b=V11otBL+UVG8a+8VV/P+JPtXOvSwWhc174FxWR5pzzoDi6RVfhQ1M1QSpTa+4yudAxcj
 yAl6gd5zjnUmJraIF9VPsBiFzx0KaJBGGOrOuOjk6+yQMime0kwOn1xwCLgrI75Rv++e
 gUemlEdQcMU/ZsE96y2IGpz923b6Kar1WdoSLTK8sSCRDYfTpiCTXRg4w8dD5tAoGe0n
 Hdl4XSOabOE14Qf1fBdeV5gWzCjLHkiroYYexV/OceKorZ6huwNp8w6jp36/bQGEVqTu
 TYO52Q10R8ig7YPh5LTzt9VGHW/4zQSlVXRtT2iT8BhS+NrD5QdaBB6xFwe6vlqbOdH1 aQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4wx9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 10:28:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TAADQK025319;
        Fri, 29 Apr 2022 10:28:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w7v7q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 10:28:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTeutKwzElByEBfCVcKXq27Y5RK9M35MoT5bd4HU821TTpYAqfx02rVzkKSqvXYuJH+jVFUMQ+wIJmQcW3snWx3eD9GUp51GZRKtU2+et/lqtdqIL0dBnpy4sQ9i+O58pRBEXNWobvfEN2TPVx3fYTQ86sIcnpC+6xDvnL8qX/hAhGEWqDsgv9g/uBN1yeV4kg9LW7ACzENyHD/K/7UG8Lrk2QyX5UAx7BKsdtWpQWoelhyuAq7ZMnHXc291s3SqxLZcAr5iTgsjWlnxMSARMCaBnnVAjAP0fVl20ILmzR4zl3oLsUZFk8xUwih30MBdMazH3+kqv02JdYcEGHePsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xrOouc2LmL54Z/gmCQb/IvxtgBUapSWDu7uDqHveyxY=;
 b=haWwJgqUl8z+Yxu1l5tSWg5wJq7J646YOzLZwz884OijJC4FzlpOsfOaTLyJFZi/zOkB7GG51mLrQRt28eMVmK17fwkRC3kor6dXL2xKOE2flF/ccbpaHEpRGVdteNDWyrZoCPAvQw5kSljyZlY/9JaJnIa26Hq0EFAxs7GZAsW0Ee4YYsLfNiV1F5YP1Tlzr3DF08mJYRJkZWYL9xOgtNX3Us4NEKY+Cg8j/+o17PD6ZBC6gmIy3U/6WrFir21IENysQyL/M/OvcoqniL30ZtGLS/c3aEwe2y9K6Ynn7ldkoiI2hVL4dJotBKYPw2EUofHSxXhrnLQE73hC0Mut3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrOouc2LmL54Z/gmCQb/IvxtgBUapSWDu7uDqHveyxY=;
 b=lHd5ciyOpz96eQ3gNZF0xfVkFigK4s+/WvrG5P1vxOEyTNwKswX9VmQxy0n/bFZUrA56Na+8+vNaW7BfrU9OESQ6Djb4gnWgT5EGSsbvueQFRhjwVS/9UF+8ZowWIy2HPVAuwZj/PdEc6PPvDjx1e4BrNfTssKsOXHS60HiVn/k=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN8PR10MB3218.namprd10.prod.outlook.com (2603:10b6:408:c1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 10:28:07 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 10:28:06 +0000
Message-ID: <f5d1a20c-df6e-36b9-c336-dc0d06af67f3@oracle.com>
Date:   Fri, 29 Apr 2022 11:27:58 +0100
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0385.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::13) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b153d3f-c0af-4c58-5d66-08da29caf2ea
X-MS-TrafficTypeDiagnostic: BN8PR10MB3218:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3218F3383ED67AE4C31A05ACBBFC9@BN8PR10MB3218.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gIF7xIQmJvnjBxXjYNMczSyT1bgFt5GQw89jrUpyH+WD0ONN94w8OOx/XwSfiCtj2d8OfIOHLjF12W7N3jd68AOg2KRGh/oNfC3khm/k6EfeISemGveqmIiOVT/t9KB68c9Wd3W2yMyofOOclVfazkzvTD5hCDVQ1HSWijQiNJVrRjRx0kMpqqFTCUaMbi5L830Uvcg3ahzplsas8ZGOg7RLIY0CCHxvsPlRDVKtNFnOudfO33+MDmu1TrODeoCQaGnGMFRr530Dqy65Ttabz8aJFgZ0bexD/CfHDOY1jjxX/agdiwRpNen+C512ye+POumNkYCjrGdfCW4jXMBi+jbLItv9tbeljTWsYGVg8+W8OhDuy5uVevIW4/NgLlr3mkSBXroIm0ssi14KO3FmnWVR5fxftCrj6YHa6gZ3HYegRmORUb8ACFv2Ov9SogNmd+46E/eSzj4wJ6X4Aoq0sQzVhSz80b+SDudMgIDv+MXHlDD8rSyKtlP5/lsiK5dZvB5sgqfrBVO/R+hPLPR246ryB55KirEGQhU+3ngo9VMi56yM0vMvqQ89qL54bPEmX2KREX5ZhVGHpHO3I3gZfycWaK6PzSpyvv9o8sTNIu5kqKS4SnD5iRn+SjcQLNLsNWsR6M20BFL6tUfeNfIrt8UrncnPN/isCfj8u408vyo9zHOy/hsYjpi5/Y8DLmBnIVRAj2Sil4akIscGYYEDlzBrCMvi0lgFDcF5gcxP4pq1pziujw6SiJ2U8Yohtrxu0xx+lfb5JQCt4+xy560UMqU3ax/9MxmB6g8ebos2MLwxOYiS9LWclMpeMtotW+nEqZ750NacnzIrIL5vF9aRtClbk5lMWdecxCgHzzuJvPY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(966005)(6486002)(508600001)(31696002)(2616005)(53546011)(26005)(6506007)(6512007)(38100700002)(6666004)(30864003)(2906002)(66946007)(7416002)(66476007)(316002)(66556008)(186003)(36756003)(5660300002)(8936002)(54906003)(31686004)(4326008)(6916009)(83380400001)(8676002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEpvcjhBUXBoalJLVmNIVWdxWHhqTzMxMjhPSWsxYytWQlpWZWhSTHkwOEc1?=
 =?utf-8?B?MnY4VUduR0NzREU5MHE3c2wwSlBsbnBlNTZnRDR5cXRwUE1sNy9lMmRMNDRv?=
 =?utf-8?B?YXY3TkFNUHdvQ1ZLV2JxMkxJN1c5ditOVG5ROFNwUVk2QXhxSjdTcUI4a3ZP?=
 =?utf-8?B?My93S0xvL0c1SisyTm5YTG9nVnpPTmQ2aGVVNXBjelR4NnVmWlcycjU4VUNE?=
 =?utf-8?B?eG9RNVgydWNnbjBjQlJta3lMbDJNRDQ5azd2amhZWk8wTFRZYURPRDFUem5P?=
 =?utf-8?B?YXRtS3Y1aEtIaW5XNFZxOVRMWHQ5bk1ZNEhoQ0RJQ3hrampldWhsb0VidUNF?=
 =?utf-8?B?WXcxWVZhT1lqYzk1RVRFalRqMm9Sdnk5dmcwTUZjU2VITTcyQnNwZHA5Q2p6?=
 =?utf-8?B?R2hRd3B1TnZ2UzdlR3YyMitnNStHYzJOd0VzSkNwVUQyQ1A1YTFXOWhTYklq?=
 =?utf-8?B?aXBwU0FGQi80ZlNuSSs3VU95U1BCcWpXQjkwNEZrcW91L0haVTJYNUV6UjYw?=
 =?utf-8?B?MnhkTXVVemVXZEpLczBoeVAwRXdpc3J4UnZyaFB0bzVOY0R5Y013aWRGaFo0?=
 =?utf-8?B?cG1UMWQ1TVo0emJ1ZFJ2QkxnRjU5bE9vK2o0cGlCQUp0TDllL3NxYXNMMmU2?=
 =?utf-8?B?SFZsemNuSUNxNUV2UG84WUtVRmNLeWNOclhhREx1TjhJVDlua251TC8zWDFT?=
 =?utf-8?B?WnhJNHFkTGlBdEJxK2RvQ3VyYjQ3dmYyZVR4N0NVZ05qUGJpMEJyUCt3WTl3?=
 =?utf-8?B?ZklncGJCclhvZ2lsOEcxVHhUd1ZZa3kyOUZCcGQ0SWYxQUpmUnVlc1RYWXl3?=
 =?utf-8?B?RTBYcTFRNG1RYjlOZjk3WDJZcXVDTVdzYUJ0aEpvek5BaHBNTmFWU0dtdlNj?=
 =?utf-8?B?Mkt6WjYxYzFOcnFYR1dmL0lNUUxEaWYxSWJGR1N3cUpTVnQ4aW5WRTNVSjA1?=
 =?utf-8?B?RnpZcFZTei9BR0RaUU1LL1lvVkk2cEJFMHBVY0hJZFNEYTRwZnBqdUxzcmdM?=
 =?utf-8?B?dE9mTDVhc2RmeFRhS0VBdHduNEx1a2VSZ1NoZ1V1dGpmbENBWFBhUUFnS2Zv?=
 =?utf-8?B?M24rQmFXMlI4Q2FqM0dZcU9xUm5oSDFOY1Fja0g3WHpGSVVTc3BVSXZSRi9F?=
 =?utf-8?B?elpPWVNtZ1o1SS9xdnhWMzdzdURNUnlKbkZPbkJuL1lOS2JkYjVQOGlqM28w?=
 =?utf-8?B?WVJrOHpvMldpRnd2UFhrQ2pKQjNXckcyVVFBZ1U4TVlIcmpaZEpVUWdoRmtE?=
 =?utf-8?B?WlZXeGZXamE5aGJ3WEFxSXN2T2lZa2F6R3NDQXNvem5JKzVPM1hVaHlYcU0v?=
 =?utf-8?B?aGU5YzREU1phNHBHMThrNWNLR0ZiZEgxdGtseVA5a1FydlZKaGZROTJMb0VU?=
 =?utf-8?B?ZHNBZEk5OTJNaFVZNDFXZHljRGVMbGZiRUpIMjQ2WUxzdHNwR29BK2RpRUNQ?=
 =?utf-8?B?djZUdHJzWmdyeENWU0lhazJCZkR5LytLT25yUFdVaHVrQVlqMVRKNEVUd05w?=
 =?utf-8?B?Rlo3SXFjTFZVZXJpOWlmNnpKTHdpaERvQkx2eHo3RmFqN0w1Rkd6ZTJXNzVj?=
 =?utf-8?B?aHhXUENpTWcyZ0FnbTFVaTNaTGFWM3RGQk9LUFcxUDhObGNiWTJXMVNKL2oy?=
 =?utf-8?B?WU9wVkdmbjNJWmxoQ3A0K3FTQ0xBWVJ5TlBSbEZ1L0dYVi8vOGNTeVJabWlT?=
 =?utf-8?B?YWNEU3RhejNvWUpBTUU0dTRjNWhNNW1JZ0pscUFzelNHNkEzWDY1dG5KbTRj?=
 =?utf-8?B?MTdnL2YwV2dab08zK3pLUy8vejA2MGlJanZCTnU5MTZtZnA2eHZMbnZUK2Fl?=
 =?utf-8?B?TExBQTF5WXpzSjV0QnBtRjNyRkw0dTd1bWFCRHFRWWtXSnJVQmErQWdpSW5M?=
 =?utf-8?B?czJ6dXdKek15TzM3QytrS2VuZlB6WU8wcVNTY3prM0Y5R0szb2laK1pTK3FN?=
 =?utf-8?B?NTRLMFhQOGRWSjVvdVg4T0xFa0pjTS9yaE53WGZjL1hvN2ZtL1JIbFFLS3VD?=
 =?utf-8?B?YnBjVS84V3N1Y0VwYTJ6RUNOVS9yMGlZMXkzNG1uMGxFMGNXNzNHU28rMmFH?=
 =?utf-8?B?SWlIc0IrR0ZkbW90cm1TM0FoajlLY3lPNWNJWkdpRk5sMXJvRzc3OWxiT29h?=
 =?utf-8?B?WHNHdlA4SVBOYVIyWXZ1NUNDcUVJeUtMVEdtVkplVkZlendFUlhUZDczL1JQ?=
 =?utf-8?B?S1lYREQzaGM2MlowQ0RMV0trbElSRFZXdXhUbVRDZktkUWN1UnpVQkdWMHdt?=
 =?utf-8?B?TXh6MVRvOXBPUGN4Q1hrejh4QUVLUmRyVnlDMDQxUDkzSytjWlM2V1NINXVR?=
 =?utf-8?B?V0s3TlNaY1A3dzE5VitDekJxMERpaXArODJIV2N0MlhXaXRGbU9LaGIzNXZE?=
 =?utf-8?Q?2CYulmZrHlgkflKk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b153d3f-c0af-4c58-5d66-08da29caf2ea
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 10:28:06.4749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jLHHlffAgS7s1S9bTrgoxNUBmN90bwEYSdXZszoFHoiyYzGImdcPD6dlrCseGyrEbGzeutA3+x9GJxMpePcULoeF84d2OJR7XtfP0xPwVVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3218
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_03:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290059
X-Proofpoint-ORIG-GUID: uikmzLCy-AjVMh6XW867QAL3BAxoI3qW
X-Proofpoint-GUID: uikmzLCy-AjVMh6XW867QAL3BAxoI3qW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 06:45, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Friday, April 29, 2022 5:09 AM
>>
>> Presented herewith is a series that extends IOMMUFD to have IOMMU
>> hardware support for dirty bit in the IOPTEs.
>>
>> Today, AMD Milan (which been out for a year now) supports it while ARM
>> SMMUv3.2+ alongside VT-D rev3.x are expected to eventually come along.
>> The intended use-case is to support Live Migration with SR-IOV, with
> 
> this should not be restricted to SR-IOV.
> 
True. Should have written PCI Devices as that is orthogonal to SF/S-IOV/SR-IOV.

>> IOMMUs
>> that support it. Yishai Hadas will be soon submiting an RFC that covers the
>> PCI device dirty tracker via vfio.
>>
>> At a quick glance, IOMMUFD lets the userspace VMM create the IOAS with a
>> set of a IOVA ranges mapped to some physical memory composing an IO
>> pagetable. This is then attached to a particular device, consequently
>> creating the protection domain to share a common IO page table
>> representing the endporint DMA-addressable guest address space.
>> (Hopefully I am not twisting the terminology here) The resultant object
> 
> Just remove VMM/guest/... since iommufd is not specific to virtualization. 
> 
/me nods

>> is an hw_pagetable object which represents the iommu_domain
>> object that will be directly manipulated. For more background on
>> IOMMUFD have a look at these two series[0][1] on the kernel and qemu
>> consumption respectivally. The IOMMUFD UAPI, kAPI and the iommu core
>> kAPI is then extended to provide:
>>
>>  1) Enabling or disabling dirty tracking on the iommu_domain. Model
>> as the most common case of changing hardware protection domain control
> 
> didn't get what 'most common case' here tries to explain
> 
Most common case because out of the 3 analyzed IOMMUs two of them require
per-device context bits (intel, amd) and not page table entries being changed (arm).

>> bits, and ARM specific case of having to enable the per-PTE DBM control
>> bit. The 'real' tracking of whether dirty tracking is enabled or not is
>> stored in the vendor IOMMU, hence no new fields are added to iommufd
>> pagetable structures.
>>
>>  2) Read the I/O PTEs and marshal its dirtyiness into a bitmap. The bitmap
>> thus describe the IOVAs that got written by the device. While performing
>> the marshalling also vendors need to clear the dirty bits from IOPTE and
> 
> s/vendors/iommu drivers/ 
> 
OK, I will avoid the `vendor` term going forward.

>> allow the kAPI caller to batch the much needed IOTLB flush.
>> There's no copy of bitmaps to userspace backed memory, all is zerocopy
>> based. So far this is a test-and-clear kind of interface given that the
>> IOPT walk is going to be expensive. It occured to me to separate
>> the readout of dirty, and the clearing of dirty from IOPTEs.
>> I haven't opted for that one, given that it would mean two lenghty IOPTE
>> walks and felt counter-performant.
> 
> me too. that doesn't feel like a performant way.
> 
>>
>>  3) Unmapping an IOVA range while returning its dirty bit prior to
>> unmap. This case is specific for non-nested vIOMMU case where an
>> erronous guest (or device) DMAing to an address being unmapped at the
>> same time.
> 
> an erroneous attempt like above cannot anticipate which DMAs can
> succeed in that window thus the end behavior is undefined. For an
> undefined behavior nothing will be broken by losing some bits dirtied
> in the window between reading back dirty bits of the range and
> actually calling unmap. From guest p.o.v. all those are black-box
> hardware logic to serve a virtual iotlb invalidation request which just
> cannot be completed in one cycle.
> 
> Hence in reality probably this is not required except to meet vfio
> compat requirement. Just in concept returning dirty bits at unmap
> is more accurate.
> 
> I'm slightly inclined to abandon it in iommufd uAPI.
> 

OK, it seems I am not far off from your thoughts.

I'll see what others think too, and if so I'll remove the unmap_dirty.

Because if vfio-compat doesn't get the iommu hw dirty support, then there would
be no users of unmap_dirty.

>>
>> [See at the end too, on general remarks, specifically the one regarding
>>  probing dirty tracking via a dedicated iommufd cap ioctl]
>>
>> The series is organized as follows:
>>
>> * Patches 1-3: Takes care of the iommu domain operations to be added and
>> extends iommufd io-pagetable to set/clear dirty tracking, as well as
>> reading the dirty bits from the vendor pagetables. The idea is to abstract
>> iommu vendors from any idea of how bitmaps are stored or propagated
>> back to
>> the caller, as well as allowing control/batching over IOTLB flush. So
>> there's a data structure and an helper that only tells the upper layer that
>> an IOVA range got dirty. IOMMUFD carries the logic to pin pages, walking
> 
> why do we need another pinning here? any page mapped in iommu page
> table is supposed to have been pinned already...
> 

The pinning is for user bitmap data, not the IOVAs. This is mainly to avoid
doing any copying back to userspace of the bitmap dirty data. And this happens
for every 2M of bitmap data (i.e. representing 64G of IOVA space, having one
page track 128M of IOVA assuming worst case scenario of base-pages)

I think I can't just use/deref user memory bluntly and IOMMU core ought to
work with kernel buffers instead.

>> the bitmap user memory, and kmap-ing them as needed. IOMMU vendor
>> just has
>> an idea of a 'dirty bitmap state' and recording an IOVA as dirty by the
>> vendor IOMMU implementor.
>>
>> * Patches 4-5: Adds the new unmap domain op that returns whether the
>> IOVA
>> got dirtied. I separated this from the rest of the set, as I am still
>> questioning the need for this API and whether this race needs to be
>> fundamentally be handled. I guess the thinking is that live-migration
>> should be guest foolproof, but how much the race happens in pratice to
>> deem this as a necessary unmap variant. Perhaps maybe it might be enough
>> fetching dirty bits prior to the unmap? Feedback appreciated.
> 
> I think so as aforementioned.
> 
/me nods

>>
>> * Patches 6-8: Adds the UAPIs for IOMMUFD, vfio-compat and selftests.
>> We should discuss whether to include the vfio-compat or not. Given how
>> vfio-type1-iommu perpectually dirties any IOVA, and here I am replacing
>> with the IOMMU hw support. I haven't implemented the perpectual dirtying
>> given his lack of usefullness over an IOMMU-backed implementation (or so
>> I think). The selftests, test mainly the principal workflow, still needs
>> to get added more corner cases.
> 
> Or in another way could we keep vfio-compat as type1 does today, i.e.
> restricting iommu dirty tacking only to iommufd native uAPI?
> 
I suppose?

Another option is not exposing the type1 migration capability.
See further below.

>>
>> Note: Given that there's no capability for new APIs, or page sizes or
>> etc, the userspace app using IOMMUFD native API would gather -
>> EOPNOTSUPP
>> when dirty tracking is not supported by the IOMMU hardware.
>>
>> For completeness and most importantly to make sure the new IOMMU core
>> ops
>> capture the hardware blocks, all the IOMMUs that will eventually get IOMMU
>> A/D
>> support were implemented. So the next half of the series presents *proof of
>> concept* implementations for IOMMUs:
>>
>> * Patches 9-11: AMD IOMMU implementation, particularly on those having
>> HDSup support. Tested with a Qemu amd-iommu with HDSUp emulated,
>> and also on a AMD Milan server IOMMU.
>>
>> * Patches 12-17: Adapts the past series from Keqian Zhu[2] but reworked
>> to do the dynamic set/clear dirty tracking, and immplicitly clearing
>> dirty bits on the readout. Given the lack of hardware and difficulty
>> to get this in an emulated SMMUv3 (given the dependency on the PE HTTU
>> and BBML2, IIUC) then this is only compiled tested. Hopefully I am not
>> getting the attribution wrong.
>>
>> * Patches 18-19: Intel IOMMU rev3.x implementation. Tested with a Qemu
>> based intel-iommu with SSADS/SLADS emulation support.
>>
>> To help testing/prototypization, qemu iommu emulation bits were written
>> to increase coverage of this code and hopefully make this more broadly
>> available for fellow contributors/devs. A separate series is submitted right
>> after this covering the Qemu IOMMUFD extensions for dirty tracking,
>> alongside
>> its x86 iommus emulation A/D bits. Meanwhile it's also on github
>> (https://github.com/jpemartins/qemu/commits/iommufd)
>>
>> Remarks / Observations:
>>
>> * There's no capabilities API in IOMMUFD, and in this RFC each vendor tracks
> 
> there was discussion adding device capability uAPI somewhere.
> 
ack let me know if there was snippets to the conversation as I seem to have missed that.

>> what has access in each of the newly added ops. Initially I was thinking to
>> have a HWPT_GET_DIRTY to probe how dirty tracking is supported (rather
>> than
>> bailing out with EOPNOTSUP) as well as an get_dirty_tracking
>> iommu-core API. On the UAPI, perhaps it might be better to have a single API
>> for capabilities in general (similar to KVM)  and at the simplest is a subop
>> where the necessary info is conveyed on a per-subop basis?
> 
> probably this can be reported as a device cap as supporting of dirty bit is
> an immutable property of the iommu serving that device. 

I wasn't quite sure how this mapped in the rest of potential features to probe
in the iommufd grand scheme of things. I'll get properly done for the next iteration. In
the kernel, I was wondering if this could be tracked at iommu_domain given that virtually
all supporting iommu drivers will need to track dirty-tracking status on a per-domain
basis. But that structure is devoid of any state :/ so I suppose each iommu driver tracks
in its private structures (which part of me was trying to avoid).

> Userspace can
> enable dirty tracking on a hwpt if all attached devices claim the support
> and kernel will does the same verification.
> 
Sorry to be dense but this is not up to 'devices' given they take no part in the tracking?
I guess by 'devices' you mean the software idea of it i.e. the iommu context created for
attaching a said physical device, not the physical device itself.

> btw do we still want to keep vfio type1 behavior as the fallback i.e. mark
> all pinned pages as dirty when iommu dirty support is missing? From uAPI
> naming p.o.v. set/clear_dirty_tracking doesn't preclude a special
> implementation like vfio type1.
> 
Maybe let's not illude userspace that dirty tracking is supported?
I wonder how much of this can be done in userspace
without the iommu pretending to be doing said tracking, if all we are doing is setting
all IOVAs as dirty.

The issue /I think/ with the perpectual dirtyness is that it's not that useful
in pratice, and gives a false illusion of any tracking happening. Really looks
to be useful in maybe the testing of a vfio-pci vendor driver and one gotta put a gigantic
@downtime-limit so large not to make the VMM think that the migration can't
converged given the very high rate of dirty pages.

For the testing in general, my idea was to have iommu emulation to fill that gap.

>> * The UAPI/kAPI could be generalized over the next iteration to also cover
>> Access bit (or Intel's Extended Access bit that tracks non-CPU usage).
>> It wasn't done, as I was not aware of a use-case. I am wondering
>> if the access-bits could be used to do some form of zero page detection
>> (to just send the pages that got touched), although dirty-bits could be
>> used just the same way. Happy to adjust for RFCv2. The algorithms, IOPTE
> 
> I'm not fan of adding support for uncertain usages. 

The suggestion above was really because the logic doesn't change much.

But I guess no point in fattening UAPI if it's there's no use-case.

> Comparing to this
> I'd give higher priority to large page break-down as w/o it it's hard to
> find real-world deployment on this work. 😊
> 
Yeap. Once I hash out the comments I get here in terms of
direction, that's what I will be focusing next shortly (unless someone else wants
to take that adventure).

>> walk and marshalling into bitmaps as well as the necessary IOTLB flush
>> batching are all the same. The focus is on dirty bit given that the
>> dirtyness IOVA feedback is used to select the pages that need to be
>> transfered
>> to the destination while migration is happening.
>> Sidebar: Sadly, there's a lot less clever possible tricks that can be
>> done (compared to the CPU/KVM) without having the PCI device cooperate
>> (like
>> userfaultfd, wrprotect, etc as those would turn into nepharious IOMMU
>> perm faults and devices with DMA target aborts).
>> If folks thing the UAPI/iommu-kAPI should be agnostic to any PTE A/D
>> bits, we can instead have the ioctls be named after
>> HWPT_SET_TRACKING() and add another argument which asks which bits to
>> enabling tracking
>> (IOMMUFD_ACCESS/IOMMUFD_DIRTY/IOMMUFD_ACCESS_NONCPU).
>> Likewise for the read_and_clear() as all PTE bits follow the same logic
>> as dirty. Happy to readjust if folks think it is worthwhile.
>>
>> * IOMMU Nesting /shouldn't/ matter in this work, as it is expected that we
>> only care about the first stage of IOMMU pagetables for hypervisors i.e.
>> tracking dirty GPAs (and not caring about dirty GIOVAs).
> 
> Hypervisor uses second-stage while guest manages first-stage in nesting.
> 
/me nods

>>
>> * Dirty bit tracking only, is not enough. Large IO pages tend to be the norm
>> when DMA mapping large ranges of IOVA space, when really the VMM wants
>> the
>> smallest granularity possible to track(i.e. host base pages). A separate bit
>> of work will need to take care demoting IOPTE page sizes at guest-runtime to
>> increase/decrease the dirty tracking granularity, likely under the form of a
>> IOAS demote/promote page-size within a previously mapped IOVA range.
>>
>> Feedback is very much appreciated!
> 
> Thanks for the work!
> 
Thanks for the feedback thus far and in the rest of the patches too!

>>
>> [0] https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-
>> iommufd_jgg@nvidia.com/
>> [1] https://lore.kernel.org/kvm/20220414104710.28534-1-yi.l.liu@intel.com/
>> [2] https://lore.kernel.org/linux-arm-kernel/20210413085457.25400-1-
>> zhukeqian1@huawei.com/
>>
>> 	Joao
>>
>> TODOs:
>> * More selftests for large/small iopte sizes;
>> * Better vIOMMU+VFIO testing (AMD doesn't support it);
>> * Performance efficiency of GET_DIRTY_IOVA in various workloads;
>> * Testing with a live migrateable VF;
>>
>> Jean-Philippe Brucker (1):
>>   iommu/arm-smmu-v3: Add feature detection for HTTU
>>
>> Joao Martins (16):
>>   iommu: Add iommu_domain ops for dirty tracking
>>   iommufd: Dirty tracking for io_pagetable
>>   iommufd: Dirty tracking data support
>>   iommu: Add an unmap API that returns dirtied IOPTEs
>>   iommufd: Add a dirty bitmap to iopt_unmap_iova()
>>   iommufd: Dirty tracking IOCTLs for the hw_pagetable
>>   iommufd/vfio-compat: Dirty tracking IOCTLs compatibility
>>   iommufd: Add a test for dirty tracking ioctls
>>   iommu/amd: Access/Dirty bit support in IOPTEs
>>   iommu/amd: Add unmap_read_dirty() support
>>   iommu/amd: Print access/dirty bits if supported
>>   iommu/arm-smmu-v3: Add read_and_clear_dirty() support
>>   iommu/arm-smmu-v3: Add set_dirty_tracking_range() support
>>   iommu/arm-smmu-v3: Add unmap_read_dirty() support
>>   iommu/intel: Access/Dirty bit support for SL domains
>>   iommu/intel: Add unmap_read_dirty() support
>>
>> Kunkun Jiang (2):
>>   iommu/arm-smmu-v3: Add feature detection for BBML
>>   iommu/arm-smmu-v3: Enable HTTU for stage1 with io-pgtable mapping
>>
>>  drivers/iommu/amd/amd_iommu.h               |   1 +
>>  drivers/iommu/amd/amd_iommu_types.h         |  11 +
>>  drivers/iommu/amd/init.c                    |  12 +-
>>  drivers/iommu/amd/io_pgtable.c              | 100 +++++++-
>>  drivers/iommu/amd/iommu.c                   |  99 ++++++++
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 135 +++++++++++
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  14 ++
>>  drivers/iommu/intel/iommu.c                 | 152 +++++++++++-
>>  drivers/iommu/intel/pasid.c                 |  76 ++++++
>>  drivers/iommu/intel/pasid.h                 |   7 +
>>  drivers/iommu/io-pgtable-arm.c              | 232 ++++++++++++++++--
>>  drivers/iommu/iommu.c                       |  71 +++++-
>>  drivers/iommu/iommufd/hw_pagetable.c        |  79 ++++++
>>  drivers/iommu/iommufd/io_pagetable.c        | 253 +++++++++++++++++++-
>>  drivers/iommu/iommufd/io_pagetable.h        |   3 +-
>>  drivers/iommu/iommufd/ioas.c                |  35 ++-
>>  drivers/iommu/iommufd/iommufd_private.h     |  59 ++++-
>>  drivers/iommu/iommufd/iommufd_test.h        |   9 +
>>  drivers/iommu/iommufd/main.c                |   9 +
>>  drivers/iommu/iommufd/pages.c               |  79 +++++-
>>  drivers/iommu/iommufd/selftest.c            | 137 ++++++++++-
>>  drivers/iommu/iommufd/vfio_compat.c         | 221 ++++++++++++++++-
>>  include/linux/intel-iommu.h                 |  30 +++
>>  include/linux/io-pgtable.h                  |  20 ++
>>  include/linux/iommu.h                       |  64 +++++
>>  include/uapi/linux/iommufd.h                |  78 ++++++
>>  tools/testing/selftests/iommu/Makefile      |   1 +
>>  tools/testing/selftests/iommu/iommufd.c     | 135 +++++++++++
>>  28 files changed, 2047 insertions(+), 75 deletions(-)
>>
>> --
>> 2.17.2
> 
