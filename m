Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00F94CD198
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239427AbiCDJs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239390AbiCDJrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:47:55 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8861A6366;
        Fri,  4 Mar 2022 01:47:07 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso6825769pjb.0;
        Fri, 04 Mar 2022 01:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JCaur61bPmGU642Xi+wX8g5Kkw4epev4yyqUyqMyUgo=;
        b=iIP5DQIxcFkCC40dzVlvMR+bQcoEFoIZZEKMDIpPtw9DzueFwDpNqHq7nx5uOU2RKD
         Kmbu9BWhhW6d/xlPbGgK27PsK9DEjorJymeRj9cVIhvtMbUPCKr7qOLcFJpuh6Z2IvlW
         nTvlVsltppXhGf68h4Ge3KgnhytfPBErhgjmLBgcgtHllPglJipNR9I4EDz262I57ZOi
         u2576Hb8VwwXX6FcmDjWqUqrCgcyIsOXcYVXoJXq4sn+yi0NFcAGxyBm+1mmpWd9vXT0
         SiRTAyKWdxkO4as13PBq+ozS1S8VxLK2a5GTkC4fl/3L83BcAJBgA93TatetX8wfLAo5
         ptCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JCaur61bPmGU642Xi+wX8g5Kkw4epev4yyqUyqMyUgo=;
        b=5QK7QSOT6XqYStGR4VIcYzTKsU6iMo8gnVcfAGTv0+4Va1gOEUcqo4nslczKQs0Vag
         ExM/8S7Ulr0zmo3d6IiPdSNBQ9hsFeEEDmURDZeYdodAfFW8VcC6pQYPf7RZTm9nrab0
         FpAoEznE/v6KAxlvwsImQzAV5Wlh+C7bFhhy+cgu2SH0KH99kwPbRT6ghGQ8lR6F9SWG
         yvVkQlU3iRcqvWFUh6xjVHm1mkf1QJSQPsy2b6cxad261NUUGlYYc10G6CEt54/CpI2p
         sczXzNcOv8MU5WgHUSUG4NokmbLs5TCuUk7cA2kekAGq+xGObqPoxdPZBmm//pfDZU9/
         gd+w==
X-Gm-Message-State: AOAM533a6ngqVgzOxFDh+pp07aIenVhrejU+jgDXH1J6X9Ydr/bZTU1+
        q+RrrtKJo08UEm6Z/BlWXgk=
X-Google-Smtp-Source: ABdhPJyEw3XfasQbL/436tU6ks+U/nx8BEU7zmbXuhjGMA8iklsqeWN2LmpLXi2CimNSdbfLtlPyZA==
X-Received: by 2002:a17:902:b697:b0:151:4c2e:48be with SMTP id c23-20020a170902b69700b001514c2e48bemr30634893pls.70.1646387227488;
        Fri, 04 Mar 2022 01:47:07 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5249920pfm.200.2022.03.04.01.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 01:47:07 -0800 (PST)
Message-ID: <273a7631-188b-a7a9-a551-4e577dcdd8d1@gmail.com>
Date:   Fri, 4 Mar 2022 17:46:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 12/12] KVM: x86/pmu: Clear reserved bit PERF_CTL2[43]
 for AMD erratum 1292
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20220302111334.12689-1-likexu@tencent.com>
 <20220302111334.12689-13-likexu@tencent.com>
 <CALMp9eT1N_HeipXjpyqrXs_WmBEip2vchy4d1GffpwrEd+444w@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eT1N_HeipXjpyqrXs_WmBEip2vchy4d1GffpwrEd+444w@mail.gmail.com>
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

On 3/3/2022 1:52 am, Jim Mattson wrote:
> On Wed, Mar 2, 2022 at 3:14 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> The AMD Family 19h Models 00h-0Fh Processors may experience sampling
>> inaccuracies that cause the following performance counters to overcount
>> retire-based events. To count the non-FP affected PMC events correctly,
>> a patched guest with a target vCPU model would:
>>
>>      - Use Core::X86::Msr::PERF_CTL2 to count the events, and
>>      - Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>>      - Program Core::X86::Msr::PERF_CTL2[20] to 0b.
>>
>> To support this use of AMD guests, KVM should not reserve bit 43
>> only for counter #2. Treatment of other cases remains unchanged.
>>
>> AMD hardware team clarified that the conditions under which the
>> overcounting can happen, is quite rare. This change may make those
>> PMU driver developers who have read errata #1292 less disappointed.
>>
>> Reported-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
> 
> This seems unnecessarily convoluted. As I've said previously, KVM
> should not ever synthesize a #GP for any value written to a
> PerfEvtSeln MSR when emulating an AMD CPU.

IMO, we should "never synthesize a #GP" for all AMD MSRs,
not just for AMD PMU msrs, or keep the status quo.

I agree with you on this AMD #GP transition, but we need at least one
kernel cycle to make a more radical change and we don't know Paolo's
attitude and more, we haven't received a tidal wave of user complaints.

