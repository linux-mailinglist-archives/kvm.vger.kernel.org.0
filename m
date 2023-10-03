Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CA47B6B92
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 16:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbjJCOaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 10:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240084AbjJCOaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 10:30:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD302AC
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 07:29:57 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-406609df1a6so10196755e9.3
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 07:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696343396; x=1696948196; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0AsNLbWUO9UMmd8b5Jij1zwO5hgHkJ7ZdZdK4D/2Kbk=;
        b=YIuhaiMnkXqAFq0OAVil/YgftA98/yBmPlmB6KV5Jx7qBSiQizjT7YXBZNxsIOiUzj
         fOkJ2O83KSqsgrYVgyo4xmmWMDAafv6WVNISVgt/2fTVj3DCLEgjI04iPl2MYsJ2aqHM
         Y56ecMF5OdY6vwWhK0rqoShSR2ksC8I7rJmr2KxlvcFftUbQKB9dFvSZzzq8o3o0Uu8Z
         bjAcq0a839rwNMAg0Y7WYohZ5HyIEHuliT9rpNRVjVnxy1G+OUlxC+1A3O/3A4ax7KVx
         Rcorxg4mWqF5OjGxlcRbQjxD+731Ihp6Qp/Ndp3+e99sFwemVRObbass2a3Q1P7/Gs6b
         x5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696343396; x=1696948196;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0AsNLbWUO9UMmd8b5Jij1zwO5hgHkJ7ZdZdK4D/2Kbk=;
        b=Fk+9NOTuMys42mGHRLHp6OWa2ttD5y5Ha/jeaS/oMd0XPmZVrjb7pdTLkD60iB1mEh
         D9GWbtU/0LlYen4viVT66Ad63RMt3kK990GtOvvueq6J6T7qL8RIONWK+gEkx43vv/67
         PRFh3gkG5y8NgFNTH4G8WmhDbvXuSTUASD9/Job/1SntRxaZ4C5txQGCElNXr5ZRsXKb
         vdIl0abS5YMPdbqURxjlckG78nBaSDHYVZBmbyr6yqXvu4HSoS2K7y3biA+RKhWBV6g8
         2zF8etVH4VuJXfoyZj6UAQmciQDqnbd8fNazfKxygyzK92lNcnxSi9cMj9XiYvHoij0i
         aeNg==
X-Gm-Message-State: AOJu0Yyo268PoQ+rnrV/4MZcIHOQmFpzZpFuE7yCWxFvXiSa9Pvmpv5B
        L9hp08pIamn3V4tO1/za9PHBRw==
X-Google-Smtp-Source: AGHT+IHsQMGYX0sFloYUtQ7JodeOoXMzSKIszUSriJqyPVhF/1t3l77+z7Uvz3IR3Ul8W9YAFFRI9w==
X-Received: by 2002:a05:600c:21d1:b0:401:cb45:3fb8 with SMTP id x17-20020a05600c21d100b00401cb453fb8mr13594246wmj.38.1696343396230;
        Tue, 03 Oct 2023 07:29:56 -0700 (PDT)
Received: from [192.168.69.115] (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id v11-20020a1cf70b000000b004065d67c3c9sm1419429wmh.8.2023.10.03.07.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 07:29:55 -0700 (PDT)
Message-ID: <2f56c993-39f4-476e-25e6-80969d46e413@linaro.org>
Date:   Tue, 3 Oct 2023 16:29:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 0/5] accel: Restrict tcg_exec_[un]realizefn() to TCG
Content-Language: en-US
To:     Richard Henderson <richard.henderson@linaro.org>,
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
 <96a726c8-186c-3f09-9d9b-d17d7f5289e2@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <96a726c8-186c-3f09-9d9b-d17d7f5289e2@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/10/23 16:04, Richard Henderson wrote:
> On 10/2/23 23:44, Philippe Mathieu-Daudé wrote:
>> On 15/9/23 21:00, Philippe Mathieu-Daudé wrote:
>>> - Add missing accel_cpu_unrealize()
>>> - Add AccelClass::[un]realize_cpu handlers
>>> - Use tcg_exec_[un]realizefn as AccelClass handlers
>>>
>>> Philippe Mathieu-Daudé (5):
>>>    accel: Rename accel_cpu_realizefn() ->  accel_cpu_realize()
>>>    accel: Introduce accel_cpu_unrealize() stub
>>>    accel: Declare AccelClass::[un]realize_cpu() handlers
>>>    accel/tcg: Have tcg_exec_realizefn() return a boolean
>>>    accel/tcg: Restrict tcg_exec_[un]realizefn() to TCG
>>
>> Ping?
>>
> 
> I have this series queued for the next tcg pull.

Oh I didn't noticed, thanks!

My preference would be v2, which Claudio already
reviewed and tested:
https://lore.kernel.org/qemu-devel/20231003123026.99229-1-philmd@linaro.org/

