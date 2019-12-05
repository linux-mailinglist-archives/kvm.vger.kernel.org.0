Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025641148B5
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 22:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbfLEVax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 16:30:53 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33313 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbfLEVaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 16:30:52 -0500
Received: by mail-il1-f196.google.com with SMTP id r81so4373181ilk.0
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 13:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=REY3TuDh3Yo2pFvG9oHpYgHNYlrRV9H0l3wK1gd4r54=;
        b=j7KB4+SDuEEJVg8sN5qUNyhZ8oPBmJRGYhlzpom8z7cfT2F00CRnURcF2k8pF3l4OI
         haY+j9/4AEZPa9UdCvSEyOLe2D4D3f2TNMmGCstiR5WjQbfuchLW6UT5+kH7JCmcDKsN
         T7HLomKVRsss5/2Mm+u57ZmIUoUNhOJ/NfpcJQd9DBt+9QyzST9HsezwdSjBaP6HlqAF
         uRShz7E/iCZicr8iXB/WzGdYMmSVYeXf2Pay4eYsAS0vPuM9BI8O2eAJax2usU8iJFBH
         C9O3NJM8p9UfgHfLq7P1eYtaPO8L25jd/ZfDprJhbBBvldqCtcNqs48tlb6piPbym5Yw
         mEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=REY3TuDh3Yo2pFvG9oHpYgHNYlrRV9H0l3wK1gd4r54=;
        b=U5iEctcgflNjVfznzuHMf8Tka3JdMV6iWni7LN0CMV7csYxwz55BjIlXQvos9FFxQf
         V7m5wbKVI8mB6tZQa0qHtjk5/FpKHchg+Qc3I1/PEl9Ig5UfHpQ677VO4jAIIF8vaImS
         GAFdJrNN4PdqLJL64OOykWW2+bVlfpADbfwqImW819vqe12hgt8Z8Q0knB2TfoZl2hMB
         R1Rd7e+uzFE6/1yL2XWw9f/+utcq67zHgWtiLIHInTS3FDk225mJwsvfqm6oHrJv4wzP
         lbBgo3p2eUpqjEhEmrfCS8eZXRcazBYKaBiOUwg2VYTpUUFgYYDVnpCrtmKtc7WpJFEi
         RRVg==
X-Gm-Message-State: APjAAAUt0guARnx85+z0GnYO3nUuV1I9+PedvSZi2pdmguBXm4rF39km
        e4Qy7z/XJAWnPU3txQAQsHlekWBn6MUWkoGmo3MSnZheYuM=
X-Google-Smtp-Source: APXvYqwbHYqNmnH9LVzcN74/l+BGPCsvR9r9GKteDCmPZfhxIM0GZP8zF2lWvRQ2XTFPA/Txb4srM8PPm4bNZBFrpBw=
X-Received: by 2002:a92:1d1b:: with SMTP id d27mr10972175ild.118.1575581451403;
 Thu, 05 Dec 2019 13:30:51 -0800 (PST)
MIME-Version: 1.0
References: <20191204214027.85958-1-jmattson@google.com> <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
 <CALMp9eRbiKnH15NBFk0hrh8udcqZvu6RHm0Nrfh4TikQ3xF6OA@mail.gmail.com>
In-Reply-To: <CALMp9eRbiKnH15NBFk0hrh8udcqZvu6RHm0Nrfh4TikQ3xF6OA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Dec 2019 13:30:40 -0800
Message-ID: <CALMp9eTyhRwqsriLGg1xoO2sOPkgnKK1hV1U3C733xCjW7+VCA@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 5, 2019 at 5:11 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Thu, Dec 5, 2019 at 3:46 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 04/12/19 22:40, Jim Mattson wrote:
> > > According to the SDM, a VMWRITE in VMX non-root operation with an
> > > invalid VMCS-link pointer results in VMfailInvalid before the validity
> > > of the VMCS field in the secondary source operand is checked.
> > >
> > > Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if running L2")
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > Cc: Liran Alon <liran.alon@oracle.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 38 +++++++++++++++++++-------------------
> > >  1 file changed, 19 insertions(+), 19 deletions(-)
> >
> > As Vitaly pointed out, the test must be split in two, like this:
>
> Right. Odd that no kvm-unit-tests noticed.
>
> > ---------------- 8< -----------------------
> > From 3b9d87060e800ffae2bd19da94ede05018066c87 Mon Sep 17 00:00:00 2001
> > From: Paolo Bonzini <pbonzini@redhat.com>
> > Date: Thu, 5 Dec 2019 12:39:07 +0100
> > Subject: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
> >
> > According to the SDM, a VMWRITE in VMX non-root operation with an
> > invalid VMCS-link pointer results in VMfailInvalid before the validity
> > of the VMCS field in the secondary source operand is checked.
> >
> > While cleaning up handle_vmwrite, make the code of handle_vmread look
> > the same, too.
>
> Okay.
>
> > Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if running L2")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 4aea7d304beb..c080a879b95d 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4767,14 +4767,13 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
> >         if (to_vmx(vcpu)->nested.current_vmptr == -1ull)
> >                 return nested_vmx_failInvalid(vcpu);
> >
> > -       if (!is_guest_mode(vcpu))
> > -               vmcs12 = get_vmcs12(vcpu);
> > -       else {
> > +       vmcs12 = get_vmcs12(vcpu);
> > +       if (is_guest_mode(vcpu)) {
> >                 /*
> >                  * When vmcs->vmcs_link_pointer is -1ull, any VMREAD
> >                  * to shadowed-field sets the ALU flags for VMfailInvalid.
> >                  */
> > -               if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
> > +               if (vmcs12->vmcs_link_pointer == -1ull)
> >                         return nested_vmx_failInvalid(vcpu);
> >                 vmcs12 = get_shadow_vmcs12(vcpu);
> >         }
> > @@ -4878,8 +4877,19 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
> >                 }
> >         }
> >
> > +       vmcs12 = get_vmcs12(vcpu);
> > +       if (is_guest_mode(vcpu)) {
> > +               /*
> > +                * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
> > +                * to shadowed-field sets the ALU flags for VMfailInvalid.
> > +                */
> > +               if (vmcs12->vmcs_link_pointer == -1ull)
> > +                       return nested_vmx_failInvalid(vcpu);
> > +               vmcs12 = get_shadow_vmcs12(vcpu);
> > +       }
> >
> >         field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
> > +
> >         /*
> >          * If the vCPU supports "VMWRITE to any supported field in the
> >          * VMCS," then the "read-only" fields are actually read/write.
> > @@ -4889,24 +4899,12 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
> >                 return nested_vmx_failValid(vcpu,
> >                         VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
> >
> > -       if (!is_guest_mode(vcpu)) {
> > -               vmcs12 = get_vmcs12(vcpu);
> > -
> > -               /*
> > -                * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
> > -                * vmcs12, else we may crush a field or consume a stale value.
> > -                */
> > -               if (!is_shadow_field_rw(field))
> > -                       copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
> > -       } else {
> > -               /*
> > -                * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
> > -                * to shadowed-field sets the ALU flags for VMfailInvalid.
> > -                */
> > -               if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
> > -                       return nested_vmx_failInvalid(vcpu);
> > -               vmcs12 = get_shadow_vmcs12(vcpu);
> > -       }
> > +       /*
> > +        * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
> > +        * vmcs12, else we may crush a field or consume a stale value.
> > +        */
> > +       if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
> > +               copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
> >
> >         offset = vmcs_field_to_offset(field);
> >         if (offset < 0)
> >
> >
> > ... and also, do you have a matching kvm-unit-tests patch?
>
> I'll put one together, along with a test that shows the current
> priority inversion between read-only and unsupported VMCS fields.

I can't figure out how to clear IA32_VMX_MISC[bit 29] in qemu, so I'm
going to add the test to tools/testing/selftests/kvm instead.

> > Thanks,
> >
> > Paolo
> >
