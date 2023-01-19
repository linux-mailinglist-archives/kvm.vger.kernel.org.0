Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B036743A2
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjASUnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjASUnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:43:50 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A0A6FF8F;
        Thu, 19 Jan 2023 12:43:47 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NyZNG0j75z4xGM;
        Fri, 20 Jan 2023 07:43:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674161022;
        bh=OVMeYFepwe2nhDfTebMISEal8NwdZk/ON7NKF1Lf+8U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NP56b6ZJ8TNN2ruGvglHBXvf7r0HzRBQ1jcOqa8xpD9y13Hz5qC39yJHVhFvAzvln
         s5u5tBskuvU6cpHpQ8XkFrKffRQGjMaTSgTAig33TeReYRyKy3BTZavBZoqPOp0wDZ
         5aOvBozS/+RSc1nno607LHJVBbqOzI3QZw2o1FxJhLPKrlFZM/wDhDeCxo/g0jhhtf
         nqOlX7krozv5cy1LypCtUo5JWPotiBM4ZwVUawknZMFyvC2iNaItVO+yRZWqRyR3hC
         055zjK0IIVzgq4XXBXaML+xLtUgxgVWLM8Vq3p/RzGbXNwDInLCNqxR0SmFVXGZoWo
         qfwbpmPwkvmNA==
Date:   Fri, 20 Jan 2023 07:43:27 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Add kvm-x86 to linux-next
Message-ID: <20230120074327.3e96bb7e@canb.auug.org.au>
In-Reply-To: <Y8mhA9NBzAT27sh0@google.com>
References: <Y8mhA9NBzAT27sh0@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4Ys2hWAjez6hY/3l1TX.XQr";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/4Ys2hWAjez6hY/3l1TX.XQr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On Thu, 19 Jan 2023 19:58:59 +0000 Sean Christopherson <seanjc@google.com> =
wrote:
>
> Can you please add
>=20
>   https://github.com/kvm-x86/linux.git next
>=20
> to the set of linux-next inputs?  Going forward, it'll be my semi-officia=
l tree
> for KVM x86 (Paolo and I are still working out exactly how best to juggle=
 x86).

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/4Ys2hWAjez6hY/3l1TX.XQr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPJq28ACgkQAVBC80lX
0Gwr1wgAhfrbIKcWqaponb079qRd8RHg1Qz7Fxyo3HKkrHeAxU+aLwy3XUCKZokq
VdwEzzCfUt+47zb7+2jw3n0E1UQIlXxk1XkUXc5RLqRk0PRdmmfxM2X6nza7n0Cf
V0zO3SY8+aoxwCxm7GxliWw1c6UGy+SU9MTZW8ID+4zQmz87LCEhJX+ZsXojhkw+
YPKmZxqlPiMAGoeAjJwjypjZD7p2hrCX11r8HpyWrIO9/bvpl31KbUIP+BAnbdwf
UETXSW4SklKyBwwVVnTmn17kRivzaukvGBVJP8rI4gkAniqKmqpVJvkVrc9oxa66
9vdwwm9Cer4mAdyAe7c9NyXYwFXcCQ==
=p8IL
-----END PGP SIGNATURE-----

--Sig_/4Ys2hWAjez6hY/3l1TX.XQr--
