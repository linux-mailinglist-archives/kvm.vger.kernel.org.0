Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8469A337D14
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 19:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhCKS65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 13:58:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:57372 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhCKS6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 13:58:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615489110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UeR9O6P1emLf4uUoCF6hVv1qLiOIeDl0w/mf73dEI2E=;
        b=OwpKvPoTX9B4yab8n0scwNESzz7thwrJdKqX4WFz3lHFLf67loAd28uab7i47IZMql2eR5
        RyL+3KIt+uBJwUWHLTGWzqTYzha8lNAOaUkGr4IATny44mok/bF5C241k90yFbjbA+itVG
        +zk/i5e6dg7/tDEX/Cqm/oqkkDJPmlQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AB16BABD7;
        Thu, 11 Mar 2021 18:58:29 +0000 (UTC)
Date:   Thu, 11 Mar 2021 19:58:19 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Vipin Sharma <vipinsh@google.com>, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 0/2] cgroup: New misc cgroup controller
Message-ID: <YEpoS90X19Z2QOro@blackbook>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <YETLqGIw1GekWdYK@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O0rnu3bXQXs0OCyA"
Content-Disposition: inline
In-Reply-To: <YETLqGIw1GekWdYK@slm.duckdns.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--O0rnu3bXQXs0OCyA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Sun, Mar 07, 2021 at 07:48:40AM -0500, Tejun Heo <tj@kernel.org> wrote:
> Vipin, thank you very much for your persistence and patience.
Yes, and thanks for taking my remarks into account.

> Michal, as you've been reviewing the series, can you please take
> another look and ack them if you don't find anything objectionable?
Honestly, I'm still sitting on the fence whether this needs a new
controller and whether the miscontroller (:-p) is a good approach in the
long term [1].

I admit, I didn't follow the past dicussions completely, however,
(Vipin) could it be in the cover letter/commit messages shortly
summarized why cgroups and a controller were chosen to implement
restrictions of these resources, what were the alternatives any why were
they rejected?

In the previous discussion, I saw the reasoning for the list of the
resources to be hardwired in the controller itself in order to get some
scrutiny of possible changes. That makes sense to me. But with that, is
it necessary to commit to the new controller API via EXPORT_SYMBOL? (I
don't mean this as a licensing question but what the external API should
be (if any).)

Besides the generic remarks above, I'd still suggest some slight
implementation changes, posted inline to the patch.


Thanks,
Michal

[1] Currently, only one thing comes to my mind -- the delegation via
cgroup.subtree_control. The miscontroller may add possibly further
resources whose delegation granularity is bunched up under one entry.

--O0rnu3bXQXs0OCyA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBKaEIACgkQia1+riC5
qSgOghAAjNwE9wBkbntz80HPsO1VwMth86Q8t51F/1HKwoZ6k0VF2q5h0CvFo001
a1C+P8ZwgBEoFppNcDFZ7oGHmY5SuleyaUXJA+DXiiMyisZsgYYsrYwIZdvnYd1E
nMBAu1f/+JcTnMEMV/BQF/eQzSbXbN0Sb7sh1UwZ1gjC5vufWml2lCR8lWcUB8dW
1XhIs+p7KXxk/S9btShMO0sE13DNg0Teq74ugpDbQgM8hrESkC3d4/tJlVM8nqe6
O0kAtW2M4AP+R9MHyi59cCQAT6mV3mkGkEPtJr9rKwSlNAIS0Oe/8bZ/iGOmTHaP
HkdBbBEMeRHvZzgrJ3mzioJ8gY5VeOU7dAfgSdzt8xlXTkHqzm53DxSBtbzdzu54
C2PiElG9UXdLATAhH0GqCw8q352B0Xe66nZKSHKEK6oZQSBok+mjr/ZfKeTUKL5b
ktGsoAydg3GwXPozi9msTJ6MZLA8/kN2XvTKTyZYJMFUlzWVs2pSL/uxKmVpkXNS
A7jS3UYeLsQ6kZzW/6XTQQ+FRw2tAiIOOZDrU1lWr7Xoi0bY4DTHWupJgftyn0MQ
XHx7tqI56RSXgA0/GYPzyF/aO9cV0fUO/9aKE4M+GFDzp8OmpXUFprBy90UifF31
0y17JUH447oTUuyZUxcC93GcFVkMxVu5BvYPkYGmrvn6pe6c3u4=
=hCWq
-----END PGP SIGNATURE-----

--O0rnu3bXQXs0OCyA--
