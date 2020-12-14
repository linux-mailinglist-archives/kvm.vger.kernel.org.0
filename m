Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D321A2D9A30
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 15:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438456AbgLNOlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 09:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438269AbgLNOlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 09:41:10 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833FBC061793
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 06:40:29 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id y23so15508932wmi.1
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 06:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BrrQYqYGshTc/6VuSGjvuyQkulwl1IqzMrsCfz/Qh9c=;
        b=YsW+yVlO5oUprEeUcbHHli4nljShXyjwH+t4Z8ielbT02jAyjt8COxW4D6coVh2447
         RgYQEhleQDRqpk8P7oI7Gu9oisQdO1BfBSlqMG5uv7W9+EoSE8D1lQA/dUai6XD2xPGf
         kzUQz7a095cMTPznxt0pwqQZd+2pqF65oc3lcLeMgGbeKpVhqgOOD0Qd8+LeHddap6FL
         a1GxcrezR1NOI9jNvN2DBfOiGPOIqaORMvaaHerJ8q+4kGaJr8Z1OAcQLl1cThKBStGR
         kMQmAkUZLCIHWAiQok/i36Px0PvnANoeOdKK4hGr2G5dbga4rPcJilvVENsUsIvT7gJ1
         uVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BrrQYqYGshTc/6VuSGjvuyQkulwl1IqzMrsCfz/Qh9c=;
        b=czvzHxV/whtNbm7Xf8/bAmDZtMERvR7QOzMUQxb8uyfOZEBQatbmAJUdKLYsQ1UrE4
         NM5bZhZCYnS/ZdZWLuJ0c4pVlgedmzNH4Br7WeYodFcb+g1WkvLCIfIEabu4CkkKSNuE
         7W5Blapzp6q0NJ9vdPdz6nAATlx+uJEbXdlHvR0DCUzUP/NjMhpqlH8xSJk1s/Y4dVpf
         /DQRsL6upmuiV33uzpWE2yMawroSYMmdBkD9KU8XcMRIT7HwncsR+wOTuDjlznt/YWpx
         HV86m3gnzkXuVCM7Gy/TqnLmrl1TaIzCnebL21NQ7Q0REg7YDjvfRs2N2AgbOA9oNMjb
         7GzA==
X-Gm-Message-State: AOAM531p5x1q0PIvT/5GUpOOmzQjrbIjlUtj6s92Uqtp5SrBeRH1cTvN
        r6Pax8j6y8Er3/SVbw38lWw=
X-Google-Smtp-Source: ABdhPJz7jvk8QmPzwDl9rZNaxqCujA35kY69TYJskYQDu6FwSpGoKI7efyzEGe4dOA+wJk9OFcjdiA==
X-Received: by 2002:a7b:c3c8:: with SMTP id t8mr27895135wmj.88.1607956828302;
        Mon, 14 Dec 2020 06:40:28 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id i8sm30274942wma.32.2020.12.14.06.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 06:40:27 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH 17/19] target/mips: Rename translate_init.c as cpu-defs.c
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-18-f4bug@amsat.org>
 <56eefa47-f95a-087e-54d2-05135d2c506d@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <b479857d-3b31-9e68-1d51-3de614b300dc@amsat.org>
Date:   Mon, 14 Dec 2020 15:40:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <56eefa47-f95a-087e-54d2-05135d2c506d@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/20 11:30 PM, Richard Henderson wrote:
> On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
>> This file is not TCG specific, contains CPU definitions
>> and is consumed by cpu.c. Rename it as such.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>> cpu-defs.c still contains fpu_init()/mvp_init()/msa_reset().
>> They are moved out in different series (already posted).
> 
> After the other functions are moved, then this file may be compiled separately?
> 
> Or... why is mips_cpu_list moved?  I guess it wouldn't be able to be separately
> compiled, because of the ARRAY_SIZE.

Indeed, I missed that.

Thanks,

Phil.
