Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BE164B29C
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 10:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiLMJqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 04:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbiLMJqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 04:46:23 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04FA165B0
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 01:46:22 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h7so14995180wrs.6
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 01:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6HCpfsDxKsbRWDniMvTsAcm6k9bqzut02W2Q+dej5cA=;
        b=Ex6palua+CAb8sAnNRSs8QCJJYJy/CXh6vu8iuxELmuLYIDrF2/RExi4CYvGIwjJVb
         0Hw8S/7m4UBgKH+bGVe+zuk8w2F7mFhNNeHeX6LVfeyQY5x3cnou27cfkigKZrENvKBz
         LX8clCm2xYOgwgxlVTiZEEtbOr3jJ1dLVrGoE6s3UPIvxdMR9U2X4lxGEf6qw9kIOdYD
         K+ksfEaTBuwkypOmNmDFRZz5c/4gWAgs5j5mnkV4YFuQmGeJELWnGZ41hrzsIeZ+TXtt
         quGHmeCbmOcVfzAXWOBWrrgDYUWcXplwtQ/ZI6tst+MM7yleBo+Dyn7REujufWRh+W+H
         fTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6HCpfsDxKsbRWDniMvTsAcm6k9bqzut02W2Q+dej5cA=;
        b=wtm40VHF+48XwX/rMadNYG1ST8z/4bLP4neAPUFcc1Dzaecgz/Iz/wQdg26OeIAZ4U
         r8l8JD5q6GT1qo0RzUW9BXJAPfg12Y1u+7qVUv/24glyGl5zqkcCobQkEQaqaaBSr7uE
         3dhGAb97FnHxhY2peKeGYDzvLVnpYk8mYA6p9OCLVN30CdCoKRZ6QhRMhpcJP74fP5ui
         0BcRAVeacEnyNKfT8gsmPDT6mo6cmVECDWxQeQmhW2B9jVFpqPpA9JUPC7s5nwHBIIvu
         lJqDtOpTBsMMLx374+R41srnNuD4vTaj4RPCMAnE9dOtluA3vy8PPzo+4BvpUB7tihlX
         Vorg==
X-Gm-Message-State: ANoB5pnokkEO3Tlh4kvNuNkxtgvL1q+tE6Znz1F6btRzvKREQDiVX17Q
        josoXs8zvUJIEMM7a1vr1VnRBQ==
X-Google-Smtp-Source: AA0mqf62OayQR32aHZW7SQ2L2Smz6e0kOzvNE3xqgzO1KHXWbyXt8wEW/lnneYLd3l0I3gIKF9q7mQ==
X-Received: by 2002:a5d:5a19:0:b0:242:8177:6291 with SMTP id bq25-20020a5d5a19000000b0024281776291mr15276191wrb.1.1670924781185;
        Tue, 13 Dec 2022 01:46:21 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id j13-20020a5d618d000000b002422816aa25sm12963005wru.108.2022.12.13.01.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 01:46:20 -0800 (PST)
Message-ID: <84c81594-0106-536c-5e04-1afb24953727@linaro.org>
Date:   Tue, 13 Dec 2022 10:46:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 03/14] KVM: selftests: Fix divide-by-zero bug in
 memslot_perf_test
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
 <20221213001653.3852042-4-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221213001653.3852042-4-seanjc@google.com>
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
> Check that the number of pages per slot is non-zero in get_max_slots()
> prior to computing the remaining number of pages.  clang generates code
> that uses an actual DIV for calculating the remaining, which causes a #DE
> if the total number of pages is less than the number of slots.
> 
>    traps: memslot_perf_te[97611] trap divide error ip:4030c4 sp:7ffd18ae58f0
>           error:0 in memslot_perf_test[401000+cb000]
> 
> Fixes: a69170c65acd ("KVM: selftests: memslot_perf_test: Report optimal memory slots")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/memslot_perf_test.c | 3 +++
>   1 file changed, 3 insertions(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


