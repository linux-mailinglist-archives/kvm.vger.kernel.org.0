Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E638D757270
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 05:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjGRDnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 23:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjGRDnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 23:43:31 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F22E107
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 20:43:30 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id 006d021491bc7-56584266c41so2886979eaf.2
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 20:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689651809; x=1692243809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pm2gMrNh3ih+rsbR6NABGqNi1n0eSBAcRpAU/wsMVE0=;
        b=IRspjUYHvmiC1ZadVkuQ4Hltl46KAq/xlEqT0bDDyIWHpVy/SSrF7TL+v0klPPWDvI
         dPElsj0Ovf+MAydBgvZbl1/+iu/5GKi6+2t1WhfbfiETOsp0vWFdYeqNb9rWyGIFZFH/
         4CK6IgeOnnOzU5bDTvXqYETUzeiRfHkYd1Vh86gcu/g6Q94kXtJMEOPjzRtA5LvfDbRH
         Dz4ykIJItYsaDnKB4m6S7fsvPNbBvixQOfnigLecvk1oCRonRvcwzei8xmcCWT+SjsTK
         jm6vMK/KNlyuNjW8/NKH+r1Zw1HRMgaqvObhl+N3TLfxZm78J/B3Bj7GAz9FsjnlwXkz
         xwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689651809; x=1692243809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pm2gMrNh3ih+rsbR6NABGqNi1n0eSBAcRpAU/wsMVE0=;
        b=IBLe4TDLt6tG7J/++PkN4859xmYSLadBpqtH6bsVZBfY8GwBInogBqeeX5Wv6KJEfW
         1ANTs9DeoCLdG1MUZNQ7TM11dB75HBWg0EbX9TmNIs6e1wTXnx+oZ+ekTEu6PHIjxALE
         IQ/L0htBgJDZOJkz1RucyYik8WN9K4sS9+Wx0MjGBHYADL2/+xAjSUj+k4LPJhEBb+hE
         DJJraGz0rnFWpVIZytcxZ3Pszg6UngwaLAfLV6JLkFe5A5kSmMXtBmbwqNgTWT23a54O
         BOT/DeJOsi2d/hl1d31c0keH7rfRFp193vDd5B4VQ2u+gtnrysokjIfz7kPGGsZ8XGtC
         B0xg==
X-Gm-Message-State: ABy/qLaP6zo7VWFDtMOTWEt3WY2sVw3Soegf8LhALraH1Jf+1AbOthyJ
        wDYOHPHz9GJqZ9ozJz74YOI=
X-Google-Smtp-Source: APBJJlFr0f3AiaE19t6VH3LsRdYt7C7Rn3RttewoMF12GtfV7f5gK9tKSHnzdzFte9QBDqql2FdkpA==
X-Received: by 2002:a05:6358:7e0f:b0:135:4003:7849 with SMTP id o15-20020a0563587e0f00b0013540037849mr9966757rwm.4.1689651809491;
        Mon, 17 Jul 2023 20:43:29 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r23-20020a62e417000000b0066a613c4a58sm503198pfh.102.2023.07.17.20.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 20:43:28 -0700 (PDT)
Message-ID: <0810897c-de79-28b9-df3e-98eb442e803f@gmail.com>
Date:   Tue, 18 Jul 2023 11:43:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [Bug 217379] New: Latency issues in irq_bypass_register_consumer
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        "Alex Williamson, Red Hat" <alex.williamson@redhat.com>
References: <bug-217379-28872@https.bugzilla.kernel.org/>
 <ZE/uDYGhVAJ28LYu@google.com>
 <c1ac9dae-51d8-f570-db6c-39a161ab6bb9@gmail.com>
 <CABgObfbmR3oPhMirpKooPCMkMi=JwcoCjoVzS1-nXKhfYhOZhA@mail.gmail.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CABgObfbmR3oPhMirpKooPCMkMi=JwcoCjoVzS1-nXKhfYhOZhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/7/2023 11:25 pm, Paolo Bonzini wrote:
> On Mon, Jul 17, 2023 at 1:58 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>>      - Use a different data type to track the producers and consumers so that lookups
>>>        don't require a linear walk.  AIUI, the "tokens" used to match producers and
>>>        consumers are just kernel pointers, so I _think_ XArray would perform reasonably
>>>        well.
>>
>> My measurements show that there is little performance gain from optimizing lookups.
> 
> How did you test this?
> 
> Paolo
> 

First of all, I agree that the use of linear lookups here is certainly not
optimal, and meanwhile the point is that it's not the culprit for the long
delay of irq_bypass_register_consumer().

Based on the user-supplied kvm_irqfd_fork load, we note that this is a test
scenario where there are no producers and the number of consumer is growing
linearly, and we note that the time delay [*] for two list_for_each_entry()
walks (w/o xArray proposal) is:

- avg = 444773 ns
- min = 44 ns
- max = 1865008 ns

[*] calculate sched_clock() delta on 2.70GHz ICX

Compare this with the wait time delay on mutex_lock(&lock):

- avg = 117.855314 ms
- min = 20 ns
- max = 11428.340858 ms

It's fair to say that optimizing the lock bottleneck has greater
performance gain, right?

Please let me know what ideas you have to move this forward.
