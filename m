Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B29B6E5779
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 04:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjDRCZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 22:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjDRCZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 22:25:54 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159ADE71
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 19:25:53 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id q10so4636017uas.2
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 19:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681784752; x=1684376752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRz2vYMowRDgjT6RimOcd4wh2p5yRkq7Sh0siGa5SBw=;
        b=TsrHj3BdWTCQ7C+lkNBsHPg8hd+oAw00LeJHzNTJV4PDZRl6XSLT3Uifp6RQPKc388
         B5t3qZvqjUXgHiFLtc1//DxJ5U9108V9KF5x6sC04rEEKadO10WU89kYBep47wN9JoIk
         fM1T7+sRiWdCfrGn1dqgs/VYa/TBdzD3TXFE7mati39It7rdFS8pSG4AJlQqijohXeqk
         lJNm1MFi8NSCEdGk+YwLw7G1VQvivsctQw97IDD8hso8XGdf/2fZEkuy0QegiUYEfvXJ
         yX1gcuPN1GMKYVfgkUHr1QlYhQ6tmtgwWPUL7tx7XvDqdkCRy6Tl93jFl//FFICnjqao
         lVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681784752; x=1684376752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xRz2vYMowRDgjT6RimOcd4wh2p5yRkq7Sh0siGa5SBw=;
        b=k2bb0nde1QmitlsCt8Km9e126ZCL6Dp8Bi3Y7H346zcB9no8aeeh4LOwnDVM1Z0cpR
         BB+/EnPzgewvOLZMC8oXU1bg5k9IE3zDLpfmNuOIzLVJG0VjfU+FBlsplR9rybDb7K5w
         0YdxU8iPAP5bJj4Pv5L1Jk79hvCpNIwCjZy/8hf0pilXI8053RIWssvqwtAhcTI0cOzU
         9zgLD95OSNpW6yqNRRkhy9j03hR/w2e0frVftcnzu2PPYAxWt8aTccUIFcD4zA651Hg/
         LV69uko331VnYD+IDoSK7kwemU8cBQ0uic267SrwTv4pzWrbcp6n+VCrE/v+H7uJq6O6
         7Y6Q==
X-Gm-Message-State: AAQBX9c6KAAwPcOGBWUrWVRFhcKxhpgyE/4IKLTKsd0FfAifGMAvDh+V
        BYOY4pN6bGoVo3GFE0+x7Lrt+NzQBQX0rQTYp5Q=
X-Google-Smtp-Source: AKy350YhJ77w0AdtI7jhG1i02j6dfJC/k6EAlQMi+EyRM/vGouudL3KpymygWAdE1Cmog9TBSDD8T4f9HRj30EiXpBM=
X-Received: by 2002:a1f:4387:0:b0:440:50c4:3e13 with SMTP id
 q129-20020a1f4387000000b0044050c43e13mr4660205vka.5.1681784752133; Mon, 17
 Apr 2023 19:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk> <20230417135821.609964-3-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230417135821.609964-3-lawrence.hunter@codethink.co.uk>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 18 Apr 2023 12:25:26 +1000
Message-ID: <CAKmqyKP1akoCLyp-O3wt=Y8sZaiROzxRY2Aq9ierK+nnnzsrYg@mail.gmail.com>
Subject: Re: [PATCH v2 02/17] target/riscv: Refactor vector-vector translation macro
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Cc:     qemu-devel@nongnu.org, dickon.hood@codethink.co.uk,
        nazar.kazakov@codethink.co.uk, kiran.ostrolenk@codethink.co.uk,
        frank.chang@sifive.com, palmer@dabbelt.com,
        alistair.francis@wdc.com, bin.meng@windriver.com,
        pbonzini@redhat.com, philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023 at 12:01=E2=80=AFAM Lawrence Hunter
<lawrence.hunter@codethink.co.uk> wrote:
>
> From: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>
>
> Factor the non SEW-specific stuff out of `GEN_OPIVV_TRANS` into
> function `opivv_trans` (similar to `opivi_trans`). `opivv_trans` will be
> used in proceeding vector-crypto commits.
>
> Signed-off-by: Kiran Ostrolenk <kiran.ostrolenk@codethink.co.uk>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  target/riscv/insn_trans/trans_rvv.c.inc | 62 +++++++++++++------------
>  1 file changed, 32 insertions(+), 30 deletions(-)
>
> diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_=
trans/trans_rvv.c.inc
> index f2e3d385152..4106bd69949 100644
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
> --
> 2.40.0
>
>
