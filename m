Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88ED717B673
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 06:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgCFFhU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 6 Mar 2020 00:37:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:59903 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgCFFhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 00:37:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 21:37:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="scan'208";a="264349775"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga004.fm.intel.com with ESMTP; 05 Mar 2020 21:37:18 -0800
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 5 Mar 2020 21:37:18 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.86]) with mapi id 14.03.0439.000;
 Fri, 6 Mar 2020 13:37:16 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Andi Kleen <ak@linux.intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>
Subject: RE: [PATCH v1 00/11] PEBS virtualization enabling via DS
Thread-Topic: [PATCH v1 00/11] PEBS virtualization enabling via DS
Thread-Index: AQHV8tSwrTDGup6zbUucqvSF6td/Fqg6FLYAgAD03DA=
Date:   Fri, 6 Mar 2020 05:37:15 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E17389190B@SHSMSX104.ccr.corp.intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <20200305224852.GE1454533@tassilo.jf.intel.com>
In-Reply-To: <20200305224852.GE1454533@tassilo.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
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

> Subject: Re: [PATCH v1 00/11] PEBS virtualization enabling via DS
> 
> > Testing:
> > The guest can use PEBS feature like native. e.g.
> 
> Could you please add example qemu command lines too? That will make it
> much easier for someone to reproduce.

I introduce a new CPU parameter "pebs" to enable PEBS in KVM guest(disabled in default)  
e.g. "qemu-system-x86_64 -enable-kvm -M q35 -cpu Icelake-Server,pmu=true,pebs=true ...."

[PATCH v1 0/3] PEBS virtualization enabling via DS in Qemu
https://lore.kernel.org/qemu-devel/1583490005-27761-1-git-send-email-luwei.kang@intel.com/

Thanks,
Luwei Kang

> 
> -Andi
> >
> > # perf record -e instructions:ppp ./br_instr a
> >
> > perf report on guest:
> > # Samples: 2K of event 'instructions:ppp', # Event count (approx.):
> 1473377250
> > # Overhead  Command   Shared Object      Symbol
> >   57.74%  br_instr  br_instr           [.] lfsr_cond
> >   41.40%  br_instr  br_instr           [.] cmp_end
> >    0.21%  br_instr  [kernel.kallsyms]  [k] __lock_acquire
> >
> > perf report on host:
> > # Samples: 2K of event 'instructions:ppp', # Event count (approx.):
> 1462721386
> > # Overhead  Command   Shared Object     Symbol
> >   57.90%  br_instr  br_instr          [.] lfsr_cond
> >   41.95%  br_instr  br_instr          [.] cmp_end
> >    0.05%  br_instr  [kernel.vmlinux]  [k] lock_acquire
