Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6568255F074
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 23:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiF1VlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 17:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiF1Vk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 17:40:59 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4184A9FF0;
        Tue, 28 Jun 2022 14:40:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7QTrXrSJvyyLJqIFQcLkno1lfZ5Xk88J7ZrfRUeQwZP1ZdF4l/v2DKNW/RZBgHjmMOgCzgDNQEc7cnw/Zp6NNWW5kpodzN0aT3VGZYEXmsb16YmzCyE7LRIYoqN8d6TklkMj/l4YQgXDOn3bdZQK7CvLiTqkkLPNV0wB9BDwUelZsqlQ1S0pjnTE0kDba1rNRbUvoKkkZCkO+RUc9DzHYorl/Fa95Ue6DPU/eQrysqQH62/KZTwgqm94sIyHCKEgF8pJNlsr/Mk+7Q4pnhmo5bgjntvldzeeqWeOYfdf5asua8505gIu5PO927g22NT32mKekww0pcWT8+66jjc5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAZb+MTPwTikM4JOhrjyi1Mh2n+YRGU9MTfLr6/SUbg=;
 b=CbLCJ7teSPC8MogTjKL8q0r0L08pNFF15tLrecjPYlyGTdHiOYiiiVQhIVcl8WdwoZ1Dmk1rka4CzpUlqMDAHPJGimMop7QIZpqxNbW/+lU6RUQyf2hqDEpILCmfGWqPtAEE60cFPBlWE70MSXFJ5iAsuS6Dce25PJEL9V63v/kGEuN/UCdMhbiK8t3pi7eL6OT9wMnNhKZVQD7RT2uthIHyIZphml7GraR74ali8WEgXidpKmPuBJmY/lJ2X58pc5OUb74qeHifIk+v3C0J69yJmjx8L9AktfB4C1VaGFUUUhCExOTSdn32Zk0oB3K4WtBbbMkNtwvzb6ZUVTl0dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAZb+MTPwTikM4JOhrjyi1Mh2n+YRGU9MTfLr6/SUbg=;
 b=rDtTQiIYDuAaWhleLYvV1mEb+9a2aGh9rT3lSivA0HBza309pucNlY4BIMNfC/cT1YQy9TT7jxjlKWkFhS9Pqpi5MPZWxyyOXHFsCFez2eRDpM8Nig4AitdkV5byyiQdFfKSjJ2HaR7/Kpq6Wa72IqIux0/Uxa/D7pbZn8ATIiecKHDmHQDs916rAN1nSoJvzrJl0oJjwChTW+MECrvxFFr2sjmZvXMtP95m023rPh2vWFiDjgJ3DhCHJb7IWRbEV+BzgJsao2Ud0uPiMKwrW7NMRgQWS/CExx8hJkyrEvyuUI8ctxJq7F/mBjBW5nGCVLdiK9qiAfwZQywIDQJZrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by DM5PR12MB1515.namprd12.prod.outlook.com (2603:10b6:4:6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.16; Tue, 28 Jun 2022 21:40:56 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910%4]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 21:40:56 +0000
Message-ID: <16c181d3-09ef-ace4-c910-0a13fc245e48@nvidia.com>
Date:   Tue, 28 Jun 2022 14:40:53 -0700
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
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <YrtXGf20oa5eYgIU@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0038.namprd07.prod.outlook.com
 (2603:10b6:a03:60::15) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15fb3be7-a2be-411a-b861-08da594ee213
X-MS-TrafficTypeDiagnostic: DM5PR12MB1515:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5uA6/OkRMpR3YSFeiy69soCHlmIw0NqKQGxLG2EMNTPM3+R+edVdg7tYyI3V/EBaPdxCSRiJmK0qb0xf4+pNNMShly3Lkl/E7mSoUBSJsJaQbkM0o9zbijaDbgdKxLXF7I9NMVRtyVt915KBdVAg1dda0TozZI8TlFznjf8kE/hmzU0OEzKsKevor5OWh63MBTvV5HZSm+r1qVIp3wfd+JIIqPErIMGhYRF2YkpyH9XXi/cME1meA6T/PwmA3x5EF6Yp+/Y1DX4LFnwJmIWVvKJnm238/sTNakanpeAeBItTiJXCcbv2p4BILiho6T7e5rz4RV83Ymf3gOE8JcDyFG3bnMksLuPVMRIP3/aErqM7Tvg3OCUqtTFIu+wQkTyVwokbG+ESVCIdMHyUCCdDZapvPpuiP/8Sm+wn6lPHOdaCy8A5khbuR4RoO5Z55+50OX1By1nPBjzvNVVN4BFs64nqI8Ubmyoq0fgm6Vx77JtDsI+isGepIlHO/WlHngwcDRAsaHtt5ocdeWvNR0GSRAYiftLrnVdhShmcmP+Q97NZrW2mJnh4sDLl5L0D9/V1MF9dm+rTjwxYmq9A17AspHQZRf+FqzvkyGhRq5BFTTNthKMVbH4HzS+PyHP3wH6TqSZNSteKv+5my4IOFotpLRCnWMdb5CKEk8Ax71a+jAg/ROYRqW6OOHZTXmmwoU9fIOs05/+WkwT90Nl+bL8swzs2bml7JhK+0ebKHct8ANLKB6rODSSSCMlU3aVCoxOWFqIqAC6wT6XrQ+6Qy3AHadcLVIyQOx1KYqPNfl4XyThcIftWoBC5opPZ1MRwDZR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(2906002)(478600001)(54906003)(8936002)(53546011)(6486002)(316002)(6916009)(4326008)(26005)(7416002)(6512007)(8676002)(36756003)(66556008)(66476007)(41300700001)(66946007)(86362001)(31686004)(5660300002)(31696002)(83380400001)(186003)(6506007)(2616005)(6666004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnpBWldESE5DQ2k5dGh3VjBsVFhSYyt5akNBMVZvdEtVY2ZNZTRsWTd4SXMx?=
 =?utf-8?B?ZEphUVFzZEoydERuNnB4U0FCS2RSMVBnZFpJVWd0Zy81Ty9RL0VWbXE2V0dr?=
 =?utf-8?B?Zi81Q1dwUnZaOFR4WmFuM3NiTXJKcnp1dk85eTlSRkM0enNqRSsrYVp6R1Fa?=
 =?utf-8?B?M0hnVHRSQmN2MVRxNitub1RqQkZJNHhHRmlzbkJySm44U2JkUGxQSlVKZkdN?=
 =?utf-8?B?L0ZzZzNSMXBiamx1ZFNIT2x5bHRwRlMwYkxJQmVmRG01YmcwczA4S3ZhOFo2?=
 =?utf-8?B?ZS9qL041bktQNnlDbk43a2Y5TFliQnV0UGgvY1M3NlRMLy83MW5FYndGbHls?=
 =?utf-8?B?cENjS0s5eEJvQXl6a2NGRk5LQ0ZYSE5zVUJ5dWhtNzJsQ1hIaUYyZE5DUGZh?=
 =?utf-8?B?dXVGQ04zNGpwSXZ1MjQ5d3JuazBSYW9BMUp6R2JnaDV3RnEwZGhHUXlPalV3?=
 =?utf-8?B?cmFucjlNd0dGUENaNlVrL3Fhb1JiSkNLL1UwVm52MzF2TUN6cHAwOHlZYXRa?=
 =?utf-8?B?aDRVOWw2V2RDcmx1eFdxR1MxTDBrQ3ZRSHMzdHJRZVpGV3c0MEhSU3h6a1lG?=
 =?utf-8?B?R0xWN3pkcktnMXprVmdZQjFiVU9NQ1RGci8zK0RkYzNNSytKaFpQYVVPR0Mz?=
 =?utf-8?B?MmpGUzV4bUliRFdnOEp2RUdOODRlclViR3Jmb0VqQUxRbnJBTzFWRUtWMzc0?=
 =?utf-8?B?RkdNKzVFYXZ5MjFMYWNzZWlVK29EVU1MQ1pQN0tjd2J0ZHFDRUEyOURRTUhW?=
 =?utf-8?B?SHdWT01lVllyK3EyV2ZGSklFeU5jSkdaUEtlVnBrYnZhOGVqWkpwbmV4Uy84?=
 =?utf-8?B?VnJySWVmMmg0MGdlcG9jTXNnbkN3K3c3YUpVVGFYeXcrTldCeUgrRTFMRnZ5?=
 =?utf-8?B?eWtOOTVDUUNDNi9NVFR5d2NNY1pENEZ6NmhZa1pwMUlGZnp3V1dmcDlFT3lp?=
 =?utf-8?B?QlZ2MlBiUzY0d2ZzV0RnOUdEMHZha2xDZEw2Mm9Nd1pwaWZ0RUNzK2pjK3Nh?=
 =?utf-8?B?akZwTEh1RFRkRjhKYmZSY3l3R2NTak1CWFBTY0FIM3Fvc0VXVDNZU1lHQm9w?=
 =?utf-8?B?S2FoekVyNysxeDRMeHFzWlVtYU5MR3QyUDc0bkovN1A2K3FBWmU3UEJkZWRq?=
 =?utf-8?B?S0hRV1Ezc3lJYXcwOUp4MHB4am5Ba2FNYmN6RmZKY3pNSXZaQk11dlRXakRj?=
 =?utf-8?B?QUR2SUhEcGJKdWt4SzBxb0xLdmx6WlpkTWU4YzdreE1IWkVOVEVpSVRlc2ps?=
 =?utf-8?B?azQvMnlWaEF2eGx1R2ZmaWRRRDNLSmY3dnhXWU5rNHRTY2pzcjdwRzFOcjlQ?=
 =?utf-8?B?dUUyQ2lMemNERWc3M3lnVVZFR09pcDduTVMzMG5xd3NoSFl6dlVXWnZ3ZWhR?=
 =?utf-8?B?MmdvcjdJTU5tcjYwUnVaTnFqY2tHQXduNmM0d01ZZWVYRC84ckVsclVwN3lT?=
 =?utf-8?B?b3QzV25TdnBGSVV2cm16NHUrS0w0UkF0K2Y3RjY5WlhKeTExYjdLNkgxQ0Z2?=
 =?utf-8?B?YlFxUmpaTUF6eStXbVJhUjBqY0tBZk16YTJsU0VnRE4zY2VWajFUSGp0TGN6?=
 =?utf-8?B?aWt3eVIxWFlCdSt4YmZZNklCdnc0SEVXWjNNSG5pZmt4MmUwL01uSE13S2lD?=
 =?utf-8?B?RTFnTC93SmZwR0lHbFZrNjVOL2xVUUMzQ3FISmdod1JxMFBPcktaTGpveVpx?=
 =?utf-8?B?QVZGS2VwV3BuaVBuZWNpTGQ0bEdOZ1NGdjZDQ2VXeHlZL214RjZSUzhiMzNO?=
 =?utf-8?B?OHRGUENmMldOcXhzWlBpdjRQdXlteVRNWjM4OHZEeFJGZHJGSjNxajQ0NHV4?=
 =?utf-8?B?c3RPalVjMG44Y2V0dmVaT01Gczh5UWwxdm1mRThZYVlSbW0zUUdXZUN5K1J3?=
 =?utf-8?B?RVRkZ0JCWjB2cllVWS9MTzV2N09wdzNmS0UyS2RXQWpNOEdPVlRHTU1rSGxk?=
 =?utf-8?B?L1JQejJLajd1V1huZFA5dHFFd3lSaDNPUzhIT0hhUkFqMWoxRGZiWUcxaldV?=
 =?utf-8?B?NVRxQXhvcDlqMG5sNHljQjJZalduMTZCem9hWlYxWGF4WWpYT3JBMUp0WkJx?=
 =?utf-8?B?b1MyT3NVTjZvMUw1b0J4QVZyY3B6THRvOTBhNTFMZnQ0dWZhMFlqWTFhVlNJ?=
 =?utf-8?Q?nmi3ODSZaijxZTd8VBajCIEJM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fb3be7-a2be-411a-b861-08da594ee213
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 21:40:56.5360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onk44HH2wveKAnJ5LFvxlDnUc6LJTZbvnNyo7UIXzRh7pSy7USxRN9mrjou0eJ8iCNxUrVgxQsQhpFUX7a9HQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1515
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

On 6/28/22 12:31, Peter Xu wrote:
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index 551264407624..ad74b137d363 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -933,8 +933,17 @@ static int faultin_page(struct vm_area_struct *vma,
>>>    		fault_flags |= FAULT_FLAG_WRITE;
>>>    	if (*flags & FOLL_REMOTE)
>>>    		fault_flags |= FAULT_FLAG_REMOTE;
>>> -	if (locked)
>>> +	if (locked) {
>>>    		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>>> +		/*
>>> +		 * We should only grant FAULT_FLAG_INTERRUPTIBLE when we're
>>> +		 * (at least) killable.  It also mostly means we're not
>>> +		 * with NOWAIT.  Otherwise ignore FOLL_INTERRUPTIBLE since
>>> +		 * it won't make a lot of sense to be used alone.
>>> +		 */
>>
>> This comment seems a little confusing due to its location. We've just
>> checked "locked", but the comment is talking about other constraints.
>>
>> Not sure what to suggest. Maybe move it somewhere else?
> 
> I put it here to be after FAULT_FLAG_KILLABLE we just set.
> 
> Only if we have "locked" will we set FAULT_FLAG_KILLABLE.  That's also the
> key we grant "killable" attribute to this GUP.  So I thought it'll be good
> to put here because I want to have FOLL_INTERRUPTIBLE dependent on "locked"
> being set.
> 

The key point is the connection between "locked" and killable. If the comment
explained why "locked" means "killable", that would help clear this up. The
NOWAIT sentence is also confusing to me, and adding "mostly NOWAIT" does not
clear it up either... :)


>> Generally, gup callers handle failures pretty well, so it's probably
>> not too bad. But I wanted to mention the idea that handled interrupts
>> might be a little surprising here.
> 
> Yes as I mentioned anyway it'll be an opt-in flag, so by default we don't
> need to worry at all, IMHO, because it should really work exactly like
> before, otherwise I had a bug somewhere else.. :)
> 

Yes, that's true. OK then.

thanks,
-- 
John Hubbard
NVIDIA
