Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9481B5E53D3
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 21:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiIUTbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 15:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIUTbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 15:31:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C679A68E
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 12:31:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LJTOLI017143;
        Wed, 21 Sep 2022 19:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=NSG49BN9cLFU8+9Xjf59ROquUUatyKqQiXrIswDMVEE=;
 b=mHwFhvaeFqF3OizS0dtUYQbM0Ln1ZsZQCyI81ZZuW0TjL25J0VdLnDjq2MfsMxUusmIY
 UszuRwuVPc7YRZe9crqKgxzLwJZgVOnk6AqIrBoCSESAFWnZp+HVgiEq1Vf5Y5R7FH4s
 98pp5RTsjQ+IQ63HkuWri+WeWeEPUsEYDlDO1703YLlaQBjOViBwjl+zJO19irYTEyxh
 yGbUJZM4DsuGfQztqUNPninpTu6oaRqXM1qcItCaA9QdeK1/LAEA3U3dSC8kuS4p7k9r
 C8bH2kx/HNPD/xStLDtJBuln2uwVAvreBbuG24FQ8u0wIzJU1ehoqKHJsaZZgxVycZca fA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kugkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 19:31:04 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28LI5BM9009996;
        Wed, 21 Sep 2022 19:31:03 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cag1mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 19:31:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KaYFZGnDDnMelTR5IN8BMsR4DPy4oR6vEO81LBw1CjL7Mao+C07A38ZZDTnZvqWKdpvXx/oRNt1DtZYPznQofufMul24CMq0pAHYIE/AjogRVGCC2plIcRJo3b5akven2up8PMhr1rbuhv7y6DZ52luio/7tRQu7UjznN3pTFFEydsNjjO6mAGVq+5mo1JKoaMEcFwsiShLz2uH9TJppAD/Mr7Vutq+YqeWMhCX/SpU/zUzh8iVLOEripJZZDR+Tl+4vYYrhCdIGjtAOPnBaBcZWtL9g59XPJE0MspOn45Mrvxu0u2ltZbhsR+DBnzKNWkm+FAhieW7k2Ot2TovM0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSG49BN9cLFU8+9Xjf59ROquUUatyKqQiXrIswDMVEE=;
 b=VnAELYwjueW4PwJmNS8kU1MmrP5GsH3Us8+3IXmNAT8CeAo/Q+BBDCUo7EmMdIgeqQIUeYXPp6IuadAefN8bQT3a6wkDYFpuqUqO69j6nuGwOchzNyo7xDRxC8RKxdEMngBJ1cEa7eHTwWlsrRQwZkb0quhodbbhtcpPpNiWrQDSPKCftn7nXFa4CvOHuEyTpGaeIcJfoKR93lJmi90PIw8U56yXq6cm3mqdpDw/lKrtZkcQx26SSsW7oPWxnqIwfIqw5JHTe80Idk6lWGu4Z16GuNF4WshCtvD9A1MK/R8+z3oY9+uYK+nVaxEMvtOzhUIjuDHqkaTIS5KO1/Hd7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSG49BN9cLFU8+9Xjf59ROquUUatyKqQiXrIswDMVEE=;
 b=pBcl4ayahkjwMDoWKipWgjNWZigcTSFDfWy4Og+uZtciY+UqBRWnkGgWbsLKUKkGK3Dj6YAKriv7dIAxOjZxMa70a7cQjP6DaPQUiZHHm4rm31UEfXp6bm4E9WXabEMda2G2Dv7mBQIlzJwE/IXLOjCkn2f4t+pEPdDH30kn0o0=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by SA1PR10MB5712.namprd10.prod.outlook.com (2603:10b6:806:23f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 19:31:00 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::f013:ef98:4ed8:1056]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::f013:ef98:4ed8:1056%6]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 19:31:00 +0000
Message-ID: <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
Date:   Wed, 21 Sep 2022 15:30:55 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <YytbiCx3CxCnP6fr@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:5:335::12) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3240:EE_|SA1PR10MB5712:EE_
X-MS-Office365-Filtering-Correlation-Id: 63bc8ce0-8e6e-4444-5648-08da9c07d09a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEulAznXv7VW757UrUF2B/LMPxLdBsJ4wMzLi4V7IGLefFJw1oGJijOC1wkVAMXk7UX9m7lJj53uz0W+XyfJ5d6PfbOxmetbZrjf7Chwsn00OmPwQFQ+18FxTEjGeifD17e7vydMBqJf9Vn0GOyVLM4aoVneJG9cDmDif1MoUAMgX3/i+iOHf19VQ4HKMLKgD6rvcqWEx+qPAxM5dSTqcwa6pPNdidKNC0o6SoWkQbJNw99EHOUbktaYP8ncsAXnpqYd2EwpQtYCx4cq+rZZMwyptgjgcrW9htxmQqNynNgLMlELXbAtm39ecc/qBCi97TC6OjavgdEI9VjFwn4XHpLG1WKJdDyBAHUjlOE5QFJViFvVIKTjLgOVa6BUnLTtBxQLg0Ce1cvIJ5MhKdU88dsOXHpZ20iHP8LsWPtYTfD0oRavkD1ysQjUcgwXjuHbIOrimI9eBIWozWvdEI5ab9IqYYYmL2BlK4FJuyXpHeOMz/iw2tIXCUXY4YnFg77gW6awTXCwvsHZ+cyQdt/gZuWFmxSgRMFZej//XM3RdB8V6SPA3Y5ExG3ablpC2RVgN+okFByPzo2g+pbSVILeXjglh4mRmv/mz7Lg8Nd7Oar5vsM0Hoh222fnzBT/Yl++qpI+Ssm7CVCu7mDRHsRHMFoRYXYxw7PPeNbv8ybggCnsLUpntsfI9F8g/t7oQVxub8oVgvpiR9/NRjiCgKHrQ1Vxw+u1F3iQ3R37Y5HrKnZo9Ixl6XzohZenJsgb72/zSNrfjtiMfXX/mQOWpPL9Kh7fIO9YnRMonTPJRnQ6K1SiR4l2nOvcO9Vr3dg7zZb0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199015)(2616005)(186003)(26005)(83380400001)(6506007)(31686004)(53546011)(6512007)(478600001)(66946007)(66476007)(66556008)(8676002)(7416002)(5660300002)(86362001)(4326008)(36756003)(6666004)(36916002)(31696002)(316002)(41300700001)(6486002)(44832011)(54906003)(8936002)(110136005)(38100700002)(2906002)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHJVdlBtditpc2I5K0JscDZIRWRTM3BHZ1VMZllPOE1kZnZUOW5EbWhqM0th?=
 =?utf-8?B?cjJiZisxSDJOQVhCV01ITldEa3Y5cFgyb3Y0V1dJWkliUFZ1bDBub2R0Z05W?=
 =?utf-8?B?dHdSVDFONnV6cVR2T1JKb0tJUEgyTmZzQS9naWpXTnFlZlJ6RGUyU2dMV0ha?=
 =?utf-8?B?WHRrbHdETWFsSnlLdmtMWTRuTkU2eGNDVlYxSDNJQ0ZvN1NjQU1TRDc1eXJN?=
 =?utf-8?B?YmxVc2oxWlFxdGlPZTk5Q3htdS8rK2VOSnl5czZpOEp6ZkkzQjEvdFNLUEhs?=
 =?utf-8?B?UjVLdE1uVlBLcjNvc2prc2x0VXRNaWEvSUpBMVNWL3FOQkxVRitQeFZDcit3?=
 =?utf-8?B?UkNFUnBINUV0dkF3NFNQcXpNbWxFMXF2SEhXYzdhTkQrL0dqWEJRV3BjM1Fi?=
 =?utf-8?B?VHlpV0N2Mnd6cEpGUkV6S1Q5MGN3MEZvekVXd2R0V0FOeTdyMnhGZmtMeExN?=
 =?utf-8?B?MllERnVZTXNCVnhlRlZrL2YzR2VHT1pTQzNIdVhESEZBc3huQlNrRWozMGFN?=
 =?utf-8?B?UnVmd3NCNjZaczJ3OGNUczA1NzhLcWQ2aS8rTWNzUGNUTWdickZOVmJvaVNa?=
 =?utf-8?B?TStVc1NKdkxDWFJXYUE0dEt1TjVwRlR1UnhsNVVPSFBlcHBLcnRKb05sbHJx?=
 =?utf-8?B?OCt3SHQrRnp6QlIxTmU4bUh6K1NvOHEwZ2Y3aEZab3ZwSzRmQkxCMC9rRSt4?=
 =?utf-8?B?WThLZ1FrRlBRY3JYZVNtaTNXdGVvUi93MUhuR1BmR0k3cE1RMVhJM3IzZVdE?=
 =?utf-8?B?eER5UWxDZ25ZUDVTTjA2UE1OWTFUYTRPUHZDK0lzZVY4WlBQQlhGcExaOGNT?=
 =?utf-8?B?eWZGRE5ocC8xVFNGOGRJVGdmV3pkTDVMcmg1RE1UM0JrOWhpMDBDTlpKSElm?=
 =?utf-8?B?bnpJMklJbWEyNDBwRTJPZmFIaTBHZmswNSszbTFSZUlHaHFneUE5ZjlwQ0pH?=
 =?utf-8?B?V1VsT0VwekRVanBZaWxsRGZmRllCRExWNUo0SXliVHVsUEE5bk5SRDVRYkdz?=
 =?utf-8?B?SVNPSXFlQ2pBS1Q5WXhtSCtxN0xjVGp3MmczUXdBQ2E4Uy9rU0dod0FvU3VK?=
 =?utf-8?B?bFZRL1ZjRENWVXlLVmJ0a3lJYUp6NmpkS0VVc3hDQ0dXT0ZEbERBTmJNZThu?=
 =?utf-8?B?dVdJd25rTGdwTDdMK0IybnducGJhdTYyNnRjM05STjJIdGF2YlJJRjQzUGo2?=
 =?utf-8?B?MUlHSTEySlRoclFQS2ZyQ09CVm9zRTQrKzlRRTlTRndpSFNGR2pEcFY3OVZG?=
 =?utf-8?B?SDZXR0R6L1IrQ1V0OHZIcHEyL0gvVS8vVUx2bEFrUGM3UkJONHM3NldYTEZp?=
 =?utf-8?B?QlV5UjEyMnNOdzdJZWRPOG1YRTcyZXc0RTl3SGlyeDB1YXFIOTBNK1k4WDBx?=
 =?utf-8?B?cTRid3VVenpweDVLeEJIT3dLUDdpakl0N1FhcGFGajRid1NFaWhHV1NjNi9W?=
 =?utf-8?B?c3hSeVBsdnVsVWl0TG0zYTUzeEdYMGYxTlI1R2xvNG9jNW5NU1NzRk15YjJq?=
 =?utf-8?B?L1M4aHhmTUtmcVJ4RnVTdi9UTWErdWg0a3FYSE44QitvdHpNM1VsWE1vYWFX?=
 =?utf-8?B?cWNveGJiY1ByOVFIb002aisvcE9JWlJHZVpNV1AwM3BDcGFoc09rQ0ZKSUIx?=
 =?utf-8?B?MHpwcHdGa0pRaTJOc1lUbE05NmtoR09ZWXBqMlRLUzVGdk5lcU5jblNjVWU4?=
 =?utf-8?B?bUpRNllwUnZUMHRUTXpWRGNEQUo1OWtjVmhUL1RzUE9FSVlDY1VHSm5hVDlJ?=
 =?utf-8?B?cXNoTTJWVnk4c0FvQUM5MkpPc3hKUTgxNjI5Qk9qdjc1MGdOei8zVlVxSmVn?=
 =?utf-8?B?ajV1VXZhZ3BMYncrNEpEczFXVHdTT3h3dWUvS2tpQmR3ZGpEVkY2QXFvckRR?=
 =?utf-8?B?Um51TlFmOGYwSUxlNnA5aHN4M1E0REZ3QVk0K2lyNDdSdWJSeDhCZHBRTTVO?=
 =?utf-8?B?MXIxQnkzUy9DZ1RGT3lqZDhWZWNpZjVsZFRURGowUTNaOHZ1TWEzc21UQnNk?=
 =?utf-8?B?UVFzM0VPeGV1L244b0lySVM3YTNkUFFQTm9CSEJLZEZWbS91Tyt0UTFtRjU1?=
 =?utf-8?B?aHRpVEI0VW9TUFI2NStvelFLclV4dFYrUlNTUnhIYjA1OE9LMHFqRis4dDBU?=
 =?utf-8?B?RTdJNVZlc2lpSWd2dlFpTTR0RjFFZHFoV0Y3cWprQktGQjVuZVRUWWVvOHVr?=
 =?utf-8?B?L3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bc8ce0-8e6e-4444-5648-08da9c07d09a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 19:31:00.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2by7OoX2hwVhsu9gGAq+YvOwT4GqhWYxKdOssAfloZ8TGSLdASHNjxGt6+a3nh6aU4NJ6/iBUzImAXncrAXUYFJL8VsQjH7CMHttmwrqLIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_09,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210130
X-Proofpoint-ORIG-GUID: YsYg59TS3pBvqj-XsXSjlcedeqFJPlxR
X-Proofpoint-GUID: YsYg59TS3pBvqj-XsXSjlcedeqFJPlxR
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/2022 2:44 PM, Jason Gunthorpe wrote:
> On Wed, Sep 21, 2022 at 12:06:49PM -0600, Alex Williamson wrote:
> 
>>> I still think the compat gaps are small. I've realized that
>>> VFIO_DMA_UNMAP_FLAG_VADDR has no implementation in qemu, and since it
>>> can deadlock the kernel I propose we purge it completely.
>>
>> Steve won't be happy to hear that, QEMU support exists but isn't yet
>> merged.

"unhappy" barely scratches the surface of my feelings!

Live update is a great feature that solves a real problem, and lots of 
people have spent lots of time providing thorough feedback on the qemu
patches I have submitted.  We *will* cross the finish line.  In the
mean time, I maintain a patched qemu for use in my company, and I have
heard from others who do the same.

> If Steve wants to keep it then someone needs to fix the deadlock in
> the vfio implementation before any userspace starts to appear. 

The only VFIO_DMA_UNMAP_FLAG_VADDR issue I am aware of is broken pinned accounting
across exec, which can result in mm->locked_vm becoming negative. I have several 
fixes, but none result in limits being reached at exactly the same time as before --
the same general issue being discussed for iommufd.  I am still thinking about it.

I am not aware of a deadlock problem.  Please elaborate or point me to an
email thread.

> I can fix the deadlock in iommufd in a terrible expensive way, but
> would rather we design a better interface if nobody is using it yet. I
> advocate for passing the memfd to the kernel and use that as the page
> provider, not a mm_struct.

memfd support alone is not sufficient.  Live update also supports guest ram
backed by named shared memory.

- Steve

>> The issue is where we account these pinned pages, where accounting is
>> necessary such that a user cannot lock an arbitrary number of pages
>> into RAM to generate a DoS attack.  
> 
> It is worth pointing out that preventing a DOS attack doesn't actually
> work because a *task* limit is trivially bypassed by just spawning
> more tasks. So, as a security feature, this is already very
> questionable.
> 
> What we've done here is make the security feature work to actually
> prevent DOS attacks, which then gives you this problem:
> 
>> This obviously has implications.  AFAICT, any management tool that
>> doesn't instantiate assigned device VMs under separate users are
>> essentially untenable.
> 
> Because now that the security feature works properly it detects the
> DOS created by spawning multiple tasks :(
> 
> Somehow I was under the impression there was not user sharing in the
> common cases, but I guess I don't know that for sure.
> 
>>> So, I still like 2 because it yields the smallest next step before we
>>> can bring all the parallel work onto the list, and it makes testing
>>> and converting non-qemu stuff easier even going forward.
>>
>> If a vfio compatible interface isn't transparently compatible, then I
>> have a hard time understanding its value.  Please correct my above
>> description and implications, but I suspect these are not just
>> theoretical ABI compat issues.  Thanks,
> 
> Because it is just fine for everything that doesn't use the ulimit
> feature, which is still a lot of use cases!
> 
> Remember, at this point we are not replacing /dev/vfio/vfio, this is
> just providing the general compat in a form that has to be opted
> into. I think if you open the /dev/iommu device node then you should
> get secured accounting.
> 
> If /dev/vfio/vfio is provided by iommufd it may well have to trigger a
> different ulimit tracking - if that is the only sticking point it
> seems minor and should be addressed in some later series that adds
> /dev/vfio/vfio support to iommufd..
> 
> Jason
