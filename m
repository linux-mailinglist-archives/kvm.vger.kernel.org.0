Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAB86F4B08
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 22:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjEBUL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 16:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjEBULV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 16:11:21 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FD71996
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 13:11:20 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f195b164c4so27279045e9.1
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 13:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683058279; x=1685650279;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G8W8uovREul2fjSz4ctWSs8on3qfCZtGwx3akPGfCho=;
        b=GhDde+IzRT/Iz2MyV4B6i/1fNEtgBuT+ASzKpunfyXCUY7EOpb1e7BqeFpzr1l1qbi
         tXt/SDokiQImuBpzan2H/qu8dLRELqmX3S9e+2Q83BikF4khnx2bAP84+mXYIwDBxHki
         MGhBaRWybXoSrd72i+4630ypP0itjKAc+XW0qLLQicybv2y08ZfHmXi7z1cS6+dmrAbj
         4kuidZOkYQjhrouK/wyNMFPUDbM9xpvLz/JtdTI8/1gU3JlABj6ALqepr2xCasPyYtmi
         pgJdP8fWRyuh03NF0AGxgkkaDap6nenu2eFV8rFgc7Omz9HExw+6O4IdqMlBUFolzshH
         sPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683058279; x=1685650279;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8W8uovREul2fjSz4ctWSs8on3qfCZtGwx3akPGfCho=;
        b=KMRWYpGrVY5DxxGmHboEYR9wvOEeh1twyPHBel3ADu+1kW40mNUAiCF/RyUSmE6FpO
         kEUGCXw1FqxDfUrEg0BlrAdkdhKc7nROo7687O5GKYVUhAgO/UvIc32TMG8UDSszO/XU
         2qKyxXzjWKfjv/c28Ey56R2YbZh2mc3dqtaBrLGrIzXHsokqkYUZN+KC92xEOzFYzu+E
         RUD/VRUsXDi2eTuXyoolnyQtJPnQlOt3s+4E4Se22ee6GV5nzS/AYdoAW51+WBs/ejp6
         fK3VVfxdIuGyruHEbrR16A3B2pNjygDWRpMIs+7vA9WQVVwe4Ijj8NRPr4Ybz0JWIwBf
         /cpw==
X-Gm-Message-State: AC+VfDyVYhfo6E4lx5/qRr+uKP5pcPRn9qvhlUSJ49e+nc5Wpe2mRbCh
        KogynIHJ90mHYVVaL12o4YfTwQ==
X-Google-Smtp-Source: ACHHUZ44PCy7E/XtvFkW3m5C1otW6y1vCSFg3OHlv31ZzM1H4SpQLbtJM5WZats+tadljGs04jmZvA==
X-Received: by 2002:a05:600c:2219:b0:3f3:1fa6:d2a8 with SMTP id z25-20020a05600c221900b003f31fa6d2a8mr11326218wml.25.1683058278803;
        Tue, 02 May 2023 13:11:18 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:5063:9fcd:f6cc:e52d? ([2a02:c7c:74db:8d00:5063:9fcd:f6cc:e52d])
        by smtp.gmail.com with ESMTPSA id o17-20020a5d4751000000b003063a92bbf5sm1769813wrs.70.2023.05.02.13.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 13:11:18 -0700 (PDT)
Message-ID: <80f6b30f-5d3f-5e43-5472-2108b89758aa@linaro.org>
Date:   Tue, 2 May 2023 21:11:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 08/19] qemu/bitops.h: Limit rotate amounts
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
 <20230428144757.57530-9-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230428144757.57530-9-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/23 15:47, Lawrence Hunter wrote:
>   static inline uint32_t ror32(uint32_t word, unsigned int shift)
>   {
> -    return (word >> shift) | (word << ((32 - shift) & 31));
> +    shift &= 31;
> +    return (word >> shift) | (word << (32 - shift));

This is incorrect, because if shift == 0, you are now performing (word << 32).

I agree with your original intent though, to mask and accept any rotation.
I've changed these like so:

-    return (word >> shift) | (word << ((32 - shift) & 31));
+    return (word >> (shift & 31)) | (word << (-shift & 31));

which also eliminates the useless subtract from word-size-before-mask.


r~
