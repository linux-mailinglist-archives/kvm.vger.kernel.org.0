Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E98E560B5E
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 23:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiF2VGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 17:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiF2VG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 17:06:27 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E429126116
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 14:06:26 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id n12-20020a9d64cc000000b00616ebd87fc4so4268169otl.7
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 14:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OolVUkIIOVZdzicRTGG0zD6QG6ARP9wLsdvwwKNda0A=;
        b=AKQjsmRhfRlQJo258TAkTomYKtXbmOHO37Mc51mc9Bk2Ny5X9zfUtpa11mh+awdn1v
         JmKiLHfwXuV3FVlqI5ziRn/mxB4ErkfMAkKSnuKrE6LQub9za/n8nWKoKKSGKpUvE+GA
         9Qr0fWVNHCrjIzFpoXRZpdSYhyAgQeJAhiwVSQLELfED87IyjQvCawS1YRjJX0rNSW9t
         2T6Wokj/a4E7TRI+GmdcRrrRfilReyA3LIQYyy+/rGcej37KeXQdtGd4OqriEGE0WLeO
         9HQNv+TdOMFapDzDHUFKkRz7K+jYPOf3dgh7oXhfevdlaIDkZSJI3ya1LtWvQ3Aiulbz
         QEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OolVUkIIOVZdzicRTGG0zD6QG6ARP9wLsdvwwKNda0A=;
        b=0U1IGBzvFpbnJK6Lm2H7QKwApbyOnOyZlEqSYbi2oy1qCdCLMXonK5ysiawSDHyrx7
         h41nACn1YrCaeIj6hlQNRV6U7eKNYpFWfJJM5wUwbK12tzXaZb1P20AiJwGys/hLEwFc
         AfllELXM6nygip674H0y6FzOliC63gh5edXVDi2YdGSEo/B6zqRmV/Cd++RV89o6zTB3
         0B6LPPNLIU43hU0yRYbf9oSvuxaNDgn8roXDrFo2EEksfKS3eNEc9ValCuJNp3bBMkIo
         s7fbRUSLEZZiN4oAPiub4JlACAL8xpxn/3cKLvlIun/tLSe9G0mcBhhjEMJ59tqoa2NS
         x2zw==
X-Gm-Message-State: AJIora9SpS0n9cQNsm7gwB8yec0AC2kXdk/hFTGik+E0KoxuqVPP6I1j
        AMIaejRSNIUXShAfKPqy+f0=
X-Google-Smtp-Source: AGRyM1t6y7jZaB5nsog53Nk30RjHzPIqemOUu6bx1YU4um73aQ+oL6MuwA/amqpYRQDc8gG9dBmcxg==
X-Received: by 2002:a05:6830:6306:b0:614:c6db:9d3e with SMTP id cg6-20020a056830630600b00614c6db9d3emr2374154otb.60.1656536786173;
        Wed, 29 Jun 2022 14:06:26 -0700 (PDT)
Received: from [192.168.10.102] ([191.193.1.105])
        by smtp.gmail.com with ESMTPSA id ek34-20020a056870f62200b000f28a948dd2sm11426396oab.21.2022.06.29.14.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 14:06:25 -0700 (PDT)
Message-ID: <83b5e16f-0146-587f-6e09-bd205a317d6c@gmail.com>
Date:   Wed, 29 Jun 2022 18:06:21 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] target/ppc: Add error reporting when opening file fails
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>,
        jianchunfu <jianchunfu@cmss.chinamobile.com>
Cc:     clg@kaod.org, david@gibson.dropbear.id.au, groug@kaod.org,
        pbonzini@redhat.com, qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
References: <20220629031552.5407-1-jianchunfu@cmss.chinamobile.com>
 <87a69wrp0v.fsf@pond.sub.org>
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <87a69wrp0v.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/29/22 02:56, Markus Armbruster wrote:
> jianchunfu <jianchunfu@cmss.chinamobile.com> writes:
> 
>> Add error reporting before return when opening file fails.
>>
>> Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
>> ---
>>   target/ppc/kvm.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
>> index dc93b99189..ef9a871411 100644
>> --- a/target/ppc/kvm.c
>> +++ b/target/ppc/kvm.c
>> @@ -1798,6 +1798,7 @@ static int read_cpuinfo(const char *field, char *value, int len)
>>   
>     static int read_cpuinfo(const char *field, char *value, int len)
>     {
>         FILE *f;
>         int ret = -1;
>         int field_len = strlen(field);
>         char line[512];
> 
>>       f = fopen("/proc/cpuinfo", "r");
>>       if (!f) {
>> +        fprintf(stderr, "Error opening /proc/cpuinfo: %s\n", strerror(errno));
>>           return -1;
>>       }
> 
>         do {
>             if (!fgets(line, sizeof(line), f)) {
>                 break;
>             }
>             if (!strncmp(line, field, field_len)) {
>                 pstrcpy(value, len, line);
>                 ret = 0;
>                 break;
>             }
>         } while (*line);
> 
>         fclose(f);
> 
>         return ret;
>     }
> 
> This function now reports an error on one out of two failures.  The
> caller can't tell whether it reported or not.
> 
> Please use error_report() for errors, warn_report() for warnings, and
> info_report() for informational messages.
> 
> But is it an error?  Here's the only caller:
> 
>      static uint32_t kvmppc_get_tbfreq_procfs(void)
>      {
>          char line[512];
>          char *ns;
>          uint32_t tbfreq_fallback = NANOSECONDS_PER_SECOND;
>          uint32_t tbfreq_procfs;
> 
>          if (read_cpuinfo("timebase", line, sizeof(line))) {
> --->        return tbfreq_fallback;
>          }
> 
>          ns = strchr(line, ':');
>          if (!ns) {
> --->        return tbfreq_fallback;
>          }
> 
>          tbfreq_procfs = atoi(++ns);
> 
>          /* 0 is certainly not acceptable by the guest, return fallback value */
> --->    return tbfreq_procfs ? tbfreq_procfs : tbfreq_fallback;
>      }
> 
> I marked the three spots that handle errors.  All quietly return
> NANOSECONDS_PER_SECOND.  The caller can't tell whether that happened.
> 
> Reporting an error when we don't actually fail is confusing.  Better
> would be something like "Can't open /proc/cpuinfo, assuming timebase X",
> where X is the value you assume.
> 
> Reporting this only in one out of several cases where we assume feels
> wrong.  If it's worth reporting in one case, why isn't it worth
> reporting in the other cases?  Is it worth reporting?
> 
> Aside: the use of atoi() silently maps a timebase of 0 to
> NANOSECONDS_PER_SECOND.  Not fond of this function.  Not your patch's
> problem, of course.
> 
>>   
>> @@ -1906,6 +1907,7 @@ static uint64_t kvmppc_read_int_dt(const char *filename)
>>   
>>       f = fopen(filename, "rb");
>>       if (!f) {
>> +        fprintf(stderr, "Error opening %s: %s\n", filename, strerror(errno));
>>           return -1;
>>       }
> 
> Preexisting: this function returns -1 when fopen() fails, 0 when fread()
> fails or read less data than expected.  Its caller
> kvmppc_read_int_cpu_dt() passes on the return value.  However, it is
> documented to return "0 if anything goes wrong".  Bug.  Not your patch's
> fault, but it needs fixing.

It does needs fixing , but it'll require some work because this code is
called in a lot of places. I'll hand this part personally because it's less
trivial than the error you reported above with read_cpuinfo() and
kvmppc_get_tbfreq_procfs().


I'll apply the relevant bits of jianchunfu's patch in the cleanup as well.


Thanks,


Daniel

> 
> Similar issue as above: you make the function emit an error message on
> some, but not all failures.  If it's worth reporting in one case, why
> isn't it worth reporting in the other cases?  Is it worth reporting?
> 
