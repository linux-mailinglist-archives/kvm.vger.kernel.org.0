Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A7D5147A5
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 12:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352119AbiD2K7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 06:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358065AbiD2K7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 06:59:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2E4A76F2
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 03:55:54 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TA22MZ003693;
        Fri, 29 Apr 2022 10:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=I3VuNR+MEdjd4x8XJ4emUCD/VrFccaasjvBkPfcfx80=;
 b=jUrr8z77CD/tSm/uYn1XIlq4AzjtJOgnKOnCK9mPDH1tXvbArawDydsjPy0TqVeYAxo/
 tiRxHkSCuCshj7Ta+o24rIWp7vDLP1L/qlGBmvm/L98rgycqthZYYk7vTqkRXHdfe8lQ
 N8VHOdfsxUodKrC5Gmu8xCyNXsvoCoz4w2MWLvZJQ/9nkhSANI1v7qbZNRy8/lMEbKFg
 PinY8la+LwNcnTcAhkzwFto1+lZi5g8mMmLZ4YCdoQwdasWGQHMS6JdR2fDY4w/95nfS
 /nPkoUTjq8oma/1BRc02fVFQB0T4R2PduKOd7/6Dphlv7WZpSGAoiUoCOZdM6xE6h9Dz 7A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4wyr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 10:54:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TAnOCQ018532;
        Fri, 29 Apr 2022 10:54:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w7x3tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 10:54:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6BJTTvfPnX00c4cBaeOJWOhULg6FfStY7q7AgdKaxkNvPCL9Pu+jwzwJanGkdpvO50X1KE4qZhT/eqZ17ENEnotOdUHTRGLoykF6zT6GR9zQ2sW61cAjFv8CxtOFduTjGDozoWKTB/98ym/E8u2eIgokkGhk6EZnV4lfiYQK+ag2V4cbIq+XuDt1fKv2di0+EJWaQRL1a/64MUjayFxdQTrA4y8HN62LxuWE6QiGEl29vYq4Zh91BMNDb3ZrqIBqSdM9LKJG+JJfXgCxQE13MjpxEqHU3+0C3ggN8iWHDcasIgV51jJUTTnK+apFwwCZOMEXyZGLbPs6zpuSmOPnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3VuNR+MEdjd4x8XJ4emUCD/VrFccaasjvBkPfcfx80=;
 b=CEk2lmUNpH6HLAZWxmHHaeoNjjoqpn57uO5KQbR94KQXbo7dZsu+uAEXmenSYrC2ENPlSSPAsBYGUm6jyLcu1nfmbUh6Q36j7JtEG334Nt1Vu7+woeuH7aQI43y7FE6NAwLMBNXXc22MDwMzwysDohqNz5is0/+RvSkam+jT1jwK5Fg7h1/1wXkTOjCxbXPXH99DeNJW6cnhCBy/mfq7jTpJGm9VI0cWzU7M9YqzBFedASspQmFzGkXk4pvwCNvXaDFLCnTYIQp6cmKMY28mVRcrrhizaXKeXmXNdMIYZjQNTR+tpay7LPz4ioLSImYD1wB3cXcqL4nHBtnNuRltwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3VuNR+MEdjd4x8XJ4emUCD/VrFccaasjvBkPfcfx80=;
 b=pMAwV5lDwiJCwr8WzN3ny4W4KcufLk50VHO1tQOiBi3hkesNKqQ4Wd57UjmEkk5soXkyG9b1IaxF4B51tS/ff6wkrQBG9OuWmqvMk9Ev36E2oKqPGo0Y5NAAw/fSQIhbSaXsLlnssfOrtSJFd9speW42WYL9FXNMuGRf9HoIIDo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY4PR10MB1398.namprd10.prod.outlook.com (2603:10b6:903:30::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 10:54:23 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 10:54:23 +0000
Message-ID: <ef762630-c466-af13-c8a3-da3f360b334b@oracle.com>
Date:   Fri, 29 Apr 2022 11:54:16 +0100
Subject: Re: [PATCH RFC 03/19] iommufd: Dirty tracking data support
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
 <20220428210933.3583-4-joao.m.martins@oracle.com>
 <BN9PR11MB5276C829C3F744BD4F4932B78CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB5276C829C3F744BD4F4932B78CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0035.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5b42f79-8e3e-42d6-22bf-08da29ce9ebc
X-MS-TrafficTypeDiagnostic: CY4PR10MB1398:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB13981919765DED740614DD61BBFC9@CY4PR10MB1398.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UeTNsJSURXF6agGBCSpUxLv/OYlrDAAlJV+u+h7x8y2t+MHHUaaFBh/8I9ZNYF0G3BIsGMnYQJORiVuzYHaEGW/No53Ce05b/LrR7dSQ7rDRT9IWaTT0ZKFAQom7E/pNmsoeCIWI98Jqrbc5p1FGgIGZYum2Ef3zteHnA7YEhacESBJNIuvOv3o3TB8WhI6VQ/z1smZyr5p4Gz7GHQ33iwKaWA29Xuq1B5Aw0hRC5g/ZNB/lPcKYB9K4Rn1sCE6dOhS7fbZU1Tn54TRfpAvl5JuQwZ7pN12msm71uzBd8U5QH/GjDVC3YUGUqIR/gOUxlw2A+nDJRXVsIupg9jEgAholTIryfnmgC4GTIWrhR/M9FczZtVsvGSdXqzTqj4MFk3vRE+sfSjLMzAgDFW6v29/mLMYyYej/08lOUS7vClYxlv7AzyFnPpDJAZohsoGu2gXy1h7nSJ4MyydsfASGRcOh4I+LKiulYzvMv3jdYlKdnoVUCA3YBj1IUFb2KroXMxoj3VCzkYkfG9IiY0WFiKRb3yOHKH7YAvqfLrDaLgExU6mQFlk975E83uWa9r+NPXcqVeFlfRoHb/u6TCxKBAZjMJjtYlH/SREp450pd2gS56QG4/eIllac56onz6UUBtC5tUwl1O2J0LV8wQoQQzwPBcY0sF78sNBByLox9uwl9XAoiS1nBSVqUQXGRwmi+OZHADtyZp97Utg0mRS/cbd+OqurmAzoA/0/7sKci1aWTpO52XVWoWn0IXC/+fCn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(86362001)(508600001)(6512007)(8936002)(186003)(6486002)(7416002)(5660300002)(26005)(316002)(6506007)(6666004)(38100700002)(53546011)(2616005)(2906002)(31696002)(31686004)(54906003)(4326008)(66946007)(6916009)(8676002)(66476007)(66556008)(21314003)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3k3YjR4STlBb1VXa3kraE9NSzJaY05oamc2Wk51ZEd0Q3J1NldCd3hDWGlS?=
 =?utf-8?B?Tjd3SUhmd3AyWHBybVgzMVdKWEt0dExhd0tyRmdrUG1neDlvUzRFQjBnSU5n?=
 =?utf-8?B?ZEZ6cVRZczJUSjhQdWx2WnRlNlpVVTdmVVV1ZXJwcDUrWHRBa0JuaHlGNlB4?=
 =?utf-8?B?T1VBbmVBTlBGcDN1ODhzSlBtUWtiNlRJUVZYVngyVFpQM2lnNjdOakkvZzBU?=
 =?utf-8?B?b2FVZUsxaW15bHB1ZkxxMW9CZzZmVE5sS2JSRzUvK0RkOTNySXA2ZUY0Y0lm?=
 =?utf-8?B?TGIzd0h1NVJ0YXYxV3FSUk4wL3JjWHJuZnFLMGtYVVdJVCt2SlVmaUROSzdK?=
 =?utf-8?B?Lzk1T09RbDE4b0RlL0pIZWpKME9CWXhadkpvdVRRLzR4MTEweE5wTFdTRVVD?=
 =?utf-8?B?Z2lIdnA1aFpJWVhxSVU3K2FDcStvTXlGVVRUQ2s0UE5mSjFxdTJjUHREanFm?=
 =?utf-8?B?NXV0VDRYS3lrcjZYS1NZODQ3MDFkM1hPWTlyM1pIOW43Z1FWQ0E5T1kzN01J?=
 =?utf-8?B?ejg0VDRGNUVNWk03d1pwNk1XaVV1MTZpaEQxR2dWVWJOaFlQREpnZGlsb1Y0?=
 =?utf-8?B?a29SaFdObTVlaU0reDFvR0EvU3YvQUw4TEM2MkcyMlJKNXVmTThtVTlReXJp?=
 =?utf-8?B?dm4wWnFlbkZ5NzAxdTNoWUpLZGxHY3BjY3lqc3hMNVg3OThSS01heEI0VldQ?=
 =?utf-8?B?SkszU2pOYS9GVVFla0lMbmlMMkJpcHZLK3JMS0s4VXBrbGZiQSt4c2tNdTlu?=
 =?utf-8?B?VUpPYU5lQW5PVy8vOTFMeFloUzB3eGxlMmxaVkNoaUFuOXhIcnBvK1ljNU5F?=
 =?utf-8?B?aFRqcUk4aFVUZjYxeFU4Y1lzWUZzNjE2bUZFMlY0MGQ3Y1MrSTBZMllwQUtF?=
 =?utf-8?B?eUxPYTIrbXdqZytOQUtTWnYwTmFud0k5MU1XSUNXYW1DTDVLQTZCWENZc1FK?=
 =?utf-8?B?cW56V2dlUlBaT29MWEZ6RWFpK2pIUGNuL3FGRTF5NnJzZjdPaDYwMGV4cDNt?=
 =?utf-8?B?UnY3WEh3ZStBNHI4eGgrVzRWM0g4S293MERSYXhkNmxmQlRFOXJoY3R4b25P?=
 =?utf-8?B?eVdhSlBwUmloVlFHeFpNZndmRVcyYmJwMVBJQjN2QXdxOTRPK2dJaHc2RUNq?=
 =?utf-8?B?MUp1dFhlZG1pUDRieGFEOHBuUitwcFhKNzZ0L0R1MWpwL2tTc0Qwdmk2dUE0?=
 =?utf-8?B?T1pMaWFqTkMzY0grelhXeWRxR29xZ001dWlEZHlpajJMUGRORG9MalBKSVdS?=
 =?utf-8?B?Q0ptY21xUlIwQVFmWmJQck9IY2pYRmIvSi9hRll2cnR3ZFhuTnJ3TGRrTG5Y?=
 =?utf-8?B?dFdSaVA0eGkvajRyb05xQmdvZ0lBM2VOT0ZkcEF2eWpjT0IzU081WHdBa256?=
 =?utf-8?B?V2ZIa0hQeSt3YnR2aW9SdHIxbm5UWnEzZUVHVzBSUzNiWmcwbXpEN0RRMFA2?=
 =?utf-8?B?UjRwSmFnNlR1NzJVMElKNFlBOHBkcTFGdUkvbXBSV0tJdjJzQ0dFM20wMFJJ?=
 =?utf-8?B?TmoyUFJyRzViSDNxQUtYQlVxdzhHeGtXd0oxN3kvSjQ4M1NVL3ozSC9vSDFK?=
 =?utf-8?B?TlJ6b3RIR2xieGE0akUraGJzamo2ckZveGF0RzBtQ21kQW9oWnJrSkhBZk9w?=
 =?utf-8?B?bWhjYzhwcG5hT3RZeHJ2TnZPUkJ6dUVxOHJaWlgxQTU5Q2xmQ2lNb2ZyN1lK?=
 =?utf-8?B?ODNVMlNTNlJaaXU3MVRSd0twRjMzYU9MYXBIdDdvbWVLU0NzTlhjK2ozTWlr?=
 =?utf-8?B?RGZBNzZKR05sbmRDVHBJWHpuaWM3QjlMWEt5cEhDWEtuTTBXR1JMNWV0Njh5?=
 =?utf-8?B?dDVFbHZlRHJZVmxKQmo3UXBDMmhFT2hCUWhOd2NOTGRhMm9MYmlyTG9SNFFS?=
 =?utf-8?B?NlJpV3Z3WnZkcE5ZUkVicFVQSVlobGpuMnY1YU9FUjA2cFhEdHl1TVRQaStM?=
 =?utf-8?B?Z1N2OE9VUVBVUk1IcnhnU3JXMG05NzV5NTZxaGRyYmVsMFA0YWx5ZHBQdFVC?=
 =?utf-8?B?RXZpWmZhWGI2VHRhd055U3ZhL0djdnV3YVpVZUNMZjU1c0dHSDhycnFEVEdv?=
 =?utf-8?B?OThCanJONjlvZFgxMklsT2phL2pzNXZTb2ZqMjdKRmRIUlF6cldkOStlSVN2?=
 =?utf-8?B?QXNhYVZkYnFmMkw5UXZpOVpWQ3JmK0dyd2IrZ0tMdjhwQlRMZDIyZG1pUWNU?=
 =?utf-8?B?L2p3YkxGZTVOZ0lPU0YyY0htL2lTdC9QQktHUGRGNWE3T2s4Y1gwZjdHV3hD?=
 =?utf-8?B?RUVJMWNUUXZLN0ZidUZMS2NHT3lXQnF0TGJxVEpJRjZlUVNwSU1tbFBiYlAy?=
 =?utf-8?B?TmtqUGlXWFdudmpNQVI1bjJYYnEwVW9ZWUpwZXpBMFhKeGZaVHNMSTFpenFR?=
 =?utf-8?Q?ukDoDOfFCLkZp/vo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b42f79-8e3e-42d6-22bf-08da29ce9ebc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 10:54:23.1522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9b+Dg0/zWD4ZTQ+DAbrbTQIaa3we3gfYQljjRhH5YfZZ2jmEltCFUMqXqjyYJ87+xnMwRWRxdXQSbBoByJFHWVfX8AgsPbT3xcn7Kopqk/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1398
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_03:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290061
X-Proofpoint-ORIG-GUID: mmGvpCifFD4XPnGHy0Wn9NrirYyPUfXU
X-Proofpoint-GUID: mmGvpCifFD4XPnGHy0Wn9NrirYyPUfXU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 09:12, Tian, Kevin wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>> Sent: Friday, April 29, 2022 5:09 AM
> [...]
>> +
>> +static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
>> +				      struct iommufd_dirty_data *bitmap)
> 
> In a glance this function and all previous helpers doesn't rely on any
> iommufd objects except that the new structures are named as
> iommufd_xxx. 
> 
> I wonder whether moving all of them to the iommu layer would make
> more sense here.
> 
I suppose, instinctively, I was trying to make this tie to iommufd only,
to avoid getting it called in cases we don't except when made as a generic
exported kernel facility.

(note: iommufd can be built as a module).

>> +{
>> +	const struct iommu_domain_ops *ops = domain->ops;
>> +	struct iommu_iotlb_gather gather;
>> +	struct iommufd_dirty_iter iter;
>> +	int ret = 0;
>> +
>> +	if (!ops || !ops->read_and_clear_dirty)
>> +		return -EOPNOTSUPP;
>> +
>> +	iommu_dirty_bitmap_init(&iter.dirty, bitmap->iova,
>> +				__ffs(bitmap->page_size), &gather);
>> +	ret = iommufd_dirty_iter_init(&iter, bitmap);
>> +	if (ret)
>> +		return -ENOMEM;
>> +
>> +	for (; iommufd_dirty_iter_done(&iter);
>> +	     iommufd_dirty_iter_advance(&iter)) {
>> +		ret = iommufd_dirty_iter_get(&iter);
>> +		if (ret)
>> +			break;
>> +
>> +		ret = ops->read_and_clear_dirty(domain,
>> +			iommufd_dirty_iova(&iter),
>> +			iommufd_dirty_iova_length(&iter), &iter.dirty);
>> +
>> +		iommufd_dirty_iter_put(&iter);
>> +
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	iommu_iotlb_sync(domain, &gather);
>> +	iommufd_dirty_iter_free(&iter);
>> +
>> +	return ret;
>> +}
>> +
