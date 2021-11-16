Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833DC4535CF
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbhKPPcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:32:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237556AbhKPPci (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 10:32:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637076580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VaQqHG4/jga1XO3GfECxH0/laMbbGhPQ9AIJYdWkGvk=;
        b=Vb4CqqLKVFXA+1zkJ/67WWik6/Q/XLlUdOe5li1c2v3h9NRGDRTbWVFPp9KIOmsMC6MXMk
        ng8NYR8Q0IivQM+V41wv9bfwwij8Mb+0XctwxeYW6Hj806dIIBMTklwkinQPPR3vdHNR53
        r8x/ZLoTSLcFv11QV+8Z6wQWhc/WtkU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-KesP4sxkN9OM_-rOEtp4gQ-1; Tue, 16 Nov 2021 10:29:37 -0500
X-MC-Unique: KesP4sxkN9OM_-rOEtp4gQ-1
Received: by mail-qt1-f197.google.com with SMTP id v19-20020ac85793000000b002b19184b2bfso11809681qta.14
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 07:29:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VaQqHG4/jga1XO3GfECxH0/laMbbGhPQ9AIJYdWkGvk=;
        b=5QhebRPdat1BsKTLGp3CN20/7bKHL/VQCWXCSK0Kusp7EBbLMRJQB8xzs7hGk0tKfC
         6IVbXedBaRCQFMCYyLJ8Xbz9LO4vtI320kYp/+KDSgp58uTMoV0v8miy5OSBwVF/TFx3
         QPds/KZ7QXbFm6dUSX0mTVkYxZRR/S7Wj4YAYdq4OO8XVyi81tVlAmkWOP8X/6VLcRIv
         CSShj89Y6lHUhIFTOdA5sbCzgru12s+gVM07UdukP9z5wiCWEQYwoDjvYjr6RP1+qCWS
         QrIzZjshMgW/kM2lRW1L7nZIZ9tBnYI1WAVKAoVWWYUja7hmixumPBNMMurF4tmr7JLP
         X6kw==
X-Gm-Message-State: AOAM532DMuLQ+mlrpFTgfwpIiVE/nlNhOpe3zR7L9RepUawwdlXADMR+
        mJkFgYO6OeG1r2O14jY7jxDmq1j+WK1czZ9NcaojUNX5iSmRePRrRfC3uv4KnASms2L7SAWLfSH
        9UhG84GlJMtVW
X-Received: by 2002:a37:a353:: with SMTP id m80mr6964587qke.7.1637076576595;
        Tue, 16 Nov 2021 07:29:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwITglvPi2d6ptA7qlv7UsEsQHhpmbjP5wd37vrspPDXa7c4jDqjxj4mcPzI9zJn+gnj3xYZA==
X-Received: by 2002:a37:a353:: with SMTP id m80mr6964563qke.7.1637076576339;
        Tue, 16 Nov 2021 07:29:36 -0800 (PST)
Received: from [192.168.1.234] (pool-71-175-3-221.phlapa.fios.verizon.net. [71.175.3.221])
        by smtp.gmail.com with ESMTPSA id t15sm9279843qta.45.2021.11.16.07.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 07:29:35 -0800 (PST)
Message-ID: <26204690-493f-67a8-1791-c9c9d38c0240@redhat.com>
Date:   Tue, 16 Nov 2021 10:29:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] sev: allow capabilities to check for SEV-ES support
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        armbru@redhat.com, pbonzini@redhat.com, eblake@redhat.com
References: <20211115193804.294529-1-tfanelli@redhat.com>
 <YZN3OECfHBXd55M5@redhat.com>
From:   Tyler Fanelli <tfanelli@redhat.com>
In-Reply-To: <YZN3OECfHBXd55M5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 4:17 AM, Daniel P. Berrangé wrote:
> On Mon, Nov 15, 2021 at 02:38:04PM -0500, Tyler Fanelli wrote:
>> Probe for SEV-ES and SEV-SNP capabilities to distinguish between Rome,
>> Naples, and Milan processors. Use the CPUID function to probe if a
>> processor is capable of running SEV-ES or SEV-SNP, rather than if it
>> actually is running SEV-ES or SEV-SNP.
>>
>> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
>> ---
>>   qapi/misc-target.json | 11 +++++++++--
>>   target/i386/sev.c     |  6 ++++--
>>   2 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
>> index 5aa2b95b7d..c3e9bce12b 100644
>> --- a/qapi/misc-target.json
>> +++ b/qapi/misc-target.json
>> @@ -182,13 +182,19 @@
>>   # @reduced-phys-bits: Number of physical Address bit reduction when SEV is
>>   #                     enabled
>>   #
>> +# @es: SEV-ES capability of the machine.
>> +#
>> +# @snp: SEV-SNP capability of the machine.
>> +#
>>   # Since: 2.12
>>   ##
>>   { 'struct': 'SevCapability',
>>     'data': { 'pdh': 'str',
>>               'cert-chain': 'str',
>>               'cbitpos': 'int',
>> -            'reduced-phys-bits': 'int'},
>> +            'reduced-phys-bits': 'int',
>> +            'es': 'bool',
>> +            'snp': 'bool'},
>>     'if': 'TARGET_I386' }
>>   
>>   ##
>> @@ -205,7 +211,8 @@
>>   #
>>   # -> { "execute": "query-sev-capabilities" }
>>   # <- { "return": { "pdh": "8CCDD8DDD", "cert-chain": "888CCCDDDEE",
>> -#                  "cbitpos": 47, "reduced-phys-bits": 5}}
>> +#                  "cbitpos": 47, "reduced-phys-bits": 5
>> +#                  "es": false, "snp": false}}
> We've previously had patches posted to support SNP in QEMU
>
>    https://lists.gnu.org/archive/html/qemu-devel/2021-08/msg04761.html
>
> and this included an update to query-sev for reporting info
> about the VM instance.
>
> Your patch is updating query-sev-capabilities, which is a
> counterpart for detecting host capabilities separate from
> a guest instance.

Yes, that's because with this patch, I'm more interested in determining 
which AMD processor is running on a host, and less if ES or SNP is 
actually running on a guest instance or not.

>
> None the less I wonder if the same design questions from
> query-sev apply. ie do we need to have the ability to
> report any SNP specific information fields, if so we need
> to use a discriminated union of structs, not just bool
> flags.
>
> More generally I'm some what wary of adding this to
> query-sev-capabilities at all, unless it is part of the
> main SEV-SNP series.
>
> Also what's the intended usage for the mgmt app from just
> having these boolean fields ? Are they other more explicit
> feature flags we should be reporting, instead of what are
> essentially SEV generation codenames.

If by "mgmt app" you're referring to sevctl, in order to determine which 
certificate chain to use (Naples vs Rome vs Milan ARK/ASK) we must query 
which processor we are running on. Although sevctl has a feature which 
can do this already, we cannot guarantee that sevctl is running on the 
same host that a VM is running on, so we must query this capability from 
QEMU. My logic was determining the processor would have been the following:

!es && !snp --> Naples

es && !snp --> Rome

es && snp --> Milan

>
>
> Regards,
> Daniel

Tyler.

-- 
Tyler Fanelli (tfanelli)

