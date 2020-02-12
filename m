Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9767315A6E3
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 11:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgBLKrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 05:47:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32323 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725710AbgBLKrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 05:47:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581504465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bU58FGBGLS0jy1qDfhQyMLCuH6KWkAzBxj36lGqtNx4=;
        b=gvUjxgmC7Vx1tRxIH7QS4RcOVV14XuRNT+F6sTC5kg4zfTlxWAea5rgqvLJaCAGPThJP5R
        vZlMEEjvk69epCFn8I0qOnlFRtfeUGVhlgzymR8XTmxVVheAKLx6h+zUe3B6h4/X9HJ2R9
        NYibHdYPMM5DhH2SeQQyZ7vWTxHIXYM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-vwFh36xzMbeClA2j4ksjMw-1; Wed, 12 Feb 2020 05:47:43 -0500
X-MC-Unique: vwFh36xzMbeClA2j4ksjMw-1
Received: by mail-wr1-f70.google.com with SMTP id s13so647341wru.7
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 02:47:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=bU58FGBGLS0jy1qDfhQyMLCuH6KWkAzBxj36lGqtNx4=;
        b=PXWO+9j6Z9rTpimDC40ReqyCiq9unOOBgczwkFKbtn0UmTGx8ZoPn5rW5dDpyczOwp
         xiRcpcNDPOYIZwmWOIicDay5vbQvmUfVO+iqd3pPsYHWj1DvS7FmsvnLqErR4CvdYVUK
         ZUwt7XbbWmlZ4Oiu4A95BcPZQLeVacpZfHC+Ph6/FYbrqiulH5Ypk4Bhu+D2vGmHM9NJ
         FKV5ptvIP5Kh1sxYnvyz2MqE0UxmWpZzpFpOhMjZx4VsMmD5+FHWjU6z3OIDTu632otI
         wW/R8xPJ7jhTRVNt9C4AvljLUcP6/CwP2TCRxWJbS3p2LCfl6aPGbyJnocTwC67q5DPj
         bkfA==
X-Gm-Message-State: APjAAAVd9g+vw4HR1nys5Jz++92ydzlL/fDX3d+KxZRpwcEvqtHnZkK+
        lfguCk1r2hlUlPYvSBRwn+0wdtFUKCU6kvdTdBbKOQlfTDsET6IfPpE9HtkzocL9gPKauSUvJmJ
        rkgqkR/SuZSR9
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr14325512wrp.167.1581504461737;
        Wed, 12 Feb 2020 02:47:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqwLBHyeNGsmOy6Es07w83didIiJIRTo7s+JH2ONtXWburJhx0+/jBzqkYCB8MGwirQ7Wvzn0Q==
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr14325489wrp.167.1581504461457;
        Wed, 12 Feb 2020 02:47:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id f8sm150241wru.12.2020.02.12.02.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 02:47:40 -0800 (PST)
Subject: Re: [RFC] eventfd: add EFD_AUTORESET flag
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kivity <avi@scylladb.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <20200129172010.162215-1-stefanha@redhat.com>
 <66566792-58a4-bf65-6723-7d2887c84160@redhat.com>
 <20200212102912.GA464050@stefanha-x1.localdomain>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <156cb709-282a-ddb6-6f34-82b4bb211f73@redhat.com>
Date:   Wed, 12 Feb 2020 11:47:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200212102912.GA464050@stefanha-x1.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xU0tVZrw8brOJjVsV01vKofMTvhRKZKxV"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xU0tVZrw8brOJjVsV01vKofMTvhRKZKxV
Content-Type: multipart/mixed; boundary="MaDoqHjjBxHp8eCAqI3jz65LJEMmeZZxz"

--MaDoqHjjBxHp8eCAqI3jz65LJEMmeZZxz
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/02/20 11:29, Stefan Hajnoczi wrote:
> On Wed, Feb 12, 2020 at 09:31:32AM +0100, Paolo Bonzini wrote:
>> On 29/01/20 18:20, Stefan Hajnoczi wrote:
>>> +	/* Semaphore semantics don't make sense when autoreset is enabled *=
/
>>> +	if ((flags & EFD_SEMAPHORE) && (flags & EFD_AUTORESET))
>>> +		return -EINVAL;
>>> +
>>
>> I think they do, you just want to subtract 1 instead of setting the
>> count to 0.  This way, writing 1 would be the post operation on the
>> semaphore, while poll() would be the wait operation.
>=20
> True!  Then EFD_AUTORESET is not a fitting name.  EFD_AUTOREAD or
> EFD_POLL_READS?

Avi's suggestion also makes sense.  Switching the event loop from poll()
to IORING_OP_POLL_ADD would be good on its own, and then you could make
it use IORING_OP_READV for eventfds.

In QEMU parlance, perhaps you need a different abstraction than
EventNotifier (let's call it WakeupNotifier) which would also use
eventfd but it would provide a smaller API.  Thanks to the smaller API,
it would not need EFD_NONBLOCK, unlike the regular EventNotifier, and it
could either set up a poll() handler calling read(), or use
IORING_OP_READV when io_uring is in use.

Paolo



--MaDoqHjjBxHp8eCAqI3jz65LJEMmeZZxz--

--xU0tVZrw8brOJjVsV01vKofMTvhRKZKxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl5D19IACgkQv/vSX3jH
roM+aAf/W3jBbdLNeQLTS0tYtPLyv8cKjG4tqJDI1MqsLa0ZboNfbejC+I//nLsn
yww6C9VTcbCtwGLsZcw6gHjRqJZH5jbZIlUKITmFYO1zs5wpIBr7zdjfQ7J6aJjJ
Gr2F/p+/Idy+PmetqsTaM2c+bluEodXk/mks5lqylxxuG8JNTwvl1ZHu9e2ITNAp
ZsftPzb78n5EPlZGGkcwwwGWj+285Ah5r2tN8UWZgn1EV5AQ/CUYwvzWLseeaNJA
q4Alm/OTEEqIY2QidMU48of2wCZA/kTNsO815RjUvIFE2fNtweISOu5ElDXn24Ov
ca6hSkq7yToF+9vxMrNZJsjJSrN3LA==
=7XVH
-----END PGP SIGNATURE-----

--xU0tVZrw8brOJjVsV01vKofMTvhRKZKxV--

