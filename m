Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB37761777C
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 08:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiKCHSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 03:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiKCHSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 03:18:18 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75FAD61
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 00:18:17 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h9so1367189wrt.0
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 00:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D/SNnecemsjQs+W90QUlkgsOD/Rjb4+lDkgjOjEDTCQ=;
        b=jw3d99cvMg52Lg1tLW9BuRNFr97hU8VbjiyM8gochZWG1eGvxYgj4JDJfCZnnjS66j
         2lDmaY49Y9gNXV+0NqqYMPompzAvLelDDyxTDyv63Mzv1FpaKJ2B9UYwTxwc6+9E1fj5
         FJhI1fX/X/YYeQJFY71s0y5YmCRlxUG6ujCNUlpLlY/mY+G8+yumC0FbiEGwNFo+LVFU
         bsVfMxNPq9XriX8IesQE+M4MIPqclT9ZI+C/ooGdqt08Ib6SHWOMYVtcjCYmkNt5Y22V
         kEpFY0C9GTT/VRjoVENUsza65QqqGrehKGm4P0CKYdVEVtyKJm9XwB/y8pqmKkigPrlA
         3XhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D/SNnecemsjQs+W90QUlkgsOD/Rjb4+lDkgjOjEDTCQ=;
        b=q+RZH9a3jtFT9B83Lmp0zRfW0rVapUd3m7hzoht2JFLHshwNt2VE1ZAdjuHMfplOmi
         xeYRTSeFkttRVdwyheOy1RCJhLEwgnlu8YvCjRdgcUfFcQnw4HvpcjHMbi3kabG9d4Fv
         PSj78Qr3IEiD53hN1R+PpdL6JPghMV8eQ0/u+MjgbbUxTs4pxRD0qagJvfP9ThoJs1sj
         YwnH/27DYiOLSwoMQnwzFrmCfSFFBWSGdHVXUH9XtNVF9GcnN6ed2xLUSQF4gL2/mYTD
         NaOTRVF0Xx1hqTZWcpeHcu9GwQlM0OkPOg/N2D6b6dC1aDaAhkia7+Zrcub4Jjf3oQ7n
         USjg==
X-Gm-Message-State: ACrzQf3/JuuHuZNJ2yj4r4l6tfAfWv3Az6H4ZXguKBqCA9LJ4ISD0fXO
        IVkGUvX+CihxfsCj9l80V1jabQ==
X-Google-Smtp-Source: AMsMyM6jhYnE/aEjYcHXapzofavAu7pX7ddMD038s2P34j/GAHoNYKyfFysuRe52YUvpGlRBEmTO3A==
X-Received: by 2002:a5d:42c7:0:b0:236:4ddd:3576 with SMTP id t7-20020a5d42c7000000b002364ddd3576mr17938354wrr.289.1667459896483;
        Thu, 03 Nov 2022 00:18:16 -0700 (PDT)
Received: from [192.168.11.175] (216.red-88-29-181.dynamicip.rima-tde.net. [88.29.181.216])
        by smtp.gmail.com with ESMTPSA id j7-20020a05600c190700b003b477532e66sm6341187wmq.2.2022.11.03.00.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 00:18:15 -0700 (PDT)
Message-ID: <1da0b1fa-ca20-4370-26b4-9f18ab8ac95d@linaro.org>
Date:   Thu, 3 Nov 2022 08:18:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH 27/44] KVM: Drop kvm_arch_{init,exit}() hooks
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-28-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221102231911.3107438-28-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/22 00:18, Sean Christopherson wrote:
> Drop kvm_arch_init() and kvm_arch_exit() now that all implementations
> are nops.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kvm/arm.c                | 11 -----------
>   arch/mips/kvm/mips.c                | 10 ----------
>   arch/powerpc/include/asm/kvm_host.h |  1 -
>   arch/powerpc/kvm/powerpc.c          |  5 -----
>   arch/riscv/kvm/main.c               |  9 ---------
>   arch/s390/kvm/kvm-s390.c            | 10 ----------
>   arch/x86/kvm/x86.c                  | 10 ----------
>   include/linux/kvm_host.h            |  3 ---
>   virt/kvm/kvm_main.c                 | 19 ++-----------------
>   9 files changed, 2 insertions(+), 76 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

