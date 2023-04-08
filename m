Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA3D6DB7DB
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 02:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjDHAhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 20:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDHAhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 20:37:36 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD11E182
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 17:37:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1a52674f1abso346365ad.2
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 17:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680914255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FlnYyalzN/iYxpFe1DybwocYPl8XORXDn/OIhRtakc4=;
        b=jD/5aTfjyaqC30FvcPzK1FczFQvjqacUTe6hG7h7Zdejg2oqWWAxgluXNmGIKRau7Z
         aCv0iGDV9NKf/eTTyW03asl72Ya09KyKgvltAiInJJ7jP3tIPSLwGu/U8PKdhS+BUSje
         o0IMuUyW0Wp56hmbf1TkgK5jgSn0hDE5uleDPAoa3y6mXvo6uAvglTH0VAD4WsZzqMve
         xHOcVyp1Is8jg2qJ3e1Xs0LP/X147jJLfPm3uHUN5aQ7m4kGtDxuSUfWbi+J105NC+Bo
         FJc1L95ryAhR3qGy+BLef2OPTuiayCPXNzvjEYwZyHqWiCZqWlaChfRFFBJqLFw6IAi7
         SzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680914255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlnYyalzN/iYxpFe1DybwocYPl8XORXDn/OIhRtakc4=;
        b=G7SSpbsQyUrvIe4fr5ooi1fYgPl/j3jz9yl0/bVK1cuTYF1mkRbOyQrqfWspIhX4C9
         oFZH+zBxXQKwGZdstFf0xvZdRq2fP6tn5fNnUQd7HhmBBYj52BRF7Rr7tHBfL0b/IqeE
         OAij9zSaeja0NgiE+nYnEjNCJfyFHlstCSLzMe+dMi0yG8XSdCiiGJHqSKaaf0JRbtVk
         VNWMAHxHwcoqBT26RQU1mQEI4Ja23guRdiKQB4jjGVt53rqLlV6mxplPm4Lvm2X+xmUK
         aWgR3lUij/elii75+CUOvquGOXLifizTQWiiKp3LokJrW5snIWjU3EWtt6XBtj9B7KgG
         2E9w==
X-Gm-Message-State: AAQBX9dJrQ5f028g7/19nPw2Yx999WLv1DFFBgFcDuz8p1dJDncfuB02
        guGoF3KBfpK9wX7vHEe6cRdsBw==
X-Google-Smtp-Source: AKy350ZFn5BoldKrbBUWslJpxAkAjDJBSYdQq+Ec5vWs6+jDZvrCocT7tagi2MsZlaQ9G0+7PoMgYg==
X-Received: by 2002:a62:3884:0:b0:623:165e:e459 with SMTP id f126-20020a623884000000b00623165ee459mr3904159pfa.7.1680914255611;
        Fri, 07 Apr 2023 17:37:35 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id 6-20020a630706000000b00517be28bcf9sm145504pgh.86.2023.04.07.17.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 17:37:35 -0700 (PDT)
Message-ID: <bbb6afe3-60b7-04c5-a65e-62873744d3fe@linaro.org>
Date:   Fri, 7 Apr 2023 17:37:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 02/10] accel/kvm: Declare kvm_direct_msi_allowed in stubs
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-3-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405160454.97436-3-philmd@linaro.org>
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
> Avoid when calling kvm_direct_msi_enabled() from
> arm_gicv3_its_common.c the next commit:
> 
>    Undefined symbols for architecture arm64:
>      "_kvm_direct_msi_allowed", referenced from:
>          _its_class_name in hw_intc_arm_gicv3_its_common.c.o
>    ld: symbol(s) not found for architecture arm64
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   accel/stubs/kvm-stub.c | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
