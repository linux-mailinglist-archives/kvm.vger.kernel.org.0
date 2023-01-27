Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BE367F171
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 23:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjA0WxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 17:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjA0WxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 17:53:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6B52CC43;
        Fri, 27 Jan 2023 14:53:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9B1761DD6;
        Fri, 27 Jan 2023 22:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A201C433EF;
        Fri, 27 Jan 2023 22:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674859991;
        bh=AlW+shdolVDZD+HbkKOCpGj3Nr78aWfSzEIvsiWfq3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T7+IRG0Himjk8sh4eB2oOCBXhhL8B83WBfjC9K55BXmnGc8qPx9gabg++Do+JyIrL
         JdxglCUACcWNcWW1uazinfWHZiJgGKNGmrn0QCIgg3OXB6FeBWUw/58+XSKjlJtWEH
         IBUkiaB7wO0Suvl7i0nx4R2XkQwkBhYr5GTEiYUx7CzveTKMTyB5SopUiMpFLPTTJ1
         nk9XxWBp1qcJze5iL+kuwuNoYIoSERSKi+cF2UXz5nL+LRHNwQHVbXkFfchDUZe4rg
         4INLIZfopNKkQR+4nnde1GV6DiyJRyqniCeR+FZDRM7RkttnP6T9Q5ifqkA6CQUxz5
         qYAFFTkRbopOw==
Date:   Fri, 27 Jan 2023 22:53:05 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 03/14] RISC-V: Improve SBI PMU extension related
 definitions
Message-ID: <Y9RV0cOMld20EFBI@spud>
References: <20230127182558.2416400-1-atishp@rivosinc.com>
 <20230127182558.2416400-4-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SXHZm0283L6wqZyc"
Content-Disposition: inline
In-Reply-To: <20230127182558.2416400-4-atishp@rivosinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--SXHZm0283L6wqZyc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Yo Atish,

On Fri, Jan 27, 2023 at 10:25:47AM -0800, Atish Patra wrote:
> This patch fixes/improve few minor things in SBI PMU extension
> definition.
>=20
> 1. Align all the firmware event names.

> @@ -171,7 +171,7 @@ enum sbi_pmu_fw_generic_events_t {
>  	SBI_PMU_FW_IPI_RECVD		=3D 7,
> -	SBI_PMU_FW_FENCE_I_RECVD	=3D 9,
> +	SBI_PMU_FW_FENCE_I_RCVD		=3D 9,
>  	SBI_PMU_FW_SFENCE_VMA_RCVD	=3D 11,

Alignment looks incomplete to me! Looks like you went from 2 RECVD and
1 RCVD to 2 RCVD and 1 RECVD! FWIW, the spec uses RECEIVED for all of
these:
https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/riscv-sbi.adoc#1=
14-event-firmware-events-type-15

Thanks,
Conor.


--SXHZm0283L6wqZyc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9RV0QAKCRB4tDGHoIJi
0uAcAQDWSusshNSb8//8SiCdQXkPLrC/kJDsiYKg3vrNJmwohAEAjsDGGzhx00ZF
YUzKIx2KVlPQFXJ9hBhCmjsG1KfQ4AE=
=wHrk
-----END PGP SIGNATURE-----

--SXHZm0283L6wqZyc--
