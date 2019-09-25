Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49C6BE85A
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 00:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfIYWdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 18:33:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:36606 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfIYWdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 18:33:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 15:33:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="scan'208";a="219146348"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 25 Sep 2019 15:33:34 -0700
Date:   Wed, 25 Sep 2019 15:33:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH] kvm: x86: Fix a spurious -E2BIG in __do_cpuid_func
Message-ID: <20190925223334.GP31852@linux.intel.com>
References: <20190925181714.176229-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925181714.176229-1-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 11:17:14AM -0700, Jim Mattson wrote:
> Don't return -E2BIG from __do_cpuid_func when processing function 0BH
> or 1FH and the last interesting subleaf occupies the last allocated
> entry in the result array.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Fixes: 831bf664e9c1fc ("KVM: Refactor and simplify kvm_dev_ioctl_get_supported_cpuid")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
