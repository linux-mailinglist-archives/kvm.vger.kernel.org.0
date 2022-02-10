Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BAA4B0D36
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 13:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241434AbiBJMJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 07:09:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiBJMJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 07:09:03 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A28A1098;
        Thu, 10 Feb 2022 04:09:05 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id r19so9845806pfh.6;
        Thu, 10 Feb 2022 04:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=/lyjd8DzHr1ZFN7n5g+6x/ewHBndnhwtxkDtCmmE8GE=;
        b=L6ZgFT9WhpOELHm/6zoM1fuDCVfXhqfBdI4ku2SSpeiBRDXiqcQ9mPNlvlKG3OjlVg
         okKbXPgxLnm8hwyzp0TAny+vACb58oxfjHsuy9TAAtr5BLi8SAS9ogw3CrJZR4Dqp/6E
         I8led7uMPtn0I/PV/MRTWe9Vykr96+LJucrQ+n58/JohwpIhrt5Amig8oc18y+HCUHLs
         aJaUPf8AUKhi39Z6I1ITdB34gX1RK++aIbqYishbcwYWTKFxUXC3q1DHgtrLdh0gXVxz
         g7RD3CaCV3re5K49OJ8tjQCnFRWUPTPLKTqR/P7Z3LlkS/7+OI6zcWx/uT3v28rz/t7C
         n7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=/lyjd8DzHr1ZFN7n5g+6x/ewHBndnhwtxkDtCmmE8GE=;
        b=KwhY+WyLNSx/9tt3Xd1SftRaSP78pd8rY0M1Fe0Jd2XVPVvyrzhDAalcQcaI7j5Rky
         BnAXbvbXiOfPkM0JYknukiZRsQK1wUeiopVPkbUSuNpYBaXwRvkFhaW+ZWcdPGI4O0/l
         ZGEX6chD2KavHnsSuNQCtaF6T74iwruyZAN/SMRl92G03xG1DnIQ/uJ6qOPkJ3/hmrjU
         FSF/8XcEYLKgvyRAd9gNlam255i/4zeMjr/GtaXm7ClmC8H3HOihDMhpy8xIR+E2igbA
         BEerLZ+KWovCGUnWbMIUY7UHkqCIBP1tuvNeij0uzl/yznvFt6hv+D8Wv0dOB0K+X6Lz
         Ip3g==
X-Gm-Message-State: AOAM533DvNS8QEzlYFMqc3DX315SDC5HslkTNzzMhiBF63mdnbih4/Pk
        FhVL3vgbZWC7BAADOPYytso=
X-Google-Smtp-Source: ABdhPJwT7QCUaOgCbqxu9iuBMskrTSC/WStIay4JWz/JceDUiFSFVOBM2BjVvIZ2f1joJBdKre0JrQ==
X-Received: by 2002:a62:506:: with SMTP id 6mr7149948pff.86.1644494944656;
        Thu, 10 Feb 2022 04:09:04 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h6sm25123612pfk.110.2022.02.10.04.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 04:09:04 -0800 (PST)
Message-ID: <39b64c56-bc8d-272d-da92-5aa29e54cdaf@gmail.com>
Date:   Thu, 10 Feb 2022 20:08:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: KVM: x86: Reconsider the current approach of vPMU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Dunn <daviddunn@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
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
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <YgQrWHCNG/s4EWFf@google.com>
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

On 10/2/2022 5:00 am, Sean Christopherson wrote:
> On Wed, Feb 09, 2022, Peter Zijlstra wrote:
>> On Wed, Feb 09, 2022 at 04:10:48PM +0800, Like Xu wrote:
>>> On 3/2/2022 6:35 am, Jim Mattson wrote:
>>>> 3) TDX is going to pull the rug out from under us anyway. When the TDX
>>>> module usurps control of the PMU, any active host counters are going
>>>> to stop counting. We are going to need a way of telling the host perf
>>>
>>> I presume that performance counters data of TDX guest is isolated for host,
>>> and host counters (from host perf agent) will not stop and keep counting
>>> only for TDX guests in debug mode.
>>
>> Right, lots of people like profiling guests from the host. That allows
>> including all the other virt gunk that supports the guest.

We (real-world production environments) have a number of PMU use cases
(system-wide or zoomed in on each guest) to characterize different guests on the 
host.

>>
>> Guests must not unilaterally steal the PMU.
> 
> The proposal is to add an option to allow userspace to gift the PMU to the guest,

Please define the verb "gift" in more details.

How do we balance the performance data collection needs of the
'hypervisor user space' and the 'system-wide profiler user space' ?

> not to let the guest steal the PMU at will.  Off by default, certain capabilities
> required, etc... are all completely ok and desired, e.g. we also have use cases
> where we don't want to let the guest touch the PMU.

One ideological hurdle here (between upstream and vendor-defined Linux) is 
whether we
let the host's perf be the final arbiter of PMU resource allocation, rather than 
not being able
to recycle this resource once it has been dispatched or gifted to the (TDX or 
normal) guests.

> 
> David's response in the original thread[*] explains things far better than I can do.
> 
> [*] https://lore.kernel.org/all/CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com
