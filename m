Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4652F734D12
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjFSIG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjFSIGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:06:31 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62FBE73
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:06:29 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2b45b6adffbso38467541fa.3
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687161988; x=1689753988;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W2wJQibJMYx7IpRQW/5lysZzzgnwm9zZuo7OpJnNNPU=;
        b=hwd5W86NsK4CpRW4dqsg/zEoIigiZyhWFzzgaEO32Lwhqbhh8K7srQN5RtdpdMTqBP
         UzvsuIfvWQsx3usj4uV5AKBSsB7ABRtr+6XdvUG2rRXkhz/H0dh55RYvRNXB5CNVzVBK
         T+D5sGfPdVvLrIegwVL/TdbKksh3FP65KfMG3JYZAXcWrTAcYAzN+gmc9hbYQYfssuFn
         BkqH19Vs5mL2YQVt50cQ+LqtnOXUmpGTC4atqFSj6oZDL0a2et6VWjB5jYb8+ACS3LSu
         AkNYr5l9X2be80DxpOLV3lHTNLf/qCa2owg+MrdfYRMUQPU4sI5zH9vY/DiCYhVEc3AE
         Rc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687161988; x=1689753988;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W2wJQibJMYx7IpRQW/5lysZzzgnwm9zZuo7OpJnNNPU=;
        b=jTkgvkau98bk6xbgm/xtZRr7tjaF95BDG4dC1USe453eeAXFLjApPkxTfpIFcRNxqU
         dtA4jKslaxF8yNRaOnfwVInUAkhm123+QJaFPWz1YUxqD8yP4pbuu5GnBRir9kThnZIZ
         +g6I051qvGsKmDOD+zo/oAMwb4gBARZxGACB/nuFUm056dXr7drFXwyqK/4NTYOMZLZF
         zvgMYEbMcuL968tMVPIKIedylokDpKQC6i78/txeLI0zFDbvRIKpT/V0GOjLBo7rXfCL
         w6ymvErGNSQhopObZFVzmHkPbwajTJwyUnKrKtWnGT3p/RBx2dyvjk3MJzuJ2HYm74e6
         wSgw==
X-Gm-Message-State: AC+VfDygehc83aiwt2pblAn3HFS/kZq0VfVdVXevo7uW1HLnxUVIB68w
        mQfHiTmNbogYeyaz0Bt4yLcjgg==
X-Google-Smtp-Source: ACHHUZ71xlQKFkuaPhLU+XPgbCWRUxNJLkNIgPwtIN9LnnbGNp2KpMm+89TlVscS/Wcapgi3hmaagA==
X-Received: by 2002:a2e:800a:0:b0:2b4:6c47:6240 with SMTP id j10-20020a2e800a000000b002b46c476240mr2294130ljg.53.1687161988030;
        Mon, 19 Jun 2023 01:06:28 -0700 (PDT)
Received: from [192.168.69.129] (sar95-h02-176-184-10-225.dsl.sta.abo.bbox.fr. [176.184.10.225])
        by smtp.gmail.com with ESMTPSA id p26-20020a056402075a00b00515c8024cb9sm1974990edy.55.2023.06.19.01.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 01:06:27 -0700 (PDT)
Message-ID: <9e0961bb-0625-41b0-39cb-a18749859ee7@linaro.org>
Date:   Mon, 19 Jun 2023 10:06:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 3/4] exec/address-spaces.h: Remove unuseful
 'exec/memory.h' include
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20230619074153.44268-1-philmd@linaro.org>
 <20230619074153.44268-4-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230619074153.44268-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/23 09:41, Philippe Mathieu-Daudé wrote:
> "exec/address-spaces.h" declares get_system_io() and
> get_system_memory(), both returning a MemoryRegion pointer.
> MemoryRegion is forward declared in "qemu/typedefs.h", so
> we don't need any declaration from "exec/memory.h" here.
> Remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/exec/address-spaces.h | 2 --
>   1 file changed, 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
