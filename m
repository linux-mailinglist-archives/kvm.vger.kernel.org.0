Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF97641CAE4
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 19:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345188AbhI2RLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 13:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343872AbhI2RL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 13:11:29 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B042C06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 10:09:48 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k7so5378605wrd.13
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 10:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+H8AOyZXxw+5dCnqa2Q8A+xVYQisa33e+HzuNr9q3b0=;
        b=e15wcr+U8+SeX0f0+TJQbJ9yTVrmhcbTbLrgO2+1meYKkYDow0z6HAQPlS+z+uYZj0
         Zqr/IVjHLuF8k/Y/e79uSZTBUAnkZ5yng16Ru1V/sY9FABLONWBS60RO7+8EENcdlxWF
         ztX4yUPdiQkuXt08X2OKZaDP/j6aiY1qGGykfS3wjVtFfpoTZ+ldIETCZB08i+bZ8XvP
         uHLFDedERYfIAKHAQFMminXoYCAGKSNC0980Bvkit5ICUBNJzDmhGMyS2dHEfHLtPQkb
         2X6h0QtYl2AnHzbd5I0v5uG1JG14MrMhSLhxMQGf8/x71RSUARTLI4hOZyqSc7fwZIOr
         cCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+H8AOyZXxw+5dCnqa2Q8A+xVYQisa33e+HzuNr9q3b0=;
        b=mrW6VtFvgp+Qh350KhrZlel+VqmECRAXAsxuaYm19YUCTFIcFl8PI0Mvry7H2RwE+C
         CWvMu3tdesqsmnWYr7/QAjkEZtUCjsut9vdVLRDcbTF8K4HxzQI5XTJ4OT9NzWK39mm5
         vpIBCpnXGd7e3ZzENlrx11VllwVCaFBAA4D45MGcMSxQ9ucUyr1Wr75XVFCQCVTrRktz
         251ioaXISTEOOWq4TvWMn8Lw1y/Ryk+dut5nLLKi28qDdE5kD6YVHgx7rXJhlzFJosmf
         74xDAbxNhieLw28Q5vApY6ByAN+KGi4vOV2670K6T/83Y7zgzUt4X8907ATaTYSYYorK
         L+QA==
X-Gm-Message-State: AOAM5302u0sigv2qnct3iBCkFn23zWepTLLxH9OASiXYJwEN6geqHR89
        nKLz5ZDgLjvG6OdPsn8RwZ0=
X-Google-Smtp-Source: ABdhPJx91Earijit4bnHlQwY4VNfjWceJTN7Nua8OGpHlgNMgQcJyd3MLp/k3DH3+jrAr8VD/DyeCg==
X-Received: by 2002:a5d:5683:: with SMTP id f3mr1138553wrv.349.1632935387064;
        Wed, 29 Sep 2021 10:09:47 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id o17sm485218wrs.25.2021.09.29.10.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 10:09:46 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <f022914b-052a-cb5e-e2aa-a01cb208b372@amsat.org>
Date:   Wed, 29 Sep 2021 19:09:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3] target/i386: Include 'hw/i386/apic.h' locally
Content-Language: en-US
To:     Laurent Vivier <laurent@vivier.eu>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        haxm-team@intel.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210929163124.2523413-1-f4bug@amsat.org>
 <bee85404-7092-5565-aa77-165b35db10ee@vivier.eu>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <bee85404-7092-5565-aa77-165b35db10ee@vivier.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/21 18:51, Laurent Vivier wrote:
> Le 29/09/2021 à 18:31, Philippe Mathieu-Daudé a écrit :
>> Instead of including a sysemu-specific header in "cpu.h"
>> (which is shared with user-mode emulations), include it
>> locally when required.
>>
>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>>  target/i386/cpu.h                    | 4 ----
>>  hw/i386/kvmvapic.c                   | 1 +
>>  hw/i386/x86.c                        | 1 +
>>  target/i386/cpu-dump.c               | 1 +
>>  target/i386/cpu-sysemu.c             | 1 +
>>  target/i386/cpu.c                    | 1 +
>>  target/i386/gdbstub.c                | 4 ++++
>>  target/i386/hax/hax-all.c            | 1 +
>>  target/i386/helper.c                 | 1 +
>>  target/i386/hvf/hvf.c                | 1 +
>>  target/i386/hvf/x86_emu.c            | 1 +
>>  target/i386/nvmm/nvmm-all.c          | 1 +
>>  target/i386/tcg/sysemu/misc_helper.c | 1 +
>>  target/i386/tcg/sysemu/seg_helper.c  | 1 +
>>  target/i386/whpx/whpx-all.c          | 1 +
>>  15 files changed, 17 insertions(+), 4 deletions(-)
>>
> ...
>> diff --git a/target/i386/cpu-dump.c b/target/i386/cpu-dump.c
>> index 02b635a52cf..0158fd2bf28 100644
>> --- a/target/i386/cpu-dump.c
>> +++ b/target/i386/cpu-dump.c
>> @@ -22,6 +22,7 @@
>>  #include "qemu/qemu-print.h"
>>  #ifndef CONFIG_USER_ONLY
>>  #include "hw/i386/apic_internal.h"
>> +#include "hw/i386/apic.h"
>>  #endif
>>  
>>  /***********************************************************/
> 
> Why do you add this part compared to v1?

This is a mistake.

>> diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
>> index 4ba6e82fab3..50058a24f2a 100644
>> --- a/target/i386/hvf/hvf.c
>> +++ b/target/i386/hvf/hvf.c
>> @@ -70,6 +70,7 @@
>>  #include <sys/sysctl.h>
>>  
>>  #include "hw/i386/apic_internal.h"
>> +#include "hw/i386/apic.h"
>>  #include "qemu/main-loop.h"
>>  #include "qemu/accel.h"
>>  #include "target/i386/cpu.h"
> 
> Same question

Was missing for cpu_set_apic_tpr():

include/hw/i386/apic.h:16:void cpu_set_apic_tpr(DeviceState *s, uint8_t
val);
target/i386/hvf/hvf.c:98:    cpu_set_apic_tpr(x86_cpu->apic_state, tpr);
target/i386/hvf/hvf.c:618:
cpu_set_apic_tpr(x86_cpu->apic_state, tpr);

> 
> Thanks,
> Laurent
> 
