Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 032A6E9587
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 05:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfJ3EGx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 30 Oct 2019 00:06:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:36903 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfJ3EGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 00:06:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 21:06:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,246,1569308400"; 
   d="scan'208";a="205679958"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2019 21:06:51 -0700
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 21:06:51 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 21:06:50 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.149]) with mapi id 14.03.0439.000;
 Wed, 30 Oct 2019 12:06:50 +0800
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
Subject: RE: [PATCH v1 2/8] KVM: x86: PEBS output to Intel PT MSRs emulation
Thread-Topic: [PATCH v1 2/8] KVM: x86: PEBS output to Intel PT MSRs emulation
Thread-Index: AQHVjLdyhOcLoCoSDkKqY/nWjYpZ1qdxNEmAgAE5RbA=
Date:   Wed, 30 Oct 2019 04:06:49 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E173835B2F@SHSMSX104.ccr.corp.intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-3-git-send-email-luwei.kang@intel.com>
 <20191029150243.GM4097@hirez.programming.kicks-ass.net>
In-Reply-To: <20191029150243.GM4097@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjE2ZTE1MmEtZDQ2Mi00ZTM2LThmNzctN2ZjM2Q1MjgwOTdkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicXZxMFdINjhNNVM1UWlrUjNyNmt3WnZvaGxPR1MxS0dVWWpWWnFwK0tuQ1RKenFSbkl0VE8zUVVKNG9YWWJGSSJ9
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

> > Intel new hardware introduces a mechanism to direct PEBS records
> > output into the Intel PT buffer that can be used for enabling PEBS in
> > KVM guest. This patch implements the registers read and write
> > emulation when PEBS is supported in KVM guest.
> >
> > KMM needs to reprogram the counters when the value of these MSRs be
> > changed that to make sure it can take effect in hardware.
> >
> > Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h  |  4 +++
> > arch/x86/include/asm/msr-index.h |  6 ++++
> > arch/x86/kvm/vmx/capabilities.h  | 15 ++++++++++
> >  arch/x86/kvm/vmx/pmu_intel.c     | 63 ++++++++++++++++++++++++++++++++++++++--
> >  4 files changed, 86 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/msr-index.h
> > b/arch/x86/include/asm/msr-index.h
> > index 20ce682..d22f8d9 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -131,9 +131,13 @@
> >  #define LBR_INFO_ABORT			BIT_ULL(61)
> >  #define LBR_INFO_CYCLES			0xffff
> >
> > +#define MSR_IA32_PEBS_PMI_AFTER_REC	BIT_ULL(60)
> > +#define MSR_IA32_PEBS_OUTPUT_PT		BIT_ULL(61)
> > +#define MSR_IA32_PEBS_OUTPUT_MASK	(3ULL << 61)
> >  #define MSR_IA32_PEBS_ENABLE		0x000003f1
> >  #define MSR_PEBS_DATA_CFG		0x000003f2
> >  #define MSR_IA32_DS_AREA		0x00000600
> > +#define MSR_IA32_PERF_CAP_PEBS_OUTPUT_PT	BIT_ULL(16)
> >  #define MSR_IA32_PERF_CAPABILITIES	0x00000345
> >  #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
> >
> > @@ -665,6 +669,8 @@
> >  #define MSR_IA32_MISC_ENABLE_FERR			(1ULL << MSR_IA32_MISC_ENABLE_FERR_BIT)
> >  #define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT		10
> >  #define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX		(1ULL << MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX_BIT)
> > +#define MSR_IA32_MISC_ENABLE_PEBS_BIT			12
> > +#define MSR_IA32_MISC_ENABLE_PEBS			(1ULL << MSR_IA32_MISC_ENABLE_PEBS_BIT)
> >  #define MSR_IA32_MISC_ENABLE_TM2_BIT			13
> >  #define MSR_IA32_MISC_ENABLE_TM2			(1ULL << MSR_IA32_MISC_ENABLE_TM2_BIT)
> >  #define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE_BIT	19
> 
> Some of these already exist but are local to perf. Don't blindly introduce more without unifying.

Got it. Will reuse the exist definition in perf.

Thanks,
Luwei Kang
