Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39016E28A7
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 18:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjDNQrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 12:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjDNQrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 12:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7139005
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 09:47:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6939864934
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 16:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23059C4339C;
        Fri, 14 Apr 2023 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681490830;
        bh=V+3AlzUEvU220Qfu5FQzGqeb/Diu4gbuqSKPjUsqsC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oOgMDPAuldNfaIluMPFZGKLBLlA8L0JYUjPEKzkuwUExITKMCZXQigT3XcKoJcymx
         aPog8vXXskrALKG8LD4AOafSP0IL+QJHfMFbRks2OGwMLl7dFqMXpne/FpvWkTY+Kc
         oKL7JmMX+lPQmny9Z69KIYPOTSo2Emz2uhzHGLI1WLNjL65j0WBtwjQqUSkoLHEZ6J
         IaT/k2SF3VG+AsF+EbT8/JtXHtQDhrDR+UUTuhayv38FNdHSoFoOs7GA21xKPfJGJD
         azmz2xKzRdTChQtfHUNRlSIW2Hk/9Hi429oxUjKCyWRxwifNBTxQ0gcZqfkd+mxOG1
         NTngOnQlC86eg==
Date:   Fri, 14 Apr 2023 17:47:03 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Liao Chang <liaochang1@huawei.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Philipp Tomsich <philipp.tomsich@vrull.eu>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Ley Foon Tan <leyfoon.tan@starfivetech.com>
Subject: Re: [PATCH -next v18 07/20] riscv: Introduce riscv_v_vsize to record
 size of Vector context
Message-ID: <20230414-kerosene-jackknife-2bf17e228b1d@spud>
References: <20230414155843.12963-1-andy.chiu@sifive.com>
 <20230414155843.12963-8-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mODSqKfubxZdcXl/"
Content-Disposition: inline
In-Reply-To: <20230414155843.12963-8-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--mODSqKfubxZdcXl/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 14, 2023 at 03:58:30PM +0000, Andy Chiu wrote:

> +	if (riscv_v_vsize != this_vsize) {
> +		WARN(1, "RISCV_ISA_V only supports one vlenb on SMP system");

nit: systems
Clearly I don't expect a resubmission to change that!

You can re-add:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--mODSqKfubxZdcXl/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDmDhwAKCRB4tDGHoIJi
0rSyAP9qZMzkst1MmzvhXVxyB6lP1VuWBHZln/+8EWDjVy1dawEAyvgTJdrucXuR
hwzRuGZuH4b2+10D2XhKW5cQ5K9ckgI=
=wnXU
-----END PGP SIGNATURE-----

--mODSqKfubxZdcXl/--
