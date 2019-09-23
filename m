Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF298BBE76
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 00:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503301AbfIWW1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 18:27:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:5127 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391372AbfIWW1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 18:27:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 15:27:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,542,1559545200"; 
   d="scan'208";a="188271691"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2019 15:27:35 -0700
Date:   Mon, 23 Sep 2019 15:27:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] x86: spec_ctrl: fix SPEC_CTRL initialization after
 kexec
Message-ID: <20190923222734.GP18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-2-aarcange@redhat.com>
 <c56d8911-5323-ac40-97b3-fa8920725197@redhat.com>
 <20190923153057.GA18195@linux.intel.com>
 <20190923173421.GA13551@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923173421.GA13551@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 01:34:21PM -0400, Andrea Arcangeli wrote:
> Per subject of the patch, 14 is also an optimization that while not a
> strict requirement, is somewhat related to the monolithic conversion
> because in fact it may naturally disappear if I rename the vmx/svm
> functions directly.
> 
> 15 16 17 don't have the monolithic tag in the subject of the patch and
> they're obviously unrelated to the monolithic conversion, but when I
> did the first research on this idea of dropping kvm.ko a couple of
> months ago, things didn't really work well until I got rid of those
> few last retpolines too. If felt as if the large retpoline regression
> wasn't linear with the number of retpolines executed for each vmexit,
> and that it was more linear with the percentage of vmexits that hit on
> any number of retpolines. So while they're not part of the monolithic
> conversion I assumed they're required to run any meaningful benchmark.
> 
> I can drop 15 16 17 from further submits of course, after clarifying
> benchmark should be only run on the v1 full set I posted earlier, or
> they wouldn't be meaningful.

I like the patches, I'd just prefer that they be sent in a separate
series so they can churn independently.
