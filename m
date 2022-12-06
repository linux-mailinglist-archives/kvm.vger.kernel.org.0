Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E963644E52
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 23:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiLFWEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 17:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLFWE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 17:04:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2F030567;
        Tue,  6 Dec 2022 14:04:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71DCE6191C;
        Tue,  6 Dec 2022 22:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE19C433D7;
        Tue,  6 Dec 2022 22:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670364266;
        bh=YFNk4wnUyvIHV45xGst0M6Mv6RD7mO9izPkpSepzLzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCQ8QgD9sWBXUdsklJNObETAxZWLKj/mfcGTZ8FsD1nSq7Um8QXMlrfDe6T7jUGE3
         kwaHFl4KCJWaKucnZk5avrgW044opwkMLGVukvCGyfuoF4CST0/Qlk93UlIyWNa9l3
         70TVGJEfq/srcImBvBAnqnHoreUaVpfIFYrpftHlM1bbrr/Jd/RUbjTSBt5eDJd7iM
         8Z+87nfBkN2O9wrorSobXkA7SSK+PizEAg9TD8kRLExiyqhwtP/5lUEIswfF7jP2eU
         4/Vm9Lo12OzFCvjhn1J54MVd6T8Kn5/C14RydSwvjeXrRc0WCE6odlE88JCEBOv/ps
         X6/mfXaNFWy9Q==
Date:   Tue, 6 Dec 2022 22:04:21 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 11/13] riscv: cpu_relax: switch to
 riscv_has_extension_likely()
Message-ID: <Y4+8ZY8xb2nMRCD6@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-12-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f4Q+4tgBFM+GKuzY"
Content-Disposition: inline
In-Reply-To: <20221204174632.3677-12-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--f4Q+4tgBFM+GKuzY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 01:46:30AM +0800, Jisheng Zhang wrote:
> Switch cpu_relax() from statich branch to the new helper

The tiniest nit: static

> riscv_has_extension_likely()
>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  arch/riscv/include/asm/vdso/processor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/include/asm/vdso/processor.h b/arch/riscv/include=
/asm/vdso/processor.h
> index fa70cfe507aa..edf0e25e43d1 100644
> --- a/arch/riscv/include/asm/vdso/processor.h
> +++ b/arch/riscv/include/asm/vdso/processor.h
> @@ -10,7 +10,7 @@
> =20
>  static inline void cpu_relax(void)
>  {
> -	if (!static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_ZIHINTP=
AUSE])) {
> +	if (!riscv_has_extension_likely(RISCV_ISA_EXT_ZIHINTPAUSE)) {
>  #ifdef __riscv_muldiv
>  		int dummy;
>  		/* In lieu of a halt instruction, induce a long-latency stall. */
> --=20
> 2.37.2
>=20

--f4Q+4tgBFM+GKuzY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY4+8ZQAKCRB4tDGHoIJi
0iZSAQDn6oK5bKWljy3KIV6V3K/CWCHzkYcNsNECA5bTRZKIFwEAzfIX2k6NR1ma
Wr/RIOCfc2KOx5pGO8gdBgyULr2aBAM=
=Odo+
-----END PGP SIGNATURE-----

--f4Q+4tgBFM+GKuzY--
