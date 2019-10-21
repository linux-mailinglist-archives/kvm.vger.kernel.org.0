Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BF3DE443
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 08:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfJUGCc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 21 Oct 2019 02:02:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:3890 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbfJUGCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 02:02:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Oct 2019 23:02:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,322,1566889200"; 
   d="scan'208";a="222361367"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga004.fm.intel.com with ESMTP; 20 Oct 2019 23:02:31 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 20 Oct 2019 23:02:31 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 20 Oct 2019 23:02:30 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 20 Oct 2019 23:02:30 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX152.ccr.corp.intel.com ([10.239.6.52]) with mapi id 14.03.0439.000;
 Mon, 21 Oct 2019 14:02:29 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: RE: [PATCH v4 2/2] i386: Add support to get/set/migrate Intel
 Processor Trace feature
Thread-Topic: [PATCH v4 2/2] i386: Add support to get/set/migrate Intel
 Processor Trace feature
Thread-Index: AQHVgKsg+eNsNdVZH0GZ6Dwyyz/Lp6dbpngw//+LOYCACWt2QA==
Date:   Mon, 21 Oct 2019 06:02:28 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E17382BB76@SHSMSX104.ccr.corp.intel.com>
References: <1520182116-16485-1-git-send-email-luwei.kang@intel.com>
 <1520182116-16485-2-git-send-email-luwei.kang@intel.com>
 <20191012031407.GK4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382A209@SHSMSX104.ccr.corp.intel.com>
 <20191015132929.GY4084@habkost.net>
In-Reply-To: <20191015132929.GY4084@habkost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTk4OWUwODctY2U0Ni00NDhmLTkzMGItOTRiOTc5NjVhMzNmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVjRobHg4aGRkZVh2MGlxQ0RYMTIyNDNWd0RtMmdPb2NGUGpxVDlJTjVaMUx5cGU0T3JTUk9RNU9NemhQK1dVYyJ9
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

> > > > f9f4cd1..097c953 100644
> > > > --- a/target/i386/kvm.c
> > > > +++ b/target/i386/kvm.c
> > > > @@ -1811,6 +1811,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
> > > >                  kvm_msr_entry_add(cpu, MSR_MTRRphysMask(i), mask);
> > > >              }
> > > >          }
> > > > +        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
> > > > +            int addr_num = kvm_arch_get_supported_cpuid(kvm_state,
> > > > +                                                    0x14, 1,
> > > > + R_EAX) & 0x7;
> > > > +
> > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
> > > > +                            env->msr_rtit_ctrl);
> > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS,
> > > > +                            env->msr_rtit_status);
> > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_BASE,
> > > > +                            env->msr_rtit_output_base);
> > >
> > > This causes the following crash on some hosts:
> > >
> > >   qemu-system-x86_64: error: failed to set MSR 0x560 to 0x0
> > >   qemu-system-x86_64: target/i386/kvm.c:2673: kvm_put_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> > >
> > > Checking for CPUID_7_0_EBX_INTEL_PT is not enough: KVM has
> > > additional conditions that might prevent writing to this MSR (PT_CAP_topa_output && PT_CAP_single_range_output).  This
> causes QEMU to crash if some of the conditions aren't met.
> > >
> > > Writing and reading this MSR (and the ones below) need to be conditional on KVM_GET_MSR_INDEX_LIST.
> > >
> >
> > Hi Eduardo,
> >     I found this issue can't be reproduced in upstream source code but can be reproduced on RHEL8.1. I haven't got the qemu source
> code of RHEL8.1. But after adding some trace in KVM, I found the KVM has reported the complete Intel PT CPUID information to qemu
> but the Intel PT CPUID (0x14) is lost when qemu setting the CPUID to KVM (cpuid level is 0xd). It looks like lost the below patch.
> >
> > commit f24c3a79a415042f6dc195f029a2ba7247d14cac
> > Author: Luwei Kang <luwei.kang@intel.com>
> > Date:   Tue Jan 29 18:52:59 2019 -0500
> >     i386: extended the cpuid_level when Intel PT is enabled
> >
> >     Intel Processor Trace required CPUID[0x14] but the cpuid_level
> >     have no change when create a kvm guest with
> >     e.g. "-cpu qemu64,+intel-pt".
> 
> Thanks for the pointer.  This may avoid triggering the bug in the default configuration, but we still need to make the MSR writing
> conditional on KVM_GET_MSR_INDEX_LIST.  Older machine-types have x-intel-pt-auto-level=off, and the user may set `level`
> manually.

Hi Eduardo,
    Sorry for a delay reply because my mail filter. I tried with the Q35 machine type and default, all looks work well (With some old cpu type + "intel_pt" also work well).  KVM will check the Intel PT work mode and HW to decide if Intel PT can be exposed to guest, only extended the CPUID level is useless. If the guest doesn't support Intel PT, any MSR read or write will cause #GP. Please remind me if I lost something.

Thanks,
Luwei Kang

> 
> --
> Eduardo
