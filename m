Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7CA516F1E
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 13:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiEBL4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 07:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiEBL4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 07:56:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182DA1A044
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 04:53:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242923PB004092;
        Mon, 2 May 2022 11:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+0UAXyhl5kGR3D/varIm0vUZUbXXazzl6816tDQFpoI=;
 b=T+ikej9T1v0LIoow3zk1i80DDBc3KryZktjegfiMH6dTbwxRkq3zaPI+ebZopJAmM/+d
 u1NT2JH88kjF4Cfb9kAbe339YKXRAusvwZQ9V9hPqbaNezkYhyBVSOBFHLWfKWaz500i
 4akw9EvfkCQHZv8589zgItz+oXTwx0D16LSj1Oz6g3H6bObcbUpioehmhlhlJIi26DdP
 pADfyocjv6dwPCgOl2hOaRYjijt2HbOUtU/PmscRxet8Zpn89faNxwDKU35yuIpDVUgs
 l4B1N2ukivK3oeymFbCtsmBgaKreath+lQtWFj0bU5EeBzN/fRetSNLtXmHTk6Q5BmJZ Kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0ajxg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 11:52:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 242BkNWq020518;
        Mon, 2 May 2022 11:52:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj7xq81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 11:52:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+5ul2OiKEJjTB7QyRq7QhJ6G7hFIHeBYZt/XIM+ekh9190Rr2JYZTvKfvVsXr73Pi+Woc49Aalamdpv1Ur8ELVNIEJewZ768dja4mTHkBFFBe5P2XJ2vju7bcDjWYYc6Nurdurqv9jThueVPjtzWSCWBabg6N/lAiC0opz8xZJwLhsGJx6C6w1CxokxvQ243gjZOKBhyPxIPId24Dhrv4i6d4+OQMIiKX73e/34Oo0LzNW37O4Pn32kYndfDLpFIL3VFCc9mo+QjGql1IdUMze/LnHbbT/+HDPn9QxriBf4ZukTMzyOM37uDc9JTk2FC8PutcMFZBsYYKF7h8RinQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+0UAXyhl5kGR3D/varIm0vUZUbXXazzl6816tDQFpoI=;
 b=QVUqrzVgfgDZ3MbLzLPxCxOS/Moy9MuJPQSCDijFZdUUcr1Jmg0MpRdsp/ix27kGDbvjoS9/SPWtYGn7v7sB4xTz4g7R/cqzmG7VPjLOwUOb7oevLtWG6UR0eC7ymK24lNL5wDD0qiuuxDWogT12oeCwX+uoYUYJMY6hF6qW/aNpNuBxpmV3As1rmxmBj0bRce2HD0SbWvxiH+mgtC1R1JFQblwtDROlX09Hou+tGN5757HPPuveYKYTc85c5uOniWFJ8HZJe2LdR49YaCwXd/x6TAWOYnIR0MUPyXdk1fVmzoqhOk0kHSuWhc9ZvWoUeW3DO27R1WfitPdAU/RblA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0UAXyhl5kGR3D/varIm0vUZUbXXazzl6816tDQFpoI=;
 b=DULWkpy8CPRY6rCoQSam/ShS8HRzlJoaKJfCwFXxWcj4ULiWNzrvzlLU5l3aFAY3YFL6O+0WDToGNlecPicvvHU8xoMZeI4bAXPVjisbG+M2+aSaSUDOXznluQBJ5KQ0SfznFF5wiuZpQGzgKEBh3TVcpUjYH7tTOjRR6PcCPtU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA2PR10MB4700.namprd10.prod.outlook.com (2603:10b6:806:11c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Mon, 2 May
 2022 11:52:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Mon, 2 May 2022
 11:52:31 +0000
Message-ID: <8b01b261-7385-8247-4d19-3ac2dd2306b1@oracle.com>
Date:   Mon, 2 May 2022 12:52:22 +0100
Subject: Re: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-16-joao.m.martins@oracle.com>
 <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
 <a0331f20-9cf4-708e-a30d-6198dadd1b23@arm.com>
 <e1c92dad-c672-51c6-5acc-1a50218347ff@oracle.com>
 <20220429122352.GU8364@nvidia.com>
 <bed35e91-3b47-f312-4555-428bb8a7bd89@oracle.com>
 <20220429161134.GB8364@nvidia.com>
 <e238dd28-2449-ec1e-ee32-08446c4383a9@oracle.com>
 <cab0cf66-5e9c-346e-6eb5-ea1f996fbab3@arm.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <cab0cf66-5e9c-346e-6eb5-ea1f996fbab3@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0141.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::46) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83cda808-1bcd-439b-75e9-08da2c323cf2
X-MS-TrafficTypeDiagnostic: SA2PR10MB4700:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB470009DD2D100C27500E321ABBC19@SA2PR10MB4700.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o5lcnBsGmJiQrcRHpuoB8nFyxuzFbzPahcIVmD98uLYjk96jyJYNaVPvnaLbvPPNItvj1OA/q/cv2IHiolR+cLtXN0KkMHpVHeh/VST7ouwLaYzn0sqzqZTWEzRtxoo5135MK9H/v+Uo+td33a16lFNqHeaQK9WR7V0xS5tS5poga3CctT0Fv+rnzc171HZSGN02O+HIYcXvkp1Z4AdwR/l+3SpiBbUA4VI+It+bG01Rdfh0ljmouANS9o84MJdPBrmGHUWBsKdnWwALsVJ02yjoTH/iPzuJQNo+8OQLOAmPfFIRdCrrdUp5/Vp4j6i8YkQ6C5abP1+2SxbUgPTWWUkpfIRI/Fj0gOAk6DCBG0kd6Ac8OfvIsZneWVE46zOEugwxHwOWZ/iJT/ysfCTa+w8BYLty08OuZAOACqJatts8BJSB3W77rHu1IX4+a5053zS1nx8Yu7LjwWIMeb7wxoByJU3jzVL1l5GJ4wf7m3t6oVbqTeiCizhVtZMy6XuEdKskS4xTwnpehtGhT/tyMyyFSLPPMsnef0eITTQ5pttIYWyGkkvHiampWYMzVg88gn0bFHIzZ6z4DMoQOV+5kiKPqJK6UfyfIwLwaznPkica+wJG28KX62pOaBLEX2je3r8InvCDuQ43zR4wrNnYmTJyMvq0kfxz5iPvKopw1AL+iqMBxCvKbyumYrjKzud93TWSHtnSmtdb+CABnU0MZfjntcUTgRR4+rpsYW1VjWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(8676002)(6486002)(66556008)(4326008)(186003)(66476007)(31686004)(316002)(36756003)(7416002)(5660300002)(31696002)(86362001)(2616005)(8936002)(2906002)(6666004)(38100700002)(54906003)(110136005)(6506007)(26005)(6512007)(53546011)(83380400001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXJQSmdNcjZIR25WN0ZsSDY2UldSMFhBVFR5R3R5blEyUUJXNDc1dzE5MEdj?=
 =?utf-8?B?Zmp0bk1ac2ZHMVFtSE1jdzZsSUdDYWQzK1IzemZzVGxocUkrdHZiWjVyejVX?=
 =?utf-8?B?eHd5RVVyTzZkRktsU1Q2TVJzNWRNUHhHSU5GcHdSSFdLTktuYTF6ekt5MjRj?=
 =?utf-8?B?U1pMbm9IMmtWcDdlQXZqOUU2MnFJR3NEZkc3Z0VxQnpVRnU5Wll5bVFGMm1F?=
 =?utf-8?B?UkZ0YzJ5dzBzZSszSlRXLzM2eU1BRzFJL2JpY1duQUs5L2JJYUxoMXovZHZN?=
 =?utf-8?B?UE1XNDhIU2FYVmNJN0cyY1gvY1orVDdEa2ora29kVVlWOGtrSjRvZTZPenF3?=
 =?utf-8?B?VXlzY3NwSTlXUVBKamIxWVdsSXhRNlhhZW5odmc2bnJnRE56SUZjc2pVM2lR?=
 =?utf-8?B?WUlkK0E1R20rdkt1cmdNQjlTNCtxSDBaNTFNMWs4WENtaCtReS9FMlMyUFFC?=
 =?utf-8?B?bjhqakpmTkhYSVIwMzZUQnhWUFFUaGtNNFdZcG5OSXFHRTYvbTc5RjB0bGNw?=
 =?utf-8?B?c1dmeVJYbjdnK2hqSzZwbFJqVHFuZ2k2M0dNLytlMnVtV2YrNWo4OE5HVTgv?=
 =?utf-8?B?UytnUFNnc0ZFZjhrelg5NUxva1BsajdPMFRhMjFjWDZablorak1memxnYlRB?=
 =?utf-8?B?dmVULy9uQmYvMWhoRkdUS0dlQW56eHFZclcxMFZlUGcvUnArODJnQ3FGcUNo?=
 =?utf-8?B?Y0dMTlJvY2t5TytMcyt1b3VxMDNkb2QvYlhIalpMTG55UHVDNmVnNitmd3k3?=
 =?utf-8?B?K2VQMVcvc25jbHIrc2pRU3JWNktpam9TNGxyQlR6RFhNc29QRWtlUy9aeWN1?=
 =?utf-8?B?OVNjelVTTy9ma0tLNkVHNnJ2enVsY0xyazlMbC9UQkRvT2VMRXo5a3IvbnpU?=
 =?utf-8?B?YVB4WFgyY0JPZFdzczNaT0pxY0FBczBlbk43Um83cGdXZnJWYnpTbGJCT0ZZ?=
 =?utf-8?B?YzhLM1pRMXBmRnczN1cxaEh0SlBacUhBR0hWOStuakkxcTBsN2xDSUZUTHZ6?=
 =?utf-8?B?NDZTcUVYMlFtRkdPRWxGNmdzWSs0bE5uVGxrcEVhSi9wS3JGcHAwbTByS0F0?=
 =?utf-8?B?Uk5FOTV1K0xmM1lJeCtabFo1ZXNyaXN0UXhsZDhtVEdwck0wcVVtNjB2M2gz?=
 =?utf-8?B?SHU5R2pWdDNSYlNGV2NkQjI5ZEN6L1lzaXhDbGdZZHZkQ1pXNUFuTWp2Q3pL?=
 =?utf-8?B?UTZLUC9KR01qaGNQR3hGYmYyOS95Y0pudUs4bXJ3N3NJUS9kYkZ1N0lBZUQ2?=
 =?utf-8?B?cnkzSGk3Skc3MlF2M0ZsankvMXdBazBMSGV0NUhkWWFZSVAzOU1XS3pmVVNY?=
 =?utf-8?B?U2RrSnlRNm54cVpPZkhhWjVxTUhvc2YxKzlOa0FBYlJBQVRBNWo2WlpyUXVQ?=
 =?utf-8?B?TmNIT3JpdzcvVTFLY1NiSm5aVURkbEJjZHRIVUFaeUFPZkVvZXloM0lBYXdz?=
 =?utf-8?B?b3RscmVXdHRYbk9Fd1BmWjRuK1hETkFSR0RKSDcxdDY4M2lCWVp2Nld5RWJy?=
 =?utf-8?B?V1RyNnAyOTZzS09iVlRhNVRHM1lPWnRSYnVsT3lrMSt3Wnd6cW9ROGxpWURC?=
 =?utf-8?B?S0ZTQnhBejlqTmZNL21mdEx4MTlIak9GS3I0ci9FNEJrd2cxS1dsRTVqbFdB?=
 =?utf-8?B?R1lSNnY3OWR5OFVXd1RwVHBneUk1QjFXY0Q0U0tmd24zKzhLWXFTMTd3NUlI?=
 =?utf-8?B?YTlESHo0dmV1Z3FhSmxTSnArUCtCeXlaSVJPaVJJU2tNV1JjalFqMCtiRnRF?=
 =?utf-8?B?MjRHRkE3dGtscDRHZjlaUHQrMU9vODgvdTEwcklUZHFYQ2d4NUlvSUl3ZnMx?=
 =?utf-8?B?cm5oN3AxS0JtNzl0eVdHWmJ0c3pndFZFLzBNOW14akZhTWI2WFNkU2FCUnVV?=
 =?utf-8?B?UDREZUxyRHNyMTFJajdtN3p3QVlBTmdwRllXQ3I4NDBydjk1QXNoVlZlZ0dS?=
 =?utf-8?B?ZzQzU0JlT05DbGtPSi84dzBXdUtMbEFsSG1lUytvVVRES1J0NVBYdEtRLzgv?=
 =?utf-8?B?NVArM0RvZWNuN0ZsSEhqK2tUT0Y2UG8yOUhBUFgxY3FhUlJQcDlNc25NTmU1?=
 =?utf-8?B?aWlCbFVCRVVKemt0TXBlK0Q5ek8zOW9CQmRPdFJEMEthbkM5Q1NOQlJuVlMr?=
 =?utf-8?B?cHVuTEFRbXg0TGFOVE0yanBzbThIZk5sWmRKOTBRQ2EwSFhtSGxkcUxDSU95?=
 =?utf-8?B?bW9GVFNKbVhpWk1kZFR1emk5YkhOc1p4WDA3U1pSaS8yWXFFQmZZbm4vbmtM?=
 =?utf-8?B?UFdNSUlkY3c0S0hBcWdQdUZJcDEwckJlM2cvcVdmMmpQUkE5cnJXcC8vaUtF?=
 =?utf-8?B?dzU2WHd0eVR4dW41dnNRVXZFMWdhRnlvOFdiSFNoaVBzcmhpK2VpZFVJeCsr?=
 =?utf-8?Q?+kmjBWtWAQZDq95g=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cda808-1bcd-439b-75e9-08da2c323cf2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 11:52:31.1668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: opAXLuhqAZn8lqnXQixmKo9OqVIAIJL2O37AQsFjAJ5RYoY6muBtR5FCGb80sUVf7q8Xu0YrNhy5AFCD/KsXMc+Bsmr1wu6t3H29CYFAaAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4700
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-02_03:2022-05-02,2022-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=561 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020092
X-Proofpoint-GUID: bJNaHvEqalyCB-X0WjXx6S2PepjA-ApX
X-Proofpoint-ORIG-GUID: bJNaHvEqalyCB-X0WjXx6S2PepjA-ApX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 20:20, Robin Murphy wrote:
> On 2022-04-29 17:40, Joao Martins wrote:
>> On 4/29/22 17:11, Jason Gunthorpe wrote:
>>> On Fri, Apr 29, 2022 at 03:45:23PM +0100, Joao Martins wrote:
>>>> On 4/29/22 13:23, Jason Gunthorpe wrote:
>>>>> On Fri, Apr 29, 2022 at 01:06:06PM +0100, Joao Martins wrote:
>>>>>
>>>>>>> TBH I'd be inclined to just enable DBM unconditionally in
>>>>>>> arm_smmu_domain_finalise() if the SMMU supports it. Trying to toggle it
>>>>>>> dynamically (especially on a live domain) seems more trouble that it's
>>>>>>> worth.
>>>>>>
>>>>>> Hmmm, but then it would strip userland/VMM from any sort of control (contrary
>>>>>> to what we can do on the CPU/KVM side). e.g. the first time you do
>>>>>> GET_DIRTY_IOVA it would return all dirtied IOVAs since the beginning
>>>>>> of guest time, as opposed to those only after you enabled dirty-tracking.
>>>>>
>>>>> It just means that on SMMU the start tracking op clears all the dirty
>>>>> bits.
>>>>>
>>>> Hmm, OK. But aren't really picking a poison here? On ARM it's the difference
>>>> from switching the setting the DBM bit and put the IOPTE as writeable-clean (which
>>>> is clearing another bit) versus read-and-clear-when-dirty-track-start which means
>>>> we need to re-walk the pagetables to clear one bit.
>>>
>>> Yes, I don't think a iopte walk is avoidable?
>>>
>> Correct -- exactly why I am still more learning towards enable DBM bit only at start
>> versus enabling DBM at domain-creation while clearing dirty at start.
> 
> I'd say it's largely down to whether you want the bother of 
> communicating a dynamic behaviour change into io-pgtable. The big 
> advantage of having it just use DBM all the time is that you don't have 
> to do that, and the "start tracking" operation is then nothing more than 
> a normal "read and clear" operation but ignoring the read result.
> 
> At this point I'd much rather opt for simplicity, and leave the fancier 
> stuff to revisit later if and when somebody does demonstrate a 
> significant overhead from using DBM when not strictly needed.
> OK -- I did get the code simplicity part[*]. Albeit my concern is that last
point: if there's anything fundamentally affecting DMA performance then
any SMMU user would see it even if they don't care at all about DBM (i.e. regular
baremetal/non-vm iommu usage).

[*] It was how I had this initially PoC-ed. And really all IOMMU drivers dirty tracking
could be simplified to be always-enabled, and start/stop is essentially flushing/clearing
dirties. Albeit I like that this is only really used (by hardware) when needed and any
other DMA user isn't affected.
