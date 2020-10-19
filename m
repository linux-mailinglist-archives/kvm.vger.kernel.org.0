Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238BB292B9F
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 18:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbgJSQhu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 19 Oct 2020 12:37:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:15669 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729916AbgJSQhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 12:37:50 -0400
IronPort-SDR: Zir6oaiXy2+gdQ7SiWpDy7XtAedOn+1Vmn6fyJeFKbFHWnt9ix7VBWKtvDWTkSsVcXS94N1UUz
 4O5m4W0TeJ2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9779"; a="154000337"
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="154000337"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2020 09:37:49 -0700
IronPort-SDR: fcC4SFpY7CCDbBnL3powKDKKZirs5h/walq5s+NobQElXVA9ShdL2PJ4EQnvkNiiDmU+Pn/c6O
 YLjLfDsZrILw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,395,1596524400"; 
   d="scan'208";a="522055920"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 19 Oct 2020 09:37:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 19 Oct 2020 09:37:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 19 Oct 2020 09:37:48 -0700
Received: from orsmsx611.amr.corp.intel.com ([10.22.229.24]) by
 ORSMSX611.amr.corp.intel.com ([10.22.229.24]) with mapi id 15.01.1713.004;
 Mon, 19 Oct 2020 09:37:48 -0700
From:   "Christopherson, Sean J" <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic
 test
Thread-Topic: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for
 apic test
Thread-Index: AQHWoUFdByb/PYMQ3Eu+JgdRCcLx/amZS0UA//+UpoCABmnVAP//3/eQ
Date:   Mon, 19 Oct 2020 16:37:47 +0000
Message-ID: <a6e33cd7d0084d6389a02786225db0e8@intel.com>
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
 <87d01j5vk7.fsf@vitty.brq.redhat.com>
 <20201015163539.GA27813@linux.intel.com>
 <87o8ky4fkf.fsf@vitty.brq.redhat.com>
In-Reply-To: <87o8ky4fkf.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 19, 2020 at 01:32:00PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> >> > index 872d679..c72a659 100644
> >> > --- a/x86/unittests.cfg
> >> > +++ b/x86/unittests.cfg
> >> > @@ -41,7 +41,7 @@ file = apic.flat
> >> >  smp = 2
> >> >  extra_params = -cpu qemu64,+x2apic,+tsc-deadline
> >> >  arch = x86_64
> >> > -timeout = 30
> >> > +timeout = 240
> >> >
> >> >  [ioapic]
> >> >  file = ioapic.flat
> >>
> >> AFAIR the default timeout for tests where timeout it not set explicitly
> >> is 90s so don't you need to also modify it for other tests like
> >> 'apic-split', 'ioapic', 'ioapic-split', ... ?
> >>
> >> I was thinking about introducing a 'timeout multiplier' or something to
> >> run_tests.sh for running in slow (read: nested) environments, doing that
> >> would allow us to keep reasonably small timeouts by default. This is
> >> somewhat important as tests tend to hang and waiting for 4 minutes every
> >> time is not great.
> >
> > I would much prefer to go in the other direction and make tests like APIC not
> > do so many loops (in a nested environment?). The port80 test in particular is
> > an absolute waste of time.
>
> I don't think these two suggestions are opposite. Yes, making tests run fast
> is good, however, some of the tests are doomed to be slow. E.g. running
> VMX testsuite while nested (leaving aside the question about who needs
> three level nesting) is always going to be much slower than on bare metal.

Ya, I was specifically referring to tests that arbitrarily choose a high loop
count, without any real/documented justification for running millions of loops.

> > E.g. does running 1M loops in test_multiple_nmi() really add value versus
> > say 10k or 100k loops?
>
> Oddly enough, I vaguely remember this particular test hanging
> *sometimes* after a few thousand loops but I don't remember any
> details.

Thousands still ain't millions :-D.

IMO, the unit tests should sit between a smoke test and a long running,
intensive stress test, i.e. the default config shouldn't be trying to find
literal one-in-a-million bugs on every run.
