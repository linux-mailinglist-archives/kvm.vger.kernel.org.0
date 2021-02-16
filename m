Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794E031C8D4
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 11:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhBPKa5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 16 Feb 2021 05:30:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:39030 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhBPKas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 05:30:48 -0500
IronPort-SDR: e3KDvlqNvzO0Ig5IT1UGkeUSontjC/5Q2qszCuAtEzldboQtuKqAyRc10HNVgDzREBBdtdBpuc
 tnja4QLhMASA==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="182926106"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="182926106"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 02:30:04 -0800
IronPort-SDR: kAShZ2WkP/t9TGbmpMrm/P8VWLVO39JYhDhBXlmH9gvEbDNZJhC7ePVZnv+dNPhDcwzQrSoVNm
 ZZmWaI2UWMQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="580433288"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 16 Feb 2021 02:30:04 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 02:30:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 02:30:03 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 02:30:03 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Thread-Topic: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Thread-Index: AQHXAgqNtwlxthmplU6cFSX1Hb3mCqpalcMAgAACzaA=
Date:   Tue, 16 Feb 2021 10:30:03 +0000
Message-ID: <cdc73d737d634e778de4c691ca4fd080@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org>
In-Reply-To: <YCsrNqcB1C0Tyxz9@kernel.org>
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
> On Sun, Feb 14, 2021 at 02:29:10AM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Expose SGX architectural structures, as KVM will use many of the
> > architectural constants and structs to virtualize SGX.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} | 0
> >  arch/x86/kernel/cpu/sgx/encl.c                             | 2 +-
> >  arch/x86/kernel/cpu/sgx/sgx.h                              | 2 +-
> >  tools/testing/selftests/sgx/defines.h                      | 2 +-
> >  4 files changed, 3 insertions(+), 3 deletions(-)  rename
> > arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} (100%)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/arch.h
> > b/arch/x86/include/asm/sgx_arch.h similarity index 100% rename from
> > arch/x86/kernel/cpu/sgx/arch.h rename to
> > arch/x86/include/asm/sgx_arch.h
> 
> Why not just sgx.h? The postfix is useless.

Because those contents are *architectural*. They are defined in SDM.

And patch 13 (x86/sgx: Add helpers to expose ECREATE and EINIT to KVM) will introduce arch/x86/include/asm/sgx.h, where non-architectural functions will be declared.

