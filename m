Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6482A251B9
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 16:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfEUORc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 10:17:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:18769 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbfEUORb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 10:17:31 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 07:17:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 21 May 2019 07:17:31 -0700
Date:   Tue, 21 May 2019 07:17:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     kvm@vger.kernel.org
Subject: Re: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Message-ID: <20190521141731.GC22089@linux.intel.com>
References: <bug-203543-28872@https.bugzilla.kernel.org/>
 <bug-203543-28872-iUz9JFoNNJ@https.bugzilla.kernel.org/>
 <20190521141101.GB22089@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521141101.GB22089@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 21, 2019 at 07:11:01AM -0700, Sean Christopherson wrote:
> On Tue, May 21, 2019 at 01:37:42PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=203543
> > 
> > --- Comment #10 from moi@davidchill.ca ---
> > Reverting both commits solves this problem:
> > 
> > f93f7ede087f2edcc18e4b02310df5749a6b5a61
> > e51bfdb68725dc052d16241ace40ea3140f938aa
> 
> Hmm, that makes no sense, f93f7ede087f is a straight revert of
> e51bfdb68725.  I do see the same behavior on v5.2-rc1 where hiding the
> pmu from L1 breaks nested virtualization, but manually reverting both
> commits doesn't change that for me, i.e. there's another bug lurking,
> which I'll start hunting.

Scratch that, had a brain fart and tested the wrong kernel.  I do *NOT*
see breakage on v5.2-rc1, at least when running v5.2-rc1 as L1 and probing
KVM in L2.

When running v5.2-rc1 as L0, what are the values of MSRs 0x482 and 0x48e
in L1?

> 
> Any chance the successful test used a different command line or something?
