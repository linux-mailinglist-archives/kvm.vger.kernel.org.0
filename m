Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7D63E2995
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 13:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbhHFLam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 07:30:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239948AbhHFLal (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 07:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628249425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pTlr3c52TlrPZjNn01B9Yc2TW1zR2QrXNrx8DpDtl0g=;
        b=E2uvy+4WL8l239yELwfUIApCyrHtre5koeThEh2jqZqdsVQJ0SPgb2ws6Hz98ABcqOPt6J
        3xC2AMM0vk3ZsIkIBqnLtQE79fqS8gU9Le6o9XVP9orp1QNsFWfJUfwi2wt6lWTbBFnL3g
        kplW+dY4uxWX71jSsubv2SzYFDImoo0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-pA9897buPVGw4sr30rmQdg-1; Fri, 06 Aug 2021 07:30:24 -0400
X-MC-Unique: pA9897buPVGw4sr30rmQdg-1
Received: by mail-wm1-f71.google.com with SMTP id 25-20020a05600c0219b029024ebb12928cso2357146wmi.3
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 04:30:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pTlr3c52TlrPZjNn01B9Yc2TW1zR2QrXNrx8DpDtl0g=;
        b=hqbI0+R9KXjpjVlMnzFRna/Z72Babu6MDMJ0cqGjsfRREmzF84SN36UFmXAVLav9aP
         +t+CBmV1+eSpKMv/3ETNXqEIzqheqbpMaKHz319ble9FsZOn+HhFILCISMLQwKWLBPFW
         R25K+HtOp0Jj+i04B3kDslat8riOkUfN1s1pPhon69bWHxwfPbYZfwZLJgrTeeuU05PM
         1cIOy1yDJ01MfAn3Jn1UIEWlGICU0HdYQ7tm797UNW6r0ZXz+b2U8pmXcejpUSD+YYKP
         I+aUHqOsXh7svQZh5AnNbyZ//Ao4lybYnpDKVaAvERmikawcJDmh+TzpLyzwaIzeOjs4
         yJ5w==
X-Gm-Message-State: AOAM532qbZ5dmnXJ5B/qsaWmtNj6CKV8MciE6kHfbTysboHKre0Vk+e2
        GCb9QLEJmReCl29isCAfWYd3J3zcaadCwC9e918yU2mBIb7con1FbqlD1xa7gfgkqrr97Q1XwqT
        nHjJ7fm3T5NJh
X-Received: by 2002:adf:f602:: with SMTP id t2mr10044864wrp.232.1628249423141;
        Fri, 06 Aug 2021 04:30:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNmG6xkSFgJJKLpxPSZOuyPxqiv5NEnXFWCst9foFZeSqgWcwPEuP2Q12L+fDdVGB/UHUOnQ==
X-Received: by 2002:adf:f602:: with SMTP id t2mr10044849wrp.232.1628249422950;
        Fri, 06 Aug 2021 04:30:22 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6104.dip0.t-ipconnect.de. [91.12.97.4])
        by smtp.gmail.com with ESMTPSA id x15sm8944899wrs.57.2021.08.06.04.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 04:30:22 -0700 (PDT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
 <86b114ef-41ea-04b6-327c-4a036f784fad@redhat.com>
 <20210806113005.0259d53c@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v3 00/14] KVM: s390: pv: implement lazy destroy
Message-ID: <ada27c6d-4dc9-04c3-d5b9-566e65359701@redhat.com>
Date:   Fri, 6 Aug 2021 13:30:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210806113005.0259d53c@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> This means that the same address space can have memory belonging to
>>> more than one protected guest, although only one will be running,
>>> the others will in fact not even have any CPUs.
>>
>> ... this ...
> 
> this ^ is exactly the reboot case.

Ah, right, we're having more than one protected guest per process, so 
it's all handled within the same process.

> 
>>> When a guest is destroyed, its memory still counts towards its
>>> memory control group until it's actually freed (I tested this
>>> experimentally)
>>>
>>> When the system runs out of memory, if a guest has terminated and
>>> its memory is being cleaned asynchronously, the OOM killer will
>>> wait a little and then see if memory has been freed. This has the
>>> practical effect of slowing down memory allocations when the system
>>> is out of memory to give the cleanup thread time to cleanup and
>>> free memory, and avoid an actual OOM situation.
>>
>> ... and this sound like the kind of arch MM hacks that will bite us
>> in the long run. Of course, I might be wrong, but already doing
>> excessive GFP_ATOMIC allocations or messing with the OOM killer that
> 
> they are GFP_ATOMIC but they should not put too much weight on the
> memory and can also fail without consequences, I used:
> 
> GFP_ATOMIC | __GFP_NOMEMALLOC | __GFP_NOWARN
> 
> also notice that after every page allocation a page gets freed, so this
> is only temporary.

Correct me if I'm wrong: you're allocating unmovable pages for tracking 
(e.g., ZONE_DMA, ZONE_NORMAL) from atomic reserves and will free a 
movable process page, correct? Or which page will you be freeing?

> 
> I would not call it "messing with the OOM killer", I'm using the same
> interface used by virtio-baloon

Right, and for virtio-balloon it's actually a workaround to restore the 
original behavior of a rarely used feature: deflate-on-oom. Commit 
da10329cb057 ("virtio-balloon: switch back to OOM handler for 
VIRTIO_BALLOON_F_DEFLATE_ON_OOM") tried to document why we switched back 
from a shrinker to VIRTIO_BALLOON_F_DEFLATE_ON_OOM:

"The name "deflate on OOM" makes it pretty clear when deflation should
  happen - after other approaches to reclaim memory failed, not while
  reclaiming. This allows to minimize the footprint of a guest - memory
  will only be taken out of the balloon when really needed."

Note some subtle differences:

a) IIRC, before running into the OOM killer, will try reclaiming
    anything  else. This is what we want for deflate-on-oom, it might not
    be what you want for your feature (e.g., flushing other processes/VMs
    to disk/swap instead of waiting for a single process to stop).

b) Migration of movable balloon inflated pages continues working because
    we are dealing with non-lru page migration.

Will page reclaim, page migration, compaction, ... of these movable LRU 
pages still continue working while they are sitting around waiting to be 
cleaned up? I can see that we're grabbing an extra reference when we put 
them onto the list, that might be a problem: for example, we can most 
certainly not swap out these pages or write them back to disk on memory 
pressure.

> 
>> way for a pure (shutdown) optimization is an alarm signal. Of course,
>> I might be wrong.
>>
>> You should at least CC linux-mm. I'll do that right now and also CC
>> Michal. He might have time to have a quick glimpse at patch #11 and
>> #13.
>>
>> https://lkml.kernel.org/r/20210804154046.88552-12-imbrenda@linux.ibm.com
>> https://lkml.kernel.org/r/20210804154046.88552-14-imbrenda@linux.ibm.com
>>
>> IMHO, we should proceed with patch 1-10, as they solve a really
>> important problem ("slow reboots") in a nice way, whereby patch 11
>> handles a case that can be worked around comparatively easily by
>> management tools -- my 2 cents.
> 
> how would management tools work around the issue that a shutdown can
> take very long?

The traditional approach is to wait starting a new VM on another 
hypervisor instead until memory has been freed up, or start it on 
another hypervisor. That raises the question about the target use case.

What I don't get is that we have to pay the price for freeing up that 
memory. Why isn't it sufficient to keep the process running and let 
ordinary MM do it's thing?

Maybe you should clearly spell out what the target use case for the fast 
shutdown (fast quitting of the process?) is?. I assume it is, starting a 
new VM / process / whatsoever on the same host immediately, and then

a) Eventually slowing down other processes due heavy reclaim.
b) Slowing down the new process because you have to pay the price of 
cleaning up memory.

I think I am missing why we need the lazy destroy at all when killing a 
process. Couldn't you instead teach the OOM killer "hey, we're currently 
quitting a heavy process that is just *very* slow to free up memory, 
please wait for that before starting shooting around" ?

-- 
Thanks,

David / dhildenb

