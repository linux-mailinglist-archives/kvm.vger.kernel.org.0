Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB3F74F493
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 18:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjGKQNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 12:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjGKQM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 12:12:57 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24B6E60;
        Tue, 11 Jul 2023 09:12:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-26309247002so3050588a91.0;
        Tue, 11 Jul 2023 09:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689091976; x=1691683976;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYqNYiLc/VSRqT0IHIEaGbe+Ec1s2G3MAEV854wLvwE=;
        b=lNNx6wWm01i6FwGu8spXhcN5UCoLG5hsLjrXiCM02iWMfDXX+ON9g8z1ghV8+o5cyd
         v6jJ5u3Uh4EJVmmsupEV0ufyjZuRR22Lx8JDLNe0iITwbF+DG+bRc76xVWP5foKNl/bA
         VQPEkLtQgRY1cnE3JFOISQorcXTeB/Q15r4YoHOBEFBizzSkzbIjIkEAWtiOQSpIBt9u
         T3VcbxdjXf1L1b64mSTfC9n6Yz3u5cQBEMe+0isGq2JxWWkKahPYTsoeG6m1mMkG5J5v
         8BKQS+XqjqWxRCUmto4otY/niPLpFA2LEwmhMkUk+YUfzOdKliI/dostWi7tLVNXRuWb
         PvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689091976; x=1691683976;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fYqNYiLc/VSRqT0IHIEaGbe+Ec1s2G3MAEV854wLvwE=;
        b=hnO81vub/p//uo1gRD9HBsgIXPvN2iUCP17j7jqWk0jFAXMVPXJLMNml52bcrkgydk
         isIHHbeB5FCfh6TrIpWgm6LcOITn0uY7MgFpBNmZukWmb7+clhgWZ3HEhGWh61XEUxNj
         A0axLw2mAInwEEkuYqiwLgCsk7cdrRse3HVNNsSIrIPb319/x/GwdgdXVD/5WpmwK/y/
         Emvw6ozdAkTRExwB/PI5P4BTzypaBr0QIz111MBnTSfZE9mG3R/uQ3Na5cjjZfJP6dvD
         1Wpw4AOT40LkLTtE+zGs1TQd2pGXRHcoWGKQUMlhbb2w2HNgXlD5J5fQG9mmrW0FJS6N
         JQIg==
X-Gm-Message-State: ABy/qLbZ8lQjQgmUNHr9VJRdxsC6W0mvMwuGpzQShdmiZSfk3BeebNfR
        veUml78woEdFP8H8OCTYHQA=
X-Google-Smtp-Source: APBJJlH6dO4+7GQad8x8JpVrfs7jmDMeW8kSHYXyu7QhVBhXnNN8LtrgubcmcS300pSMyiX8pzIOdQ==
X-Received: by 2002:a17:90a:c90f:b0:262:e564:3ecb with SMTP id v15-20020a17090ac90f00b00262e5643ecbmr12337345pjt.36.1689091975889;
        Tue, 11 Jul 2023 09:12:55 -0700 (PDT)
Received: from [192.168.255.10] ([114.84.31.161])
        by smtp.gmail.com with ESMTPSA id c6-20020a17090a020600b00263dccf96a3sm2133756pjc.54.2023.07.11.09.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 09:12:54 -0700 (PDT)
Message-ID: <4b621470-8c58-264b-1e8b-75cec73cd7b0@gmail.com>
Date:   Wed, 12 Jul 2023 00:12:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
To:     Sean Christopherson <seanjc@google.com>,
        Luiz Capitulino <luizcap@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Yong He <zhuangel570@gmail.com>,
        Robert Hoo <robert.hoo.linux@gmail.com>,
        Kai Huang <kai.huang@intel.com>
References: <20230602005859.784190-1-seanjc@google.com>
 <168667299355.1927151.1998349801097712999.b4-ty@google.com>
 <abf509a2-ebfd-7b5f-4f7a-fdd4ef60c1de@amazon.com>
 <ZIoQDbte/uAiit9N@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZIoQDbte/uAiit9N@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/6/15 03:07, Sean Christopherson wrote:
> On Wed, Jun 14, 2023, Luiz Capitulino wrote:
>>
>>
>> On 2023-06-13 19:21, Sean Christopherson wrote:
>>
>>>
>>>
>>>
>>> On Thu, 01 Jun 2023 17:58:59 -0700, Sean Christopherson wrote:
>>>> Add a "never" option to the nx_huge_pages module param to allow userspace
>>>> to do a one-way hard disabling of the mitigation, and don't create the
>>>> per-VM recovery threads when the mitigation is hard disabled.  Letting
>>>> userspace pinky swear that userspace doesn't want to enable NX mitigation
>>>> (without reloading KVM) allows certain use cases to avoid the latency
>>>> problems associated with spawning a kthread for each VM.
>>>>
>>>> [...]
>>>
>>> Applied to kvm-x86 mmu.  I kept the default as "auto" for now, as that can go on
>>> top and I don't want to introduce that change this late in the cycle.  If no one
>>> beats me to the punch (hint, hint ;-) ), I'll post a patch to make "never" the
>>> default for unaffected hosts so that we can discuss/consider that change for 6.6.
>>
>> Thanks Sean, I agree with the plan. I could give a try on the patch if you'd like.
> 
> Yes please, thanks!
> 
> 

As a KVM/x86 *feature*, playing with splitting and reconstructing large
pages have other potential user scenarios, e.g. for performance test
comparisons in a easier approach, not just for itlb_multihit mitigation.

On unaffected machines (ICX and later), nx_huge_pages is already "N",
and turning it into "never" doesn't help materially in the mitigation
implementation, but loses flexibility.

IMO, the real issue here is that the kernel thread "kvm-nx-lpage-
recovery" is created unconditionally. We also need to be aware of the
existence of this commit 084cc29f8bbb ("KVM: x86/MMU: Allow NX huge
pages to be disabled on a per-vm basis").

One of the technical proposals is to defer kvm_vm_create_worker_thread()
to kvm_mmu_create() or kvm_init_mmu(), based on 
kvm->arch.disable_nx_huge_pages, even until guest paging mode is enabled
on the first vcpu.

Is this step worth taking ?
