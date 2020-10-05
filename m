Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994C7283858
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgJEOqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 10:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgJEOqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 10:46:20 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1AAC0613A8
        for <kvm@vger.kernel.org>; Mon,  5 Oct 2020 07:46:19 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z1so9891864wrt.3
        for <kvm@vger.kernel.org>; Mon, 05 Oct 2020 07:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mti8ToBgeF8Xz8ii2x7rVmWXfXxcziA9CWhs2/5AMEo=;
        b=GqOXyYSc7hqR7m+PYE0zPD9UnibSUIVSI8A/3uHbx25H4uPe8Djx0YXph+V1W64iUr
         XwhtUbptGAqonoJp9MNFNvKsssIpVp1CSKeVqOynJDPW9ChZuchcZ58OABG/SslXNJbt
         3wqKD25DA2LV3BwcVnR1fFb/s2LTxI/GtgT8mdMyPpmTj5f+NAPn+aVAfN+4Xk2cMkGw
         QbRcvYL0qkFrvhbQFGc3krQcMyyhSmHAe2nLY3jZXN+Z9h9hFOPagpTqjSgNKTTKIx6L
         VjsU5mQ7IG+ZsG1NbQXzVjUoG0g4exPie9H0A/tkPDryhIC7GCeVI9YMbvDcueXrsqjj
         tXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mti8ToBgeF8Xz8ii2x7rVmWXfXxcziA9CWhs2/5AMEo=;
        b=cmuhY7SP4TUax5vjiVmGvMl6l8SRTlD97umINxJVSMjU5+FnAV9EUKeTrN7aSp4rq0
         YFfMqn0iTJMoZeIamD5KSszHHCgSDc2auA6NdhLA7m25H2xpCwbTcB7pcb/DgEAf/RX9
         GME7dGGJ9bZGZ4xVS9xf5xnB58NfmlTQFbIGPV8QOZ3wg9BJeJaH0YT+bYpwEjFFXnGE
         RIP6AQz8KkCfK8oGgHoGkvlZKA3mmqj03ADlPIg6V8CID/hbJi1/D3dvDa9CtYvJfWQR
         ueKcIzAtW0sAQ5kuRmdtcj/Jkn3bBSqGUWJUglNgnYB4vLai1hs240V1FS9xlMThxLAD
         VwkA==
X-Gm-Message-State: AOAM531sImeA2eOnIYhE5RgbPt+S5OZAmZ6Y68Yzw5TIf5a+DQpTp+sp
        gNTIqF+Y7qN5RsNc8FioPl4=
X-Google-Smtp-Source: ABdhPJz3USeDjZJlyWbMTaAKsHxwnbf3k3DjM4vHKrfgkQJg1Rkm4IqH3DyGE1iatUY7ikg32gfWrQ==
X-Received: by 2002:adf:fd49:: with SMTP id h9mr8172713wrs.115.1601909178459;
        Mon, 05 Oct 2020 07:46:18 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id u66sm370498wme.1.2020.10.05.07.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 07:46:16 -0700 (PDT)
Date:   Mon, 5 Oct 2020 15:46:15 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        John Snow <jsnow@redhat.com>
Subject: Re: KVM call for agenda for 2020-10-06
Message-ID: <20201005144615.GE5029@stefanha-x1.localdomain>
References: <874kndm1t3.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kA1LkgxZ0NN7Mz3A"
Content-Disposition: inline
In-Reply-To: <874kndm1t3.fsf@secure.mitica>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--kA1LkgxZ0NN7Mz3A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 02, 2020 at 11:09:44AM +0200, Juan Quintela wrote:
> For this call, we have agenda!!
>=20
> John Snow wants to talk about his new (and excting) developments with
> x-configure.  Stay tuned.

Hi,
Juan will be offline tomorrow so I will moderate the call.

You can join the call from your web browser here:
https://bluejeans.com/497377100

Meeting ID: 497377100
Phone numbers: https://www.redhat.com/en/conference-numbers

Stefan

--kA1LkgxZ0NN7Mz3A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl97MbcACgkQnKSrs4Gr
c8g8IwgAxK7tu8b3HFYwYyigwdvR/mgdyTPF5sj4wq+uwsJGrn+QZxEyg1SbFGCX
WcEy1vWEO9gXdcAkNvswz2sogML3vEQV7RE9zXLEC3S5sTK7LB2k7Is4oXKPgP0+
5tbKK4l3GU1bs4Z4rgZT/iBvikhuvdEtHulFWdE8SO/WsmbRctyowNuNHolSm34Z
+GPFQGhxShZeSAftHMirCyYFiz/M5pAzjOUCsTUGMCRevNC0XAuYa8pf9VTwSJwr
CyV1Ks+Lrc2DP03BuPKblwUbkFt/muiNjaVEyVBd65TIcoBx5pn2c3xSxCgy0CYz
RQulsmPO8OgcLb038/MsKZsjuNLjMg==
=hwnF
-----END PGP SIGNATURE-----

--kA1LkgxZ0NN7Mz3A--
