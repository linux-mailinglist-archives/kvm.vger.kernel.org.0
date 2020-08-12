Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2B5242A9B
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 15:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgHLNvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 09:51:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48607 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726804AbgHLNvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 09:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597240278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDAp+ggb7oSFGFdMC5id6rMGnPA4tyUwDxMCjaPImAI=;
        b=QOp9nkTSYPgDP0VrKtPbiegh7+X1SSF5eWR0GjGkkp0BDDA8qjfJiVM61QzEZFSyhmhbMB
        CS7oYPttpqeRUGGlk4oEBLaYlCA9kka48LgPSHoDuEdoBJI0SQ3NBTjjPKDkVND7dreJLZ
        6Oem+5/XCMiWmkH8uDAn1+sHmC1PIEc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-cCD58XPvNzK3FPuYJL6F2A-1; Wed, 12 Aug 2020 09:51:16 -0400
X-MC-Unique: cCD58XPvNzK3FPuYJL6F2A-1
Received: by mail-wm1-f69.google.com with SMTP id q15so904019wmj.6
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 06:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BDAp+ggb7oSFGFdMC5id6rMGnPA4tyUwDxMCjaPImAI=;
        b=e1tzvrrKBugPWHa1aXM1u/6qLkd3+4X4biWDqjJqetlvYdZ+SGXB1Z9SRATtMXwTDW
         XYKOS+ifigQ0RWDWGwXJRR1SoDGlSwAUml8sFLKtKefA0WhWQmxANX+zpGRDIHRKAQKq
         YuTsZeSO9L50sLmzBQ8umMedSRIkJivhL+it309LjTLOqxA37xPLhSBa430G5BrJD2Cm
         jgDaXJsAmgsJGj2WlZMx8cBqVxyX7+xxF/XBhw82/3cd1FNlYVL/b9kfjXHdpoGNszc6
         IQdw2VWyX4Mi2cSugMM6CkCNPdbo/FUjpyL2/P8XbFq7J8SokOGGJY6p4W8yussF69sw
         3F2g==
X-Gm-Message-State: AOAM532yEhYiO6aZ7gLkhVxuAP7eEHB+kzhMRm78iw0sIi6ikGgnLL3d
        Z1ZCiBnrf0a28zlabZh9DEzo1hu4cuiHs0MJGPb2x4vvKiDrqzh47a3TIP6y9X0VJtnFK9txbVw
        fihuoAX/pvxfI
X-Received: by 2002:a5d:6381:: with SMTP id p1mr33077723wru.112.1597240275476;
        Wed, 12 Aug 2020 06:51:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyV0DY2n7laMwZDQQRC9n0q+OBfOQbVOA063aLwgQMFyxIvC6lgf++6/c9GE8CTPUAZapSlfw==
X-Received: by 2002:a5d:6381:: with SMTP id p1mr33077708wru.112.1597240275211;
        Wed, 12 Aug 2020 06:51:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fcdc:39e8:d361:7e30? ([2001:b07:6468:f312:fcdc:39e8:d361:7e30])
        by smtp.gmail.com with ESMTPSA id h11sm4322603wrb.68.2020.08.12.06.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 06:51:14 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/pmu: Add '.exclude_hv = 1' for guest perf_event
To:     peterz@infradead.org
Cc:     Like Xu <like.xu@linux.intel.com>, Yao <yao.jin@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
References: <20200812050722.25824-1-like.xu@linux.intel.com>
 <5c41978e-8341-a179-b724-9aa6e7e8a073@redhat.com>
 <20200812111115.GO2674@hirez.programming.kicks-ass.net>
 <65eddd3c-c901-1c5a-681f-f0cb07b5fbb1@redhat.com>
 <20200812133150.GQ2674@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40005c08-27ec-edcd-503e-9d2eaac7d2a4@redhat.com>
Date:   Wed, 12 Aug 2020 15:51:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200812133150.GQ2674@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/20 15:31, peterz@infradead.org wrote:
> This isn't about x86, I want these checks in generic code. We have the
> flag, it needs checking.
> 
> unpriv users have no busniess getting anything from a possible hv.

Ah ok if it's generic that sounds good.

>> That would be the case of an unprivileged user that wants to measure
>> performance of its guests.
> 
> An unpriv user can run guests?

Sure, on most distros /dev/kvm is either 0666 or 0660, usually with
group kvm if it's 0660.  To run a guest you might have to be in group
kvm, but it does not require either root or CAP_SOMETHING.

>>> Also, exclude_host is really poorly defined:
>>>
>>>   https://lkml.kernel.org/r/20200806091827.GY2674@hirez.programming.kicks-ass.net
>>>
>>>   "Suppose we have nested virt:
>>>
>>> 	  L0-hv
>>> 	  |
>>> 	  G0/L1-hv
>>> 	     |
>>> 	     G1
>>>
>>>   And we're running in G0, then:
>>>
>>>   - 'exclude_hv' would exclude L0 events
>>>   - 'exclude_host' would ... exclude L1-hv events?
>>>   - 'exclude_guest' would ... exclude G1 events?
>>
>> From the point of view of G0, L0 *does not exist at all*.  You just
>> cannot see L0 events if you're running in G0.
> 
> On x86, probably, in general, I'm not at all sure, we have that
> exclude_hv flag after all.

No, and you can quote me on that: exclude_hv is *not* about excluding
the hypervisor from a guest.  It's about excluding the part of _your_
kernel which runs in a "more privileged" level (EL2 on ARM, HV on POWER).

>> exclude_host/exclude_guest are the right definition.
> 
> For what?

I meant in the nested virt case you drew above.

> I still think exclude_host is absolute shit. If you set it,
> you'll not get anything even without virt.

If you dislike the name you can change it to only_guest.  Anybody who
does not do virt just leaves it zero and is happy.  Anybody who does not
do virt and sets it gets what they expect (or deserve).  But this
definition is the same as exclude_host, and it's the correct one.

> If, as you seem to imply above, that unpriv users can create guests,
> then maybe so, but if I look at /dev/kvm it seems to have 0660
> permissions and thus really requires privileges.

Since you can be non-root and you don't need any capability either, it
doesn't require what the kernel considers to be privilege.

Paolo

