Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81542799C11
	for <lists+kvm@lfdr.de>; Sun, 10 Sep 2023 01:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbjIIXcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Sep 2023 19:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345360AbjIIXcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Sep 2023 19:32:45 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1181B5
        for <kvm@vger.kernel.org>; Sat,  9 Sep 2023 16:32:41 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-3a88ef953adso2502283b6e.0
        for <kvm@vger.kernel.org>; Sat, 09 Sep 2023 16:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694302360; x=1694907160; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hklIEyvEMdt+6pjJnj9lvNqIg+adlSoBHDezk3jIHmw=;
        b=ltELDrPo6NzugHCDpce7G2QID6xVbd7j6jrqXO20IDvXse/ZVpH8gFx7BNF56zw4jr
         lhmjApIc0SbBjG07Lxw3TkiGCUiZXLA49fHQq6ymBse8umRfJWG6ToOmOeZLJBBShPMi
         l/NdHUhxOahXYMoPjgXJnGUxO5oo0fEgktvsL0NjWodylXgHWgWkF2HZiw2V84dJcvL4
         JgrV3Xf5bgJFl/CI4yUZl/JZexV8wI06OfHZX/6t7s1Up5mXekJrwZuuk8d8/fD28z4d
         KbUSxZCyqZMG7mjbEm1cE3Y2ErbvQYvPVFDY58lwJHHXV3/DRi/RcWeNrc4PTZVFEdXO
         CMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694302360; x=1694907160;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hklIEyvEMdt+6pjJnj9lvNqIg+adlSoBHDezk3jIHmw=;
        b=OsyfkJUvX0e+rjK1RNCK5fb9muHFF6cU1YQFeFuRwvJ7awsq1JL7Gy7ayysri6QrQM
         GG93gsrxdWObk1sBdDaxSFoCgJE23yhP14YSOnHx1c3EXFYSp2b26cBy4f2kVVb17+0R
         nREpzEHaY78S4uDHvB/mlwSwpXR98GjKKFDZjRF9/yatpenQ5J3UkDNP0YX3z78ct6Gc
         Godbytiq0GH4c7e+3C/5ZtNAJiTmmuZFxhgBGssE7SSQF2FVAgwG1jL0zAJ4zIlpQ6nw
         S+VNAaFfMFXn8xW6+GtuLxXTFhgv8WZL6RcHH2I0y8vpnbGBdKCKhHqhJnhXvwE2Xq+G
         yXiQ==
X-Gm-Message-State: AOJu0YyxT+1g9fQsRjElZAxUSXBRpcxC9s+nJIuUZE55FaIN8F/CgqG+
        A5v+zA3AWz1YX8xbbkoRm+bYGQ==
X-Google-Smtp-Source: AGHT+IEhY4vwQ1atyyj0XqtBPn+kj5StFrNDxnfRNmIcOgAF9OvXbsYdqUVk6Y4yShd2rU6YvRkuCA==
X-Received: by 2002:a05:6870:82a4:b0:1bb:5480:4bc with SMTP id q36-20020a05687082a400b001bb548004bcmr6753473oae.37.1694302360231;
        Sat, 09 Sep 2023 16:32:40 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.131.115])
        by smtp.gmail.com with ESMTPSA id iz2-20020a170902ef8200b001bd99fd1114sm3728700plb.288.2023.09.09.16.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Sep 2023 16:32:39 -0700 (PDT)
Message-ID: <caa52ece-dacc-782e-015f-f27238482fbf@linaro.org>
Date:   Sat, 9 Sep 2023 16:32:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 05/13] target/i386/cpu-sysemu: Inline kvm_apic_in_kernel()
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
References: <20230904124325.79040-1-philmd@linaro.org>
 <20230904124325.79040-6-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230904124325.79040-6-philmd@linaro.org>
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
> In order to have cpu-sysemu.c become accelerator-agnostic,
> inline kvm_apic_in_kernel() -- which is a simple wrapper
> to kvm_irqchip_in_kernel() -- and use the generic "sysemu/kvm.h"
> header.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/i386/kvm/kvm_i386.h | 2 --
>   target/i386/cpu-sysemu.c   | 4 ++--
>   2 files changed, 2 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
