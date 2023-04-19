Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C77D6E7B15
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbjDSNl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjDSNl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:41:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2F2E60;
        Wed, 19 Apr 2023 06:41:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k65-20020a17090a3ec700b00247131783f7so765624pjc.0;
        Wed, 19 Apr 2023 06:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681911716; x=1684503716;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E3S7zUDqSoGDbvXpJqNdjvrmE0MdUknEcdQTrbgz6t4=;
        b=okkUGo7gegyBD1nHjFvS6ZtyWsjV2AUXQmYK005ZtfngbgAwntbnuR92yEq1p/Xxlf
         r1ReTZFI6mgRMkXTAa5YLi4cjQ/VbBWji6o5ZExu040KTWeUCsTPNz6EIzTIPL0AM07U
         GitaV/m6Nd4SCe4M96IfaG10Q/YqQFDbNcb27qu8KBH2DjTjRr68fO4n9IZC9gS+xBVt
         nzTqmk6ufa8SZGlOyOB4ZCYFwZ4kGu/vmOpzDxHGtLD+RseqQgDZrKRkQJ+tBvVFAqo0
         XxLnZSQi+jYrkMKuuh+5x74wEpnLPdUgDYnMkosBwDok2fQGFYBVWUBmY7lPD7UhA1Xy
         oPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681911716; x=1684503716;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E3S7zUDqSoGDbvXpJqNdjvrmE0MdUknEcdQTrbgz6t4=;
        b=fUzDDTiq1hwaaWCAEGxlkFirvaK8QU7NLrSwK+PRB6F57E/ex6PzWp5WDv8XhP+bU9
         pJO5DHTCYy4u8ZlycWKKQZVLqTc85NkLw+EoonOxMGJLuFpDXjg1KTLKmi9egehYqYIN
         wN1XXWPI7Xo8jNNfhe0KIvVXi8T+QVfgwX4iEOwy1fUmp3bPqA2+4ovWIVxELVlbhloX
         r1X9prNom41ZundkFSt/sHZ7kmBgrGRvlSl1Qz9wAqEHv8oLNTAIPUk3bdqUTyay9XK6
         oWEBLMUqHOYDosJxxVte7/O/2kUKKSj3YPu+2ipEOfq5mAnPQQ+AA/iU0x+c3125WrlE
         vHTg==
X-Gm-Message-State: AAQBX9dfhaLncySZ6ffDpvlPZEy7Qz0n/PiQEMoqGJ5sIkzqj/h7FMgn
        ahGg+v/YpzIqLRj8ZBpmv+o=
X-Google-Smtp-Source: AKy350asPZehfUNLL9aORgUWJy61wPDiDBSsoimxzU9gOkx8nipugfIttaItji5zLn/y5X7EhhuujA==
X-Received: by 2002:a05:6a21:151b:b0:f0:3c5e:b997 with SMTP id nq27-20020a056a21151b00b000f03c5eb997mr3253130pzb.58.1681911715565;
        Wed, 19 Apr 2023 06:41:55 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p22-20020aa78616000000b0063b675f01a2sm9206802pfn.26.2023.04.19.06.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 06:41:54 -0700 (PDT)
Message-ID: <34b5dd08-edac-e32f-1884-c8f2b85f7971@gmail.com>
Date:   Wed, 19 Apr 2023 21:41:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Bangoria, Ravikumar" <ravi.bangoria@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        "Tom Lendacky (AMD)" <thomas.lendacky@amd.com>,
        Ananth Narayan <ananth.narayan@amd.com>
References: <20230310105346.12302-1-likexu@tencent.com>
 <20230310105346.12302-6-likexu@tencent.com> <ZC99f+AO1tZguu1I@google.com>
 <509b697f-4e60-94e5-f785-95f7f0a14006@gmail.com>
 <ZDAvDhV/bpPyt3oX@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZDAvDhV/bpPyt3oX@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/2023 10:56 pm, Sean Christopherson wrote:
> On Fri, Apr 07, 2023, Like Xu wrote:
>> On 7/4/2023 10:18 am, Sean Christopherson wrote:
>>> Wait, really?  VMRUN is counted if and only if it enters to a CPL0 guest?  Can
>>> someone from AMD confirm this?  I was going to say we should just treat this as
>>> "normal" behavior, but counting CPL0 but not CPL>0 is definitely quirky.
>>
>> VMRUN is only counted on a CPL0-target (branch) instruction counter.
> 
> Yes or no question: if KVM does VMRUN and a PMC is programmed to count _all_ taken
> branches, will the PMC count VMRUN as a branch if guest CPL>0 according to the VMCB?

YES, my quick tests (based on run_in_user() from KUT on Zen4) show:

EVENTSEL_GUESTONLY + EVENTSEL_ALL + VMRUN_to_USR -> AMD_ZEN_BR_RETIRED + 1
EVENTSEL_GUESTONLY + EVENTSEL_ALL + VMRUN_to_OS -> AMD_ZEN_BR_RETIRED + 1

EVENTSEL_GUESTONLY + EVENTSEL_USR + VMRUN_to_USR -> AMD_ZEN_BR_RETIRED + 1
EVENTSEL_GUESTONLY + EVENTSEL_OS + VMRUN_to_OS -> AMD_ZEN_BR_RETIRED + 1

VENTSEL_GUESTONLY + EVENTSEL_OS + VMRUN_to_USR -> No change
VENTSEL_GUESTONLY + EVENTSEL_USR + VMRUN_to_OS -> No change

I'm actually not surprised and related test would be posted later.

> 
>> This issue makes a guest CPL0-target instruction counter inexplicably
>> increase, as if it would have been under-counted before the virtualization
>> instructions were counted.
> 
> Heh, it's very much explicable, it's just not desirable, and you and I would argue
> that it's also incorrect.

This is completely inaccurate from the end guest pmu user's perspective.

I have a toy that looks like virtio-pmu, through which guest users can get 
hypervisor performance data.
But the side effect of letting the guest see the VMRUN instruction by default is 
unacceptable, isn't it ?

> 
> AMD folks, are there plans to document this as an erratum?  I agree with Like that
> counting VMRUN as a taken branch in guest context is a CPU bug, even if the behavior
> is known/expected.

+CC: Santosh, Tom, Ananth

