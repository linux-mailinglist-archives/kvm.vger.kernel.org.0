Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F51E7AE448
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 05:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjIZDt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 23:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjIZDt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 23:49:58 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB26DC;
        Mon, 25 Sep 2023 20:49:51 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1c61bde0b4bso26918165ad.3;
        Mon, 25 Sep 2023 20:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695700191; x=1696304991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DEJeOj8lKjC24vEMGtxXTPjkSZb1cMn22NpZwCntJfk=;
        b=fFac9oY464XPhMHqFPRygsyzvitGlbxt0VHsRE1ZN0Ur3p0blA6jWq9A7N/zS/Fs90
         xmzqntdPbhIehP3j9QEMYPgkCybxWfcaDNzBuzfJhdzl7+5MsxoQeYoYW64hG5086uxC
         ejkZOwSUfPjUfxIEssp8XAK+wlnXgYfZLaTO20IkH+naA2ZbRD/FgRhQJXIwZkOdFRhQ
         MsWRMI/q9jhFPdzqXF0NyOva7XfMdpNvjlEm2Cvmm3JsMpO7NMDcwKyOMRED6c9gF0Xa
         yDqzKg4rcdruxghAzMTG5nSy8v25m3DsHKCRV/UO+O0EyNeEgaPJcnMZ5S+EUIhl0Kb/
         02Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695700191; x=1696304991;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DEJeOj8lKjC24vEMGtxXTPjkSZb1cMn22NpZwCntJfk=;
        b=K3X3/Np58+1JwIXSNz5YNFvP1oI37Ue5LDt3xuh9Lbn+1nxu4yXdY/n1xrp4yWj5sx
         PSK/NBEhNu/En24ENixn2XL1aqF1nFxZaAzIQciN6lqzAVojfD3RsD4phxzRIQTk1b8F
         EQ80K468WWmCEkqaV1JLGdERWZ69o6wxMZ+RqKYX2wdxXdU7zTp7ciwAKJdtuPoRjm1A
         MBjq3h3KJZCzsjKCXqhQgRtse6xZGmXmr6aBbDVcrbVNFDkpMFOQlDHNjLoxYtyqh+UH
         ZR3Q+Mhxa6Uej9W7dtiis2JcfTTCJJ9FPkZGluyv6uI1LoMP5E43K6bsud07CsjtO8Nl
         g0pA==
X-Gm-Message-State: AOJu0Yx+bmgrfwyABY7lQvr8lkDb8ulFSdpRaJN0jKK7WvHO9313A6un
        56Fs3GmXF1FzblKcx/TdpHU=
X-Google-Smtp-Source: AGHT+IGkFMC4W+VruRHn+9YMP3Msz2kB5rnKpUAeN7n2f2Aty8bXz9HXWAe0sM149yP9SikRLZ6Uqg==
X-Received: by 2002:a17:903:190:b0:1c6:15fc:999 with SMTP id z16-20020a170903019000b001c615fc0999mr5710128plg.45.1695700191016;
        Mon, 25 Sep 2023 20:49:51 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v24-20020a17090331d800b001c3267ae314sm9785441ple.156.2023.09.25.20.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 20:49:50 -0700 (PDT)
Message-ID: <90dd2e2e-71ae-d8c4-5d3b-9628e7710337@gmail.com>
Date:   Tue, 26 Sep 2023 11:49:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH V2] KVM: x86/pmu: Disable vPMU if EVENTSEL_GUESTONLY bit
 doesn't exist
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Manali Shukla <manali.shukla@amd.com>
References: <20230407085646.24809-1-likexu@tencent.com>
 <ZDA4nsyAku9B2/58@google.com>
 <6ee140c9-ccd5-9569-db17-a542a7e28d5c@gmail.com>
 <ZRIYbu4wSVW9a+8i@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZRIYbu4wSVW9a+8i@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/9/2023 7:31 am, Sean Christopherson wrote:
> On Thu, Sep 14, 2023, Like Xu wrote:
>> On 7/4/2023 11:37 pm, Sean Christopherson wrote:
>>> On Fri, Apr 07, 2023, Like Xu wrote:
>> /*
>>   * The guest vPMU counter emulation depends on the EVENTSEL_GUESTONLY bit.
>>   * If this bit is present on the host, the host needs to support at least
>> the PERFCTR_CORE.
>>   */
> 
> ...
> 
>>> 	/*
>>> 	 * KVM requires guest-only event support in order to isolate guest PMCs
>>> 	 * from host PMCs.  SVM doesn't provide a way to atomically load MSRs
>>> 	 * on VMRUN, and manually adjusting counts before/after VMRUN is not
>>> 	 * accurate enough to properly virtualize a PMU.
>>> 	 */
>>>
>>> But now I'm really confused, because if I'm reading the code correctly, perf
>>> invokes amd_core_hw_config() for legacy PMUs, i.e. even if PERFCTR_CORE isn't
>>> supported.  And the APM documents the host/guest bits only for "Core Performance
>>> Event-Select Registers".
>>>
>>> So either (a) GUESTONLY isn't supported on legacy CPUs and perf is relying on AMD
>>> CPUs ignoring reserved bits or (b) GUESTONLY _is_ supported on legacy PMUs and
>>> pmu_has_guestonly_mode() is checking the wrong MSR when running on older CPUs.
>>>
>>> And if (a) is true, then how on earth does KVM support vPMU when running on a
>>> legacy PMU?  Is vPMU on AMD just wildly broken?  Am I missing something?
>>>
>>
>> (a) It's true and AMD guest vPMU have only been implemented accurately with
>> the help of this GUESTONLY bit.
>>
>> There are two other scenarios worth discussing here: one is support L2 vPMU
>> on the PERFCTR_CORE+ host and this proposal is disabling it; and the other
>> case is to support AMD legacy vPMU on the PERFCTR_CORE+ host.
> 
> Oooh, so the really problematic case is when PERFCTR_CORE+ is supported but
> GUESTONLY is not, in which case KVM+perf *think* they can use GUESTONLY (and
> HOSTONLY).
> 
> That's a straight up KVM (as L0) bug, no?  I don't see anything in the APM that
> suggests those bits are optional, i.e. KVM is blatantly violating AMD's architecture
> by ignoring those bits.

For L2 guest, it often doesn't see all the cpu features corresponding to the
cpu model because KVM and VMM filter some of the capabilities. We can't say
that the absence of these features violates spec, can we ?

I treat it as a KVM flaw or a lack of emulation capability.

> 
> I would rather fix KVM (as L0).  It doesn't seem _that_ hard to support, e.g.
> modify reprogram_counter() to disable the counter if it's supposed to be silent
> for the current mode, and reprogram all counters if EFER.SVME is toggled, and on
> all nested transitions.

I thought about that too, setting up EFER.SVME and VMRUN is still a little
bit far away, and more micro-testing is needed to correct the behavior
of the emulation here, considering KVM also has to support emulated ins.

It's safe to say that there are no real user scenarios using vPMU in a nested
guest, so I'm more inclined to disable it provisionally (for the sake of more
stable tree users), enabling this feature is honestly at the end of my to-do list.
