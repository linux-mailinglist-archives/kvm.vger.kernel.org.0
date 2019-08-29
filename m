Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065C2A1344
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfH2ILF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 29 Aug 2019 04:11:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:53717 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfH2ILF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:11:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 01:11:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="380692792"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga005.fm.intel.com with ESMTP; 29 Aug 2019 01:11:04 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 29 Aug 2019 01:11:04 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 01:11:03 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Aug 2019 01:11:03 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.112]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.62]) with mapi id 14.03.0439.000;
 Thu, 29 Aug 2019 16:11:02 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC v1 0/9] PEBS enabling in KVM guest
Thread-Topic: [RFC v1 0/9] PEBS enabling in KVM guest
Thread-Index: AQHVXiwNBbYS5tWphkaKCUykcUkcJqcRNF2AgACP/hA=
Date:   Thu, 29 Aug 2019 08:11:02 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E1737F068B@SHSMSX104.ccr.corp.intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
 <20190829072853.GK2369@hirez.programming.kicks-ass.net>
In-Reply-To: <20190829072853.GK2369@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTljYzIyZWItNzE3ZS00OWJkLTk2ZmMtZWJhZjIyYmVkNGM2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiK3RWdFwvditkU1wvbExTU3BWNSt2c1wvMFU4d0N5Q21qZ0gyeTVieHp3NWR0T0tQWXVJM3dPdVo4bkVnVVwvZDVEcTAifQ==
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

> On Thu, Aug 29, 2019 at 01:34:00PM +0800, Luwei Kang wrote:
> > Intel new hardware introduces some Precise Event-Based Sampling (PEBS)
> > extensions that output the PEBS record to Intel PT stream instead of
> > DS area. The PEBS record will be packaged in a specific format when
> > outputing to Intel PT.
> >
> > This patch set will enable PEBS functionality in KVM Guest by PEBS
> > output to Intel PT. The native driver as [1] (still under review).
> >
> > [1] https://www.spinics.net/lists/kernel/msg3215354.html
> 
> Please use:
> 
>   https://lkml.kernel.org/r/$MSGID
> 
> then I don't have to touch a browser but can find the email in my MUA.

Thanks. The link of native driver should be:
https://lkml.kernel.org/r/20190806084606.4021-1-alexander.shishkin@linux.intel.com

Luwei Kang
