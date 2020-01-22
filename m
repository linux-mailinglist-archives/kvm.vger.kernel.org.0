Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2236D14580D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 15:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgAVOmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 09:42:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725911AbgAVOmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 09:42:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579704164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDwvN2ooT1SuoWWlnWxcdN3KIvOJ2lbj3tc6N5m3qYw=;
        b=DJN+5HDIRBEravs2j3T4qzmxvdZ2ymlZzTTMBBVBGKa2JC6cDNzUPD4oyRkxGHf0kibWDe
        fz37/19OiYcAqPL8wEodoM1FTCJVUlDrz4pEw4eZiaJY4yW9oOcWG9V0n4Z7fBEjeXD3im
        FF5+R1g78f7/90gyyMfcGBifMCuPMtk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-rfLwwzUpPbmLsapQg_9jow-1; Wed, 22 Jan 2020 09:42:43 -0500
X-MC-Unique: rfLwwzUpPbmLsapQg_9jow-1
Received: by mail-wr1-f72.google.com with SMTP id f15so3185453wrr.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 06:42:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UDwvN2ooT1SuoWWlnWxcdN3KIvOJ2lbj3tc6N5m3qYw=;
        b=RG5GXdBJItBFKrv4dO5q1+x9KjDj6vDm7hxPz+t+tPnbGlGNee+SHmesewm0j0+ZX1
         c7gKfHcjbUsuTx+0YBkTYhYUSWwRhzAVVYRuLwz3a26ut889PpbjYSGe6MrKp6w9eapk
         b75SLidjp0gfI5Ov7Mv/u4ZMeZK0d9TJpyCdsLT6H6pofnztuvBYdCAZNBv0I0Xm5BL6
         OHqWnqEq7obmEpZ51enloELHqSXi64xJJrsddtHAbMu4Ch1PbRvAjNxSkBb563lReioB
         LBGEbXyO1NMrMnURrwOF9VxgrfIfBDRXQSuDXpgGOtiAwRWOdkAZNrd/91Fm5sQwYsEB
         61Sw==
X-Gm-Message-State: APjAAAWbOHJ+HP8Nkdg03Vx+vyVRxt+DQXlDz3cyCHEtvUHCkQ6EauZQ
        L/JlVve6/WNeACymLRp0ODcvQFiCvDstMNHztSS0MvG2f6iqzMDeWCwVcOYoVAyTlokZqFT0wUX
        sD6oviCHCUWr4
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr12391259wrx.153.1579704161871;
        Wed, 22 Jan 2020 06:42:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQUDKmrXCaFnKNcN1v2OhENNM+FWvom7hQynS11gqJn4yPpbacNvwYiNFNaCru/B274/JIyQ==
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr12391233wrx.153.1579704161622;
        Wed, 22 Jan 2020 06:42:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id w22sm3980976wmk.34.2020.01.22.06.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 06:42:40 -0800 (PST)
Subject: Re: strict aliasing in kvm-unit-tests (was: Re: [kvm-unit-tests PATCH
 v8 6/6] s390x: SCLP unit test)
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com
References: <20200120184256.188698-1-imbrenda@linux.ibm.com>
 <20200120184256.188698-7-imbrenda@linux.ibm.com>
 <35e59971-c09e-2808-1be6-f2ccd555c4f6@redhat.com>
 <42c5b040-733d-4e5b-0276-5b94315336bb@redhat.com>
 <e406268e-7881-f5c3-7b28-70e355765539@redhat.com>
 <997a62b7-7ab7-6119-4948-e8779e639101@redhat.com>
 <4d09b567-c2ae-ec9d-59d0-bd259a86b14d@redhat.com>
 <946e1194-4607-c928-6d66-9e306dc1216a@redhat.com>
 <d467e614-621b-aca7-4255-dfe5707b5dd7@redhat.com>
 <ddf083a3-7d29-ca78-0fd9-e7e3c38e0f04@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa3c6235-7a9e-d7c5-bd9d-974f2b947992@redhat.com>
Date:   Wed, 22 Jan 2020 15:42:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <ddf083a3-7d29-ca78-0fd9-e7e3c38e0f04@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/20 15:15, Thomas Huth wrote:
> On 22/01/2020 13.16, Thomas Huth wrote:
>> On 22/01/2020 11.40, David Hildenbrand wrote:
>>> On 22.01.20 11:39, Thomas Huth wrote:
>>>> On 22/01/2020 11.32, David Hildenbrand wrote:
>>>>> On 22.01.20 11:31, Thomas Huth wrote:
>>>>>> On 22/01/2020 11.22, David Hildenbrand wrote:
>>>>>>> On 22.01.20 11:10, David Hildenbrand wrote:
>> [...]
>>>>>>>> Doing a fresh ./configure + make on RHEL7 gives me
>>>>>>>>
>>>>>>>> [linux1@rhkvm01 kvm-unit-tests]$ make
>>>>>>>> gcc  -std=gnu99 -ffreestanding -I /home/linux1/git/kvm-unit-tests/lib -I /home/linux1/git/kvm-unit-tests/lib/s390x -I lib -O2 -march=zEC12 -fno-delete-null-pointer-checks -g -MMD -MF s390x/.sclp.d -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Werror  -fomit-frame-pointer    -Wno-frame-address   -fno-pic    -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes   -c -o s390x/sclp.o s390x/sclp.c
>>>>>>>> s390x/sclp.c: In function 'test_one_simple':
>>>>>>>> s390x/sclp.c:121:2: error: dereferencing type-punned pointer will break strict-aliasing rules [-Werror=strict-aliasing]
>>>>>>>>   ((SCCBHeader *)sccb_template)->length = sccb_len;
>>>>>>>>   ^
>>>>>>>> s390x/sclp.c: At top level:
>>>>>>>> cc1: error: unrecognized command line option "-Wno-frame-address" [-Werror]
>>>>>>>> cc1: all warnings being treated as errors
>>>>>>>> make: *** [s390x/sclp.o] Error 1
>>>>>>>
>>>>>>> The following makes it work:
>>>>>>>
>>>>>>>
>>>>>>> diff --git a/s390x/sclp.c b/s390x/sclp.c
>>>>>>> index c13fa60..0b8117a 100644
>>>>>>> --- a/s390x/sclp.c
>>>>>>> +++ b/s390x/sclp.c
>>>>>>> @@ -117,8 +117,10 @@ static bool test_one_ro(uint32_t cmd, uint8_t *addr, uint64_t exp_pgm, uint16_t
>>>>>>>  static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sccb_len,
>>>>>>>                         uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
>>>>>>>  {
>>>>>>> +       SCCBHeader *header = (void *)sccb_template;
>>>>>>> +
>>>>>>>         memset(sccb_template, 0, sizeof(sccb_template));
>>>>>>> -       ((SCCBHeader *)sccb_template)->length = sccb_len;
>>>>>>> +       header->length = sccb_len;
>>>>>>
>>>>>> While that might silence the compiler warning, we still might get
>>>>>> aliasing problems here, I think.
>>>>>> The right way to solve this problem is to turn sccb_template into a
>>>>>> union of the various structs/arrays that you want to use and then access
>>>>>> the fields through the union instead ("type-punning through union").
>>>>>
>>>>> We do have the exact same thing in lib/s390x/sclp.c already, no?
>>>>
>>>> Maybe we should carefully check that code, too...
>>>>
>>>>> Especially, new compilers don't seem to care?
>>>>
>>>> I've seen horrible bugs due to these aliasing problems in the past -
>>>> without compiler warnings showing up! Certain versions of GCC assume
>>>> that they can re-order code with pointers that point to types of
>>>> different sizes, i.e. in the above example, I think they could assume
>>>> that they could re-order the memset() and the header->length = ... line.
>>>> I'd feel better if we play safe and use a union here.
>>>
>>> Should we simply allow type-punning?
>>
>> Maybe yes. The kernel also compiles with "-fno-strict-aliasing", and
>> since kvm-unit-tests is mainly a "playground" for people who do kernel
>> development, too, we should maybe also compile the unit tests with
>> "-fno-strict-aliasing".
>>
>> Paolo, Andrew, Laurent, what do you think?

I think enabling -fno-strict-aliasing is a good idea.

Paolo

