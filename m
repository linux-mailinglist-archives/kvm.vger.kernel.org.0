Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775ED1B7702
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 15:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgDXNcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 09:32:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:29418 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgDXNcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 09:32:06 -0400
IronPort-SDR: 0n8FF7ZkZsEBnkXJX2bMjWM9zKpbJOKSv9LEEBdPyg+mP9SQbW3MvC2qVcW06rkA7Rquxq2nQ2
 I3ghT52n4hlg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 06:32:06 -0700
IronPort-SDR: mN1k2NkBR+hDx9JISGYgp5v5QAjsvlkB1UT0ODoZDFZ6eTqlyxSp6S58RAOEOMUPqBso0uFaAn
 Nu3ku6c+tl0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="256369290"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 24 Apr 2020 06:32:04 -0700
Date:   Fri, 24 Apr 2020 21:34:06 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 0/9] Introduce support for guest CET feature
Message-ID: <20200424133406.GB24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200423160314.GE17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423160314.GE17824@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 09:03:14AM -0700, Sean Christopherson wrote:
> On Thu, Mar 26, 2020 at 04:18:37PM +0800, Yang Weijiang wrote:
> > Control-flow Enforcement Technology (CET) provides protection against
> > Return/Jump-Oriented Programming (ROP/JOP) attack. It includes two
> > sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> > 
> > KVM needs to update to enable guest CET feature.
> > This patchset implements CET related CPUID/XSAVES enumeration, MSRs
> > and vmentry/vmexit configuration etc.so that guest kernel can setup CET
> > runtime infrastructure based on them. Some CET MSRs and related feature
> > flags used reference the definitions in kernel patchset.
> > 
> > CET kernel patches are here:
> > https://lkml.org/lkml/2020/2/5/593
> > https://lkml.org/lkml/2020/2/5/604
> 
> ...
> 
> > - This patch serial is built on top of below branch and CET kernel patches
> >   for seeking xsaves support:
> >   https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=cpu-caps
> 
> Can you provide the full code in a branch/tag somewhere?  The CET patches
> are in turn dependent on XSAVES enabling[*], and those don't apply cleanly
> on the cpu-caps branch.
> 
> It might make sense to also rebase to kvm/queue?  Though that's not a
> requirement by any means, e.g. don't bother if the CET patches are going to
> be respun soon.
>
I'll rebase the patches to 5.7-rc2, so things will be clear then.

> https://lkml.kernel.org/r/20200328164307.17497-1-yu-cheng.yu@intel.com
