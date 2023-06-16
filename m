Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8712F73381F
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 20:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245204AbjFPS2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 14:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344678AbjFPS23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 14:28:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CC84213;
        Fri, 16 Jun 2023 11:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0381162D0C;
        Fri, 16 Jun 2023 18:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57CBC433B8;
        Fri, 16 Jun 2023 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686940089;
        bh=Gdv9fvJ1NHmCLB70+je1Emv0mXKmQqEenEYSf/icR8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i6R6K73ye+wTMFv327hPtl64SX3bEnBBUvtEeYJoB1QxtXXAgM57dmtI2G18XGi1s
         TonhT4YRZGKIGVHXm1Wd3Tb8RZkqZDZdYaL7perPPC8lSHp5ViFGZMq+COssttMSaa
         BUjha8DukbYt3F65G9xFNV+YbzdDJujwnvNvcHBWbrQVmsR9JE8OHvUo7xkC4s78Cf
         Ijg70078BR+8lj4Q8P/voqDiJqbO8f7XjfiDFU9V1R3FY+dXuvBAt7beQuNxx1Tij3
         TWJljneOGDrMkdJf1xw7OCD2XK1BL6GPG0SXnjkP/D52Hl/d7r7/vXglQrx5vdPU9v
         UVViuWgLKz0ZA==
Date:   Fri, 16 Jun 2023 19:28:05 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org
Subject: Re: [PATCH v2] riscv: kvm: define vcpu_sbi_ext_pmu in header
Message-ID: <20230616-army-portable-4b604631bc5a@spud>
References: <20230616142203.168996-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wuezkFbRNqG8HV/z"
Content-Disposition: inline
In-Reply-To: <20230616142203.168996-1-ben.dooks@codethink.co.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--wuezkFbRNqG8HV/z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 03:22:03PM +0100, Ben Dooks wrote:
> Sparse is giving a warning about vcpu_sbi_ext_pmu not being
> defined, so add a definition to the relevant header to fix
> the following:
>=20
> arch/riscv/kvm/vcpu_sbi_pmu.c:81:37: warning: symbol 'vcpu_sbi_ext_pmu' w=
as not declared. Should it be static?
>=20
> Fixes: cbddc4c4cb9e ("RISC-V: KVM: Add SBI PMU extension support")
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--wuezkFbRNqG8HV/z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIyptQAKCRB4tDGHoIJi
0utWAQDOZoqWIkYQnbkMm7nO53K0YDVrTgVmA09ry26g74O7xwD9Fex5dGTbA89O
lXXITUjjMd48RWstSMKcZhZ2orMIGA4=
=p5AJ
-----END PGP SIGNATURE-----

--wuezkFbRNqG8HV/z--
