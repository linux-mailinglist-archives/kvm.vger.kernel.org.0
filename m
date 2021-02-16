Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275C731C622
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 06:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhBPFEK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 16 Feb 2021 00:04:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:19675 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhBPFEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 00:04:08 -0500
IronPort-SDR: KIWfTWwk961fpo8xO3jJdifMZd1+y+HTCyDaYjHT0Gvvz72BxdS7jO4VTdf+0GLvshACMCTYAE
 d51SVx1tOXxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="246871575"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="246871575"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 21:03:27 -0800
IronPort-SDR: JnDdbw7zRtDYFbq8FuhT/5R0GzJZxduPRKlprLlkCOwZUrbxT9CN6SLhgrgHdmuL5HPHRLy8W7
 UKHIhjCcOB8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="384225230"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2021 21:03:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Feb 2021 21:03:27 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Feb 2021 21:03:26 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Mon, 15 Feb 2021 21:03:26 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>
Subject: RE: [RFC PATCH v5 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Thread-Topic: [RFC PATCH v5 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Thread-Index: AQHXAgqLyQlO6VDl10euDf/K0SnZy6palUwA//+mseA=
Date:   Tue, 16 Feb 2021 05:03:26 +0000
Message-ID: <af4798077c93450e8e30dddbc7c650d0@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <82c304d6f4e8ebfa9b35d1be74360a5004179c5f.1613221549.git.kai.huang@intel.com>
 <YCsq0uFdzwLrFCMW@kernel.org>
In-Reply-To: <YCsq0uFdzwLrFCMW@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> On Sun, Feb 14, 2021 at 02:29:05AM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > The kernel will currently disable all SGX support if the hardware does
> > not support launch control.  Make it more permissive to allow SGX
> > virtualization on systems without Launch Control support.  This will
> > allow KVM to expose SGX to guests that have less-strict requirements
> > on the availability of flexible launch control.
> >
> > Improve error message to distinguish between three cases.  There are
> > two cases where SGX support is completely disabled:
> > 1) SGX has been disabled completely by the BIOS
> > 2) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
> >    of LC unavailability.  SGX virtualization is unavailable (because of
> >    Kconfig).
> > One where it is partially available:
> > 3) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
> >    of LC unavailability.  SGX virtualization is supported.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> > v4->v5:
> >
> >  - No code change.
> >
> > v3->v4:
> >
> >  - Removed cpu_has(X86_FEATURE_SGX1) check in enable_sgx_any, since it
> logically
> >    is not related to KVM SGX series, per Sean.
> >  - Changed declaration of variables to be in reverse-christmas tree style, per
> >    Jarkko.
> >
> > v2->v3:
> >
> >  - Added to use 'enable_sgx_any', per Dave.
> >  - Changed to call clear_cpu_cap() directly, rather than using clear_sgx_caps()
> >    and clear_sgx_lc().
> >  - Changed to use CONFIG_X86_SGX_KVM, instead of
> CONFIG_X86_SGX_VIRTUALIZATION.
> >
> > v1->v2:
> >
> >  - Refined commit message per Dave's comments.
> >  - Added check to only enable SGX virtualization when VMX is supported, per
> >    Dave's comment.
> >  - Refined error msg print to explicitly call out SGX virtualization will be
> >    supported when LC is locked by BIOS, per Dave's comment.
> >
> > ---
> >  arch/x86/kernel/cpu/feat_ctl.c | 57
> > ++++++++++++++++++++++++++--------
> >  1 file changed, 44 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/feat_ctl.c
> > b/arch/x86/kernel/cpu/feat_ctl.c index 27533a6e04fa..96c370284913
> > 100644
> > --- a/arch/x86/kernel/cpu/feat_ctl.c
> > +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);  void
> > init_ia32_feat_ctl(struct cpuinfo_x86 *c)  {
> >  	bool tboot = tboot_enabled();
> > -	bool enable_sgx;
> > +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
> > +	bool enable_vmx;
> >  	u64 msr;
> >
> >  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) { @@ -114,13 +115,21
> @@
> > void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  		return;
> >  	}
> >
> > +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> > +		     IS_ENABLED(CONFIG_KVM_INTEL);
> 
> It's less than 100 characters:

Just carious, shouldn't be 80 characters to wrap a new line, instead of 100?

> 
>         enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> IS_ENABLED(CONFIG_KVM_INTEL);
> 
> This is better:
> 
>         enable_vmx = IS_ENABLED(CONFIG_KVM_INTEL) && cpu_has(c,
> X86_FEATURE_VMX);
> 
> You only want to evaluate cpu_has() if COHNFIG_KVM_INTEL is enabled.

If you look at the original code, cpu_has() comes first. It's just one-time booting time code, and I don't think it matters.

Btw, are you also suggesting IS_ENABLED(CONFIG_X86_SGX) should come before cpu_has() for SGX in below code? 

That being said, cpu_has() comes first for both VMX and SGX in the original code. I don't know why I need to change the sequence in this patch.

> 
> > +
> >  	/*
> > -	 * Enable SGX if and only if the kernel supports SGX and Launch Control
> > -	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
> > +	 * Separate out SGX driver enabling from KVM.  This allows KVM
> > +	 * guests to use SGX even if the kernel SGX driver refuses to
> > +	 * use it.  This happens if flexible Faunch Control is not
> > +	 * available.
> >  	 */
> > -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > -		     IS_ENABLED(CONFIG_X86_SGX);
> > +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> > +			 IS_ENABLED(CONFIG_X86_SGX);
> > +	enable_sgx_driver = enable_sgx_any &&
> > +			    cpu_has(c, X86_FEATURE_SGX_LC);
> > +	enable_sgx_kvm = enable_sgx_any && enable_vmx &&
> > +			  IS_ENABLED(CONFIG_X86_SGX_KVM);
> >
> >  	if (msr & FEAT_CTL_LOCKED)
> >  		goto update_caps;
> > @@ -136,15 +145,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	 * i.e. KVM is enabled, to avoid unnecessarily adding an attack vector
> >  	 * for the kernel, e.g. using VMX to hide malicious code.
> >  	 */
> > -	if (cpu_has(c, X86_FEATURE_VMX) &&
> IS_ENABLED(CONFIG_KVM_INTEL)) {
> > +	if (enable_vmx) {
> >  		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> >
> >  		if (tboot)
> >  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
> >  	}
> >
> > -	if (enable_sgx)
> > -		msr |= FEAT_CTL_SGX_ENABLED |
> FEAT_CTL_SGX_LC_ENABLED;
> > +	if (enable_sgx_kvm || enable_sgx_driver) {
> > +		msr |= FEAT_CTL_SGX_ENABLED;
> > +		if (enable_sgx_driver)
> > +			msr |= FEAT_CTL_SGX_LC_ENABLED;
> > +	}
> >
> >  	wrmsrl(MSR_IA32_FEAT_CTL, msr);
> >
> > @@ -167,10 +179,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	}
> >
> >  update_sgx:
> > -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> > -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> > -		if (enable_sgx)
> > -			pr_err_once("SGX disabled by BIOS\n");
> > +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
> > +		if (enable_sgx_kvm || enable_sgx_driver)
> > +			pr_err_once("SGX disabled by BIOS.\n");
> >  		clear_cpu_cap(c, X86_FEATURE_SGX);
> 
> Empty line before return statement.

It's just two statements inside the if() {} statement. Putting a new line here is too sparse IMHO.

I'd like to hear more.

Dave, do you have any comment?

> 
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * VMX feature bit may be cleared due to being disabled in BIOS,
> > +	 * in which case SGX virtualization cannot be supported either.
> > +	 */
> > +	if (!cpu_has(c, X86_FEATURE_VMX) && enable_sgx_kvm) {
> > +		pr_err_once("SGX virtualization disabled due to lack of VMX.\n");
> > +		enable_sgx_kvm = 0;
> > +	}
> > +
> > +	if (!(msr & FEAT_CTL_SGX_LC_ENABLED) && enable_sgx_driver) {
> > +		if (!enable_sgx_kvm) {
> > +			pr_err_once("SGX Launch Control is locked. Disable
> SGX.\n");
> > +			clear_cpu_cap(c, X86_FEATURE_SGX);
> > +		} else {
> > +			pr_err_once("SGX Launch Control is locked. Support
> SGX virtualization only.\n");
> > +			clear_cpu_cap(c, X86_FEATURE_SGX_LC);
> > +		}
> >  	}
> >  }
> > --
> > 2.29.2
> >
> >
> 
> /Jarkko
