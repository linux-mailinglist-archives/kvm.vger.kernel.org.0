Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75486745FE
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 23:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjASWam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 17:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjASW3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 17:29:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24A8A731E;
        Thu, 19 Jan 2023 14:13:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9AB061D98;
        Thu, 19 Jan 2023 22:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A94C433D2;
        Thu, 19 Jan 2023 22:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674166425;
        bh=0TfIfsT7UPQtXb3sT22jU7uGw99A7souxhvdf2e+V9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UXJOQ07ln3xNI1VGM2Ekd+dqU7VasYlqn85+drkmHpU8ZmhSLftCzVTUNeMqDjOyu
         dsh6nk7CJ4/CyDlbu+r5pov2snB5LFE3j9fETGo7u68xTcvbNFpRJz3JckN/MjJ3Hn
         Ux/h6yeaTTRxic34et2/mHCxnKDYXBfeCKgdeJm+2ribsgpFeNq/zFNTilDFpPkybn
         kfzNcDxR8G2apTwQk103syCxkrc72QR2KJyEP++x5QPxtpABIV2/EG+wwiz5WBkbZI
         kk3XvZccPbyeAVdd6BnD3ScThEr8xdC9P5p67lZ55ngcDVceqFIG5HXWb3S4JB6MB5
         3S5f4GHdgiakA==
Date:   Thu, 19 Jan 2023 22:13:39 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andrew Jones <ajones@ventanamicro.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Palmer Dabbelt <palmer@dabbelt.com>, kernel@esmil.dk,
        bjorn@kernel.org
Cc:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        David Abdurachmanov <david.abdurachmanov@gmail.com>
Subject: Re: [PATCH v3 05/13] riscv: cpufeature: extend
 riscv_cpufeature_patch_func to all ISA extensions
Message-ID: <Y8nAk8c/acWf6++5@spud>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-6-jszhang@kernel.org>
 <2398293.3Lj2Plt8kZ@diego>
 <20230112092136.f2g43hrhmrqouy4y@orel>
 <Y8F2YxMHUt+djhX4@wendy>
 <Y8MRZQENua+wi34T@spud>
 <Y8hqptFcUgjhns4F@spud>
 <20230119082903.yk3uslfrjtxzassi@orel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="t/O9pox46sePZAp3"
Content-Disposition: inline
In-Reply-To: <20230119082903.yk3uslfrjtxzassi@orel>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--t/O9pox46sePZAp3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Me again!

On Thu, Jan 19, 2023 at 09:29:03AM +0100, Andrew Jones wrote:
> On Wed, Jan 18, 2023 at 09:54:46PM +0000, Conor Dooley wrote:
> > Hey!
> >=20
> > I guess here is the right place to follow up on all of this stuff...
> >=20
> > On Sat, Jan 14, 2023 at 08:32:37PM +0000, Conor Dooley wrote:

> > Today at [1] we talked a bit about the various bits going on here.
> > I'll attempt to summarise what I remember, but I meant to do this
> > several hours ago and am likely to make a hames of it.
> >=20
> > For Zbb/unaligned stuff, the sentiment was along the lines of there
> > needing to be a performance benefit to justify the inclusion.
> > Some of us have HW that is (allegedly) capable of Zbb, and, if that's t=
he

I did some very very basic testing today. Ethernet is still a no-go on
my visionfive 2 board, but the sd card works at least, so I can run w/
Zbb code people want & we can see how it goes!

At the very least, it is capable of executing the instructions that were
used in Appendix A. I didn't try to do anything else, because I am lazy
and if there were some pre-existing test programs I didn't want to go
and write out a bunch of asm myself!

impid appears to be 0x4210427, if that means anything to anyone!

> > case, will give it a go.
> > I think it was similar for unaligned, since there is nothing yet that
> > supports this behaviour, we should wait until a benefit is demonstrable.
> >=20
> > On the subject of grouping extension/non-extension capabilities into a
> > single cpufeature, Palmer mentioned that GCC does something similar,
> > for the likes of the Ventana vendor extensions, that are unlikely to be
> > present in isolation.

Jess pointed out on IRC that GCC doesn't support XVentanaCondOps
so maybe there was a mixup there. I don't think that really matters
though, as the point stands regardless of whether it was in GCC or not.

> > Those are (or were?) probed as a group of extensions rather than
> > individually.
> > I think it was said it'd make sense for us to unify extensions that will
> > only ever appear together single psuedo cpufeature too.
> >=20
> > For the bitfield approach versus creating pseudo cpufeatures discussion
> > & how to deal with that in alternatives etc, I'm a bit less sure what t=
he
> > outcome was.
> > IIRC, nothing concrete was said about either approach, but maybe it was
> > implied that we should do as GCC does, only grouping things that won't
> > ever been seen apart.
> > Figuring that out seems to have been punted down the road, as the
> > inclusion of our only current example of this (Zbb + unaligned) is
> > dependant on hardware showing up that actually benefits from it.
> >=20
> > The plan then seemed to be press ahead with this series & test the
> > benefits of the Zbb str* functions in Zbb capable hardware before making
> > a decision there.
> >=20
> > Hopefully I wasn't too far off with that summary...
>=20
> This matches my recollection. Thanks for the summary, Conor.

Cool, thanks.

--t/O9pox46sePZAp3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8nAkwAKCRB4tDGHoIJi
0jpZAP976+x+ZkRVzdavgP77bKd1eLS8QZmSr/7+1xVouP4CvgEAtgyo6s7+n/qA
oANTfCfXncWnh8YtZaGwZlbAOakaKgc=
=C0SZ
-----END PGP SIGNATURE-----

--t/O9pox46sePZAp3--
