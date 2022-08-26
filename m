Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D125A2159
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 09:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244864AbiHZHCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 03:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245082AbiHZHBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 03:01:42 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534CDC6CF0
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 00:01:41 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id i11so250405ual.7
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 00:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=V4bSpRziuje5o+7gdBCVWtLAAELBDhvrH2H1U3nqZI0=;
        b=OLtuuLmLpl344WRI7J+cur9nAxPQ7ZaKG8zx2VP90fd8A0epTRXOx1f8ZLfz6ZgSMy
         +MUz3i/eKpzHMzA85hg9LnbFbm5CakGmVhtDcaiHKZVempawzMZGNM1yCbG8fHI4I7GN
         j03sd3fbZZfaYKeluJUeWa806SbFcVxSpetBj7DSCaUl2o1Wbuv7Vw9B7xntDFkMDdqC
         h5awviYj0x2uz14vESodvepbYF/G9WeIm1FK9qqT090IN323DlWVR4K034MiHlkgTeiO
         mIvEDSkW+S7hVvr/EbCKJyPd008/gIAEzx8Pr/pANmT1ek7V5vPqYYbUgt4xNRS6aPJ/
         8iXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=V4bSpRziuje5o+7gdBCVWtLAAELBDhvrH2H1U3nqZI0=;
        b=7nCdFnmpI+WXh4QRc4BhGenbIuNnpVqS4SCDN5+sb0B+ewr0zEAUGQwlCAO0Lwo8J7
         6AEUtec8CWV4jpO+lQgvO2RvQ35kps2NV0qbQqAyO1Vhu2nujR/QvZ3oVCA54AjFN11o
         r6Kb0N22Fnvz30cfj0UYVJ+xmDjyM97gsVsYwsFTZs2e7ivnXSxteTkHu5uVflPb4uAz
         bC6sIeb6QgFddck/RM5X4bs7pm7pA1f8KhuAq09PJF/+L8Ccwv+rAaZGNuWWuwdLC/Um
         6L19r8C7ApfEdPy8Y6cCAeY3YMZa15dq3d6usjsZn6Xdsf9chhphmUSOfgNB2QgWbWYN
         TTdA==
X-Gm-Message-State: ACgBeo1O7EzHC2cSBV3G+AEkkf7kOSKnCI3SPSRoSoqRlhsoXh0kHDgr
        zZkcB9GsDqOYAIeh61xuKubgkS4f8/24tlL3whN/Ig==
X-Google-Smtp-Source: AA6agR4BwjdlteSPdMbRx7NYLnCpMTRac4VWfKVgj3SObmnB5WEsoRlGSLWKRdvYNYXmXw42ZxTEbU4vIn1707ikLW8=
X-Received: by 2002:ab0:154a:0:b0:39e:fee3:a65d with SMTP id
 p10-20020ab0154a000000b0039efee3a65dmr2738648uae.51.1661497300388; Fri, 26
 Aug 2022 00:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org> <20220805135813.2102034-8-maz@kernel.org>
In-Reply-To: <20220805135813.2102034-8-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 26 Aug 2022 00:01:24 -0700
Message-ID: <CAAeT=Fye1b3CbBxhzpD6V4L1qLwszWKARRDFtRom6QVTjb_OXA@mail.gmail.com>
Subject: Re: [PATCH 7/9] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to be
 set from userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Aug 5, 2022 at 6:58 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Allow userspace to write ID_AA64DFR0_EL1, on the condition that only
> the PMUver field can be altered and be at most the one that was
> initially computed for the guest.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 55451f49017c..c0595f31dab8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1236,6 +1236,38 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +                              const struct sys_reg_desc *rd,
> +                              u64 val)

The function prototype doesn't appear to be right as the
set_user of sys_reg_desc().
---
[From sys_regs.h]
[sys_regs.h]
        int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
                        const struct kvm_one_reg *reg, void __user *uaddr);
---

> +{
> +       u8 pmuver, host_pmuver;
> +
> +       host_pmuver = kvm_arm_pmu_get_host_pmuver();
> +
> +       /*
> +        * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
> +        * as it doesn't promise more than what the HW gives us. We
> +        * don't allow an IMPDEF PMU though.
> +        */
> +       pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), val);
> +       if (pmuver == ID_AA64DFR0_PMUVER_IMP_DEF || pmuver > host_pmuver)
> +               return -EINVAL;

As mentioned in my comments for the patch-6, the vCPU's PMUVER could
currently be IMP_DEF.  So, with this IMP_DEF checking, a guest with
IMP_DEF PMU cannot be migrated to a newer KVM host.
Do we need to tolerate writes of IMP_DEF for compatibility ?

Oliver originally point this out for my ID register series, and
my V6 or newer series tried to not return an error for this by
ignoring the user requested IMP_DEF when PMU is not enabled for
the vCPU (Instead, the field is set to 0x0).

 https://lore.kernel.org/all/20220419065544.3616948-16-reijiw@google.com/

Thank you,
Reiji

> +
> +       /* We already have a PMU, don't try to disable it... */
> +       if (kvm_vcpu_has_pmu(vcpu) && pmuver == 0)
> +               return -EINVAL;
> +
> +       /* We can only differ with PMUver, and anything else is an error */
> +       val ^= read_id_reg(vcpu, rd, false);
> +       val &= ~(0xFUL << ID_AA64DFR0_PMUVER_SHIFT);
> +       if (val)
> +               return -EINVAL;
> +
> +       vcpu->kvm->arch.dfr0_pmuver = pmuver;
> +
> +       return 0;
> +}
> +
>  /*
>   * cpufeature ID register user accessors
>   *
> @@ -1510,7 +1542,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         ID_UNALLOCATED(4,7),
>
>         /* CRm=5 */
> -       ID_SANITISED(ID_AA64DFR0_EL1),
> +       { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
> +         .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
>         ID_SANITISED(ID_AA64DFR1_EL1),
>         ID_UNALLOCATED(5,2),
>         ID_UNALLOCATED(5,3),
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
