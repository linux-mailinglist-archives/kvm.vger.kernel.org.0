Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A4361E1E3
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 12:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiKFLis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 06:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiKFLiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 06:38:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A486F644B
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 03:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667734670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hvYtUaq9PZ7P1LfxxWz8L3x7PiJUZo8m0lYyPPjz+XQ=;
        b=X/K0KHcA0uNmL7HPSjF8xYlaepmSkx5adFGWXJZl17YErbJi2wDifooF1zio4QT7LrJ2RT
        B7JVw4nxypGPVOAm9Qs08KwimhbVVNGja2rR8LdCKEhHwOpHCcVzK6xfAwnTNhFcni8286
        2SLlvSEfcio38itr75sb8jj20t0OA2o=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-422-ou2y_-nyPD-LtUTkJ2Qceg-1; Sun, 06 Nov 2022 06:37:49 -0500
X-MC-Unique: ou2y_-nyPD-LtUTkJ2Qceg-1
Received: by mail-ej1-f70.google.com with SMTP id nb1-20020a1709071c8100b007ae4083d6f5so2283585ejc.15
        for <kvm@vger.kernel.org>; Sun, 06 Nov 2022 03:37:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hvYtUaq9PZ7P1LfxxWz8L3x7PiJUZo8m0lYyPPjz+XQ=;
        b=aWJeyUU2N9arijX+ubyG5NNcBlKubm/YYB/36ucoisHbsTqh4gbl/UYrAPBfFWjD+J
         fAsWqskiGq+zlAMQEIysCt7obMDFhJ9wRSYN3kFeIO3f4t6tXop2Ddhc5N8OucyjnsIO
         /CLmiXtfWWUeSRl2DGW9rUaDGIvqFbq1GLzSD3ocD7a9g0UGn/1GQF+mryQXO0Jfofxm
         s0M6CncP3crTl4KjOSISFQa0hcy0xbcPnBBpBkBig8T5yHkddn/xCCoOOgHgnZUbdYaW
         /3CQ22HY1AMj5Tns3YH57xHXaJ5TzRq+bvjk3JRZV+XhuYXLg/dbXVwbA+kIBCRXisaM
         W+iQ==
X-Gm-Message-State: ACrzQf2GDJvf+aCXlcn90kNUmWFXitb4cC8+n8ERWTHX1nlHLy5ksaDV
        aip05XjmwgVkSrs8vormgDUB0/u8QvwguMLerpgigBMnNeYo5YPoplzQFJT7fNg4QpTm/D/xJbs
        zZ3rEKCubBuNG
X-Received: by 2002:a05:6402:884:b0:461:1ed:579f with SMTP id e4-20020a056402088400b0046101ed579fmr44671868edy.413.1667734668375;
        Sun, 06 Nov 2022 03:37:48 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4ucyvgaAuUDiTySpxjMelcJvAVksqQKfaZH5y4trZWFzfcldn4jy6hLF0HpAM2plHC2lVPdQ==
X-Received: by 2002:a05:6402:884:b0:461:1ed:579f with SMTP id e4-20020a056402088400b0046101ed579fmr44671835edy.413.1667734668135;
        Sun, 06 Nov 2022 03:37:48 -0800 (PST)
Received: from [192.168.8.100] (tmo-067-175.customers.d1-online.com. [80.187.67.175])
        by smtp.gmail.com with ESMTPSA id ca26-20020a170906a3da00b0078b03d57fa7sm2018768ejb.34.2022.11.06.03.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Nov 2022 03:37:47 -0800 (PST)
Message-ID: <5fd39710-902e-bc26-65ec-12cabe24178d@redhat.com>
Date:   Sun, 6 Nov 2022 12:37:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v11 01/11] s390x: Register TYPE_S390_CCW_MACHINE
 properties as class properties
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-2-pmorel@linux.ibm.com>
 <3f913a58-e7d0-539e-3bc0-6cbd5608db8e@redhat.com>
 <7d809617-67e0-d233-97b2-8534e2a4610f@linux.ibm.com>
 <6415cf08-e6a1-c72a-1c56-907d3a446a8c@kaod.org>
 <7a3c34dc-2c16-6fdd-e8bc-7a1c623823ae@redhat.com>
 <7177da22-ca19-6510-9bf3-4120140f5431@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <7177da22-ca19-6510-9bf3-4120140f5431@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/2022 15.57, Pierre Morel wrote:
> 
> 
> On 11/4/22 15:29, Thomas Huth wrote:
>> On 04/11/2022 11.53, Cédric Le Goater wrote:
>>> On 11/4/22 11:16, Pierre Morel wrote:
>>>>
>>>>
>>>> On 11/4/22 07:32, Thomas Huth wrote:
>>>>> On 03/11/2022 18.01, Pierre Morel wrote:
>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>> ---
>>>>>>   hw/s390x/s390-virtio-ccw.c | 127 +++++++++++++++++++++----------------
>>>>>>   1 file changed, 72 insertions(+), 55 deletions(-)
>>>>>
>>>>> -EMISSINGPATCHDESCRIPTION
>>>>>
>>>>> ... please add some words *why* this is a good idea / necessary.
>>>>
>>>> I saw that the i386 patch had no description for the same patch so...
>>>>
>>>> To be honest I do not know why it is necessary.
>>>> The only reason I see is to be in sync with the PC implementation.
>>>>
>>>> So what about:
>>>> "
>>>> Register TYPE_S390_CCW_MACHINE properties as class properties
>>>> to be conform with the X architectures
>>>> "
>>>> ?
>>>>
>>>> @Cédric , any official recommendation for doing that?
>>>
>>> There was a bunch of commits related to QOM in this series :
>>>
>>>    91def7b83 arm/virt: Register most properties as class properties
>>>    f5730c69f0 i386: Register feature bit properties as class properties
>>>
>>> which moved property definitions at the class level.
>>>
>>> Then,
>>>
>>>    commit d8fb7d0969 ("vl: switch -M parsing to keyval")
>>>
>>> changed machine_help_func() to use a machine class and not machine
>>> instance anymore.
>>>
>>> I would use the same kind of commit log and add a Fixes tag to get it
>>> merged in 7.2
>>
>> Ah, so this fixes the problem that running QEMU with " -M 
>> s390-ccw-virtio,help" does not show the s390x-specific properties anymore? 
>> ... that's certainly somethings that should be mentioned in the commit 
>> message! What about something like this:
>>
>> "Currently, when running 'qemu-system-s390x -M -M s390-ccw-virtio,help' 
>> the s390x-specific properties are not listed anymore. This happens because 
>> since commit d8fb7d0969 ("vl: switch -M parsing to keyval") the properties 
>> have to be defined at the class level and not at the instance level 
>> anymore. Fix it on s390x now, too, by moving the registration of the 
>> properties to the class level"
>>
>> Fixes: d8fb7d0969 ("vl: switch -M parsing to keyval")
>>
>> ?
>>
>>   Thomas
>>
> 
> That seems really good :)

All right, I've queued this patch (with the updated commit description) and 
the next one on my s390x-branch for QEMU 7.2:

  https://gitlab.com/thuth/qemu/-/commits/s390x-next/

  Thomas

