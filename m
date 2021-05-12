Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF03537BD96
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 15:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhELNCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 09:02:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:59184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhELNCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 09:02:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7ADA4AE27;
        Wed, 12 May 2021 13:01:01 +0000 (UTC)
Date:   Wed, 12 May 2021 14:00:58 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Paul Wise <pabs3@bonedaddy.net>
Cc:     Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        pbonzini@redhat.com, maz@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
Message-ID: <20210512130058.GJ3672@suse.de>
References: <20210505105940.190490250@infradead.org>
 <20210505222940.GA4236@balbir-desktop>
 <YJOzUAg30LZWSHcI@hirez.programming.kicks-ass.net>
 <20210507123810.GB4236@balbir-desktop>
 <20210512113419.GF3672@suse.de>
 <9524e77d054f380e4711eaf68344ebba2d1271be.camel@bonedaddy.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <9524e77d054f380e4711eaf68344ebba2d1271be.camel@bonedaddy.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 12, 2021 at 08:23:51PM +0800, Paul Wise wrote:
> On Wed, 2021-05-12 at 12:34 +0100, Mel Gorman wrote:
>=20
> > Alternatively, I've added Paul Wise to the cc who is the latest
> > committer to iotop.=A0 Maybe he knows who could add/commit a check for
> > sysctl.sched_delayacct and if it exists then check if it's 1 and display
> > an error suggesting corrective action (add delayacct to the kernel comm=
and
> > line or sysctl sched.sched_delayacct=3D1). iotop appears to be in maint=
enance
> > mode but gets occasional commits even if it has not had a new version
> > since 2013 so maybe it could get a 0.7 tag if such a check was added.
>=20
> I am able to commit to the iotop repository but I don't have permission
> from the author to make releases nor do I have access to the website.
>=20
> I am happy to apply any patches anyone has for iotop and upload the
> result to Debian, or I'll be willing to write patches to cope with
> changes in Linux behaviour, if given a succinct explanation of what
> changes are needed in iotop, once the Linux changes are fully merged.
>=20

If you send me the same patch, I can do submit a request to the devel
package for openSUSE. I don't have commit access but I would be surprised
if the package maintainer didn't accept the request. Obviously, I'll
build+boot a kernel that includes the final version of this series in
case of any naming changes or other oddities.

> As well as the Python iotop implementation, there is one written in C=20
> with more features, so please also file an issue or pull request there.
> Please note that I don't have commit access to that repository though.
>=20

Good thinking. I'll open a bug on github when I've tested your iotop
patch so that the bug report is more coherent.

Thanks for the quick response.

--=20
Mel Gorman
SUSE Labs

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEElcbIJ2qkxLDKryriKjSY26pIcMkFAmCb0YoACgkQKjSY26pI
cMlCHQf9GT0P/UankEgBtZounGI78uf3N202drVjCELtqnzKvYq7G98vv0De+IFb
TbVMRqUZegJXJk0I4bGqtPUO3Nt5CxqrgSBVI9D3kLAGgzLZ8dQCLQqbszffJr6s
5Kap0bdCp94nLDrtknOFCM4ne7UYA0xF4q9E6v8n2mVfvrpIClX5AAnoijRobyeH
bICRMNLEficuhj+y7Gtkhm2oKQJAKW8mTLywUi/30KF8C7hVobgxSjnVCNil4Eqb
sMtyqDA1IfqhTsnnyQMUk6j7hQuqJOUf6zI1uv4lW2FDl165q3ozoKVjQ90Ac3LT
WUumVin9QgdId2Mxej74YYzn7MF7UA==
=nPPi
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
