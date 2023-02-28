Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDBE6A629C
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjB1WjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjB1WjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:39:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBB22FCE3
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 14:39:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB8B611DE
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 22:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C96DC433D2;
        Tue, 28 Feb 2023 22:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677623943;
        bh=0WaCdvsHVq/zDbPI5+vxHe1OJGeYo+0fvMauhsIrMgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OLn+oa0cOugw7DxCKlN5cYGgNHwiJtneb68umXcFETE3MNlD6J/VPgQvzwSGcsl94
         DZiKwhyslYMgJkNkyEOROB5h/qC1bOYnXODmx0tnusw3IoAfMNHY+1RvBWNqs/RQbG
         Bu46fKUMOEs47HBLD1gwtuS0Gd0qlhLB2crqQWESkfqLv5WVDiFe2TvUXFd2kXmFL7
         3tElyGESpGiN+oCWLqk/E43oqBzAoh0AslrQgRs4+kUC8rAVfHon+OGj4wvpbvGSNV
         JHgsCDMsdqDr33onlQYWf543l1yym6ykniOj1RQz91623YKNJMQFf+XFS/8fXSqEBh
         rTaJQhyfh9Vzw==
Date:   Tue, 28 Feb 2023 22:38:56 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Changbin Du <changbin.du@intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v14 07/19] riscv: Introduce riscv_v_vsize to record
 size of Vector context
Message-ID: <Y/6CgMvoRciA7Ow1@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-8-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Sf16JiWW3vpd/Nea"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-8-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Sf16JiWW3vpd/Nea
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:06PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> This patch is used to detect the size of CPU vector registers and use
> riscv_v_vsize to save the size of all the vector registers. It assumes all
> harts has the same capabilities in a SMP system.
>=20
> [guoren@linux.alibaba.com: add has_vector checking]
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--Sf16JiWW3vpd/Nea
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/6CgAAKCRB4tDGHoIJi
0pdCAP0TVVosuKQXadUzRi4eBz0sZMFW7opQG4CjSCnDyGjR/gD/SxyYi9mpkTm8
1z16AO9+1IzUFa0Sn9L6CJyL/0OdIgQ=
=aci0
-----END PGP SIGNATURE-----

--Sf16JiWW3vpd/Nea--
