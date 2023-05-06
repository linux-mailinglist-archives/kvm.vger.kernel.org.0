Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5D6F9295
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 17:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjEFO77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 10:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjEFO76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 10:59:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7F91E998
        for <kvm@vger.kernel.org>; Sat,  6 May 2023 07:59:58 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6436e075166so2186199b3a.0
        for <kvm@vger.kernel.org>; Sat, 06 May 2023 07:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683385197; x=1685977197;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0WknxeLIgyh/IdA63MY18VpPwY0hLVlMX7AWRB4K0d8=;
        b=GxEMZH1Ms5UVmNyONeKBcwZ5UxA1oMHlBKyyueGxcv62gDKU0fyhHZfZK+ZEf/Z5Jr
         3KwtnJgMkNSm3X8mLl3OPainrJtB01zS7badlSMt6fu8Qa5t3qjllKqAK9dB729JrdQQ
         VW+ZDqtoAMNrpEgezAzL3P5UlUBCIYhxsZnE0yh4YRKckcPonQg1xhIW8c1W5pZFRiZ3
         wYiCsrrncA7NHTTLHZtf9GOmPnKSM0kQftnZFDpP5GAzPiihYZj9FljEGyQJnOZzs7hy
         rae8eym+YsfjQ52tZjfw440sgStF6puf5gqonNGsIpR8uK0Dv6A6EvYnaEP6je3qivTt
         qkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683385197; x=1685977197;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0WknxeLIgyh/IdA63MY18VpPwY0hLVlMX7AWRB4K0d8=;
        b=T2D5k7gPrajrJ+Fiu6A1adk3QoO2IfRRfBvBIjKZwguwIGoawIlIGiujIAOk+2VbUw
         dQK7j8mM0s24eGlg+7UUy95F6G1XgrlthK+IHEfO8oYWEyKp4BZxW+1Y+YHBGU69EqWA
         U5bnhTh0tOs10Lmqp4vNFuMuWjhA11aiZK2GhJkJsdxPc7rAUycMcsVAIRQvxtyj/ZQp
         CJREfbwoOCgJ35B3HB0MJ0QD2guZLN0UWJxawxUusJ/zHzEXRf3qMpu3WyS8rHjtG6XI
         C33VHlIIPpv7yXgkjg7Rb3JBR6DDAEduLv8fs1NWwujWa445FkW0yH2LJM8xJJKz8cXV
         nQDA==
X-Gm-Message-State: AC+VfDyq3R1CRKqokpbtdWSvWGP1dZGxga9e5mxX5j1Ks/Y3PQypdvgN
        2tzMHjH1CAVeGHyxzbCkoYU=
X-Google-Smtp-Source: ACHHUZ7TBt01Q8SaUznGgxMRguQUYhqpH8LFLmgqjGyFXr9GafhFngJjdhKet0UJT5FElzHV6g1JDw==
X-Received: by 2002:a05:6a00:2e18:b0:638:7e00:3737 with SMTP id fc24-20020a056a002e1800b006387e003737mr6519147pfb.23.1683385197389;
        Sat, 06 May 2023 07:59:57 -0700 (PDT)
Received: from [172.27.224.4] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id j21-20020a62e915000000b005a8173829d5sm3256704pfh.66.2023.05.06.07.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 May 2023 07:59:57 -0700 (PDT)
Message-ID: <1ae0812e-bc0a-2de5-44f5-9e8b15dd4ce8@gmail.com>
Date:   Sat, 6 May 2023 22:59:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: x86/mmu: Don't create kvm-nx-lpage-re kthread if not
 itlb_multihit
Content-Language: en-US
To:     zhuangel570 <zhuangel570@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     lirongqing@baidu.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        kvm@vger.kernel.org, x86@kernel.org
References: <1679555884-32544-1-git-send-email-lirongqing@baidu.com>
 <b8facaa4-7dc3-7f2c-e25b-16503c4bfae7@gmail.com>
 <CANZk6aTqiOtJiriSUtZ3myod5hcbV8fb7NA8O2YmUo5PrFyTYw@mail.gmail.com>
 <ZFVAd+SRpnEkw5tx@google.com>
 <CANZk6aTQoYn5g2ELucjg16yTjo13xUeprOMfgJtZVY+psxHTCQ@mail.gmail.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <CANZk6aTQoYn5g2ELucjg16yTjo13xUeprOMfgJtZVY+psxHTCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/2023 3:12 PM, zhuangel570 wrote:
> The "never" parameter works for environments without ITLB MULTIHIT issue. But
> for vulnerable environments, should we prohibit users from turning off
> software mitigations?
> 
> As for the nx_huge_page_recovery_thread worker thread, this is a solution to
> optimize software mitigation, maybe not needed in all cases.
> For example, on a vulnerable machine, software mitigations need to be enabled,
> but worker threads may not be needed when the VM determines that huge pages
> are not in use (not sure).

Then nx_hugepage is totally not needed:)
> 
> Do you think it is possible to introduce a new parameter to disable worker
> threads?

I suggest no. I would perceive this kthread as ingredient of nx_hugepage 
solution.


