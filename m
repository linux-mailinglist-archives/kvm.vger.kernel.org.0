Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846E34CFC77
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241983AbiCGLO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 06:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241818AbiCGLOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 06:14:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DAB6571;
        Mon,  7 Mar 2022 02:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rHYNV0ZYOcfFauctoccivR4ZVELdCLkYwb1pIpiTrIQ=; b=mi2nm8I1roa2F2/jWACjC75eDK
        3Rz820lEWTzeRYmh5g2mACydav4flIm/j+TAN60TDH/ZPeA1c1Jm3PWi3zA/eyVatbZGBJLdpY4ZC
        cQlaqx9V92Vc5gSzd6aEREbguQc5mNs33NODZhn7fzEeJr+V1REMKGnuY9oMsVF64MbF921BrRmSQ
        BsejN4r6K5nZjawkq6OUaJhI5dq5T++w345ZCgBiaOV0z73So8fnA/+nR93mKS0J5IpCI7MlfQPKB
        k1wSj+9MO9Uk5/uUYmRHZkS+BkkfdoihyX8ZREH6uDqa3uBXjB9+0hMbFIJ4qZkXfCPFwjEzlYpY8
        4XENh36w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRAkd-00F8L9-SJ; Mon, 07 Mar 2022 10:38:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 201C4300242;
        Mon,  7 Mar 2022 11:38:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0B20D30ED10F7; Mon,  7 Mar 2022 11:38:02 +0100 (CET)
Date:   Mon, 7 Mar 2022 11:38:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>, sdeep@vmware.com,
        pv-drivers@vmware.com, pbonzini@redhat.com, seanjc@google.com,
        kys@microsoft.com, sthemmin@microsoft.com,
        virtualization@lists.linux-foundation.org,
        Andrew.Cooper3@citrix.com
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Message-ID: <YiXgirw1kFOPgBgY@hirez.programming.kicks-ass.net>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
 <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
 <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
 <f40937c9-35f6-ce86-f07b-5cea09a963af@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tchVmGsWRnW2cmas"
Content-Disposition: inline
In-Reply-To: <f40937c9-35f6-ce86-f07b-5cea09a963af@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--tchVmGsWRnW2cmas
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 07, 2022 at 11:06:46AM +0100, Juergen Gross wrote:

> > diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> > index 4420499f7bb4..a1f179ed39bf 100644
> > --- a/arch/x86/kernel/paravirt.c
> > +++ b/arch/x86/kernel/paravirt.c
> > @@ -145,6 +145,15 @@ DEFINE_STATIC_CALL(pv_sched_clock, native_sched_cl=
ock);
> >   void paravirt_set_sched_clock(u64 (*func)(void))
> >   {
> > +	/*
> > +	 * Anything with ART on promises to have sane TSC, otherwise the whole
> > +	 * ART thing is useless. In order to make ART useful for guests, we
> > +	 * should continue to use the TSC. As such, ignore any paravirt
> > +	 * muckery.
> > +	 */
> > +	if (cpu_feature_enabled(X86_FEATURE_ART))
> > +		return;
> > +
> >   	static_call_update(pv_sched_clock, func);
> >   }
> >=20
>=20
> NAK, this will break live migration of a guest coming from a host
> without this feature.

I thought the whole live-migration nonsense made sure to equalize crud
like that. That is, then don't expose ART to the guest.


--tchVmGsWRnW2cmas
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEv3OU3/byMaA0LqWJdkfhpEvA5LoFAmIl4IkACgkQdkfhpEvA
5LqeGhAAgYjyLC44CdKrjJlYBSjuWb7BOGWqLy5TG90z6gQOkB/NWwifaAc6fEh/
II/sKNKy5OVfXqCCRaWC5ZMEV2PlDFh2LeYkw7uZ6aUYWKa5f4nZM1DnkMM1TR7j
KrdzuO7YfzERSg85pWo5ziuC4XKfGtV2Elf390C4KWftB7R/cnrpnjpgSUNEGkGb
wJJ3lvGDEEHwla+x1wu1yUuxQgeYTMtDBnLhI0YNHZwCXP1SYyZvctWUlIQ7b6cw
YJ4pUC295OKxKH1to7ZVSO+28RaGnQOYJubVuQQ8Pa1EO+ufl2toJb6vl7uRMEMQ
Qb5i27nDReiuQNh5ePbrzowfYx1us6kNLW+GD2OAddEioFTh2JULqGYjA581fCWK
9FFkZ4WncQNLjPd91dd/8XEmJ19I3f6FLwgM4oQpUcU7djYO2cCMdqR0HLvl0Iox
sAP6KBcbib9l035112KAQY6p/H/lW3THSyy5PQ9ZfG8me/Y8eXZ5cViaFh1bBtzQ
OgShEKKsZ/EDsmW5iYxXU7cAdspI6ynsQ/xfqAg50gu22+/ielVGXwW3yvlPS8eP
k1MdmqnQuWuc5LxYdK0Fp/40D8DkQCbbNcS8vEoFZmFyrR1oImx1bXUDVtku/Bry
RTh2DZ4xZX5DSb5jb2GsNThzj13DVPaQVwfl5wz/Yf0HqFTh34g=
=V7fO
-----END PGP SIGNATURE-----

--tchVmGsWRnW2cmas--
