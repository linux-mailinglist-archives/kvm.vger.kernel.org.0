Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1107314336
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 23:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBHWvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 17:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhBHWvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 17:51:31 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898A9C061788
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 14:50:51 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id e133so16768727iof.8
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 14:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8c+yB1qlK1ryFKsET6Kdo+DhhdjEW/570SBj9yRO/E4=;
        b=O1bOiYqoHYbW8H2dvLtd4BbojpqQgNaHk/34/+dq5vnMlD8neHv9jX1SKTzIJuTWCP
         tda7JfvG/Z7K2cBEOjwFfTZNBq1lb43me0Q9SOKgrUjmj6zcVaWTmjTxqV6vMljzt5LD
         jegWrYI6+aJAUZeN+tSPMzTOg7QlLIOPV8ZNx8IpQIeZfmZg71WQn61pNoLscKoj0lo2
         V2KOGtKHvXnTYJhIdWJq3RVL3ACBb2iJPIUrLjPtgE4rXaKgYGtu7uB6VQt7ghxZ97GM
         Z8IdMa8NoGAlRBw0AOIh7hKRMvGSZ+1e86sm7DeqxIsW/TLWw5dOlF9JiOz/vulqHNwz
         9wsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8c+yB1qlK1ryFKsET6Kdo+DhhdjEW/570SBj9yRO/E4=;
        b=BNh9pUx1xEdYc3VjNHrlR//ytOqkH74mwgs/fCDajWGNRNqypiv//fEKhv+zxaoKAm
         OaeeIiQrvnT3sDUuNtxgusSjMZkpjZYzdVyDFSxmnnjsdMeCk9qIYvOXdag0Motx6W4T
         OW1BUAZpr/pvgT0vA9faTuDTGBr6Bq0mhV5lE3UeO+ojNrM/bPRIt3cIYEzumkjzVwgg
         zPcSWPjpYGSd5wGsmfL61j/AIGqPoj+FAcSktM1ttiV5nTnC8gZKsnPrROeWZVv41oZN
         PTrSORmBYNsGHcI2ojeAyVAab1sgWvE9Iv3O4uko+gX965mPVHEbQdiYiFVYTvapjyMY
         B5tA==
X-Gm-Message-State: AOAM530OY8bIAVRErb2c0Y53S6W8OByGzXewWKU17kMCVGbsIx2qkCgO
        3QCrpk3k5QSHT5t0yC3bOU1uleH2WEXULyIutXXqLQ==
X-Google-Smtp-Source: ABdhPJxvr3om5tATbFqL2NAwmRowb+jj0sQCgFNP10/jqBdI93q4wS9MRE0vUxNQi3qP8MU9r0IbmFOp/3XIe04sGpQ=
X-Received: by 2002:a05:6602:22d7:: with SMTP id e23mr13936936ioe.156.1612824650606;
 Mon, 08 Feb 2021 14:50:50 -0800 (PST)
MIME-Version: 1.0
References: <cover.1612398155.git.ashish.kalra@amd.com> <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
 <CABayD+fBrNA_Oz542D5zoLqoispQG=1LWgHt2b5vr8hTMOveOQ@mail.gmail.com>
 <20210205030753.GA26504@ashkalra_ubuntu_server> <CABayD+eVwUsnB9pt+GA92uJis5dEGZ=zcrzraaR8_=YhuLTntg@mail.gmail.com>
 <20210206054617.GA19422@ashkalra_ubuntu_server> <20210206135646.GA21650@ashkalra_ubuntu_server>
 <20210208002858.GA23612@ashkalra_ubuntu_server>
In-Reply-To: <20210208002858.GA23612@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 8 Feb 2021 14:50:14 -0800
Message-ID: <CABayD+dB3fJ-YmZZ2qsP7ud-E+R8McjVmVXB4ER4Dmk18cAvoA@mail.gmail.com>
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

Hi Ashish,

On Sun, Feb 7, 2021 at 4:29 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> Hello Steve,
>
> On Sat, Feb 06, 2021 at 01:56:46PM +0000, Ashish Kalra wrote:
> > Hello Steve,
> >
> > On Sat, Feb 06, 2021 at 05:46:17AM +0000, Ashish Kalra wrote:
> > > Hello Steve,
> > >
> > > Continued response to your queries, especially related to userspace
> > > control of SEV live migration feature :
> > >
> > > On Fri, Feb 05, 2021 at 06:54:21PM -0800, Steve Rutherford wrote:
> > > > On Thu, Feb 4, 2021 at 7:08 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > >
> > > > > Hello Steve,
> > > > >
> > > > > On Thu, Feb 04, 2021 at 04:56:35PM -0800, Steve Rutherford wrote:
> > > > > > On Wed, Feb 3, 2021 at 4:39 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > > > > >
> > > > > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > > > > >
> > > > > > > Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> > > > > > > for host-side support for SEV live migration. Also add a new custom
> > > > > > > MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> > > > > > > feature.
> > > > > > >
> > > > > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > > > > ---
> > > > > > >  Documentation/virt/kvm/cpuid.rst     |  5 +++++
> > > > > > >  Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
> > > > > > >  arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
> > > > > > >  arch/x86/kvm/svm/sev.c               | 13 +++++++++++++
> > > > > > >  arch/x86/kvm/svm/svm.c               | 16 ++++++++++++++++
> > > > > > >  arch/x86/kvm/svm/svm.h               |  2 ++
> > > > > > >  6 files changed, 52 insertions(+)
> > > > > > >
> > > > > > > diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> > > > > > > index cf62162d4be2..0bdb6cdb12d3 100644
> > > > > > > --- a/Documentation/virt/kvm/cpuid.rst
> > > > > > > +++ b/Documentation/virt/kvm/cpuid.rst
> > > > > > > @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
> > > > > > >                                                 before using extended destination
> > > > > > >                                                 ID bits in MSI address bits 11-5.
> > > > > > >
> > > > > > > +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> > > > > > > +                                               using the page encryption state
> > > > > > > +                                               hypercall to notify the page state
> > > > > > > +                                               change
> > > > > > > +
> > > > > > >  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
> > > > > > >                                                 per-cpu warps are expected in
> > > > > > >                                                 kvmclock
> > > > > > > diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> > > > > > > index e37a14c323d2..020245d16087 100644
> > > > > > > --- a/Documentation/virt/kvm/msr.rst
> > > > > > > +++ b/Documentation/virt/kvm/msr.rst
> > > > > > > @@ -376,3 +376,15 @@ data:
> > > > > > >         write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
> > > > > > >         and check if there are more notifications pending. The MSR is available
> > > > > > >         if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> > > > > > > +
> > > > > > > +MSR_KVM_SEV_LIVE_MIGRATION:
> > > > > > > +        0x4b564d08
> > > > > > > +
> > > > > > > +       Control SEV Live Migration features.
> > > > > > > +
> > > > > > > +data:
> > > > > > > +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> > > > > > > +        in other words, this is guest->host communication that it's properly
> > > > > > > +        handling the shared pages list.
> > > > > > > +
> > > > > > > +        All other bits are reserved.
> > > > > > > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > > index 950afebfba88..f6bfa138874f 100644
> > > > > > > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > > @@ -33,6 +33,7 @@
> > > > > > >  #define KVM_FEATURE_PV_SCHED_YIELD     13
> > > > > > >  #define KVM_FEATURE_ASYNC_PF_INT       14
> > > > > > >  #define KVM_FEATURE_MSI_EXT_DEST_ID    15
> > > > > > > +#define KVM_FEATURE_SEV_LIVE_MIGRATION 16
> > > > > > >
> > > > > > >  #define KVM_HINTS_REALTIME      0
> > > > > > >
> > > > > > > @@ -54,6 +55,7 @@
> > > > > > >  #define MSR_KVM_POLL_CONTROL   0x4b564d05
> > > > > > >  #define MSR_KVM_ASYNC_PF_INT   0x4b564d06
> > > > > > >  #define MSR_KVM_ASYNC_PF_ACK   0x4b564d07
> > > > > > > +#define MSR_KVM_SEV_LIVE_MIGRATION     0x4b564d08
> > > > > > >
> > > > > > >  struct kvm_steal_time {
> > > > > > >         __u64 steal;
> > > > > > > @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
> > > > > > >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> > > > > > >  #define KVM_PV_EOI_DISABLED 0x0
> > > > > > >
> > > > > > > +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> > > > > > > +
> > > > > > >  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> > > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > > index b0d324aed515..93f42b3d3e33 100644
> > > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > > @@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > > > > > >         return ret;
> > > > > > >  }
> > > > > > >
> > > > > > > +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> > > > > > > +{
> > > > > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > > > > +
> > > > > > > +       if (!sev_guest(kvm))
> > > > > > > +               return;
> > > > > >
> > > > > > This should assert that userspace wanted the guest to be able to make
> > > > > > these calls (see more below).
> > > > > >
> > > > > > >
> > > > > > > +
> > > > > > > +       sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);
> > > > > > > +}
> > > > > > > +
> > > > > > >  int svm_get_shared_pages_list(struct kvm *kvm,
> > > > > > >                               struct kvm_shared_pages_list *list)
> > > > > > >  {
> > > > > > > @@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
> > > > > > >         if (!sev_guest(kvm))
> > > > > > >                 return -ENOTTY;
> > > > > > >
> > > > > > > +       if (!sev->live_migration_enabled)
> > > > > > > +               return -EINVAL;
> > > >
> > > > This is currently under guest control, so I'm not certain this is
> > > > helpful. If I called this with otherwise valid parameters, and got
> > > > back -EINVAL, I would probably think the bug is on my end. But it
> > > > could be on the guest's end! I would probably drop this, but you could
> > > > have KVM return an empty list of regions when this happens.
> > > >
> > > > Alternatively, as explained below, this could call guest_pv_has instead.
> > > >
> > > > >
> > > > > > > +
> > > > > > >         if (!list->size)
> > > > > > >                 return -EINVAL;
> > > > > > >
> > > > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > > > index 58f89f83caab..43ea5061926f 100644
> > > > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > > > @@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > > > > > >                 svm->msr_decfg = data;
> > > > > > >                 break;
> > > > > > >         }
> > > > > > > +       case MSR_KVM_SEV_LIVE_MIGRATION:
> > > > > > > +               sev_update_migration_flags(vcpu->kvm, data);
> > > > > > > +               break;
> > > > > > >         case MSR_IA32_APICBASE:
> > > > > > >                 if (kvm_vcpu_apicv_active(vcpu))
> > > > > > >                         avic_update_vapic_bar(to_svm(vcpu), data);
> > > > > > > @@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > > > > >                         vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
> > > > > > >         }
> > > > > > >
> > > > > > > +       /*
> > > > > > > +        * If SEV guest then enable the Live migration feature.
> > > > > > > +        */
> > > > > > > +       if (sev_guest(vcpu->kvm)) {
> > > > > > > +               struct kvm_cpuid_entry2 *best;
> > > > > > > +
> > > > > > > +               best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> > > > > > > +               if (!best)
> > > > > > > +                       return;
> > > > > > > +
> > > > > > > +               best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
> > > > > > > +       }
> > > > > > > +
> > > > > >
> > > > > > Looking at this, I believe the only way for this bit to get enabled is
> > > > > > if userspace toggles it. There needs to be a way for userspace to
> > > > > > identify if the kernel underneath them does, in fact, support SEV LM.
> > > > > > I'm at risk for having misread these patches (it's a long series), but
> > > > > > I don't see anything that communicates upwards.
> > > > > >
> > > > > > This could go upward with the other paravirt features flags in
> > > > > > cpuid.c. It could also be an explicit KVM Capability (checked through
> > > > > > check_extension).
> > > > > >
> > > > > > Userspace should then have a chance to decide whether or not this
> > > > > > should be enabled. And when it's not enabled, the host should return a
> > > > > > GP in response to the hypercall. This could be configured either
> > > > > > through userspace stripping out the LM feature bit, or by calling a VM
> > > > > > scoped enable cap (KVM_VM_IOCTL_ENABLE_CAP).
> > > > > >
> > > > > > I believe the typical path for a feature like this to be configured
> > > > > > would be to use ENABLE_CAP.
> > > > >
> > > > > I believe we have discussed and reviewed this earlier too.
> > > > >
> > > > > To summarize this feature, the host indicates if it supports the Live
> > > > > Migration feature and the feature and the hypercall are only enabled on
> > > > > the host when the guest checks for this support and does a wrmsrl() to
> > > > > enable the feature. Also the guest will not make the hypercall if the
> > > > > host does not indicate support for it.
> > > >
> > > > I've gone through and read this patch a bit more closely, and the
> > > > surrounding code. Previously, I clearly misread this and the
> > > > surrounding space.
> > > >
> > > > What happens if the guest just writes to the MSR anyway? Even if it
> > > > didn't receive a cue to do so? I believe the hypercall would still get
> > > > invoked here, since the hypercall does not check if SEV live migration
> > > > is enabled. Similarly, the MSR for enabling it is always available,
> > > > even if userspace didn't ask for the cpuid bit to be set. This should
> > > > not happen. Userspace should be in control of a new hypercall rolling
> > > > out.
> > > >
> > > > I believe my interpretation last time was that the cpuid bit was
> > > > getting surfaced from the host kernel to host userspace, but I don't
> > > > actually see that in this patch series. Another way to ask this
> > > > question would be "How does userspace know the kernel they are on has
> > > > this patch series?". It needs some way of checking whether or not the
> > > > kernel underneath it supports SEV live migration. Technically, I think
> > > > userspace could call get_cpuid, set_cpuid (with the same values), and
> > > > then get_cpuid again, and it would be able to infer by checking the
> > > > SEV LM feature flag in the KVM leaf. This seems a bit kludgy. Checking
> > > > support should be easy.
> > > >
> > > > An additional question is "how does userspace choose whether live
> > > > migration is advertised to the guest"? I believe userspace's desire
> > > > for a particular value of the paravirt feature flag in CPUID get's
> > > > overridden when they call set cpuid, since the feature flag is set in
> > > > svm_vcpu_after_set_cpuid regardless of what userspace asks for.
> > > > Userspace should have a choice in the matter.
> > > >
> >
> > Actually i did some more analysis of this, and i believe you are right
> > about the above, feature flag gets set in svm_vcpu_after_set_cpuid.
> >
>
> As you mentioned above and as i confirmed in my previous email,
> calling KVM_SET_CPUID2 vcpu ioctl will always set the live migration
> feature flag for the vCPU.
>
> This is what will be queried by the guest to enable the kernel's
> live migration feature and to start making hypercalls.
>
> Now, i want to understand why do you want the userspace to have a
> choice in this matter ?
Kernel rollout risk is a pretty big factor:
1) Feature flagging is a pretty common risk mitigation for new features.
2) Without userspace being able to intervene, the kernel rollout
becomes a feature rollout.

IIUC, as soon as new VMs started running on this host kernel, they
would immediately start calling the hypercall if they had the guest
patches, even if they did not do so on older versions of the host
kernel.

>
> After all, it is the userspace which actually initiates the live
> migration process, so doesn't it have the final choice in this
> matter ?
With the current implementation, userspace has the final say in the
migration, but not the final say in whether or not that particular
hypercall is used by the guest. If a customer showed up, and said
"don't have my guest migrate", there is no way for the host to tell
the guest "hey, we're not even listening to what you're sending over
the hypercall". IIRC, there is an SEV Policy bit for migration
enablement, but even if it were set to false, that guest would still
update the host about its unencrypted regions.

Right now, the host can't even remove the feature bit from CPUID
(since its desire would be overridden post-set), so it doesn't have
the ability to tell the guest to hang up the phone. And even if we
could tell the guest through CPUID, if the guest ignored what we told
it, it could still send data down anyway! If there were a bug in this
implementation that we missed, the only way to avoid it would be to
roll out a new kernel, which is pretty heavy handed. If you could just
disable the feature (or never enable it in the first place), that
would be much less costly.

> Even if this feature is reported by host, the guest only uses
> it to enable and make page encryption status hypercalls
> and the host's shared pages list gets setup accordingly.
>
> But unless userspace calls KVM_GET_SHARED_PAGES_LIST ioctl and
> initiates live migration process, the above is simply enabling
> the guest to make hypercalls whenever a page's encryption
> status is changed.
>
> Thanks,
> Ashish

Thanks,
Steve
