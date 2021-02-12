Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A88531A024
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 14:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhBLNxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 08:53:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhBLNxp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 08:53:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613137937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sCmy6FY/1cRscZs0bdUOfj+rx34BkhzAqJKCsVIdL/g=;
        b=WArpu08fV98/yQC5CEXl1CTvWG4izPDS32tOa85AEl+wOILWK65xOzEyWcc4Po5fEZ0PzP
        ouf63pOiqwngcpRsx0c4lo/YVg6nAjsmJCvZ8v33iox+WkHG9GtMy6w1UIlIrBDWDMbuxK
        XW++QXFqhmC3SbhpbdF8E/iAL6qWnas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-9bmunfxWNvS5V5vrcG9hFg-1; Fri, 12 Feb 2021 08:52:13 -0500
X-MC-Unique: 9bmunfxWNvS5V5vrcG9hFg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26BA9801962;
        Fri, 12 Feb 2021 13:52:11 +0000 (UTC)
Received: from localhost (ovpn-114-207.rdu2.redhat.com [10.10.114.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D2C65D6AB;
        Fri, 12 Feb 2021 13:51:57 +0000 (UTC)
Date:   Fri, 12 Feb 2021 14:51:56 +0100
From:   Sergio Lopez <slp@redhat.com>
To:     "Florescu, Andreea" <fandree@amazon.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "rust-vmm@lists.opendev.org" <rust-vmm@lists.opendev.org>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        Alberto Garcia <berto@igalia.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        Aleksandar Markovic <Aleksandar.Markovic@rt-rk.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [Rust-VMM] Call for Google Summer of Code 2021 project ideas
Message-ID: <20210212135105.2llsgdiagk2tzu2m@mhamilton>
References: <CAJSP0QWWg__21otbMXAXWGD1FaHYLzZP7axZ47Unq6jtMvdfsA@mail.gmail.com>
 <1613136163375.99584@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zzrupzpehcdzn47i"
Content-Disposition: inline
In-Reply-To: <1613136163375.99584@amazon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zzrupzpehcdzn47i
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 12, 2021 at 01:22:43PM +0000, Florescu, Andreea wrote:
> Hey Stefan,
>=20
>=20
> Thanks for taking care of organizing GSoC, and for allowing rust-vmm to a=
lso participate under the QEMU umbrella!
>=20
> I am a bit unsure of how can we propose projects related to rust-vmm.
>=20
> We did a bit of brainstorming in our team, and we came up with 3 project =
ideas.
>=20
> I'll just paste them below, but please let me know if we were supposed to=
 propose them some other way.
>=20
>=20
> =3D=3D=3D Implement the Virtio Console device in Rust =3D=3D=3D
>=20
> '''Summary:''' Implement the basic emulation for the Virtio Console devic=
e in Rust
>=20
> Implement the basic functionality (excluding the optional features:
> VIRTIO_CONSOLE_F_SIZE, VIRTIO_CONSOLE_F_MULTIPORT, or VIRTIO_CONSOLE_F_EM=
ERG_WRITE)
> of the Virtio Console Device, using the Virtio building blocks (queue imp=
lementations,
> VirtioDevice traits) defined in rust-vmm/vm-virtio. The virtio console de=
vice uses
> one virtio queue for transmitting data, and one virtio queue for receivin=
g data.
> The implementation can be extended to also support a subset of the previo=
usly
> mentioned optional features.

FWIW, libkrun already has support for virtio-console with the basic
functionality and VIRTIO_CONSOLE_F_SIZE, and this code could be easily
borrowed for implementing it in some rust-vmm crate:

https://github.com/containers/libkrun/blob/main/src/devices/src/virtio/cons=
ole

Sergio.

> '''Links:'''
> * About rust-vmm: https://github.com/rust-vmm/community
> * rust-vmm/vm-virtio: https://github.com/rust-vmm/vm-virtio
> * virtio-console spec: https://docs.oasis-open.org/virtio/virtio/v1.1/csp=
rd01/virtio-v1.1-csprd01.html#x1-2550003
>=20
> '''Details:'''
> * Skill level: intermediate
> * Language: Rust
> * Mentor: iul@amazon.com
> * Suggested by: fandree@amazon.com<mailto:fandree@amazon.com>
>=20
>=20
> =3D=3D=3D Mocking framework for Virtio Queues =3D=3D=3D
>=20
> '''Summary:''' Implement a mocking framework for virtio queues
>=20
> Paravirtualized devices (such as those defined by the Virtio standard) ar=
e used
> to provide high performance device emulation. Virtio drivers from a guest=
 VM
> communicate with the device model using an efficient mechanism based on q=
ueues
> stored in a shared memory area that operate based on a protocol and messa=
ge format
> defined by the standard. Various implementations of devices and other
> virtualization building blocks require mocking the contents that a driver=
 would
> place into a Virtio queue for validation, testing, and evaluation purpose=
s.
>=20
> This project aims to lay the foundations of a reusable framework for mock=
ing the
> driver side of Virtio queue operation, that can be consumed by rust-vmm c=
rates and
> other projects. At the basic level, this means providing a flexible and e=
asy to
> use interface for users to set up the underlying memory areas and populat=
e contents
> (as the driver would do) for the basic split queue format in a generic ma=
nner. This
> can further be extended for the packed format and with device-specific mo=
cking
> capabilities.
>=20
> '''Links:'''
> * About rust-vmm: https://github.com/rust-vmm/community
> * Virtio queue spec: https://docs.oasis-open.org/virtio/virtio/v1.1/csprd=
01/virtio-v1.1-csprd01.html#x1-230005
> Issue in rust-vmm about reusing the mocking logic: rust-vmm/vm-virtio: ht=
tps://github.com/rust-vmm/vm-virtio
>=20
> '''Details:'''
> * Skill level: intermediate
> * Language: Rust
> * Mentor: aagch@amazon.com
> * Suggested by: aagch@amazon.com
>=20
>=20
> =3D=3D=3D Local running rust-vmm-ci =3D=3D=3D
>=20
> '''Summary:''' Run the rust-vmm-ci locally
>=20
> The rust-vmm-ci provides automation for uniformely running the tests on
> all rust-vmm repositories. It is built on top of Buildkite, and only allo=
ws
> running the tests in the Buildkite context. To run the same tests as in t=
he CI
> locally, users need to manually copy the Buildkite pipeline steps.
>=20
> The scope of this project is to make it possible for the same tests to ea=
sily run
> locally. This project makes it easier to contribute to all rust-vmm repos=
itories.
>=20
> In order for that to be possible, the following steps are required:
> - the Buildlkite pipeline is autogenerated from code instead of being a s=
tatic
> list of tests to run. This also allows us to uniformely use the same cont=
ainer
> version for running all the tests (instead of manually modifying each ste=
p in
> the pipeline)
> - the code for autogenerating the Buildkite pipeline is reused for genera=
ting
> a Python script which can be run locally
>=20
>=20
> '''Links:'''
> * rust-vmm-ci: https://github.com/rust-vmm/rust-vmm-ci
> * Buildkite pipeline that currently runs the tests: https://github.com/ru=
st-vmm/rust-vmm-ci/blob/master/.buildkite/pipeline.yml
> * About rust-vmm: https://github.com/rust-vmm/community
> * Buildkite documentation: https://buildkite.com/docs/tutorials/getting-s=
tarted
>=20
> '''Details:'''
> * Skill level: intermediate
> * Language: Python
> * Mentor: fandree@amazon.com
> * Suggested by: fandree@amazon.com
>=20
>=20
> ?Thanks again!
>=20
> Andreea
>=20
> ________________________________
> From: Stefan Hajnoczi <stefanha@gmail.com>
> Sent: Monday, January 11, 2021 1:47 PM
> To: qemu-devel; kvm; rust-vmm@lists.opendev.org; Alex Benn=E9e; Alexander=
 Graf; Alberto Garcia; David Hildenbrand; Eduardo Habkost; Igor Mammedov; J=
ohn Snow; Julia Suvorova; Gerd Hoffmann; Kevin Wolf; Laurent Vivier; Marc-A=
ndr=E9 Lureau; Aleksandar Markovic; Sergio Lopez; Stefano Garzarella; Paolo=
 Bonzini; Philippe Mathieu-Daud=E9
> Subject: [EXTERNAL] [Rust-VMM] Call for Google Summer of Code 2021 projec=
t ideas
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you can confirm the sender and know t=
he content is safe.
>=20
>=20
>=20
> Dear QEMU, KVM, and rust-vmm community,
> QEMU will apply for Google Summer of Code
> (https://summerofcode.withgoogle.com/) again this year.  This internship
> program offers paid, 10-week, remote work internships for
> contributing to open source.  QEMU can act as an umbrella organization
> for KVM kernel and rust-vmm projects too.
>=20
> Please post project ideas on the QEMU wiki before February 14th:
> https://wiki.qemu.org/Google_Summer_of_Code_2021
>=20
> What's new this year:
>  * The number of internship hours has been halved to 175 hours over
>    10 weeks. Project ideas must be smaller to fit and students will have
>    more flexibility with their working hours.
>  * Eligibility has been expanded to include "licensed coding school or
>    similar type of program".
>=20
> Good project ideas are suitable for 175 hours (10 weeks half-day) work by=
 a
> competent programmer who is not yet familiar with the codebase.  In
> addition, they are:
>  * Well-defined - the scope is clear
>  * Self-contained - there are few dependencies
>  * Uncontroversial - they are acceptable to the community
>  * Incremental - they produce deliverables along the way
>=20
> Feel free to post ideas even if you are unable to mentor the project.
> It doesn't hurt to share the idea!
>=20
> I will review project ideas and keep you up-to-date on QEMU's
> acceptance into GSoC.
>=20
> For more background on QEMU internships, check out this video:
> https://www.youtube.com/watch?v=3DxNVCX7YMUL8
>=20
> Stefan
>=20
> _______________________________________________
> Rust-vmm mailing list
> Rust-vmm@lists.opendev.org
> http://lists.opendev.org/cgi-bin/mailman/listinfo/rust-vmm
>=20
>=20
>=20
> Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Laz=
ar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in=
 Romania. Registration number J22/2621/2005.

--zzrupzpehcdzn47i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmAmh/sACgkQ9GknjS8M
AjWYIRAAlTC6OPBFMpGxM3yt6BHhhZh4Ghsu9h+IlogQSBg4afN//hqLcMP8KiLn
Pte6l1/Qft7joPL8UTOe9v1EK6c8wG09Q0378spyFqcjuQjd/aEgUKlV+Ukf4WQm
ROe34VMGGN3CiHVYCZQuST+TSMxDrgTiBMBck1dn61zfkaOtoF4hGsJazG3mQwVX
KbvtB6zslZOjePvCYd5LanaNyCxvw2R92kUVNmff1dc2dlUy3DoBtcoC49CQJcGQ
lGxlWBH/iMIwSEPDZnTvolnlTMLkReq2NXW1M7plr63k1tvihTaxfpNo6rSqiW8Z
hKTd7NWiP24TsCpsWB9n83baQHWasgzil2K1ttWNxN7hDJecAZ/SVb5ve9kJXd6J
jluQVBWlvoWVvNuzydUOi0o/zeOJc344Le1yqdVfwegzexWmtCwQ6ha6721RsL2G
spZDRpyF751UFW+NnDv1hg5wChuXpRV7Hlqt3Sq70jZbrXT95/awwzjLWUV4Gred
yyPBDMgOqqTjL5jz9x24CCk1cKDC/E54lm8w9a6uoc6pHsLMDeKah8g2Ppfpoe5o
x/7G4ze03Tb+E6VW4hK5YQeqod6110BTVi76PIXm0IUoTudZ+OMADQ+solXVEWDn
PcPBExG1m2hCra2LzLrl6W9R4g5IdNekwlVal9kKg8YisIoUqJo=
=JDg6
-----END PGP SIGNATURE-----

--zzrupzpehcdzn47i--

