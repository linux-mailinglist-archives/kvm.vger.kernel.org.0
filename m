Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37179F1E1
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 19:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbfH0Rum convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 27 Aug 2019 13:50:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:43424 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727683AbfH0Rum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 13:50:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 10:50:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="209836974"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by fmsmga002.fm.intel.com with ESMTP; 27 Aug 2019 10:50:41 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 27 Aug 2019 10:50:40 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.103]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.98]) with mapi id 14.03.0439.000;
 Tue, 27 Aug 2019 10:50:40 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Krcm=E1r?= <rkrcmar@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>
Subject: RE: [PATCH] KVM: x86: Only print persistent reasons for kvm
 disabled once
Thread-Topic: [PATCH] KVM: x86: Only print persistent reasons for kvm
 disabled once
Thread-Index: AQHVXDtY9fhddvc9IEqJnfbY95p10acO/gWAgABI7TA=
Date:   Tue, 27 Aug 2019 17:50:40 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F43E3E2@ORSMSX115.amr.corp.intel.com>
References: <20190826182320.9089-1-tony.luck@intel.com>
 <87imqjm8b4.fsf@vitty.brq.redhat.com>
In-Reply-To: <87imqjm8b4.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiN2VlMDdjYWYtOTRlYi00NTgwLWI2NDgtMmM3MGRlYmUzZTllIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRlVIN1laMnZMNUlEQ1FLM1ArOUdqTjB3T3ROYTVnSytlc0lkSUNHT0w0SG04aWUxVzhwN1ZmdW1SVHBGcTJaNyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> and we bail on first error so there should be only 1 message per module
> load attempt. The question I have is who (and why) is trying to load
> kvm-intel (or kvm-amd which is not any different) for each CPU? Is it
> udev? Can this be changed?

No idea where to look.  The system has a RHEL8 user space install. Kernel
is latest from Linus (v5.3-rc6).

-Tony
