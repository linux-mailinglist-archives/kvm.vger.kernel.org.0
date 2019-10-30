Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1BEE958C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 05:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfJ3EHH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 30 Oct 2019 00:07:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:24712 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbfJ3EHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 00:07:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 21:07:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,246,1569308400"; 
   d="scan'208";a="198564310"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga008.fm.intel.com with ESMTP; 29 Oct 2019 21:07:06 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 21:07:06 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 fmsmsx158.amr.corp.intel.com (10.18.116.75) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 21:07:06 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.60]) with mapi id 14.03.0439.000;
 Wed, 30 Oct 2019 12:07:04 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: RE: [PATCH v1 7/8] KVM: x86: Expose PEBS feature to guest
Thread-Topic: [PATCH v1 7/8] KVM: x86: Expose PEBS feature to guest
Thread-Index: AQHVjLd7lPe74bngJEyQFMJJsvDDF6dxNRGAgAFBajA=
Date:   Wed, 30 Oct 2019 04:07:03 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E173835B45@SHSMSX104.ccr.corp.intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-8-git-send-email-luwei.kang@intel.com>
 <20191029150531.GN4097@hirez.programming.kicks-ass.net>
In-Reply-To: <20191029150531.GN4097@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDMzOTNmY2QtYWU5MS00YThhLWE5MTctZjg1OThhNDBiZmEwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMjkzaDh2WUZWVDRpcGQ5aFowUHdZWms0MTNVQ25ZbDJOVlwvQjVHUUZHOXFxZndJN3dBTWdDaWZZZVBpRjY2ZnMifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Expose PEBS feature to guest by IA32_MISC_ENABLE[bit12].
> > IA32_MISC_ENABLE[bit12] is Processor Event Based Sampling (PEBS)
> > Unavailable (RO) flag:
> > 1 = PEBS is not supported; 0 = PEBS is supported.
> 
> Why does it make sense to expose this on SVM?

Thanks for the review. This patch won't expose the pebs feature to SVM and return not supported.

> 
> > Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/svm.c              |  6 ++++++
> >  arch/x86/kvm/vmx/vmx.c          |  1 +
> >  arch/x86/kvm/x86.c              | 22 +++++++++++++++++-----
> >  4 files changed, 25 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h
> > b/arch/x86/include/asm/kvm_host.h index 24a0ab9..76f5fa5 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1127,6 +1127,7 @@ struct kvm_x86_ops {
> >  	bool (*xsaves_supported)(void);
> >  	bool (*umip_emulated)(void);
> >  	bool (*pt_supported)(void);
> > +	bool (*pebs_supported)(void);
> >  	bool (*pdcm_supported)(void);
> >
> >  	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool
> > external_intr); diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 7e0a7b3..3a1bbb3 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -5975,6 +5975,11 @@ static bool svm_pt_supported(void)
> >  	return false;
> >  }
> >
> > +static bool svm_pebs_supported(void)
> > +{
> > +	return false;
> > +}
> > +
> >  static bool svm_pdcm_supported(void)
> >  {
> >  	return false;
> > @@ -7277,6 +7282,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> >  	.xsaves_supported = svm_xsaves_supported,
> >  	.umip_emulated = svm_umip_emulated,
> >  	.pt_supported = svm_pt_supported,
> > +	.pebs_supported = svm_pebs_supported,
> >  	.pdcm_supported = svm_pdcm_supported,
> >
> >  	.set_supported_cpuid = svm_set_supported_cpuid, diff --git
> > a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > 5c4dd05..3c370a3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7879,6 +7879,7 @@ static __exit void hardware_unsetup(void)
> >  	.xsaves_supported = vmx_xsaves_supported,
> >  	.umip_emulated = vmx_umip_emulated,
> >  	.pt_supported = vmx_pt_supported,
> > +	.pebs_supported = vmx_pebs_supported,
> >  	.pdcm_supported = vmx_pdcm_supported,
> >
> >  	.request_immediate_exit = vmx_request_immediate_exit, diff --git
> > a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index 661e2bf..5f59073
> > 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2591,6 +2591,7 @@ static void record_steal_time(struct kvm_vcpu
> > *vcpu)  int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data
> > *msr_info)  {
> >  	bool pr = false;
> > +	bool update_cpuid = false;
> >  	u32 msr = msr_info->index;
> >  	u64 data = msr_info->data;
> >
> > @@ -2671,11 +2672,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
> >  			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
> >  				return 1;
> > -			vcpu->arch.ia32_misc_enable_msr = data;
> > -			kvm_update_cpuid(vcpu);
> > -		} else {
> > -			vcpu->arch.ia32_misc_enable_msr = data;
> > +			update_cpuid = true;
> >  		}
> > +
> > +		if (kvm_x86_ops->pebs_supported())
> > +			data &=  ~MSR_IA32_MISC_ENABLE_PEBS;
> 
> whitespace damage

Yes. Will fix it and below coding style violation.

Thanks,
Luwei Kang

> 
> > +		else
> > +			data |= MSR_IA32_MISC_ENABLE_PEBS;
> > +
> > +		vcpu->arch.ia32_misc_enable_msr = data;
> > +		if (update_cpuid)
> > +			kvm_update_cpuid(vcpu);
> >  		break;
> >  	case MSR_IA32_SMBASE:
> >  		if (!msr_info->host_initiated)
> > @@ -2971,7 +2978,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		msr_info->data = (u64)vcpu->arch.ia32_tsc_adjust_msr;
> >  		break;
> >  	case MSR_IA32_MISC_ENABLE:
> > -		msr_info->data = vcpu->arch.ia32_misc_enable_msr;
> > +		if (kvm_x86_ops->pebs_supported())
> > +			msr_info->data = (vcpu->arch.ia32_misc_enable_msr &
> > +						~MSR_IA32_MISC_ENABLE_PEBS);
> > +		else
> > +			msr_info->data = (vcpu->arch.ia32_misc_enable_msr |
> > +						MSR_IA32_MISC_ENABLE_PEBS);
> 
> Coding style violation.
> 
> >  		break;
> >  	case MSR_IA32_SMBASE:
> >  		if (!msr_info->host_initiated)
> > --
> > 1.8.3.1
> >
