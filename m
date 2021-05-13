Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6943637F0EC
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 03:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhEMBbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 21:31:49 -0400
Received: from smtp.bonedaddy.net ([45.33.94.42]:33298 "EHLO
        smtp.bonedaddy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhEMBbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 21:31:48 -0400
Received: from [192.168.1.209] (n49-190-168-235.per1.wa.optusnet.com.au [49.190.168.235])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pabs3@bonedaddy.net)
        by smtp.bonedaddy.net (Postfix) with ESMTPSA id 75DC5180043;
        Wed, 12 May 2021 21:31:12 -0400 (EDT)
Authentication-Results: smtp.bonedaddy.net; dmarc=fail (p=none dis=none) header.from=bonedaddy.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bonedaddy.net;
        s=mail; t=1620869477;
        bh=jo6L1Lp7McpbL1Z7cGpI5dwqXVJEwyplDJ1NRFFYviA=;
        h=Subject:From:To:Cc:In-Reply-To:References:Date;
        b=LsxNjlV/IZszm2EOz/GRJeP3ns1jeQTNoK7R7ldZYkPbaCcdEo2Nu7e5020j5wg7X
         p5RIQ9ADSISR+e7omHY35IiO9+kHvax3WU017wr9B+NqFrm4EIH6A0iwboZ61jjcLg
         qtEXHowM7FuhoBhkFPfhDmdgcLjWguG6fIQM7ibnY9t0QU5bdZs8HSxrQUw0cxLm2B
         NW80sl+JDrlVGW4PeqGbRHYKQekA6PrRZWmZD1whM2WiTpYRuiae84hyjaRJudrdB1
         JRDeWuu2q/ekbOLQAJ+cEepU+ry0X54vONw60GPCi4BaSON2lZC7tGjtEyCSWTWVWC
         Qgx8wBTWGFa3A==
Message-ID: <ffbfcb73bfb7abb44cbe01db892bb492d80900c1.camel@bonedaddy.net>
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
From:   Paul Wise <pabs3@bonedaddy.net>
To:     Mel Gorman <mgorman@suse.de>
Cc:     Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        pbonzini@redhat.com, maz@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org
In-Reply-To: <20210512130058.GJ3672@suse.de>
References: <20210505105940.190490250@infradead.org>
         <20210505222940.GA4236@balbir-desktop>
         <YJOzUAg30LZWSHcI@hirez.programming.kicks-ass.net>
         <20210507123810.GB4236@balbir-desktop> <20210512113419.GF3672@suse.de>
         <9524e77d054f380e4711eaf68344ebba2d1271be.camel@bonedaddy.net>
         <20210512130058.GJ3672@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-oxFvlExZTgu9NltSQ5vc"
Date:   Thu, 13 May 2021 09:29:38 +0800
MIME-Version: 1.0
User-Agent: Evolution 3.40.1-1 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-oxFvlExZTgu9NltSQ5vc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-05-12 at 14:00 +0100, Mel Gorman wrote:

> If you send me the same patch, I can do submit a request to the devel
> package for openSUSE. I don't have commit access but I would be surprised
> if the package maintainer didn't accept the request. Obviously, I'll
> build+boot a kernel that includes the final version of this series in
> case of any naming changes or other oddities.

At this point I'm not clear exactly what needs to be done and whether
or not the details have been nailed down enough that it is time to
commit the change to the iotop-py and iotop-c git repositories.

I recommend upgrading the openSUSE iotop package to the latest git
commit rather than just applying the latest patch on top.

Alternatively, once the patch is applied I can probably overstep my
permissions and add a tag to the iotop-py git repository, in case folks
are happy to pull from the git repository instead of the website.

> Good thinking. I'll open a bug on github when I've tested your iotop
> patch so that the bug report is more coherent.

OK, sounds good.

PS: does Linux have a facility for userspace processes to convert
syscall names to numbers for the currently running Linux kernel? I
noticed that iotop-py just hard-codes the syscall numbers for
ioprio_set and ioprio_get on common arches, missing newer arches.

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-oxFvlExZTgu9NltSQ5vc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAmCcgP4ACgkQMRa6Xp/6
aaPPXxAAkN9epwOw3XK0bdtOoltH0wOnGHPnNcyh8LeRjNyaNcIuz/m+g2s9M3dH
s5SXKsNNJPj/UKQd+IA7zDE32qOwq+Vn2IspWjhJ7pLrcXIu8MNAcWoHyrJ3/Duo
025aTp+XoNqEL0PUJ+plsnC+3sTYFBiMxobkXgOUiJD6qxTypTEAxFyw4byUhsZl
2y4VPKFSWQy+oZwpWvmHiZ6W8h71iZzGrBDrhBpWEqvkx1Xeu4z317xZHYqAWSvR
CGUVMGC5uYcZqnUFl0PNJ94fnKVcu1JL06gdPBsTLUfeK+n0aVVB+8ZUSrli5Wc1
tcCGPG8XOdOFmDiPZX5xy1F7tdJl1uBTDYzB4r3+LcYJphrmOy13XTUmcgAtrqJk
HF7FJLalkmJ4VHO6wWZtCzQVYTz36vXCZEtJJLd/3blScwP61kWyaNKc5jhvAN7J
Cj2xAPg1kkD1SAR2QoCW2kQK8h9luA/oeYycRcm2Lk08R9krXVtwX5tzgQYwjn57
QFiZJoicyFvEAEh/lZWdc+2HEXuYAfYp0BFqhxEn/PTImlEbm7jV7DzUAAR+5fRm
eKm380DSQ1ZORqWwb92olgIiKfobLubUX/5b5iczSAu4ENgaHXjQ1Lrgp5WFR9nY
h4VBFZiVXrjWOOlFJ0s7M1fhEKKYI41sc6e196mv38TG9NrZbwA=
=t0Gt
-----END PGP SIGNATURE-----

--=-oxFvlExZTgu9NltSQ5vc--

