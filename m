Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4016FEFF7E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 15:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389515AbfKEOLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 09:11:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45075 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389486AbfKEOLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 09:11:52 -0500
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 824B081DE3
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 14:11:51 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id y3so5498880wrm.12
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 06:11:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EkDCY7ijO5SQqK949MOdQ62nUzWqq7wHG7AQeLvnhlw=;
        b=WWB+F5CicQznjDl+bZt/2b+l1di5u1HbOmLDXU7Fp9dMPgywh7QE8HMApefGywgG9S
         ulRyjDy+Ux9FOuCpI+++m5RcetBC0FyLEZ1h3iPPk5Q6Bub/huBcBOK6IJjaHzM8bvei
         VAc4/jos3BpQASCbc5RCxDdalKkpTqv4duJqvW+uB4RRHW2eRu89uR9gNfhkgPSVWxB3
         LzrWdBWdxZ7N+XEySmdOK2SjnMCtEvUOktC3HQY8vWKgf0sfij5b8ZOAdo4C4WPcuot1
         Ac29CxUT1aOkx69RxpG44vuWdIdlIOh1vmnDCGEMI1hbL3jPg4d5GOMBTnqT3fAR2tdO
         astA==
X-Gm-Message-State: APjAAAXaPBLLyjwu5zNLRj83LZAMjv6+xVoxar6DkUFzWhw+uwA7nKoy
        Yl3dzJogJn5aHBbJNqPfT8cRZCHB2jAwoGkQVwUewyf9TyFRb0/76J/zalJm+8IjzCfTBD5K9pn
        ZnETSk6UZTiN1
X-Received: by 2002:adf:f192:: with SMTP id h18mr30049434wro.148.1572963110034;
        Tue, 05 Nov 2019 06:11:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqxUPTma9hOlEpDdUWQmQaJiZsL6tt3pXEjgbC4Z+qEmwG1hi7Kqk/a2UTfdviEV9OwuW0FLfA==
X-Received: by 2002:adf:f192:: with SMTP id h18mr30049412wro.148.1572963109679;
        Tue, 05 Nov 2019 06:11:49 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q6sm21502159wrx.30.2019.11.05.06.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 06:11:49 -0800 (PST)
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-4-aarcange@redhat.com>
 <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
 <678358c1-0621-3d2a-186e-b60742b2a286@redhat.com>
 <20191105135414.GA30717@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <330acce5-a527-543b-84c0-f3d8d277a0e2@redhat.com>
Date:   Tue, 5 Nov 2019 15:09:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105135414.GA30717@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 14:54, Andrea Arcangeli wrote:
> x86-64 is already bisectable.
> 
> All other archs bisectable I didn't check them all anyway.
> 
> Even 4/13 is suboptimal and needs to be re-done later in more optimal
> way. I prefer all logic changes to happen at later steps so one can at
> least bisect to something that functionally works like before. And
> 4/13 also would need to be merged in the huge patch if one wants to
> guarantee bisectability on all CPUs, but it'll just be hidden there in
> the huge patch.
> 
> Obviously I can squash both 3/13 and 4/13 into 2/13 but I don't feel
> like doing the right thing by squashing them just to increase
> bisectability.

You can reorder patches so that kvm_x86_ops assignments never happen.
That way, 4/13 for example would be moved to the very beginning.

>> - look into how to remove the modpost warnings.  A simple (though
>> somewhat ugly) way is to keep a kvm.ko module that includes common
>> virt/kvm/ code as well as, for x86 only, page_track.o.  A few functions,
>> such as kvm_mmu_gfn_disallow_lpage and kvm_mmu_gfn_allow_lpage, would
>> have to be moved into mmu.h, but that's not a big deal.
> 
> I think we should:
> 
> 1) whitelist to shut off the warnings on demand

Do you mean adding a whitelist to modpost?  That would work, though I am
not sure if the module maintainer (Jessica Yu) would accept that.

> 2) verify that if two modules are registering the same export symbol
>    the second one fails to load and the module code is robust about
>    that, this hopefully should already be the case
> 
> Provided verification of 2), the whitelist is more efficient than
> losing 4k of ram in all KVM hypervisors out there.

I agree.

>> - provide at least some examples of replacing the NULL kvm_x86_ops
>> checks with error codes in the function (or just early "return"s).  I
>> can help with the others, but remember that for the patch to be merged,
>> kvm_x86_ops must be removed completely.
> 
> Even if kvm_x86_ops wouldn't be guaranteed to go away, this would
> already provide all the performance benefit to the KVM users, so I
> wouldn't see a reason not to apply it even if kvm_x86_ops cannot go
> away.

The answer is maintainability.  My suggestion is that we start looking
into removing all assignments and tests of kvm_x86_ops, one step at a
time.  Until this is done, unfortunately we won't be able to reap the
performance benefit.  But the advantage is that this can be done in many
separate submissions; it doesn't have to be one huge patch.

Once this is done, removing kvm_x86_ops is trivial in the end.  It's
okay if the intermediate step has minimal performance regressions, we
know what it will look like.  I have to order patches with maintenance
first and performance second, if possible.

By the way, we are already planning to make some module parameters
per-VM instead of global, so this refactoring would also help that effort.

> Said that it will go away and there's no concern about it. It's
> just that the patchset seems large enough already and it rejects
> heavily already at every port. I simply stopped at the first self
> contained step that provides all performance benefits.

That is good enough to prove the feasibility of the idea, so I agree
that was a good plan.

Paolo

> If I go ahead and remove kvm_x86_ops how do I know it won't reject
> heavily the next day I rebase and I've to redo it all from scratch? If
> you explain me how you're going to guarantee that I won't have to do
> that work more than once I'd be happy to go ahead.
