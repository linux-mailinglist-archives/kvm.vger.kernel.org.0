Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491CA621B46
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 18:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbiKHR5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 12:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiKHR51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 12:57:27 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6603B1E3DC
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 09:57:25 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 7so13714508ybp.13
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 09:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yq6SxkaZozukMrO18EMGqMBbnexsg8nmoacOgG58fTU=;
        b=QScNn0Kp+hzyQhI7j3OHVC3ZpGfVww8KjVkmD7X2+zcn5ZVnkcYxIZLnHRr3uHL09Y
         Eh6U8QLplXpfKJwW2PUO0ot67x9sW6/LuDaeFxiqOyT9N8CHQGrZugmNiImBTIPPWFrm
         gKBdO70LZ3dNocFhsoFy54RWoUfWhkl/ZnEH/AI0AgoMl3augkKlcAb1f9v2fcGqMDbg
         k/igdO7FTbVidXZT+j8CTA1fTr/UvT4i/LxmoDCF13ivGqHdyQo0AR/wlcb2/RSVQ/Vz
         BVycsu1e+y0EPuVnlCBviEZSvh2eqGx5Zfzrp4Iux5/gX0Ar2y9RMPFDwiR9b3/pEMxY
         58Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yq6SxkaZozukMrO18EMGqMBbnexsg8nmoacOgG58fTU=;
        b=S+Omy3qEoEgI8pbip25hsgEeDeLAV4pp7wMhQ4tkwpFW1XDBn8xthIy0QC9Fu69jwI
         PEPQ+Kk7A9JJOu71tYvFrBE6f9ALR9raJRwy+/zMG76yEJE3BeTYyC8oeea4LY9avo/y
         GEPsDzwCDKmccIDLm2Fu2D4em6R/+oACOcxc7ibKGOLRwoUdoar1Hk8tE/XPb0pVeHbJ
         gsGoXvT405zMiLZ9eWINgDywq/6qGRNY7mEmooJLYFUnQuqiOnHWGvmdV7E2pQSzMDip
         GD+BzyiuO2fnD7WjSp8PkqEl4jQ3rjrLxkDyimNKhU6GnR5IAPC0PD1lMfKtLqIVJePA
         1O+g==
X-Gm-Message-State: ANoB5pk3Mk0kCEDaVyxr/9MP1YxdAOXW30Yvd3Lj9xAcx5uQBQrEYl2G
        waMp3/OimR8rrPHX6vj5WoCVNFUMNE2DtmplaLpT0Ppd4RE=
X-Google-Smtp-Source: AA0mqf4iqNsh5zLKqxE4owqIb5QivOPugZlsrSsWEsxhRGWffbKB62V6hcwEJxpvqyz9F2REc5qZ0rAi+mKHTqa21yU=
X-Received: by 2002:a25:5888:0:b0:6d5:1100:5dcc with SMTP id
 m130-20020a255888000000b006d511005dccmr17158056ybb.0.1667930244512; Tue, 08
 Nov 2022 09:57:24 -0800 (PST)
MIME-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com> <20221105045704.2315186-5-vipinsh@google.com>
 <Y2lXld6G+Hp0FW3A@google.com> <CAHVum0ewgeA81T2ttPGB0V-2njdc1oqTjQWziKzTu_pzN+srxw@mail.gmail.com>
In-Reply-To: <CAHVum0ewgeA81T2ttPGB0V-2njdc1oqTjQWziKzTu_pzN+srxw@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 8 Nov 2022 09:56:57 -0800
Message-ID: <CALzav=djtqYAchW0x=riSEtvoQAbpotjBeibBLWVQg4J2T5iiA@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: selftests: Make Hyper-V guest OS ID common
To:     Vipin Sharma <vipinsh@google.com>
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

On Mon, Nov 7, 2022 at 5:45 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Mon, Nov 7, 2022 at 11:08 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Fri, Nov 04, 2022 at 09:57:02PM -0700, Vipin Sharma wrote:
> > > Make guest OS ID calculation common to all hyperv tests and similar to
> > > hv_generate_guest_id().
> >
> > This commit makes the HV_LINUX_VENDOR_ID and adds LINUX_VERSION_CODE
> > to existing tests. Can you split out the latter to a separate commit?
> > Also what's the reason to add LINUX_VERSION_CODE to the mix?
> >
>
> I looked at the implementation in selftest and what is in the
> include/asm-generic/mshyperv.h for the hv_generate_guest_id()
> function, both looked different. I thought it would be nice to have
> consistent logic at both places.
>
> I can remove LINUX_VERISON_CODE if you prefer.

Using LINUX_VERSION_CODE here assumes the selftest will run on the
same kernel that it was compiled with. This might not be the case in
practice, e.g. if anyone runs the latest upstream selftests against
their internal kernel (something we've discussed doing recently).

The right way to incorporate the Linux version code would be for the
selftest to query it from the host dynamically and use that (at which
point hv_linux_guest_id() would actually have to be a function).

But since you don't strictly need it, it's probably best to just omit
it for the time being.



>
> > >
> > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 10 ++++++++++
> > >  tools/testing/selftests/kvm/x86_64/hyperv_clock.c    |  2 +-
> > >  tools/testing/selftests/kvm/x86_64/hyperv_features.c |  6 ++----
> > >  tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c |  2 +-
> > >  4 files changed, 14 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> > > index 075fd29071a6..9d8c325af1d9 100644
> > > --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> > > +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> > > @@ -9,6 +9,10 @@
> > >  #ifndef SELFTEST_KVM_HYPERV_H
> > >  #define SELFTEST_KVM_HYPERV_H
> > >
> > > +#include <linux/version.h>
> > > +
> > > +#define HV_LINUX_VENDOR_ID                   0x8100
> > > +
> > >  #define HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS        0x40000000
> > >  #define HYPERV_CPUID_INTERFACE                       0x40000001
> > >  #define HYPERV_CPUID_VERSION                 0x40000002
> > > @@ -189,4 +193,10 @@
> > >  /* hypercall options */
> > >  #define HV_HYPERCALL_FAST_BIT                BIT(16)
> > >
> > > +static inline uint64_t hv_linux_guest_id(void)
> > > +{
> > > +     return ((uint64_t)HV_LINUX_VENDOR_ID << 48) |
> > > +            ((uint64_t)LINUX_VERSION_CODE << 16);
> >
> > This can be a compile-time constant (i.e. macro).
> >
>
> Yes, I will make it a macro in the next version.
>
> > > +}
> > > +
> > >  #endif /* !SELFTEST_KVM_HYPERV_H */
> > > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> > > index d576bc8ce823..f9112c5dc3f7 100644
> > > --- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> > > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
> > > @@ -104,7 +104,7 @@ static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_
> > >
> > >       /* Set Guest OS id to enable Hyper-V emulation */
> > >       GUEST_SYNC(1);
> > > -     wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> > > +     wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
> > >       GUEST_SYNC(2);
> > >
> > >       check_tsc_msr_rdtsc();
> > > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > > index 6b443ce456b6..b5a42cf1ad9d 100644
> > > --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> > > @@ -13,8 +13,6 @@
> > >  #include "processor.h"
> > >  #include "hyperv.h"
> > >
> > > -#define LINUX_OS_ID ((u64)0x8100 << 48)
> > > -
> > >  static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
> > >                               vm_vaddr_t output_address, uint64_t *hv_status)
> > >  {
> > > @@ -71,7 +69,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
> > >
> > >       GUEST_ASSERT(hcall->control);
> > >
> > > -     wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
> > > +     wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
> > >       wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> > >
> > >       if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
> > > @@ -169,7 +167,7 @@ static void guest_test_msrs_access(void)
> > >                        */
> > >                       msr->idx = HV_X64_MSR_GUEST_OS_ID;
> > >                       msr->write = 1;
> > > -                     msr->write_val = LINUX_OS_ID;
> > > +                     msr->write_val = hv_linux_guest_id();
> > >                       msr->available = 1;
> > >                       break;
> > >               case 3:
> > > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> > > index a380ad7bb9b3..2c13a144b04c 100644
> > > --- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> > > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> > > @@ -69,7 +69,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm)
> > >
> > >       GUEST_SYNC(1);
> > >
> > > -     wrmsr(HV_X64_MSR_GUEST_OS_ID, (u64)0x8100 << 48);
> > > +     wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
> > >
> > >       GUEST_ASSERT(svm->vmcb_gpa);
> > >       /* Prepare for L2 execution. */
> > > --
> > > 2.38.1.273.g43a17bfeac-goog
> > >
