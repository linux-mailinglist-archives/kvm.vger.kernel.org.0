Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88234477641
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 16:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbhLPPqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 10:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbhLPPqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 10:46:02 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F97AC06173E
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 07:46:02 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so23023822pjq.4
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 07:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dBNwy6JmI5LlG8Ycy4IPBbB/eEua42BeOhgPlNQAOyo=;
        b=nIi0FFB2Y7Fla3mKWA7uAzUn8+ecRT8lHYGvg6TkkROKiPz+ClDphKYDx8oCaDTKRt
         ykJx+BwiHPCE9MOeYcCexgT6huXA7KtR5MomX7yW1WMQey5sH5eocU79bQMsZ5pI2w4x
         iwnL9Dzkno6ohXpwUJAKA18KtJDlHd+B3iDNWADfxvqTSJGlYrNLfs17dbN1sUDCrN60
         NXXn0jN8I3td1IvRXDS08gKg+tsyo8oxwzl8Cflo1kX1HlLEoA+AgRqGieDb9qNkbou4
         /pJm6q/xTnbijS5eEq5esO5VO+ne4FJrIMIwdr1IDAHQqwk5QICuoFj8HozzIHxLsfwo
         m9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dBNwy6JmI5LlG8Ycy4IPBbB/eEua42BeOhgPlNQAOyo=;
        b=sFAMsIxFh2hLXaktcaqRxGSdWiYK7Xqbu0Um+rV6+eiyaAiY2yXxsZO/w5Lub5XzHi
         MldUwVLSWPIb3+iwYqrW8nH7TmLYcadcaJveb5QflE4ox4ybsqfKjg4teNPjphA++5OO
         +687+vRTiPcYV6hMhyK+/vwXCstfGpT7ZMG3M0gDICDs8vJykBuKES7D78UExcWRNHN/
         HB+YSf/vBPwXQUcM1QqjRdkcsXgLC6NuyVmr7vcY2ofQn0DDrLr4+HB/za8jdvJ4CbmM
         3Xx6GvOxLuyu7n3Be1sZ7yXgXsCGmPgJxvJoxPHosoGeHgZXynREtZg4OQdyl49yhyaS
         AdWg==
X-Gm-Message-State: AOAM532jNVQepWFdWUa61dV1+FwV90k6ChRrtuokppkb8bJ3nBCX7stW
        uAjS5XBQh7xMYuzM9PlEoSLiYA==
X-Google-Smtp-Source: ABdhPJychtCuZ6yu/JvyLXz+PjPk9S7u3FuVFYWbPENnVBOnHjdLFaZN9JDJ3qnQiVaSob+E9Dl8LA==
X-Received: by 2002:a17:902:6b05:b0:142:83f9:6e29 with SMTP id o5-20020a1709026b0500b0014283f96e29mr17436144plk.32.1639669561310;
        Thu, 16 Dec 2021 07:46:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m2sm247122pjh.36.2021.12.16.07.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 07:46:00 -0800 (PST)
Date:   Thu, 16 Dec 2021 15:45:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aili Yao <yaoaili126@gmail.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH v2] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <YbtfNVVtLlvxE2YB@google.com>
References: <20211124125409.6eec3938@gmail.com>
 <Ya/s17QDlGZi9COR@google.com>
 <20211216162303.230dbdaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216162303.230dbdaa@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16, 2021, Aili Yao wrote:
> On Tue, 7 Dec 2021 23:23:03 +0000
> Sean Christopherson <seanjc@google.com> wrote:
> > On Tue, Nov 23, 2021 at 10:00 PM Wanpeng Li <kernellwp@gmail.com> wrote:
> > > ---
> > >  arch/x86/kvm/lapic.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 759952dd1222..8257566d44c7 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> > >
> > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> > >  {
> > > -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > +       return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) && kvm_vcpu_apicv_active(vcpu);  
> > 
> > As Aili's changelog pointed out, MWAIT may not be advertised to the guest. 
> > 
> > So I think we want this?  With a non-functional, opinionated refactoring of
> > kvm_can_use_hv_timer() because I'm terrible at reading !(a || b).
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 40270d7bc597..c77cb386d03d 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -113,14 +113,25 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> > 
> >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> >  {
> > -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > +       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > +              (kvm_mwait_in_guest(vcpu) || kvm_hlt_in_guest(vcpu));
> >  }
> > 
> >  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
> >  {
> > -       return kvm_x86_ops.set_hv_timer
> > -              && !(kvm_mwait_in_guest(vcpu->kvm) ||
> > -                   kvm_can_post_timer_interrupt(vcpu));
> > +       /*
> > +        * Don't use the hypervisor timer, a.k.a. VMX Preemption Timer, if the
> > +        * guest can execute MWAIT without exiting as the timer will stop
> > +        * counting if the core enters C3 or lower.  HLT in the guest is ok as
> > +        * HLT is effectively C1 and the timer counts in C0, C1, and C2.
> > +        *
> > +        * Don't use the hypervisor timer if KVM can post a timer interrupt to
> > +        * the guest since posted the timer avoids taking an extra a VM-Exit
> > +        * when the timer expires.
> > +        */
> > +       return kvm_x86_ops.set_hv_timer &&
> > +              !kvm_mwait_in_guest(vcpu->kvm) &&
> > +              !kvm_can_post_timer_interrupt(vcpu));
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
> > 
> 
> It seems Sean and Wanpeng are busy with some other more important issues;
> So Please let me try to merge Sean, Wanpeng's ideas and suggestions together,also including my opinions
> into one possible approach and get it reviewed, Only if others are OK with this;
> 
> I will post a new patch for this later today or tomorrow.

Sorry, I was waiting for someone to say "this works", but never actually said as
much.

Does the above change address your use case?  If not, what's missing?
