Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEA54B0E6E
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 14:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242219AbiBJN3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 08:29:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240857AbiBJN3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 08:29:40 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABC3BC3;
        Thu, 10 Feb 2022 05:29:41 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id l19so4418441pfu.2;
        Thu, 10 Feb 2022 05:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=D4vX7U/4/eXLGsQNCnlpueeNeyw5JqB5wZkzYgsrDaY=;
        b=cdWfI91117NwJqR2B5SCbKzBpPGa0QqYE304JWlS+gWSx2MRXzFNgpzYxYRVygNSR0
         5gxneyPL4wXXeSiGe5ZjaGdgC0Agz45cUL7AE6R7egCsgQFaoRbgt1XfgGNR0sE+NRg7
         XI3QTDEQ7VaD7f9szxFGuEgnkA26wqmKxqt2hQ0s2GCgN9c8lOX4+eYHDMhR+BcGk75p
         7PWe3ZSpGkVdrp5XqP+rrevoA+NWpkAkVUhcetY4zJ9oWqB4+g9emUBhBH1T+YCp/NHG
         l+Vnk6N2In8N40vO6WCUpYkJjzPcGT740YopPpfTTmAx4/mgAFRaKxNTyaVC9oWui8z+
         ThKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=D4vX7U/4/eXLGsQNCnlpueeNeyw5JqB5wZkzYgsrDaY=;
        b=kZ9rm07Anv3bZP8SjYFeiuKES2gUAyQPTP4p1BUNixmCYxCOde78A1jyPd0jpWTEEA
         vYM5t1JDGSKykPVe+8PLytEQ62qPdnUcGst5nZGDikeu3dbpknLkfuPDHJ47VXq8Img7
         sLI2EYRGHrshIChlfqfvqMegJ7RrbOgUWu3NT5Dy7wfFR6SgFlTE08DQZ8xN3hFUKkfx
         VL2MkxhXuSO9+6i1LMu/NskvN7I8BI8VO+PQg9xRqy7e6xMMWzbRAuaApp0d1mmQ7Cym
         w6HLZZhMat/He+GjilxzGb/j8qSQPfnvCvGWNyHUMh3Df10AMBwvBSUq0IpPlk4U5qXV
         VBpg==
X-Gm-Message-State: AOAM530ORk7TYZuWJqPm8Bqw5Vt+nrsuq6Qenvi0efWno6aZMbmJxuAB
        VYFY0fQYru/w3dYYd7F1vQw=
X-Google-Smtp-Source: ABdhPJxWec9KpRNekvo5nTr/pCTVA8G2AQMZvpiDFiJZ3w3craV2P/nFkbqiFd+Sx8fxuQiiVQQhWA==
X-Received: by 2002:a62:506:: with SMTP id 6mr7475568pff.86.1644499780909;
        Thu, 10 Feb 2022 05:29:40 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h19sm23240746pfh.40.2022.02.10.05.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 05:29:39 -0800 (PST)
Message-ID: <9a8f5f15-05fa-c512-bb96-165581d307b9@gmail.com>
Date:   Thu, 10 Feb 2022 21:29:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     David Dunn <daviddunn@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>,
        Dave Hansen <dave.hansen@intel.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
 <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
 <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
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

On 10/2/2022 3:24 am, David Dunn wrote:
> Dave,
> 
> In my opinion, the right policy depends on what the host owner and
> guest owner are trying to achieve.

And more, who is the arbiter of the final resource allocation
and who is the consumer of performance data.

This is not a one-shot deal to cede the PMU to the guest or not.

> 
> If the PMU is being used to locate places where performance could be
> improved in the system, there are two sub scenarios:
>     - The host and guest are owned by same entity that is optimizing
> overall system.  In this case, the guest doesn't need PMU access and
> better information is provided by profiling the entire system from the
> host.

It's not only about who the entity is but more about capabilities:

Can we profile the entire system including normal guests, and at the same time,
some guest PMU featurs are still available ? Isn't that a better thing?

>     - The host and guest are owned by different entities.  In this
> case, profiling from the host can identify perf issues in the guest.
> But what action can be taken?  The host entity must communicate issues
> back to the guest owner through some sort of out-of-band information

Uh, I'd like to public my pv-PMU idea (via static guest physical memory) and
web subscription model to share un-core and off-core performance data to
trusted guests.

> channel.  On the other hand, preempting the host PMU to give the guest
> a fully functional PMU serves this use case well.

The idea of "preempting PMU from the host" that requires KVM to prioritize
the PMU over any user on the host, was marked as a dead end by PeterZ.

We need to actively restrict host behavior from grabbing guest pmu
and in that case, "a fully functional guest PMU" serves well.

> 
> TDX and SGX (outside of debug mode) strongly assume different
> entities.  And Intel is doing this to reduce insight of the host into
> guest operations.  So in my opinion, preemption makes sense.

Just like the TDX guest uses pCPU resources, this is isolated from
host world, but only if the host scheduler allows it to happen.

> 
> There are also scenarios where the host owner is trying to identify
> systemwide impacts of guest actions.  For example, detecting memory
> bandwidth consumption or split locks.  In this case, host control

or auto numa balance, bla bla...

> without preemption is necessary.

I have some POC code that allows both guest and host PMUs to work
at the same time for completely different consumers of performance data.

> 
> To address these various scenarios, it seems like the host needs to be
> able to have policy control on whether it is willing to have the PMU
> preempted by the guest.

The policy is the perf scheduling. The order is:

CPU-pinned
Task-pinned
CPU-flexible
Task-flexible

There is nothing special about KVM in the perf semantics, which is an art.

> 
> But I don't see what scenario is well served by the current situation
> in KVM.  Currently the guest will either be told it has no PMU (which
> is fine) or that it has full control of a PMU.  If the guest is told
> it has full control of the PMU, it actually doesn't.  But instead of
> losing counters on well defined events (from the guest perspective),
> they simply stop counting depending on what the host is doing with the
> PMU.

I do understand your annoyance very well, just as I did at first.

> 
> On the other hand, if we flip it around the semantics are more clear.
> A guest will be told it has no PMU (which is fine) or that it has full
> control of the PMU.  If the guest is told that it has full control of
> the PMU, it does.  And the host (which is the thing that granted the
> full PMU to the guest) knows that events inside the guest are not
> being measured.  This results in all entities seeing something that
> can be reasoned about from their perspective.

If my comments helps you deliver some interesting code for vPMU,
I'm looking forward to it. :D

> 
> Thanks,
> 
> Dave Dunn
> 
> On Wed, Feb 9, 2022 at 10:57 AM Dave Hansen <dave.hansen@intel.com> wrote:
> 
>>> I was referring to gaps in the collection of data that the host perf
>>> subsystem doesn't know about if ATTRIBUTES.PERFMON is set for a TDX
>>> guest. This can potentially be a problem if someone is trying to
>>> measure events per unit of time.
>>
>> Ahh, that makes sense.
>>
>> Does SGX cause problem for these people?  It can create some of the same
>> collection gaps:
>>
>>          performance monitoring activities are suppressed when entering
>>          an opt-out (of performance monitoring) enclave.
