Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B02E303C
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437029AbfJXLWW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 24 Oct 2019 07:22:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:26357 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392305AbfJXLWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 07:22:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 04:22:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="197707850"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga007.fm.intel.com with ESMTP; 24 Oct 2019 04:22:20 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 24 Oct 2019 04:22:20 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 24 Oct 2019 04:22:20 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.165]) with mapi id 14.03.0439.000;
 Thu, 24 Oct 2019 19:22:18 +0800
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
Thread-Index: AQHVgKsg+eNsNdVZH0GZ6Dwyyz/Lp6dbpngw//+LOYCACWt2QIACHxuAgAL58EA=
Date:   Thu, 24 Oct 2019 11:22:18 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E17382D523@SHSMSX104.ccr.corp.intel.com>
References: <1520182116-16485-1-git-send-email-luwei.kang@intel.com>
 <1520182116-16485-2-git-send-email-luwei.kang@intel.com>
 <20191012031407.GK4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382A209@SHSMSX104.ccr.corp.intel.com>
 <20191015132929.GY4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382BB76@SHSMSX104.ccr.corp.intel.com>
 <20191022214416.GA21651@habkost.net>
In-Reply-To: <20191022214416.GA21651@habkost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjczMDk5MmUtNWUwOS00NjExLWE1NDAtZThmNGU5YTA4ZjQ3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiM2dHTDFuYkc2ZkM1UUt5S1J3dDRzV0JTV0xvK0pkcXNUaDdScmdRSkpMSUVvaTA3NlpGXC96ajBhdWU3U1BiM1gifQ==
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

> > > > > > f9f4cd1..097c953 100644
> > > > > > --- a/target/i386/kvm.c
> > > > > > +++ b/target/i386/kvm.c
> > > > > > @@ -1811,6 +1811,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
> > > > > >                  kvm_msr_entry_add(cpu, MSR_MTRRphysMask(i), mask);
> > > > > >              }
> > > > > >          }
> > > > > > +        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
> > > > > > +            int addr_num = kvm_arch_get_supported_cpuid(kvm_state,
> > > > > > +                                                    0x14, 1,
> > > > > > + R_EAX) & 0x7;
> > > > > > +
> > > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
> > > > > > +                            env->msr_rtit_ctrl);
> > > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS,
> > > > > > +                            env->msr_rtit_status);
> > > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_BASE,
> > > > > > +                            env->msr_rtit_output_base);
> > > > >
> > > > > This causes the following crash on some hosts:
> > > > >
> > > > >   qemu-system-x86_64: error: failed to set MSR 0x560 to 0x0
> > > > >   qemu-system-x86_64: target/i386/kvm.c:2673: kvm_put_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> > > > >
> > > > > Checking for CPUID_7_0_EBX_INTEL_PT is not enough: KVM has
> > > > > additional conditions that might prevent writing to this MSR
> > > > > (PT_CAP_topa_output && PT_CAP_single_range_output).  This
> > > causes QEMU to crash if some of the conditions aren't met.
> > > > >
> > > > > Writing and reading this MSR (and the ones below) need to be conditional on KVM_GET_MSR_INDEX_LIST.
> > > > >
> > > >
> > > > Hi Eduardo,
> > > >     I found this issue can't be reproduced in upstream source code
> > > > but can be reproduced on RHEL8.1. I haven't got the qemu source
> > > code of RHEL8.1. But after adding some trace in KVM, I found the KVM
> > > has reported the complete Intel PT CPUID information to qemu but the Intel PT CPUID (0x14) is lost when qemu setting the CPUID
> to KVM (cpuid level is 0xd). It looks like lost the below patch.
> > > >
> > > > commit f24c3a79a415042f6dc195f029a2ba7247d14cac
> > > > Author: Luwei Kang <luwei.kang@intel.com>
> > > > Date:   Tue Jan 29 18:52:59 2019 -0500
> > > >     i386: extended the cpuid_level when Intel PT is enabled
> > > >
> > > >     Intel Processor Trace required CPUID[0x14] but the cpuid_level
> > > >     have no change when create a kvm guest with
> > > >     e.g. "-cpu qemu64,+intel-pt".
> > >
> > > Thanks for the pointer.  This may avoid triggering the bug in the
> > > default configuration, but we still need to make the MSR writing
> > > conditional on KVM_GET_MSR_INDEX_LIST.  Older machine-types have x-intel-pt-auto-level=off, and the user may set `level`
> manually.
> >
> > Hi Eduardo,
> > Sorry for a delay reply because my mail filter. I tried with the Q35
> > machine type and default, all looks work well (With some old cpu type
> > + "intel_pt" also work well).  KVM will check the Intel PT work mode
> > and HW to decide if Intel PT can be exposed to guest, only extended
> > the CPUID level is useless. If the guest doesn't support Intel PT, any
> > MSR read or write will cause #GP. Please remind me if I lost
> > something.
> 
> I understand you have tried q35 and pc, but have you tried with older machine-type versions?
> 
> Commit f24c3a79a415 doesn't change behavior on pc-*-3.1 and older, so it only avoids triggering the crash in the default case.
> Doesn't QEMU crash if running:
> "-cpu qemu64,+intel-pt -machine pc-i440fx-3.1"?
> 
> KVM rejecting MSR writes when something is missing is correct.
> QEMU trying to write the MSR when something is missing (and crashing because of that) is a bug.

Hi Eduardo,
    Yes, you are right. Intel PT is only set in leaf 0x7.ebx but leaf 0x14 is lost because of the leaf number still 0xd (should 0x14). 
    May I remove the "off" like this?

--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -132,7 +132,6 @@ GlobalProperty pc_compat_3_1[] = {
     { "Icelake-Client" "-" TYPE_X86_CPU,      "mpx", "on" },
     { "Icelake-Server" "-" TYPE_X86_CPU,      "mpx", "on" },
     { "Cascadelake-Server" "-" TYPE_X86_CPU, "stepping", "5" },
-    { TYPE_X86_CPU, "x-intel-pt-auto-level", "off" },
 };
 const size_t pc_compat_3_1_len = G_N_ELEMENTS(pc_compat_3_1);

Thanks,
Luwei Kang

> 
> --
> Eduardo

