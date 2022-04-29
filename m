Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3858514DA2
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376863AbiD2Olm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377591AbiD2Ok7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:40:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112672C66C
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:36:59 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TDlihO003733;
        Fri, 29 Apr 2022 14:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=usRtOQUakCKKNjcGL3OL6N6IzPvo6Lrk/VFTJQF2jYM=;
 b=wwsawupgI3Mj49+JTjbWil/MLkCzckn3B2Hu2J26+GygsZAaT1rXV4BECxiPicFnGBPU
 ZvkQl4TihSapXCGpGSJtyD+eaey0AsKh1B3MF3tPBergaXHnLHmEbuPOYRUtPm+cJjjz
 p1lp7OJrjs/esy6cGMVqfqEG9v62honNtQYhzlOqglFY8lPwdBuokZGK2vc6OLOMRkE+
 HfiSNLuboY8XtjRh2Ig9y8FVy+VWEerSTUYrIi6ofjDuJggkuEjRkjZZaqD+VPcI33FK
 067XZ6obGeg3dktG0krNJVfTJC5iZqsPRo2VJzDarZZfGs0fK04ZHp+A+502rkvREeBf +Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4xfv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:36:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TEGfKo026995;
        Fri, 29 Apr 2022 14:36:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yq8cwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:36:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmoRL7STydzN4zOSzpqxpQilgKMKK1DJRobvEQBjQf72/zu+AUFdPzSK+BikWagnidHh0vWc7KnPbAFV2CiPtz0gV9dNA8RL4VARVQyUMHwLCQpsXZSFBCxMUN9RAF5ChIxlyVQWODCvMrqF4rETA3hQvHVt/62r9ZVLui0ptDcI10OUMtKWZ3IqGnr6V70y0cCtkRByoE2iDF1QDmPvf5QHl++5RewXXDjMKENKCbdycK9JvT4GrP8nK5D4/Os2QJJZ2LTOGYtZ7tLG6fZgfpYgRuBANGqgxfrj/aMX5MX0jp2kmV7NxpnA8eNHu7Puarx0guJCJE0BaotsRkAHFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usRtOQUakCKKNjcGL3OL6N6IzPvo6Lrk/VFTJQF2jYM=;
 b=gFFba7G6v5W/2u/vq2lHSZMrnqHzRbCFyIelhI+F3CIArPnkQqRtj0QVurKPH/L/Ie/AiGKmDiCCxcEj/ve2TC98zSWpjEWtHXKFMbWyN/Y0ruhUM201ZsuthqXZNmy28X0x99O7vaEY5IpvdDDVauI3/+h/5NaYHn4ruxtm7aS0sVZQpVqGsLFX29g42qx1ELWvreZi7h7bLFNjS+v29oBT3f1YluLkLNmMihAXqLvTCe59PnzqUK9oWpboayt8QcYFTBJptqosd55SQy+j/zngNXEhgMmVsED2prJrfGw0XCMlqbE8M3DwyR9xzd5PX16IxPrat+fK6kQFEWOKZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usRtOQUakCKKNjcGL3OL6N6IzPvo6Lrk/VFTJQF2jYM=;
 b=tfl89rMUBx0RxMZjimqJlqO0C3DjCV+6e/pVACKCpaO25awUaKtCcHNmJagnLajPVhCgVzkzTcxNWX8PK/lbKN6UFtca7vH/iSmQA3aLWDr2AsxO6KcCLNSzrdldx2kQsVpKxXZFywuk4QUsCbqLyUEnTEAse+aMXi4Ot3IvPK0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 14:36:28 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 14:36:28 +0000
Message-ID: <90d87975-d08d-1964-9c8c-41429ba91f8c@oracle.com>
Date:   Fri, 29 Apr 2022 15:36:20 +0100
Subject: Re: [PATCH RFC 05/19] iommufd: Add a dirty bitmap to
 iopt_unmap_iova()
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
 <20220428210933.3583-6-joao.m.martins@oracle.com>
 <20220429121417.GS8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220429121417.GS8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::13) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83ce9264-b48f-42bd-82d3-08da29eda51d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB365887CCC3EBF9359E220272BBFC9@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BM4RLeCeArg28++TmiaiSAQ8oZT3PDMNHe98sNhm6/ySFhxG2C38anwd3YJMy8N4k9LDn7IqEOtfEEeH2uQEdcArW6Gsam+NPiSbjBADkoct3OdtHFO0bxcfUxi1oTYMyRsVuR3sl+aOSsLLl2nsr6jj7zNKBeMOdvyJbB0Nr/fTImKSesQvd0WmHvoahNUzkmpj372cmAbWNzexmsD5AD1ZR96Ocezg+lMys0P4DIUHxfoVUF1PmrqM+5osu/Bj0V16b/MKx0Ln7MOElFU3Zg30mE1g1n7dobQDzH84qPajVYn52po0IYGzI0I7sDTtMNa380oMZB6/BbqADSKL1W/Sn992afUw3Df4XfBEHbvTw1QeImDBO7icWFf03AOuCVH5TvSVfQCS2tUq4htGW+TkBgVVrFYG6jxFOANDZqO+5QVl173bVHkyvio7dSJTBAILNP5N3VMU31ArhTFWibVNvQA0oSO99C7pUEOh/ye4pFgcxFszsFYBCiPMnOGZjUdLXBWBUWGnWRkpOHglkn2h4ho19ofA0Zs1gpbO38fILm3aBAxQzZrZ7fXpuJGXNTpA1ebFzSWhbshgFkUfsQ1YV4NASCOusP3X4ytV5y72jfT1kP0Aq3VTOURKUTipUFKKeL9rJT+3lvXeYdwpFuyL02Mf6W31JDp4N9g4uRRJieWB4liUQ2VS06mDYfIyqDN60yTIZoHavzb/gCLg23VLtZajVUC8K/E3hrGaOCM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(6512007)(6916009)(31696002)(38100700002)(66556008)(66476007)(4744005)(8676002)(66946007)(4326008)(2906002)(6486002)(26005)(53546011)(6666004)(8936002)(54906003)(7416002)(36756003)(316002)(31686004)(186003)(2616005)(508600001)(86362001)(6506007)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVl1QUdmZGxrcmNZMk9JdWNjVW4ycDVUL2hDNzlLYTZqeVVKYmkzbXFIOW9w?=
 =?utf-8?B?YWJlM25jSnh4SWhac1FsRzZQeFFvKzNjTEdBMWYxVnhiMVZEQ0dUSUtadVJS?=
 =?utf-8?B?dU1OSHk1cEdYVkxqYUU0bkJSVmhmcWFZbHdZWWMycjBYUkNqb2p2ZDZPY21H?=
 =?utf-8?B?cG1zWEljYzdFSDJRa3pRMG9DU2dNT0g4QzZiNEhhN1E0MFRnNndCVktTb0J3?=
 =?utf-8?B?MUFqZ21naXpOSmRrbTVhbzVCUE84RldGa3RnU2ZzbHdDTEQrNXBtZWZWTUtv?=
 =?utf-8?B?RDQrYVRnc1JLUFl5cHlNZnNRRGdJVUlldElpd09yTGkrRUpMQkg3N0hyaUpL?=
 =?utf-8?B?WXpIWVNpYmhwdGRqclRoclk0bkhROSt6cjR3a0dxdmVhMnRuSFdlRFB5cHl6?=
 =?utf-8?B?N2xCUm50cnZxVFdGZGt2S1JWT3puSk44V3JLOGlUdXJxclc2RVJHajNqa2U0?=
 =?utf-8?B?cURJN3lpTkEzdWZOczB3N3JEd1ZBcUY4MFExdmZGK09QalRNcTk1N3c0WUJG?=
 =?utf-8?B?WE1OOVNoUWZnRWt4OTNFelczMXhHaUtGTWdocmEwYUhrbmhXVm41T1lhTm5F?=
 =?utf-8?B?OElUbDhKOUxPUDBFWG1EcVdtRFczeDV0eWNWQ2ErVDdTMlh0VFh3UnRXcVNK?=
 =?utf-8?B?aWdGMS9KM2ZPY05ZZkdJRElJdWNITTdCbjNWeVFLOWUrQmZEVDJpR0dwS084?=
 =?utf-8?B?U2R6S3RxZktmZm00aTNVUjRDazluS2VmbDhIemNLUzRVR2lCWFJjZEVLdmc3?=
 =?utf-8?B?WGdSZzFScmR3QXQvRkp4Wld2cUpUa1R5TkNtQ0EwR2tKN0NDQmtwdWpqZTM2?=
 =?utf-8?B?aks1MUg0N2lZY1NsNFdnRy92bU80b0I0N05XRnFvM29XUGF5SEF6Nnk4Uzdi?=
 =?utf-8?B?d2ZpTGg5YTNHcytncDRHRUtGN0FjeDU4c1ZmKzdPQTNiMzVqdUo4aThWd3oy?=
 =?utf-8?B?aks4YTdWR2ZiYWZCUEFMTkQ2WGdUUHlxNnZRRWpQRk9UMjJWSzM4MXpvQVNP?=
 =?utf-8?B?cGhBZTdWaTRGN2hGR2x5bHNCY1NqcG5IZWc2QlZnN2RUelhPZHhST0lkakRQ?=
 =?utf-8?B?ekJ5d1NGM1NwTU1HRzRCQWJrUTZXTTNFN0pvQjE1dzdwbzQxZk8rR1p0UUs2?=
 =?utf-8?B?N082RzZhZEl3S0kxbStQUGNNM1hlaUYvdXJXbm1FdFhsVUZVY2VtVVZuMnVh?=
 =?utf-8?B?cHpkWnQ5NDhvazBKaUV0MHBob2V3bE9VWTR4QkdIVlgwZHFOeEZFam9aUWxs?=
 =?utf-8?B?T1VGT3VUSXNOa1paRndpdXc2L0RaUmVlVjBnNnlMUnZPU1dhZlQ1clRpeVhS?=
 =?utf-8?B?RWtpSVFLWnFqTWpSenViYWtLamxNa0ZNT04yQWRyajI4MTE0eDJ6MDJ0bGxz?=
 =?utf-8?B?TlpLNUlya0Z5by9HalNyencrWXhJR0taVm85UHd2aXd3MnVJcUo1ZHdkdXFo?=
 =?utf-8?B?NTY4blhIZEIrbkxTVkMzVzlaaDc4dGN4a3ZTc0N0Y2dWQXhGQU55MXYwaTl0?=
 =?utf-8?B?Y3NBaW85U2RSNkRCUmNEREJaV0UzN3ZDaEJyR1Y3OVA0YWVrSDcrTEFUMzBl?=
 =?utf-8?B?blB3eTdSU3V6azN2TnZrWE9KNkdrOG9kOW1wRExOOGRQR21YTEdTQS8vbUNi?=
 =?utf-8?B?NGZQbzQ0WjM2ZXdySHJ6Um5xUWJsUURpN0JBN0pCL3loSjdaRXZxek1XUDhB?=
 =?utf-8?B?K2M5eDE0U29qN2hlZ3RDWk1OWmN2VkduVDdHcldwV0pLY25GaUJ2Mm8xai93?=
 =?utf-8?B?NjVTamV1bkQvZGR5U0p2K1hMQTZlU3pzdm1WOGs3WlA0dWNZMzZlVC9vd0ZJ?=
 =?utf-8?B?UTVKNEV5cHMzbEN3L1FFaE14NHZ3bE8wam40dXJTYS9DRkM3alc5aDVpZkVR?=
 =?utf-8?B?L0JweDBWYW5DVjJlV283bWZmWUZvVG1paFM4VHlEbE82cXFhcW96VTl5QWs4?=
 =?utf-8?B?dGFkdjhkMUxRWlJUOEdnYWdQSCt4YVhNQXFLWEFvaUZhRC9jWkNrcEV5YnZK?=
 =?utf-8?B?WHp1dHo5R0FTeVo5UFNXaktub2N3cVgzWjM1ajZPdXNHd3A4aktXTUNEOWts?=
 =?utf-8?B?aGtFQnFpZ3g1enB4VUtLWTN5MGpEdktkL3BhNXY2ckhsR0YvNUYrazJYVXRS?=
 =?utf-8?B?aGk0SEw3MGJiaEg1L2FMUmVsUmRsMG4xT0lUay9IUDJkbHRBR3VpNjUrWFAv?=
 =?utf-8?B?eGo1YU9zT1hacjRPcEtCMEFQZ1NXWlJvSExkZmRBTXJoNjRLZDRmTzNtOUpq?=
 =?utf-8?B?c3ZKdEdXQXBYYU92TUdleTM2eW1xdHdmc2lHTGRsdjA4MGEzenE2b3F4VGNk?=
 =?utf-8?B?MGJuMTlTQnR2UXpIUXVBdVRwWWlNUXhHb0k1NlhXM3FFVnhSSnF3Nng4TGxl?=
 =?utf-8?Q?vJ7Q+AZXonIm8svs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ce9264-b48f-42bd-82d3-08da29eda51d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 14:36:28.3164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mu9SAqdy+LJSAsvWcbjYdsQ5yVh2t4LOZr0sNKaiTlPHtSnTf5qXKTjWuJ9SOonaONGMrRU0mE0j7hQ16qT6HA9ETNjV5zcpp7Hrldp4gvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=702 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290080
X-Proofpoint-ORIG-GUID: nXoTmEBoSBySigsyhz8MJ9v5NWhw6dpn
X-Proofpoint-GUID: nXoTmEBoSBySigsyhz8MJ9v5NWhw6dpn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 13:14, Jason Gunthorpe wrote:
> On Thu, Apr 28, 2022 at 10:09:19PM +0100, Joao Martins wrote:
> 
>> +static void iommu_unmap_read_dirty_nofail(struct iommu_domain *domain,
>> +					  unsigned long iova, size_t size,
>> +					  struct iommufd_dirty_data *bitmap,
>> +					  struct iommufd_dirty_iter *iter)
>> +{
> 
> This shouldn't be a nofail - that is only for path that trigger from
> destroy/error unwindow, which read dirty never does. The return code
> has to be propogated.
> 
> It needs some more thought how to organize this.. only unfill_domains
> needs this path, but it is shared with the error unwind paths and
> cannot generally fail..

It's part of the reason I splitted this part as it didn't struck as a natural
extension of the API.
