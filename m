Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501D35104C7
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353569AbiDZRCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 13:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241424AbiDZRCb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 13:02:31 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875BE6EC53
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:59:20 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id w187so24687109ybe.2
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GH43qdalFH201bywPnynKUZzlq3g2/HxF1LQk9DABhQ=;
        b=Uzta1YZI7Jy2BsepTIAPH2iHY8+QVbAQm2WuRTvfQjdO+Zl0TRZ5s48KpmTMOljED8
         dlp+glTdjoXZ7+WRnbWOM34zoxDTa5fTmwjYVFz/zrw/gq+TTnuEA68ZkGWgFx5k062m
         d7NtID9A7CDm0FTV2cgPwBgxxuSD7QL05dGsXXxz21Djn9hWloPKV30mFUxO8MQndSPi
         ZcxzBwBKKlk43RePiPZmgRKr55YK4Jpw3zrGexCE6fuDTrHQZL275xlKSdQqnp19MZtS
         q9mjO9zgmXQbLR287q01cq28x/be2qK1DLQoklNucuYOBt5GJCrghmJRkrKZzb5HvEC0
         oAZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GH43qdalFH201bywPnynKUZzlq3g2/HxF1LQk9DABhQ=;
        b=Pkz+GvZOQlsG/9Q7mv9uCpgYKvdMOVFd9Z4HqH9kS12R5at+o8y+GU4g94KB+4JVg3
         Uh2t2rjnKsIuJAkTOKMJM1q22pfPOe7++BoLtrRjOZQuwR6PhSxo5JydOwqVpZswcM7D
         7MFth1AO6EC1cUnoKedKnn7fNtJEIuol1NCMZKeDI1CZJzS2CE0Y9EIsACCkbFoux3bX
         B3bJdngMr6Hvn7eC+LGpLQ8Z77f03CpWwjtgbOPqsYd+PmBAAqd6xbKy4H9lnBEiFzIO
         UkCrMS9iz17slRgAaFhThoVE1vgLIdd2/8upjZs+hbtbTeWNFTNPBcw/qt8kSqdUWxg0
         aF0w==
X-Gm-Message-State: AOAM532vOTKygtZpkcqXWSz6PHu555wxNUUpBAbTLfPRrLzOMV1zo/V6
        hugwkiJ4b2OncBsRZ+VMxKQHayiTOZyddmgMDe9jhA==
X-Google-Smtp-Source: ABdhPJyS816mANzNCVy6Xw+/t0TYvoxND0MQXvY0xO2rpGgXp0BPOB5YvkrnMrAaGay/ubrvl3TbG4MxQf+GkmNhPEc=
X-Received: by 2002:a05:6902:1242:b0:644:c30c:cfcc with SMTP id
 t2-20020a056902124200b00644c30ccfccmr21290240ybu.509.1650992359476; Tue, 26
 Apr 2022 09:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com> <20220423000328.2103733-9-rananta@google.com>
 <896e95a1-6a3e-c524-4951-8fae9697b85e@redhat.com>
In-Reply-To: <896e95a1-6a3e-c524-4951-8fae9697b85e@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 26 Apr 2022 09:59:08 -0700
Message-ID: <CAJHc60z_+O09u0wB9=PnuEu3bZC0tQG93iWbjTP7-WvnN-FEnQ@mail.gmail.com>
Subject: Re: [PATCH v6 8/9] selftests: KVM: aarch64: Introduce hypercall ABI test
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On Tue, Apr 26, 2022 at 12:50 AM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Raghavendra,
>
> On 4/23/22 8:03 AM, Raghavendra Rao Ananta wrote:
> > Introduce a KVM selftest to check the hypercall interface
> > for arm64 platforms. The test validates the user-space'
> > [GET|SET]_ONE_REG interface to read/write the psuedo-firmware
> > registers as well as its effects on the guest upon certain
> > configurations.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   tools/testing/selftests/kvm/.gitignore        |   1 +
> >   tools/testing/selftests/kvm/Makefile          |   1 +
> >   .../selftests/kvm/aarch64/hypercalls.c        | 335 ++++++++++++++++++
> >   3 files changed, 337 insertions(+)
> >   create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c
> >
>
> There are comments about @false_hvc_info[] and some nits, as below.
> Please evaluate and improve if it makes sense to you. Otherwise, it
> looks good to me:
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
>
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 1bb575dfc42e..b17e464ec661 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -2,6 +2,7 @@
> >   /aarch64/arch_timer
> >   /aarch64/debug-exceptions
> >   /aarch64/get-reg-list
> > +/aarch64/hypercalls
> >   /aarch64/psci_test
> >   /aarch64/vcpu_width_config
> >   /aarch64/vgic_init
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index c2cf4d318296..97eef0c03d3b 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -105,6 +105,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
> >   TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
> >   TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> >   TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> > +TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
> >   TEST_GEN_PROGS_aarch64 += aarch64/psci_test
> >   TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
> >   TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
> > diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
> > new file mode 100644
> > index 000000000000..f404343a0ae3
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
> > @@ -0,0 +1,335 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +/* hypercalls: Check the ARM64's psuedo-firmware bitmap register interface.
> > + *
> > + * The test validates the basic hypercall functionalities that are exposed
> > + * via the psuedo-firmware bitmap register. This includes the registers'
> > + * read/write behavior before and after the VM has started, and if the
> > + * hypercalls are properly masked or unmasked to the guest when disabled or
> > + * enabled from the KVM userspace, respectively.
> > + */
> > +
> > +#include <errno.h>
> > +#include <linux/arm-smccc.h>
> > +#include <asm/kvm.h>
> > +#include <kvm_util.h>
> > +
> > +#include "processor.h"
> > +
> > +#define FW_REG_ULIMIT_VAL(max_feat_bit) (GENMASK(max_feat_bit, 0))
> > +
> > +/* Last valid bits of the bitmapped firmware registers */
> > +#define KVM_REG_ARM_STD_BMAP_BIT_MAX         0
> > +#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX     0
> > +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX  1
> > +
> > +struct kvm_fw_reg_info {
> > +     uint64_t reg;           /* Register definition */
> > +     uint64_t max_feat_bit;  /* Bit that represents the upper limit of the feature-map */
> > +};
> > +
> > +#define FW_REG_INFO(r)                       \
> > +     {                                       \
> > +             .reg = r,                       \
> > +             .max_feat_bit = r##_BIT_MAX,    \
> > +     }
> > +
> > +static const struct kvm_fw_reg_info fw_reg_info[] = {
> > +     FW_REG_INFO(KVM_REG_ARM_STD_BMAP),
> > +     FW_REG_INFO(KVM_REG_ARM_STD_HYP_BMAP),
> > +     FW_REG_INFO(KVM_REG_ARM_VENDOR_HYP_BMAP),
> > +};
> > +
> > +enum test_stage {
> > +     TEST_STAGE_REG_IFACE,
> > +     TEST_STAGE_HVC_IFACE_FEAT_DISABLED,
> > +     TEST_STAGE_HVC_IFACE_FEAT_ENABLED,
> > +     TEST_STAGE_HVC_IFACE_FALSE_INFO,
> > +     TEST_STAGE_END,
> > +};
> > +
> > +static int stage = TEST_STAGE_REG_IFACE;
> > +
> > +struct test_hvc_info {
> > +     uint32_t func_id;
> > +     uint64_t arg1;
> > +};
> > +
> > +#define TEST_HVC_INFO(f, a1) \
> > +     {                       \
> > +             .func_id = f,   \
> > +             .arg1 = a1,     \
> > +     }
> > +
> > +static const struct test_hvc_info hvc_info[] = {
> > +     /* KVM_REG_ARM_STD_BMAP */
> > +     TEST_HVC_INFO(ARM_SMCCC_TRNG_VERSION, 0),
> > +     TEST_HVC_INFO(ARM_SMCCC_TRNG_FEATURES, ARM_SMCCC_TRNG_RND64),
> > +     TEST_HVC_INFO(ARM_SMCCC_TRNG_GET_UUID, 0),
> > +     TEST_HVC_INFO(ARM_SMCCC_TRNG_RND32, 0),
> > +     TEST_HVC_INFO(ARM_SMCCC_TRNG_RND64, 0),
> > +
> > +     /* KVM_REG_ARM_STD_HYP_BMAP */
> > +     TEST_HVC_INFO(ARM_SMCCC_ARCH_FEATURES_FUNC_ID, ARM_SMCCC_HV_PV_TIME_FEATURES),
> > +     TEST_HVC_INFO(ARM_SMCCC_HV_PV_TIME_FEATURES, ARM_SMCCC_HV_PV_TIME_ST),
> > +     TEST_HVC_INFO(ARM_SMCCC_HV_PV_TIME_ST, 0),
> > +
> > +     /* KVM_REG_ARM_VENDOR_HYP_BMAP */
> > +     TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
> > +                     ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID),
> > +     TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0),
> > +     TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID, KVM_PTP_VIRT_COUNTER),
> > +};
> > +
> > +/* Feed false hypercall info to test the KVM behavior */
> > +static const struct test_hvc_info false_hvc_info[] = {
> > +     /* Feature support check against a different family of hypercalls */
> > +     TEST_HVC_INFO(ARM_SMCCC_TRNG_FEATURES, ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID),
> > +     TEST_HVC_INFO(ARM_SMCCC_ARCH_FEATURES_FUNC_ID, ARM_SMCCC_TRNG_RND64),
> > +     TEST_HVC_INFO(ARM_SMCCC_HV_PV_TIME_FEATURES, ARM_SMCCC_TRNG_RND64),
> > +};
> > +
>
> I don't see too much benefits of @false_hvc_info[] because
> NOT_SUPPORTED is always returned from its test case. I think
> it and its test case can be removed if you agree. I'm not
> sure if it was suggested by somebody else.
>
While this is not exactly testing the bitmap firmware registers, the
idea behind introducing false_hvc_info[] was to introduce some
negative tests and see if KVM handles it well. Especially with
*_FEATURES func_ids, we can accidentally introduce functional bugs in
KVM, and these would act as our safety net. I was planning to also
test with some reserved hypercall numbers, just to test if the kernel
doesn't panic for some reason.

> > +static void guest_test_hvc(const struct test_hvc_info *hc_info)
> > +{
> > +     unsigned int i;
> > +     struct arm_smccc_res res;
> > +     unsigned int hvc_info_arr_sz;
> > +
> > +     hvc_info_arr_sz =
> > +     hc_info == hvc_info ? ARRAY_SIZE(hvc_info) : ARRAY_SIZE(false_hvc_info);
> > +
> > +     for (i = 0; i < hvc_info_arr_sz; i++, hc_info++) {
> > +             memset(&res, 0, sizeof(res));
> > +             smccc_hvc(hc_info->func_id, hc_info->arg1, 0, 0, 0, 0, 0, 0, &res);
> > +
> > +             switch (stage) {
> > +             case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
> > +             case TEST_STAGE_HVC_IFACE_FALSE_INFO:
> > +                     GUEST_ASSERT_3(res.a0 == SMCCC_RET_NOT_SUPPORTED,
> > +                                     res.a0, hc_info->func_id, hc_info->arg1);
> > +                     break;
> > +             case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
> > +                     GUEST_ASSERT_3(res.a0 != SMCCC_RET_NOT_SUPPORTED,
> > +                                     res.a0, hc_info->func_id, hc_info->arg1);
> > +                     break;
> > +             default:
> > +                     GUEST_ASSERT_1(0, stage);
> > +             }
> > +     }
> > +}
> > +
> > +static void guest_code(void)
> > +{
> > +     while (stage != TEST_STAGE_END) {
> > +             switch (stage) {
> > +             case TEST_STAGE_REG_IFACE:
> > +                     break;
> > +             case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
> > +             case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
> > +                     guest_test_hvc(hvc_info);
> > +                     break;
> > +             case TEST_STAGE_HVC_IFACE_FALSE_INFO:
> > +                     guest_test_hvc(false_hvc_info);
> > +                     break;
> > +             default:
> > +                     GUEST_ASSERT_1(0, stage);
> > +             }
> > +
> > +             GUEST_SYNC(stage);
> > +     }
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static int set_fw_reg(struct kvm_vm *vm, uint64_t id, uint64_t val)
> > +{
> > +     struct kvm_one_reg reg = {
> > +             .id = id,
> > +             .addr = (uint64_t)&val,
> > +     };
> > +
> > +     return _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
> > +}
> > +
> > +static void get_fw_reg(struct kvm_vm *vm, uint64_t id, uint64_t *addr)
> > +{
> > +     struct kvm_one_reg reg = {
> > +             .id = id,
> > +             .addr = (uint64_t)addr,
> > +     };
> > +
> > +     vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &reg);
> > +}
> > +
> > +struct st_time {
> > +     uint32_t rev;
> > +     uint32_t attr;
> > +     uint64_t st_time;
> > +};
> > +
> > +#define STEAL_TIME_SIZE              ((sizeof(struct st_time) + 63) & ~63)
> > +#define ST_GPA_BASE          (1 << 30)
> > +
> > +static void steal_time_init(struct kvm_vm *vm)
> > +{
> > +     uint64_t st_ipa = (ulong)ST_GPA_BASE;
> > +     unsigned int gpages;
> > +     struct kvm_device_attr dev = {
> > +             .group = KVM_ARM_VCPU_PVTIME_CTRL,
> > +             .attr = KVM_ARM_VCPU_PVTIME_IPA,
> > +             .addr = (uint64_t)&st_ipa,
> > +     };
> > +
> > +     gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE);
> > +     vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
> > +
> > +     vcpu_ioctl(vm, 0, KVM_SET_DEVICE_ATTR, &dev);
> > +}
> > +
> > +static void test_fw_regs_before_vm_start(struct kvm_vm *vm)
> > +{
> > +     uint64_t val;
> > +     unsigned int i;
> > +     int ret;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(fw_reg_info); i++) {
> > +             const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
> > +
> > +             /* First 'read' should be an upper limit of the features supported */
> > +             get_fw_reg(vm, reg_info->reg, &val);
> > +             TEST_ASSERT(val == FW_REG_ULIMIT_VAL(reg_info->max_feat_bit),
> > +                     "Expected all the features to be set for reg: 0x%lx; expected: 0x%lx; read: 0x%lx\n",
> > +                     reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit), val);
> > +
> > +             /* Test a 'write' by disabling all the features of the register map */
> > +             ret = set_fw_reg(vm, reg_info->reg, 0);
> > +             TEST_ASSERT(ret == 0,
> > +                     "Failed to clear all the features of reg: 0x%lx; ret: %d\n",
> > +                     reg_info->reg, errno);
> > +
> > +             get_fw_reg(vm, reg_info->reg, &val);
> > +             TEST_ASSERT(val == 0,
> > +                     "Expected all the features to be cleared for reg: 0x%lx\n", reg_info->reg);
> > +
> > +             /*
> > +              * Test enabling a feature that's not supported.
> > +              * Avoid this check if all the bits are occupied.
> > +              */
> > +             if (reg_info->max_feat_bit < 63) {
> > +                     ret = set_fw_reg(vm, reg_info->reg, BIT(reg_info->max_feat_bit + 1));
> > +                     TEST_ASSERT(ret != 0 && errno == EINVAL,
> > +                     "Unexpected behavior or return value (%d) while setting an unsupported feature for reg: 0x%lx\n",
> > +                     errno, reg_info->reg);
> > +             }
> > +     }
> > +}
>
> Just in case :)
>
>       ret = set_fw_reg(vm, reg_info->reg, GENMASK(63, reg_info->max_feat_bit + 1));
>
It may be better to cover the entire range, but to test only the
(max_feat_bit + 1) gives us the advantage of checking if there's any
discrepancy between the kernel and the test, now that *_BIT_MAX are
not a part of UAPI headers.

Probably also include your test along with the existing one?
>
> > +
> > +static void test_fw_regs_after_vm_start(struct kvm_vm *vm)
> > +{
> > +     uint64_t val;
> > +     unsigned int i;
> > +     int ret;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(fw_reg_info); i++) {
> > +             const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
> > +
> > +             /*
> > +              * Before starting the VM, the test clears all the bits.
> > +              * Check if that's still the case.
> > +              */
> > +             get_fw_reg(vm, reg_info->reg, &val);
> > +             TEST_ASSERT(val == 0,
> > +                     "Expected all the features to be cleared for reg: 0x%lx\n",
> > +                     reg_info->reg);
> > +
> > +             /*
> > +              * Set all the features for this register again. KVM shouldn't
> > +              * allow this as the VM is running.
> > +              */
> > +             ret = set_fw_reg(vm, reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit));
> > +             TEST_ASSERT(ret != 0 && errno == EBUSY,
> > +             "Unexpected behavior or return value (%d) while setting a feature while VM is running for reg: 0x%lx\n",
> > +             errno, reg_info->reg);
> > +     }
> > +}
> > +
>
> I guess you want to check -EBUSY is returned. In that case,
> the comments here could be clearer, something like below
> to emphasize '-EBUSY'.
>
>          /*
>           * After VM runs for once, -EBUSY should be returned on attempt
>           * to set features. Check if the correct errno is returned.
>           */
>
Sounds good.

> > +static struct kvm_vm *test_vm_create(void)
> > +{
> > +     struct kvm_vm *vm;
> > +
> > +     vm = vm_create_default(0, 0, guest_code);
> > +
> > +     ucall_init(vm, NULL);
> > +     steal_time_init(vm);
> > +
> > +     return vm;
> > +}
> > +
> > +static struct kvm_vm *test_guest_stage(struct kvm_vm *vm)
> > +{
> > +     struct kvm_vm *ret_vm = vm;
> > +
> > +     pr_debug("Stage: %d\n", stage);
> > +
> > +     switch (stage) {
> > +     case TEST_STAGE_REG_IFACE:
> > +             test_fw_regs_after_vm_start(vm);
> > +             break;
> > +     case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
> > +             /* Start a new VM so that all the features are now enabled by default */
> > +             kvm_vm_free(vm);
> > +             ret_vm = test_vm_create();
> > +             break;
> > +     case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
> > +     case TEST_STAGE_HVC_IFACE_FALSE_INFO:
> > +             break;
> > +     default:
> > +             TEST_FAIL("Unknown test stage: %d\n", stage);
> > +     }
> > +
> > +     stage++;
> > +     sync_global_to_guest(vm, stage);
> > +
> > +     return ret_vm;
> > +}
> > +
> > +static void test_run(void)
> > +{
> > +     struct kvm_vm *vm;
> > +     struct ucall uc;
> > +     bool guest_done = false;
> > +
> > +     vm = test_vm_create();
> > +
> > +     test_fw_regs_before_vm_start(vm);
> > +
> > +     while (!guest_done) {
> > +             vcpu_run(vm, 0);
> > +
> > +             switch (get_ucall(vm, 0, &uc)) {
> > +             case UCALL_SYNC:
> > +                     vm = test_guest_stage(vm);
> > +                     break;
> > +             case UCALL_DONE:
> > +                     guest_done = true;
> > +                     break;
> > +             case UCALL_ABORT:
> > +                     TEST_FAIL("%s at %s:%ld\n\tvalues: 0x%lx, 0x%lx; 0x%lx, stage: %u",
> > +                     (const char *)uc.args[0], __FILE__, uc.args[1],
> > +                     uc.args[2], uc.args[3], uc.args[4], stage);
> > +                     break;
> > +             default:
> > +                     TEST_FAIL("Unexpected guest exit\n");
> > +             }
> > +     }
> > +
> > +     kvm_vm_free(vm);
> > +}
> > +
> > +int main(void)
> > +{
> > +     setbuf(stdout, NULL);
> > +
> > +     test_run();
> > +     return 0;
> > +}
> >
>
> Thanks,
> Gavin
>
Thanks for the reviews on all the patches, Gavin.

Regards,
Raghavendra
