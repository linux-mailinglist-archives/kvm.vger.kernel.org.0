Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D479B8F75B
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 01:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbfHOXDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 19:03:09 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45684 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbfHOXDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 19:03:08 -0400
Received: by mail-io1-f68.google.com with SMTP id t3so2560995ioj.12
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 16:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yw6psdcGgCaSzgG0zQOEf0HAwGHEA1exhWPCNTEeCR0=;
        b=abkDIVkJZvLpasZ9OPEyxVpdPtEU1ZLGYjnvGbQbx6JpuURdXZ2WR2xrQoPWAgX55d
         TEWi3WouJsaBDY+tS7FafbLXy2Suvw8BdcVXeJhUOn47ockg2CsjH9HqetisIfZUQrTF
         ZSD/OSRe3R+XtOhE50Fa5aAciTb+bOtpdC5Ad82OQmntK5qtkUTi90SQ2JnV6Y82RTuG
         uPpVpGJqOtmvHuuUOp3rkn139fI4xAR8sPCDIVo8TWQAO8k2EadS0zJhKqKBtFmrxTHH
         mQ5zCo0k/FhhuFLPDnX42DzBJdUwIBouutt5uvX90ljg/LZ8C1p+qH26reSBnve0iLcJ
         FStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yw6psdcGgCaSzgG0zQOEf0HAwGHEA1exhWPCNTEeCR0=;
        b=epFL+gwCEy5MCLS80/jmsydHqhAJwdb8DkX+2SzlpGKlxds3hfRPstVFWersId615y
         24UBAuIjVfJsnssDRqddzJG47/PU3+9xKTRXrHCj0TdyV4L7RBzNfCyckPkifce276Mc
         bStl0mT7QFulRRwq3Ml7x/QUWlpFIM81W3nMRkTTE7BS4dJe7AHBV7FzNr/9nm4EgUar
         /GaGK6KlYGvxHLuWKriOBUa9PnZVxM4ja6EPiKHIc+ANnBX5FMIsSIl8r1EJ3pKa280j
         gZK5aQ7LHH95wykCNFDTn8OlhmVI5lYnb+BKrsQVUETopGUqaCRqZ56I9oTcY9rTf8wa
         e4NA==
X-Gm-Message-State: APjAAAUbSZJLN0MqlGjlinGlsyJbe/7wJSSvZZdgu9jMX1P66skv8sry
        zxGRWsxVx6jvdk0RWkcxpEW1IFDBAfqkmDbILYifPA==
X-Google-Smtp-Source: APXvYqyiBBVtYFil/iszRypJ+tOnipi70kCHabdOQgwwr16cItasYS79ddZUXqCEz/f9FutorigI/J1gNcPLRWAcLLY=
X-Received: by 2002:a5d:8954:: with SMTP id b20mr8159626iot.118.1565910187642;
 Thu, 15 Aug 2019 16:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-8-krish.sadhukhan@oracle.com> <20190513191254.GJ28561@linux.intel.com>
In-Reply-To: <20190513191254.GJ28561@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 15 Aug 2019 16:02:56 -0700
Message-ID: <CALMp9eQy+rf7qvsTd9AfzrUhU_k76vzOZLU4MLpGCFG-fM0fPQ@mail.gmail.com>
Subject: Re: [PATCH 7/8][KVM nVMX]: Enable "load IA32_PERF_GLOBAL_CTRL
 VM-{entry,exit} controls
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 12:12 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Apr 24, 2019 at 07:17:23PM -0400, Krish Sadhukhan wrote:
> >  ...based on whether the guest CPU supports PMU
> >
> > Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 4d39f731bc33..fa9c786afcfa 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6964,6 +6964,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
> >  static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +     bool pmu_enabled = guest_cpuid_has_pmu(vcpu);
>
> A revert has been sent for the patch that added guest_cpuid_has_pmu().
>
> Regardless, checking only the guest's CPUID 0xA is not sufficient, e.g.
> at the bare minimum, exposing the controls can be done if and only if
> cpu_has_load_perf_global_ctrl() is true.

I don't think cpu_has_load_perf_global_ctrl() is required. Support for
the VM-entry and VM-exit controls, "load IA32_PERF_GLOBAL_CTRL," can
be completely emulated by kvm, since add_atomic_switch_msr() is
capable of falling back on the VM-entry and VM-exit MSR-load lists if
!cpu_has_load_perf_global_ctrl().

The only requirement should be kvm_pmu_is_valid_msr(MSR_CORE_PERF_GLOBAL_CTRL).

> In general, it's difficult for me to understand exactly what functionality
> you intend to introduce.  Proper changelogs would be very helpful.

I concur!
