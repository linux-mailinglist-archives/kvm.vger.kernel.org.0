Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39EA6BB824
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbfIWPjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:39:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:59368 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbfIWPjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 11:39:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 08:39:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,540,1559545200"; 
   d="scan'208";a="179166708"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 23 Sep 2019 08:39:48 -0700
Date:   Mon, 23 Sep 2019 08:39:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/17] KVM monolithic v1
Message-ID: <20190923153948.GB18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920212509.2578-1-aarcange@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 20, 2019 at 05:24:52PM -0400, Andrea Arcangeli wrote:
> Andrea Arcangeli (17):
>   x86: spec_ctrl: fix SPEC_CTRL initialization after kexec
>   KVM: monolithic: x86: convert the kvm_x86_ops methods to external
>     functions
>   KVM: monolithic: x86: handle the request_immediate_exit variation
>   KVM: monolithic: x86: convert the kvm_pmu_ops methods to external
>     functions
>   KVM: monolithic: x86: enable the kvm_x86_ops external functions
>   KVM: monolithic: x86: enable the kvm_pmu_ops external functions
>   KVM: monolithic: x86: adjust the section prefixes
>   KVM: monolithic: adjust the section prefixes in the KVM common code
>   KVM: monolithic: x86: remove kvm.ko

IMO, the conversion to a monolithic module should occur immediately, i.e.
"KVM: monolithic: x86: remove kvm.ko" should be patch 01/nn.

Removing kvm_x86_ops and kvm_pmu_ops isn't a preqrequisite to making KVM
a monolothic module, rather they're enhancements that are made possible
*because* KVM is a monolithic module.

With that ordering, I suspect the convert->enable->use of kvm_x86_ops can
be collapsed into a single patch.

>   KVM: monolithic: x86: use the external functions instead of kvm_x86_ops
>   KVM: monolithic: x86: remove exports
>   KVM: monolithic: remove exports from KVM common code
>   KVM: monolithic: x86: drop the kvm_pmu_ops structure

>   KVM: monolithic: x86: inline more exit handlers in vmx.c
>   KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers
>   KVM: retpolines: x86: eliminate retpoline from svm.c exit handlers
>   x86: retpolines: eliminate retpoline from msr event handlers
