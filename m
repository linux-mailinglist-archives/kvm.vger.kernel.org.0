Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F142F783CED
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 11:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbjHVJaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 05:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbjHVJaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 05:30:07 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C841A5;
        Tue, 22 Aug 2023 02:30:05 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bc83a96067so24295915ad.0;
        Tue, 22 Aug 2023 02:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692696605; x=1693301405;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lCRik0YPn6zGFydyKXFsTHT3Lhr4dvWbpOAeptHYZ4Y=;
        b=sOexN9z+fVpl9ZwQ2r/TlywBjQZD5T7t57MBaptBk9QYlGcRUtTmD8YI/ztW0ENSix
         9DeVLf3b1FYHPdaAY6OF90CH9Glk2nY7telwwwlX2U1ocHwuPpN0i3GXh9yHdXhn0qZj
         NkErfoKfdYrXGIToUYU5OCG/Iq6AZC1SXD8/p4OMVC+ezyt3PZex9M5TfjUhwS35CRCv
         A1ScCy8NwB7m1vZ9nk0lB6tO6koh+yonzZq4tub90hF87M+w0D83/H0Ul5nky2InqWyO
         UpBJpezxIeaH7bvFYeDtN8VGxc91lW2KruvKP0lb8JzpgmqyGSCTUjNURkQ2gjvTraxW
         ikPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692696605; x=1693301405;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lCRik0YPn6zGFydyKXFsTHT3Lhr4dvWbpOAeptHYZ4Y=;
        b=Xls5HPjxd6g01tHDLImwKN0zbNYfZbBCCrMecZM4tExLmcYQ+BkT2YmjTnk2AmsCYO
         o/uupRwHN8364JtrQVykaOnNtkYRU6Trrwfik3fCAxK5EkPZh7+xztnUXFN9WO0cOkMu
         QRFO1uf5jgAOlwZKN8Kys6Khu43B6hEWYKfB4G9N9Egm0x+UAaWinjDnvSjjGkSLlC6H
         RWDHs/RJTZRc1DBmDZB2Vvhg0Emt6h+NId+/jNhLBzOEXaeE9PMAlltp6XjRyYvufWiC
         m++Ox3GOZ2XQoR5jd68HUqwN8Btj6MmN4hCEKj94gxZrv8UzzoFKzM3Qe7vNLyDVfKPs
         mYPw==
X-Gm-Message-State: AOJu0YxDaMZT6k9gFJlNzOwMeR1yRqkXFSHBgI2/RyGc0WMrCYS1q7c/
        JCuy7unp4ZIpv05VmOHBlMI=
X-Google-Smtp-Source: AGHT+IHtDOPpXYFq5RpVde6MoViKqJyL+vLH6eoqmWJqRfGseWq2PVDG3nQrUjv2GCW9dqg/+PjukA==
X-Received: by 2002:a17:903:1c4:b0:1bb:b91b:2b3c with SMTP id e4-20020a17090301c400b001bbb91b2b3cmr7550714plh.34.1692696604898;
        Tue, 22 Aug 2023 02:30:04 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q4-20020a170902bd8400b001b9f032bb3dsm8523129pls.3.2023.08.22.02.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 02:30:04 -0700 (PDT)
Message-ID: <bdc2be50-c8c4-ff06-196f-d9b67e61a6b5@gmail.com>
Date:   Tue, 22 Aug 2023 17:29:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Roman Kagan <rkagan@amazon.de>
References: <20230504120042.785651-1-rkagan@amazon.de>
 <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com>
 <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com>
 <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
 <ZJ74gELkj4DgAk4S@google.com> <ZJ9IaskpbIK9q4rt@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZJ9IaskpbIK9q4rt@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/2023 5:26 am, Sean Christopherson wrote:
> Ugh, yeah, de0f619564f4 created a bit of a mess.  The underlying issue that it
> was solving is that perf_event_read_value() and friends might sleep (yay mutex),
> and so can't be called from KVM's fastpath (IRQs disabled).
Updating pmu counters for emulated instructions cause troubles.

> 
> However, detecting overflow requires reading perf_event_read_value() to gather
> the accumulated count from the hardware event in order to add it to the emulated
> count from software.  E.g. if pmc->counter is X and the perf event counter is Y,
> KVM needs to factor in Y because X+Y+1 might overflow even if X+1 does not.
> 
> Trying to snapshot the previous counter value is a bit of a mess.  It could probably
> made to work, but it's hard to reason about what the snapshot actually contains
> and when it should be cleared, especially when factoring in the wrapping logic.
> 
> Rather than snapshot the previous counter, I think it makes sense to:
> 
>    1) Track the number of emulated counter events

If events are counted separately, the challenge here is to correctly time
the emulation of counter overflows, which can occur on both sides of the
counter values out of sync.

>    2) Accumulate and reset the counts from perf_event and emulated_counter into
>       pmc->counter when pausing the PMC
>    3) Pause and reprogram the PMC on writes (instead of the current approach of
>       blindly updating the sample period)

Updating the sample period is the only interface for KVM to configure hw
behaviour on hw-ctr. I note that perf_event_set_count() will be proposed,
and I'm pessimistic about this change.

>    4) Pause the counter when stopping the perf_event to ensure pmc->counter is
>       fresh (instead of manually updating pmc->counter)
> 
> IMO, that yields more intuitive logic, and makes it easier to reason about
> correctness since the behavior is easily define: pmc->counter holds the counts
> that have been gathered and processed, perf_event and emulated_counter hold
> outstanding counts on top.  E.g. on a WRMSR to the counter, both the emulated
> counter and the hardware counter are reset, because whatever counts existed
> previously are irrelevant.

If we take the hardware view, a counter, emulated or not, just increments
and overflows at the threshold. The missing logic here is when the counter
is truncated when writing high bit-width values, and how to deal with the
value of pmc->prev_counter was before pmc->counter was truncated.

> 
> Pausing the counter_might_  make WRMSR slower, but we need to get this all
> functionally correct before worrying too much about performance.

Performance, security and correctness should all be considered at the beginning.

> 
> Diff below for what I'm thinking (needs to be split into multiple patches).  It's
> *very*  lightly tested.

It saddens me that no one has come up with an actual low-level counter-test for 
this issue.

> 
> I'm about to disappear for a week, I'll pick this back up when I get return.  In
> the meantime, any testing and/or input would be much appreciated!

How about accepting Roman's original fix and then exercising the rewriting genius ?
