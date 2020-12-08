Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF88C2D35A0
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 22:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgLHVwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgLHVwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 16:52:12 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C59BC0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:51:32 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id a109so241713otc.1
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AcB7iPZH/6gryYNKiOK9LRk4ALwhtVZ0H0FlNoQ7ZeM=;
        b=KKXYPzgWdCnzpXrMlF0qNwOlBtZ80Lwvr1FLdadhrZ3zw1T06gxyPoQUgtPfQHGFKU
         gr3OWw5YDnqmK+/IcPsY//PFz1oLHgyIqPaq8Bz5GrA6Uj3pUyuazUzc/fcHmdWRxlP7
         AgPhTVevF+ST5iI/WZFAy8q3Wq4OW9uTtLbglpYofILXu04qGN5ViEurZBq5JjSCksHZ
         y557HsxE5UQTD7dTy3iFsJzW2s4VJ18M46sUBWRaWo3kQQuO+vmvKh3v7IGG9ScwmgZj
         XYzYDKzyh9zayLi9XPD70hAPXgP/4SFIMB6EdADRAuUHNHAMgpx/j7VnVMnFg+Vhswbt
         QBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AcB7iPZH/6gryYNKiOK9LRk4ALwhtVZ0H0FlNoQ7ZeM=;
        b=kTYArJ4EHyI5P7eBZg7r9aTjrdnpWpimLaeoDYWr+oulfGQBVi0MEO6rX9RTVmJxfR
         Ege/5DOETGlX82LG+M03Ofd8dqI/UeEgg9UCO+eg6m8Yu6sNSKsaslXEXpLmggLDdp8b
         pnrBt5i2HmaBWEW8p5ueIl54b8F66KQPzc/wkoka+h1hpAw9/Qd8VeB45vdI4GLv4RGg
         tiSTpsP4gsDU6xKOIm1fhmjkeBsjETowuyTdZxk1s4TEHdESTEPbspe8Rivk6iKBlMNt
         PfK9KsPSJhWjaEkEKJ1IjxrzyPAdY6NYSu0K3MKtiAu7qUc2+LBGLjuWbilmLGfV2T++
         /JhQ==
X-Gm-Message-State: AOAM531Q+XGXDF6E0qe+2CvXc41irn2Ze0XgyI1Qn2ChijA5r2YE9D4y
        35tdrUKfVeFnioW4T5H9MyTilw==
X-Google-Smtp-Source: ABdhPJw0iO65IFT6OUZQO2aiSQQcVDqIgAXdoz+mis7CW4sQQA1tfICMbjhUCuMC/BvCcx8xe1hrJw==
X-Received: by 2002:a9d:6317:: with SMTP id q23mr74231otk.251.1607464292083;
        Tue, 08 Dec 2020 13:51:32 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id k63sm13525oia.14.2020.12.08.13.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:51:31 -0800 (PST)
Subject: Re: [PATCH 07/19] target/mips: Include "exec/memattrs.h" in
 'internal.h'
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-8-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <62ff83ec-fdc4-61dc-6309-c68e3efda2db@linaro.org>
Date:   Tue, 8 Dec 2020 15:51:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-8-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> mips_cpu_do_transaction_failed() requires MemTxAttrs
> and MemTxResult declarations.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/internal.h | 1 +
>  target/mips/kvm.c      | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
