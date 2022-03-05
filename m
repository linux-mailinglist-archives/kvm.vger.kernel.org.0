Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386D04CE270
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 04:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiCEDaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 22:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiCEDaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 22:30:05 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315F55A177;
        Fri,  4 Mar 2022 19:29:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b56lPOknbG+dAWNrwZhf0ugt1sFXrhp80otWz6xYh7YNGi99pCyrvmKwgXoA/lk/jCt+u1ckgdzrnYEEAjjXDq+p9J/mUDqayJ8slsz5o0rjZzkWYfsrCLo1FO8raDpZ4nxiDdTxmhe5jMPZHg57tqvu8BUZR8uLg7yRB3zIFar8RWPGl1TqWsS7En6PVU2cHjnIK3sBs3cy9iG3f9KtVF8vKzAkiM9hYpHHJCh6JnqypthHpq+/arz7bZaTzyfeK0HpTexXjWDWBEL5PvTtrTXujyc+rPQspPxinbCFC+kCkFAnL8VvFd8x40BD3GFvNWp2XvQlpGtcS67ZXx0QlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/kfqonbAWmgovsxluM88FVaiKHRdpg8GpoI5i0az4I=;
 b=eSpDBLqOJbepw9gfhUd7pOzZ7zejUx66T4P2+uzA71VWhsfsndW3QTSYvCHHy8b95avaPVToKpQ1fww6VRnxuYlNRBhXreYDpxJRsHj6dRdJ8IwgmBgcsMes+9QNll1W5O3qHIrEPZM4kx3b8E6BmeoC3zsU+XUv1RMpb0OAd0frRemFJZ9HXrAPOEFQ0d/5sxu47jUQ0NdT/D1nV3rle5jg94DkicgTw3QWr26uyyg0L0S7UYHRx6SrnM++ToDQLzXCRpgVHHwdyb4jeprrtLn+Gq4iOpyFIfJBMEQLFCz4WLu48lVAtr/pHKu9J2eGIs4hywG2qMSnys6H0D2aKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/kfqonbAWmgovsxluM88FVaiKHRdpg8GpoI5i0az4I=;
 b=dT5RbFTGgwY5j8pGpg2FCaC7tntlrgGwyXPBmJNc/dAZ48LBnoY/q4OrAcbSMmtlElukxNntVk8tgonJYepdXDgblqlyJmbGVWZ6j6S8xZP/IJHK8ksp2rx5upVJa64ZtSIyMDaZW/9shbZ4/cogkUg/hRv/ehT6Hs5o8EW93Hs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by DS7PR12MB5742.namprd12.prod.outlook.com (2603:10b6:8:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Sat, 5 Mar
 2022 03:29:14 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b%4]) with mapi id 15.20.5038.015; Sat, 5 Mar 2022
 03:29:14 +0000
Message-ID: <6cabe626-eab3-a973-f279-917a540f2c1f@amd.com>
Date:   Sat, 5 Mar 2022 08:59:01 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 3/3] KVM: x86/pmu: Segregate Intel and AMD specific logic
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     seanjc@google.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, alexander.shishkin@linux.intel.com,
        eranian@google.com, daviddunn@google.com, ak@linux.intel.com,
        kan.liang@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kim.phillips@amd.com,
        santosh.shukla@amd.com,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, Ravi Bangoria <ravi.bangoria@amd.com>
References: <20220221073140.10618-1-ravi.bangoria@amd.com>
 <20220221073140.10618-4-ravi.bangoria@amd.com>
 <1e0fc70a-1135-1845-b534-79f409e0c29d@gmail.com>
 <80fce7df-d387-773d-ad7d-3540c2d411d1@amd.com>
 <CALMp9eQtW6SWG83rJa0jKt7ciHPiRbvEyCi2CDNkQ-FJC+ZLjA@mail.gmail.com>
 <54d94539-a14f-49d7-e4f3-092f76045b33@amd.com>
 <CALMp9eTTpdtsEek17-EnSZu53-+LmwcSTYmou1+u34LdT3TMmQ@mail.gmail.com>
 <e1dd4d82-b5d8-fdae-325b-75ba690eaf2e@gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <e1dd4d82-b5d8-fdae-325b-75ba690eaf2e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::29) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21ddc0fe-ea54-4951-5480-08d9fe585203
X-MS-TrafficTypeDiagnostic: DS7PR12MB5742:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5742A12A6B30D131DB30E4ACE0069@DS7PR12MB5742.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A52U1MvWiYdMWa4yVwx0uXKvt5Uf5qlWdMsc57e/yCmdV254DD80MnJreXXJJuGqg9sxXC/ZPNvXh5BA86bRHL/g472Y7lA9fJ9ceApioPxa4dogH+ErLLcxUY/JcZ8nOHS6dE7TZTVh7TB1pCBrVKFZC9RCgHzZqkRDIf1yMy0CcaY6u8gmZP9LJh4bJJhoeQbwRF3dZDB7IqPC5cYZ2dREWy/kuR8Hj+NkRP+BTkvVyfGP6wULJ6i5np1LbjJQeahnhLWLOnq9ns5wn5jDpi7wcc4UbcfSTE7v4a5vzGnq0RD8p5lSeG0NPfTNQhIkIOq24lKzXg9xLG4WL60d1ohCrr/lnDrTLOL9ekclvc6Sq269OdBVx+6dUkVRVjVg0wColnpH+6yjN/8ATbMUO+kuwkKD8KHaJ7UryeKLmdrkgGN8lEdz+7u2uVqWQZIDj99kgMVJCp5C6wEju67cD8it9uf/Q+Ns3I65hYFPTmkjvtuG/sEVWvHNwM8W5mUbJbK4hXKdY9bcj+BMugkwgnG+8zRp/p0PdgBXhLBzgFKDX9kfBpUkJ5Ds7QeaoASvrl04vtKQ9iKnpKRRQDGvl0GgCrSQD6TOjyyNx+N96VYjUFiMHRiP/RhhaSyo4m680Ir68S+66HmbmthJP5I2n5/1iE/sM8ZZLWLuybtNDHV41mYl9NiX2TgyjTfhCJyAzAUYzHw/mlqYzRuD6MDgyptTxRPY3+afjzyubup7ZrY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(31686004)(508600001)(86362001)(31696002)(36756003)(54906003)(186003)(316002)(2616005)(26005)(110136005)(8936002)(6506007)(6666004)(8676002)(5660300002)(4326008)(6512007)(38100700002)(44832011)(53546011)(55236004)(66476007)(6486002)(66556008)(66946007)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2p0Y1N1U0dUek5IMG02SWozT3dINGRLQzI5V2tVMndFWEhnemFKMWRVbCtY?=
 =?utf-8?B?M2ZJaXFvbVFSSnowRCsxWlBEWDRzUmprOFJOeHZGMkVuWmU2VERpTHRtV3BR?=
 =?utf-8?B?RjQ3WEJ2TnVCS3hpdkdYODJweVo1NEFGRWZEZldQTU9PSllkL0ZKQVV3MHpF?=
 =?utf-8?B?WDZES01FM3hKTmc4WXpMbVVpVW5HcnMwNzdYQjZXa2o1U05MWWFSNnpiTFJj?=
 =?utf-8?B?VFhhbWcvRk1rOHBNUVI3aE9iSlErZ20vZDBVOVY2REtWV0xQK1JHQ3BPQlhq?=
 =?utf-8?B?MVpleWRSTnplWTlmQlhiTm9yT3IydlgzbTJxSFRMNnNibERYemY0V0x4N1I4?=
 =?utf-8?B?R1BwMC9TbExZcGtUK0RnOVI0TFB2VVRmenpZMHNVOUVNc09vV2NJbDRWM21i?=
 =?utf-8?B?Vkc3eUsyT1FLNjFLQXNhZllYa3A3ZTBNUGVVdERraGpSMzFpczRSS3g2VlJx?=
 =?utf-8?B?clFnTktPNnMyckdKT3lGcFQxTFpDR3dPQ3RWckhOOElkYXU3T3V2endrUi9Q?=
 =?utf-8?B?Qjk0a2pONUFnaGQ4dkl3U1hLWldINStEMlhMdWdYRnpMQlNoOHZ1Z1AwNjYy?=
 =?utf-8?B?amRrT3ZLdU02SURDbWE5eVNwbkRBbTlyYVhlYi95bm4xc2hpQXV3Qzhlek1D?=
 =?utf-8?B?NUlPcUtSdzVTQmJXZGlrR1Y3VXV1ZnhlTXBRUU5RazNYRGhUUEhkdXlMdzRP?=
 =?utf-8?B?RWpUb1FqYkdCMGNnQlVhaTN5bTdLYkZMZWNicjZGNVNXWVI0RENVM0paT205?=
 =?utf-8?B?R2JoVkhwTTZ0MEdTdEt4QkZFdHFzYk9RSUl6VGs1MUdmQ2hHK21BZi80SlZO?=
 =?utf-8?B?b0k5TUU2dEhtTXpYU1dTMWRzSXFPTTgvRVlKRzBrQUo3QWpwV2JienVnSzQv?=
 =?utf-8?B?TUhvVEk2YlQ2Y1ZBZEcwaFdSbW0yL2w3M3p5SG5hZXVjZ2xzYjBOUEx6L1BF?=
 =?utf-8?B?VWhoNWtrdVVCQ0lrTFFPZGxKZUJUdzMyL0RCaGFCazJSaG1tTWlHR1lRSE9O?=
 =?utf-8?B?MnhpUmx5OXNqYVJiTzM0eE9OV2NyT0h5UVRmaGFsMTZQdUFZS2dlQjNBaExN?=
 =?utf-8?B?b3liSzJRU2Vnelo5ZHdMNkV6R1g1QmxYOVN5OC93aGVxcmN2OUdtZU5paDVz?=
 =?utf-8?B?Tnc5ZjZxU21jdXJoRWhBOUR3WXBScytNMnk0ZkhzMHBoS2xzWGl3cUltdEcx?=
 =?utf-8?B?c1VjL1VhMm4velpzaTM0K01WeVlFdTdWYWF1Y2U1QWlGTWoybDBQdFlaM01Z?=
 =?utf-8?B?cmtwa09KQmtibC96MENjdnhDdHB1eW1DS0huUzVXUDdlUlJORXRSbjZINmdm?=
 =?utf-8?B?Y3B1d2FKQ0QralljUWpOSmJzY1pTN3hhWmw5VFlCZ0M0YW5CZ0w2dmtPaFVY?=
 =?utf-8?B?bVk5UmhwOGdsVEZWZWo0NE1vTkQ1YXVjZ28rbGVudXJjM0NKRjMrMzl6eFd2?=
 =?utf-8?B?aXQ0SEdrNW1DdHpSSzBwNjJHTDdQZkY3aWJEUTFUV080SmxOTTNPeUpUZFZ3?=
 =?utf-8?B?TmRpZTBWQ1BLaUNCbUl2K0RZRTJmL2I4cHU3UnhGMTI5RlZ5NHJvRFhYM0dB?=
 =?utf-8?B?WEd2cnlCUHVCbm10aThUM09MRzAybFlrdEZCS0cvaXFDQ1VGd3JndFkyMlB6?=
 =?utf-8?B?cHZEa0NCQ0xBeS82akxBZXVQQk9WWGF4SVE4OFZiMlpZclNoRzJTaklBeFZR?=
 =?utf-8?B?MXMwMWMvd2xoM2krSVhRSC8rRWU3M0R5blFENitjWkl2WGovVURWNUhvZTVV?=
 =?utf-8?B?UUlXTHdacEUrSU16SURLSEZOaEtpbTloMWFRYTlMRUhXZGNmUnRmNUhDRDhD?=
 =?utf-8?B?bGFjQXI4THhjT3Jpb2cvY3FLUmlUdXJOK2VvTEhScSt2Rm9rdDBwblJhZm5W?=
 =?utf-8?B?K215a00vYS9IdkUwenF5RFlpVFJXY2pqV2gvL0hueHdKQUZIUHV5eG9yU3dL?=
 =?utf-8?B?d3plbnVFbkZNckkyTGpnR1Q2WGdNcDdmRUQwWS9hZ1R0MjlCY1FuOWVDS1Zk?=
 =?utf-8?B?VWJJNG1jcWRnUzZ6QmJCUUZlTEFTMjNtQnRCRlVGVitZSG8vMjFGRzVBeUov?=
 =?utf-8?B?Nk9kaXEzYWFLVFVlcXA1SHh4aEliZUlNSnZhOU5kUlZ0bFZzR3p2MnRvSjc4?=
 =?utf-8?B?S3dneU1jS0lqZ0s5Z0J5Z2Irc20vUmVTbDRYWWdOd1pTNUNDcm9sNWZ3dVk4?=
 =?utf-8?Q?C3bVCsCaNZBeT7B0pTjmU/s=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ddc0fe-ea54-4951-5480-08d9fe585203
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 03:29:14.1943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAXupZkELYOYYqivg2ipGC5czEzOpYIv+7ZrsEblUTYJ+PPd6PLodUWGEHCEiTtwPS0qq1tuM4Isx7cF5e7fow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5742
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04-Mar-22 3:03 PM, Like Xu wrote:
> On 4/3/2022 2:05 am, Jim Mattson wrote:
>> On Thu, Mar 3, 2022 at 8:25 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>
>>>
>>>
>>> On 03-Mar-22 10:08 AM, Jim Mattson wrote:
>>>> On Mon, Feb 21, 2022 at 2:02 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 21-Feb-22 1:27 PM, Like Xu wrote:
>>>>>> On 21/2/2022 3:31 pm, Ravi Bangoria wrote:
>>>>>>>    void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
>>>>>>>    {
>>>>>>>        struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
>>>>>>> +    bool is_intel = !strncmp(kvm_x86_ops.name, "kvm_intel", 9);
>>>>>>
>>>>>> How about using guest_cpuid_is_intel(vcpu)
>>>>>
>>>>> Yeah, that's better then strncmp().
>>>>>
>>>>>> directly in the reprogram_gp_counter() ?
>>>>>
>>>>> We need this flag in reprogram_fixed_counter() as well.
>>>>
>>>> Explicit "is_intel" checks in any form seem clumsy,
>>>
>>> Indeed. However introducing arch specific callback for such tiny
>>> logic seemed overkill to me. So thought to just do it this way.
>>
>> I agree that arch-specific callbacks are ridiculous for these distinctions.
>>
>>>> since we have
>>>> already put some effort into abstracting away the implementation
>>>> differences in struct kvm_pmu. It seems like these differences could
>>>> be handled by adding three masks to that structure: the "raw event
>>>> mask" (i.e. event selector and unit mask), the hsw_in_tx mask, and the
>>>> hsw_in_tx_checkpointed mask.
>>>
>>> struct kvm_pmu is arch independent. You mean struct kvm_pmu_ops?
>>
>> No; I meant exactly what I said. See, for example, how the
>> reserved_bits field is used. It is initialized in the vendor-specific
>> pmu_refresh functions, and from then on, it facilitates
>> vendor-specific behaviors without explicit checks or vendor-specific
>> callbacks. An eventsel_mask field would be a natural addition to this
>> structure, to deal with the vendor-specific event selector widths. The
>> hsw_in_tx_mask and hsw_in_tx_checkpointed_mask fields are less
>> natural, since they will be 0 on AMD, but they would make it simple to
>> write the corresponding code in a vendor-neutral fashion.
>>
>> BTW, am I the only one who finds the HSW_ prefixes a bit absurd here,
>> since TSX was never functional on Haswell?
> 
> The TSX story has more twists and turns, but we may start with 3a632cb229bf.
> 
>>
>>>>
>>>> These changes should also be coordinated with Like's series that
>>>> eliminates all of the PERF_TYPE_HARDWARE nonsense.
>>>
>>> I'll rebase this on Like's patch series.
> 
> I could take over 3nd patch w/ Co-developed-by and move on if Ravi agrees.

Sure. I don't mind.

Thanks,
Ravi
