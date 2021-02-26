Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FB9326407
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 15:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhBZOYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 09:24:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:56710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhBZOYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 09:24:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614349429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EZ8keW/MmYo/ENSptctxMrJ/qqagf2xtsHbib8YaQAw=;
        b=LSycJx2ivWEdJJgeje1f3n3MzxIWq9i+1H14zarEBVnqfjsRyrE1qdgTZ8NRjn2eZHcbOM
        XyLdocTAt8/EyLAHtETrPeE/SklJq3eKUO2b+f5R8AKF6x5kuJ09iEfrJeDvX7XVPiq1ra
        t+e3m83qhS/4gCKyc9EfHgyaAdxWen4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5A13EAE30;
        Fri, 26 Feb 2021 14:23:49 +0000 (UTC)
Date:   Fri, 26 Feb 2021 15:23:42 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, tj@kernel.org, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <YDkEbv9u3OBNpk6f@blackbook>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-2-vipinsh@google.com>
 <YDVIdycgk8XL0Zgx@blackbook>
 <YDcuQFMbe5MaatBe@google.com>
 <YDdzcfLxsCeYxLNG@blackbook>
 <YDf6bpSxX6I5xdqZ@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0cdvV5m4yIkS6Bx1"
Content-Disposition: inline
In-Reply-To: <YDf6bpSxX6I5xdqZ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0cdvV5m4yIkS6Bx1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 25, 2021 at 11:28:46AM -0800, Vipin Sharma <vipinsh@google.com> wrote:
> My approach here is that it is the responsibility of the caller to:
> 1. Check the return value and proceed accordingly.
> 2. Ideally, let all of the usage be 0 before deactivating this resource
>    by setting capacity to 0
If the calling side can ensure itself that no new units of the resource
are used from that moment on, then it can work this way -- but describe
that in misc_cg_set_capacity() comment.

> Is the above change good?
I think both alternatives would work. But the latter (as I see it now)
would mandate dependency on CONFIG_CGROUP or it'd have to double the
similar logic itself. So maybe keeping the caller responsible explicitly
is simpler from this POV.

> Will there be any objection to extra information?
IMO it's unnecessary (stating this just for consistency reasons), no
strong opinion.

Michal

--0cdvV5m4yIkS6Bx1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmA5BGsACgkQia1+riC5
qSgTGRAAoZ8UZQoAOpamNp2/t/ZoGBQlc2u+5XDs9tPI1LzW7tJ3hNNitPkhB+aC
oh7SiaI8f6LkAqKPRjKsZwPi1oXJUHjaf9T7Vf8HF+CfmahqQBDI+iR3tHO2GDw8
Fn8GabyVuBtFQn8XDHmINeiYkXhTn4IGBO0VO1vrYkZrUSOoE4uIfIRz+8thfpeh
vigJRDm+DTSyNX1klJlfe3li8UHgK282Hf/C2EqXmpMULCdTcrxmsayzh9UgONjX
6ElaMeFSjYIPyYZUFlkwGYmXZ6Kfk0Z+HTm6D+/1nIIuvFImr5u7lY6ssxIb5BhG
VDuJDoIGZp+H7MvB1yRhPnygltT1JkRbi1EDpX5q8HDtFn05h/opFWU5A1leAh6U
mVwn1i6VZ7DEtyqEaCI8iyRLqCK86+fr4W0q9i5QzG5YzddlHqv9QZkF8mPJL5aj
ng008bFSfGliYdIoqmTeHYho+K6hgSVT6W+Sf5bUb0P2w8vWKPwJiFiYlBtitdv/
gReKLtnFUAzHV+w2J7loq0ZbrPAQhdqzHrJo1zpQsByTed0q/Nby8MM3OKk3vmFo
RjxxF7cLao8PIsud76c8LnwkLe3tqLjaXeUYeIKlLdrTjOJeSBjfUEx0nhywg88R
CDTzmts8VVbqWyhBmyuxSmgxYLWdcyX/XZlVexBZotGpGDk6ZWI=
=uKkz
-----END PGP SIGNATURE-----

--0cdvV5m4yIkS6Bx1--
