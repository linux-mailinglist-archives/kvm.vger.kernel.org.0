Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71AF14585B
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 16:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgAVPBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 10:01:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50993 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725802AbgAVPBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 10:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579705291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=EhOr3wrc3S+VcGunzCB8nMYLb4tD/h192YRG3JPu4DI=;
        b=ItFS+5/vMpONa4PcQwPl6XHi/KaL8SomZEZFoIyYFw8oWE7kYT9LA/GNcLVPuOf0s2aIB4
        5Ra+zHQ9ueP0Hr1quIlGMAcnqgwNxX5w79KGhPrGJRnVToK7aq/vaqv+/ILfoQfHIkYWjr
        Znle9kmmhws6jwhf9s2nsn3RFVHznkw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-dvMVoQuFNkO-fpz8SmJPcQ-1; Wed, 22 Jan 2020 10:01:28 -0500
X-MC-Unique: dvMVoQuFNkO-fpz8SmJPcQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 333E7107B795;
        Wed, 22 Jan 2020 15:01:27 +0000 (UTC)
Received: from [10.40.204.119] (ovpn-204-119.brq.redhat.com [10.40.204.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D28045DD64;
        Wed, 22 Jan 2020 15:01:20 +0000 (UTC)
Subject: Re: strict aliasing in kvm-unit-tests (was: Re: [kvm-unit-tests PATCH
 v8 6/6] s390x: SCLP unit test)
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>
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
 <aa3c6235-7a9e-d7c5-bd9d-974f2b947992@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Autocrypt: addr=lvivier@redhat.com; prefer-encrypt=mutual; keydata=
 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
 D+Ofp0T3KOr1RUHvCZoLURfFhSQ=
Message-ID: <3ab57ab8-d015-3ae6-550c-39db94d52265@redhat.com>
Date:   Wed, 22 Jan 2020 16:01:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <aa3c6235-7a9e-d7c5-bd9d-974f2b947992@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/2020 15:42, Paolo Bonzini wrote:
> On 22/01/20 15:15, Thomas Huth wrote:
>> On 22/01/2020 13.16, Thomas Huth wrote:
>>> On 22/01/2020 11.40, David Hildenbrand wrote:
>>>> On 22.01.20 11:39, Thomas Huth wrote:
>>>>> On 22/01/2020 11.32, David Hildenbrand wrote:
>>>>>> On 22.01.20 11:31, Thomas Huth wrote:
>>>>>>> On 22/01/2020 11.22, David Hildenbrand wrote:
>>>>>>>> On 22.01.20 11:10, David Hildenbrand wrote:
>>> [...]
>>>>>>>>> Doing a fresh ./configure + make on RHEL7 gives me
>>>>>>>>>
>>>>>>>>> [linux1@rhkvm01 kvm-unit-tests]$ make
>>>>>>>>> gcc  -std=gnu99 -ffreestanding -I /home/linux1/git/kvm-unit-tests/lib -I /home/linux1/git/kvm-unit-tests/lib/s390x -I lib -O2 -march=zEC12 -fno-delete-null-pointer-checks -g -MMD -MF s390x/.sclp.d -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Werror  -fomit-frame-pointer    -Wno-frame-address   -fno-pic    -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes   -c -o s390x/sclp.o s390x/sclp.c
>>>>>>>>> s390x/sclp.c: In function 'test_one_simple':
>>>>>>>>> s390x/sclp.c:121:2: error: dereferencing type-punned pointer will break strict-aliasing rules [-Werror=strict-aliasing]
>>>>>>>>>   ((SCCBHeader *)sccb_template)->length = sccb_len;
>>>>>>>>>   ^
>>>>>>>>> s390x/sclp.c: At top level:
>>>>>>>>> cc1: error: unrecognized command line option "-Wno-frame-address" [-Werror]
>>>>>>>>> cc1: all warnings being treated as errors
>>>>>>>>> make: *** [s390x/sclp.o] Error 1
>>>>>>>>
>>>>>>>> The following makes it work:
>>>>>>>>
>>>>>>>>
>>>>>>>> diff --git a/s390x/sclp.c b/s390x/sclp.c
>>>>>>>> index c13fa60..0b8117a 100644
>>>>>>>> --- a/s390x/sclp.c
>>>>>>>> +++ b/s390x/sclp.c
>>>>>>>> @@ -117,8 +117,10 @@ static bool test_one_ro(uint32_t cmd, uint8_t *addr, uint64_t exp_pgm, uint16_t
>>>>>>>>  static bool test_one_simple(uint32_t cmd, uint8_t *addr, uint16_t sccb_len,
>>>>>>>>                         uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
>>>>>>>>  {
>>>>>>>> +       SCCBHeader *header = (void *)sccb_template;
>>>>>>>> +
>>>>>>>>         memset(sccb_template, 0, sizeof(sccb_template));
>>>>>>>> -       ((SCCBHeader *)sccb_template)->length = sccb_len;
>>>>>>>> +       header->length = sccb_len;
>>>>>>>
>>>>>>> While that might silence the compiler warning, we still might get
>>>>>>> aliasing problems here, I think.
>>>>>>> The right way to solve this problem is to turn sccb_template into a
>>>>>>> union of the various structs/arrays that you want to use and then access
>>>>>>> the fields through the union instead ("type-punning through union").
>>>>>>
>>>>>> We do have the exact same thing in lib/s390x/sclp.c already, no?
>>>>>
>>>>> Maybe we should carefully check that code, too...
>>>>>
>>>>>> Especially, new compilers don't seem to care?
>>>>>
>>>>> I've seen horrible bugs due to these aliasing problems in the past -
>>>>> without compiler warnings showing up! Certain versions of GCC assume
>>>>> that they can re-order code with pointers that point to types of
>>>>> different sizes, i.e. in the above example, I think they could assume
>>>>> that they could re-order the memset() and the header->length = ... line.
>>>>> I'd feel better if we play safe and use a union here.
>>>>
>>>> Should we simply allow type-punning?
>>>
>>> Maybe yes. The kernel also compiles with "-fno-strict-aliasing", and
>>> since kvm-unit-tests is mainly a "playground" for people who do kernel
>>> development, too, we should maybe also compile the unit tests with
>>> "-fno-strict-aliasing".
>>>
>>> Paolo, Andrew, Laurent, what do you think?
> 
> I think enabling -fno-strict-aliasing is a good idea.

I agree too

Laurent

