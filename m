Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3801CF3F02
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 05:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfKHEtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 23:49:47 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39758 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfKHEtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 23:49:47 -0500
Received: by mail-lj1-f193.google.com with SMTP id p18so4748027ljc.6
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 20:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GiVTAYNpSvRRdjjjzIb6v88FEscueczAxaA6ZxgqCpk=;
        b=lHuAA84Ap+AeazHkcX8k1qftDMyZ9IghtqbsQpu9Mr2SGXk/WaMkN4bKSdr4Z0+y+o
         tYo75d0TST5bysmutZ6Sbtws7J9iXE/wRBDNFFqJELK2IeYKVau/Fj8fC00zeb/R6+p2
         8dX41mt/iRWHVzdvBcsOrYXGf0BaKvOfBvIXVGU0VC7f3UEtX+MSIKz/u9qN9Co8aWuf
         RuxP8eTflaENMOm92xXq35jTORmikRLjv2XUIXowTBCgS7V9Y1AlYvJB3kxPVcGpaQ+P
         1zK2LRkraTxIpCMPvJmjaZcSoS0zbTEWKGPQMwo2SysYyh7Wm0znu7tbhLUSnI/6Rvb+
         C3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GiVTAYNpSvRRdjjjzIb6v88FEscueczAxaA6ZxgqCpk=;
        b=X/7yHoRzl53R4f1M+VUGDZVuk/nTnHaM76Tuj/8yJIVC6GFowHFtfVzc5+mfyEBD3x
         OIITXwl1AAUUJ18+NY/YVpnPxUAoURhiAoPRrKIL22WkJh5r9ssk/VYImA7OlGQNQSwD
         JIb15ae1KtAYjmVAk6Is7oBvNteJXO/BhR0arYCw7D6gmsH0JeeW5EzcgSVYf+WT1Zw0
         UipNtszF2IFrSevb+n0IXz44gGEQmnWKbUkt9RZP5iEWvQ2WbHDyoW2C2okDu7c+u17E
         kq0pllkVSJ4Rytle7xBtJ2kswoTZkJj8tVh/+Zrq6lbidyPzrkneH61vy012hi6fDmBx
         6QXw==
X-Gm-Message-State: APjAAAVAknvryGchlVPmCNY0AZsUOZa8WUHUbjTjRMpykV8ebMucYrih
        kkj37SHn2g9ZdzOVZThAfxVzVw1wXJCDnmXuxlSOQQ==
X-Google-Smtp-Source: APXvYqypgrD584rmqw9wLaKDYA7POsspwR27Xj7g6DV5XkNjR28fwAgxSfvNwUdoUGyylzGSqqfhyJ1tcLQiyF+F7n0=
X-Received: by 2002:a2e:898d:: with SMTP id c13mr5257611lji.54.1573188584945;
 Thu, 07 Nov 2019 20:49:44 -0800 (PST)
MIME-Version: 1.0
References: <20191107224941.60336-1-aaronlewis@google.com> <20191107224941.60336-5-aaronlewis@google.com>
 <DA3ABA30-66FC-4CD8-A828-77686A868FD0@oracle.com>
In-Reply-To: <DA3ABA30-66FC-4CD8-A828-77686A868FD0@oracle.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 7 Nov 2019 20:49:33 -0800
Message-ID: <CAAAPnDEyNHbkBp0rRX658jSVWBbYoTPY9By=X3cW=ibuP8igtw@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] KVM: nVMX: Prepare MSR-store area
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 7, 2019 at 3:00 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 8 Nov 2019, at 0:49, Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > Prepare the MSR-store area to be used in a follow up patch.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> > arch/x86/kvm/vmx/nested.c | 17 ++++++++++++++++-
> > arch/x86/kvm/vmx/vmx.h    |  4 ++++
> > 2 files changed, 20 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 7b058d7b9fcc..c249be43fff2 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -982,6 +982,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu *v=
cpu, u64 gpa, u32 count)
> >       return 0;
> > }
> >
> > +static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu)
> > +{
> > +     struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > +     struct vmx_msrs *autostore =3D &vmx->msr_autostore.guest;
> > +
> > +     autostore->nr =3D 0;
> > +}
> > +
> > static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
> > {
> >       unsigned long invalid_mask;
> > @@ -2027,7 +2035,7 @@ static void prepare_vmcs02_constant_state(struct =
vcpu_vmx *vmx)
> >        * addresses are constant (for vmcs02), the counts can change bas=
ed
> >        * on L2's behavior, e.g. switching to/from long mode.
> >        */
> > -     vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
> > +     vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.gues=
t.val));
> >       vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.v=
al));
> >       vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest=
.val));
> >
> > @@ -2294,6 +2302,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx =
*vmx, struct vmcs12 *vmcs12)
> >               vmcs_write64(EOI_EXIT_BITMAP3, vmcs12->eoi_exit_bitmap3);
> >       }
> >
> > +     /*
> > +      * Make sure the msr_autostore list is up to date before we set t=
he
> > +      * count in the vmcs02.
> > +      */
> > +     prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);
>
> Doesn=E2=80=99t this fail compilation?
> prepare_vmx_msr_autostore_list() is declared with single parameter while =
it is called here with two parameters.
>
> Also, why do we need this as a separate patch?
> It made sense if next patch was split between all the framework code and =
the code specific using it in regards to MSR_IA32_TSC,
> but current separation is a bit bizarre. It is also OK if this patch and =
next one will just be merged to one (with no such separation).

I'll send out an updated patch with this patch and the next one merged
together like it originally was.

>
> > +
> > +     vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.guest.nr=
);
> >       vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> >       vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr)=
;
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 1dad8e5c8f86..2616f639cf50 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -230,6 +230,10 @@ struct vcpu_vmx {
> >               struct vmx_msrs host;
> >       } msr_autoload;
> >
> > +     struct msr_autostore {
> > +             struct vmx_msrs guest;
> > +     } msr_autostore;
> > +
> >       struct {
> >               int vm86_active;
> >               ulong save_rflags;
> > --
> > 2.24.0.432.g9d3f5f5b63-goog
> >
>
