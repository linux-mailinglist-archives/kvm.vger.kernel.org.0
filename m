Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C783D6C3131
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 13:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjCUMDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 08:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjCUMC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 08:02:58 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41AD1ADE3
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 05:02:46 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d17so4958378wrb.11
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 05:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vrull.eu; s=google; t=1679400165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=No6GsNXikNsyLPm1p6Xx7U9s7yJRaxe7Q0AfqeDqth0=;
        b=tLrglERRc7AUvszwBF0B81yQOjLho/G/KX6RlYVEEgcuRte++AG47DetrrYahSZuNO
         44urCZmyrzt1I2QvVzkRhVVCjP5yuNstgRUcYZB74FbCPlbkg6nnBfoVrIu42r5k8xhe
         I/RcQTks54cnbSgyBjfwsusaQbja1ulYHMm+bWZKrlmg12yYYB3CqXx55X3XIFRTUctX
         F5Ed7tEs6Acn4ghhC0BecbNdn/JvueGo/5eH4c7N18ulloC7y3E4FQkakFWyLPEuoKcp
         xy/BH7MZf2zRHSbhkJdlArUhcEW2AlqfSoRjzyNRb58iAKC/qsO6GpR0e/OldPgvGZEf
         5Rvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679400165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=No6GsNXikNsyLPm1p6Xx7U9s7yJRaxe7Q0AfqeDqth0=;
        b=kMMhPlKEBHICVZJhxbiAFya9uHqD5mrcW8cDZ0mUL/nx9CPVOAiXMHeHtGIJw/W0Lp
         KIzJZtmxuYCzMfR19htuwBCSY+7orfoVYq5SWZHiNrjm9J8kckLcsUIF+AXl71+95Iep
         eEeZ6rcPjzsA37DA+Q5hbV6ieLey1J7CVfltzZpn7tZfHmCbJq9UqhajhzJ+TYbwnHdX
         88HheRC8loSb5WzwRz1nIWvKtNUHkv2aQpSgGeuDO9FjLz6r387xxR7VM53zNgM5ysp/
         TLQ9dScCgcwih2bN4ZXthIXqbpVCA+Dw+NtIjWrIwP2u2LjPo8LK69WDvSEbklE+dpw6
         xiQg==
X-Gm-Message-State: AO0yUKUhdGPpL6ggQUYISVgwFQ2zFZjtQnZ2UPiVRShU1ltPO7o8V2Sb
        KgwT3DjYIXlU6p/VmKpuOlmczVGjg+2qZzp2Tmgyjg==
X-Google-Smtp-Source: AK7set9JzmJib45q5Wb1VyPUCiObVrSSwD1PMc+oS/RsMdMdIgffVCHOqJpNhORg4bKnVL/ZClLIhPTxlmZr/QkFM8E=
X-Received: by 2002:a5d:67c3:0:b0:2c7:3d2:fa20 with SMTP id
 n3-20020a5d67c3000000b002c703d2fa20mr477077wrw.13.1679400165039; Tue, 21 Mar
 2023 05:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230310160346.1193597-1-lawrence.hunter@codethink.co.uk> <20230310160346.1193597-3-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230310160346.1193597-3-lawrence.hunter@codethink.co.uk>
From:   =?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>
Date:   Tue, 21 Mar 2023 13:02:31 +0100
Message-ID: <CAEg0e7j=yGrz6uSCZirthZB7FEF-BtB73e+D-UB_hXQTJEtmyw@mail.gmail.com>
Subject: Re: [PATCH 02/45] target/riscv: Refactor some of the generic vector functionality
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, philipp.tomsich@vrull.eu, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 5:06=E2=80=AFPM Lawrence Hunter
<lawrence.hunter@codethink.co.uk> wrote:
>
> From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
>
> Summary of refactoring:
>
> * take some functions/macros out of `vector_helper` and put them in a
> new module called `vector_internals`
>
> * factor the non SEW-specific stuff out of `GEN_OPIVV_TRANS` into
> function `opivv_trans` (similar to `opivi_trans`)

I think splitting this commit into two changes would be better.
Besides that the two changes look reasonable and correct.

BR
Christoph

>
> All this refactoring ensures more functions/macros can be used by both
> vector and vector-crypto helpers (latter implemented in proceeding
> commit).
>
> Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
> ---
>  target/riscv/insn_trans/trans_rvv.c.inc |  62 +++++-----
>  target/riscv/meson.build                |   1 +
>  target/riscv/vector_helper.c            | 155 +-----------------------
>  target/riscv/vector_internals.c         |  57 +++++++++
>  target/riscv/vector_internals.h         | 155 ++++++++++++++++++++++++
>  5 files changed, 246 insertions(+), 184 deletions(-)
>  create mode 100644 target/riscv/vector_internals.c
>  create mode 100644 target/riscv/vector_internals.h
>
> diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_=
trans/trans_rvv.c.inc
> index f2e3d38515..4106bd6994 100644
> --- a/target/riscv/insn_trans/trans_rvv.c.inc
> +++ b/target/riscv/insn_trans/trans_rvv.c.inc
> @@ -1643,38 +1643,40 @@ GEN_OPIWX_WIDEN_TRANS(vwadd_wx)
>  GEN_OPIWX_WIDEN_TRANS(vwsubu_wx)
>  GEN_OPIWX_WIDEN_TRANS(vwsub_wx)
>
> +static bool opivv_trans(uint32_t vd, uint32_t vs1, uint32_t vs2, uint32_=
t vm,
> +                        gen_helper_gvec_4_ptr *fn, DisasContext *s)
> +{
> +    uint32_t data =3D 0;
> +    TCGLabel *over =3D gen_new_label();
> +    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
> +    tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
> +
> +    data =3D FIELD_DP32(data, VDATA, VM, vm);
> +    data =3D FIELD_DP32(data, VDATA, LMUL, s->lmul);
> +    data =3D FIELD_DP32(data, VDATA, VTA, s->vta);
> +    data =3D FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);
> +    data =3D FIELD_DP32(data, VDATA, VMA, s->vma);
> +    tcg_gen_gvec_4_ptr(vreg_ofs(s, vd), vreg_ofs(s, 0), vreg_ofs(s, vs1)=
,
> +                       vreg_ofs(s, vs2), cpu_env, s->cfg_ptr->vlen / 8,
> +                       s->cfg_ptr->vlen / 8, data, fn);
> +    mark_vs_dirty(s);
> +    gen_set_label(over);
> +    return true;
> +}
> +
>  /* Vector Integer Add-with-Carry / Subtract-with-Borrow Instructions */
>  /* OPIVV without GVEC IR */
> -#define GEN_OPIVV_TRANS(NAME, CHECK)                               \
> -static bool trans_##NAME(DisasContext *s, arg_rmrr *a)             \
> -{                                                                  \
> -    if (CHECK(s, a)) {                                             \
> -        uint32_t data =3D 0;                                         \
> -        static gen_helper_gvec_4_ptr * const fns[4] =3D {            \
> -            gen_helper_##NAME##_b, gen_helper_##NAME##_h,          \
> -            gen_helper_##NAME##_w, gen_helper_##NAME##_d,          \
> -        };                                                         \
> -        TCGLabel *over =3D gen_new_label();                          \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
> -        tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
> -                                                                   \
> -        data =3D FIELD_DP32(data, VDATA, VM, a->vm);                 \
> -        data =3D FIELD_DP32(data, VDATA, LMUL, s->lmul);             \
> -        data =3D FIELD_DP32(data, VDATA, VTA, s->vta);               \
> -        data =3D                                                     \
> -            FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);\
> -        data =3D FIELD_DP32(data, VDATA, VMA, s->vma);               \
> -        tcg_gen_gvec_4_ptr(vreg_ofs(s, a->rd), vreg_ofs(s, 0),     \
> -                           vreg_ofs(s, a->rs1),                    \
> -                           vreg_ofs(s, a->rs2), cpu_env,           \
> -                           s->cfg_ptr->vlen / 8,                   \
> -                           s->cfg_ptr->vlen / 8, data,             \
> -                           fns[s->sew]);                           \
> -        mark_vs_dirty(s);                                          \
> -        gen_set_label(over);                                       \
> -        return true;                                               \
> -    }                                                              \
> -    return false;                                                  \
> +#define GEN_OPIVV_TRANS(NAME, CHECK)                                    =
 \
> +static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                  =
 \
> +{                                                                       =
 \
> +    if (CHECK(s, a)) {                                                  =
 \
> +        static gen_helper_gvec_4_ptr * const fns[4] =3D {               =
   \
> +            gen_helper_##NAME##_b, gen_helper_##NAME##_h,               =
 \
> +            gen_helper_##NAME##_w, gen_helper_##NAME##_d,               =
 \
> +        };                                                              =
 \
> +        return opivv_trans(a->rd, a->rs1, a->rs2, a->vm, fns[s->sew], s)=
;\
> +    }                                                                   =
 \
> +    return false;                                                       =
 \
>  }
>
>  /*
> diff --git a/target/riscv/meson.build b/target/riscv/meson.build
> index 5dee37a242..a94fc3f598 100644
> --- a/target/riscv/meson.build
> +++ b/target/riscv/meson.build
> @@ -16,6 +16,7 @@ riscv_ss.add(files(
>    'gdbstub.c',
>    'op_helper.c',
>    'vector_helper.c',
> +  'vector_internals.c',
>    'bitmanip_helper.c',
>    'translate.c',
>    'm128_helper.c',
> diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
> index 2423affe37..f0e8ceff80 100644
> --- a/target/riscv/vector_helper.c
> +++ b/target/riscv/vector_helper.c
> @@ -26,6 +26,7 @@
>  #include "fpu/softfloat.h"
>  #include "tcg/tcg-gvec-desc.h"
>  #include "internals.h"
> +#include "vector_internals.h"
>  #include <math.h>
>
>  target_ulong HELPER(vsetvl)(CPURISCVState *env, target_ulong s1,
> @@ -75,68 +76,6 @@ target_ulong HELPER(vsetvl)(CPURISCVState *env, target=
_ulong s1,
>      return vl;
>  }
>
> -/*
> - * Note that vector data is stored in host-endian 64-bit chunks,
> - * so addressing units smaller than that needs a host-endian fixup.
> - */
> -#if HOST_BIG_ENDIAN
> -#define H1(x)   ((x) ^ 7)
> -#define H1_2(x) ((x) ^ 6)
> -#define H1_4(x) ((x) ^ 4)
> -#define H2(x)   ((x) ^ 3)
> -#define H4(x)   ((x) ^ 1)
> -#define H8(x)   ((x))
> -#else
> -#define H1(x)   (x)
> -#define H1_2(x) (x)
> -#define H1_4(x) (x)
> -#define H2(x)   (x)
> -#define H4(x)   (x)
> -#define H8(x)   (x)
> -#endif
> -
> -static inline uint32_t vext_nf(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, NF);
> -}
> -
> -static inline uint32_t vext_vm(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, VM);
> -}
> -
> -/*
> - * Encode LMUL to lmul as following:
> - *     LMUL    vlmul    lmul
> - *      1       000       0
> - *      2       001       1
> - *      4       010       2
> - *      8       011       3
> - *      -       100       -
> - *     1/8      101      -3
> - *     1/4      110      -2
> - *     1/2      111      -1
> - */
> -static inline int32_t vext_lmul(uint32_t desc)
> -{
> -    return sextract32(FIELD_EX32(simd_data(desc), VDATA, LMUL), 0, 3);
> -}
> -
> -static inline uint32_t vext_vta(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, VTA);
> -}
> -
> -static inline uint32_t vext_vma(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, VMA);
> -}
> -
> -static inline uint32_t vext_vta_all_1s(uint32_t desc)
> -{
> -    return FIELD_EX32(simd_data(desc), VDATA, VTA_ALL_1S);
> -}
> -
>  /*
>   * Get the maximum number of elements can be operated.
>   *
> @@ -155,21 +94,6 @@ static inline uint32_t vext_max_elems(uint32_t desc, =
uint32_t log2_esz)
>      return scale < 0 ? vlenb >> -scale : vlenb << scale;
>  }
>
> -/*
> - * Get number of total elements, including prestart, body and tail eleme=
nts.
> - * Note that when LMUL < 1, the tail includes the elements past VLMAX th=
at
> - * are held in the same vector register.
> - */
> -static inline uint32_t vext_get_total_elems(CPURISCVState *env, uint32_t=
 desc,
> -                                            uint32_t esz)
> -{
> -    uint32_t vlenb =3D simd_maxsz(desc);
> -    uint32_t sew =3D 1 << FIELD_EX64(env->vtype, VTYPE, VSEW);
> -    int8_t emul =3D ctzl(esz) - ctzl(sew) + vext_lmul(desc) < 0 ? 0 :
> -                  ctzl(esz) - ctzl(sew) + vext_lmul(desc);
> -    return (vlenb << emul) / esz;
> -}
> -
>  static inline target_ulong adjust_addr(CPURISCVState *env, target_ulong =
addr)
>  {
>      return (addr & env->cur_pmmask) | env->cur_pmbase;
> @@ -202,20 +126,6 @@ static void probe_pages(CPURISCVState *env, target_u=
long addr,
>      }
>  }
>
> -/* set agnostic elements to 1s */
> -static void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t=
 cnt,
> -                              uint32_t tot)
> -{
> -    if (is_agnostic =3D=3D 0) {
> -        /* policy undisturbed */
> -        return;
> -    }
> -    if (tot - cnt =3D=3D 0) {
> -        return;
> -    }
> -    memset(base + cnt, -1, tot - cnt);
> -}
> -
>  static inline void vext_set_elem_mask(void *v0, int index,
>                                        uint8_t value)
>  {
> @@ -225,18 +135,6 @@ static inline void vext_set_elem_mask(void *v0, int =
index,
>      ((uint64_t *)v0)[idx] =3D deposit64(old, pos, 1, value);
>  }
>
> -/*
> - * Earlier designs (pre-0.9) had a varying number of bits
> - * per mask value (MLEN). In the 0.9 design, MLEN=3D1.
> - * (Section 4.5)
> - */
> -static inline int vext_elem_mask(void *v0, int index)
> -{
> -    int idx =3D index / 64;
> -    int pos =3D index  % 64;
> -    return (((uint64_t *)v0)[idx] >> pos) & 1;
> -}
> -
>  /* elements operations for load and store */
>  typedef void vext_ldst_elem_fn(CPURISCVState *env, target_ulong addr,
>                                 uint32_t idx, void *vd, uintptr_t retaddr=
);
> @@ -739,18 +637,11 @@ GEN_VEXT_ST_WHOLE(vs8r_v, int8_t, ste_b)
>   *** Vector Integer Arithmetic Instructions
>   */
>
> -/* expand macro args before macro */
> -#define RVVCALL(macro, ...)  macro(__VA_ARGS__)
> -
>  /* (TD, T1, T2, TX1, TX2) */
>  #define OP_SSS_B int8_t, int8_t, int8_t, int8_t, int8_t
>  #define OP_SSS_H int16_t, int16_t, int16_t, int16_t, int16_t
>  #define OP_SSS_W int32_t, int32_t, int32_t, int32_t, int32_t
>  #define OP_SSS_D int64_t, int64_t, int64_t, int64_t, int64_t
> -#define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
> -#define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
> -#define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
> -#define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
>  #define OP_SUS_B int8_t, uint8_t, int8_t, uint8_t, int8_t
>  #define OP_SUS_H int16_t, uint16_t, int16_t, uint16_t, int16_t
>  #define OP_SUS_W int32_t, uint32_t, int32_t, uint32_t, int32_t
> @@ -774,16 +665,6 @@ GEN_VEXT_ST_WHOLE(vs8r_v, int8_t, ste_b)
>  #define NOP_UUU_H uint16_t, uint16_t, uint32_t, uint16_t, uint32_t
>  #define NOP_UUU_W uint32_t, uint32_t, uint64_t, uint32_t, uint64_t
>
> -/* operation of two vector elements */
> -typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
> -
> -#define OPIVV2(NAME, TD, T1, T2, TX1, TX2, HD, HS1, HS2, OP)    \
> -static void do_##NAME(void *vd, void *vs1, void *vs2, int i)    \
> -{                                                               \
> -    TX1 s1 =3D *((T1 *)vs1 + HS1(i));                             \
> -    TX2 s2 =3D *((T2 *)vs2 + HS2(i));                             \
> -    *((TD *)vd + HD(i)) =3D OP(s2, s1);                           \
> -}
>  #define DO_SUB(N, M) (N - M)
>  #define DO_RSUB(N, M) (M - N)
>
> @@ -796,40 +677,6 @@ RVVCALL(OPIVV2, vsub_vv_h, OP_SSS_H, H2, H2, H2, DO_=
SUB)
>  RVVCALL(OPIVV2, vsub_vv_w, OP_SSS_W, H4, H4, H4, DO_SUB)
>  RVVCALL(OPIVV2, vsub_vv_d, OP_SSS_D, H8, H8, H8, DO_SUB)
>
> -static void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
> -                       CPURISCVState *env, uint32_t desc,
> -                       opivv2_fn *fn, uint32_t esz)
> -{
> -    uint32_t vm =3D vext_vm(desc);
> -    uint32_t vl =3D env->vl;
> -    uint32_t total_elems =3D vext_get_total_elems(env, desc, esz);
> -    uint32_t vta =3D vext_vta(desc);
> -    uint32_t vma =3D vext_vma(desc);
> -    uint32_t i;
> -
> -    for (i =3D env->vstart; i < vl; i++) {
> -        if (!vm && !vext_elem_mask(v0, i)) {
> -            /* set masked-off elements to 1s */
> -            vext_set_elems_1s(vd, vma, i * esz, (i + 1) * esz);
> -            continue;
> -        }
> -        fn(vd, vs1, vs2, i);
> -    }
> -    env->vstart =3D 0;
> -    /* set tail elements to 1s */
> -    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
> -}
> -
> -/* generate the helpers for OPIVV */
> -#define GEN_VEXT_VV(NAME, ESZ)                            \
> -void HELPER(NAME)(void *vd, void *v0, void *vs1,          \
> -                  void *vs2, CPURISCVState *env,          \
> -                  uint32_t desc)                          \
> -{                                                         \
> -    do_vext_vv(vd, v0, vs1, vs2, env, desc,               \
> -               do_##NAME, ESZ);                           \
> -}
> -
>  GEN_VEXT_VV(vadd_vv_b, 1)
>  GEN_VEXT_VV(vadd_vv_h, 2)
>  GEN_VEXT_VV(vadd_vv_w, 4)
> diff --git a/target/riscv/vector_internals.c b/target/riscv/vector_intern=
als.c
> new file mode 100644
> index 0000000000..95efaa79cb
> --- /dev/null
> +++ b/target/riscv/vector_internals.c
> @@ -0,0 +1,57 @@
> +/*
> + * RISC-V Vector Extension Internals
> + *
> + * Copyright (c) 2020 T-Head Semiconductor Co., Ltd. All rights reserved=
.
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2 or later, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOU=
T
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "vector_internals.h"
> +
> +/* set agnostic elements to 1s */
> +void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
> +                       uint32_t tot)
> +{
> +    if (is_agnostic =3D=3D 0) {
> +        /* policy undisturbed */
> +        return;
> +    }
> +    if (tot - cnt =3D=3D 0) {
> +        return ;
> +    }
> +    memset(base + cnt, -1, tot - cnt);
> +}
> +
> +void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
> +                CPURISCVState *env, uint32_t desc,
> +                opivv2_fn *fn, uint32_t esz)
> +{
> +    uint32_t vm =3D vext_vm(desc);
> +    uint32_t vl =3D env->vl;
> +    uint32_t total_elems =3D vext_get_total_elems(env, desc, esz);
> +    uint32_t vta =3D vext_vta(desc);
> +    uint32_t vma =3D vext_vma(desc);
> +    uint32_t i;
> +
> +    for (i =3D env->vstart; i < vl; i++) {
> +        if (!vm && !vext_elem_mask(v0, i)) {
> +            /* set masked-off elements to 1s */
> +            vext_set_elems_1s(vd, vma, i * esz, (i + 1) * esz);
> +            continue;
> +        }
> +        fn(vd, vs1, vs2, i);
> +    }
> +    env->vstart =3D 0;
> +    /* set tail elements to 1s */
> +    vext_set_elems_1s(vd, vta, vl * esz, total_elems * esz);
> +}
> diff --git a/target/riscv/vector_internals.h b/target/riscv/vector_intern=
als.h
> new file mode 100644
> index 0000000000..a04b7321fb
> --- /dev/null
> +++ b/target/riscv/vector_internals.h
> @@ -0,0 +1,155 @@
> +/*
> + * RISC-V Vector Extension Internals
> + *
> + * Copyright (c) 2020 T-Head Semiconductor Co., Ltd. All rights reserved=
.
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2 or later, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOU=
T
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef TARGET_RISCV_VECTOR_INTERNALS_H
> +#define TARGET_RISCV_VECTOR_INTERNALS_H
> +
> +#include "qemu/osdep.h"
> +#include "qemu/bitops.h"
> +#include "cpu.h"
> +#include "tcg/tcg-gvec-desc.h"
> +#include "internals.h"
> +
> +static inline uint32_t vext_nf(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, NF);
> +}
> +
> +/*
> + * Note that vector data is stored in host-endian 64-bit chunks,
> + * so addressing units smaller than that needs a host-endian fixup.
> + */
> +#if HOST_BIG_ENDIAN
> +#define H1(x)   ((x) ^ 7)
> +#define H1_2(x) ((x) ^ 6)
> +#define H1_4(x) ((x) ^ 4)
> +#define H2(x)   ((x) ^ 3)
> +#define H4(x)   ((x) ^ 1)
> +#define H8(x)   ((x))
> +#else
> +#define H1(x)   (x)
> +#define H1_2(x) (x)
> +#define H1_4(x) (x)
> +#define H2(x)   (x)
> +#define H4(x)   (x)
> +#define H8(x)   (x)
> +#endif
> +
> +/*
> + * Encode LMUL to lmul as following:
> + *     LMUL    vlmul    lmul
> + *      1       000       0
> + *      2       001       1
> + *      4       010       2
> + *      8       011       3
> + *      -       100       -
> + *     1/8      101      -3
> + *     1/4      110      -2
> + *     1/2      111      -1
> + */
> +static inline int32_t vext_lmul(uint32_t desc)
> +{
> +    return sextract32(FIELD_EX32(simd_data(desc), VDATA, LMUL), 0, 3);
> +}
> +
> +static inline uint32_t vext_vm(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, VM);
> +}
> +
> +static inline uint32_t vext_vma(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, VMA);
> +}
> +
> +static inline uint32_t vext_vta(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, VTA);
> +}
> +
> +static inline uint32_t vext_vta_all_1s(uint32_t desc)
> +{
> +    return FIELD_EX32(simd_data(desc), VDATA, VTA_ALL_1S);
> +}
> +
> +/*
> + * Earlier designs (pre-0.9) had a varying number of bits
> + * per mask value (MLEN). In the 0.9 design, MLEN=3D1.
> + * (Section 4.5)
> + */
> +static inline int vext_elem_mask(void *v0, int index)
> +{
> +    int idx =3D index / 64;
> +    int pos =3D index  % 64;
> +    return (((uint64_t *)v0)[idx] >> pos) & 1;
> +}
> +
> +/*
> + * Get number of total elements, including prestart, body and tail eleme=
nts.
> + * Note that when LMUL < 1, the tail includes the elements past VLMAX th=
at
> + * are held in the same vector register.
> + */
> +static inline uint32_t vext_get_total_elems(CPURISCVState *env, uint32_t=
 desc,
> +                                            uint32_t esz)
> +{
> +    uint32_t vlenb =3D simd_maxsz(desc);
> +    uint32_t sew =3D 1 << FIELD_EX64(env->vtype, VTYPE, VSEW);
> +    int8_t emul =3D ctzl(esz) - ctzl(sew) + vext_lmul(desc) < 0 ? 0 :
> +                  ctzl(esz) - ctzl(sew) + vext_lmul(desc);
> +    return (vlenb << emul) / esz;
> +}
> +
> +/* set agnostic elements to 1s */
> +void vext_set_elems_1s(void *base, uint32_t is_agnostic, uint32_t cnt,
> +                       uint32_t tot);
> +
> +/* expand macro args before macro */
> +#define RVVCALL(macro, ...)  macro(__VA_ARGS__)
> +
> +/* (TD, T1, T2, TX1, TX2) */
> +#define OP_UUU_B uint8_t, uint8_t, uint8_t, uint8_t, uint8_t
> +#define OP_UUU_H uint16_t, uint16_t, uint16_t, uint16_t, uint16_t
> +#define OP_UUU_W uint32_t, uint32_t, uint32_t, uint32_t, uint32_t
> +#define OP_UUU_D uint64_t, uint64_t, uint64_t, uint64_t, uint64_t
> +
> +/* operation of two vector elements */
> +typedef void opivv2_fn(void *vd, void *vs1, void *vs2, int i);
> +
> +#define OPIVV2(NAME, TD, T1, T2, TX1, TX2, HD, HS1, HS2, OP)    \
> +static void do_##NAME(void *vd, void *vs1, void *vs2, int i)    \
> +{                                                               \
> +    TX1 s1 =3D *((T1 *)vs1 + HS1(i));                             \
> +    TX2 s2 =3D *((T2 *)vs2 + HS2(i));                             \
> +    *((TD *)vd + HD(i)) =3D OP(s2, s1);                           \
> +}
> +
> +void do_vext_vv(void *vd, void *v0, void *vs1, void *vs2,
> +                CPURISCVState *env, uint32_t desc,
> +                opivv2_fn *fn, uint32_t esz);
> +
> +/* generate the helpers for OPIVV */
> +#define GEN_VEXT_VV(NAME, ESZ)                            \
> +void HELPER(NAME)(void *vd, void *v0, void *vs1,          \
> +                  void *vs2, CPURISCVState *env,          \
> +                  uint32_t desc)                          \
> +{                                                         \
> +    do_vext_vv(vd, v0, vs1, vs2, env, desc,               \
> +               do_##NAME, ESZ);                           \
> +}
> +
> +#endif /* TARGET_RISCV_VECTOR_INTERNALS_H */
> --
> 2.39.2
>
>
