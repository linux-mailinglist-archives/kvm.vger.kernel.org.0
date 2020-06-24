Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCC9206C05
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 07:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389060AbgFXF4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 01:56:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:14787 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388280AbgFXF4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 01:56:04 -0400
IronPort-SDR: g/asH8//nlEQk76LudjXvHhqlhOgB0eeFxCPF7tu/Tz7UeNbVFrVlgks8mX+4o6BqWbfvfOkCi
 JPyuFh+m3zkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="131780348"
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="131780348"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 22:56:03 -0700
IronPort-SDR: +WRzbudH5WccXgHhEBtGs7jLgYUfPgjlpURNgwMRnNr8taqh93vYgYIb0rMoD/QWuyHKAlqow+
 /rk7ofOMn1ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="452519601"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 23 Jun 2020 22:55:58 -0700
Date:   Wed, 24 Jun 2020 13:56:11 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v12 00/10] Introduce support for guest CET feature
Message-ID: <20200624055611.GA14379@local-michael-cet-test>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
 <20200610165635.GB18790@linux.intel.com>
 <20200611012913.GA15497@local-michael-cet-test>
 <20200623183919.GB24107@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623183919.GB24107@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 11:39:19AM -0700, Sean Christopherson wrote:
> On Thu, Jun 11, 2020 at 09:29:13AM +0800, Yang Weijiang wrote:
> > On Wed, Jun 10, 2020 at 09:56:36AM -0700, Sean Christopherson wrote:
> > > On Wed, May 06, 2020 at 04:20:59PM +0800, Yang Weijiang wrote:
> > > > Several parts in KVM have been updated to provide VM CET support, including:
> > > > CPUID/XSAVES config, MSR pass-through, user space MSR access interface, 
> > > > vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> > > > kernel patches for xsaves support and CET definitions, e.g., MSR and related
> > > > feature flags.
> > > 
> > > Other than the MSR and cpufeatures flags definitions, is there any direct
> > > dependency on kernel CET support?  I.e. if/when XSAVES support is merged,
> > > is there anything beyond the architectural definitions that are required to
> > > merge KVM CET virtualization?
> > No, KVM CET patches only depend on kernel CET related definitions and XSAVES 
> > support now.
> 
> Neato.
> 
> > But to make guest CET work, we need CET patches for QEMU.
> 
> Ya, but we don't need to wait for host kernel support, which was the crux of
> my question.
> 
> 
> Can you please respin this series with the CET definition patches included?
> The XSAVES support has been queued to tip/x86/fpu.  Assuming that lands in
> kernel 5.9, I _think_ KVM support for CET can land in 5.10.

Sure. Besides this change and the unrestricted guest case change, any
other changes I should do to v12 patch?

Thanks for review!
> 
> Base your series on kvm/queue, i.e. don't worry about the XSAVES patches,
> I'll merge them in from tip/x86/fpu for testing.
> 
> Thanks!
