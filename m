Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9596AB657
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 07:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCFGfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 01:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCFGfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 01:35:13 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FEBEC61
        for <kvm@vger.kernel.org>; Sun,  5 Mar 2023 22:34:33 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cy23so33921333edb.12
        for <kvm@vger.kernel.org>; Sun, 05 Mar 2023 22:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hJUTGqXMGW6Cvfi0ywOK0Ci1yU/jQFhAT6zE35M7ZeQ=;
        b=e48TI2ZvHI5FBKmp0u2PF06+IlS2gtAApcfcYqn5Kw9NSfKcduGBkxQkMGKyd7YfSZ
         a1SnidYMaFHBqZiLaWQLQDVVu/Ig2HOnd5jNQYRk5s6NGn7swquLiraIU2zQ5ro6Mjus
         AVUEtvkcycFPdDHJG+oZTEprW32XBeDU9eInwnQAvmDPry5owUwuXdjrX6ahHMpQRUmD
         2/COP9+gjmHybbeeq6SPbmRUMP6Q7qzIlaurKCAuyB32+7KCGOYg2zHE+R3pWm8VXiiH
         dAIPVyo3k8PtXL4OnySogb+pBOpHWIG4gNz8tRu8dnc14/lVUH9LgoGP67PWnN57pqpM
         rufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJUTGqXMGW6Cvfi0ywOK0Ci1yU/jQFhAT6zE35M7ZeQ=;
        b=b3aa/AH3KqatHCjGm5T5muD5lf23PIQhT+XmnNO4kMupAFxF+DMMCtsBGMPmLOJ1eM
         1+E6imSpKB1An6MJhZDU0smVwovOyu9BYfJYwE7+JddcF1FIMIfrqiNt22uvlp1pYf0Y
         1LVNGz4lXNZLe4qG3C2CFVHRXjQmKYT3jF5w3v2VvrvTexxhk06NgyuUW4Mf3/vxagI1
         V7xy3Ieay6teW72uBMA1SW6ibuwAjZDQ1D6LVUlUWrMsrLudbS9We+qp4Kipgx9bq0UY
         SylQ2z+TWU/3XU/ufOdGi0x0B0MxQywQNEHBPib797oMjlsHMkp/QpqpvUA6enM7lzU+
         B7vw==
X-Gm-Message-State: AO0yUKVXzPTVb/2GHFDMxXt3bXBQqk3LAKjn3satn/JZjL7EHnLS70qx
        WARmsoemG5Rd751g3mdILJTETeGUaPdqTkF6+Zk=
X-Google-Smtp-Source: AK7set8uKaGDlcX6Op9yv25E1smVg63HCTHMfb5vyBrLcyhP28O7rbqqRACkDd3RiPVzFWhhqUrpNQ==
X-Received: by 2002:a17:906:e98:b0:901:33f9:a3cc with SMTP id p24-20020a1709060e9800b0090133f9a3ccmr9730568ejf.68.1678084471410;
        Sun, 05 Mar 2023 22:34:31 -0800 (PST)
Received: from ?IPV6:2003:f6:af24:3c00:ae50:581:dd3c:8873? (p200300f6af243c00ae500581dd3c8873.dip0.t-ipconnect.de. [2003:f6:af24:3c00:ae50:581:dd3c:8873])
        by smtp.gmail.com with ESMTPSA id d8-20020a170906040800b008bda61ff999sm4125308eja.130.2023.03.05.22.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Mar 2023 22:34:30 -0800 (PST)
Message-ID: <d26b0ae9-bc72-3cfd-4428-d7760524c218@grsecurity.net>
Date:   Mon, 6 Mar 2023 07:34:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 0/6] KVM: MMU: performance tweaks for heavy CR0.WP
 users
Content-Language: en-US, de-DE
To:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org
References: <20230201194604.11135-1-minipli@grsecurity.net>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230201194604.11135-1-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.02.23 20:45, Mathias Krause wrote:
> v2: https://lore.kernel.org/kvm/20230118145030.40845-1-minipli@grsecurity.net/
> 
> This series is a resurrection of the missing pieces of Paolo's previous
> attempt[1] to avoid needless MMU roots unloading. The performance gap
> between TDP and legacy MMU is still existent, especially noticeable under
> grsecurity which implements kernel W^X by toggling CR0.WP, which happens
> very frequently.
> 
> Patches 1-13 and 17 of the old series had been merged, but, unfortunately,
> the remaining parts never saw a v3. I therefore took care of these, took
> Sean's feedback into account[2] and simplified the whole approach to just
> handle the case we care most about explicitly.
> 
> Patch 1 is a v3 of [3], addressing Sean's feedback.
> 
> Patch 2 is specifically useful for grsecurity, as handle_cr() is by far
> *the* top vmexit reason.
> 
> Patch 3 is the most important one, as it skips unloading the MMU roots for
> CR0.WP toggling.
> 
> Sean was suggesting another change on top of v2 of this series, to skip
> intercepting CR0.WP writes completely for VMX[4]. That turned out to be
> yet another performance boost and is implemenmted in patch 6.
> 
> While patches 1 and 2 bring small performance improvements already, the
> big gains come from patches 3 and 6.
> 
> I used 'ssdd 10 50000' from rt-tests[5] as a micro-benchmark, running on a
> grsecurity L1 VM. Below table shows the results (runtime in seconds, lower
> is better):
> 
>                          legacy     TDP    shadow
>     kvm.git/queue        11.55s   13.91s    75.2s
>     + patches 1-3         7.32s    7.31s    74.6s
>     + patches 4-6         4.89s    4.89s    73.4s
> 
> This series builds on top of kvm.git/queue, namely commit de60733246ff
> ("Merge branch 'kvm-hw-enable-refactor' into HEAD").
> 
> Patches 1-3 didn't change from v2, beside minor changlog mangling.
> 
> Patches 4-6 are new to v3.
> 
> Thanks,
> Mathias
> 
> [1] https://lore.kernel.org/kvm/20220217210340.312449-1-pbonzini@redhat.com/
> [2] https://lore.kernel.org/kvm/YhATewkkO%2Fl4P9UN@google.com/
> [3] https://lore.kernel.org/kvm/YhAB1d1%2FnQbx6yvk@google.com/
> [4] https://lore.kernel.org/kvm/Y8cTMnyBzNdO5dY3@google.com/
> [5] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git
> 
> Mathias Krause (5):
>   KVM: VMX: Avoid retpoline call for control register caused exits
>   KVM: x86: Do not unload MMU roots when only toggling CR0.WP
>   KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
>   KVM: x86/mmu: Fix comment typo
>   KVM: VMX: Make CR0.WP a guest owned bit
> 
> Paolo Bonzini (1):
>   KVM: x86/mmu: Avoid indirect call for get_cr3
> 
>  arch/x86/kvm/kvm_cache_regs.h   |  3 ++-
>  arch/x86/kvm/mmu/mmu.c          | 31 ++++++++++++++++++++-----------
>  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
>  arch/x86/kvm/mmu/spte.c         |  2 +-
>  arch/x86/kvm/pmu.c              |  4 ++--
>  arch/x86/kvm/vmx/capabilities.h |  1 +
>  arch/x86/kvm/vmx/nested.c       |  4 ++--
>  arch/x86/kvm/vmx/vmx.c          | 15 ++++++++++++---
>  arch/x86/kvm/vmx/vmx.h          |  8 ++++++++
>  arch/x86/kvm/x86.c              |  9 +++++++++
>  10 files changed, 58 insertions(+), 21 deletions(-)

Ping!

Anything I can do to help getting this series reviewed and hopefully merged?

Thanks,
Mathias
