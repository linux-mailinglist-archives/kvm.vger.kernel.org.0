Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ABC37BC90
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 14:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhELMcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 08:32:46 -0400
Received: from smtp.bonedaddy.net ([45.33.94.42]:32960 "EHLO
        smtp.bonedaddy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhELMcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 08:32:46 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2021 08:32:45 EDT
Received: from [192.168.1.209] (n49-190-168-235.per1.wa.optusnet.com.au [49.190.168.235])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pabs3@bonedaddy.net)
        by smtp.bonedaddy.net (Postfix) with ESMTPSA id D3DD9180043;
        Wed, 12 May 2021 08:24:43 -0400 (EDT)
Authentication-Results: smtp.bonedaddy.net; dmarc=fail (p=none dis=none) header.from=bonedaddy.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bonedaddy.net;
        s=mail; t=1620822289;
        bh=Y+OR1Cp/4WVuJF9ZRWmV7Y1lH7u4fHsASKa2u+zdctc=;
        h=Subject:From:To:Cc:In-Reply-To:References:Date;
        b=EvbvDlrg68v3KcnDddoysHB5R8QHRMdd3OICAoXh1TAvVAOBUIov3lwaWd+njm0ct
         s1HSTEGvy6uwnG604uYl3HwIlaujTRq3Lh8zti1peuJOLVRdn7MwmKvuls9qmuFbp1
         bbne7tmFoiRGGz8wruDdUm8xok6Qb07VUA15MXfe1W242wKyyLrv+Od2CersVRRIJM
         Y0gC/PhsvY7D1gOmEtq3IWVrlmIM+WEYn44B7Ed269R8oEqJo6A5hqnAhQQnUinqq7
         S9NzYb0kTR+oPG2gf/NqrxH8yigf9YBOG+p4E2dp1p+hiwbQ6nDFLtvs8eg+C8EH00
         59527nn9YXsWA==
Message-ID: <9524e77d054f380e4711eaf68344ebba2d1271be.camel@bonedaddy.net>
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
        protocol="application/pgp-signature"; boundary="=-Uj4PyxtEQbiiT89g6vh3"
Date:   Wed, 12 May 2021 20:23:51 +0800
MIME-Version: 1.0
User-Agent: Evolution 3.40.1-1 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-Uj4PyxtEQbiiT89g6vh3
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

I am able to commit to the iotop repository but I don't have permission
from the author to make releases nor do I have access to the website.

I am happy to apply any patches anyone has for iotop and upload the
result to Debian, or I'll be willing to write patches to cope with
changes in Linux behaviour, if given a succinct explanation of what
changes are needed in iotop, once the Linux changes are fully merged.

As well as the Python iotop implementation, there is one written in C=20
with more features, so please also file an issue or pull request there.
Please note that I don't have commit access to that repository though.

https://github.com/Tomas-M/iotop

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-Uj4PyxtEQbiiT89g6vh3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAmCbyNcACgkQMRa6Xp/6
aaN5RA/8C/BUKG210CJqpxGy7oVPI/iv6zRYnmlv6xNjnvtQspLDNa0YGHMFbdZt
2V5t+fwenyVOzbxsxIHjC0x9Wz0Iqu6bl3ayTzafAVUAj/8wcD8adkRF81lMmm91
eW75CqcnClTwuYk+AkrHGAgz+kPMa0mpqykwpycDYbKKAIx1BWPAqaQkfXf5WT/A
w9EkT9aM/2Qo41TM8iVGzXvIZKLSbnBIkGh4qHnasE9uQ4nXsV3/hiOEcfFkR8Lj
m+GypVb6f973XuvWSR0zbgcCxsCKPDn2OH99My5N8U3OdsaQGR8sUxl8+iD/UnJU
k20mvZbhvuQheATgjVGSzEQbeepQJ1LV/A0lsr/vsI5tEJgPtnQ8NmgQOdAqngFU
xs+8CbOGMSb4Z5WJhb5BpyCwuWSZUvF6OFQ+FvTSuRlyTMDNMf0YHme+m02NK8/Q
7bQqmuLZXNYRVYO3aLwmvvcYlMVbRQaf5EPS4wyDKfmYG2IooLOI1nv6WqfZEOqo
m2ynkyKCqVNanXg0NHWhWqw5XRLOpNQW7sYks3UzSPOB8B55irUqyfu4l91px5rm
NKoWJckb9Fh+iqWknWwaOzoi/CsKV2qCBm2wDOo/ha3mRQC/pKUKagijilRYzWdr
kwdFkZdGM9sWovE+CeBw/aGoPEGgNP9AkJnntqRMjzfl2FrF8JY=
=7Xv6
-----END PGP SIGNATURE-----

--=-Uj4PyxtEQbiiT89g6vh3--

