Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DDF29F2D2
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 18:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgJ2RTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 13:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgJ2RTv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 13:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603991990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=HvyBW2nvCeaOGLDf/P2oJ01ZxreAyO+J2d1YGbMpWBI=;
        b=bXdt3SBD6ocy4PtbzrqnbK9+7pHi9ETN8cxJgOT5sQbr5GCFV95EjGXIPIlsu6gq+E1je1
        4zmles8wQ/JGYagiJKIEJvFfDp//YicwG+HmImE6twJORkALJ/UIp9MCfEPIpmLlgergj1
        WwijRO+P8WAB8+DTas1KHyXSzwWYKSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-sY7N98vIN4uzpthHDC0Wmw-1; Thu, 29 Oct 2020 13:19:47 -0400
X-MC-Unique: sY7N98vIN4uzpthHDC0Wmw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADEF6805EF4;
        Thu, 29 Oct 2020 17:19:46 +0000 (UTC)
Received: from localhost (ovpn-113-78.ams2.redhat.com [10.36.113.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46C2455780;
        Thu, 29 Oct 2020 17:19:46 +0000 (UTC)
Date:   Thu, 29 Oct 2020 17:19:45 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     jiangyifei@huawei.com
Cc:     kvm@vger.kernel.org, anup@brainfault.org
Subject: RISC-V UER for trapless doorbell register writes
Message-ID: <20201029171945.GA290707@stefanha-x1.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
Thanks for the "HA-IOV: Applying Hardware-assisted Techniques to IO
Virtualization Framework" KVM Forum presentation about RISC-V UER for
trapless doorbell register writes.

I'm trying to understand the motivation for HA-IOV. Is the key point
that UER is faster than IPI at waking up a target thread that is
currently descheduled?

If not, then I missed something and maybe you could explain the
advantages of using UER?

Thanks,
Stefan

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+a+bEACgkQnKSrs4Gr
c8gFjwf/QshA+T188I5MVzr9VmaxUc9GF1fRhHVypRCnM1ETR4cWOcYSa+266Si7
MqMjtBtp5t8yf8R3KmDzRN8m0TXpdj9nM20cfhbhhXnSDOfu5T97soixslAp+j1A
dYArqUz2Hf5JsLsUGbHw3D8L/dRWBPpGTPaqVQl/6Wa93Qs/IA+pvN7OILOGgaek
zlh7yNIwJaJu/OIx/VWlG7+3eGlabrsEx4naNEGRtIXh5Yh7CADqTC9rh8H46RDf
t87ugQecz05QKQtOEPfJdOVdzdgooa08bQS/Skud40dgVZGIl2gd5iLJ70SVlVEX
vy+/Kj3XTejlns3c5UVSfOBV6/1DGw==
=PHcM
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--

