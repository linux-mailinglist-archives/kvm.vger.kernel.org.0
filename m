Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D718181C29
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 16:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgCKPUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 11:20:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:11319 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729408AbgCKPUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 11:20:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 08:19:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,541,1574150400"; 
   d="scan'208";a="231721982"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2020 08:19:59 -0700
Date:   Wed, 11 Mar 2020 08:19:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment Registers on vmentry of nested guests
Message-ID: <20200311151959.GC21852@linux.intel.com>
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <20200310225149.31254-2-krish.sadhukhan@oracle.com>
 <20200311150516.GB21852@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311150516.GB21852@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 08:05:16AM -0700, Sean Christopherson wrote:
> On Tue, Mar 10, 2020 at 06:51:49PM -0400, Krish Sadhukhan wrote:
> > +	/*
> > +	 * The address of TR, FS, GS and LDTR must be canonical.
> > +	 */
> > +	TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_TR, "GUEST_BASE_TR");
> > +	TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_FS, "GUEST_BASE_FS");
> > +	TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_GS, "GUEST_BASE_GS");
> 
> FS/GS bases aren't checked if the segment is unusable.

Ah, I stand corrected, I misread the section on loading guest segs.   There
is an exception clause for FS/GS base inside the unusuable path.  And the
"checks on guest segments" clearly states FS/GS base are unconditionally
checked.
