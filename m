Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB5435822B
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 13:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhDHLlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 07:41:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229921AbhDHLlO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 07:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617882063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s9XSwEEi1zJXTpbPUBOMu9HhV0dFlRjs6EwHYbE6+e4=;
        b=BCqGMbJOfrjxEXjDu0AmwJDqVN1hDW8OvOjjCRNYXhMvLGE1yEFFfOo1BfJNp8NQdCY9uv
        Fd5Lz11RVCjX3uZZkkrOtfjOPIKnAFGuJ0UFudoxphsoYzKlXQZll4PWvYXfWi8b98WRHQ
        LikfUekwF6sExdN/PxLALQuUr73igqg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-51xpkcPENrunN9tYRMAkxg-1; Thu, 08 Apr 2021 07:41:01 -0400
X-MC-Unique: 51xpkcPENrunN9tYRMAkxg-1
Received: by mail-ej1-f69.google.com with SMTP id k26so721229ejs.5
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 04:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s9XSwEEi1zJXTpbPUBOMu9HhV0dFlRjs6EwHYbE6+e4=;
        b=OCFpq2ybg66N7tjplPXKQG1KefioeW+JKUN1Kj4dddXoy7Q+Sd+r8hLB+rnLkENXh+
         aQcN/knTdhD1Q7nuuz51O1fOlZju8c/4kbC2hL1IVs10PhzQIlG7r+LsEQfMsKV4PUtS
         nsG9JZr9MJuxk0aBzS84iboLrwpokjYbid+C61RsPHZ032Y/qJeah4lSsJa8BV30tCLM
         kwjRO6zW6NnoYHF9Zu5KvJ3R8cR1SObI7GjZ2wmCeppM9/EcMobg8eJiDnuiFOEXpADd
         Evu0C1RTO1HVd7bZgwURYd1WMfsDvSm9p0Qh/+Vvdw58LGneMkO6GHWdpPw0SlaC5/Jk
         zG9A==
X-Gm-Message-State: AOAM531VPxvyXPP3idqZE8hMKLLavN82eBmjyNxJf1ecFKCG6sQBxxT8
        pIjFwfk3fqidWz8XsllaQ+rOvabUBJXWZLOb5PZMoYYO2hntIFTqAFLPbvoLe1ExWaYHrxvIsX6
        Y+Kof68vSuGrk
X-Received: by 2002:aa7:cf90:: with SMTP id z16mr10682022edx.273.1617882060783;
        Thu, 08 Apr 2021 04:41:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUNwVjPU6LZkoTiJz3z03af3SU7UKs6cSUJv0KPBteAvMvZy2H6osTmzxUIJoPNr0/d/3eYQ==
X-Received: by 2002:aa7:cf90:: with SMTP id z16mr10682002edx.273.1617882060615;
        Thu, 08 Apr 2021 04:41:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t1sm4680038eds.53.2021.04.08.04.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 04:41:00 -0700 (PDT)
To:     Jason Gunthorpe <jgg@nvidia.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        3pvd@google.com, Jann Horn <jannh@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20210316153303.3216674-1-daniel.vetter@ffwll.ch>
 <20210316153303.3216674-4-daniel.vetter@ffwll.ch>
 <20210329133101.GA1168973@nvidia.com> <YG7VWWkvnv2IPEXt@phenom.ffwll.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] mm: unexport follow_pfn
Message-ID: <5f956a46-da38-e72a-edaa-3b746a275f1e@redhat.com>
Date:   Thu, 8 Apr 2021 13:40:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YG7VWWkvnv2IPEXt@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/21 12:05, Daniel Vetter wrote:
> On Mon, Mar 29, 2021 at 10:31:01AM -0300, Jason Gunthorpe wrote:
>> On Tue, Mar 16, 2021 at 04:33:03PM +0100, Daniel Vetter wrote:
>>> Both kvm (in bd2fae8da794 ("KVM: do not assume PTE is writable after
>>> follow_pfn")) and vfio (in 07956b6269d3 ("vfio/type1: Use
>>> follow_pte()")) have lost their callsites of follow_pfn(). All the
>>> other ones have been switched over to unsafe_follow_pfn because they
>>> cannot be fixed without breaking userspace api.
>>>
>>> Argueably the vfio code is still racy, but that's kinda a bigger
>>
>> vfio and kvm
> 
> Hm I thought kvm is non-racy due to the mmu notifier catch races?

No, but the plan is indeed to have some struct for each page that uses 
follow_pfn and update it from the MMU notifiers.

Paolo

>>
>>> picture. But since it does leak the pte beyond where it drops the pt
>>> lock, without anything else like an mmu notifier guaranteeing
>>> coherence, the problem is at least clearly visible in the vfio code.
>>> So good enough with me.
>>>
>>> I've decided to keep the explanation that after dropping the pt lock
>>> you must have an mmu notifier if you keep using the pte somehow by
>>> adjusting it and moving it into the kerneldoc for the new follow_pte()
>>> function.
>>>
>>> Cc: 3pvd@google.com
>>> Cc: Jann Horn <jannh@google.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>>> Cc: Cornelia Huck <cohuck@redhat.com>
>>> Cc: Peter Xu <peterx@redhat.com>
>>> Cc: Alex Williamson <alex.williamson@redhat.com>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-samsung-soc@vger.kernel.org
>>> Cc: linux-media@vger.kernel.org
>>> Cc: kvm@vger.kernel.org
>>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>>> ---
>>>   include/linux/mm.h |  2 --
>>>   mm/memory.c        | 26 +++++---------------------
>>>   mm/nommu.c         | 13 +------------
>>>   3 files changed, 6 insertions(+), 35 deletions(-)
>>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Thanks for your r-b tags, I'll add them.
> -Daniel
> 
>>
>> Jason
> 

