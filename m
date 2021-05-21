Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846C138C082
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 09:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbhEUHPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 03:15:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:46622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235573AbhEUHO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 03:14:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621581214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7kAah6wOBUe6gBpHNLknbqTS8+LRlcH2a6NUBifyQNg=;
        b=HkgaFmLY+DiT7fqavNxSq58K8HL+lnUzxpJeCcxb7m8VALI4OvzM6eWhSw51LZpzWLDeGt
        sNsxZzfQgs8jc3pAoW4LF/eigI5IPvv0topUHdmMCSMFDtyhia0kmAO9HfUKdZqoZMgp6S
        pnEOT6yuqBcE9MlUrhjrBdqyG34+4rI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 00ACBAC36;
        Fri, 21 May 2021 07:13:33 +0000 (UTC)
Message-ID: <832ccdcd6b199f45b64fc10a70b9b7962071badd.camel@suse.com>
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the
 actual event
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, rostedt@goodmis.org,
        y.karadz@gmail.com
Date:   Fri, 21 May 2021 09:13:31 +0200
In-Reply-To: <875yzddg5n.ffs@nanos.tec.linutronix.de>
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
         <875yzddg5n.ffs@nanos.tec.linutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Ps9gwJ7uHHce6z6Gcj4m"
User-Agent: Evolution 3.40.1 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-Ps9gwJ7uHHce6z6Gcj4m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thomas,=20

And thanks a lot for the review!

On Thu, 2021-05-20 at 09:21 +0200, Thomas Gleixner wrote:
> On Wed, May 19 2021 at 20:23, Stefano De Venuto wrote:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 05eca131eaf2..c77d4866e239 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3707,6 +3705,8 @@ static noinstr void
> > svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_guest_enter_irqoff(=
);
> > =C2=A0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0trace_kvm_entry(vcpu);
>=20
> No. This violates the noinstr rules and will make objtool complain on
> a
> full validation run.
>=20
Ok, I see, sorry for not noticing it.

Well, in this specific case --considering others' reviews-- it seems
that the tracepoints will be moved to somewhere else anyway, but we'll
make sure to run all the proper validation steps next time.

Thanks again and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-Ps9gwJ7uHHce6z6Gcj4m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCnXZsACgkQFkJ4iaW4
c+69DA/+KRP2R8sKIOrew4DW30xOJLfRdrUsRiL6M4bQ/eUuw3ZGOgHADzN9GnhL
cIu8stZAKIxrSWcjpXrdELiIv/TFUJ1m5uH1Z7oi4ovku9E1AQDlV57iFCv61oTy
3use73BZyttv2pCSlUGjOz8bcmzxNkn5mBA3I69aMJQIygMcpEybwGG2Z+b5VzQW
cBI8a7YoE3dM7TN8lyluevg5Mry9DTRXKSb06dX/uGTX5vhwTHQEOJe2FCnqhyVG
GMTQjMOI9lIxrOdb68g4jAi+LeNTzVOimU7KSTDROLSkz2gLNST2/Jhc04rxmdbe
4IojvuzDDdgp9gWI+x3OOuRVSt/tlm7x80Mp/H2HalbeKh8VQLp9w+DUWO3/nbrt
8ASIC60HJSwFgBBz+g/0wypOpBOV2RH4AqdmuKyTWvSwJ8ifiezE6N0L6d4LmfWW
t4SInT+8BZU45D05xdkrv29hSIyjlCEL2W8naCO+vwVvTn/Pj5LjP9vOiklrSXEs
YclrK3y0Iu6fokYqWrkWCHXh/vLQLwvafk2lw5wXIKRhH0AVxm1PtbmW43gwpZru
iyabmiP2Oi3gVZsXA5wqWBR5guFGFSJT7cdzYn1Mh+0C5n+KJtqswhAo+r/wmgh9
8n8//T+zKdxj5tf8ZzkD2dPkqOvjyg4KvhdrVX43nS2n4a69qzc=
=PjA0
-----END PGP SIGNATURE-----

--=-Ps9gwJ7uHHce6z6Gcj4m--

