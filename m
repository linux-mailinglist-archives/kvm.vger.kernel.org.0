Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BC576FB8C
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 10:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbjHDIA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 04:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjHDIAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 04:00:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3BA1704;
        Fri,  4 Aug 2023 01:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1691136023; x=1722672023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mozKuYzJnKHA2aKr3eiYDtSGyCx3d+I7fkTRCyvB7W0=;
  b=S9meV5hrPUbBWAY9o6CBbP4zp+xjTUOqzEz4V6ZlpD8H2B8tHo8L1nwn
   J+cxYIHYcDIgWTY2rLLlG3UhfVIB554mdIApG5n6sVzQMbMid3158CjkH
   v/rNMykvOYsJ49x2MXBs1YjEVpZlQTA+Li9qoAZJVc86SfwWzIp/+RIHq
   C0o7scN3tX+VkKR/L+J5S+dFJK5K7cDvlqF3d42Pk4MR0XiKzXV6bm8hK
   W6ISf0f/5EQPsoIdmAlr3tcyz+F72jnKDnepDDHxGslQ76uyFlcoyIogo
   H8xoAXe/MiIZPQ1mhshb9FWdRwKYEmZwvCbhM0ZHqoAGTLBeefzP/VehU
   g==;
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="asc'?scan'208";a="164824311"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Aug 2023 01:00:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 4 Aug 2023 01:00:06 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 4 Aug 2023 01:00:01 -0700
Date:   Fri, 4 Aug 2023 08:59:24 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Charlie Jenkins <charlie@rivosinc.com>
CC:     <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <bpf@vger.kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Nam Cao <namcaov@gmail.com>
Subject: Re: [PATCH 01/10] RISC-V: Expand instruction definitions
Message-ID: <20230804-barterer-heritage-ed191081bc47@wendy>
References: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
 <20230803-master-refactor-instructions-v4-v1-1-2128e61fa4ff@rivosinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="giltLFM/xoeS/K8e"
Content-Disposition: inline
In-Reply-To: <20230803-master-refactor-instructions-v4-v1-1-2128e61fa4ff@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--giltLFM/xoeS/K8e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 03, 2023 at 07:10:26PM -0700, Charlie Jenkins wrote:
> There are many systems across the kernel that rely on directly creating
> and modifying instructions. In order to unify them, create shared
> definitions for instructions and registers.
>=20
> Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
> ---
>  arch/riscv/include/asm/insn.h            | 2742 ++++++++++++++++++++++++=
+++---

"I did a lot of copy-pasting from the RISC-V spec"

How is anyone supposed to cross check this when there's 1000s of lines
of a diff here? We've had some subtle bugs in some of the definitions in
the past, so I would like to be able to check at this opportune moment
that things are correct.

>  arch/riscv/include/asm/reg.h             |   88 +
>  arch/riscv/kernel/kgdb.c                 |    4 +-
>  arch/riscv/kernel/probes/simulate-insn.c |   39 +-
>  arch/riscv/kernel/vector.c               |    2 +-

You need to at least split this up. I doubt a 2742 change diff for
insn.h was required to make the changes in these 4 files.

Then after that, it would be so much easier to reason about these
changes if the additions to insn.h happened at the same time as the
removals from the affected locations.

I would probably split this so that things are done in more stages,
with the larger patches split between changes that require no new
definitions and changes that require moving things to insn.h

>  5 files changed, 2629 insertions(+), 246 deletions(-)

What you would want to see if this arrived in your inbox as a reviewer?

Don't get me wrong, I do like what you are doing here, the BPF JIT
especially is filled with "uhh okay, I guess those offsets are right",
so I don't mean to be discouraging.

Thanks,
Conor.

--giltLFM/xoeS/K8e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZMyvzwAKCRB4tDGHoIJi
0gQYAP0UlvSWYX6mB67CAGmIVZwnT0CwyiNPOEXW+G0t9GnWngD+PxdgtapB+DMY
MPJ1zDp8mSYyzU+MKQ++56q8pPpFyQg=
=yGw/
-----END PGP SIGNATURE-----

--giltLFM/xoeS/K8e--
