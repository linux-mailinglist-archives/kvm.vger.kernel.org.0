Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DBB2FA868
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407232AbhARSLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:11:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407196AbhARRzH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:55:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610992421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAzmdrlrImmsnp3Yfb2oPgysXp3GAdtPiDt2zXuCZAo=;
        b=N/HgHX0fuygbG9KkqkKJmW+BqljmQyk11zpndq54Pou5r8HxW2lO7RQmtlxHK/siR8yUG5
        +iaYBuAU0bnRwxQsd1cGpyMGgR/wq3juxcM77AEemGC6rvJiDi90iSpc7pLk3Qg8U2sd/a
        UY3yt/o8T4jCsLOeGJgNy8fUpUbxHQ8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-Qp0TSh7XMD-Zbvi0aiET2Q-1; Mon, 18 Jan 2021 12:53:39 -0500
X-MC-Unique: Qp0TSh7XMD-Zbvi0aiET2Q-1
Received: by mail-ej1-f71.google.com with SMTP id f1so2012437ejq.20
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 09:53:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qAzmdrlrImmsnp3Yfb2oPgysXp3GAdtPiDt2zXuCZAo=;
        b=lW3P3QnrTl5/GUJleLSF2Fq8NT3GQd30fZRlIVLtHyqEvEwPEsthTRd1OmtJQi/Puw
         eDb0/ghFH9B85XjH0wyJFfPP4O8OfIYNh8r6vBvhVT0qEGgvbZhqbLaGG33guKA0Xn6v
         y9OasEWnKTPDWvwbI6gpZU2SDXlP27QwnpbxTst9X12SAlhTuwQpT/qa8xAFurfow9Sk
         3D/MXMOyC2Y+SnbLoDWnK8K53IU2JrRzwqeimH4JOCysYnNDYUGcCsGSdwSxACp9vr1w
         uBBbpP3yjWWvV4OuoI/lHTrbTc+AIrMtPx8ku0Ujw2QXC31OQps1apa6qSlVZAe8DeCh
         Jgig==
X-Gm-Message-State: AOAM532yRrVSFK+Bln8d44HHy3ty+ReMQQg7RRMJyZaGUvvSckqP35aM
        PRZXoOsZ6I+QsM3M2U+JOcBzcLl0/ETYkXXCbtJlagzs3ZJSvfHgO3LI/E9TZDFbPM4o8eqTPC8
        rMxcG9Ut/COMIxf126O1xhnSep5Vqos/C4BFLQtSVK48odDYJvBlG4M+NQhJstYtK
X-Received: by 2002:a50:d50a:: with SMTP id u10mr497234edi.58.1610992417769;
        Mon, 18 Jan 2021 09:53:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRCAb76RlZjORShXEiZPRbk6vcnz3j0QtGQjTaMP5+QIxE5mYWI20/+LlwaXEeB8dy0PvfnA==
X-Received: by 2002:a50:d50a:: with SMTP id u10mr497224edi.58.1610992417593;
        Mon, 18 Jan 2021 09:53:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h12sm10063700ejx.81.2021.01.18.09.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:53:36 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] fix a arrayIndexOutOfBounds in function
 init_apic_map, online_cpus[i / 8] when i in 248...254.
To:     Thomas Huth <thuth@redhat.com>,
        Xinpeng Liu <liuxp11@chinatelecom.cn>, kvm@vger.kernel.org
References: <1608642049-21007-1-git-send-email-liuxp11@chinatelecom.cn>
 <247c12f5-ba85-e24d-3747-ba561db96551@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <39cc0877-16be-4e56-c083-1f2636cd5b5b@redhat.com>
Date:   Mon, 18 Jan 2021 18:53:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <247c12f5-ba85-e24d-3747-ba561db96551@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/21 18:42, Thomas Huth wrote:
> On 22/12/2020 14.00, Xinpeng Liu wrote:
>> refer to x86/cstart64.S:online_cpus:.fill (max_cpus + 7) / 8, 1, 0
>>
>> Signed-off-by: Xinpeng Liu <liuxp11@chinatelecom.cn>
>> ---
>>   lib/x86/apic.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
>> index f43e9ef..da8f301 100644
>> --- a/lib/x86/apic.c
>> +++ b/lib/x86/apic.c
>> @@ -232,7 +232,7 @@ void mask_pic_interrupts(void)
>>       outb(0xff, 0xa1);
>>   }
>> -extern unsigned char online_cpus[MAX_TEST_CPUS / 8];
>> +extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];
> 
> According to apic-defs.h, MAX_TEST_CPUS is set to 255, so this makes 
> sense, indeed!
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Queued, thanks.

Paolo

