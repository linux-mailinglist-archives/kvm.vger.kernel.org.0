Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24CD460D4A
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 04:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhK2Det (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 22:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348163AbhK2Dct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 22:32:49 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134A7C061574;
        Sun, 28 Nov 2021 19:29:08 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 8so15363137pfo.4;
        Sun, 28 Nov 2021 19:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iatS13sutXzzthvveSjyuAeqndR1TlQQpWzKyFyjlkM=;
        b=elynjsio8fpfWYK5pbyKQYh4U67qYEmKV5iqw40fTjPlwp/MzCagdBJ4mbU8HJK2jE
         WcEVL7dkPihPls/s/qnB+A8D7LvquSOMvpuag86ubh3FFXha5p6GGGqJgMWrpPie6aOJ
         ZmT6AxObt66qWjorAyACJw4DDGAEjcFznSyVlXHqTC8WDyx3f9PHIaVCpL9aBtZUY0Nn
         cxPqcHY0M3pjOfYv3BCJWdiP0YKQ/eZKs7j7SKUb9qPYzrb7eBqbJ0fBq85XoafCE3Ed
         OT82oiRU3YNHNC1BzPgxsZFc9MR2RwLKl/h8BRhfY6sPzaNJTjFB+hXHkhySzVFAfS4F
         peIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iatS13sutXzzthvveSjyuAeqndR1TlQQpWzKyFyjlkM=;
        b=bSCMaJgakNAIeZ/J2XJhoWME3cvW/QWTmealJtO52oua0of1LPAIwrPChnD35epqBo
         CDwFk/fhn+32PZeRYbdlNHQGY11DW4p4+isZwh0Cg76Hdvq7bvjOGOtrgqx46lLeJ2IL
         1qbWBna3cXN5oLmzJ86hm04z23QGWYwd3Ffb3AbIyh9s6q+ijlY/fk0SKuFD4eAUReCe
         AxInpp62mVcqzHgBQf9aPZ6Tjdxq0lGh7wQR33rMaXNY7yHRFV84asb4Dea9lJOzVyPx
         wTglNB++EzvSc+g/oMF39lsSxfb9SALVASiu28BmZZ9d8LEHY7+0UOM92Yra41Pp4grx
         RM5w==
X-Gm-Message-State: AOAM5337ctiJh0eujl/MHKUIiYszDRf0bNfDuvzE1CMQHYrHeypvUqvT
        iz59s2+sBBUtfS3zSdWmrcf8Uw/8S+ZTjFKlMSQ=
X-Google-Smtp-Source: ABdhPJyieQLsKqqrSgM1aQ1qqQAp1ZuD5qmX1LSwyWR72G2wlXXhv+eLFksgIuHqr724KpGLhPphdg==
X-Received: by 2002:a63:130c:: with SMTP id i12mr26458676pgl.297.1638156547446;
        Sun, 28 Nov 2021 19:29:07 -0800 (PST)
Received: from localhost.localdomain ([43.128.78.144])
        by smtp.gmail.com with ESMTPSA id pf15sm17911786pjb.40.2021.11.28.19.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 19:29:07 -0800 (PST)
Date:   Mon, 29 Nov 2021 11:28:59 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211129112859.048b3d1a@gmail.com>
In-Reply-To: <20211123161834.30714698@gmail.com>
References: <20211122095619.000060d2@gmail.com>
        <YZvrvmRnuDc1e+gi@google.com>
        <20211123161834.30714698@gmail.com>
Organization: ksyun
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 16:18:34 +0800
Aili Yao <yaoaili126@gmail.com> wrote:

> On Mon, 22 Nov 2021 19:13:02 +0000
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Mon, Nov 22, 2021, Aili Yao wrote:
> > > From: Aili Yao <yaoaili@kingsoft.com>
> > > 
> > > When we isolate some pyhiscal cores, We may not use them for kvm
> > > guests, We may use them for other purposes like DPDK, or we can
> > > make some kvm guests isolated and some not, the global judgement
> > > pi_inject_timer is not enough; We may make wrong decisions:
> > > 
> > > In such a scenario, the guests without isolated cores will not be
> > > permitted to use vmx preemption timer, and tscdeadline fastpath
> > > also be disabled, both will lead to performance penalty.
> > > 
> > > So check whether the vcpu->cpu is isolated, if not, don't post timer
> > > interrupt.
> > > 
> > > Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> > > ---
> > >  arch/x86/kvm/lapic.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 759952dd1222..72dde5532101 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -34,6 +34,7 @@
> > >  #include <asm/delay.h>
> > >  #include <linux/atomic.h>
> > >  #include <linux/jump_label.h>
> > > +#include <linux/sched/isolation.h>
> > >  #include "kvm_cache_regs.h"
> > >  #include "irq.h"
> > >  #include "ioapic.h"
> > > @@ -113,7 +114,8 @@ static inline u32 kvm_x2apic_id(struct
> > > kvm_lapic *apic) 
> > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> > >  {
> > > -	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > +	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > +		!housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);  
> > 
> > I don't think this is safe, vcpu->cpu will be -1 if the vCPU isn't
> > scheduled in. 
> 
> I checked this, It seems we will set vcpu->cpu to a valid value when we
> create vcpu( kvm_vm_ioctl_create_vcpu()), 

Really Sorry, My code base is too old; This vcpu->cpu assignment has been deleted
in latest code, And this housekeeping_cpu() check will result problem.

Thanks!

>only after that we can
> configure lapic through vcpu fd and start the timer, this may not be one
> real problem.
> 
> Currently, the patch seems work as expected in my test, maybe one
> possible candidate for the issue listed above.
> 
> Thanks
> 
> > This also doesn't play nice with the admin forcing
> > pi_inject_timer=1.  Not saying there's a reasonable use case for
> > doing that, but it's supported today and this would break that
> > behavior.  It would also lead to weird behavior if a vCPU were
> > migrated on/off a housekeeping vCPU.  Again, probably not a
> > reasonable use case, but I don't see anything that would outright
> > prevent that behavior.
> > 
> > The existing behavior also feels a bit unsafe as pi_inject_timer is
> > writable while KVM is running, though I supposed that's orthogonal to
> > this discussion.
> > 
> > Rather than check vcpu->cpu, is there an existing vCPU flag that can
> > be queried, e.g. KVM_HINTS_REALTIME?
> > 
> > >  }
> > >  
> > >  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
> > > -- 
> > > 2.25.1
> > >   
> 

