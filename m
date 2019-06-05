Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A9635AB8
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 12:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfFEK4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 06:56:34 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42712 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFEK4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 06:56:34 -0400
Received: by mail-oi1-f194.google.com with SMTP id s184so6829089oie.9;
        Wed, 05 Jun 2019 03:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UitpZkq4NAYEkPuSk5JVXv2jvPJzGCS3S2Czf95ERP0=;
        b=aU0laK5mJhXzqlrKdeEmun/nyOR3MFIs8LU/KeMA1EEhXlmY1EiOo2WjVEdXNvqd9D
         sGCKfeACNPSRSPrTFJ4kAo4Rdlvu9c5sdfv7GoXU5I55+ike/lfrCcU3G2ZcHUiiU/eY
         KGlbK8EDCYwCCBw4cYA71KNxbaYhIEAu5An/MEWKs9kAcepkC1aUxuYDfxVUV47SjE6Z
         EBQ16s5RYUvrPFNVEHKh8Fdqdy7D0A9muTIPhupM54W5BAtRJh2Z8eNjE+WtLIdQP25Y
         GZqq/8StXafuFUSfDs3mlwVxfWhn0mUcvIwHO9nIkBNdikyYV9+D1ZGXuoQN20BDNmxK
         2Uag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UitpZkq4NAYEkPuSk5JVXv2jvPJzGCS3S2Czf95ERP0=;
        b=mhRhhqML7vrLY55Agfp7uGXdc3YUD/zZgd6K7qdZYaskRhPP2ZuU42Cl0SagBHOHSl
         1BiQRHwPcUU6g91ocAUG0aIWVBNPj9Mhl6FOsCyaeS5cC++TIivbixqqXDdDo8J1uF0Y
         is8V2mmTGkWRdAboQHFIfdQ4py9ff8iTLh42XQJHu3EDyKvx0UFjHoACGGlb5YWDmsze
         kPYnePkXZaOyhI7asJuwXB/7RxfCq5t6jiOQPFbrIs+uUX3WbNFJq6e3o4eUhyeK2V8R
         Jhee4DP3gtVo80OyvGDSXEa1XnW3SEhunfVBdel4IpbQuTzG3TlPE6f1oukTBwodcdgn
         FubA==
X-Gm-Message-State: APjAAAWm90Vbt0MwhEyKpq1KwMpX716p31gQgZoHaeivyFDatMWgqj3d
        7LK/R4k7QgIwwsB6wZIul1ajwNiQP71cNj8RYac=
X-Google-Smtp-Source: APXvYqzRUo/s3TX6dlNif/a2CHEqvkm6rp6qIbtOQxbYI4Qm8SnkTg4BAOfsBFqzCJq7srW22CVfIcEGATOIkbxifKU=
X-Received: by 2002:aca:3305:: with SMTP id z5mr7915698oiz.141.1559732193618;
 Wed, 05 Jun 2019 03:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
 <1558418814-6822-2-git-send-email-wanpengli@tencent.com> <627e4189-3709-1fb2-a9bc-f1a577712fe0@redhat.com>
In-Reply-To: <627e4189-3709-1fb2-a9bc-f1a577712fe0@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 5 Jun 2019 18:56:59 +0800
Message-ID: <CANRm+CxHXEg15FK9AOaNinWgwGpTuSt=xDzw+PJO6xGgX+9MWQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: X86: Provide a capability to disable cstate
 msr read intercepts
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Jun 2019 at 00:53, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/05/19 08:06, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Allow guest reads CORE cstate when exposing host CPU power management c=
apabilities
> > to the guest. PKG cstate is restricted to avoid a guest to get the whol=
e package
> > information in multi-tenant scenario.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v1 -> v2:
> >  * use a separate bit for KVM_CAP_X86_DISABLE_EXITS
> >
> >  Documentation/virtual/kvm/api.txt | 1 +
> >  arch/x86/include/asm/kvm_host.h   | 1 +
> >  arch/x86/kvm/vmx/vmx.c            | 6 ++++++
> >  arch/x86/kvm/x86.c                | 5 ++++-
> >  arch/x86/kvm/x86.h                | 5 +++++
> >  include/uapi/linux/kvm.h          | 4 +++-
> >  tools/include/uapi/linux/kvm.h    | 4 +++-
> >  7 files changed, 23 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
> > index 33cd92d..91fd86f 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -4894,6 +4894,7 @@ Valid bits in args[0] are
> >  #define KVM_X86_DISABLE_EXITS_MWAIT            (1 << 0)
> >  #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
> >  #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
> > +#define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
> >
> >  Enabling this capability on a VM provides userspace with a way to no
> >  longer intercept some instructions for improved latency in some
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index d5457c7..1ce8289 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -882,6 +882,7 @@ struct kvm_arch {
> >       bool mwait_in_guest;
> >       bool hlt_in_guest;
> >       bool pause_in_guest;
> > +     bool cstate_in_guest;
> >
> >       unsigned long irq_sources_bitmap;
> >       s64 kvmclock_offset;
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 0861c71..da24f18 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6637,6 +6637,12 @@ static struct kvm_vcpu *vmx_create_vcpu(struct k=
vm *kvm, unsigned int id)
> >       vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, M=
SR_TYPE_RW);
> >       vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, =
MSR_TYPE_RW);
> >       vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, =
MSR_TYPE_RW);
> > +     if (kvm_cstate_in_guest(kvm)) {
> > +             vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES=
, MSR_TYPE_R);
> > +             vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RES=
IDENCY, MSR_TYPE_R);
> > +             vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RES=
IDENCY, MSR_TYPE_R);
> > +             vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RES=
IDENCY, MSR_TYPE_R);
>
> I think I have changed my mind on the implementation of this, sorry.
>
> 1) We should emulate these MSRs always, otherwise the guest API changes
> between different values of KVM_CAP_X86_DISABLE_EXITS which is not
> intended.  Also, KVM_CAP_X86_DISABLE_EXITS does not prevent live
> migration, so it should be possible to set the MSRs in the host to
> change the delta between the host and guest values.
>
> 2) If both KVM_X86_DISABLE_EXITS_HLT and KVM_X86_DISABLE_EXITS_MWAIT are
> disabled (i.e. exit happens), the MSRs will be purely emulated.
> C3/C6/C7 residency will never increase (it will remain the value that is
> set by the host).  When the VM executes an hlt vmexit, it should save
> the current TSC.  When it comes back, the C1 residency MSR should be
> increased by the time that has passed.
>
> 3) If KVM_X86_DISABLE_EXITS_HLT is enabled but
> KVM_X86_DISABLE_EXITS_MWAIT is disabled (i.e. mait exits happen),
> C3/C6/C7 residency will also never increase, but the C1 residency value
> should be read using rdmsr from the host, with a delta added from the
> host value.
>
> 4) If KVM_X86_DISABLE_EXITS_HLT and KVM_X86_DISABLE_EXITS_MWAIT are both
> disabled (i.e. mwait exits do not happen), all four residency values
> should be read using rdmsr from the host, with a delta added from the
> host value.
>
> 5) If KVM_X86_DISABLE_EXITS_HLT is disabled and
> KVM_X86_DISABLE_EXITS_MWAIT is enabled, the configuration makes no sense
> so it's okay not to be very optimized.  In this case, the residency
> value should be read as in (4), but hlt vmexits will be accounted as in
> (2) so we need to be careful not to double-count the residency during
> hlt.  This means doing four rdmsr before the beginning of the hlt vmexit
> and four at the end of the hlt vmexit.

I will have a try, thanks Paolo! :)

Regards,
Wanpeng Li

>
> Therefore the data structure should be something like
>
> struct kvm_residency_msr {
>         u64 value;
>         bool delta_from_host;
>         bool count_with_host;
> }
>
> u64 kvm_residency_read_host(struct kvm_residency_msr *msr)
> {
>         u64 unscaled_value =3D rdmsrl(msr->index);
>         // apply TSC scaling...
>         return ...
> }
>
> u64 kvm_residency_read(struct kvm_residency_msr *msr)
> {
>         return msr->value +
>                 (msr->delta_from_host ? kvm_residency_read_host(msr) : 0)=
;
> }
>
> void kvm_residency_write(struct kvm_residency_msr *msr,
>                          u64 value)
> {
>         msr->value =3D value -
>                 (msr->delta_from_host ? kvm_residency_read_host(msr) : 0)=
;
> }
>
> // count_with_host is true for C1 iff any of KVM_CAP_DISABLE_EXITS_HLT
> // or KVM_CAP_DISABLE_EXITS_MWAIT is set
> // count_with_host is true for C3/C6/C7 iff KVM_CAP_DISABLE_EXITS_MWAIT
> is set
> void kvm_residency_setup(struct kvm_residency_msr *msr, u16 index,
>                          bool count_with_host)
> {
>         /* Preserve value on calls after the first */
>         u64 value =3D msr->index ? kvm_residency_read(msr) : 0;
>         msr->delta_from_host =3D msr->count_with_host =3D count_with_host=
;
>         msr->index =3D index;
>         kvm_residency_write(msr, value);
> }
>
> // The following functions are called from hlt vmexits.
>
> void kvm_residency_start_hlt(struct kvm_residency_msr *msr)
> {
>         if (msr->count_with_host) {
>                 WARN_ON(msr->delta_from_host);
>                 msr->value +=3D kvm_residency_read_host(msr);
>                 msr->delta_from_host =3D false;
>         }
> }
>
> // host_tsc_waited is 0 except for MSR_CORE_C1_RES
> void kvm_residency_end_hlt(struct kvm_residency_msr *msr,
>                            u64 host_tsc_waited)
> {
>         if (msr->count_with_host) {
>                 WARN_ON(!msr->delta_from_host);
>                 msr->value -=3D kvm_residency_read_host(msr);
>                 msr->delta_from_host =3D true;
>         }
>         if (host_tsc_waited) {
>                 // ... apply TSC scaling to host_tsc_waited ...
>                 msr->value +=3D ...;
>         }
> }
>
> Thanks,
>
> Paolo
