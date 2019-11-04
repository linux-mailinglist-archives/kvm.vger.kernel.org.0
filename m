Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167AFEDC49
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfKDKQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:16:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727419AbfKDKQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 05:16:30 -0500
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3560259455
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 10:16:30 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id z9so10212882wrq.11
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 02:16:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=k1A6jbXxrCBgnswfdth1gpmzXKl2QeS+K8DubNEMx0g=;
        b=hAAoVfKLxHY86k/V4tMpempSwaEuOltfqerzEaWDnkmLMDfb9TMPRlM2m1UIwCjPrt
         8nTWMOrOuDOXLF9U7Z4sJ0EE7LtFBk8U7MapEd7uhJJ9y+jtd6+FD4C1NGW8GRlk2MPl
         zChtPvscpn+emqXYxWDDg61UWNzKCNjtkiV0ar488iEpor3Uh/rL4tvwqvlC1BW4PpPo
         CBJSuJuNrkeq+ZC9zqr7+jRB3BL4lOaxNsI37BGH7Mszk3aEsbhtOiQiKJl0pKRUd0pq
         WSQzweAmtmT8DnaRJLXNTDrsFMSzeT2F/yLhdvn3tOgMbyLWSJTAiCDPm5t/ZMzd5BrJ
         uO7w==
X-Gm-Message-State: APjAAAWMmCEhtsd6lvxasi/JOpisTfso4WAr8XQd3exMMuYtKO7qgX5U
        9J2LLCYE4fQEXTBzIEFkqqpP+L3YyuRPxsLFDPeQ4p7etPmn3JhYg3kzc/hUpPRh/lwWRECVK1A
        ktUWvhvb7IsRt
X-Received: by 2002:a05:6000:12c4:: with SMTP id l4mr6872709wrx.110.1572862588848;
        Mon, 04 Nov 2019 02:16:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqzERWGioGx3f8WYSq2i81Wv5llnwZkSIhySkY+oKX6yyRLdj7CDqXU1idtDdvovdCCN4ei/OA==
X-Received: by 2002:a05:6000:12c4:: with SMTP id l4mr6872692wrx.110.1572862588554;
        Mon, 04 Nov 2019 02:16:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id v8sm18530222wra.79.2019.11.04.02.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 02:16:27 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] alloc: Add more memalign asserts
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com
References: <20191104092055.5679-1-frankja@linux.ibm.com>
 <6f7795ac-5700-c132-e3b1-708e9451956f@redhat.com>
 <af428ca3-09b2-a1dc-61f8-a6eee290e36b@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <16f0867d-a190-593e-1225-f83eed00efa0@redhat.com>
Date:   Mon, 4 Nov 2019 11:16:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <af428ca3-09b2-a1dc-61f8-a6eee290e36b@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BSkQJNWKUVIDxEYWWv2mKwkscEiiH4cdS"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BSkQJNWKUVIDxEYWWv2mKwkscEiiH4cdS
Content-Type: multipart/mixed; boundary="f5cgDWBGpWHlAg2IgutcBhOzWbMsb21gF";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: thuth@redhat.com, david@redhat.com
Message-ID: <16f0867d-a190-593e-1225-f83eed00efa0@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] alloc: Add more memalign asserts
References: <20191104092055.5679-1-frankja@linux.ibm.com>
 <6f7795ac-5700-c132-e3b1-708e9451956f@redhat.com>
 <af428ca3-09b2-a1dc-61f8-a6eee290e36b@linux.ibm.com>
In-Reply-To: <af428ca3-09b2-a1dc-61f8-a6eee290e36b@linux.ibm.com>

--f5cgDWBGpWHlAg2IgutcBhOzWbMsb21gF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 04/11/19 11:12, Janosch Frank wrote:
> On 11/4/19 11:07 AM, Paolo Bonzini wrote:
>> On 04/11/19 10:20, Janosch Frank wrote:
>>> Let's test for size and alignment in memalign to catch invalid input
>>> data. Also we need to test for NULL after calling the memalign
>>> function of the registered alloc operations.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>
>>> Tested only under s390, tests under other architectures are highly
>>> appreciated.
>>>
>>> ---
>>>  lib/alloc.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/lib/alloc.c b/lib/alloc.c
>>> index ecdbbc4..eba9dd6 100644
>>> --- a/lib/alloc.c
>>> +++ b/lib/alloc.c
>>> @@ -46,6 +46,7 @@ void *memalign(size_t alignment, size_t size)
>>>  	uintptr_t blkalign;
>>>  	uintptr_t mem;
>>> =20
>>> +	assert(size && alignment);
>>
>> Do we want to return NULL instead on !size?  This is how malloc(3) is
>> documented.
>>
>> Paolo
>=20
> I myself never check for NULL on a unit test and therefore added the
> asserts to have it fail visibly.
>=20
> But sure, we can return NULL for both asserts.

Hmm yeah for ->memalign it makes sense since unit tests won't SIGSEGV.
For !size let's return NULL, it can simplify code a bit.

Paolo

>>
>>>  	assert(alloc_ops && alloc_ops->memalign);
>>>  	if (alignment <=3D sizeof(uintptr_t))
>>>  		alignment =3D sizeof(uintptr_t);
>>> @@ -56,6 +57,8 @@ void *memalign(size_t alignment, size_t size)
>>>  	size =3D ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
>>>  	p =3D alloc_ops->memalign(blkalign, size);
>>> =20
>>> +	assert(p !=3D NULL);
>>> +
>>>  	/* Leave room for metadata before aligning the result.  */
>>>  	mem =3D (uintptr_t)p + METADATA_EXTRA;
>>>  	mem =3D ALIGN(mem, alignment);
>>>
>>
>=20
>=20



--f5cgDWBGpWHlAg2IgutcBhOzWbMsb21gF--

--BSkQJNWKUVIDxEYWWv2mKwkscEiiH4cdS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2/+nsACgkQv/vSX3jH
roPG6Qf9FF4IC6qtBxQul91q0lNyk+SGe51Ky6LbNQlc8//Gans3GAA6FKamKPxn
1YvbDYc5NQMoDwgHlES2A2oc/LV3fhWhMsBl5VwMmLgXHHSS5MzviMpX9jvGGTpP
d019Oo4UNaKooRb3PdyEA4dyghsUJqlotKXjPATL30zx8rGmcfjLCtPRL2p/hUgy
uKP0utQgSjT3+RsWsEU5qotX7BrcMxBcTw8+2nXOSes1o2MztvuJ0hRB61Iandgr
toc1G6N8ef4gR3xcvFRM1uSe0hrVOYGqliAFMK3wkhkNCq4jvd2lpt5B7B3N6Exf
+H3ZzqT/e2+5ID937uxucTFTYewphQ==
=olIo
-----END PGP SIGNATURE-----

--BSkQJNWKUVIDxEYWWv2mKwkscEiiH4cdS--
