Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0736D8A40
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 00:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjDEWGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 18:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDEWG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 18:06:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1782D74
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:06:27 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j13so35440061pjd.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 15:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680732387;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7JvVUj41FM9yqQNBhoUa/XewsevSyL6fsaIuCj+Vv38=;
        b=QMiD/dw6gORZddwX7mCho4LNkB2EQqjDXAzTeHXXGvY2zCMdI6F2myR6ct8FCxVedw
         ypQLeDfH1JAtFkXx974GnVTdxSGCfUbQxd6kxPT7aX2mA1l4gOvfIKI+j8+xp/j4FdT1
         P49R5LTLFUdWmDTbryt4L4cWhZ3ZXh2umyyL/9b8KJieU+gfV+o4mUJTAMgRo7NUr1HP
         wEiXrTnsGPdW2e7laKYywEu3jJ/2q+ISQgVZon72N7Hc/VrNOhvdvyDu9H8AgllDqUXY
         QUSt6b6+vwGiEBbqwiT7gyav/81J4+lejn27QcU/fe35VRTwh2IitB1KtZsjDUZJwcq1
         Oq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732387;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7JvVUj41FM9yqQNBhoUa/XewsevSyL6fsaIuCj+Vv38=;
        b=iFRdwh06buydGuOSm6aQ2htvcNYmkkhHSX3m8E7EQUbmiiTrK9GmfDJZrnfEsnF5zs
         8Dn8Hy0dqRbuULtdP6qXBw96VnSVAej5rBpKvjfMLXRne66achar8JY/bTIk70nC9SW4
         BeeeM7fvdMnD229OJg5dRuXy+NreiifRUp5ehqAsRh5RjmymkklvFEhnZ92lTI4N+TGe
         4yK3PVI5gty0G4+m02aTtr6Hps42MoQt5JIl+RQziYOuBrV0EX3/dpXutQN5FyKaK5xT
         xhELm1/AJ/ain8zkIYGJePK2dI1+saZzLQsxVAdibqd8FokqspKdD0RZZbjhQfSIIADL
         Lp0Q==
X-Gm-Message-State: AAQBX9dD/EIXGZYPw+lzBeO/b0N5tPc/+VxYeHQJ5vf9gUUI9ifU+Wj3
        lY2eJCMVGmmsF6WQytai0Yja1IfKKwkyCZaDZ/w=
X-Google-Smtp-Source: AKy350a3jd+YtqUTGBuWzAD/I/YLuZIljN8RlTAttaNyXiBSYHEmXJKNFi8w6Ykq9JQV121yyUxZwg==
X-Received: by 2002:a17:902:e843:b0:1a1:8860:70e5 with SMTP id t3-20020a170902e84300b001a1886070e5mr9754214plg.57.1680732387278;
        Wed, 05 Apr 2023 15:06:27 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:ce11:4532:7f18:7c59? ([2602:ae:1541:f901:ce11:4532:7f18:7c59])
        by smtp.gmail.com with ESMTPSA id jb22-20020a170903259600b001a190baea88sm14891plb.97.2023.04.05.15.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 15:06:26 -0700 (PDT)
Message-ID: <42d004e7-efa8-cd94-950b-525eac0d7ee1@linaro.org>
Date:   Wed, 5 Apr 2023 15:06:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/2] target/arm: KVM Aarch32 spring cleaning
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230405100848.76145-1-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405100848.76145-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 03:08, Philippe Mathieu-Daudé wrote:
> Remove unused KVM/Aarch32 definitions.
> 
> Philippe Mathieu-Daudé (2):
>    target/arm: Remove KVM AArch32 CPU definitions
>    hw/arm/virt: Restrict Cortex-A7 check to TCG
> 
>   target/arm/kvm-consts.h | 9 +++------
>   hw/arm/virt.c           | 2 ++
>   target/arm/cpu_tcg.c    | 2 --
>   3 files changed, 5 insertions(+), 8 deletions(-)
> 

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
