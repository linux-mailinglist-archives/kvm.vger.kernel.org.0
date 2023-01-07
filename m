Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84DAD661080
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 18:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjAGRZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Jan 2023 12:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbjAGRZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Jan 2023 12:25:32 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D50E4F115
        for <kvm@vger.kernel.org>; Sat,  7 Jan 2023 09:24:59 -0800 (PST)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 307HLgO0017132;
        Sat, 7 Jan 2023 09:24:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=zAZ3oz8xhRXyIMk1svFVEDLMLW3EILuiWrwu9jC8MX4=;
 b=xyvVQuvJPFD2EhYSV1bA+ZCp34gJeM8+l3bHSMW0+8biviBl7E84Fea5gYT1yGZl19Xr
 r9+tdYPO8v8ow+vOGM33Pcv86BL4JW6MEIKb1n7gcpitWmLnxGA4wiQg32Jnj4XfL0vg
 mUno5vu5u7pJLV24VQWG6KxfvROzrkRlrtH2oSxS2UQUvLoDda4gp9ONSsMS8laq3LEK
 KQ8kJe0MBJN6TWv16f5Ooqlv4ehTMEIWrEJiXgwQpi7AqFja+OIQ+qwxfN1KYhsc3AXm
 rsMDWhW8Psm9Ai1sTylPQajAPAiaS/61saWVb/cSRANXCqRdBU3wDN5KAtebYsKsguyU hg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3my955g6a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Jan 2023 09:24:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsDbsQF4QMVMK3T3IoeQnzj0Fmxkag9Hsb5/QvmLAg7AFTSCW9h5pgfVI1igQm05s2HhgZmDpEXIeczyud68GnxkxJiCf1HqlTFt2HPEMDnL5UgaboVWYwIRaw1UopaVRvgIpHXivIqaKuB9IBusm3q1hmIz2siojYRsLm3/yQKnbxKRh8xBlc2NckgQmXoIPKc85AP48+MivJBYfe+gUbaQL/BjlZUtnrqgfHc2/TpvigFcpWNIylnCLSBBXmibCHuYyq0nxC6ahR+N2oaLqO1Lqt8lm/vCLwDPZ+XvO7DeomB2NWCVZVkT/Wmy+7BL6B2auwUcJbtOidDQTePnwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAZ3oz8xhRXyIMk1svFVEDLMLW3EILuiWrwu9jC8MX4=;
 b=Z7t+pOCafC2t1QX4VaYmu/6DNkEx30//vtDnBKYMNby/Nt9itP55AvYrroxe7cg6ZjxNsGkzxXxV7/fTTc+xIDwxW8wdBaJAY8oVOA55WAgGCK0L34VpOT6GXL7TAYLKbQ52jyBiSdLpSC+AhZtRuzmANi3h9/aAMPUCRkl7rk+qqobrX5J1GgMMwzbVta4UKqWHYCAkpYpQKRGjmjWrw5nSGYRXpn2KIDjYkyB4B1r1sMzGkMpj1u421OSb4JoUqhvhbpQkTMIYI2x3FXcbpjPV5u9jeIKPIC5X7msMaSqcab4CaS2TTPvSYWdsq2oy8Pjo2jsY701yegR7Mtvquw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAZ3oz8xhRXyIMk1svFVEDLMLW3EILuiWrwu9jC8MX4=;
 b=uXToGLo2SwCPC+Pkq0KnEOcSWojUOfOIA3fEh+Toc3Qm64suJwmkyiv5Vvnl7XJwhl9CNneIaPyaVGFxvQyn8Vnn+qdyfWqpeJH6Pao6h8voqfp9ej7Lzq9Du4pF8PiG3z81671refZWeejeNTRCNLCxsee7KtD916kIWQF/IUgos+IqZ5egCvmhhnmiY0dfkn1/Ef6zjA26h6DWOn0PsnO1t/52qwcWMaExum1XplIV1GH2euQLsT3o4nk4C7+kfDh4iC4GHk3NeijGWfU/5Wd166ki25PakW/h4V1/OSQUMAhT5qm0l9gcfHIw9TUlIxr85qbHMKabF0TxJQ3uAA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by PH0PR02MB7399.namprd02.prod.outlook.com (2603:10b6:510:a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Sat, 7 Jan
 2023 17:24:37 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::dc45:3b8a:bd53:133a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::dc45:3b8a:bd53:133a%9]) with mapi id 15.20.5944.019; Sat, 7 Jan 2023
 17:24:37 +0000
Message-ID: <77408d91-655a-6f51-5a3e-258e8ff7c358@nutanix.com>
Date:   Sat, 7 Jan 2023 22:54:24 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org> <Y5DvJQWGwYRvlhZz@google.com>
 <b55b79b1-9c47-960a-860b-b669ed78abc0@nutanix.com>
 <eafbcd77-aab1-4e82-d53e-1bcc87225549@nutanix.com>
 <874jtifpg0.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <874jtifpg0.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0149.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::19) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|PH0PR02MB7399:EE_
X-MS-Office365-Filtering-Correlation-Id: c95ab59c-34d0-4271-f9a8-08daf0d40ca4
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s/HdZ5HZaXbwmBmxjz6ZlHSpES0f6LHxv7hz4i//6uqRqIdKybIzy3VrUNty2EclU1WUyJs88jVfoCZQxUsaISjyD/MfnbXlIIUJoFV4ROdo03io9AqztSXPiD6CfCO0YCW6W/d+d2200q9hQEk1S7b7CH1y912NMcSavGqvq3jcQrpc/9fDgL5sYKahphu1XZm9thBCxxYVZm5UMKTMEGXjghJ4ZB1EvZfuBVwLKochYHHViyaa+Y1VhgnsFzg6w2hTwpZ9ZNobXj7z9S9HrffVdxxc4BUAarlFuP4dPsMXTWrj7DB5rYpNcvlwJr0/1lAGGaRtJ7qa5IGmnYVm5JsRgHrgYzGb/ndnWkuYb9djkzeGd05RB8L975dQ+egbsxncyqnBsVK/+/ENW444cxuW3r6xhG8ubJPSTVP3Wt/5yd+bc7waSk2l4E2VeAVT3FDElGlR+1z5B5xuoWwsWbS/Kul83B0xmJTtOeW5XSbhurfvWPpvaqjOj6aS2yEfLUbmc+Lk2zXpDhO1wFbdcNkwPfNUpZIha7wg+a3qEiaIZMcI0k9NIJ1GuCJa01UM6/RDrMcxErYPoXZV+yTnTCgO8TTiJDxlAjfpPaXkyLLc5xdIcZN43uxH4X3Tiw+P1DN3ZRrKbWO/Zvnr9KUPg5kcCpJsT9Cbo4dU+yx7Mw8M2oFoWFzFPe0UQSY9H/GkIDRc6lrrJrSnRpX8F9rNkc7HH5kzUzs0TQW5Ev0NScH67QOfSKlPjw/wz6olPZ0M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(8676002)(36756003)(2906002)(15650500001)(5660300002)(38100700002)(8936002)(31696002)(83380400001)(86362001)(41300700001)(6916009)(31686004)(66946007)(6486002)(66556008)(478600001)(54906003)(107886003)(4326008)(6506007)(6666004)(6512007)(186003)(26005)(2616005)(53546011)(316002)(66476007)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2NZMGtFeGpTY2lyTDkzZ0ROTCtGRnV5SjQ5Smljd3k0QmMwZWw0ektwclg2?=
 =?utf-8?B?QTh0Z3JqSXVOeFQ0S3dUL0syTlFqSTl3blNmQ1VYN2hVb2VhbENkeXR2S2RL?=
 =?utf-8?B?clhGQUVQTUFvRFExYVV3Vk9vazZxa0N3TDNDejBxVVNMVzZ1MVRLWk9qM3Rl?=
 =?utf-8?B?MVY0MXZRUnZHWU9ZU053VFZXS0Q4Tmt0dE9taWdwcUxLNms1TFo5TUNDaTBl?=
 =?utf-8?B?ZmgwZzlhNVFDUlF5LzZCL1E0S0N6NDN6b0hvUkQrc0FxQkNKMnVaMXRhTUhU?=
 =?utf-8?B?WEE1NklSNjh4SDBNaG0rMkZSUUVKQldBZWJtUHE5SWtoZVRzYWc5ODNrRExV?=
 =?utf-8?B?a0syUnVzWkpBeDBieFlWOFg5djJoK1BwaHJXcWllTnpibHRxTUtwKzlua01U?=
 =?utf-8?B?L2lVUXRZTGR3akFKNWZ6eE85d1lqM1hIdkJIRTNiYmtGUnByWk14bFVmYkZT?=
 =?utf-8?B?ZWEvZVRrdjdUazA0d0V0VWthcE5wUWg1OTl1WDZBWjJQVnZSVHpIYlllRm9v?=
 =?utf-8?B?N281MGlOWjZ0TzFLYkpKd3I5dEgzOXBoOWFHVmRES0IyV1VMNERtWUNkYm41?=
 =?utf-8?B?K05NamZUQXJFeStWVmx2ZzV4K3JsM0JFbUdBZnBkK3ZGUzIza3pGcnJkaUtz?=
 =?utf-8?B?QTIyR3o5RmVGNzFxeXI3SmlOandGR0RBNWR6TjdaR3V5d1FkdUovQnRhREF2?=
 =?utf-8?B?QUJYRjRoMjJIeGhQWkovV1l4Mi8xdHVMVEJ4K1BrV005M1lDb1dyYnhhWk1N?=
 =?utf-8?B?OGFCRnpQaTBGQ1pFd1g0bUgzU0NVZHFMVDhtMlVHeTg1ekNDaURHKzlpVDl3?=
 =?utf-8?B?QWxzcjJrQjdhY3NqZGsyNC9vemxNVlZSUEVWeFhMbFZjNU92ejVnNEI5SVpM?=
 =?utf-8?B?eUYrZHdRN1V4ZWJDamJxNWU5Rm5LcDgyS3d2elZxVEY2ek5hdUFOVFVaajVk?=
 =?utf-8?B?UGIveWZqTHovSEhielpMVy82a1pGeTQ4azdsYTdnbHJXTWV4N0ZsYW01OEdy?=
 =?utf-8?B?dzVHcy81dmo0VUJpWlJBcHk5TVZNRE5vV3JzZHBhbE0wMzlkdHdSamhWZmZT?=
 =?utf-8?B?aXBYN0UwbzJmTG9SbFkxd29BTC9FaGF1UXZIVWF5eDVYQ3lzclNjc2dnWThR?=
 =?utf-8?B?N0NTbWtwcFdEVzZia3ZUb3VNbmNORk1RU3liWUJtbEV0NEx1UjVHL0ZDZWxa?=
 =?utf-8?B?bEFkUENRTGhINWhhM2J3Z09YZnlOTngrUCsybUJ2SE5yN0dhT2J0MVhVT1Q5?=
 =?utf-8?B?WDRzc3F0ejhCTGttV25rTWJjUFV2VG9tT3B0c1NQbjMwdGp3dDVrOUxKVTVi?=
 =?utf-8?B?WVpHN01xaXZBOXFmZ29vNWNVSkhJVkVIQm1OeElwS1k4dXBqZmh1SlJmbEl4?=
 =?utf-8?B?bXdpL1lXKyt0TVlZdDlwM0NXMDAyRnlROTVCNkhUOWVURkVWUGFUaXZPaSty?=
 =?utf-8?B?OGtHcllpZ1JTV0ZkZE4rbUswZTR3dFM1NlV4UGkzdzFxZVJ2Y1RHdkE0VXdu?=
 =?utf-8?B?TExxSnN5UWpJWjhPYTl6RlpxTEJrMTQrcy9GbWNuNW9WR0hvS3BsNzY3dmh3?=
 =?utf-8?B?WFFUc01JSnVZYmRRODlHSk9ySFQ4NVdXVEswblBZNjV0Tks0dTlNU0VBdGxE?=
 =?utf-8?B?QWswZys5NTdUOHdwQkFybC9iaGxyUDVXVE0xMzdHSnQxTHEvYk00OXRjd2Vr?=
 =?utf-8?B?bUR4ZERHR3hOMG9NcXROb0orMGxqUnA3S0FhNnpZc3RMYW1YVVNMRXJYeDJW?=
 =?utf-8?B?TlI2NGQ4VkVxb0svOFFWczVXbXVxSUR3Tlh1SGtnUDJwTW0zeUtBU2YraVBJ?=
 =?utf-8?B?YVhIZGlZaGxzaThFTkhqNmR2allYT2tBeFBqSitaa25uaG5CZ3l2aTQ0Q2lI?=
 =?utf-8?B?Q2o3ckw1MnEvb2dvQzV5K3l6ME9NWkpNa3F2Nmp0OHVVRjlEdFQ5NUJMTkhx?=
 =?utf-8?B?UTV1ejVEcG1SdFpSTnB6aklHdjBHL3JROXVRL0Z4a1d0VnBnWHI0Z2JzN0dh?=
 =?utf-8?B?ay9BNHl3aW5kaVlDeGxsZHVGM0l5QzljWXBZeWpIVU53ZWtFbEhjdHJGYW5s?=
 =?utf-8?B?dFQ2bVBhNWhQdWdYbWxnczI5QWtONURJRzBrd3crWWt5eDR4aVNRMHU0VzNh?=
 =?utf-8?B?aWllSEdBQURSbHIzb3hDL1FqYnpUTDRwYVkva0ZZMWFleUJjc0x0ZDdRUVZ2?=
 =?utf-8?B?L3c9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95ab59c-34d0-4271-f9a8-08daf0d40ca4
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2023 17:24:36.6904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPoX2pVWqT6COeHegOn7vUAp/F5R0AVxAta6+N4FHQBCIAVUgDO+C0M23V3pE4fPzwn3TIBHagLQUNEa8cOyIemNV+fSykVm7JaJ3LmViHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7399
X-Proofpoint-ORIG-GUID: x6g4shEE_Kxlnx7hican9b3bhCB1iO-T
X-Proofpoint-GUID: x6g4shEE_Kxlnx7hican9b3bhCB1iO-T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-07_08,2023-01-06_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26/12/22 3:37 pm, Marc Zyngier wrote:
> On Sun, 25 Dec 2022 16:50:04 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>
>>
>>
>> On 08/12/22 1:00 pm, Shivam Kumar wrote:
>>>
>>>
>>> On 08/12/22 1:23 am, Sean Christopherson wrote:
>>>> On Wed, Dec 07, 2022, Marc Zyngier wrote:
>>>>> On Tue, 06 Dec 2022 06:22:45 +0000,
>>>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>>> You need to define the granularity of the counter, and account for
>>>>> each fault according to its mapping size. If an architecture has 16kB
>>>>> as the base page size, a 32MB fault (the size of the smallest block
>>>>> mapping) must bump the counter by 2048. That's the only way userspace
>>>>> can figure out what is going on.
>>>>
>>>> I don't think that's true for the dirty logging case.  IIUC, when a
>>>> memslot is
>>>> being dirty logged, KVM forces the memory to be mapped with
>>>> PAGE_SIZE granularity,
>>>> and that base PAGE_SIZE is fixed and known to userspace.
>>>> I.e. accuracy is naturally
>>>> provided for this primary use case where accuracy really matters,
>>>> and so this is
>>>> effectively a documentation issue and not a functional issue.
>>>
>>> So, does defining "count" as "the number of write permission faults"
>>> help in addressing the documentation issue? My understanding too is
>>> that for dirty logging, we will have uniform granularity.
>>>
>>> Thanks.
>>>
>>>>
>>>>> Without that, you may as well add a random number to the counter, it
>>>>> won't be any worse.
>>>>
>>>> The stat will be wildly inaccurate when dirty logging isn't
>>>> enabled, but that doesn't
>>>> necessarily make the stat useless, e.g. it might be useful as a
>>>> very rough guage
>>>> of which vCPUs are likely to be writing memory.  I do agree though
>>>> that the value
>>>> provided is questionable and/or highly speculative.
>>>>
>>>>> [...]
>>>>>
>>>>>>>>> If you introduce additional #ifdefery here, why are the additional
>>>>>>>>> fields in the vcpu structure unconditional?
>>>>>>>>
>>>>>>>> pages_dirtied can be a useful information even if dirty quota
>>>>>>>> throttling is not used. So, I kept it unconditional based on
>>>>>>>> feedback.
>>>>>>>
>>>>>>> Useful for whom? This creates an ABI for all architectures, and this
>>>>>>> needs buy-in from everyone. Personally, I think it is a pretty useless
>>>>>>> stat.
>>>>>>
>>>>>> When we started this patch series, it was a member of the kvm_run
>>>>>> struct. I made this a stat based on the feedback I received from the
>>>>>> reviews. If you think otherwise, I can move it back to where it was.
>>>>>
>>>>> I'm certainly totally opposed to stats that don't have a clear use
>>>>> case. People keep piling random stats that satisfy their pet usage,
>>>>> and this only bloats the various structures for no overall benefit
>>>>> other than "hey, it might be useful". This is death by a thousand cut.
>>>>
>>>> I don't have a strong opinion on putting the counter into kvm_run
>>>> as an "out"
>>>> fields vs. making it a state.  I originally suggested making it a
>>>> stat because
>>>> KVM needs to capture the information somewhere, so why not make it
>>>> a stat?  But
>>>> I am definitely much more cavalier when it comes to adding stats,
>>>> so I've no
>>>> objection to dropping the stat side of things.
>>>
>>> I'll be skeptical about making it a stat if we plan to allow the
>>> userspace to reset it at will.
>>>
>>>
>>> Thank you so much for the comments.
>>>
>>> Thanks,
>>> Shivam
>>
>> Hi Marc,
>> Hi Sean,
>>
>> Please let me know if there's any further question or feedback.
> 
> My earlier comments still stand: the proposed API is not usable as a
> general purpose memory-tracking API because it counts faults instead
> of memory, making it inadequate except for the most trivial cases.
> And I cannot believe you were serious when you mentioned that you were
> happy to make that the API.
> 
> This requires some serious work, and this series is not yet near a
> state where it could be merged.
> 
> Thanks,
> 
> 	M.
> 

Hi Marc,

IIUC, in the dirty ring interface too, the dirty_index variable is 
incremented in the mark_page_dirty_in_slot function and it is also 
count-based. At least on x86, I am aware that for dirty tracking we have 
uniform granularity as huge pages (2MB pages) too are broken into 4K 
pages and bitmap is at 4K-granularity. Please let me know if it is 
possible to have multiple page sizes even during dirty logging on ARM. 
And if that is the case, I am wondering how we handle the bitmap with 
different page sizes on ARM.

I agree that the notion of pages dirtied according to our pages_dirtied 
variable depends on how we are handling the bitmap but we expect the 
userspace to use the same granularity at which the dirty bitmap is 
handled. I can capture this in documentation


CC: Peter Xu

Thanks,
Shivam
