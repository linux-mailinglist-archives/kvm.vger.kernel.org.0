Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719B1416555
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 20:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242777AbhIWSpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 14:45:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242714AbhIWSpx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 14:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632422661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x46eN9ZPpLusYWrqgbutzxSh8ecH9uBw9nNtjHfLCXU=;
        b=h4ZEuaEtpuF/qXCpAC/phsc/9MvmQQJQvfX6NfmedhFQ4YZsT79mN7fUKCMY+j5vKPThv/
        hlJQGbg2mSE7IRXmkBCLfyX2nMadHTXFGTXqYtHWEO0DiyK6AihdycLoWymQ8dbQzUI1WS
        NbH2WkM5trQQbiB7cUn7RG8fxgcPAXc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-6_9ewU9IMOCnCevn3Er9sQ-1; Thu, 23 Sep 2021 14:44:20 -0400
X-MC-Unique: 6_9ewU9IMOCnCevn3Er9sQ-1
Received: by mail-ed1-f69.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso7648821edi.1
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 11:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x46eN9ZPpLusYWrqgbutzxSh8ecH9uBw9nNtjHfLCXU=;
        b=FutyNKTrFZtLuIv9v6cIFil83EdeDIDdEaYkP2dlIEsykTeLS9GTB8OMSC9ZdLAmyb
         czP+ywhXqHm5Izq1rps3xIBnhT/k2t/r29q56qnN5CMR3kQ4sOb7B0L4Wmg2HbVkbjz6
         zr8WS1nwq9/ZrGcMe9d9h0jIZXuW82CfDkc3SgGlMaueyLj8yOTPLMio0TxHI9IlP+pX
         HKV3tgIjumzMQF/HZrGq36Y+mtx8nvBukge3T4hqjWA3KkgUVBoaRDi60+1GpxekWzEW
         dCRujKAnyJeGe8TkXAJFzGxsc3zm7OD+dsUxd1S4XAiDRXCniQvWNVk1VEjepypwLbo5
         I5ew==
X-Gm-Message-State: AOAM531xwUSs/bUX9KYA7+26d5tl7Omjm7jqi/YxvVp1RUefRSsH3wrk
        8g9JZZVkNSEtJxnfC/CZy19qdNxkkIxtkEBsgiyfb5z2vO6c00ZUOTGaBOQ8rQdhea9fCkL3Id2
        B+GBkypnbkTA7jKT6mLXLriuAuxPeFB9CJYrJCCq2B1hB7VlIV09FwRzVf8SGSe5p
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr7023134ejy.493.1632422659137;
        Thu, 23 Sep 2021 11:44:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTdMDL6/n0aYA0fgWnBgCS+Q0RVDKeac5WzIl4FyXndcJbeT1l9fh0WjKxt9aUl05CJr3cZQ==
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr7023096ejy.493.1632422658785;
        Thu, 23 Sep 2021 11:44:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ku7sm3608060ejc.90.2021.09.23.11.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 11:44:18 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/rseq changes for Linux 5.15-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <20210923181252.44385-1-pbonzini@redhat.com>
 <CAHk-=wjp7psdNc8KpxVDmcVYaAAxDUvvFTgx21OwZJzkghktLg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5b351abc-3bb7-abce-7a5c-2d16f6fe9b34@redhat.com>
Date:   Thu, 23 Sep 2021 20:44:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjp7psdNc8KpxVDmcVYaAAxDUvvFTgx21OwZJzkghktLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/21 20:35, Linus Torvalds wrote:
> But I'm adding a few people to the cc for a completely different
> reason: the cleanup to move all the notify_resume stuff to
> tracehook_notify_resume() is good, but it does make me go - once again
> - "Hmm, that naming is really really bad".

Absolutely, it's even in the commit message:

---
Note, tracehook_notify_resume() is horribly named and arguably does not
belong in tracehook.h as literally every line of code in it has nothing
to do with tracing.  But, that's been true since commit a42c6ded827d
("move key_repace_session_keyring() into tracehook_notify_resume()")
first usurped tracehook_notify_resume() back in 2012.  Punt cleaning that
mess up to future patches.
---

As you point out, it's really all of the header and not just that one
function.

Paolo

> The <linux/tracehook.h> code was literally meant for tracing. It's
> where the name comes from, and it's the original intent: having a
> place that you can hook into for tracing that doesn't depend on how
> the core kernel code ends up changing.
> 
> But that's not how it actually acts right now. That header file is now
> some very core functionality, and little of it is actually related to
> tracing any more. It's more core process state handling for the user
> space return path.
> 
> So I don't object to the patches, and they are merged, but I'm cc'ing people to
> 
>   (a) let them know about this (see commit a68de80f61f6: "entry: rseq:
> Call rseq_handle_notify_resume() in tracehook_notify_resume()" in the
> current -git tree)
> 
>   (b) possibly prod some people into perhaps moving/renaming some of
> that code to actual core kernel C files, instead of a misnamed header
> file..
> 
> Hmm?
> 
>           Linus
> 

