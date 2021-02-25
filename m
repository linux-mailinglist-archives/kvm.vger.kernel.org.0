Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E53324D47
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 10:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbhBYJyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 04:54:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:40404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235331AbhBYJxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 04:53:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614246779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pa5Bv87vsQTpNehYktuqD4xYQKRjzqObciTH5tWVW3c=;
        b=u1ctV2DOvv5M/TvL8/NGNEplVlPYpTSVWIJY6Fgko4qtzjF/gHw0OWAMLiSHDQ2b2mkXzZ
        OJMe1QSJXKkXn6QoauxzkkNhwaGXQ3gVkDh7eGFtuQUB386tBsy+u3z/9gwTwUoQmKXP4R
        NSylMMyzM4WXnI5wUI+gcDsJ9XQ5aVI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 23A6DADDC;
        Thu, 25 Feb 2021 09:52:59 +0000 (UTC)
Date:   Thu, 25 Feb 2021 10:52:49 +0100
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
Message-ID: <YDdzcfLxsCeYxLNG@blackbook>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-2-vipinsh@google.com>
 <YDVIdycgk8XL0Zgx@blackbook>
 <YDcuQFMbe5MaatBe@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kWQSwDEX83EtuxH+"
Content-Disposition: inline
In-Reply-To: <YDcuQFMbe5MaatBe@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--kWQSwDEX83EtuxH+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 24, 2021 at 08:57:36PM -0800, Vipin Sharma <vipinsh@google.com> wrote:
> This function is meant for hot unplug functionality too.
Then I'm wondering if the current form is sufficient, i.e. the generic
controller can hardly implement preemption but possibly it should
prevent any additional charges of the resource. (Or this can be
implemented the other subsystem and explained in the
misc_cg_set_capacity() docs.)

> Just to be on the same page are you talking about adding an events file
> like in pids?
Actually, I meant just the kernel log message. As it's the simpler part
and even pid events have some inconsistencies wrt hierarchical
reporting.

> However, if I take reference at the first charge and remove reference at
> last uncharge then I can keep the ref count in correct sync.
I see now how it works. I still find it a bit complex. What about making
misc_cg an input parameter and making it the callers responsibility to
keep a reference? (Perhaps with helpers for the most common case.)


Thanks,
Michal

--kWQSwDEX83EtuxH+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmA3c20ACgkQia1+riC5
qSi9BhAAlE9yZPtCtt/Vj6a3n7ho7173BwjAGMkNrRYQK8qoh8ebExxRtCAKL0E1
lyWI0cSq4Wul9uHduKwRLljqNpBziZYHrrpaQsT7uQw4A7yn62zAU2xbqDFm558D
9TSQxO59pXdYzyemTPLmkOmkPwjHE5YUfodskMG35tbgFzIxc5SN3izteu3rl/8b
A9Z2Q4Lo/iXi9qKNTpBtQzsNnhxO7ZL+ElkdhEINYX8G2H8tQ0DNVz+vXDXroMPp
N3L3CA00iWrr52jtOoec3TrMsVgnlU5l3jIJASbgt4s68ukWEbgpzdHGEj8U/BfW
dLoxQPNN8sWRChl4nehFtRq06z7hduHdOtqdgYq6y4UDKWJvBObjRFcPYIHuxN6W
MMZOKRvm4ocUENTLK5jbv4I87E7D3457NIYUnmp0+F24tB/D5kRAkT2tNIq7nfWO
e9GmQEeN30UyIudcI9NK7lHdJFEyXYasSR3nDKazdcDSBtxfQ0n65dmEVMtyMkRg
e9Hot1A97AmYYSzJNoUFKKem5f75wvS+/U6dOA3gM43U/69lxNL1mQLeHVkodjTK
Bz9YZgvDvx5sOsTfvmVNe2iFz5y35we5zh3hqLJWOEFSsPJ2lI2aTeVhku7x9w8N
/U90fUVnkjCV7X1gKYOav/vJprMAHOv3CtkfBVp1zXdvzZO2YsE=
=rCA2
-----END PGP SIGNATURE-----

--kWQSwDEX83EtuxH+--
