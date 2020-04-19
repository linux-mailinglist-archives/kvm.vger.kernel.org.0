Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8961AFC06
	for <lists+kvm@lfdr.de>; Sun, 19 Apr 2020 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDSQcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Apr 2020 12:32:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28795 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726157AbgDSQcA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Apr 2020 12:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587313918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mdx8uZoicdMAL3gsk4iw2tZTBBc5tNVnam1BJXq8JpA=;
        b=J4pvzgS7T5MEdU1EgJweUGJc4SwqJDXiDdLixMlFBib64dqs/GWVkr4/l/VbtWpvjnE5oy
        eYwCO2iPysGvEEdF0R3/L8YMZJPA25MXhrvSnZkK3JsRar6gUqw9M1/BoN22d45KTv6ki7
        it8FYOJPaUGSS5RAz280wUo/vAJcmRc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-pW_E9HBYOj2h-6K_aRB_vg-1; Sun, 19 Apr 2020 12:31:52 -0400
X-MC-Unique: pW_E9HBYOj2h-6K_aRB_vg-1
Received: by mail-ej1-f69.google.com with SMTP id b23so4552206ejv.5
        for <kvm@vger.kernel.org>; Sun, 19 Apr 2020 09:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mdx8uZoicdMAL3gsk4iw2tZTBBc5tNVnam1BJXq8JpA=;
        b=bZqHt+FRE4kXdTRInnO19hXVvtqUafs0ojc2BFGT80VvKPq4hpneArmPF8/Po8BZs3
         c5w2kI4tifRGhWkbkHtLc9PMsLZ2HjKvmqnoMwZPnxG3kxfckGVDWzhcLZDmaZsV2vhj
         Jr2AAMKU9sB2yU9vgweC9DTOHa9f2cI0AJAptnxWVgb7YmPP39tSLUksecELA602lvCG
         laGtsGxP6IgJEnMcmULOOuGdDhbBWRNgb8YKcqXpn3mj6WaHzYAlqS+WozLLlsq6K15Z
         0yiWMWdCZpphK01JCCIzNUEwgFGcYf4xyitu0WNR5RV+VQBKjq42ngY+oHtfqRLYx5bc
         8XeQ==
X-Gm-Message-State: AGi0PuYjAfqILLK3tz/N8F8HUZl0hnCSaZuiwqpGIn2dR4qVW6Lq8yTq
        CUHBJl8c6lH2FThMxO0XRRjqhXwFF1vR3iybA3YgbPQmxP5VFvdOV+zupDcNAnUAt+XMMNFb4XP
        gGpVr9GHsIMeu
X-Received: by 2002:a17:906:2548:: with SMTP id j8mr12206225ejb.378.1587313911157;
        Sun, 19 Apr 2020 09:31:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypIGMVc28IzTxhaadVRoFY6tLBI6HBJuXp/EquYW22a4sqO/BslnxojkVnswkaba/ShOkJowLQ==
X-Received: by 2002:a17:906:2548:: with SMTP id j8mr12206211ejb.378.1587313910951;
        Sun, 19 Apr 2020 09:31:50 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net. [83.42.57.116])
        by smtp.gmail.com with ESMTPSA id b8sm1799672edt.7.2020.04.19.09.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 09:31:50 -0700 (PDT)
Subject: Re: [PATCH v3 01/19] target/arm: Rename KVM set_feature() as
 kvm_set_feature()
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-2-philmd@redhat.com>
 <cb3178f1-5a0c-b11c-a012-c41beeb66cd2@linaro.org>
 <3dc0e645-05a5-938c-4277-38014e4a68a3@redhat.com>
Message-ID: <f4ee109e-b6fc-8e1b-7110-41e045e58c30@redhat.com>
Date:   Sun, 19 Apr 2020 18:31:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <3dc0e645-05a5-938c-4277-38014e4a68a3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/17/20 10:09 AM, Philippe Mathieu-Daudé wrote:
> On 3/16/20 9:16 PM, Richard Henderson wrote:
>> On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
>>> +++ b/target/arm/kvm32.c
>>> @@ -22,7 +22,7 @@
>>>   #include "internals.h"
>>>   #include "qemu/log.h"
>>> -static inline void set_feature(uint64_t *features, int feature)
>>> +static inline void kvm_set_feature(uint64_t *features, int feature)
>>
>> Why, what's wrong with the existing name?

Peter suggested the rename here:
https://www.mail-archive.com/qemu-devel@nongnu.org/msg641931.html

>> Plus, with patch 2, you can just remove these.

Since they don't have the same prototype, they clash:

target/arm/kvm64.c:450:20: error: conflicting types for ‘set_feature’
  static inline void set_feature(uint64_t *features, int feature)
                     ^~~~~~~~~~~
In file included from target/arm/kvm64.c:30:0:
target/arm/internals.h:30:20: note: previous definition of ‘set_feature’ 
was here
  static inline void set_feature(CPUARMState *env, int feature)
                     ^~~~~~~~~~~
target/arm/kvm64.c:455:20: error: conflicting types for ‘unset_feature’
  static inline void unset_feature(uint64_t *features, int feature)
                     ^~~~~~~~~~~~~
In file included from target/arm/kvm64.c:30:0:
target/arm/internals.h:35:20: note: previous definition of 
‘unset_feature’ was here
  static inline void unset_feature(CPUARMState *env, int feature)
                     ^~~~~~~~~~~~~
rules.mak:69: recipe for target 'target/arm/kvm64.o' failed
make[1]: *** [target/arm/kvm64.o] Error 1

> 
> The prototypes are different:
> 
>    void set_feature(uint64_t *features, int feature)
> 
>    void set_feature(CPUARMState *env, int feature)
> 
> Anyway you are right, I'll use the later prototype instead, thanks.

There are ~180 uses of set_feature(CPUARMState,...) and 10 of 
set_feature(uint64_t,...) (kvm32:4 kvm64:6).

We are going to remove kvm32, so replacing 180 set_feature(env) by 
set_feature(env->features) seems a waste.

If you prefer to avoid renaming as kvm_set_feature() another option is 
to move the declaration in a local "features.h" header that would not be 
included by kvm*.c.

The main problem is the use of the ARMHostCPUFeatures structure which 
apparently was introduced similar to a CPUClass (commit a96c0514ab7) 
then lost this in commit c4487d76d52.

