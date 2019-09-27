Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFD3C0A3D
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 19:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfI0RXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 13:23:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:39067 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfI0RXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 13:23:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 10:23:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,556,1559545200"; 
   d="scan'208";a="204206862"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 27 Sep 2019 10:23:32 -0700
Date:   Fri, 27 Sep 2019 10:23:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
Message-ID: <20190927172332.GF25513@linux.intel.com>
References: <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
 <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com>
 <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
 <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com>
 <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
 <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com>
 <20190927171405.GD25513@linux.intel.com>
 <7a12a208-4969-e3fe-4a42-b432b91599d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a12a208-4969-e3fe-4a42-b432b91599d8@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 07:19:14PM +0200, Paolo Bonzini wrote:
> On 27/09/19 19:14, Sean Christopherson wrote:
> >>
> >> Perhaps we can make all MSRs supported unconditionally if
> >> host_initiated.  For unsupported performance counters it's easy to make
> >> them return 0, and allow setting them to 0, if host_initiated 
> > I don't think we need to go that far.  Allowing any ol' MSR access seems
> > like it would cause more problems than it would solve, e.g. userspace
> > could completely botch something and never know.
> 
> Well, I didn't mean really _all_ MSRs, only those returned by
> KVM_GET_MSR_INDEX_LIST.

Ah, that makes way more sense :-)

> > For the perf MSRs, could we enumerate all arch perf MSRs that are supported
> > by hardware?  That would also be the list of MSRs that host_initiated MSR
> > accesses can touch regardless of guest support.
> 
> Yes, that is easy indeed.  Any ideas about VMX?

Can you elaborate on the problem with VMX MSRs?
