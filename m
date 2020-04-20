Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995071B06CB
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 12:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgDTKoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 06:44:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51840 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTKoM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 06:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587379451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/xjJsUgF778LpNzZZV/h2y2cV6lCn7Ce6da2WhB8fs=;
        b=i5j1nuRn7Y1+tUYAZeOaLVPWRsEIpEbfWRLE2Ennf/kqj960j3fLARP37kUaXFQyTn4P7s
        dKBTFG+uehQsE5wsuEmTV0v2pTytUO0M5o1tioE/iUe8hpU7wxuaEV86uJmm/LPsL6TFoM
        Vs/niuqXzNjDextqwO8PPGLfrW+7aJs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-G7cjnHKvN26_nQbmfDdevA-1; Mon, 20 Apr 2020 06:44:05 -0400
X-MC-Unique: G7cjnHKvN26_nQbmfDdevA-1
Received: by mail-ej1-f70.google.com with SMTP id q24so6117125ejb.3
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 03:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T/xjJsUgF778LpNzZZV/h2y2cV6lCn7Ce6da2WhB8fs=;
        b=LqDiAn/8jRFr9g/bwj2pLuSI5sjFuFNomuKJcAU7dZp6nJf8vGtE1xeL7MUQtXVyE3
         S2W2NUoTYihBkmGrB152lDcsC/bYoqw07ja0RB/5pt7I1Uh7mSsVj8zMHqshoMJYIeTZ
         Qmc+3v9sEMgFXAgLQ9yvxQ5t8yXDujVAsvirt8plX5ewh1GwGRog9W0hSmqYgrO6QHWQ
         zrFnAcJALF9xBIUqoL0+jYgYriWjDtJadCAS7BfOE8AKGupWEwEJMdqTs/mQe1WbDE3P
         dMseMdPQzvO76QtWxPie4CRAKCLl1jS+clg4GdxrmxDewCam/zePvsdO947QOvHdfO0D
         UHEg==
X-Gm-Message-State: AGi0PuaeDA8mR5ZIYm5qEPyh99xMmyHciOAXB4s6Yanu5roD8GMDCN1e
        OdSFleC1emAT1Jvt6379urUe7n0qeirGYk5dno4lt6WHPyKK0iTkU5StpzK6tz3jb2XmgqIMQZS
        s0woKzB5XASvh
X-Received: by 2002:a17:906:298f:: with SMTP id x15mr15459768eje.380.1587379444245;
        Mon, 20 Apr 2020 03:44:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypKapnJbCH/Kuk3uuqBQKtd5dm/azVYbWC7aCH/L/nUed6lIVglsjt8ASpV3nhRhiQz38THiWA==
X-Received: by 2002:a17:906:298f:: with SMTP id x15mr15459754eje.380.1587379444049;
        Mon, 20 Apr 2020 03:44:04 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net. [83.42.57.116])
        by smtp.gmail.com with ESMTPSA id mj1sm107969ejb.6.2020.04.20.03.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 03:44:03 -0700 (PDT)
Subject: Re: [PATCH v3 01/19] target/arm: Rename KVM set_feature() as
 kvm_set_feature()
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-2-philmd@redhat.com>
 <cb3178f1-5a0c-b11c-a012-c41beeb66cd2@linaro.org>
 <3dc0e645-05a5-938c-4277-38014e4a68a3@redhat.com>
 <f4ee109e-b6fc-8e1b-7110-41e045e58c30@redhat.com>
 <CAFEAcA8z5t__ZQQSqx88nMcC26SHowa3AjtDaQQFaPn-p-FYYQ@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <7f49bc68-8c40-42b9-7810-fc1f9f6ff904@redhat.com>
Date:   Mon, 20 Apr 2020 12:44:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA8z5t__ZQQSqx88nMcC26SHowa3AjtDaQQFaPn-p-FYYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/20 9:58 PM, Peter Maydell wrote:
> On Sun, 19 Apr 2020 at 17:31, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>
>> On 3/17/20 10:09 AM, Philippe Mathieu-Daudé wrote:
>>> On 3/16/20 9:16 PM, Richard Henderson wrote:
>>>> On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
>>>>> +++ b/target/arm/kvm32.c
>>>>> @@ -22,7 +22,7 @@
>>>>>    #include "internals.h"
>>>>>    #include "qemu/log.h"
>>>>> -static inline void set_feature(uint64_t *features, int feature)
>>>>> +static inline void kvm_set_feature(uint64_t *features, int feature)
>>>>
>>>> Why, what's wrong with the existing name?
>>
>> Peter suggested the rename here:
>> https://www.mail-archive.com/qemu-devel@nongnu.org/msg641931.html
> 
> In that message I suggest that if you move the set_feature()
> function to cpu.h (which is included in lots of places) then
> that is too generic a name to use for it. The function of
> the same name here in kvm32.c is fine, because it's
> 'static inline' and only visible in this file, so the bar
> for naming is lower. (In fact, it's a demonstration of why
> you don't want a generic name like 'set_feature' in a widely
> included header file.)

And your suggestion is indeed obviously correct...

Apparently after 19 months rebasing this work I'm not seeing clearly.

Thanks again!

