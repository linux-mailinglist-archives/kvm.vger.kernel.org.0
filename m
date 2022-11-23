Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC7A6369EC
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 20:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238557AbiKWTed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 14:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238248AbiKWTeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 14:34:31 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0115A6F7
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:34:30 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d1so18849789wrs.12
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=54gwlBZl2Mf+sd8h4nHSOZMRH+Engb2ZuOzenuumqrU=;
        b=r/jDHxwUcpE0J33YIxMPzCAbn66zIkY7Q08m9fJKufH0T+rFcLNb+uOZx7Pr9zIYYj
         6XAEu1scb2/xoBcdIQ/25G1AfU1KMT6VVF7EdwY4RK9ykdimufhV/dIBwl8ni8Wcq0Iy
         OdUJ9eD/ERrqemK69RdjVDUZKRPBr6n6fGQq/vgK8LSRj/IywofXkUz7g1n41S3X2iVo
         amNeKtwRj1fwa6XIA2hEdIlTJNuXgJVsCqhvxLFmB0XAMZmIJQvdJIZRwGjd73BIayee
         XoZxS/O0vNvWQ2UwX+Iu787Em+M5eleVGF51cH/RSbnCR3Pox7ojor6llQFMlkbi9UGd
         Qfow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=54gwlBZl2Mf+sd8h4nHSOZMRH+Engb2ZuOzenuumqrU=;
        b=uAm7eID2TKhSRUYMk4OBhr+8SC2Fv+1u4gi92iOMGpiAuwpOn77U6Dt7/v7lODIZKh
         znUhCLl+OnmGPenEeX5PPVedbgJLMF0RFhnqBss4+CetURBmBixQ40fbSPtMx1HNr18c
         YBhIwRmCaKhfEwv3dJEbmEi77P1J/AZjHEdid3dBgCpELjM64E7MoCqzkGq+JX7Oc6UM
         HXMscrOU63ifuka0gdKO+pAYyojbiDOqB9OcQSSqRNG9PMt1GRpy9LaJlnOC/56L5awq
         ZdHRYTSQD4E93k41QSV+wAGssAWNuGB3TZL0AIwAjhHUxAeYgWiqkTuxjSThr765Qojv
         ZFJA==
X-Gm-Message-State: ANoB5pnr8cN6LkCPTnhXJO/rXXhHXsORIl6lS2TfuDGTOj4gFGF/YOaq
        ie9h/oQpM0WkN/VmdCq5+16nscOAZWBhFiNPrpoohQ==
X-Google-Smtp-Source: AA0mqf7K/+5nkPCwqrpkV1q/a9sC32bxcEA8Ux5+uxQ+MxbdQfVj3zItbtfIknPXxhAUOL2/sHq5/OnBKMxLMel1sXY=
X-Received: by 2002:a5d:5d0f:0:b0:236:6f6f:8dd7 with SMTP id
 ch15-20020a5d5d0f000000b002366f6f8dd7mr7794554wrb.4.1669232068839; Wed, 23
 Nov 2022 11:34:28 -0800 (PST)
MIME-Version: 1.0
References: <20221121234026.3037083-1-vipinsh@google.com> <20221121234026.3037083-7-vipinsh@google.com>
 <87mt8jouc0.fsf@ovpn-194-185.brq.redhat.com>
In-Reply-To: <87mt8jouc0.fsf@ovpn-194-185.brq.redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 23 Nov 2022 11:33:52 -0800
Message-ID: <CAHVum0cpR7=yk-8s5yx8em7vCMxPWemqxYD2ULm+L7_CWpA7Ag@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] KVM: selftests: Test Hyper-V extended hypercall
 exit to userspace
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
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

On Tue, Nov 22, 2022 at 7:57 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Vipin Sharma <vipinsh@google.com> writes:
>
> > index 082855d94c72..b17874697d74 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -24,6 +24,7 @@
> >  /x86_64/hyperv_clock
> >  /x86_64/hyperv_cpuid
> >  /x86_64/hyperv_evmcs
> > +/x86_64/hyperv_extended_hypercalls
>
> My personal preference would be to shorten the name to something like
> "hyperv_ext_hcalls", doesn't seem to be ambiguos. No strong preference
> though, feel free to keep the long version.
>

I will keep the long one, in v1 David was suggesting it will be easier
for non Hyperv developers to read and understand.

> > +/* Hyper-V defined paravirt features */
> > +#define X86_FEATURE_HYPERV_EXTENDED_HYPERCALLS       KVM_X86_CPU_FEATURE(0x40000003, 0, EBX, 20)
> > +
>
> I completely forgot about my other series where I've converted the whole
> hyperv_features test to using KVM_X86_CPU_FEATURE():
> https://lore.kernel.org/kvm/20221013095849.705943-6-vkuznets@redhat.com/
>
> but your define reminded me of it, thanks! Hope the whole thing will get
> queued soon.
>

Your patches are always one step ahead of me :D

If your series doesn't show up in the KVM queue soon, I will rebase my
patch series on top of your series

> As for your change, I think it is better suited for
> include/x86_64/hyperv.h instead of include/x86_64/processor.h anyway,
> I'm trying to keep all Hyper-V related stuff separate as Hyper-V CPUID
> leaves intersect with KVM's, e.g. 0x40000001.
>

Sounds good.

> >  /*
> >   * Same idea as X86_FEATURE_XXX, but X86_PROPERTY_XXX retrieves a multi-bit
> >   * value/property as opposed to a single-bit feature.  Again, pack the info
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
> > new file mode 100644
> > index 000000000000..13c1b03294a4
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c
> > @@ -0,0 +1,94 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Test Hyper-V extended hypercall, HV_EXT_CALL_QUERY_CAPABILITIES (0x8001),
> > + * exit to userspace and receive result in guest.
> > + *
> > + * Negative tests are present in hyperv_features.c
> > + *
> > + * Copyright 2022 Google LLC
> > + * Author: Vipin Sharma <vipinsh@google.com>
> > + */
> > +
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "hyperv.h"
> > +
> > +/* Any value is fine */
> > +#define EXT_CAPABILITIES 0xbull
> > +
> > +static void guest_code(vm_vaddr_t in_pg_gpa, vm_vaddr_t out_pg_gpa,
> > +                    vm_vaddr_t out_pg_gva)
> > +{
> > +     uint64_t *output_gva;
> > +
> > +     wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
> > +     wrmsr(HV_X64_MSR_HYPERCALL, in_pg_gpa);
> > +
> > +     output_gva = (uint64_t *)out_pg_gva;
> > +
> > +     hyperv_hypercall(HV_EXT_CALL_QUERY_CAPABILITIES, in_pg_gpa, out_pg_gpa);
> > +
> > +     /* TLFS states output will be a uint64_t value */
> > +     GUEST_ASSERT_EQ(*output_gva, EXT_CAPABILITIES);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +int main(void)
> > +{
> > +     vm_vaddr_t hcall_out_page;
> > +     vm_vaddr_t hcall_in_page;
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_run *run;
> > +     struct kvm_vm *vm;
> > +     uint64_t *outval;
> > +     struct ucall uc;
> > +
> > +     /* Verify if extended hypercalls are supported */
> > +     if (!kvm_cpuid_has(kvm_get_supported_hv_cpuid(),
> > +                        X86_FEATURE_HYPERV_EXTENDED_HYPERCALLS)) {
> > +             print_skip("Extended calls not supported by the kernel");
> > +             exit(KSFT_SKIP);
> > +     }
> > +
> > +     vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> > +     run = vcpu->run;
> > +     vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
>
> Do we need this enforcement assuming we have no plans to add 'negative'
> tests here (hyperv_features does it just fine)? vcpu_set_hv_cpuid()
> enables everything anyway...
>

We do not. I will remove it.

> > +     vcpu_set_hv_cpuid(vcpu);
> > +
> > +     /* Hypercall input */
> > +     hcall_in_page = vm_vaddr_alloc_pages(vm, 1);
> > +     memset(addr_gva2hva(vm, hcall_in_page), 0x0, vm->page_size);
> > +
> > +     /* Hypercall output */
> > +     hcall_out_page = vm_vaddr_alloc_pages(vm, 1);
> > +     memset(addr_gva2hva(vm, hcall_out_page), 0x0, vm->page_size);
> > +
> > +     vcpu_args_set(vcpu, 3, addr_gva2gpa(vm, hcall_in_page),
> > +                   addr_gva2gpa(vm, hcall_out_page), hcall_out_page);
> > +
> > +     vcpu_run(vcpu);
> > +
> > +     ASSERT_EXIT_REASON(vcpu, KVM_EXIT_HYPERV);
> > +
> > +     outval = addr_gpa2hva(vm, run->hyperv.u.hcall.params[1]);
> > +     *outval = EXT_CAPABILITIES;
> > +     run->hyperv.u.hcall.result = HV_STATUS_SUCCESS;
> > +
> > +     vcpu_run(vcpu);
> > +
> > +     ASSERT_EXIT_REASON(vcpu, KVM_EXIT_IO);
> > +
> > +     switch (get_ucall(vcpu, &uc)) {
> > +     case UCALL_ABORT:
> > +             REPORT_GUEST_ASSERT_2(uc, "arg1 = %ld, arg2 = %ld");
> > +             break;
> > +     case UCALL_DONE:
> > +             break;
> > +     default:
> > +             TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> > +     }
> > +
> > +     kvm_vm_free(vm);
> > +     return 0;
> > +}
>
> --
> Vitaly
>
