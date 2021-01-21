Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2762FE037
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 04:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732094AbhAUDxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 22:53:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:25788 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392977AbhAUByL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:54:11 -0500
IronPort-SDR: IpbVMVmTta/bS/MJJ6WXIGaYobBnvyAwuCQ60t0ZdPSK/iuhKFzp/2NgxIpALuUjQIfVjlDUcL
 GWmoH7CyMx/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="175698492"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="175698492"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:53:29 -0800
IronPort-SDR: YTuSdqf7JTVPfMOaHl07geipP4qj462+JdHXha35om2ISImZS/FHUNMcsP+MenbKAZO2FEHk51
 H9KjtxXa/FvQ==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="427115555"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:53:25 -0800
Date:   Thu, 21 Jan 2021 14:53:23 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <jarkko@kernel.org>, <luto@kernel.org>,
        <haitao.huang@intel.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <jethro@fortanix.com>, <b.thiel@posteo.de>
Subject: Re: [RFC PATCH v2 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-Id: <20210121145323.0caad8f1d1970214bba905b1@intel.com>
In-Reply-To: <626d0157-c0a0-60fd-813f-af3207ad91df@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
        <a6c0b0d2632a6c603e68d9bdc81f564290ff04ad.1610935432.git.kai.huang@intel.com>
        <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
        <YAiwhdcOknqTJihk@google.com>
        <666e0995-cf08-1ed9-20b2-f64d1ce64c20@intel.com>
        <20210121124830.3cb323c5ead91800645c912a@intel.com>
        <626d0157-c0a0-60fd-813f-af3207ad91df@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 15:51:44 -0800 Dave Hansen wrote:
> On 1/20/21 3:48 PM, Kai Huang wrote:
> >> Not a big deal either way.  I agree that "virt" can be confusing.
> >>
> >> Considering that:
> >>
> >> +config X86_SGX_VIRTUALIZATION
> >> +	depends on ... KVM_INTEL
> > It is already in patch 3: Introduce virtual EPC for use by KVM guests:
> > 
> > +config X86_SGX_VIRTUALIZATION
> > +	bool "Software Guard eXtensions (SGX) Virtualization"
> > +	depends on X86_SGX && KVM_INTEL
> 
> Right, I'm suggesting that patch 3 should call it:
> 
> 	X86_SGX_KVM
> 
> instead of:
> 
> 	X86_SGX_VIRTUALIZATION

In case we want to change to X86_SGX_KVM, is it more reasonable to put it to
arch/x86/kvm/Kconfig (maybe change to X86_KVM_SGX)?

Jarkko also mentioned X86_SGX_VEPC, in which case still putting it to
arch/x86/Kconfig looks a better fit.

Sean, Paolo,

Do you have comment here?
