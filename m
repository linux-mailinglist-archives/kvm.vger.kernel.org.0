Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA81B2796
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 23:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfIMV4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 17:56:10 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:46203 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfIMV4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 17:56:10 -0400
Received: by mail-wr1-f47.google.com with SMTP id o18so2214777wrv.13
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 14:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BBsZ4JWMNaV4EH0SCRq5e+QYsznn+tUuDwYGzEjYpmQ=;
        b=fsdep+1JH2kKJz3BfpY9RawUSS/+w2Xxhg/rd/l4VwL7KD+N9oFynJEdmvcmDl75iA
         UpN0trBvunSg06lR57zAhiHr/mRQclxY46pjFL1X5ykvX6ar/awpAvurT9tr44BJQ5hk
         tqe0IGYqIOYJ7GakO/DK5c6kjFB/fzhcqlqpji5nY1d7s7wSGt+TIJNWNun7oEAkDIaj
         luK3bmybPgZX8pViZXNkE0AXt/Lj4Yf0HHlz9XKZIAhhIy7Q4KXCiufCrLldWmRTv5U/
         J3R7c1Ou+5fI0iS8J1XaeL3I/3vpwkJHY3Eo6h8jG9x5ENfMtbkfVKan1/2IIHu4jCyo
         aagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BBsZ4JWMNaV4EH0SCRq5e+QYsznn+tUuDwYGzEjYpmQ=;
        b=kCQcfbb1MJtfSbQICjol5V2+glp0Ezbcf3JY5y48m9CU+DZf8Q6SED1KHUm9hZHJo6
         04Pvhmr5AfPN3uL32oR/Lcan5LkwLTbbKPIhrdEuKYscrLErOlYIfe4a4rJegDphZtcn
         1qUoAPkbzL9CjrzKge5Ci9Gn8JxoHRMUpEU+HYKkmbca+SH0/IjfwN9QyInITJ6KkOgz
         c5A1ngQ2dzYePXdTb7TMOd0wGfiueEq6tYYoumFH6Fs4oAU/EB8+l0zT6/rZkkS2x9OP
         vU5doAo7/jaxznF+ro5KR3/J53HG8WbVYXEY1FYoQEXnM6ZHJf24nYnzWy2U61iUiwKt
         0qUA==
X-Gm-Message-State: APjAAAV3e+JVNuRVCebaYelA8zWnWzNwYG7ZtksolHqPEgj7mVMcXY60
        I0YFitbsKMwZtryhIPQY1fq5BuOedAyyfPclH+0V+0rXDrk=
X-Google-Smtp-Source: APXvYqxMWNNXXpLxF4UZ9eITlaS9Zfi8S3pZABNmhunfzPSdSC3oVJMFXXef6wuJGkBZo0u/E1W+0lvONnTggjvX21g=
X-Received: by 2002:a05:6000:1081:: with SMTP id y1mr40589425wrw.53.1568411767420;
 Fri, 13 Sep 2019 14:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190912180928.123660-1-marcorr@google.com> <20190913152442.GC31125@linux.intel.com>
 <CAA03e5F3SNxcYxdeOg6ZUfxRA5gBe7qaMxSATL13sq1cUL63KQ@mail.gmail.com> <20190913183040.GA8904@linux.intel.com>
In-Reply-To: <20190913183040.GA8904@linux.intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 13 Sep 2019 14:55:56 -0700
Message-ID: <CAA03e5E28QaDAHjCg5J0_aPoY8pNnUiUQVvrZSHsEj0dq6-q7w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nvmx: test max atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for the review! I'll get to work on v2 now.

> > I'll happily apply what you've suggested in v2. But I don't see why
> > it's so terrible to over-allocate here. Leveraging a generic 2 MB page
> > allocator can be reused going forward, and encourages uniformity
> > across tests.
>
> My main concern is avoiding setting 6mb+ of memory.  I like to run the
> tests in L1 and L2 and would prefer to keep overhead at a minimum.
>
> As for the allocation itself, being precise in the allocation size is a
> form of documentation, e.g. it conveys that the size/order was chosen to
> ensure enough space for the maximum theoretical list size.  A purely
> arbitrary size, especially one that corresponds with a large page size,
> can lead to people looking for things that don't exist, e.g. the 2mb size
> is partially what led me to believe that this test was deliberately
> exceeding the limit, otherwise why allocate such a large amount of memory?
> I also didn't know if 2mb was sufficient to handle the maximum theoretical
> list size.

SGTM. I'll make this change in v2.

> > > Distilling things down to the bare minimum yields something like the
> > > following.
> >
> > Looks excellent overall. Still not clear what the consensus is on
> > whether or not to test the VM-entry failure. I think a flag seems like
> > a reasonable compromise. I've never added a flag to a kvm-unit-test,
> > so I'll see if I can figure that out.
>
> No need for a flag if you want to go that route, just put it in a separate
> VMX subtest and exclude said test from the [vmx] config, i.e. make the
> test opt-in.

SGTM, thanks!
