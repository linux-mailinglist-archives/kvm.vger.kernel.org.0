Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35591B06DE
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 12:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgDTKtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 06:49:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58644 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTKty (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 06:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587379792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtRzTRehi0O6bAYAyvwFPzRkMeZJfRli4FPebqPOExY=;
        b=gDIMDsyAA5vaDAnEvrGbxvusWWwCfD/VrAu/Ufr2ltYDgfHOWdLKzPJWs22m9YLK4Hyxjh
        yd+iTFbHD7029aAT8Eq5iEybkVpqyVpUN8nJb9LXUc4DhZCQ3/rgCA2Lvi1NQPc33is0ZF
        2cr1yEJAYaPRPfsmM+7dnJL9gE1KPoY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-eLRhgQavMOKKpeB3rWmvLw-1; Mon, 20 Apr 2020 06:49:50 -0400
X-MC-Unique: eLRhgQavMOKKpeB3rWmvLw-1
Received: by mail-ej1-f71.google.com with SMTP id m21so6056415ejd.17
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 03:49:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rtRzTRehi0O6bAYAyvwFPzRkMeZJfRli4FPebqPOExY=;
        b=iNre6P8fAq7+ZOp0l33ar3iMEZuFECawOjsk+eHV7RSbTc/HlLEkJKtflHY1+PSYyy
         RaxSI7dYxpehoa6p7IuijyqFMbnVYwobDPWl6OwaMxx/3d0p7si/6sH7sDm9Q5LmH9+6
         Vkb6M8+7WvaGJb2jYJ2/IWWrtJeqgE3qmz5/+CytBCoaqkHjXDm899DhAx6+xmT9gU3v
         ETB8lkqjwUTb3ahsis2+r5a5DzPZ13VS9MAcZtGzAtRy1I+LUljbGwqOK+/sBiD+gQZ0
         UquS3huzGxkMoqgMM6DqsruemtHoq94jCsaOa+mF6fVP/BImw4+zLak2NNFtkMLf00h8
         bziw==
X-Gm-Message-State: AGi0Pua5vAwVeEYXqsAl8gxW/u4UtPQ/TPbGQrw2j+kVVdzb0/x/BHhP
        Psbc7MCiaAqlLq8Tymqx5ttgKk/m95meXiAHRimqbj9yJNt2d+CjYankNFcVvK59aluoW11GL4e
        FdM16+oit9pn7
X-Received: by 2002:a50:d942:: with SMTP id u2mr13893153edj.116.1587379789754;
        Mon, 20 Apr 2020 03:49:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypJztSB+Un3E4swJv9LDYUAgNj/8yk+tU0DtKAOnWSiOSTU8XCz+5yFKhkcH8st6qPWw5VQM9Q==
X-Received: by 2002:a50:d942:: with SMTP id u2mr13893142edj.116.1587379789573;
        Mon, 20 Apr 2020 03:49:49 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net. [83.42.57.116])
        by smtp.gmail.com with ESMTPSA id gh8sm108359ejb.32.2020.04.20.03.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 03:49:49 -0700 (PDT)
Subject: Re: [PATCH v3 05/19] target/arm: Restrict Virtualization Host
 Extensions instructions to TCG
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-6-philmd@redhat.com>
 <9cff4a7a-e404-fcc4-eb04-fdbc48ceb7c2@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <ad90c620-8594-aac8-75f6-da342861211c@redhat.com>
Date:   Mon, 20 Apr 2020 12:49:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <9cff4a7a-e404-fcc4-eb04-fdbc48ceb7c2@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:17 PM, Richard Henderson wrote:
> On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
>> Under KVM the ARMv8.1-VHE instruction will trap.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   target/arm/helper.c | 22 ++++++++++++----------
>>   1 file changed, 12 insertions(+), 10 deletions(-)
> 
> What happened to the uses of these functions?

Sincerely I don't remember... I got this branch working again without 
this patch, so I'll just drop it.

> 
> r~
> 
>>
>> diff --git a/target/arm/helper.c b/target/arm/helper.c
>> index a5280c091b..ce6778283d 100644
>> --- a/target/arm/helper.c
>> +++ b/target/arm/helper.c
>> @@ -2897,16 +2897,6 @@ static void gt_virt_ctl_write(CPUARMState *env, const ARMCPRegInfo *ri,
>>       gt_ctl_write(env, ri, GTIMER_VIRT, value);
>>   }
>>   
>> -static void gt_cntvoff_write(CPUARMState *env, const ARMCPRegInfo *ri,
>> -                              uint64_t value)
>> -{
>> -    ARMCPU *cpu = env_archcpu(env);
>> -
>> -    trace_arm_gt_cntvoff_write(value);
>> -    raw_write(env, ri, value);
>> -    gt_recalc_timer(cpu, GTIMER_VIRT);
>> -}
>> -
>>   static uint64_t gt_virt_redir_cval_read(CPUARMState *env,
>>                                           const ARMCPRegInfo *ri)
>>   {
>> @@ -2949,6 +2939,17 @@ static void gt_virt_redir_ctl_write(CPUARMState *env, const ARMCPRegInfo *ri,
>>       gt_ctl_write(env, ri, timeridx, value);
>>   }
>>   
>> +#if !defined(CONFIG_USER_ONLY) && defined(CONFIG_TCG)
>> +static void gt_cntvoff_write(CPUARMState *env, const ARMCPRegInfo *ri,
>> +                              uint64_t value)
>> +{
>> +    ARMCPU *cpu = env_archcpu(env);
>> +
>> +    trace_arm_gt_cntvoff_write(value);
>> +    raw_write(env, ri, value);
>> +    gt_recalc_timer(cpu, GTIMER_VIRT);
>> +}
>> +
>>   static void gt_hyp_timer_reset(CPUARMState *env, const ARMCPRegInfo *ri)
>>   {
>>       gt_timer_reset(env, ri, GTIMER_HYP);
>> @@ -2976,6 +2977,7 @@ static void gt_hyp_ctl_write(CPUARMState *env, const ARMCPRegInfo *ri,
>>   {
>>       gt_ctl_write(env, ri, GTIMER_HYP, value);
>>   }
>> +#endif /* !CONFIG_USER_ONLY && CONFIG_TCG */
>>   
>>   static void gt_sec_timer_reset(CPUARMState *env, const ARMCPRegInfo *ri)
>>   {
>>
> 

