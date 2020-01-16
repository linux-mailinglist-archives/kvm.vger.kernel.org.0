Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA5F13DF04
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 16:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgAPPi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 10:38:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:39942 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgAPPi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 10:38:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 07:38:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="248847832"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 16 Jan 2020 07:38:55 -0800
Date:   Thu, 16 Jan 2020 07:38:54 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
Subject: Re: [Bug 206215] New: QEMU guest crash due to random 'general
 protection fault' since kernel 5.2.5 on i7-3517UE
Message-ID: <20200116153854.GA20561@linux.intel.com>
References: <bug-206215-28872@https.bugzilla.kernel.org/>
 <20200115215256.GE30449@linux.intel.com>
 <e6ec4418-4ac1-e619-7402-18c085bc340d@djy.llc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6ec4418-4ac1-e619-7402-18c085bc340d@djy.llc>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 15, 2020 at 08:08:32PM -0500, Derek Yerger wrote:
> On 1/15/20 4:52 PM, Sean Christopherson wrote:
> >+cc Derek, who is hitting the same thing.
> >
> >On Wed, Jan 15, 2020 at 09:18:56PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> >>https://bugzilla.kernel.org/show_bug.cgi?id=206215
> >*snip*
> >that's a big smoking gun pointing at commit ca7e6b286333 ("KVM: X86: Fix
> >fpu state crash in kvm guest"), which is commit e751732486eb upstream.
> >
> >1. Can you verify reverting ca7e6b286333 (or e751732486eb in upstream)
> >    solves the issue?
> >
> >2. Assuming the answer is yes, on a buggy kernel, can you run with the
> >    attached patch to try get debug info?
> I did these out of order since I had 5.3.11 built with the patch, ready to
> go for weeks now, waiting for an opportunity to test.
> 
> Win10 guest immediately BSOD'ed with:
> 
> WARNING: CPU: 2 PID: 9296 at include/linux/thread_info.h:55
> kernel_fpu_begin+0x6b/0xc0

Can you provide the full stack trace of the WARN?  I'm hoping that will
provide a hint as to what's going wrong.

> Then stashed the patch, reverted ca7e6b286333, compile, reboot.
> 
> Guest is running stable now on 5.3.11. Did test my CAD under the guest, did
> not experience the crashes that had me stuck at 5.1.
