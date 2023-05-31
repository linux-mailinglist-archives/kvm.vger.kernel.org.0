Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22117188A0
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjEaRlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 13:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjEaRks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 13:40:48 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C53510CB
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 10:40:19 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-75b1975ea18so395946885a.3
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 10:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vultr.com; s=google; t=1685554819; x=1688146819;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yXp1RUK8ObiOcFYtO3+OuQ5bKcre6F1M14ngTQGctvQ=;
        b=QVcAelLQ1/6ezCKuZMi8ImBzi0tpJfN7EGV8VDQ5e+a5cpPFT3AA7czS9FMArbT7VR
         7FjfPgFgYD4GcK1/MaNTI1VobOgmnSLmawQnmU7U22pw/jbY+Sphg4nYVJEjaruvpJi7
         /5axfecYhN9wmgdzrnx2X3snKOORTFydUBSBp8rGVJ1culR8PzXCkKQfweYB21zYXpjI
         /xVPqbNsC0fEyBQOteFGMRlXV02XDCBZjgUGyzIDG9U3qh7y4WUuD17iG0Sf3gJn6fIQ
         VUA7PmC06jY57/srnMroMVvAlZ8HE6gMoMTviblA2MTbD0qzI0RHJOEgvfMk5dd0Ejr/
         SufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685554819; x=1688146819;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yXp1RUK8ObiOcFYtO3+OuQ5bKcre6F1M14ngTQGctvQ=;
        b=NA6qPEBqclmtul+uJhizmjh9AywMswtf6PQ8NzITIZx5/uN9uq+6If/dhLQ7QI5qSd
         y9IPeiTT13Y8WyDnVa8DZrPt00L+xqyntdhRyCp6ddW4HoXuC/fS8N6KHvfBulPQYTkT
         b21OAdfFtyLCwKuyKfHz+qxFn62LaPxmxfqCPm6ftNWPfTd2Vo4qdvE4KWOdnitPmoid
         zmlFVZinzUZcndL1sVUYYehxAzQSbhH8k9iCus1WVO3zFkN3lT9eEY2GyLCHW4WKShic
         1m7+seJo/nCR3mh148rcSVBLxfLv0XphQfKB/AuxsEJPmhvb9DLPnz62HvLZZrMJx7aZ
         Znkg==
X-Gm-Message-State: AC+VfDxvvMoQHfK86N4Jr1LLdsOud7psxSSN2aIEH54CeoqRRYAV8Iz2
        fe0fQgak8KDGowP76wHcdTnk4cWUlomBn5UBnFY=
X-Google-Smtp-Source: ACHHUZ5fYbRU2/6vE2IuO78ZQ/GfPkdtDyD3+JoQ0116m8wexlZsUu6UrIuGzRdxOPIQRcOJa2mwAQ==
X-Received: by 2002:a05:6214:5294:b0:625:7802:f382 with SMTP id kj20-20020a056214529400b006257802f382mr6502859qvb.50.1685554818814;
        Wed, 31 May 2023 10:40:18 -0700 (PDT)
Received: from [10.7.101.16] ([208.167.225.210])
        by smtp.gmail.com with ESMTPSA id u7-20020ae9c007000000b0075784a8f13csm4962883qkk.96.2023.05.31.10.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 10:40:18 -0700 (PDT)
From:   Brian Rak <brak@vultr.com>
X-Google-Original-From: Brian Rak <brak@gameservers.com>
Message-ID: <7fb24485-5049-a64c-0f62-bedebbc5eec2@gameservers.com>
Date:   Wed, 31 May 2023 13:40:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Reply-To: brak@gameservers.com
Subject: Re: Deadlock due to EPT_VIOLATION
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com>
 <ZGzoUZLpPopkgvM0@google.com>
 <44ba516b-afe0-505d-1a87-90d489f9e03f@gameservers.com>
 <bce4b387-638d-7f3c-ca9b-12ff6e020bad@vultr.com>
 <ZHEefxsu5E3BsPni@google.com>
 <9fa11f06-bd55-b061-d16a-081351f04a13@gameservers.com>
 <ZHZCEUzr9Ak7rkjG@google.com>
In-Reply-To: <ZHZCEUzr9Ak7rkjG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/30/2023 2:36 PM, Sean Christopherson wrote:
> On Tue, May 30, 2023, Brian Rak wrote:
>> On 5/26/2023 5:02 PM, Sean Christopherson wrote:
>>> On Fri, May 26, 2023, Brian Rak wrote:
>>>> On 5/24/2023 9:39 AM, Brian Rak wrote:
>>>>> On 5/23/2023 12:22 PM, Sean Christopherson wrote:
>>>>>> The other thing that would be helpful would be getting kernel stack
>>>>>> traces of the
>>>>>> relevant tasks/threads.ï¿½ The vCPU stack traces won't be interesting,
>>>>>> but it'll
>>>>>> likely help to see what the fallocate() tasks are doing.
>>>>> I'll see what I can come up with here, I was running into some
>>>>> difficulty getting useful stack traces out of the VM
>>>> I didn't have any luck gathering guest-level stack traces - kaslr makes it
>>>> pretty difficult even if I have the guest kernel symbols.
>>> Sorry, I was hoping to get host stack traces, not guest stack traces.  I am hoping
>>> to see what the fallocate() in the *host* is doing.
>> Ah - here's a different instance of it with a full backtrace from the host:
> Gah, I wasn't specific enough again.  Though there's no longer an fallocate() for
> any of the threads', so that's probably a moot point.  What I wanted to see is what
> exactly the host kernel was doing, e.g. if something in the host memory management
> was indirectly preventing vCPUs from making forward progress.  But that doesn't
> seem to be the case here, and I would expect other problems if fallocate() was
> stuck.  So ignore that request for now.
>
>>> Another datapoint that might provide insight would be seeing if/how KVM's page
>>> faults stats change, e.g. look at /sys/kernel/debug/kvm/pf_* multiple times when
>>> the guest is stuck.
>> It looks like pf_taken is the only real one incrementing:
> Drat.  That's what I expected, but it doesn't narrow down the search much.
>
>>> Are you able to run modified host kernels?  If so, the easiest next step, assuming
>>> stack traces don't provide a smoking gun, would be to add printks into the page
>>> fault path to see why KVM is retrying instead of installing a SPTE.
>> We can, but it can take quite some time from when we do the update to
>> actually seeing results.ï¿½ This problem is inconsistent at best, and even
>> though we're seeing it a ton of times a day, it's can show up anywhere.ï¿½
>> Even if we rolled it out today, we'd still be looking at weeks/months before
>> we had any significant number of machines on it.
> Would you be able to run a bpftrace program on a host with a stuck guest?  If so,
> I believe I could craft a program for the kvm_exit tracepoint that would rule out
> or confirm two of the three likely culprits.
>
> Can you also dump the kvm.ko module params?  E.g. `tail /sys/module/kvm/parameters/*`

Yes, we can run bpftrace programs

# tail /sys/module/kvm/parameters/*
==> /sys/module/kvm/parameters/eager_page_split <==
Y

==> /sys/module/kvm/parameters/enable_pmu <==
Y

==> /sys/module/kvm/parameters/enable_vmware_backdoor <==
N

==> /sys/module/kvm/parameters/flush_on_reuse <==
N

==> /sys/module/kvm/parameters/force_emulation_prefix <==
0

==> /sys/module/kvm/parameters/halt_poll_ns <==
200000

==> /sys/module/kvm/parameters/halt_poll_ns_grow <==
2

==> /sys/module/kvm/parameters/halt_poll_ns_grow_start <==
10000

==> /sys/module/kvm/parameters/halt_poll_ns_shrink <==
0

==> /sys/module/kvm/parameters/ignore_msrs <==
N

==> /sys/module/kvm/parameters/kvmclock_periodic_sync <==
Y

==> /sys/module/kvm/parameters/lapic_timer_advance_ns <==
-1

==> /sys/module/kvm/parameters/min_timer_period_us <==
200

==> /sys/module/kvm/parameters/mitigate_smt_rsb <==
N

==> /sys/module/kvm/parameters/mmio_caching <==
Y

==> /sys/module/kvm/parameters/nx_huge_pages <==
Y

==> /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms <==
0

==> /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio <==
60

==> /sys/module/kvm/parameters/pi_inject_timer <==
0

==> /sys/module/kvm/parameters/report_ignored_msrs <==
Y

==> /sys/module/kvm/parameters/tdp_mmu <==
Y

==> /sys/module/kvm/parameters/tsc_tolerance_ppm <==
250

==> /sys/module/kvm/parameters/vector_hashing <==
Y


