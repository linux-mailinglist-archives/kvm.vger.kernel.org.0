Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35713687C63
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 12:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjBBLe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 06:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjBBLeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 06:34:24 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CC949564;
        Thu,  2 Feb 2023 03:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675337661; x=1706873661;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qTJGm0+3lSL7Eg3SsTrKOebqIYkNSjfdxlEJ+ZGPA8w=;
  b=f2Kwja1cf+s9dvM1ESCrNhhVSrIKUR0esEWhP5jslMOU/JSNI9eEVOhw
   7X7q/p17GGCgQwg0ihgOvEP8dfUarc3A40rcYoQfnErlOF/KAeLS6FTVu
   Nw7Oxc53SkxiZQSWgzRUzJWIBA44bXPVJAkIMYjt5pLIbAjEEP7teCZZ+
   O3/Baxpp6JYuxm+4krzlNFvVMpOEZ0AfqR3b+eHR1ADck52p7pf0oTl6X
   v+xpgoLBGGybR+I4JbcaXOpBCbbtQw0NSGvul/NaxNCU3sIIj099yCEku
   mJpKDINRFfW7g+v+hw74mS1XZ5jkmCnQZmpBpxG3yzwW4T8q1VCxeByKe
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="asc'?scan'208";a="199301901"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 04:34:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 04:34:20 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Thu, 2 Feb 2023 04:34:17 -0700
Date:   Thu, 2 Feb 2023 11:33:53 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Atish Patra <atishp@rivosinc.com>
CC:     <linux-kernel@vger.kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 07/14] RISC-V: KVM: Add skeleton support for perf
Message-ID: <Y9ufoeZ/4obZDJz6@wendy>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-8-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oYelnov9+3SzjngH"
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-8-atishp@rivosinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--oYelnov9+3SzjngH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 01, 2023 at 03:12:43PM -0800, Atish Patra wrote:
> This patch only adds barebone structure of perf implementation. Most of
> the function returns zero at this point and will be implemented
> fully in the future.
>=20
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> +/* Per virtual pmu counter data */
> +struct kvm_pmc {
> +	u8 idx;
> +	struct perf_event *perf_event;
> +	uint64_t counter_val;

CI also complained that here, and elsewhere, you used uint64_t rather
than u64. Am I missing a reason for not using the regular types?

Thanks,
Conor.

> +	union sbi_pmu_ctr_info cinfo;
> +	/* Event monitoring status */
> +	bool started;

--oYelnov9+3SzjngH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9ufoQAKCRB4tDGHoIJi
0kf/AQCm19aDqW1X5Lc6vESz6aB/eF/+kPgo7u2mGJcop7tftgEAtJiiKgtviPjo
RITcuT0ZpQ5HmhOW5orv0qV/m2UzhAA=
=ZjQN
-----END PGP SIGNATURE-----

--oYelnov9+3SzjngH--
