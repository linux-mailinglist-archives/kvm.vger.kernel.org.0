Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD27A7A2186
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 16:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbjIOOwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 10:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbjIOOwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 10:52:07 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BE01FD2
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 07:52:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59c0dd156e5so8946537b3.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 07:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694789521; x=1695394321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pxBgjf4cFGqduUhZ9Ofgvxr6N7enlbl7a5N9uijxEC4=;
        b=lRIoQDzjFLY03ilV7tTmj67bO7QNiEYa0foiClX7X9p0ylZEMBPmxWKJBoM4nbbeaC
         vrRDd+3t5VnSD1YTU96pFV1FH6p6HEqTMvqLLGqbvQu5BbNhXXfKbfCQ0jzsPhBuX0MA
         aT3wrYRGS2tI2OqjFufYWBFo7P/8cNYxks4Bd9Gao2CKyDOxkx5O/89C9ZUuhn65zKDd
         Jobj3xrGpMFT/lr7ImUjFHnIeBw/1y32IWAl2xlk2HOMcZ8ohiXzwmjZKBPWRigFQ71L
         5CfzYqNdru/FY7KKfD8kQC7RpLw6i8627LZGjLSjabQqCxN8Cv6WfB4gDxJcINAQhBYg
         lA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694789521; x=1695394321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxBgjf4cFGqduUhZ9Ofgvxr6N7enlbl7a5N9uijxEC4=;
        b=mXLLfpve2Nczs3NNGaHH0who5W3cDFUhZiwrwjk/8TbHxs/Zfc1CWbR8uZq/pMSx+P
         D5M35qKAQ+SAaHgAuD2jRX2/PjFfnk1tngiSYWHwuvKTYQ+KxFPPHxW+ODKy4800hake
         bn1zKdrK4AYfLgxZYErrR+y3OUjCF+pzxCBsvezIlldr42j5h569bgmQmn9uNcUPV/JH
         CfdQ0ibh4DxGoZYY2C0DJ8AgOjTQTEJcDgKY8sOHv5/EjF6nvLRp6758cdvULH2lAaIQ
         YoTCXENE2ppwYhbalmkrTyuctfewBVg3EPFxahCSwo1xHkhhvGP555NvZMggQyr1F6MR
         HiUA==
X-Gm-Message-State: AOJu0YxLbMR0Nwz3T76vFusbWIULDTO6Ryd5UAmET93xBkJrA4HepWgX
        uq3wmxxjdVo5p5BL42ftOfGLWbSWU7c=
X-Google-Smtp-Source: AGHT+IF2Ec1htPRQajwMXl2rb+28B3EL6IeFXs5CguJre2yMRWQYZ8onAhbuCs/7FoHHfHQreuCyqW94Rfc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af28:0:b0:584:3d8f:a425 with SMTP id
 n40-20020a81af28000000b005843d8fa425mr51269ywh.10.1694789521683; Fri, 15 Sep
 2023 07:52:01 -0700 (PDT)
Date:   Fri, 15 Sep 2023 07:51:59 -0700
In-Reply-To: <ZQRtpVjXTwjeJ5rI@google.com>
Mime-Version: 1.0
References: <cover.1694721045.git.thomas.lendacky@amd.com> <025fd734d35acbbbbca74c4b3ed671a02d4af628.1694721045.git.thomas.lendacky@amd.com>
 <ZQRtpVjXTwjeJ5rI@google.com>
Message-ID: <ZQRvjy/NQa3HcKsY@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Do not use user return MSR support for
 virtualized TSC_AUX
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023, Sean Christopherson wrote:
> On Thu, Sep 14, 2023, Tom Lendacky wrote:
> > When the TSC_AUX MSR is virtualized, the TSC_AUX value is swap type "B"
> > within the VMSA. This means that the guest value is loaded on VMRUN and
> > the host value is restored from the host save area on #VMEXIT.
> > 
> > Since the value is restored on #VMEXIT, the KVM user return MSR support
> > for TSC_AUX can be replaced by populating the host save area with current
> > host value of TSC_AUX. This replaces two WRMSR instructions with a single
> > RDMSR instruction.
> > 
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 14 +++++++++++++-
> >  arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++----------
> >  arch/x86/kvm/svm/svm.h |  4 +++-
> >  3 files changed, 32 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 565c9de87c6d..1bbaae2fed96 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2969,6 +2969,7 @@ static void sev_es_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)
> >  	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
> >  	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
> >  	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
> > +		svm->v_tsc_aux = true;
> >  		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
> >  		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> >  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> > @@ -3071,8 +3072,10 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
> >  					    sev_enc_bit));
> >  }
> >  
> > -void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> > +void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
> >  {
> > +	u32 msr_hi;
> > +
> >  	/*
> >  	 * All host state for SEV-ES guests is categorized into three swap types
> >  	 * based on how it is handled by hardware during a world switch:
> > @@ -3109,6 +3112,15 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> >  		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
> >  		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
> >  	}
> > +
> > +	/*
> > +	 * If TSC_AUX virtualization is enabled, MSR_TSC_AUX is loaded but NOT
> > +	 * saved by the CPU (Type-B). If TSC_AUX is not virtualized, the user
> > +	 * return MSR support takes care of restoring MSR_TSC_AUX. This
> > +	 * exchanges two WRMSRs for one RDMSR.
> > +	 */
> > +	if (svm->v_tsc_aux)
> > +		rdmsr(MSR_TSC_AUX, hostsa->tsc_aux, msr_hi);
> 
> IIUC, when V_TSC_AUX is supported, SEV-ES guests context switch MSR_TSC_AUX
> regardless of what has been exposed to the guest.  So rather than condition the
> hostsa->tsc_aux update on guest CPUID, just do it if V_TSC_AUX is supported.
> 
> And then to avoid the RDMSR, which is presumably the motivation for checking
> guest CPUID, grab the host value from user return framework.  The host values
> are per-CPU, but constant after boot, so the only requirement is that KVM sets
> up MSR_TSC_AUX in the user return framework.

Actually, duh.  The save area is also per-CPU, so just fill hostsa->tsc_aux in
svm_hardware_setup() and then sev_es_prepare_switch_to_guest() never has to do
anything.
