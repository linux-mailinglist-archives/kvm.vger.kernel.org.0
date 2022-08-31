Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9D65A787E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiHaIFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiHaIFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:05:47 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C19BCBE;
        Wed, 31 Aug 2022 01:05:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso20349752pjk.0;
        Wed, 31 Aug 2022 01:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=KAGqkvOKiabn/+RhA/LB35qY/OwR5Hgcx6mK/sCzhDM=;
        b=JL/g4wLIEVjPo4DpYiDYAHm7zNH48YuwegOYKCy4jQ0xPAKnjUtOFSwPtpzY/tg+9Q
         DV41ceVmq6X5/BJ4uBVmuBpUbCrKO7DkZdA0lJUy58K7X3bY3m5++wPdBfuN+qNphuVS
         1RPmY/YoPCz76A9dAFA2x2LRLwmVkw8VBDGMZnrUX9c9JsCC+YrBmJq10LnREw2T2XBC
         WKJIEyaPzbwuLqsvxm+BRPmehvz/g03wbft7dyO3bZSaFbOeFnuHZxyRcH1h0t/Q8Spe
         ksxUiXo2B2P5rAy4Hf8wn59fsJtv+9GcuOn8yrQlwW0qKMMz3vfZnX2KBAcuSjVWjNeY
         scKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=KAGqkvOKiabn/+RhA/LB35qY/OwR5Hgcx6mK/sCzhDM=;
        b=kTpU76IIH+R48/EGmgsCKZnWeEQW2niPXj+ghWT/UJnZWpBcw5uEL0wkvALYBkN402
         jzGciEcxFdlCjcbcNgi4VYtGXTSS2gvxJKRc9GcU7x2JX1DSkyCjUr5BsIp/GhjIgAkO
         16DCzkcciD2y6wtuunh/WbIH9ditGSa/n8YLXqBfX9BuA+OvPz18GIeCPKT8i3z+x1ib
         4HwlY2nTOQC3mZJ99ZEfQV78WAQUGGiXYkkrdpUlgMnpUs8sUl6SGMyJuqHCCiUK0Eqm
         wIWEknknjxAJk6y5ti+OUZC4ItXB80Vh4USnXUmYbS6//xdWI8cDUhnd+JXF89y7fetX
         9cWg==
X-Gm-Message-State: ACgBeo0kH+bS0YaCNXld7W28wlRQEbqHGz4Z/PF9ixnarRz2dIpUHge/
        eNP5J8/XVxM8YdonARPhSjw=
X-Google-Smtp-Source: AA6agR4YoFdT7TkXbipm6o/wat/23Ik2j+mhGIsWuQAwJ9S5TDs2aIqtNWZVWufkqhz2Mpa0l3NVOA==
X-Received: by 2002:a17:902:a58c:b0:174:3c97:d9a1 with SMTP id az12-20020a170902a58c00b001743c97d9a1mr23266345plb.22.1661933136810;
        Wed, 31 Aug 2022 01:05:36 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z24-20020aa79f98000000b00537f9e32b00sm8207498pfr.37.2022.08.31.01.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 01:05:36 -0700 (PDT)
Message-ID: <f8d1275b-966a-95ed-1122-d74fa62d811a@gmail.com>
Date:   Wed, 31 Aug 2022 16:05:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH RESEND v2 0/8] x86/pmu: Corner cases fixes and
 optimization
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220823093221.38075-1-likexu@tencent.com>
 <Yw5I3P4Vs5GGBtuJ@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Yw5I3P4Vs5GGBtuJ@google.com>
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

On 31/8/2022 1:29 am, Sean Christopherson wrote:
> On Tue, Aug 23, 2022, Like Xu wrote:
>> Good well-designed tests can help us find more bugs, especially when
>> the test steps differ from the Linux kernel behaviour in terms of the
>> timing of access to virtualized hw resources.
>>
>> In this patch series, there are three small optimization (006/007/008),
>> one hardware surprise (001), and most of these fixes have stepped
>> on my little toes.
>>
>> Please feel free to run tests, add more or share comments.
>>
>> Previous:
>> https://lore.kernel.org/kvm/20220721103549.49543-1-likexu@tencent.com/
>> https://lore.kernel.org/kvm/20220803130124.72340-1-likexu@tencent.com/
>>
>> V2 -> V2 RESEND Changelog:
>> - The "pebs_capable" fix has been merged into tip/perf/tree tree;
>> - Move the other two AMD vPMU optimization here;
> 
> This is not a RESEND.  These things very much matter because I'm sitting here
> trying to figure out whether I need to review this "v2", which is really v3, or
> whether I can just review the real v2.
> 
>    Don't add "RESEND" when you are submitting a modified version of your
>    patch or patch series - "RESEND" only applies to resubmission of a
>    patch or patch series which have not been modified in any way from the
>    previous submission.

Roger that. Thanks for your detailed comments and all of that will be applied in V3.

The new AMD vPMU testcases[1] will also help guard future related changes.
[1] https://lore.kernel.org/kvm/20220819110939.78013-1-likexu@tencent.com/

Thanks,
Like Xu
