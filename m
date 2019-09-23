Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4EFBB7F3
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfIWPa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:30:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:28142 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfIWPa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 11:30:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 08:30:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,540,1559545200"; 
   d="scan'208";a="388521635"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 23 Sep 2019 08:30:57 -0700
Date:   Mon, 23 Sep 2019 08:30:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] x86: spec_ctrl: fix SPEC_CTRL initialization after
 kexec
Message-ID: <20190923153057.GA18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-2-aarcange@redhat.com>
 <c56d8911-5323-ac40-97b3-fa8920725197@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c56d8911-5323-ac40-97b3-fa8920725197@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 12:22:23PM +0200, Paolo Bonzini wrote:
> On 20/09/19 23:24, Andrea Arcangeli wrote:
> > We can't assume the SPEC_CTRL msr is zero at boot because it could be
> > left enabled by a previous kernel booted with
> > spec_store_bypass_disable=on.
> > 
> > Without this fix a boot with spec_store_bypass_disable=on followed by
> > a kexec boot with spec_store_bypass_disable=off would erroneously and
> > unexpectedly leave bit 2 set in SPEC_CTRL.
> > 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> 
> Can you send this out separately, so that Thomas et al. can pick it up
> as a bug fix?

Can all off the patches that are not directly related to the monolithic
conversion be sent separately?  AFAICT, patches 01, 03, 07, 08, 14, 15, 16
and 17 are not required or dependent on the conversion to a monolithic
module.  That's almost half the series...
