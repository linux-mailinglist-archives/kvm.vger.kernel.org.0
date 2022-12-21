Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2705B653100
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 13:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiLUMmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 07:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbiLUMmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 07:42:46 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302B722BD0
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 04:42:45 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id i7so14775994wrv.8
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 04:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DSLylZIbhPn05wu8CDALl3Z3fJcAly6SHUFJHgsXGrs=;
        b=LzvDugLQaIwTLYXaDT+5Jvrzjg9m2kdlUGl1QDJ+rfQzDa7nXYqy99vKvgqeA2JGlS
         LhyA0yPyCv0AYJ05RHB91ODXPB4DTkCDZv5BqL+J0WahLMO4Z64jloTSxgOuMB4F90Dy
         J4xNYiDGgeEXP0ChmfkGhYuBJNcSFJh6naVM0ljVFsCBsCD8eBDmTy/W8p2mt1Utw5o1
         nbX4QkVzplAgdHmMY/1BdKAFUeHR9vxlbXSO7yiapI/VMAg0z9FG676XaQbYa5jh9iO/
         RG5BZ9X7Sx2wcMmAkRB3mV7mF6ehUlUzFMCX14+5n9HuoF5roPWE2wJz/vp8vh2XF2De
         2WKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DSLylZIbhPn05wu8CDALl3Z3fJcAly6SHUFJHgsXGrs=;
        b=BY9dqm8vRqQEVwz73yrbjk6PN8LZ0AqlUIPqX7WqboTSdQYqf2W0EyEDlBlFRqQH3a
         ZH+eZD66sRGp5HDqCBYph1UT1Hh3ZdUIhip85ebhkHyaBR4Fv5WHZQBPSgRrI7/MCNtL
         KmP27KPNwl8uCj1auQ7tBJece/7qyYuOHqnKMSA/FcCqRtCmg6BCwSKO1jrInqw3JDTt
         4cPxwWx12lQuUOpzBgl4B1RxL8PqxljycO2sRhksh8dFLaAA3SdCJVy5RaHjY34pHag0
         WYnfelrk34EoXjqsz2imC+tLgEy4uaIPwHv2HlGD/Gvx9vjAPEIFs1kuOSE/7r2bl1x7
         CVtw==
X-Gm-Message-State: AFqh2kohYQA7v3yqzNWdjTdbEa2B5O6Xc0Z/CvlNjfSdnU9AyMl39078
        rV7L1quYbvkX4jcCoPl1orlnNA==
X-Google-Smtp-Source: AMrXdXvAwq0kZbr8y7PdhQPvUSbhNwbFRqI3/IRineNTiDM/q+gWpzQQeO/jrJd+rt7jYClFf2JcaQ==
X-Received: by 2002:a05:6000:1082:b0:242:7d27:594c with SMTP id y2-20020a056000108200b002427d27594cmr1148574wrw.54.1671626563739;
        Wed, 21 Dec 2022 04:42:43 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id w16-20020adfee50000000b002420dba6447sm15053779wro.59.2022.12.21.04.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 04:42:43 -0800 (PST)
Message-ID: <486e9c9a-8979-046e-36c4-182eb3667476@linaro.org>
Date:   Wed, 21 Dec 2022 13:42:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH 3/3] of: overlay: Fix trivial typo
Content-Language: en-US
To:     Ricardo Ribalda <ribalda@chromium.org>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org
References: <20221220-permited-v1-0-52ea9857fa61@chromium.org>
 <20221220-permited-v1-3-52ea9857fa61@chromium.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221220-permited-v1-3-52ea9857fa61@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/12/22 23:20, Ricardo Ribalda wrote:
> Permitted is spelled with two t.
> 
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>   drivers/of/overlay.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


