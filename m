Return-Path: <kvm+bounces-1604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C657EA150
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 17:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 297101C2099F
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 16:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7DB224D1;
	Mon, 13 Nov 2023 16:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="iEfSXjq5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72539224C3
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 16:33:42 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2112.outbound.protection.outlook.com [40.107.15.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B73FF2;
	Mon, 13 Nov 2023 08:33:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUK5kzNWwfUBziIRKMnfN51qPM9npTTrVOMJ0K60nrM0ABzdDehGwbE7M7nbUsnx4YqH+e44+5TS9YKmbj0hqqfJrLsjE51iyhQdOVHrZ68VOCBY0hsrMUyCO03inLs5G/lr1ff1LFP3FROmL4fi7KiUoBeDTIjyjsyKqU2sZY7Wmfpo8n0PosCEu091GjBaRnfpBAy9gL+95yk9AkiiWqotx59L1hDb3uhbsuUVsCLWF5o5lYTIKPbsTLrEnC4Jn/WB/b4yk8OZXDIPkB7s8hrnOmFiP5hN38NxW/pRQDItYdSO3Nhgz4cFwrUdMBkqCPP6siGfrwc7GzY7HX0Krg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5tJxsjwEb7RAh4nXUwvDZSaYt2MHGT63VLFp+ugfG0=;
 b=ldAyfEzY18uPqFH4XDSMAAx5+mC4FtBIDzVw1p35MOyzaz3DwLwbYT5ww4UqOOx9e6bRlYS6qHa2VgMMS4qYtoqWO//ZOaotdSAUMIy50MFemrtK+Qxe47sSXOAk0nzqN7LfKUPduqCcHEnx1lxgnMr4eel6VKl2AVFXZcirEsQEKQSOV/YM0ws+406726OGAPjJZl86XvneI+kwMF8zUZp+LRiYcTxUAkjCK9pCygjLf/h7LykOR7CQWR/mWd4hA8KajtQfb9+cfoHF4HFfJ3vGoUOucoESb2hLljHKPnzTGQJG9W2WANFPHVesvU3FhwJtkH0ULU93X+TnlDp+3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5tJxsjwEb7RAh4nXUwvDZSaYt2MHGT63VLFp+ugfG0=;
 b=iEfSXjq5tRwt/r5S7rCCf19EU8Ko+/vGiB9/24Juolufwjr4CZ9NzaBgkw7DlszB8jEqkdmFXZ2BeSvbjIroVTKoOPZKPHhM2vJZeoYIDes1jYRS7MBGU3l8LVRbf0Iw776FqAWxxwSkA9yucbEfHw20MNuT3V20SLtcnwGgyYyNcZjY8UECECeqxiPmKmYttTvH23mJdAQTKuwAeV9xKqCQ6WXDiTPdMi9u8oFc9eP6DkO1yudgTmQ0S8it6sFXoBRVJ/awVdqXpVwKgwO6lub04Bw8idRaBlxLVSapRIn8DSk1bPmvv89wDIOIqkRfQiRQByTz2IrtjN1tWu5AbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by AS8PR08MB8465.eurprd08.prod.outlook.com (2603:10a6:20b:569::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 16:33:36 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::46ee:1c5c:2cc6:b1fa]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::46ee:1c5c:2cc6:b1fa%4]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 16:33:36 +0000
Message-ID: <971a67f9-fa21-42d5-b722-611bdfdc760e@virtuozzo.com>
Date: Mon, 13 Nov 2023 17:33:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: KVM: x86/vPMU/AMD: Can we detect PMU is off for a VM?
Content-Language: en-US
To: Dongli Zhang <dongli.zhang@oracle.com>,
 Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Alexander Ivanov <alexander.ivanov@virtuozzo.com>,
 Jim Mattson <jmattson@google.com>
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com>
 <CALMp9eSg=DZrFcq1ERGMeoEngFLRFtmnQN6t-noFT8T596NAYA@mail.gmail.com>
 <09116ed9-3409-4fbf-9c4f-7a94d8f620aa@virtuozzo.com>
 <4a0296d4-e4c6-9b90-d805-04284ad1af9f@oracle.com>
 <12aa9054-73cd-44d3-ba76-f3b59a2bdda3@virtuozzo.com>
 <12d19ae8-9140-e569-4911-0d8ff8666260@oracle.com>
 <600ec8cd-bd94-4f82-996f-28225442d5b2@virtuozzo.com>
 <5ac76cf6-04e6-875f-3075-facffb01053b@oracle.com>
From: "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <5ac76cf6-04e6-875f-3075-facffb01053b@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR08CA0224.eurprd08.prod.outlook.com
 (2603:10a6:802:15::33) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|AS8PR08MB8465:EE_
X-MS-Office365-Filtering-Correlation-Id: d12142fd-293e-4b66-8e1a-08dbe4664917
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4g/04crTVc3wIfcZAV3Lb12U+InhryGqEjmIvXVp7NHnVUNcoyTFoLEXEx0uLHM0douhg0xuCSpmSXlVlngWxYgnhQ5UF/8Siw7yHhjltvypIEuiTnB7II5x3YvLff58rRz8R2MObeRqHyv7PQNhPndUMin4/25a3+lT9X7FSdweBZhVImMuWidWwEc97R8UjBfR6dplNZgMx4iMcJDBK2G3MHgLeq/Q2u2EaKqGoBVW9QGv44J6tRwdqaGtON5QKZaFeWpw6YNyaKjG9OO+OAaqLnlTeB/9esRzv3k58fqoiQ5ItjyfxbByyZhX21B+Ro2dGa2xRDd2BlU3mgxVL8ylVuo0PPz7fqJU6pkylsmPGUpkfPQZOBFj+f8+zvgIwdJzqZdklG6YtNbr7NX3n2H3TMLiXNfq7d350yzeoYYnQ9IwXEDNehKBPWAujcMkYu+4+1Pnb3GZ5fO8LhDmjIlU3rEuh/JymtybU3LheOJSPvh4rOU0NU0dvTcxrvbMxdbkMST+fJgTxC7vvd5y3IxocwUflgcf6vf8rsdHUOxzNMow1Q7FD96dyE3n6aOr7rGDEM8Zh4WJ1mT10zJLjO2f5ba8LwnLIz2oKL/mxFtnDJI8i7tKzRQXismoxrh6s2pWBNUUVAYlhAyQA6hllgzFdj8h+mRkdLs59tRgvfBwwAeNMy+/83sspBqjpfGc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(346002)(376002)(396003)(136003)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(26005)(38100700002)(83380400001)(31696002)(86362001)(7416002)(5660300002)(2616005)(6512007)(6506007)(53546011)(31686004)(478600001)(6486002)(966005)(36756003)(66946007)(316002)(110136005)(66476007)(6636002)(66556008)(54906003)(8676002)(4326008)(8936002)(2906002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnJuSTdmcXRGL3J0N0hjVFA1bUNCMnB2dUw2QzVzaDVrVFY2cVBvTWdUdDFV?=
 =?utf-8?B?ZmlCL3liYTBOK1BHNWUwamtEcWI3QVNVUXNMREtiQXA0RzVhOWsvRWtJZWxl?=
 =?utf-8?B?aDFtek9CUzJkcjRGLzhwb1ZjemI5SkJBUWcyMXpRUmRBUmpOTWhZa2dVZ3BF?=
 =?utf-8?B?NmxEc0hSZlorSDROVE5PZi9QcDhYK1k1REV0R2ZwUjFYbmppQnJheGN6M1g2?=
 =?utf-8?B?NUZGcXV0cGpXL1dGMGVtNTJHRUZZK20yWUZyenBDcml3bk54OWpmWGl5WVZy?=
 =?utf-8?B?VEZrWHB5Qld1OVpGOVRqOUtMMkVBdmcxOXFqMS84Q2dHZWpRQk50VWJmNWNZ?=
 =?utf-8?B?L2ZFZGVzR01xZnBSN3RWOHVINmRIZnpQVUJiQ09yWFJEWjh1d293cjhyRGE5?=
 =?utf-8?B?SFdxN2o2cFNIcDV3ZG9GUlh4OHVYbFBtNzhZSDJ4TUswL3RrZ0NvbDRCVUUr?=
 =?utf-8?B?UkpWS0JITGJWYnhzMmJqaXJDS3h0M2JCd3o1blRDK2ZDTVl4UlpQNTdhL2Z0?=
 =?utf-8?B?MDl2aGowOFRXY3YzT3VoZHhXNHQzbUxzUG1WZSt1djFvMmlocmovcEdlNGI5?=
 =?utf-8?B?ejFsbWJjc241S1VsSThlQ3ZpYjZIQU5WYWUzN1F5U1o3RktSNm1Lc1QwM0RR?=
 =?utf-8?B?bWp1UkFPaERXNWN4c1dKTVhyMFZmeHR3YzZmRUhpT0JsUW1PV1BtVlBYcjFI?=
 =?utf-8?B?bEI3UEsrbGNkZEJsSUM0UkwyVHJNQng5QjNFT081VUlJQ3dTbHJDVStXZDNo?=
 =?utf-8?B?dVE0akRZamthcVpNRkNnL3dxcWdIUEpqNEtha2RySGJTV0dYT0FoWjFINk42?=
 =?utf-8?B?bDNFWmFIWlYwd2I1K01qOVpWNERjMytET0llRk9Oa1AwL0YzQXpxU3VwdW1C?=
 =?utf-8?B?dkRzaXg2VmZmeXlzb2g0UjZqZzBpQXIwL1lFWVJKbkp4ZnlkeE9CTUtKYlRv?=
 =?utf-8?B?RCszSGtYMFg4OXdYUjNBUzBTWEdGQXp3dzg1THJpL0tjQU9oVmdxZnI0S0lU?=
 =?utf-8?B?UG84Y2xtbVA5MjJKVkFZUWN0c3JQcHRlNkg1cVVHV2cvK0ZwRHlGbGwvUWVw?=
 =?utf-8?B?Z2ppeGsxbjZidjJ6TDljQmdTUkJOMGp5cG5DMkYwTXpmd1Rod0dxQXlpcDIv?=
 =?utf-8?B?dWttVFhqa0x2alBvbUorV3h0S2RTZ0dSZVBNSGJQTk9kSVJtZ1VVMHJOSHlK?=
 =?utf-8?B?QmFnOFNibkRQSDBOdlQzKzZjcU4zQU50SDhMYmtvZ3ByaG5tYmRXaTY4bllW?=
 =?utf-8?B?VS92QkdKbkh6T1YzRE16WnNoRDcvcEFzekNBS3ZyTEc0WUQ3T1p1cUJFQU0x?=
 =?utf-8?B?REpIT2d6OGE0V0VRaDM2aGNUYXVVbGZpNTJpbEVIVWJSMDdRaklVLzUrczNu?=
 =?utf-8?B?VXNtVTFSbzZqZE45Zy9lT1JDbVlod2lnb25icS9uaHN1VTRYcy83RzRVRDR4?=
 =?utf-8?B?UFg5S0hXMlA3R0tXazkwV2RYeEwyeTkzaE10cFR5TGkwak5md3dPM2pyV1Qz?=
 =?utf-8?B?eCtBSXNYeEh3YU9zcnRRWTRZQitLemthMVErN0piY2ptcENSV0pISjRna0s0?=
 =?utf-8?B?amhOYWV2bUk5eU9CUFF6cUEwYjlzL0RxdktBbUw1K1EyWHZPUXoyYzRBUEVX?=
 =?utf-8?B?QlRyWm5Sc2ZFTlV0ZGlSMGJINFhVL0ZyNnFmRThwYk1XODQ5NHFneXpFcm9R?=
 =?utf-8?B?b3NqY3lQRXprdGwyN2hOWHFaTDEzN2hQQWdMaENNdUJ1QkhlZWQvbFhTZ2k0?=
 =?utf-8?B?b25HVC91N2JqVDYvTUVXWWNuRW9xQ0VvanNXVFFZQ1NxUmczdUxQMDJ2ajRP?=
 =?utf-8?B?MHIwUksxbjJyMnkwMFZpdWlCUlR1cXArdFJ5NUZhdGQwVWZoK3FwbzBmU0Q2?=
 =?utf-8?B?emFpVVdkR2tma3MyYXpsM1ZFTlFkc2VxVS9GUjlTWVk5MFQ4cDVkalhDeVMx?=
 =?utf-8?B?NkRFVGdYVmMyZjJXeW1jR2kwK0ZLQmt3M1pHdGJCL05OM1Fkb3l2ZG1UMnZP?=
 =?utf-8?B?c2JFVTRTSDA3cE5zdms3UmZ6TE5DZUp1L0p3dVh1dm9ZYkx3Z2pzWnVlRk51?=
 =?utf-8?B?NnVjc0FXa0NZVGRSTEczOFFhU3dSd3NDWVJWV3JmRityK1hmdTQ4MnVSckxi?=
 =?utf-8?Q?sUEJhUkOWusggxsfMAUDC/KzH?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d12142fd-293e-4b66-8e1a-08dbe4664917
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 16:33:36.8340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MaqdpkaoHYrB9cLddndoErn8gSU5geM/s+zEX93izoUI3S7MGzdvtKM/ProShWd/wpFvDM0+Zt23dWbjVto1/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8465

On 11/13/23 17:17, Dongli Zhang wrote:
>
> On 11/13/23 06:42, Denis V. Lunev wrote:
>> On 11/13/23 15:14, Dongli Zhang wrote:
>>> Hi Denis,
>>>
>>> On 11/13/23 01:31, Denis V. Lunev wrote:
>>>> On 11/10/23 01:01, Dongli Zhang wrote:
>>>>> On 11/9/23 3:46 PM, Denis V. Lunev wrote:
>>>>>> On 11/9/23 23:52, Jim Mattson wrote:
>>>>>>> On Thu, Nov 9, 2023 at 10:18 AM Konstantin Khorenko
>>>>>>> <khorenko@virtuozzo.com> wrote:
>>>>>>>> Hi All,
>>>>>>>>
>>>>>>>> as a followup for my patch: i have noticed that
>>>>>>>> currently Intel kernel code provides an ability to detect if PMU is totally
>>>>>>>> disabled for a VM
>>>>>>>> (pmu->version == 0 in this case), but for AMD code pmu->version is never 0,
>>>>>>>> no matter if PMU is enabled or disabled for a VM (i mean <pmu state='off'/>
>>>>>>>> in the VM config which
>>>>>>>> results in "-cpu pmu=off" qemu option).
>>>>>>>>
>>>>>>>> So the question is - is it possible to enhance the code for AMD to also
>>>>>>>> honor
>>>>>>>> PMU VM setting or it is
>>>>>>>> impossible by design?
>>>>>>> The AMD architectural specification prior to AMD PMU v2 does not allow
>>>>>>> one to describe a CPU (via CPUID or MSRs) that has fewer than 4
>>>>>>> general purpose PMU counters. While AMD PMU v2 does allow one to
>>>>>>> describe such a CPU, legacy software that knows nothing of AMD PMU v2
>>>>>>> can expect four counters regardless.
>>>>>>>
>>>>>>> Having said that, KVM does provide a per-VM capability for disabling
>>>>>>> the virtual PMU: KVM_CAP_PMU_CAPABILITY(KVM_PMU_CAP_DISABLE). See
>>>>>>> section 8.35 in Documentation/virt/kvm/api.rst.
>>>>>> But this means in particular that QEMU should immediately
>>>>>> use this KVM_PMU_CAP_DISABLE if this capability is supported and PMU=off. I am
>>>>>> not seeing this code thus I believe that we have missed this. I think that
>>>>>> this
>>>>>> change worth adding. We will measure the impact :-) Den
>>>>>>
>>>>> I used to have a patch to use KVM_PMU_CAP_DISABLE in QEMU, but that did not
>>>>> draw
>>>>> many developers' attention.
>>>>>
>>>>> https://urldefense.com/v3/__https://lore.kernel.org/qemu-devel/20230621013821.6874-2-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!McSH2M-kuHmzAwTuXKxrjLkrdJoPqML6cY_Ndc-8k9LRQ7D1V9bSBRQPwHqtx9XCVLK3uzdsMaxyfwve$
>>>>> It is time to first re-send that again.
>>>>>
>>>>> Dongli Zhang
>>>> We have checked that setting KVM_PMU_CAP_DISABLE really helps. Konstantin has
>>>> done this and this is good. On the other hand, looking into these patches I
>>>> disagree with them. We should not introduce new option for QEMU. If PMU is
>>>> disabled, i.e. we assume that pmu=off passed in the command line, we should set
>>>> KVM_PMU_CAP_DISABLE for that virtual machine. Den
>>> Can I assume you meant pmu=off, that is, cpu->enable_pmu in QEMU?
>>>
>>> In my opinion, cpu->enable_pmu indicates the option to control the cpu features.
>>> It may be used by any accelerators, and it is orthogonal to the KVM cap.
>>>
>>>
>>> The KVM_PMU_CAP_DISABLE is only specific to the KVM accelerator.
>>>
>>>
>>> That's why I had introduced a new option, to allow to configure the VM in my
>>> dimensions.
>>>
>>> It means one dimension to AMD, but two for Intel: to disable PMU via cpuid, or
>>> KVM cap.
>>>
>>> Anyway, this is KVM mailing list, and I may initiate the discussion in QEMU list.
>>>
>>> Thank you very much!
>>>
>>> Dongli Zhang
>> with the option pmu='off' it is expected that PMU should be
>> off for the guest. At the moment (without this KVM capability)
>> we can disable PMU for Intel only and thus have performance
>> degradation on AMD.
>>
>> This option disables PMU and thus normally when we are
>> running KVM guest and wanting PMU to be off it would
>> be required to
>> * disable CPUID leaf for Intel
>> * set KVM_PMU_CAP_DISABLE for both processors This would be quite natural and
>> transparent for the libvirt. Alexander will prepare the patch today or tomorrow
>> for the discussion. Den
> That is what I had implemented in the v1 of patch.
>
> https://lore.kernel.org/all/20221119122901.2469-3-dongli.zhang@oracle.com/
>
> However, I changed that after people suggested introduce a new property.
>
> Dongli Zhang
That would save a bit of our work :)

For me this patch looks absolutely awesome and is doing exactly
what I want to do in our downstream. This would get us required
15+% benefit for each VMexit.

Den

