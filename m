Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6B573FC1E
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 14:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjF0Mnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 08:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjF0Mnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 08:43:32 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC5326AE
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 05:43:31 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-9920a6a6cb0so111921166b.3
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 05:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687869809; x=1690461809;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1mTG0cvKU+zMeoqHlEai9X0XN4bdRY0Fj+S2ZVFglsw=;
        b=JGscvSjGoIt5zVRLMj+z4pQB3/0FtPmXup22DqGc0zhhp0riN4aIMg20E/BBLW2E98
         WdgKEMXAsf/vjSlW+0rzfMzh92/bntJIhsUWrs+pYQ2RCqNBJn7CruxkEX4Num2CPpjq
         Cu1VAziumpAykPKlGGwPoVrLybX8oEiiXC+oMQ6cOOpJ6MspwTxN5xTynf2HfJc/4PuS
         agFOT6HJF3FjtKyGBOUzZ4+wnAxZAWbCIkMijKhC8/MTL7fmrPW4o1umQGjvwNPZj3qk
         Dv8C/gAh/xvAnE5RsFwiY2mA4XOXlcUBSuvjWJC3jAaqrWkQFNjoTjLU6ISTyg2Xge7U
         FZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687869809; x=1690461809;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1mTG0cvKU+zMeoqHlEai9X0XN4bdRY0Fj+S2ZVFglsw=;
        b=MMo7WQPlQHpoofL+r7WB1951FX6UkeThU64FGSKvgEIpkXNKbtTvhAtb7o+kw1WO+c
         mfKbbW5T96snzMg3HYU/5cD/tHTySNeY+aOEqhhaJd4zldK7LrKHqyq48M5Bp0U5lJr9
         GJp2xwEl1/+dbFcEE9WI3WNn4r33tavp6x0/HoKxH0zzF1QfG21q7w/IcG9qHKWD/H5A
         b5y9lwi5abkFR6wFhDlNYuAMV0TW1JB4UVJXWK2q2SlFdBJignnMj9IeC9OEaFWaksR2
         b9Kx0x3ADV9Gvqtj5NbpEvBA5HH8FjqCPCdH6i8o9B87gwGX18fVaToKS2dwoqVBHUPM
         uk6Q==
X-Gm-Message-State: AC+VfDx8j7i0GRcGwGd/GsRDtkIJVDc9ISFR7sOEhzRQILxXB2zTLXWv
        hfAd9Yu6PaENNU/ryYwl3fxAZA==
X-Google-Smtp-Source: ACHHUZ7fuT0GL83RVg8Gj86ErRvzE6j5P8CLlQ8jWsCVG81jwLRBBrRfpqNvsX0LXyM1vFUtszJWyg==
X-Received: by 2002:a17:907:a42c:b0:991:bf04:204f with SMTP id sg44-20020a170907a42c00b00991bf04204fmr5098434ejc.60.1687869809706;
        Tue, 27 Jun 2023 05:43:29 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.199.204])
        by smtp.gmail.com with ESMTPSA id k19-20020a1709061c1300b0098dd3981be9sm4477872ejg.224.2023.06.27.05.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 05:43:29 -0700 (PDT)
Message-ID: <7b6c659f-a9d3-c883-ff53-3226c8d31bb8@linaro.org>
Date:   Tue, 27 Jun 2023 14:43:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v3 16/16] accel: Rename HVF 'struct hvf_vcpu_state' ->
 AccelCPUState
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230624174121.11508-1-philmd@linaro.org>
 <20230624174121.11508-17-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230624174121.11508-17-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/6/23 19:41, Philippe Mathieu-Daudé wrote:
> We want all accelerators to share the same opaque pointer in
> CPUState.
> 
> Rename the 'hvf_vcpu_state' structure as 'AccelCPUState'.
> 
> Use the generic 'accel' field of CPUState instead of 'hvf'.
> 
> Replace g_malloc0() by g_new0() for readability.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
> Not even built on x86!

Per IRC chat:
Tested-by: Peter Maydell <peter.maydell@linaro.org>

> ---
>   include/hw/core/cpu.h       |   4 -
>   include/sysemu/hvf_int.h    |   2 +-
>   target/i386/hvf/vmx.h       |  22 ++--
>   accel/hvf/hvf-accel-ops.c   |  18 ++--
>   target/arm/hvf/hvf.c        | 108 +++++++++----------
>   target/i386/hvf/hvf.c       | 104 +++++++++---------
>   target/i386/hvf/x86.c       |  28 ++---
>   target/i386/hvf/x86_descr.c |  26 ++---
>   target/i386/hvf/x86_emu.c   |  62 +++++------
>   target/i386/hvf/x86_mmu.c   |   4 +-
>   target/i386/hvf/x86_task.c  |  10 +-
>   target/i386/hvf/x86hvf.c    | 208 ++++++++++++++++++------------------
>   12 files changed, 296 insertions(+), 300 deletions(-)

