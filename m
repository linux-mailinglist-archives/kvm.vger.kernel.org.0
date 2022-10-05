Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F155F5545
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 15:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiJENZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 09:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJENZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 09:25:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A0540BFA
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 06:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664976309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWyVMsTufL8O0yq+tGXghGy9lXFaSPuhUB/xxLeZGik=;
        b=DI6s/5y7F1j/nubnbSL1SFN5YmCtBiSf3eQXy6CF5iUG9/lRQTtgR1X6pjHVwuU9n+ry63
        2p6YipLTdX+ELIBpU71pr/Mvzi2ZBg8271iOcSwLxnT9hAiOYFijbCP5ao6Gs9vY9bT6P6
        RtShqMGEpNnM43PsMcb7JsSB3wBwyYY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-42-s0XxBpndMMOoZfB2_B0dMw-1; Wed, 05 Oct 2022 09:25:07 -0400
X-MC-Unique: s0XxBpndMMOoZfB2_B0dMw-1
Received: by mail-wm1-f71.google.com with SMTP id f25-20020a7bc8d9000000b003b4768dcd9cso385344wml.9
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 06:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=KWyVMsTufL8O0yq+tGXghGy9lXFaSPuhUB/xxLeZGik=;
        b=3NhG9wgTAxgu6BJTaDJxJJfv1oUFcknhMjBJcUgyNvErGQRiO5q25SkT9NH4ogBiFD
         ctHyH32pZLW96Mmas5CxP+uCc37/pJvcgMsUT+gtnWRMBhKH2bbj3vV3MUUkLtS7CP8Q
         xlK+6kll0c1mUtNGqe2jomW6NZqmgi9gVaFNxZ9AQA7mJhuqosTuFuetVjfBvXH3R8BD
         ixEjfiyQO6LjsUbO7wdUFIZPARIluJbGowcVbSp0ROQKMmrnvnt/8/B7JF9hBkAuYGix
         Qn3uieI71h+JKzik4CY7u8+vwFZtxtmxt+nmr8yM7BJrK4E+3msUlSh0eG8zxuevgtqT
         X4Uw==
X-Gm-Message-State: ACrzQf1BXhDXEtIxBPjjiXUonkzD1q2k5Rti5Ci5taipVXsOojWDxHgX
        kVmW52j/NSYggyV4lHpaIaafZPlHr7nne/5urGM0aUe7RZ5PHQi1vUcTB1wIlBveADZW4D9kiv1
        VtdLOEBrUNDEc
X-Received: by 2002:a05:6000:188c:b0:22b:5c7:a21c with SMTP id a12-20020a056000188c00b0022b05c7a21cmr19662809wri.59.1664976305977;
        Wed, 05 Oct 2022 06:25:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4lMTJsKio2Ns8v1dhauCter28KF2qG0Un8dJ3dZxxZ7CpA6mnqHAd0oJ014sVWxVLS5xd/WQ==
X-Received: by 2002:a05:6000:188c:b0:22b:5c7:a21c with SMTP id a12-20020a056000188c00b0022b05c7a21cmr19662791wri.59.1664976305651;
        Wed, 05 Oct 2022 06:25:05 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-177-249.web.vodafone.de. [109.43.177.249])
        by smtp.gmail.com with ESMTPSA id m7-20020a05600c3b0700b003a1980d55c4sm2171072wms.47.2022.10.05.06.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 06:25:05 -0700 (PDT)
Message-ID: <9314c772-c2d0-2b3a-dc8c-b4294f830938@redhat.com>
Date:   Wed, 5 Oct 2022 15:25:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests GIT PULL 02/28] s390x: add test for SIGP
 STORE_ADTL_STATUS order
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
 <20220512093523.36132-3-imbrenda@linux.ibm.com>
 <f7b8977e-7cf3-f422-77fa-808d9049ffeb@redhat.com>
 <166497590219.75085.13496829953913366119@t14-nrb>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <166497590219.75085.13496829953913366119@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/2022 15.18, Nico Boehr wrote:
> Hi Thomas,
> 
> Quoting Thomas Huth (2022-09-20 17:53:28)
>> On 12/05/2022 11.34, Claudio Imbrenda wrote:
>> [...]
>>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>>> index 743013b2..256c7169 100644
>>> --- a/s390x/unittests.cfg
>>> +++ b/s390x/unittests.cfg
>>> @@ -146,3 +146,28 @@ extra_params = -device virtio-net-ccw
>>>    
>>>    [tprot]
>>>    file = tprot.elf
>>> +
>>> +[adtl-status-kvm]
>>> +file = adtl-status.elf
>>> +smp = 2
>>> +accel = kvm
>>> +extra_params = -cpu host,gs=on,vx=on
>>
>> FWIW, on my z13 LPAR, I now see a warning:
>>
>> SKIP adtl-status-kvm (qemu-kvm: can't apply global host-s390x-cpu.gs=on:
>> Feature 'gs' is not available for CPU model 'z13.2', it was introduced with
>> later models.)
>>
>> Could we silence that somehow?
> 
> instead of a SKIP, what would you expect to see in this case? Or do you mean the message inside the parenthesis?

I meant the message inside the parenthesis ... but thinking about it twice, 
it's maybe even useful to have it here ... so I'm also fine if we keep it. 
... it's just a little bit long ...

  Thomas


