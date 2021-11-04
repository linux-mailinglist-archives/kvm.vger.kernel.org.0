Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821794455E7
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 15:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhKDPCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 11:02:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231293AbhKDPC2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 11:02:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636037989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OywEmERAjqnp3xpD/xphVv+JsaHYOpWwlE+ARSZcRms=;
        b=Kg0LnSrrmk8Sc8Dit+39rjPpTjkCwKgZn/U633klJb9AHr/L4ZoryiqX2/UDHIkdzssKEk
        D3foMJN0AdVCQxoOTRlyCbqnMfuzPCyx5JS6MJGju9NIjvnQgZA/54aIokh69A8P3w9sM8
        vKrjn2bBNQHeNAQbyo2eirpUDDs9q9I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-Ok9cUBdtMSqGR5gsnAhyLA-1; Thu, 04 Nov 2021 10:59:48 -0400
X-MC-Unique: Ok9cUBdtMSqGR5gsnAhyLA-1
Received: by mail-wm1-f69.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so2586443wmb.3
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 07:59:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=OywEmERAjqnp3xpD/xphVv+JsaHYOpWwlE+ARSZcRms=;
        b=5Hc9dmdIE05sXXwlnSte4AklBUxnCbi2DqO3KdfhbUMeHibQPPzyhqkt658dvdbejO
         TBWr4+FMYb5th4j+opG5VwfDnKnNrom5jPY8fC6s/JA2fXUb87ZI71h5FOH0SkgRDg9d
         EAxuq9UtDT6cnHb6zGBsYj/TsbWPJbhynbwUctcLsXMmzvqgiaWfxJZWFp6M4YZdUfWk
         MYjABts6SMIbBjoSCT9nt18S2AHeVkCwe6NJpROa+sulLgU7Uknu/hFrBFwL+3CV6vgd
         THBYPDQgzeBRpwEqyCHag6JXokOreGZNqm1oqG7Jkd7DUuhWaCp7WlFvV2T57hehbLL2
         3U5A==
X-Gm-Message-State: AOAM533Fj0cloTtLESPjuP0OUC0QI2Py7pKOsdcMHrugnNHdD7j/ZDwm
        GrwemhO+wFKRExjEIvjKwUMrkC9OD/zVtjmXW/w8GLIa/0rUYRkWRPs9uJxYLUYOYbQ1MeueITF
        YJ5TS7g0I0Hht
X-Received: by 2002:adf:e9c5:: with SMTP id l5mr47132644wrn.218.1636037987505;
        Thu, 04 Nov 2021 07:59:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZnsIUY59kEITzrweyjZxsCu4IT4tZhpy5RuLH2jpOCXwxIFNchYDAG95YngTbQOPWFa1y1Q==
X-Received: by 2002:adf:e9c5:: with SMTP id l5mr47132543wrn.218.1636037987209;
        Thu, 04 Nov 2021 07:59:47 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23c9c.dip0.t-ipconnect.de. [79.242.60.156])
        by smtp.gmail.com with ESMTPSA id u2sm5033198wrr.35.2021.11.04.07.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 07:59:46 -0700 (PDT)
Message-ID: <655b3473-ccbd-f198-6566-c23a0ec20940@redhat.com>
Date:   Thu, 4 Nov 2021 15:59:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211102194652.2685098-1-farman@linux.ibm.com>
 <20211102194652.2685098-3-farman@linux.ibm.com>
 <7e98f659-32ac-9b4e-0ddd-958086732c8d@redhat.com>
 <2ad9bef6b39a5a6c9b634cab7d70d110064d8f04.camel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH v2 2/2] KVM: s390: Extend the USER_SIGP capability
In-Reply-To: <2ad9bef6b39a5a6c9b634cab7d70d110064d8f04.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> For example, we don't care about concurrent SIGP SENSE. We only care
>> about "lightweight" SIGP orders with concurrent "heavy weight" SIGP
>> orders.
> 
> I very much care about concurrent SIGP SENSE (a "lightweight" order
> handled in-kernel) and how that interacts with the "heavy weight" SIGP
> orders (handled in userspace). SIGP SENSE might return CC0 (accepted)
> if a vcpu is operating normally, or CC1 (status stored) with status
> bits indicating an external call is pending and/or the vcpu is stopped.
> This means that the actual response will depend on whether userspace
> has picked up the sigp order and processed it or not. Giving CC0 when
> userspace is actively processing a SIGP STOP/STOP AND STORE STATUS
> would be misleading for the SIGP SENSE. (Did the STOP order get lost?
> Failed? Not yet dispatched? Blocked?)

But that would only visible when concurrently SIGP STOP'ing from one
VCPU and SIGP SENSE'ing from another VCPU. But in that case, there are
already no guarantees, because it's inherently racy:

VCPU #2: SIGP STOP #3
VCPU #1: SIGP SENSE #3

There is no guarantee who ends up first
a) In the kernel
b) On the final destination (SENSE -> kernel; STOP -> QEMU)

They could be rescheduled/delayed in various ways.


The important part is that orders from the *same* CPU are properly
handled, right?

VCPU #1: SIGP STOP #3
VCPU #1: SIGP SENSE #3

SENSE must return BUSY in case the STOP was not successful yet, correct?

And that can be achieved by setting the VCPU #3 busy when landing in
user space to trigger the SIGP STOP, before returning to the kernel and
processing the SIGP SENSE.


Or am I missing something important?

> 
> Meanwhile, the Principles of Operation (SA22-7832-12) page 4-95
> describes a list of orders that would generate a CC2 (busy) when the
> order is still "active" in userspace:
> 
> """
> A previously issued start, stop, restart, stop-
> and-store-status, set-prefix, store-status-at-
> address order, or store-additional-status-at-
> address has been accepted by the
> addressed CPU, and execution of the func-
> tion requested by the order has not yet been
> completed.

Right, but my take is that the order has not been accepted by the target
CPU before we're actually in user space to e.g., trigger SIGP STOP.

> ...
> If the currently specified order is sense, external
> call, emergency signal, start, stop, restart, stop
> and store status, set prefix, store status at
> address, set architecture, set multithreading, or
> store additional status at address, then the order
> is rejected, and condition code 2 is set. If the cur-
> rently specified order is one of the reset orders,
> or an unassigned or not-implemented order, the
> order code is interpreted as described in “Status
> Bits” on page 4-96.
> """
> 
> (There is another entry for the reset orders; not copied here for sake
> of keeping my novella manageable.)

Yes, these have to be special because we can have CPUs that never stop
(endless program interruption stream).

> 
> So, you're right that I could be more precise in terms how QEMU handles
> a SIGP order while it's already busy handling one, and only limit the
> CC2 from the kernel to those in-kernel orders. But I did say I took
> this simplified approach in the cover letter. :)
> 
> Regardless, because of the above I really do want/need a way to give
> the kernel a clue that userspace is doing something, without waiting
> for userspace to say "hey, that order you kicked back to me? I'm
> working on it now, I'll let you know when it's done!" Otherwise, SIGP
> SENSE (and other lightweight friends) is still racing with the receipt
> of a "start the sigp" ioctl.

And my point is that it's only visible when two VCPUs are involved and
there are absolutely no guarantees regarding that. (see my first reply)


-- 
Thanks,

David / dhildenb

