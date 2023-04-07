Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC20D6DB6FD
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjDGXMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjDGXLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:11:51 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BDFE074
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:11:34 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-517baf1c496so19739a12.0
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680909094;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4cErFy4VVSXH+T35LT4D8bhMQRXEc0jWj0rx0ggjSPk=;
        b=OJFinG4r+Jx35MVNhHZcNTMCoIxRVzugHa8wQb0aF3/WTzIXXBfPwEM81GLW5qzvA3
         5ETEJsnkXy63xKZpvH1BGx4E4mJabdebFUPIucQkQ109TgyzR/OJANaStfogZeUwJSvB
         +n0AkGdqt/wNTf7EIX5oMoy0GvlBdDdwbxgBQ/FNmniodkjKXrGRz7rWA6vw+T9AgziT
         RkNSL9rUUEBJmTGgAlLH2V6qPGr0J/0/wvBQXd6nbZl2I2R617/+2FmNyTRd56JrEd17
         LWo9ZJvzBF+Jg+CjaCPLtDsd5FPc+J0a2N1UTbzoR7A8cxU06vM7OEL1iLwmOTtAizig
         nHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680909094;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4cErFy4VVSXH+T35LT4D8bhMQRXEc0jWj0rx0ggjSPk=;
        b=ngfo4yekXS4zhW/I9BkUuPyvO6XbgmJutwD5Al4Zb7u3y+IwFfJBaXQ/UQ6T65g/Zw
         eYB//HJi1sB5MI/gTy1xuCVcyhnOY3Obew4IdZ5PxFNDxSkw4V8501egnPk9a+XfuQJv
         N+6P6UbGvHy4LDopF8dtRztOyOfvq3bJO1vSdTskW4UYiE41MFfdWAXjwYr1IKntZUQr
         vQP3ikrBo95HcjkkjU1G7rsT9ihTtlC7OJv/wLc9dj8GQOudKkOTTsO6Or0NNwZO4p2r
         Bm4xH3EpkUStcZvi1cSBBcYvb/XMpbf0/F8zwM4NydwKm8syLnwtZK3Wq6HJ6+n3gldd
         MKpA==
X-Gm-Message-State: AAQBX9deAdD5MWIPBRFIMatMHdZqjwczf57K8K1q/UM01SyFulKlRvDN
        YFib+P0v5nSEmG2K/wSPb1/oQw==
X-Google-Smtp-Source: AKy350bXu0YXNAHiNTKVWIi38x7qw1rEbHmvanIsHsxL3sMeptcsGTDsDeyKqZftiwBuvO2w43WOyw==
X-Received: by 2002:a62:1850:0:b0:62d:8376:3712 with SMTP id 77-20020a621850000000b0062d83763712mr155681pfy.28.1680909093896;
        Fri, 07 Apr 2023 16:11:33 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id 80-20020a630253000000b005136d5a2b26sm3141345pgc.60.2023.04.07.16.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:11:33 -0700 (PDT)
Message-ID: <b2778af0-52e1-88fa-f2a8-cc4060835464@linaro.org>
Date:   Fri, 7 Apr 2023 16:11:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 11/14] accel: Inline NVMM get_qemu_vcpu()
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Reinoud Zandijk <reinoud@netbsd.org>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-12-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-12-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 03:18, Philippe Mathieu-Daudé wrote:
> No need for this helper to access the CPUState::accel field.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/i386/nvmm/nvmm-all.c | 28 +++++++++++-----------------
>   1 file changed, 11 insertions(+), 17 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
