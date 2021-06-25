Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06003B3A46
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 02:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhFYA72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 20:59:28 -0400
Received: from smtp.bonedaddy.net ([45.33.94.42]:40130 "EHLO
        smtp.bonedaddy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFYA71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 20:59:27 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2021 20:59:27 EDT
Received: from [192.168.1.209] (n175-38-129-149.per2.wa.optusnet.com.au [175.38.129.149])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pabs3@bonedaddy.net)
        by smtp.bonedaddy.net (Postfix) with ESMTPSA id ED574180045;
        Thu, 24 Jun 2021 20:51:59 -0400 (EDT)
Authentication-Results: smtp.bonedaddy.net; dmarc=fail (p=none dis=none) header.from=bonedaddy.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bonedaddy.net;
        s=mail; t=1624582325;
        bh=zXuCZMd9zz98b+NCH+tpPpN/tUHyuBhG6l57d8TmYeQ=;
        h=Subject:From:To:Cc:In-Reply-To:References:Date;
        b=oG5DKZJw6f4PiGCpuQDdwTx31bY6q34/dz4Jk86xbEFgZ844cWjggZkd1i9v7B2Hz
         xQ+j4olt+FJeQwuGpvDkPPqGDVEFKrEV4uAikMiR5wCzSzuh8zTRq+j8JmzQIeyjcD
         +B566Ayg2nh5TG9bfGw4NwCc/mkMRIch8nuTLzdytu6Ui7FU9T0KxTOaBDdCLrHrge
         WQbmx7Km/FbS/7+0PSDLMNHaV7lfiHKqxSmXsdce3d0eGGq+zrLc/IuMynyHFzsYgr
         J9DFgzQ0jV6HJk+uXz+/+e9ZFVo2+DWh+XZlGthobUCnKrTvpQhKKCN5ykJLmUNexb
         f+Pts58pqb5iA==
Message-ID: <466172bd9e2e3e223685ea3fa11cb1f990113e6e.camel@bonedaddy.net>
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
From:   Paul Wise <pabs3@bonedaddy.net>
To:     Mel Gorman <mgorman@suse.de>, Balbir Singh <bsingharora@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        pbonzini@redhat.com, maz@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org
In-Reply-To: <20210512113419.GF3672@suse.de>
References: <20210505105940.190490250@infradead.org>
         <20210505222940.GA4236@balbir-desktop>
         <YJOzUAg30LZWSHcI@hirez.programming.kicks-ass.net>
         <20210507123810.GB4236@balbir-desktop> <20210512113419.GF3672@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ChuWidyUdrci/irWU01F"
Date:   Fri, 25 Jun 2021 08:50:55 +0800
MIME-Version: 1.0
User-Agent: Evolution 3.40.2-1 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-ChuWidyUdrci/irWU01F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-05-12 at 12:34 +0100, Mel Gorman wrote:

> Alternatively, I've added Paul Wise to the cc who is the latest
> committer to iotop.=C2=A0 Maybe he knows who could add/commit a check for
> sysctl.sched_delayacct and if it exists then check if it's 1 and display
> an error suggesting corrective action (add delayacct to the kernel comman=
d
> line or sysctl sched.sched_delayacct=3D1). iotop appears to be in mainten=
ance
> mode but gets occasional commits even if it has not had a new version
> since 2013 so maybe it could get a 0.7 tag if such a check was added.

Did the proposed changes get merged?

If so, please let me know the details of what needs to happen in iotop
and iotop-c to cope with the changes in the Linux kernel.

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-ChuWidyUdrci/irWU01F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAmDVKGwACgkQMRa6Xp/6
aaO8XQ/7BncsdOw1sINDr8GaBKzEocFNtwiEgN1V7sffj4clK7ZOvheQy8yIjFr3
mKDWLGQ68AfgVNeMnERlxyaxlFp+/rzJt1vhUdHNs/3BPY++HqcdwKVx2Ay/IHC4
PDtYcr/9hx0UwpImqzPckVgA5q5TqGgjP6AH5POOhrmn25FEvcRoEla8BwiIutWE
aFO00+4nFsR0t5ALbv3vH8yH0iFCIWK14Datd9iorDnU2Kghm1cNEgURjk1zU3Iq
0AQMn54+kxpHUUBzB9iasGrund3Tcs6aVcDprV/iVcWbMkGby5jQs3yfupJAgKI8
nA/SUQikwPnyV1i5W0CtRD4HV9PxPYiMhCM07+nMc2Q9wq/IKWXyzLwsZePwcxiS
zLwO0s/108ULzNxDC4nrcdWXR6tNpdkxi3dwGntjsMv0e5oYpDF0Vg3Zp6XjT7js
vRXDjZ39TUKQBupkzhQuj8z8AxOttfOKPAZIoaHBqboeTLaSFb+Ga3LRIvUU4Ohg
0sL4AemLw6UlK13UvjCtg54Q1UD5vvCkchzpFwR9mZGa0zowNPe5AzRuCu5Ci9QN
KRY+RrIIaArRPWfi8vSxSJJ1Avyd7XlthnJMnbq4qJtGtpPgorNeztnffo5dmuZt
hZzwkTha5vBjVE0wm5x0g/aYjMFO6J9JmYkV4FvRjQWgChnaW60=
=QHXq
-----END PGP SIGNATURE-----

--=-ChuWidyUdrci/irWU01F--

