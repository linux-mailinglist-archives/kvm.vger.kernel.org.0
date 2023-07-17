Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5550B756224
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 13:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjGQL6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 07:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjGQL6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 07:58:44 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9C8E6
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 04:58:43 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6682909acadso2808211b3a.3
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 04:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689595123; x=1692187123;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ptc8VsW5kzG278uKrrYn+kSA2zDJejBtuWV3SmbYN4=;
        b=UEgJgw3lOZ1i58bT+zocpkpA6+Vwe4rRTVUSR9UyRe8QbOzm8aUcBFsQW5xzEKfvjW
         qMqoyloTvGFh668MAgNRDYVmnWF9AwApBUZAfCViY9JmYPlKUUhIGV2/4LKzj9EMTN8J
         8kKJGocOfI+zO+ZzizsKK/gWr51jA+54c3+u78jup9iCTDziNnMha2vm/IKyfuZXf4cg
         OpVVLxL/ioKDcJ6Gv71gbESmYzBUwhkq3PrKDhns6GpcfQQHCkyF5IP+Hzlu8ov3YFG+
         R4+pq538y8azeHoAykxOsTATnLByNZgCwFgMwchyDCOytOGjqiX3Rd2P3Vx7pUjTKI4s
         hhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689595123; x=1692187123;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ptc8VsW5kzG278uKrrYn+kSA2zDJejBtuWV3SmbYN4=;
        b=KFOWH9G5uk7LZ0gB9RDLfpeG/Gt9rsr5GlIeM93QihHfWScdPvTse7bVOn6KQSqWD7
         S5aUXgaAfbr6fnrJ40Pb2fXab+Rs7117aaGkw9zmKxIJ5VHVUh2q9gWGKtt+avGaX4es
         nLp491wF9mKPCGtWo8PdT+11hd09HynFgyz2o6Fv06nE9+jiPLSPDJULsmiqpEya0/rz
         N3BJcO6g2UQyCJHMBDv6OFfGwxO2meek9YFLcsjRHjqIu2P+tJ+0nnnXhVyGbU6rlL2I
         G3AafizIXQU2bNHemIap5wukcEYGKAgtYwxClqy5CkmP4M80XPDjMO07OHaYZbRZ2F29
         AkUw==
X-Gm-Message-State: ABy/qLbEIMIzi0dmWmJJ46goH4JeHBUhL/b1ROBFWOKJFRToXh09GNio
        9IeTMe1Vl9n5ZmcrOF5cPQo=
X-Google-Smtp-Source: APBJJlH3bB1YcJMN82LyrjQnK689s+YEMdx7vLrvV70Z68zIhLP/LdPIJ4DUQaxYx4eNEETqreNVgw==
X-Received: by 2002:a05:6a00:2484:b0:668:94a2:2ec7 with SMTP id c4-20020a056a00248400b0066894a22ec7mr14597755pfv.25.1689595122911;
        Mon, 17 Jul 2023 04:58:42 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ey24-20020a056a0038d800b00666add7f047sm11766634pfb.207.2023.07.17.04.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 04:58:41 -0700 (PDT)
Message-ID: <c1ac9dae-51d8-f570-db6c-39a161ab6bb9@gmail.com>
Date:   Mon, 17 Jul 2023 19:58:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [Bug 217379] New: Latency issues in irq_bypass_register_consumer
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>,
        "Alex Williamson, Red Hat" <alex.williamson@redhat.com>
References: <bug-217379-28872@https.bugzilla.kernel.org/>
 <ZE/uDYGhVAJ28LYu@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZE/uDYGhVAJ28LYu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/5/2023 12:51 am, Sean Christopherson wrote:
> On Fri, Apr 28, 2023, bugzilla-daemon@kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=217379
>>
>>              Bug ID: 217379
>>             Summary: Latency issues in irq_bypass_register_consumer
>>             Product: Virtualization
>>             Version: unspecified
>>            Hardware: Intel
>>                  OS: Linux
>>              Status: NEW
>>            Severity: normal
>>            Priority: P3
>>           Component: kvm
>>            Assignee: virtualization_kvm@kernel-bugs.osdl.org
>>            Reporter: zhuangel570@gmail.com
>>          Regression: No
>>
>> We found some latency issue in high-density and high-concurrency scenarios,
>> we are using cloud hypervisor as vmm for lightweight VM, using VIRTIO net and
>> block for VM. In our test, we got about 50ms to 100ms+ latency in creating VM
>> and register irqfd, after trace with funclatency (a tool of bcc-tools,
>> https://github.com/iovisor/bcc), we found the latency introduced by following
>> functions:
>>
>> - irq_bypass_register_consumer introduce more than 60ms per VM.
>>    This function was called when registering irqfd, the function will register
>>    irqfd as consumer to irqbypass, wait for connecting from irqbypass producers,
>>    like VFIO or VDPA. In our test, one irqfd register will get about 4ms
>>    latency, and 5 devices with total 16 irqfd will introduce more than 60ms
>>    latency.
>>
>> Here is a simple case, which can emulate the latency issue (the real latency
>> is lager). The case create 800 VM as background do nothing, then repeatedly
>> create 20 VM then destroy them after 400ms, every VM will do simple thing,
>> create in kernel irq chip, and register 15 riqfd (emulate 5 devices and every
>> device has 3 irqfd), just trace the "irq_bypass_register_consumer" latency, you
>> will reproduce such kind latency issue. Here is a trace log on Xeon(R) Platinum
>> 8255C server (96C, 2 sockets) with linux 6.2.20.
>>
>> Reproduce Case
>> https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/kvm_irqfd_fork.c
>> Reproduce log
>> https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/test.log
>>
>> To fix these latencies, I didn't have a graceful method, just simple ideas
>> is give user a chance to avoid these latencies, like new flag to disable
>> irqbypass for each irqfd.
>>
>> Any suggestion to fix the issue if welcomed.
> 
> Looking at the code, it's not surprising that irq_bypass_register_consumer() can
> exhibit high latencies.  The producers and consumers are stored in simple linked
> lists, and a single mutex is held while traversing the lists *and* connecting
> a consumer to a producer (and vice versa).
> 
> There are two obvious optimizations that can be done to reduce latency in
> irq_bypass_register_consumer():
> 
>     - Use a different data type to track the producers and consumers so that lookups
>       don't require a linear walk.  AIUI, the "tokens" used to match producers and
>       consumers are just kernel pointers, so I _think_ XArray would perform reasonably
>       well.
My measurements show that there is little performance gain from optimizing lookups.

> 
>     - Connect producers and consumers outside of a global mutex.

In usage scenarios where a large number of VMs are created, it is very awful to 
have races
on this global mutex, especially when users on different NUMA nodes are concurrently
walking this critical path.

Wait time to acquire this lock (on 2.70GHz ICX):
- avg = 117.855314 ms
- min = 20 ns
- max = 11428.340.858 ms

Before we optimize this path using rewrites, could we first adopt a conservative 
approach:

- introduce the KVM_IRQFD_FLAG_NO_BYPASS [*], or
- introduce module_param_cb(kvm_irq_bypass ...) (644abbb254b1), or
- introduce extra Kconfig knob for "select IRQ_BYPASS_MANAGER";

[*] 
https://lore.kernel.org/kvm/bug-217379-28872-KU8tTDkhtT@https.bugzilla.kernel.org%2F/

Any better move ?

> 
> Unfortunately, because .add_producer() and .add_consumer() can fail, and because
> connections can be established by adding a consumer _or_ a producer, getting the
> locking right without a global mutex is quite difficult.  It's certainly doable
> to move the (dis)connect logic out of a global lock, but it's going to require a
> dedicated effort, i.e. not something that can be sketched out in a few minutes
> (I played around with the code for the better part of an hour trying to do just
> that and kept running into edge case race conditions).
> 
