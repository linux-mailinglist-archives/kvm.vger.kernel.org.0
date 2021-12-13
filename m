Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCC1472A89
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhLMKpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:45:45 -0500
Received: from mail-dm6nam08on2073.outbound.protection.outlook.com ([40.107.102.73]:21857
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233775AbhLMKpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 05:45:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+Jo6HIcki3zm4NsW1QLsIroicr7wxMz4D3S6Zl41U3FLO81/LmW0fd/q/oMZhN0ZjJyR4H9LU4CCw6cqzoKQi6l82hldKrqTGZqOK0YZhmW0s5sAQujnuflQqZ/H3eJ9a35Su5r0SNkrcvTK7DiIwrSdJoqsvbgi8SebqHjvqWVJJEWGKEAROSeM7rgJKsR2dNSEYBxENO28zF9N30ZbQK82CLOolQ//XJ2j+zkxhcAnd4SqCPAXAqaeTCV4tRJLMo5uTv7+CyoAY0RmX7rei0dY1gANuaWHQK2BPqLLrXjaLGNKGs5QcGaaC+xuQp9UYg11qKTuQmdCR6n35fR7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xvMtt+Z5kVGA6jlJLaMnP3lz7nbkFBKbulHadUwfmRE=;
 b=UAhEibTCDsCA3VI+s/+vLPeRN71gu5LfKuhNgDgzI3/vD+nORvN9LVzY+/x8PFl+Ne7j9mGv+REKBbgu9dT4jz7gcIbhDgt0Ri4bYKWkp5k9WouQvxV7LzkRz1LOiM+9d3EoKYDT+SpOQQdB9grRiWSsCS70XAAb4KsKMdWkMEZF0jH71eohHyUR6xZGLc6VHy/SjvX9bIa+5Akk/yhU36nu1zWZgUWr69u26qra1qkUAFsi3Vnjm1AseWwPvUhxcw1Q2l1k/hTxHeM3vxyUBTYlTul26xsaRopbtyZ8XSw/rYZKDo7hCtOgRZOKObGCi10TdIy5TQFRkNmv6nyOug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvMtt+Z5kVGA6jlJLaMnP3lz7nbkFBKbulHadUwfmRE=;
 b=Pn5NAElxE7LwgC9aXZ0Yarjh4WdWeXAOh8lwucN3myX7S4Sex2ghYNvMaNVsECFs48mtObuRZw8EjBbIQr4nrpQexZCqATj3gaB0KjCz3BM9l+XVHQ8IkYJkrBHP3HzDVyDxVorxdSO/KEFocf/RHcxX7Ek8BC197j9PoxMk1Xk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Mon, 13 Dec 2021 10:45:43 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::548c:85f1:ef86:559e]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::548c:85f1:ef86:559e%5]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 10:45:43 +0000
Message-ID: <e45121c3-57e9-a7fe-4bc5-762f3b62e40d@amd.com>
Date:   Mon, 13 Dec 2021 17:45:28 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
References: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
 <20211202235825.12562-4-suravee.suthikulpanit@amd.com>
 <7dd1e7d1510f17f1140b7174dd42fed752eefc38.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <7dd1e7d1510f17f1140b7174dd42fed752eefc38.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1PR01CA0018.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::31) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fe302e3-52ee-4433-f0bf-08d9be25b611
X-MS-TrafficTypeDiagnostic: DM4PR12MB5279:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB52795D31FA675EF17A38F4F4F3749@DM4PR12MB5279.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4lbZVyUqzwVOrEKSwK42ac4LSH/4p1X4a8IW90QMbwMyPPRk7qfXKJIQFr+tt2AXp54tTwivaSWiuus3zIZ/Kif1iufu1DvoSIYZDocCyQfywizik6QAymnDcyHD9wi7NGoPE1OJo1r0fFasML06uxtN1t1aWwm0APqoEMWMSTkhO2WkS65ztkOrOlrO7O53gEiZylgr+NrmyfL/JL5Eere13R5QTJde/KEpZK1S0UoJYqAGLz+UsuPRHRn3b9w1XjM9nOnmYfgLfuCGNlFnBSBNTa5lCGaIfpzZ3/8J2+KMBWW5S+YlVLTZht3fYbo3n1nQZdbHLMi1N5CQ8AMyckgJbKDwmR01zE4Ct2ukat1ZuSe5ymOCAfavK3A9NW+4SoJ6dzBljQylyZuGPrCFIghxHrigfq8FM03xAjTKkUffh3+xh4Hl2BB1VRqbhQLq1IEK7A2wBFZGyt50rEsaokDwGMMxsjORdrnGUWdceO5YYCHFlQj0XHXgyCOTS74U/Qq0acjTM3YEmNhZqsBdbqFmnhmE+RIbzgAenQKebpZvR4elgam85o9i0izsjX2rKx/7/sfuDq7Di97ilQoKvoZA8MMcwTKOn3k2qLcRz2ENCtUq+Qs+TUgShZu/vVQL33JJLgnJm16dsfklQxr2nPyXEND7qh2foHtMXOWrE57CHaq6/XlnLmuh5xLU75fzy32uql2YJksJCXavgxM66AdlugtFfBamoFy+SDRrHQIgZ0COKuxr07hf+pWPSoO3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(6666004)(4326008)(6512007)(26005)(38100700002)(66476007)(31696002)(186003)(2906002)(558084003)(508600001)(86362001)(2616005)(31686004)(66556008)(66946007)(7416002)(5660300002)(6506007)(8676002)(316002)(53546011)(8936002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGNFV1B0d2RVRlArNHp2QkpFRlJzQWwvU2J5QyszdTA3cHN2Z1o1L2dGbXZM?=
 =?utf-8?B?UzRFV0lPSUs1U2NsSnJRdVdDQ29RWlhwT0FtNmU5Y29JSFc1VWZNV2xURHd1?=
 =?utf-8?B?S0pON3FMb2NoV08rQkJaU3d5VW8xUjM2OFFJTWJzK1JZeGgrSHZmY0l2NHRK?=
 =?utf-8?B?T3o1U1Y3ZHNpN3lPc0R1dzF2akVIOGlLU2VmaTA2QVJkMHJyM253bExRVkQ4?=
 =?utf-8?B?TmJ3Uk03YkZOLzVOSnNabGVIT0Z2RE54N1E3SWNMdkY0MVd2ckF1RDZBU1No?=
 =?utf-8?B?L0lpbXFJTDNMZWxNcGpmUmhJMlB2NUMwZjllc21oTEtpNzFIOGpHK2Q1YmtQ?=
 =?utf-8?B?NG9zV0x1TmlzVFV4RXVpZTd0NWJoT3NVM0ViLzBwTVdsMGJqbkFUeWxqRTZQ?=
 =?utf-8?B?NzVVNGxvZytKZkpOK3NFNHpQUTZpRlhwdnZkMTRjcXBaS2o4aWVSSS93STly?=
 =?utf-8?B?dW9HTDNqdjhpQTNXQnRGaVVtNEwwc2s5OVVKKzdDOGMyNXFIM1BkdW5ReXN4?=
 =?utf-8?B?d3pPQzh5bnJtZFRDNm04a20wektpZjVDZC9JUlBZV25KZlBwNDJ4YTZ1czR1?=
 =?utf-8?B?b2tFbVJHTTFZVklHZk14aTVLY0RDdmw5cFROYllkTm9yMW9Sdk1RM2I4cUV4?=
 =?utf-8?B?ZUVNNEVTUm5hT3B3aUdsQVN5V1ZuM0FlekF6Y0Vyb3JBem5MN3dnWlpxdlB6?=
 =?utf-8?B?S0l5d3hOT0lkZmtLWjh3amNocHJ2SEVOQThwN3pneExQSGNKY2dWMFJFK21S?=
 =?utf-8?B?YU5UblR2YXZLSW9iUmRJd1R6RUJnKzRjNVlBaEtaRTNzQzBBa3ZWRnFicVBN?=
 =?utf-8?B?UEs2bG1kVlFBUmp5UEgzQkRiajlTM0FIV0hqYWduWVpMMEhUam1PaGhzOGpV?=
 =?utf-8?B?L1hkaE0xYlFhQnhGRlkzaklVZkp5TWJKQm5md0xsWmcwRFBSZzZqaGtlM1NZ?=
 =?utf-8?B?Y2wrcmJFTHdGaWdPN2h4S2xEV3lFZUdaOXdYNzMzbUhYNDY4YWE5dXNEb3Vm?=
 =?utf-8?B?ajU2TEl6MDNJUU9sQ0ltZmw1VTZFTWdnWHpxQTJkVjlDb2V3WVFXa0Ivc2RE?=
 =?utf-8?B?QW50cXV2R3Y2WjcvYnI3VVBaYk1Qc0hNTzFyNlJOVk5GV1AwZzJESmI5K2xQ?=
 =?utf-8?B?d043REVxNnNsNlZtVEwybGtmRnM0VmdiWlJodS83R1RkSENrMHYxd3hrcXNF?=
 =?utf-8?B?U2FvSGhkTXcvbWd0ODZvQTJIVFpac0JOcUlFZnc0ajhqbmVMcTVYV0ZSNlRF?=
 =?utf-8?B?QjRSbkJFek5pWStOUWZhZWdUc2lTaE1zVHZIZlJJekFwNExBbmMvYlNDSkt0?=
 =?utf-8?B?UTVKWDhZZlpWSldXUWFwdlpiR2o4Z2k4TUpRR0xhVmJGNmVNRi84WkZTRFpv?=
 =?utf-8?B?OUdOOEl6NHhBNk1pUUg4UlduajhBbFJjTFRyZVJreEdja1UrWVlEci91dDJI?=
 =?utf-8?B?VUxNU2ZLckdEY1lXRkpvSjc1bGExUnR6bnlkZWM2cUt1cG4wZ2w4MnpLbEpC?=
 =?utf-8?B?Nm9CN25sK2JSQ0psc1RKSWpGWXZIVlRCZS96ZHo4cnhwbnhSRGZRNndFaTlH?=
 =?utf-8?B?UlhkSWRraXNZWlpDblhDQ1hocG01cTA5TDZxaFZRdVFFcXoreThBOGgzOGZV?=
 =?utf-8?B?U1dINTNCVmhYS2EzdG9xbm5JS1ROM3luTGdOSS9aaVJ0UnA2VUFNTTJWRWpz?=
 =?utf-8?B?ZnhrdndjUjVac1VnK2RSQTNOYVJObHYrMjM4UTFvcFdNYkFCK295VW45VlNu?=
 =?utf-8?B?WXZOdDU4SzloM0VpWGd2TkNXdWZCZGcxNUttUktuc2k0TCtPY3FETW0ybHVD?=
 =?utf-8?B?UUZJaTRTNjJBUlM2aUh1ZjlRTGY1YXl2Nm5GU0FlcERaUW95UFMxOWFmOXZj?=
 =?utf-8?B?dzM2SnZna1dBdkYrK00xQ2wxQXdmbk01RWxKeWZaMlB2cVBSUkZGY2dXNkNy?=
 =?utf-8?B?WWphcjB4V0g0REwzK3JzSlZ1cWdtaW9HL1M0L0ZaNmdPWUltWDZyTVhHY2tU?=
 =?utf-8?B?TS9sYlV2N25qeC9VQlkwM3poSFArZGw3V2drY21KcFR6T016ZWM1RFp2ejQz?=
 =?utf-8?B?OVljaXF0c2FhOTUvYVF5Tzc5VVAwK0h5WFE1QUhEaldJT01sZUM5WHRFdmsv?=
 =?utf-8?B?WCszWHd6NEtJa3NkYVBPQmtheVVvOTgrWEhZKys3eGxWZ2VBeDRqc1ovZFU0?=
 =?utf-8?Q?c4hXrFnTc8pxSYABmmt4pUQ=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe302e3-52ee-4433-f0bf-08d9be25b611
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 10:45:43.0144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OAApMZtgzrQs4lekjkUAClSOa03mTB2bhaiOWqrOVaF6n3YSy+KNAdJWQPz0URDCMshcZMeG20fcdZ6emhdioA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5279
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/2021 2:46 PM, Maxim Levitsky wrote:
> 
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Best regards,
> 	Maxim Levitsky
> 

Thanks for the review.

Regards,
Suravee
