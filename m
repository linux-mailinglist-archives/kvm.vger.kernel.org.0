Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA72310315
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 04:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhBEDBL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 4 Feb 2021 22:01:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:46073 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhBEDBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 22:01:06 -0500
IronPort-SDR: /2iAwB1Voxkjf8eSbPNHCb5k7150cX4PoC1EKNP55ukq/+2DmmOYZDHz0Vy2NQgGyHkGRbzzq/
 LO39j8+ROPtw==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="177863845"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="177863845"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 19:00:25 -0800
IronPort-SDR: /N9KlomrGzE1NvDHkNF3/6VYBOFGIQCix9bArtsU56IhCHRnMcVq+RmSQ9NmjU4DUA5xGeJ6b0
 BiNI8ZoKCKuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="415443677"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Feb 2021 19:00:25 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Feb 2021 19:00:24 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Feb 2021 19:00:24 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Thu, 4 Feb 2021 19:00:24 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     Sean Christopherson <seanjc@google.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Thread-Topic: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Thread-Index: AQHW88S6tXP2pgrp0EKF1qhJ4uWs4apAy76AgAKMYQCAAlk3AIAADX2AgABSlACAABnrAIABY8yAgAAP/oCAACyPAIAA8E0A//8n5QCAAADgAIAA3TuA///m/ICAAIOBgIAAObmA//+IQVA=
Date:   Fri, 5 Feb 2021 03:00:24 +0000
Message-ID: <f37a40b7137b4c89ba202c65f781cc0e@intel.com>
References: <20210203134906.78b5265502c65f13bacc5e68@intel.com>
 <YBsdeco/t8sa7ecV@kernel.org> <YBsq45IDDX9PPc7s@google.com>
 <YBtQRCC3NHBmtrck@kernel.org>
 <b63bf7db09442e994563ccc3a3b608fc2f17b784.camel@intel.com>
 <YBtkkEp5hXpTl84s@kernel.org> <YBtlTE2xZ3wBrukB@kernel.org>
 <b523357d2f062bf801d8fa1b05bf7abf13c19e89.camel@intel.com>
 <YBwJ5S0C3dMS2AFY@kernel.org>
 <7a1d2316-5ce2-63fa-4186-a623dac1ecc8@intel.com>
 <YByooRl8riad4moe@kernel.org>
In-Reply-To: <YByooRl8riad4moe@kernel.org>
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

> On Thu, Feb 04, 2021 at 02:41:57PM -0800, Dave Hansen wrote:
> > On 2/4/21 6:51 AM, Jarkko Sakkinen wrote:
> > >>> A: ret == -ENODEV
> > >>> B: ret == 0
> > >>> C: ret != 0 && ret != -ENODEV
> > >> Let me try again:
> > >>
> > >> Why A and C should be treated differently? What will behave
> > >> incorrectly, in case of C?
> > > So you don't know what different error codes mean?
> >
> > How about we just leave the check in place as Sean wrote it, and add a
> > nice comment to explain what it is doing:
> >
> > 	/*
> > 	 * Always try to initialize the native *and* KVM drivers.
> > 	 * The KVM driver is less picky than the native one and
> > 	 * can function if the native one is not supported on the
> > 	 * current system or fails to initialize.
> > 	 *
> > 	 * Error out only if both fail to initialize.
> >  	 */
> > 	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > 	if (ret)
> > 		goto err_kthread;
> 
> WFM, I can go along, as long as there is a remark. There is a semantical
> difference between "not supported" and "failure to initialize". The driving point
> is that this should not be hidden. I was first thinking a note in the commit
> message, but inline comment is actually a better idea. Thanks!
> 
> I can ack the next version, as long as this comment is included.

Sure. Thanks Dave and Jarkko.

> 
> /Jarkko
