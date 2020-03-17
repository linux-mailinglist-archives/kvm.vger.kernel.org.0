Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44F8187BBE
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 10:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgCQJKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 05:10:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:32326 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbgCQJKB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 05:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584436200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33HOQxyjSNkaXfQU6fJkB48HoXWoJZs0ADNmqK4BWjc=;
        b=ijko8ir+vnw5ED1ytkTtyqsq2nbCs3mhBNarZxDGsQn8jbPKfhK93MlHIL2yViYFr2SU1q
        5wkSO40Q+LgETTNOx1Aox6LIz3wg9ouM7XHmXpJws652zLGkA7JXwmqAz2Akri0wcvSHHb
        doXPgvutT9u2nV8YvLWqeXmOeJ5fS6g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-YzM6GGyBMum4pz0QxLztsg-1; Tue, 17 Mar 2020 05:09:58 -0400
X-MC-Unique: YzM6GGyBMum4pz0QxLztsg-1
Received: by mail-wr1-f69.google.com with SMTP id v7so924289wrp.0
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 02:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=33HOQxyjSNkaXfQU6fJkB48HoXWoJZs0ADNmqK4BWjc=;
        b=R27kNZkUTOW1QDUdTn31/i1o3FPfoRndru9secaWGjoENYgjA5/WzjLpKfbh1UNa7h
         HW58Dv5n/HCD3ksPIfaC602gz0UsABQoQV0H34AnSOCpWqGAmro/hRrXwfqWdDFc8xsi
         DavzT8jtK/0psTyxVRE9RGWTTTEfkVkEFpDLh4FrbXzRHT9gisuW8qL8/sigWElItjcV
         ekNBxqBwtqh4XkPEosl3zjBp4+W4pfog/86kEOwGTmaartuLrvkGaKwd/QlmSZsxWRl/
         qCM0HeKC8NyE60sk37eywQ27pXuGCVGQgDLT9d0pJrbH5aqjecZXdMoNZ7aE9YkI0AKS
         FjZg==
X-Gm-Message-State: ANhLgQ2TetHuAjOv89mRaRP3BCGwWejgXuN7t8aTNavfKFx6/tXxyj+/
        b2WKQbwcMd8hmPPer6xuvsRuoBNkPhVI7dwDW+RVYxFcGvWLlF6W28y1baZrfRZLiv4bAG96RzN
        iY1tFntIPI0Zy
X-Received: by 2002:a7b:c552:: with SMTP id j18mr4165513wmk.42.1584436197474;
        Tue, 17 Mar 2020 02:09:57 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsVhMPn0HH0yjUz3wkQv8Y+81cQSZkbZuYdWOMMNo1uHPo3ZbzVny9ih/PRaMnKHtKR3ZdflA==
X-Received: by 2002:a7b:c552:: with SMTP id j18mr4165486wmk.42.1584436197243;
        Tue, 17 Mar 2020 02:09:57 -0700 (PDT)
Received: from [192.168.1.34] (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id s1sm3673452wrp.41.2020.03.17.02.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 02:09:56 -0700 (PDT)
Subject: Re: [PATCH v3 01/19] target/arm: Rename KVM set_feature() as
 kvm_set_feature()
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
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <3dc0e645-05a5-938c-4277-38014e4a68a3@redhat.com>
Date:   Tue, 17 Mar 2020 10:09:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cb3178f1-5a0c-b11c-a012-c41beeb66cd2@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:16 PM, Richard Henderson wrote:
> On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
>> +++ b/target/arm/kvm32.c
>> @@ -22,7 +22,7 @@
>>   #include "internals.h"
>>   #include "qemu/log.h"
>>   
>> -static inline void set_feature(uint64_t *features, int feature)
>> +static inline void kvm_set_feature(uint64_t *features, int feature)
> 
> Why, what's wrong with the existing name?
> Plus, with patch 2, you can just remove these.

The prototypes are different:

   void set_feature(uint64_t *features, int feature)

   void set_feature(CPUARMState *env, int feature)

Anyway you are right, I'll use the later prototype instead, thanks.

