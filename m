Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B457F6C15AC
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbjCTO4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjCTO4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:56:01 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4DB7D8B
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:54:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54196bfcd5fso122366067b3.4
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679324037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qQGGTioDiFhMUev8HEdAuk60WbDrELdDZuLoywdGHhs=;
        b=ek9Rtks1+RLLIGYP9pLXyiQGTAdkwhYdChftSdXgUbweUuBMHdtsjTM9Az9+3nmUqY
         C5CRfRQOxBw2lI9piPSumO+6TQ6VLkgq7iFSRGODmyNP69JeGXwu/nNsLVidcw3SwJvs
         v2EAbrCloIyJhbbnzTOHgmODWsDgqRt7rseU5bdbSsEKQepvGjSzWBwHNTGzXkkXUsH9
         +2v/jBVNnCU5mw3/l3VF2SWMpt+vmMJ64lzIPdHJtTeqiLXECoLJ78ms9qX18R81AUNe
         YYYPzgPijo5X/3Rsf/9a1xbivqSM3r5skWcJRU5BR+uXZjKlBbrQIzzYG1cDdZ6bU1Ag
         4eHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679324037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qQGGTioDiFhMUev8HEdAuk60WbDrELdDZuLoywdGHhs=;
        b=sklPpcB6iunJ+U0xPKIAtr2Jg3lJX4Xuxd2Ui0KX/2kp0zzUNBZqllQQkj7jPO8JIH
         2BdzvaXyv3Yh9C8PZVQSNwMNXIQfTGU5vmEfzrCCC7gEO6wgZBLdFVq393VKc0UBFFKQ
         /sLs55Tt1W+jywD2KjpeV74csveemunGhxd+/ATs1SJhJ2R+bNYGtGhTAfGIXA1TtHg4
         X8z7vbKcohGgU4mps9X+5er9xyRoBXnxvKHNiyaXLPvrlQe8SXxDZYtRQ01mFMmZWqT/
         0xaFA+/GyABaqPVrY9ouBnnBEL+BNlW9QuXcpbNKfnaS74YbAlfPONos3Aq668egO82g
         XVnA==
X-Gm-Message-State: AO0yUKUfRePEITj8d2FjmcwJH02kCazz6pbK/r8PynIViErE5E3um2uo
        bdIuvzk5Nyaex/mZ4oHT7NxjlNxJkVg=
X-Google-Smtp-Source: AK7set/PCK3X9s+E6GRIICuOFmnyzneuIcUGunPdbFL18912Eq2A09I5mT3JJrRlAsxBuRZ/JtaocvKtfEI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c749:0:b0:541:753d:32f9 with SMTP id
 i9-20020a81c749000000b00541753d32f9mr10653263ywl.9.1679324037680; Mon, 20 Mar
 2023 07:53:57 -0700 (PDT)
Date:   Mon, 20 Mar 2023 07:53:56 -0700
In-Reply-To: <20230317235959.buk3y25iwllscrbe@desk>
Mime-Version: 1.0
References: <20230201132905.549148-1-eesposit@redhat.com> <20230201132905.549148-2-eesposit@redhat.com>
 <20230317190432.GA863767@dev-arch.thelio-3990X> <20230317225345.z5chlrursjfbz52o@desk>
 <20230317231401.GA4100817@dev-arch.thelio-3990X> <20230317235959.buk3y25iwllscrbe@desk>
Message-ID: <ZBhzhPDk+EV1zRf0@google.com>
Subject: Re: [PATCH 1/3] kvm: vmx: Add IA32_FLUSH_CMD guest support
From:   Sean Christopherson <seanjc@google.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023, Pawan Gupta wrote:
> On Fri, Mar 17, 2023 at 04:14:01PM -0700, Nathan Chancellor wrote:
> > On Fri, Mar 17, 2023 at 03:53:45PM -0700, Pawan Gupta wrote:
> > > On Fri, Mar 17, 2023 at 12:04:32PM -0700, Nathan Chancellor wrote:
> > > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > > index c788aa382611..9a78ea96a6d7 100644
> > > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > > @@ -2133,6 +2133,39 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
> > > > >  	return debugctl;
> > > > >  }
> > > > >  
> > > > > +static int vmx_set_msr_ia32_cmd(struct kvm_vcpu *vcpu,
> > > > > +				struct msr_data *msr_info,
> > > > > +				bool guest_has_feat, u64 cmd,
> > > > > +				int x86_feature_bit)
> > > > > +{
> > > > > +	if (!msr_info->host_initiated && !guest_has_feat)
> > > > > +		return 1;
> > > > > +
> > > > > +	if (!(msr_info->data & ~cmd))
> > > 
> > > Looks like this is doing a reverse check. Shouldn't this be as below:
> > 
> > That diff on top of next-20230317 appears to resolve the issue for me
> > and my L1 guest can spawn an L2 guest without any issues (which is the
> > extent of my KVM testing).
> 
> Great!
> 
> > Is this a problem for the SVM version? It has the same check it seems,
> > although I did not have any issues on my AMD test platform (but I guess
> > that means that the system has the support?).
> 
> IIUC, SVM version also needs to be fixed.

Yeah, looks that way.  If we do go this route, can you also rename "cmd" to something
like "allowed_mask"?  It took me far too long to understand what "cmd" represents.

> > I assume this will just be squashed into the original change but if not:
> 
> Thats what I think, and if its too late to be squashed I will send a
> formal patch. Maintainers?

Honestly, I'd rather revert the whole mess and try again.  The patches obviously
weren't tested, and the entire approach (that was borrowed from the existing
MSR_IA32_PRED_CMD code) makes no sense.

The MSRs are write-only command registers, i.e. don't have a persistent value.
So unlike MSR_IA32_SPEC_CTRL (which I suspect was the source for the copy pasta),
where KVM needs to track the guest value, there are no downsides to disabling
interception of the MSRs.  

Manually checking the value written by the guest or host userspace is similarly
ridiculous.  The MSR is being exposed directly to the guest, i.e. after the first
access, the guest can throw any value at bare metal anyways, so just do wrmsrl_safe()
and call it good.

In other words, the common __kvm_set_msr() switch should have something like so,

	case MSR_IA32_PRED_CMD:
		if (!cpu_feature_enabled(X86_FEATURE_IBPB))
			return 1;

		if (!msr_info->host_initiated &&
		    !guest_cpuid_has(vcpu, guest_has_pred_cmd_msr(vcpu)))
			return 1;

		ret = !!wrmsrl_safe(MSR_IA32_PRED_CMD, msr_info->data);
		break;
	case MSR_IA32_FLUSH_CMD:
		if (!cpu_feature_enabled(X86_FEATURE_FLUSH_L1D))
			return 1;

		if (!msr_info->host_initiated &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
			return 1;

		ret = !!wrmsrl_safe(MSR_IA32_FLUSH_CMD, msr_info->data);
		break;

with the MSR interception handled in e.g. vmx_vcpu_after_set_cpuid().

Paolo?
