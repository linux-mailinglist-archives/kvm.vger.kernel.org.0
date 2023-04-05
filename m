Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391806D818D
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238865AbjDEPTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbjDEPSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:18:43 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E766598
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:18:11 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id p34so21101217wms.3
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 08:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680707889;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=idFXVwnEQw2AeckpahKfXswn5+/Jk4JVx854v+ndXlM=;
        b=P5FRw1Bg8gByNSRzaVrWUJucc+Ia4IMT8SBajxnMMvSH0nmkPoBKvzzOp8cPpm0043
         W55c3pCluAC9R0flUGbEbU7/UOi25PsdH6FiniT+JvE7ldpWa3l6uPy/ngUjkHb2R1nI
         lDct8ip3jjWb9ZROycFg+zRRunyCOZEJtqUtxAV7aEzkeuiimDkDVTD8s1N/T9AVVfcu
         ZKoBR5zXSIvJZ2JIo/R2+DR5oTvV0/L9XzKUlEb5jX9SCauc267Ovw8quhwNhbHCnBZ1
         8EWK7u4/h6p/P9crBvmOAbjQYbSrYrxaz/Jn0hJ/1Wx9uKiQKBukAv/SHkV2N833Rknz
         lSnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680707889;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=idFXVwnEQw2AeckpahKfXswn5+/Jk4JVx854v+ndXlM=;
        b=Gv+zQmyAOIUpEWFrvDreVJYACQ3mnPfREqOa2qwi/8peZfl7F6N0zWGhxUt4hiPbqz
         E8WyPXeOeG9UL2z0KWW+LO2/LOuGOoY0VMS4SfHTYuBzGZkrqwAHcMzxWeUNFGAeHAho
         mYYPcjxaURctqmc7w/C9jRk2PPI81vF1lRYbGeyFYvE4XjKEYZkYs0VGLwYbHHzdMZou
         6KNqGRwEFbldh9zJzUZE2lY86yo1N1tfUUSaUvCuWNTD8JB2O5BdENEfnE25CaxG/PLV
         YsD9UJH07iTja9I7tKixJkNVQtpy/FWbRNUvCFwJFQf/dq1Ot3m05AZUlKRL8t+y8E7b
         oP3g==
X-Gm-Message-State: AAQBX9d6W2sNPFXMOdnDg+t2uoegybI8fAH+txy38VpU/fXUdb+1/ofe
        WBKp2nuoE4isSOOsZrpG0LPpqw==
X-Google-Smtp-Source: AKy350Z6S5WSad5iHIzjt49TqgYs41yzdYlN/8d2eI12bwZ9Xb+YKGePa0vAg6iMH5JR4Z/F8GyAAQ==
X-Received: by 2002:a7b:c38b:0:b0:3ed:8bef:6a04 with SMTP id s11-20020a7bc38b000000b003ed8bef6a04mr5244487wmj.27.1680707889387;
        Wed, 05 Apr 2023 08:18:09 -0700 (PDT)
Received: from [192.168.69.115] (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id i42-20020a05600c4b2a00b003f0321c22basm2461375wmp.12.2023.04.05.08.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 08:18:09 -0700 (PDT)
Message-ID: <b84ecc42-4201-d714-364a-6a55682cbce7@linaro.org>
Date:   Wed, 5 Apr 2023 17:18:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH 09/14] accel: Allocate NVMM vCPU using g_try_FOO()
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Reinoud Zandijk <reinoud@netbsd.org>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-10-philmd@linaro.org> <874jpul9d1.fsf@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <874jpul9d1.fsf@linaro.org>
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

On 5/4/23 15:55, Alex Bennée wrote:
> 
> Philippe Mathieu-Daudé <philmd@linaro.org> writes:
> 
>> g_malloc0() can not fail. Use g_try_malloc0() instead.
>>
>> https://developer-old.gnome.org/glib/stable/glib-Memory-Allocation.html#glib-Memory-Allocation.description
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   target/i386/nvmm/nvmm-all.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
>> index 3c7bdd560f..45fd318d23 100644
>> --- a/target/i386/nvmm/nvmm-all.c
>> +++ b/target/i386/nvmm/nvmm-all.c
>> @@ -942,7 +942,7 @@ nvmm_init_vcpu(CPUState *cpu)
>>           }
>>       }
>>   
>> -    qcpu = g_malloc0(sizeof(*qcpu));
>> +    qcpu = g_try_malloc0(sizeof(*qcpu));
>>       if (qcpu == NULL) {
>>           error_report("NVMM: Failed to allocate VCPU context.");
>>           return -ENOMEM;
> 
> Why - if we fail to allocate the vCPU context its game over anyway any
> established QEMU practice is its ok to assert fail on a malloc when
> there isn't enough memory. IOW keep the g_malloc0 and remove the error
> handling case.

This was my first approach but then I realized the author took care
to warn / return ENOMEM, so I went for _try_; but you are right,
since this is "game over" let's simply remove the check.

