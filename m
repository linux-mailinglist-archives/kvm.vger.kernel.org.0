Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D156DB7DA
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 02:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDHAgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 20:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDHAgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 20:36:46 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A916E06F
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 17:36:46 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id c3so531512pjg.1
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 17:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680914205;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pToGA7FV0Kiuzd13D8HdwPAx2mWDhQqvcrmIS2Cnr7I=;
        b=NTkB0j9lk3kv7Vr/kgHBVZYw4BNYJx3chmF+8X9rG0YK1V5srco7gsi2d7gbEC7tu0
         8pqFA+IZGlpP1ssRQC5vU0ql7nVO+DBZPq4aRNxko+WIRV4NHqKnwLn6xyqVNuOx8dYl
         tHsz9KE0ZRd7uWCuj4Zkf2x8T1HAKDO7AnQ62nX+967KKhesRrTtKZWdRHLRN3rsZhfr
         WGLiUFQ5zJiAp/fRBwyWzImXwU8NQOrT5tEDWTjSG5PH5/SIEP0p+Z2OE0/Vpyio1f9I
         d8x3vsBe/4OIySwaaKi6gxhmp+X3XVic8EBPRusNcRrmSUahp4+AkSR0X5qvhOXIBBJI
         /C1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680914205;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pToGA7FV0Kiuzd13D8HdwPAx2mWDhQqvcrmIS2Cnr7I=;
        b=zJJnkwvjFJ7agMHrM5gKrWq5xl2h1LDmWqDQaPjghGfkomCfYmd8jSQM4jfL0lCxcS
         NyGthDNyO/uR2YzW60wDGYdFfnC0tYv229PckXMn3WU+hCvGGGDkCZCjsdNRRob0xaOx
         G5/3jNaq2ttoIkB0+TZaPiyrg3kYblBtmYiZKHV43v5xAp0aNZlH8k+TWCpGCfEaqIFi
         1G4LiTwM1jIZpNV3x1c+Wf4w4efabHL7O/nIsilV9QOdhGtBd6Ae4i4M+L4CPnRcrBWG
         XqFKLXJJa29ft02u2+jy+TnfGF8Yf+URG5FN3arcvQYARufrhfGQU0YPunDERrQmQd3w
         ukfQ==
X-Gm-Message-State: AAQBX9fp5JinTZRojbeLMObvlCoNP1cFT63ZwxIUW3YeyF2hxBzIQ2Xh
        dJk05GG9iQKTUwykhUSEydO/IuMWujNrozF6gsI=
X-Google-Smtp-Source: AKy350aucnCbxoMrXwvAyMohaMMogPmBAdeaQMVXJGLyL1y0RYnmQhQH5DdC3xcMXS5Nug67U7UBLg==
X-Received: by 2002:a17:90b:4f42:b0:237:d2d8:3256 with SMTP id pj2-20020a17090b4f4200b00237d2d83256mr754113pjb.20.1680914205650;
        Fri, 07 Apr 2023 17:36:45 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id pc9-20020a17090b3b8900b00233cde36909sm5172046pjb.21.2023.04.07.17.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 17:36:45 -0700 (PDT)
Message-ID: <d6d73e10-a551-09aa-88b7-848b11953f60@linaro.org>
Date:   Fri, 7 Apr 2023 17:36:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 01/10] sysemu/kvm: Remove unused headers
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-2-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405160454.97436-2-philmd@linaro.org>
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

On 4/5/23 09:04, Philippe Mathieu-Daudé wrote:
> All types used are forward-declared in "qemu/typedefs.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/sysemu/kvm.h | 3 ---
>   1 file changed, 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
