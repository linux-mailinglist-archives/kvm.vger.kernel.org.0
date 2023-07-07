Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB34D74B096
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 14:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjGGMWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 08:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjGGMWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 08:22:32 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A487F1FE4
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 05:22:30 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6b72c4038b6so1673360a34.0
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 05:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688732550; x=1691324550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=41A/EdJS8c5KVDrJAQsS4FRcYX2qmleSBk89b6gBvKs=;
        b=LmemQ1st+CVTPPdoMNLdA78Ky3EyuNDwZMRi2wMhXMGYLiB4OHgcBBGhpV0ujMTsde
         QweWjq5Ce7jRN6UAKSxhp3T1lGGha7aCuIHZ7czKxI6Rf8w9LT0OqFJAJYZ4lqglh9h+
         hL0aCVVoMW0W37aK+sKSvOfNikRCNbSbP4WS6vDYk+b3GFAHpggZRfsjHzevRJmqKr9U
         cmnBtrg67jzs7sFl0WTgfrUh3kwogxlC/QGkrwABENHsiSAhVi+ZBuXh0fkGBAyqBSf8
         b+ymeOtt7THS4n7jJuSznt0Ltv42MRILJkYGj4aNUw9WE0+UydKrtIOGFwhq0cxngEqf
         Myww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688732550; x=1691324550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=41A/EdJS8c5KVDrJAQsS4FRcYX2qmleSBk89b6gBvKs=;
        b=XirKE0GjI7XDCR/oI29rVcSScozceMWuE6fGYx9DRy7hDSCCpOL61PaNfsnl25JGeI
         PSViYxjIJf+MRUDVix+2MnqyOKZzCMUT+mnnN8XYCccjK8t/EX4Y0XqaIAFDCwjthfTY
         82Pe+NerPbMPC4j/MQj2Zj0Pr1Gjoigd4JSnPulRdgJXwCTm1+8TAGU6e2V5fODt3/5f
         0cRt944GQk6+LKylK111JNj/xhSMVCWOq+nF2DQU6bZp3/zsqUT0AdT5o7DiqNGowtZD
         7P0TGI1dbpkgZPphgcgvz2TuC6Q0z4yWH41CuHLZ2Zy/uE9DpID0DvT8ZFu5gdWMYvzr
         Go6g==
X-Gm-Message-State: ABy/qLY6vEJDrXImem7X2HS48insFKKaoPnvo681EQ6Hl8ciIY9YNYzR
        l4jrp6t5XL1WMmKx3WGpWlo=
X-Google-Smtp-Source: APBJJlFn0+yrlXOq2XsBJOQ+tBt4g7BLGjeMXUMEkwuZkzJ8oS8PdWD0AjXF5ZpfqPKV6xRxAkdF5Q==
X-Received: by 2002:a05:6870:5610:b0:1b0:414f:3631 with SMTP id m16-20020a056870561000b001b0414f3631mr6445046oao.14.1688732549754;
        Fri, 07 Jul 2023 05:22:29 -0700 (PDT)
Received: from ?IPV6:2804:7f0:bcc0:bdf2:b7ba:a476:c0e3:fb59? ([2804:7f0:bcc0:bdf2:b7ba:a476:c0e3:fb59])
        by smtp.gmail.com with ESMTPSA id v7-20020a9d5a07000000b006b8a0c7e14asm1568188oth.55.2023.07.07.05.22.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jul 2023 05:22:29 -0700 (PDT)
Message-ID: <a5e358b3-be18-db69-9e61-cdaeaaf03de0@gmail.com>
Date:   Fri, 7 Jul 2023 09:22:25 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v6] ppc: Enable 2nd DAWR support on p10
To:     Greg Kurz <groug@kaod.org>
Cc:     Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        david@gibson.dropbear.id.au, clg@kaod.org, harshpb@linux.ibm.com,
        npiggin@gmail.com, pbonzini@redhat.com, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, ravi.bangoria@amd.com
References: <168871963321.58984.15628382614621248470.stgit@ltcd89-lp2>
 <b0047746-5b36-c39b-c669-055d08ca3164@gmail.com>
 <20230707135909.1b1a89d5@bahia>
Content-Language: en-US
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20230707135909.1b1a89d5@bahia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/7/23 08:59, Greg Kurz wrote:
> Hi Daniel and Shiva !
> 
> On Fri, 7 Jul 2023 08:09:47 -0300
> Daniel Henrique Barboza <danielhb413@gmail.com> wrote:
> 
>> This one was a buzzer shot.
>>
> 
> Indeed ! :-) I would have appreciated some more time to re-assess
> my R-b tag on this 2 year old bug though ;-)

My bad! I never thought it was that old. Never occured to me to check when
the previous version was sent.

Folks, please bear in mind that a Reviewed-by is given on the context when the
patch was sent. A handful of months? Keep the R-bs. 6 months, from one release
to the other? Things starts to get a little murky. 2 years? hahaha c'mon

At the very least you need to point out that the acks are old.


> 
> My concerns were that the DAWR1 spapr cap was still not enabled by
> default but I guess it is because POWER9 is still the default cpu
> type. Related, the apply function should probably spit a warning
> with TCG instead of failing, like already done for some other
> TCG limitations (e.g. cap_safe_bounds_check_apply()). This will
> be needed for `make test` to succeed when DAWR1 is eventually
> enabled by default. Not needed right now.
> 
> My R-b still stands then ! :-)

This patch got lucky then. If you/Cedric remove your acks I would simply drop the
patch and re-send the PR with the greatest of ease, no remorse whatsoever.


Thanks,

Daniel

> 
> Cheers,
> 
> --
> Greg
> 
>>
>> Queued in gitlab.com/danielhb/qemu/tree/ppc-next. Thanks,
>>
>>
>> Daniel
>>
>>
>> On 7/7/23 05:47, Shivaprasad G Bhat wrote:
>>> From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
>>>
>>> As per the PAPR, bit 0 of byte 64 in pa-features property
>>> indicates availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
>>> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to find
>>> whether kvm supports 2nd DAWR or not. If it's supported, allow user to set
>>> the pa-feature bit in guest DT using cap-dawr1 machine capability. Though,
>>> watchpoint on powerpc TCG guest is not supported and thus 2nd DAWR is not
>>> enabled for TCG mode.
>>>
>>> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
>>> Reviewed-by: Greg Kurz <groug@kaod.org>
>>> Reviewed-by: Cédric Le Goater <clg@kaod.org>
>>> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
>>> ---
>>> Changelog:
>>> v5: https://lore.kernel.org/all/20210412114433.129702-1-ravi.bangoria@linux.ibm.com/
>>> v5->v6:
>>>     - The other patches in the original series already merged.
>>>     - Rebased to the top of the tree. So, the gen_spr_book3s_310_dbg() is renamed
>>>       to register_book3s_310_dbg_sprs() and moved to cpu_init.c accordingly.
>>>     - No functional changes.
>>>
>>> v4: https://lore.kernel.org/r/20210406053833.282907-1-ravi.bangoria@linux.ibm.com
>>> v3->v4:
>>>     - Make error message more proper.
>>>
>>> v3: https://lore.kernel.org/r/20210330095350.36309-1-ravi.bangoria@linux.ibm.com
>>> v3->v4:
>>>     - spapr_dt_pa_features(): POWER10 processor is compatible with 3.0
>>>       (PCR_COMPAT_3_00). No need to ppc_check_compat(3_10) for now as
>>>       ppc_check_compati(3_00) will also be true. ppc_check_compat(3_10)
>>>       can be added while introducing pa_features_310 in future.
>>>     - Use error_append_hint() for hints. Also add ERRP_GUARD().
>>>     - Add kvmppc_set_cap_dawr1() stub function for CONFIG_KVM=n.
>>>
>>> v2: https://lore.kernel.org/r/20210329041906.213991-1-ravi.bangoria@linux.ibm.com
>>> v2->v3:
>>>     - Don't introduce pa_features_310[], instead, reuse pa_features_300[]
>>>       for 3.1 guests, as there is no difference between initial values of
>>>       them atm.
>>>     - Call gen_spr_book3s_310_dbg() from init_proc_POWER10() instead of
>>>       init_proc_POWER8(). Also, Don't call gen_spr_book3s_207_dbg() from
>>>       gen_spr_book3s_310_dbg() as init_proc_POWER10() already calls it.
>>>
>>> v1: https://lore.kernel.org/r/20200723104220.314671-1-ravi.bangoria@linux.ibm.com
>>> v1->v2:
>>>     - Introduce machine capability cap-dawr1 to enable/disable
>>>       the feature. By default, 2nd DAWR is OFF for guests even
>>>       when host kvm supports it. User has to manually enable it
>>>       with -machine cap-dawr1=on if he wishes to use it.
>>>     - Split the header file changes into separate patch. (Sync
>>>       headers from v5.12-rc3)
>>>
>>> [1] https://git.kernel.org/torvalds/c/bd1de1a0e6eff
>>>
>>>    hw/ppc/spapr.c         |    7 ++++++-
>>>    hw/ppc/spapr_caps.c    |   32 ++++++++++++++++++++++++++++++++
>>>    include/hw/ppc/spapr.h |    6 +++++-
>>>    target/ppc/cpu.h       |    2 ++
>>>    target/ppc/cpu_init.c  |   15 +++++++++++++++
>>>    target/ppc/kvm.c       |   12 ++++++++++++
>>>    target/ppc/kvm_ppc.h   |   12 ++++++++++++
>>>    7 files changed, 84 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
>>> index 54dbfd7fe9..1e54e0c719 100644
>>> --- a/hw/ppc/spapr.c
>>> +++ b/hw/ppc/spapr.c
>>> @@ -241,7 +241,7 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>>>            0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
>>>            /* 54: DecFP, 56: DecI, 58: SHA */
>>>            0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
>>> -        /* 60: NM atomic, 62: RNG */
>>> +        /* 60: NM atomic, 62: RNG, 64: DAWR1 (ISA 3.1) */
>>>            0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
>>>        };
>>>        uint8_t *pa_features = NULL;
>>> @@ -282,6 +282,9 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>>>             * in pa-features. So hide it from them. */
>>>            pa_features[40 + 2] &= ~0x80; /* Radix MMU */
>>>        }
>>> +    if (spapr_get_cap(spapr, SPAPR_CAP_DAWR1)) {
>>> +        pa_features[66] |= 0x80;
>>> +    }
>>>
>>>        _FDT((fdt_setprop(fdt, offset, "ibm,pa-features", pa_features, pa_size)));
>>>    }
>>> @@ -2084,6 +2087,7 @@ static const VMStateDescription vmstate_spapr = {
>>>            &vmstate_spapr_cap_fwnmi,
>>>            &vmstate_spapr_fwnmi,
>>>            &vmstate_spapr_cap_rpt_invalidate,
>>> +        &vmstate_spapr_cap_dawr1,
>>>            NULL
>>>        }
>>>    };
>>> @@ -4683,6 +4687,7 @@ static void spapr_machine_class_init(ObjectClass *oc, void *data)
>>>        smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] = SPAPR_CAP_ON;
>>>        smc->default_caps.caps[SPAPR_CAP_FWNMI] = SPAPR_CAP_ON;
>>>        smc->default_caps.caps[SPAPR_CAP_RPT_INVALIDATE] = SPAPR_CAP_OFF;
>>> +    smc->default_caps.caps[SPAPR_CAP_DAWR1] = SPAPR_CAP_OFF;
>>>
>>>        /*
>>>         * This cap specifies whether the AIL 3 mode for
>>> diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
>>> index 5a0755d34f..2f2cf4a250 100644
>>> --- a/hw/ppc/spapr_caps.c
>>> +++ b/hw/ppc/spapr_caps.c
>>> @@ -655,6 +655,28 @@ static void cap_ail_mode_3_apply(SpaprMachineState *spapr,
>>>        }
>>>    }
>>>
>>> +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
>>> +                               Error **errp)
>>> +{
>>> +    ERRP_GUARD();
>>> +    if (!val) {
>>> +        return; /* Disable by default */
>>> +    }
>>> +
>>> +    if (tcg_enabled()) {
>>> +        error_setg(errp, "DAWR1 not supported in TCG.");
>>> +        error_append_hint(errp, "Try appending -machine cap-dawr1=off\n");
>>> +    } else if (kvm_enabled()) {
>>> +        if (!kvmppc_has_cap_dawr1()) {
>>> +            error_setg(errp, "DAWR1 not supported by KVM.");
>>> +            error_append_hint(errp, "Try appending -machine cap-dawr1=off\n");
>>> +        } else if (kvmppc_set_cap_dawr1(val) < 0) {
>>> +            error_setg(errp, "Error enabling cap-dawr1 with KVM.");
>>> +            error_append_hint(errp, "Try appending -machine cap-dawr1=off\n");
>>> +        }
>>> +    }
>>> +}
>>> +
>>>    SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
>>>        [SPAPR_CAP_HTM] = {
>>>            .name = "htm",
>>> @@ -781,6 +803,15 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
>>>            .type = "bool",
>>>            .apply = cap_ail_mode_3_apply,
>>>        },
>>> +    [SPAPR_CAP_DAWR1] = {
>>> +        .name = "dawr1",
>>> +        .description = "Allow 2nd Data Address Watchpoint Register (DAWR1)",
>>> +        .index = SPAPR_CAP_DAWR1,
>>> +        .get = spapr_cap_get_bool,
>>> +        .set = spapr_cap_set_bool,
>>> +        .type = "bool",
>>> +        .apply = cap_dawr1_apply,
>>> +    },
>>>    };
>>>
>>>    static SpaprCapabilities default_caps_with_cpu(SpaprMachineState *spapr,
>>> @@ -923,6 +954,7 @@ SPAPR_CAP_MIG_STATE(large_decr, SPAPR_CAP_LARGE_DECREMENTER);
>>>    SPAPR_CAP_MIG_STATE(ccf_assist, SPAPR_CAP_CCF_ASSIST);
>>>    SPAPR_CAP_MIG_STATE(fwnmi, SPAPR_CAP_FWNMI);
>>>    SPAPR_CAP_MIG_STATE(rpt_invalidate, SPAPR_CAP_RPT_INVALIDATE);
>>> +SPAPR_CAP_MIG_STATE(dawr1, SPAPR_CAP_DAWR1);
>>>
>>>    void spapr_caps_init(SpaprMachineState *spapr)
>>>    {
>>> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
>>> index 538b2dfb89..47fffb921a 100644
>>> --- a/include/hw/ppc/spapr.h
>>> +++ b/include/hw/ppc/spapr.h
>>> @@ -80,8 +80,10 @@ typedef enum {
>>>    #define SPAPR_CAP_RPT_INVALIDATE        0x0B
>>>    /* Support for AIL modes */
>>>    #define SPAPR_CAP_AIL_MODE_3            0x0C
>>> +/* DAWR1 */
>>> +#define SPAPR_CAP_DAWR1                 0x0D
>>>    /* Num Caps */
>>> -#define SPAPR_CAP_NUM                   (SPAPR_CAP_AIL_MODE_3 + 1)
>>> +#define SPAPR_CAP_NUM                   (SPAPR_CAP_DAWR1 + 1)
>>>
>>>    /*
>>>     * Capability Values
>>> @@ -407,6 +409,7 @@ struct SpaprMachineState {
>>>    #define H_SET_MODE_RESOURCE_SET_DAWR0           2
>>>    #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
>>>    #define H_SET_MODE_RESOURCE_LE                  4
>>> +#define H_SET_MODE_RESOURCE_SET_DAWR1           5
>>>
>>>    /* Flags for H_SET_MODE_RESOURCE_LE */
>>>    #define H_SET_MODE_ENDIAN_BIG    0
>>> @@ -990,6 +993,7 @@ extern const VMStateDescription vmstate_spapr_cap_ccf_assist;
>>>    extern const VMStateDescription vmstate_spapr_cap_fwnmi;
>>>    extern const VMStateDescription vmstate_spapr_cap_rpt_invalidate;
>>>    extern const VMStateDescription vmstate_spapr_wdt;
>>> +extern const VMStateDescription vmstate_spapr_cap_dawr1;
>>>
>>>    static inline uint8_t spapr_get_cap(SpaprMachineState *spapr, int cap)
>>>    {
>>> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
>>> index af12c93ebc..64855935f7 100644
>>> --- a/target/ppc/cpu.h
>>> +++ b/target/ppc/cpu.h
>>> @@ -1588,9 +1588,11 @@ void ppc_compat_add_property(Object *obj, const char *name,
>>>    #define SPR_PSPB              (0x09F)
>>>    #define SPR_DPDES             (0x0B0)
>>>    #define SPR_DAWR0             (0x0B4)
>>> +#define SPR_DAWR1             (0x0B5)
>>>    #define SPR_RPR               (0x0BA)
>>>    #define SPR_CIABR             (0x0BB)
>>>    #define SPR_DAWRX0            (0x0BC)
>>> +#define SPR_DAWRX1            (0x0BD)
>>>    #define SPR_HFSCR             (0x0BE)
>>>    #define SPR_VRSAVE            (0x100)
>>>    #define SPR_USPRG0            (0x100)
>>> diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
>>> index aeff71d063..c688e52928 100644
>>> --- a/target/ppc/cpu_init.c
>>> +++ b/target/ppc/cpu_init.c
>>> @@ -5131,6 +5131,20 @@ static void register_book3s_207_dbg_sprs(CPUPPCState *env)
>>>                            KVM_REG_PPC_CIABR, 0x00000000);
>>>    }
>>>
>>> +static void register_book3s_310_dbg_sprs(CPUPPCState *env)
>>> +{
>>> +    spr_register_kvm_hv(env, SPR_DAWR1, "DAWR1",
>>> +                        SPR_NOACCESS, SPR_NOACCESS,
>>> +                        SPR_NOACCESS, SPR_NOACCESS,
>>> +                        &spr_read_generic, &spr_write_generic,
>>> +                        KVM_REG_PPC_DAWR1, 0x00000000);
>>> +    spr_register_kvm_hv(env, SPR_DAWRX1, "DAWRX1",
>>> +                        SPR_NOACCESS, SPR_NOACCESS,
>>> +                        SPR_NOACCESS, SPR_NOACCESS,
>>> +                        &spr_read_generic, &spr_write_generic32,
>>> +                        KVM_REG_PPC_DAWRX1, 0x00000000);
>>> +}
>>> +
>>>    static void register_970_dbg_sprs(CPUPPCState *env)
>>>    {
>>>        /* Breakpoints */
>>> @@ -6435,6 +6449,7 @@ static void init_proc_POWER10(CPUPPCState *env)
>>>        /* Common Registers */
>>>        init_proc_book3s_common(env);
>>>        register_book3s_207_dbg_sprs(env);
>>> +    register_book3s_310_dbg_sprs(env);
>>>
>>>        /* Common TCG PMU */
>>>        init_tcg_pmu_power8(env);
>>> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
>>> index a8a935e267..05f68d2d91 100644
>>> --- a/target/ppc/kvm.c
>>> +++ b/target/ppc/kvm.c
>>> @@ -89,6 +89,7 @@ static int cap_large_decr;
>>>    static int cap_fwnmi;
>>>    static int cap_rpt_invalidate;
>>>    static int cap_ail_mode_3;
>>> +static int cap_dawr1;
>>>
>>>    static uint32_t debug_inst_opcode;
>>>
>>> @@ -138,6 +139,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>        cap_ppc_nested_kvm_hv = kvm_vm_check_extension(s, KVM_CAP_PPC_NESTED_HV);
>>>        cap_large_decr = kvmppc_get_dec_bits();
>>>        cap_fwnmi = kvm_vm_check_extension(s, KVM_CAP_PPC_FWNMI);
>>> +    cap_dawr1 = kvm_vm_check_extension(s, KVM_CAP_PPC_DAWR1);
>>>        /*
>>>         * Note: setting it to false because there is not such capability
>>>         * in KVM at this moment.
>>> @@ -2109,6 +2111,16 @@ int kvmppc_set_fwnmi(PowerPCCPU *cpu)
>>>        return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
>>>    }
>>>
>>> +bool kvmppc_has_cap_dawr1(void)
>>> +{
>>> +    return !!cap_dawr1;
>>> +}
>>> +
>>> +int kvmppc_set_cap_dawr1(int enable)
>>> +{
>>> +    return kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_DAWR1, 0, enable);
>>> +}
>>> +
>>>    int kvmppc_smt_threads(void)
>>>    {
>>>        return cap_ppc_smt ? cap_ppc_smt : 1;
>>> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
>>> index 611debc3ce..584916a6d1 100644
>>> --- a/target/ppc/kvm_ppc.h
>>> +++ b/target/ppc/kvm_ppc.h
>>> @@ -67,6 +67,8 @@ bool kvmppc_has_cap_htm(void);
>>>    bool kvmppc_has_cap_mmu_radix(void);
>>>    bool kvmppc_has_cap_mmu_hash_v3(void);
>>>    bool kvmppc_has_cap_xive(void);
>>> +bool kvmppc_has_cap_dawr1(void);
>>> +int kvmppc_set_cap_dawr1(int enable);
>>>    int kvmppc_get_cap_safe_cache(void);
>>>    int kvmppc_get_cap_safe_bounds_check(void);
>>>    int kvmppc_get_cap_safe_indirect_branch(void);
>>> @@ -352,6 +354,16 @@ static inline bool kvmppc_has_cap_xive(void)
>>>        return false;
>>>    }
>>>
>>> +static inline bool kvmppc_has_cap_dawr1(void)
>>> +{
>>> +    return false;
>>> +}
>>> +
>>> +static inline int kvmppc_set_cap_dawr1(int enable)
>>> +{
>>> +    abort();
>>> +}
>>> +
>>>    static inline int kvmppc_get_cap_safe_cache(void)
>>>    {
>>>        return 0;
>>>
>>>
> 
> 
> 
