Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956E72822E6
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbgJCJJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJCJJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 05:09:27 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED44C0613D0
        for <kvm@vger.kernel.org>; Sat,  3 Oct 2020 02:09:25 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m13so3795395otl.9
        for <kvm@vger.kernel.org>; Sat, 03 Oct 2020 02:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HYSCtcMUH1CnN1lWiP4pycuNjmBqf/V7CmBzZsvjo70=;
        b=zen9iB1yMPujq97iQd0rcqeRg2ftw3ME8gIklBFi8p9ldwneLaDXCDPYRUIQTkjPmu
         34gpNg5WuzSZl9oqb4EqsMJpID7Y8kqBXJN3lH6S4KyBU2GMIlgl0TTl6E+UVa33u510
         3Rh14+w366lPClVPydalaCx8NxczYi4TvLeZD2vj3p3wCzFn7msZNBt/JVfVWh3nGC0n
         7+GGP4US3qXnRDgu9/Ti+7ZjPRKMQiE30/YT7a1k6v6ax+sUGyRg9yD6N68gbwO1wt1H
         Rt9BsMi2c3z3Q8NvcmfIH8x9WHxlS3gWDRK7Ni2ODGW31CZ6cw45ek/rpWWeBWhDhvBh
         lXAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HYSCtcMUH1CnN1lWiP4pycuNjmBqf/V7CmBzZsvjo70=;
        b=WD1hhYN5fyyRtfhpl8LupBcuNHKeR4u1K9ghkArs5+WBk9tNtGOAdVwAm6ys3PTYTP
         uuMLJwLyKLz1iTiWAmqPifD+q5/tp5H6xQF7kkYH0t+5HhqtAQLpRvv/rJliNuXBe27i
         kVcPIl/zhh2OxS255XJetD2m1EbVrICl6Y29WFk5RBtMFzLzgaiYxkMaFTh8wwLQI1mV
         PDha5Ao8tGT8CvUu7BAlqgwEGK001Uz7ax23mWMkjn4c0dm42YN2IW4qQz8XZAWuPdqM
         DZAlMgw7qn7bH8ikkcohRltoPzrNYrZBhWNIVlPFtew5d5f6dj4HILC0RL+DQ2BAprtF
         47gA==
X-Gm-Message-State: AOAM530mF2muldwpmIejGYCtSmqKWqutuVSZNCCdMxrf/p4YTU7lpbR7
        hu3U5wfKJ+dy7GSQnYu/xHNnyIdxot0xsmdY
X-Google-Smtp-Source: ABdhPJx4lrVJsgCJS8zeF1KPZ5f9Ry1mx0UpzDyt1+dQuj+wzFEHnqikKO7+ju8aX5ld/ijPH/aJeg==
X-Received: by 2002:a9d:53cc:: with SMTP id i12mr4536397oth.215.1601716164481;
        Sat, 03 Oct 2020 02:09:24 -0700 (PDT)
Received: from [10.10.73.179] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id v18sm1125780oof.41.2020.10.03.02.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 02:09:23 -0700 (PDT)
Subject: Re: [PATCH v4 01/12] accel/tcg: Add stub for cpu_loop_exit()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        Keith Packard <keithp@keithp.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
 <20200929224355.1224017-2-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <c4d714db-18d6-a789-b7f9-fe7e2c62b224@linaro.org>
Date:   Sat, 3 Oct 2020 04:09:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929224355.1224017-2-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/20 5:43 PM, Philippe Mathieu-Daudé wrote:
> Since the support of SYS_READC in commit 8de702cb67 the
> semihosting code is strongly depedent of the TCG accelerator
> via a call to cpu_loop_exit().
> 
> Ideally we would only build semihosting support when TCG
> is available, but unfortunately this is not trivial because
> semihosting is used by many targets in different configurations.
> For now add a simple stub to avoid link failure when building
> with --disable-tcg:
> 
>   hw/semihosting/console.c:160: undefined reference to `cpu_loop_exit'
> 
> Cc: Keith Packard <keithp@keithp.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  accel/stubs/tcg-stub.c | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
