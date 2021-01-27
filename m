Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9F53053EE
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 08:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhA0HGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 02:06:14 -0500
Received: from mga14.intel.com ([192.55.52.115]:20500 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317827AbhA0Awz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 19:52:55 -0500
IronPort-SDR: SgMBw2oDT1ppSVfU+Bms1MeFzMIVebcJ2FFVst49iyYP+Aph3cb2SIF3NpZ1P/62iYQo8Lv9C7
 aMF60rkVupaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="179215356"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="179215356"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:52:14 -0800
IronPort-SDR: oklwDcgXGh7NO5d+3lKV16cp46aV47E3E8a87rwomkiMUofkH9qdA29Rqo5V84eCtQZCFLwOpu
 69G8XFsS+h7Q==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="353629954"
Received: from rsperry-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.187])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:52:11 -0800
Date:   Wed, 27 Jan 2021 13:52:09 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH v3 05/27] x86/sgx: Add SGX_CHILD_PRESENT hardware
 error code
Message-Id: <20210127135209.b7f35d507bbdf96af40646af@intel.com>
In-Reply-To: <83fc6b6b-0ced-ca75-5c31-9c275778351f@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <5a7c7715147f089d97ae4c033b74b0eafb8f3f89.1611634586.git.kai.huang@intel.com>
        <3bdda0ea-3935-1a8a-8d11-b898371d6168@intel.com>
        <a7877d1d9624873d25da175a02d0840f7b5e91dc.camel@intel.com>
        <83fc6b6b-0ced-ca75-5c31-9c275778351f@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jan 2021 16:21:36 -0800 Dave Hansen wrote:
> On 1/26/21 4:00 PM, Kai Huang wrote:
> > On Tue, 2021-01-26 at 07:49 -0800, Dave Hansen wrote:
> >> On 1/26/21 1:30 AM, Kai Huang wrote:
> >>> From: Sean Christopherson <sean.j.christopherson@intel.com>
> >>>
> >>> SGX virtualization requires to allocate "raw" EPC and use it as "virtual
> >>> EPC" for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> >>> track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> >>> so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> >>> knowledge of which pages are SECS with non-zero child counts.
> >>
> >> The grammar there is a bit questionable in spots.  Here's a rewrite:
> >>
> >> SGX can accurately track how bare-metal enclave pages are used.  This
> >> enables SECS to be specifically targeted and EREMOVE'd only after all
> >> child pages have been EREMOVE'd.  This ensures that bare-metal SGX will
> >> never encounter SGX_CHILD_PRESENT in normal operation.
> > 
> > How about:
> > 
> > "SGX driver can accurate track how enclave pages are used. This enables..."
> > 
> > Since in another email, you mentioned that we should get rid of bare-metal driver,
> > and Andy suggested we can just use SGX driver?
> 
> <sigh>
> 
> Sure, but with correct grammar, please.
> 
> "SGX driver can accurately track how enclave pages are used. This
> enables..."
> 
> Seriously, if you just paste the sentences into Word, it will highlight
> this and tell you.

Thanks. My fault.
