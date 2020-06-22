Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFADA203E32
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 19:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgFVRmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 13:42:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:44744 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729857AbgFVRmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 13:42:10 -0400
IronPort-SDR: 1DZ2KcqH0cA+O3ifN7zhWKayojjDs3zTy3yPVf7kNn082KQ0IU6xayNh4iM8wJwEybdZBBpmjF
 DS6nmsRZTH/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="123481397"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="123481397"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 10:42:09 -0700
IronPort-SDR: v7QVxNL6aILN3Hw6YMUkGkLI/GmnJoY9rzjAX9KSAh86f3jJAGI8xMqGGcbFvTBTeRVBPZGwFn
 NnUjWtokEhgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="310182048"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 22 Jun 2020 10:42:08 -0700
Date:   Mon, 22 Jun 2020 10:42:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/4] nVMX: 5-level nested EPT support
Message-ID: <20200622174208.GF5150@linux.intel.com>
References: <20200207174244.6590-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207174244.6590-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.  These still apply cleanly on master and are required to get unit
tests passing on systems with 5-level paging.

On Fri, Feb 07, 2020 at 09:42:40AM -0800, Sean Christopherson wrote:
> Add support for 5-level nested EPT and clean up the test for
> MSR_IA32_VMX_EPT_VPID_CAP in the process.
> 
> Sean Christopherson (4):
>   nVMX: Extend EPTP test to allow 5-level EPT
>   nVMX: Refactor the EPT/VPID MSR cap check to make it readable
>   nVMX: Mark bit 39 of MSR_IA32_VMX_EPT_VPID_CAP as reserved
>   nVMX: Extend EPT cap MSR test to allow 5-level EPT
> 
>  x86/vmx.c       | 21 ++++++++++++++++++++-
>  x86/vmx.h       |  4 +++-
>  x86/vmx_tests.c | 12 ++++++++----
>  3 files changed, 31 insertions(+), 6 deletions(-)
> 
> -- 
> 2.24.1
> 
