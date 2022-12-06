Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96390643D1A
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 07:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiLFGXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 01:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiLFGXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 01:23:12 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682A063CD
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 22:23:11 -0800 (PST)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B655aPt002084;
        Mon, 5 Dec 2022 22:22:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=/7QPIfgnpKn9R0gKxENjwS1dyvZZQej9CuJyqCguEkE=;
 b=cpYdpgeSS3egrHd19QdFQ+nwbGqoHni53Vmq5IkGDW2iRVF7QwGgQYh6OwEG0qG2SdX4
 CwMU+R8idQeuMf8V7uH46MXKWxbxhaiEdcmWhoKfHDulQG7KRL+YiwObOXq2+Xp+hNzf
 +IWZTSnY4kayiqYnLLegAW/KmW0e7ZSVsgpEhAxS+5dBj2WD3/VDpBuQ0XDlqPT395aB
 Z4ALS6Tdm+VDsDjjzalsQhkfOkMX3AdIYCgUBeUtko6K6Ncd7bWCWZIP7Ljz6C9qsFXl
 9NockOiT/jOeQyUYvbPSbyX3leXXtPBOqvlnM179qH6bUOFyoEt8m1bTXCDd40Jz0Blo ZA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3m85epwxbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 22:22:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WS5MTXZLGs47AvZEP0cpBV35sUi/OuMLSSrZQVY33j0u4aswQaztOCeesMfQp5GvGByqQm5CFMTwlMAPz3P9N/rwgCYbiCxWqhB1YWdrUjkx5/gUACv2IA4g3DVMeFMrgBkIEa8vgVrctDVEaxrjAQF0hPvLnLbYvvQayTp0wdHDvCc2IsQTyyS/wKT4HPG7VDUTISHSA98DikUH5tIy8REXCGG+UHFaVq9qzCdoeaQb+0nDh+zMvRamUugPsfxvccRla0SxViR9FuoiludmwW3f0FiaTsWTY12TjTl5E/mHJKR5wk3V9vDWtgWQK2CwhFPGYiknWMF2/Zj7EJT6ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7QPIfgnpKn9R0gKxENjwS1dyvZZQej9CuJyqCguEkE=;
 b=Ihh4ZEWgDPTRy46Jq3obsJY9EuhkXK7xvqHliGjqe4k6T9ugo7b7+uHQBkET1mNnahlaLppNJXRcUqCp0DUds+auNReHTrDctlF/zdEnUXkuspPB1D0ZFVD+N3SHR9tVP/SYNPoWetNtwP4BQRbD/lp+03I0HdoYcrN1hi/NwSjCis3UlefedkB4lyvQ9HrA4/2wd9o4Z/XDDcFd4yrh6lPX+CJbhKLh5+XiRJVnSi9imod+24iK8gVzjh1bCk0NIBV6vo+SxirJN8x4f4H6ds2f0xwjgqS9JNZClqjI1vMT0pUbrR9NGDKMFBf9hvgixT9k1J0djD5zsQkam+ORng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7QPIfgnpKn9R0gKxENjwS1dyvZZQej9CuJyqCguEkE=;
 b=HHONqcynpEWlGtWAfWDK263bnktGcbt6MnjFgdDaBzWR6SsFiXFfvTnAO4M0pdNZfZuCGjnjh1EbV0hkHkMnjSAbWSrkbaBv1QkuIx/zNcMAESMLZLhYxXMKAs/YSK+jeSlf0QMnqQj88zzUHhpovL9MGTiFT6E0uIC7B1uNSUPhM+4DHPbz66QFttoMmNq2rNYivelzP3YVQO0sJgpU++W/31yLiwUOIt9rSoMeHuJR4cKJQNCy6/0CxPM3KunNMJNH7cpUUluFeB8xeamRFuvQ8jpLYJsNdk3ifZzx4zGYuOAKzxcnLVJ4etLQ4HyQ6Kco3pvfy/V35tz2mdutXQ==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by IA0PR02MB9076.namprd02.prod.outlook.com (2603:10b6:208:440::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 06:22:56 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%6]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 06:22:56 +0000
Message-ID: <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
Date:   Tue, 6 Dec 2022 11:52:45 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, seanjc@google.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <86mt8iopb7.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::7) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|IA0PR02MB9076:EE_
X-MS-Office365-Filtering-Correlation-Id: 453db807-ba67-471c-5665-08dad7525062
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P46TPK4Pw3uwCEVg/dF6qcn3wMBBK+5B7hxt1Cx6V/rvXYznwMLIbiE4KQgrubVUCAaa631pRZr3HGV78jFYXnvizQ9whCYOaWZZ6cwujAF6fqBuXpgnQZJcgOVkaNhSB1GZTD02Xa8x5PMYgUbkvoGPad12Sq3lNgHd/Qh194H7m3uQ7tL1LD2hBr58csCAwhuAJniRBIupxbht6NMBmyDTNK5ztDmXgPU1kIpUG3lgxoF59DKrptxWEWHaCWtsLJAF6Yyx1pzZVJmUQ8EokyvAAigIkWSWi9zb3ilIb3d6TGA8hPwPE0+bupnN1F+Hi7jeNrXd+ygvXDK2JyoDLVG8K1GtfOFdPM9QHRcT9rSTPY53seQxsiEPViIeO7VtXXjclSIZ2z2tCN1lrqBEL15Pv6CDXRpVzQFyzWWjKhTST6qD1Zkgaqn4bk+QA4c6m8u8Ux7VPWFA+8Z6Fag5tL/pVF9EjeKZv/a2z+JpLxjCRDifyYhD7Qxz5u31ytSTbf/227SZSwnNiDMgN4u+oIrGMUOy1OsosuH0Rxma6v9ZCTI4THLmD/wLmw4dfUVbaVuEoILyYFl7fFroHwaf0/KLLG6OPMSXTVraKsql2XeZCjRRfZf/xkrzf/QcR9XvG8LJKisS34W8ttaMCoF92zuSYXp+n3e6sG6JFQjWKvuvcT7oIQhBn7juOJZUIc+weESPaOW7QRIU7Ub82QUhjFtv0L3k964eycBZnMWZA1LIk/ohXKC/cXzkB0F4F3VaATYJkSMAeRSPhOvk/hjeTk/WyBBaJP+P7rqQC1V2KzE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199015)(83380400001)(86362001)(8936002)(31696002)(38100700002)(5660300002)(15650500001)(2906002)(41300700001)(4326008)(8676002)(966005)(186003)(6506007)(26005)(6512007)(53546011)(107886003)(6666004)(2616005)(6916009)(478600001)(66556008)(316002)(6486002)(66946007)(66476007)(54906003)(31686004)(66899015)(36756003)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUZXcWg4WThZdFBGRWNUUkx1ZTVZSGRLVHkxNThaR1FBbEkrS0R3ckM3S29B?=
 =?utf-8?B?c21GcnphVWtIeUFCWi9rVHZNcEM4TEsrNjVSLy9qMnZHdzhrM3UzUGxPZjBx?=
 =?utf-8?B?RUlNRUFOUUNKUTBYcEpBbThNVXBRcm0zUngvUHVFbGg1N2tKaFRHbXIrQmk5?=
 =?utf-8?B?UEk1NXFnQzFjNlNPN2o4UWwveXJXSCtiODExUTdNaWxFb2g2U0U3c0lqOVgx?=
 =?utf-8?B?cHRVNWczYW5IQU9IUUcwK1Btc0pXR1oyd01IbE9XWU9EZkxobm1obDlyVmhO?=
 =?utf-8?B?MGUwNWg3QjJCNTdKSGl4QzBnNDBLd2lTbGtUdE9uZEg2V1lqckFUL1hOZ05r?=
 =?utf-8?B?TWZnVnZYTWl0L1ZReEJSWGZIRk9iWmYvMDFQb2Y4MVN2bUNFNkZXMng5WWRR?=
 =?utf-8?B?NjJndEdRdEV5bU5zUldYODQrNEt0Y2RUdmMvZUJGd0FZQTViMnc0RjB6ZTVu?=
 =?utf-8?B?L3J0NjlWdTNTUG1uSEtPUXdvQW5wb2lPZW1QVzFnTFN5d0tuTVFiaUl6ZVFn?=
 =?utf-8?B?Q2tTUis4bGtoTkxXRGwrc3JleWJ4Y1RHTFdFRytiekxBeTBsdDVRK2szYnVU?=
 =?utf-8?B?VXBrNkNOVWc5YlIra1ZXb1B3MlJMNlZoV252Q3RLclhmMmJYWCtNYmhNLzUx?=
 =?utf-8?B?SW5pQ2Ywa1R5cHUwYlcxVWJ6YjZxREVJRklHTHBmTERPZDV3b0UxenpHVXBI?=
 =?utf-8?B?bTJ2a3p0bVlrZWhKM1JYMTh4KzFRSVFkUlU4MDNwS0VJdGo2NWFTMnZxTTg3?=
 =?utf-8?B?R2lPNUdpcE9YK3F2aDN4UzFNaEhkVEFoM3V0R01lUlQxMGs4VGpheStxZ3FT?=
 =?utf-8?B?TDZvbEo1Q0RXc2Vpa1ZlY0pJc3FqNVAvWVJOdEsveVJVM2tCZjE4UDkrTjNj?=
 =?utf-8?B?VEZBYjNlSFh3R3ltV21sditFK2VVZy9JT1graFpZSTNMWWtHQnNQVmMzMit1?=
 =?utf-8?B?UWRzeEVrVm82T2V5Y1FjRmlkMVBJVmRHMmV5L0laZkd2S2tuS25DL1BRVFZa?=
 =?utf-8?B?T29vaUd3S3FXcmU3NnVNODNXMlhhWTd2RUdBMnA1bHpoMUE2V2pnR1Y5TUVl?=
 =?utf-8?B?dlZpaHYzMW16YThzN29uektkSDdPaWtnOUNlTTg2dU4ydGdUNWlINkJvWjFP?=
 =?utf-8?B?c2hGeTNxcytOZmwzVHhUWXVrKytvWVBqRDBmTXhXWnZ4SkJsUWZkY1lPUGFq?=
 =?utf-8?B?WFd6bThQNkxJbEd2ZDlBNzVacVArSU5lSWI2clF1ZDMwVklSeEo0MENYVXBv?=
 =?utf-8?B?QlRHNXl5bWNqeERjVS93blQ1OEJaZW52SVc2b0hlRzU3R2pUYWZwc0JhOWZt?=
 =?utf-8?B?U2NPbG1wSUFiOUpPUDJEb3FHcTVPK3VqeEpQSGVWSGRsUXA0WHJIelpoeFBy?=
 =?utf-8?B?Q2VBRDVoSzNaUDM2dUtRV1JLSWV4MVVMS3VoWWJMUHRiUVUrMkR0cnFqZnpo?=
 =?utf-8?B?SnFnQ1QzVnRFL0ZBbENGK2lCWjVEL0N2TThVL0RibDN4K3BkT21pZTl5cGJa?=
 =?utf-8?B?QTNDM3M0dmJNV2ErNzdoZlIvVWtKSXloZ1NER2tKSHdtS2h1UnFSRFpFdGNJ?=
 =?utf-8?B?amlsbkxSUS9Fck5iaWJ5VDQ5ZU9KNGZvbnFPbGNGZW8xZTNqS1VJQW9sVXUx?=
 =?utf-8?B?TVJLRy8rSkdlbm44a0IwOEcxWWlwSndrOE5kUWV3SnRGek1ya296a3hmY1l6?=
 =?utf-8?B?eThqdndqeXMxU29tQTFKV3dWdWpEVHlqU05DMnRRYTRRdWNSd2p1bnVnZE5F?=
 =?utf-8?B?M0htL25LWDlsVkVYZ25SM3kyUTZubGdNM1dSb3N1WlZUa3I1QWJFT3grbGMx?=
 =?utf-8?B?U28zQjNxVDJaMVJlRGErTjl2YVF3K1RkRWRpT1JSSHZNWjNSTWhsZDRCNi91?=
 =?utf-8?B?bnNKbW5YY0RBcUdoV29hdFdOTUUrUkhYUGZ0MkxLVlF6WjNEbDUrUGR4bzI4?=
 =?utf-8?B?b1FiRGwyUitqQThXWkRSdTd3ZUtaSDlvQ1l5a1NsRWptOGRVR3RmdVRtVDNl?=
 =?utf-8?B?bUc4bzF1aVRLaHNNTjk5d29kdVJHazlBUzVPUEVnd2luTjJBb1ArUytRY3JF?=
 =?utf-8?B?UG85aGw5TU1ma1dKc1NQTWUxOGZpMnJjOFpQTlhCMFR3a3dZSmtGYndTcHhS?=
 =?utf-8?B?dGh1TXJNVG1raEU4UnJldERwR0RHSzBGOHhQVmR3THFvbExsSm5ZR1FsdFZh?=
 =?utf-8?B?TEE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453db807-ba67-471c-5665-08dad7525062
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 06:22:56.5539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vr41aNM5Xb8XNFYssJyoCI9vDwUhsngzCH0SfIL4q5/XaugKl9sgQvCI3khH7puCj/ECVTroAETgRGOCMNfz21MbTG73QUdAVPunegGCszM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9076
X-Proofpoint-GUID: 4cOxjQAJ3RVH7h6zbVAeqlzyIErv2zSC
X-Proofpoint-ORIG-GUID: 4cOxjQAJ3RVH7h6zbVAeqlzyIErv2zSC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_04,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22/11/22 11:16 pm, Marc Zyngier wrote:
> On Fri, 18 Nov 2022 09:47:50 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>
>>
>>
>> On 18/11/22 12:56 am, Marc Zyngier wrote:
>>> On Sun, 13 Nov 2022 17:05:06 +0000,
>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>>
>>>> +    count: the current count of pages dirtied by the VCPU, can be
>>>> +    skewed based on the size of the pages accessed by each vCPU.
>>>
>>> How can userspace make a decision on the amount of dirtying this
>>> represent if this doesn't represent a number of base pages? Or are you
>>> saying that this only counts the number of permission faults that have
>>> dirtied pages?
>>
>> Yes, this only counts the number of permission faults that have
>> dirtied pages.
> 
> So how can userspace consistently set a quota of dirtied memory? This
> has to account for the size that has been faulted, because that's all
> userspace can reason about. Remember that at least on arm64, we're
> dealing with 3 different base page sizes, and many more large page
> sizes.

I understand that this helps only when the majority of dirtying is 
happening for the same page size. In our use case (VM live migration), 
even large page is broken into 4k pages at first dirty. If required in 
future, we can add individual counters for different page sizes.

Thanks for pointing this out.

>>>> +    quota: the observed dirty quota just before the exit to
>>>> userspace.
>>>
>>> You are defining the quota in terms of quota. -ENOCLUE.
>>
>> I am defining the "quota" member of the dirty_quota_exit struct in
>> terms of "dirty quota" which is already defined in the commit
>> message.
> 
> Which nobody will see. This is supposed to be a self contained
> documentation.
Ack. Thanks.

>>>> +The userspace can design a strategy to allocate the overall scope of dirtying
>>>> +for the VM among the vcpus. Based on the strategy and the current state of dirty
>>>> +quota throttling, the userspace can make a decision to either update (increase)
>>>> +the quota or to put the VCPU to sleep for some time.
>>>
>>> This looks like something out of 1984 (Newspeak anyone)? Can't you
>>> just say that userspace is responsible for allocating the quota and
>>> manage the resulting throttling effect?
>>
>> We didn't intend to sound like the Party or the Big Brother. We
>> started working on the linux and QEMU patches at the same time and got
>> tempted into exposing the details of how we were using this feature in
>> QEMU for throttling. I can get rid of the details if it helps.
> 
> I think the details are meaningless, and this should stick to the API,
> not the way the API could be used.

Ack. Thanks.

>>>> +	/*
>>>> +	 * Number of pages the vCPU is allowed to have dirtied over its entire
>>>> +	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
>>>> +	 * is reached/exceeded.
>>>> +	 */
>>>> +	__u64 dirty_quota;
>>>
>>> How are dirty_quota and dirty_quota_exit.quota related?
>>>
>>
>> dirty_quota_exit.quota is the dirty quota at the time of the exit. We
>> are capturing it for userspace's reference because dirty quota can be
>> updated anytime.
> 
> Shouldn't that be described here?

Ack. Thanks.

>>>> +#endif
>>>
>>> If you introduce additional #ifdefery here, why are the additional
>>> fields in the vcpu structure unconditional?
>>
>> pages_dirtied can be a useful information even if dirty quota
>> throttling is not used. So, I kept it unconditional based on
>> feedback.
> 
> Useful for whom? This creates an ABI for all architectures, and this
> needs buy-in from everyone. Personally, I think it is a pretty useless
> stat.

When we started this patch series, it was a member of the kvm_run 
struct. I made this a stat based on the feedback I received from the 
reviews. If you think otherwise, I can move it back to where it was.

Thanks.

> And while we're talking about pages_dirtied, I really dislike the
> WARN_ON in mark_page_dirty_in_slot(). A counter has rolled over?
> Shock, horror...

Ack. I'll give it a thought but if you have any specific suggestion on 
how I can make it better, kindly let me know. Thanks.

>>
>> CC: Sean
>>
>> I can add #ifdefery in the vcpu run struct for dirty_quota.
>>
>>>>    		else
>>>>    			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>>>> +
>>>> +		if (kvm_vcpu_is_dirty_quota_exhausted(vcpu))
>>>> +			kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
>>>
>>> This is broken in the light of new dirty-tracking code queued for
>>> 6.2. Specifically, you absolutely can end-up here *without* a vcpu on
>>> arm64. You just have to snapshot the ITS state to observe the fireworks.
>>
>> Could you please point me to the patchset which is in queue?
> 
> The patches are in -next, and you can look at the branch here[1].
> Please also refer to the discussion on the list, as a lot of what was
> discussed there does apply here.
> 
> Thanks,
> 
> 	M.
> 
> [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__git.kernel.org_pub_scm_linux_kernel_git_maz_arm-2Dplatforms.git_log_-3Fh-3Dkvm-2Darm64_dirty-2Dring&d=DwIBAg&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=gyAAYSO2lIMhffCjshL9ZiA15_isV4kNauvn7aKEDy-kwpVrGNLlmO9AF6ilCsI1&s=x8gk31QIy9KHImR3z1xJOs9bSpKw1WYC_d1W-Vj5eTM&e=
> 

Thank you so much for the information. I went through the patches and I 
feel an additional check in the "if" condition will help eliminate any 
possible issue.

if (vcpu && kvm_vcpu_is_dirty_quota_exhausted(vcpu))
	kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);

Happy to know your thoughts.


Thank you so much Marc for the review.


Thanks,
Shivam
