Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2A537967F
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhEJRyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:54:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44623 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231512AbhEJRyr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 13:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620669222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZRMKkN3puVHnbiCCjdkC/0aI/Ng/WMP6VZjBrfm3u3I=;
        b=cOCihoxcPQzvGKQJ3FuT5Eir1fNpEVpYOjbwj2J5Rr5dZVP6CLttvtPGgHPJWtbVTqKMzD
        7Rg1nj1O5gFr+sHsMQ4RjJTtRg051x6eO7jfaasZvnXJGs2J8oJju/inxl7CGSOPwFdUAW
        +a0HwvzYUnzpCy6gGZ93mhLvYnrMVM4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-xGEn8BMDP_eVTZEvrCbdHA-1; Mon, 10 May 2021 13:53:41 -0400
X-MC-Unique: xGEn8BMDP_eVTZEvrCbdHA-1
Received: by mail-wm1-f69.google.com with SMTP id o18-20020a1ca5120000b02901333a56d46eso7259801wme.8
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZRMKkN3puVHnbiCCjdkC/0aI/Ng/WMP6VZjBrfm3u3I=;
        b=Llt/b4hTGebMBfsrjw2Zygekplm8mtjs/+9DmTYdJ8TXfVg7Jc/w7ZqBsjNT/exurn
         H5Q0iJ3qBl6OosnCeN24GgIDxf0MBese5RGiEQNrT7SXH6UFImeihGDnyNm697WEGB8N
         SwaJu5sd79xkiTMVY6rhyFVrkaPRmew7TPIOZj1Kcriyz9cyh9aZpp2zvg69hdO5cOkz
         IzDDBYwQfUEULBePYmxKJp6NkFVnSlknLzzvMCFq8ECZr47P8e4fsi7ZV6Dxlu7EhjO0
         OWzD3tS90gI0prY20SVqcbrSFmc001UI1hbTVFIGMnDU0OkuvctE4z79ltb9qlaepX26
         5cVQ==
X-Gm-Message-State: AOAM5319QahWzahgLBKu85VbJJ5/d3rBKHBI34nUL+iOrTAgdl7aqzZS
        pMGZdK78KlpKeLaQpqcl30fZcKUpKVq4mZcJdXdnfIvoSuQW0oycgHTTz7/qHz71csJXnnBaIg9
        H8nVEEtk02qZ7
X-Received: by 2002:a05:600c:41d4:: with SMTP id t20mr397218wmh.46.1620669219692;
        Mon, 10 May 2021 10:53:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxACCYv6x9QhD3YmeCA/WIWl5sAyibLtwamGjdiFCeIqnub2B2iMTBAkL7kge9o6yM046pzgw==
X-Received: by 2002:a05:600c:41d4:: with SMTP id t20mr397186wmh.46.1620669219388;
        Mon, 10 May 2021 10:53:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n123sm285028wme.24.2021.05.10.10.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 10:53:38 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-8-bgardon@google.com>
 <e2e73709-f247-1a60-4835-f3fad37ab736@redhat.com>
 <YJlxQe1AXljq5yhQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 7/8] KVM: x86/mmu: Protect rmaps independently with
 SRCU
Message-ID: <a13b6960-3628-2899-5fbf-0765f97aa9eb@redhat.com>
Date:   Mon, 10 May 2021 19:53:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJlxQe1AXljq5yhQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/05/21 19:45, Sean Christopherson wrote:
>>
>> ---------
>> Currently, rmaps are always allocated and published together with a new
>> memslot, so the srcu_dereference for the memslots array already ensures that
>> the memory pointed to by slots->arch.rmap is zero at the time
>> slots->arch.rmap.  However, they still need to be accessed in an SRCU
>> read-side critical section, as the whole memslot can be deleted outside
>> SRCU.
>> --------
> I disagree, sprinkling random and unnecessary __rcu/SRCU annotations does more
> harm than good.  Adding the unnecessary tag could be quite misleading as it
> would imply the rmap pointers can_change_  independent of the memslots.
> 
> Similary, adding rcu_assign_pointer() in alloc_memslot_rmap() implies that its
> safe to access the rmap after its pointer is assigned, and that's simply not
> true since an rmap array can be freed if rmap allocation for a different memslot
> fails.  Accessing the rmap is safe if and only if all rmaps are allocated, i.e.
> if arch.memslots_have_rmaps is true, as you pointed out.

This about freeing is a very good point.

> Furthermore, to actually gain any protection from SRCU, there would have to be
> an synchronize_srcu() call after assigning the pointers, and that _does_  have an
> associated.

... but this is incorrect (I was almost going to point out the below in 
my reply to Ben, then decided I was pointing out the obvious; lesson 
learned).

synchronize_srcu() is only needed after *deleting* something, which in 
this case is done as part of deleting the memslots---it's perfectly fine 
to batch multiple synchronize_*() calls given how expensive some of them 
are.

(BTW an associated what?)

So they still count as RCU-protected in my opinion, just because reading 
them outside SRCU is a big no and ought to warn (it's unlikely that it 
happens with rmaps, but then we just had 2-3 bugs like this being 
reported in a short time for memslots so never say never).  However, 
rcu_assign_pointer is not needed because the visibility of the rmaps is 
further protected by the have-rmaps flag (to be accessed with 
load-acquire/store-release) and not just by the pointer being there and 
non-NULL.

Paolo

> Not to mention that to truly respect the __rcu annotation, deleting
> the rmaps would also have to be done "independently" with the correct
> rcu_assign_pointer() and synchronize_srcu() logic.
> 

