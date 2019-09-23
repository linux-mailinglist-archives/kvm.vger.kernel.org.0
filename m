Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68AABBC99
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 22:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502453AbfIWUIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 16:08:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:48601 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbfIWUIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 16:08:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 13:08:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,541,1559545200"; 
   d="scan'208";a="203199208"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 13:08:48 -0700
Date:   Mon, 23 Sep 2019 13:08:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        krish.sadhukhan@oracle.com, pbonzini@redhat.com, rkrcmar@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 2/2] x86: nvmx: test max atomic switch
 MSRs
Message-ID: <20190923200848.GK18195@linux.intel.com>
References: <20190920222945.235480-1-marcorr@google.com>
 <20190920222945.235480-2-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920222945.235480-2-marcorr@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 20, 2019 at 03:29:45PM -0700, Marc Orr wrote:
> +		u32 exit_reason;
> +		u32 exit_reason_want;
> +		u32 exit_qual;
> +
> +		enter_guest_with_invalid_guest_state();
> +
> +		exit_reason = vmcs_read(EXI_REASON);
> +		exit_reason_want = VMX_FAIL_MSR | VMX_ENTRY_FAILURE;
> +		report("exit_reason, %u, is %u.",
> +		       exit_reason == exit_reason_want, exit_reason,
> +		       exit_reason_want);
> +
> +		exit_qual = vmcs_read(EXI_QUALIFICATION);
> +		report("exit_qual, %u, is %u.", exit_qual == max_allowed + 1,
> +		       exit_qual, max_allowed + 1);

I'd stick with the more standard "val %u, expected %u" verbiage.  E.g.:

	exit_reason, 34, is 35

versus

	exit_reason 34, expected 35

The "is" part makes it sound like the value in the VMCS *is* 35.
