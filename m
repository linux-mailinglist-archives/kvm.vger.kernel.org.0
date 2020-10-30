Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB032A04FC
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 13:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgJ3MHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 08:07:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgJ3MHa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 08:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604059602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dCy0R4WBzBwMlHPUHr9Zz+5Uhtrk4oJxTBMJenFrdaE=;
        b=VZ8xNNsBEiTDnoGgnvIdS8a1iC9gHem3IUKwVSHzkRt6gwsnGNoA+H89jcGz2RLKvvG/9y
        j2qe0js+4izvodtH+i/yzT1N2Mbu2ThEcLDeOP+oyOwfA2eINubYcR725hdP18uxgKFdrU
        +OI5DlORJSyJz3LmRXbfPYgtFCWcbas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-Sy5gUsywP36n0sjQVtDfrA-1; Fri, 30 Oct 2020 08:06:38 -0400
X-MC-Unique: Sy5gUsywP36n0sjQVtDfrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58D9C188C135;
        Fri, 30 Oct 2020 12:06:37 +0000 (UTC)
Received: from localhost (ovpn-113-41.ams2.redhat.com [10.36.113.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8E4860BFA;
        Fri, 30 Oct 2020 12:06:36 +0000 (UTC)
Date:   Fri, 30 Oct 2020 12:06:35 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Wu, Hao" <hao.wu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: ENQCMD
Message-ID: <20201030120635.GA320132@stefanha-x1.localdomain>
References: <20201030075046.GA307361@stefanha-x1.localdomain>
 <MWHPR11MB164567FA998B13128EB284D48C150@MWHPR11MB1645.namprd11.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB164567FA998B13128EB284D48C150@MWHPR11MB1645.namprd11.prod.outlook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2020 at 08:04:54AM +0000, Tian, Kevin wrote:
> > From: Stefan Hajnoczi <stefanha@redhat.com>
> > Sent: Friday, October 30, 2020 3:51 PM
> >=20
> > Hi,
> > The "Scalable Work Submission in Device Virtualization" talk at KVM
> > Forum 2020 was interesting and I have some beginner questions about
> > ENQCMD:
> > https://static.sched.com/hosted_files/kvmforum2020/22/Scalable_Work_Su
> > bmission_In_Device_Virtualization.pdf
> >=20
> > Security
> > --------
> > If the ENQCMD instruction is allowed for userspace applications, how ca=
n
> > they be prevented from writing to the MMIO address directly (without th=
e
> > ENQCMD instruction) and faking the 64-byte enqueue register data format=
?
> > For example, they could set the PRIV bit or an arbitrary PASID.
>=20
> ENQCMD payload is transmitted through DMWr transactions (slide 10), which
> cannot be triggered through other memory instructions. The device portal
> only handles DMWr transactions.

Thanks, that explains it! I was wondering the a regular write
transaction could fool the device :).

Stefan

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+cAcsACgkQnKSrs4Gr
c8gjUQf8Cz3bnmtojBjngXBB9jhNbNZcFMUrJd0zUQdPmGboSR1VG/hikQHxNA+s
gKIB8CHRB1G70P/V4xwowc6efSzB60utJwJLOwoMLnawSrYpCYcoYNKEcyzCxH/M
NmTSjFgPgyx/bCvXw7oIeZT9q+rqRWXyRV7xJIXyH/WVwj96pEwFXSlAwVBAMPIT
UNICGLq49/HiQ0v1nX/+VAGJVr6NErO/AF5/cIcI39q1sU7tVRA2xTb3wP5SZR+b
Yr9nKQLjcUjmI1hWRqjS4eFS7BwWkM3BVcoyEwLQPEKa763R6j3OCUPlMLFoikBJ
abWmPnKEE6dDcBftgM05J6ZMyKoz5w==
=In8c
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--

