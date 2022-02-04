Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4AA4A96DA
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 10:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiBDJdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 04:33:04 -0500
Received: from mail-dm3nam07on2062.outbound.protection.outlook.com ([40.107.95.62]:63072
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232946AbiBDJdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 04:33:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtLvN9VfXV8zjS9sIQYTUH/Bk0+d4Wifnc4BUxHQztAx+wrw5lRVZN4+axRRGZS7GM+7rhpiT8k8VfJqy0KnrRuJkr55N5xIMG4yk66FPdaudtUHzYxKUAe1gsEThuj+RI6TpjvpaDMlW16pKqGNwJ9XOSvgqrt7DMxjHPh/0PORzi8DFYoRmB1p+PAtM13baua/fJJKtDtCc0eGYT4U4sTzBLnVZdQRZfKWvDQ9p4PCwPNX/zgaicS4/kkOfG1cSYCXKifCebczqCbH9HHO7hOZg7cRcZ94tUVWGyqHvewsmpyxbQqomQecA8MZ8T4AIATvL8IlVsY+itqy95ZTeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOUZOa2eFaaPyv0ecWpgD207rU7vIrJDxFXKU22eO8E=;
 b=DC2fM5hiJBtkFNWEqASKiLF64pqCexRwIkaPsBuX92AZVK8Rr9Q79QZ3SFbCPrnYdm747p5y+Ess/jD1OtFBcEYUp01Nqhyw0leEjjKf5Nsag9YP1NUeo3+QraSjXsHUFbqeb/X4U+ENlNL9+DwjoUw0dFICnJMPolxbzS6MHmFr0YmDlvl0TKmZklPY6AtPsFYt8TMwk/x/7S0n4eW25vuEjZ+JvYaQXtFNyYM931RUzkhjcjQSL0NgQDNGO4Fv2yKEsgOSYfNz7NbvMV86x7YlcEWXMlY7H+uThRgrvdlX9g8HcNA0BD51cjsuuDsYV4Uh7Jt6i8sMUBLxYXa+KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOUZOa2eFaaPyv0ecWpgD207rU7vIrJDxFXKU22eO8E=;
 b=pv19NvMiPtMbLjlB/lvWZrUWZQGJp9soOkgCrJrWXX0XxG/Mj6VlNYegONHqxP5rONKmJgpxhu1H/Aox/KiaqsiXIXMMSJakjzl4BX6baHEnMzZU4Setvc75xG9cqv6sGLKguCDe+otdhOIDCsSUqIu5wZTuBLUHJBfOxgCEZYo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by BYAPR12MB3607.namprd12.prod.outlook.com (2603:10b6:a03:dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 4 Feb
 2022 09:33:00 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::10c4:c928:bb18:44bc%5]) with mapi id 15.20.4951.012; Fri, 4 Feb 2022
 09:33:00 +0000
Message-ID: <9b890769-e769-83ed-c953-d25930b067ba@amd.com>
Date:   Fri, 4 Feb 2022 15:02:36 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2] perf/amd: Implement erratum #1292 workaround for F19h
 M00-0Fh
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     like.xu.linux@gmail.com, eranian@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        peterz@infradead.org, mingo@redhat.com,
        alexander.shishkin@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com, Ravi Bangoria <ravi.bangoria@amd.com>
References: <2e96421f-44b5-c8b7-82f7-5a9a9040104b@amd.com>
 <20220202105158.7072-1-ravi.bangoria@amd.com>
 <CALMp9eQHfAgcW-J1YY=01ki4m_YVBBEz6D1T662p2BUp05ZcPQ@mail.gmail.com>
 <3c97e081-ae46-d92d-fe8f-58642d6b773e@amd.com>
 <CALMp9eS72bhP=hGJRzTwGxG9XrijEnGKnJ-pqtHxYG-5Shs+2g@mail.gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <CALMp9eS72bhP=hGJRzTwGxG9XrijEnGKnJ-pqtHxYG-5Shs+2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0086.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::26) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaedae07-d86a-4acd-3b98-08d9e7c155b7
X-MS-TrafficTypeDiagnostic: BYAPR12MB3607:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3607F21982FF09619A5D7DF7E0299@BYAPR12MB3607.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yrizKaUoTLb0T+YxuRnhooY74daA4kVZYGm6bZSjJJmr0GDnZqnDbYGvtANg0ZK0BKqXH2j0qKYF3FS/dbK7f6yQXOYK74wGMI4FivBbyHdHd4Ub+1xWoXKQTfnxNMO4ABGy/VbaS0w2+E8bPHikFceZAiap8atFzl9onbwfbokDhn/hDZM0UEYiIJboGqdngHt+F4Epu1GbEse7qOyMpsdn3vsmIAzybNqEOwvJJ2C2rCNGkiqbJHVEqhBKFVjjDIh+PwcuxnrFPq6qkcB4OTeEl99ayqwaM4l1RpyPaU2xelCLPeDCWu39ik5kV8Sogw4VPp3opBSOETpw4zAgJwuo3vj86WVEOITMdHNYFFMRxYOPWY6Wktw5Cf6++qZYVt01i8RoDb2o36d8vBEA7ymppMz/fIusi3ldAX+8LTElDsUaCIc1kJ7eaxTWuUQVz149Q10wzSTAif6REpbqFJ5UjnwQ3lTiEEeGH/DEIdUqCeTFMDnFJvuR1mESIzHr2k5w3eH5DsL5RhodDVbtrNb+uhOe7LaK9vWrNx1mL0lr02fyfROL4Gm/tuuI7rGm4cbhvog7eXtJsQjpKY4BQ0PNyyWq2mdZYAQuL+ZkHK2PAjoDiFgIW2jnw2Lx8pIkUrmKsYZBnY5pC5hKLkawXP2O1zNKwzgh07936/limKW366u8boVQwosZXMmVn9UvRMQhyCeGh+G09Vq3TNjp6M00+L1W5jjr888amgxZj1A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(2616005)(31686004)(83380400001)(26005)(316002)(66476007)(6916009)(66556008)(6506007)(6512007)(6666004)(31696002)(8676002)(4326008)(2906002)(186003)(7416002)(508600001)(8936002)(53546011)(66946007)(36756003)(6486002)(38100700002)(44832011)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDFSVGFCOEgzL0I4U25Ia21mMlo4dW9lQlpRM3RqZlV0K3I0cUY5endDMCtJ?=
 =?utf-8?B?QUJwVlM4WktVSkJBbk1IOWFDcEVwV3p3ZGw2WVF0Kytoa2xQTVBYY0duYkpM?=
 =?utf-8?B?Y0EvdGV1UkQ2SXhQQ20rZXAxQndZSFJvNVFaWndnUS9BT0trRXhWaHhlNnBS?=
 =?utf-8?B?TXY5QTFIZTIwbnFuOGk2b0RXMXVoV3VqTjlKN1pZVis1QzlNVVJ6azhVVkQw?=
 =?utf-8?B?dDRRRzd6QkNVMGtERk1mbm1pWklVSGtGdGRZUDFaVXZ3UXkwRFFZcXpqOXpr?=
 =?utf-8?B?UkwxU0tLSDlDaEtyaTRuNEo5VXFpM3EvT2xEL1BXVTMrTjFFekIrMElDbjZY?=
 =?utf-8?B?KzRHY0ZrMzVKdmhRR0FxQzRzNGRmcTdLOExBem1sWFRGbERNVE0wcnllVEdK?=
 =?utf-8?B?YjE1UEFoWjJTejl0VVAyVGpCOHNid2l0RnlQcTRlbG1taWN4WmVpNGVmd01J?=
 =?utf-8?B?OXNQZ3JIQVZ4NXlFMEc2TGx2ajdyOVFnMEJFZVBhMmxQTzN3aFU5SkRUcGhD?=
 =?utf-8?B?ZnhRbFJRaGkzMk9CWjVJQnJMd3N4SG1neExTN3NBWnhNU1l6U3VIck82czBr?=
 =?utf-8?B?cnY3M2grbGJ0N05aN1B2OG1uSER4dHB0Mk43ckdRRnNrcWR2OURMalQ3ODJy?=
 =?utf-8?B?aEs1V1BXOTA5R2dxbGlzb3RtK3dNd0gwMTFKSXoxQkswYWVCL3ozNUs5UklT?=
 =?utf-8?B?MlIxMWUzZE5OM2Z4YVkwSGRzNDNDZ05VS09nc1JQZHpBRHRoclA1UG1YQVlX?=
 =?utf-8?B?cjdVdDJ4SGlqTG5Ja3RGWHVsQ01HTmluQS81TlBsdG1GQWpVQmFxNWZ4VXgz?=
 =?utf-8?B?RE1DaytaTHFaMnUzNzB5UTZjRUIwSVcvMXIxMm9ybk90Y0FXTlliREt5RW9F?=
 =?utf-8?B?TkpRaFF1b05rZEVZUkg5NzNRZ1V4Wk96RWJ2TzZkWEhVd2ljY21Pc1hsbndT?=
 =?utf-8?B?dCt3Q2pIVFEvbGlqcXA4ZXFhNkxTSnRVcFJDM016Tm5DMDViV0tWTEhTZTJ1?=
 =?utf-8?B?cy9qVEVvVGN1TkhtdlhTVGlzMGJUeUhJOGJwbFg3UURtTHJiMjhQV2dCekR0?=
 =?utf-8?B?TWs5ajQyZFY3V0FVSHQxOFM4djhqU3NpdDRzV1JpZFJnZGdVNmNBYnFFUHZL?=
 =?utf-8?B?WTRQbDRHWHV6aVJEa2V5TzA1NUloZTJJSkdXRjRkcXcxRjF1S1d1dTlkQVNE?=
 =?utf-8?B?TG5RNTFGelFiZ1RxR0lsMUZHc1kwdU8vTmd4QUdLaDEvT1IwZEFwUUdocnpQ?=
 =?utf-8?B?ZEh6SWVDSG5vUDB4M1ovWUFOeGFZZHNUbTdySVdkTERSZ2NYZ0dnaVNwUW5P?=
 =?utf-8?B?dmVvWTZrMHpVMkp3b09nUnAwL1Y0SHF4YmtseHRLVG9nRmRKM3ZEU1B6LzVQ?=
 =?utf-8?B?cDhMbEdYZmdraldLRGp2UU5sVHdha2ZUREJVUWtaMFJMQjlwVGJJTlBSRWVN?=
 =?utf-8?B?NjZDUlY4ZjZkRUdmdVZuVmo4SU1SOVMxc013Vjk3SEJPcHdqdWNLZy9GTHo3?=
 =?utf-8?B?dDhra0ljamE2SGR2Vm5SSWk4ZkRmcjdlbWJwSjlEMkdHejdTVW9TL0oyTk12?=
 =?utf-8?B?MkhtZXVLek8wM1RmdXc5REh5cW1LL0oyZVFiZEtjcjcrdzhTZnhoU2tUWHVq?=
 =?utf-8?B?R01zUmZpQ3M5QVYvb2RjV1l4ZEswM2V0OHlvWUEvaFA1OE9WMjQrdnA2TlZV?=
 =?utf-8?B?WFIwNm9TM0Y1OFpTYmZtMkl4bGh3YjlGWS9UYThzaW5VRjVCeUVqclZNdkUr?=
 =?utf-8?B?ekhxMnhvVmxmc0VBZVpMYVRJMjFTSjhQaUx3OUlBNVAvU0dNcDN1YmY5WHlL?=
 =?utf-8?B?VkJaOG9aMHlqb3doY1U1WmYweG45bWNMdFBqS0NXaDhjdzh6RDdneWZsS29V?=
 =?utf-8?B?YkRCb3R2SEduVUZpUTNaZlcvNWQrNDRBaVB4RzBNU0lPR3pwODBDb0FtSk9Z?=
 =?utf-8?B?WHQ2ZlAxQlNqR3BwNDltVjhTVUJKTzljVXRNdXAwR2FRbmJSM21OY00yUWlz?=
 =?utf-8?B?OE5XNE9BYUJ2ZkROdlUxcGdBNFlsdnNpblNVWUFISzZrUi9vVHJGcEl4MWZw?=
 =?utf-8?B?Ti9MQ2hNZkVlMEV1bmwvT3krMGJzQUV5UzhUS2RNVHdiY01YVCtlaHBUdVUr?=
 =?utf-8?B?RDFHTi90TEJ2R2NuY1c3aVp0bjVrTXdiSUJUZU1zcCthRS9wNDlNS1UyWFI2?=
 =?utf-8?Q?vgnH1aGFtOKm+7PZUyQQKg8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaedae07-d86a-4acd-3b98-08d9e7c155b7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 09:33:00.5224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYwdIrcM9B2wCU4EH5EaWTdZKEVhJ9eoED1OmF8N2IxVb489kpxp6U7jyNDkgyaJBpevMj7CMZGWKan5JRH7EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3607
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03-Feb-22 11:25 PM, Jim Mattson wrote:
> On Wed, Feb 2, 2022 at 9:18 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>
>> Hi Jim,
>>
>> On 03-Feb-22 9:39 AM, Jim Mattson wrote:
>>> On Wed, Feb 2, 2022 at 2:52 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>
>>>> Perf counter may overcount for a list of Retire Based Events. Implement
>>>> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
>>>> Revision Guide[1]:
>>>>
>>>>   To count the non-FP affected PMC events correctly:
>>>>     o Use Core::X86::Msr::PERF_CTL2 to count the events, and
>>>>     o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>>>>     o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
>>>>
>>>> Note that the specified workaround applies only to counting events and
>>>> not to sampling events. Thus sampling event will continue functioning
>>>> as is.
>>>>
>>>> Although the issue exists on all previous Zen revisions, the workaround
>>>> is different and thus not included in this patch.
>>>>
>>>> This patch needs Like's patch[2] to make it work on kvm guest.
>>>
>>> IIUC, this patch along with Like's patch actually breaks PMU
>>> virtualization for a kvm guest.
>>>
>>> Suppose I have some code which counts event 0xC2 [Retired Branch
>>> Instructions] on PMC0 and event 0xC4 [Retired Taken Branch
>>> Instructions] on PMC1. I then divide PMC1 by PMC0 to see what
>>> percentage of my branch instructions are taken. On hardware that
>>> suffers from erratum 1292, both counters may overcount, but if the
>>> inaccuracy is small, then my final result may still be fairly close to
>>> reality.
>>>
>>> With these patches, if I run that same code in a kvm guest, it looks
>>> like one of those events will be counted on PMC2 and the other won't
>>> be counted at all. So, when I calculate the percentage of branch
>>> instructions taken, I either get 0 or infinity.
>>
>> Events get multiplexed internally. See below quick test I ran inside
>> guest. My host is running with my+Like's patch and guest is running
>> with only my patch.
> 
> Your guest may be multiplexing the counters. The guest I posited does not.

It would be helpful if you can provide an example.

> I hope that you are not saying that kvm's *thread-pinned* perf events
> are not being multiplexed at the host level, because that completely
> breaks PMU virtualization.

IIUC, multiplexing happens inside the guest.

Thanks,
Ravi
