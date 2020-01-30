Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D201914DEE0
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgA3QTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:19:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727191AbgA3QTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 11:19:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580401146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJDuw8RyWmimZqJTb0SD7Zvy2aJ5w3lTDsQ2p3X6juI=;
        b=hyTM3YR2OmrCSx7JpF2S1Xkjrm+Ma8TaFXZc89T8B/nkRjzTRoNlD4+Qx/uzQdaGKjOxqU
        KzwgMId1AybHgI0k89Wl31c8JJrk5ikOiLnl2WMU8L6HrAauMHeCYJmtICGJmHXIqMEaqv
        zfGXTVIWdOXkw8uFsIXCJfPwShfuRnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-PY1kKj3_NESv_KNnXcXJ6Q-1; Thu, 30 Jan 2020 11:18:48 -0500
X-MC-Unique: PY1kKj3_NESv_KNnXcXJ6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 673EE107ACC7;
        Thu, 30 Jan 2020 16:18:46 +0000 (UTC)
Received: from localhost (unknown [10.36.118.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB6AF5DA75;
        Thu, 30 Jan 2020 16:18:42 +0000 (UTC)
Date:   Thu, 30 Jan 2020 16:18:41 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Kevin Wolf <kwolf@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Max Reitz <mreitz@redhat.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH 00/10] python: Explicit usage of Python 3
Message-ID: <20200130161841.GB182316@stefanha-x1.localdomain>
References: <20200129231402.23384-1-philmd@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200129231402.23384-1-philmd@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2020 at 12:13:52AM +0100, Philippe Mathieu-Daud=E9 wrote:
> Hello,
>=20
> These are mechanical sed patches used to convert the
> code base to Python 3, as suggested on this thread:
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg675024.html
>=20
> Regards,
>=20
> Phil.
>=20
> Philippe Mathieu-Daud=E9 (10):
>   scripts: Explicit usage of Python 3
>   tests/qemu-iotests: Explicit usage of Python 3
>   tests: Explicit usage of Python 3
>   scripts/minikconf: Explicit usage of Python 3
>   tests/acceptance: Remove shebang header
>   scripts/tracetool: Remove shebang header
>   tests/vm: Remove shebang header
>   tests/qemu-iotests: Explicit usage of Python 3
>   scripts: Explicit usage of Python 3
>   tests/qemu-iotests/check: Update to match Python 3 interpreter
>=20
>  scripts/analyse-9p-simpletrace.py                | 2 +-
>  scripts/analyse-locks-simpletrace.py             | 2 +-
>  scripts/decodetree.py                            | 2 +-
>  scripts/device-crash-test                        | 2 +-
>  scripts/kvm/kvm_flightrecorder                   | 2 +-
>  scripts/minikconf.py                             | 1 +
>  scripts/qapi-gen.py                              | 2 +-
>  scripts/qmp/qemu-ga-client                       | 2 +-
>  scripts/qmp/qmp                                  | 2 +-
>  scripts/qmp/qmp-shell                            | 2 +-
>  scripts/qmp/qom-fuse                             | 2 +-
>  scripts/render_block_graph.py                    | 2 +-
>  scripts/replay-dump.py                           | 2 +-
>  scripts/simpletrace.py                           | 2 +-
>  scripts/tracetool.py                             | 2 +-
>  scripts/tracetool/__init__.py                    | 1 -
>  scripts/tracetool/backend/__init__.py            | 1 -
>  scripts/tracetool/backend/dtrace.py              | 1 -
>  scripts/tracetool/backend/ftrace.py              | 1 -
>  scripts/tracetool/backend/log.py                 | 1 -
>  scripts/tracetool/backend/simple.py              | 1 -
>  scripts/tracetool/backend/syslog.py              | 1 -
>  scripts/tracetool/backend/ust.py                 | 1 -
>  scripts/tracetool/format/__init__.py             | 1 -
>  scripts/tracetool/format/c.py                    | 1 -
>  scripts/tracetool/format/d.py                    | 1 -
>  scripts/tracetool/format/h.py                    | 1 -
>  scripts/tracetool/format/log_stap.py             | 1 -
>  scripts/tracetool/format/simpletrace_stap.py     | 1 -
>  scripts/tracetool/format/stap.py                 | 1 -
>  scripts/tracetool/format/tcg_h.py                | 1 -
>  scripts/tracetool/format/tcg_helper_c.py         | 1 -
>  scripts/tracetool/format/tcg_helper_h.py         | 1 -
>  scripts/tracetool/format/tcg_helper_wrapper_h.py | 1 -
>  scripts/tracetool/format/ust_events_c.py         | 1 -
>  scripts/tracetool/format/ust_events_h.py         | 1 -
>  scripts/tracetool/transform.py                   | 1 -
>  scripts/tracetool/vcpu.py                        | 1 -
>  scripts/vmstate-static-checker.py                | 2 +-
>  tests/acceptance/virtio_seg_max_adjust.py        | 1 -
>  tests/acceptance/x86_cpu_model_versions.py       | 1 -
>  tests/docker/travis.py                           | 2 +-
>  tests/qapi-schema/test-qapi.py                   | 2 +-
>  tests/qemu-iotests/030                           | 2 +-
>  tests/qemu-iotests/040                           | 2 +-
>  tests/qemu-iotests/041                           | 2 +-
>  tests/qemu-iotests/044                           | 2 +-
>  tests/qemu-iotests/045                           | 2 +-
>  tests/qemu-iotests/055                           | 2 +-
>  tests/qemu-iotests/056                           | 2 +-
>  tests/qemu-iotests/057                           | 2 +-
>  tests/qemu-iotests/065                           | 2 +-
>  tests/qemu-iotests/093                           | 2 +-
>  tests/qemu-iotests/096                           | 2 +-
>  tests/qemu-iotests/118                           | 2 +-
>  tests/qemu-iotests/124                           | 2 +-
>  tests/qemu-iotests/129                           | 2 +-
>  tests/qemu-iotests/132                           | 2 +-
>  tests/qemu-iotests/136                           | 2 +-
>  tests/qemu-iotests/139                           | 2 +-
>  tests/qemu-iotests/147                           | 2 +-
>  tests/qemu-iotests/148                           | 2 +-
>  tests/qemu-iotests/149                           | 2 +-
>  tests/qemu-iotests/151                           | 2 +-
>  tests/qemu-iotests/152                           | 2 +-
>  tests/qemu-iotests/155                           | 2 +-
>  tests/qemu-iotests/163                           | 2 +-
>  tests/qemu-iotests/165                           | 2 +-
>  tests/qemu-iotests/169                           | 2 +-
>  tests/qemu-iotests/194                           | 2 +-
>  tests/qemu-iotests/196                           | 2 +-
>  tests/qemu-iotests/199                           | 2 +-
>  tests/qemu-iotests/202                           | 2 +-
>  tests/qemu-iotests/203                           | 2 +-
>  tests/qemu-iotests/205                           | 2 +-
>  tests/qemu-iotests/206                           | 2 +-
>  tests/qemu-iotests/207                           | 2 +-
>  tests/qemu-iotests/208                           | 2 +-
>  tests/qemu-iotests/209                           | 2 +-
>  tests/qemu-iotests/210                           | 2 +-
>  tests/qemu-iotests/211                           | 2 +-
>  tests/qemu-iotests/212                           | 2 +-
>  tests/qemu-iotests/213                           | 2 +-
>  tests/qemu-iotests/216                           | 2 +-
>  tests/qemu-iotests/218                           | 2 +-
>  tests/qemu-iotests/219                           | 2 +-
>  tests/qemu-iotests/222                           | 2 +-
>  tests/qemu-iotests/224                           | 2 +-
>  tests/qemu-iotests/228                           | 2 +-
>  tests/qemu-iotests/234                           | 2 +-
>  tests/qemu-iotests/235                           | 2 +-
>  tests/qemu-iotests/236                           | 2 +-
>  tests/qemu-iotests/237                           | 2 +-
>  tests/qemu-iotests/238                           | 2 +-
>  tests/qemu-iotests/242                           | 2 +-
>  tests/qemu-iotests/245                           | 2 +-
>  tests/qemu-iotests/246                           | 2 +-
>  tests/qemu-iotests/248                           | 2 +-
>  tests/qemu-iotests/254                           | 2 +-
>  tests/qemu-iotests/255                           | 2 +-
>  tests/qemu-iotests/256                           | 2 +-
>  tests/qemu-iotests/257                           | 2 +-
>  tests/qemu-iotests/258                           | 2 +-
>  tests/qemu-iotests/260                           | 2 +-
>  tests/qemu-iotests/262                           | 2 +-
>  tests/qemu-iotests/264                           | 2 +-
>  tests/qemu-iotests/266                           | 2 +-
>  tests/qemu-iotests/277                           | 2 +-
>  tests/qemu-iotests/280                           | 2 +-
>  tests/qemu-iotests/281                           | 2 +-
>  tests/qemu-iotests/check                         | 2 +-
>  tests/qemu-iotests/nbd-fault-injector.py         | 2 +-
>  tests/qemu-iotests/qcow2.py                      | 2 +-
>  tests/qemu-iotests/qed.py                        | 2 +-
>  tests/vm/basevm.py                               | 1 -
>  tests/vm/centos                                  | 2 +-
>  tests/vm/fedora                                  | 2 +-
>  tests/vm/freebsd                                 | 2 +-
>  tests/vm/netbsd                                  | 2 +-
>  tests/vm/openbsd                                 | 2 +-
>  tests/vm/ubuntu.i386                             | 2 +-
>  121 files changed, 95 insertions(+), 120 deletions(-)
>  mode change 100755 =3D> 100644 tests/acceptance/virtio_seg_max_adjust.py
>  mode change 100755 =3D> 100644 tests/vm/basevm.py
>=20
> --=20
> 2.21.1
>=20

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4zAeEACgkQnKSrs4Gr
c8i4Rwf8CbQ6iPcMGfSL3uMU2G1n1NGWN5x3KWK3QwVXGtSABwn1d9H+OOaFWlcf
K8M4ev1lAef8Aj6w9HcVgx/xqJ++2fI6u5hMIIgMkGTlGp0D908LNKy/stXYTaBK
th2bGcauEqoyVME+lXuAItxZzdsoLrrppF9XW+B1vIvtAAlKcy4vQl4lsW6AKESv
2vWuFMEgjtrusojBH3dSssRxy2AtWs7OrINVDTrd9EaWSROjdBVYDx5HlrsUwQri
phfYgCz5gcaVyNQR4lVOxf0NJI+GBLaGAfOm1OxPNLWFQGdQMIZtA2zvdtjkzwaX
GRdE8PD3TUm68hMKj/LkcK8rPNifPw==
=0FaO
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--

