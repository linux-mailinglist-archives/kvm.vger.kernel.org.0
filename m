Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F60458CC75
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 19:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbiHHRBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 13:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiHHRBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 13:01:04 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4EE13D7F
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 10:01:02 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id h16so5179326ilc.10
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 10:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+dJtRlmFjt91K9tF3wZ5b+WYiCa7+aYk2YzrQB9nc/4=;
        b=sKG1tRb9wl6bKoNiuIS35OYXXdkOJ0X8XjeORGEnfVb/XUHTmKA2Fav2Kb1WruerUH
         2d/zTSw7GvqRwQOG0tYXh8lZuoiPsmYXosjKNiW8WJR3V/445UzxVPvr85vDw75FW/l6
         Xwn4btdNh90enwMgeHxTM0LkG7webzfC8CsSKuMv57Aq9kUz9gOg8TcMFvsd/j2fbaNr
         HtCtiomms0SWv7uC8HUnQYwHG6imSYVF5cphwDXuPIDRhClxsPAbFIEbndLA7iEVCci/
         0l3L8kz3R4yiawJoprvdICLOnOkeQrF1SHrkbhSfY7cMq805JBEd4iIECh5KtMAwuxVq
         tXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+dJtRlmFjt91K9tF3wZ5b+WYiCa7+aYk2YzrQB9nc/4=;
        b=TA3/Vp3k5YrCWInFr+w8QQSbfDxMCZFZkkJw330SnEQCs5yj7Q/c3D955IVwkQ80NZ
         Fjf3IpbxAnpIkMXWwbvqsk71K2hq81g5OBDEZ4MARFcNzlYX3WY3d2/+1ex2Uw1ToVik
         N19g+DfcUaeYQK+pyHaPGZ3fq3Y82OaXGBjCzoy+YNaHvQYUaYtvQ6ZECf+zWDyPrU09
         +Hhj5KTaKRKt8ABI3KBsVoQhYW0Dky850Dm/chLJB/iRICR1vgmhu9YDZC5FPbtYooKi
         f+Msf6Ks2uQ21RV3VOMT0YmZ46vbrPi9goA+eRnyy5XhQpo7jhnzZASgXqLmj0aqrUMl
         +8zQ==
X-Gm-Message-State: ACgBeo2PTgPbUfL2D2rvpObwwraE8xA5R6MnqnF/f0Cb9KS6ScFrSvTu
        B3jWJfrcy7XyFdffZTet1VI9Aw==
X-Google-Smtp-Source: AA6agR7WppV+RrWFuGSA7HHyqYMM1k2sgffgvpE/yI/hlGkpL+0PkCOwcxTzuwERpVONAk1THiXP+g==
X-Received: by 2002:a05:6e02:178d:b0:2de:a00d:d06c with SMTP id y13-20020a056e02178d00b002dea00dd06cmr8946772ilu.142.1659978061392;
        Mon, 08 Aug 2022 10:01:01 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id u68-20020a022347000000b00339c3906b08sm5406500jau.177.2022.08.08.10.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 10:01:01 -0700 (PDT)
Date:   Mon, 8 Aug 2022 12:00:59 -0500
From:   Coleman Dietsch <dietschc@csp.edu>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 2/2] KVM: x86/xen: Stop Xen timer before changing the
 IRQ vector
Message-ID: <YvFBS04HIDTpnca8@kernel-dev-1>
References: <20220729184640.244969-1-dietschc@csp.edu>
 <20220729184640.244969-3-dietschc@csp.edu>
 <Yu1mZyJeYf/0/LP+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yu1mZyJeYf/0/LP+@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022 at 06:50:15PM +0000, Sean Christopherson wrote:
> On Fri, Jul 29, 2022, Coleman Dietsch wrote:
> > This moves the stop xen timer call outside of the previously unreachable
> 
> Please avoid "This", "This patch", etc... and describe what the change is, not
> what the patch is.
> 
> > if else statement as well as making sure that the timer is stopped first
> > before changing IRQ vector. Code was streamlined a bit also.
> 
> Generally speaking, don't describe the literal code changes, e.g. write the changelog
> as if you were describing the bug and the fix to someone in a verbal conversation.
> 

Understood.

> > This was contributing to the ODEBUG bug in kvm_xen_vcpu_set_attr crash that
> > was discovered by syzbot.
> 
> That's not proper justification as it doesn't explain why this patch is needed
> even after fixing the immedate cause of the ODEBUG splat.
> 
>   Stop Xen's timer (if it's running) prior to changing the vector and
>   potentially (re)starting the timer.  Changing the vector while the timer
>   is still running can result in KVM injecting a garbage event, e.g.
>   vm_xen_inject_timer_irqs() could see a non-zero xen.timer_pending from
>   a previous timer but inject the new xen.timer_virq.
> 

Thanks for helping clarify this Sean.

> > ODEBUG: init active (active state 0)
> > object type: hrtimer hint: xen_timer_callbac0
> > RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
> > Call Trace:
> > __debug_object_init
> > debug_hrtimer_init
> > debug_init
> > hrtimer_init
> > kvm_xen_init_timer
> > kvm_xen_vcpu_set_attr
> > kvm_arch_vcpu_ioctl
> > kvm_vcpu_ioctl
> > vfs_ioctl
> > 
> 
> Fixes: 536395260582 ("KVM: x86/xen: handle PV timers oneshot mode")
> Cc: stable@vger.kernel.org
> 
> > Link: https://syzkaller.appspot.com/bug?id=8234a9dfd3aafbf092cc5a7cd9842e3ebc45fc42
> > Reported-by: syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
> > Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
> > ---
> >  arch/x86/kvm/xen.c | 37 ++++++++++++++++++-------------------
> >  1 file changed, 18 insertions(+), 19 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > index 2dd0f72a62f2..f612fac0e379 100644
> > --- a/arch/x86/kvm/xen.c
> > +++ b/arch/x86/kvm/xen.c
> > @@ -707,27 +707,26 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
> >  		break;
> >  
> >  	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
> > -		if (data->u.timer.port) {
> > -			if (data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
> > -				r = -EINVAL;
> > -				break;
> > -			}
> > -			vcpu->arch.xen.timer_virq = data->u.timer.port;
> > -
> > -			/* Check for existing timer */
> > -			if (!vcpu->arch.xen.timer.function)
> > -				kvm_xen_init_timer(vcpu);
> > -
> > -			/* Restart the timer if it's set */
> > -			if (data->u.timer.expires_ns)
> > -				kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
> > -						    data->u.timer.expires_ns -
> > -						    get_kvmclock_ns(vcpu->kvm));
> > -		} else if (kvm_xen_timer_enabled(vcpu)) {
> > -			kvm_xen_stop_timer(vcpu);
> > -			vcpu->arch.xen.timer_virq = 0;
> > +		if (data->u.timer.port &&
> > +		    data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
> > +			r = -EINVAL;
> > +			break;
> >  		}
> >  
> > +		/* Check for existing timer */
> > +		if (!vcpu->arch.xen.timer.function)
> > +			kvm_xen_init_timer(vcpu);
> > +
> > +		/* Stop the timer (if it's running) before changing the vector */
> > +		kvm_xen_stop_timer(vcpu);
> > +		vcpu->arch.xen.timer_virq = data->u.timer.port;
> > +
> > +		/* Restart the timer if it's set */
> 
> The "if it's set" part is stale, maybe this?
> 
> 		/* Start the timer if the new value has a valid vector+expiry. */
> 

Agreed, I'll clean that comment up a bit.

> > +		if (data->u.timer.port && data->u.timer.expires_ns)
> > +			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
> > +					    data->u.timer.expires_ns -
> > +					    get_kvmclock_ns(vcpu->kvm));
> > +
> >  		r = 0;
> >  		break;
> >  
> > -- 
> > 2.34.1
> > 
