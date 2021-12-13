Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7EF4733EC
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 19:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241553AbhLMSXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 13:23:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53656 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbhLMSXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 13:23:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7D8AB8119C;
        Mon, 13 Dec 2021 18:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0437CC34604;
        Mon, 13 Dec 2021 18:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639419792;
        bh=+R6NDqcGutAYshwzXxwxa7ravrzpbyPvgNsfdH6wCRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eq/I2Urkni/w+qmXOfU2nzyzlpaFAgL0ek5wN5LcSbbUiObfYXmSdXmqft8AMCUJb
         5F4/9s66coDBJ/CEjegdNbb6TdiXMbSXYYLopKbzwxqAKgubpMgdglm5RQIQO7gXSw
         GzgN+Txwel26SvjMYVb+vq0akwWaxXiBfOoUu9eaxkKBqHLujzNOom8sfAWnCjM3co
         FzV6AqvFon4Rdazf157JKNcT3phRot2ghWKMPM9djFKUbuEC0HZ9YN6GNXWraSb11B
         yDD2Ah2KwPDAgdUN1dHHvlrhDpboK3PgVWDSXR2rvdB0oSG5csg0HsPbjD2jc0G0Nv
         Kg0wRsby2xhgg==
Date:   Mon, 13 Dec 2021 18:23:07 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <YbePi35ecFjiowyv@sirena.org.uk>
References: <20211213174628.178270-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JK/GYE3+BJyphU8J"
Content-Disposition: inline
In-Reply-To: <20211213174628.178270-1-broonie@kernel.org>
X-Cookie: No solicitors.
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--JK/GYE3+BJyphU8J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 13, 2021 at 05:46:28PM +0000, broonie@kernel.org wrote:

> - kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
> - 	 $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
> - 	 arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>  -kvm-y += arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
> ++kvm-y := arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \

This should of course have used the +=.

--JK/GYE3+BJyphU8J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmG3j4sACgkQJNaLcl1U
h9CfXgf+Mero7srvJT+lAVRiPrwnVjrc/7IweajVlCA1S/Xsv5ZhiGCsAg6mOumd
BNpZRVBKnb+6viSLNqDFDWWUr0xx3kq9QDMTU9BJtn46jEJYYlHZKY+wgKdswcyw
Flb1uZ7lqxhgAAnWq/9fTu9vUkfWuGe2+sbLN1Fm0FQE8ur4OaAWOYiqyJvZmK8u
Xq+DiDdczvl5vxrr5yhM/C7u2uoX1EUL/4Qgik5Gm78FqWFhab9OLapqHSOEfIqd
meYZ4q5p8YQ8FAtf8HR/3RoLXpk94UcfzY68eYPoYwjClM9eFINBPgYZ+f4M0Dyr
o/8IlWWLnFSj2+Z5n0eapIrms+hSag==
=t9Iw
-----END PGP SIGNATURE-----

--JK/GYE3+BJyphU8J--
