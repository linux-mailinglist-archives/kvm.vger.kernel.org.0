Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEB2560ED6
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 03:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiF3Bxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 21:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiF3Bxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 21:53:41 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3C13CFEC;
        Wed, 29 Jun 2022 18:53:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BS2WAayVX8ZNSQYdlYsNB7KI8jPylV0mIzAL5/qQTp8nbYI//UXiehpGKgB7Bkw4trVp3yvZWAgNEJ9W1+BqVU/EZDwxaCwYdSy/oFri4YWFYW0WINuDiI6XOZnTYtEptr8IHpik1MY3yU8mYAa+dxwUTT4j3/trDMk//wMkcwMnyk2OSB/EzCs4A/FfwfL3a8mSEPfdMnZSrV0ZIBKop/pByE8Z9lI1MtbrJ/oy1tdHv+ON//DvjcIso8qFOpVqphjNG0/PUshkSD0dtMbV7d2VWHOVtHv5te/6d156wd1Y+MalIf2kTZTZfVYBQB3BcsodrjI7ojbGKBXKsbQrbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4nwGocQP0hm/+OlqRDslQl/3JS6WGFh4GoyiK6bbfU=;
 b=mwWVD7IXNZ5X37z8mghJ8iUIGVVfTMhnOlCY8Fl+CsXvc4OLlKWVCOkxyB22GruVijTHH0TLxYSdbkOkWfBwtxJm1Hfpoq+xTStD1uWj6XDBE3MNNhrwIM2bXUZpNcswutZPxq6k0XBVhXenUEnkLQozuznmMgJZDqPREdgj1SPgZwDBEfhPGQH4WBQr98tG81nbFIGBrpVVAhZ2m49sY6EhjLNgVlpWJML2pGz1oN739/SZlwb+Kn5HLg+aRE+EZ9QAOmUzaAv32l8j+aCces8CpbZpMX4aKf9tkDVO09T8BxutEMWvABpX8WJq3fH2m67UZTMtZTLpDYONVZDISg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4nwGocQP0hm/+OlqRDslQl/3JS6WGFh4GoyiK6bbfU=;
 b=iAFPSy7ddY68E6PwFHXTJq4KJTiWe1f7yj3BJr3sC7zGwA5a+Wk107VIoBq9U7DVqJGaj1q8DVtrs874tqcnAIOTx6QyZr9wWJs0WlrJX+9xrQ2PiOyp1l4OhsPDqihtIsK5g1LJOmG8u3tikUXsWrB5vhTF91Jh6dRFVT0LsElQvGbQ8z6CpMOOrxaDbjLwO1Ohyo0ApQUK7yCPS4ogikHDI2JYNqVEPBA0B/LKk1QHuBxN3MUvFvXoKnM+sHZ4YUfUV2aXXN4KdtPAUTcIN+ow9C7WNtLq/+3c5Ty5RuRKhtPA5QC4A0lPKabHyLJFJP/bnvfnmIMpBBg2/FQhuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BN8PR12MB3076.namprd12.prod.outlook.com (2603:10b6:408:61::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 01:53:33 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910%5]) with mapi id 15.20.5395.015; Thu, 30 Jun 2022
 01:53:33 +0000
Message-ID: <17f9eae0-01bb-4793-201e-16ee267c07f2@nvidia.com>
Date:   Wed, 29 Jun 2022 18:53:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
 <c196a140-6ee4-850c-004a-9c9d1ff1faa6@nvidia.com>
 <YrtXGf20oa5eYgIU@xz-m1.local>
 <16c181d3-09ef-ace4-c910-0a13fc245e48@nvidia.com>
 <YruBzuJf9s/Nmr6W@xz-m1.local>
 <177284f9-416d-c142-a826-e9a497751fca@nvidia.com>
 <Yrx0ETyb2kk4fO4M@xz-m1.local>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <Yrx0ETyb2kk4fO4M@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:a03:255::26) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eab4e8c7-491b-4681-00e1-08da5a3b568e
X-MS-TrafficTypeDiagnostic: BN8PR12MB3076:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ho5Lgdjo/8BmboQg3NK+F+yNC784XPPQsjtnXBmQc+J++GUkOSQ9YICI1G40WCeYxbAj/QoX7qj0fClnuA5Mc529UAmaMPGTRcqM/tDjQL+JUX0bWJgiI5APL00uHo9Jd3oTQY3qoWHIjejaHI8QYgjNzUNIhKMCzn95jOMLdtr5Y73NJA3crpZxQoa8bCtuYpU5DlJKLMEgwuhHnkv1IbF4d7NYApbQmkf3mEo65/snXVb9Gvk4UNUaLZ3goVsIdw5elWOkMAl672rDN9nVzsAHR8zsNI203CJQ9R1tfroV91rZhfh16b1cWVn0eQgksjwCzjDG6gOoVuWPd16DHEEY6vBTMo4iysCR0xK5ELWU4O8XU03g/I4CgZSK/OL9gTFP4RiAXr0xXLCHqZrM08/f8cQPORaP0xQ/kNInWceOEKHSwjH7dUbSejnOKgxtwhu9Pu2+sosaxBYbNU6yq0Pbfe3+7XTZOU1WIOdZjkft6hfD2MPBweFv9eXhcYDq73dT3WGIbowjB2dEsJiU6XCuhHSQOtdnK7bFRQBxd4t/0npb2LX3J/u6LMz1rnXjN+YGjxQhAHy1qIlNCZrQnZtjfHHFf8PMWaRdjboROP5/AqslTWCf71agRfEEI+g0JIZdGKoeXMMY13gqLQi9oMQsV818RVlAnt+hDQZg18sLKHcwsFLlctGICj/Q4FUs4UlgSO4szfgHQSjsGN7m35HaAG2VL6gcNH7apCzNWr5eIp+ZEj6xbYyakbhLAq2O/WhqfAwilEMdwZ183zcb4VaDZecmFe3Qy4CA4zNgWWI4/r/4qVmFo4MwDXm19rR4GLSRfwBaRzTzcms2nKGAMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(478600001)(26005)(2906002)(6486002)(6512007)(6916009)(4326008)(54906003)(316002)(36756003)(7416002)(8936002)(31686004)(5660300002)(86362001)(66476007)(66556008)(2616005)(66946007)(8676002)(31696002)(83380400001)(186003)(6506007)(38100700002)(53546011)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHc0alNNakVtVnljQ3htMUlKejN3bkd2bHp4TFh2d3p2NWVrcys3VkJGSThD?=
 =?utf-8?B?c2pzdkg2eE5NYUkzN2VUbk5rRDRYWmMxdDkzek5tTDlZajROTzRRQXlLOC96?=
 =?utf-8?B?Vnl4dVhZUzBxVmRxcVp4OHhaZXZwWGZjckthcVpHOC9yRkdaZGFLc0Qxc05x?=
 =?utf-8?B?aW92bXNKMG5sWWFnWlZ0NzUwSERtZXJtMDBsZGJxK3hrTmFiTW9aTTE5QkxF?=
 =?utf-8?B?WG1tK1l6VWF4N3VDOFRTK3lSaXZ0am1mazN4UGpRdC94bTZqR2lxSEE0OXcv?=
 =?utf-8?B?YnR2MGtFaW9qQTN5N2RsQnA3TlBTSUVhblVNN1grVnE0MVdrN1hLSWFMcGtZ?=
 =?utf-8?B?Y2FOM1UrUXk0cUJkcktiZm9oK3lrZkhlcExndVFPTlUwTVo1TWJZREQrOUh1?=
 =?utf-8?B?OHExWmd1c0dkSEtSN0hQZ2tpNWViNWt2SThZeUJxRmF4bSs3Snl5bUR0bnZj?=
 =?utf-8?B?eGJwOUkvVUNKckd3QkRSNnFOWGtnbkpRWU8ySFZOVjAxdXdIbTF3MGttbVVF?=
 =?utf-8?B?QklnTVdqbU5DdGZiVHRudTdxSjFmbkoxM3NuUk9hZ2hBNTB3VUpLR0dwNFVl?=
 =?utf-8?B?RlVFMk1wWE1PeHJaRkExRkFKYU5mc2RWbVIzTnlJVXY3akFLNEgvYmhQaVFs?=
 =?utf-8?B?WGdNRVdQU3dWOWpSaU5RVUp0cldrR0M3YXVvcGI5VzZ1N3o4aGhZM21Fakc1?=
 =?utf-8?B?UVptRzVtTDJWQkRNM05ObHV5M2lYb0t4M003cWZ5ZEJmaUJ6QU90QTJ3bkJt?=
 =?utf-8?B?VUV6cjhJbGcwVmhQT3RUWUdqdG1ITnBVQ01hL3pQeXpGajNRcVBkSDhVMFYz?=
 =?utf-8?B?bC9qVHpTenRNbElBQnQ5ZzZQcmJZMlQwcVVId0tDUzVEaVpRTkRMS2ZVemhL?=
 =?utf-8?B?bEtqa3BNTExhaDdNbjJqdTFXVElVbkU0V2lBTHArdTFlOW42RGI5WDJtMkxo?=
 =?utf-8?B?V2pjMHRxYTBDQ1dkT0N4czNuVkFwRzhuZ2RtWDBxK0hwTHhrZm1TTGtnNkVQ?=
 =?utf-8?B?dUZNUUxOMnZEVG9NRXkxODNiWVY5UjlyU1owT0RNcElQamlQd3pXQjI2WG9I?=
 =?utf-8?B?elFHT296TjVhQlE0UTJ2Sm0zd2QrSGFobDR2S28zRXZmWW43K2xMUVJNbXVm?=
 =?utf-8?B?MnNJajl6bUhPUjdPNUgvQm9EWHd5WCtCdVF0Z2tId0VvYnVBNWdOVDZnbkw2?=
 =?utf-8?B?RnJqM2pNMUgxMWpMMkp0UHZKSHpZM2xWWXNCVHVCUDVKVHJTSExhR1JZOUpu?=
 =?utf-8?B?MmtaZjVnaTZCK09rbHRlZ1JDUHk5Y3EwRHNCMTJDRkc1RlVxUERoSkFlNTNI?=
 =?utf-8?B?cWxZNFkxbWFGWHFsZVE1UGoybG1VYU54VmpKR1V3TkhCSHlPRVVYU2hnOXdY?=
 =?utf-8?B?Zm51OVZlVkxmV3NsZGo3MkV2MjN0UTZPanRWMmpSblNsYjNUdnpmTnB1ZjhE?=
 =?utf-8?B?UjNJbXdhQTlLaWdHcjAycFBOV3BidFQ4aEVybld5VjNTb1Bwa0hEYTJpTWcx?=
 =?utf-8?B?YzFiMXZuV2FUL29LVHpSenB1TDgzNnNpaU5kT2gyNXNEaS9scmdMSWlPSVNH?=
 =?utf-8?B?MXJsL2xjRU9vRTFDM3JxOXNtQU5OR3VOUVQ5ckRNRXJyWG44K01PblVBcDJm?=
 =?utf-8?B?RGk2N0NVNEZpVTBzNEE2ZWhkaVJZWTQ0UWsxZmV2TG92MiswcDl3R091eFMx?=
 =?utf-8?B?L3c1Y2RrdTA4cDBMM2ZWdExWRlBuOFBrQU42bmNQZWxBemdpenhVRTAycloy?=
 =?utf-8?B?ZHdaUlVwQXg2ZE1LalVUemMvY2JuVERta2hOSnppREpNWmd3S0NIOXZ1NFVB?=
 =?utf-8?B?eG5FV25pM2JIemdUVVRUWlpFelRnZi9kenV3Zlp4d2xoQXV4U0dMNmI5bjBt?=
 =?utf-8?B?YTc3TVJmczMxOW51UWRDS3pxRzRITnZ1YXNGVHZWakZ2cWdZZmViUkRQTGp6?=
 =?utf-8?B?N2JGbE5HN1U1Z0VxZUtzUWc4blhOMVg0YTExUEQ3NlFTa2Y1Szk4OHlKYlFm?=
 =?utf-8?B?QkdlMGdWcDFiQmJjWEVITjZyUTZTRzNUMkY4cndYSjRhaUx2ZUc4ZFJKZ3BZ?=
 =?utf-8?B?cW80ZjhhR3NoNFJ0cnlFdGc2L1dFUnNWNmdDNlVmbDdIcjZJTjExWDZVNnhH?=
 =?utf-8?Q?xVYFQI4Th2eUJwL+a4yAchBV9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab4e8c7-491b-4681-00e1-08da5a3b568e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 01:53:32.9157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRpRq/C5ncU6Bujq9p/oYlvh4YdVNtP34/RLt8FZgaHN/tUWVmRlnRfCrtLbFqxJh09YW6ziP58CBxqy5rbbyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3076
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/29/22 08:47, Peter Xu wrote:
>> It looks like part of this comment is trying to document a pre-existing
>> concept, which is that faultin_page() only ever sets FAULT_FLAG_KILLABLE
>> if locked != NULL.
> 
> I'd say that's not what I wanted to comment.. I wanted to express that
> INTERRUPTIBLE should rely on KILLABLE, that's also why I put the comment to
> be after KILLABLE, not before.  IMHO it makes sense already to have
> "interruptible" only if "killable", no matter what's the pre-requisite for
> KILLABLE (in this case it's having "locked" being non-null).
>

OK, I think I finally understand both the intention of the comment,
and (thanks to your notes, below) the interaction between *locked and
_RETRY, _KILLABLE, and _INTERRUPTIBLE. Really appreciate your leading
me by the nose through that. The pre-existing code is abusing *locked
a bit, by treating it as a flag when really it is a side effect of
flags, but at least now that's clear to me.

Anyway...this leads to finally getting into the comment, which I now
think is not quite what we want: there is no need for a hierarchy of
"_INTERRUPTIBLE should depend upon _KILLABLE". That is: even though an
application allows a fatal signal to get through, it's not clear to me
that that implies that non-fatal signal handling should be prevented.

The code is only vaguely enforcing such a thing, because it just so
happens that both cases require the same basic prerequisites. So the
code looks good, but I don't see a need to claim a hierarchy in the
comments.

So I'd either delete the comment entirely, or go with something that is
doesn't try to talk about hierarchy nor locked/retry either. Does this
look reasonable to you:


	/*
	 * FAULT_FLAG_INTERRUPTIBLE is opt-in: kernel callers must set
	 * FOLL_INTERRUPTIBLE. That's because some callers may not be
	 * prepared to handle early exits caused by non-fatal signals.
	 */

?

>> The problem I am (personally) having is that I don't yet understand why
>> or how those are connected: what is it about having locked non-NULL that
>> means the process is killable? (Can you explain why that is?)
> 
> Firstly RETRY_KILLABLE relies on ALLOW_RETRY, because if we don't allow
> retry at all it means we'll never wait in handle_mm_fault() anyway, then no
> need to worry on being interrupted by any kind of signal (fatal or not).
> 
> Then if we allow retry, we need some way to know "whether mmap_sem is
> released or not" during the process for the caller (because the caller
> cannot see VM_FAULT_RETRY).  That's why we added "locked" parameter, so
> that we can set *locked=false to tell the caller we have released mmap_sem.
> 
> I think that's why we have "locked" defined as "we allow this page fault
> request to retry and wait, during wait we can always allow fatal signals".
> I think that's defined throughout the gup call interfaces too, and
> faultin_page() is the last step to talk to handle_mm_fault().
> 
> To make this whole picture complete, NOWAIT is another thing that relies on
> ALLOW_RETRY but just to tell "oh please never release the mmap_sem at all".
> For example, when we want to make sure no vma will be released after
> faultin_page() returned.
> 

Again, thanks for taking the time to explain that for me. :)

>>
>> If that were clear, I think I could suggest a good comment wording.
> 
> IMHO it's a little bit weird to explain "locked" here, especially after
> KILLABLE is set, that's why I didn't try to mention "locked" in my 2nd
> attempt.  There are some comments for "locked" above the definition of
> faultin_page(), I think that'll be a nicer place to enrich explanations for
> "locked", and it seems even more suitable as a separate patch?
> 

Totally agreed. I didn't intend to ask for that kind of documentation
here.

For that, I'm thinking a combination of cleaning up *locked a little
bit, plus maybe some higher level notes like what you wrote above, added
to either pin_user_pages.rst or a new get_user_pages.rst or some .rst
anyway. Definitely a separately thing.


thanks,
-- 
John Hubbard
NVIDIA
