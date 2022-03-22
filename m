Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF554E3BE6
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 10:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiCVJsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 05:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiCVJso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 05:48:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F2F6A42E;
        Tue, 22 Mar 2022 02:47:16 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22M7Hnvh011681;
        Tue, 22 Mar 2022 09:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6HA61SuPbk8P14Wkez1OPWu3UxdF0zlTk7SclWxgXxs=;
 b=sOt11pgxRlTz8BdhPAtAj0QVd4yAxs7kFn1HP0Xnt7w/FLBTcQE6/nsRKliNX9Loh1cp
 jSfV4t4lkM6FJw9dCd5OESy8tfNsDQpvhFJg/GsCjjm9PEUZHnhy+kj9R6d6JenqD+RP
 J0NNbKdELcnfGILQXRiN9xRpBapT5I+1byqQC8zQWyQ6DmT2bW2kL4FoO6h8a83f+KWX
 0JIP3GwHOiZ+qWKlD5weOHMiAlJZ/BKmysDDXdWp3RjPEL0fXr/m/vWBjQfz5w2kZtdM
 tzUaTORHL61TCTabmDk8QXjRxUHrhb/qVWBvRcCUXDMymSpls0i8AkrQvzjOXzg2qUGw nw== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss5tch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 09:46:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22M9klrS053299;
        Tue, 22 Mar 2022 09:46:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3ew578u7d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 09:46:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVGMpGxMFm03NW5R+Cp4FaScvidgYB7ukud05H8xEQCZ6tlCqfmzzYr2xMyZMinX3Iyh1xhQ6rpL8AJgsxJa0Pj4YspwlHG2uQS5UwWEHTR26/Vc0c/2kdrsZE0dzf5x/N2uYumhe+gFR0eX/Rjs43jMHJ+UxP8ImoY0TRBLMdWvDhgZS0+cMhWPpWE4Huzm/5DYuGrGmCi2EFIMCCsDbuOxjms6Gmb458bUHsQWbGnIdz6MIlwEeLRUiGqItBjhxiCnQ7N+NRfEaCze8o+WaU03rGfbCpLkeL8wL8MJxPBP92y/rJtuzY6bkY4wyoOZjhH3K8wbqjvWNA9Rk7Cbcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HA61SuPbk8P14Wkez1OPWu3UxdF0zlTk7SclWxgXxs=;
 b=JJIiWk10hyC0TbLcVqtwIeR5ZW2wXbekSeP4rw+H4dzmmu5hsDz3wnHjgmpegTYblKZd4+mciD8jaDt0qklPF6knBp7YpKfFy0j+dSuJ+KSFb+DcAsnZVGekvJ2YFY5zR+cbyLFGMh26kqGKwFtCRnlF/xskLPcboYsJy3yu3puN7J/yTdFKI/DzFvHHsdNMCVM3yL+1aDk8MPPO2SKTvntxvkaZQBVRW37MQFSmcjhkSZPu8JEUiIdcNqUI9HMXwk496UfyniMua7b9UuQwte9NACxGTBvO1E0BtTFAL9HnEpPrjEd6mJrHuayneEv1ZLTApKF5eK9BGSZVFNW55w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HA61SuPbk8P14Wkez1OPWu3UxdF0zlTk7SclWxgXxs=;
 b=xpCkm96/Z+R+/ds8UuTDjgzkTRxtBWuCSJAVPXqdmR1+lNUX46T9DL/h+eQ3mH2tuGIS2u25TG+2FKgMpd86nqMO06+/CIy6rL3k9ecj0yL5WRFre5IH0rBPXg2HJyPib8IHGxC+RCdwb/tVuAS64m+IL+/MtDlW69RmSd2QlzA=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by SN6PR10MB3005.namprd10.prod.outlook.com (2603:10b6:805:cc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Tue, 22 Mar
 2022 09:46:43 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::3966:22c2:dc6a:957f]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::3966:22c2:dc6a:957f%6]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 09:46:43 +0000
Message-ID: <c3131f1c-a354-ca3b-ed61-5b06ef1ab7a1@oracle.com>
Date:   Tue, 22 Mar 2022 10:46:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 00/47] Address Space Isolation for KVM
Content-Language: en-US
To:     Junaid Shahid <junaids@google.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
References: <20220223052223.1202152-1-junaids@google.com>
 <91dd5f0a-61da-074d-42ed-bf0886f617d9@oracle.com>
 <a37bb4b7-3772-4579-a4e6-d27fb29411a6@google.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
In-Reply-To: <a37bb4b7-3772-4579-a4e6-d27fb29411a6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0055.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::19) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e7d3be7-19af-4d78-4350-08da0be8df24
X-MS-TrafficTypeDiagnostic: SN6PR10MB3005:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3005F6F5F2CD02087856A6FF9A179@SN6PR10MB3005.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SkO5IVE1ek4t2Kfx/fVNCMhW4mycDCxxeTfUDEMATUzfliFwi6DcqaKcchzwGHkIibWcOelwqwnWU1CMnVoobRjgsdViSYKTVqYFIiVIT0aW3P4gVjRgB/P5qU/L0s5iohis/pDlt6DRGsaJpQsdU6qRIxg7lGHot1yLPeUjfV424MQYfS9gzsad28qScRvEo0bVR3yLkwQZ8OirMHy1+u210P3NGv/wLJ1lfN+Cf/ALJwOIB4O9XhEbyq17ms9l92c5oO+bteBb57+nCkeZZbBsHEkIn0q8WK5cqp9PcTfPrREKiShBiktp+/TvEVavfLzXb9CqB+bJpQdV4WQfbpr3mp+GjlZJa1YQJrMjNmRMQe6PnODrgIer+2BOqlLFXuG0FjAEf8QStUO/sdkPV8kiuwzUzejdEf9KlmuMcojn9L/uxCSk8tewFHL+wFHVfAq2jAwHQDa/jJVppiC3f4K+cY5MSIe5YIq4atJfcO/xOOv7DxzExesHTVtQ6r2S+DpM/Er6h6882HCGYB7F+sc3YNJOezJ4B4j+ZxnEBolTDDIBcaqqcw++DOCgjWZnnKeujEuAUFHEXuWCpq0WNhLX2UWXFzgQEHQZgT+pvEyLVoi9+2NDbUMxScwej/6/D6Ir18O67sYNY5usZ+0Ofg5pwV7h0s6qHQH/9jgJOiIC1I5yZEngW0mB2aw5NjFTdoI1mp8C6rnYnUjJN0DwxAfi3FXS7n/FzumDfghKah33VNkkOg10QfcZLfONpzwDWXV0nU48CwrJvs0V0eUE/UQkXbQ+eWrZO2S9lYoKhBiNHjMv8MXTWUOwBysOMfyGfdLgbwoPHPZjrlGiU9+ktg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(36756003)(38100700002)(31686004)(508600001)(53546011)(66556008)(66946007)(6512007)(66476007)(6666004)(8936002)(6506007)(6486002)(966005)(44832011)(83380400001)(316002)(2616005)(186003)(26005)(30864003)(8676002)(5660300002)(4326008)(7416002)(31696002)(86362001)(69594002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXRsQlN5K0lMVnY3RlNkYnlFQXdwaEJsT2VTSzdMMmRBSVlmMTdqUkUwMnBI?=
 =?utf-8?B?eXR0clpoZEJ4N0VXNXR2NlNqQ0svL1Q2K0thdFN2OUJubG1rdnV2MTV1RnFv?=
 =?utf-8?B?WkVWWkJZa1JxMkpwTFg3dzE4OElNNGFIeExacitFaEI1aEVxU1VySUZpdE1i?=
 =?utf-8?B?MnJqdi8yQ2dUV1llUWNiMUZ1TFNGWnZ3RnBoaUdnbTNkV0hXZWozbFV5anZS?=
 =?utf-8?B?WDZQUUlsUVlDSVRUdk5lYmVQZk95S1p6c0hoVTZGS2luOVFmMnVGcVhkWjRp?=
 =?utf-8?B?R0k4U1dDdzF2ZHQ3ZUhyMWNYZEJvKzNKcFkrZ2gyZTVUYUtoQWZCYkFSODZY?=
 =?utf-8?B?Nmk3N1h3Wkdub0Nwa0dLalhnaGRSNUJKV1dpclRPTFJQRzYxYm5IR1gzdzlx?=
 =?utf-8?B?NHAwTmxXcUJ2NGNSOFFrZGZGM0tVU3pNaDI4Smdua3NKOEJZaVJhK01iTW42?=
 =?utf-8?B?ZFhTcUlrUHM3ZVJFQk5aN0NQdEFGQzdIMjNTRDNlZU5VYjE3WjNCVUgxbEZt?=
 =?utf-8?B?NSswYi83YTQ0WEsycmFKMnVIOUo4eFRIdkRrMmhsZ2FlM3A2MTVaQ0YzQW5P?=
 =?utf-8?B?Yll6MU5yelc5YXR3K29qdXFmWndnemRUaTRWeXFPTlc2MWZpU1hxNVJjblYy?=
 =?utf-8?B?WXB6MXV4a1FKOXpmbWtVRHhTV3U1d0o1elpiaXhkcjh4MlQzMFNlRzJiTlRU?=
 =?utf-8?B?SitxdW15NXZLSGxIWmZBUFRzckhHTUVNak9PcnNZamt4S3U0VlczZFk1VkZN?=
 =?utf-8?B?R3kxSVppTHU3d0tZcnhYUXJseXQxRDNKa3ZXQlB4d2x4YTdPWUdzMnEzenJp?=
 =?utf-8?B?c0FYdnd0KzFYdXJWU0VrQ2wzUkpPOE5zeGxyM0o3RldhbmRJRWQvbnVWZTB4?=
 =?utf-8?B?ZXkvaXJOWThNb28zVDVwTGl6QmZtSnVmZ09iRHl6QndLamRoQlBlNko0ZzVp?=
 =?utf-8?B?QUtYUkEyUVJpMDZNNStxV1lyS25WaGNQZStHV2FIdUxBK2x0cFptRE9aS2kz?=
 =?utf-8?B?enJ4QUNnd0YwaG9uSkp6QWI0RTVhZ25HQ3J4UUxMTDVYS1gxVjJONzB2Ny9v?=
 =?utf-8?B?UTcvRmlZVzF2cGxLM0hVaE42Z0VrTnBSbmg2UnVtZFRhalpHQWhPdmkxTllE?=
 =?utf-8?B?RXVoWE5saWxLYXIrVzNQY2s2Qm80WWt0TTZoSHkvOENBdmxqYnpja3JOd01G?=
 =?utf-8?B?Wmx2OUx2QlAzYWVRWm5US09NdDFweGdKMXlQZG01M2pEcm53M2RaWVdFVVp1?=
 =?utf-8?B?NWlUbklvM2dOWFp2N1NNNk9LK0IyNi8rbFR2ZEt0ek1QQUYvb3ZENGtZSXJC?=
 =?utf-8?B?ZUFjbFpLR1RHT0w2dHRhb2NJUnlNK3BHWVFodklSZ0gxOVhOa1J6OVdPcTYx?=
 =?utf-8?B?UXlHaWluWHdrWjBPcFVDNVV1d2hsNFlvaE5Ncnd5RWhPRmk3WEJOZ1MwZlg2?=
 =?utf-8?B?SWVCV3RJa1c5cFgrWjNRVHN4RGYrNnRnWUpkVGg5MmswY3dGRHYrcEJNSS9s?=
 =?utf-8?B?WkNScEN6bjNxQ2o3RVdmaUEvMXJuOGZ1RDhONlYwM3FuNllzYzBtbGh2ZXdh?=
 =?utf-8?B?enYvbnlPRzZaem5TR3JYSVFNZjhRaXpISFdXMC9CclRsSUh1WUJ3SkVsU0U0?=
 =?utf-8?B?ZGE5OUd4c0txWnFYZDhFUW5CQmtwZjlUMGMrOUdSUk91QW90TjVQVEp6Q3c1?=
 =?utf-8?B?TVNmZlE3Mnc0Sk82OTFhR2RCZ2hmVldlbWFwVTB2akw0d3lZQlh2eEIvMzZX?=
 =?utf-8?B?dHg5NE5JRk4xYjJUUVIwMkVUb3hhWjhIMGRXQ0RWQ2crSmxDSXhYeExYNXQv?=
 =?utf-8?B?R0FGVXhMajVldFFtSUxYVk9KWXFZbTNNOVNndXEwK05keSt2UFdrN1VLbXpj?=
 =?utf-8?B?WjhxeVU0TXdtT0RqaDduclpNVWhzNWhFTkNEaGYvVEVmb1hiNmw5SHdnNGVs?=
 =?utf-8?B?TDJLWFV6Ym9qRXJiSW5velR1cy9sbnAvTzh0WTJzLzYydHpZWTVwd2RCRWFk?=
 =?utf-8?B?ZDhTbDFjbTdBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e7d3be7-19af-4d78-4350-08da0be8df24
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 09:46:43.1922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+7Tf5n8MQAF7d6joT8gTCfnphFmSaNOWfNLaAecmdPI1AsSBijInAEnOfUrr8vpvY3Qxj6MqDpbJa6EEkopyo7ZlF4r4hP/QgyIcd6AtnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3005
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10293 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220059
X-Proofpoint-ORIG-GUID: bldipKsfiS9J9jl6aftyibkWSlwdh3gb
X-Proofpoint-GUID: bldipKsfiS9J9jl6aftyibkWSlwdh3gb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/18/22 00:25, Junaid Shahid wrote:
>> ASI Core
>> ========
>>
>> KPTI
>> ----
>> Implementing KPTI with ASI is possible but this is not straight forward.
>> This requires some special handling in particular in the assembly kernel
>> entry/exit code for syscall, interrupt and exception (see ASI RFC v4 [4]
>> as an example) because we are also switching privilege level in addition
>> of switching the pagetable. So this might be something to consider early
>> in your implementation to ensure it is effectively compatible with KPTI.
> 
> Yes, I will look in more detail into how to implement KPTI on top of
> this ASI implementation, but at least at a high level, it seems that
> it should work. Of course, the devil is always in the details :)
> 
>>
>> Going beyond KPTI (with a KPTI-next) and trying to execute most
>> syscalls/interrupts without switching to the full kernel address space
>> is more challenging, because it would require much more kernel mapping
>> in the user pagetable, and this would basically defeat the purpose of
>> KPTI. You can refer to discussions about the RFC to defer CR3 switch
>> to C code [7] which was an attempt to just reach the kernel entry C
>> code with a KPTI pagetable.
> 
> In principle, the ASI restricted address space would not contain any
> sensitive data, so having more mappings should be ok as long as they
> really are non-sensitive. Of course, it is possible that we may
> mistakenly think that some data is not sensitive and mark it as such,
> but in reality it really was sensitive in some way. In that sense, a
> strict KPTI is certainly a little more secure than the KPTI-Next that
> I mentioned, but KPTI-Next would also have lower performance overhead
> compared to the strict KPTI.
> 

Mappings are precisely the issue for KPTI-next. The RFC I submitted show
that going beyond KPTI might require to map data which could be deemed
sensitive. Also they are extra complications that make it difficult to reach
C code with a KPTI page-table. This was discussed in v2 of the "Defer CR3
switch to C code" RFC:
https://lore.kernel.org/all/20201116144757.1920077-1-alexandre.chartre@oracle.com/


>>
>> Interrupts/Exceptions
>> ---------------------
>> As long as interrupts/exceptions are not expected to be processed with
>> ASI, it is probably better to explicitly exit ASI before processing an
>> interrupt/exception, otherwise you will have an extra overhead on each
>> interrupt/exception to take a page fault and then exit ASI.
> 
> I agree that for those interrupts/exceptions that will need to access
> sensitive data, it is better to do an explicit ASI Exit at the start.
> But it is probably possible for many interrupts to be handled without
> needing to access sensitive data, in which case, it would be better
> to avoid the ASI Exit.
> 
>>
>> This is particularily true if you have want to have KPTI use ASI, and
>> in that case the ASI exit will need to be done early in the interrupt
>> and exception assembly entry code.
>>
>> ASI Hooks
>> ---------
>> ASI hooks are certainly a good idea to perform specific actions on ASI
>> enter or exit. However, I am not sure they are appropriate places for cpus
>> stunning with KVM-ASI. That's because cpus stunning doesn't need to be
>> done precisely when entering and exiting ASI, and it probably shouldn't be
>> done there: it should be done right before VMEnter and right after VMExit
>> (see below).
>>
> 
> I believe that performing sibling CPU stunning right after VM Exit
> will negate most of the performance advantage of ASI. I think that it
> is feasible to do the stunning on ASI Exit. Please see below for how
> we handle the problem that you have mentioned.
> 

Right, I was confused by what you exactly meant by cpu stun/unstun but
I think it's now clearer with your explanation below.


> 
>> Sibling CPUs Synchronization
>> ============================
>> KVM-ASI requires the synchronization of sibling CPUs from the same CPU
>> core so that when a VM is running then sibling CPUs are running with the
>> ASI associated with this VM (or an ASI compatible with the VM, depending
>> on how ASI is defined). That way the VM can only spy on data from ASI
>> and won't be able to access any sensitive data.
>>
>> So, right before entering a VM, KVM should ensures that sibling CPUs are
>> using ASI. If a sibling CPU is not using ASI then KVM can either wait for
>> that sibling to run ASI, or force it to use ASI (or to become idle).
>> This behavior should be enforced as long as any sibling is running the
>> VM. When all siblings are not running the VM then other siblings can run
>> any code (using ASI or not).
>>
>> I would be interesting to see the code you use to achieve this, because
>> I don't get how this is achieved from the description of your sibling
>> hyperthread stun and unstun mechanism.
>>
>> Note that this synchronization is critical for ASI to work, in particular
>> when entering the VM, we need to be absolutely sure that sibling CPUs are
>> effectively using ASI. The core scheduling sibling stunning code you
>> referenced [6] uses a mechanism which is fine for userspace synchronization
>> (the delivery of the IPI forces the sibling to immediately enter the kernel)
>> but this won't work for ASI as the delivery of the IPI won't guarantee that
>> the sibling as enter ASI yet. I did some experiments that show that data
>> will leak if siblings are not perfectly synchronized.
> 
> I agree that it is not secure to run one sibling in the unrestricted
> kernel address space while the other sibling is running in an ASI
> restricted address space, without doing a cache flush before
> re-entering the VM. However, I think that avoiding this situation
> does not require doing a sibling stun operation immediately after VM
> Exit. The way we avoid it is as follows.
> 
> First, we always use ASI in conjunction with core scheduling. This
> means that if HT0 is running a VCPU thread, then HT1 will be running
> either a VCPU thread of the same VM or the Idle thread. If it is
> running a VCPU thread, then if/when that thread takes a VM Exit, it
> will also be running in the same ASI restricted address space. For
> the idle thread, we have created another ASI Class, called Idle-ASI,
> which maps only globally non-sensitive kernel memory. The idle loop
> enters this ASI address space.
> 
> This means that when HT0 does a VM Exit, HT1 will either be running
> the guest code of a VCPU of the same VM, or it will be running kernel
> code in either a KVM-ASI or the Idle-ASI address space. (If HT1 is
> already running in the full kernel address space, that would imply
> that it had previously done an ASI Exit, which would have triggered a
> stun_sibling, which would have already caused HT0 to exit the VM and
> wait in the kernel).

Note that using core scheduling (or not) is a detail, what is important
is whether HT are running with ASI or not. Running core scheduling will
just improve chances to have all siblings run ASI at the same time
and so improve ASI performances.


> If HT1 now does an ASI Exit, that will trigger the stun_sibling()
> operation in its pre_asi_exit() handler, which will set the state of
> the core/HT0 to Stunned (and possibly send an IPI too, though that
> will be ignored if HT0 was already in kernel mode). Now when HT0
> tries to re-enter the VM, since its state is set to Stunned, it will
> just wait in a loop until HT1 does an unstun_sibling() operation,
> which it will do in its post_asi_enter handler the next time it does
> an ASI Enter (which would be either just before VM Enter if it was
> KVM-ASI, or in the next iteration of the idle loop if it was
> Idle-ASI). In either case, HT1's post_asi_enter() handler would also
> do a flush_sensitive_cpu_state operation before the unstun_sibling(),
> so when HT0 gets out of its wait-loop and does a VM Enter, there will
> not be any sensitive state left.
> 
> One thing that probably was not clear from the patch, is that the
> stun state check and wait-loop is still always executed before VM
> Enter, even if no ASI Exit happened in that execution.
> 

So if I understand correctly, you have following sequence:

0 - Initially state is set to "stunned" for all cpus (i.e. a cpu should
     wait before VMEnter)

1 - After ASI Enter: Set sibling state to "unstunned" (i.e. sibling can
     do VMEnter)

2 - Before VMEnter : wait while my state is "stunned"

3 - Before ASI Exit : Set sibling state to "stunned" (i.e. sibling should
     wait before VMEnter)

I have tried this kind of implementation, and the problem is with step 2
(wait while my state is "stunned"); how do you wait exactly? You can't
just do an active wait otherwise you have all kind of problems (depending
if you have interrupts enabled or not) especially as you don't know how
long you have to wait for (this depends on what the other cpu is doing).

That's why I have been dissociating ASI and cpu stunning (and eventually
move to only do kernel core scheduling). Basically I replaced step 2 by
a call to the scheduler to select threads using ASI on all siblings (or
run something else if there's higher priority threads to run) which means
enabling kernel core scheduling at this point.

>>
>> A Possible Alternative to ASI?
>> =============================
>> ASI prevents access to sensitive data by unmapping them. On the other
>> hand, the KVM code somewhat already identifies access to sensitive data
>> as part of the L1TF/MDS mitigation, and when KVM is about to access
>> sensitive data then it sets l1tf_flush_l1d to true (so that L1D gets
>> flushed before VMEnter).
>>
>> With KVM knowing when it accesses sensitive data, I think we can provide
>> the same mitigation as ASI by simply allowing KVM code which doesn't
>> access sensitive data to be run concurrently with a VM. This can be done
>> by tagging the kernel thread when it enters KVM code which doesn't
>> access sensitive data, and untagging the thread right before it accesses
>> sensitive data. And when KVM is about to do a VMEnter then we synchronize
>> siblings CPUs so that they run threads with the same tag. Sounds familar?
>> Yes, because that's similar to core scheduling but inside the kernel
>> (let's call it "kernel core scheduling").
>>
>> I think the benefit of this approach would be that it should be much
>> simpler to implement and less invasive than ASI, and it doesn't preclude
>> to later do ASI: ASI can be done in addition and provide an extra level
>> of mitigation in case some sensitive is still accessed by KVM. Also it
>> would provide the critical sibling CPU synchronization mechanism that
>> we also need with ASI.
>>
>> I did some prototyping to implement this kernel core scheduling a while
>> ago (and then get diverted on other stuff) but so far performances have
>> been abyssal especially when doing a strict synchronization between
>> sibling CPUs. I am planning go back and do more investigations when I
>> have cycles but probably not that soon.
>>
> 
> This also seems like an interesting approach. It does have some
> different trade-offs compared to ASI. First, there is the trade-off
> between a blacklist vs. whitelist approach. Secondly, ASI has a more
> structured approach based on the sensitivity of the data itself,
> instead of having to audit every new code path to verify whether or
> not it can potentially access any sensitive data. On the other hand,
> as you point out, this approach is much simpler than ASI, which is
> certainly a plus.

I think the main benefit is that it provides a mechanism for running
specific kernel threads together on sibling cpus independently of ASI.
So it will be easier to implement (you don't need ASI) and to test.

Then, once this mechanism has proven to work (and to be efficient),
you can have KVM ASI use it.

alex.

