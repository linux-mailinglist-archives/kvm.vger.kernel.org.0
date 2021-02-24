Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57692323B58
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 12:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhBXLfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 06:35:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234900AbhBXLfi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 06:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614166450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GztiOhY4vNIEM/XK5kioI43l4GhFLRpSzqvc3Vvbygs=;
        b=UtvLcxvrChPS04BhnQz+wwKYlitFjJdAm4wsVfulRS1AMz7CcLKu9wQnyZzbMqjcIv0Q0T
        Mhb0izjaYKXRWAysZyP2cKPA37mBRFIXpnWxFhuqJLWysOa0wm1din5BF81Npszey9i8ja
        r2ne2M+rKf4pP9JCCPkW34SEFzgLvDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-OJdNhx_yO0Sd3PDf_JEadg-1; Wed, 24 Feb 2021 06:34:08 -0500
X-MC-Unique: OJdNhx_yO0Sd3PDf_JEadg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB7A5107ACE4;
        Wed, 24 Feb 2021 11:34:06 +0000 (UTC)
Received: from localhost (ovpn-115-137.ams2.redhat.com [10.36.115.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFB2A17577;
        Wed, 24 Feb 2021 11:34:03 +0000 (UTC)
Date:   Wed, 24 Feb 2021 11:34:02 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Afanasova <eafanasova@gmail.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
Subject: Re: [RFC v3 0/5] Introduce MMIO/PIO dispatch file descriptors
 (ioregionfd)
Message-ID: <YDY5qrhIJM//VQ0z@stefanha-x1.localdomain>
References: <cover.1613828726.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="paWvJmHFw/6B/xvh"
Content-Disposition: inline
In-Reply-To: <cover.1613828726.git.eafanasova@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--paWvJmHFw/6B/xvh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 21, 2021 at 03:04:36PM +0300, Elena Afanasova wrote:
> This patchset introduces a KVM dispatch mechanism which can be used=20
> for handling MMIO/PIO accesses over file descriptors without returning=20
> from ioctl(KVM_RUN). This allows device emulation to run in another task=
=20
> separate from the vCPU task.
>=20
> This is achieved through KVM vm ioctl for registering MMIO/PIO regions an=
d=20
> a wire protocol that KVM uses to communicate with a task handling an=20
> MMIO/PIO access.
>=20
> TODOs:
> * Implement KVM_EXIT_IOREGIONFD_FAILURE
> * Add non-x86 arch support
> * Add kvm-unittests
> * Flush waiters if ioregion is deleted
 * Add ioctl docs to api.rst
 * Add wire protocol docs to <linux/ioregionfd.h>

Great, looks like userspace can really start trying out ioregionfd now -
most features are implemented. I will do a deeper review of the state
machine when you send the next revision.

Stefan

--paWvJmHFw/6B/xvh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA2OaoACgkQnKSrs4Gr
c8g89QgAxWZJEMU0XbyR4e2FdvuOKuhiez/Fy+w1HhcS0Hz+KLDMsCeMrdYU43FB
BhJx+TlNIEUavFSwvws0onrPRNx4G9vLX+d7sFzQDObkp4ny32G1PEune0YGuL8S
chN416tFZa6QoUjwmUfEymZmuKgA2n8pxqNGBrluX8uXQ0z6ELdkECndJ4HjAaFE
jXh49dU1O1kUJgh+PrwUU1Jcaj0K6r/IWE5uKOSdCFJPGAgXudJI/bABZMWIG6bm
KBtPfNt7vNaxsDM8J7PrcSGVhho0vhO+I1xed2WJsGQZGzWoMsq7yfEvOesFYD3e
oh74ap6ltQaO13zN0E6RCgwAgE9H2A==
=bAuI
-----END PGP SIGNATURE-----

--paWvJmHFw/6B/xvh--

