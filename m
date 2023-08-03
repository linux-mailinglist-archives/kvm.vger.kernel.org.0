Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE9876F63D
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 01:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjHCXnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 19:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjHCXnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 19:43:02 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1078B1716
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 16:43:01 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1bb5c259b44so1129323fac.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 16:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691106180; x=1691710980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6XhTATf7/1RB+zplPqP6wYl1J1IWawU9DRK/kARaQxY=;
        b=nSuC/+XSqdQ1YanUgq545MskEaAHukgNoBOlmSZVKmod6vOZDdpipaKGH268pE5Fal
         hfaRb5vRY1a8Tmidm5evHBN+kkH9Dh+LN/VZ9AWnUOjUcN0RxVPMJbzYZZR2cPrykgC6
         f+pMZW3M5xY6ba4f21UTDj3Oq6s+bh1FdT7zJXGDVDHAESQ8ob85OguaaXq3PODLog/P
         lnQEyTD/a4poZLFBlgDiGwdIJ2H458aoQg+V8dJLpLpNTioQfMNKQtW7yJ1dI+i8wiyj
         KGGd8DunZkccZ3YgDVPhKwqWuYLiTklfkK8843SfPL6ZjyRvbd2q/x9T++8krCCTIqh/
         6ujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691106180; x=1691710980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6XhTATf7/1RB+zplPqP6wYl1J1IWawU9DRK/kARaQxY=;
        b=F3ZQlh411SQKLNVKDFzky0/bvi5/AoE0rVK/DVVUqQASoW96QggdP0w34GAO8zwJFa
         +g0ToZzb0KJ07QY1C5v2KsXf0h1RWPDThOA4fhXxiEpmAMu6bUn260fEcLW3c6uIr1HL
         cBlaXO4Deg5oVfBIfosCVXwuZS06Ijkgl8qBamcL/m7rH+JqLQgaXlNEtaJV7KOEvzy0
         sTMXsj6lEAm4mkb02qMs6RdQTYUYM7u4W/TxHCdz3JjqlEpVUbncb+XWkB/fsLt67Dtd
         Zn8/TDFXB9Dd8K7vssRf2P1yF6Jf3O4NjdvtHfycLXiWOVl9qAmsOVwxm+HNxTWbLAxt
         MvkA==
X-Gm-Message-State: AOJu0YxxT1X26DTj47MFwKVq7xNhCl7XvoyFsXNfruDaIDGPbFI9mFyD
        vNBJGErE/nw6KZTPwVVaH7+VH+zAk6zjUT/CgiB1Tw==
X-Google-Smtp-Source: AGHT+IGiNFCs933FN6xk1z8jcKeMJbMUb7tAjiA7cZo6uk7R9idxCMPus1HWhwBUE3PnfysY6z7FdewYJsKqxjbqlyM=
X-Received: by 2002:a05:6870:65ac:b0:1b3:f1f7:999e with SMTP id
 fp44-20020a05687065ac00b001b3f1f7999emr89539oab.45.1691106180192; Thu, 03 Aug
 2023 16:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-11-jingzhangos@google.com> <ZMqSHhFe/4nSN4US@linux.dev>
In-Reply-To: <ZMqSHhFe/4nSN4US@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 3 Aug 2023 16:42:47 -0700
Message-ID: <CAAdAUtjSfHR0FUMv48K9F0WVCMFDeP_i7FdcQz5LMV+1-y=v5A@mail.gmail.com>
Subject: Re: [PATCH v7 10/10] KVM: arm64: selftests: Test for setting ID
 register from usersapce
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Wed, Aug 2, 2023 at 10:28=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Jing,
>
> On Tue, Aug 01, 2023 at 08:20:06AM -0700, Jing Zhang wrote:
> > Add tests to verify setting ID registers from userapce is handled
> > correctly by KVM. Also add a test case to use ioctl
> > KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS to get writable masks.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  tools/arch/arm64/include/uapi/asm/kvm.h       |  25 +++
> >  tools/include/uapi/linux/kvm.h                |   2 +
>
> Why is this diff needed? I thought we wound up using the latest headers
> from the kernel.

You are right. These changes are not needed. Will drop them.

>
> >  tools/testing/selftests/kvm/Makefile          |   1 +
>
> Need to add your file to .gitignore too.

Will do.

>
> >  .../selftests/kvm/aarch64/set_id_regs.c       | 191 ++++++++++++++++++
> >  4 files changed, 219 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
>
> [...]
>
> > diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/=
testing/selftests/kvm/aarch64/set_id_regs.c
> > new file mode 100644
> > index 000000000000..9c8f439ac7b3
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> > @@ -0,0 +1,191 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * set_id_regs - Test for setting ID register from usersapce.
> > + *
> > + * Copyright (c) 2023 Google LLC.
> > + *
> > + *
> > + * Test that KVM supports setting ID registers from userspace and hand=
les the
> > + * feature set correctly.
> > + */
> > +
> > +#include <stdint.h>
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "test_util.h"
> > +#include <linux/bitfield.h>
> > +
> > +#define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffsl(_mask) - 1=
))
> > +#define field_prep(_mask, _val) (((_val) << (ffsl(_mask) - 1)) & (_mas=
k))
> > +
>
> Shadowing the naming of the kernel's own FIELD_{GET,PREP}() is a bit
> awkward. I'm guessing that you're working around @_mask not being a
> compile-time constant?

Yes, they are used to work around @_mask not being a compile-time constant.
As we discussed offline, I'll port automatic system registers
definition generation in selftests and use those definition instead.

>
> > +struct reg_feature {
> > +     uint64_t reg;
> > +     uint64_t ftr_mask;
> > +};
> > +
> > +static void guest_code(void)
> > +{
> > +     for (;;)
> > +             GUEST_SYNC(0);
> > +}
>
> The test should check that the written values are visible both from the
> guest as well as userspace.

Sure. Will add checks in guest too.

>
> > +static struct reg_feature lower_safe_reg_ftrs[] =3D {
> > +     { KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), ARM64_FEATURE_MASK(ID_A=
A64DFR0_WRPS) },
> > +     { KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), ARM64_FEATURE_MASK(ID_A=
A64PFR0_EL3) },
> > +     { KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1), ARM64_FEATURE_MASK(ID_=
AA64MMFR0_FGT) },
> > +     { KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR1_EL1), ARM64_FEATURE_MASK(ID_=
AA64MMFR1_PAN) },
> > +     { KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR2_EL1), ARM64_FEATURE_MASK(ID_=
AA64MMFR2_FWB) },
> > +};
>
> My preference would be to organize the field descriptors by register
> rather than the policy. This matches what the kernel does in cpufeature.c
> quite closely and allows us to easily reason about which fields are/aren'=
t
> tested.

Sure. Will do.

>
> > +static void test_user_set_lower_safe(struct kvm_vcpu *vcpu)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(lower_safe_reg_ftrs); i++) {
> > +             struct reg_feature *reg_ftr =3D lower_safe_reg_ftrs + i;
> > +             uint64_t val, new_val, ftr;
> > +
> > +             vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> > +             ftr =3D field_get(reg_ftr->ftr_mask, val);
> > +
> > +             /* Set a safe value for the feature */
> > +             if (ftr > 0)
> > +                     ftr--;
> > +
> > +             val &=3D ~reg_ftr->ftr_mask;
> > +             val |=3D field_prep(reg_ftr->ftr_mask, ftr);
> > +
> > +             vcpu_set_reg(vcpu, reg_ftr->reg, val);
> > +             vcpu_get_reg(vcpu, reg_ftr->reg, &new_val);
> > +             ASSERT_EQ(new_val, val);
> > +     }
> > +}
> > +
> > +static void test_user_set_fail(struct kvm_vcpu *vcpu)
> > +{
> > +     int i, r;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(lower_safe_reg_ftrs); i++) {
> > +             struct reg_feature *reg_ftr =3D lower_safe_reg_ftrs + i;
> > +             uint64_t val, old_val, ftr;
> > +
> > +             vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> > +             ftr =3D field_get(reg_ftr->ftr_mask, val);
> > +
> > +             /* Set a invalid value (too big) for the feature */
> > +             if (ftr >=3D GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0)=
)
> > +                     continue;
>
> This assumes that the fields in the register are unsigned, but there are
> several which are not.

This is based on the reg/fields which are defined previously. Those
are carefully chosen without unsigned ones.

>
> > +             ftr++;
> > +
> > +             old_val =3D val;
> > +             val &=3D ~reg_ftr->ftr_mask;
> > +             val |=3D field_prep(reg_ftr->ftr_mask, ftr);
> > +
> > +             r =3D __vcpu_set_reg(vcpu, reg_ftr->reg, val);
> > +             TEST_ASSERT(r < 0 && errno =3D=3D EINVAL,
> > +                         "Unexpected KVM_SET_ONE_REG error: r=3D%d, er=
rno=3D%d", r, errno);
> > +
> > +             vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> > +             ASSERT_EQ(val, old_val);
> > +     }
> > +}
> > +
> > +static struct reg_feature exact_reg_ftrs[] =3D {
> > +     /* Items will be added when there is appropriate field of type
> > +      * FTR_EXACT enabled writing from userspace later.
> > +      */
> > +};
> > +
> > +static void test_user_set_exact(struct kvm_vcpu *vcpu)
> > +{
> > +     int i, r;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(exact_reg_ftrs); i++) {
> > +             struct reg_feature *reg_ftr =3D exact_reg_ftrs + i;
> > +             uint64_t val, old_val, ftr;
> > +
> > +             vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> > +             ftr =3D field_get(reg_ftr->ftr_mask, val);
> > +             old_val =3D val;
> > +
> > +             /* Exact match */
> > +             vcpu_set_reg(vcpu, reg_ftr->reg, val);
> > +             vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> > +             ASSERT_EQ(val, old_val);
> > +
> > +             /* Smaller value */
> > +             if (ftr > 0) {
> > +                     ftr--;
> > +                     val &=3D ~reg_ftr->ftr_mask;
> > +                     val |=3D field_prep(reg_ftr->ftr_mask, ftr);
> > +                     r =3D __vcpu_set_reg(vcpu, reg_ftr->reg, val);
> > +                     TEST_ASSERT(r < 0 && errno =3D=3D EINVAL,
> > +                                 "Unexpected KVM_SET_ONE_REG error: r=
=3D%d, errno=3D%d", r, errno);
> > +                     vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> > +                     ASSERT_EQ(val, old_val);
> > +                     ftr++;
> > +             }
> > +
> > +             /* Bigger value */
> > +             ftr++;
> > +             val &=3D ~reg_ftr->ftr_mask;
> > +             val |=3D field_prep(reg_ftr->ftr_mask, ftr);
> > +             r =3D __vcpu_set_reg(vcpu, reg_ftr->reg, val);
> > +             TEST_ASSERT(r < 0 && errno =3D=3D EINVAL,
> > +                         "Unexpected KVM_SET_ONE_REG error: r=3D%d, er=
rno=3D%d", r, errno);
> > +             vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> > +             ASSERT_EQ(val, old_val);
> > +     }
> > +}
>
> Don't add dead code, this can be added when we actually test FTR_EXACT
> fields. Are there not any in the registers exposed by this series?

Nope, there is no in the registers exposed by this series.
Anyway, I'll drop this code in this series.

>
> > +static uint32_t writable_regs[] =3D {
> > +     SYS_ID_DFR0_EL1,
> > +     SYS_ID_AA64DFR0_EL1,
> > +     SYS_ID_AA64PFR0_EL1,
> > +     SYS_ID_AA64MMFR0_EL1,
> > +     SYS_ID_AA64MMFR1_EL1,
> > +     SYS_ID_AA64MMFR2_EL1,
> > +};
> > +
> > +void test_user_get_writable_masks(struct kvm_vm *vm)
> > +{
> > +     struct feature_id_writable_masks masks;
> > +
> > +     vm_ioctl(vm, KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS, &masks);
> > +
> > +     for (int i =3D 0; i < ARRAY_SIZE(writable_regs); i++) {
> > +             uint32_t reg =3D writable_regs[i];
> > +             int idx =3D ARM64_FEATURE_ID_SPACE_IDX(sys_reg_Op0(reg),
> > +                             sys_reg_Op1(reg), sys_reg_CRn(reg),
> > +                             sys_reg_CRm(reg), sys_reg_Op2(reg));
> > +
> > +             ASSERT_EQ(masks.mask[idx], GENMASK_ULL(63, 0));
> > +     }
> > +}
>
> The more robust test would be to check that every field this test knows
> is writable is actually advertised as such in the ioctl. So you could
> fetch this array at the start of the entire test and pass it through to
> the routines that do granular checks against the fields of every
> register.

Makes sense. Will do.

>
> It'd also be good to see basic sanity tests on the ioctl (i.e. call
> fails if ::rsvd is nonzero), since KVM has screwed that up on several
> occasions in past.

Sure. Will add some basic sanity tests on the ioctl.

>
> > +int main(void)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_vm *vm;
> > +
> > +     vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
> > +
> > +     ksft_print_header();
> > +     ksft_set_plan(4);
> > +
> > +     test_user_get_writable_masks(vm);
> > +     ksft_test_result_pass("test_user_get_writable_masks\n");
> > +
> > +     test_user_set_exact(vcpu);
> > +     ksft_test_result_pass("test_user_set_exact\n");
> > +
> > +     test_user_set_fail(vcpu);
> > +     ksft_test_result_pass("test_user_set_fail\n");
> > +
> > +     test_user_set_lower_safe(vcpu);
> > +     ksft_test_result_pass("test_user_set_lower_safe\n");
> > +
> > +     kvm_vm_free(vm);
> > +
> > +     ksft_finished();
> > +}
> > --
> > 2.41.0.585.gd2178a4bd4-goog
> >
>
> --
> Thanks,
> Oliver

Thanks,
Jing
