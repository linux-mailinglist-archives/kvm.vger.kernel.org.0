Return-Path: <kvm+bounces-1601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD71D7E9EF8
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 15:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52F54B20AA1
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 14:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1B91DDDE;
	Mon, 13 Nov 2023 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="XCt1P05L"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35BB3D78
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 14:42:33 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2138.outbound.protection.outlook.com [40.107.6.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1029210FB;
	Mon, 13 Nov 2023 06:42:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htT4ldVB5IdAadRP6EiVZbyJFXQ6dxV+CU52k7QKAbyFDnAvsQDkQIuFNhGrMv7n0L+WrIiGCUQ2xgrUT+3/sidM4auKthvTZtC3xfI/QEMvdGvZQNdc8uj7yTOKxp8f89TMAMyxpXcaogX+YoEMAyqB4tQ5qp06wmbg6GaKf8Iy7i1Ik9mwZO/fXhswMxeQbVKguL+bJzHIvdxZ+C3oPAXt/YD6hvHAjyVDDIFCuIJSbR0cPWHmnQ1FxminfMdCE+LYi30eP1eUUIr4xOr5Aofw8PDjACTkk9/7F/WZzSJ/pZMc4N7dHQiIM5r39icKjc79Me+BUNwOS17CZbUsDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+bfg2KWO2djylcIKfrRESQb1pldSm1yxTo9aqlyVO8=;
 b=guDl+I+fMFWqv+qSVMpgmaIk7ZYvpZuX56hxhZMDRGCjqhFmVwaKPDUaBSYAc3Buk+koDleZfivnpZ0z8BB8GgSexoBVVWB80ZAfXlfQZkh9s4/RHnSk3yjf2AlsRXh1Cwd4rNh5HRKm+2MqH3na1DDgkq+VSU8uYzmgDDhVedzIZuYrPBHwG09j+adkNnUMsJunbiZgI2NHm9gBVtxsI9sLEPgydDzaNT4NiSAI2cydT/Pwvy6sYBYSua7CwzNPX4ZGQ4uIfKTXKNJyvw9C1Ox+ChX8IxT0s29y4TrkAVPXDeRIQzpKq9NZy0mTRtjeERi091siwf2uEDRE0MpXZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+bfg2KWO2djylcIKfrRESQb1pldSm1yxTo9aqlyVO8=;
 b=XCt1P05LXj+ORkcvrYl8DbFnD71K8kTsV00joyG1zKMM0yYqQbE6F1TWhfcPD7YE1qomDSK5xQn6PAi4loK5JVP+aAUMI1zQY/og6+W5AGfOA7C2/OscyWH81/5yreBO81OU+O9lBM+aZfhAbpJTmQOH1CiMl7ZFTfbo+Ldd3lhJYhByH9vqfISnFNopu+sRpaG7JZOGVKAdUfRi5znw2ZcT4Arm6eSuGRr05RdXaNda8dkg36FmjPTDuJ6RAQxVbQxiMommt/AugcypMzZe7YRUQlf8GGxx+FyYkxeaqwTc+gwfCZUYNcskwsomylAED1BYB0GJciFQ0TBEttTPnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by AS8PR08MB9388.eurprd08.prod.outlook.com (2603:10a6:20b:5ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.28; Mon, 13 Nov
 2023 14:42:29 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::46ee:1c5c:2cc6:b1fa]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::46ee:1c5c:2cc6:b1fa%4]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 14:42:29 +0000
Message-ID: <600ec8cd-bd94-4f82-996f-28225442d5b2@virtuozzo.com>
Date: Mon, 13 Nov 2023 15:42:26 +0100
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
From: "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <12d19ae8-9140-e569-4911-0d8ff8666260@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR06CA0214.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::35) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|AS8PR08MB9388:EE_
X-MS-Office365-Filtering-Correlation-Id: 1effe53a-2c6e-401a-b7e0-08dbe456c2be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ezrAodH1nWQ/NmOxkNYpMByIgKh8awixBGm5x/GBodajS+Z1KHyPBjmvtwOlVekwMvPpBLa2l4L8Jp1g4YmThRnFAk5qxnBKPHiTJeZC5lU51ex3peO/vG7ggc6qMnTyNlNVx27Q7i+gfdQ/co/7Qu6AU7vjzeCw9sebxM4Eu87O/m1RkBVEZNVPPk9Cc2dX/Wf8NdRyyDc3ixlEP8Lvto2F4ZALLtrvG5OBrRu7sdTSCsy0lai0JhFEtk/Nl9Ezq99KUGEfGg/+xklnSCw2ojmQ6c8ohNVZ5kobtSWsmXMpGAMcQOQ0r6XouJyQCSq8dOSmMk1nfvRylro11XVdpovogN9eXXTO8YoWOCPipYl6mCMKqw42GmdYsi6JDnppnorlbrnQ4A2nhu5xb61aaA/TwOJsJH3Tl0I5JN2Grl3zfTrkDPJSsohUptyDLtq2WGSnrSOf55ZE7q2DapCrcJEUG7n3taI7F2PW8bYxqpRzK87mRJpZSTFWkZScjMpBkJHvkSLbJJetdOTFD/YomWekQlSabw9X4VMmM1No3VwRlTF7kcudoQn28A/fJA6L3zHgNNecBY+V3WivYQx5rJx6c6AjIfnhVQc6FlSRbRDaKyCYbH++7MMkQw3IqIWHS4L3Nyez04CuAVGqOixbNA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39850400004)(346002)(366004)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(26005)(6506007)(53546011)(6666004)(2616005)(6512007)(83380400001)(4326008)(5660300002)(8936002)(8676002)(2906002)(41300700001)(7416002)(966005)(6486002)(478600001)(6636002)(316002)(110136005)(66946007)(66476007)(66556008)(54906003)(36756003)(31696002)(86362001)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1JyU2NTSFMxWGs1c2N2QlRjVFAxRTI0M3VSZ0UrczcvMzBVZ3hOeklNVnJU?=
 =?utf-8?B?RFpNTjdsdk5MVk1wZXF3dXluN1FMS29rNEtTeHV3cmpYdlpPY2xrOC9rOU16?=
 =?utf-8?B?VTZRZTdhdmNyb2ErM1dVS0w2a0thZHNvQkVQaU1vSXZLNkRrYzUxMVVBa3Fa?=
 =?utf-8?B?U2VEUmJpSkx2a2xPekQ3TlZRbFNCbGFEZ0dVV3k0aDhPb2prb0tuUE8xdFNW?=
 =?utf-8?B?S3docE9rQml4OW1hSGdzMHNaTFQwZi9VdTlKN01ZNkpQU0FJR1hETUczbUtC?=
 =?utf-8?B?YzhJdFVYUllTNVBOdVYzU1hSZmlId2pRVVBDVmplU2tqTXQyUCtWL0o2QzBB?=
 =?utf-8?B?V0hqalN5b3VVU3dhTkd4aGFyY3NXeTROTk9MRGszZFZJd3hwWW02RnQwcENn?=
 =?utf-8?B?VnVJVTJBLzJPQnBKOVhwYkJZSC81QkU3Z1RlWnRVNHE1OHpkdFRqbFVkbnlh?=
 =?utf-8?B?U2RPdkJrVktiRmoreE9wNUtaRVhtWWpvdVd3aG9qdldvb1pnaVEzU1dFamFV?=
 =?utf-8?B?L1M5bGhFbGxVWFBCOGdOcDB2YUt6WHZYZW9EcjNJdXByc0IzekpQRlhzL0dI?=
 =?utf-8?B?dWJHVjIwYVBjK3lFeWpOVXpIcTQwVFdBMHBickRXK1lwZEE3L0pGVWJna0Fa?=
 =?utf-8?B?WUxpbTVjT1I0Q1hUTWczQVo2eXlHRUQyWXRWVGNocFdZdzB5WDBNOG1WK1dY?=
 =?utf-8?B?UXdpYjdJSUF1QXhLUFpyVDNIbjhwaEI2blE0b1lrQmIzaU1meTNNcThpdm13?=
 =?utf-8?B?T2dtMU1pN3VBbGRYdEVFTVN1RmUyRit6ZmpRQzZidkpTM2FGbTIyMEVqcGQ3?=
 =?utf-8?B?M0svbmxtaDVxMGFtT0xWNXlLazJYbVhud25vVEt5d2hiWWFLV2FhODZKSXhD?=
 =?utf-8?B?aE8yV3BuUTBwUVhvQ0VIOCs3ZVdQQkpIUC9pR3RNR3hRcW9GWUZzN0JMSmdN?=
 =?utf-8?B?S2xyNFVTSzE1eGdXanRRNVU3Y0NzdHYzem94Mjlkb3FCMzM0a0lYVk8vN2Vp?=
 =?utf-8?B?MU1ZNStlZGpuVzVMKy9TMlFSK1VPVEJ2QnBaTVRUSUlHQWNVaW1XcGdLQ25C?=
 =?utf-8?B?end6OEg1aXl5ZEVmelZDNVBmMERkelFtWTBLT0daYUJ2L2NQSHpYYlROSTNT?=
 =?utf-8?B?NSsyYlVnREJMajhHa1N1bWpicHVML0tOV2JpL2x1NzdTQnV2MkRBQ2YvVUd1?=
 =?utf-8?B?TVNhYkh0UTk3STVaSktSSzQvQU5qYmhPZFEvbWp1VURWRzZNWFF0ZE8zQ3Bh?=
 =?utf-8?B?UlRsUW1Hb3g3S3p0TUE1cU5MNnRzN0JaeFZQUFppZXRpT013KzM4blJ5KzZJ?=
 =?utf-8?B?YVFRNHdzL2ZsNm1JUkZiVWxRN0NIRDAwKzArcEd5a0dHTk1aQmxPM0IwTEVT?=
 =?utf-8?B?dXorT0JSWFlRbHhQMlIyaVI2YndZZVdzT3lYVXR2K1hYa3hHQllZZ2h6QlpJ?=
 =?utf-8?B?ZmhmQzhDY3hNTGxkbkNlQWFqWDlTSjhvTFliYldrWmN5eVJpVXgxWDFZeFEr?=
 =?utf-8?B?STUzWUR1SUZ2NFFFNzZjTGc1Ry85WlpNMWFCaTBlK1FkSU56eVAwTlovK1My?=
 =?utf-8?B?ZVNxUVB0eVkxZlRSdGI3TkRlL0o2RXQ2djQ4Q0xzSzdkVE42SmFWRTRpSi9P?=
 =?utf-8?B?Qkh3SEovZDdQQ0kvMGZHLzZDTThCRWtHWjg3M29aNVpNYjVNZ3praGlhdWps?=
 =?utf-8?B?Zjd2Q2FIQm9XaFR4VFM4WVU2RzUrTmlhN3JXeE83eEZoR2szMUtJcGxFdytx?=
 =?utf-8?B?cHh4Qi9QaXpLV3BWZGExMncxRUc4R1REV2FtUXg2UnZPaEt6MHVnUGR5dW0v?=
 =?utf-8?B?K3VXOFpFWklUY0hMN0luNE9xRVZLK1BYTDNrR0dMVzgxVXVSZ0t3OWZ4cU55?=
 =?utf-8?B?SnlYQWF2ZytuWDBQVE9saEY0NWdKNnVYV0JRSDJrT1FnQW10ZjhDZVdYTkZn?=
 =?utf-8?B?SmVqeDNtb0EyU0RlNkFNWUZrdm5qN2k0YkNhOW5FZHBuUk5EUGdMNWVUZW9x?=
 =?utf-8?B?YXBucE5RWC9kdUp3OVpxaEJWZlhKY3htQnNkQ3UrRjRUdXl1M2ZXTFJnRjlL?=
 =?utf-8?B?VGhkajFBRElFU3EvcVNiNjZRTjF1M3BqZ3lPcEp6cHZxdDZCN2wzVTNiM2No?=
 =?utf-8?Q?7d/g8nz51E0XnhH/nTlTPoaYC?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1effe53a-2c6e-401a-b7e0-08dbe456c2be
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 14:42:28.9994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBRcORO6c7CeIM8NHMWH4ZGpFEESSARlg1RYuY3Y2O00hTFeDM1YRJ5qsVLIaBQdbBJ4jlvsMBzRPINAMXqjOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9388

On 11/13/23 15:14, Dongli Zhang wrote:
> Hi Denis,
>
> On 11/13/23 01:31, Denis V. Lunev wrote:
>> On 11/10/23 01:01, Dongli Zhang wrote:
>>> On 11/9/23 3:46 PM, Denis V. Lunev wrote:
>>>> On 11/9/23 23:52, Jim Mattson wrote:
>>>>> On Thu, Nov 9, 2023 at 10:18 AM Konstantin Khorenko
>>>>> <khorenko@virtuozzo.com> wrote:
>>>>>> Hi All,
>>>>>>
>>>>>> as a followup for my patch: i have noticed that
>>>>>> currently Intel kernel code provides an ability to detect if PMU is totally
>>>>>> disabled for a VM
>>>>>> (pmu->version == 0 in this case), but for AMD code pmu->version is never 0,
>>>>>> no matter if PMU is enabled or disabled for a VM (i mean <pmu state='off'/>
>>>>>> in the VM config which
>>>>>> results in "-cpu pmu=off" qemu option).
>>>>>>
>>>>>> So the question is - is it possible to enhance the code for AMD to also honor
>>>>>> PMU VM setting or it is
>>>>>> impossible by design?
>>>>> The AMD architectural specification prior to AMD PMU v2 does not allow
>>>>> one to describe a CPU (via CPUID or MSRs) that has fewer than 4
>>>>> general purpose PMU counters. While AMD PMU v2 does allow one to
>>>>> describe such a CPU, legacy software that knows nothing of AMD PMU v2
>>>>> can expect four counters regardless.
>>>>>
>>>>> Having said that, KVM does provide a per-VM capability for disabling
>>>>> the virtual PMU: KVM_CAP_PMU_CAPABILITY(KVM_PMU_CAP_DISABLE). See
>>>>> section 8.35 in Documentation/virt/kvm/api.rst.
>>>> But this means in particular that QEMU should immediately
>>>> use this KVM_PMU_CAP_DISABLE if this capability is supported and PMU=off. I am
>>>> not seeing this code thus I believe that we have missed this. I think that this
>>>> change worth adding. We will measure the impact :-) Den
>>>>
>>> I used to have a patch to use KVM_PMU_CAP_DISABLE in QEMU, but that did not draw
>>> many developers' attention.
>>>
>>> https://urldefense.com/v3/__https://lore.kernel.org/qemu-devel/20230621013821.6874-2-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!McSH2M-kuHmzAwTuXKxrjLkrdJoPqML6cY_Ndc-8k9LRQ7D1V9bSBRQPwHqtx9XCVLK3uzdsMaxyfwve$
>>> It is time to first re-send that again.
>>>
>>> Dongli Zhang
>> We have checked that setting KVM_PMU_CAP_DISABLE really helps. Konstantin has
>> done this and this is good. On the other hand, looking into these patches I
>> disagree with them. We should not introduce new option for QEMU. If PMU is
>> disabled, i.e. we assume that pmu=off passed in the command line, we should set
>> KVM_PMU_CAP_DISABLE for that virtual machine. Den
> Can I assume you meant pmu=off, that is, cpu->enable_pmu in QEMU?
>
> In my opinion, cpu->enable_pmu indicates the option to control the cpu features.
> It may be used by any accelerators, and it is orthogonal to the KVM cap.
>
>
> The KVM_PMU_CAP_DISABLE is only specific to the KVM accelerator.
>
>
> That's why I had introduced a new option, to allow to configure the VM in my
> dimensions.
>
> It means one dimension to AMD, but two for Intel: to disable PMU via cpuid, or
> KVM cap.
>
> Anyway, this is KVM mailing list, and I may initiate the discussion in QEMU list.
>
> Thank you very much!
>
> Dongli Zhang
with the option pmu='off' it is expected that PMU should be
off for the guest. At the moment (without this KVM capability)
we can disable PMU for Intel only and thus have performance
degradation on AMD.

This option disables PMU and thus normally when we are
running KVM guest and wanting PMU to be off it would
be required to
* disable CPUID leaf for Intel
* set KVM_PMU_CAP_DISABLE for both processors This would be quite 
natural and transparent for the libvirt. Alexander will prepare the 
patch today or tomorrow for the discussion. Den

