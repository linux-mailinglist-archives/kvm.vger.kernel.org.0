Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C3C46F2E3
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242802AbhLISYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243180AbhLISYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:24:35 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C094C061746
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 10:21:02 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id k26so6156026pfp.10
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 10:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q1B/B6frpMpx5MKHMjooXNn4nRrnCrkfKththO/2mrk=;
        b=QZ8QWIuEHrIiG9QNQt9qRYwDPoBq3em5nu2AuA0P1pMIEt0dxs1DteeGCHfncp4fd4
         PgNSPYS4EUncx1AREYRewY6KUYQV5MdovCrXGhe7ePbAqUk7Mqp+vhbnVmMMFtAc9+yk
         /FBYZI3mlc42e5ILzRmvHZmEkjAb5LXtS2AdXm91XZs6kIMyZxRUYOj/oYquUvz24shM
         PF9NrRvIVo58R3whJkKUKDouLRtdNILnq2G8obRCyEhZii7up1N/ZqBQKPkaxZELtZ6+
         mUcBaactaIzGFhB+uU/mkUk18YAzO3o0eQGzVS6G8tctiM8Lx/M0JWORG1F/H+JTofL0
         IRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q1B/B6frpMpx5MKHMjooXNn4nRrnCrkfKththO/2mrk=;
        b=jyImNvwnUYcqtSQoAayNPp21ffZE0/MtJ9kaH+pVJRqd9o2IYvLDXdgO9yFomaaYee
         bs4WGrb97JCIPs3miVvmRlKZORVmauh68/W3HlWYq0NMPo7vLxkexLxWGR6FyVtKZX90
         txz9D8kfVi/VjarhaqRyyaG6L9DEBMO6HI6vDobBvRpLdytFbfuHX5Xu9yOArLq5OsjE
         wqVsiAS9cMEiwhAVFY943GLV3TWkdsQhSxOPYCq7FRKO/jhzb1NUnghEjWXGyoJ96anS
         JDJ/2/8d/QKoxs4kyaXPBGkQhhbc5QexzrSahWFnvcQZs/TukjvmQ+Z0cyYs/hORxxk9
         YHMQ==
X-Gm-Message-State: AOAM532Fy0hHy7BIp3jVqa9gbgWsarKLioHP0lUjaKWNv9by+KMoIAzF
        jx06/kLSxLmoFznWYlXicD5zKQ==
X-Google-Smtp-Source: ABdhPJwJJtXqPIepUiw9fOMLWmxYQB6UiOX0HDPFjljJDq8tThT40b1GbYGCfv4sExT7mqWQ6Ee3tQ==
X-Received: by 2002:a63:5f14:: with SMTP id t20mr27138606pgb.382.1639074061719;
        Thu, 09 Dec 2021 10:21:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o124sm370842pfb.177.2021.12.09.10.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 10:21:01 -0800 (PST)
Date:   Thu, 9 Dec 2021 18:20:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aili Yao <yaoaili126@gmail.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: Re: [PATCH v2] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <YbJJCf20VdHNnpzY@google.com>
References: <20211124125409.6eec3938@gmail.com>
 <Ya/s17QDlGZi9COR@google.com>
 <20211208182158.571fcdee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208182158.571fcdee@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 08, 2021, Aili Yao wrote:
> On Tue, 7 Dec 2021 23:23:03 +0000
> Sean Christopherson <seanjc@google.com> wrote:
> 
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
> Sorry, I am little confused here now:
> if kvm_can_post_timer_interrupt(vcpu) return true(cpu-pm enabled), then the kvm_can_use_hv_timer will always be false;
> if kvm_can_post_timer_interrupt(vcpu) return false(cpu-pm disable),then kvm_mwait_in_guest(vcpu->kvm) can't be true ether;
> It seems we don't need kvm_mwait_in_guest(vcpu->kvm) here?

We do, it's to prevent the guest from enter C3+ and stopping the VMX preemption
timer, e.g. if either kvm_vcpu_apicv_active() or pi_inject_timer evaluates false.
