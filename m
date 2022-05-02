Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FD6516F4C
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 14:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384896AbiEBMKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 08:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358164AbiEBMKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 08:10:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4791C34
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 05:07:19 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242Bq0wG032436;
        Mon, 2 May 2022 12:06:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HIkAu7Rq/FnKrP2Ryt+tY9GoRaJpfxauAfH/7hHwydQ=;
 b=kVt0smYEKRDOiO98YZZumH2iuiZQOc1zBR0g6lGV3k0bD1x8N0JXZMilXbY0yGY4AJ72
 6RaXOM6Fi1J8nlHZ9TSe/sRuw9Ntc9eegTEQxpJf0cUinvQGpLbPsdWhS4DHC4P5wIcv
 9Rluh+um6LdBsQjPuSWu13ypzaU5k2Mp8F8AcAJVSIfh9guRLRTzjsC7XMM9wvp6VqAz
 khXH0sxkNbd/9dwkPDOEVAmrcO8nhW8xxRgzCqIGEcZCx77HwE6OBsZWHVVYxp5dAGd/
 v416V0d21rwj0np1D2NyTw6T3HoyChfZsc3sKi9bQZB4zGOizkGLnuIf7PitvOhtKfuh nQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0ajy8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 12:06:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 242C6naF018300;
        Mon, 2 May 2022 12:06:53 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj7h2cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 12:06:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNGE486PsI1bF9HWpLFulnNBsrM+9y2qxaefRAy3CbmLUkIGeEP0ncFo0aILfRwJz60QQ/c111JUoejiHwPICBV+T3lRgGsOC6rqx96CPnvIpuZrdlgIWIj1D4IgPGTmGqWZM/tOtzsQ4TDk3gZg74qtECy7LS8yw77q/xpTnBjO/9tW2P68oKqhJHqUsZCn8NtLQnIihxjayFi5do59/+xZ2kUEYgtb56Kwic2dI3XZd8WdgkVUdMyPeluMF4Sk+Kem3h7034gSrC59DGIPLGAptRwK5NavhMNMsLPLVoJy3A/iz+pLYKfU7afLghLx5HPO9IBnazbT8Bu7EKxl4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIkAu7Rq/FnKrP2Ryt+tY9GoRaJpfxauAfH/7hHwydQ=;
 b=L/IWkvwzf6GYjit13fFEaC9U0Tzyy1h5XPEmJ2DeZWaCg1nBQ+FiBwY9w5OCxvuXsF8ZZzkwLoXlstFTeE+gW5jL2BvOr+UjIb9KP9orIherAC8aWhwRRZ82WaAvUU4KHi67zYrA782qOGXQnrTvFQuXzBEHHEbmJm2jvxQSvPDo9aZgzARkVLPfWO4+mI5bEr4oPHk5aASzwZVUV+zV/DCITgsXxQELDD1OnqFe79iGwOuesOmQ31zntYwXHHTV9fjC4w3yaa8rbMubv8mjoHYAHzgDTPwYfvTdPDtHnN0g55YbRLwV/STyaHmbIX9LOVI9JluDRP7Vf2RJYC5JLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIkAu7Rq/FnKrP2Ryt+tY9GoRaJpfxauAfH/7hHwydQ=;
 b=fBv2rBCXmIgDvvJNoSA5NJb3cPYyei+s63a+n8w2r+kG5E5tG2aZQHJZAZRsco6sTQdz5w3jnmZzGcvOj1/RwrCSk92BrJ0e4zIvp64R7DNDR5dhltwOytYtWcyveIfV5oUr3OOm5aujzTUSXITdSelldBxDocCR43uEg5/PveQ=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BYAPR10MB2440.namprd10.prod.outlook.com (2603:10b6:a02:b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 12:06:51 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Mon, 2 May 2022
 12:06:51 +0000
Message-ID: <e5169837-511a-7e1c-d157-3696fe240c73@oracle.com>
Date:   Mon, 2 May 2022 13:06:43 +0100
Subject: Re: [PATCH RFC 03/19] iommufd: Dirty tracking data support
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-4-joao.m.martins@oracle.com>
 <d80b318d-278b-2592-8665-e5dec91f70e3@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <d80b318d-278b-2592-8665-e5dec91f70e3@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0505.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::12) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 267694b0-a1a9-4e4c-ebc2-08da2c343d82
X-MS-TrafficTypeDiagnostic: BYAPR10MB2440:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB24408A94E0D022C1FA204FB9BBC19@BYAPR10MB2440.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SUX0saPy795G/rPZxKQI5oi4QuuTD6CEh7rS/+I4sADDNVAs8uIvk4ED5lvVJvbY3wqS76kTgTkj10sb7zT8QAs3OtYKp1NRhSbsPm6Eph/QMW/2h6KWOLXSvNfCpi5ogldEJ5VOnMJJPGtaSxM2M1lgc11x2z5hZ5ZAJ7moNYgDKNqKqt/lWuKdTvhGG0215b++XzK9g9YwEk2OC6D4pyv9bA+PJpJjx2/BAHf6irmgykl/l/nqbxEGUm7Bu+Ii4BArhN0DxPMhP/sg3ukXKFZHfESP0v/mg51nvRcVuLKXlAbveD019LAJfOov9OOTrdGeS0Jmkev7cguEs+Xi9qeR3GH6OaaeXhnPFyAU1nEvxELGVX5AE3fc0D8wSWlVItJ2CAMNpiErCDzDTPazGnU3CYl71Q19Vj4vPvcjsV5XxgvTK4Zuac2CcYBlFBVzLem7kXbVfB2fdTBSvalrO8YPoosDX911m+5/9mLoNU8h0PsH5gB0vBUmKE4AjqMtA6ss4WOnxSg7W8vleIg4nVfYLG9gD8qmlDFIPAmTTUu5rxjdAw5tUY9Yu+17g3guty940r2y+O0FSk0pMaO3iI68p8yD2oKRRV5tBbOQ1bKkJ7r/VaAFbgR1fpysIHA3TzV1bNaSQi/u+J4Qqfw2h21DhmwdA35S9ZI4i9SCQyMKgi0OuFBYUU7lvddRYc1Ja+U3KXhfXCx41d+jKJmUjUeQRs+WPWmY+9pOtezBrgs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(30864003)(83380400001)(5660300002)(31696002)(53546011)(38100700002)(186003)(86362001)(66476007)(4326008)(6512007)(8676002)(26005)(66946007)(66556008)(6666004)(2906002)(2616005)(31686004)(54906003)(7416002)(6916009)(6506007)(316002)(36756003)(6486002)(508600001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVE5cjBzczdHWXA0VXI4bncrRVRkdTg1RjFaVlJFQzBMZUpTeDdLd2s4c3dt?=
 =?utf-8?B?NnJkbWFXRFluWG5XMitHM3ZEM2RmZFNLVkdITytTYjZDQm1nTXNQNStVUXFP?=
 =?utf-8?B?ZGZqRXFYc2lBVUVzbEJvZm1BeUxDMjlidlF4aHdHSUpmQUNqRWppTHRXaThY?=
 =?utf-8?B?UnZwekxYaEVFOE5GbzhwalVLRUExZVBqZTI0NWRRdEhJMVA1QlBHNk9BWm1k?=
 =?utf-8?B?VEJUNjdVZFh2SE9FemRvQ01kMmVGNHc4cDk4UGlBZW9MMFgzaytsdC9FbmNE?=
 =?utf-8?B?Y1I5RDE0Z2tQQ0dmMkNSZGRZVzRZU3B0YXA5V0JudU5VVHJuMVdTQnJML0xi?=
 =?utf-8?B?M0pvQ29rSmxMSHJNN1JORldTUHhxUlpLMDVJQ2lhMnlHZ2EzUVVLbTBxWE9F?=
 =?utf-8?B?ZVlPaGc3REdGOFBXd2xVOXI1VW9YOTN4bFJGczJKbmtpL3JSYlFGSnFyMWg1?=
 =?utf-8?B?UytjTjJJeEFXaWt6Q0IzcWJ3aFVGTDlQdUlZTmhRMVFTOCt1UU43a0w2dDlS?=
 =?utf-8?B?MjNlTFNjbUZvSkJlTFF0OXVpM3JzM1RSdGx1aHNMcWdkVHNxK2F0QnR0cVJQ?=
 =?utf-8?B?QnhDSUV1V1ozYVc1OGJxUDFvM3ZYS3JQd2YwYjExYTAwbUN6T2hGc2psMzR2?=
 =?utf-8?B?MUdnTmd4ZmpCNkZzbzlwc1hvVGpmT0FDNU1ET29UdVBnZDR0aU9JL1NjNWd1?=
 =?utf-8?B?WHJzd3VmQ2JSODRNczNlR1hhNTFlZ25vUGs2cFdqMFdPYnZ0eTdTK0tDd3BB?=
 =?utf-8?B?RTRKMGxRY0M1bEpaVTZUbExHR2xOSjk1RzNJMjdpUXVmaUFuNGduU0VKQ1Jv?=
 =?utf-8?B?dzNFL0ZJT0pkc3V3Tm94eThpa1ZWbEVYdHpuam1zM3l4RWRZQ1ZSTnF0WEl0?=
 =?utf-8?B?dE1iWHliQUhLMnJXcDBuay9WK0RpbFNQVE5iR1A0WDJycXpPYks3QldxSDJn?=
 =?utf-8?B?VWltaVpTdEsrMFVMbytENTM4L0RVMTI0aWx6NzF0NXErYWZjSXl3REpnYno3?=
 =?utf-8?B?SXo0NnVvWUsxNVJ2TDl4Y25UKzFrNGowZGpyekNCc2FXRWcyVHlvR1dERUFx?=
 =?utf-8?B?ZHRrdnJTSW5hQzk1VWh3ZUxaU0pxbW45ZDVBT002OVJBSFRUUEtnbWtLUS9B?=
 =?utf-8?B?NERGNnhUNjJhMzRVcDhvK2FlOXhGeCtmYW9MVEYvbkQvazNHY3hzZGVrQUo4?=
 =?utf-8?B?TWdrMm9NUkp3VnFvb2w1clN4Y0JjN0tGMWFGSkM4eWs2YmttTFMrZmdvTkJ1?=
 =?utf-8?B?enF1czR4YlRXcmNZbjY3V09adXVVTTdrdWZzSEVFNmVXdWROeFNRaDFYSVkw?=
 =?utf-8?B?UkQ3QWNDemtVcXJXSElzOXZJcFNZdFV3WHoxaWhIV1lsTEpyREFOZDI0cEsx?=
 =?utf-8?B?U2FrekxaNE9rbTAraEFFaXFhR2xMZXgzdE9VVW5kREIxZlJGTFNHYkRQNmt0?=
 =?utf-8?B?M1JpOW12cXE0Vm9wT3d1R0E3WmJadjg0QlVQelIwRFlhWXF3eUtFSlBBWXJX?=
 =?utf-8?B?cHRwdWJhdTU4cGtaWnd3cjhsVXBnRm5nUmNhNHNMTnlqckZDZFJIOTlYVWJk?=
 =?utf-8?B?MzAwYnJNakEwU2FabEJQa1RkQnk4STVQeGJOM2hMM3I1UUNlQzdFNTBGTkxZ?=
 =?utf-8?B?SndZZ01VQlJMSk5ZY2hVNms5RTZRbDB6ZTkxdytqRWMyVTB5Vjl4dytyUlFV?=
 =?utf-8?B?LzhmRmFtOEozRjkwMVh4dTJYWWlSQ3d4OXBtanZwRGIwUk04K3JEeTNrSmhR?=
 =?utf-8?B?dWtxNkFvK0d5bUxTc0ZHWEttaXVTYzF3MjNLUlNVSzkvWlBwMUU5L29CSkdL?=
 =?utf-8?B?T0RWTVc0enI2NFQ0SklQa1J0RncwU2l3KytJMWlSQ3ZtM2NacEtiOUJHb25C?=
 =?utf-8?B?WUVhNXEvWDRlMnlGcTBsdGd6bWhKeXFGekJxUFhETGZaclltaDNRZ1VjWjlj?=
 =?utf-8?B?UGRSZmEzZjlJa0o3dlF6R01oeVEwSFhpTmF1d2IrbEpSdEFzdk5zSURuaDdE?=
 =?utf-8?B?S1FSNE40U3BEVVgrS05LNWx2UlQ0dVJCcWdxY0ZaeGFUa0JmazhucStrVnhz?=
 =?utf-8?B?Z1UvK2VpOWNJRVhvQ2xuTm5EMTJOaG5PR25VZTlLOGtKVWRXOGNjT050VGho?=
 =?utf-8?B?cmRVWERjSlZhdTR3bXNxNUN6OUhIcHQ4MDNHS2k3bEJXcGlxQ2xjQnl1UWlL?=
 =?utf-8?B?ZzJyZkw1VXQ5eUsyRFhqbHBKNGExdmFDa1RBcFkwYkFXODM4bkc3QjJYL1dD?=
 =?utf-8?B?ak90ektteFA4WWpjQ1Y0K3hUeFM2Ni9NUEhoQUQvSGxuemVlWDMybVZ2a1o0?=
 =?utf-8?B?eEs3VGNKa01CSkdqRGdQdlBGK3pGMy9ES3NlMHpKM041T3Q1RzJ3VHlSd0hZ?=
 =?utf-8?Q?OEJ6BgkAYYXiD17U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 267694b0-a1a9-4e4c-ebc2-08da2c343d82
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 12:06:50.9976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R4VFEnJXXrKclQWA39xqnZBOTVaX1B+qndHEhDpk3fNztdIHKQEGoPWhNIBdyvZv8Kxo19If8xxfMNkp23m5N4LbOIMs1LzO8eMsRvN+cD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2440
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-02_03:2022-05-02,2022-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020095
X-Proofpoint-GUID: GfHCfC62RvMDkKBayVaEUIg4KUXhX3Cw
X-Proofpoint-ORIG-GUID: GfHCfC62RvMDkKBayVaEUIg4KUXhX3Cw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/30/22 05:11, Baolu Lu wrote:
> On 2022/4/29 05:09, Joao Martins wrote:
>> Add an IO pagetable API iopt_read_and_clear_dirty_data() that
>> performs the reading of dirty IOPTEs for a given IOVA range and
>> then copying back to userspace from each area-internal bitmap.
>>
>> Underneath it uses the IOMMU equivalent API which will read the
>> dirty bits, as well as atomically clearing the IOPTE dirty bit
>> and flushing the IOTLB at the end. The dirty bitmaps pass an
>> iotlb_gather to allow batching the dirty-bit updates.
>>
>> Most of the complexity, though, is in the handling of the user
>> bitmaps to avoid copies back and forth. The bitmap user addresses
>> need to be iterated through, pinned and then passing the pages
>> into iommu core. The amount of bitmap data passed at a time for a
>> read_and_clear_dirty() is 1 page worth of pinned base page
>> pointers. That equates to 16M bits, or rather 64G of data that
>> can be returned as 'dirtied'. The flush the IOTLB at the end of
>> the whole scanned IOVA range, to defer as much as possible the
>> potential DMA performance penalty.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/iommufd/io_pagetable.c    | 169 ++++++++++++++++++++++++
>>   drivers/iommu/iommufd/iommufd_private.h |  44 ++++++
>>   2 files changed, 213 insertions(+)
>>
>> diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
>> index f4609ef369e0..835b5040fce9 100644
>> --- a/drivers/iommu/iommufd/io_pagetable.c
>> +++ b/drivers/iommu/iommufd/io_pagetable.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/err.h>
>>   #include <linux/slab.h>
>>   #include <linux/errno.h>
>> +#include <uapi/linux/iommufd.h>
>>   
>>   #include "io_pagetable.h"
>>   
>> @@ -347,6 +348,174 @@ int iopt_set_dirty_tracking(struct io_pagetable *iopt,
>>   	return ret;
>>   }
>>   
>> +int iommufd_dirty_iter_init(struct iommufd_dirty_iter *iter,
>> +			    struct iommufd_dirty_data *bitmap)
>> +{
>> +	struct iommu_dirty_bitmap *dirty = &iter->dirty;
>> +	unsigned long bitmap_len;
>> +
>> +	bitmap_len = dirty_bitmap_bytes(bitmap->length >> dirty->pgshift);
>> +
>> +	import_single_range(WRITE, bitmap->data, bitmap_len,
>> +			    &iter->bitmap_iov, &iter->bitmap_iter);
>> +	iter->iova = bitmap->iova;
>> +
>> +	/* Can record up to 64G at a time */
>> +	dirty->pages = (struct page **) __get_free_page(GFP_KERNEL);
>> +
>> +	return !dirty->pages ? -ENOMEM : 0;
>> +}
>> +
>> +void iommufd_dirty_iter_free(struct iommufd_dirty_iter *iter)
>> +{
>> +	struct iommu_dirty_bitmap *dirty = &iter->dirty;
>> +
>> +	if (dirty->pages) {
>> +		free_page((unsigned long) dirty->pages);
>> +		dirty->pages = NULL;
>> +	}
>> +}
>> +
>> +bool iommufd_dirty_iter_done(struct iommufd_dirty_iter *iter)
>> +{
>> +	return iov_iter_count(&iter->bitmap_iter) > 0;
>> +}
>> +
>> +static inline unsigned long iommufd_dirty_iter_bytes(struct iommufd_dirty_iter *iter)
>> +{
>> +	unsigned long left = iter->bitmap_iter.count - iter->bitmap_iter.iov_offset;
>> +
>> +	left = min_t(unsigned long, left, (iter->dirty.npages << PAGE_SHIFT));
>> +
>> +	return left;
>> +}
>> +
>> +unsigned long iommufd_dirty_iova_length(struct iommufd_dirty_iter *iter)
>> +{
>> +	unsigned long left = iommufd_dirty_iter_bytes(iter);
>> +
>> +	return ((BITS_PER_BYTE * left) << iter->dirty.pgshift);
>> +}
>> +
>> +unsigned long iommufd_dirty_iova(struct iommufd_dirty_iter *iter)
>> +{
>> +	unsigned long skip = iter->bitmap_iter.iov_offset;
>> +
>> +	return iter->iova + ((BITS_PER_BYTE * skip) << iter->dirty.pgshift);
>> +}
>> +
>> +void iommufd_dirty_iter_advance(struct iommufd_dirty_iter *iter)
>> +{
>> +	iov_iter_advance(&iter->bitmap_iter, iommufd_dirty_iter_bytes(iter));
>> +}
>> +
>> +void iommufd_dirty_iter_put(struct iommufd_dirty_iter *iter)
>> +{
>> +	struct iommu_dirty_bitmap *dirty = &iter->dirty;
>> +
>> +	if (dirty->npages)
>> +		unpin_user_pages(dirty->pages, dirty->npages);
>> +}
>> +
>> +int iommufd_dirty_iter_get(struct iommufd_dirty_iter *iter)
>> +{
>> +	struct iommu_dirty_bitmap *dirty = &iter->dirty;
>> +	unsigned long npages;
>> +	unsigned long ret;
>> +	void *addr;
>> +
>> +	addr = iter->bitmap_iov.iov_base + iter->bitmap_iter.iov_offset;
>> +	npages = iov_iter_npages(&iter->bitmap_iter,
>> +				 PAGE_SIZE / sizeof(struct page *));
>> +
>> +	ret = pin_user_pages_fast((unsigned long) addr, npages,
>> +				  FOLL_WRITE, dirty->pages);
>> +	if (ret <= 0)
>> +		return -EINVAL;
>> +
>> +	dirty->npages = ret;
>> +	dirty->iova = iommufd_dirty_iova(iter);
>> +	dirty->start_offset = offset_in_page(addr);
>> +	return 0;
>> +}
>> +
>> +static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
>> +				      struct iommufd_dirty_data *bitmap)
> 
> This looks more like a helper in the iommu core. How about
> 
> 	iommufd_read_clear_domain_dirty()?
> 
Heh, I guess that's more accurate naming indeed. I can switch to that.

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
>> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
>> +				   struct iommu_domain *domain,
>> +				   struct iommufd_dirty_data *bitmap)
>> +{
>> +	unsigned long iova, length, iova_end;
>> +	struct iommu_domain *dom;
>> +	struct iopt_area *area;
>> +	unsigned long index;
>> +	int ret = -EOPNOTSUPP;
>> +
>> +	iova = bitmap->iova;
>> +	length = bitmap->length - 1;
>> +	if (check_add_overflow(iova, length, &iova_end))
>> +		return -EOVERFLOW;
>> +
>> +	down_read(&iopt->iova_rwsem);
>> +	area = iopt_find_exact_area(iopt, iova, iova_end);
>> +	if (!area) {
>> +		up_read(&iopt->iova_rwsem);
>> +		return -ENOENT;
>> +	}
>> +
>> +	if (!domain) {
>> +		down_read(&iopt->domains_rwsem);
>> +		xa_for_each(&iopt->domains, index, dom) {
>> +			ret = iommu_read_and_clear_dirty(dom, bitmap);
> 
> Perhaps use @domain directly, hence no need the @dom?
> 
> 	xa_for_each(&iopt->domains, index, domain) {
> 		ret = iommu_read_and_clear_dirty(domain, bitmap);
> 
Yeap.

>> +			if (ret)
>> +				break;
>> +		}
>> +		up_read(&iopt->domains_rwsem);
>> +	} else {
>> +		ret = iommu_read_and_clear_dirty(domain, bitmap);
>> +	}
>> +
>> +	up_read(&iopt->iova_rwsem);
>> +	return ret;
>> +}
>> +
>>   struct iopt_pages *iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
>>   				  unsigned long *start_byte,
>>   				  unsigned long length)
>> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
>> index d00ef3b785c5..4c12b4a8f1a6 100644
>> --- a/drivers/iommu/iommufd/iommufd_private.h
>> +++ b/drivers/iommu/iommufd/iommufd_private.h
>> @@ -8,6 +8,8 @@
>>   #include <linux/xarray.h>
>>   #include <linux/refcount.h>
>>   #include <linux/uaccess.h>
>> +#include <linux/iommu.h>
>> +#include <linux/uio.h>
>>   
>>   struct iommu_domain;
>>   struct iommu_group;
>> @@ -49,8 +51,50 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
>>   		    unsigned long length);
>>   int iopt_unmap_all(struct io_pagetable *iopt);
>>   
>> +struct iommufd_dirty_data {
>> +	unsigned long iova;
>> +	unsigned long length;
>> +	unsigned long page_size;
>> +	unsigned long *data;
>> +};
> 
> How about adding some comments around this struct? Any alingment
> requirement for iova/length? What does the @data stand for?
> 
I'll add them.

Albeit this structure eventually gets moved to iommu-core later in
the series when we add the UAPI and it has some comments documenting it.

I don't cover the the alignment though, but it's the same restrictions
as IOAS map/unmap (iopt_alignment essentially) which is the smaller-page-size
supported by IOMMU hw.

>> +
>>   int iopt_set_dirty_tracking(struct io_pagetable *iopt,
>>   			    struct iommu_domain *domain, bool enable);
>> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
>> +				   struct iommu_domain *domain,
>> +				   struct iommufd_dirty_data *bitmap);
>> +
>> +struct iommufd_dirty_iter {
>> +	struct iommu_dirty_bitmap dirty;
>> +	struct iovec bitmap_iov;
>> +	struct iov_iter bitmap_iter;
>> +	unsigned long iova;
>> +};
> 
> Same here.
> 
Yes, this one deserves some comments.

Most of it is state for gup/pup and iterating the bitmap user addresses
to make iommu_dirty_bitmap_record() work only with kva.

>> +
>> +void iommufd_dirty_iter_put(struct iommufd_dirty_iter *iter);
>> +int iommufd_dirty_iter_get(struct iommufd_dirty_iter *iter);
>> +int iommufd_dirty_iter_init(struct iommufd_dirty_iter *iter,
>> +			    struct iommufd_dirty_data *bitmap);
>> +void iommufd_dirty_iter_free(struct iommufd_dirty_iter *iter);
>> +bool iommufd_dirty_iter_done(struct iommufd_dirty_iter *iter);
>> +void iommufd_dirty_iter_advance(struct iommufd_dirty_iter *iter);
>> +unsigned long iommufd_dirty_iova_length(struct iommufd_dirty_iter *iter);
>> +unsigned long iommufd_dirty_iova(struct iommufd_dirty_iter *iter);
>> +static inline unsigned long dirty_bitmap_bytes(unsigned long nr_pages)
>> +{
>> +	return (ALIGN(nr_pages, BITS_PER_TYPE(u64)) / BITS_PER_BYTE);
>> +}
>> +
>> +/*
>> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
>> + * further casts to signed integer for unaligned multi-bit operation,
>> + * __bitmap_set().
>> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
>> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
>> + * system.
>> + */
>> +#define DIRTY_BITMAP_PAGES_MAX  ((u64)INT_MAX)
>> +#define DIRTY_BITMAP_SIZE_MAX   dirty_bitmap_bytes(DIRTY_BITMAP_PAGES_MAX)
>>   
>>   int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
>>   		      unsigned long npages, struct page **out_pages, bool write);
> 
> Best regards,
> baolu
