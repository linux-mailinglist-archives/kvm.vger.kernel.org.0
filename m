Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EE6305525
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 09:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhA0H7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 02:59:44 -0500
Received: from mga18.intel.com ([134.134.136.126]:39764 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317151AbhAZX1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 18:27:01 -0500
IronPort-SDR: JvmO3xkerYDDchiNpWdw2qjSCBELtolQWlvGtUNRGZBJxwP2jrtNe1P5O1tdnCrnoLfL7x5INO
 mN6mA+FU8woA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="167658942"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="167658942"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 15:25:43 -0800
IronPort-SDR: VFBEAJaeFNzIoU6MLuX0/sE3ZHn5O654+Ko1FQNTRd4RVGgpXeAsS1K+Vtd0xc6GwZ5HH5mXrf
 3m2XjoKPLyJg==
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="574197960"
Received: from rsperry-desk.amr.corp.intel.com ([10.251.7.187])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 15:25:38 -0800
Message-ID: <6d91b8e1c45b304ee671c1d359094b9c1b1e5730.camel@intel.com>
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver
 even when SGX driver is disabled
From:   Kai Huang <kai.huang@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Wed, 27 Jan 2021 12:25:36 +1300
In-Reply-To: <7379D257-B504-4142-9FA3-F83DE5ABAEB4@amacapital.net>
References: <24778167-cbd4-1dc5-5b81-e8a49266d1f8@intel.com>
         <7379D257-B504-4142-9FA3-F83DE5ABAEB4@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-26 at 10:10 -0800, Andy Lutomirski wrote:
> 
> > On Jan 26, 2021, at 9:03 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> > 
> > ﻿On 1/26/21 1:31 AM, Kai Huang wrote:
> > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > even if the bare-metal SGX driver is disabled.  The bare-metal driver
> > > might be disabled if SGX Launch Control is in locked mode, or not
> > > supported in the hardware at all.  This allows (non-Linux) guests that
> > > support non-LC configurations to use SGX.
> > 
> > One thing worth calling out *somewhere* (which is entirely my fault):
> > "bare-metal" in the context of this patch set refers to true bare-metal,
> > but *ALSO* covers the plain SGX driver running inside a guest.
> > 
> > So, perhaps "bare-metal" isn't the best term to use.  Again, my bad.
> > Better nomenclature suggestions are welcome.
> 
> 
> How about just SGX?  We can have an SGX driver and a virtual EPC driver.

Thanks. If no one has better idea, I'll change 'bare-metal' driver to SGX driver, in
the whole series.


