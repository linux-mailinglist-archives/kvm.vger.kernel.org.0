Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFF823416A
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 10:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgGaIoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 04:44:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60352 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728412AbgGaIoD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 04:44:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596185041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g6rCQ77cJ3KGTfJIcUziTCt2axfJDlPmcw2swo9EzwM=;
        b=A0PhdeJB8S+5asZMgw09u6aJmqUe5VTwKLL6eOc6bzFcbxMA7g5RcRcsRcd1QIFMODVxyn
        tgBqeDJNzvrlgRxyTI9RYCZx8UhMX5hOlRq3U8MncznnLTOkVqwLvfLGT61YAoLajyM5VG
        ahLbpkU/LhkXSLuvNLpYwvoOE6Czi+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-wvXEsELBOwOBwnJwsv7DDA-1; Fri, 31 Jul 2020 04:42:26 -0400
X-MC-Unique: wvXEsELBOwOBwnJwsv7DDA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12874803822;
        Fri, 31 Jul 2020 08:42:25 +0000 (UTC)
Received: from gondolin (ovpn-113-36.ams2.redhat.com [10.36.113.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE5555DA75;
        Fri, 31 Jul 2020 08:42:17 +0000 (UTC)
Date:   Fri, 31 Jul 2020 10:42:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
Message-ID: <20200731104205.37add810.cohuck@redhat.com>
In-Reply-To: <d9333547-b93e-629b-e004-53f1b581914f@linux.ibm.com>
References: <20200727095415.494318-1-frankja@linux.ibm.com>
        <20200727095415.494318-4-frankja@linux.ibm.com>
        <20200730131617.7f7d5e5f.cohuck@redhat.com>
        <1a407971-0b43-879e-0aac-65c7f9e29606@redhat.com>
        <d9333547-b93e-629b-e004-53f1b581914f@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=cohuck@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/8eQUDJuxBj0OzNO_W=EyW7w";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/8eQUDJuxBj0OzNO_W=EyW7w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Jul 2020 09:34:41 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/30/20 5:58 PM, Thomas Huth wrote:
> > On 30/07/2020 13.16, Cornelia Huck wrote: =20
> >> On Mon, 27 Jul 2020 05:54:15 -0400
> >> Janosch Frank <frankja@linux.ibm.com> wrote:
> >> =20
> >>> Test the error conditions of guest 2 Ultravisor calls, namely:
> >>>      * Query Ultravisor information
> >>>      * Set shared access
> >>>      * Remove shared access
> >>>
> >>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >>> ---
> >>>  lib/s390x/asm/uv.h  |  68 +++++++++++++++++++
> >>>  s390x/Makefile      |   1 +
> >>>  s390x/unittests.cfg |   3 +
> >>>  s390x/uv-guest.c    | 159 ++++++++++++++++++++++++++++++++++++++++++=
++
> >>>  4 files changed, 231 insertions(+)
> >>>  create mode 100644 lib/s390x/asm/uv.h
> >>>  create mode 100644 s390x/uv-guest.c
> >>> =20
> >>
> >> (...)
> >> =20
> >>> +static inline int uv_call(unsigned long r1, unsigned long r2)
> >>> +{
> >>> +=09int cc;
> >>> +
> >>> +=09asm volatile(
> >>> +=09=09"0:=09.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> >>> +=09=09"=09=09brc=093,0b\n"
> >>> +=09=09"=09=09ipm=09%[cc]\n"
> >>> +=09=09"=09=09srl=09%[cc],28\n"
> >>> +=09=09: [cc] "=3Dd" (cc)
> >>> +=09=09: [r1] "a" (r1), [r2] "a" (r2)
> >>> +=09=09: "memory", "cc");
> >>> +=09return cc;
> >>> +} =20
> >>
> >> This returns the condition code, but no caller seems to check it
> >> (instead, they look at header.rc, which is presumably only set if the
> >> instruction executed successfully in some way?)
> >>
> >> Looking at the kernel, it retries for cc > 1 (presumably busy
> >> conditions), and cc !=3D 0 seems to be considered a failure. Do we wan=
t
> >> to look at the cc here as well? =20
> >=20
> > It's there - but here it's in the assembly code, the "brc 3,0b". =20

Ah yes, I missed that.

>=20
> Yes, we needed to factor that out in KVM because we sometimes need to
> schedule and then it looks nicer handling that in C code. The branch on
> condition will jump back for cc 2 and 3. cc 0 and 1 are success and
> error respectively and only then the rc and rrc in the UV header are set.

Yeah, it's a bit surprising that rc/rrc are also set with cc 1.

(Can you add a comment? Just so that it is clear that callers never
need to check the cc, as rc/rrc already contain more information than
that.)

>=20
> >=20
> > Patch looks ok to me (but I didn't do a full review):
> >=20
> > Acked-by: Thomas Huth <thuth@redhat.com>
> >  =20
>=20
>=20


--Sig_/8eQUDJuxBj0OzNO_W=EyW7w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl8j2V0ACgkQ3s9rk8bw
L6+cmQ//YOsiSCQXbZfHRB7uLvY+MkhLsapdTrehS/6feRPBihr+1cGdJWGdgWJq
XLYAFVb0hqJGgjRM/tgaHHApzvpWg9+QYSUKb0DMxqJtMtGOCkkWc7f1fxygVSEg
rolnMDV42tTNjccWSSVrHbpyEitAC1AuQXWscxvEZmPXpkClzovLUwJzggxjE1JB
ffcnIR/Y/CNUvY0+rZtLrGGoCSLylVvNg2K1d66nyHvmqbazdEVrR31R94v9zo3A
omKZcaUlXAjhu1mdj+r2reLF1QTraIde0+KAZ9Ca1dlfied0gRLvxH2xjCaMH59a
fdkiEapFFfFUuMM+5pbIprZ4vQ5gu9Wh81WRVhj83rxFia8tmXo6PXSzJ/bF6v2k
iyCsaMPunUTQ8+X5F1dc+6t0JZJCMectyPyDQvR8WT7jkGc79JDKPTZGj4Tz1WBE
X9GK9wq3wOvDvD8gX4yJisbBK2iArJZ6nC2nTV9YetEXlGMMkkaY5IPaGDGASs5M
gINunXoCXN8jbZKIyFmV4Lf+l/msk1IY6rJmXR9daoge3CVZxazSdQXLg1FRH9hl
faietukjxmLW80tMCs8tFsDv1LZmBMr0ic5lH2Aw+XAwvpRINtAZvndkBvJZAstj
qA2ryGZw8uCq7+xmlnUJKXUMeMTlVWU9pNsh1jEXq0frk6EtHFo=
=FQDR
-----END PGP SIGNATURE-----

--Sig_/8eQUDJuxBj0OzNO_W=EyW7w--

