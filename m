Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7372B602D68
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 15:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiJRNv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 09:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiJRNv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 09:51:57 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BBE9D50F
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 06:51:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id iv17so10745777wmb.4
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 06:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ip4fB/O2dncy+wTIhlbp/UW+BPiXgCFv8LjkfDyNXyc=;
        b=uASQrGd8zGqIhI2gfu203qtfOZtr50VqLQ+dlG+Xezd9SxA/IDbDgEOtpsYz5YS33e
         JTS4YIpyPZ9UlaQK+MwpXOxCZP3vGjB5KrJA5EdXHA3OBUK0MzxFUh2+L301h9QKGTfF
         4oA9N8nnP8oV7zN9w/pp0Sa+bjghVyakTOndkVIhhM2X4i0xWgHhoAVPrUWoKg1BPUlN
         ajpH1yRDsv+WSC7g6YXHWGveEP0CHIbT/1UL4HXAzHumbiCygf/amoK2mA0NSpuVdpqc
         s8WTGMydarqKcWriHW+EmvvW5e0dQJX2jvfc861IREH31cqAlBgjfYOzs+YcW62aK1tZ
         ETTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ip4fB/O2dncy+wTIhlbp/UW+BPiXgCFv8LjkfDyNXyc=;
        b=593u9HJgbFSwikGY4Dundcgf7kaCDbhRHHUtPZMdJMqXSUbh3szvRQXFuOVz7PUFoD
         ZYWWMFANQvUfS62idoi6tfysSWGdbIUee1FxBOFMvhXkY6J8AYXy9C0WJfQ49ZaikE6Y
         xn9u45Tfo17RvEGaH2Bup7hZuH9gM0icKd1LImo6Lc1i7f+sjD4um97P1I9Ej5t7BY3s
         rQGypBeAd8yb+g5h4bxBYC8I8sVVSOBNgq/HIW6HshZFBv/XrF7F+uJRWXxyqPfR1hbw
         Vg1VZTLiZDosp6ihGGYf401KmsVIQEefplWusGnr6ZKQBGzacAF6gyl6mCj3y8vHqYRF
         +jIQ==
X-Gm-Message-State: ACrzQf13bGEjJkiClwaWTt/Gdl7RdecHwXu7EqYmZhY14OaYVLTC/eX2
        jjTeFiLBzzbfrIbf+cMTuZEORg==
X-Google-Smtp-Source: AMsMyM7E+2Q1pbpwQ+k40AFxl6lABOVhZzIlvO8nSbYJqDspKlNqDFpLxTGlIUCKWEhgyQFjnvZRyA==
X-Received: by 2002:a05:600c:4f54:b0:3c6:edec:2787 with SMTP id m20-20020a05600c4f5400b003c6edec2787mr2163528wmq.109.1666101112917;
        Tue, 18 Oct 2022 06:51:52 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id q19-20020a05600c2ed300b003b3365b38f9sm12995962wmn.10.2022.10.18.06.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 06:51:52 -0700 (PDT)
Message-ID: <a238f56e-b663-4109-1b5d-745b62c4f04e@linaro.org>
Date:   Tue, 18 Oct 2022 15:51:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 10/25] KVM: arm64: Add hyp_spinlock_t static
 initializer
Content-Language: en-US
To:     Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc:     Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-11-will@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-11-will@kernel.org>
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

On 17/10/22 13:51, Will Deacon wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Introduce a static initializer macro for 'hyp_spinlock_t' so that it is
> straightforward to instantiate global locks at EL2. This will be later
> utilised for locking the VM table in the hypervisor.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
