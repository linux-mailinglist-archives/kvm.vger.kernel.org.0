Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5613F6F3BBD
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 03:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbjEBBQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 21:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjEBBQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 21:16:09 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29513A8D
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 18:16:08 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-5286311be47so2102165a12.1
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 18:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682990168; x=1685582168;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6QBwaKlUjWN2NGzBXeCWCmzO37tEyotKyssaBO20HFM=;
        b=T/du0SEabWZH9U04NHHBWUOxqbp/slNjEXVBox6PFNMkn2MAZnq0/86k9YQNcsznXI
         W3vYbf4atec6EQp1iLu46EiFAq2gejqX+QUecaqjK2ywrC9GffRskPudHaU2ZxIRqsFP
         rQza14gQWqkiK/4M5B+BvG1suOMD+9e4musczyfFq2oH710BqLShtAG/37/FaZxqxM6K
         3x8P9IU6TaivabOpXIsLa2U3VbIPC8XCEqUfZRb0St72Dax0wnLXg6DqeG0/eQu0ORo1
         Be/iptHEDIuWVJFmPO3t+NMPxEe53/i6iZCp8moMeG4sCKaRoQvxOFlWzJ1OEae6PD8h
         m6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682990168; x=1685582168;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6QBwaKlUjWN2NGzBXeCWCmzO37tEyotKyssaBO20HFM=;
        b=hFxPW/ThxfXaLcfh0TkqCc3TjH2msmm576N00OmVW/QO7CXarBA8o8IinmjaZfWQND
         qvY2qzzSSF/GA51Rzw1/lEf1t2y4DCnvYI10/c97mUCcFR0D6qEJtt+97VsDjn6PXrjh
         WmQGJssz8+K7APESJUf9f4JI9JDa6xh0bVAhJOg0DvV/TilrrJPviF1crMjBe4HAgmfZ
         BStNiph6ZSuDpIahxLe0bzX24kxBZoaWcuUopjnBE5GF5i7R47K0kKTycGxskRa9Mw/H
         kTp7P/2Q4UKMPRmxoznGFsU6xQzI9lDSAp9YavcomoeECmrzupcholrCPegJeyxKaLfw
         IYxg==
X-Gm-Message-State: AC+VfDxUUV3VZOKyeufYRQ+fwDYRyLrYXvq3GI7arUCGubMBr4Q0LFCi
        gme47SkOuF3jnDgDYIkhICN5IVlFo+RuYA==
X-Google-Smtp-Source: ACHHUZ6jrdDL16gB1QYCA4x0+HiwWvY5Qh+naIb0zt9+AJ2rLVCNGf1mMAmdySLHLgIM5SHQcCskpA==
X-Received: by 2002:a17:903:244f:b0:1a9:b977:81c7 with SMTP id l15-20020a170903244f00b001a9b97781c7mr19717256pls.62.1682990168123;
        Mon, 01 May 2023 18:16:08 -0700 (PDT)
Received: from [172.27.224.2] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id e17-20020a17090301d100b001a52ee4c4a5sm8138440plh.60.2023.05.01.18.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 18:16:07 -0700 (PDT)
Message-ID: <665d7fc9-5245-b63c-af6a-aae6ba9aabce@gmail.com>
Date:   Tue, 2 May 2023 09:16:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Latency issues inside KVM.
To:     Sean Christopherson <seanjc@google.com>
Cc:     zhuangel570 <zhuangel570@gmail.com>, kvm@vger.kernel.org
References: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
 <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com>
 <ZE/R1/hvbuWmD8mw@google.com>
Content-Language: en-US
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <ZE/R1/hvbuWmD8mw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/1/2023 10:51 PM, Sean Christopherson wrote:
> 
> For the NX hugepage mitation, I think it makes sense to restart the discussion
> in the context of this thread: https://lore.kernel.org/all/ZBxf+ewCimtHY2XO@google.com
> 
OK, wasn't aware of that thread. Thanks for pointing out.
Just took a glance at it, I'll comment there.


> TL;DR: I am open to providng an option to hard disable the mitigation, 

Why hard disable? Isn't already "nx_huge_pages" parameter sufficient for this?
My aforementioned not-sent-out patch is to consider nx_huge_pages for 
creating the kthread or not, i.e. if nx_huge is enabled, start the kthread, 
if not, terminate the kthread; once re-enabled, spawn the kthread again...

> but there
> needs to be sufficient justification, e.g. that the above 100ms latency is a
> problem for real world deployments.
> 
Ah, I was objected by similar reason: the kthread does nothing if 
nx_huge_pages = false, it does no harm. Therefore I put the patch aside.

For the justification from real world, I guess Zhuangel570 can say more.

>> As more and more old CPUs retires, I think NX-HugePage code will become more
>> and more minority code path/situation, and be refactored out eventually one
>> day.
> 
> Heh, yeah, one day.  But "one day" is likely 10+ years away.  Intel discontinuing
> a CPU has practically zero relevance to KVM removing support a CPU, e.g. KVM still
> supports the original Core CPUs from ~2006, which were launched in 2006 and
> discontinued in 2008.

OK, got it.
Why does KVM still FULLY support so old CPUs? Any real world users? What's 
the rational/necessity? even if it's already EOL by manufacture.
My thought was that each new generation of CPU will linger in CSP's data 
center for 3~4 yrs.

