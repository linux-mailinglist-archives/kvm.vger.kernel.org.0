Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4EEF1095
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 08:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbfKFHoz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 6 Nov 2019 02:44:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:30171 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbfKFHoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 02:44:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 23:44:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="227138250"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Nov 2019 23:44:54 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 5 Nov 2019 23:44:54 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 5 Nov 2019 23:44:54 -0800
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 5 Nov 2019 23:44:53 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.108]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 15:44:52 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     'Peter Zijlstra' <peterz@infradead.org>
CC:     "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'pbonzini@redhat.com'" <pbonzini@redhat.com>,
        "'rkrcmar@redhat.com'" <rkrcmar@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "'vkuznets@redhat.com'" <vkuznets@redhat.com>,
        "'wanpengli@tencent.com'" <wanpengli@tencent.com>,
        "'jmattson@google.com'" <jmattson@google.com>,
        "'joro@8bytes.org'" <joro@8bytes.org>,
        "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        "'bp@alien8.de'" <bp@alien8.de>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'x86@kernel.org'" <x86@kernel.org>,
        "'ak@linux.intel.com'" <ak@linux.intel.com>,
        "'thomas.lendacky@amd.com'" <thomas.lendacky@amd.com>,
        "'acme@kernel.org'" <acme@kernel.org>,
        "'mark.rutland@arm.com'" <mark.rutland@arm.com>,
        "'alexander.shishkin@linux.intel.com'" 
        <alexander.shishkin@linux.intel.com>,
        "'jolsa@redhat.com'" <jolsa@redhat.com>,
        "'namhyung@kernel.org'" <namhyung@kernel.org>
Subject: RE: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS
 event
Thread-Topic: [PATCH v1 3/8] KVM: x86: Allocate performance counter for PEBS
 event
Thread-Index: AQHVjLd13+lWyOpx00qD/bA0eE059qdxL6sAgAEppjCAABXXgIACK7fwgAk3MFA=
Date:   Wed, 6 Nov 2019 07:44:51 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1738387F8@SHSMSX104.ccr.corp.intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-4-git-send-email-luwei.kang@intel.com>
 <20191029144612.GK4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173835B1A@SHSMSX104.ccr.corp.intel.com>
 <20191030094941.GQ4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E17383642D@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E17383642D@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzE3NjQyYjEtYmE2OS00YjI4LTk2MjUtMmVlZTIwM2Y2M2UzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiR2xDRGN4bHZSakV6S01JcHJMaVJnZFFmcTl3NHRyN0U4UkNOTmoxR0RsXC8rVmJKV1g4WGx0NWVDQTlvT3hFXC9EIn0=
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

> > > > >  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> > > > >  				  unsigned config, bool exclude_user,
> > > > >  				  bool exclude_kernel, bool intr,
> > > > > -				  bool in_tx, bool in_tx_cp)
> > > > > +				  bool in_tx, bool in_tx_cp, bool pebs)
> > > > >  {
> > > > >  	struct perf_event *event;
> > > > >  	struct perf_event_attr attr = { @@ -111,9 +111,12 @@ static
> > > > > void pmc_reprogram_counter(struct kvm_pmc *pmc,
> > u32 type,
> > > > >  		.exclude_user = exclude_user,
> > > > >  		.exclude_kernel = exclude_kernel,
> > > > >  		.config = config,
> > > > > +		.precise_ip = pebs ? 1 : 0,
> > > > > +		.aux_output = pebs ? 1 : 0,
> > > >
> > > > srsly?
> > >
> > > Hi Peter,
> > >     Thanks for review. For aux_output, I think it should be set 1
> > > when the guest wants to
> > enabled PEBS by Intel PT.
> > >      For precise_ip, it is the precise level in perf and set by perf
> > > command line in KVM
> > guest, this may not reflect the accurate value (can be 0~3) here. Here
> > set to 1 is used to allocate a counter for PEBS event and set the
> > MSR_IA32_PEBS_ENABLE register. For PMU virtualization, KVM will trap
> > the guest's write operation to PMU registers and allocate/free event
> > counter from host if a counter enable/disable in guest. We can't
> > always deduce the exact parameter of perf command line from the value of the guest
> writers to the register.
> >
> > Please, teach your MUA to wrap on 78 chars.
> >
> > The thing I really fell over is the gratuitous 'bool ? 1 : 0'. But
> > yes, the aux_output without a group leader is dead wrong. We'll go fix
> > perf_event_create_kernel_counter() to refuse that.
> 
> Yes, I also think it is a little gratuitous here. But it is a little hard to reconstruct the guest
> perf parameters from the register value, especially the "precise_ip". Do you have any
> advice?
> 
> About refuse the perf_event_create_kernel_counter() request w/o aux_ouput, I think I
> need to allocate the PT event as group leader here,  is that right?

Hi Peter,
     What's your opinion?

Thanks,
Luwei Kang
