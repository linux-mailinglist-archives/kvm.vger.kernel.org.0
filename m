Return-Path: <kvm+bounces-1588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C18187E98FD
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 10:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 711C8280C35
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CC51A5B1;
	Mon, 13 Nov 2023 09:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="TSHYAapd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3B219BBD
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 09:31:16 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2109.outbound.protection.outlook.com [40.107.15.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4C010D4;
	Mon, 13 Nov 2023 01:31:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhpXwpJyk3I2iJYlPMfGzAGGqPWfQo3zTvIYYikoLP05aGSnrn4JajzPRqwRXGyrf/nZ00KNGI5iA/pWzvr8JKaKCkZIX4v13U5P51Snlel69XCfSHHZ4NjRvysaCwM5UF+PSQNAkp2eIkiPyrxxYsQ58uXWSjomQ8jo/E1tMyRh9g0fSMVfE1GnGvTMPcB+CO95bJzxSeh8I/jvaQLxmiGcuRGNDkLCBZHV8agXxW319cO86issiRWtJ8Nxug7M0KelI5n4NyRJvzM6AEPMy8uuN/Y/rDGfpsVHkiJNti1Jd7gmb4x+StnWa6bfqAMOBdmSg/VSlzls7ukO1Q4XhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqGJyByzRxj6lY/Qgou17pyg1qVsLAEKPCqSWmNZzTE=;
 b=Bz3FxZse56ngh9HwI2Ilyk0jbMG6v+745hB1YFkqeJbGSuRkVdTU+0All63lEcZ2P3Lf568C7M0WwSRuzx+TLfdQAoeH1ffcDFtdW4ZtTw+ukK8uZqHS8NRpBFtvOK+a4HZZmggJqSNCygo17qEmwxYmWISR05xQxNgvWz1ubc036F5IxfEZHFCN3V/e95o0FPJnDD1FpUWt72zEIbGQHGlWqgymgHYBT1yeklp215RCUxRTXmeZIPEp+bi+0C26uaHeXuvSI9+ysrS9vO4MVDbwVJAI6EMoO4nlLLbcjsqLm09cE1ug/eXiVPDGHHniDRojBwFy6ZMeFF/s0Rj8BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqGJyByzRxj6lY/Qgou17pyg1qVsLAEKPCqSWmNZzTE=;
 b=TSHYAapdVOhr4/FPrpf9xY/oReziUjCJd2jinkJAyHCN78kfDL06O5Ow9COg8sZ4yDa27RKdIOuiLQPURiQP7tijRlhwiTWb5mht5gcIw3vKjeB02U9fCMQKpl0peSf9ndq3RnCzXBB6ol7U0T7MDWoUkc7skykEq62swws+GVAWx0HDj52PSGISCPIhLIR09NO16lRmGL00BDtDRO9RTNjWsHnDBEjOawJ1sHGFf8hn+Y6hfG7O0wlZAXzNlR2S6RKiEXCZJk5OMGprID8TGZWoNL0VY+omlo5bPwqJpmyuEAc2bHdIjji/TSstMrJF/VXRdlcQVbmAL1qlw9Wakg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by AS8PR08MB6325.eurprd08.prod.outlook.com (2603:10a6:20b:332::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 09:31:11 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::46ee:1c5c:2cc6:b1fa]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::46ee:1c5c:2cc6:b1fa%4]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 09:31:11 +0000
Message-ID: <12aa9054-73cd-44d3-ba76-f3b59a2bdda3@virtuozzo.com>
Date: Mon, 13 Nov 2023 10:31:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: KVM: x86/vPMU/AMD: Can we detect PMU is off for a VM?
Content-Language: en-US
To: Dongli Zhang <dongli.zhang@oracle.com>, Jim Mattson
 <jmattson@google.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Alexander Ivanov <alexander.ivanov@virtuozzo.com>
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com>
 <CALMp9eSg=DZrFcq1ERGMeoEngFLRFtmnQN6t-noFT8T596NAYA@mail.gmail.com>
 <09116ed9-3409-4fbf-9c4f-7a94d8f620aa@virtuozzo.com>
 <4a0296d4-e4c6-9b90-d805-04284ad1af9f@oracle.com>
From: "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <4a0296d4-e4c6-9b90-d805-04284ad1af9f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0266.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::33) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|AS8PR08MB6325:EE_
X-MS-Office365-Filtering-Correlation-Id: ddebce1f-657c-4795-049e-08dbe42b45ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RedUBXPHaGm4j8S86M/+CIjqjLOg5/N/QsdFUxHq3QGNjR2CkFUDJew94xJ0I5xc2B2Ae+boSJkvoNYAJqsKQsmD5dLx8YE+wAgkB3I75j9EAiY7VpPa1zHfTtMz2YqTSZMOwLCiFwH1F+9q7mD8eZPMPwcbyOHhLPfYcc63+5BaRFz3l7E3yYokJ2LkdEV4dGQT7AoOlaAgDXtJgpQBjWN6zuAC0GbTNFdh/zV4WMoTwQrRwFlOeSrd73x9yPvUAT32/LVIpYHbZoigwl3R1+oYuBLRqDHaOlUXscxAs0tV3z+Auzm1sfzqu0uAYowV7NiDA2sQPLeibMHUFyL6uxvkuM0OyT5V/s4KtVvPkHcjBrugGAxn+7kT0RLYp4lo0LTNBbVQrcdn3QLDs0V41QFDFQwDc9xM4wFKk4Cmo4c7Z3RxWmStg4bmIO7xylEDmtghim4FurGot/bgQna8ZrwF1ghq6L1iAAIkbpXV3jARD1Z2fj9974fLi13WPxW91aeP3N34lggVLF++ZigIY+VmmPjUebUn1IQYQbGstVlMseGlWysswxjZwv+YHhvvKksOc7yRi4a79AcgbXQ0XclwPGgS3SGA3Gv5Dyy9pH34/kjja+hn/47Bil7wSe8m08h5gU3IEhoSof/2UsUSjQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39840400004)(396003)(346002)(376002)(136003)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(2906002)(7416002)(8936002)(8676002)(4326008)(5660300002)(83380400001)(41300700001)(31696002)(86362001)(966005)(6486002)(478600001)(6506007)(53546011)(36756003)(26005)(31686004)(6512007)(107886003)(2616005)(316002)(6636002)(110136005)(38100700002)(66946007)(66556008)(66476007)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1pKWWVoUE93ck5oY3diM204aDB0SUlNWGRpbGdTeGpmdWx6a3FSZXMwcEJ2?=
 =?utf-8?B?eWdnMEJ0YVFocHBxZmJMSUdiSTlYNEUyNFI0MUR3YlN3M3E5WkxoUHZVSi8x?=
 =?utf-8?B?RHBXMTVmRGR6TzNtY2RPZ201VUtOOHdqL1AweXp3ZTRpWWt2dXh3N3NxdEZh?=
 =?utf-8?B?MUtpczNTb1NNNWJRTEk5dm5ZQU4yNmVlRFlPREhPeldtT2hmTzJyWWw5cHM5?=
 =?utf-8?B?NG45Vmt1N2lrL01uSDAwQnd4TlFJZlBIU1BIZWdONzdFd09nZ092R3VoSi92?=
 =?utf-8?B?eXY4SmR3T1BDZVMzcWxDRGRvaVdOeEFlcTZnY0NFSEJ4am9GcDdCU0FXWGM0?=
 =?utf-8?B?dnA5OHBmYjJ1WFR6Y2dNbTg3YVB3WjNTUmJ5SDRBL1FhbkswNUw5bWg4MkNn?=
 =?utf-8?B?RTlVTVhQRUtyeFdSOUYwUHJwdmI5a2RuLzJ2SjBrQUZuVUtIOHhBdlhOZjAr?=
 =?utf-8?B?T3VSVVJMaUVkQ2pZK3lwbjIxNkNhaURkT0wrL1p3NnNCZXkwK3VVejFhVWhx?=
 =?utf-8?B?QjB2azN5eGpQM3NQYkdGeDY1VU9vbDhVNE01M1A4VEs2QVI1RkZPdkZqdUNC?=
 =?utf-8?B?VEFBcjdoak9kN28rUWVpL2tMSWhGRWRNMlZXOXg3bXFZb3k0SHpsYmlVYXRW?=
 =?utf-8?B?WDlKVnpRT1VSbmwveFRxWFZwWStxTWxuTHllcWxBajhDUkFqMVk5Vy9pVTJV?=
 =?utf-8?B?bkVUbDB2WlJtMERTUnlOVG1MTGUxcG9aL3NQVGMwelo2ZjVuNDdrdzE4b0dt?=
 =?utf-8?B?b2ZNd0kyTlJzOThWaW0rS3FGbUdvd09uazZTNGNHWExRalE1eE9ndzlPNnZY?=
 =?utf-8?B?YzRtMmhYZG84L2ovWDM4K3NjZ05RVTV5Q2NYS0VSRFljZ2pocmc4VzhvWlpK?=
 =?utf-8?B?b1BndzR1d2JZRm9Fa3MwYldRUWtTTEpuWE84L1B5bGxBWnF1U1ZWenEvdHVS?=
 =?utf-8?B?azRvM2h3eDdOTnVNM01JNGpoM01qSHBMeVZDNXVPYVN0WlZPRDV2Nzd2U1Zr?=
 =?utf-8?B?a003SUxPVUgxWmc2M0ZYK2pmMmNtMnV4K0JhMFNsc0xKQmQrQXZxRU1rNVlu?=
 =?utf-8?B?MU5PeGp0SmVGc3puTXdWNEJuaHJMZ2dlWFB3ZHdlYlJJZkt1RFpjdGpYTmlZ?=
 =?utf-8?B?aGs5cUpacDFBbUg0MHpyaTc4ZElCY0Vsd1FBeWhQSEl6SllkbWp6ZXVkU3RY?=
 =?utf-8?B?bmUrV3A0UzJvMHlJM1RtYTNCR3dZcnd1ZVVubVlXOU9oMHRxRnU5dWVnVE9O?=
 =?utf-8?B?ZWt5VGVmTEZpbmdua1piMWFUK1JvQSs4MEs3YUU1Qlhza2U2c01jUFF1MzVp?=
 =?utf-8?B?Wmw0anBIT0xwTHN0T2FqT3hjNFNEdlluaFZsSTJnSUVjdmdaV2YvNU8xbWo1?=
 =?utf-8?B?bzNWalFPZHRFQTFKRDZvb3dBR0tkOE0zYXJiU1p5VE5tYS9QRktjK0dFWUJT?=
 =?utf-8?B?TzZIVHNFSC93RUZSZWx0bklDcFBBVjg2NkthSGNwaGVwMHMyd01HV05mS08z?=
 =?utf-8?B?MHlrSFMrQ0gzVEh5MUlzYlFnbmxEZzdteXVwU1ROWndSa00xWDNwQm9LSHFK?=
 =?utf-8?B?N2R4WUlGdU5NVTVyKzVTUWsxSnNqRWhXZ044ZUJDRkU2bFpEV1FHclB6OThv?=
 =?utf-8?B?NENvL2w5WEN0ZzcvZVl0VGNNd3RUb0VuVmh4MVVGTzIvWmluRUF2OE9Ob01Y?=
 =?utf-8?B?K1c0WlNGZ3RzVFNkeTBCMkpuUjNxd05vM0Q3Y0RMR0pIbkI3bGlUWkNRWUxC?=
 =?utf-8?B?TnN3STBPM0F4TzU0c3hQZXJ6MnBvOU0zTjNGcUVLWVoyQ0VsYlhBR0ZhU0Fa?=
 =?utf-8?B?WFBrQkJYN0ZFb1R5TFhMVzB2aFlrZjdxYjQrQ1hlbVJnQ1c5SVN6K1A5R3Qy?=
 =?utf-8?B?UEg1NlpqMjI0Z2o3YlZYM3ByWXVMY25QdVdVcDJDajhVSGdPVXozUUtweGR5?=
 =?utf-8?B?bXVaMi9xeVMwT0FSZ08xWjhKT3hwZ1k4MWNIT3gyWERMdDJTcW1oMEphMGNq?=
 =?utf-8?B?eFRvZ1BrTnBLcXFnR3o3YnZCem9XcEdNbkYxblNLbnF0bzRicm9WUHQvV3Q2?=
 =?utf-8?B?WXRnK3F6LzNINWozWnkvUnFKb0t0NGtRSU9DRzN2cTZBdExwNDRGUzJtbDY2?=
 =?utf-8?Q?yhkNFDp3sEdoh24kYxCUCJqty?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddebce1f-657c-4795-049e-08dbe42b45ea
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 09:31:11.2370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0hwBDAbE3i0ZIhFBRlE3agT5s5ncgEf2094W+lcPRP8Qkj5RusJhXcbWZA9M8tlkSfEb900sk3WGPnMLgbWT0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6325

On 11/10/23 01:01, Dongli Zhang wrote:
>
> On 11/9/23 3:46 PM, Denis V. Lunev wrote:
>> On 11/9/23 23:52, Jim Mattson wrote:
>>> On Thu, Nov 9, 2023 at 10:18 AM Konstantin Khorenko
>>> <khorenko@virtuozzo.com> wrote:
>>>> Hi All,
>>>>
>>>> as a followup for my patch: i have noticed that
>>>> currently Intel kernel code provides an ability to detect if PMU is totally
>>>> disabled for a VM
>>>> (pmu->version == 0 in this case), but for AMD code pmu->version is never 0,
>>>> no matter if PMU is enabled or disabled for a VM (i mean <pmu state='off'/>
>>>> in the VM config which
>>>> results in "-cpu pmu=off" qemu option).
>>>>
>>>> So the question is - is it possible to enhance the code for AMD to also honor
>>>> PMU VM setting or it is
>>>> impossible by design?
>>> The AMD architectural specification prior to AMD PMU v2 does not allow
>>> one to describe a CPU (via CPUID or MSRs) that has fewer than 4
>>> general purpose PMU counters. While AMD PMU v2 does allow one to
>>> describe such a CPU, legacy software that knows nothing of AMD PMU v2
>>> can expect four counters regardless.
>>>
>>> Having said that, KVM does provide a per-VM capability for disabling
>>> the virtual PMU: KVM_CAP_PMU_CAPABILITY(KVM_PMU_CAP_DISABLE). See
>>> section 8.35 in Documentation/virt/kvm/api.rst.
>> But this means in particular that QEMU should immediately
>> use this KVM_PMU_CAP_DISABLE if this capability is supported and PMU=off. I am
>> not seeing this code thus I believe that we have missed this. I think that this
>> change worth adding. We will measure the impact :-) Den
>>
> I used to have a patch to use KVM_PMU_CAP_DISABLE in QEMU, but that did not draw
> many developers' attention.
>
> https://lore.kernel.org/qemu-devel/20230621013821.6874-2-dongli.zhang@oracle.com/
>
> It is time to first re-send that again.
>
> Dongli Zhang
We have checked that setting KVM_PMU_CAP_DISABLE really helps. 
Konstantin has done this and this is good. On the other hand, looking 
into these patches I disagree with them. We should not introduce new 
option for QEMU. If PMU is disabled, i.e. we assume that pmu=off passed 
in the command line, we should set KVM_PMU_CAP_DISABLE for that virtual 
machine. Den

