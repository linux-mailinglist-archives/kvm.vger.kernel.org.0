Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F93F7499
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfKKNR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:17:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50433 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726845AbfKKNR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:17:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573478245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=OVWkruw23H0EJpUMKndpkLEW/N7TJYZTdx2JugVXhw0=;
        b=QmBC6NhYW+X4MP00AxvftOOirLaJZ9aBvOdTMTtksjANgF+M1u6ldMXCPVJIhfLOWKsCsZ
        zhYrxFEsgWJJzCV3jgZ6QX+BeDemj6+qjiAXHQAcZwKrGEYMKZUNv5/KHY1wHVngB/e1t7
        QNI2AEQzR3aeFxU7a5W84aicTvAadyw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-hX4fBi66NGmUpOBaNVl-iw-1; Mon, 11 Nov 2019 08:17:24 -0500
X-MC-Unique: hX4fBi66NGmUpOBaNVl-iw-1
Received: by mail-wm1-f69.google.com with SMTP id k184so6825555wmk.1
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:17:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=OH/rVbiJEglxyAMDn85gLKOB0traYMHHJxwL81rUgKQ=;
        b=AzzE+aTHUADq6vCRQqFAYnZKVqQ6iytiPKHMBtCZ8qciV1VCuhUcmGupxkP9TKGv3u
         mdHhhxeXHHQ2oVzq0fdHkasrpY3VgFfQ7ItWhekB/9k3jcKUSTJ/Oq8ZQ4RWdi554KHL
         ei5Ub6WR6WweahTA5j6TGYYeldDSYpbIgQanOo7MVaJ34Zkftx6Ch9Dn/YGadI8VDmmY
         d3/dlvRTwzbCIYYiunFO0gTEZ9wfSrz3S3rxMrh+dHHvCeO6SkjCqVDO9/xuZ/FqR9/Z
         7siaOkAxhDcNdo/hiYVgNkB1Lm+ghgJPglBJ4R6Z3FCxq01S4DZ1p1xXY5x7MaWMerKW
         h7dw==
X-Gm-Message-State: APjAAAWunKusG9e0hoojKQHQ2YjamN4pxf99al1xdjI9h2vtgv0XT4pc
        V3vK2mXtmjsEkrTav3ufpP19dR0P97Q8NAd+qSsWYsklP6+F1M5SltYa0Uk/XeJvAeukbQ/6Iil
        qRPOSKQ9Zxv7z
X-Received: by 2002:a1c:e3d4:: with SMTP id a203mr6341164wmh.173.1573478242787;
        Mon, 11 Nov 2019 05:17:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBSYWvgng9tLfS9uRB+tZcGbIK5CktFHiYB1uVBDH4KHZPyEgohBbtbvYytqmJ43uPCkkp9Q==
X-Received: by 2002:a1c:e3d4:: with SMTP id a203mr6341137wmh.173.1573478242500;
        Mon, 11 Nov 2019 05:17:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id f13sm15132817wrq.96.2019.11.11.05.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:17:21 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2] alloc: Add memalign error checks
To:     Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        thuth@redhat.com
References: <20191104102916.10554-1-frankja@linux.ibm.com>
 <61db264b-6d29-66bc-ea60-053b5aa8b995@redhat.com>
 <20191104105417.xt2z5gcuk5xqf4bi@kamzik.brq.redhat.com>
 <a91a1828-017a-b0c6-442f-5b31263f3568@redhat.com>
 <4c26975a-84af-e21b-fe40-33197b51fffd@linux.ibm.com>
 <20191111123109.mnibzicgsbcvvtth@kamzik.brq.redhat.com>
 <1f0fb08c-ca4d-93dc-2b43-72356c75d033@redhat.com>
 <fbd4d212-3a22-d836-a648-44c177be1fd4@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7ce54112-1d9d-abb5-a375-0d6eea411af1@redhat.com>
Date:   Mon, 11 Nov 2019 14:17:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fbd4d212-3a22-d836-a648-44c177be1fd4@linux.ibm.com>
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1OfgTicJ91wREd2xuL2cEYBcHaZo6jyv5"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1OfgTicJ91wREd2xuL2cEYBcHaZo6jyv5
Content-Type: multipart/mixed; boundary="vBIlyTnFrNAiemiJRimbyLp3TJjjDcdfa";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Janosch Frank <frankja@linux.ibm.com>, Andrew Jones <drjones@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
 thuth@redhat.com
Message-ID: <7ce54112-1d9d-abb5-a375-0d6eea411af1@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2] alloc: Add memalign error checks
References: <20191104102916.10554-1-frankja@linux.ibm.com>
 <61db264b-6d29-66bc-ea60-053b5aa8b995@redhat.com>
 <20191104105417.xt2z5gcuk5xqf4bi@kamzik.brq.redhat.com>
 <a91a1828-017a-b0c6-442f-5b31263f3568@redhat.com>
 <4c26975a-84af-e21b-fe40-33197b51fffd@linux.ibm.com>
 <20191111123109.mnibzicgsbcvvtth@kamzik.brq.redhat.com>
 <1f0fb08c-ca4d-93dc-2b43-72356c75d033@redhat.com>
 <fbd4d212-3a22-d836-a648-44c177be1fd4@linux.ibm.com>
In-Reply-To: <fbd4d212-3a22-d836-a648-44c177be1fd4@linux.ibm.com>

--vBIlyTnFrNAiemiJRimbyLp3TJjjDcdfa
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/11/19 14:13, Janosch Frank wrote:
> On 11/11/19 2:04 PM, Paolo Bonzini wrote:
>> On 11/11/19 13:31, Andrew Jones wrote:
>>>> I had some more time to think about and test this and I think returnin=
g
>>>> NULL here is more useful. My usecase is a limit test where I allocate
>>>> until I get a NULL and then free everything afterwards.
>>> I think I prefer the assert here, since most users of this will not be
>>> expecting to run out of memory, and therefore not checking for it.
>>
>> Yeah, the main issue with returning NULL is that (void*) 0 is a valid
>> address for kvm-unit-tests.
>=20
> So, images are not loaded to 0 for non s390x architectures?

It depends on the architecture.  Either way, if there is an out of
memory error it would turn into a rogue memory write.  That would be
harder to debug than an assertion failure.

If there is need, we can add try_malloc and try_memalign, too.

Paolo


--vBIlyTnFrNAiemiJRimbyLp3TJjjDcdfa--

--1OfgTicJ91wREd2xuL2cEYBcHaZo6jyv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl3JX2MACgkQv/vSX3jH
roOtMQgAln29BlAoC8CAjzmh7NNtW1nCSwBROvgiMWW6h62Kh//5oe+p/U0E2d4M
Kfr6dlBhRr3u+aAuAdLM178ZW04P+0htJl2lkruLExMwQUThsb1immC9pQUJKLcN
N5+cniEcYxqVw2S496h24lZAVqMzFeSDG0GHGYk6rx6+2tTyOdUAYWDi01XLZTY2
Y+V6agIhHeaEywyp+Ujlw7TXjT1cR++9/PZ7gXyhG5H2cWSii9gi3blgdfbsrX9g
gF8LOW1A3A/5x79Nv5ZCVsj9P9GH2l6bTdpTJQAyMQUkbPwfnJYZkJCQUf4QjEmr
2YzXZXZzLWji8z42oBUN5O3l7st0yw==
=3DE3
-----END PGP SIGNATURE-----

--1OfgTicJ91wREd2xuL2cEYBcHaZo6jyv5--

