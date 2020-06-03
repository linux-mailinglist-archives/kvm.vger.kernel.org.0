Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3821ECF6D
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 14:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgFCMHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 08:07:51 -0400
Received: from ozlabs.org ([203.11.71.1]:59969 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgFCMHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 08:07:50 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cSN472bmz9sT5; Wed,  3 Jun 2020 22:07:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591186068;
        bh=l66gCwIrRiSwuLg0ZaPKtVUkHcSSYrgP/ssMJmn7Cp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B2gjWvmzY6JjRzyG9hIEYu8DC8b/C6OHSOVnQCg2DQfmgKurMRHcc7517cpiAoWtB
         aA2HoNusPwbJ22VJLQR8y1oizFjJo7+7ZsBXgXCgcm0uQeczvnyLOC14snAw2SnK+e
         b5Xo5mtB5/gZF4vABkvU39UFcoDSH5D0+96CSf8E=
Date:   Wed, 3 Jun 2020 20:18:13 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Richard Henderson <richard.henderson@linaro.org>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 15/18] guest memory protection: Decouple
 kvm_memcrypt_*() helpers from KVM
Message-ID: <20200603101813.GC11091@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-16-david@gibson.dropbear.id.au>
 <eed92a20-3e0b-76c3-3ed0-3b467f12cf52@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <eed92a20-3e0b-76c3-3ed0-3b467f12cf52@linaro.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 01, 2020 at 09:13:01PM -0700, Richard Henderson wrote:
> On 5/20/20 8:43 PM, David Gibson wrote:
> > The kvm_memcrypt_enabled() and kvm_memcrypt_encrypt_data() helper funct=
ions
> > don't conceptually have any connection to KVM (although it's not possib=
le
> > in practice to use them without it).
>=20
> Yet?
>=20
> I would expect TCG implementations of these interfaces eventually, for
> simulation of such hardware.  Or are we expecting *this* interface to be =
used
> only with kvm/any-other-hw-accel, as the nested guest inside of the outer=
most
> tcg qemu that's simulating hardware that supports...

Yes, this.  The whole point of this stuff is that the guest is
protected *from the hypervisor*, and therefore qemu can't expect to
access guest memory.  It's hard to imagine any way TCG could deal with
that.

An implementation for a non-KVM accelerator is entirely plausible, on
the other hand.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7XeOQACgkQbDjKyiDZ
s5Ls3A//QSIvAgoVD5g9hPQj0P+czIYikWw2+UHbALGMprjYwk7HkkZRnUsfJrgT
2cpaSOV5Mm2Ip/yoU7chK50zs//NlR/VKHGMs6SbhG/zf2zbT1dqNUoIf1O3X9hf
xImS45BfTGKxgLFByYPrI2WgvkIfcMTdWt2GIYFZeNMwzlA/1CsFZY48OCfdfou6
a1G0NtThAnXxw08XzRhpGRkojSBhxxmqDfMPPA+NzrapbDzlru/l27HBiI17dhOy
58tQgi/mKJqXfcIFgN4fPUFn/+KYAzTNtHV7T1u1Tua/X7jQidCK0dwDTiyWXhmh
ynEbhhINsehlQo1bMN8QNe3g6+XTJR4u7wh3o5hlRgIkKqP0raKmqVU0Rn6TdY/D
LTYSmUj3f579YkoWAJ+Hosc6Q0Bclzm9aKL4NIvhCFQBlVN+s72rR+D1nM8pNu2Y
XEGn8x0tRGXM9dX2blcwD4DaAfNltZm4GI1FGZQSRxDXedN9iqox6enf8zH2WvPY
8bM48H5fsD+blCMzOUMmkwwnF/yuDZ4C5M56kPUrpaqMgyAq2ryYuRQpHaF48DyX
oYCToloDoR5/Y50J/8hmbjMgjWhvvaVLOtWhPyaNROmIfTPcRf8yUm5Yl69j6ewf
/shLfIMiRWHUem0604JdWg7debNenU/29lkCIx65IFAz3QUQfys=
=sr1S
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
