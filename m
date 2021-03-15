Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DC733C5C3
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 19:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhCOSed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 14:34:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:38734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhCOSeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 14:34:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615833258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H+y7FsHAfr9H0V0nZlpCJwqn4arhOTDKupfGhSsi4L0=;
        b=KjlbibSfXB7NG662v+nqeUvX9bQmFZ6Tn4FZ8LSyV2Dy1wShX6HyGPkQ/3oP/oi8ltOa82
        p4LArpJEH3uiUS4qK5AotGb4JiNd6JM5FPMBGV9OllfNYp2H0+Bq9mcfUIPNFQ81bOWovM
        7fmYs578Xsmg19z3fl9mWp/3G2HomOI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2014DAE8F;
        Mon, 15 Mar 2021 18:34:18 +0000 (UTC)
Date:   Mon, 15 Mar 2021 19:34:15 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     tj@kernel.org, rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <YE+op0MZKG41EALi@blackbook>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com>
 <YEpod5X29YqMhW/g@blackbook>
 <YEu74hkEPEyvxC85@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s/zzXfvrLmfa0Un9"
Content-Disposition: inline
In-Reply-To: <YEu74hkEPEyvxC85@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--s/zzXfvrLmfa0Un9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 12, 2021 at 11:07:14AM -0800, Vipin Sharma <vipinsh@google.com>=
 wrote:
> We should be fine without atomic64_t because we are using unsigned
> long and not 64 bit explicitly. This will work on both 32 and 64 bit
> machines.
I see.

> But I will add READ_ONCE and WRITE_ONCE because of potential chances of
> load tearing and store tearing.
>=20
> Do you agree?
Yes.

> This was only here to avoid multiple reads of capacity and making sure
> if condition and seq_print will see the same value.
Aha.

> Also, I was not aware of load and store tearing of properly aligned
> and machine word size variables. I will add READ_ONCE and WRITE_ONCE
> at other places.
Yeah, although it's theoretical, I think it also serves well to annotate
such unsychronized accesses.

Thanks,
Michal

--s/zzXfvrLmfa0Un9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBPqKEACgkQia1+riC5
qSihOg//SpH6gNPHIcbQ+iF47BrOX3zJwft1PTn3D8d3byIaot3/Sym+j12ttkQU
xstX/U3Mvimyouy50DFaYLiQ+EWMOPm8dzEw2nPOQFrL0bT6cjRdFnAzH7Y2m87c
GufRjzeGwn8H2dRTPHiUjc+ETQhdjIRUOL5yUgoJkDGmV1m63j4rQUS5JXoHuW/i
WH8ePRhc4SlGS/Ifgu3/+g0a3z+K46umCrHA9//BHI5gPyuvobyCdwIjrFekSDAq
5vWwp6YGavoX5ZoZALUpokgcZR/iVRhTpt5m6psuYFhb+i+sWi/jYVgAeGSzZgCU
G9uvFogZrPASTAHTss+MwdXoKUWWckG33D5MA8RtTXobewWrO7GcpTCFb79Mm0pF
JzdVgBuMMuphLjkXHgQnSX8wHQQ7R545TuaSLXZBM9AqDPFjScEwdi68qRKPqopt
wqqL64XiFnoICLnZjFpp11cL1gccY4cHYo71eNrVA1bdscO1iiO/c5xPbh9JD6cX
I/cwAksf9R+bW+XUWrgsDvx9VuCiWfhEtiT/obqgDyHEQfE7JtgVX2IDN1o1pLcM
+aGLPoyU/4Nc6aK898xqpJdzY/kCNB73YUuhdgH8lf1tY1P0myDTTivn7+XqZXd3
hfMM6u+AdaUZhqymfylaEnTpQpBH4VfRAsBS0SnFuUnT93GnkqU=
=+zv/
-----END PGP SIGNATURE-----

--s/zzXfvrLmfa0Un9--
