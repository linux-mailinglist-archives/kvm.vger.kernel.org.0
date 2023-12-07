Return-Path: <kvm+bounces-4101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB0480DB2B
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 20:59:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F9891F21BCF
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 19:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3FE537FE;
	Mon, 11 Dec 2023 19:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fdsqZpvo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44295D8
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 11:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702324739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGinPrkiYBUv1YpF3Bzj3P62FX5Z+i7ujIcxMu/rMPE=;
	b=fdsqZpvoRTGRav6D4xX3a96pn3q0cU/NUovEqPzuKbCBtSUoouu0tBUDA4+hVmyM8ZUnFy
	N7ccsztmTPARNjK92jryFTTiiIga2UeZNwIQSH5Kyq99LcykyHlHgWEWdeUG2rAMKyMBGG
	DwfBjDoIGox3yaA0xgNGYa0UrtJvAuE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-v1B8qgfrPhenSkL7wH5zEw-1; Mon, 11 Dec 2023 14:58:54 -0500
X-MC-Unique: v1B8qgfrPhenSkL7wH5zEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60313869EC0;
	Mon, 11 Dec 2023 19:58:54 +0000 (UTC)
Received: from localhost (unknown [10.39.193.189])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7344FC15E6A;
	Mon, 11 Dec 2023 19:58:53 +0000 (UTC)
Date: Thu, 7 Dec 2023 06:11:10 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Carlos Santos <casantos@redhat.com>
Cc: qemu-devel@nongnu.org, Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Julia Suvorova <jusual@redhat.com>, Eric Blake <eblake@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org,
	Cornelia Huck <cohuck@redhat.com>,
	"Dr. David Alan Gilbert" <dgilbert@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
	Hanna Reitz <hreitz@redhat.com>,
	Fam Zheng <fam@euphon.net>, Aarushi Mehta <mehta.aaru20@gmail.com>
Subject: Re: [PULL 20/20] tracing: install trace events file only if necessary
Message-ID: <20231207111110.GA2132561@fedora>
References: <20230420120948.436661-1-stefanha@redhat.com>
 <20230420120948.436661-21-stefanha@redhat.com>
 <CAC1VKkMadcEV4+UwXQQEONTBnw=xfmFC2MeUoruMRNkOLK0+qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/JWOOMTQ9rSr2PPQ"
Content-Disposition: inline
In-Reply-To: <CAC1VKkMadcEV4+UwXQQEONTBnw=xfmFC2MeUoruMRNkOLK0+qg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Spam-Level: *


--/JWOOMTQ9rSr2PPQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 06, 2023 at 07:26:01AM -0300, Carlos Santos wrote:
> On Thu, Apr 20, 2023 at 9:10=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.=
com> wrote:
> >
> > From: Carlos Santos <casantos@redhat.com>
> >
> > It is not useful when configuring with --enable-trace-backends=3Dnop.
> >
> > Signed-off-by: Carlos Santos <casantos@redhat.com>
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Message-Id: <20230408010410.281263-1-casantos@redhat.com>
> > ---
> >  trace/meson.build | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/trace/meson.build b/trace/meson.build
> > index 8e80be895c..30b1d942eb 100644
> > --- a/trace/meson.build
> > +++ b/trace/meson.build
> > @@ -64,7 +64,7 @@ trace_events_all =3D custom_target('trace-events-all',
> >                                   input: trace_events_files,
> >                                   command: [ 'cat', '@INPUT@' ],
> >                                   capture: true,
> > -                                 install: true,
> > +                                 install: get_option('trace_backends')=
 !=3D [ 'nop' ],
> >                                   install_dir: qemu_datadir)
> >
> >  if 'ust' in get_option('trace_backends')
> > --
> > 2.39.2
> >
>=20
> Hello,
>=20
> I still don't see this in the master branch. Is there something
> preventing it from being applied?

Hi Carlos,
Apologies, I dropped this patch when respinning the pull request after
the CI test failures caused by the zoned patches.

Your patch has been merged on my tracing tree again and will make it
into qemu.git/master when the development window opens again after the
QEMU 8.2.0 release (hopefully next Tuesday).

Stefan

>=20
> --=20
> Carlos Santos
> Senior Software Maintenance Engineer
> Red Hat
> casantos@redhat.com    T: +55-11-3534-6186
>=20

--/JWOOMTQ9rSr2PPQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmVxqE4ACgkQnKSrs4Gr
c8itQwf8CoYzCIy0daz+4j0btXA9PoCbVlfHqCBOS+l8Pjr8FeyLkZg1wrWCMOWv
DuCpUgJX3U2f3WyCxWz9mJmgwp92fUmiE8Pw1zoynlR/241nC+vkv49DNiNpRbPg
OKG1sJq7tAKLFjUUnbd13xSKFhTGiSUWUWsPIKkqwgPpo2hx37BDMef8fQgKXvWg
MqabZjG+szwCYbOWM/EOLLFlkRC7hGYix1Zk1NrTDxKzvsjc10FKEtdM0eXsCXli
+mNIyImiXUJc06uBuvnosPyuW5NkRTKUtXVmB2FBvtXpZ7+zCjMUo8rew4zTaBKC
iEeiNvC7ywXAE9+2LTmWMh/acfIc5Q==
=98O6
-----END PGP SIGNATURE-----

--/JWOOMTQ9rSr2PPQ--


