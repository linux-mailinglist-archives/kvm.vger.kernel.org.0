Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01DD77A4BB
	for <lists+kvm@lfdr.de>; Sun, 13 Aug 2023 04:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjHMCYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Aug 2023 22:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjHMCYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Aug 2023 22:24:31 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC2F1706
        for <kvm@vger.kernel.org>; Sat, 12 Aug 2023 19:24:33 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b9d07a8d84so50635971fa.3
        for <kvm@vger.kernel.org>; Sat, 12 Aug 2023 19:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691893472; x=1692498272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SuYbk7NxBbnqEZN+HqilzfXpT2oPpONXvOl1AkVEhCU=;
        b=Ab1RBorDx/eVmWiTFEMsOThyJQZwOQOuE8hzeZuQlwcQ9GJXCOa2nxzhK6ryisaSDo
         3uoB6Upr/yULiyltvZDNejw+AIn05VHoT2N4kVDDsbJ+d38eci8LoZJYwLNJYACc7KPj
         pqLKQmcb2dQroPipWc61lYX0kOAEp6e/frsnLN/X2XUNdYbjPxGfHNgYsPVlxDz1Y6ww
         wVBTupteWZwGyH3H+qcqECbxnMzgYRxJiMblKiwA/jWwuvDPGFj2BaTtiane1HrbE87E
         rbuAJL9gqkdkQYs/DSjOeeMKl1SQbp/mUkb9LWaRDfOvToUaFMDqyk/Yo9CM1ZxkUIN9
         qiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691893472; x=1692498272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SuYbk7NxBbnqEZN+HqilzfXpT2oPpONXvOl1AkVEhCU=;
        b=cKK6tKkFjsQhWLXh44zVyK+EPtZPh063TQPXDru5SbbeWFq88i4T8LArWN46R8Pp1q
         DC/Q9P1YZwmV4k3IjIle0SNzZBAhpZGI2Gk50qEk/LEtnjFNUWWMgfEAeJOZqfrE7o+L
         hoGDjMDNgP+1wna2RlNH5LO11TY0kwPTbvmO5Q8ZC4mEKcSWKyZDco522LUYuu1teSIy
         mcoIR2SAiTuZh+1yCx+MLU756NYiP6gCHMKNZg7LGK2/z3nKdm0fj56mRuftzL6X6ZfE
         fpxKfbSf1kIr3Ed+6TwmRzOTzbtuBg/Okf8668Yw0wwsGFFqeUdqj8iqT6uRRj1XeZLS
         nYJg==
X-Gm-Message-State: AOJu0YxtOBcuZH/GYOe0W/18GVJjOdSL+sOYp8GTHnGQmXQTw8h7fxwy
        fncRa3IUe4vVJhq87v85BAPSC8WR0v+6v9o/Pi+vfK84p811yU9z5NqGaQ==
X-Google-Smtp-Source: AGHT+IGnwAci+zoYp17T7DjsAXa0Tonukwztw5tvsXr3FLtHNOvFYosEVtaggGuRi2e7IdrYzMH8stYEgDqCoAXxo0E=
X-Received: by 2002:a2e:8791:0:b0:2b7:7c:d5a1 with SMTP id n17-20020a2e8791000000b002b7007cd5a1mr4215967lji.23.1691893471437;
 Sat, 12 Aug 2023 19:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-15-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-15-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Sat, 12 Aug 2023 19:24:19 -0700
Message-ID: <CAAdAUtjpUwgChEJCsEBnMFEKPW+hDhU-73Kp=NJ9f7=gA8SJyQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/27] KVM: arm64: nv: Add trap forwarding infrastructure
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Aug 8, 2023 at 4:48=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> A significant part of what a NV hypervisor needs to do is to decide
> whether a trap from a L2+ guest has to be forwarded to a L1 guest
> or handled locally. This is done by checking for the trap bits that
> the guest hypervisor has set and acting accordingly, as described by
> the architecture.
>
> A previous approach was to sprinkle a bunch of checks in all the
> system register accessors, but this is pretty error prone and doesn't
> help getting an overview of what is happening.
>
> Instead, implement a set of global tables that describe a trap bit,
> combinations of trap bits, behaviours on trap, and what bits must
> be evaluated on a system register trap.
>
> Although this is painful to describe, this allows to specify each
> and every control bit in a static manner. To make it efficient,
> the table is inserted in an xarray that is global to the system,
> and checked each time we trap a system register while running
> a L2 guest.
>
> Add the basic infrastructure for now, while additional patches will
> implement configuration registers.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h   |   1 +
>  arch/arm64/include/asm/kvm_nested.h |   2 +
>  arch/arm64/kvm/emulate-nested.c     | 262 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c           |   6 +
>  arch/arm64/kvm/trace_arm.h          |  26 +++
>  5 files changed, 297 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 721680da1011..cb1c5c54cedd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -988,6 +988,7 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
>  void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
>
>  int __init kvm_sys_reg_table_init(void);
> +int __init populate_nv_trap_config(void);
>
>  bool lock_all_vcpus(struct kvm *kvm);
>  void unlock_all_vcpus(struct kvm *kvm);
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm=
/kvm_nested.h
> index 8fb67f032fd1..fa23cc9c2adc 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -11,6 +11,8 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *v=
cpu)
>                 test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
>  }
>
> +extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
> +
>  struct sys_reg_params;
>  struct sys_reg_desc;
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index b96662029fb1..1b1148770d45 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -14,6 +14,268 @@
>
>  #include "trace.h"
>
> +enum trap_behaviour {
> +       BEHAVE_HANDLE_LOCALLY   =3D 0,
> +       BEHAVE_FORWARD_READ     =3D BIT(0),
> +       BEHAVE_FORWARD_WRITE    =3D BIT(1),
> +       BEHAVE_FORWARD_ANY      =3D BEHAVE_FORWARD_READ | BEHAVE_FORWARD_=
WRITE,
> +};
> +
> +struct trap_bits {
> +       const enum vcpu_sysreg          index;
> +       const enum trap_behaviour       behaviour;
> +       const u64                       value;
> +       const u64                       mask;
> +};
> +
> +enum trap_group {
> +       /* Indicates no coarse trap control */
> +       __RESERVED__,
> +
> +       /*
> +        * The first batch of IDs denote coarse trapping that are used
> +        * on their own instead of being part of a combination of
> +        * trap controls.
> +        */
> +
> +       /*
> +        * Anything after this point is a combination of trap controls,
> +        * which all must be evaluated to decide what to do.
> +        */
> +       __MULTIPLE_CONTROL_BITS__,
> +
> +       /*
> +        * Anything after this point requires a callback evaluating a
> +        * complex trap condition. Hopefully we'll never need this...
> +        */
> +       __COMPLEX_CONDITIONS__,
> +
> +       /* Must be last */
> +       __NR_TRAP_GROUP_IDS__
> +};
> +
> +static const struct trap_bits coarse_trap_bits[] =3D {
> +};
> +
> +#define MCB(id, ...)                                   \
> +       [id - __MULTIPLE_CONTROL_BITS__]        =3D       \
> +               (const enum trap_group []){             \
> +                       __VA_ARGS__, __RESERVED__       \
> +               }
> +
> +static const enum trap_group *coarse_control_combo[] =3D {
> +};
> +
> +typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *=
);
> +
> +#define CCC(id, fn)                            \
> +       [id - __COMPLEX_CONDITIONS__] =3D fn
> +
> +static const complex_condition_check ccc[] =3D {
> +};
> +
> +/*
> + * Bit assignment for the trap controls. We use a 64bit word with the
> + * following layout for each trapped sysreg:
> + *
> + * [9:0]       enum trap_group (10 bits)
> + * [13:10]     enum fgt_group_id (4 bits)
> + * [19:14]     bit number in the FGT register (6 bits)
> + * [20]                trap polarity (1 bit)
> + * [62:21]     Unused (42 bits)
> + * [63]                RES0 - Must be zero, as lost on insertion in the =
xarray
> + */
> +#define TC_CGT_BITS    10
> +#define TC_FGT_BITS    4
> +
> +union trap_config {
> +       u64     val;
> +       struct {
> +               unsigned long   cgt:TC_CGT_BITS; /* Coarse trap id */
> +               unsigned long   fgt:TC_FGT_BITS; /* Fing Grained Trap id =
*/

Would it be better to leave the definition of FGT field to patch 19/27
which adds the infrastructure for FGT forwarding?

> +               unsigned long   bit:6;           /* Bit number */
> +               unsigned long   pol:1;           /* Polarity */
> +               unsigned long   unk:42;          /* Unknown */
> +               unsigned long   mbz:1;           /* Must Be Zero */
> +       };
> +};
> +
> +struct encoding_to_trap_config {
> +       const u32                       encoding;
> +       const u32                       end;
> +       const union trap_config         tc;
> +};
> +
> +#define SR_RANGE_TRAP(sr_start, sr_end, trap_id)                       \
> +       {                                                               \
> +               .encoding       =3D sr_start,                            =
 \
> +               .end            =3D sr_end,                              =
 \
> +               .tc             =3D {                                    =
 \
> +                       .cgt            =3D trap_id,                     =
 \
> +               },                                                      \
> +       }
> +
> +#define SR_TRAP(sr, trap_id)           SR_RANGE_TRAP(sr, sr, trap_id)
> +
> +/*
> + * Map encoding to trap bits for exception reported with EC=3D0x18.
> + * These must only be evaluated when running a nested hypervisor, but
> + * that the current context is not a hypervisor context. When the
> + * trapped access matches one of the trap controls, the exception is
> + * re-injected in the nested hypervisor.
> + */
> +static const struct encoding_to_trap_config encoding_to_cgt[] __initcons=
t =3D {
> +};
> +
> +static DEFINE_XARRAY(sr_forward_xa);
> +
> +static union trap_config get_trap_config(u32 sysreg)
> +{
> +       return (union trap_config) {
> +               .val =3D xa_to_value(xa_load(&sr_forward_xa, sysreg)),
> +       };
> +}
> +
> +int __init populate_nv_trap_config(void)
> +{
> +       int ret =3D 0;
> +
> +       BUILD_BUG_ON(sizeof(union trap_config) !=3D sizeof(void *));
> +       BUILD_BUG_ON(__NR_TRAP_GROUP_IDS__ > BIT(TC_CGT_BITS));
> +
> +       for (int i =3D 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
> +               const struct encoding_to_trap_config *cgt =3D &encoding_t=
o_cgt[i];
> +               void *prev;
> +
> +               prev =3D xa_store_range(&sr_forward_xa, cgt->encoding, cg=
t->end,
> +                                     xa_mk_value(cgt->tc.val), GFP_KERNE=
L);
> +
> +               if (prev) {
> +                       kvm_err("Duplicate CGT for (%d, %d, %d, %d, %d)\n=
",
> +                               sys_reg_Op0(cgt->encoding),
> +                               sys_reg_Op1(cgt->encoding),
> +                               sys_reg_CRn(cgt->encoding),
> +                               sys_reg_CRm(cgt->encoding),
> +                               sys_reg_Op2(cgt->encoding));
> +                       ret =3D -EINVAL;
> +               }

The xa_store_range would only return non-NULL when the entry cannot be
stored (XA_ERROR(-EINVAL)) or memory allocation failed
(XA_ERROR(-ENOMEM)).
Another way may be needed to detect duplicate CGT.

> +       }
> +
> +       kvm_info("nv: %ld coarse grained trap handlers\n",
> +                ARRAY_SIZE(encoding_to_cgt));
> +
> +       for (int id =3D __MULTIPLE_CONTROL_BITS__;
> +            id < (__COMPLEX_CONDITIONS__ - 1);
> +            id++) {
> +               const enum trap_group *cgids;
> +
> +               cgids =3D coarse_control_combo[id - __MULTIPLE_CONTROL_BI=
TS__];
> +
> +               for (int i =3D 0; cgids[i] !=3D __RESERVED__; i++) {
> +                       if (cgids[i] >=3D __MULTIPLE_CONTROL_BITS__) {
> +                               kvm_err("Recursive MCB %d/%d\n", id, cgid=
s[i]);
> +                               ret =3D -EINVAL;

I am confused about the above check for recursive MCB. In patch 17/29,
a recursive MCD is added and looks like recursive MCB is allowed as
shown in __do_compute_trap_behaviour().

> +                       }
> +               }
> +       }
> +
> +       if (ret)
> +               xa_destroy(&sr_forward_xa);
> +
> +       return ret;
> +}
> +
> +static enum trap_behaviour get_behaviour(struct kvm_vcpu *vcpu,
> +                                        const struct trap_bits *tb)
> +{
> +       enum trap_behaviour b =3D BEHAVE_HANDLE_LOCALLY;
> +       u64 val;
> +
> +       val =3D __vcpu_sys_reg(vcpu, tb->index);
> +       if ((val & tb->mask) =3D=3D tb->value)
> +               b |=3D tb->behaviour;
> +
> +       return b;
> +}
> +
> +static enum trap_behaviour __do_compute_trap_behaviour(struct kvm_vcpu *=
vcpu,
> +                                                      const enum trap_gr=
oup id,
> +                                                      enum trap_behaviou=
r b)
> +{
> +       switch (id) {
> +               const enum trap_group *cgids;
> +
> +       case __RESERVED__ ... __MULTIPLE_CONTROL_BITS__ - 1:
> +               if (likely(id !=3D __RESERVED__))
> +                       b |=3D get_behaviour(vcpu, &coarse_trap_bits[id])=
;
> +               break;
> +       case __MULTIPLE_CONTROL_BITS__ ... __COMPLEX_CONDITIONS__ - 1:
> +               /* Yes, this is recursive. Don't do anything stupid. */
> +               cgids =3D coarse_control_combo[id - __MULTIPLE_CONTROL_BI=
TS__];
> +               for (int i =3D 0; cgids[i] !=3D __RESERVED__; i++)
> +                       b |=3D __do_compute_trap_behaviour(vcpu, cgids[i]=
, b);
> +               break;
> +       default:
> +               if (ARRAY_SIZE(ccc))
> +                       b |=3D ccc[id -  __COMPLEX_CONDITIONS__](vcpu);
> +               break;
> +       }
> +
> +       return b;
> +}
> +
> +static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
> +                                                 const union trap_config=
 tc)
> +{
> +       enum trap_behaviour b =3D BEHAVE_HANDLE_LOCALLY;
> +
> +       return __do_compute_trap_behaviour(vcpu, tc.cgt, b);
> +}
> +
> +bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
> +{
> +       union trap_config tc;
> +       enum trap_behaviour b;
> +       bool is_read;
> +       u32 sysreg;
> +       u64 esr;
> +
> +       if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +               return false;
> +
> +       esr =3D kvm_vcpu_get_esr(vcpu);
> +       sysreg =3D esr_sys64_to_sysreg(esr);
> +       is_read =3D (esr & ESR_ELx_SYS64_ISS_DIR_MASK) =3D=3D ESR_ELx_SYS=
64_ISS_DIR_READ;
> +
> +       tc =3D get_trap_config(sysreg);
> +
> +       /*
> +        * A value of 0 for the whole entry means that we know nothing
> +        * for this sysreg, and that it cannot be forwareded. In this
> +        * situation, let's cut it short.
> +        *
> +        * Note that ultimately, we could also make use of the xarray
> +        * to store the index of the sysreg in the local descriptor
> +        * array, avoiding another search... Hint, hint...
> +        */
> +       if (!tc.val)
> +               return false;
> +
> +       b =3D compute_trap_behaviour(vcpu, tc);
> +
> +       if (((b & BEHAVE_FORWARD_READ) && is_read) ||
> +           ((b & BEHAVE_FORWARD_WRITE) && !is_read))
> +               goto inject;
> +
> +       return false;
> +
> +inject:
> +       trace_kvm_forward_sysreg_trap(vcpu, sysreg, is_read);
> +
> +       kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +       return true;
> +}
> +
>  static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64=
 spsr)
>  {
>         u64 mode =3D spsr & PSR_MODE_MASK;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f5baaa508926..dfd72b3a625f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3177,6 +3177,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>
>         trace_kvm_handle_sys_reg(esr);
>
> +       if (__check_nv_sr_forward(vcpu))
> +               return 1;
> +
>         params =3D esr_sys64_to_params(esr);
>         params.regval =3D vcpu_get_reg(vcpu, Rt);
>
> @@ -3594,5 +3597,8 @@ int __init kvm_sys_reg_table_init(void)
>         if (!first_idreg)
>                 return -EINVAL;
>
> +       if (kvm_get_mode() =3D=3D KVM_MODE_NV)
> +               populate_nv_trap_config();

Do we need to check the return value of populate_nv_trap_config() and
fail the initialization if the return value is non-zero?

> +
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 6ce5c025218d..8ad53104934d 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -364,6 +364,32 @@ TRACE_EVENT(kvm_inject_nested_exception,
>                   __entry->hcr_el2)
>  );
>
> +TRACE_EVENT(kvm_forward_sysreg_trap,
> +           TP_PROTO(struct kvm_vcpu *vcpu, u32 sysreg, bool is_read),
> +           TP_ARGS(vcpu, sysreg, is_read),
> +
> +           TP_STRUCT__entry(
> +               __field(u64,    pc)
> +               __field(u32,    sysreg)
> +               __field(bool,   is_read)
> +           ),
> +
> +           TP_fast_assign(
> +               __entry->pc =3D *vcpu_pc(vcpu);
> +               __entry->sysreg =3D sysreg;
> +               __entry->is_read =3D is_read;
> +           ),
> +
> +           TP_printk("%llx %c (%d,%d,%d,%d,%d)",
> +                     __entry->pc,
> +                     __entry->is_read ? 'R' : 'W',
> +                     sys_reg_Op0(__entry->sysreg),
> +                     sys_reg_Op1(__entry->sysreg),
> +                     sys_reg_CRn(__entry->sysreg),
> +                     sys_reg_CRm(__entry->sysreg),
> +                     sys_reg_Op2(__entry->sysreg))
> +);
> +
>  #endif /* _TRACE_ARM_ARM64_KVM_H */
>
>  #undef TRACE_INCLUDE_PATH
> --
> 2.34.1
>
>

Thanks,
Jing
