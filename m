Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE67A799C0A
	for <lists+kvm@lfdr.de>; Sun, 10 Sep 2023 01:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345289AbjIIXbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Sep 2023 19:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244063AbjIIXbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Sep 2023 19:31:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176B41AC
        for <kvm@vger.kernel.org>; Sat,  9 Sep 2023 16:31:05 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1c34c9cc9b9so23478565ad.3
        for <kvm@vger.kernel.org>; Sat, 09 Sep 2023 16:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694302264; x=1694907064; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y/yt21vhMu/DJnZjeTWd6kEQk4GssF9C0RgKhht8a+k=;
        b=itqnuRrIFAFuZyfIgury8S3ea1rgeH7wEE43eBNaoW5J/Dm+0YhmsECV8NAz9MVYNB
         z0sWHjzT7xdjCj3clyYlxQmZ91v8nDwyRVXXGN5teSPW/UGUf6S9m1dFKRuFC9mXtJ+b
         FeHQqkGaxEmoOxCSrywf7FaQC+bYOiatQmfqRSkEKMhUad8EXfRfb6Qo+5lmXrd52vNr
         VIHsdqpap8mCNQQx0kh5j2+khklQO1y9ir7UTzjRNfBXPIsfaF0RAXxQIEKfYpE3fo+5
         mnD8SNt4yMC2gOCKrp8rylrPRgpw0mIHtdSZl5rkgO53oTWD3sKXtrtroBC05OZkcaUN
         IZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694302264; x=1694907064;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/yt21vhMu/DJnZjeTWd6kEQk4GssF9C0RgKhht8a+k=;
        b=vPEXxOyPGEWYfbDjDyE7zzw9ERQGpENJ93kwazZQb5Knm/qabB2OF64pW5du1JRCzw
         O+5nxUUhboXhlK8gXUVyWLSK30xhFWTUjym3rRd2y59zWPCjLjeBBaERfj1TeKX2PKwr
         OxXWaxg9EmyfIwT+Vbvynety4ZMN3zawRg4a/1BDdp4HlGwHzY0gy9KDYYCJysM1uIz8
         RhTzSkwM9XGJpeQpeoA/MOAQXKhLv/kuu43vsoHNT5UtTulGwX6EJ7oH16VeTTCC/WbU
         WWVPswMrsmZLtR/mzBGlSYFxAhnRWDnHh/VGk+8FyKmlqJNCyuZ9V4afLaEXwKkyMEBF
         4DWA==
X-Gm-Message-State: AOJu0YyYEOSQ+6eQdywQMztCQZJ90JqmmS14BeWXgWFYviUGADWlTzMJ
        eRYa1oR4mGdLqRUcv+21nyChaA==
X-Google-Smtp-Source: AGHT+IH20ght8SsJh1rMsaqufBnplJXf1kawXu9G/RcKF75dGqP+GokGAvO9346SyegKYq594HMz4Q==
X-Received: by 2002:a17:903:41cd:b0:1c0:c174:3695 with SMTP id u13-20020a17090341cd00b001c0c1743695mr7001607ple.13.1694302264403;
        Sat, 09 Sep 2023 16:31:04 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.131.115])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902778c00b001bc6536051bsm3731037pll.184.2023.09.09.16.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Sep 2023 16:31:04 -0700 (PDT)
Message-ID: <fb1249b1-c365-b859-9201-dc6cab2e93fb@linaro.org>
Date:   Sat, 9 Sep 2023 16:31:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 02/13] hw/i386/pc: Include missing 'cpu.h' header
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>
References: <20230904124325.79040-1-philmd@linaro.org>
 <20230904124325.79040-3-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230904124325.79040-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 05:43, Philippe Mathieu-Daudé wrote:
> Both pc_piix.c and pc_q35.c files use CPU_VERSION_LEGACY
> which is defined in "target/i386/cpu.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/i386/pc_piix.c | 1 +
>   hw/i386/pc_q35.c  | 1 +
>   2 files changed, 2 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
