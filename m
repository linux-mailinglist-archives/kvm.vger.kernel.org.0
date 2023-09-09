Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9711E799C07
	for <lists+kvm@lfdr.de>; Sun, 10 Sep 2023 01:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345271AbjIIX3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Sep 2023 19:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345126AbjIIX3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Sep 2023 19:29:46 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D70C19F
        for <kvm@vger.kernel.org>; Sat,  9 Sep 2023 16:29:42 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1c336f3f449so28023415ad.3
        for <kvm@vger.kernel.org>; Sat, 09 Sep 2023 16:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694302181; x=1694906981; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8hpk6Vv6gEk/esh7ofxD7YQWCy3eBDdkfxemfWNFEbQ=;
        b=MDNAjG1i9j0JabfS/jc6OJN8GHQyin9MZFKjfBdOzATY+BsNxB6gxqmZ9pJ0RDXll1
         6ksZutIlV9J/BeQQM+17oLCRl5dmOlLmxYakiOt9js/bej1OBCm9YaqWxx9vbSFqYo3y
         Nfw0hVqlNiFr/ZKahS/dzw7LBZ1OIhRGpjXbjd3l5uADI5BBT1pVXj+RxtGHROnVsRLM
         4XaxpUBcrc7waws2FCXvrx/DE3Ha9YoKOgusZduuf19egQclPhMV+HmNpPC6ocvPkmIh
         4xIBmuQrersnS2yYlblrwH7PkwlqfPIXmvIbgtNPy+IlaXKwMWHW4aN6tcJVodY4wF8Q
         0Yqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694302181; x=1694906981;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8hpk6Vv6gEk/esh7ofxD7YQWCy3eBDdkfxemfWNFEbQ=;
        b=HNrx2DUCzGGi4egmmytTLhdjcXf0Q5eGf8aYnGGIcz3ht3xWXnH3I8/dIjcsFFc8o3
         3RashkzzJQrzELjmoZWPo+L7LnQht8Ckj9grbkrviu5IUWW+iOuRAtmZ5SrF7oD1RwXs
         mMsUFmsmfXuXO0+7De+yyHZ3HrnM0hfvoIcNHCy8PmzgZr8F86Z5eE3e8RETThBu2W5J
         XxQCn43iG5XvgtwRtEPoe4433Yd1/nk2kHx1RHpOS5frvSMnUKPtSY4VhlMg8s/UAA26
         9HszgUbMT1cbplisTtYp4bp8IdpkUUvU9kMf/HA3+94Fw/OUI/pQNXCDE93L5LFpOBXu
         msNg==
X-Gm-Message-State: AOJu0YwtTRrIq9bRWE6+eHJsEHAYKO0J5qmds4T2MK+fvq/o4vJGusbC
        tlMsqXGgv7u7rCDpg5bCJU6ZIA==
X-Google-Smtp-Source: AGHT+IE+CzCL2tKNeddi4iNPtB2WSxGo9DCRACwneV514HJXWis5oBWL3EUep7gudA6Hoocv3EYWOg==
X-Received: by 2002:a17:902:c081:b0:1bc:422a:b9fd with SMTP id j1-20020a170902c08100b001bc422ab9fdmr6744555pld.13.1694302180899;
        Sat, 09 Sep 2023 16:29:40 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.131.115])
        by smtp.gmail.com with ESMTPSA id d11-20020a170903230b00b001bb99ea5d02sm3744234plh.4.2023.09.09.16.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Sep 2023 16:29:40 -0700 (PDT)
Message-ID: <b89e3e47-f4a5-735f-010b-6cd6e333e032@linaro.org>
Date:   Sat, 9 Sep 2023 16:29:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 01/13] hw/i386/pc: Include missing 'sysemu/tcg.h' header
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>
References: <20230904124325.79040-1-philmd@linaro.org>
 <20230904124325.79040-2-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230904124325.79040-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 05:43, Philippe Mathieu-Daudé wrote:
> Since commit 6f529b7534 ("target/i386: move FERR handling
> to target/i386") pc_q35_init() calls tcg_enabled() which
> is declared in "sysemu/tcg.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/i386/pc_q35.c | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
