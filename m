Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565285E6A6F
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiIVSKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiIVSKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:10:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24728A98CE;
        Thu, 22 Sep 2022 11:10:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MH4RiI002476;
        Thu, 22 Sep 2022 18:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HLOGxFUDUbH4h83AhjvC0ySutBhn9eznzwbUG7sdflU=;
 b=Gp2u+rdPAEWVOP+vnchowQKqx1DyaPtKNJ91TUSGY5FrWzKyl0JqV+taQ6ey4Z9JjufD
 6O1s3dVDebHhBIA+MTnbdBa3sz1bDl6gvgy7owlBin/UEkG8sPt5+m4Re4S2RpcH+Zg4
 CX33dOgv/45RRCp4hw/wUovbd8AJUfI/ZdIthUJ7LVf4YY22wdMzmHNgt6YHqJ1lV7cK
 8BCX1lx2GRUeXF3qvVLtLrfzlWaGJ18Z2a2QLL0zLiZ5BUFs3RWSB7hQiOiDd5jhhErx
 /AYNrX5ihaX4RZLwQWynXybK6gSyV0CBVuacUtlltDSE5iiVwwgUj0ZRbJsXwxbPkif5 Kw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688ns4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 18:10:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28MGE8Av031333;
        Thu, 22 Sep 2022 18:10:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39nwutj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 18:10:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXX33YaEuh2SspdiRTBfzUhgPGLksvwgMLzlc7SVKTvp7lCz5ohYAy0wh6GNDpYU88zXwkCuq7bPNqTlmRmuoVpJ6KTCpPvqCFxFtzDiowqSWihHheA3lK9C3GyRkdl4IaZVOiOsEiLl2FjM+NTnDQcN3mQJpjmmjGaRpYGVSNkxJJVBxe2G3qSm5ClyMsxuu9ORfPhL4shIrtX7UytIvYka34WvHlYjLcqo0Wrom90/h4eeP/lTXrWxZdhc97ZfjS4pfvEfQ1B/TAfkEuQubGBm/2WmX+kXrr+X/vtP7B7TSx7yRffKoo+Iti+56tjEfkkDmr0UxIQOgd51vssyJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLOGxFUDUbH4h83AhjvC0ySutBhn9eznzwbUG7sdflU=;
 b=cV0qkpmVVIaZDtcyPkISj+NqzhgCy4J2vlda/ptUY1AxWupfETl/BYxwzqQafxIMWxeS8HjDXCqzg4qop47AYizL6G+pBLAwyp00Pp8+MnEoH9TKb1BsxHkQqXhSb1Hih8u/qCkSpYn7O2DsjDHnCwfar1GpcAmxuD/J8DNfZyep2RGqw5RrnDvdO7LAPrcdBQuH9ctUJJWtypdeyq33b3CXuJho2ZlRosXjigQokDGqtp2iciR+skrHOzazMhFaK6QeFK2cldb6PBo287NkO7k5XbLonKZqho8vzO5N/FmXlLqPRzvQTnT0LlNjC+0XgusR646rUUpT6ELzT8l3YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLOGxFUDUbH4h83AhjvC0ySutBhn9eznzwbUG7sdflU=;
 b=FX8dq8wFlv1ih1YJlxS1BKpRBRJSRdv+bQ+tHpOrIw7DgOj/gPh/s/r7WkpKgoMHLzLr2kF/LDt46skyP7QnvDi7xdDuMPo01BgNchTKWt2cAQ3C/GG7ecR+ttMzih7Djh2Opwsn2T9MhBrqqIP0dD22Wnb3qN1TAZrNZbuOP0o=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB4252.namprd10.prod.outlook.com (2603:10b6:5:215::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 18:10:13 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::36d2:a229:987:a748]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::36d2:a229:987:a748%5]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 18:10:13 +0000
Subject: Re: [PATCH RFC 1/1] perf stat: do not fatal if the leader is errored
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, joe.jin@oracle.com,
        linux-perf-users@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Bert Barbe <bert.barbe@oracle.com>
References: <20220922071017.17398-1-dongli.zhang@oracle.com>
 <ad2572d0-06b5-7250-31f2-a5efa1048cc0@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <d6ad12e0-3659-42c3-e913-3c9e4daa8ef8@oracle.com>
Date:   Thu, 22 Sep 2022 11:10:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <ad2572d0-06b5-7250-31f2-a5efa1048cc0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:8:2f::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DM6PR10MB4252:EE_
X-MS-Office365-Filtering-Correlation-Id: edad13bb-4443-4ef6-1251-08da9cc5b1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dp0mYEj2jfwz/P/F41EyBxwjmX7MNdL11yJRTaUNIV2KoC7bs2/yt4aDJVJ/JK9Q5IbH7A4QHxZU30uR1IkmRoIK+L/suWyrObk7qTEFBcqGixNzu1tss0Hf93wsd6AtHOliBD+8AS9jt6imz/OXvVKzBJDxgh1b0cxNWNn9tFoqXCWgNjINsprfxyX3prIb76JhUQjZ4GB+jZ+1mGCvoyrtJJmUD9Go27IYM2NHL0vU1dh411qvBuJbLjziwaru2XSvaKjXL+EVXvdaX4CMOsMqWbXqrAaJz9xgSBZiPHcXcXdyNdibjNcZqCOOp9W3znxEjWNzG1WPTlGuRteW3rNgqSyb74McB2lpnkghD+Gla/A+57LaHWJU6APQ076bTQPNpcRgtDAL0Qcj2Pfs2PsiU9uXrObw3fooeOrkP5adK5Z3RfflmkZ7MoHhC3JJtJjdrQcKfmcZ73wfDvTIhIDK8Vjce6toaplQCyJDwb1VFTCqDDq7VteGmkf5qX0wfcvZ5b8KJsCri9fg3AGXYcyYSQ1guiqnqRybC29YXD8lV0yhlkJN8Ar9IFEujVpqiWyhbZ8eC7xUXRruaInV142rODk9ghXQ/3IUkF6M1Ukw8NvUIZKkMYPes9SnZ3SnVCrhHlq5y1J3MbuRogSHALdKwxxwRhcg+gDA/Y51CSnXashqkCKMFLipVJi83gRAW/KMAoy8S4xWD/mdir6Da3B03O7EF0KJsGxHMCQBbtTKtmFKrG6Id4o0v+h+Lffno0GRORp8welqNjrrJs2ZXXsUX2XNZ8cKBPYz6ChOzEjHH0gT+t6x6AUDbetiy6Qwr1eUMzDfQK2Kzkh0ClXA3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199015)(7416002)(38100700002)(5660300002)(44832011)(8936002)(41300700001)(66476007)(8676002)(4326008)(66556008)(66946007)(2906002)(31696002)(86362001)(6916009)(316002)(53546011)(54906003)(107886003)(6666004)(6506007)(6512007)(478600001)(2616005)(6486002)(966005)(83380400001)(186003)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVdCU3ZRTW1ZUHVDb1NvbDBxQ3U1YjU4bThMQ0xzUjFqbnlhZkZoeEsxb2tG?=
 =?utf-8?B?elgvNUNQVnd0d0t3NHhGaTZId0JBdzkwOGJCMmhVRzRvWStzQUhIUFlEUkt6?=
 =?utf-8?B?cGdZakRWOFZaTWVQUjRMY3RZUkw3aW9DNjcvVkxhUENPMFJzYWpwMVNHVEo5?=
 =?utf-8?B?YnFKa2tWcVVUL20veHdtRUtTck5WMlZiM2tJM3RsTFJmQ01CVzhvV2x0UU82?=
 =?utf-8?B?NkcxUTFnSkd5Qk9YOXU2NjQxajJUbVd2SFhONXZzR3FkOHQ5TUFhZXpTR1pQ?=
 =?utf-8?B?TnhrVkFOaW1udVI5OHRiemZ1RFZtNEFwc3dPVHhUaVhZcVZwRkNCM01oaXhl?=
 =?utf-8?B?MlhqZldlamVxVGk4dy9UV2w4UEM3YnFJZnZ4QU5ZNGs1dnl0TTgwRDB5cVFz?=
 =?utf-8?B?VFN2L1ozNlZIV21sZTFrVGEyMHJ6b1l6c3BrVTlYSzB0WlNzR0h1R2hkK3B6?=
 =?utf-8?B?ejRrODdQVUp3VUNNbUxBbU1oZ0YyM3gxZVRnOXdKaWJPR2V0Y25IazFJN2F3?=
 =?utf-8?B?Mk55bm9HWVNETjRwMnF0LzFPa1pXQlh6NUJrd0Z0bXZWRks0SkV0SXFOMFVI?=
 =?utf-8?B?WUNRamowMnN3WVJyYlVTNGlxclZNSm5GWXpiVUNoeE1nR1k2ZjU4b25QMUF1?=
 =?utf-8?B?V0x1MXV2dEk5ZFI2dXlFQ3Y1cWZOZk1tWUV1aURVZkZmaUNTcm53eWV6cVJs?=
 =?utf-8?B?MXA3QmFLVThlU29kQTNUa3lsK05WbW91UVYyN0twOE44Vmw3Ni8zdE01T3dO?=
 =?utf-8?B?VTRRNHlqWXFwNENZYlNzWVVKd1YyMXRnQ2pDanFWTTFZWVZsaUNSVk1Vd2FJ?=
 =?utf-8?B?VUVXTHByUzlHUnRDWmFNRmh0RGU4UkhSSFJHa0V4YUVvZGNlM2ZlNG5kMmZm?=
 =?utf-8?B?V1l0M3BxTVdBVnp5UmplMGYyallGYzl2eVQxTGdkbWxDeTY2ZmNDcmF1elUw?=
 =?utf-8?B?NEJDY2IzVDlGQVJmUnRrNkt1Q081aTlDN2JnZVJlT1ErSmU5TnJGUTlOWGMv?=
 =?utf-8?B?SnBGOHVtWmhIUG14cHZYVEtXd0JrOTczWmRndmU1NTZEZUZyWVNmR1lSdW1F?=
 =?utf-8?B?VU1WSkU5NHdON1RhbHlmQVhOZ1RBa1pnMksyWFY5ZmZrVExGZ0ZIMkQwUnJ4?=
 =?utf-8?B?SVdJYnVuUlExRlFPSE5XVjROT1VKWTBVVzEybDhZYTF0NGJYODhobUZ6STYz?=
 =?utf-8?B?L0VTSEpyZTNVSGZycUZELy9LL2J2Z1dJV2puQklTU1hIbWZDL0wrSURsUTdo?=
 =?utf-8?B?WFQvZ0l2UFA1TDBudmJOY0JJaUJhakJXU3hMaWU4TU1uUm9MNmZEandXN2hm?=
 =?utf-8?B?TllJL1d1SXlsVlFEZXh6YytCY1hxTkFTd1dEK2t4VmxOYjVnYmZhRHBpTks0?=
 =?utf-8?B?QzRTYkhYcFBGdFBwTWxoU1lnUkxuRzlUbC85eWh1NGNNWTRDaEU3N3hBVThk?=
 =?utf-8?B?OUd6NHFBMDM1ck9QVmRkYmRPNGtnd0sxSTd6VXVpOG1SS3BsaVFGUytJam5K?=
 =?utf-8?B?NU54UmQxMkh2dmNiV0kxZGJOVWh1R2x4bzZPUFc0bm0wZnhsWmpDNGRBOEhz?=
 =?utf-8?B?aDBTcmJXdGF5RUQvZ0FkZzhTNi85TTJXa01WUzhKWXh5YmJuZjRqSUxHcTFU?=
 =?utf-8?B?UHh2elVCU1A5QmorMjZjbHF0d0prdDJkcTBDVnF0aE5xWFVtOUxnb0JrR0x0?=
 =?utf-8?B?VTRnRGcyUGZSL2pWODZVWHF2dFdXUy92eHRqeVp2T3lQZGE4aTJaTmlpejhi?=
 =?utf-8?B?N0hvdTJWTDR5NU5NU29pbTBNYkVtTXFCcGRjcGtKeFBNQjFYSjZsS01RVW82?=
 =?utf-8?B?MWlCVUhycjlUd3ZEM3FPbHREREwyYnkyK3ZiVHcvcXRyaDNqbWRiWVZXZkEw?=
 =?utf-8?B?RGxDWEdNRGpRbDByYlVEYi9jUVc2YUpJRys1YkZON3ErZHFWWTVXRXRjeTBC?=
 =?utf-8?B?QkJGWGNzZTUyOE10endkVHVoUGZOUGVBSzJXTXRSSmRzNUZBREhLVFBJcG9v?=
 =?utf-8?B?WnJ1Y0laVXZPV0dGZmJxT3FxM0gzMjltWWcydjlpT0JxNzEvcXEyRkZmd1Yw?=
 =?utf-8?B?bW9EM0I5UE1LZjMzdWdMbE9pZ0ZtN0pUeS9oVUxEdUtVRm9jYXlSWTk5dzk3?=
 =?utf-8?B?aFpTT1lTZEZxdzVBa2FWc1UzcHhObW9YckVPODlqZGFSMDFqRVprdjhuTWhy?=
 =?utf-8?Q?m8JGTd8xn8nDSEA0ktHup8c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edad13bb-4443-4ef6-1251-08da9cc5b1c4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 18:10:13.2347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yEnjW18MAxkr5MQJAZ6Wn49gQl+ffatVilQOaJIJwXIwtnmBiptzZ403FLe4T+zRQI5AN0k5Yy5G1KKLXV/8BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_12,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220119
X-Proofpoint-GUID: j7XHu6O3Vbc9mx1xZZUG22ng1eSSgUqU
X-Proofpoint-ORIG-GUID: j7XHu6O3Vbc9mx1xZZUG22ng1eSSgUqU
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/22/22 1:07 AM, Like Xu wrote:
> On 22/9/2022 3:10 pm, Dongli Zhang wrote:
>> There are three options to fix the issue.
>>
>> 1. Do not expose /sys/bus/event_source/devices/cpu/events/slots to
>> userspace so that pmu_have_event(pmu->name, "slots") returns false.
> 
> IMO, the guest PMU driver should be fixed
> since it misrepresents emulated hardware capabilities in terms of slots.
> 
>>
>> 2. Run cpuid at perf userspace and avoid using 'slots' if it is not
>> supported in cpuid.
>>
>> 3. Do not fatal perf if the leader is failed. Do not create events for an
>> evsel if its leader is already failed.
> 
> We may also need this since it's easier and more agile to update the perf tool
> than the kernel code or KVM emulated capabilities.

Thank you very much for the suggestion. I may remove the RFC and re-send the
patch for perf userspace.

BTW, I used to try your prior patch at KVM side (suggested by Bert) but it does
not help in this case. The VM kernel is already aware that 'slots' is not
supported by the hypervisor.

https://lore.kernel.org/lkml/20220106032118.34459-1-likexu@tencent.com/T/

Dongli Zhang

> 
>>
>> This RFC patch is with the 3rd option. Would you mind suggesting which
>> option is better?
