Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8E862924C
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 08:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiKOHQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 02:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiKOHQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 02:16:49 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34A51DF05;
        Mon, 14 Nov 2022 23:16:48 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so13027154pjd.4;
        Mon, 14 Nov 2022 23:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fjcqU0Yv2A32s2SZaZ6INj/8QiFmDDgMwnvLoZG299s=;
        b=dNKpJeTd6cmZ1Y4DYaObSz+BJLYLnYUShR4aN0WDIO3wvs9eKnEM6tmit5ENISJbrU
         NSAxdqpi/ESsnzioUNCYWYUcIQgY2dM7W0b8PaOqkP1Byg1YS3+L6V2BDjNEmLH1Bn33
         vBLbs4wBd0/XDSQn6mTs97Vov5H78tf8S70wkNTElWLAAYlAPofG27S2zVArw716l1G3
         pEQd5tq6cTcy5QxPhVyJbJgIwiSSf6xMrhw0GzpaIm+NbsVayjHXghHSoSWyEmtPWCG6
         Gk0EK0R4f2fKPm9S1yn3DWjL6ghgjWYY5wtcNMVhu2HtDVGPVtTut9emFg/5c8CxGds2
         Khhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjcqU0Yv2A32s2SZaZ6INj/8QiFmDDgMwnvLoZG299s=;
        b=4VjdFQIi1QQWfj63qOR89dsxAL1hYj+XBaLq3MHtPWljQLY/MKFHQlOxwqJx/0wxPE
         MgmjJhA2PdSZWjrWeXomY1yusx6yaVlNbhSgbRuGYlWmGWzhIyJNsEXq8WuzaGh3Eapp
         fKyQnjWEC7MChc6/H4dy9nNNAlb0HPPXF2ZSvRlgZSwEi+5CgIOs+Lc6knuKEmm5xmqY
         rD3GGmtCF6COyMXWmC67pU4PwVonN13SRxDk8r7KQSsk1NG2q0MhvRd8zPG7f40DzqFI
         2NxI2jruIc1lVGKAZctxod027fd4fGuqaZqSK7Z6p3szCc0T0+jf1D8xsyYRU1J0O3+W
         fr4w==
X-Gm-Message-State: ANoB5pmNfsreifKfFs5DQcDLYkNpKnaKxQgws/knKskUyulraFn1huiI
        JFC/BNOUngg8bnFB/AInzBs=
X-Google-Smtp-Source: AA0mqf7j4019WSw9o5A9HTPkOlX3C5kSR007f4WWqq/s+ccX9gim1nD47CLbQfmjsANAkAmAFjEY1g==
X-Received: by 2002:a17:902:b691:b0:187:30f0:b16b with SMTP id c17-20020a170902b69100b0018730f0b16bmr2832376pls.14.1668496608366;
        Mon, 14 Nov 2022 23:16:48 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902b40200b0018685257c0dsm8864195plr.58.2022.11.14.23.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 23:16:47 -0800 (PST)
Message-ID: <42fc9103-bbd8-0482-e2fc-49589b6698b5@gmail.com>
Date:   Tue, 15 Nov 2022 15:16:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v3 3/3] perf/x86/intel: Expose EPT-friendly PEBS for SPR
 and future models
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org
References: <20221109082802.27543-1-likexu@tencent.com>
 <20221109082802.27543-4-likexu@tencent.com>
 <Y3I4o4Y/TcqidyJT@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y3I4o4Y/TcqidyJT@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/2022 8:46 pm, Peter Zijlstra wrote:
> On Wed, Nov 09, 2022 at 04:28:02PM +0800, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> According to Intel SDM, the EPT-friendly PEBS is supported by all the
>> platforms after ICX, ADL and the future platforms with PEBS format 5.
>>
>> Currently the only in-kernel user of this capability is KVM, which has
>> very limited support for hybrid core pmu, so ADL and its successors do
>> not currently expose this capability. When both hybrid core and PEBS
>> format 5 are present, KVM will decide on its own merits.
> 
> Oh right; the whole ADL KVM trainwreck :/ What's the plan there?

As we know, our community doesn't really have a plan in terms of feature reception,
considering hyprid pmu doesn't have market share in the data center (where most KVM
users are, and the test farms), and KVM-based client hypervisor will actively 
control the
cpu that the KVM module initializes, and adds more trainwreck, so as of now I don't
have a timeline for vPMU on ADL+ (until there are noteworthy user complaints).

Please let me know if you and Kan have other input.

> 
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: linux-perf-users@vger.kernel.org
>> Suggested-by: Kan Liang <kan.liang@linux.intel.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
>> ---
>> Nit: This change is proposed to be applied via the KVM tree.
> 
> Works for me;
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
