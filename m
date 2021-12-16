Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90049476BCF
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 09:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhLPIXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 03:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhLPIXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 03:23:15 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02003C061574;
        Thu, 16 Dec 2021 00:23:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so21902460pjb.5;
        Thu, 16 Dec 2021 00:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HLeccMgObWGxz81bJE+3Vca+86bEOL8IL5Tkqn2xXf4=;
        b=RigCruDdm2697dk3JS+zKv8hMjgJpHnTU7tEa9MmVvL+46CisvnQGv0UfmaMJNv3xk
         dkwvQcZ4MieFawUUzyVcujIQeEpic9h9ycYT9CKUlmH5+hQlZKUq4sURNeb4Z9w7sBbR
         ysvwsaKR4FQkutidEz8sc86bKKO9wiqWednGjkoSSDCWgX4RA7Lgvt8QiGodRDMyIsdo
         62hJwGGDGRdJQ2nMxS469V5wKcnCDZmkVI5rwn8yF/N+PjHpqyeQwYKCY0MaZQnJjRJF
         4zMwtzChe5rcNpHKt4r5kQHLPIwUHMfEagbpnqLOzwlKBnVRltHuPF+V1NzROxd6mWV5
         MeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HLeccMgObWGxz81bJE+3Vca+86bEOL8IL5Tkqn2xXf4=;
        b=03JO7jQGZjdwmcCDSbQgUf7r5iO5thAB8nVATAYdMKfNZvlp5DPiH0FKhoAK1ey8Ox
         t7ha2Dt1Dt0tSKww70mr9zZVJ+biWCWlK/yFb+KMLbv0IOs4sHkO+8Api7AdnDgneb1k
         4UGltjotHaQ8Kj63sxDnl5R1j6s0+9HHykk5RG21jKKH4DNENdnif37Wxr0oQnhr5VaV
         knvILNRegZdya6qUimnyCMRm9DNDVok150x8JhiQXojlSRWJiYjx8Dxl6ZdD5gwA2l12
         fEG5lroow/G3SjOZhnxQp7vLpZUM1sGhzZMOve6zZxDR8L/qoVWFBtA+Sm6xuzb/U/ww
         tt+w==
X-Gm-Message-State: AOAM530WjXJxA9mZqfPCsxPvJL/hKfGBK9xkS5M7QE+ATbASmcoZHehs
        WiC5GjPDmxA5nOIaW6xPaNs=
X-Google-Smtp-Source: ABdhPJxQRoYY/viJyRk7MR85tHB6G4snUPbXXj/PD05aKcFG/NwwrlGsrzMQg+eALAazgumorjMOVQ==
X-Received: by 2002:a17:90a:4a06:: with SMTP id e6mr4710500pjh.228.1639642994393;
        Thu, 16 Dec 2021 00:23:14 -0800 (PST)
Received: from localhost.localdomain ([43.128.78.144])
        by smtp.gmail.com with ESMTPSA id h10sm4531971pgj.64.2021.12.16.00.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:23:14 -0800 (PST)
Date:   Thu, 16 Dec 2021 16:23:03 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH v2] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211216162303.230dbdaa@gmail.com>
In-Reply-To: <Ya/s17QDlGZi9COR@google.com>
References: <20211124125409.6eec3938@gmail.com>
        <Ya/s17QDlGZi9COR@google.com>
Organization: ksyun
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Dec 2021 23:23:03 +0000
Sean Christopherson <seanjc@google.com> wrote:
> On Tue, Nov 23, 2021 at 10:00 PM Wanpeng Li <kernellwp@gmail.com> wrote:
> > ---
> >  arch/x86/kvm/lapic.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 759952dd1222..8257566d44c7 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> >
> >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> >  {
> > -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > +       return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) && kvm_vcpu_apicv_active(vcpu);  
> 
> As Aili's changelog pointed out, MWAIT may not be advertised to the guest. 
> 
> So I think we want this?  With a non-functional, opinionated refactoring of
> kvm_can_use_hv_timer() because I'm terrible at reading !(a || b).
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 40270d7bc597..c77cb386d03d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -113,14 +113,25 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> 
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  {
> -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +              (kvm_mwait_in_guest(vcpu) || kvm_hlt_in_guest(vcpu));
>  }
> 
>  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
>  {
> -       return kvm_x86_ops.set_hv_timer
> -              && !(kvm_mwait_in_guest(vcpu->kvm) ||
> -                   kvm_can_post_timer_interrupt(vcpu));
> +       /*
> +        * Don't use the hypervisor timer, a.k.a. VMX Preemption Timer, if the
> +        * guest can execute MWAIT without exiting as the timer will stop
> +        * counting if the core enters C3 or lower.  HLT in the guest is ok as
> +        * HLT is effectively C1 and the timer counts in C0, C1, and C2.
> +        *
> +        * Don't use the hypervisor timer if KVM can post a timer interrupt to
> +        * the guest since posted the timer avoids taking an extra a VM-Exit
> +        * when the timer expires.
> +        */
> +       return kvm_x86_ops.set_hv_timer &&
> +              !kvm_mwait_in_guest(vcpu->kvm) &&
> +              !kvm_can_post_timer_interrupt(vcpu));
>  }
>  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
> 

It seems Sean and Wanpeng are busy with some other more important issues;
So Please let me try to merge Sean, Wanpeng's ideas and suggestions together,also including my opinions
into one possible approach and get it reviewed, Only if others are OK with this;

I will post a new patch for this later today or tomorrow.

Thanks!

--Aili Yao
