Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2209276D4F5
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 19:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjHBRTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 13:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjHBRTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 13:19:44 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A0F11D
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 10:19:43 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-56c7eb17945so3045404eaf.2
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 10:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690996783; x=1691601583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DPDMYwW6AD+CeXfvbHMsXXK++vSwayxvzZfywmToZY=;
        b=ifYNRPlloJr+J4y12Fk+/WCyxn0Wa5cA5rEAAEA2xUfMcbRFm59dS5uvwdSyHWrz6p
         NnxzGBR9+G8elazlvJIcTOa9CAo9cfZSduCX4HKa5M6xscEuGNOXihAABoBQF6T50LYe
         2yjSGrQ6BOXz3UpAkKYIMc6CQ/ohZv6B5/lWH/51M6rCnSCn2wScxhhvt+N70YqlTNCN
         k8mtrTd5rpV3yuCkceOrw6hsh2Glb4meExq9ab0J34TX/PWBa6rNUvEmoCOjJek9qB3e
         7Deee+ohUMZVzCQH6epXPl8y15euOb1C9Lhkg/OyL3s+2L5T7NB7DTeeEHeFgA6DwGnd
         afTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690996783; x=1691601583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DPDMYwW6AD+CeXfvbHMsXXK++vSwayxvzZfywmToZY=;
        b=IdQ0+H6x5fSwIUDuDvnA/SODRXY+dCGMRGFNWJTbpRB1sGP+gQ+Ko5rH9kqsHHSHGs
         dkp0Nk7p/IMVyEK+2LVrM6U9mS1dHZSobUx9hpFwXp49YqgGB7pKZDr8kEKQ/nYy1Qll
         4O/hLYlXvf7jZ6p4zs6CgrWZjodvshyUcUIUKFuJZwDmDf0w2UGdRhL+kzi5Ndftbk7T
         gkLm9MnNfxC1Xhsr0TtIOe2TTTMQ1qzEZalnvAxc2ic/u7v9J5Juy4JC3VmlmAb8KH4/
         sm5/mOn8Iyx8QyaF1tVLf8iPCbYQLxN/+AaDGLj34vgFRBgCUfcIPghc7Y7otRkkVCif
         f6xw==
X-Gm-Message-State: ABy/qLZaamt2wSQTnxQ0EJUd+YdFcHmXrCu8Y5G2+Pk3lHjh5nyRMtu1
        CBGQckiL7bnZjqe9yjqAuzCw4ShYOGSofbPh6+Jj/Q==
X-Google-Smtp-Source: APBJJlEvcX74p4SqrRE7CMFFHYSkSenGk9PjW0S1ycrWcMHzb0fk5ZONzby1FUCTugF8EvLtYB6uKUGpqhjfkR14WCA=
X-Received: by 2002:a05:6870:5623:b0:1bf:1346:63e with SMTP id
 m35-20020a056870562300b001bf1346063emr5707684oao.49.1690996782681; Wed, 02
 Aug 2023 10:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230726044652.2169513-1-jingzhangos@google.com> <871qgvrwbi.wl-maz@kernel.org>
In-Reply-To: <871qgvrwbi.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 2 Aug 2023 10:19:30 -0700
Message-ID: <CAAdAUthi6oZ6oRQDFLeOFVwm2dtcTK2ERJm316x0bdn5TQObYw@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Test pointer authentication
 support in KVM guest
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
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

Hi Marc,

On Wed, Jul 26, 2023 at 12:01=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Hi Jing,
>
> Thanks for getting the ball rolling on that front.
>
> On Wed, 26 Jul 2023 05:46:51 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Add a selftest to verify the support for pointer authentication in KVM
> > guest.
>
> I guess it'd be worth describing *what* you are testing.
Sure, I will add test details.
>
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/aarch64/pauth_test.c        | 143 ++++++++++++++++++
> >  .../selftests/kvm/include/aarch64/processor.h |   2 +
> >  3 files changed, 146 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/pauth_test.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selft=
ests/kvm/Makefile
> > index c692cc86e7da..9bac5aecd66d 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -143,6 +143,7 @@ TEST_GEN_PROGS_aarch64 +=3D aarch64/debug-exception=
s
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/get-reg-list
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/hypercalls
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/page_fault_test
> > +TEST_GEN_PROGS_aarch64 +=3D aarch64/pauth_test
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/psci_test
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/smccc_filter
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/vcpu_width_config
> > diff --git a/tools/testing/selftests/kvm/aarch64/pauth_test.c b/tools/t=
esting/selftests/kvm/aarch64/pauth_test.c
> > new file mode 100644
> > index 000000000000..d5f982da8891
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/aarch64/pauth_test.c
> > @@ -0,0 +1,143 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * pauth_test - Test for KVM guest pointer authentication.
> > + *
> > + * Copyright (c) 2023 Google LLC.
> > + *
> > + */
> > +
> > +#define _GNU_SOURCE
> > +
> > +#include <sched.h>
> > +
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "test_util.h"
> > +
> > +enum uc_args {
> > +     WAIT_MIGRATION,
> > +     PASS,
> > +     FAIL,
> > +     FAIL_KVM,
> > +     FAIL_INSTR,
> > +};
> > +
> > +static noinline void pac_corruptor(void)
> > +{
> > +     __asm__ __volatile__(
> > +             "paciasp\n"
> > +             "eor lr, lr, #1 << 53\n"
>
> Why bit 53? This looks pretty odd. Given that you don't compute the
> size of the PAC field (think FEAT_D128...), this isn't a safe bet...
>
It is kind of arbitrarily chosen, but surely belongs to PAC since the
VM was created with mode VM_MODE_P40V48_4K by default. I will change
the VM creation call to explicitly specify the mode.
> > +     );
> > +
> > +     /* Migrate guest to another physical CPU before authentication */
> > +     GUEST_SYNC(WAIT_MIGRATION);
> > +     __asm__ __volatile__("autiasp\n");
>
> If the test was compiled with PAuth enabled, you shouldn't need to add
> the paciasp/authiasp instructions. On the other hand, the whole
> "corrupt LR" is extremely fragile -- the compiler doesn't know you've
> messed with it, and it is free to reuse it.
>
> If you want a reliable test, you must write this entirely in
> assembly.
Right. I didn't take care of the LR when I added the GUEST_SYNC call.
I guess it would work too if I save the LR on stack before the call to
GUEST_SYNC and restore it later before the authentication instruction.
>
> > +}
> > +
> > +static void guest_code(void)
> > +{
> > +     uint64_t sctlr =3D read_sysreg(sctlr_el1);
> > +
> > +     /* Enable PAuth */
> > +     sctlr |=3D SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | SCTLR_ELx_ENDA | SCT=
LR_ELx_ENDB;
> > +     write_sysreg(sctlr, sctlr_el1);
> > +     isb();
>
> Out of curiosity, where are the keys set up? Because part of the
> validation would be that for a given set of keys and authentication
> algorithm, we obtain the same results.
I just used whatever in the key system registers. I will set up the
keys explicitly with given values. This then can also verify that KVM
saves/restores the keys correctly.
>
> > +
> > +     pac_corruptor();
> > +
> > +     /* Shouldn't be here unless the pac_corruptor didn't do its work =
*/
> > +     GUEST_SYNC(FAIL);
> > +     GUEST_DONE();
> > +}
> > +
> > +/* Guest will get an unknown exception if KVM doesn't support guest PA=
uth */
> > +static void guest_unknown_handler(struct ex_regs *regs)
> > +{
> > +     GUEST_SYNC(FAIL_KVM);
> > +     GUEST_DONE();
> > +}
> > +
> > +/* Guest will get a FPAC exception if KVM support guest PAuth */
> > +static void guest_fpac_handler(struct ex_regs *regs)
> > +{
> > +     GUEST_SYNC(PASS);
> > +     GUEST_DONE();
> > +}
> > +
> > +/* Guest will get an instruction abort exception if the PAuth instruct=
ions have
> > + * no effect (or PAuth not enabled in guest), which would cause guest =
to fetch
> > + * an invalid instruction due to the corrupted LR.
> > + */
> > +static void guest_iabt_handler(struct ex_regs *regs)
> > +{
> > +     GUEST_SYNC(FAIL_INSTR);
> > +     GUEST_DONE();
> > +}
> > +
> > +int main(void)
> > +{
> > +     struct kvm_vcpu_init init;
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_vm *vm;
> > +     struct ucall uc;
> > +     cpu_set_t cpu_mask;
> > +
> > +     TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PTRAUTH_ADDRESS));
> > +     TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PTRAUTH_GENERIC));
> > +
> > +     vm =3D vm_create(1);
> > +
> > +     vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> > +     init.features[0] |=3D ((1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS) |
> > +                          (1 << KVM_ARM_VCPU_PTRAUTH_GENERIC));
> > +
> > +     vcpu =3D aarch64_vcpu_add(vm, 0, &init, guest_code);
> > +
> > +     vm_init_descriptor_tables(vm);
> > +     vcpu_init_descriptor_tables(vcpu);
> > +
> > +     vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> > +                             ESR_EC_UNKNOWN, guest_unknown_handler);
> > +     vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> > +                             ESR_EC_FPAC, guest_fpac_handler);
> > +     vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
> > +                             ESR_EC_IABT, guest_iabt_handler);
> > +
> > +     while (1) {
> > +             vcpu_run(vcpu);
> > +
> > +             switch (get_ucall(vcpu, &uc)) {
> > +             case UCALL_ABORT:
> > +                     REPORT_GUEST_ASSERT(uc);
> > +                     break;
> > +             case UCALL_SYNC:
> > +                     switch (uc.args[1]) {
> > +                     case PASS:
> > +                             /* KVM guest PAuth works! */
> > +                             break;
> > +                     case WAIT_MIGRATION:
> > +                             sched_getaffinity(0, sizeof(cpu_mask), &c=
pu_mask);
> > +                             CPU_CLR(sched_getcpu(), &cpu_mask);
> > +                             sched_setaffinity(0, sizeof(cpu_mask), &c=
pu_mask);
> > +                             break;
> > +                     case FAIL:
> > +                             TEST_FAIL("Guest corruptor code doesn't w=
ork!\n");
> > +                             break;
> > +                     case FAIL_KVM:
> > +                             TEST_FAIL("KVM doesn't support guest PAut=
h!\n");
>
> Why is that a hard failure? The vast majority of the HW out there
> doesn't support PAuth...
Since previous TEST_REQUIRES have passed, KVM should be able to
support guest PAuth. The test will be skipped on those HW without
PAuth.
>
> > +                             break;
> > +                     case FAIL_INSTR:
> > +                             TEST_FAIL("Guest PAuth instructions don't=
 work!\n");
> > +                             break;
> > +                     }
> > +                     break;
> > +             case UCALL_DONE:
> > +                     goto done;
>
> Why a goto instead of a break?
To jump out of the while(1) loop.
>
> > +             default:
> > +                     TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
> > +             }
> > +     }
> > +
> > +done:
> > +     kvm_vm_free(vm);
> > +}
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/=
tools/testing/selftests/kvm/include/aarch64/processor.h
> > index cb537253a6b9..f8d541af9c06 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -104,7 +104,9 @@ enum {
> >  #define ESR_EC_SHIFT         26
> >  #define ESR_EC_MASK          (ESR_EC_NUM - 1)
> >
> > +#define ESR_EC_UNKNOWN               0x00
> >  #define ESR_EC_SVC64         0x15
> > +#define ESR_EC_FPAC          0x1c
> >  #define ESR_EC_IABT          0x21
> >  #define ESR_EC_DABT          0x25
> >  #define ESR_EC_HW_BP_CURRENT 0x31
> >
>
> Although that's a good start, PAuth instructions that are in the NOP
> space are not that interesting, because we already have tons of code
> using it. What I'd really love to see is a test exercising some of the
> non-NOP stuff, including use of the generic auth keys and the
> PACGA/XPAC* instructions.
Sure, I will add more tests for non-NOP stuff.
>
> As I mentioned above, another thing I'd like to see is a set of
> reference results for a given set of keys and architected algorithm
> (QARMA3, QARMA5) so that we can compare between implementations
> (excluding the IMPDEF implementations, of course).
Sure. Will do.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
