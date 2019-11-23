Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF2F2107BF9
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 01:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfKWAW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 19:22:28 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40213 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWAW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 19:22:28 -0500
Received: by mail-io1-f66.google.com with SMTP id b26so8259951ion.7
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 16:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OJiKa/nOf3Di2MymEJ8+BVE7LhjX9sa8ESWUBAYCXdw=;
        b=sqhCatqtmrAcqG5zu401qANQp9xOLzsqa2+vPRmTCE1uuCtLXysZNtrho9Udoep9OH
         j8+U62DvmgRDpKGBz923+BkZm+5binXPPiNzZ3m98+T9CfRURUDa60429URRUCvOygW+
         L6Naw5AiIsZl0DFPIE3Dp2o8zEj007Zko+YL8uVBCuQ6FglQGbAYJ/iaLY+oFsABjvjr
         VK4XlHDIyEfj4EiGXdVd0rGkdalgUfvXaDYAKmkFeBWHET5GJttwoPOTuLxCEVkkd0Dp
         VVSZcwmr0UdQzbKRhPLZRvmugpcJ8MTSWyUWPhImiUU7OaOdMgZS2XKrcro5JKnU92eb
         JOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OJiKa/nOf3Di2MymEJ8+BVE7LhjX9sa8ESWUBAYCXdw=;
        b=Y8YbWF9H1CTLD8pkZzSCc1Tr5myx0rLeHD7r86ioErxhLMDqN3Bg1uKm2KzT/8tgq0
         GBrWaHMY82BrHLrZLyvGZkNIGSe97DkewIiAUsLeHuy98xMqbs0mk6bix2MHSSM5m7t/
         rK580NIIaNm+KR7wELv0zdHtHd9K0svesuCXjhd6Co8jPzW0sgSln+eHTTKxZm5tnoTj
         RrQ9bm1dBhBREA1gypYMLRE0XJJ1ZebJ6g/OyYg4roZnFpagABWg7OSdKV7hh3izvTzS
         IYCZGN0SV7qZgywYUdRJKYUKKvHA26gNlgF435FK6nVHuEVsQhYb/o8yicON30BWUHaa
         +B7g==
X-Gm-Message-State: APjAAAUAb7ViNFqDCHuIp4Osl0IgLLCZKy6XYb1CI0Nn7V7fSqKEQXze
        S9WwM8+HPpddnkUedeZfxdOaci7GlcMsiKChyhmtlg==
X-Google-Smtp-Source: APXvYqyHaOzZf9M7XbPodEzuxV2qHiEBNNs+OtpFiDDL9m84rfOiqTyhjorw3tub77L1TKTHQ3RvuCl+d/GUxXW8Gm4=
X-Received: by 2002:a5d:9153:: with SMTP id y19mr15825520ioq.26.1574468547017;
 Fri, 22 Nov 2019 16:22:27 -0800 (PST)
MIME-Version: 1.0
References: <20191122234355.174998-1-jmattson@google.com> <97EE5F0F-3047-46BC-B569-D407B5800499@oracle.com>
In-Reply-To: <97EE5F0F-3047-46BC-B569-D407B5800499@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Nov 2019 16:22:15 -0800
Message-ID: <CALMp9eTLQrFprNoYtXa2MCiAGnHuf4Rqxxh33cXD936boxMEwg@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: Relax guest IA32_FEATURE_CONTROL constraints
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 3:57 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 23 Nov 2019, at 1:43, Jim Mattson <jmattson@google.com> wrote:
> >
> > Commit 37e4c997dadf ("KVM: VMX: validate individual bits of guest
> > MSR_IA32_FEATURE_CONTROL") broke the KVM_SET_MSRS ABI by instituting
> > new constraints on the data values that kvm would accept for the guest
> > MSR, IA32_FEATURE_CONTROL. Perhaps these constraints should have been
> > opt-in via a new KVM capability, but they were applied
> > indiscriminately, breaking at least one existing hypervisor.
> >
> > Relax the constraints to allow either or both of
> > FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX and
> > FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX to be set when nVMX is
> > enabled. This change is sufficient to fix the aforementioned breakage.
> >
> > Fixes: 37e4c997dadf ("KVM: VMX: validate individual bits of guest MSR_I=
A32_FEATURE_CONTROL")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
>
> I suggest to also add a comment in code to clarify why we allow setting
> FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX even though we expose a vCPU tha=
t doesn=E2=80=99t support Intel TXT.
> (I think the compatibility to existing workloads that sets this blindly o=
n boot is a legit reason. Just recommend documenting it.)
>
> In addition, if the nested hypervisor which relies on this is public, ple=
ase also mention it in commit message for reference.

It's not an L1 hypervisor that's the problem. It's Google's L0
hypervisor. We've been incorrectly reporting IA32_FEATURE_CONTROL as 7
to nested guests for years, and now we have thousands of running VMs
with the bogus value. I've thought about just changing it to 5 on the
fly (on real hardware, one could almost blame it on SMM, but the MSR
is *locked*, after all).

> Reviewed-by: Liran Alon <liran.alon@oracle.com>
>
> > ---
> > arch/x86/kvm/vmx/vmx.c | 4 +++-
> > 1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 04a8212704c17..9f46023451810 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7097,10 +7097,12 @@ static void vmx_cpuid_update(struct kvm_vcpu *v=
cpu)
> >
> >       if (nested_vmx_allowed(vcpu))
> >               to_vmx(vcpu)->msr_ia32_feature_control_valid_bits |=3D
> > +                     FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX |
> >                       FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
> >       else
> >               to_vmx(vcpu)->msr_ia32_feature_control_valid_bits &=3D
> > -                     ~FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
> > +                     ~(FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX |
> > +                       FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX);
> >
> >       if (nested_vmx_allowed(vcpu)) {
> >               nested_vmx_cr_fixed1_bits_update(vcpu);
> > --
> > 2.24.0.432.g9d3f5f5b63-goog
> >
>
