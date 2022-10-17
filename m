Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27A8601A4F
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 22:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiJQUbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 16:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiJQUaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 16:30:46 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED17B75CD0
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:27:52 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id e18so9408524wmq.3
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 13:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jee5xT/EbIpj8zhUcGkaQNaDYXtiHF+Gr32UNKB5FwY=;
        b=dwz6lIdYbrjvZM5oFp3vrUl6kps0z9vWWwePBaTB+aDUjB7JK7VH3f6r52qEY+S72e
         Xmkse56HzsT336u3PHmC4ONwmO+pCZU22xi+6FwCpOCjmO3p130J4QRorjEFmAanLLpi
         AhJNT0DG1Wy9iuEYE5F9kuO4tjTij8VMkvFH91LFt2XiGiaRQCAhHqxXg8Z7LgfGlSLz
         fSl0omG71v29cAivfgDwvOARC65kRdnAx6A6PNaq8kZjn+wnf0DJbO0rbFeedz1AzFFb
         WDbmWTQZ6gjTAEX44LZbh+O4TYT39VkdTAQd7vCwi47eFbKdC4E5uuWXg3TRKeH6keDk
         uLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jee5xT/EbIpj8zhUcGkaQNaDYXtiHF+Gr32UNKB5FwY=;
        b=S8Ls5brJWUFBYah+JgI31pI0ufgDtJ8ybz38odyHochiDduft1nCDccREKkrEXIHDf
         +RqNg/6IRGWbwuhk8nni/2RNJ+WxtcgjX2/iwy1BtkmIuHu6KtPW5oEgefK8haSGgD6B
         nCrKGoUcY9049WOfal+3GwCxyqEweX2QEYi53GN720Aa3V3RLneSXoV5NjYG6E54k/Wr
         4tpeJMilZz9fyLWb5ZXLU4HPQ/3ArjIZhNRrG47dTJRnqZFhKnxSuSzC50gy3/VVg2Gw
         5TKlQEhDX5SMxzTid196P4DvKXiYuaY1fLm85f9+1WAXCWq+QtP5RvYtra9nLFmdfB4+
         +DSw==
X-Gm-Message-State: ACrzQf38+U+9y5dlCC3kNnvc+U4DiixCsVpzp+qk7Vf66cLiiDVFBQ9B
        QEPuNpzSr6hYPzCfG1XBAcURhw==
X-Google-Smtp-Source: AMsMyM4kLOVDIjrvsg0+K4Qqr9feEXAFShXtdhEF1u2/AMVlJREkPwYkiJZmoEr23KoivW+580TlgQ==
X-Received: by 2002:a05:600c:5127:b0:3c6:47ff:5d33 with SMTP id o39-20020a05600c512700b003c647ff5d33mr9249484wms.68.1666038377313;
        Mon, 17 Oct 2022 13:26:17 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c35d000b003a84375d0d1sm18144979wmq.44.2022.10.17.13.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 13:26:16 -0700 (PDT)
Message-ID: <905d1ff0-f039-85ef-f998-051c6879ad6e@linaro.org>
Date:   Mon, 17 Oct 2022 22:26:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 15/25] KVM: arm64: Initialise hypervisor copies of host
 symbols unconditionally
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
 <20221017115209.2099-16-will@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221017115209.2099-16-will@kernel.org>
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
> The nVHE object at EL2 maintains its own copies of some host variables
> so that, when pKVM is enabled, the host cannot directly modify the
> hypervisor state. When running in normal nVHE mode, however, these
> variables are still mirrored at EL2 but are not initialised.
> 
> Initialise the hypervisor symbols from the host copies regardless of
> pKVM, ensuring that any reference to this data at EL2 with normal nVHE
> will return a sensibly initialised value.
> 
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/arm.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
