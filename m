Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218633E2E1F
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 18:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhHFQHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 12:07:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231384AbhHFQH0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 12:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628266029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDMPpNAqPC6c45pDZs2yjH7PLpb9RWebANU8kuJcJMc=;
        b=I4ik0qn9k5vPuN2MKediOHKKJxcNGGs+KIklZgcgtnPBPBrEPiRjzWjd6ESoorz+9MvkEh
        keKuIbC6njEBoMPJumtHgdLSEkmh5CZRx5dDi5hX0LfCfPL5bJ5KO4yhYP+JL/4L3UYcy8
        AglGkAq7eJbWqi5VPxo+wu6bU3E43OY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-8yD8uYCeMeyOmP170b01Og-1; Fri, 06 Aug 2021 12:07:08 -0400
X-MC-Unique: 8yD8uYCeMeyOmP170b01Og-1
Received: by mail-ed1-f72.google.com with SMTP id g3-20020a0564024243b02903be33db5ae6so1002942edb.18
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 09:07:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QDMPpNAqPC6c45pDZs2yjH7PLpb9RWebANU8kuJcJMc=;
        b=bCYkX0a+tXchzjQL54U/4JwGkrggjPZIsfJspIQrdFOcyIY7AI3iHLrjkt9XG+q7iX
         ikfn3VqRmCRtdNFu6XgUG3K8m4RChee00G2dAAymm+CKBuhz6vUrl9ZmYa7lq5qYerCb
         VHLn2g/jGstfUSqIrS7Nu5VXOTpkLEnnu5DX8mBUd/pGDW6aqFinr4ic/DhhtJYpwMJB
         RyLYXll3ZTGib1Sv4Xbo5cu+MQGbyPkmMY8W67zDO9zQ9hYujynZxpIjJm5c2kzh0rQ1
         aMr0+FrviKMFMombJ6ux7ABaDWp3G6BfKCPLIKIsl2qmz0mxSp81vcWiM6GwPRmo1rlH
         M6Tg==
X-Gm-Message-State: AOAM531igaIc8kVOIroSwUzakR+e5lgRYqrO3oofKbn5Q6gIv8KMjvXJ
        JL29ZJs41QrIGncVZzNIADeONYjBeZfJTFwaf3MFJFX437GyVJP0Qi2nlDG/tAInwRLeN1AhsYY
        8gR/IW8ITOJF8
X-Received: by 2002:aa7:d6cd:: with SMTP id x13mr13924592edr.300.1628266027560;
        Fri, 06 Aug 2021 09:07:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNut+zkF53aMyAth4YpbAYiNqCg0tB+sVJKxD8iKoH3db7FvFgJxKcgEjHFLbV48HftTBN/g==
X-Received: by 2002:aa7:d6cd:: with SMTP id x13mr13924568edr.300.1628266027375;
        Fri, 06 Aug 2021 09:07:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ch5sm2738049edb.61.2021.08.06.09.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 09:07:06 -0700 (PDT)
Subject: Re: [RFC PATCH 00/10] KVM: x86/mmu: simplify argument to kvm page
 fault handler
To:     David Matlack <dmatlack@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
 <YK65V++S2Kt1OLTu@google.com>
 <936b00e2-1bcc-d5cc-5ae1-59f43ab5325f@redhat.com>
 <20210610220056.GA642297@private.email.ne.jp>
 <CALzav=d2m+HffSLu5e3gz0cYk=MZ2uc1a3K+vP8VRVvLRiwd9g@mail.gmail.com>
 <92ffcffb-74c1-1876-fe86-a47553a2aa5b@redhat.com>
 <CALzav=eSrEGt9Xn99YtmHnWE1hm7ExZ4o_wjn_Rc0ZokLpizeQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <97ea1a31-4763-cefd-bfb8-8eeef46931b9@redhat.com>
Date:   Fri, 6 Aug 2021 18:07:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALzav=eSrEGt9Xn99YtmHnWE1hm7ExZ4o_wjn_Rc0ZokLpizeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/21 19:24, David Matlack wrote:
> On Thu, Jul 29, 2021 at 10:17 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 29/07/21 18:48, David Matlack wrote:
>>> On Thu, Jun 10, 2021 at 3:05 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
>>>>
>>>> Thanks for feedback. Let me respin it.
>>>
>>> Hi Isaku,
>>>
>>> I'm working on a series to plumb the memslot backing the faulting gfn
>>> through the page fault handling stack to avoid redundant lookups. This
>>> would be much cleaner to implement on top of your struct
>>> kvm_page_fault series than the existing code.
>>>
>>> Are you still planning to send another version of this series? Or if
>>> you have decided to drop it or go in a different direction?
>>
>> I can work on this and post updated patches next week.
> 
> Sounds good. For the record I'm also looking at adding an per-vCPU LRU
> slot, which *may* obviate the need to pass around the slot. (Isaku's
> series is still a nice cleanup regardless.)

Backport done, but not tested very well yet (and it's scary :)).

Paolo

