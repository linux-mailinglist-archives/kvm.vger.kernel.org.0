Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF4D139574
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 17:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAMQGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 11:06:14 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726567AbgAMQGO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 11:06:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578931572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=QFIs0c9dJuKvsjnv0OQJuSpYTsmPDGD54V12k5hVC4c=;
        b=WuIXkpd+nJ8jx2fORxgd5ouCHKojlfk87iyQFyCqJtnyCKbUg9DfRmwc1M8KoEM2dY2rpW
        062Rc5p+sa0+7sWEQg4mes8NU89OfEh8keZ5CdAWbl4xSHYcl7tNIHf4qObY/IEztwvlNO
        BX8CsNBNiSirg2hRRLpzrrX5kmP0PoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-76q6QQeNOeOjIvMFfulPYw-1; Mon, 13 Jan 2020 11:06:08 -0500
X-MC-Unique: 76q6QQeNOeOjIvMFfulPYw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 836E810239A6;
        Mon, 13 Jan 2020 16:06:07 +0000 (UTC)
Received: from [10.36.117.201] (ovpn-117-201.ams2.redhat.com [10.36.117.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2678160BF1;
        Mon, 13 Jan 2020 16:06:05 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 4/4] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <20200110184050.191506-1-imbrenda@linux.ibm.com>
 <20200110184050.191506-5-imbrenda@linux.ibm.com>
 <8d7fb5c4-9e2c-e28a-16c0-658afcc8178d@redhat.com>
 <20200113133325.417bf657@p-imbrenda>
 <1b86b00a-261e-3d8c-fa52-c30e67463ad5@redhat.com>
 <20200113135832.1c6d3bb8@p-imbrenda>
 <22b5ce6a-18af-edec-efc6-e03450faddf8@redhat.com>
 <20200113150504.3fd218d5@p-imbrenda>
 <3db7eaf7-6020-365b-c849-9961e483352e@redhat.com>
 <20200113162439.7ae81f84@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <9f0bee07-28bc-8154-3c67-402c82da8f89@redhat.com>
Date:   Mon, 13 Jan 2020 17:06:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200113162439.7ae81f84@p-imbrenda>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.01.20 16:24, Claudio Imbrenda wrote:
> On Mon, 13 Jan 2020 15:43:28 +0100
> David Hildenbrand <david@redhat.com> wrote:
>=20
>> On 13.01.20 15:05, Claudio Imbrenda wrote:
>>> On Mon, 13 Jan 2020 14:10:10 +0100
>>> David Hildenbrand <david@redhat.com> wrote:
>>>
>>> [...]
>>>  =20
>>>> :) I'm confused by the fact that you "expect_pgm_int()" but
>>>> actually don't expect one ...
>>>>
>>>> Please enlighten me why this isn't
>>>>
>>>> +	sclp_mark_busy();
>>>> +	h->length =3D 8;
>>>> +	sclp_setup_int();
>>>> +
>>>> +	asm volatile(
>>>> +		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc
>>>> %1,%2 */
>>>> +		"       ipm     %0\n"
>>>> +		"       srl     %0,28"
>>>> +		: "=3D&d" (cc) : "d" (valid_code), "a"
>>>> (__pa(pagebuf))
>>>> +		: "cc", "memory");
>>>> +	if (!cc)
>>>> +		sclp_wait_busy();
>>>> +	report(cc =3D=3D 0, "Instruction format ignored bits");
>>>>
>>>> I feel like I am missing something important. =20
>>>
>>> because if we take an unexpected pgm interrupt:
>>> * the interrupt handler will write stuff on the console using SCLP
>>> * it will wait for the busy flag to be cleared before doing so
>>> * thus it will hang.
>>>
>>> this would be solved by adding special logic to the pgm interrupt
>>> handler (as we have discussed in your previous email)
>>>  =20
>>
>> I see, so the issue should hold for all SCLP checks where we don't
>> expect an exception ... hmmm
> =20
> which is why my wrapper in the unit test is so complicated :)
>=20

so .... if we would implement my suggestion (if we get an exception on a
servc instruction, clear sclp_busy) that code would get simplified as
well? :)

It would be really beneficial if we could rely on

expect_pgm_int()
...
check_pgm_int_code(whatever)

if we *expect an interrupt and none of that if we don't. So if it's a
matter of clearing sclp_busy on PGM exceptions, that shouldn't be too
hard ... but maybe I am missing something (haven't looked again at the
whole patch ...).

--=20
Thanks,

David / dhildenb

