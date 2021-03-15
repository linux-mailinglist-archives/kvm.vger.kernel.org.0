Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C24D33C68C
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 20:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhCOTKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 15:10:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:58734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230243AbhCOTKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 15:10:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615835412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gBh9rZ1pe0Dw23aY7I0BceM5dAfPMfFrVDEvEe02JBQ=;
        b=LtTDSfiEFPCuY2dr1iPNxVN3WP7R4nJ6QBfYlBO9dIEx3AZD7DORPVEpyqSZwxaNBD67ho
        thqQwRLsCImAVaMVNPEnBPxDviIafWx0by0BLCZeyNCaYS1XjGqT0/nwMs8kOH0kUWCam7
        aDMSyE7WKRGcejD1r5ZNrf11mumaWEc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 126BDAE8F;
        Mon, 15 Mar 2021 19:10:12 +0000 (UTC)
Date:   Mon, 15 Mar 2021 20:10:09 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Tejun Heo <tj@kernel.org>, rdunlap@infradead.org,
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
Message-ID: <YE+xEbwUoRj+snTY@blackbook>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <YETLqGIw1GekWdYK@slm.duckdns.org>
 <YEpoS90X19Z2QOro@blackbook>
 <YEupplaAWU1i0G6B@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WauBitk+7AKZVUrp"
Content-Disposition: inline
In-Reply-To: <YEupplaAWU1i0G6B@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--WauBitk+7AKZVUrp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 12, 2021 at 09:49:26AM -0800, Vipin Sharma <vipinsh@google.com> wrote:
> I will add some more information in the cover letter of the next version.
Thanks.

> Each one coming up with their own interaction is a duplicate effort
> when they all need similar thing.
Could this be expressed as a new BPF hook (when allocating/freeing such
a resource unit)?

The decision could be made based on the configured limit or even some
other predicate.

(I saw this proposed already but I haven't seen some more reasoning
whether it's worse/better. IMO, BPF hooks are "cheaper" than full-blown
controllers, though it's still new user API.)


> As per my understanding this is the only for way for loadable modules
> (kvm-amd in this case) to access Kernel APIs. Let me know if there is a
> better way to do it.
I understood the symbols are exported for such modularized builds.
However, making them non-GPL exposes them to any out-of-tree modules,
although, the resource types are supposed to stay hardcoded in the misc
controller. So my point was to make them EXPORT_SYMBOL_GPL to mark
they're just a means of implementing the modularized builds and not an
API. (But they'd remain API for out-of-tree GPL modules anyway, so take
this reasoning of mine with a grain of salt.)

Michal

--WauBitk+7AKZVUrp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBPsQ0ACgkQia1+riC5
qSh1cQ/9GddlgkcRcRP9oxFJbsVUxhnntwF8wqSof5oSUCBDSWP5Hz7M3P05aFrI
5VTcopKswg9sI+xO2rMiZb2guzOsy4soqTHRj6emRwbs09Pmtb9uEPrg3nbTZsAR
jUHnNRkhPB7LVMhyVRH4wmZRcD1mq0HiJLkzQNaPVG8D3XG0ge6xVr6+doCc2Ev6
UTrbbtcdBXmZX8hnLutMYu+QWNWQJyWJjii1nJKwby1v6heb10/fN40Ai1DQiOrR
l21qKqxrzUjzpJUOv7Rek/FHvKf1u6HcIEI8H1wx/tMdbptH7IMH6fAtRSDpzbnl
rPzovNq6h6r49VwFPKAaY0kx8u0Yv+IUME2GrjpmuxO+O3dvDJiaQeltisxlfWLn
/Cn236Hzs3aGAHHqqLDJXoxarCmdbFbLL5KjLfK8onoUuNkKf9jmZ2puG04Lgin6
iuvW2VEwUeKDXGxly0+JmzbRatQlvjfltDf7QlHx5zZxbGXYXVDFaz0AKx2hS6h+
XeoV5ko/poc6htsxJWdygD+DXl8y0c9JJlQsLHhBr5JPszYaw3BegCedwvZdF4ph
5QczC/tm0JiKqlb9tNIJ/kv2qIC97DbLt0Q0wv3idoAAZ9iTCwOSwRIdA79txnm4
brb1x019FyJQXQbSL9pP2saG0dbJ7PYgNHp//N/zFMahETXHkq4=
=lJqH
-----END PGP SIGNATURE-----

--WauBitk+7AKZVUrp--
