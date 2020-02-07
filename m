Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277F2155BB7
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 17:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgBGQ0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 11:26:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43625 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726874AbgBGQ0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 11:26:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581092769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxeqVJ/Oa/YlVBdGzWhoqslIEY+UxuZ7N1JDOSgyoqQ=;
        b=Ter8RomugqA/P4CPQkmuojbApqU71KCMQlPZUSojuF0Hq752NrCGmrCorU0rlawQKU4gWH
        vf2YULKlu9pAUzXB4JONCyUsvLhT3QdAQINUAxnTrO5Nlh3v4WLpLQBZutaLpCHI63zeEw
        /zmCiVsXzlnL5ouJ/EZHxDgxV0k9BM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-NBQ247HvPGu52Ha5hOOkJw-1; Fri, 07 Feb 2020 11:26:06 -0500
X-MC-Unique: NBQ247HvPGu52Ha5hOOkJw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B039D18A5510
        for <kvm@vger.kernel.org>; Fri,  7 Feb 2020 16:26:05 +0000 (UTC)
Received: from paraplu.localdomain (ovpn-116-47.ams2.redhat.com [10.36.116.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C7B4C46;
        Fri,  7 Feb 2020 16:26:02 +0000 (UTC)
Received: by paraplu.localdomain (Postfix, from userid 1001)
        id 42D2F3E048C; Fri,  7 Feb 2020 17:26:00 +0100 (CET)
Date:   Fri, 7 Feb 2020 17:26:00 +0100
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, dgilbert@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH] docs/virt/kvm: Document running nested guests
Message-ID: <20200207162600.GA30317@paraplu>
References: <20200207153002.16081-1-kchamart@redhat.com>
 <20200207164653.28849ef0.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200207164653.28849ef0.cohuck@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 04:46:53PM +0100, Cornelia Huck wrote:
> On Fri,  7 Feb 2020 16:30:02 +0100
> Kashyap Chamarthy <kchamart@redhat.com> wrote:
>=20

[...]

> > ---
> >  .../virt/kvm/running-nested-guests.rst        | 171 ++++++++++++++++=
++
> >  1 file changed, 171 insertions(+)
> >  create mode 100644 Documentation/virt/kvm/running-nested-guests.rst
>=20
> FWIW, there's currently a series converting this subdirectory to rst
> on-list.

I see, noted.  I hope there won't be any conflict, as this is a new file
addition.

> >=20
> > diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Docum=
entation/virt/kvm/running-nested-guests.rst
> > new file mode 100644
> > index 0000000000000000000000000000000000000000..e94ab665c71a36b7718ae=
bae902af16b792f6dd3
> > --- /dev/null
> > +++ b/Documentation/virt/kvm/running-nested-guests.rst
> > @@ -0,0 +1,171 @@
> > +Running nested guests with KVM
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>=20
> I think the common style is to also have a "=3D=3D=3D..." line on top.

Will add.  (Just that some projects don't use it; others do.  :-))


> > +
> > +A nested guest is a KVM guest that in turn runs on a KVM guest::
> > +
> > +              .----------------.  .----------------.
> > +              |                |  |                |
> > +              |      L2        |  |      L2        |
> > +              | (Nested Guest) |  | (Nested Guest) |
> > +              |                |  |                |
> > +              |----------------'--'----------------|
> > +              |                                    |
> > +              |       L1 (Guest Hypervisor)        |
> > +              |          KVM (/dev/kvm)            |
> > +              |                                    |
> > +      .------------------------------------------------------.
> > +      |                 L0 (Host Hypervisor)                 |
> > +      |                    KVM (/dev/kvm)                    |
> > +      |------------------------------------------------------|
> > +      |                  x86 Hardware (VMX)                  |
>=20
> Just 'Hardware'? I don't think you want to make this x86-specific?

Good point, will make it more generic.

>=20
> > +      '------------------------------------------------------'
> > +
> > +
> > +Terminology:
> > +
> > +  - L0 =E2=80=93 level-0; the bare metal host, running KVM
> > +
> > +  - L1 =E2=80=93 level-1 guest; a VM running on L0; also called the =
"guest
> > +    hypervisor", as it itself is capable of running KVM.
> > +
> > +  - L2 =E2=80=93 level-2 guest; a VM running on L1, this is the "nes=
ted guest"
> > +
> > +
> > +Use Cases
> > +---------
> > +
> > +An additional layer of virtualization sometimes can .  You
>=20
> Something seems to be missing here?

Err, broken sentence while rewriting (perils of distraction).  I'll fix
it.

> > +might have access to a large virtual machine in a cloud environment =
that
> > +you want to compartmentalize into multiple workloads.  You might be
> > +running a lab environment in a training session.
> > +
> > +There are several scenarios where nested KVM can be Useful:
>=20
> s/Useful/useful/

Will fix in v2.

[...]

> > +    $ cat /sys/module/kvm_intel/parameters/nested
> > +    Y
> > +
> > +For AMD hosts, the process is the same as above, except that the mod=
ule
> > +name is ``kvm-amd``.
>=20
> This looks x86-specific. Don't know about others, but s390 has one
> module, also a 'nested' parameter, which is mutually exclusive with a
> 'hpage' parameter.

Fair point, I'll add a seperate section for all relevant architectures.
Thanks for pointing it out.

> > +
> > +Once your bare metal host (L0) is configured for nesting, you should=
 be
> > +able to start an L1 guest with ``qemu-kvm -cpu host`` (which passes
> > +through the host CPU's capabilities as-is to the guest); or for bett=
er
> > +live migration compatibility, use a named CPU model supported by QEM=
U,
> > +e.g.: ``-cpu Haswell-noTSX-IBRS,vmx=3Don`` and the guest will subseq=
uently
> > +be capable of running an L2 guest with accelerated KVM.
>=20
> That's probably more something that should go into a section that gives
> an example how to start a nested guest with QEMU? Cpu models also look
> different between architectures.

Yeah, I wondered about it.  I'll add a simple, representative example.

[...]

> > +Again, to persist the above values across reboot, append them to
> > +``/etc/modprobe.d/kvm_intel.conf``::
> > +
> > +    options kvm-intel nested=3Dy
> > +    options kvm-intel enable_shadow_vmcs=3Dy
> > +    options kvm-intel enable_apivc=3Dy
> > +    options kvm-intel ept=3Dy
>=20
> x86 specific -- maybe reorganize this document by starting with a
> general setup section and then giving some architecture-specific
> information?

Yeah, good point.  Sorry, I was too x86-centric as I tend to just work
with x86 machines.  Reorganizing it as you suggest sounds good.

[...]

> > +Limitations on Linux kernel versions older than 5.3
> > +---------------------------------------------------
> > +
> > +On Linux kernel versions older than 5.3, once an L1 guest has starte=
d an
> > +L2 guest, the L1 guest would no longer capable of being migrated, sa=
ved,
> > +or loaded (refer to QEMU documentation on "save"/"load") until the L=
2
> > +guest shuts down.  [FIXME: Is this limitation fixed for *all*
> > +architectures, including s390x?]
>=20
> I don't think we ever had that limitation on s390x, since the whole way
> control blocks etc. are handled is different there. David (H), do you
> remember?

I see, I was just not sure.  Thought I better ask on the list :-)

Thank you for the quick review!

[...]

--=20
/kashyap

