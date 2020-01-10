Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC99136A09
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 10:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgAJJeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 04:34:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39240 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726759AbgAJJeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 04:34:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578648857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ukap/D6uM+tm5XLlP0CcTaHbFa/qulLkLeaGy/Fleuc=;
        b=MqI4v4Xw37QgD+tuGZFlmKk36cRNwKLvz6bJ3mDxz3rSwa75W7r7mVjNweT4nPWWtCMLbp
        khpKhjR5CJGw79uDG5DFusnDXH2O7StwuhiDVcC96LtdszIBBFPynfFCsavsKYPS+N8OOB
        zZS7V8hYJ76EJrYT2VLzCUIyXj+fHpU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-DYuQw0mEPhW5MF6e64jnGQ-1; Fri, 10 Jan 2020 04:34:16 -0500
X-MC-Unique: DYuQw0mEPhW5MF6e64jnGQ-1
Received: by mail-wr1-f69.google.com with SMTP id y7so654307wrm.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 01:34:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ukap/D6uM+tm5XLlP0CcTaHbFa/qulLkLeaGy/Fleuc=;
        b=g9ugIFQB+rbQXCpWXnoD2LYvjwhs/o18Jjt2vgxZicw1C0dqtHMixEBUK5olWnlKU9
         ow29bDqQxSu25CES1yYg6aWR7m/QMfHzl8d3fiKZRNdbNQpGhRi95Xj530pjM1RsMoPA
         ukxk8ni9e0w2TPf1AWB37VE/sGWVAXrDOEuZbyExo79W2/9Tv9FQsyPRTJpsWRkUMfgY
         tgncmwiT+8rNJ2SgW6dPLCE3vUIIqm4FCytMbtd8DDI5BmAMCO4OuAJGKJkp00y9kta8
         mvfo2NaWe5BZLIOCLSrHq4JQFQRtoxA6Rhns1YfBgq0FBobL4Y6ZW9L7Mvr5yYfV962y
         m6hw==
X-Gm-Message-State: APjAAAUR91qVkyHEjis1ERXkmcI1W/R5za2bTVfgoO8H4No8gVR5wfky
        CtxaNaXioeOhLm3wj+c3rdV3I933u/nnPgAWUtZ7XdjWPjWsmtwTvBEXNTMpV/yVlvByf6D261n
        yihpmrNr3cZHq
X-Received: by 2002:adf:f789:: with SMTP id q9mr2461809wrp.103.1578648855096;
        Fri, 10 Jan 2020 01:34:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqw60eNDeSeLZaK+zXZdsmOGqFEjjGKDrKCuXrKR/uyM92hpU/dvYO081Du7NvMHfdLGnlYFEA==
X-Received: by 2002:adf:f789:: with SMTP id q9mr2461773wrp.103.1578648854833;
        Fri, 10 Jan 2020 01:34:14 -0800 (PST)
Received: from [10.101.1.81] ([176.12.107.132])
        by smtp.gmail.com with ESMTPSA id v3sm1510233wru.32.2020.01.10.01.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 01:34:14 -0800 (PST)
Subject: Re: [PATCH 04/15] hw/ppc/spapr_rtas: Restrict variables scope to
 single switch case
To:     Greg Kurz <groug@kaod.org>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>, qemu-ppc@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm@nongnu.org, Alistair Francis <alistair.francis@wdc.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>,
        Eric Blake <eblake@redhat.com>
References: <20200109152133.23649-1-philmd@redhat.com>
 <20200109152133.23649-5-philmd@redhat.com>
 <20200109184349.1aefa074@bahia.lan>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <9870f8ed-3fa0-1deb-860d-7481cb3db556@redhat.com>
Date:   Fri, 10 Jan 2020 10:34:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200109184349.1aefa074@bahia.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/20 6:43 PM, Greg Kurz wrote:
> On Thu,  9 Jan 2020 16:21:22 +0100
> Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
> 
>> We only access these variables in RTAS_SYSPARM_SPLPAR_CHARACTERISTICS
>> case, restrict their scope to avoid unnecessary initialization.
>>
> 
> I guess a decent compiler can be smart enough detect that the initialization
> isn't needed outside of the RTAS_SYSPARM_SPLPAR_CHARACTERISTICS branch...
> Anyway, reducing scope isn't bad. The only hitch I could see is that some
> people do prefer to have all variables declared upfront, but there's a nested
> param_val variable already so I guess it's okay.

I don't want to outsmart compilers :)

The MACHINE() macro is not a simple cast, it does object introspection 
with OBJECT_CHECK(), thus is not free. Since 
object_dynamic_cast_assert() argument is not const, I'm not sure the 
compiler can remove the call.

Richard, Eric, do you know?

>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   hw/ppc/spapr_rtas.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/ppc/spapr_rtas.c b/hw/ppc/spapr_rtas.c
>> index 6f06e9d7fe..7237e5ebf2 100644
>> --- a/hw/ppc/spapr_rtas.c
>> +++ b/hw/ppc/spapr_rtas.c
>> @@ -267,8 +267,6 @@ static void rtas_ibm_get_system_parameter(PowerPCCPU *cpu,
>>                                             uint32_t nret, target_ulong rets)
>>   {
>>       PowerPCCPUClass *pcc = POWERPC_CPU_GET_CLASS(cpu);
>> -    MachineState *ms = MACHINE(spapr);
>> -    unsigned int max_cpus = ms->smp.max_cpus;
>>       target_ulong parameter = rtas_ld(args, 0);
>>       target_ulong buffer = rtas_ld(args, 1);
>>       target_ulong length = rtas_ld(args, 2);
>> @@ -276,6 +274,8 @@ static void rtas_ibm_get_system_parameter(PowerPCCPU *cpu,
>>   
>>       switch (parameter) {
>>       case RTAS_SYSPARM_SPLPAR_CHARACTERISTICS: {
>> +        MachineState *ms = MACHINE(spapr);
>> +        unsigned int max_cpus = ms->smp.max_cpus;
> 
> The max_cpus variable used to be a global. Now that it got moved
> below ms->smp, I'm not sure it's worth keeping it IMHO. What about
> dropping it completely and do:
> 
>          char *param_val = g_strdup_printf("MaxEntCap=%d,"
>                                            "DesMem=%" PRIu64 ","
>                                            "DesProcs=%d,"
>                                            "MaxPlatProcs=%d",
>                                            ms->smp.max_cpus,
>                                            current_machine->ram_size / MiB,
>                                            ms->smp.cpus,
>                                            ms->smp.max_cpus);

OK, good idea.

> And maybe insert an empty line between the declaration of param_val
> and the code for a better readability ?
> 
>>           char *param_val = g_strdup_printf("MaxEntCap=%d,"
>>                                             "DesMem=%" PRIu64 ","
>>                                             "DesProcs=%d,"
> 

