Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C55704F48
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 15:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjEPN3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 09:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjEPN3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 09:29:18 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963C410DA;
        Tue, 16 May 2023 06:29:17 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64a9335a8e7so5612151b3a.0;
        Tue, 16 May 2023 06:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684243757; x=1686835757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jUpMKkeQ46D5uu18ivzpTiIogNM9XxtMaWsIe0fYmGc=;
        b=NaJWSEVAIt3X4DtjyEJdf8yCCDHUz3EQN6BKfiW80SIkZspCQAyB4bjm07gOlridsq
         /kaDGDRXLMJj6VB6sQg/Dt4IREqxuGwEVzrm2/o6NylG1XFMBl8AMP0jcrNEeJlwPUzs
         UZJTie37JGC+/D0aHFikoWpQkzZuffCP440Qj4iD1DMaDQ8Cul6NIJjtQVM9j/JXXS7M
         ztijTyH6kKgs4wN5H+UC/tSu7rIezUNZCC/JPFcKZspnaqQqil1esGcDIconlB3YB24b
         szpqm+Gn0dHjC/WqdaDrWRAu5OPqQAvjVl+uOTfQWMTZVdLIbdLmNQscVjItfyhgOb0W
         6r8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684243757; x=1686835757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jUpMKkeQ46D5uu18ivzpTiIogNM9XxtMaWsIe0fYmGc=;
        b=PHPyRYWAV50DfR94uDSm1ymjKtP+MC3LLXgNdYSwCprJy6mpaLveCpm7CY7aBKMJaI
         NpH7FT7G9RN+Skt0dFrM3UzZCv8aBcSnv4qlMsdCP88RAfjwDvYleHPkRpGHkB8+tSI+
         yi0LKqV3AaFd/rinFrhbAC8rOBVYzi8KH4MnwC6m5zuLpZtuMyZGHjwni4I+cxl7BuBM
         hLeQF43MCQBzfneZ44TvbF01/a2DIkY5FtN2Ab+QqD9gFMNaKg7nI6hr5Rs59itExeDy
         a15bY9baepwZx7u98yNTOCDz3+U+pr3aoCtbPbCAv2fag6ghLXeQuU/pugndwJxs1+/M
         2M2A==
X-Gm-Message-State: AC+VfDx/aSOBKe9UEYxpKpyWJOQxirvA8cG4wofk6RuAtbSf8C+VLI+a
        /Ks0EqsKHv/43askzoaFiH0=
X-Google-Smtp-Source: ACHHUZ5KQBHcV/EXVP/PA0CwMyI4VZOO8xTzsMe1XoYtRsH8glLYgll8eLIrWe/4QGYAucRkKnpjbA==
X-Received: by 2002:a05:6a00:b45:b0:63d:3c39:ecc2 with SMTP id p5-20020a056a000b4500b0063d3c39ecc2mr45566401pfo.12.1684243756820;
        Tue, 16 May 2023 06:29:16 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n23-20020a62e517000000b0064398fe3451sm13327197pff.217.2023.05.16.06.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 06:29:16 -0700 (PDT)
Message-ID: <2d7f7f80-278d-9fcf-cfc4-c433e95d9842@gmail.com>
Date:   Tue, 16 May 2023 21:29:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH 0/2] KVM support for Intel PMU v5 fixed function PMC
 bitmap
Content-Language: en-US
To:     Anselm Busse <abusse@amazon.com>
Cc:     dwmw@amazon.co.uk, hborghor@amazon.de, sironi@amazon.de,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230427095333.35038-1-abusse@amazon.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230427095333.35038-1-abusse@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/4/2023 5:53 pm, Anselm Busse wrote:
> Starting with v5, the Intel PMU allows to indicate the available fixed
> function PMCs not only through CPUID.0AH.EDX[4:0] but also through a
> bit mask in CPUID.0AH.ECX. According to the SDM the OS can consider a
> fix function PMC i supported for:
> 
> CPUID.0AH.ECX[i] || (CPUID.0AH.EDX[4:0] > i)

Yes, this feature is attractive for virtualization scenarios, and it gives 
flexibility
to control which fixed counters are available or not in the virtual machine.

However, currently KVM/x86 also supports Intel PMU V2, so I would expect
that we will review the enablement code for v3 and v4 first.

Ref: 
https://lore.kernel.org/kvm/CALMp9eQVnk8gkOpX5AHhaCr8-5Fe=qNuX8PUP1Gv2H5FSYmHSw@mail.gmail.com/

> 
> This behavior is already supported by the Intel PMU driver. However, KVM
> support is missing. This patch series add the support by first
> refactoring the tracking of available fixed function PMCs in KVM from a
> number to a bitmap in the frist patch. The second patch populates the
> bitmap accoring to the rule given by the SDM mentioned above.
> 
> Regards,
> Anselm
> 
> Anselm Busse (2):
>    KVM: vmx/pmu: Indicate available fixed function PMCs through a bitmap
>    KVM: vmx/pmu: Add support for selected fixed vPMU enablement for PMU v5
> 
>   arch/x86/include/asm/kvm_host.h |  2 +-
>   arch/x86/kvm/pmu.h              |  6 ++---
>   arch/x86/kvm/svm/pmu.c          |  2 +-
>   arch/x86/kvm/vmx/pmu_intel.c    | 40 ++++++++++++++++++++-------------
>   4 files changed, 30 insertions(+), 20 deletions(-)
> 
> 
> base-commit: 0cfd8703e7da687924371e9bc77a025bdeba9637
