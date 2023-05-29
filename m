Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E2D714BE3
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 16:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjE2OTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 10:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjE2OTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 10:19:30 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC75AD;
        Mon, 29 May 2023 07:19:27 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-52cbd7d0c37so2077826a12.3;
        Mon, 29 May 2023 07:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685369967; x=1687961967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wcga5Ujzgw9yS3ZqoCJOTRbX3rbCtuIhzzOXk2KdQxI=;
        b=omQ1euuv1EE7D4dUgbIRBhV+afzPDk3Azerkn3KJQgKDMc6ng73AzJPLkS3DZmyZia
         OPFexDfx8Xpich9xOGq38RQVPQ5dr0+R9P2IzubjOJn/KnJ0PQrGMWyHHODApuA7qg+N
         nQXNqY/QpivGPKjtQUdaNtclO/m8/x6oKNQugOqMRXbtj3eAiaL44Skt9nDuCEec5wz4
         d3gFd2nSGhs7TQuUluFb7EAA0FZBzhR57CYi8GUZCEU5Ozrm+9c00XAdLrig5PvaIfEu
         GZukM6ghIETMs/W8E77Pd7IGjecd8K/qRYnpmY8gL8iPLlOYMEuq5W1FqklHVwD77m9I
         6sFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685369967; x=1687961967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wcga5Ujzgw9yS3ZqoCJOTRbX3rbCtuIhzzOXk2KdQxI=;
        b=Qk+HykO/2EZC+aCN4Iaq2IhXmcY85IjkAmoSWjJK/ZUq0bMlV8QF/YUFSm2ETnPeBn
         F/TNRWxJfnY2YzHb3xyMJ1E/69JwfN94mrze3xWR7bevJ6ESSRcfb5TEFpOdT7fs+xjM
         LfNL/VggIZ4a+xzPHYd1EZWkv6FeUFvxebspQ6vJw5h7IjJbp+CeB38VoQCULrs8YmZ/
         XflYQXIAU+EP7546sueOMZgBKkrOcwtobxPQrrlVAAilPJoPEgFrrVYxeWveUL9hyVAX
         rugu5Lyato218ChUfuZovZVKg9K9WSLldLurceNEr28/vnii8qDlmtHzuVO6RhXptHY9
         w/7w==
X-Gm-Message-State: AC+VfDzHN6bfTXXLFFs2DcG9uhA2HsrCtYndpzusIfrNoTVN581WpZqv
        ycuIewQTVI6z4oYIs3NfgmM=
X-Google-Smtp-Source: ACHHUZ7sSPAwTkYsvpOJOhTOWTpJbqf9ltQ9SKHgu0mqnY2rHH+psQu/Drc4x2WsZdkXPIRUN6ukog==
X-Received: by 2002:a17:902:8b89:b0:1b0:42ac:74ef with SMTP id ay9-20020a1709028b8900b001b042ac74efmr3099250plb.57.1685369966685;
        Mon, 29 May 2023 07:19:26 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t16-20020a170902e85000b001ac912cac1asm8336409plg.175.2023.05.29.07.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 07:19:26 -0700 (PDT)
Message-ID: <cd8b6ea4-1293-c57c-1bed-4f6dbdbc2722@gmail.com>
Date:   Mon, 29 May 2023 22:19:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH v13 021/113] KVM: TDX: Make pmu_intel.c ignore guest TD
 case
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <017a06174fa054ae264a2caba6f7f55e00f258e8.1678643052.git.isaku.yamahata@intel.com>
 <20230402115019.000046fd@gmail.com>
 <36fb638a-c9ff-0139-3e8e-7e8ff0bbff1f@gmail.com>
 <20230528082602.GC1234772@ls.amr.corp.intel.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230528082602.GC1234772@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/5/2023 4:26 pm, Isaku Yamahata wrote:
> On Wed, Apr 19, 2023 at 04:21:21PM +0800,
> Like Xu <like.xu.linux@gmail.com> wrote:
> 
>> On 2/4/2023 4:50 pm, Zhi Wang wrote:
>>> Hi Like:
>>>
>>> Would you mind to take a look on this patch? It would be nice to have
>>> a r-b also from you. :)
>>>
>>> On Sun, 12 Mar 2023 10:55:45 -0700
>>> isaku.yamahata@intel.com wrote:
>>>
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
>>>> support as another patch series) and pmu_intel.c touches vmx specific
>>
>> It would be nice to have pmu support for tdx-guest from the very beginning.
> 
> It's supported in the public github repo.
> https://github.com/intel/tdx/tree/kvm-upstream-workaround
> As this patch series has 100+ patches, I don't want to bloat this patch more.

I presume we are talking about 873e2391e729...63761adbf5aa for TD pmu:

A quick glance brought me at least these comments:

(1) how does intel_pmu_save/restore() handle the enabled host LBR/PEBS ?
(2) guest PMI injection may be malicious and could the current guest pmu driver 
handle it ?
(3) how do we handle the case when host counters can be enabled before TDENTER
for debuggable TD and support the case like "perf-kvm for both guest and host" ?

My point is actually, changes to perf/core should be CC to the perf reviewers
as early as possible to prevent key player from killing the direction.

> 
> 
>> If you guys are more open on the tdx development model, I'd like to help on
>> those features.
> 
> This mainling list is the place.

Yeah, plus the PUCK and LPC KVM micro-conference.

> 
> 
>>>> structure in vcpu initialization, as workaround add dummy structure to
>>>> struct vcpu_tdx and pmu_intel.c can ignore TDX case.
>>
>> If the target is not to provide a workaround, how about other variants:
>> 	- struct lbr_desc lbr_desc;
>> 	- pebs ds_buffer;
>> ?
>>
>> We also need tdx selftest to verify the unavailability of these features.
>> Also, it would be great to have TDX's "System Profiling Mode" featue back in
>> the specification.

Detailed TD (plus debuggable) PMU selftest would clearly speed up the review 
process.

> 
> I don't think it's productive. Once merging this patch series, we can move on
> to TDX PMU support (or whatever still missing feature) as second (or later)
> step.

I totally agree that TD PMU (plus debuggable) support should not be the first 
part of the
code to be merged in, but the related discussion should be kicked off on day 0.
As a scenario for users using Intel TDX, it's expected to support "System 
Profiling Mode",
which was first introduced in 344425-001US but disappeared since version 003.
