Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199A464B2BE
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 10:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbiLMJwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 04:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235010AbiLMJwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 04:52:02 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7718B15735
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 01:52:01 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id w15so14989773wrl.9
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 01:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q5puRTi/aBwHreExscKf/w+BThNFn9mhIDV4jDBOxJ4=;
        b=cX9OvtSSUPl2VjlUMxN9wkJTxjF4VMryEK2+74/Jcp2+VxH/7zdJAOksUNssIxTm51
         zg9bgDUDeJ1da0Q996JdsUZgJPySpalntdnf95UOKKDwkbLVqfZrmNUqAsJxl8FWHMCo
         iy42JdAmC96Wf8DLM5Sr75akb1KR+vn97tncFrPZBcvjFGsoCr31lDbd1B+K+87hjvvn
         J6OXoKWzFDZwo6PVBpAVoy279lQ0QJaFjVIq0qJgY5lAWSUvA0Y+b8aCIhtTQTKtfXNx
         h4SjEkvduYcq4V2JhT/HRFFC/rhUGSGHW5+soZiuFIjG+etlAVkEl6tT5ICKi8K/z2Ab
         cL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5puRTi/aBwHreExscKf/w+BThNFn9mhIDV4jDBOxJ4=;
        b=aqz92iH5Ts/N74LPlfsqHTlrO6E0ZNGEbS2CxFN07AbFXNBx8N7crteYr1CfiqgpZp
         a4MC1e6R+bvJb8M5vO7jlxLNMXgBZf6MXGwWFAZDeKlpjGVsFQFVAjQ6hOUEjRQ0cdOt
         ULefyOgtr4G/Hyx9L1uGVr+WF6CYx3xdwrxBCugJQF45E2TL80LjbRt3berWvtKqNKkl
         NHyqV0vmLsuCvdd9YVAY8hRUj9ZJZeHSkRJR67QFfiwMugysoXV94pFXUN87eQNF5C4q
         gR/RHUMK/MZNxzwCd6wAPP7Z3SiTZ2coJOzX/zPZLJ/Wb5OBk4S5nst0Z7R+RENsgNP9
         3+YA==
X-Gm-Message-State: ANoB5pn/YOOT325UFscmXeTdw6CpFILHY7C7bVLXSzVMUwSmFHG83xqd
        NTb7fzteOdwo2NEE1p/9vm4YzA==
X-Google-Smtp-Source: AA0mqf4PMHJopL+j1/FAA6cNdu0WvhJE91YQY4pXO/EmIJ2pu66aV5lVRtcU7SIMWuMwfp4CKKKVmw==
X-Received: by 2002:adf:d22f:0:b0:242:1fb8:1ca9 with SMTP id k15-20020adfd22f000000b002421fb81ca9mr10116658wrh.37.1670925120065;
        Tue, 13 Dec 2022 01:52:00 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id y5-20020a5d4705000000b00241f029e672sm10620076wrq.107.2022.12.13.01.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 01:51:59 -0800 (PST)
Message-ID: <f32e0526-2c67-0962-52c8-27d02439fbc2@linaro.org>
Date:   Tue, 13 Dec 2022 10:51:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 01/14] KVM: selftests: Define literal to asm constraint in
 aarch64 as unsigned long
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-2-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221213001653.3852042-2-seanjc@google.com>
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

On 13/12/22 01:16, Sean Christopherson wrote:
> Define a literal '0' asm input constraint to aarch64/page_fault_test's
> guest_cas() as an unsigned long to make clang happy.
> 
>    tools/testing/selftests/kvm/aarch64/page_fault_test.c:120:16: error:
>      value size does not match register size specified by the constraint
>      and modifier [-Werror,-Wasm-operand-widths]
>                         :: "r" (0), "r" (TEST_DATA), "r" (guest_test_memory));
>                                 ^
>    tools/testing/selftests/kvm/aarch64/page_fault_test.c:119:15: note:
>      use constraint modifier "w"
>                         "casal %0, %1, [%2]\n"
>                                ^~
>                                %w0
> 
> Fixes: 35c581015712 ("KVM: selftests: aarch64: Add aarch64/page_fault_test")
> Cc: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/aarch64/page_fault_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

