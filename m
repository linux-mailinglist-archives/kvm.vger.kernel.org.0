Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B992620648
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 02:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiKHBpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 20:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiKHBpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 20:45:47 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233FD1DA7C
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 17:45:45 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v1so18715216wrt.11
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 17:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=47ST8kmmDbEPRBRn6r6aMdT2x8GHsd3FK/EUSGxsYEE=;
        b=GFo6RS8mX1NNIO37+zsamL4bAjKLInJP+o1MsxgHfDyXO8FU50vpd+4idKcfhIEBjJ
         1OYuuRLm96Q6JiQYQKWDL3W4nr6eGD1SWisIAE9t9a+lBPIGccolUpNQx0IN/DVdAsC2
         eAk0rx0hplA/+bslZDWEmW/4/z0V7AD8hVCUfex9TVh7MHsF2XPU/90iwu5kEcg2Drv2
         yv0dq7Huslmzhw/h0JKS2cWzDegl5Thx7oIluPuZKkySPUYQo7ixYE0KgvTNKuHXnINJ
         bvBF5TMVL8S2dC+xNzGd8rXP4KKqgrsuLukHHA/F+st/XYZzE0a6cLkFA5w4pBEf8BBh
         2EWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47ST8kmmDbEPRBRn6r6aMdT2x8GHsd3FK/EUSGxsYEE=;
        b=YzZV3jl4oaCyTqjBt5o3mWjYYC4Ar1XzPcfFhWzQTQzIIVYaXeyuTafneDnVLJVCBt
         +2SF6vKgUCxpJY8E3kLiLlzCAE59MtQR8x+eU/Ppd1DaFvya/7FOR7p6d4lppFivBbGJ
         xCAxhzW/EpNDnWwhA9P9VdaKS0KHXk8tRTUMggXWiuPhQ0GyjfjV8MrshvCRYK8pjW6Z
         F9LipXinQCaM8FaYILljFTN0j1aO6wbf2nlzSxvbcv+XGMQ3tgcQHKuqCi1HMGT3HVeM
         xOVb0Rd4baPf6cmVdX0Rmu9fqHSqrlgC6M1QfPNwAiu4BSzoiv/BXKhdGktmGdV4sWpW
         pXQw==
X-Gm-Message-State: ACrzQf2rneeygWoiPwt1D9D6VEayHMIG37JmQ2WCkvV4tJLHyEEefqjX
        rqoGhyczWjme/6toNPy+Qwu/3pLBWcbXjsfZrXVX5w==
X-Google-Smtp-Source: AMsMyM41/Ipz6FXAw0YtKeEUFBdvrb4zqjfz6bOYn6APrx5qRd9/xTI2L0wcE4cG9+BPXcI51leUYjvlb02/J6i2HJo=
X-Received: by 2002:a5d:47a1:0:b0:236:6f4d:1db3 with SMTP id
 1-20020a5d47a1000000b002366f4d1db3mr32991491wrb.383.1667871943348; Mon, 07
 Nov 2022 17:45:43 -0800 (PST)
MIME-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com> <20221105045704.2315186-5-vipinsh@google.com>
 <Y2lXld6G+Hp0FW3A@google.com>
In-Reply-To: <Y2lXld6G+Hp0FW3A@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 7 Nov 2022 17:45:07 -0800
Message-ID: <CAHVum0ewgeA81T2ttPGB0V-2njdc1oqTjQWziKzTu_pzN+srxw@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: selftests: Make Hyper-V guest OS ID common
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 7, 2022 at 11:08 AM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, Nov 04, 2022 at 09:57:02PM -0700, Vipin Sharma wrote:
> > Make guest OS ID calculation common to all hyperv tests and similar to
> > hv_generate_guest_id().
>
> This commit makes the HV_LINUX_VENDOR_ID and adds LINUX_VERSION_CODE
> to existing tests. Can you split out the latter to a separate commit?
> Also what's the reason to add LINUX_VERSION_CODE to the mix?
>

I looked at the implementation in selftest and what is in the
include/asm-generic/mshyperv.h for the hv_generate_guest_id()
function, both looked different. I thought it would be nice to have
consistent logic at both places.

I can remove LINUX_VERISON_CODE if you prefer.

> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 10 ++++++++++
> >  tools/testing/selftests/kvm/x86_64/hyperv_clock.c    |  2 +-
> >  tools/testing/selftests/kvm/x86_64/hyperv_features.c |  6 ++----
> >  tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c |  2 +-
> >  4 files changed, 14 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> > index 075fd29071a6..9d8c325af1d9 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> > @@ -9,6 +9,10 @@
> >  #ifndef SELFTEST_KVM_HYPERV_H
> >  #define SELFTEST_KVM_HYPERV_H
> >
> > +#include <linux/version.h>
> > +
> > +#define HV_LINUX_VENDOR_ID                   0x8100
> > +
> >  #define HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS        0x40000000
> >  #define HYPERV_CPUID_INTERFACE                       0x40000001
> >  #define HYPERV_CPUID_VERSION                 0x40000002
> > @@ -189,4 +193,10 @@
> >  /* hypercall options */
> >  #define HV_HYPERCALL_FAST_BIT                BIT(16)
> >
> > +static inline uint64_t hv_linux_guest_id(void)
> > +{
> > +     return ((uint64_t)HV_LINUX_VENDOR_ID << 48) |
> > +            ((uint64_t)LINUX_VERSION_CODE << 16);
>
> This can be a compile-time constant (i.e. macro).
>

Yes, I will make it a macro in the next version.

> > +}
> > +
> >  #endif /* !SELFTEST_KVM_HYPERV_H */
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> > index d576bc8ce823..f9112c5dc3f7 100644
> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> > @@ -104,7 +104,7 @@ static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_
> >
> >       /* Set Guest OS id to enable Hyper-V emulation */
> >       GUEST_SYNC(1);
> > -     wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> > +     wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
> >       GUEST_SYNC(2);
> >
> >       check_tsc_msr_rdtsc();
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > index 6b443ce456b6..b5a42cf1ad9d 100644
> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > @@ -13,8 +13,6 @@
> >  #include "processor.h"
> >  #include "hyperv.h"
> >
> > -#define LINUX_OS_ID ((u64)0x8100 << 48)
> > -
> >  static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
> >                               vm_vaddr_t output_address, uint64_t *hv_status)
> >  {
> > @@ -71,7 +69,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
> >
> >       GUEST_ASSERT(hcall->control);
> >
> > -     wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
> > +     wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
> >       wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> >
> >       if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
> > @@ -169,7 +167,7 @@ static void guest_test_msrs_access(void)
> >                        */
> >                       msr->idx = HV_X64_MSR_GUEST_OS_ID;
> >                       msr->write = 1;
> > -                     msr->write_val = LINUX_OS_ID;
> > +                     msr->write_val = hv_linux_guest_id();
> >                       msr->available = 1;
> >                       break;
> >               case 3:
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> > index a380ad7bb9b3..2c13a144b04c 100644
> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> > @@ -69,7 +69,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
> >
> >       GUEST_SYNC(1);
> >
> > -     wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> > +     wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
> >
> >       GUEST_ASSERT(svm->vmcb_gpa);
> >       /* Prepare for L2 execution. */
> > --
> > 2.38.1.273.g43a17bfeac-goog
> >
