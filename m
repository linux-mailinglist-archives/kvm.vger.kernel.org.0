Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8CE309DF
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 10:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfEaILP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 31 May 2019 04:11:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:16369 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfEaILP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 04:11:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:11:14 -0700
X-ExtLoop1: 1
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga008.jf.intel.com with ESMTP; 31 May 2019 01:11:14 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 31 May 2019 01:11:14 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx120.amr.corp.intel.com (10.18.124.208) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 31 May 2019 01:11:13 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.10]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.98]) with mapi id 14.03.0415.000;
 Fri, 31 May 2019 16:11:12 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] KVM: LAPIC: Do not mask the local interrupts when LAPIC
 is sw disabled
Thread-Topic: [PATCH] KVM: LAPIC: Do not mask the local interrupts when
 LAPIC is sw disabled
Thread-Index: AQHVD8I2LU4/pRFEgkiaWmh/P2D76KaDijsAgAFc1nA=
Date:   Fri, 31 May 2019 08:11:12 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E172DAE266@SHSMSX101.ccr.corp.intel.com>
References: <1558435455-233679-1-git-send-email-luwei.kang@intel.com>
 <20190530184602.GD23930@linux.intel.com>
In-Reply-To: <20190530184602.GD23930@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiY2FmMzQ1NDgtYzY0OS00MjI2LWE2YzktZTYyMmE1ODEyNjA1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZUdhM2R6MnlaWjFUVlFQS1pTdm10Z2F3RVVxTWdZVUVHVVZaSTJLWUdmdlh1TVkya1haUlg2Y1h6Rzk3ZE92RCJ9
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Christopherson, Sean J
> Sent: Friday, May 31, 2019 2:46 AM
> To: Kang, Luwei <luwei.kang@intel.com>
> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; pbonzini@redhat.com; rkrcmar@redhat.com; tglx@linutronix.de;
> mingo@redhat.com; bp@alien8.de; hpa@zytor.com; x86@kernel.org
> Subject: Re: [PATCH] KVM: LAPIC: Do not mask the local interrupts when LAPIC is sw disabled
> 
> On Tue, May 21, 2019 at 06:44:15PM +0800, Luwei Kang wrote:
> > The current code will mask all the local interrupts in the local
> > vector table when the LAPIC is disabled by SVR (Spurious-Interrupt
> > Vector Register) "APIC Software Enable/Disable" flag (bit8).
> > This may block local interrupt be delivered to target vCPU even if
> > LAPIC is enabled by set SVR (bit8 == 1) after.
> 
> The current code aligns with the SDM, which states:
> 
>   Local APIC State After It Has Been Software Disabled
> 
>   When the APIC software enable/disable flag in the spurious interrupt
>   vector register has been explicitly cleared (as opposed to being cleared
>   during a power up or reset), the local APIC is temporarily disabled.
>   The operation and response of a local APIC while in this software-
>   disabled state is as follows:
> 
>     - The mask bits for all the LVT entries are set. Attempts to reset
>       these bits will be ignored.

Thanks for Sean's reminder. 
I make this patch because I found the PMI from Intel PT can't be inject to target vCPU when there have multi vCPU in guest and the Intel PT interrupt happened on not the first vCPU (i.e. not vCPU0).  The interrupt blocked in kvm_apic_local_deliver() function and can't pass the APIC_LVT_MASKED flag check (LVTPC is masked from start to end). The KVM Guest will enabled the LVTPC during LAPIC is software disabled and enabled LAPIC after during VM bootup, but LVTPC is still disabled. Guest PT driver didn't enabled LVTPC before enable PT as well. But the Guest performance monitor counter driver will enabled LVTPC in each time before using PMU. I will do more check on this. Thank you.

Luwei Kang

