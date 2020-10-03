Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF67282353
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJCJsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 05:48:54 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516FDC0613E7
        for <kvm@vger.kernel.org>; Sat,  3 Oct 2020 02:48:53 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id m25so993129oou.0
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 02:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=reROD41lJiup6iZYSsuhFcjvbHAZP6Y8+IJM5pW4HeI=;
        b=sWdNuZoNp/SGC8O1o+gdEy3C5k23urEB1dAKsYNbDtYqBpmPE91qz4352lpPe14wGo
         Mjghe/3N7DZNefvUhoz4cGX092xo/HznXvL4fFclS1lB1/w1cIcyhQiCDbTcaBV4LN3R
         8JifkpLVgsGxtSvvCXK0J2h/7PWBL6nFzXnbBsbMT+So/no43D5TxYvFEGem6dDZr1Ut
         g+odFZH9QmiZiY/bgy1dXj/qXnIxY4BN1vZMnfU6ofwZDImCTr0XXN/JSrkO0NzFWwiC
         o2E5+E4aE57ASi0R094qVKCjKmichdgnY7+JPa8fU7Aj4l5JsrOzO12nkidNE5vOUXOM
         V3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=reROD41lJiup6iZYSsuhFcjvbHAZP6Y8+IJM5pW4HeI=;
        b=ehdbmcZI/dnkrKUTWE6wEPDr3u15dNN+cj5zaX82FWE8BtMQKlugo4DPn8mzU/rTeP
         1NvDRslstjFoiWmnoIElmvofqlYPaZOPYjyiy47SWIc67aaFAgTynNOdDGBDcob0cElU
         6bnHPdVgZAM0GVT4o+y3hq3slGX10qQM8H7jiO2Znp4tGQwgUZgg8VTDzmTs4w2HIePe
         muKyApMWt+8sUXCJ1BeVqOE++cXbfvh/KIOBhjlehbMz8PNu6Ns0uxtSx+oMoY66ulyJ
         UQvIWXu9wUzORPK44AXzYET4Y/xUDnJXMn8Ba/u4O6ic/+6obfEqUUJES2D77QCEUXV+
         ZgiQ==
X-Gm-Message-State: AOAM531rToQ/cH5H94gSuQd8ZC9X3f4eoVBJas0FFsRRggrjocAgJM5z
        uUulzBfpiAQ8/D4KAPVtjKmKoA==
X-Google-Smtp-Source: ABdhPJx4UssWIUrC+FErQ3GDoZmOAg3dnXteUU8ca3qiO7110tjet5RiqpvMFtfazMzjUfQyFVWR6w==
X-Received: by 2002:a4a:c541:: with SMTP id j1mr5129157ooq.13.1601718532719;
        Sat, 03 Oct 2020 02:48:52 -0700 (PDT)
Received: from [10.10.73.179] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id m6sm1077388otm.76.2020.10.03.02.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 02:48:52 -0700 (PDT)
Subject: Re: [PATCH v4 09/12] target/arm: Make m_helper.c optional via
 CONFIG_ARM_V7M
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-10-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <d9af8896-efec-c850-655e-1d1eb2629762@linaro.org>
Date:   Sat, 3 Oct 2020 04:48:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-10-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
> +arm_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('m_helper.c'), if_false: files('m_helper-stub.c'))
> +
>  arm_ss.add(zlib)
>  
>  arm_ss.add(when: 'CONFIG_TCG', if_true: files('arm-semi.c'))
> +arm_ss.add(when: 'CONFIG_TCG', if_false: files('m_helper-stub.c'))

I'm a bit surprised about adding the file twice.
Since ARM_V7M depends on TCG, isn't the second line redundant?


r~
