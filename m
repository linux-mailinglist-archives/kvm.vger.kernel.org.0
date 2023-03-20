Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03E96C1395
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 14:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjCTNhl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 09:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjCTNhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 09:37:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752301024F
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 06:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679319439; x=1710855439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h4HiHREoA7rE0yPUEqTyH6YdUw7SoaVF6TRzL8eNJhI=;
  b=s7vwBF+4+76svtpIxgqkI8SbAM7UB7FvJwSCS2Bk1HZdPrHvzCErIPfC
   LT98/uEWSdMlaIwCtFqBNT3otuiNu1MsEMZMr5m8DdMXWZ0HdT0M4FJgc
   oGSrmL3sXj/BoCoh2IikJcmuQyiEpLiR6OOy2GO8hwrN1P2MXfNPb74L/
   vlpGI4xSjkYceeI1LRfKsPOHyb89x4i/WS+f1+YvN/HOGgjzxI+EoaHFJ
   ZImgaBREQ4PIZqwWRYaCJQ3RsBOKa+CEVsHvA/9PgR4PcHC3JwWEWy8sb
   lIBoM9v5Xlb3rZJKRqn3zLjDij0/k3Rbd0NiDoL87FNyGTrP5X0lM2yYM
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="asc'?scan'208";a="142930726"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Mar 2023 06:37:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 06:37:17 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 20 Mar 2023 06:37:14 -0700
Date:   Mon, 20 Mar 2023 13:36:44 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     <linux-riscv@lists.infradead.org>, <palmer@dabbelt.com>,
        <anup@brainfault.org>, <atishp@atishpatra.org>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <vineetg@rivosinc.com>, <greentime.hu@sifive.com>,
        <guoren@linux.alibaba.com>, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, Guo Ren <guoren@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        David Hildenbrand <david@redhat.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Wenting Zhang <zephray@outlook.com>,
        Andrew Bresticker <abrestic@rivosinc.com>
Subject: Re: [PATCH -next v15 13/19] riscv: signal: Add sigcontext
 save/restore for vector
Message-ID: <e0b5df49-4d78-4a0f-8509-ff29085486cf@spud>
References: <20230317113538.10878-1-andy.chiu@sifive.com>
 <20230317113538.10878-14-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OqCyYS4AY+5VfreL"
Content-Disposition: inline
In-Reply-To: <20230317113538.10878-14-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--OqCyYS4AY+5VfreL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 17, 2023 at 11:35:32AM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> This patch facilitates the existing fp-reserved words for placement of
> the first extension's context header on the user's sigframe. A context
> header consists of a distinct magic word and the size, including the
> header itself, of an extension on the stack. Then, the frame is followed
> by the context of that extension, and then a header + context body for
> another extension if exists. If there is no more extension to come, then
> the frame must be ended with a null context header. A special case is
> rv64gc, where the kernel support no extensions requiring to expose
> additional regfile to the user. In such case the kernel would place the
> null context header right after the first reserved word of
> __riscv_q_ext_state when saving sigframe. And the kernel would check if
> all reserved words are zeros when a signal handler returns.
>=20
> __riscv_q_ext_state---->|	|<-__riscv_extra_ext_header
> 			~	~
> 	.reserved[0]--->|0	|<-	.reserved
> 		<-------|magic	|<-	.hdr
> 		|	|size	|_______ end of sc_fpregs
> 		|	|ext-bdy|
> 		|	~	~
> 	+)size	------->|magic	|<- another context header
> 			|size	|
> 			|ext-bdy|
> 			~	~
> 			|magic:0|<- null context header
> 			|size:0	|
>=20
> The vector registers will be saved in datap pointer. The datap pointer
> will be allocated dynamically when the task needs in kernel space. On
> the other hand, datap pointer on the sigframe will be set right after
> the __riscv_v_ext_state data structure.
>=20
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> Suggested-by: Richard Henderson <richard.henderson@linaro.org>
> Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Sparse, or at least Palmer's hacked up version of it that I am running
[1] complains a bit about this patch, that you've added a few:
+      1 ../arch/riscv/kernel/signal.c:145:29: warning: incorrect type in i=
nitializer (different address spaces)
+      1 ../arch/riscv/kernel/signal.c:171:24: warning: incorrect type in i=
nitializer (different address spaces)
+      1 ../arch/riscv/kernel/signal.c:172:24: warning: incorrect type in i=
nitializer (different address spaces)
+      1 ../arch/riscv/kernel/signal.c:268:47: warning: incorrect type in i=
nitializer (different address spaces)
+      1 ../arch/riscv/kernel/signal.c:282:16: warning: incorrect type in i=
nitializer (different address spaces)
+      1 ../arch/riscv/kernel/signal.c:283:16: warning: incorrect type in i=
nitializer (different address spaces)
Please have a look at those, and check whether they're valid complaints.

Otherwise, this version of this patch seems a lot nicer than the last
version, so that makes me happy at least, even if sparse isn't..

Acked-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

1 - https://git.kernel.org/pub/scm/linux/kernel/git/palmer/sparse.git/ risc=
v-zicbom

> ---
>  arch/riscv/include/uapi/asm/ptrace.h     |  15 ++
>  arch/riscv/include/uapi/asm/sigcontext.h |  16 ++-
>  arch/riscv/kernel/setup.c                |   3 +
>  arch/riscv/kernel/signal.c               | 174 +++++++++++++++++++++--
>  4 files changed, 193 insertions(+), 15 deletions(-)
>=20
> diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/ua=
pi/asm/ptrace.h
> index e8d127ec5cf7..e17c550986a6 100644
> --- a/arch/riscv/include/uapi/asm/ptrace.h
> +++ b/arch/riscv/include/uapi/asm/ptrace.h
> @@ -71,6 +71,21 @@ struct __riscv_q_ext_state {
>  	__u32 reserved[3];
>  };
> =20
> +struct __riscv_ctx_hdr {
> +	__u32 magic;
> +	__u32 size;
> +};
> +
> +struct __riscv_extra_ext_header {
> +	__u32 __padding[129] __attribute__((aligned(16)));
> +	/*
> +	 * Reserved for expansion of sigcontext structure.  Currently zeroed
> +	 * upon signal, and must be zero upon sigreturn.
> +	 */
> +	__u32 reserved;
> +	struct __riscv_ctx_hdr hdr;
> +};
> +
>  union __riscv_fp_state {
>  	struct __riscv_f_ext_state f;
>  	struct __riscv_d_ext_state d;
> diff --git a/arch/riscv/include/uapi/asm/sigcontext.h b/arch/riscv/includ=
e/uapi/asm/sigcontext.h
> index 84f2dfcfdbce..8b8a8541673a 100644
> --- a/arch/riscv/include/uapi/asm/sigcontext.h
> +++ b/arch/riscv/include/uapi/asm/sigcontext.h
> @@ -8,6 +8,17 @@
> =20
>  #include <asm/ptrace.h>
> =20
> +/* The Magic number for signal context frame header. */
> +#define RISCV_V_MAGIC	0x53465457
> +#define END_MAGIC	0x0
> +
> +/* The size of END signal context header. */
> +#define END_HDR_SIZE	0x0
> +
> +struct __sc_riscv_v_state {
> +	struct __riscv_v_ext_state v_state;
> +} __attribute__((aligned(16)));
> +
>  /*
>   * Signal context structure
>   *
> @@ -16,7 +27,10 @@
>   */
>  struct sigcontext {
>  	struct user_regs_struct sc_regs;
> -	union __riscv_fp_state sc_fpregs;
> +	union {
> +		union __riscv_fp_state sc_fpregs;
> +		struct __riscv_extra_ext_header sc_extdesc;
> +	};
>  };
> =20
>  #endif /* _UAPI_ASM_RISCV_SIGCONTEXT_H */
> diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
> index 376d2827e736..b9b3e03b2564 100644
> --- a/arch/riscv/kernel/setup.c
> +++ b/arch/riscv/kernel/setup.c
> @@ -262,6 +262,8 @@ static void __init parse_dtb(void)
>  #endif
>  }
> =20
> +extern void __init init_rt_signal_env(void);
> +
>  void __init setup_arch(char **cmdline_p)
>  {
>  	parse_dtb();
> @@ -299,6 +301,7 @@ void __init setup_arch(char **cmdline_p)
> =20
>  	riscv_init_cbom_blocksize();
>  	riscv_fill_hwcap();
> +	init_rt_signal_env();
>  	apply_boot_alternatives();
>  	if (IS_ENABLED(CONFIG_RISCV_ISA_ZICBOM) &&
>  	    riscv_isa_extension_available(NULL, ZICBOM))
> diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
> index eefc78d74055..55d2215d18ea 100644
> --- a/arch/riscv/kernel/signal.c
> +++ b/arch/riscv/kernel/signal.c
> @@ -18,9 +18,11 @@
>  #include <asm/signal.h>
>  #include <asm/signal32.h>
>  #include <asm/switch_to.h>
> +#include <asm/vector.h>
>  #include <asm/csr.h>
> =20
>  extern u32 __user_rt_sigreturn[2];
> +static size_t riscv_v_sc_size __ro_after_init;
> =20
>  #define DEBUG_SIG 0
> =20
> @@ -62,12 +64,87 @@ static long save_fp_state(struct pt_regs *regs,
>  #define restore_fp_state(task, regs) (0)
>  #endif
> =20
> +#ifdef CONFIG_RISCV_ISA_V
> +
> +static long save_v_state(struct pt_regs *regs, void **sc_vec)
> +{
> +	struct __riscv_ctx_hdr __user *hdr;
> +	struct __sc_riscv_v_state __user *state;
> +	void __user *datap;
> +	long err;
> +
> +	hdr =3D *sc_vec;
> +	/* Place state to the user's signal context space after the hdr */
> +	state =3D (struct __sc_riscv_v_state *)(hdr + 1);
> +	/* Point datap right after the end of __sc_riscv_v_state */
> +	datap =3D state + 1;
> +
> +	/* datap is designed to be 16 byte aligned for better performance */
> +	WARN_ON(unlikely(!IS_ALIGNED((unsigned long)datap, 16)));
> +
> +	riscv_v_vstate_save(current, regs);
> +	/* Copy everything of vstate but datap. */
> +	err =3D __copy_to_user(&state->v_state, &current->thread.vstate,
> +			     offsetof(struct __riscv_v_ext_state, datap));
> +	/* Copy the pointer datap itself. */
> +	err |=3D __put_user(datap, &state->v_state.datap);
> +	/* Copy the whole vector content to user space datap. */
> +	err |=3D __copy_to_user(datap, current->thread.vstate.datap, riscv_v_vs=
ize);
> +	/* Copy magic to the user space after saving  all vector conetext */
> +	err |=3D __put_user(RISCV_V_MAGIC, &hdr->magic);
> +	err |=3D __put_user(riscv_v_sc_size, &hdr->size);
> +	if (unlikely(err))
> +		return err;
> +
> +	/* Only progress the sv_vec if everything has done successfully  */
> +	*sc_vec +=3D riscv_v_sc_size;
> +	return 0;
> +}
> +
> +/*
> + * Restore Vector extension context from the user's signal frame. This f=
unction
> + * assumes a valid extension header. So magic and size checking must be =
done by
> + * the caller.
> + */
> +static long __restore_v_state(struct pt_regs *regs, void *sc_vec)
> +{
> +	long err;
> +	struct __sc_riscv_v_state __user *state =3D sc_vec;
> +	void __user *datap;
> +
> +	/* Copy everything of __sc_riscv_v_state except datap. */
> +	err =3D __copy_from_user(&current->thread.vstate, &state->v_state,
> +			       offsetof(struct __riscv_v_ext_state, datap));
> +	if (unlikely(err))
> +		return err;
> +
> +	/* Copy the pointer datap itself. */
> +	err =3D __get_user(datap, &state->v_state.datap);
> +	if (unlikely(err))
> +		return err;
> +	/*
> +	 * Copy the whole vector content from user space datap. Use
> +	 * copy_from_user to prevent information leak.
> +	 */
> +	err =3D copy_from_user(current->thread.vstate.datap, datap, riscv_v_vsi=
ze);
> +	if (unlikely(err))
> +		return err;
> +
> +	riscv_v_vstate_restore(current, regs);
> +
> +	return err;
> +}
> +#else
> +#define save_v_state(task, regs) (0)
> +#define __restore_v_state(task, regs) (0)
> +#endif
> +
>  static long restore_sigcontext(struct pt_regs *regs,
>  	struct sigcontext __user *sc)
>  {
> +	void *sc_ext_ptr =3D &sc->sc_extdesc.hdr;
> +	__u32 rsvd;
>  	long err;
> -	size_t i;
> -
>  	/* sc_regs is structured the same as the start of pt_regs */
>  	err =3D __copy_from_user(regs, &sc->sc_regs, sizeof(sc->sc_regs));
>  	if (unlikely(err))
> @@ -80,32 +157,81 @@ static long restore_sigcontext(struct pt_regs *regs,
>  			return err;
>  	}
> =20
> -	/* We support no other extension state at this time. */
> -	for (i =3D 0; i < ARRAY_SIZE(sc->sc_fpregs.q.reserved); i++) {
> -		u32 value;
> +	/* Check the reserved word before extensions parsing */
> +	err =3D __get_user(rsvd, &sc->sc_extdesc.reserved);
> +	if (unlikely(err))
> +		return err;
> +	if (unlikely(rsvd))
> +		return -EINVAL;
> +
> +	while (!err) {
> +		__u32 magic, size;
> +		struct __riscv_ctx_hdr *head =3D sc_ext_ptr;
> =20
> -		err =3D __get_user(value, &sc->sc_fpregs.q.reserved[i]);
> +		err |=3D __get_user(magic, &head->magic);
> +		err |=3D __get_user(size, &head->size);
>  		if (unlikely(err))
> +			return err;
> +
> +		sc_ext_ptr +=3D sizeof(*head);
> +		switch (magic) {
> +		case END_MAGIC:
> +			if (size !=3D END_HDR_SIZE)
> +				return -EINVAL;
> +
> +			return 0;
> +		case RISCV_V_MAGIC:
> +			if (!has_vector() || !riscv_v_vstate_query(regs) ||
> +			    size !=3D riscv_v_sc_size)
> +				return -EINVAL;
> +
> +			err =3D __restore_v_state(regs, sc_ext_ptr);
>  			break;
> -		if (value !=3D 0)
> +		default:
>  			return -EINVAL;
> +		}
> +		sc_ext_ptr =3D (void *)head + size;
>  	}
>  	return err;
>  }
> =20
> +static size_t get_rt_frame_size(void)
> +{
> +	struct rt_sigframe __user *frame;
> +	size_t frame_size;
> +	size_t total_context_size =3D 0;
> +
> +	frame_size =3D sizeof(*frame);
> +
> +	if (has_vector() && riscv_v_vstate_query(task_pt_regs(current)))
> +		total_context_size +=3D riscv_v_sc_size;
> +	/*
> +	 * Preserved a __riscv_ctx_hdr for END signal context header if an
> +	 * extension uses __riscv_extra_ext_header
> +	 */
> +	if (total_context_size)
> +		total_context_size +=3D sizeof(struct __riscv_ctx_hdr);
> +
> +	frame_size +=3D total_context_size;
> +
> +	frame_size =3D round_up(frame_size, 16);
> +	return frame_size;
> +}
> +
>  SYSCALL_DEFINE0(rt_sigreturn)
>  {
>  	struct pt_regs *regs =3D current_pt_regs();
>  	struct rt_sigframe __user *frame;
>  	struct task_struct *task;
>  	sigset_t set;
> +	size_t frame_size =3D get_rt_frame_size();
> =20
>  	/* Always make any pending restarted system calls return -EINTR */
>  	current->restart_block.fn =3D do_no_restart_syscall;
> =20
>  	frame =3D (struct rt_sigframe __user *)regs->sp;
> =20
> -	if (!access_ok(frame, sizeof(*frame)))
> +	if (!access_ok(frame, frame_size))
>  		goto badframe;
> =20
>  	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
> @@ -139,17 +265,22 @@ static long setup_sigcontext(struct rt_sigframe __u=
ser *frame,
>  	struct pt_regs *regs)
>  {
>  	struct sigcontext __user *sc =3D &frame->uc.uc_mcontext;
> +	struct __riscv_ctx_hdr *sc_ext_ptr =3D &sc->sc_extdesc.hdr;
>  	long err;
> -	size_t i;
> =20
>  	/* sc_regs is structured the same as the start of pt_regs */
>  	err =3D __copy_to_user(&sc->sc_regs, regs, sizeof(sc->sc_regs));
>  	/* Save the floating-point state. */
>  	if (has_fpu())
>  		err |=3D save_fp_state(regs, &sc->sc_fpregs);
> -	/* We support no other extension state at this time. */
> -	for (i =3D 0; i < ARRAY_SIZE(sc->sc_fpregs.q.reserved); i++)
> -		err |=3D __put_user(0, &sc->sc_fpregs.q.reserved[i]);
> +	/* Save the vector state. */
> +	if (has_vector() && riscv_v_vstate_query(regs))
> +		err |=3D save_v_state(regs, (void **)&sc_ext_ptr);
> +	/* Write zero to fp-reserved space and check it on restore_sigcontext */
> +	err |=3D __put_user(0, &sc->sc_extdesc.reserved);
> +	/* And put END __riscv_ctx_hdr at the end. */
> +	err |=3D __put_user(END_MAGIC, &sc_ext_ptr->magic);
> +	err |=3D __put_user(END_HDR_SIZE, &sc_ext_ptr->size);
> =20
>  	return err;
>  }
> @@ -174,6 +305,13 @@ static inline void __user *get_sigframe(struct ksign=
al *ksig,
>  	/* Align the stack frame. */
>  	sp &=3D ~0xfUL;
> =20
> +	/*
> +	 * Fail if the size of the altstack is not large enough for the
> +	 * sigframe construction.
> +	 */
> +	if (current->sas_ss_size && sp < current->sas_ss_sp)
> +		return (void __user __force *)-1UL;
> +
>  	return (void __user *)sp;
>  }
> =20
> @@ -182,9 +320,10 @@ static int setup_rt_frame(struct ksignal *ksig, sigs=
et_t *set,
>  {
>  	struct rt_sigframe __user *frame;
>  	long err =3D 0;
> +	size_t frame_size =3D get_rt_frame_size();
> =20
> -	frame =3D get_sigframe(ksig, regs, sizeof(*frame));
> -	if (!access_ok(frame, sizeof(*frame)))
> +	frame =3D get_sigframe(ksig, regs, frame_size);
> +	if (!access_ok(frame, frame_size))
>  		return -EFAULT;
> =20
>  	err |=3D copy_siginfo_to_user(&frame->info, &ksig->info);
> @@ -338,3 +477,10 @@ asmlinkage __visible void do_work_pending(struct pt_=
regs *regs,
>  		thread_info_flags =3D read_thread_flags();
>  	} while (thread_info_flags & _TIF_WORK_MASK);
>  }
> +
> +void init_rt_signal_env(void);
> +void __init init_rt_signal_env(void)
> +{
> +	riscv_v_sc_size =3D sizeof(struct __riscv_ctx_hdr) +
> +			  sizeof(struct __sc_riscv_v_state) + riscv_v_vsize;
> +}
> --=20
> 2.17.1
>=20
>=20

--OqCyYS4AY+5VfreL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBhhbAAKCRB4tDGHoIJi
0sCWAPsGHSJSBZ/WT9E/XX7zYzS07AY/DGeZMy+/FD5sxK6tjQD/YoT0lmHvSSPS
jgZPgvWCMepQ2vvUdfycyfYw83ByXAw=
=kI0V
-----END PGP SIGNATURE-----

--OqCyYS4AY+5VfreL--
