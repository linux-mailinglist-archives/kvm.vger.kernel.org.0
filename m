Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479F4273D19
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 10:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgIVIR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 04:17:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgIVIR1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 04:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600762645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oakQ8ZvOG/PZHFgINL6qXTOYOkalonDKl4hzXDidq5o=;
        b=gsHJliB2b1Pf7VoRNrxCZYkpa1Z2X8QeHQU85UPYLdZ7nDtZdb4NfeIW8WQDgNd84aRnBC
        AJQmSawDU7PyPyrCmPpgKgWWozodUuGFNZKbwY+D89wKPSfg6pyvNu11wM9rlHUiuUwvk2
        bukRE82rzOYtstinOz9fqZYmjjYiW84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-NmB85ZUzNVuAZQDy8gEBcA-1; Tue, 22 Sep 2020 04:17:23 -0400
X-MC-Unique: NmB85ZUzNVuAZQDy8gEBcA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8F881868405;
        Tue, 22 Sep 2020 08:17:18 +0000 (UTC)
Received: from localhost (ovpn-115-46.ams2.redhat.com [10.36.115.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E4395C225;
        Tue, 22 Sep 2020 08:17:05 +0000 (UTC)
Date:   Tue, 22 Sep 2020 09:17:05 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-riscv@nongnu.org, fam@euphon.net, ysato@users.sourceforge.jp,
        berto@igalia.com, jslaby@suse.cz, rth@twiddle.net, pl@kamp.de,
        david@redhat.com, pasic@linux.ibm.com, eblake@redhat.com,
        mreitz@redhat.com, marcandre.lureau@redhat.com,
        berrange@redhat.com, palmer@dabbelt.com, armbru@redhat.com,
        kvm@vger.kernel.org, yuval.shaia.ml@gmail.com, mst@redhat.com,
        cohuck@redhat.com, qemu-block@nongnu.org, sw@weilnetz.de,
        dgilbert@redhat.com, mdroth@linux.vnet.ibm.com,
        jiaxun.yang@flygoat.com, jsnow@redhat.com, jcmvbkbc@gmail.com,
        marcel.apfelbaum@gmail.com, Alistair.Francis@wdc.com,
        aurelien@aurel32.net, aleksandar.rikalo@syrmia.com,
        chenhc@lemote.com, aleksandar.qemu.devel@gmail.com,
        ehabkost@redhat.com, borntraeger@de.ibm.com,
        sunilmut@microsoft.com, thuth@redhat.com, pbonzini@redhat.com,
        sstabellini@kernel.org, anthony.perard@citrix.com,
        kraxel@redhat.com, peter.maydell@linaro.org, namei.unix@gmail.com,
        paul@xen.org, kwolf@redhat.com, kbastian@mail.uni-paderborn.de,
        sagark@eecs.berkeley.edu, jasowang@redhat.com, laurent@vivier.eu,
        xen-devel@lists.xenproject.org, mjrosato@linux.ibm.com,
        sheepdog@lists.wpkg.org, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, quintela@redhat.com,
        zhang.zhanghailiang@huawei.com
Subject: Re: [PATCH] qemu/atomic.h: prefix qemu_ to solve <stdatomic.h>
 collisions
Message-ID: <20200922081705.GB201611@stefanha-x1.localdomain>
References: <20200921162346.188997-1-stefanha@redhat.com>
 <160072176188.21069.7427016597134663502@66eaa9a8a123>
MIME-Version: 1.0
In-Reply-To: <160072176188.21069.7427016597134663502@66eaa9a8a123>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2020 at 01:56:08PM -0700, no-reply@patchew.org wrote:
> ERROR: Macros with multiple statements should be enclosed in a do - while=
 loop
> #2968: FILE: include/qemu/atomic.h:152:
> +#define qemu_atomic_rcu_read__nocheck(ptr, valptr)      \
>      __atomic_load(ptr, valptr, __ATOMIC_RELAXED);       \
>      smp_read_barrier_depends();
>=20
> ERROR: space required before that '*' (ctx:VxB)
> #3123: FILE: include/qemu/atomic.h:347:
> +#define qemu_atomic_read__nocheck(p) (*(__typeof__(*(p)) volatile*) (p))
>                                                                   ^
>=20
> ERROR: Use of volatile is usually wrong, please add a comment
> #3123: FILE: include/qemu/atomic.h:347:
> +#define qemu_atomic_read__nocheck(p) (*(__typeof__(*(p)) volatile*) (p))
>=20
> ERROR: space required before that '*' (ctx:VxB)
> #3125: FILE: include/qemu/atomic.h:349:
> +    ((*(__typeof__(*(p)) volatile*) (p)) =3D (i))
>                                   ^
>=20
> ERROR: Use of volatile is usually wrong, please add a comment
> #3125: FILE: include/qemu/atomic.h:349:
> +    ((*(__typeof__(*(p)) volatile*) (p)) =3D (i))
>=20
> ERROR: space required after that ',' (ctx:VxV)
> #3130: FILE: include/qemu/atomic.h:352:
> +#define qemu_atomic_set(ptr, i)     qemu_atomic_set__nocheck(ptr,i)
>                                                                  ^
>=20
> ERROR: memory barrier without comment
> #3205: FILE: include/qemu/atomic.h:410:
> +#define qemu_atomic_xchg(ptr, i) (smp_mb(), __sync_lock_test_and_set(ptr=
, i))
>=20
> WARNING: Block comments use a leading /* on a separate line
> #3280: FILE: include/qemu/atomic.h:462:
> +/* qemu_atomic_mb_read/set semantics map Java volatile variables. They a=
re
>=20
> WARNING: Block comments use a leading /* on a separate line
> #6394: FILE: util/bitmap.c:214:
> +        /* If we avoided the full barrier in qemu_atomic_or(), issue a
>=20
> WARNING: Block comments use a leading /* on a separate line
> #7430: FILE: util/rcu.c:85:
> +        /* Instead of using qemu_atomic_mb_set for index->waiting, and
>=20
> WARNING: Block comments use a leading /* on a separate line
> #7456: FILE: util/rcu.c:154:
> +        /* In either case, the qemu_atomic_mb_set below blocks stores th=
at free
>=20
> total: 7 errors, 4 warnings, 6507 lines checked

These are pre-existing coding style issues. This is a big patch that
tries to make as few actual changes as possible so I would rather not
try to fix them.

Stefan

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9pswEACgkQnKSrs4Gr
c8iYggf/cN1AvmT30HEFnk6TFaWwEK/1uPdJX8OsfFcwI7Y3ubB8wcLWnyXzwsOg
tRL2aDrOZ1cJcV8pHVtlNuJTcqox1NBFhSC6thYgo4PzXU7O2+LPijF+PrrJBrer
C/TLImTNNDBL8+IQX8bOBz4kVqyoEoodEvNsRUb05oyhVK0uej9yK0Vf+WOiRDmf
O4f1cAXTcA0qhhmU5NJO5sNe3cVEbrkHJ9wtK7mFlIRt/RuHLvW5M0UscL0/KF2o
SyWNVBIVFKBl/o16jkA4J+C1wAM6uPP3s5NYqJgaEUtYUaP7cir42blCMCa3MYz6
LSmqavtaJ2f531DBpjOq3G5c+fyk5A==
=nJgj
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--

