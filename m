Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84D977744F
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbjHJJUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbjHJJU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:20:27 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF644685
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:18:18 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3fe1fc8768aso6153695e9.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691659093; x=1692263893;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MBdVHirNXgRmSuVF99QvdHBq0xUrRZDq/GlpbFzl0yA=;
        b=szSpctEef+yzg8vnVsIk+G7f4iPEkbBusXqJuwrqh9b03dTJymgcaOuMQUf7o5daai
         3mQJzk2eoV0p40LsbXT6ulnW6gh/xS2hRju4HEFszr62cXp7vL4m2C1l6ifBzQiXRQdk
         SSfpO1aKIHQhrzs6OsUFbwnMlqLMtKazH5OukZEeZuSrqkPuqNIU2c9kdZ74qutXy+6Y
         Mhr+elzS1ccBnnSmeiwc3SI34UN9eHNXnTP7qnvxgJ+eDbh9WIaneG5a4N0fCiiCfOTu
         BhUXH//U05ZkIC9oLyYkRqjZxa8T9FgESAAX0IjVN9mJbkPP5CVh9UgIfRZ3pXDmCYay
         EGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691659093; x=1692263893;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBdVHirNXgRmSuVF99QvdHBq0xUrRZDq/GlpbFzl0yA=;
        b=Z91kHL3AQAqgxa1MlGjUgxBK1CvaE+jmomUS9HZzZhLx0tyi5Vwh+HL7lNmd9Yl7sr
         BWnlPQbEKyh1Un/MTsgUpqHX3YaProvYfzfIYDGaSDbAkI9daaHgkmullCEioqiFf0WP
         py7Dmk9YfZhPXNR2QYhBvJGy0sAjFqlmdaapDcas9TAG3Y/8DcNH/8PZq/lDx7IUAgDe
         XzDkWLqAaIJzJWZE3LDm9V95vUDDoNNZp1WyZvtJE0PDTMIfOEvElBPhfOlRkJmRlQrd
         mY4PSH8Pc6MIC9oSFal7/k1kFMkd5v59Z3ZGJnyTIEx6jNQduJckb7PRzBEeQ/nj1rg0
         0KVA==
X-Gm-Message-State: AOJu0Yyxmt/ND+4HmU0JmxAZoeZv8fxFb54KAhEZWN3IvF84hPDbRq2b
        d5jfeoq8JYM8RiPHum0ZDSfNXRGSnm9Iy6HAZU4=
X-Google-Smtp-Source: AGHT+IFUctqjaHhL7Sxzl5O5+Ihcltgpb96DKiLbiut+qEN4QllxYZxYdpSpWwOt8OzRCc2oRm9d4w==
X-Received: by 2002:a1c:7714:0:b0:3fd:30cb:18bd with SMTP id t20-20020a1c7714000000b003fd30cb18bdmr1548286wmi.15.1691659093234;
        Thu, 10 Aug 2023 02:18:13 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.158.65])
        by smtp.gmail.com with ESMTPSA id z21-20020a1c4c15000000b003fbfef555d2sm4341476wmf.23.2023.08.10.02.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 02:18:12 -0700 (PDT)
Message-ID: <5ecc9d84-bf6a-22f5-fc06-996dc5bec334@linaro.org>
Date:   Thu, 10 Aug 2023 11:18:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v5 6/6] accel/kvm: Make kvm_dirty_ring_reaper_init() void
Content-Language: en-US
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230727073134.134102-1-akihiko.odaki@daynix.com>
 <20230727073134.134102-7-akihiko.odaki@daynix.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230727073134.134102-7-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/7/23 09:31, Akihiko Odaki wrote:
> The returned value was always zero and had no meaning.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   accel/kvm/kvm-all.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

