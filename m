Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328A62D375D
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 01:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbgLIAEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 19:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730467AbgLIAD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 19:03:56 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B302C061793
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 16:03:16 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id o11so526189ote.4
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 16:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v9Zbd3hMysWUE0vmbip6QeMTd4FqW/oqK4E5d/p0K9w=;
        b=LgP3cCOwkrkvIWeNrQFCD34np7ZTFALmCd8/ykuMhnah6ZBICN4BznmuR5k1UrNKfT
         M0AioMjjCqYoGnmDkog2GYlY1f4P0yADZcpBKNUaS0NVoBPAa8NbaOIU8WBCNAMSXayz
         HBDnHATjFiqC+CUBvRsKn68s35zkWqX2/gTvyhN5W2Dn8pwUV5XPGRd8RqtDaKhpJWYq
         J8FvSGUkKdwR1icCpxZfOUbANS0YRX9rUjQMMy7KhrJOY0/kAlxeXOnvM+8UBQSTt66e
         L7cQAAQ8fFAwu7p9InuSKqjRvV59sG64OPSYuJdamjBYfzaNcX5LjdzG4IS/FSNczQz0
         kqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v9Zbd3hMysWUE0vmbip6QeMTd4FqW/oqK4E5d/p0K9w=;
        b=CSNsv4KY8tVoQJu024qXfoEv0Gx+IWKUS9ukRRdiwly10pNL9jwhukG+rMuwmS5OIa
         To+5JMeIcX5CDr8Amewv+4ASGZnQSP4/koffBpaML2zqPySOTxaKjeMsLuL3Lq3BWUYp
         aD6CCK7/KDsnnMt/Tx2ucmYc8p/Q5QwOCLduZe0/KoogCKE0TM1daH/cyzacNf7R4Nid
         CZBCCM9weVVnrvBH4IbJnRs52Ccm6vYelEXV360+tq+KxbdttfEwNAVVOG49xQe+qoC6
         Z6jYPkTq676IMnanmgZwu3tgRQDAMY3B5u80R9ueBatO0Vut2JJzs4W5P2P3jXwPqwTW
         G5dA==
X-Gm-Message-State: AOAM530EGthhcATBydR0Mz6NokxogW12EZdhOopoNPSxg8ucMB3PUEnd
        wlK9rAJc7wF512xvmBTrXTb/OA==
X-Google-Smtp-Source: ABdhPJyFOSiIgRDuUOyJ0eSUvk91D5XxLN09325/QoAa1sYB+6paSmuvDwIZGLT5+MsFoqzKtzdqpg==
X-Received: by 2002:a9d:65d7:: with SMTP id z23mr493876oth.131.1607472195622;
        Tue, 08 Dec 2020 16:03:15 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id k5sm127307oot.30.2020.12.08.16.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 16:03:15 -0800 (PST)
Subject: Re: [PATCH 14/17] target/mips: Declare gen_msa/_branch() in
 'translate.h'
From:   Richard Henderson <richard.henderson@linaro.org>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <20201208003702.4088927-15-f4bug@amsat.org>
 <45ab33e0-f00e-097a-74fb-4c7c42e29e33@linaro.org>
 <b0cf35c4-a086-b704-5710-0f05bf7921bb@linaro.org>
Message-ID: <58a0d6c4-fc01-3932-52b9-9deb13b43c51@linaro.org>
Date:   Tue, 8 Dec 2020 18:03:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b0cf35c4-a086-b704-5710-0f05bf7921bb@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/20 6:01 PM, Richard Henderson wrote:
> On 12/8/20 5:56 PM, Richard Henderson wrote:
>> On 12/7/20 6:36 PM, Philippe Mathieu-Daudé wrote:
>>> Make gen_msa() and gen_msa_branch() public declarations
>>> so we can keep calling them once extracted from the big
>>> translate.c in the next commit.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>> ---
>>>  target/mips/translate.h | 2 ++
>>>  target/mips/translate.c | 4 ++--
>>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> Actually, I think this should be dropped, and two other patches rearranged.

Actually, nevermind, you already get the right result in the end; there's no
point re-rearranging.


r~
