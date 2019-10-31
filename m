Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5CEEAD74
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 11:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfJaKbY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 31 Oct 2019 06:31:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:10024 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfJaKbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 06:31:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 03:31:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="375198433"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga005.jf.intel.com with ESMTP; 31 Oct 2019 03:31:22 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 31 Oct 2019 03:31:21 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 31 Oct 2019 03:31:21 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 31 Oct 2019 03:31:21 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.2]) with mapi id 14.03.0439.000;
 Thu, 31 Oct 2019 18:31:20 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
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
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: RE: [PATCH v1 8/8] perf/x86: Add event owner check when PEBS output
 to Intel PT
Thread-Topic: [PATCH v1 8/8] perf/x86: Add event owner check when PEBS
 output to Intel PT
Thread-Index: AQHVjLd7YuomyMFGekW7/CerqBL266dxNysAgAFIGiD///EXAIABvUSA//+vdgCAALWpgA==
Date:   Thu, 31 Oct 2019 10:31:20 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1738363E9@SHSMSX104.ccr.corp.intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-9-git-send-email-luwei.kang@intel.com>
 <20191029151302.GO4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173835B6A@SHSMSX104.ccr.corp.intel.com>
 <20191030095400.GU4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173836317@SHSMSX104.ccr.corp.intel.com>
 <87bltxfjo3.fsf@ashishki-desk.ger.corp.intel.com>
In-Reply-To: <87bltxfjo3.fsf@ashishki-desk.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZWIxMzBhNzctZTg2ZS00OTkwLTlmZGUtZTg1N2ZiZWQyNGMzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUit0SlZZVGtzeFZaQnhUV01YeXRzOW9mMHV4aFNKamM0QU9sZ05FOXI5WHYwaEFLRFNYcnFDVkVyN0VKNEVFdCJ9
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

> >> Then how does KVM deal with the host using PT? You can't just steal PT.
> >
> > Intel PT in virtualization can work in system and host_guest mode.
> > In system mode (default), the trace produced by host and guest will be saved in host PT buffer. Intel PT will not be exposed to guest
> in this mode.
> >  In host_guest mode, Intel PT will be exposed to guest and guest can use PT like native. The value of host PT register will be saved
> and guest PT register value will be restored during VM-entry. Both trace of host and guest are exported to their respective PT buffer.
> The host PT buffer not include guest trace in this mode.
> 
> IOW, it will steal PT from the host.

Hi Alexander,
    The host buffer does not include guest packets in this mode because the guest trace will be saved in guest PT buffer in this mode. You can think it is stealing. 

> 
> Regards,
> --
> Alex
