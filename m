Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453E215B17C
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 21:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgBLUCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 15:02:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49240 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727923AbgBLUCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 15:02:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581537724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xACQJzdDDlbOWzGGCryoyeWskqYfJq+P7a8dbWxnMZg=;
        b=EaXusB6fxxGR0qZaqZr8nVMssqse3H0+S1yYgDuim2BZfomOvQPQ5adUouehb7O9xf4IS3
        eC6vlqo7Fsddv0mC4gwuYQtXK5FWEVUL+Pz+ThzewEILmzzAINDytZWMJpiUeqzNxLyVV4
        Ak5MwmRrHo03jv33LCTnAamEFK3sH6s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-Du6h6gJdPmiOOWq-TP60mA-1; Wed, 12 Feb 2020 15:02:02 -0500
X-MC-Unique: Du6h6gJdPmiOOWq-TP60mA-1
Received: by mail-wr1-f70.google.com with SMTP id w6so1272853wrm.16
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 12:02:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xACQJzdDDlbOWzGGCryoyeWskqYfJq+P7a8dbWxnMZg=;
        b=qW6eIfjqmqWIL0sbU3FeBNuDwKI2wwWZxM2ixMKEIlIordRkdKszqO8Rb1zuK+5Zr8
         YGCOoEkOPWT9HyBs2OErSpeZr8Sn6zH3MsbzcRKODlCCWAUjObl84uBW3QZ4Pb9fuyA2
         4LnJ5vNm7gufnnN6GoLiJ789X5HnRljwfCAVjH+bHIVkIveSHJDwOrHqDYbNlds4C9CM
         psz09MC68rmxR2/DCUg0qns42bBYrkLU1+YluazpwHfWw0Eh1C0qM7BLHxvrM0am/ORB
         vY5t5wq6r8DoSmo7LilGqAFuofasmcF+JeEyV1JtDdMnS3HRVgEyiE7zii53SQU8waWp
         HtpA==
X-Gm-Message-State: APjAAAWlR5TsQaQ0sKaEhNwIIuHhAnTYh+561W8jUc+KQBQUBYznWIhx
        xaEQtn1ZwpR9tXzTMDCBaV7xrKl5A+md5+NlKIxnGHTLvhQ8tX5AWaH76ktYyIclze1YtqVKUAj
        rEWYF5dySu2sp
X-Received: by 2002:adf:e2c5:: with SMTP id d5mr16732617wrj.165.1581537720864;
        Wed, 12 Feb 2020 12:02:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqwmfvhQhntZ0xl323TsLbJsGJRLD3EnRwc6SDjJpS5+J/aqGrVF/uNojcfTxi8DzEt/rbz3dA==
X-Received: by 2002:adf:e2c5:: with SMTP id d5mr16732593wrj.165.1581537720554;
        Wed, 12 Feb 2020 12:02:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id e16sm1954758wrs.73.2020.02.12.12.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 12:02:00 -0800 (PST)
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
References: <20200212164714.7733-1-pbonzini@redhat.com>
 <CAHk-=wh6KEgPz_7TFqSgg3T29SrCBU+h64t=BWyCKwJOrk3RLQ@mail.gmail.com>
 <b90a886e-b320-43d3-b2b6-7032aac57abe@redhat.com>
 <CAHk-=wh8eYt9b8SrP0+L=obHWKU0=vXj8BxBNZ3DYd=6wZTKqw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <23585515-73a9-596e-21f1-cbbcc9d7e7f9@redhat.com>
Date:   Wed, 12 Feb 2020 21:01:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wh8eYt9b8SrP0+L=obHWKU0=vXj8BxBNZ3DYd=6wZTKqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/02/20 20:38, Linus Torvalds wrote:
> On Wed, Feb 12, 2020 at 11:19 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>>> So this clearly never even got a _whiff_ of build-testing.
>>
>> Oh come on.
> 
> Seriously - if you don't even _look_ at the warnings the build
> generates, then it hasn't been build-tested.
>
> I don't want to hear "Oh come on". I'm 100% serious.

I know, but still I consider it.  There is no reason why the "build
test" should be anything more than "make && echo yes i am build-tested".
 It shouldn't involve any grep or script magic, it's already hard enough
to script all the functional part of the testing.

My "Oh come on" was because "it never got a whiff of build-testing"
hides how "the default build testing configuration is crap".  Of course
I don't want warnings either, but unless there is -Werror somewhere
mistakes _will_ happen.  Get new commits from you, or make mrproper to
build another architecture? Everything gets rebuilt and the warnings
scroll by.  During next-release development I will catch it of course,
but for rc I usually don't even need to build more than once before
applying a pull request.  I am surprised it took a few years for the
wrong set of factors to occur at the same time.

Did I screw up?  Yes.  Could we do better to avoid someone else doing
the same mistake?  Hell yes.

I'm not making excuses.  I'm just saying that the *root* cause is not my
mistake or even Oliver's.  The root cause is that our (shared!)
definition of "good" does not match the exit code of "make".  We all
want zero warnings, but we don't enable -Werror.  Let's add at least a
Kconfig to enable it for every architecture you build-test (is it only
x86 or anything else?).

Paolo

> Build-testing is not just "building". It's the "testing" of the build
> too. You clearly never did _any_ testing of the build, since the build
> had huge warnings.
> 
> Without the checking of the result, "build-testing" is just
> "building", and completely irrelevant.
> 
> If you have problems seeing the warnings, add a "-Werror" to your scripts.
>
> I do not want to see a _single_ warning in the kernel build. Yes, we
> have one in the samples code, and even that annoys the hell out of me.
> 
> And exactly because we don't have any warnings in the default build,
> it should be really really easy to check for new ones - it's not like
> you have to wade through pages of warnings to see if any of them are
> your new ones.
> 
> So no "Oh come on". You did *zero* testing of this crap, and you need
> to own that fact instead of making excuses about it.

