Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14786F226D
	for <lists+kvm@lfdr.de>; Sat, 29 Apr 2023 04:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346852AbjD2ChP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 22:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346837AbjD2ChO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 22:37:14 -0400
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A20C2696
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 19:37:11 -0700 (PDT)
Received: from [192.168.0.120] (unknown [61.165.33.195])
        by APP-05 (Coremail) with SMTP id zQCowAAH+BSrgkxksSpIGw--.1032S2;
        Sat, 29 Apr 2023 10:36:28 +0800 (CST)
Message-ID: <a707768f-e8f2-5412-0f7e-0038f29f92be@iscas.ac.cn>
Date:   Sat, 29 Apr 2023 10:36:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 03/19] target/riscv: Remove redundant "cpu_vl == 0"
 checks
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org, richard.henderson@linaro.org,
        liweiwei@iscas.ac.cn
References: <20230428144757.57530-1-lawrence.hunter@codethink.co.uk>
 <20230428144757.57530-4-lawrence.hunter@codethink.co.uk>
From:   Weiwei Li <liweiwei@iscas.ac.cn>
In-Reply-To: <20230428144757.57530-4-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: zQCowAAH+BSrgkxksSpIGw--.1032S2
X-Coremail-Antispam: 1UD129KBjvJXoW3KrWDtF1rtF4DXw48WFW7Jwb_yoWDZr4fpr
        17tr4fZ39rGas5J34vqw45Ar4SvF40kr409wnIyr4rGrW8Jr4DJr1UGw4Fgr1IvFWfXrW2
        ya17ZFW2ganxWaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJV
        WxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr4
        1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
        67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
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
> From: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
>
> Remove the redundant "vl == 0" check which is already included within the  vstart >= vl check, when vl == 0.
>
> Signed-off-by: Nazar Kazakov <nazar.kazakov@codethink.co.uk>
> ---
Reviewed-by: Weiwei Li <liweiwei@iscas.ac.cn>

Weiwei Li
>   target/riscv/insn_trans/trans_rvv.c.inc | 31 +------------------------
>   1 file changed, 1 insertion(+), 30 deletions(-)
>
> diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
> index 4106bd69949..2660dda42be 100644
> --- a/target/riscv/insn_trans/trans_rvv.c.inc
> +++ b/target/riscv/insn_trans/trans_rvv.c.inc
> @@ -617,7 +617,6 @@ static bool ldst_us_trans(uint32_t vd, uint32_t rs1, uint32_t data,
>       TCGv_i32 desc;
>   
>       TCGLabel *over = gen_new_label();
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       dest = tcg_temp_new_ptr();
> @@ -786,7 +785,6 @@ static bool ldst_stride_trans(uint32_t vd, uint32_t rs1, uint32_t rs2,
>       TCGv_i32 desc;
>   
>       TCGLabel *over = gen_new_label();
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       dest = tcg_temp_new_ptr();
> @@ -893,7 +891,6 @@ static bool ldst_index_trans(uint32_t vd, uint32_t rs1, uint32_t vs2,
>       TCGv_i32 desc;
>   
>       TCGLabel *over = gen_new_label();
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       dest = tcg_temp_new_ptr();
> @@ -1034,7 +1031,6 @@ static bool ldff_trans(uint32_t vd, uint32_t rs1, uint32_t data,
>       TCGv_i32 desc;
>   
>       TCGLabel *over = gen_new_label();
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       dest = tcg_temp_new_ptr();
> @@ -1191,7 +1187,6 @@ do_opivv_gvec(DisasContext *s, arg_rmrr *a, GVecGen3Fn *gvec_fn,
>           return false;
>       }
>   
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       if (a->vm && s->vl_eq_vlmax && !(s->vta && s->lmul < 0)) {
> @@ -1241,7 +1236,6 @@ static bool opivx_trans(uint32_t vd, uint32_t rs1, uint32_t vs2, uint32_t vm,
>       uint32_t data = 0;
>   
>       TCGLabel *over = gen_new_label();
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       dest = tcg_temp_new_ptr();
> @@ -1405,7 +1399,6 @@ static bool opivi_trans(uint32_t vd, uint32_t imm, uint32_t vs2, uint32_t vm,
>       uint32_t data = 0;
>   
>       TCGLabel *over = gen_new_label();
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       dest = tcg_temp_new_ptr();
> @@ -1492,7 +1485,6 @@ static bool do_opivv_widen(DisasContext *s, arg_rmrr *a,
>       if (checkfn(s, a)) {
>           uint32_t data = 0;
>           TCGLabel *over = gen_new_label();
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>           data = FIELD_DP32(data, VDATA, VM, a->vm);
> @@ -1575,7 +1567,6 @@ static bool do_opiwv_widen(DisasContext *s, arg_rmrr *a,
>       if (opiwv_widen_check(s, a)) {
>           uint32_t data = 0;
>           TCGLabel *over = gen_new_label();
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>           data = FIELD_DP32(data, VDATA, VM, a->vm);
> @@ -1648,7 +1639,6 @@ static bool opivv_trans(uint32_t vd, uint32_t vs1, uint32_t vs2, uint32_t vm,
>   {
>       uint32_t data = 0;
>       TCGLabel *over = gen_new_label();
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       data = FIELD_DP32(data, VDATA, VM, vm);
> @@ -1842,7 +1832,6 @@ static bool trans_##NAME(DisasContext *s, arg_rmrr *a)             \
>               gen_helper_##NAME##_w,                                 \
>           };                                                         \
>           TCGLabel *over = gen_new_label();                          \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
>                                                                      \
>           data = FIELD_DP32(data, VDATA, VM, a->vm);                 \
> @@ -2054,7 +2043,6 @@ static bool trans_vmv_v_v(DisasContext *s, arg_vmv_v_v *a)
>                   gen_helper_vmv_v_v_w, gen_helper_vmv_v_v_d,
>               };
>               TCGLabel *over = gen_new_label();
> -            tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>               tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>               tcg_gen_gvec_2_ptr(vreg_ofs(s, a->rd), vreg_ofs(s, a->rs1),
> @@ -2078,7 +2066,6 @@ static bool trans_vmv_v_x(DisasContext *s, arg_vmv_v_x *a)
>           vext_check_ss(s, a->rd, 0, 1)) {
>           TCGv s1;
>           TCGLabel *over = gen_new_label();
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>           s1 = get_gpr(s, a->rs1, EXT_SIGN);
> @@ -2140,7 +2127,6 @@ static bool trans_vmv_v_i(DisasContext *s, arg_vmv_v_i *a)
>                   gen_helper_vmv_v_x_w, gen_helper_vmv_v_x_d,
>               };
>               TCGLabel *over = gen_new_label();
> -            tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>               tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>               s1 = tcg_constant_i64(simm);
> @@ -2288,7 +2274,6 @@ static bool trans_##NAME(DisasContext *s, arg_rmrr *a)             \
>           };                                                         \
>           TCGLabel *over = gen_new_label();                          \
>           gen_set_rm(s, RISCV_FRM_DYN);                              \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
>                                                                      \
>           data = FIELD_DP32(data, VDATA, VM, a->vm);                 \
> @@ -2323,7 +2308,6 @@ static bool opfvf_trans(uint32_t vd, uint32_t rs1, uint32_t vs2,
>       TCGv_i64 t1;
>   
>       TCGLabel *over = gen_new_label();
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       dest = tcg_temp_new_ptr();
> @@ -2408,7 +2392,6 @@ static bool trans_##NAME(DisasContext *s, arg_rmrr *a)           \
>           };                                                       \
>           TCGLabel *over = gen_new_label();                        \
>           gen_set_rm(s, RISCV_FRM_DYN);                            \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);        \
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);\
>                                                                    \
>           data = FIELD_DP32(data, VDATA, VM, a->vm);               \
> @@ -2483,7 +2466,6 @@ static bool trans_##NAME(DisasContext *s, arg_rmrr *a)             \
>           };                                                         \
>           TCGLabel *over = gen_new_label();                          \
>           gen_set_rm(s, RISCV_FRM_DYN);                              \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
>                                                                      \
>           data = FIELD_DP32(data, VDATA, VM, a->vm);                 \
> @@ -2601,7 +2583,6 @@ static bool do_opfv(DisasContext *s, arg_rmr *a,
>           uint32_t data = 0;
>           TCGLabel *over = gen_new_label();
>           gen_set_rm_chkfrm(s, rm);
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>           data = FIELD_DP32(data, VDATA, VM, a->vm);
> @@ -2713,7 +2694,6 @@ static bool trans_vfmv_v_f(DisasContext *s, arg_vfmv_v_f *a)
>                   gen_helper_vmv_v_x_d,
>               };
>               TCGLabel *over = gen_new_label();
> -            tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>               tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>               t1 = tcg_temp_new_i64();
> @@ -2792,7 +2772,6 @@ static bool trans_##NAME(DisasContext *s, arg_rmr *a)              \
>           };                                                         \
>           TCGLabel *over = gen_new_label();                          \
>           gen_set_rm_chkfrm(s, FRM);                                 \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
>                                                                      \
>           data = FIELD_DP32(data, VDATA, VM, a->vm);                 \
> @@ -2844,7 +2823,6 @@ static bool trans_##NAME(DisasContext *s, arg_rmr *a)              \
>           };                                                         \
>           TCGLabel *over = gen_new_label();                          \
>           gen_set_rm(s, RISCV_FRM_DYN);                              \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
>                                                                      \
>           data = FIELD_DP32(data, VDATA, VM, a->vm);                 \
> @@ -2912,7 +2890,6 @@ static bool trans_##NAME(DisasContext *s, arg_rmr *a)              \
>           };                                                         \
>           TCGLabel *over = gen_new_label();                          \
>           gen_set_rm_chkfrm(s, FRM);                                 \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
>                                                                      \
>           data = FIELD_DP32(data, VDATA, VM, a->vm);                 \
> @@ -2962,7 +2939,6 @@ static bool trans_##NAME(DisasContext *s, arg_rmr *a)              \
>           };                                                         \
>           TCGLabel *over = gen_new_label();                          \
>           gen_set_rm_chkfrm(s, FRM);                                 \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
>                                                                      \
>           data = FIELD_DP32(data, VDATA, VM, a->vm);                 \
> @@ -3053,7 +3029,6 @@ static bool trans_##NAME(DisasContext *s, arg_r *a)                \
>           uint32_t data = 0;                                         \
>           gen_helper_gvec_4_ptr *fn = gen_helper_##NAME;             \
>           TCGLabel *over = gen_new_label();                          \
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);          \
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over); \
>                                                                      \
>           data = FIELD_DP32(data, VDATA, LMUL, s->lmul);             \
> @@ -3222,7 +3197,6 @@ static bool trans_vid_v(DisasContext *s, arg_vid_v *a)
>           require_vm(a->vm, a->rd)) {
>           uint32_t data = 0;
>           TCGLabel *over = gen_new_label();
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>           data = FIELD_DP32(data, VDATA, VM, a->vm);
> @@ -3409,7 +3383,6 @@ static bool trans_vmv_s_x(DisasContext *s, arg_vmv_s_x *a)
>           TCGv s1;
>           TCGLabel *over = gen_new_label();
>   
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>           t1 = tcg_temp_new_i64();
> @@ -3466,8 +3439,7 @@ static bool trans_vfmv_s_f(DisasContext *s, arg_vfmv_s_f *a)
>           TCGv_i64 t1;
>           TCGLabel *over = gen_new_label();
>   
> -        /* if vl == 0 or vstart >= vl, skip vector register write back */
> -        tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
> +        /* if vstart >= vl, skip vector register write back */
>           tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>           /* NaN-box f[rs1] */
> @@ -3718,7 +3690,6 @@ static bool int_ext_op(DisasContext *s, arg_rmr *a, uint8_t seq)
>       uint32_t data = 0;
>       gen_helper_gvec_3_ptr *fn;
>       TCGLabel *over = gen_new_label();
> -    tcg_gen_brcondi_tl(TCG_COND_EQ, cpu_vl, 0, over);
>       tcg_gen_brcond_tl(TCG_COND_GEU, cpu_vstart, cpu_vl, over);
>   
>       static gen_helper_gvec_3_ptr * const fns[6][4] = {

