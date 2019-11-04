Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF64EE288
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 15:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbfKDO3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 09:29:47 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53942 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728834AbfKDO3r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 09:29:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572877786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wb9j+F/9Sf6oCoca2wosBelBgRRumV4npa1OMb0WJ8I=;
        b=Ud7/fbpF+8cxBotv0VUaS6uJGjzFBXzk6v5bqcqmq5zlnhEYFwCKon2AWHXyv2XLQZivcv
        pY5QnR8TOLrlkvtC6KpBHIY3V5/FSmiBiBunUa4hPDKfSYzWbrX+xEODREr7AtmRCDLotk
        +Mo4gPEQ9xg4Fq4lvhWUGzIJ1v709YM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-OVdRxE7FN9-GAQv4PQqP3A-1; Mon, 04 Nov 2019 09:29:33 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A7A78017DD;
        Mon,  4 Nov 2019 14:29:32 +0000 (UTC)
Received: from [10.36.117.96] (ovpn-117-96.ams2.redhat.com [10.36.117.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E82126FC5;
        Mon,  4 Nov 2019 14:29:30 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
 <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
 <1df14176-20a7-a9af-5622-2853425d973e@redhat.com>
 <20191104122931.0774ff7a@p-imbrenda.boeblingen.de.ibm.com>
 <56ce2fe9-1a6a-ffd6-3776-0be1b622032b@redhat.com>
 <20191104124912.7cb58664@p-imbrenda.boeblingen.de.ibm.com>
 <73d233c8-6599-ab1c-6da3-88a4fa719c82@redhat.com>
 <20191104130626.460261a1@p-imbrenda.boeblingen.de.ibm.com>
 <3a551500-102b-c80e-8b4e-9ff2c498d5df@redhat.com>
 <20191104152439.677b97ea@p-imbrenda.boeblingen.de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <0732eeb8-c2b2-a7ca-28ad-cbdf4f9c1d68@redhat.com>
Date:   Mon, 4 Nov 2019 15:29:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191104152439.677b97ea@p-imbrenda.boeblingen.de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: OVdRxE7FN9-GAQv4PQqP3A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.19 15:24, Claudio Imbrenda wrote:
> On Mon, 4 Nov 2019 14:47:54 +0100
> David Hildenbrand <david@redhat.com> wrote:
>=20
>> On 04.11.19 13:06, Claudio Imbrenda wrote:
>>> On Mon, 4 Nov 2019 12:55:48 +0100
>>> David Hildenbrand <david@redhat.com> wrote:
>>>   =20
>>>> On 04.11.19 12:49, Claudio Imbrenda wrote:
>>>>> On Mon, 4 Nov 2019 12:31:32 +0100
>>>>> David Hildenbrand <david@redhat.com> wrote:
>>>>>      =20
>>>>>> On 04.11.19 12:29, Claudio Imbrenda wrote:
>>>>>>> On Mon, 4 Nov 2019 11:58:20 +0100
>>>>>>> David Hildenbrand <david@redhat.com> wrote:
>>>>>>>
>>>>>>> [...]
>>>>>>>         =20
>>>>>>>> Can we just please rename all "cx" into something like "len"?
>>>>>>>> Or is there a real need to have "cx" in there?
>>>>>>>
>>>>>>> if cx is such a nuisance to you, sure, I can rename it to i
>>>>>>
>>>>>> better than random characters :)
>>>>>
>>>>> will be in v3
>>>>>      =20
>>>>>>>         =20
>>>>>>>> Also, I still dislike "test_one_sccb". Can't we just just do
>>>>>>>> something like
>>>>>>>>
>>>>>>>> expect_pgm_int();
>>>>>>>> rc =3D test_one_sccb(...)
>>>>>>>> report("whatever pgm", rc =3D=3D WHATEVER);
>>>>>>>> report("whatever rc", lc->pgm_int_code =3D=3D WHATEVER);
>>>>>>>>
>>>>>>>> In the callers to make these tests readable and cleanup
>>>>>>>> test_one_sccb(). I don't care if that produces more LOC as long
>>>>>>>> as I can actually read and understand the test cases.
>>>>>>>
>>>>>>> if you think that makes it more readable, ok I guess...
>>>>>>>
>>>>>>> consider that the output will be unreadable, though
>>>>>>>         =20
>>>>>>
>>>>>> I think his will turn out more readable.
>>>>>
>>>>> two output lines per SCLP call? I  don't think so
>>>>
>>>> To clarify, we don't always need two checks. E.g., I would like to
>>>> see instead of
>>>>
>>>> +static void test_sccb_too_short(void)
>>>> +{
>>>> +=09int cx;
>>>> +
>>>> +=09for (cx =3D 0; cx < 8; cx++)
>>>> +=09=09if (!test_one_run(valid_code, pagebuf, cx, 8,
>>>> PGM_BIT_SPEC, 0))
>>>> +=09=09=09break;
>>>> +
>>>> +=09report("SCCB too short", cx =3D=3D 8);
>>>> +}
>>>>
>>>> Something like
>>>>
>>>> static void test_sccb_too_short(void)
>>>> {
>>>> =09int i;
>>>>
>>>> =09for (i =3D 0; i < 8; i++) {
>>>> =09=09expect_pgm_int();
>>>> =09=09test_one_sccb(...); // or however that will be
>>>> called check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>>>> =09}
>>>> }
>>>>
>>>> If possible.
>>>>  =20
>>>
>>> so, thousands of output lines for the whole test, ok
>>>   =20
>>
>> A couple of things to note
>>
>> a) You perform 8 checks, so report the result of 8 checks
>> b) We really don't care about the number of lines in a log file as
>> long as we can roughly identify what went wrong (e.g., push/pop a
>> prefix here) c) We really *don't* need full coverage here. The same
>> applies to other tests. Simply testing against the boundary
>> conditions is good enough.
>>
>>
>> expect_pgm_int();
>> test_one_sccb(..., 0, ...);
>> check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>>
>> expect_pgm_int();
>> test_one_sccb(..., 7, ...);
>> check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>>
>> Just as we handle it in other tests.
>=20
> the fact that the other test are not as extensive as they should be
> doesn't mean this test should cover less.

All I'm saying is that you might test too much and I am not sure if that=20
is really needed everywhere in this patch. But I'll leave that up to you.

--=20

Thanks,

David / dhildenb

