Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECE445382B
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 17:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236714AbhKPRBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 12:01:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25487 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230103AbhKPRBM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 12:01:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637081895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/hd7T/jg4QlM/dTl0BZIXMVWjWWVvd+3iW1T4KK1VXw=;
        b=Lvn/eOC/n05D+2tuW4r60agirvG0Cs+cr04c8L3RAruSYZ19/zA7uqjmgjyl3K4Vdzfx0m
        jrUvFiQck1K3TBsoLj2eFaPXXvOBIbWtVUOFF+lZfgd71oYUeOOufmwcXBZx9oBbL3t6rj
        9pVs/k8HtYPx62sUwq30WznZJvjpiys=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-lBeQui7aNDuTwyl3l6th4g-1; Tue, 16 Nov 2021 11:58:13 -0500
X-MC-Unique: lBeQui7aNDuTwyl3l6th4g-1
Received: by mail-qt1-f198.google.com with SMTP id w12-20020ac80ecc000000b002a7a4cd22faso16149069qti.4
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 08:58:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/hd7T/jg4QlM/dTl0BZIXMVWjWWVvd+3iW1T4KK1VXw=;
        b=zDrQPEy2yCx6zbJX0S9VW75Qk2Fu4GoYvp9eV/KOdQLOsGIEGdooUk9me1pxtCzYvt
         o+MVeEdVHyuE1RfdPDm2mcHH0wcwiW9DzFDKuuhj2P+JeRyuSnr5eYO4XZf8dZEeIOyW
         pBgKu/7cpaNFrSZmKcXer4tCdZHEmtpIXX2+2zf3oHLi+X0onfdRjasbastTqMfPUBTP
         qqcFjpef9IDKVROE53Ws3H0UllrnR6owYuKHk6kH1UGAyGQpeVCh+mz9gXDcFJVuda91
         Yq/91tfKgMDg+G5jXZt8UB9HJltUZLsYsEMxa316GbAFcOEH/2b3gzST5qnRNNIirpIN
         3wdA==
X-Gm-Message-State: AOAM532eS27gI9kEnJyBQHi5L+zNkzPLSYXW59jVy2hFHloSlgRpwSxR
        PySUrW9gYykS98iWztI6p7a9tizQNdNpRMLeftDjyqKWf34dYOGgJEhTX3Skd/MrtkmAhIQGgV0
        Ey+KhMwAOY6Wa
X-Received: by 2002:a0c:fb47:: with SMTP id b7mr46465232qvq.12.1637081893392;
        Tue, 16 Nov 2021 08:58:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzueEXYTzxPyrkueqraDyRt6Tx3Us13LhsaiiPNJ+PDqKYtXEqpzduI5iGP/XakbjNymNsUyg==
X-Received: by 2002:a0c:fb47:: with SMTP id b7mr46465208qvq.12.1637081893200;
        Tue, 16 Nov 2021 08:58:13 -0800 (PST)
Received: from [192.168.1.234] (pool-71-175-3-221.phlapa.fios.verizon.net. [71.175.3.221])
        by smtp.gmail.com with ESMTPSA id t11sm8645198qkm.96.2021.11.16.08.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 08:58:13 -0800 (PST)
Message-ID: <02e72302-8cb3-9268-32bd-57e9423f1590@redhat.com>
Date:   Tue, 16 Nov 2021 11:58:12 -0500
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
 <26204690-493f-67a8-1791-c9c9d38c0240@redhat.com>
 <YZPT3ojgzdmH3lkq@redhat.com>
From:   Tyler Fanelli <tfanelli@redhat.com>
In-Reply-To: <YZPT3ojgzdmH3lkq@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 10:53 AM, Daniel P. Berrangé wrote:
> On Tue, Nov 16, 2021 at 10:29:35AM -0500, Tyler Fanelli wrote:
>> On 11/16/21 4:17 AM, Daniel P. Berrangé wrote:
>>> On Mon, Nov 15, 2021 at 02:38:04PM -0500, Tyler Fanelli wrote:
>>>> Probe for SEV-ES and SEV-SNP capabilities to distinguish between Rome,
>>>> Naples, and Milan processors. Use the CPUID function to probe if a
>>>> processor is capable of running SEV-ES or SEV-SNP, rather than if it
>>>> actually is running SEV-ES or SEV-SNP.
>>>>
>>>> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
>>>> ---
>>>>    qapi/misc-target.json | 11 +++++++++--
>>>>    target/i386/sev.c     |  6 ++++--
>>>>    2 files changed, 13 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
>>>> index 5aa2b95b7d..c3e9bce12b 100644
>>>> --- a/qapi/misc-target.json
>>>> +++ b/qapi/misc-target.json
>>>> @@ -182,13 +182,19 @@
>>>>    # @reduced-phys-bits: Number of physical Address bit reduction when SEV is
>>>>    #                     enabled
>>>>    #
>>>> +# @es: SEV-ES capability of the machine.
>>>> +#
>>>> +# @snp: SEV-SNP capability of the machine.
>>>> +#
>>>>    # Since: 2.12
>>>>    ##
>>>>    { 'struct': 'SevCapability',
>>>>      'data': { 'pdh': 'str',
>>>>                'cert-chain': 'str',
>>>>                'cbitpos': 'int',
>>>> -            'reduced-phys-bits': 'int'},
>>>> +            'reduced-phys-bits': 'int',
>>>> +            'es': 'bool',
>>>> +            'snp': 'bool'},
>>>>      'if': 'TARGET_I386' }
>>>>    ##
>>>> @@ -205,7 +211,8 @@
>>>>    #
>>>>    # -> { "execute": "query-sev-capabilities" }
>>>>    # <- { "return": { "pdh": "8CCDD8DDD", "cert-chain": "888CCCDDDEE",
>>>> -#                  "cbitpos": 47, "reduced-phys-bits": 5}}
>>>> +#                  "cbitpos": 47, "reduced-phys-bits": 5
>>>> +#                  "es": false, "snp": false}}
>>> We've previously had patches posted to support SNP in QEMU
>>>
>>>     https://lists.gnu.org/archive/html/qemu-devel/2021-08/msg04761.html
>>>
>>> and this included an update to query-sev for reporting info
>>> about the VM instance.
>>>
>>> Your patch is updating query-sev-capabilities, which is a
>>> counterpart for detecting host capabilities separate from
>>> a guest instance.
>> Yes, that's because with this patch, I'm more interested in determining
>> which AMD processor is running on a host, and less if ES or SNP is actually
>> running on a guest instance or not.
>>> None the less I wonder if the same design questions from
>>> query-sev apply. ie do we need to have the ability to
>>> report any SNP specific information fields, if so we need
>>> to use a discriminated union of structs, not just bool
>>> flags.
>>>
>>> More generally I'm some what wary of adding this to
>>> query-sev-capabilities at all, unless it is part of the
>>> main SEV-SNP series.
>>>
>>> Also what's the intended usage for the mgmt app from just
>>> having these boolean fields ? Are they other more explicit
>>> feature flags we should be reporting, instead of what are
>>> essentially SEV generation codenames.
>> If by "mgmt app" you're referring to sevctl, in order to determine which
>> certificate chain to use (Naples vs Rome vs Milan ARK/ASK) we must query
>> which processor we are running on. Although sevctl has a feature which can
>> do this already, we cannot guarantee that sevctl is running on the same host
>> that a VM is running on, so we must query this capability from QEMU. My
>> logic was determining the processor would have been the following:
> I'm not really talking about a specific, rather any tool which wants
> to deal with SEV and QEMU, whether libvirt or an app using libvirt,
> or something else using QEMU directly.

Ah, my mistake.

> Where does the actual cert chain payload come from ? Is that something
> the app has to acquire out of band, or can the full cert chain be
> acquired from the hardware itself ?

The cert chain (or the ARK/ASK specifically) comes from AMD's KDS, yet 
sevctl is able to cache the values, and has them on-hand when needed. 
This patch would tell sevctl *which* of the cert chains to use (Naples 
vs Rome vs Milan chain). If need be, I could just focus on Naples and 
Rome processors for now and bring support for SNP (Milan processors) 
later on when it is more mature.

>> !es && !snp --> Naples
>>
>> es && !snp --> Rome
>>
>> es && snp --> Milan
> This approach isn't future proof if subsequent generations introduce
> new certs. It feels like we should be explicitly reporting something
> about the certs rather than relying on every app to re-implement tihs
> logic.

Alright, like an encoding of which processor generation the host is 
running on?

>
> Regards,
> Daniel

Tyler.

-- 
Tyler Fanelli (tfanelli)

