Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6662C4B7E8F
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 04:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344320AbiBPDeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 22:34:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBPDeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 22:34:13 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EEDFFF80;
        Tue, 15 Feb 2022 19:34:00 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so5275490pjl.2;
        Tue, 15 Feb 2022 19:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=o3EVlHksdajQdBfBvOiLN/f2i7KYfXPDyLB3952Q0qQ=;
        b=EYLoXrRP1U8WrAtVCvcbnscubeOoT5RgzL0LBTetgsbKfnRNVg9OdwKH4jL3n7lR01
         6H35vMmStPRQMi/Pnx0Rvw6GfuusBdvj24zFnsvdNmMJl78PWncMzsGA7JkuUoxkrSDt
         6QkAW+UZEM6k2s1PthPUSQpRa0d/bIiAjZv4tk0i0SmEfhuvJKVQCit0YNdRwZcVETcO
         sfrC9oqLCWhXIAs6OT5cvBFNtlr+bvOFFphOMgUdkjk4eOxjX7/MmpSmJkpP3wof4Fbc
         pTMjl3utfb5ptBcH01kYzqaCG/drYmDPSYbfIgu205Y69198d7ZrmDBPy9jOjTA2dgzQ
         IGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=o3EVlHksdajQdBfBvOiLN/f2i7KYfXPDyLB3952Q0qQ=;
        b=J52IoHrbOs4OAblQKoexJt91Goj/r+vQ1Rk8JanxpNErfPzdxFugeP02Awzg84/CWa
         GCHCWrkieCAJYE0ylgEih5ac5kRZSjZD+p+pE4WL/Bi/7EJmR28v6BFuWhWeV+3XyJ8z
         aFbBceaLzGNrC36/Zk9e+3ZpoO0wUD8C82j/cGSf1XFM0qrRY7A8fFZi7C42qxSwcv1y
         hjbhL9+dPPz2OuOd/o+DVsJa5IgNcSzKjvo5YAQth7/ZQusm2L0T5iQTr7sai2mbVZ5u
         gtHAUFQLSZCvanWmgMildDwjBbx/w5ulr9YxolmILEQdZgsYpHNG7BBkzpxgWmHPXoC3
         cZ4g==
X-Gm-Message-State: AOAM533Hb9tb5yNdy85RM7J6m7FOjPaMjetrib6TJ9gzEpmDcFaYBEQy
        dO9WhKljyqX7Ca8P/2LjezU=
X-Google-Smtp-Source: ABdhPJx4u+Z0346VExNtDaIoM0mAg46d1IU9We7nCATZ+NWU5xquU9tessa0U139em/s75ZmQ5duIQ==
X-Received: by 2002:a17:902:e9c5:b0:14d:8c80:dbf2 with SMTP id 5-20020a170902e9c500b0014d8c80dbf2mr662723plk.154.1644982435884;
        Tue, 15 Feb 2022 19:33:55 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s15sm3824604pgn.30.2022.02.15.19.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 19:33:55 -0800 (PST)
Message-ID: <810c3148-1791-de57-27c0-d1ac5ed35fb8@gmail.com>
Date:   Wed, 16 Feb 2022 11:33:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: KVM: x86: Reconsider the current approach of vPMU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Dunn <daviddunn@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <2db2ebbe-e552-b974-fc77-870d958465ba@gmail.com>
 <YgPCm1WIt9dHuoEo@hirez.programming.kicks-ass.net>
 <YgQrWHCNG/s4EWFf@google.com>
 <39b64c56-bc8d-272d-da92-5aa29e54cdaf@gmail.com>
 <YgVHawnQWuSAk+C1@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <YgVHawnQWuSAk+C1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/2022 1:12 am, Sean Christopherson wrote:
> On Thu, Feb 10, 2022, Like Xu wrote:
>> On 10/2/2022 5:00 am, Sean Christopherson wrote:
>>> On Wed, Feb 09, 2022, Peter Zijlstra wrote:
>>>> Guests must not unilaterally steal the PMU.
>>>
>>> The proposal is to add an option to allow userspace to gift the PMU to the guest,
>>
>> Please define the verb "gift" in more details.
> 
> Add a knob that allows host userspace to control toggle between host perf having
> sole ownership of the PMU, versus ownership of the PMU being "gifted" to KVM guests
> upon VM-Entry and returned back to the host at VM-Exit.

For the vm-entry/exit level of granularity, we're able to do it without the host 
perf knob.
For the guest power-on/off level of granularity, perf does not compromise with KVM.

> 
> IIUC, it's the same idea as PT's PT_MODE_HOST_GUEST mode, just applied to the PMU.

TBH, I don't like the design of PT_MODE_HOST_GUEST, it breaks the flexibility.
I would prefer to see a transition in the use of PT to the existing vPMU approach.

> 
> By default, the host would have sole ownership, and access to the knob would be
> restricted appropriately.  KVM would disallow creation any VM that requires
> joint ownership, e.g. launching a TDX guest would require the knob to be enabled.

The knob implies a per-pCPU control granularity (internal or explicit), for 
scalability.

But again, regardless of whether the (TDX) guest has pmu enabled or not, the host
needs to use pmu (to profile host, non-TDX guest) without giving it away easily
at runtime (via knob).

We should not destroy the kind of hybrid usage, but going in a legacy direction,
complementing the lack of guest pmu functionality with emulation or
full context switching per the vm-entry/exit level of granularity.

> 
>> How do we balance the performance data collection needs of the
>> 'hypervisor user space' and the 'system-wide profiler user space' ?
> 
> If host userspace enables the knob and transitions into a joint ownership mode,
> then host userspace is explicitly acknowledging that it will no longer be able
> to profile KVM guests.

AFAI, most cloud provider don't want to lose this flexibility as it leaves
hundreds of "profile KVM guests" cases with nowhere to land.

> 
> Balancing between host and guest then gets factored into VM placement, e.g. VMs
> that need or are paying for access to the PMU can only land on systems that are
> configured for joint ownership.  If profiling the guest from the host is important,
> then place those guests only on hosts with sole ownership.

If the host user space does not reclaim PMU (triumph through prioritization) 
from the
guest (controlling this behavior is like controlling VMs placement), then the 
guest's
PMU functionality has nothing to lose, which is complete.

