Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECA8514E6D
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377982AbiD2O5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377986AbiD2O5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:57:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D394CC3E1D
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:54:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TEfitR015530;
        Fri, 29 Apr 2022 14:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=SIAadAGEPsV7WhqCNpk/fh2fBUOFGAjyHZZ4kbAVX0g=;
 b=YnWTGteikTu6Gp76n+DqCL/yYqD5et6o60Xs0q1mSwirI/wrRKHTZJXrlV1WTrPbAU94
 ysXEGQFL8oQcWBed9qzwiswgBhExUE+7QBGP5R+++ZZFXsTa5eLyjmX8ce+kiqKmzAh4
 pVNd5b5DdutG9Wbk3DZcZVgc1VB0B4lWnea4rIBz7zsUeX9CvosW6lnlM3nsLdGC0fCL
 dP3mbq9JiXYMZtV/s/78e9689JrdqZoiZ/3Y3L9AUJ7DP2wOZUQ0cKWwEgpjHRqWIxPz
 IxQAIKw6qSuBVVUq9yin+Khyf1KGlZ00oUtQS+oTJ2GVb0sUIr1Mg/bXZPac7peWXV7x dQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9axx3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:52:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TEpFXq021298;
        Fri, 29 Apr 2022 14:52:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w854tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:52:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLuyHCxuU2yIjr+0CKl/QIabWL8nHYyZopKXY+Q3jmb2GTH3+MwU5NluEF2ipfUI8jjdRgjaPuTB5MxEr1kB4mAGXCVRRij3iiSUzEgmwY73i32ZCLxjXNajxr16WKIk3iLWHR9Ho4EV4yDQZ5up1eUQik1m43RBSRtL39jGruwKqE4f5G6WYS8eHdcIsI6qJgoYFFZ8Fh8z/Un+CxE3hVbdza5G4J5vJnUnnIF0VsAc60jTsoJU3wEkgT87XFRhTjEPWZfpkW9cKew4gR6ijVjk+ATCjIww3hXLgClk6mUDzI6vid15z+RuS116ZU2mRQmMwZHQlBs4Ke72TBXwUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIAadAGEPsV7WhqCNpk/fh2fBUOFGAjyHZZ4kbAVX0g=;
 b=l11cyFDEWeRkl7v5cjsJAu4HG1dwIZDdeXZgfX3UpgnI7/u3+tmPzyCrsYXuM6oHw7OYGU4bHGBqkRGqIyLlqS5ipVIJm+kcSRW35Qmqbcb2ODus4Qe099RT6WffMQzwy28Bd017f3HBTPdJ2nxOxpxhNXJTL/jwP1cBO/4awoiJ9WeD5L/SCj3FIeuKhd6jLl/1LImj3t238CYvmNyjAoBKDOiGiKzLrkTKYpsalibtk4pqBWgi5BaxZ8aqraHQK/QwpcyHtT8QtD3btsjoKYSwRQt2RoACRX2JV9EifkTPH+Fk4+3tWhZidKnMJxUIAKzekfZx+OA0tJeYyYIWGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIAadAGEPsV7WhqCNpk/fh2fBUOFGAjyHZZ4kbAVX0g=;
 b=enCyUz3I+OFJtE5Y9NX0T73rPx8IUfOYhXgaBJxNRgW8Ksh+JiARRwj4llT8Se6WVDlLa3rdYWHT/uTxYXc4tjqJ0vmuJP0xtpyeWPUAf9qK1wNmsMUj3Ytp58Nxyfow1B0PO002ES4Lsr7vLe2L2ebLw3frT5jRNb+XhOVL4KM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH2PR10MB4360.namprd10.prod.outlook.com (2603:10b6:610:ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.26; Fri, 29 Apr
 2022 14:52:35 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 14:52:35 +0000
Message-ID: <4f1c49b8-8f51-349c-bb86-8ba0d7af7de7@oracle.com>
Date:   Fri, 29 Apr 2022 15:52:27 +0100
Subject: Re: [PATCH RFC 07/19] iommufd/vfio-compat: Dirty tracking IOCTLs
 compatibility
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-8-joao.m.martins@oracle.com>
 <20220429121910.GT8364@nvidia.com>
 <862dbdc4-b619-d97e-f358-1fd9e3778c5d@oracle.com>
 <20220429143635.GA8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220429143635.GA8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c2c92e8-26e3-4c6e-894d-08da29efe57b
X-MS-TrafficTypeDiagnostic: CH2PR10MB4360:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB436026261B51CE3C964741A2BBFC9@CH2PR10MB4360.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rEXfp0aWRF4GXD8/eogbvkeRbYTxYZ7K4jD2iHEFj7fVC0WnoxB0+os0YB5kewwD9V4Y+s33ie0j37fCpBZfUVHPqPnQ21Cxqud2tzFM4dugXc2DT2GlrHYvcm0UYRmWEgqqG6zcqAcNsQbg3l/Gu/NlqalUPEuUVSp29FGV9PXMNiMifR7eAL1JRbjiaj6U7MZ4taAzNJ29SU03/8kuKOqBfzI+fLXwgHoGnCyFF+UJp65p2dmZtsluLQyWmvP3h1WcafbdA9fYk98y+GvzfL8IjP5TOaVR9dGg7gTSPqM/1i/u0/Ht+AeGtpudQ1ZTILpbRz85aNluL/Yms5pUg4r83Tm6hRB0tCD+mQL3XZ9gTK8/OTO70SSSu5yBf97KiDSqnjnaSrsuiXSZH2rYdmswmrWKpZvFNPc7M/qkVhhs2HkgWunENXDKeAtOy6m4+POLfCiOGlA/DQWSqTa2AXcCi7iPU+8/uIA009T/3qrFN2Df82haRuW3CR/UjEvpOexxWcDRkAvUPAB1sqFewcYQVrZoQ834DKe2DL4nHynxh+hAO8UpjMh4gi1trdR09HQK5f7SYLAUfG4hbTNqNAdWvN5Ieo65Iok2u0wW8I5cjFOXF6T/SXcUy9jPe/ub8KSDPGbEm+mMew0BRJHt8JciU5Wwvh6cZhMOrC7aXWknQYlXwEnWy82xPT9XfCoXRgG7WHi0TucDR8Xb7PcmuVJ8TM/vHwz4Q6DEMGKhGhI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(2616005)(508600001)(31696002)(86362001)(26005)(53546011)(6506007)(38100700002)(6512007)(186003)(2906002)(31686004)(6666004)(316002)(7416002)(5660300002)(36756003)(66476007)(66946007)(66556008)(8676002)(4326008)(8936002)(6916009)(54906003)(83380400001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QThxRkFjZ3ZiRVowa1AydWJ6aGFKZ1F4cHU3eWtsMlZPczNYMmN1REx3bFZp?=
 =?utf-8?B?eUhxdjdpY0lXV0hvRUwyUnpyS2h1SFhHb3F2bTFmeFNNa1NrMGVHWXlJbWhu?=
 =?utf-8?B?T2RSUndKMit3SGdHVTdKWXlLVFREeVZGU2lnTXlhT1VvdWZKU1hGd1J5Wjhz?=
 =?utf-8?B?MERpSHJrN1BXZDd2OWt3N2FxQUVScXJLU2l5cEQ4TTQxZGpPK3JwZnpjTVZj?=
 =?utf-8?B?enVQb1BzVVZaQXMzcHNPNVExS0tYMTdnR2JpRkJJU3N4ZUpPZmd2dkpNWnc5?=
 =?utf-8?B?VWFKQWtBcHVBVTVaUklFR3p3dDhkSWR0MmErSnlpL2VTcVFUSTZzMjFxUk9z?=
 =?utf-8?B?MWpTVUo3TmJhdXJlbTVaaTM3dngvVitsZjBsTHhESXVZU2RCSkNsd1JJdEV3?=
 =?utf-8?B?ckZXajJRcExIbHVUSDZSRnZZaEtVU2hRM0paSDQ3dWl6Szcvb3cwMTNvbnBw?=
 =?utf-8?B?K0x3a095dmVVV2IyQmxGYUdnT1JLL0FHbjZrVkVTZjNGOE1hWDFsOGI3b24x?=
 =?utf-8?B?MzlyQjRjVkYzNVpnRGh4NzZGTEdyMDI5UFNTdUN6ektmTzNHZDJCc2hGV3lm?=
 =?utf-8?B?ZjhVTTRwMTlQUGN6b0tPbHB2bG5WU3JheHd4VjJDanFQMnQ4anlUSTdPcWFY?=
 =?utf-8?B?NGVSalZJTVN2Rk9NZ0V4UGwzSXJ4Wk02aW5rRUJzdEtZODN0SE4vR0VYZ3FB?=
 =?utf-8?B?UkJ2blV4WUtHVmJPUWxibmUrZUtUU2RFcjRJd1orc1hJZTVJQ2tJMlg5ZE5s?=
 =?utf-8?B?N0VhWjJMalBYMkYzMytqNFRDU05FalJHbEN4OC9mdEt0WXpnNkYydUdPLzYv?=
 =?utf-8?B?S1hiVXRlV0xieHgxTjlkYm13Rlo4RC9KbmRKYWpMUmZEQ2hkOXdkNVE5MFhK?=
 =?utf-8?B?L29yT0hEVVRpeVdBN0hXY0ljRDdjM25mSGU0eUk2Z1grNUs4d1h1c1RvNW1H?=
 =?utf-8?B?Um13dUwwNkZteGp4aXF5cmljblM4d0ZtclQwRDBWMzFhMEZqV1AwZlZJbnpL?=
 =?utf-8?B?WHFmR2ZOSmxKVy9PcU5UOVZhbmwvVEVTZERMYXN3UjRMVGlYU2ZGN0pOOXph?=
 =?utf-8?B?dFdGS0NZb05zdXZJSzZuc3BVdmoyZHN6V2dmeThaWVdyRE9LcXAvNEhlVFRG?=
 =?utf-8?B?NndCYnQ1REZwNHNEMFY1OEFTb1JJaVJLcjFHR1F4V0hFbHhqS05JeWdheExq?=
 =?utf-8?B?dXo1QWtHa1Q1Uk1Icm5IdFlGcERxNHVTVnFJR2JWTUdsZ2xXMEFUN3luL2Nu?=
 =?utf-8?B?emh4U0hEbzdSc0pRRXhIT3RPTmxSSE1hNnFOZVVkcE1Md3loTDhmYlJsalpD?=
 =?utf-8?B?YytVMytPUVdFdnB6dWJoaG53QmtoUmJTQW5Ua3V2d1k3WW5POXdsVlJMQXF2?=
 =?utf-8?B?M09EcTNDVDNJUGZnNWlPM0R0eWVoMWRIQlBJUGd3K3NmZ05SUVJiOThReWpz?=
 =?utf-8?B?SmUveUZKS3dibmhnb05rR1A3QlRGR0pkK2FmbjlRSURyVUpWSnFvSktWQWdh?=
 =?utf-8?B?cUJYOWJLREZYdThTb3Z0UkoycG96R3gxYzhhYStMQ3Fzb0d3bk1JTHpZOHgr?=
 =?utf-8?B?eHJFUU5YdXhleXdjQi8rWnl5WmJHMDMzZ1FyN2ZZNnkyK2hQc0VTb0l2WkUv?=
 =?utf-8?B?SlcwZ3RCSlYzSEtUUG9ncVh4b0FpTUt1dzB6VUh6UzAvcXNVZjE4dngrR0JZ?=
 =?utf-8?B?WVRoaGFBOGJlNE9xelBlTi93cTloeGZsUjlDbmM1R3ZsYTg5ellUNndpenlj?=
 =?utf-8?B?T29ybUYyMGxFN1RZZ1JYWUl0bUF2bUl2bXAwTTJ4R2dQQ2Y0YTVuRHlhS3I5?=
 =?utf-8?B?bFBhNDAvTGM0clRteTV5aGdSTXZiWmJqNkxOK1NZVWdmNWxkQmx5THFOYmRa?=
 =?utf-8?B?VUpWNWtBbkVUTnFrRk4ySllzSktqbWlKRUNPb0FkL1JuWnZxVEx3N1E5SVcz?=
 =?utf-8?B?TldsVE5rbnhPWndpVUhoZzV4WU5Db3NHQzJLRWRBUjQ5UnF1T1NqVHVJMmJV?=
 =?utf-8?B?ajdsRFE1dkIwcnJpMDJoa0dPdlhQc2JUU080aEJEZGRrMGlRd0psYVVzMUt5?=
 =?utf-8?B?bkdvZXZZOHpXTDczNDY2TFl6M1owR2VibHpHVG85dDR5eDFXTkNSN1Z4ZmJa?=
 =?utf-8?B?OC9BOFNWVlRmVVhyYTB0cmI2Z3U2QUxlSFBrUHRBTTVUenp2MklwQlNLMk1x?=
 =?utf-8?B?TEU5N1dpZ0RYdCs3TzJyaDNZbEpOekVvMjVGNDhRMEJ0bkdzcDlOZDdyM09o?=
 =?utf-8?B?ZjJxUHBwblIwQStjdW1QZjZuVGp5emgzcnA4b3JjQ08vbGdtdmx1SnJ4SVZa?=
 =?utf-8?B?OE1jUHFvaXlkRFlqK0hkdXB1UnJNSEFETEhnUTV4dXZQNlVva0huQmxuR1Q1?=
 =?utf-8?Q?pWpjIhOFstr5F76E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2c92e8-26e3-4c6e-894d-08da29efe57b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 14:52:35.2222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vYBujxzE+1lzdDZatzja6VF1R7YP7zK+doM+RayDdDQj9hzYMJKCsLorCPSa5Cspy9eAnrev2gy8jdK2AYLOFQroUfpugPhB0gzarGnp7u0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4360
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=937
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290082
X-Proofpoint-ORIG-GUID: 1Qt4CgNvs2j9QDgAUlJdfVZr3mKV6_Bv
X-Proofpoint-GUID: 1Qt4CgNvs2j9QDgAUlJdfVZr3mKV6_Bv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 15:36, Jason Gunthorpe wrote:
> On Fri, Apr 29, 2022 at 03:27:00PM +0100, Joao Martins wrote:
> 
>>> We've made a qemu patch to allow qemu to be happy if dirty tracking is
>>> not supported in the vfio container for migration, which is part of
>>> the v2 enablement series. That seems like the better direction.
>>>
>> So in my auditing/testing, the listener callbacks are called but the dirty ioctls
>> return an error at start, and bails out early on sync. I suppose migration
>> won't really work, as no pages aren't set and what not but it could
>> cope with no-dirty-tracking support. So by 'making qemu happy' is this mainly
>> cleaning out the constant error messages you get and not even attempt
>> migration by introducing a migration blocker early on ... should it fetch
>> no migration capability?
> 
> It really just means pre-copy doesn't work and we can skip it, though
> I'm not sure exactly what the qemu patch ended up doing.. I think it
> will be posted by Monday
> 
Ha, or that :D i.e.

Why bother checking if there's dirty pages periodically when we can just do at the
beginning, and at the end when we pause the guest(and DMA). Maybe it prevents a whole
bunch of copying in the interim, and this patch of yours might be a improvement.
