Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5DA2640EB
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgIJJIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:08:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32238 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbgIJJIJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 05:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599728887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MPFIhvjjZZMrZtxtj2VIAvzFKsc4panpciSld1za2uc=;
        b=A55aU+iyHWubZqR4rg1Ax4psvMWLYyrjw34qNdrEudJWCQvu0F+EN4ErELGjcQHXntTT50
        mFvyFy/GTBPKW8m4Ank80rzBD/nXitVwu9li8fKW/j3qUCt1xMDpPc/EPLVVLMETS+Y9Mz
        xBffUUTJFosluo5rx/uO9JHWDoGPKbo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-NZLi8m6IONqERAgKCCFQjA-1; Thu, 10 Sep 2020 05:08:02 -0400
X-MC-Unique: NZLi8m6IONqERAgKCCFQjA-1
Received: by mail-ej1-f71.google.com with SMTP id gt18so2453875ejb.16
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 02:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MPFIhvjjZZMrZtxtj2VIAvzFKsc4panpciSld1za2uc=;
        b=cD7NYjaHlEE4XXqhmY7zjsXs87VXS7aAqokwW2WLNS03tPpozPhriAzywnMO9hDZO8
         Typ4Is4ET0gHT5jDpozr4DQu6qDStdqOBdJi+6DFAMqQU/sI+gh6inrCbgSlKABO4FLy
         B1KLjrmLnz9ATdNcdmU/s2ZV7aofNgNLEgM1AIJYzW04uJ0/hAlP8/znDQ4yFrfM1+u5
         VKp8TorAw1eohLY9iQJQpQx62KDioCOxSzIsC/RoBcI7whnkS4s1F5IC+a7dKyiSbdkh
         rfiIAsquuPAesGGo4Sh0b0HnEDOgPI4I8ihEOrPDSd32bk2gAYD+oImTQmPzgMfjYJh0
         VofA==
X-Gm-Message-State: AOAM530qFUugCNGJ/ABwLWpCy1vxrJdH1dh2fvg30R9u3QQdZbXfZM5A
        PhMTuTDpNRYpkm+IqwhnIV9moysBbxJloxeHIl11duwAF7KM/nBX60bM1TIc3YoyRm43wWJhNR8
        mEWPgzHNtUkR/
X-Received: by 2002:aa7:d15a:: with SMTP id r26mr8264328edo.181.1599728881628;
        Thu, 10 Sep 2020 02:08:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQY7ESTIgaZMy+kHSdTrJ7jizxujH24NZ0PRXz6BdORgw8v3h7QKACcLPwL7zPscN03XKOCg==
X-Received: by 2002:aa7:d15a:: with SMTP id r26mr8264297edo.181.1599728881331;
        Thu, 10 Sep 2020 02:08:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2744:1c91:fa55:fa01? ([2001:b07:6468:f312:2744:1c91:fa55:fa01])
        by smtp.gmail.com with ESMTPSA id lr14sm6284398ejb.0.2020.09.10.02.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:08:00 -0700 (PDT)
Subject: Re: [PATCH 6/6] target/i386/kvm: Rename host_tsx_blacklisted() as
 host_tsx_broken()
To:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-7-philmd@redhat.com>
 <118a4cae-f220-8224-52ac-26a1795ac071@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cfc1c6be-8569-4150-6deb-136f930285ee@redhat.com>
Date:   Thu, 10 Sep 2020 11:08:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <118a4cae-f220-8224-52ac-26a1795ac071@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/20 09:08, Thomas Huth wrote:
> On 10/09/2020 09.01, Philippe Mathieu-Daudé wrote:
>> In order to use inclusive terminology, rename host_tsx_blacklisted()
>> as host_tsx_broken().
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  target/i386/kvm.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>> index 205b68bc0ce..3d640a8decf 100644
>> --- a/target/i386/kvm.c
>> +++ b/target/i386/kvm.c
>> @@ -302,7 +302,7 @@ static int get_para_features(KVMState *s)
>>      return features;
>>  }
>>  
>> -static bool host_tsx_blacklisted(void)
>> +static bool host_tsx_broken(void)
>>  {
>>      int family, model, stepping;\
>>      char vendor[CPUID_VENDOR_SZ + 1];
>> @@ -408,7 +408,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>>      } else if (function == 6 && reg == R_EAX) {
>>          ret |= CPUID_6_EAX_ARAT; /* safe to allow because of emulated APIC */
>>      } else if (function == 7 && index == 0 && reg == R_EBX) {
>> -        if (host_tsx_blacklisted()) {
>> +        if (host_tsx_broken()) {
>>              ret &= ~(CPUID_7_0_EBX_RTM | CPUID_7_0_EBX_HLE);
>>          }
>>      } else if (function == 7 && index == 0 && reg == R_EDX) {
>>
> 
> Looking at commit 40e80ee4113, the term "broken" seems to be a good
> replacement here.
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

