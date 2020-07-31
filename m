Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7931D23425E
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbgGaJVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:21:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20088 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731991AbgGaJVm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 05:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596187300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p/AbGD85AC3D05R3PpUdXYBBm4gZ2fwTONMaPVeH3Tg=;
        b=QK9Ju4hER0L89xsfxZI/bKQtBcZWXzHMUHsgmbKKXsNBDVNDYyduRSnr7d+nyc+KzIfS+3
        3JBrvd0h+Y8SZ9fiRwEumI6mtDJspS0JmLiaXMOc94OzGXprzvSFZMVjmPQqkYomgIfBSN
        0xQhk+iitKJpMHsDfeVXFcSrXFTct8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-KFm2PxtFO8KX9e0MmqignA-1; Fri, 31 Jul 2020 05:21:38 -0400
X-MC-Unique: KFm2PxtFO8KX9e0MmqignA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37AE41005504;
        Fri, 31 Jul 2020 09:21:37 +0000 (UTC)
Received: from gondolin (ovpn-113-36.ams2.redhat.com [10.36.113.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E641C5D9F1;
        Fri, 31 Jul 2020 09:21:32 +0000 (UTC)
Date:   Fri, 31 Jul 2020 11:21:22 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
Message-ID: <20200731112122.1db14419.cohuck@redhat.com>
In-Reply-To: <16eee269-d773-26df-a517-08f2265318c4@linux.ibm.com>
References: <20200727095415.494318-1-frankja@linux.ibm.com>
        <20200727095415.494318-4-frankja@linux.ibm.com>
        <20200730131617.7f7d5e5f.cohuck@redhat.com>
        <1a407971-0b43-879e-0aac-65c7f9e29606@redhat.com>
        <d9333547-b93e-629b-e004-53f1b581914f@linux.ibm.com>
        <20200731104205.37add810.cohuck@redhat.com>
        <16eee269-d773-26df-a517-08f2265318c4@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/85AWDb/urtlSoUNPc2_4Ym3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/85AWDb/urtlSoUNPc2_4Ym3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Jul 2020 11:06:25 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 7/31/20 10:42 AM, Cornelia Huck wrote:
> > On Fri, 31 Jul 2020 09:34:41 +0200
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> >> On 7/30/20 5:58 PM, Thomas Huth wrote: =20
> >>> On 30/07/2020 13.16, Cornelia Huck wrote:   =20
> >>>> On Mon, 27 Jul 2020 05:54:15 -0400
> >>>> Janosch Frank <frankja@linux.ibm.com> wrote:
> >>>>   =20
> >>>>> Test the error conditions of guest 2 Ultravisor calls, namely:
> >>>>>      * Query Ultravisor information
> >>>>>      * Set shared access
> >>>>>      * Remove shared access
> >>>>>
> >>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >>>>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >>>>> ---
> >>>>>  lib/s390x/asm/uv.h  |  68 +++++++++++++++++++
> >>>>>  s390x/Makefile      |   1 +
> >>>>>  s390x/unittests.cfg |   3 +
> >>>>>  s390x/uv-guest.c    | 159 ++++++++++++++++++++++++++++++++++++++++=
++++
> >>>>>  4 files changed, 231 insertions(+)
> >>>>>  create mode 100644 lib/s390x/asm/uv.h
> >>>>>  create mode 100644 s390x/uv-guest.c
> >>>>>   =20
> >>>>
> >>>> (...)
> >>>>   =20
> >>>>> +static inline int uv_call(unsigned long r1, unsigned long r2)
> >>>>> +{
> >>>>> +=09int cc;
> >>>>> +
> >>>>> +=09asm volatile(
> >>>>> +=09=09"0:=09.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> >>>>> +=09=09"=09=09brc=093,0b\n"
> >>>>> +=09=09"=09=09ipm=09%[cc]\n"
> >>>>> +=09=09"=09=09srl=09%[cc],28\n"
> >>>>> +=09=09: [cc] "=3Dd" (cc)
> >>>>> +=09=09: [r1] "a" (r1), [r2] "a" (r2)
> >>>>> +=09=09: "memory", "cc");
> >>>>> +=09return cc;
> >>>>> +}   =20
> >>>>
> >>>> This returns the condition code, but no caller seems to check it
> >>>> (instead, they look at header.rc, which is presumably only set if th=
e
> >>>> instruction executed successfully in some way?)
> >>>>
> >>>> Looking at the kernel, it retries for cc > 1 (presumably busy
> >>>> conditions), and cc !=3D 0 seems to be considered a failure. Do we w=
ant
> >>>> to look at the cc here as well?   =20
> >>>
> >>> It's there - but here it's in the assembly code, the "brc 3,0b".   =
=20
> >=20
> > Ah yes, I missed that.
> >  =20
> >>
> >> Yes, we needed to factor that out in KVM because we sometimes need to
> >> schedule and then it looks nicer handling that in C code. The branch o=
n
> >> condition will jump back for cc 2 and 3. cc 0 and 1 are success and
> >> error respectively and only then the rc and rrc in the UV header are s=
et. =20
> >=20
> > Yeah, it's a bit surprising that rc/rrc are also set with cc 1. =20
>=20
> Is it?
> The (r)rc *only* contain meaningful information on CC 1.
> On CC 0 they will simply say everything is fine which CC 0 states
> already anyway.

I would consider "things worked" to actually be meaningful :)

(I've seen other instructions indicating different kinds of success.)

>=20
> >=20
> > (Can you add a comment? Just so that it is clear that callers never
> > need to check the cc, as rc/rrc already contain more information than
> > that.) =20
>=20
> I'd rather fix my test code and also check the CC.
> I did check it for my other UV tests so I've no idea why I didn't do it
> here...
>=20
>=20
> How about adding a comment for the cc 2/3 case?
> "The brc instruction will take care of the cc 2/3 case where we need to
> continue the execution because we were interrupted.
> The inline assembly will only return on success/error i.e. cc 0/1."

Sounds good.

--Sig_/85AWDb/urtlSoUNPc2_4Ym3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl8j4pIACgkQ3s9rk8bw
L6+I0RAAmoCKVRrXzu8om3hAovHTbKnIf7+8PPW5tKHGnQZNaHVeo3jmioJBU6Ur
NYuMapYIwMxiBkOXkBpm/WFhLMZunWCKMmjrwZNGZGtp/sFHFvDTUAan2A1eCfZ4
23o4wHpQnMCHR3LkRgaHOvVbKrGwDwMr4n7K0btmsOQWQHFS0Ot2xEIHVwXrJj+k
xWPFVs66ylYwMPNifrtwHSejWtBvlN8QM0GvA9MDAYZCyQExRNfSyS9Ebx41+jg6
TGR3eUWrKoewmtv6JozCaCEiv3kIaRMCJkTR26FiCgUb0ZuiqtRBeMan9uxm5Yji
S+5u2Gty+yJSC6bKdhvITpDQ92mjMbVApQF6Hq4FGUY0APKXQa9+TL7CDX4ySBam
YNOVDn7gWnuzLE7pP+uRHWznYEj2SCvolDmU3zKSnYMVhKLvTqUdr/6/dwVCwq8A
JEnc8R3sXjhA3PhYaf2i4EpfPcivEBH1yuVYHtZh4t2V1+JQ2Uz7EfpAil63ACpH
dbOJj5hIYO8wBsS0e3KoNpXVPTyEmmKX1UuOqdumZzS7YUoAPZ2mGMG3Pb2ABCQW
nc9hdK31I4UGG8LDYy+nkWDpqcSA/ns0W+Cf0nW1IoyPVmiBvdWSNQZPfguNZlKJ
KSEhdsq1u0l8SllxLNWUYAbK0p0ws31p5+OiNa+IelnMJH2ry8I=
=Ib/4
-----END PGP SIGNATURE-----

--Sig_/85AWDb/urtlSoUNPc2_4Ym3--

