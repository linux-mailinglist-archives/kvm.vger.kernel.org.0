Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7985931E846
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 10:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhBRJiR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 18 Feb 2021 04:38:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:45924 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhBRJNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 04:13:39 -0500
IronPort-SDR: SmJ8EWqiq4bWgM4299WfUvWqmTVoxPLOiUpod2oF9m6VpRwPKJkySTs9zw6XBWlQkzwrKew1jO
 lFXVBzpcwLiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9898"; a="180881724"
X-IronPort-AV: E=Sophos;i="5.81,186,1610438400"; 
   d="scan'208";a="180881724"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 01:09:14 -0800
IronPort-SDR: 3Pg4ShUUz8TimkWWUFVc33lHCEuesb0CrpzdSl9/aAJANQaHUAxW2qiiOmv+UVTXYPOw7EUH1u
 s+LdXrn7CQtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,186,1610438400"; 
   d="scan'208";a="362360001"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 18 Feb 2021 01:09:13 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Feb 2021 01:09:12 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Feb 2021 01:09:12 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Thu, 18 Feb 2021 01:09:12 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     Borislav Petkov <bp@alien8.de>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Thread-Topic: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Thread-Index: AQHXAgqNtwlxthmplU6cFSX1Hb3mCqpalcMAgAACzaCAAId3AP//ga0AgACTtoCAADqQgIACCEaAgAAtVTA=
Date:   Thu, 18 Feb 2021 09:09:12 +0000
Message-ID: <0c7e6768a33f450fb4da9167ffe6f78d@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org> <cdc73d737d634e778de4c691ca4fd080@intel.com>
 <20210216103218.GB10592@zn.tnic> <a792bf6271da4fddb537085845cf868f@intel.com>
 <20210216114851.GD10592@zn.tnic>
 <9dca76b9-a0f9-a7aa-5d85-f8b43f89a3d2@intel.com>
 <YC2Ws68oxi3hizrG@kernel.org>
In-Reply-To: <YC2Ws68oxi3hizrG@kernel.org>
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

> 
> On Tue, Feb 16, 2021 at 07:18:27AM -0800, Dave Hansen wrote:
> > On 2/16/21 3:48 AM, Borislav Petkov wrote:
> > > What I'm trying to point you at is, to not give some artificial
> > > reasons why the headers should be separate - artificial as the SDM
> > > says it is architectural and so on - but give a reason from software
> > > design perspective why the separation is needed: better build times,
> > > less symbols exposed to modules, blabla and so on.
> >
> > I think I actually suggested this sgx_arch.h split for SGX in the
> > first place.
> >
> > I was reading the patches and I had a really hard time separating the
> > hardware and software structures.  There would be a 'struct sgx_foo {}'
> > and some chit chat about what it did...  and I still had no idea if it
> > was an architectural structure or not.
> >
> > This way, it's 100% crystal clear what Linux is defining and what the
> > hardware defines from the diff context.
> 
> Let's worry about split later on when we add "big" SGX specific features like
> EDMM, and consider this more like "move and rename".

If we need to worry about split when we add EDMM, why we are merging to one single asm/sgx.h in this KVM SGX series?

EDMM is a feature we definitely need to support, right?
