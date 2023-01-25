Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E0767BFCE
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 23:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbjAYWRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 17:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbjAYWQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 17:16:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A730E5D91E
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 14:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC30CB81BE0
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 22:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C4BC433EF;
        Wed, 25 Jan 2023 22:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674684971;
        bh=Z6N8d8ZTWONF4O/xScRH1efnkdWjJXAj1xICW0tJuJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hu7MNMUF4mEYAOAygvXEffVTDuc00rawPat2OhRJj/ZSi77mGstoiuKjufHD5mtci
         /W3uBwJGhK8TAITzb5MjqW6qEDHuAKa2s1VZ9YGW7F/In/yo7M9Vjlo7R9K0oiuLbn
         DOjrKGvMhhzpMIMr57XEIzNa62BCH7Hk/AM4kUVefrOI7h8ojZfMEFIW/xQOqrZLHY
         66aZ7QPYIpjTnMZ+E8DqRY5NBL3pNEHpoxULD+K6MN61WeM98aCZ0x6rmvTCeCux+1
         CiFqghbZdoViT/QEzJh4vh6oRkcybxwa4bLqUnFdet2CpEjkS2QNHxkpQRCGa3dIrC
         STnvBVPGXrAFA==
Date:   Wed, 25 Jan 2023 22:16:05 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Guo Ren <guoren@kernel.org>,
        Qinglin Pan <panqinglin2020@iscas.ac.cn>
Subject: Re: [PATCH -next v13 03/19] riscv: Add new csr defines related to
 vector extension
Message-ID: <Y9GqJbEduVHWY7aU@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-4-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BzfGwI70yXrNxc4z"
Content-Disposition: inline
In-Reply-To: <20230125142056.18356-4-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--BzfGwI70yXrNxc4z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 02:20:40PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> Follow the riscv vector spec to add new csr numbers.
>=20
> [guoren@linux.alibaba.com: first porting for new vector related csr]
> Acked-by: Guo Ren <guoren@kernel.org>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>

This series has gone on for so long, that the tags barely seem to make
sense any more. I won't pretend that I understand why quite so many
people are required to add a few definitions of the spec! Nor can I be
bothered reading 12 revisions on lore to find out why it was done this
way...
They do seem to align with what is in the latest release, so:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

I also noticed that you missed some tags from the v12 submission.
Eg Heiko's here:
https://lore.kernel.org/linux-riscv/2096011.OBFZWjSADL@diego/

There's also one for patch 1:
https://lore.kernel.org/linux-riscv/5335635.Sb9uPGUboI@diego/

Thanks,
Conor.

--BzfGwI70yXrNxc4z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9GqJQAKCRB4tDGHoIJi
0u6nAQDkxVRl745rt4A0UQYFUQvp0jh+oAclAwrXlroWD4l6kgD9GwhGmcaLm+w+
xi2BtDkFksMvW7O39e12MmxKbsTlYAE=
=rUIb
-----END PGP SIGNATURE-----

--BzfGwI70yXrNxc4z--
