Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D112DAE81
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgLOOFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgLOOFn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:05:43 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ABFC06179C
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:05:03 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id l200so23362996oig.9
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y8yeH+jXTaCBkTJCCU64nYwn4M9wbUN+h4XkjE75t68=;
        b=z2l/6Q1ykrxv+vhtgXHmivqkSSNnGhAdmTlm+JbE4JLmuT039umrkGp4wsLXoTwaV+
         v+s1beDk+OvQz8BoY5qK1MiYQdOtyzkQ+FxqegeH/hkbWA/VTTCu6fMrGkvj1J4EAGfG
         YF4c+LG6wcsH1zsflfEFdvZ0Ycuwfp1DPRs88TKIzE1aptebiTAVreY4H97yVuSDjRwM
         JgePdu/zRYeP3jYItCp8A5hYQ7WHibtQnXXZpjZuYkRX9vqo4TdH15S3Tx7wf8IiF3fm
         V/JiPrNIARypqPI1KKQRUbPRYMAlR4rDD6LjkoNGNqcVY6K3VMgS0zF02J42lgPxvBpu
         bC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y8yeH+jXTaCBkTJCCU64nYwn4M9wbUN+h4XkjE75t68=;
        b=ftr/6ZmodSiN4ozKX4dT0kMOaxxbs7c3wVa8BV5utBDLS3DzrUd8KAl7jfPfbbrz2N
         NVhPc/EDnUZ2u2CGD51GZnBouOcYfab2sU2COi3nP+yietQmi6k9VqKzsWwvg3a8rbdn
         Fn/jbGiHiUJmT3ghISkwyiLWF6RXGACbMepGyYiZIjEIVvOhIr96Ss/4bIVwKGRhnOqI
         Prz/HTbuYfPOVa2U+xalvY71/URYD9TeJRtQhEQR3Q4rt1pChOVhEPIg+ww95x8MILRg
         kVkBytRDCCaBramuELj95veCIo8LcIVmqT8Gy5Iyk3DzDrD40Bqtky2q5Wso3S2lWt6k
         5fpQ==
X-Gm-Message-State: AOAM532qK3lBsWHfKDMbmtVp4c+4I0Al514IA4+tAIzZ1eZjGl//4DUg
        eB7q0k3yXLs4RfGyoFEK1xGwvh/jgEpvqyEK
X-Google-Smtp-Source: ABdhPJxO29/jJJrxT8BZXutVSPPof3IMB5h1SnATOv+AQ+1Wkh1XB59/KBe1oWS2sqFaiT3su89XDQ==
X-Received: by 2002:aca:2418:: with SMTP id n24mr20543063oic.62.1608041102840;
        Tue, 15 Dec 2020 06:05:02 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id o17sm427518otp.30.2020.12.15.06.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:05:02 -0800 (PST)
Subject: Re: [PATCH v2 01/16] target/mips: Inline cpu_state_reset() in
 mips_cpu_reset()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-2-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <2d0dc83d-19a7-b64a-f0ee-99192a2bb051@linaro.org>
Date:   Tue, 15 Dec 2020 08:04:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214183739.500368-2-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/cpu.c | 26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
