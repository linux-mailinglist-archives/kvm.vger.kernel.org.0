Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F166F2288
	for <lists+kvm@lfdr.de>; Sat, 29 Apr 2023 04:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347194AbjD2C7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 22:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjD2C7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 22:59:22 -0400
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29BF92735
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 19:59:19 -0700 (PDT)
Received: from [192.168.0.120] (unknown [61.165.33.195])
        by APP-05 (Coremail) with SMTP id zQCowABnbc3fh0xkySJKGw--.41923S2;
        Sat, 29 Apr 2023 10:58:40 +0800 (CST)
Message-ID: <9b32863d-d446-16be-2b5e-cd1299ba539a@iscas.ac.cn>
Date:   Sat, 29 Apr 2023 10:58:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 04/19] target/riscv: Add Zvbc ISA extension support
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org,
        Max Chou <max.chou@sifive.com>, liweiwei@iscas.ac.cn
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
 <20230428144757.57530-5-lawrence.hunter@codethink.co.uk>
From:   Weiwei Li <liweiwei@iscas.ac.cn>
In-Reply-To: <20230428144757.57530-5-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowABnbc3fh0xkySJKGw--.41923S2
X-Coremail-Antispam: 1UD129KBjvJXoW3KF47ur4fJw4xAF18Wr1UAwb_yoWDuryfpF
        s5GrW7CrWDJFWxC3WSqF45JF4Uur45Cw1jkwsagwn5Z39xJrZ5XrsIk3y2kFWxJF97uw1j
        93WUuFy5Crs5taDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJV
        WxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr4
        1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
        67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
        8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
        wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUO_MaUUUUU
X-Originating-IP: [61.165.33.195]
X-CM-SenderInfo: 5olzvxxzhlqxpvfd2hldfou0/
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2023/4/28 22:47, Lawrence Hunter wrote:
> This commit adds support for the Zvbc vector-crypto extension, which
> consists of the following instructions:
>
> * vclmulh.[vx,vv]
> * vclmul.[vx,vv]
>
> Translation functions are defined in
> `target/riscv/insn_trans/trans_rvvk.c.inc` and helpers are defined in
> `target/riscv/vcrypto_helper.c`.
>
> Co-authored-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
> Co-authored-by: Max Chou <max.chou@sifive.com>
> Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
> Signed-off-by: Max Chou <max.chou@sifive.com>
> Signed-off-by: Lawrence Hunter <lawrence.hunter@codethink.co.uk>
> ---
>   target/riscv/cpu.c                       |  7 ++
>   target/riscv/cpu.h                       |  1 +
>   target/riscv/helper.h                    |  6 ++
>   target/riscv/insn32.decode               |  6 ++
>   target/riscv/insn_trans/trans_rvvk.c.inc | 88 ++++++++++++++++++++++++
>   target/riscv/meson.build                 |  3 +-
>   target/riscv/translate.c                 |  1 +
>   target/riscv/vcrypto_helper.c            | 59 ++++++++++++++++
>   8 files changed, 170 insertions(+), 1 deletion(-)
>   create mode 100644 target/riscv/insn_trans/trans_rvvk.c.inc
>   create mode 100644 target/riscv/vcrypto_helper.c
>
> diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
> index 1e97473af27..9f935d944db 100644
> --- a/target/riscv/cpu.c
> +++ b/target/riscv/cpu.c
> @@ -109,6 +109,7 @@ static const struct isa_ext_data isa_edata_arr[] = {
>       ISA_EXT_DATA_ENTRY(zve64d, true, PRIV_VERSION_1_12_0, ext_zve64d),
>       ISA_EXT_DATA_ENTRY(zvfh, true, PRIV_VERSION_1_12_0, ext_zvfh),
>       ISA_EXT_DATA_ENTRY(zvfhmin, true, PRIV_VERSION_1_12_0, ext_zvfhmin),
> +    ISA_EXT_DATA_ENTRY(zvbc, true, PRIV_VERSION_1_12_0, ext_zvbc),
>       ISA_EXT_DATA_ENTRY(zhinx, true, PRIV_VERSION_1_12_0, ext_zhinx),
>       ISA_EXT_DATA_ENTRY(zhinxmin, true, PRIV_VERSION_1_12_0, ext_zhinxmin),
>       ISA_EXT_DATA_ENTRY(smaia, true, PRIV_VERSION_1_12_0, ext_smaia),
> @@ -1211,6 +1212,12 @@ static void riscv_cpu_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> +    if (cpu->cfg.ext_zvbc &&
> +        !(cpu->cfg.ext_zve64f || cpu->cfg.ext_zve64d || cpu->cfg.ext_v)) {
> +        error_setg(errp, "Zvbc extension requires V or Zve64{f,d} extensions");
> +        return;
> +    }
> +
You can only check ext_zve64f here, since V depends on Zve64d and Zve64d 
depends on Zve64f.
>   #ifndef CONFIG_USER_ONLY
>       if (cpu->cfg.pmu_num) {
>           if (!riscv_pmu_init(cpu, cpu->cfg.pmu_num) && cpu->cfg.ext_sscofpmf) {
> diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
> index 638e47c75a5..d4915626110 100644
> --- a/target/riscv/cpu.h
> +++ b/target/riscv/cpu.h
> @@ -470,6 +470,7 @@ struct RISCVCPUConfig {
>       bool ext_zve32f;
>       bool ext_zve64f;
>       bool ext_zve64d;
> +    bool ext_zvbc;
>       bool ext_zmmul;
>       bool ext_zvfh;
>       bool ext_zvfhmin;
> diff --git a/target/riscv/helper.h b/target/riscv/helper.h
> index 37b54e09918..37f2e162f6a 100644
> --- a/target/riscv/helper.h
> +++ b/target/riscv/helper.h
> @@ -1142,3 +1142,9 @@ DEF_HELPER_FLAGS_1(aes64im, TCG_CALL_NO_RWG_SE, tl, tl)
>   
>   DEF_HELPER_FLAGS_3(sm4ed, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
>   DEF_HELPER_FLAGS_3(sm4ks, TCG_CALL_NO_RWG_SE, tl, tl, tl, tl)
> +
> +/* Vector crypto functions */
> +DEF_HELPER_6(vclmul_vv, void, ptr, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_6(vclmul_vx, void, ptr, ptr, tl, ptr, env, i32)
> +DEF_HELPER_6(vclmulh_vv, void, ptr, ptr, ptr, ptr, env, i32)
> +DEF_HELPER_6(vclmulh_vx, void, ptr, ptr, tl, ptr, env, i32)
> diff --git a/target/riscv/insn32.decode b/target/riscv/insn32.decode
> index 73d5d1b045b..52cd92e262e 100644
> --- a/target/riscv/insn32.decode
> +++ b/target/riscv/insn32.decode
> @@ -908,3 +908,9 @@ sm4ks       .. 11010 ..... ..... 000 ..... 0110011 @k_aes
>   # *** RV32 Zicond Standard Extension ***
>   czero_eqz   0000111  ..... ..... 101 ..... 0110011 @r
>   czero_nez   0000111  ..... ..... 111 ..... 0110011 @r
> +
> +# *** Zvbc vector crypto extension ***
> +vclmul_vv   001100 . ..... ..... 010 ..... 1010111 @r_vm
> +vclmul_vx   001100 . ..... ..... 110 ..... 1010111 @r_vm
> +vclmulh_vv  001101 . ..... ..... 010 ..... 1010111 @r_vm
> +vclmulh_vx  001101 . ..... ..... 110 ..... 1010111 @r_vm
> diff --git a/target/riscv/insn_trans/trans_rvvk.c.inc b/target/riscv/insn_trans/trans_rvvk.c.inc
> new file mode 100644
> index 00000000000..0dcf4d21305
> --- /dev/null
> +++ b/target/riscv/insn_trans/trans_rvvk.c.inc
> @@ -0,0 +1,88 @@
> +/*
> + * RISC-V translation routines for the vector crypto extension.
> + *
> + * Copyright (C) 2023 SiFive, Inc.
> + * Written by Codethink Ltd and SiFive.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2 or later, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +/*
> + * Zvbc
> + */
> +
> +#define GEN_VV_MASKED_TRANS(NAME, CHECK)                     \
> +    static bool trans_##NAME(DisasContext *s, arg_rmrr *a)   \
> +    {                                                        \
> +        if (CHECK(s, a)) {                                   \
> +            return opivv_trans(a->rd, a->rs1, a->rs2, a->vm, \
> +                               gen_helper_##NAME, s);        \
> +        }                                                    \
> +        return false;                                        \
> +    }
> +
> +static bool vclmul_vv_check(DisasContext *s, arg_rmrr *a)
> +{
> +    return opivv_check(s, a) &&
> +           s->cfg_ptr->ext_zvbc == true &&
> +           s->sew == MO_64;
> +}
> +
> +GEN_VV_MASKED_TRANS(vclmul_vv, vclmul_vv_check)
> +GEN_VV_MASKED_TRANS(vclmulh_vv, vclmul_vv_check)
> +
> +#define GEN_VX_MASKED_TRANS(NAME, CHECK)                                      \
> +    static bool trans_##NAME(DisasContext *s, arg_rmrr *a)                    \

Most of code of this function is similar to opivx_trans.   Maybe we can 
reuse it here.

Regards,

Weiwei Li

> +    {                                                                         \
> +        if (CHECK(s, a)) {                                                    \
> +            TCGv_ptr rd_v, v0_v, rs2_v;                                       \
> +            TCGv rs1;                                                         \
> +            TCGv_i32 desc;                                                    \
> +            uint32_t data = 0;                                                \
> +                                                                              \
> +            TCGLabel *over = gen_new_label();                                 \
> +            tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);        \
> +                                                                              \
> +            data = FIELD_DP32(data, VDATA, VM, a->vm);                        \
> +            data = FIELD_DP32(data, VDATA, LMUL, s->lmul);                    \
> +            data = FIELD_DP32(data, VDATA, VTA, s->vta);                      \
> +            data = FIELD_DP32(data, VDATA, VTA_ALL_1S, s->cfg_vta_all_1s);    \
> +            data = FIELD_DP32(data, VDATA, VMA, s->vma);                      \
> +                                                                              \
> +            rd_v = tcg_temp_new_ptr();                                        \
> +            v0_v = tcg_temp_new_ptr();                                        \
> +            rs1 = get_gpr(s, a->rs1, EXT_ZERO);                               \
> +            rs2_v = tcg_temp_new_ptr();                                       \
> +            desc = tcg_constant_i32(                                          \
> +                simd_desc(s->cfg_ptr->vlen / 8, s->cfg_ptr->vlen / 8, data)); \
> +            tcg_gen_addi_ptr(rd_v, cpu_env, vreg_ofs(s, a->rd));              \
> +            tcg_gen_addi_ptr(v0_v, cpu_env, vreg_ofs(s, 0));                  \
> +            tcg_gen_addi_ptr(rs2_v, cpu_env, vreg_ofs(s, a->rs2));            \
> +            gen_helper_##NAME(rd_v, v0_v, rs1, rs2_v, cpu_env, desc);         \
> +                                                                              \
> +            mark_vs_dirty(s);                                                 \
> +            gen_set_label(over);                                              \
> +            return true;                                                      \
> +        }                                                                     \
> +        return false;                                                         \
> +    }
> +
> +static bool vclmul_vx_check(DisasContext *s, arg_rmrr *a)
> +{
> +    return opivx_check(s, a) &&
> +           s->cfg_ptr->ext_zvbc == true &&
> +           s->sew == MO_64;
> +}
> +
> +GEN_VX_MASKED_TRANS(vclmul_vx, vclmul_vx_check)
> +GEN_VX_MASKED_TRANS(vclmulh_vx, vclmul_vx_check)
> diff --git a/target/riscv/meson.build b/target/riscv/meson.build
> index a94fc3f5982..52a61dd66eb 100644
> --- a/target/riscv/meson.build
> +++ b/target/riscv/meson.build
> @@ -20,7 +20,8 @@ riscv_ss.add(files(
>     'bitmanip_helper.c',
>     'translate.c',
>     'm128_helper.c',
> -  'crypto_helper.c'
> +  'crypto_helper.c',
> +  'vcrypto_helper.c'
>   ))
>   riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
>   
> diff --git a/target/riscv/translate.c b/target/riscv/translate.c
> index 0ee8ee147dd..518fdee5a90 100644
> --- a/target/riscv/translate.c
> +++ b/target/riscv/translate.c
> @@ -1083,6 +1083,7 @@ static uint32_t opcode_at(DisasContextBase *dcbase, target_ulong pc)
>   #include "insn_trans/trans_rvzicbo.c.inc"
>   #include "insn_trans/trans_rvzfh.c.inc"
>   #include "insn_trans/trans_rvk.c.inc"
> +#include "insn_trans/trans_rvvk.c.inc"
>   #include "insn_trans/trans_privileged.c.inc"
>   #include "insn_trans/trans_svinval.c.inc"
>   #include "decode-xthead.c.inc"
> diff --git a/target/riscv/vcrypto_helper.c b/target/riscv/vcrypto_helper.c
> new file mode 100644
> index 00000000000..8b7c63d4997
> --- /dev/null
> +++ b/target/riscv/vcrypto_helper.c
> @@ -0,0 +1,59 @@
> +/*
> + * RISC-V Vector Crypto Extension Helpers for QEMU.
> + *
> + * Copyright (C) 2023 SiFive, Inc.
> + * Written by Codethink Ltd and SiFive.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2 or later, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/host-utils.h"
> +#include "qemu/bitops.h"
> +#include "cpu.h"
> +#include "exec/memop.h"
> +#include "exec/exec-all.h"
> +#include "exec/helper-proto.h"
> +#include "internals.h"
> +#include "vector_internals.h"
> +
> +static uint64_t clmul64(uint64_t y, uint64_t x)
> +{
> +    uint64_t result = 0;
> +    for (int j = 63; j >= 0; j--) {
> +        if ((y >> j) & 1) {
> +            result ^= (x << j);
> +        }
> +    }
> +    return result;
> +}
> +
> +static uint64_t clmulh64(uint64_t y, uint64_t x)
> +{
> +    uint64_t result = 0;
> +    for (int j = 63; j >= 1; j--) {
> +        if ((y >> j) & 1) {
> +            result ^= (x >> (64 - j));
> +        }
> +    }
> +    return result;
> +}
> +
> +RVVCALL(OPIVV2, vclmul_vv, OP_UUU_D, H8, H8, H8, clmul64)
> +GEN_VEXT_VV(vclmul_vv, 8)
> +RVVCALL(OPIVX2, vclmul_vx, OP_UUU_D, H8, H8, clmul64)
> +GEN_VEXT_VX(vclmul_vx, 8)
> +RVVCALL(OPIVV2, vclmulh_vv, OP_UUU_D, H8, H8, H8, clmulh64)
> +GEN_VEXT_VV(vclmulh_vv, 8)
> +RVVCALL(OPIVX2, vclmulh_vx, OP_UUU_D, H8, H8, clmulh64)
> +GEN_VEXT_VX(vclmulh_vx, 8)

