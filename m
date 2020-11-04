Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B752E2A633A
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 12:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgKDLZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 06:25:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729429AbgKDLZe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 06:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604489132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4BNZIwcWLTN05rBOOzJO8LbkDHmlhi2kEJTRvtJ7hAU=;
        b=J3Fa1msVyRjpeUHMPEeWlG6a9vKAIMc8UBGhWjKx8F052Zn/aMNMbJGAJlftUc03FdmQmJ
        tLm7of+FKLLXtrw0RAaGYVUu7uSB6TcJHmKKKKjdfR4RP7uh0NHHzqItjKtDCQUEpabXON
        scYiiqX53AWdbY5x4AIQlgADlpdkEVk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-ktf20k2lMISFepSwuN7_2g-1; Wed, 04 Nov 2020 06:25:31 -0500
X-MC-Unique: ktf20k2lMISFepSwuN7_2g-1
Received: by mail-wr1-f72.google.com with SMTP id t11so9163644wrv.10
        for <kvm@vger.kernel.org>; Wed, 04 Nov 2020 03:25:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4BNZIwcWLTN05rBOOzJO8LbkDHmlhi2kEJTRvtJ7hAU=;
        b=h7z6Z5XxuBmbQXGcFbmMlPrk2KeNxAbqVqLB/k25IjzABLlPiCz3T2p+HcDF29BTek
         Lxei4KOOHEiiUgiJSqhT002NYh1ZuDcbZft05rhRWNToZ/mpbwkAAEa8KKV1gvs5c0HP
         37p/z6zBvib971SZVlo9UZjStvb3labGdDIvFKRjNOiWLgo9jVWj+h8r4fe4dog7zC09
         p53UKH2x8EWPbgEorghtAxPvbdFg8ZyBlv44Shx6pgnoHQDYN8NfiMfRrLoafutdx1gO
         jW2SdEMfdZc+EKq36QxrdS2DYwyYjCHgYmwe+kYTZwQMIfnn7pGFRC78XxdYVfn8JcrI
         L3CQ==
X-Gm-Message-State: AOAM533A1EGuuOD84jiWEP+curQQfJJbyPPmpIg+ARyxS7ufNEmiDxGn
        7E/Q4DbcA6dWb77HXXC49PmQ3NseJO8KV6K2b6t04mFfncfq05YKcu2oHfYXWHHrdspUSZA4BZS
        sxLqyOHyadpTn
X-Received: by 2002:a5d:568a:: with SMTP id f10mr31437360wrv.30.1604489129506;
        Wed, 04 Nov 2020 03:25:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy78sXqYN4w55Ebpjk1oN0oNUR1qsCdGgREY39d7+iO2OT4Btt5UeKFF4E22t/folmBpRds0A==
X-Received: by 2002:a5d:568a:: with SMTP id f10mr31437337wrv.30.1604489129348;
        Wed, 04 Nov 2020 03:25:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u10sm2185735wrw.36.2020.11.04.03.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 03:25:28 -0800 (PST)
Subject: Re: [PATCH v2 1/2] sched/wait: Add add_wait_queue_priority()
To:     David Woodhouse <dwmw2@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        kvm@vger.kernel.org
References: <20201026175325.585623-1-dwmw2@infradead.org>
 <20201027143944.648769-1-dwmw2@infradead.org>
 <20201027143944.648769-2-dwmw2@infradead.org>
 <20201028143509.GA2628@hirez.programming.kicks-ass.net>
 <ef4660dba8135ca5a1dc7e854babcf65d8cef46f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7fec9ad1-f5b9-6a02-64f7-95aa83668773@redhat.com>
Date:   Wed, 4 Nov 2020 12:25:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <ef4660dba8135ca5a1dc7e854babcf65d8cef46f.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/20 10:35, David Woodhouse wrote:
> On Wed, 2020-10-28 at 15:35 +0100, Peter Zijlstra wrote:
>> On Tue, Oct 27, 2020 at 02:39:43PM +0000, David Woodhouse wrote:
>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> This allows an exclusive wait_queue_entry to be added at the head of the
>>> queue, instead of the tail as normal. Thus, it gets to consume events
>>> first without allowing non-exclusive waiters to be woken at all.
>>>
>>> The (first) intended use is for KVM IRQFD, which currently has
>>> inconsistent behaviour depending on whether posted interrupts are
>>> available or not. If they are, KVM will bypass the eventfd completely
>>> and deliver interrupts directly to the appropriate vCPU. If not, events
>>> are delivered through the eventfd and userspace will receive them when
>>> polling on the eventfd.
>>>
>>> By using add_wait_queue_priority(), KVM will be able to consistently
>>> consume events within the kernel without accidentally exposing them
>>> to userspace when they're supposed to be bypassed. This, in turn, means
>>> that userspace doesn't have to jump through hoops to avoid listening
>>> on the erroneously noisy eventfd and injecting duplicate interrupts.
>>>
>>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>>
>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> Thanks. Paolo, the conclusion was that you were going to take this set
> through the KVM tree, wasn't it?
> 

Yes.

Paolo

