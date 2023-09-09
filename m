Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C861D799C0D
	for <lists+kvm@lfdr.de>; Sun, 10 Sep 2023 01:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345306AbjIIXcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Sep 2023 19:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjIIXcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Sep 2023 19:32:01 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454D41BC
        for <kvm@vger.kernel.org>; Sat,  9 Sep 2023 16:31:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-68fb898ab3bso109696b3a.3
        for <kvm@vger.kernel.org>; Sat, 09 Sep 2023 16:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694302317; x=1694907117; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ny/3tzKYbYh+LHv2XK3yr3VU7m4zenC2g/xsHVCwMbk=;
        b=sN93nuhRFote0UIECB3Y+QgYU7s6V6L1TYE8vkGBZ8sXyl/CfYIwAIef2+5fui5885
         W/ulVKBm79bsa5DwDtcgv7oiz4SW89MYV5WNgZ6IxpqSAXEX598vPpzPMI3zVoYbB/lR
         jx4Rq6Y0rgiG4oG5n8VmNx2n0br3wa/vNdLHP05xykR+KeLhtpkirXUkOUQGZbmKiZzA
         FOY/f1zA3yGQLucGrU/uZioH5MmD6rEFgIOgWXVHFlmZeYSf8CtrdxdyXwO3njVkR9t8
         STts82kEvDboQ129SB28rxxP66lXhdEFmIqO/O7roAYANq+Pg5O27K9rc6YgXEzEtssQ
         YHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694302317; x=1694907117;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ny/3tzKYbYh+LHv2XK3yr3VU7m4zenC2g/xsHVCwMbk=;
        b=RKy+iObzunGqGiJgdXHAfgSWOpZjEc8dbImoC/VOfFz2ZTyCkO553P5YZ0V5/cBHBu
         8kcDNsk7mmd7HEyPTFzlsOYAZoybHNvF2EhfqdkTTuAfsDCk+mQDkslQ8XeRjplFOw8M
         AVzjd11dDbMXWQtmW786FJUOqoRZMCLUbT0AZSzIuP5joP/mtJZSqXgIE3Css8BiwV2e
         JVS/OEVeE1MB3fmkIIyq3ZSYvg2ICEGdNMTulgzMl7v1iBLk7/9t7gHC82i/MDCsCq5E
         7psG07+/FVEAl9B3S6BsW3ckwKO5vYjtRTrSYN7i9OH92pqTWAopb7Lbl0aVvB6uzu5W
         u+rQ==
X-Gm-Message-State: AOJu0YwR6iUeB04992lwTbXplJ8nnAUUUn7CHJH0LvoHGrKEu/FdibeI
        vlsquV25qjWMIkGbaa8jXAp6lA==
X-Google-Smtp-Source: AGHT+IHqTIFUGEBUNTYDjhdnD1TPnSJ+B+rGt3q2m891+GFIwAMI9Qe/tFPqSeZ+MgBx5O2U9BpUjg==
X-Received: by 2002:a17:90a:528f:b0:26d:1eec:1fc4 with SMTP id w15-20020a17090a528f00b0026d1eec1fc4mr5109945pjh.19.1694302316739;
        Sat, 09 Sep 2023 16:31:56 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.131.115])
        by smtp.gmail.com with ESMTPSA id bt22-20020a17090af01600b002612150d958sm5036595pjb.16.2023.09.09.16.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Sep 2023 16:31:56 -0700 (PDT)
Message-ID: <a800682c-19c6-904b-d087-df90591a3927@linaro.org>
Date:   Sat, 9 Sep 2023 16:31:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 04/13] target/i386/helper: Restrict KVM declarations to
 system emulation
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
References: <20230904124325.79040-1-philmd@linaro.org>
 <20230904124325.79040-5-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230904124325.79040-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 05:43, Philippe Mathieu-Daudé wrote:
> User emulation doesn't need any KVM declarations.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/i386/helper.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
