Return-Path: <kvm+bounces-1391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB9A07E7544
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:46:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42496B2127D
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 23:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1084239866;
	Thu,  9 Nov 2023 23:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="a03e6926"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DDB3984F
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 23:46:26 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2126.outbound.protection.outlook.com [40.107.105.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E056744A6;
	Thu,  9 Nov 2023 15:46:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ugryj+8cXJFReSUYcvsVKEIrQqgM6pGRJkggQbeWYqjWEl/NfZ5xh6F3ONypEptR+MbY1lcyfPhqsqRnnLJHUhPIHEXufPgBSglBDd6fN1LsgQF+qIm+W2kzd8emlhX/UlxEkfOWZVQw85Nd6rI/NDk5yLj24bJ2mmrVe58s/amB9FH++d44Ke7/qghLjCEcnQ6MdbQmeuIgd4j/khFbLdIHm+evFJddN+jLPcF9x+gaGgUNiVE05Q8ljbZW/ZnrNpl9wxVnXs/wcAnPRKmf9y5PhrrB30SxFl4zORobzcadOiMHoag0OmFVk33fVHAK+IGUTkoarPoRuzVQeiHcJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WFu0YnWecryiKC69UvNCHx2yT/yeKW1ULDFBomfz0+s=;
 b=VwZYiktStOPP7CfJkNKZNQA25OWuxoXxbotlarP09q2dJCBBf7gS9+N7BMGwGhcHYLC3L73jZwd1bGoA+wJlBZTtds1d4rZNspu4j4IlFQBhBrwsWWxpvZFFFWDv2DWee1iXAn6r7IMHFcvqUPDPob9HmhUantfk93qYccDHicCPddWtoLrr9gLRvNi3sfasWtfClLa9Cj+hRtKlX8f466Jl1q2rN9Uvfs8mZSmtL4ml2aeYkgodzowVZ2lVOPFsYKFp/a23HkYo5YLjcPnuGsYQHtY3rfsJ0fm2dourTnrXe6OPoQFdBCCxdKcFE80G4ad+V6XWkCA60OLV2LE3SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFu0YnWecryiKC69UvNCHx2yT/yeKW1ULDFBomfz0+s=;
 b=a03e69264f64b4ShEAGq6T5RJijnmwPVbDuib7RoO3mlvUEoniMeV1lJEjLKG6DouVHZdBeWM6R+BzIBtt+sLUvGEtmGfFHy+fOMxbA1ZZU9qAbqXGkyLIEvNVmmWObfCvf7eDcV2jL7dL5+LkgnOOzWjhVcoiOMvjClumjwDiOA+1n9VDNGZ49YZvPmBC4MI/os+L7iIbJGYthWAbFvzr45No2yS+Lr2p2rnJVRwR1SvsgnwPwo4T1UDR5e2ktbrRzDM+2XsA61VWnMQMmZFGcw71SjV6ZVZzbp7IehqgbxuQFHNlAgwXc3oNAp9GrKCYQ0R+Ss2OHHYwgLGx5i6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by PAWPR08MB8934.eurprd08.prod.outlook.com (2603:10a6:102:33e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Thu, 9 Nov
 2023 23:46:23 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::c196:49d8:108c:2254]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::c196:49d8:108c:2254%6]) with mapi id 15.20.6954.028; Thu, 9 Nov 2023
 23:46:22 +0000
Message-ID: <09116ed9-3409-4fbf-9c4f-7a94d8f620aa@virtuozzo.com>
Date: Fri, 10 Nov 2023 00:46:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: KVM: x86/vPMU/AMD: Can we detect PMU is off for a VM?
Content-Language: en-US
To: Jim Mattson <jmattson@google.com>,
 Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com>
 <CALMp9eSg=DZrFcq1ERGMeoEngFLRFtmnQN6t-noFT8T596NAYA@mail.gmail.com>
From: "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <CALMp9eSg=DZrFcq1ERGMeoEngFLRFtmnQN6t-noFT8T596NAYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR09CA0118.eurprd09.prod.outlook.com
 (2603:10a6:803:78::41) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|PAWPR08MB8934:EE_
X-MS-Office365-Filtering-Correlation-Id: 0127e340-ee29-4ff8-d60c-08dbe17e1438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vb6ejeZ6jtCCFHMuaLfL8NpJom1sS5Xu1zz4gdYTtI8od+7V5uX4z5hGeU5F5T+BO8vJZX1RkKS5WWbr1oQDwfvX2YbuawQ7DZWD7hTMbCRKGlSV140Ce8igCahE5ZBN0zZZSZ4UV4doSq8NDbbdxwU0A627Hk7HgokhyHVompLwQoUYuZyTXRBkOJLXUtXSj/pjPotlDQjUl+4sf8iN4BR9hZmOjCxcUM30ZWXx4WIoCeSgPUaODjBs4aL5cn43LOhWRxbLbvgGq661q/olkQpoydaJ+xD2aUi8NnMITfahOc/x5LsbFbhSDTwfm0MrAMxd9G+j8u4fLZ+P2vx3zYQBut50p9ijfBYp7Yr2AUGaeboIvNll7PaEdWUS4wpAlfPSDFRoKyozNt1y+YB3aW4G7+4fkaVxBh2sxaEOgMVRd/QsHHRITLYeRy3tBGxCJgqxoNS9gIdx7u4DuCja8Cs/Rf5q192eTyxd6REYvI3MBCxogzYseKRnOqgYD37s2STg0atPhEZuiWoFd2gTVvxRPubaijjd3sJ9w9eDApN5tqyl2NS26BFum00Fko/2BDQrSGDA8iNX2r6Jk+DrTR+CV2BUw4E3k9jbBZX0dWPxq+72LmFwFILD/9rUzQ7DSD034xhAz3STmqIPycUH+g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39850400004)(136003)(396003)(346002)(366004)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(5660300002)(6636002)(66476007)(31696002)(86362001)(2906002)(7416002)(66946007)(54906003)(316002)(8936002)(4326008)(110136005)(36756003)(66556008)(8676002)(41300700001)(6506007)(26005)(83380400001)(478600001)(53546011)(2616005)(6512007)(31686004)(38100700002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2ZldUl5M0VJcFlqblNNSmtsNnNxTHA4M3h6U0ovaktYQ2RrQ1hKRENhQmdo?=
 =?utf-8?B?dTJ4WllxWkZQQmdBZFBXbi9xKzUyUmxTRjJKeVh0MExzaFltUWJVbzk2ZVhC?=
 =?utf-8?B?TWU4UUxmOFVwWnRKY0lTN0Y4LzAraTBqaGkvdmdCdllXMHQzdkIzMTFaelpF?=
 =?utf-8?B?R3FNeWNRZUhoam9KbTFGUSswVVBTNkVNSjV3UWM1UjVUN0s3Z2pRMVFzQXFM?=
 =?utf-8?B?OXd4aGZmVUxQNXU2VUpRQURUTVVIbGNHeW9hdG1xTEFvbXBvUWhNYi9jbnVJ?=
 =?utf-8?B?eTdyTXRHODRCL3dURDhoVHprODlPK0tuaVdOUTFFVUlvSW9tU0RrMERiZTNp?=
 =?utf-8?B?c3JWOEFIUnRvMFNSbVFWc3U1SlMvSVBaOFNIQTBaeVJFSnBqNzdYRzMyZndp?=
 =?utf-8?B?NHEzWEFwbjhENzhIZDkxaGpIenBpUWIvMDdvaUc5clZRRTFOSENMMXliUTAv?=
 =?utf-8?B?MnNTbURsTlBBY0NRZUFRcFEzL1FOVWFiMVJZNy9vcDYrWU1ENnUycTNUdUZq?=
 =?utf-8?B?MGt0UTZOMTJaODFlTkpQZWlZWGVVbmhEUlp5dEJJODBJN3R4ZmJsMC9kL0Mw?=
 =?utf-8?B?ME8rUHVra2YraE53LzRoN1JzVFczMDVqc2xPSGtEYW5rcFpnZjVtMS9wejNz?=
 =?utf-8?B?cVdTaUdGYWFjNVdqWTY3WmZzcVBnNXVtZFU4R0U4dnQ0TEdMUFVtM2hJb01D?=
 =?utf-8?B?VjA1Y2RJbjNsUlZrNEI4RU5VZWFPMEhFcEtQVEpmTU1KVVdXWW9oajBGN0M4?=
 =?utf-8?B?K3dVbzZla3dGc0E2QUtBS2JLbjEveXJTSDhZZXhMVWwvOWRpWXRLaDBVMVQw?=
 =?utf-8?B?ZzcyN0d6MTBaOW50RmIrZ2NsbmVYeG9BeTBadkQrUWxxKzNlTXNjMXpoMnFn?=
 =?utf-8?B?R1FnNGpCcHE2MlRKaDVySk5Ka3VLcFlwL2laMFBSQTNKQStPM2NHcDR5TjdJ?=
 =?utf-8?B?VjZFaTV3Qm5RSlk1ZzlmTnlybDh4T3RKMTRqUnBzVzlya0VFenV3M1ZteUVY?=
 =?utf-8?B?TUVOazRIdnJJMzhKS0U3c0V4ZGE2NmR0NDQzUFI2SXBISERtMmgyVGY4YXlj?=
 =?utf-8?B?bUEwT3pqL2V6NS9rK1pzNmdYZVEvRmQ2WnVneUgwNk1GYkpwUEw0ZzgvUEQ2?=
 =?utf-8?B?YllMUHdiZFozKysrYTZyOC81bGJwUFlvZUlrSHlwalJGK1E2RlBtN2cwbHlk?=
 =?utf-8?B?SjJ2TzdFb3RJck00RmxxZ3hpdWpnemtaa2FWdVlrOVhENFZiYmRiQWpONVYv?=
 =?utf-8?B?Tzl5MUFEbXFvQ3gwWXV2NzNPK3laaHZLeWJUenFiYmxkcXgxUkVtUGJ5Q3Q1?=
 =?utf-8?B?RUZPbnFqVDE1MFdXd0lEZDhvSDVvL0VDdTE1YkhJQnRDclNEUGFQc1lvNGd5?=
 =?utf-8?B?M3JQd3ZQVDVkTDF5eWFFTkdIS0hPT2RJdGwydGs5eUY0VEhvVm01eGNqQXlP?=
 =?utf-8?B?L1VaWVU5SXdYYjJiNDNFRDFUNHlsTmtnQ1FET0V2eDltaWFySGs5QUVkTlk4?=
 =?utf-8?B?TVNnQ2dmMk43Y2UvT0xkaUEzWllxL0Z2Wnhkdlk4N2VwYlBZUExqeXZsR2ZB?=
 =?utf-8?B?YXpYOGxaS0orQkdEYjFRNFp5UEdKMm5nclduVWk4ajlGMEdPRC9QSVY1dXBU?=
 =?utf-8?B?dGh1aVFRd1NudFo2b0NsMkVqdm9oREFlcGJRK3FXZzhhS1NneGl5WGNoWVNs?=
 =?utf-8?B?Nm4xTlliWnZMTnJESTVJNGh2T0RITFMybC83MVR6UE1qWkNDTnFoME12QkdJ?=
 =?utf-8?B?VUtkVlcvMFByYk1KMit5SXlUTWZ6Y2dWYWVrWEk0TFB1a3ZBMU1OOW1IdWk2?=
 =?utf-8?B?OGYyZG54b1pqSkhud0lVT2VJSEZ4UjBvTEVOU2xKZGxKQjlkZ3JvZU1tcFdE?=
 =?utf-8?B?TlpqYkVURnY3eTNqVHY2YnpVdUxJeW1nU0JmWXZEWW1Mem5MZlprR2pRSUUy?=
 =?utf-8?B?L1pBb3RvempjZHNQSnovU0NQaysyTnRXMGlPNStwajQvR2JHOFRnQ3F1WHpP?=
 =?utf-8?B?TmdHOTBPYkZJRGZsN3ZTWER1eXBaVTg0c1FIRk1JcEVFL2M3dmNoTG4wdUd0?=
 =?utf-8?B?ZFlsSmJkaDUyT0dJa2gyN0tJUzZ1RXBCNWdGM1Rib3E4VTJZTmJtWHozRVkv?=
 =?utf-8?Q?ns6HdUajCRVhxxUrTR0nfGrnK?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0127e340-ee29-4ff8-d60c-08dbe17e1438
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2023 23:46:22.7225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6g4ctqnoJoiCL4zX31ZeNfOUOTu8M/jQnmZK1+en4H1CVO0Ewaoq8WJWjLsb05n66CgQjOGJOin2DWtpqyQg0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8934

On 11/9/23 23:52, Jim Mattson wrote:
> On Thu, Nov 9, 2023 at 10:18 AM Konstantin Khorenko
> <khorenko@virtuozzo.com> wrote:
>> Hi All,
>>
>> as a followup for my patch: i have noticed that
>> currently Intel kernel code provides an ability to detect if PMU is totally disabled for a VM
>> (pmu->version == 0 in this case), but for AMD code pmu->version is never 0,
>> no matter if PMU is enabled or disabled for a VM (i mean <pmu state='off'/> in the VM config which
>> results in "-cpu pmu=off" qemu option).
>>
>> So the question is - is it possible to enhance the code for AMD to also honor PMU VM setting or it is
>> impossible by design?
> The AMD architectural specification prior to AMD PMU v2 does not allow
> one to describe a CPU (via CPUID or MSRs) that has fewer than 4
> general purpose PMU counters. While AMD PMU v2 does allow one to
> describe such a CPU, legacy software that knows nothing of AMD PMU v2
> can expect four counters regardless.
>
> Having said that, KVM does provide a per-VM capability for disabling
> the virtual PMU: KVM_CAP_PMU_CAPABILITY(KVM_PMU_CAP_DISABLE). See
> section 8.35 in Documentation/virt/kvm/api.rst.
But this means in particular that QEMU should immediately
use this KVM_PMU_CAP_DISABLE if this capability is supported and 
PMU=off. I am not seeing this code thus I believe that we have missed 
this. I think that this change worth adding. We will measure the impact 
:-) Den

