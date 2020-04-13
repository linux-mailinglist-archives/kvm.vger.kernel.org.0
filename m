Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF70D1A6FE3
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 01:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390149AbgDMXul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 19:50:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:21895 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390145AbgDMXuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 19:50:40 -0400
IronPort-SDR: 1a4raQk3w0rBwWnPAVINA59kewlrFeYQO7LG4gMk4N795WnI9dfV3VybJxuG/vA/fHJ6nu/Fi6
 Jk9+FEbQv0fQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 16:50:39 -0700
IronPort-SDR: yr40BAEAu0ZNwfRCZG4d5GNwNtVoD2eDvF9HgUxdXrTg/v9Y4+k+DOV2SPquFAIZDPBj+df+RA
 QpXk1LXeMIsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,380,1580803200"; 
   d="scan'208";a="268580960"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2020 16:50:39 -0700
Date:   Mon, 13 Apr 2020 16:50:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Simon Smith <brigidsmith@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests RESEND PATCH] x86: gtests: add new test for
 vmread/vmwrite flags preservation
Message-ID: <20200413235039.GK21204@linux.intel.com>
References: <20200413172432.70180-1-brigidsmith@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413172432.70180-1-brigidsmith@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/gtest/nVMX for the shortlog.  I thought this was somehow related to the
Google Test framework, especially coming from a @google.com address.

On Mon, Apr 13, 2020 at 10:24:32AM -0700, Simon Smith wrote:
> This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
> vmread should not set rflags to specify success in case of #PF")
> 
> The two new tests force a vmread and a vmwrite on an unmapped
> address to cause a #PF and verify that the low byte of %rflags is
> preserved and that %rip is not advanced.  The cherry-pick fixed a
> bug in vmread, but we include a test for vmwrite as well for
> completeness.

I think some of Google's process is bleeding into kvm-unit-tests, I'm pretty
sure the aforementioned commit wasn't cherry-picked into Paolo's tree.  :-D

> Before the aforementioned commit, the ALU flags would be incorrectly
> cleared and %rip would be advanced (for vmread).
