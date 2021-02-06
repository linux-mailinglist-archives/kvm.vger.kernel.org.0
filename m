Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D08F31197B
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 04:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhBFDIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 22:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbhBFDAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 22:00:22 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A15C061756
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 18:54:59 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id s24so9269679iob.6
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 18:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0n2kQe6Y0rkYPGIxaii3uRmkeAX9j9VkOwutGU5Yf9k=;
        b=jTPnk9/urdkHAcQcemyp0OGkEeKgxUEpmZO4VEOW8xPKAfje+I+paPw/nIettagEz7
         dTjxMeC3HL20vmR7XQBTOIgGUD72jc7NrCdAICoyZIMIUlVa6dnj9hrrFZmsjr+4N5lc
         kXq1eU6kvv7YlkNWVzCgotyLl49LRnVzk7gGr7W/PZhjvjOpNsVW/8HEN4GO1bA5aCDU
         0Sh1RubMN4bNoUfl1LUAmThqi+7yQsHMHWDFBxje5OwTxNnRIuqy79W1xVBRYfQ1QDgi
         F+oFvegKXLVgh7EZL2waA+0wiFp7wdJF0Jv00oGmoOQW/Dt2x0EbsykMS+pJTCA3k2an
         ilTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0n2kQe6Y0rkYPGIxaii3uRmkeAX9j9VkOwutGU5Yf9k=;
        b=Sc014ygh+uCH8c9sgn+Tf6mzxoZe07v5oth13oT03m1+0eG7etOfDNyF24HUi4BI4A
         fA1yYifx6uMPByW/L/JidwCrFsxyAa3mN4+NhwPI1E2wDfJ6+Jzhhm6lDvdkZthNnrXa
         wDdr+bjCpdrQQlxM+uVeaUpncz6otK5Or/mC+5XqNWc69XcNd5xsd7Pb682vjeSNPLUr
         G/1kSbiT7E09y9vq31/5nLRMh7kU0Wvjnobti1xXGnHAOmh7yuog4CLi4y5dWZYR0OFd
         6YQFWyZoAnW6EmalZff0EWGeMWPk+Oha1YGBBCB6F26QYBUbZe9Ey4GuoZQHtv1K10l8
         6hxQ==
X-Gm-Message-State: AOAM530jLGPT9q6AYrjl136Me9+3rZc+Yy/nPu88CIkLE1xUIyTq/gEl
        r/tuw7jpILiieh/LReX3uJzNxkbg9kSjhy3Of7jBCQ==
X-Google-Smtp-Source: ABdhPJwY3Z28XHsA1wBeNY2A2kc3Z+xIEoVegt0ntEj6fHaxhVAjv3AB76N5/7NbKbE/aPJbcNjbT7T96ktAhgFDkcg=
X-Received: by 2002:a5d:9588:: with SMTP id a8mr6877849ioo.34.1612580098374;
 Fri, 05 Feb 2021 18:54:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612398155.git.ashish.kalra@amd.com> <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
 <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com> <20210205030753.GA26504@ashkalra_ubuntu_server>
In-Reply-To: <20210205030753.GA26504@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 5 Feb 2021 18:54:21 -0800
Message-ID: <CABayD+eVwUsnB9pt+GA92uJis5dEGZ=zcrzraaR8_=YhuLTntg@mail.gmail.com>
Subject: Re: [PATCH v10 12/16] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION
 feature & Custom MSR.
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 4, 2021 at 7:08 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> Hello Steve,
>
> On Thu, Feb 04, 2021 at 04:56:35PM -0800, Steve Rutherford wrote:
> > On Wed, Feb 3, 2021 at 4:39 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > >
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> > >
> > > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > > for host-side support for SEV live migration. Also add a new custom
> > > MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> > > feature.
> > >
> > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > ---
> > >  Documentation/virt/kvm/cpuid.rst     |  5 +++++
> > >  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
> > >  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
> > >  arch/x86/kvm/svm/sev.c               | 13 +++++++++++++
> > >  arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
> > >  arch/x86/kvm/svm/svm.h               |  2 ++
> > >  6 files changed, 52 insertions(+)
> > >
> > > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > > index cf62162d4be2..0bdb6cdb12d3 100644
> > > --- a/Documentation/virt/kvm/cpuid.rst
> > > +++ b/Documentation/virt/kvm/cpuid.rst
> > > @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
> > >                                                 before using extended destination
> > >                                                 ID bits in MSI address bits 11-5.
> > >
> > > +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> > > +                                               using the page encryption state
> > > +                                               hypercall to notify the page state
> > > +                                               change
> > > +
> > >  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
> > >                                                 per-cpu warps are expected in
> > >                                                 kvmclock
> > > diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> > > index e37a14c323d2..020245d16087 100644
> > > --- a/Documentation/virt/kvm/msr.rst
> > > +++ b/Documentation/virt/kvm/msr.rst
> > > @@ -376,3 +376,15 @@ data:
> > >         write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
> > >         and check if there are more notifications pending. The MSR is available
> > >         if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> > > +
> > > +MSR_KVM_SEV_LIVE_MIGRATION:
> > > +        0x4b564d08
> > > +
> > > +       Control SEV Live Migration features.
> > > +
> > > +data:
> > > +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> > > +        in other words, this is guest->host communication that it's properly
> > > +        handling the shared pages list.
> > > +
> > > +        All other bits are reserved.
> > > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > > index 950afebfba88..f6bfa138874f 100644
> > > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > > @@ -33,6 +33,7 @@
> > >  #define KVM_FEATURE_PV_SCHED_YIELD     13
> > >  #define KVM_FEATURE_ASYNC_PF_INT       14
> > >  #define KVM_FEATURE_MSI_EXT_DEST_ID    15
> > > +#define KVM_FEATURE_SEV_LIVE_MIGRATION 16
> > >
> > >  #define KVM_HINTS_REALTIME      0
> > >
> > > @@ -54,6 +55,7 @@
> > >  #define MSR_KVM_POLL_CONTROL   0x4b564d05
> > >  #define MSR_KVM_ASYNC_PF_INT   0x4b564d06
> > >  #define MSR_KVM_ASYNC_PF_ACK   0x4b564d07
> > > +#define MSR_KVM_SEV_LIVE_MIGRATION     0x4b564d08
> > >
> > >  struct kvm_steal_time {
> > >         __u64 steal;
> > > @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
> > >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> > >  #define KVM_PV_EOI_DISABLED 0x0
> > >
> > > +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> > > +
> > >  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index b0d324aed515..93f42b3d3e33 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > >         return ret;
> > >  }
> > >
> > > +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> > > +{
> > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > +
> > > +       if (!sev_guest(kvm))
> > > +               return;
> >
> > This should assert that userspace wanted the guest to be able to make
> > these calls (see more below).
> >
> > >
> > > +
> > > +       sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);
> > > +}
> > > +
> > >  int svm_get_shared_pages_list(struct kvm *kvm,
> > >                               struct kvm_shared_pages_list *list)
> > >  {
> > > @@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
> > >         if (!sev_guest(kvm))
> > >                 return -ENOTTY;
> > >
> > > +       if (!sev->live_migration_enabled)
> > > +               return -EINVAL;

This is currently under guest control, so I'm not certain this is
helpful. If I called this with otherwise valid parameters, and got
back -EINVAL, I would probably think the bug is on my end. But it
could be on the guest's end! I would probably drop this, but you could
have KVM return an empty list of regions when this happens.

Alternatively, as explained below, this could call guest_pv_has instead.

>
> > > +
> > >         if (!list->size)
> > >                 return -EINVAL;
> > >
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 58f89f83caab..43ea5061926f 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > >                 svm->msr_decfg = data;
> > >                 break;
> > >         }
> > > +       case MSR_KVM_SEV_LIVE_MIGRATION:
> > > +               sev_update_migration_flags(vcpu->kvm, data);
> > > +               break;
> > >         case MSR_IA32_APICBASE:
> > >                 if (kvm_vcpu_apicv_active(vcpu))
> > >                         avic_update_vapic_bar(to_svm(vcpu), data);
> > > @@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >                         vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
> > >         }
> > >
> > > +       /*
> > > +        * If SEV guest then enable the Live migration feature.
> > > +        */
> > > +       if (sev_guest(vcpu->kvm)) {
> > > +               struct kvm_cpuid_entry2 *best;
> > > +
> > > +               best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > > +               if (!best)
> > > +                       return;
> > > +
> > > +               best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> > > +       }
> > > +
> >
> > Looking at this, I believe the only way for this bit to get enabled is
> > if userspace toggles it. There needs to be a way for userspace to
> > identify if the kernel underneath them does, in fact, support SEV LM.
> > I'm at risk for having misread these patches (it's a long series), but
> > I don't see anything that communicates upwards.
> >
> > This could go upward with the other paravirt features flags in
> > cpuid.c. It could also be an explicit KVM Capability (checked through
> > check_extension).
> >
> > Userspace should then have a chance to decide whether or not this
> > should be enabled. And when it's not enabled, the host should return a
> > GP in response to the hypercall. This could be configured either
> > through userspace stripping out the LM feature bit, or by calling a VM
> > scoped enable cap (KVM_VM_IOCTL_ENABLE_CAP).
> >
> > I believe the typical path for a feature like this to be configured
> > would be to use ENABLE_CAP.
>
> I believe we have discussed and reviewed this earlier too.
>
> To summarize this feature, the host indicates if it supports the Live
> Migration feature and the feature and the hypercall are only enabled on
> the host when the guest checks for this support and does a wrmsrl() to
> enable the feature. Also the guest will not make the hypercall if the
> host does not indicate support for it.

I've gone through and read this patch a bit more closely, and the
surrounding code. Previously, I clearly misread this and the
surrounding space.

What happens if the guest just writes to the MSR anyway? Even if it
didn't receive a cue to do so? I believe the hypercall would still get
invoked here, since the hypercall does not check if SEV live migration
is enabled. Similarly, the MSR for enabling it is always available,
even if userspace didn't ask for the cpuid bit to be set. This should
not happen. Userspace should be in control of a new hypercall rolling
out.

I believe my interpretation last time was that the cpuid bit was
getting surfaced from the host kernel to host userspace, but I don't
actually see that in this patch series. Another way to ask this
question would be "How does userspace know the kernel they are on has
this patch series?". It needs some way of checking whether or not the
kernel underneath it supports SEV live migration. Technically, I think
userspace could call get_cpuid, set_cpuid (with the same values), and
then get_cpuid again, and it would be able to infer by checking the
SEV LM feature flag in the KVM leaf. This seems a bit kludgy. Checking
support should be easy.

An additional question is "how does userspace choose whether live
migration is advertised to the guest"? I believe userspace's desire
for a particular value of the paravirt feature flag in CPUID get's
overridden when they call set cpuid, since the feature flag is set in
svm_vcpu_after_set_cpuid regardless of what userspace asks for.
Userspace should have a choice in the matter.

Looking at similar paravirt-y features, there's precedent for another
way of doing this (may be preferred over CHECK_EXTENSION/ENABLE_CAP?):
this could call guest_pv_has before running the hypercall. The feature
(KVM_FEATURE_SEV_LIVE_MIGRATION) would then need to be exposed with
the other paravirt features in __do_cpuid_func. The function
guest_pv_has would represent if userspace has decided to expose SEV
live migration to the guest, and the sev->live_migration_enabled would
indicate if the guest responded affirmatively to the CPUID bit.

The downside of using guest_pv_has is that, if pv enforcement is
disabled, guest_pv_has will always return true, which seems a bit odd
for a non-SEV guest. This isn't a deal breaker, but seems a bit odd
for say, a guest that isn't even running SEV. Using CHECK_EXTENSION
and ENABLE_CAP sidestep that. I'm also not certain I would call this a
paravirt feature.

> And these were your review comments on the above :
> I see I misunderstood how the CPUID bits get passed
> through: usermode can still override them. Forgot about the back and
> forth for CPUID with usermode.
>
> So as you mentioned, userspace can still override these and it gets a
> chance to decide whether or not this should be enabled.
>
> Thanks,
> Ashish


Thanks,
Steve
