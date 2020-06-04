Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08871EDD00
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgFDGMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:12:32 -0400
Received: from ozlabs.org ([203.11.71.1]:40133 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbgFDGMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:12:31 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cwRc3tX0z9sSf; Thu,  4 Jun 2020 16:12:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591251148;
        bh=+2BiyWsAjxRyUm+rxFtynXbdjxfdq5CMaIjOKUxVXlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=azJaSYNlfNmpMi+g8I443joKrfQxgO+mGtPHQ+0aL0K8CcZhYRaq3CqQQ5mlXVR3M
         fGIr37NPIT6cmfps8E4e66HvALbbPFoc0cri+DTZ2CEQcTTIlW3uHHwoKHlx3trr9s
         GBO4ZRIXqRdgdyIluH7GnEDTq8efFa07f8gVqFeU=
Date:   Thu, 4 Jun 2020 13:05:31 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <20200604030531.GA228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200529221926.GA3168@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20200529221926.GA3168@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2020 at 03:19:26PM -0700, Sean Christopherson wrote:
> On Thu, May 21, 2020 at 01:42:46PM +1000, David Gibson wrote:
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> >=20
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.
> >=20
> > The current code (committed or draft) for these features has each
> > platform's version configured entirely differently.  That doesn't seem
> > ideal for users, or particularly for management layers.
> >=20
> > AMD SEV introduces a notionally generic machine option
> > "machine-encryption", but it doesn't actually cover any cases other
> > than SEV.
> >=20
> > This series is a proposal to at least partially unify configuration
> > for these mechanisms, by renaming and generalizing AMD's
> > "memory-encryption" property.  It is replaced by a
> > "guest-memory-protection" property pointing to a platform specific
> > object which configures and manages the specific details.
> >=20
> > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > can be extended to cover the Intel and s390 mechanisms as well,
> > though.
> >=20
> > Note: I'm using the term "guest memory protection" throughout to refer
> > to mechanisms like this.  I don't particular like the term, it's both
> > long and not really precise.  If someone can think of a succinct way
> > of saying "a means of protecting guest memory from a possibly
> > compromised hypervisor", I'd be grateful for the suggestion.
>=20
> Many of the features are also going far beyond just protecting memory, so
> even the "memory" part feels wrong.  Maybe something like protected-guest
> or secure-guest?

I think those are too vague.  There are *heaps* of things related to
protecting or securing guests, the relevance of this stuff is that
it's protecting it from a compromised hypervisor.

> A little imprecision isn't necessarily a bad thing, e.g. memory-encryption
> is quite precise, but also wrong once it encompasses anything beyond plain
> old encryption.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7YZPkACgkQbDjKyiDZ
s5I0DxAAhUQiemOH1FQiFgGP7UsHU8vGg1PD+vb3LJKDOwpxvKCjvjpxwb5bxrf7
PKjbiZ7dGO2cZiToDwIXyl5jrH44KC6Me99oFTimg4UbLv6tlomXSbZXz9Sb9asg
bgu8vBOVeBhWHo/ipMR5yFHvz/gPblsLVIIILJH0b7QFVJn0VlXnq4N4d66p+nuW
SrNAfRp7JbsGb81Zn+sexCjWtNB3cQBHcpINU8jo1UocySt/T3LV8klIfZ0f0LF8
zrpUO8nT9OCEJ4XLxAUhlvOe0GJ3//Zn24gtWgeuVt+W+sGJtUELJ5BeMzm6oBGt
USTj661kKXoeuDUmftW6QEXA+IT5N5M3OfLMTLM+4Qh4OURAfRYbQaSpeMZBnPfb
tKykqke0smEv9nzkkyaPjpPqrDsmc99ZR1ZxY8M5JJeTdisqySKP4w3asOvQi1LY
Do7Ee4m67zgPpT7TRo6J6I8x/fIXXyf8eBEa+uLWYeWxHEpSrL6e6ry9u/U3VBkc
yy9/FzSdPVJ/CP6lOAJT9txkMAN5IC8OT8ryT9QX/fWGBK7fQZuy9jbrg4S/Pw3r
CwBfolUd9d5y4BxUZZBFffszBRmdylIgxRxgYekMvsH+YrCfbFI2OM7jCq3cuTaN
GKGuaQ53um4ihL2kUwIlO21TplOUCugia9aO2gOglZe1oh7bs2Y=
=yNx8
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
