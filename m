Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B674647831A
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 03:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhLQCXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 21:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbhLQCXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 21:23:04 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FC8C061574;
        Thu, 16 Dec 2021 18:23:04 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u17so577892plg.9;
        Thu, 16 Dec 2021 18:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YkC57fIQYOJd6l+HEs53okpuCiM+wlfOFUu3D4S4VL8=;
        b=TXf1+sH3CHPLox/x/TeYmaYOxV79u7dfdXQ4YqeSqa/l3eEKnkJtx4KSY8HOdZuiiY
         3eQfX1Jng1kaqvPyoN1XCxZlGgcQTAF6QwsqXyweEFWegvgtIxHjsSFGJkr+v36bw2uI
         wiQAUtMHbRbXTiU09zeUB7ARQPlHabIQZuzsy2SH/A0jZDVQWbkflYGxqfabvHCJkSJw
         qzjk3qauAmyhK3F92Yh6MWN1Q/BBJ1x+yOImiHWr0QR8i2kFShYjVFkTUU8e4qivL2eF
         wT+AwkmgReOqWAQmIXGSO4JseoIgPBCybbxj5spSkqVhqceov4lg1mheh+EHUT3cFkbK
         9SJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YkC57fIQYOJd6l+HEs53okpuCiM+wlfOFUu3D4S4VL8=;
        b=WBKkYiMvyzSheZJkJexUpq2mlThah+19o8sVrtGD92jz/+derbKAjjX3d1MQDPIK1D
         udtazMpSdbDoQJ4huS7o8iaguwVLwG+GsnJQCSEveq+wtxvYljiJWADQaaVnwL/auNiS
         AN92Yz9Zgyp+zu5VVPmTbvONuw22cMOcGpNo/ykEmp0NnU+78Es5+697f9t9YboQqMge
         HMpLXIcBPEGIldliAvEMmX7yWmrCHyAM3hSRcVq+VfB3HLTE0ay5i8Bcsg+TIfJI2BRW
         0SBc9KbEjTmIkr6n6K0Q7eStClgropjB0KKLMJBNSzLh+dKB01ut22As0uRdopX8xcDc
         YFxw==
X-Gm-Message-State: AOAM532jVu+ZXaHQV9W6RfRQftH4o86mFaDMNCa2hJyIF8Kdfd2Tx+5t
        WpLBvWQwmQAgt5HCJLDttHc=
X-Google-Smtp-Source: ABdhPJwN1XrN5B8b4WgxB64cirDloPcYXtFP8VF7uv9k995G0YMwetE+9bSxfKVsRneLXsjqyRR1qw==
X-Received: by 2002:a17:90b:1b03:: with SMTP id nu3mr9470286pjb.240.1639707784058;
        Thu, 16 Dec 2021 18:23:04 -0800 (PST)
Received: from localhost.localdomain ([43.128.78.144])
        by smtp.gmail.com with ESMTPSA id m1sm548349pjv.28.2021.12.16.18.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 18:23:03 -0800 (PST)
Date:   Fri, 17 Dec 2021 10:22:55 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH v2] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211217102255.481a1e1d@gmail.com>
In-Reply-To: <YbtfNVVtLlvxE2YB@google.com>
References: <20211124125409.6eec3938@gmail.com>
        <Ya/s17QDlGZi9COR@google.com>
        <20211216162303.230dbdaa@gmail.com>
        <YbtfNVVtLlvxE2YB@google.com>
Organization: ksyun
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Dec 2021 15:45:57 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Dec 16, 2021, Aili Yao wrote:
> > On Tue, 7 Dec 2021 23:23:03 +0000
> > Sean Christopherson <seanjc@google.com> wrote:  
> > > On Tue, Nov 23, 2021 at 10:00 PM Wanpeng Li <kernellwp@gmail.com> wrote:  
> > > > ---
> > > >  arch/x86/kvm/lapic.c | 5 ++---
> > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 759952dd1222..8257566d44c7 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> > > >
> > > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> > > >  {
> > > > -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > > +       return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) && kvm_vcpu_apicv_active(vcpu);    
> > > 
> > > As Aili's changelog pointed out, MWAIT may not be advertised to the guest. 
> > > 
> > > So I think we want this?  With a non-functional, opinionated refactoring of
> > > kvm_can_use_hv_timer() because I'm terrible at reading !(a || b).
> > > 
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 40270d7bc597..c77cb386d03d 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -113,14 +113,25 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> > > 
> > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> > >  {
> > > -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > +       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > +              (kvm_mwait_in_guest(vcpu) || kvm_hlt_in_guest(vcpu));
> > >  }
> > > 
> > >  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
> > >  {
> > > -       return kvm_x86_ops.set_hv_timer
> > > -              && !(kvm_mwait_in_guest(vcpu->kvm) ||
> > > -                   kvm_can_post_timer_interrupt(vcpu));
> > > +       /*
> > > +        * Don't use the hypervisor timer, a.k.a. VMX Preemption Timer, if the
> > > +        * guest can execute MWAIT without exiting as the timer will stop
> > > +        * counting if the core enters C3 or lower.  HLT in the guest is ok as
> > > +        * HLT is effectively C1 and the timer counts in C0, C1, and C2.
> > > +        *
> > > +        * Don't use the hypervisor timer if KVM can post a timer interrupt to
> > > +        * the guest since posted the timer avoids taking an extra a VM-Exit
> > > +        * when the timer expires.
> > > +        */
> > > +       return kvm_x86_ops.set_hv_timer &&
> > > +              !kvm_mwait_in_guest(vcpu->kvm) &&
> > > +              !kvm_can_post_timer_interrupt(vcpu));
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
> > >   
> > 
> > It seems Sean and Wanpeng are busy with some other more important issues;
> > So Please let me try to merge Sean, Wanpeng's ideas and suggestions together,also including my opinions
> > into one possible approach and get it reviewed, Only if others are OK with this;
> > 
> > I will post a new patch for this later today or tomorrow.  
> 
> Sorry, I was waiting for someone to say "this works", but never actually said as
> much.
> 
> Does the above change address your use case?  If not, what's missing?

After a little modifications, This works in my test.

static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
{
-       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+              (kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
 }

and also you can delete or keep kvm_mwait_in_guest() check;

Thanks!
