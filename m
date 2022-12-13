Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5712364B2A5
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 10:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiLMJsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 04:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbiLMJsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 04:48:05 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF48B88
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 01:48:04 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id m14so14992139wrh.7
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 01:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9kjr0P8P3evTsHtv0kx5R0LLm1BjbVlP2JBqTHfgIEU=;
        b=wxREDceclsVP4jxePxvte5FDBoV8oOTQ+kk6QFnlyxJvqYJlw6q99Pp1nurNiEIDcM
         9/QhIdsqo/Mvmd0D1NOjeYmiTaUYd27+N8bXw7PgG1XVqeuHvL0gucTFuUCy0TiqiLnY
         cJGcXgCzKmAfB+NHUwBa04Ks9c6wflPCLOsAECG/QjplFaeuNUn2phsb6D3wu+2hEwsu
         84WblEtk36HvUMtvdeu9efTCSwNFLmaTDZ8ypqla1IRKx/eWU0SU7u2K0C26EvvPsz9i
         fQ3rQMJDeLJobD49zJBFgCw9BxJVhEqU4EgqX+/2ZBjH0vLq+9zvQwzpZ3qp6a0lyLlu
         Xprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kjr0P8P3evTsHtv0kx5R0LLm1BjbVlP2JBqTHfgIEU=;
        b=bKekfeMx04P8mpv4cQyoV5zdCDVrshjpz1fGV/EeMY5r0bl7fGjA46ZirQOlZWKUEb
         WVU+wSz/toNCOI/VGmzTThohhd6bN7tn2WlxIWYPI2FemB0seIFixxUAYKfKMf3qhTeU
         6V3kVrzhb0eMNuq5IwaY0l1er4YPMzLNq9fEfFw4Sr20YXLXKzfe78pfKmfACbQtdyWG
         mReQCmKdvmOEzoG2sFyvbHLxI9CyfkCNdFixfDk0NpEwVW2Ivm8pZ8RBtrs1r6rQc5XB
         9O7gD32+U0TmTX0YQoiOMlwlkIQfq8R2XqrWH2TIaOk8T9K1VrB5Idok/3Qo2wojXDPc
         JnYQ==
X-Gm-Message-State: ANoB5pnjBtWvphdBVryjqHAH1qU63WzPKTROdGG83QFgWBAlFI21LSHA
        1Fypvw3Sqz/QuJJNVoDQNosHWQ==
X-Google-Smtp-Source: AA0mqf7qf8gp5KDq16JqrUroPUpREMH1ONeNa3KMxmeoce64zNsGbHFkbza+M0tQPkVeVr4/pP6aWw==
X-Received: by 2002:a5d:490d:0:b0:242:fa5:ce83 with SMTP id x13-20020a5d490d000000b002420fa5ce83mr14631600wrq.37.1670924882743;
        Tue, 13 Dec 2022 01:48:02 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id f7-20020a5d5687000000b002365730eae8sm11005215wrv.55.2022.12.13.01.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 01:48:02 -0800 (PST)
Message-ID: <ba1760b7-3153-d761-d0aa-3bf321f2f682@linaro.org>
Date:   Tue, 13 Dec 2022 10:48:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 07/14] KVM: selftests: Use proper function prototypes in
 probing code
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
 <20221213001653.3852042-8-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221213001653.3852042-8-seanjc@google.com>
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
> Make the main() functions in the probing code proper prototypes so that
> compiling the probing code with more strict flags won't generate false
> negatives.
> 
>    <stdin>:1:5: error: function declaration isn’t a prototype [-Werror=strict-prototypes]
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/Makefile | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


