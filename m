Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEB36C128B
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 14:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCTNDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 09:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjCTND0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 09:03:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16EF811E89
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 06:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679317404; x=1710853404;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QnIQEdsaltLoEekuM+H+lCcrHRVvNLxa0nPOqc1ZZTI=;
  b=h1mofqAFTL3jtfH61AN7ottUiGgAAMRiLJ3o+04+7VfSmQwb3Pu5yQdV
   DvsYhzH+XoZOV/uNvQlth5vBTCm/xfyM5kX6isji1QtlJxJFKTyq3AOS1
   75VZWgJL8RkHx3jTW3YmJ83QuXy2fVRi8KHnMOvGzn2PsvsPqN380QPJA
   0YpgoJklFNCxlJlu8v6aVHgP0XR0D6mEvT8IxFCnZ6KTJzTVy3H/h9dpC
   cWgnaAXiEwI+KMJ9Liw5EnwuH2Oa8BK9g8WCK5qtFJ9QU0WD8cvmrJQ28
   33DiV/npvumEL8RdDePoUD6sH7s3t2V8It64KmZwXbzOne9TDpAz6LxhG
   g==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="asc'?scan'208";a="217100347"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Mar 2023 06:02:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 06:02:54 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 20 Mar 2023 06:02:50 -0700
Date:   Mon, 20 Mar 2023 13:02:20 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <vineetg@rivosinc.com>, <greentime.hu@sifive.com>,
        <guoren@linux.alibaba.com>, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Liao Chang <liaochang1@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v15 07/19] riscv: Introduce riscv_v_vsize to record
 size of Vector context
Message-ID: <78b957cb-c41d-4152-8f5b-b4bae615c8be@spud>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
 <20230317113538.10878-8-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8aLMBB9LeTn6xA3i"
Content-Disposition: inline
In-Reply-To: <20230317113538.10878-8-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--8aLMBB9LeTn6xA3i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2023 at 11:35:26AM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> This patch is used to detect the size of CPU vector registers and use
> riscv_v_vsize to save the size of all the vector registers. It assumes all
> harts has the same capabilities in a SMP system.
>=20
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

FYI git am complains while applying this patch about whitespace issues:

Applying: riscv: Introduce riscv_v_vsize to record size of Vector context
Using index info to reconstruct a base tree...
M	arch/riscv/kernel/cpufeature.c
=2Egit/rebase-apply/patch:90: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Falling back to patching base and 3-way merge...

Thanks,
Conor.

--8aLMBB9LeTn6xA3i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBhZXAAKCRB4tDGHoIJi
0u98APwJ8zUVWiesDKpZT8SZ5IEnhsEcvqYCecLiJjvP1cXnYwD9HBdKPe8bVLxX
KRBwZMrG5PtnYzQMTMR+8E5Gr+W4/gY=
=Aqxv
-----END PGP SIGNATURE-----

--8aLMBB9LeTn6xA3i--
