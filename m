Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F4725197
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 16:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfEUOLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 10:11:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:18089 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbfEUOLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 10:11:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 07:11:02 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2019 07:11:02 -0700
Date:   Tue, 21 May 2019 07:11:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     kvm@vger.kernel.org
Subject: Re: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Message-ID: <20190521141101.GB22089@linux.intel.com>
References: <bug-203543-28872@https.bugzilla.kernel.org/>
 <bug-203543-28872-iUz9JFoNNJ@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-203543-28872-iUz9JFoNNJ@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 21, 2019 at 01:37:42PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203543
> 
> --- Comment #10 from moi@davidchill.ca ---
> Reverting both commits solves this problem:
> 
> f93f7ede087f2edcc18e4b02310df5749a6b5a61
> e51bfdb68725dc052d16241ace40ea3140f938aa

Hmm, that makes no sense, f93f7ede087f is a straight revert of
e51bfdb68725.  I do see the same behavior on v5.2-rc1 where hiding the
pmu from L1 breaks nested virtualization, but manually reverting both
commits doesn't change that for me, i.e. there's another bug lurking,
which I'll start hunting.

Any chance the successful test used a different command line or something?
