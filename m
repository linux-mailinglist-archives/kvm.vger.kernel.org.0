Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D3130D09E
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 02:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBCBGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 20:06:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:44045 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhBCBF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 20:05:59 -0500
IronPort-SDR: vTk/8ofuhMth3B72BGDFeatEkvD2HGA3KSYAT8wEFMiwqXebtrtnKSaH+xQhPSLQdnCw+L7S1k
 4xbdqLzUT96g==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="242476845"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="242476845"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 17:05:17 -0800
IronPort-SDR: wI4yonk4iTksm/RvEb0vZT9xvzIZliv/O///hECeWEkZnAB65M1odmsld336n3S8T+58rgT0H5
 Zfe7zppbhUAw==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="356513507"
Received: from asalasax-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.175])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 17:05:14 -0800
Date:   Wed, 3 Feb 2021 14:05:11 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 01/27] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210203140511.6f0d14c9f79903cd3d9f3a35@intel.com>
In-Reply-To: <YBmc/T8L9RCoyeWr@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <aefe8025b615f75eae3ff891f08191bf730b3c99.1611634586.git.kai.huang@intel.com>
        <ca0fa265-0886-2a37-e686-882346fe2a6f@intel.com>
        <3a82563d5a25b52f0b5f01560d70c50a2323f7e5.camel@intel.com>
        <YBVdNl+pTBBm6igw@kernel.org>
        <20210201130151.4bfb5258885ca0f0905858c6@intel.com>
        <89755f15-a873-badc-b3d6-d4f0f817326e@redhat.com>
        <87a8a3f4-3775-21f1-cb67-107cca1a78e5@intel.com>
        <88e25510-a2e0-c4b8-4dcf-0afb78d5532c@redhat.com>
        <YBmc/T8L9RCoyeWr@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 10:42:05 -0800 Sean Christopherson wrote:
> On Tue, Feb 02, 2021, Paolo Bonzini wrote:
> > On 02/02/21 19:00, Dave Hansen wrote:
> > > > /* "" Basic SGX */
> > > > /* "" SGX Enclave Dynamic Memory Mgmt */
> > > Do you actually want to suppress these from /proc/cpuinfo with the ""?
> > > 
> > 
> > sgx1 yes.  However sgx2 can be useful to have there, I guess.
> 
> Agreed, /proc/cpuinfo's sgx1 will always be in lockstep with sgx, so it won't
> be useful for dealing with the fallout of hardware disabling SGX due to software
> disabling a machine check bank via WRMSR(MCi_CTL).  I can't think of any other
> use case for checking /proc/cpuinfo's sgx1.

So combing all feedbacks, I'll put:

/* "" Basic SGX */
/* SGX Enclave Dynamic Memory Management (EDMM) */

Let me know if you guys have concern.
