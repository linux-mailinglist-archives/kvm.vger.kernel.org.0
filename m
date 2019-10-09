Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE01D13EC
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 18:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731813AbfJIQWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 12:22:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:17049 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731478AbfJIQWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 12:22:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 09:22:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,276,1566889200"; 
   d="scan'208";a="198055825"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 09 Oct 2019 09:22:31 -0700
Date:   Wed, 9 Oct 2019 09:22:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] selftests: kvm: fix sync_regs_test with newer gccs
Message-ID: <20191009162230.GA31986@linux.intel.com>
References: <20191008180808.14181-1-vkuznets@redhat.com>
 <20191008183634.GF14020@linux.intel.com>
 <b7d20806-4e88-91af-31c1-8cbb0a8a330b@redhat.com>
 <87d0f6yzd3.fsf@vitty.brq.redhat.com>
 <5b1b95e5-4836-ab55-fe4d-e9cc78a7a95e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b1b95e5-4836-ab55-fe4d-e9cc78a7a95e@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 09, 2019 at 01:11:24PM +0200, Paolo Bonzini wrote:
> On 09/10/19 12:42, Vitaly Kuznetsov wrote:
> > Paolo Bonzini <pbonzini@redhat.com> writes:
> >> There is no practical difference with Vitaly's patch.  The first
> >> _vcpu_run has no pre-/post-conditions on the value of %rbx:
> > 
> > I think what Sean was suggesting is to prevent GCC from inserting
> > anything (and thus clobbering RBX) between the call to guest_call() and
> > the beginning of 'asm volatile' block by calling *inside* 'asm volatile'
> > block instead.
> 
> Yes, but there is no way that clobbering RBX will break the test,
> because RBX is not initialized until after the first _vcpu_run succeeds.

Ah, nice, wasn't aware of that.
