Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAF738C125
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 09:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhEUH7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 03:59:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:49766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhEUH7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 03:59:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621583902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2MfCuK8zXiUfS4x7BpQYH57RVEmWBdaLQ5ye3Gim4ps=;
        b=AuvKwq/s6EAq2b2l8dwrgkqtC+32CxFIHpWu4HYjgXzuDb0+GeRXnhpg7692Uo0TfTZxOC
        Xx9ZxqcncbC25ytmcnqBL4LfZIxmzIMIcdfonF/Ncu3Hyq9bERRrCGwKpD8wVNpr1MQc3L
        ePWh/YeZ0nFcwiN2666EiXjMRHT/6Ec=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BF605AD5C;
        Fri, 21 May 2021 07:58:21 +0000 (UTC)
Message-ID: <4e27adf7df5de525b9a4af9afbb3ca88ec3d09a4.camel@suse.com>
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the
 actual event
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, rostedt@goodmis.org,
        y.karadz@gmail.com
Date:   Fri, 21 May 2021 09:58:17 +0200
In-Reply-To: <ab44e5b1-4448-d6c8-6cda-5e41866f69f1@redhat.com>
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
         <YKaBEn6oUXaVAb0K@google.com>
         <ab44e5b1-4448-d6c8-6cda-5e41866f69f1@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-SuF+Jf1Vs/AnRIDVyYCD"
User-Agent: Evolution 3.40.1 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-SuF+Jf1Vs/AnRIDVyYCD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi!

On Thu, 2021-05-20 at 18:18 +0200, Paolo Bonzini wrote:
> On 20/05/21 17:32, Sean Christopherson wrote:
> > On VMX, I think the tracepoint can be moved below the VMWRITEs
> > without much
> > contention (though doing so is likely a nop), but moving it below
> > kvm_load_guest_xsave_state() requires a bit more discussion.
>=20
> Indeed; as a rule of thumb, the tracepoint on SVM could match the=20
> clgi/stgi region, and on VMX it could be placed in a similar
> location.
>=20
Ok. So, if this is uncontroversial enough, we're more than happy to go
for it... For now. :-)

Let us try it, and see how things end up looking.

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-SuF+Jf1Vs/AnRIDVyYCD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCnaBkACgkQFkJ4iaW4
c+7TYw//Yd4x4luYqBBLERLVz7tLFs96a4KjeAjIp/ydzphAy9LtZbv1tU3ZU5T/
cxvsKeuTobr5AHX9sZEETzhKVzyBBFEbANsqMiPg8VK7i8IyS3r6mB16syVlkBmQ
9ZfV3Jmlpbv+/b4w6rfdb1XohhE62NFMyhlS4C3fahLp1bljGs0FgkL8tBeusIJd
3pORdrqFuOtqTbLZhixhLxOS//svOUKEYriBwVB1Bo74H6ktPX0lalrdbmHC5U2m
KEjjp+saZWGo2vNP5OufB/DuHy5ORd3WMMVqoX8AyOZZPjXEZ95EXdSb0iWE1nIU
ByxLLLv/o/xwr7Ls9wb00o5+8G7Z5y+nwWkC7Hc7wUQdara0YG2I0C55iTpAJpPQ
qV/vsDHQsLP5VhEGk7KxYXM4xeBDofUtRbDyLXtC3VwON7qdvsYp8Es+t0vE7AFK
6IwvkH224FqjZcs8VSvfpiVblYspyGKK7yDMkwxsI1QCw/VeA/nTSzpmZjs3o85G
wrvlrQ2VSiSLAuXBeELRoPUsu0eCQGl5S2BNXQQ5LKLdzLLDCx63vzmxWbgFEF2M
g4VLOM+qNQHgUvpez0Wy8/0fE2HGzMe75qAvHheJyw58hNJMC3Ibh6qkZPHBmf0H
n4sm+iTcDn3rmFeltv37zXbiolqHQMGAbdnFliezt8RTIAEqzDw=
=+B3i
-----END PGP SIGNATURE-----

--=-SuF+Jf1Vs/AnRIDVyYCD--

