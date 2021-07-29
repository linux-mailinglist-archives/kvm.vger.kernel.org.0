Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70D83DA49A
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbhG2NqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237707AbhG2NqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 09:46:18 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E0CC0613C1;
        Thu, 29 Jul 2021 06:46:15 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so9388669pjh.3;
        Thu, 29 Jul 2021 06:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9BleuMwCGyyuYK8dalVoDb0OhOpS8fPXyZ0wGmWz4hw=;
        b=BVniMUO0VMpL6wicSCwGbQsb7ZFApyjkGScgTnnAdjtAeJ+r6FuSUVqomcVsElIxAl
         4SyVBowADDRw47oago1vENAC9CFzPEl+oFzp9AiLb/v08vRwKCKdDaOYMSaLpyUgbKhl
         dvw+tYdAagZlRbTiza78WJAeiH1S3t03kU5WCYcqAC122FiN2Du+VR7SOOuM2FxhUgBT
         PIN7EwQ3RG1g2W5rVGHy6quC2W1ghkO0KQ75y6j5qgYfZD+i0pM50cBPPvM2p0Tm/pIK
         Cu1IMeOBDVzm4m3SBSqgedgvnJcXZf/cumWecd+M/bjhhUv6cUiEIHITBa6YjZxxKxcO
         e1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9BleuMwCGyyuYK8dalVoDb0OhOpS8fPXyZ0wGmWz4hw=;
        b=D7pDZIZXjNCy9ukbwA01KaARY9IoNudArs1U9xcIG3I0TPWnBrtXOs0rZAltAnhJIC
         BWVlCGC7UutAi0SM9qQQ2qP7mUGdrcnYpIMQY7A8Vw7CMu5YDhBKPtvnDODENLABNPdO
         GMPSLRWOIV3ZLqodpHBswhLrX1IP7y+1FnLlDhnWZg+XHK+EGeBq6TRZxht5IIWNBq1+
         O7wC7wo9lra6g6yA8ICvY9vraeguA2arFSUnk/WBs7a5ZAW0GofGx+2Dgwb4djVYhRdK
         IWPYRvpCt8R85IzKnCgzBYibVlPVWDDHLKK3FzE7dscRO5POhwKKX/qoN8geYOH2j6No
         XZvA==
X-Gm-Message-State: AOAM532Mwn6uymdmWQHZ0eAJF725kI12VLP+IVJf4oVFlcuUwKNa+Jfc
        pDDK3y0+QrAuxtmWbDJ4UfWs1x0rZcj2H8NY
X-Google-Smtp-Source: ABdhPJyDJNkumDkGd7nLqSNP/H0vJD+puzrFC5xNM8dtUZyfWlGVEsA98bxUOE3FCe+Kcfm5F9SEDA==
X-Received: by 2002:a65:550a:: with SMTP id f10mr3904659pgr.155.1627566374682;
        Thu, 29 Jul 2021 06:46:14 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a9sm2533396pjs.32.2021.07.29.06.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 06:46:14 -0700 (PDT)
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20210728120705.6855-1-likexu@tencent.com>
 <YQKl7/0I4p0o0TCY@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: Introduce pmc->is_paused to reduce the call
 time of perf interfaces
Message-ID: <1e4fdcd4-fea3-771a-f437-b0305951ca92@gmail.com>
Date:   Thu, 29 Jul 2021 21:46:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQKl7/0I4p0o0TCY@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/7/2021 8:58 pm, Peter Zijlstra wrote:
> On Wed, Jul 28, 2021 at 08:07:05PM +0800, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Based on our observations, after any vm-exit associated with vPMU, there
>> are at least two or more perf interfaces to be called for guest counter
>> emulation, such as perf_event_{pause, read_value, period}(), and each one
>> will {lock, unlock} the same perf_event_ctx. The frequency of calls becomes
>> more severe when guest use counters in a multiplexed manner.
>>
>> Holding a lock once and completing the KVM request operations in the perf
>> context would introduce a set of impractical new interfaces. So we can
>> further optimize the vPMU implementation by avoiding repeated calls to
>> these interfaces in the KVM context for at least one pattern:
>>
>> After we call perf_event_pause() once, the event will be disabled and its
>> internal count will be reset to 0. So there is no need to pause it again
>> or read its value. Once the event is paused, event period will not be
>> updated until the next time it's resumed or reprogrammed. And there is
>> also no need to call perf_event_period twice for a non-running counter,
>> considering the perf_event for a running counter is never paused.
>>
>> Based on this implementation, for the following common usage of
>> sampling 4 events using perf on a 4u8g guest:
>>
>>    echo 0 > /proc/sys/kernel/watchdog
>>    echo 25 > /proc/sys/kernel/perf_cpu_time_max_percent
>>    echo 10000 > /proc/sys/kernel/perf_event_max_sample_rate
>>    echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
>>    for i in `seq 1 1 10`
>>    do
>>    taskset -c 0 perf record \
>>    -e cpu-cycles -e instructions -e branch-instructions -e cache-misses \
>>    /root/br_instr a
>>    done
>>
>> the average latency of the guest NMI handler is reduced from
>> 37646.7 ns to 32929.3 ns (~1.14x speed up) on the Intel ICX server.
>> Also, in addition to collecting more samples, no loss of sampling
>> accuracy was observed compared to before the optimization.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
> 
> Looks sane I suppose.
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> What kinds of VM-exits are the most common?
> 

A typical vm-exit trace is as follows:

  146820 EXTERNAL_INTERRUPT
  126301 MSR_WRITE
   17009 MSR_READ
    9710 RDPMC
    7295 EXCEPTION_NMI
    2493 EPT_VIOLATION
    1357 EPT_MISCONFIG
     567 CPUID
     107 NMI_WINDOW
      59 IO_INSTRUCTION
       2 VMCALL

including the following kvm_msr trace:

   15822 msr_write, MSR_CORE_PERF_GLOBAL_CTRL
   14558 msr_read, MSR_CORE_PERF_GLOBAL_STATUS
    7315 msr_write, IA32_X2APIC_LVT_PMI
    7250 msr_write, MSR_CORE_PERF_GLOBAL_OVF_CTRL
    2922 msr_write, MSR_IA32_PMC0
    2912 msr_write, MSR_CORE_PERF_FIXED_CTR0
    2904 msr_write, MSR_CORE_PERF_FIXED_CTR1
    2390 msr_write, MSR_CORE_PERF_FIXED_CTR_CTRL
    2390 msr_read, MSR_CORE_PERF_FIXED_CTR_CTRL
    1195 msr_write, MSR_P6_EVNTSEL1
    1195 msr_write, MSR_P6_EVNTSEL0
     976 msr_write, MSR_IA32_PMC1
     618 msr_write, IA32_X2APIC_ICR

Due to the presence of a large number of msr accesses, the latency of
the guest PMI handler is still far from that of the host handler.

I have two rough ideas that could drastically reduce the vPMU overhead
for the third time:

- Add a new paravirtualized pmu guest driver that saves all msr latest
values to the static physical memory of each vcpu to achieve a reduced
number of vm-exits and also facilitate kvm emulation access;

- Bypass the host perf_event PMI callback injection path and inject
guest PMI directly after the EXCEPTION_N/PMI vm-exit; (For TDX guest)


Any negative comments or help with additional details are welcome.
