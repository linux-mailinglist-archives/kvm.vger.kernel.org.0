Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6B11BA7DB
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 17:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgD0PW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 11:22:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35800 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727840AbgD0PW5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 11:22:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588000976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j1P8r/1uiuCesfWRL2P1eB9YuwB+npl31XfwyVv6S0w=;
        b=KJfKFZU9z53vEAd6cr1p885Ma4iNkhIAFovv6bd6KXf68DTHR6WQ/vc6mh+H2gnnBIhFAB
        wkMh10KDZv+FnlQIvi8mAIgzA3qPFl2Y0ydY4J5ecGMBzPpUNc7n5aTzjnuweBLR83zmq9
        fmdF64q1tkJWE+JOfpA/1kGMGZKRgS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-oA5Rk_UpNlS7pKV9ScEOnA-1; Mon, 27 Apr 2020 11:22:52 -0400
X-MC-Unique: oA5Rk_UpNlS7pKV9ScEOnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA77118A076B
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 15:22:51 +0000 (UTC)
Received: from paraplu.localdomain (unknown [10.36.110.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81D665D716;
        Mon, 27 Apr 2020 15:22:51 +0000 (UTC)
Received: by paraplu.localdomain (Postfix, from userid 1001)
        id A592D3E048A; Mon, 27 Apr 2020 17:22:49 +0200 (CEST)
Date:   Mon, 27 Apr 2020 17:22:49 +0200
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, dgilbert@redhat.com,
        vkuznets@redhat.com
Subject: Re: [PATCH v2] docs/virt/kvm: Document running nested guests
Message-ID: <20200427152249.GB25403@paraplu>
References: <20200420111755.2926-1-kchamart@redhat.com>
 <20200422105618.22260edb.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200422105618.22260edb.cohuck@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 10:56:18AM +0200, Cornelia Huck wrote:
> On Mon, 20 Apr 2020 13:17:55 +0200
> Kashyap Chamarthy <kchamart@redhat.com> wrote:

[Just noticed this today ... thanks for the review.]

[...]

> > +A nested guest is the ability to run a guest inside another guest (i=
t
> > +can be KVM-based or a different hypervisor).  The straightforward
> > +example is a KVM guest that in turn runs on KVM a guest (the rest of
>=20
> s/on KVM a guest/on a KVM guest/

Will fix in v3.

[...]

> > +Terminology:
> > +
> > +- L0 =E2=80=93 level-0; the bare metal host, running KVM
> > +
> > +- L1 =E2=80=93 level-1 guest; a VM running on L0; also called the "g=
uest
> > +  hypervisor", as it itself is capable of running KVM.
> > +
> > +- L2 =E2=80=93 level-2 guest; a VM running on L1, this is the "neste=
d guest"
> > +
> > +.. note:: The above diagram is modelled after x86 architecture; s390=
x,
>=20
> s/x86 architecture/the x86 architecture/
>=20
> > +          ppc64 and other architectures are likely to have different
>=20
> s/to have/to have a/

Noted (both the above)

> > +          design for nesting.
> > +
> > +          For example, s390x has an additional layer, called "LPAR
> > +          hypervisor" (Logical PARtition) on the baremetal, resultin=
g in
> > +          "four levels" in a nested setup =E2=80=94 L0 (bare metal, =
running the
> > +          LPAR hypervisor), L1 (host hypervisor), L2 (guest hypervis=
or),
> > +          L3 (nested guest).
>=20
> What about:
>=20
> "For example, s390x always has an LPAR (LogicalPARtition) hypervisor
> running on bare metal, adding another layer and resulting in at least
> four levels in a nested setup..."

Yep, reads nicer; thanks.

[...]

> > +1. On the host hypervisor (L0), enable the ``nested`` parameter on
> > +   s390x::
> > +
> > +    $ rmmod kvm
> > +    $ modprobe kvm nested=3D1
> > +
> > +.. note:: On s390x, the kernel parameter ``hpage`` parameter is mutu=
ally
>=20
> Drop one of the "parameter"?

Will do.

> > +          exclusive with the ``nested`` paramter; i.e. to have
> > +          ``nested`` enabled you _must_ disable the ``hpage`` parame=
ter.
>=20
> "i.e., in order to be able to enable ``nested``, the ``hpage``
> parameter _must_ be disabled."
>=20
> ?

Yes :)

>=20
> > +
> > +2. The guest hypervisor (L1) must be allowed to have ``sie`` CPU
>=20
> "must be provided with" ?
>=20
> > +   feature =E2=80=94 with QEMU, this is possible by using "host pass=
through"
>=20
> s/this is possible by/this can be done by e.g./ ?
>=20
> > +   (via the command-line ``-cpu host``).
> > +
> > +3. Now the KVM module can be enabled in the L1 (guest hypervisor)::
>=20
> s/enabled/loaded/

Will adjust the above three; thanks.

> > +
> > +    $ modprobe kvm
> > +
> > +
> > +Live migration with nested KVM
> > +------------------------------
> > +
> > +The below live migration scenarios should work as of Linux kernel 5.=
3
> > +and QEMU 4.2.0.  In all the below cases, L1 exposes ``/dev/kvm`` in
> > +it, i.e. the L2 guest is a "KVM-accelerated guest", not a "plain
> > +emulated guest" (as done by QEMU's TCG).
>=20
> The 5.3/4.2 versions likely apply to x86? Should work for s390x as well
> as of these version, but should have worked earlier already :)

Heh, I'll specify the x86-ness of those versions :-)

> > +
> > +- Migrating a nested guest (L2) to another L1 guest on the *same* ba=
re
> > +  metal host.
> > +
> > +- Migrating a nested guest (L2) to another L1 guest on a *different*
> > +  bare metal host.
> > +
> > +- Migrating an L1 guest, with an *offline* nested guest in it, to
> > +  another bare metal host.
> > +
> > +- Migrating an L1 guest, with a  *live* nested guest in it, to anoth=
er
> > +  bare metal host.
> > +
> > +Limitations on Linux kernel versions older than 5.3
> > +---------------------------------------------------
> > +
> > +On x86 systems-only (as this does *not* apply for s390x):
>=20
> Add a "x86" marker? Or better yet, group all the x86 stuff in an x86
> section?

Right, forgot here, will do.

[...]

> > +Reporting bugs from "nested" setups
> > +-----------------------------------
> > +
> > +(This is written with x86 terminology in mind, but similar should ap=
ply
> > +for other architectures.)
>=20
> Better to reorder it a bit (see below).

[...]

> > +  - Kernel, libvirt, and QEMU version from L0
> > +
> > +  - Kernel, libvirt and QEMU version from L1
> > +
> > +  - QEMU command-line of L1 -- preferably full log from
> > +    ``/var/log/libvirt/qemu/instance.log``
>=20
> (if you are running libvirt)
>=20
> > +
> > +  - QEMU command-line of L2 -- preferably full log from
> > +    ``/var/log/libvirt/qemu/instance.log``
>=20
> (if you are running libvirt)

Yes, I'll mention that bit.  (I'm just to used to reports coming from
libvirt users :-))

> > +
> > +  - Full ``dmesg`` output from L0
> > +
> > +  - Full ``dmesg`` output from L1
> > +
> > +  - Output of: ``x86info -a`` (& ``lscpu``) from L0
> > +
> > +  - Output of: ``x86info -a`` (& ``lscpu``) from L1
>=20
> lscpu makes sense for other architectures as well.

Noted.

> > +
> > +  - Output of: ``dmidecode`` from L0
> > +
> > +  - Output of: ``dmidecode`` from L1
>=20
> This looks x86 specific? Maybe have a list of things that make sense
> everywhere, and list architecture-specific stuff in specific
> subsections?

Can do.  Do you have any other specific debugging bits to look out for
s390x or any other arch?

Thanks for the careful review.  Much appreciate it :-)

--=20
/kashyap

