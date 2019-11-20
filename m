Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E6D104451
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 20:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfKTT2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 14:28:44 -0500
Received: from mga04.intel.com ([192.55.52.120]:46056 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbfKTT2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 14:28:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 11:28:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,223,1571727600"; 
   d="scan'208";a="237863483"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 20 Nov 2019 11:28:43 -0800
Date:   Wed, 20 Nov 2019 11:28:43 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
Message-ID: <20191120192843.GA2341@linux.intel.com>
References: <20191120181913.GA11521@linux.intel.com>
 <7F99D4CD-272D-43FD-9CEE-E45C0F7C7910@djy.llc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7F99D4CD-272D-43FD-9CEE-E45C0F7C7910@djy.llc>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 20, 2019 at 02:04:38PM -0500, Derek Yerger wrote:
> 
> > Debug patch attached.  Hopefully it finds something, it took me an
> > embarassing number of attempts to get correct, I kept screwing up checking
> > a bit number versus checking a bit mask...
> > <0001-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w.patch>
> 
> Should this still be tested despite Wanpeng Li’s comments that the issue may
> have been fixed in a 5.3 release candidate?

Yes.

The actual bug fix, commit e751732486eb3 (KVM: X86: Fix fpu state crash in
kvm guest), is present in v5.2.7.

Unless there's a subtlety I'm missing, commit d9a710e5fc4941 (KVM: X86:
Dynamically allocate user_fpu) is purely an optimization and should not
have a functional impact.
