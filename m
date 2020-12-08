Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D122D359C
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 22:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgLHVvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729323AbgLHVvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 16:51:19 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D365DC061793
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:50:38 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id q25so184728otn.10
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w89jvt9xEQkyHcX0w1o44P7qbLiRNjqGfW4EIZv9AzA=;
        b=hq4rtzcxreLjWyZ1walMSdBn3yQrxk8T/ZZqpI8ju0LHX5+OXBAHOkJam6Zku8tf6R
         qe44C6uCIbTrlN/a09pmHwfYp4SWKsZn5q6zz6vDWujbfWYoPu4GxZwIU7iseWt2WZ9Y
         7/8MhpdzDhoafcbcQ6FR+41vhhrCPmprkloLb1LQt7Hb8q1qGBVhKryP42U1emCE0XHA
         fjbZaxkriphJizdr5RQTDxizuBuxflot9C7EeCb8OhJlQMMzirHpvr9taeXOtmc5l9f3
         5V4etpUcCarI9X+mWkvkcjvP74TG33zFwCPewSlisQG5zYDMJtHApcR96MuZZUJnkBp1
         yYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w89jvt9xEQkyHcX0w1o44P7qbLiRNjqGfW4EIZv9AzA=;
        b=JPmocYT+OwLpWYY7tr2ENPaYXoJWxMkBMvkWwGXk0lBHV3s6E4qrS3E6UMw54YQtex
         wOAiPPEk+CSzlERkyG/XnyN4WEq4+EROUJg+POIu6E18dSNJfBBpm7OwCeOhluRqvadO
         bhpclP7K7K6ugmbNUUZ4h2gvmqIpH2Q1s1uMk4aod6FnSHdMnGKweIq/I7KXcF+AoFEX
         +y4bEM1yzYvYL5kDUSGQMknKDkWMFWaKe48s69m48E16542BC3TWstIgmBjCh2LFPwkc
         MddmftKFqoUeVvyU3ezzaA9UP1xds4CGn43eTwTdRuP5Y2NpJrU/J6Q16YJ6/iP1rVDv
         W2fQ==
X-Gm-Message-State: AOAM532ZnZOeK2h16eCy0tQ4mJT6Z05EA/EHm0Uz82ZHbJWXuGxZ/9mr
        lzSdrhG+Ac9I3MKlq4wtHXpC5Q==
X-Google-Smtp-Source: ABdhPJyOzZZGjfZpGo/f3tX1nyI3xV4XB9a6mSy1TfhklLOwufw8hMUrUrmGNWkMr1b+clhHWEEGXg==
X-Received: by 2002:a9d:6f91:: with SMTP id h17mr120044otq.104.1607464238185;
        Tue, 08 Dec 2020 13:50:38 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id k30sm51888ool.34.2020.12.08.13.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:50:37 -0800 (PST)
Subject: Re: [PATCH 06/19] target/mips: Remove unused headers from kvm.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-7-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <8d161704-c46c-0ca8-357b-1a28b17dca49@linaro.org>
Date:   Tue, 8 Dec 2020 15:50:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-7-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/kvm.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
