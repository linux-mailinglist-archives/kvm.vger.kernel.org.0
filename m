Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0007D2428B2
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 13:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHLLdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 07:33:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53925 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726453AbgHLLdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 07:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597231983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RoczEJbTRhp4E6+m43og6G2+lF41l5//y8mz5TyVbNM=;
        b=DMG3ailNkDHlTMsWzCJrO6l6TI+fwDh1IfCJgC0jPPZavwixLwWFh61EAeNs2Nb9OZ9BoH
        EiasU7jjC7sE+CTWibN3ASXTkWwy2BrtlAsSGX+gOPk+5XjtC/YlU1OaICKj9I51EsA6BF
        J3c8vyk3+anoSRSvDE+OuJd+cyE2bSA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-LaJhRB76MISgqfstKAuVeg-1; Wed, 12 Aug 2020 07:33:01 -0400
X-MC-Unique: LaJhRB76MISgqfstKAuVeg-1
Received: by mail-wr1-f70.google.com with SMTP id j2so794832wrr.14
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 04:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RoczEJbTRhp4E6+m43og6G2+lF41l5//y8mz5TyVbNM=;
        b=GLVB/bgyT71WehWRqhxBOBUeIHB4LAJbPiSzkWVftjbebxyPCWnFpYgDpM41P/IjXU
         R0VngVPDfdIvxKTz41GSafZz4WYTL+rGRYepwv9ig5TP83Er/XQl/RfztohUhYdqLZrx
         wJ4duk3Cy/HJ03F7DfC6o54cMRcXZVaNOxvQ3MLjpcePl2EtspxWEIK5KNnHdB9F2Rxp
         XVcrF/HZDxFb0qlNi5U9hLGmjlkfllM2iYlqrdMkSwzP40SrG8CKSjcusI1CwnC9X+8y
         nMJHAfubUIrrYXYXlgiVDzAUYomEerfK8GUZD94V22Z1C+TQf2/2fWzDcgg9IgBdblIH
         bpOQ==
X-Gm-Message-State: AOAM530Db+gEzegkeb3QvnKxgHomBFr3XYSQrXR8Rzb+KLKi/m4JkjtW
        oLFzanurttc7FxXN1nI9XHtVJ33ucUxsN7I5Qfl3YzFQmf+KhwfCVDGDLbEzsHk59cDGVwrZrWb
        OzYmE8rTXYPfn
X-Received: by 2002:a5d:4749:: with SMTP id o9mr33576521wrs.68.1597231980350;
        Wed, 12 Aug 2020 04:33:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwE9vUSdqREh8t5yedMvEm4NGM9cHgKaJxXfAZaigvpsiyMMH7G3s3jyydBvrp2awjcZ69qRA==
X-Received: by 2002:a5d:4749:: with SMTP id o9mr33576497wrs.68.1597231980079;
        Wed, 12 Aug 2020 04:33:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fcdc:39e8:d361:7e30? ([2001:b07:6468:f312:fcdc:39e8:d361:7e30])
        by smtp.gmail.com with ESMTPSA id o3sm3596446wru.64.2020.08.12.04.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 04:32:59 -0700 (PDT)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <65eddd3c-c901-1c5a-681f-f0cb07b5fbb1@redhat.com>
Date:   Wed, 12 Aug 2020 13:32:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200812111115.GO2674@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/20 13:11, peterz@infradead.org wrote:
>> x86 does not have a hypervisor privilege level, so it never uses
> 
> Arguably it does when Xen, but I don't think we support that, so *phew*.

Yeah, I suppose you could imagine having paravirtualized perf counters
where the Xen privileged domain could ask Xen to run perf counters on
itself.

>> exclude_hv; exclude_host already excludes all root mode activity for
>> both ring0 and ring3.
> 
> Right, but we want to tighten the permission checks and not excluding_hv
> is just sloppy.

I would just document that it's ignored as it doesn't make sense.  ARM64
does that too, for new processors where the kernel is not itself split
between supervisor and hypervisor privilege levels.

There are people that are trying to run Linux-based firmware and have
SMM handlers as part of the kernel.  Perhaps they could use exclude_hv
to exclude the SMM handlers from perf (if including them is possible at
all).

> The thing is, we very much do not want to allow unpriv user to be able
> to create: exclude_host=1, exclude_guest=0 counters (they currently
> can).

That would be the case of an unprivileged user that wants to measure
performance of its guests.  It's a scenario that makes a lot of sense,
are you worried about side channels?  Can perf-events on guests leak
more about the host than perf-events on a random userspace program?

> Also, exclude_host is really poorly defined:
> 
>   https://lkml.kernel.org/r/20200806091827.GY2674@hirez.programming.kicks-ass.net
> 
>   "Suppose we have nested virt:
> 
> 	  L0-hv
> 	  |
> 	  G0/L1-hv
> 	     |
> 	     G1
> 
>   And we're running in G0, then:
> 
>   - 'exclude_hv' would exclude L0 events
>   - 'exclude_host' would ... exclude L1-hv events?
>   - 'exclude_guest' would ... exclude G1 events?

From the point of view of G0, L0 *does not exist at all*.  You just
cannot see L0 events if you're running in G0.

exclude_host/exclude_guest are the right definition.

>   Then the next question is, if G0 is a host, does the L1-hv run in
>   G0 userspace or G0 kernel space?

It's mostly kernel, but sometimes you're interested in events from QEMU
or whoever else has opened /dev/kvm.  In that case you care about G0
userspace too.

> The way it is implemented, you basically have to always set
> exclude_host=0, even if there is no virt at all and you want to measure
> your own userspace thing -- which is just weird.

I understand regretting having exclude_guest that way; include_guest
(defaulting to 0!) would have made more sense.  But defaulting to
exclude_host==0 makes sense: if there is no virt at all, memset(0) does
the right thing so it does not seem weird to me.

> I suppose the 'best' option at this point is something like:
> 
> 	/*
> 	 * comment that explains the trainwreck.
> 	 */
> 	if (!exclude_host && !exclude_guest)
> 		exclude_guest = 1;
> 
> 	if ((!exclude_hv || !exclude_guest) && !perf_allow_kernel())
> 		return -EPERM;
> 
> But that takes away the possibility of actually having:
> 'exclude_host=0, exclude_guest=0' to create an event that measures both,
> which also sucks.

In fact both of the above "if"s suck. :(

Paolo

