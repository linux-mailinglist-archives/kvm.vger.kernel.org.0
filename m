Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33E66C1365
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 14:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjCTN3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 09:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbjCTN3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 09:29:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F4D1CAE1
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 06:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679318917; x=1710854917;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fwQ7M2cYyv6kPD8DWSHBD9nbpZ8kTjwSTiRPjPsp0PA=;
  b=O91gDPoJPDVgo3w9YQTtQl2v6/nsT18jgnV6wEu4zJTEEYLVXXmP69tl
   n0/D5aTkVcXd/InGP6Gq6CMHtGs0VZ6DyGGt6S9tPpz+dFLx5qWx9UH7+
   aZkEmv1+wR5D1rXhp0ne5gJQPwLLkWrZLd1GPAxkOCKb3hiQm4Nu4q4Ie
   Z3MwpeZQqFYsfT9j0DfBnXUJAbGf5v9N5f/QBNhw8YIg83xWqBTM84K9p
   MlAlqWz06HhcsBP8xCvnvOr4tl5FxkDyzeAaum4yHb8tNDOnww2Qv8WXa
   4eQ0C1DmWeU7nsfRKFOVNLyFrS42j7tMjTUeo14PhY0/40ufdcCWUhJ70
   g==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="asc'?scan'208";a="217110650"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Mar 2023 06:28:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 06:28:20 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 20 Mar 2023 06:28:17 -0700
Date:   Mon, 20 Mar 2023 13:27:47 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <vineetg@rivosinc.com>, <greentime.hu@sifive.com>,
        <guoren@linux.alibaba.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Liao Chang <liaochang1@huawei.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Mattias Nissler <mnissler@rivosinc.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v15 10/19] riscv: Allocate user's vector context in
 the first-use trap
Message-ID: <31f08283-b815-4e50-80ed-3f94987ef227@spud>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
 <20230317113538.10878-11-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="75fHXjzehm0ULJe4"
Content-Disposition: inline
In-Reply-To: <20230317113538.10878-11-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--75fHXjzehm0ULJe4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2023 at 11:35:29AM +0000, Andy Chiu wrote:
> Vector unit is disabled by default for all user processes. Thus, a
> process will take a trap (illegal instruction) into kernel at the first
> time when it uses Vector. Only after then, the kernel allocates V
> context and starts take care of the context for that user process.
>=20
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Link: https://lore.kernel.org/r/3923eeee-e4dc-0911-40bf-84c34aee962d@lina=
ro.org
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

I recall being mostly happy with the v13 of this, and the bits of
complaints I had there were resolved, as does the build issue in v14.
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
I think I also said that I would like if Heiko could have a brief look
at the insn parsing bits.

Cheers,
Conor.

> ---
>  arch/riscv/include/asm/insn.h   | 29 +++++++++++
>  arch/riscv/include/asm/vector.h |  2 +
>  arch/riscv/kernel/traps.c       | 14 ++++-
>  arch/riscv/kernel/vector.c      | 90 +++++++++++++++++++++++++++++++++
>  4 files changed, 133 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
> index 8d5c84f2d5ef..4e1505cef8aa 100644
> --- a/arch/riscv/include/asm/insn.h
> +++ b/arch/riscv/include/asm/insn.h
> @@ -137,6 +137,26 @@
>  #define RVG_OPCODE_JALR		0x67
>  #define RVG_OPCODE_JAL		0x6f
>  #define RVG_OPCODE_SYSTEM	0x73
> +#define RVG_SYSTEM_CSR_OFF	20
> +#define RVG_SYSTEM_CSR_MASK	GENMASK(12, 0)
> +
> +/* parts of opcode for RVF, RVD and RVQ */
> +#define RVFDQ_FL_FS_WIDTH_OFF	12
> +#define RVFDQ_FL_FS_WIDTH_MASK	GENMASK(3, 0)
> +#define RVFDQ_FL_FS_WIDTH_W	2
> +#define RVFDQ_FL_FS_WIDTH_D	3
> +#define RVFDQ_LS_FS_WIDTH_Q	4
> +#define RVFDQ_OPCODE_FL		0x07
> +#define RVFDQ_OPCODE_FS		0x27
> +
> +/* parts of opcode for RVV */
> +#define RVV_OPCODE_VECTOR	0x57
> +#define RVV_VL_VS_WIDTH_8	0
> +#define RVV_VL_VS_WIDTH_16	5
> +#define RVV_VL_VS_WIDTH_32	6
> +#define RVV_VL_VS_WIDTH_64	7
> +#define RVV_OPCODE_VL		RVFDQ_OPCODE_FL
> +#define RVV_OPCODE_VS		RVFDQ_OPCODE_FS
> =20
>  /* parts of opcode for RVC*/
>  #define RVC_OPCODE_C0		0x0
> @@ -304,6 +324,15 @@ static __always_inline bool riscv_insn_is_branch(u32=
 code)
>  	(RVC_X(x_, RVC_B_IMM_7_6_OPOFF, RVC_B_IMM_7_6_MASK) << RVC_B_IMM_7_6_OF=
F) | \
>  	(RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
> =20
> +#define RVG_EXTRACT_SYSTEM_CSR(x) \
> +	({typeof(x) x_ =3D (x); RV_X(x_, RVG_SYSTEM_CSR_OFF, RVG_SYSTEM_CSR_MAS=
K); })
> +
> +#define RVFDQ_EXTRACT_FL_FS_WIDTH(x) \
> +	({typeof(x) x_ =3D (x); RV_X(x_, RVFDQ_FL_FS_WIDTH_OFF, \
> +				   RVFDQ_FL_FS_WIDTH_MASK); })
> +
> +#define RVV_EXRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
> +
>  /*
>   * Get the immediate from a J-type instruction.
>   *
> diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vec=
tor.h
> index 3bfa223facd0..09f8dbad3dee 100644
> --- a/arch/riscv/include/asm/vector.h
> +++ b/arch/riscv/include/asm/vector.h
> @@ -20,6 +20,7 @@
> =20
>  extern unsigned long riscv_v_vsize;
>  void riscv_v_setup_vsize(void);
> +bool riscv_v_first_use_handler(struct pt_regs *regs);
> =20
>  static __always_inline bool has_vector(void)
>  {
> @@ -163,6 +164,7 @@ static inline void __switch_to_vector(struct task_str=
uct *prev,
>  struct pt_regs;
> =20
>  static __always_inline bool has_vector(void) { return false; }
> +static inline bool riscv_v_first_use_handler(struct pt_regs *regs) { ret=
urn false; }
>  static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return f=
alse; }
>  #define riscv_v_vsize (0)
>  #define riscv_v_setup_vsize()	 		do {} while (0)
> diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
> index f6fda94e8e59..2a98fe74274e 100644
> --- a/arch/riscv/kernel/traps.c
> +++ b/arch/riscv/kernel/traps.c
> @@ -24,6 +24,7 @@
>  #include <asm/processor.h>
>  #include <asm/ptrace.h>
>  #include <asm/thread_info.h>
> +#include <asm/vector.h>
> =20
>  int show_unhandled_signals =3D 1;
> =20
> @@ -135,8 +136,17 @@ DO_ERROR_INFO(do_trap_insn_misaligned,
>  	SIGBUS, BUS_ADRALN, "instruction address misaligned");
>  DO_ERROR_INFO(do_trap_insn_fault,
>  	SIGSEGV, SEGV_ACCERR, "instruction access fault");
> -DO_ERROR_INFO(do_trap_insn_illegal,
> -	SIGILL, ILL_ILLOPC, "illegal instruction");
> +
> +asmlinkage __visible __trap_section void do_trap_insn_illegal(struct pt_=
regs *regs)
> +{
> +	if (has_vector() && user_mode(regs)) {
> +		if (riscv_v_first_use_handler(regs))
> +			return;
> +	}
> +	do_trap_error(regs, SIGILL, ILL_ILLOPC, regs->epc,
> +		      "Oops - illegal instruction");
> +}
> +
>  DO_ERROR_INFO(do_trap_load_fault,
>  	SIGSEGV, SEGV_ACCERR, "load access fault");
>  #ifndef CONFIG_RISCV_M_MODE
> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> index 082baf2a061f..f13d2f3d77fb 100644
> --- a/arch/riscv/kernel/vector.c
> +++ b/arch/riscv/kernel/vector.c
> @@ -4,9 +4,19 @@
>   * Author: Andy Chiu <andy.chiu@sifive.com>
>   */
>  #include <linux/export.h>
> +#include <linux/sched/signal.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> =20
> +#include <asm/thread_info.h>
> +#include <asm/processor.h>
> +#include <asm/insn.h>
>  #include <asm/vector.h>
>  #include <asm/csr.h>
> +#include <asm/ptrace.h>
> +#include <asm/bug.h>
> =20
>  unsigned long riscv_v_vsize __read_mostly;
>  EXPORT_SYMBOL_GPL(riscv_v_vsize);
> @@ -19,3 +29,83 @@ void riscv_v_setup_vsize(void)
>  	riscv_v_disable();
>  }
> =20
> +static bool insn_is_vector(u32 insn_buf)
> +{
> +	u32 opcode =3D insn_buf & __INSN_OPCODE_MASK;
> +	bool is_vector =3D false;
> +	u32 width, csr;
> +
> +	/*
> +	 * All V-related instructions, including CSR operations are 4-Byte. So,
> +	 * do not handle if the instruction length is not 4-Byte.
> +	 */
> +	if (unlikely(GET_INSN_LENGTH(insn_buf) !=3D 4))
> +		return false;
> +
> +	switch (opcode) {
> +	case RVV_OPCODE_VECTOR:
> +		is_vector =3D true;
> +		break;
> +	case RVV_OPCODE_VL:
> +	case RVV_OPCODE_VS:
> +		width =3D RVV_EXRACT_VL_VS_WIDTH(insn_buf);
> +		if (width =3D=3D RVV_VL_VS_WIDTH_8 || width =3D=3D RVV_VL_VS_WIDTH_16 =
||
> +		    width =3D=3D RVV_VL_VS_WIDTH_32 || width =3D=3D RVV_VL_VS_WIDTH_64)
> +			is_vector =3D true;
> +		break;
> +	case RVG_OPCODE_SYSTEM:
> +		csr =3D RVG_EXTRACT_SYSTEM_CSR(insn_buf);
> +		if ((csr >=3D CSR_VSTART && csr <=3D CSR_VCSR) ||
> +		    (csr >=3D CSR_VL && csr <=3D CSR_VLENB))
> +			is_vector =3D true;
> +		break;
> +	}
> +	return is_vector;
> +}
> +
> +static int riscv_v_thread_zalloc(void)
> +{
> +	void *datap;
> +
> +	datap =3D kzalloc(riscv_v_vsize, GFP_KERNEL);
> +	if (!datap)
> +		return -ENOMEM;
> +	current->thread.vstate.datap =3D datap;
> +	memset(&current->thread.vstate, 0, offsetof(struct __riscv_v_ext_state,
> +						    datap));
> +	return 0;
> +}
> +
> +bool riscv_v_first_use_handler(struct pt_regs *regs)
> +{
> +	__user u32 *epc =3D (u32 *)regs->epc;
> +	u32 insn =3D (u32)regs->badaddr;
> +
> +	/* If V has been enabled then it is not the first-use trap */
> +	if (riscv_v_vstate_query(regs))
> +		return false;
> +
> +	/* Get the instruction */
> +	if (!insn) {
> +		if (__get_user(insn, epc))
> +			return false;
> +	}
> +	/* Filter out non-V instructions */
> +	if (!insn_is_vector(insn))
> +		return false;
> +
> +	/* Sanity check. datap should be null by the time of the first-use trap=
 */
> +	WARN_ON(current->thread.vstate.datap);
> +	/*
> +	 * Now we sure that this is a V instruction. And it executes in the
> +	 * context where VS has been off. So, try to allocate the user's V
> +	 * context and resume execution.
> +	 */
> +	if (riscv_v_thread_zalloc()) {
> +		force_sig(SIGKILL);
> +		return true;
> +	}
> +	riscv_v_vstate_on(regs);
> +	return true;
> +}
> +
> --=20
> 2.17.1
>=20
>=20

--75fHXjzehm0ULJe4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBhfUwAKCRB4tDGHoIJi
0gQyAQDa/aNmdGxQcgE9f0VwjP+8KSctqk7yNbO5a3cAZoA+jQD9FaiaMUGxvJYL
8hP7+CnPJrl65OMUdyHFdQXJpfWvQgI=
=4gts
-----END PGP SIGNATURE-----

--75fHXjzehm0ULJe4--
