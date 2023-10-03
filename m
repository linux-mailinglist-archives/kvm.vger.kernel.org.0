Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5317B6AFE
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 16:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjJCOEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 10:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjJCOEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 10:04:06 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDF0A3
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 07:04:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-690bc3f82a7so790361b3a.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 07:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696341843; x=1696946643; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PGhYHTVvUZAkku9032I5Cj12kC+c5Sm175YoL6Kui2A=;
        b=xh1jvNV6oN/chVKFGT327HjPDURIVgNWxJooiwPzl5IORlth40xk/KqaOIlzxR2xUE
         eH0Xg09DgA+u5YIB165ThM6zyTOjFVtCddDQYp9atKlInT602hclg5vLcgUSnN10QQ0v
         JOpSku4N0UFz1ytb7BSF7X9LTJJ5haz5JkbzkIhf7FzRcq5ZGdZQu03xMeQ+iaD274My
         O1veFKfmzRjtKTdSuQ13TcCRfsD8yyWM2YwoYzCuCgyNwxAg6Ajuu+llw74y/kupn0Vb
         g41cVEXHpByMYX/IRxZK0Y50VSUcxolN+G9xZcpK5YrMcKaY4qm1B5PmFdW2KjdqlvLn
         uTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696341843; x=1696946643;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PGhYHTVvUZAkku9032I5Cj12kC+c5Sm175YoL6Kui2A=;
        b=EZ0vJw2KXJw2y12XBR3YXQtdWicYF9GaDgbDnzkP2noZmSr5o5j24AQST5xHtGQ5Og
         jvu0vmtW1W0oD+yMrCF9runCnfzICn6L4pNz+4CSHeyZqRsbupBi40h69MM1QK6Jt3FH
         LgM4geWtpv5bEVO4YvjUm9QO7VNLP1pDdyloDQQWISC5ZAaM8pqd7u6vo8dvWMPAhoJI
         MWPWabppCa3lOriMz1pCue++cF8T5ShpBx1uI7+242a/k1WM7/9xXAHd3p0X2Vx8VOsT
         F/IwP1/K9sfp8diAdou4gIKuwKHk2YGBI6Wm4pmnltfmS7DpH9KPvapO0B03yyMmMYX1
         VEFw==
X-Gm-Message-State: AOJu0YzPPYYrZwy962fGqC9oLgRy8ErfVAvrurreLdekMEoknz2njkEb
        +CFT83lSjfoRjMT9PwVJjHQbJqUG/lRl8EGgO+A=
X-Google-Smtp-Source: AGHT+IHbsC8bIzjKyXDvYfAdfaCcEVwebd0JAM2/o3vR3hGxDCXzAkhavBCserikXogG1mN2b9A0xA==
X-Received: by 2002:a05:6a00:130b:b0:690:d620:7801 with SMTP id j11-20020a056a00130b00b00690d6207801mr12959180pfu.11.1696341843634;
        Tue, 03 Oct 2023 07:04:03 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.149.95])
        by smtp.gmail.com with ESMTPSA id c13-20020aa7880d000000b0068e4c5a4f3esm1389122pfo.71.2023.10.03.07.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 07:04:03 -0700 (PDT)
Message-ID: <96a726c8-186c-3f09-9d9b-d17d7f5289e2@linaro.org>
Date:   Tue, 3 Oct 2023 07:04:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 0/5] accel: Restrict tcg_exec_[un]realizefn() to TCG
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20230915190009.68404-1-philmd@linaro.org>
 <87e1be19-c1c6-73fb-3569-7dbf186662f7@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <87e1be19-c1c6-73fb-3569-7dbf186662f7@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/23 23:44, Philippe Mathieu-Daudé wrote:
> On 15/9/23 21:00, Philippe Mathieu-Daudé wrote:
>> - Add missing accel_cpu_unrealize()
>> - Add AccelClass::[un]realize_cpu handlers
>> - Use tcg_exec_[un]realizefn as AccelClass handlers
>>
>> Philippe Mathieu-Daudé (5):
>>    accel: Rename accel_cpu_realizefn() ->  accel_cpu_realize()
>>    accel: Introduce accel_cpu_unrealize() stub
>>    accel: Declare AccelClass::[un]realize_cpu() handlers
>>    accel/tcg: Have tcg_exec_realizefn() return a boolean
>>    accel/tcg: Restrict tcg_exec_[un]realizefn() to TCG
> 
> Ping?
> 

I have this series queued for the next tcg pull.

r~
