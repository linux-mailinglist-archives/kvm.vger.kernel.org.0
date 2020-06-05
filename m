Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5691EF2EB
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 10:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgFEIPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 04:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgFEIPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 04:15:07 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549FBC08C5C2;
        Fri,  5 Jun 2020 01:15:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v19so7584122wmj.0;
        Fri, 05 Jun 2020 01:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dHbxfqZQs+MiEas28rc25pxvuy1zRUH+/v6FqkZZCBc=;
        b=COqoOl3bjsflXq+RMWBGHc7/i6lzipaIgcF73oaMaMPfMOaZD5aiznG88QRq+baU8q
         3LpbySylZGmMAMNY26TNJ3ud0fEKJ6Q6cczbAcjDXi/GkKQ/HMhDyvn+hq1E5XmDbIAM
         jW41v/3M5J6wVWh+BkVRzJ9fMEnMZGzngdC32EAFfYJjLkcbBNKAd77/ppijjQbe1Mx9
         nBMsyuiAvCwJh40l/vIbLMSxIdQmBTMXbydgt8jpplI6Vstiju4DpJ6ObuoshjXdFUx8
         cD4UGI6Up7YctmeximHTjBi/xMz5srPUoIPNKPaOEeGvvrQ8kKV3ogbESKkaV5587M0u
         u//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dHbxfqZQs+MiEas28rc25pxvuy1zRUH+/v6FqkZZCBc=;
        b=g2akr+HhhOx4rJVGRreKeKqC3kDCi3wopzGysvGLpU1XlyXgqm+mVIO95dKpxXhuTq
         e5lGWzXi+Duo792krMmdUldW7gvyv53wHkovTx0UM+lxHzSICLoSQwMFjvsCps/WFs8p
         aWDAvkXX6PvOYZ6+chwIiIqL6cVrppFaADTt3Iut8IlyHmqrC87K48pV0Xr3jsWBcd+X
         q5+COEANtklp9D8uc8QZQDRYwui73yBUlHmbYu1A3N5UiAqNdRBBdnprGYXqjb2INfbY
         y/va7rd+t89AG8oMhPq0eZtF+KfwVyDtyOJsOdbMjOR0vP07DPgw+zkW1O+JdoHPvW5I
         k1Ww==
X-Gm-Message-State: AOAM5333sMCJgl1N7HtnEUOpbvX4yLWavqDGSBAYc46DUoSttS2s9Kuq
        Mf6u/DuHskUoKx34bLNOeMg=
X-Google-Smtp-Source: ABdhPJyvKvwVasAsfTCkHvqXnqypvXaZ8wntEgi4xx4agE5ATp0lvGRT4jVb+YprnDTDar52zu5unw==
X-Received: by 2002:a7b:c7d8:: with SMTP id z24mr1442139wmk.28.1591344906024;
        Fri, 05 Jun 2020 01:15:06 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id q11sm10991924wrv.67.2020.06.05.01.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 01:15:04 -0700 (PDT)
Date:   Fri, 5 Jun 2020 09:15:03 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v3 01/18] nitro_enclaves: Add ioctl interface definition
Message-ID: <20200605081503.GA59410@stefanha-x1.localdomain>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-2-andraprs@amazon.com>
 <20200527084959.GA29137@stefanha-x1.localdomain>
 <a95de3ee4b722d418fd6cf662233cb024928804e.camel@kernel.crashing.org>
 <d639afa5-cca6-3707-4c80-40ee1bf5bcb5@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <d639afa5-cca6-3707-4c80-40ee1bf5bcb5@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 01, 2020 at 10:20:18AM +0300, Paraschiv, Andra-Irina wrote:
>=20
>=20
> On 01/06/2020 06:02, Benjamin Herrenschmidt wrote:
> > On Wed, 2020-05-27 at 09:49 +0100, Stefan Hajnoczi wrote:
> > > What about feature bits or a API version number field? If you add
> > > features to the NE driver, how will userspace detect them?
> > >=20
> > > Even if you intend to always compile userspace against the exact kern=
el
> > > headers that the program will run on, it can still be useful to have =
an
> > > API version for informational purposes and to easily prevent user
> > > errors (running a new userspace binary on an old kernel where the API=
 is
> > > different).
> > >=20
> > > Finally, reserved struct fields may come in handy in the future. That
> > > way userspace and the kernel don't need to explicitly handle multiple
> > > struct sizes.
> > Beware, Greg might disagree :)
> >=20
> > That said, yes, at least a way to query the API version would be
> > useful.
>=20
> I see there are several thoughts with regard to extensions possibilities.=
 :)
>=20
> I added an ioctl for getting the API version, we have now a way to query
> that info. Also, I updated the sample in this patch series to check for t=
he
> API version.

Great. The ideas are orthogonal and not all of them need to be used
together. As long as their is a way of extending the API cleanly in the
future then extensions can be made without breaking userspace.

Stefan

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7Z/wcACgkQnKSrs4Gr
c8ixagf9FLJp1V9BuzC0rZMPadtO77p0R7zJ3q/JbtZtO6VkFyiP1JuRRIE9QR7v
gGacilPQPMMrAXoiRjMojNFWUmOgYbqA51PDjzeQmUIGfgWDdBF8c6toyq3zjpFb
KP7GKrvVmKq2ZhvayPbS4lKK8PkFj3RUiHQ8AHxEw6EBb7OtuH2dg0IsXlDG4vv4
NMoHRm6IJ7L2P5e1CEjAyFfVK3/ATw8T7o7xYyYFrvR5AIptV2VC65fbzq5qSYjM
+cMxLYVnoqIQmZ9JR/tqEJCH7kNN5/FaCaDcQQGOiv8gWW7YQpFaQZ/YGTYnSB00
FCdtRZy4lkV5WYyK+E51CZ5e8Y5JKg==
=haJB
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
