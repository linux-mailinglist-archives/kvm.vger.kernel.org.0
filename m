Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C27389D77
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 08:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhETGG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 02:06:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:52860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhETGG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 02:06:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621490706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9aV43J4LYYDq28unM+WOCaDSlePk+ZYEcjPfgd4X2r8=;
        b=Kv3FDhUuYeHz1ibksc6IbemGP0XoBacHr1xeskd0ZMP1uOFSJvZwah9n9d5kkX0sv+U2KY
        gA4uv+ScIubFedSeFJOdcBmZOUXL1oORwtresiguorTKqMHcDqjZ9tIedMqzOYl+6ZhZU2
        Tpuz9MH7qaEWhS7fKMaHEfFp20Y6uHo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6C49EAEE7;
        Thu, 20 May 2021 06:05:06 +0000 (UTC)
Message-ID: <2c0f621f2e1d3991edf198cb32d8e788ceeb6d7d.camel@suse.com>
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the
 actual event
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, rostedt@goodmis.org,
        y.karadz@gmail.com, Borislav Petkov <bpetkov@suse.de>
Date:   Thu, 20 May 2021 08:05:04 +0200
In-Reply-To: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Q4tI7q0ZmYDhB4CBxseV"
User-Agent: Evolution 3.40.1 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-Q4tI7q0ZmYDhB4CBxseV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-05-19 at 20:23 +0200, Stefano De Venuto wrote:
>=20
> Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
> Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
>
So, thanks to Boris, I realized that this is both wrong and
inconsistent (and it's my fault, not Stefano's).

This is how it should be:

Co-developed-by: Dario Faggioli <dfaggioli@suse.com>
Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>

Of course, we're happy to re-submit with it fixed, if necessary. Just
let us know.

Sorry and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-Q4tI7q0ZmYDhB4CBxseV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCl/BAACgkQFkJ4iaW4
c+4oOQ//SYj3i96wyJIL8hwnxiMDPVDF6HJj6gKJIuhzuKIWUr0G8MhjRvUiAFoV
wMGogO6eouUEMDSIYwhwR/p5+PHY5RhVYQWvq80LsD2wEaZVD94XdRSJnC+9C4/K
TztPFebAMX4ngbWSKc/BalK8Wjmpea9/6qKqv8NGMgXYPiWBdbJnfQXWrhHr9Mdg
nEN93bhAYJwhH+yG06D/SYDzLt9PMYLEzij+t38SBfeXE5gJdofGVDePwQjxX/oW
QDyUg+4i34RH9nIbNUUpJwk2tJsH57z+dmCXZ+kMk9MBvoQfuJ7asr0qp6a81auN
3543xlY34lKLwg6LTvp/Vzctnw7Pvdxssyc/rVuUKe9JesKM5Cv7J0/KyTUELuMt
1xRe+TJf/5QLoVtvXb83YVHkXcHb8qyk1knqT2sGnoSax/WwO99pmh+mXvK6bLBR
n3ZADfVLTnAClpTzFdrPLx7Nw06kPQNekPZLOaNd22FExgZEGp7Hr0SALFBnq/ve
Nu8v69XZ9/UVYmFxnA8AEMbISq3SlVA2QxlU9J6wnw3yUivwHC7f+4eq2qPhrSaF
neNixMiymSE/9t/hJbrtSsW9FlpcJdYbi46AOegva4+OP33w7qR0CnPjJkXl997w
G1gfpEjpz5yBd8VLkEF2dLzpwLTj+E/C1/OoxKE9RXZDh2qKjlY=
=7IoS
-----END PGP SIGNATURE-----

--=-Q4tI7q0ZmYDhB4CBxseV--

