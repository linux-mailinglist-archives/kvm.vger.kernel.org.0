Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB07651BCD1
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 12:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354935AbiEEKLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 06:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350066AbiEEKLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 06:11:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB3251316
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 03:07:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24588rXm025194;
        Thu, 5 May 2022 10:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=62cIPnskhKo0j1ZuLjL89pMKT0O01WmY2Te2xWUb8Zg=;
 b=cou+t+ltavgATelN7gdHdLrV6L/oQ99r97STiYawzmexFC632KIMaJZNcKzejzeYd0It
 q7U/tqKlwZjhYgY9nRwoxa+P44kVz9nmwEq0b5m9yfjmlt0RuLapIbNxSFIC8ymvHVtV
 +pUKSDGpwhYrbhbMM7Hfq6LEMcphuulXpwslz7LllX/hIZS3pwmB6wGgbZRcrHFuc9NX
 vIG8b/r4xVqc06Xs4CkDcbGx76X+ChoPhyZUp30ljTSX4ImJCxu8HluJA9HHEL983rcE
 Jb9sIO41c1VX8oC84Wfpp6B228s/bvhq2oreKdD3/Hj6lalDd3SijbhtocqM+S4xBwlu +w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2jvqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 10:07:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245A5OlQ018225;
        Thu, 5 May 2022 10:07:00 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a6rnt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 10:06:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLuHpKAJRLqoV2q/T4qX3tz7c4OrmIAQPWnBxbwKsFlc8pccqRmwVBE0kR1N6YVQx4LC+Il1lyCtcuC0L9k8BmOQ1vxzGCC3M8kNzQVW1WgM9mSgCOtBCXkjhn6Gf26Ki0WpUc4Mu4zQy113bLbivieQ4MBOPZBIgZ+KYwyFFK8JU5LGENr3wtXtYzgVpuon45iCleV/OamLDCLXdGPEHjF7Yq3MgIQhrazA/bOwWARi0ZIb4vafj7eVG91GOAoqJyGViMhP/5+DnPaveYfNnZ9piUvc21+sEjQvvGHdWUStHFrLIKYxq4GoYkJr1tLmimDePfVJnbRTRjXFeTWE3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62cIPnskhKo0j1ZuLjL89pMKT0O01WmY2Te2xWUb8Zg=;
 b=ckH7e6FFUoSWlyN6RAZGSRfZcFbrZ7yoH/wjh/hu8rgA0Qpc+Npdrq+yEBGPvjdL5oki8jXyb4rjJWzEVFE501NW7J2dkLHIiecmwwxDsCseujobfKPfd3A3Gnb4ea2IcXWYGijrw+VKUm+AypKbaybB+6HbM2VpLVcQOtQT3Moz9Y8DmYJ/EmjxHxDwMa8W1HfXdIrr062ufhKa5JVqf2NtjXRjiZHOjUIdhjvV/e33bZY2zh0opRaNhlsrSLZG0dhSB+dykp2vY1UUZHkzTZI2VRcy6IviZNwfB+u7MI7ZO+Gc206yT8oqLsqasjStdD/iOM81SoPf90UpltlyNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62cIPnskhKo0j1ZuLjL89pMKT0O01WmY2Te2xWUb8Zg=;
 b=LobNE/rUXMgf0RMqvybi8UQEj6ntRXagyLcyOKRiMHeZQan/DrdJm+cVvwWQVM8vMmlOdz6ioqB4iyyD6/oxIuYTxXhYz64I263Cglf2265SbG2Y8GVnj5Oi055w2fxL7UtNqYAF8l+ASjtftGOOETpPOO/FKYdDc4m8o+d+Y2w=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 10:06:57 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 10:06:57 +0000
Message-ID: <7b480b96-780b-92f3-1c8c-f2a7e6c6dc53@oracle.com>
Date:   Thu, 5 May 2022 11:06:51 +0100
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
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
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220502121107.653ac0c5.alex.williamson@redhat.com>
 <20220502185239.GR8364@nvidia.com>
 <BN9PR11MB527609043E7323A032F024AC8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <BN9PR11MB527609043E7323A032F024AC8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0160.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::28) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1c620dc-74d0-4aa4-1ec7-08da2e7efd33
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB533843203E519B7E6BAB0942BBC29@CH0PR10MB5338.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+LSqpfBIyinilRC400KyWP2DCHsz9LRol0+GYNmcviAqvh/vlX8TUMIktp7YCcgT8XehI0SG/ny5l8UOVFDscx1g1z6YmEVw6P/KxIUd0cOOTtYtFWYU+L+5p8ysVMWw5K/3xi6VxsFcywmo4KMA1bf93TlnB6zQD8hHjeuMkrCFd8sTYw+3CDaGkFgYcdRsMsbRcXPtrSHPV/pNCqaP0qVwB7dJYWxQk8UWulv4vHxKxsBhBJONaIVA9jlraXUfBz8dnTMngOP4vVTIOUwNgIPG2zwBffvOMw7bWwIFfytYyFKj1IcFcW83SwoqcejDYwBuTGjke7G+QrYa+29fYeuiYnYnZdUjH8mKO5rqWnAPMETAWQBus0bxFBH39j9BMoXHl3S55At0RzwQmyW6P7suDdd9YwcjQJKGHz72V8PfabssG8/bcP2HfUXcL3k5DgmR5nWIfO3M8skz3PNrgb/vd6r8mfJmqkei2EVOxPzQ8WARpRaGy32LgLiboCnFoKajWKMlWWlfMLatveYJuQX6oTygoioManeDRJF5RHjw7nyYZyoiHKGk6AN8XzmTxc1hbgjvri+eVC5d4cjtcmw9N5tmqGM6y//O8EaZw7JJUvXpILKaOGLeMQVJnpTeaFTtZ7vkkMQ7JynpdVBpCX7/fpXiImW8wmqnuxE6kiZ2zaR7NMrr+Ttci6y7rwGPgmX7pKRyhPmpUiQptzMAwKR7lVqkxPP2J2lozfhmls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(53546011)(2906002)(7416002)(8936002)(186003)(36756003)(66476007)(4326008)(31686004)(2616005)(26005)(6512007)(6486002)(54906003)(316002)(508600001)(110136005)(6666004)(5660300002)(83380400001)(8676002)(86362001)(31696002)(6506007)(66946007)(66556008)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWJsaGhPZGVYUWpMU0VnbHhSNVFPajFmRlE2dDVjMXVlSkVQUCtVUnFDVnhH?=
 =?utf-8?B?QWdIb3R6RmR4VEpiSGlERkFWbjdkREs2aGFDaWZsUnY3OFBxdU5LU1RvWUlO?=
 =?utf-8?B?QlJVWXhZU20rK0JSak9VdEpyYVZmdjMvdjhWMFdERDJ6NUp1UkU0U0xLRWV2?=
 =?utf-8?B?Wk01TXd5MEJBWHNFVWdNaDQzMzJYc2wrcFFhb3lscSs1NVNpQnpmY0ppdUEx?=
 =?utf-8?B?WXF2dTltK0krbkd2dmFLYVIzZW5DaFFjdS9tVmZXVDBGM2V3Mzh3QmIwMVhi?=
 =?utf-8?B?azJLMXRpckFFa2o3bGJVYnFDdWQ2a2hUZVNGYVJjc0VPZS9pd1RoZytEWnEx?=
 =?utf-8?B?S05xYjNpQzB4b1htaDg3STloQUc0ZDg3RjdRU1dQeUZLUXMxRVFFWG44dGlx?=
 =?utf-8?B?eVExUEc2YkxGT2hnYk5vVEpyVnJxR01vbVFqQlA0dndqcC8xcWcrc3ZnemI4?=
 =?utf-8?B?MEJsVXR0VTd6QUR6aDZpcGwrMVFhR3R3MmZ6K0RWdXRSdHZ6NVo0NHg5YmRP?=
 =?utf-8?B?N05EMWdZeERVbDlOQy9FR0JudGE3SXRCejZnNzQzSHhBNFNKTTNqVk15a1pF?=
 =?utf-8?B?blE5S2V5NTBVeVpBSU0zdGw0Z2g4T3hQTFA0WHR1RXZ5d2hzZm4vdjBMaUZn?=
 =?utf-8?B?SzVsNTVpbklWMTFEVnMzNnd0T1JwZGRIeWVGZzJZa1dxTWNNRXFLU2t5dzJQ?=
 =?utf-8?B?MGhjWmVuSDJ5YjVhM2hiQWwyUENwQ1J5RWVxU2Q1ZVZOWUZsd1RpV3Azc0c5?=
 =?utf-8?B?R0xpdnN2RnQyNDVvRS9laUlnMks4RjdnSHUzd2w4aElSam5oQUw4VDA2NjVt?=
 =?utf-8?B?UzNwUGkveWp0VlhDaVdOOWx2NVNETlpSb3kzSFdYZTY2ZXIzTjV3TjRFSzlE?=
 =?utf-8?B?UTFoZDl0Y2lyWDI5TDYwMHVJajV3QVFveXFKcmxJYUczT1FLeXFFT2t0dXBZ?=
 =?utf-8?B?T3VWdncySHc3L0svV0thMkhuR2duemRTbWxKZFZlV25UQ1ZIYWdNaGR4UlBk?=
 =?utf-8?B?bXNNZ3hDYnhsWHJsSTIzb1JrMC9QdTk2bndaU2ZLdTZvYVptL0RTQkh0dnJC?=
 =?utf-8?B?Mm9MUXV6dFhBdnlvbitTMGx2aUFwZXMwZlE0bXEwQm5yTkdFNFRpSDMxaDRa?=
 =?utf-8?B?YmVJU09PNUZjODhOdWk0cmNFRlNFVHA3QjVmd205NEQ1V0NlTDNQcTI5d2pV?=
 =?utf-8?B?TmZ4YjdQNUVaRTNFSzJqdXBJVi96M3p1QkRBUkE3UlVtQ3ppYkVBVVZ2RzJP?=
 =?utf-8?B?bHFGT1dCajlaNEhZeXVoSFBnRGJUQTVQVElKTW9pRDJkR2ZaNmJqRlVsNm51?=
 =?utf-8?B?aG1hbzREWmcyTzJYNGJNMjkzSXZNRWpFd0VNem5jZjYxSEJZYkxVZVVpd0Vw?=
 =?utf-8?B?NUJmZklVV0o3Y3VENWdoLzkxSU51UklxUy9sUlg2ZUJDa0VzSXUzRDRTejJ4?=
 =?utf-8?B?K1JGeXlXWENUQ1hISXJ1T3Qra0tvYWN4NG1MdWFFS2Vod2oyaW1NaExheVJJ?=
 =?utf-8?B?TkRBd2tGY2hNVXMxdDc2QjFBMjhEZm1Db2tCVE5KYmVZS2k1VlRpV0YyNFlr?=
 =?utf-8?B?RGQzRXg1RUE0VG45K2R5b3M0SktRM1d3UHN4S2IxU2RUZVlGQzhIYmRJaSt4?=
 =?utf-8?B?bHJhKzRLYUFHdFczUUh4cXljR1R5ZkdyTG1QVHNjYnREQWpvTHNsd1dURFhs?=
 =?utf-8?B?TFNJajlFZXpqWWc0amJXQXNhUnJtSFBzU3pnQVlXeUNuWlRXc2JoMGdTQ0lx?=
 =?utf-8?B?UjRLSmxZa2RBL1h3akp4WjJVYy9zc3k5V1BpYlErVHFOOVNTSzVLYTlEdGVm?=
 =?utf-8?B?cTUxWG9heURwZkdoYlFOME1Zd25MUEtxZ0thcldHK2lzL0hVNnp1d21Cc3lK?=
 =?utf-8?B?SDczYWR6dmxFelFJTWp1S3JRNjhJYnB3cEwwSUxmSWh0ZmlOQXZRcTA5eWpM?=
 =?utf-8?B?VXRDdk9WUS9scWx2dmpMV2t1VzRNQUtpaDc1eG9yRVd4bDc2TmF4THp1MS9L?=
 =?utf-8?B?L0ZYQkxPR0Z2RU42SGxtS0IyYlhlMmNIZjk0S25vQ2ZxRUFwZEp4MWduT29a?=
 =?utf-8?B?S3pEUGpjRnRvZndEa0RGMUhnZXY4SVlQOTRYN1hTUFdWeTNaLy82ZjhHdmpF?=
 =?utf-8?B?aW9GalJJWnBFdFpzWVJlRnpKb3JWNVJPTDNlZThyU05ZdnZpTDVUL0d6RnM2?=
 =?utf-8?B?STJiK1lDRHNVTzVSdHgzRS9uUmZZQjI4UWJORkZybzlQSVpjN2hoQjBpSSt3?=
 =?utf-8?B?dFQ5WmdqVFBIMDlqWXVlcUhVT3FBVnFKSFo5MlBPQ2s1ZmVyVTBBVkt3RG5i?=
 =?utf-8?B?cTQ1NGIzYTdtL1FPVHVQUHFjYlVUaWhrKzBLRTNtaUxqZEpzRUVjQjFiZGUz?=
 =?utf-8?Q?7HD3g9ZrSA+7N0+Q=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c620dc-74d0-4aa4-1ec7-08da2e7efd33
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 10:06:57.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yq+4SrklBT6dha4tiiFpCtxD6EUXwIzFRpAHfYZT0XxhozQ8HwSWwT55cqV2kUAH6ZiKy/Dx7oKEW5Bhc9RPCIExA68P+2yAwA9FGbHAChg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5338
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_04:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050071
X-Proofpoint-GUID: qZMtYtW4bd63yD52zEyGInwBaBJIFItd
X-Proofpoint-ORIG-GUID: qZMtYtW4bd63yD52zEyGInwBaBJIFItd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/22 08:42, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Tuesday, May 3, 2022 2:53 AM
>>
>> On Mon, May 02, 2022 at 12:11:07PM -0600, Alex Williamson wrote:
>>> On Fri, 29 Apr 2022 05:45:20 +0000
>>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>>>> From: Joao Martins <joao.m.martins@oracle.com>
>>>>>  3) Unmapping an IOVA range while returning its dirty bit prior to
>>>>> unmap. This case is specific for non-nested vIOMMU case where an
>>>>> erronous guest (or device) DMAing to an address being unmapped at
>> the
>>>>> same time.
>>>>
>>>> an erroneous attempt like above cannot anticipate which DMAs can
>>>> succeed in that window thus the end behavior is undefined. For an
>>>> undefined behavior nothing will be broken by losing some bits dirtied
>>>> in the window between reading back dirty bits of the range and
>>>> actually calling unmap. From guest p.o.v. all those are black-box
>>>> hardware logic to serve a virtual iotlb invalidation request which just
>>>> cannot be completed in one cycle.
>>>>
>>>> Hence in reality probably this is not required except to meet vfio
>>>> compat requirement. Just in concept returning dirty bits at unmap
>>>> is more accurate.
>>>>
>>>> I'm slightly inclined to abandon it in iommufd uAPI.
>>>
>>> Sorry, I'm not following why an unmap with returned dirty bitmap
>>> operation is specific to a vIOMMU case, or in fact indicative of some
>>> sort of erroneous, racy behavior of guest or device.
>>
>> It is being compared against the alternative which is to explicitly
>> query dirty then do a normal unmap as two system calls and permit a
>> race.
>>
>> The only case with any difference is if the guest is racing DMA with
>> the unmap - in which case it is already indeterminate for the guest if
>> the DMA will be completed or not.
>>
>> eg on the vIOMMU case if the guest races DMA with unmap then we are
>> already fine with throwing away that DMA because that is how the race
>> resolves during non-migration situations, so resovling it as throwing
>> away the DMA during migration is OK too.
>>
>>> We need the flexibility to support memory hot-unplug operations
>>> during migration,
>>
>> I would have thought that hotplug during migration would simply
>> discard all the data - how does it use the dirty bitmap?
>>
>>> This was implemented as a single operation specifically to avoid
>>> races where ongoing access may be available after retrieving a
>>> snapshot of the bitmap.  Thanks,
>>
>> The issue is the cost.
>>
>> On a real iommu elminating the race is expensive as we have to write
>> protect the pages before query dirty, which seems to be an extra IOTLB
>> flush.
>>
>> It is not clear if paying this cost to become atomic is actually
>> something any use case needs.
>>
>> So, I suggest we think about a 3rd op 'write protect and clear
>> dirties' that will be followed by a normal unmap - the extra op will
>> have the extra oveheard and userspace can decide if it wants to pay or
>> not vs the non-atomic read dirties operation. And lets have a use case
>> where this must be atomic before we implement it..
> 
> and write-protection also relies on the support of I/O page fault...
> 
/I think/ all IOMMUs in this series already support permission/unrecoverable
I/O page faults for a long time IIUC.

The earlier suggestion was just to discard the I/O page fault after
write-protection happens. fwiw, some IOMMUs also support suppressing
the event notification (like AMD).
