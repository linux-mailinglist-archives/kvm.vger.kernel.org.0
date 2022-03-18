Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED84DDFA7
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbiCRRNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbiCRRNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:13:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050FE26133D;
        Fri, 18 Mar 2022 10:12:28 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22IG4FCF032174;
        Fri, 18 Mar 2022 17:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BQ2H0GQa/SOwJvtlcZDgR0gFmmt/UIm4ZPpFTxsj6N0=;
 b=qzOczX1zakwkibptUlW6dMqBvcGztUyQBWbDoxFEuLsOANiQ0EuYlnwtJygqZ9REdxR4
 76NQz3lb8Y7VUpUqkMkllD0gtgzCQ1c5p6/9ViAGMvDqPGpvkU3Wa4EjSj/ffS01UwUW
 IVAMj7noeDAAB/htySfhGeduLksFfNOtg1EY0ZzYqmbUcfiLFnQ4EfkCCbgERhs5OtHy
 oqw2ZyHUpedBbfbPiFWgVDi0VTsUxZo5hxbVOVMIV/PiC2AV+TDKZNTl8ulMVP4TDX32
 7iN7iVDdS3wCbb1+4SNyig4Ygh1hFq3mzeEJD1f174x7GAsZCOHqtQ1wDbi48MRpu99j uQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rvfa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 17:12:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22IH8p0b105378;
        Fri, 18 Mar 2022 17:12:12 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by aserp3030.oracle.com with ESMTP id 3et64u49xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 17:12:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNmh7Rh+S9drAfP1r7cMLzKrMyfaHUY9ts6zQLWD+/U7uStj5xvUVw+pYfQEhB6diXI6lmfiGqlIlBPsbB14gFVRWwL6u91UrSaP77auZt3a3pPjLUcn5U5U4EzwWXwiqATzK1a+FE4WGsZExJLUdfGZCcq9kD9UPi2Qkku4vBA0G7EH5YKZRG+Tx7Isj86oUAW3pBK46Zd4PVspGpdLmxxzj73iQd/0YUWd/6SNBZTlLl1hsS8mDZVuJB9CBGg/O8dYTHpljMmO8xzHFY5v7zTi54563RSZT34sxtqI5viGU3cJQ/6byT7w3nU5A87XQg/x6SY2v7v3MQSG6S8D3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQ2H0GQa/SOwJvtlcZDgR0gFmmt/UIm4ZPpFTxsj6N0=;
 b=og5gShOjeiSbbjSVCekQz2dGMEQ7/+Dy3O8/YlsIqKG6VyqHOPusQIM4mhFvywP70kCNsysg8wwfRwGG26t81RyEZsAmaCN9w9cqteyG1dgSZXCt6/BIom2NUETObEunFFbfH99vcFCfElvtZzo+Vv9BaHcdKg2q2p+mDtN9iuxf3bMb9nI24wDoA/te0ibaVVLIpVrS11oWbXQkjIe1htE+lvWI/we6DyQffqkW3OuWyxVPxoBo4WgS452LvlCruWDuLDwJvZEqOOAXme1wikKoKSxGKfiL/7F0CmM7nn1TNbUu4gpjsba9K2FTnRggM48QfNWHg5fscLODjUqZPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQ2H0GQa/SOwJvtlcZDgR0gFmmt/UIm4ZPpFTxsj6N0=;
 b=J68N6tplz/V342tn32u7f3HRtLXSNsWOToHZIpzbup76ilvFsoKjrJMq89bVfWeFZADiawnULf6oLSv6DXZ5/9sGE4AkEAo5zrKCZgmteaE8GmRJGnBiuJloMp/vFEzkHcespsss51vRxVucy2TMmGPagwjwPl4galcMhPiXGsM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB3241.namprd10.prod.outlook.com (2603:10b6:5:1a4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Fri, 18 Mar
 2022 17:12:09 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0%7]) with mapi id 15.20.5081.019; Fri, 18 Mar 2022
 17:12:09 +0000
Message-ID: <052c5f12-4f2d-f302-c2a3-2f2b580e4b4d@oracle.com>
Date:   Fri, 18 Mar 2022 17:12:01 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: iommufd(+vfio-compat) dirty tracking
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
 <8448d7fb-3808-c4e8-66cf-4a3184c24ec0@oracle.com>
 <20220315192952.GN11336@nvidia.com>
 <6fd0bfdc-0918-e191-0170-abce6178ddaa@oracle.com>
 <c85a0d65-143e-6246-0d48-dec4e059e51a@oracle.com>
Content-Language: en-US
In-Reply-To: <c85a0d65-143e-6246-0d48-dec4e059e51a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0050.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2d85960-c515-41f2-f782-08da09026f57
X-MS-TrafficTypeDiagnostic: DM6PR10MB3241:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3241A529F1285819732A8794BB139@DM6PR10MB3241.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWC3UiqxTWoiTOZpIRUZc8BWNLbGybYZmM8rAhMzjyah1oN9jXLqOrdjdDrOgs90zSj9o3KYEeY25ldP7KvHaDv0AtoFlV8tL9qaJR8WSeLQ1gUk/JMr2bYgv0MQ/nOJeCZFsBo6Kd0p7H1I313ynUvItQtqSZ6t+AebYoW8x8ZrczoQM+IMyuyd8QCh4qUKEhM6G9AMQVfe9R6FSTDhoL9nfEhK6yvwYy0C/FALvtKvTBf0qtElMHbs+ck6trkttrXfDcLmFI3yIfXJw+J0z6z8hi4O7+iZbqzmz5vV0OKVMUHoo3vleOrhNjXALOVL5DdyVggzYaliUEL4nrfC2sX5NFZwKGfN0FBKdH7hBL9uNo25/fMZVN1BF3tEg9iLI9mf5roddOnLJxVFwf6SHQzR8Wnlv47cMHngNLePeB/XPWwma59eHRrNtGDdPT6nqL3fwvfQRJC0/OseZOOaooD8fco5BHG6vI9M+OdLM94isfqsgPldotU+rHY9Sump1IcNwapwKRY6eLV7ZzpdE6ZkVipNEmZOOCJK7oEWiiWehN+lX2sM1qEwA9DXsSKhTuE1LUi4aLKQdXbV87PxhVPF8+I2skHZbqo++ze+yJe+uq9yGNTZ5Hykm+MBfXbTTrhB85LFQQ4NlGHuw4JK3XL5KZF1l/6QGNmwZ+HqBZZ3JAY0h9wgOn89hsYfyrjq+PAbNU0xOdNYg5G2TET2N4VruJUc1vN1cA+q1tHu8t0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(8936002)(2906002)(66946007)(66476007)(31686004)(66556008)(83380400001)(36756003)(508600001)(8676002)(4326008)(38100700002)(54906003)(316002)(53546011)(31696002)(86362001)(5660300002)(7416002)(186003)(26005)(2616005)(6512007)(6916009)(6506007)(6666004)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWhvRHNFZkY4c0hTQTNORVBWT3UvcDRLU20xTUM1ZmQxaU5pdjA4ZndNbGRr?=
 =?utf-8?B?ZFdsNmhKdWFkVkh5ckZ4czdLaEJ1cThmTU5EVzRGMUdVOFB2M1pFditURXUr?=
 =?utf-8?B?cElpY1NqT2wyaHNaWHI1SkVaMEpiZW9lampqMkE5eFdYMEx2U1hyQ0kwQTZT?=
 =?utf-8?B?TXV5eGlCVzlKMjdJYVhLRXIza21WdUE5RTI0d012ZktaS2hZd0xrMUsxa1VQ?=
 =?utf-8?B?azc3bFhrRFFhYVd5ZUNjaHp4TTlSSVowakhrR29tWVVJcG16YVNwK0d0YkRM?=
 =?utf-8?B?L0FPclJaSDhReWgxNmZIc2JyUGM0elNjdmg1Y1ROanpWMmdZZ1VXQk8wS3dW?=
 =?utf-8?B?L3B5QkxjbWFYU04zcXNCL0ZqQldsSHVlNGNxUWxxd1hQQUNtbFBmZXhXR29V?=
 =?utf-8?B?TU1wMnR6SmZNSzk0Z1B4a1BVOEZzRU5WR0xkS2J4WmxiS0pFWEU0QzFzNU4y?=
 =?utf-8?B?ZlM1NFh3WEtDVXY4cW04b3VYYWwwb1ptcEE1Z2xybWZ5cmMxL2FVcG5ya1FD?=
 =?utf-8?B?Yk9wWGQ5REEwcXJNM3RYbTVvY0orREdORU02NXh3YXVJOVExeVl0Wi9WQndr?=
 =?utf-8?B?dmJwRmlrZHZKTFhjeVJvUGI5WmVrc3E0Yi8rOFlpejVzbWZrbTRYbXVrSThs?=
 =?utf-8?B?OTUyZkxxbkNUTEFjb1NxU00yTkgzNGlOYmJIS3pST1Q1TFcyMnYyNVFNU3pW?=
 =?utf-8?B?TDEyMFV4bGdkWEg0dWJ3cy9QbExqczV3R3NmbXRqWWF6T0dMMHdRU1o0TXBv?=
 =?utf-8?B?TFU2TThXb3M1RVlSV0pHZkEyaUsxQXQrREJYdkVoMnBQczNJNTRhVE5ueE54?=
 =?utf-8?B?ZDJUcGVJeFo2YlRybkpkUWQraldBeVVEYTJyS1plVURnWUUxQUZ5VkpLMFBP?=
 =?utf-8?B?a2MrUlUwNER0WWF1QnJFWldJclRidzZnbU5BdXViM2IzeXU0UEdoU1Z4UjJZ?=
 =?utf-8?B?N1JnTG4zb1lkSGFGZVdNT3g3K0dnekI4cWNaekRFSWZmQ2dJNmI1eVBISzJO?=
 =?utf-8?B?SmlrTFpzY3F1eGZCVVE2WGNKNnpENUQzSXYzcWpnQ2wxamkzeUtEQVE5WU9G?=
 =?utf-8?B?WXBXMEJBRDNZL3FqdHhnU3pjSURWbEVYTUNNN0R1Q2FXaWI1MUhzbDkrSkhO?=
 =?utf-8?B?OU1QU2Y0SldQRjd2M3YyMEphOE9oMVl0eHZmb0grak5la0xObkVkeDB0ekRm?=
 =?utf-8?B?cEJUVUtwYm5Cc2hVelYyM2FpT2RpSFE3US9nWHh4K3QyUXZOSmpWcGYwSGhy?=
 =?utf-8?B?ZW8xNDNCZGcwNXVROGJ6RmRkZ3lIYUZZNlBvZVp4a0ZwNkc5UW91dTBSUmJL?=
 =?utf-8?B?cklUZzR4WHVEcnZXSFBKeEZ3Z0lUZFVaMGEwNlBSQWovMVN3YnNRMC9EbE5Q?=
 =?utf-8?B?YTFHS1hVMEwvL3paM3JFRzFVa0RMY0xkei9VYW1pbEgvVE5pRWFoTjRtZk5L?=
 =?utf-8?B?S2NpcTlETjJnRkVoWSt6SEY2RllIbDE0WGVaU0N3UzJlLzIzL3RKdEtIYWdY?=
 =?utf-8?B?OHhZSnovYmdLMVV1cmFLV3Z0TXI3NTdLcEs2ODQveGQyQzE3RkEzNkQwQkRT?=
 =?utf-8?B?dC9MeVk0ZUJKNWdnT2M1U0RoR0RJOEhYQlpwMThwNDJCV0wzNU94ekRYQUJa?=
 =?utf-8?B?QzVMblp5d0IyRThTMVJmaUQwelNJN0pBRjhWdEhWZWFRczAzSEJSWjczVjV5?=
 =?utf-8?B?bGJBMFJabUcvcGlaQTdhMVkrNjA3VEh2RERSN2dKY2YwaXZaaGdDa3cyMlNv?=
 =?utf-8?B?Z3ZIcExKQlQ3TDI5cys1aGRrTFViOFpuUlBxaitEMTlocEtwTWZoc3dFdk13?=
 =?utf-8?B?cjExZUg3NWdMaWhyMDM5TGJCbHdyaE5NN2ZHdTFtcFBwQktydm10cmtYbk5L?=
 =?utf-8?B?OXZxdkErZVNMOE9EaWNkV25SSUNSalJhMFFIQlQ5NVBHNGw1TmpKZ3hsaU4y?=
 =?utf-8?B?NGMzenl1NHVpbDRBcnUrRC9tZkg4VDI2aEVFbHh1bFNiWEZqalFUR0g3SWE0?=
 =?utf-8?B?eVVPM0Q4b1lnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d85960-c515-41f2-f782-08da09026f57
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:12:09.1310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uve4XOh7eDrV1/8RzbO5xnKYyERGxlUv8MobEFpmFnJP9AnxUBa2mQaBraIUQcKxaCUKSP0GPWsv0S1ygk7dKFixuI3yWZUA0QWCvdghRX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3241
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10290 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203180091
X-Proofpoint-ORIG-GUID: IbmJofV6S1zrtWMbTmOnYlttZUCnljzm
X-Proofpoint-GUID: IbmJofV6S1zrtWMbTmOnYlttZUCnljzm
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/22 20:37, Joao Martins wrote:
> On 3/16/22 16:36, Joao Martins wrote:
>> On 3/15/22 19:29, Jason Gunthorpe wrote:
>>> On Fri, Mar 11, 2022 at 01:51:32PM +0000, Joao Martins wrote:
>>>> On 2/28/22 13:01, Joao Martins wrote:
>>>>> On 2/25/22 20:44, Jason Gunthorpe wrote:
>>>>>> On Fri, Feb 25, 2022 at 07:18:37PM +0000, Joao Martins wrote:
>>>>>>> On 2/23/22 01:03, Jason Gunthorpe wrote:
>>>>>>>> On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
>>>>>> Questions I have:
>>>>>>  - Do we need ranges for some reason? You mentioned ARM SMMU wants
>>>>>>    ranges? how/what/why?
>>>>>>
> 
> An amend here.
> 
> Sigh, ARM turns out is slightly more unique compared to x86. As I am re-reviewing
> the ARM side. Apparently you have two controls: one is a 'feature bit'
> just like x86 and another is a modifier (arm-only).
> 
> The Context descriptor (CD) equivalent to AMD DTEs or Intel context descriptor
> equivalent for second-level. That's the top-level enabler to actually a *second*
> modifier bit per-PTE (or per-TTD for more accurate terminology) which is the so
> called DBM (dirty-bit-modifier). The latter when set, changes the meaning of
> read/write access-flags of the PTE AP[2].
> 
> If you have CD.HD enabled (aka HTTU is enabled) *and* PTE.DBM set, then a
> transition in the SMMU from "writable Clean" to "written" means that the the
> access bits go from "read-only" (AP[2] = 1) to "read/write" (AP[2] = 0)
> if-and-only-if PTE.DBM = 1 (and does not generate a permission IO page fault
> like it normally would be with DBM = 0). Same thing for stage-2, except that
> the access-bits are reversed (S2AP[1] is set when "written" and it's cleared
> when it's "writable" (when DBM is also set).
> 
> Now you could say that this allows you to control on a per-range basis.
> Gah, no, more like a per-PTE basis is more accurate.
> 
> And in practice I suppose that means that dynamically switching on/off SMMU
> dirty-tracking *dynamically* means not only setting CD.HD but also walking the
> page tables, and atomically setting/clearing both the DBM and AP[2].
> 
> References:
> 
> DDI0487H, Table D5-30 Data access permissions
> SMMU 3.2 spec, 3.13.3 Dirty flag hardware update

I updated my branch and added an SMMUv3 implementation of the whole thing (slightly based
on the past work) and adjusted the 'set tracking' structure to cover this slightly
different h/w construct above. At the high-level we have 'set_dirty_tracking_range' API,
which is internal in iommufd obviously. The UAPI won't change ofc.

It's only compile-tested sadly as I have no SMMUv3.2 hardware, and to have this SMMUv3
DBM/HTTU support there's some requirements on the processor that I am not sure they can be
fully emulated. The Intel iommu implementation follows same model as AMD and I will get to
that next with a compliant iommu emulation too.

But now, I will be focusing on hw_pagetable UAPI part. I understand your thinking of being
tied to the hw_pagetable obj as opposed to IOAS for the dirty tracking APIs.
