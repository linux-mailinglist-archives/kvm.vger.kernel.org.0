Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5E71825CF
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 00:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbgCKXZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 19:25:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:14766 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731417AbgCKXZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 19:25:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 16:25:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,542,1574150400"; 
   d="scan'208";a="353995030"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 11 Mar 2020 16:25:51 -0700
Date:   Wed, 11 Mar 2020 16:25:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment Registers on vmentry of nested guests
Message-ID: <20200311232550.GM21852@linux.intel.com>
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
 <20200310225149.31254-2-krish.sadhukhan@oracle.com>
 <20200311150516.GB21852@linux.intel.com>
 <0fb906f6-574f-2e2e-4113-e9d883cb713e@oracle.com>
 <20200311214657.GJ21852@linux.intel.com>
 <E53A1909-C614-401C-A22E-8A22B3E36225@gmail.com>
 <d5f0ba6a-8c7f-60b6-871b-615d11b08a1b@oracle.com>
 <20200311231206.GL21852@linux.intel.com>
 <E0581325-7501-438D-B547-4FEC4F2C2D28@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E0581325-7501-438D-B547-4FEC4F2C2D28@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 04:21:08PM -0700, Nadav Amit wrote:
> > On Mar 11, 2020, at 4:12 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > On Thu, Mar 12, 2020 at 12:54:05AM +0200, Liran Alon wrote:
> >> Of course it was best if Intel would have shared their unit-tests for CPU
> >> functionality (Sean? I'm looking at you :P), but I am not aware that they
> >> did.
> > 
> > Only in my dreams :-)  I would love to open source some of Intel's
> > validation tools so that they could be adapted to hammer KVM, but it'll
> > never happen for a variety of reasons.
> 
> FYI: In 2014 I ran Intel’s fuzzing-tool (Cafe) to test KVM and found (and
> fixed) ~100 bugs. And I did not even test nested virtualization…

Heh, I worked on Cafe for 6+ years :-)

> http://www.cs.technion.ac.il/people/namit/online-publications/161-amit.pdf
