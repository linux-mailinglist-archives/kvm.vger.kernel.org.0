Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E3B13BCF0
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 10:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgAOJ54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 04:57:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729531AbgAOJ54 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 04:57:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579082274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Q5X8c8VsfzHfWECwrmRs+WUm+mRmiVpcn1gX1x+Ygmo=;
        b=fQmxF/Tn2//0RRWUb9+SC5aMpp4lBH5V/vdBwYl5RhSA8mabRuvoJGmKyagr+5wFgOMQn+
        tGCCXla338+muI8TKnkKnIqYa/GHg1uHiH4/TPhnlz9MX3oBH0eeFTEl5IyLJemoDiTcxX
        TUWlRmuK3zy5kO+RAzmwFGJR5x9vZw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-_T9sFurKOr2VEjlw1oD2sQ-1; Wed, 15 Jan 2020 04:57:51 -0500
X-MC-Unique: _T9sFurKOr2VEjlw1oD2sQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22B40107BAA3;
        Wed, 15 Jan 2020 09:57:50 +0000 (UTC)
Received: from [10.36.118.7] (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C39CA1A7E3;
        Wed, 15 Jan 2020 09:57:48 +0000 (UTC)
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
 <9f0bee07-28bc-8154-3c67-402c82da8f89@redhat.com>
 <20200113171715.7334c1be@p-imbrenda>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <0842fa2c-62f7-025c-ab01-145ea24328a1@redhat.com>
Date:   Wed, 15 Jan 2020 10:57:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200113171715.7334c1be@p-imbrenda>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.01.20 17:17, Claudio Imbrenda wrote:
> On Mon, 13 Jan 2020 17:06:05 +0100
> David Hildenbrand <david@redhat.com> wrote:
>=20
> [...]
>=20
>>>>> this would be solved by adding special logic to the pgm interrupt
>>>>> handler (as we have discussed in your previous email)
>>>>>    =20
>>>>
>>>> I see, so the issue should hold for all SCLP checks where we don't
>>>> expect an exception ... hmmm =20
>>> =20
>>> which is why my wrapper in the unit test is so complicated :)
>>>  =20
>>
>> so .... if we would implement my suggestion (if we get an exception
>> on a servc instruction, clear sclp_busy) that code would get
>> simplified as well? :)
>=20
> sure, as I said, that can be done. The question is if we really want to
> change something in the interrupt handler (shared by all s390x unit
> tests) just for the benefit of this one unit test.
>=20
> Also consider that the changes to the interrupt handler would not
> necessarily be trivial. i.e. you need to check that the origin of the
> pgm interrupt is a SERVC instruction, and then act accordingly.
>=20

I suggest something like the following:

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 05f30be..d762e83 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -106,10 +106,17 @@ static void fixup_pgm_int(void)
=20
 void handle_pgm_int(void)
 {
-       if (!pgm_int_expected)
+       if (!pgm_int_expected) {
+               /*
+                * If we get a PGM interrupt while having sclp_busy=3Dtru=
e, we
+                * will loop forever. Just force sclp_busy=3Dfalse to mak=
e
+                * progress here.
+                */
+               sclp_handle_ext();
                report_abort("Unexpected program interrupt: %d at %#lx, i=
len %d\n",
                             lc->pgm_int_code, lc->pgm_old_psw.addr,
                             lc->pgm_int_id);
+       }
=20
        pgm_int_expected =3D false;
        fixup_pgm_int();

Then this test could become something like (not sure about cc handling)

diff --git a/s390x/sclp.c b/s390x/sclp.c
index 10f0809..81c5a76 100644
--- a/s390x/sclp.c
+++ b/s390x/sclp.c
@@ -396,25 +396,18 @@ out:
 static void test_instbits(void)
 {
        SCCBHeader *h =3D (SCCBHeader *)pagebuf;
-       int cc;
=20
-       expect_pgm_int();
        sclp_mark_busy();
        h->length =3D 8;
        sclp_setup_int();
=20
        asm volatile(
-               "       .insn   rre,0xb2204200,%1,%2\n"  /* servc %1,%2 *=
/
-               "       ipm     %0\n"
-               "       srl     %0,28"
-               : "=3D&d" (cc) : "d" (valid_code), "a" (__pa(pagebuf))
+               "       .insn   rre,0xb2204200,%0,%1\n"
+               :: "d" (valid_code), "a" (__pa(pagebuf))
                : "cc", "memory");
-       if (lc->pgm_int_code) {
-               sclp_handle_ext();
-               cc =3D 1;
-       } else if (!cc)
-               sclp_wait_busy();
-       report(cc =3D=3D 0, "Instruction format ignored bits");
+       sclp_wait_busy();
+       report(true, "Instruction format ignored bits");
 }


This works correctly. E.g., adding a "*((uint8_t *)-50ul) =3D 2;"
after the sclp_setup_int(); - to quickly fake a PGM exception - makes the
test abort correctly:

FAIL sclp-1g (0 tests)
FAIL sclp-3g (0 tests)

ABORT: sclp: Unexpected program interrupt: 5 at 0x155e8, ilen 6

--=20
Thanks,

David / dhildenb

