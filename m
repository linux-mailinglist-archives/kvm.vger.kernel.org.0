Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642B8205AEB
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733218AbgFWSjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 14:39:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:36977 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732549AbgFWSjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 14:39:20 -0400
IronPort-SDR: V5UTPpjm6puQkl3TEeXSYo74Lm8FBRgssfB2fka8elhSGQSly07DlH0HGNrI6wonpeNEMYbaI+
 XC2h5D6UhDGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="228868421"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="228868421"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 11:39:19 -0700
IronPort-SDR: xlNxctNe2zbP6tzJCCkxGGHZ1TtiYh51isJGHblsxmCPoYWnwdWa7VS/8MxR+lVxhTX6gVdNz3
 WbRPFWX9T5yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="478966266"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jun 2020 11:39:19 -0700
Date:   Tue, 23 Jun 2020 11:39:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v12 00/10] Introduce support for guest CET feature
Message-ID: <20200623183919.GB24107@linux.intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
 <20200610165635.GB18790@linux.intel.com>
 <20200611012913.GA15497@local-michael-cet-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611012913.GA15497@local-michael-cet-test>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 09:29:13AM +0800, Yang Weijiang wrote:
> On Wed, Jun 10, 2020 at 09:56:36AM -0700, Sean Christopherson wrote:
> > On Wed, May 06, 2020 at 04:20:59PM +0800, Yang Weijiang wrote:
> > > Several parts in KVM have been updated to provide VM CET support, including:
> > > CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
> > > vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> > > kernel patches for xsaves support and CET definitions, e.g., MSR and related
> > > feature flags.
> > 
> > Other than the MSR and cpufeatures flags definitions, is there any direct
> > dependency on kernel CET support?  I.e. if/when XSAVES support is merged,
> > is there anything beyond the architectural definitions that are required to
> > merge KVM CET virtualization?
> No, KVM CET patches only depend on kernel CET related definitions and XSAVES 
> support now.

Neato.

> But to make guest CET work, we need CET patches for QEMU.

Ya, but we don't need to wait for host kernel support, which was the crux of
my question.


Can you please respin this series with the CET definition patches included?
The XSAVES support has been queued to tip/x86/fpu.  Assuming that lands in
kernel 5.9, I _think_ KVM support for CET can land in 5.10.

Base your series on kvm/queue, i.e. don't worry about the XSAVES patches,
I'll merge them in from tip/x86/fpu for testing.

Thanks!
