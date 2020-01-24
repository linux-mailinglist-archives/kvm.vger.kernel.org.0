Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486B3149219
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 00:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387404AbgAXXih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 18:38:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:52242 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729147AbgAXXig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 18:38:36 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 15:38:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="230508456"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 24 Jan 2020 15:38:35 -0800
Date:   Fri, 24 Jan 2020 15:38:35 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
Message-ID: <20200124233835.GT2109@linux.intel.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 24, 2020 at 03:13:44PM -0800, Nadav Amit wrote:
> > On Dec 2, 2019, at 12:43 PM, Aaron Lewis <aaronlewis@google.com> wrote:
> > 
> > Verify that the difference between a guest RDTSC instruction and the
> > IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
> > MSR-store list is less than 750 cycles, 99.9% of the time.
> > 
> > 662f1d1d1931 ("KVM: nVMX: Add support for capturing highest observable L2 TSC”)
> > 
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> 
> Running this test on bare-metal I get:
> 
>   Test suite: rdtsc_vmexit_diff_test
>   FAIL: RDTSC to VM-exit delta too high in 117 of 100000 iterations
> 
> Any idea why? Should I just play with the 750 cycles magic number?

Argh, this reminds me that I have a patch for this test to improve the
error message to makes things easier to debug.  Give me a few minutes to
get it sent out, might help a bit.
