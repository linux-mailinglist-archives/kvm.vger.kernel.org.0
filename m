Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1734806EA
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 08:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhL1HLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 02:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbhL1HLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 02:11:04 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D82C061574;
        Mon, 27 Dec 2021 23:11:04 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id l16so879831plg.10;
        Mon, 27 Dec 2021 23:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=+IdFBI5qMMSAm1kwvXkktu8DMOSEDcrS5FdpQLP9xxg=;
        b=kykFD60dLbUyZJfF4krhjUbaf0G1oEBzEnXk75UQUfB/VUz0Wmifsr/UQi86XfV/bj
         lgn/aYkC/aYbqb3nNH7NbplZwOG8BR2xyPH9QtLRYDl7RmERBvTY++CIwVMWQ4T6L8zS
         LdhbOSGI5FbrqUxNvxTy2Au9qPRaVp5QLgxL5SVNqbevds+lQvl/3UQDXLmOudp8FIRn
         pG9ZenMLfgs7Oqf5+TpkvVagx2kRYDVLJNQFSppIl0DPZywEdS9aMu3XLA+nzuTGWh8Z
         33KCbwBhgYEi6B9dTTRHGVclmNbRtvM5IhnRVv5mDGGPsUbq7qExSh6JP5MgR80ik4Qh
         /pkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=+IdFBI5qMMSAm1kwvXkktu8DMOSEDcrS5FdpQLP9xxg=;
        b=Mbsi1L9o8T+KnufH3jUAJ61BcImk+j52v0ZG9Kon80dRiI8Oo40M+74yV/hUvwozfz
         i7WYYbNJ5K0i0sbSF7DOvMhV21g7fhFTSsu0gZn1lAHrv33I2OW0ij/a/vMkZvQR12QH
         xsYQ0g+NQC/FRjUIgGbSoHX4CqDeKsNUmIxKvkBuJ684gx0bqFVLspw8YpM8fjsKECUv
         uJH0oOvlmSBJePNT5MfHGf7GINeIT9YHX5qwI1ZHvAxoFnyXl4T7rOCGcjT5Adl7mNmd
         g1kveTYOKgP2sQWkilPFtxui9YdHe7soFwWCbinGVtvEEAgpG/DO7V4MugG0v9xv2kRT
         u05g==
X-Gm-Message-State: AOAM531eiArNhwSC0yWX6wZiNJ2oMmsJjZKHqb/Jh26MR3xFSr/WkSQp
        5vFtyTpCx4i2sYgHtvIxI/0=
X-Google-Smtp-Source: ABdhPJxEzFT9zRZhA9NXfiSp5ExlhdDYVHRxmp8dICXlmV8w7mKmlnkaBybjahzKqQmoDiKCv5C8ng==
X-Received: by 2002:a17:90b:1c8d:: with SMTP id oo13mr24723375pjb.239.1640675464248;
        Mon, 27 Dec 2021 23:11:04 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 27sm14039365pgx.81.2021.12.27.23.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 23:11:03 -0800 (PST)
Message-ID: <d80f6161-e327-f374-4caf-016de1a77cc3@gmail.com>
Date:   Tue, 28 Dec 2021 15:10:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Dongli Cao <caodongli@kingsoft.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20211222133428.59977-1-likexu@tencent.com>
 <CALMp9eRNsKMB6onhc-nhW-aMb14gK1PCtQ_CxOoyZ5RvLHfvEQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2] KVM: X86: Emulate APERF/MPERF to report actual vCPU
 frequency
In-Reply-To: <CALMp9eRNsKMB6onhc-nhW-aMb14gK1PCtQ_CxOoyZ5RvLHfvEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim,

On 28/12/2021 2:33 am, Jim Mattson wrote:
> On Wed, Dec 22, 2021 at 5:34 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> The aperf/mperf are used to report current CPU frequency after 7d5905dc14a.
>> But guest kernel always reports a fixed vCPU frequency in the /proc/cpuinfo,
>> which may confuse users especially when turbo is enabled on the host or
>> when the vCPU has a noisy high power consumption neighbour task.
>>
>> Most guests such as Linux will only read accesses to AMPERF msrs, where
>> we can passthrough registers to the vcpu as the fast-path (a performance win)
>> and once any write accesses are trapped, the emulation will be switched to
>> slow-path, which emulates guest APERF/MPERF values based on host values.
>> In emulation mode, the returned MPERF msr value will be scaled according
>> to the TSCRatio value.
>>
>> As a minimum effort, KVM exposes the AMPERF feature when the host TSC
>> has CONSTANT and NONSTOP features, to avoid the need for more code
>> to cover various coner cases coming from host power throttling transitions.
>>
>> The slow path code reveals an opportunity to refactor update_vcpu_amperf()
>> and get_host_amperf() to be more flexible and generic, to cover more
>> power-related msrs.
>>
>> Requested-by: Dongli Cao <caodongli@kingsoft.com>
>> Requested-by: Li RongQing <lirongqing@baidu.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
> 
> I am not sure that it is necessary for kvm to get involved in the
> virtualization of APERF and MPERF at all, and I am highly skeptical of
> the need for passing through the hardware MSRs to a guest. Due to

The AMPERF is pass-through for read-only guest use cases.

> concerns over potential side-channel exploits a la Platypus

I agree that the enabling of AMPERF features increases the attack surface,
like any other upstreamed features (SGX), and they're not design flaw, are they?

As we know, KVM doesn't expose sufficient RAPL interface for Platypus. At least
the vendors has patched Platypus while the cat and mouse game will not end.

User space needs to choose whether to enable features based on the
guest's level of trust, rather than trying to prevent it from enablement.

> (https://platypusattack.com/), we are planning to provide only low
> fidelity APERF/MPERF virtualization from userspace, using the
> userspace MSR exiting mechanism. Of course, we should be able to do

It works for other non time-sensitive MSRs.

We have a long delay to walk the userspace MSR exiting mechanism
for both APERF msr and MPERF msr, which is almost intolerable for
frequent access guest reads. IMO, the low fidelity is not what the guest
user wants and it defeats the motivation for introducing amperf on host.

> that whether or not this change goes in, but I was wondering if you
> could provide some more details regarding your use case(s).

In addition to the advantages amperf brings in the kernel context
(e.g. smarter scheduler policies based on different power conditions),

Guest workload analysts are often curious about anomalous benchmark
scores under predictive CPU isolation guaranteed by service providers,
and they ask to look at actual vCPU frequencies to determine if the source
of performance noise is coming from neighboring hardware threads
particularly AVX or future AMX or other high power consumption neighbors.

This AMPERF data helps the customers to decide whether the back-end pCPU
is to be multiplexed or exclusive shared, or to upgrade to a faster HW model,
without being tricked by the guest CPUID.

IMO, this feature will be of value to most performance users. Any other comments?

Thanks,
Like Xu
