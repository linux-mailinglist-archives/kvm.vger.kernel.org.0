Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C96644BAF
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 19:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiLFSYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 13:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiLFSXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 13:23:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F704B4AA
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 10:21:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98A4FCE1AF6
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 18:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B958BC433C1;
        Tue,  6 Dec 2022 18:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670350832;
        bh=T9UHAdLSg/MknZgZmsb/1izlnh+4dsvzvBWofrFnvPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=luoPid1iZfu97Vys9ehffT9v4D2YjnhX+hRe3Ze191e72jhYr66Qn06GryAP2duoZ
         1RE42tKko+FstPRliilBSUoanqmmlntF0Pwo/idQGwcxuI/UuVL9j03fZmPKxdhkk+
         ynMXSyLih0xdWhwPts8R+zucxOoOpuza+6JtctEtRruJOu8kpnSCddjejE++z12uVw
         oZ7vQ6u40msrAkSwhs6iSArVxG9wWO8kyPUU+6QRdWGRwUoS3ZMNnIywOsy55uXO/U
         3XIlwh1bM24m6SWYrLm72pJ+zUKLyiEF+XNwOwxBcjC+vo8okKnW3XIgAkS1JOL7Rg
         GpG/RdgMc7ZGA==
Date:   Tue, 6 Dec 2022 18:20:21 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morse <james.morse@arm.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Peter Collingbourne <pcc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Steven Price <steven.price@arm.com>,
        Usama Arif <usama.arif@bytedance.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Will Deacon <will@kernel.org>,
        Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Message-ID: <Y4+H5Vwy/aLvjqbw@sirena.org.uk>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y4+FmDM7E5WYP3zV@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="syV9s6Ni/PXJMYNU"
Content-Disposition: inline
In-Reply-To: <Y4+FmDM7E5WYP3zV@google.com>
X-Cookie: Save gas, don't use the shell.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--syV9s6Ni/PXJMYNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 06, 2022 at 06:10:32PM +0000, Sean Christopherson wrote:

> Alternatively, we could have a dedicated selftests/kvm tree (or branch)?

> I almost suggested doing that on multiple occasions this cycle, but ultimately
> decided not to because it would effectively mean splitting series that touch KVM
> and selftests into different trees, which would create a different kind of
> dependency hell.  Or maybe a hybrid approach where series that only (or mostly?)
> touch selftests go into a dedicated tree?

Some other subsystems do have a separate branch for kselftests.  One
fairly common occurrence is that the selftests branch ends up failing to
build independently because someone adds new ABI together with a
selftest but the patches adding the ABI don't end up on the same branch
as the tests which try to use them.  That is of course resolvable but
it's a common friction point.

--syV9s6Ni/PXJMYNU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOPh+UACgkQJNaLcl1U
h9CC7Af+MMWaPoSDO/Esk9zkroLyT2xIe855zDLbqscWMEyns5kByu5KOIbQMuI9
SUhH+Y3GvUDFrbipnIGOlU8gxrsFFta9BlEMNiisNoSMlJv2SmKDb9HZfZBYpiOt
GlmJZ0i3yxKFOsLjWnxgo62AJheT4sE8wADRIPAkPxAWRyz3KGFBesc5EooCxLNt
T/jqOtoRqoakiaejBd3eMQxKlMNdOcpqSoiOjjpWgzWOEUULA7wHa1oDRwO5W6Zr
upb+KoHtzlYfa1UHiW3+8kg9vAk8MyBnvG0Bx6Xu6/0im6Is5WpQUc9ofnR26eLZ
6aL4C8fUDYOKXdy6pfD6XAboCNuEtA==
=GF2/
-----END PGP SIGNATURE-----

--syV9s6Ni/PXJMYNU--
