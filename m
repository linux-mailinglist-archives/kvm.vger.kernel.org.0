Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2AD62C2E1
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 16:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbiKPPo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 10:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiKPPos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 10:44:48 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6948A15A1E;
        Wed, 16 Nov 2022 07:44:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGG/kYmJEFRCWDuRSuMA+39ws1TBaXZBLBcfPk01/0Nwc4in7BaHH14+1nTv8RTbYweBZrZM8joA18+uyACe0jZHSiSA4GOrMocwsray/7CAoP5rhOc4ZCk69vmUzG91QWTNsq2PC1vPg5LrPA+U02eXVjupI8TXPgGSG4R5Izmpwdn6Si4o84o9uRC0P3PCjaF+JKfUt3yeKsjHJO3lrzeOoDJtsB7D7CGRSL9T6GyLnz6IHUlpVRMMMSfePi8Ogy34jG38ZJjop5NxAFMMrjREgVVp3JGGxE5HcFTjH0VGFLQs7GHIqoPCM1RJgerbKs3+t5SZ93G4NhI0WP5jkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kMNpFEzfnH06N5geWTbegshu3RMNjskJYwA9Jv4jAw=;
 b=hZsoN3lBRjwgNIXCAWRHKl3+tyam8JArMT9JCBE7NeiGR4MI6jYoYqSbNeDfkwutd4PRVo0shM0tZopFX5JyDBi5D3E4gEB1lNI+ScEpkgK6B/E4xwmAn8eErL9LwZ2PcTDtsEXOADG0HguRzBzpCjRfSWBy+l7bqPTs9V1O9nB1UN64RUAGoAxWRB1Mdnx8Uy/ViRhMaNBq+yqnUgFBjgDW1BhJOolvGq7CIvNRTUdPaOW4xRIrtTeOr4vVWCwaap0gy9IltvC01sevFTz9LVmf1oiJ0NtoFyyLs71siNUcc5UaBxe8F++lZs+vx7o0ke/NsMp75H3U/P8Px2SnNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kMNpFEzfnH06N5geWTbegshu3RMNjskJYwA9Jv4jAw=;
 b=LS/3CC3ynnqNQj4h2TxkyeMlhVyA7cAZSKcxiGR+i45gtC+Ni29gkBkrHTHk1eFYVAgRYxQ+RNoSsR1ieBSOLNqZ50Cv6cTpKbgneZ1MqCz33krFkVQH1r4eVW3TMKVBGLPgNvhJqKWFP3F0gFQzpKjmrR9gy0WBYM/MXsl41RY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by PH7PR12MB7354.namprd12.prod.outlook.com (2603:10b6:510:20d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 15:44:43 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::3bd9:dc6b:7c66:d776%9]) with mapi id 15.20.5813.019; Wed, 16 Nov 2022
 15:44:37 +0000
Message-ID: <ce8f06df-5c7a-e122-3eb7-0d20207cfd2c@amd.com>
Date:   Wed, 16 Nov 2022 21:14:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCHv5 0/8] Virtual NMI feature
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, pbonzini@redhat.com,
        seanjc@google.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, thomas.lendacky@amd.com,
        vkuznets@redhat.com
References: <20221027083831.2985-1-santosh.shukla@amd.com>
 <d109feb8-7d07-0bf1-f4ad-76d4230ed498@amd.com>
 <869d05b2ce0437efae1cf505cf4028ceb4920ce2.camel@redhat.com>
 <fc8813c6-0091-8571-d934-e33d7d56123d@amd.com>
 <f764c7a1eb4a9fe294f04ea48db2dae9c18116c8.camel@redhat.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <f764c7a1eb4a9fe294f04ea48db2dae9c18116c8.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:194::14) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|PH7PR12MB7354:EE_
X-MS-Office365-Filtering-Correlation-Id: 99fce7e9-e61f-4dea-95cb-08dac7e9775a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dQd+YbOSiSXes4+8HQ2K6MQk1nw9a6srU1oHq+Qxe/1LkjBOPGb7ENtMmikU/2oR/pZeFD3wNkJy4pz+SCqHsXAp92Eir97LR6SCAP784OHWKHTRtKFU71fBkNnlR7QPBjKK7YyAauTBqoo3ywwpN5nff6WwDZguigY817N9NY+y6pOj1EcUQPl4OI4HdJFbjkGlb7s9JwfBBRxPSWbEMa/5TdhARzjiS6Cr6yMMV6PmpW6+l2oeUfuAtPvZdxksc4tDoarcMnMXnsQWnzkaBMRtECUXcMkxZxNnea2Fh0/vpdZKqSqtwWM085LRw1+OiS2oMo2C0po1CVd4Ehh9fXxNEAXnlhTgu0ppvBYoClhl6TQMxtVt0moum+/58IPZ5yCrBs7Cjrxv2XaQXbzn0+KHGyyMsQaG8ca7kjPXswJiI8JO9ika+0WydBoKWKtTEHGDHfw3zCLPb+KtdUeM1+GFWdpqj9pj752NsGPAevOM74JKsLHSqkrtefwQWdZFqQ6XSGaZsZUvdtLHA4/3vi1exdbidu66SuOUTmb5mtbinVFqff7LFWtAHmHUEJuiDCP0+gyHBok9rZLCMmWK91OFV0wGHrP9FIlQmvfSxqvjVxJMEkUjLQFG2nRCxZO6ksfpqa+0fJkR3CcS5lsyhcCrbTmzzTsX2z5c0VqhNnKSxmhmIEvbu10jW885LB6JUVlE4XjoVzkK/4Z0ZtM4WqkTdUiA8Tkx57JrZsZ07ZWx3GYBjOd4E8o5XyC466u7WohQncNvueFOrjSU3q5gB8v4JgKsfURB0/6JzfT6SV2B1OGLXXacDuGLDiLz3v9/utPRSarmQMCFmrlrdLfdWgY3nE5wTOdYfBKo+PpCHos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199015)(6666004)(478600001)(6486002)(966005)(31686004)(41300700001)(53546011)(316002)(8676002)(4326008)(26005)(66556008)(66946007)(6512007)(36756003)(5660300002)(8936002)(186003)(2616005)(44832011)(38100700002)(66476007)(6506007)(83380400001)(86362001)(31696002)(4001150100001)(2906002)(266194006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDNIN3NQVlhjalJFM3RjZE1QSnhrM3pQVVhjSE5zZ3h0RGdLbWZVUzl5R3lv?=
 =?utf-8?B?V3lydzhCTFgzNnFZVXJBRHJrNHozUDJyTXBzdWZ3VHNiRWtUTjFyZW9CNW9y?=
 =?utf-8?B?UXRGeStTRnpuYW16RVpTTmV4elZhVDJNUGpWMDFsMDF1SFhOQTZqcFE0TDVB?=
 =?utf-8?B?R3NHb1NMaUFJdmhlWnFoNWp1UzBmRXp2eC91OHBsbng5ZTBqaTNXMVJSb3pn?=
 =?utf-8?B?RHVnUzlCQzA3MVBPYVlpUTQwSnJCWUdWSjA3enhTcWxTMFhKb253TGlTc2xB?=
 =?utf-8?B?Tll3NjNHRkNiTDNXTElFQnVkY2gxRXFZa2xNOTkrRjZHbWY4d2VCNmFZVGsz?=
 =?utf-8?B?emN3ZHhQai9mM0xHbUlNNnlqOW40VTF1WkFxazJOV0xKU0g5NlRaM2xRTG1o?=
 =?utf-8?B?clpGNHlOQTdBTE5KVDFadW5raS9mVXowbXRJNXkwZk9yM0U1TmgzZkdDQ2Jm?=
 =?utf-8?B?TWt0Z2Fmak1SdEh4ZjZtOWRIWThwcmhsWUdtMjdGdXp2QzF4TlNOVk9NaWVP?=
 =?utf-8?B?a2Q0aXRJSERHVXlnT2pKY0pKTDJKWU1FWGJnbzFEWVZQVFNqSERWY1p4Rm95?=
 =?utf-8?B?TysrUXRnQ3Q5UWdMUUUxaUNXcG83QUZKTXpmZnVFdUdtNHM4dktuMXVtMHRB?=
 =?utf-8?B?L21Jb1RkS2RVUzNQb0FJVkc3b2RGVWk0bjluNWU3YTVsbGs2ajJuMWJBVnpT?=
 =?utf-8?B?OUZySXljMlRSNHlYdWJlcERIajZld3oxUE5rdldPRXNhS1FZMjQ4enhTNFht?=
 =?utf-8?B?S1VNMytkUkhRUU5QcjZXeUdtcmtMVjR3d0lEalJaL24wcGZZc2pvZHpOeHVi?=
 =?utf-8?B?cC9Fb0ZSc3N6OU8yeE1VTkRpUEpQalA3VXl3emcrK2k0QmpkY1lqMlJ3V3hH?=
 =?utf-8?B?UXA3TGp6QjMvL2ZwTVduQ2dWcU41dW1PVUNYbVZTUitDVkg4TFBMalRTbCtL?=
 =?utf-8?B?WVd4THJ3aFVNbHMxakFBR2h0ZlAwcS9RRHBUcGlJak5RQXczWnRBRjUzam1M?=
 =?utf-8?B?TWUzTWd0RWppckxSQ3p2KzVCMmFUWDBrWSswV2Q0SlhCTU1VRkxSY3IwdTZi?=
 =?utf-8?B?V2JCNWUvRWtoSmcvQlRnYkNBZThTL2RVNHVLamVBdERqQXVHY3BGSTkvZ2Jl?=
 =?utf-8?B?VXZidmZLOWdCZnFwMW9qazIvSGg0UHRDeFI0My9UdHlQZ2lrYkE3ZkpnbHVw?=
 =?utf-8?B?WlJtMmJSTFBRUTFqOVltbzNLWTZhNUdCWW1LS09xS2ZOYTBMNFN4RFliV3Rm?=
 =?utf-8?B?d3ZlZitZUFg3ME83aVBvd2NUb3ZUZk9RSlFXVHp1UUdBQkZ0MkhSOU40eFdi?=
 =?utf-8?B?Y3V2WmwyT2hKaDVhMGhXMllEMnJjZ280dUQ2bENzdURSbmdodEQzT3lubXRo?=
 =?utf-8?B?Unp1bjE3bEhNWjFGanlGaHpRWGlNaVdXOGZ3Ymk5U1BLM0gxamo2cTk3d1Zr?=
 =?utf-8?B?U3lCd0ppMDc1bFVLZmVQWVZjb0dQVjNMUVBjODdHN1pFVkhOa2IvaE1RaTZP?=
 =?utf-8?B?OER4OUFDWTU1YXUvM3Z0WkEvU0ZWMW4vSU0vMTV5QnB1MVhjOGZTanl0d0N5?=
 =?utf-8?B?SGlrc0dZRUVCOUc2OE9XSFhoTWpEQ0J5c3Y4cWN3c2hmYkc0aXlMWUFnVlpX?=
 =?utf-8?B?RUE3YllBcDNOMjBZcFdBRUlXNURVSHlyUGZLWWZKL3lIbFhyL1lZWlQ3NEZs?=
 =?utf-8?B?NjBLRFRaVlB4RnZ5QVliUlNYYzV6NEg2bHdTVDlDZ1ZQQUlvZlpXTis4WEZJ?=
 =?utf-8?B?THNyR29tUENqZGo2dldYMTVuZXZHSm1qUW5tR0J2YnpiaFZKdERCZnluTkkw?=
 =?utf-8?B?VE5Gc1ZxVzl6UGF0OXhXNkMybCt3b1VjTVl5OHBnWG1NTUVyS1MwdGIwM3hE?=
 =?utf-8?B?YnRRTi9OcWpkYjRQQWVpdmpUMmRyRmRINFZZdjF6VXZhSzVDcytiM3I3cmpo?=
 =?utf-8?B?ejVBbmpJNGxvQUJCTW9hemFFUUNTbDYzcEpYaU9wUFJrVVJhZHMwd1lpb2l2?=
 =?utf-8?B?TkdXcE5KMnh0MXdHOHJGVFlDQ1NtYkh0dmFJWTdydjY1QVZvZ2JWbGNITWpE?=
 =?utf-8?B?cUVIeG9LRWdIc1hIM2QvUHdVZnhvZjR1ZHBDYVdEMmNJanZQMzVNdnMrczk0?=
 =?utf-8?Q?AlLDekYbvHycsCXZp61AUjs24?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99fce7e9-e61f-4dea-95cb-08dac7e9775a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 15:44:37.2891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qgcFcWPK8/4TDJA5TlgXvvsZPq5UptPBX8/SpNguDTEXEzXlm1RgxV2i0OAUJmTasAyMQ5i+csjI091VohIfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7354
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Maxim,.

On 11/16/2022 2:51 PM, Maxim Levitsky wrote:
> On Wed, 2022-11-16 at 11:10 +0530, Santosh Shukla wrote:
>> Hi Maxim,
>>
>> On 11/14/2022 8:01 PM, Maxim Levitsky wrote:
>>> On Mon, 2022-11-14 at 13:32 +0530, Santosh Shukla wrote:
>>>>
>>>>
>>>> On 10/27/2022 2:08 PM, Santosh Shukla wrote:
>>>>> VNMI Spec is at [1].
>>>>>
>>>>> Change History:
>>>>>
>>>>> v5 (6.1-rc2)
>>>>> 01,02,06 - Renamed s/X86_FEATURE_V_NMI/X86_FEATURE_AMD_VNMI (Jim Mattson)
>>>>>
>>>>
>>>> Gentle reminder.
>>>>
>>>> Thanks,
>>>> Santosh
>>>>
>>>
>>> I started reviewing it today and I think there are still few issues,
>>> and the biggest one is that if a NMI arrives while vNMI injection
>>> is pending, current code just drops such NMI.
>>>
>>> We had a discussion about this, like forcing immeditate vm exit
>>
>> I believe, We discussed above case in [1] i.e.. HW can handle
>> the second (/pending)virtual NMI while the guest processing first virtual NMI w/o vmexit.
>> is it same scenario or different one that you are mentioning?
>>
>> [1] https://lore.kernel.org/lkml/1782cdbb-8274-8c3d-fa98-29147f1e5d1e@amd.com/>> 
> You misunderstood the issue.
> 
> Hardware can handle the case when a NMI is in service (that is V_NMI_MASK is set) and another one is injected 
> (V_NMI_PENDING can be set),
> 
> but it is not possible to handle the case when a NMI is already injected (V_NMI_PENDING set) but
> and KVM wants to inject another one before the first one went into the service (that is V_NMI_MASK is not set
> yet).
> 

In this case, HW will collapse the NMI.

Note that the HW will take the pending NMI at the boundary of IRET instruction such that
it will check for the V_NMI_PENDING and if its set then HW will *take* the NMI,
HW will clear the V_NMI_PENDING bit and set the V_NMI_MASK w/o the VMEXIT!,.


> Also same can happen when NMIs are blocked in SMM, since V_NMI_MASK is set despite no NMI in service,
> we will be able to inject only one NMI by setting the V_NMI_PENDING.
>

Ditto,. HW will collapse the NMI.

Thanks,
Santosh
 
> I think I was able to solve all these issues and I will today post a modified patch series of yours,
> which should cover all these cases and have some nice refactoring as well.
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
>>
>> Thanks,
>> Santosh
>>
>>> in this case and such but I have a simplier idea:
>>>
>>> In this case we can just open the NMI window in the good old way
>>> by intercepting IRET, STGI, and or RSM (which is intercepted anyway),
>>>
>>> and only if we already *just* intercepted IRET, only then just drop 
>>> the new NMI instead of single stepping over it based on reasoning that
>>> its 3rd NMI (one is almost done the servicing (its IRET is executing),
>>> one is pending injection, and we want to inject another one.
>>>
>>> Does this sound good to you? It won't work for SEV-ES as it looks
>>> like it doesn't intercept IRET, but it might be a reasonable tradeof
>>> for SEV-ES guests to accept that we can't inject a NMI if one is
>>> already pending injection.
>>>
>>> Best regards,
>>>         Maxim Levitsky
>>>
>>
> 
> 

