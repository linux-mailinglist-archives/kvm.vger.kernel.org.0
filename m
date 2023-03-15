Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60266BA43F
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 01:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCOArs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 20:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCOArq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 20:47:46 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF614E4
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 17:47:45 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id v15-20020a17090a458f00b0023816b2f381so6975516pjg.2
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 17:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678841265;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EwBPx+UqTO7grWmvIHxQBcyLrYQZ/vCH68LZPZ9S27k=;
        b=PpujC94juOdIxalzZNUL4tG38/HNR2WGhAGj9T1fvOcxs2slzb10featCWd873gRxJ
         bkZp7WhjdLIw3jJWE7qsd03ysV7ptnc33mhSgilPFlHkZrrM+67GV2i5MY+jT4kdepKy
         lHoVlgDV9IaZP1TKAsFzUF4bOcjIeqJCtaV6tYKjCclel8wqSorc2bCWleFDpKshIRkd
         zCQJkxdCe2QVwjs23XRmX8bhnI5cLCTNdCcs2Dy86/hZ3j8APwbvdEUu4yTGcFq1wvn1
         i5CQsNX/SOlk1oekGZxN1NS+WtB3FEKhNqrT75ElUEbLEd4JFj3ZDE7VHt93kwn6k/OT
         KF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678841265;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EwBPx+UqTO7grWmvIHxQBcyLrYQZ/vCH68LZPZ9S27k=;
        b=zQ3221BQ1OeIbo7UOLIVLXhxmgsHHLBqdoFkR0Eyzbbvaheq0ko9E6m7AzI+Qx7dLH
         WZs5hGdyxcaUXAtZbyGJIgDE5PWAkLIGIzNpPGOGwFsDpHlvWP9menSLo9o4Bx1RlqD3
         KpZV7tYs5Gi4dxi+6SeqUWTbO9eW/Ivwzd4wJ8oTTdRD85X490PE/f2tCd8yH81x+81a
         10+oOzDvU0unxgeskvaykKE20t0y4jyUTyXfrj4AHY3Amj66Kc85A/zecJSw2BucPUlU
         eQeMnjy/BugjiM2eDrcuWJVjPKIqb1Xuxso9qlW+zLwAegagKwI92bTooPxbqacZK51c
         L8lQ==
X-Gm-Message-State: AO0yUKUkyQ07Oc9ZQpVVRvd6/6vsy28dnX//YsKH1HM+j12DagayVguW
        9VS1hOQoINpR/BHo9kNr+2JTzU3uSWE=
X-Google-Smtp-Source: AK7set+Ego0QgpRq74ayNUnPPG6DkSW/keRy1zLO+iY+AOV355NsEY8KkhW5jZcxHtbLJcx+p9Hh5wyQN1c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1312:b0:1a0:5402:b17b with SMTP id
 iy18-20020a170903131200b001a05402b17bmr444844plb.0.1678841265253; Tue, 14 Mar
 2023 17:47:45 -0700 (PDT)
Date:   Tue, 14 Mar 2023 17:47:43 -0700
In-Reply-To: <9f8c89bf44a8eb68407369d26956c24082562cd2.camel@intel.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com> <20230310214232.806108-6-seanjc@google.com>
 <ce2330db94b05605a0649a3da0595211c5bd71dd.camel@intel.com>
 <ZA9avcHRPoIqZP/n@google.com> <9f8c89bf44a8eb68407369d26956c24082562cd2.camel@intel.com>
Message-ID: <ZBEVc0/vD5tEj29e@google.com>
Subject: Re: [PATCH v2 05/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023, Huang, Kai wrote:
> On Mon, 2023-03-13 at 10:18 -0700, Sean Christopherson wrote:
> > On Mon, Mar 13, 2023, Huang, Kai wrote:
> > > On Fri, 2023-03-10 at 13:42 -0800, Sean Christopherson wrote:
> > > > Use the virt callback to disable SVM (and set GIF=3D1) during an em=
ergency
> > > > instead of blindly attempting to disable SVM.=EF=BF=BD Like the VMX=
 case, if KVM
> > > > (or an out-of-tree hypervisor) isn't loaded/active, SVM can't be in=
 use.
> > > >=20
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > >=20
> > > [...]
> > >=20
> > > > -#if IS_ENABLED(CONFIG_KVM_INTEL)
> > > > +#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
> > > > =EF=BF=BD/* RCU-protected callback to disable virtualization prior =
to reboot. */
> > > > =EF=BF=BDstatic cpu_emergency_virt_cb __rcu *cpu_emergency_virt_cal=
lback;
> > > > =EF=BF=BD
> > > > @@ -821,7 +821,7 @@ int crashing_cpu =3D -1;
> > > > =EF=BF=BD */
> > > > =EF=BF=BDvoid cpu_emergency_disable_virtualization(void)
> > > > =EF=BF=BD{
> > > > -#if IS_ENABLED(CONFIG_KVM_INTEL)
> > > > +#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
> > > > =EF=BF=BD	cpu_emergency_virt_cb *callback;
> > > > =EF=BF=BD
> > > > =EF=BF=BD	rcu_read_lock();
> > > > @@ -830,8 +830,6 @@ void cpu_emergency_disable_virtualization(void)
> > > > =EF=BF=BD		callback();
> > > > =EF=BF=BD	rcu_read_unlock();
> > > > =EF=BF=BD#endif
> > > > -	/* KVM_AMD doesn't yet utilize the common callback. */
> > > > -	cpu_emergency_svm_disable();
> > > > =EF=BF=BD}
> > >=20
> > > Shouldn't the callback be always present since you want to consider '=
out-of-
> > > tree' hypervisor case?
> >=20
> > No?  The kernel doesn't provide any guarantees for out-of-tree code.  I=
 don't have
> > a super strong preference, though I do like the effective documentation=
 the checks
> > provide.  Buy more importantly, my understanding is that the x86 mainta=
iners want
> > to limit the exposure for these types of interfaces, e.g. `git grep IS_=
ENABLED\(CONFIG_KVM`
> > for a variety of hooks that are enabled iff KVM is enabled in the kerne=
l config.
>=20
> How about doing the embracing the code to do the emergency virt callback =
as the
> last step?

I like that idea, it also makes a few other patches a bit cleaner.

> I like the "cleanup" work in this series regardless whether we should gua=
rd the
> emergency virt callback with CONFIG_KVM_INTEL || CONFIG_KVM_AMD.  If we d=
o the
> actual "cleanup" work first, and put the CONFIG_KVM_INTEL || CONFIG_KVM_A=
MD as
> the last step, it is also easier to review I guess, because it's kinda a
> separate logic independent to the actual "cleanup" work.
>=20
> Also, personally I don't particularly like the middle state in patch 04:
>=20
>  void cpu_emergency_disable_virtualization(void)
>  {
>  #if IS_ENABLED(CONFIG_KVM_INTEL)
> -	cpu_crash_vmclear_loaded_vmcss();
> -#endif
> +	cpu_emergency_virt_cb *callback;
> =20
> -	cpu_emergency_vmxoff();
> +	rcu_read_lock();
> +	callback =3D rcu_dereference(cpu_emergency_virt_callback);
> +	if (callback)
> +		callback();
> +	rcu_read_unlock();
> +#endif
> +	/* KVM_AMD doesn't yet utilize the common callback. */
>  	cpu_emergency_svm_disable();
>  }
>=20
> Which eventually got fixed up in patch 05:
>=20
>  void cpu_emergency_disable_virtualization(void)
>  {
> -#if IS_ENABLED(CONFIG_KVM_INTEL)
> +#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
>  	cpu_emergency_virt_cb *callback;
> =20
>  	rcu_read_lock();
> @@ -830,8 +830,6 @@ void cpu_emergency_disable_virtualization(void)
>  		callback();
>  	rcu_read_unlock();
>  #endif
> -	/* KVM_AMD doesn't yet utilize the common callback. */
> -	cpu_emergency_svm_disable();
>  }
> =20
> Could we just merge the two patches together?=20

I'd prefer not to squash the two.  I agree it's ugly, but I dislike convert=
ing
VMX and SVM at the same time.  I'm not totally opposed to moving everything=
 in
one fell swoop, but my preference is to keep them separate.
