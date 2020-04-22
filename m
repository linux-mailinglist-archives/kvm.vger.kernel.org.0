Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BAB1B4ABA
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 18:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDVQmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 12:42:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:7728 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgDVQmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 12:42:18 -0400
IronPort-SDR: DFF6sqXvKlQYfPhBfmtUjkAQNxsTEp5k3Ex1QuiSlngwlWVq9ljYond9/q7l90wcm5sMuR9/lC
 ab0V60cWysXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 09:42:17 -0700
IronPort-SDR: +MrdKdgTmhv+I9nklXs1xFVT2yvf8v8wJCHkFcPDv8WVvdd7bJHs4E4FyBdjzIt/QV3FPKoVeD
 b4Q6jstpmY7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,304,1583222400"; 
   d="scan'208";a="255698351"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 22 Apr 2020 09:42:16 -0700
Date:   Wed, 22 Apr 2020 09:42:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
Message-ID: <20200422164216.GB4662@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200414000946.47396-2-jmattson@google.com>
 <83426123-eca6-568d-ac3e-36c4e3ca3030@redhat.com>
 <CALMp9eR75_F6su19oMKeNU1NE4yPRGdNrxfHR+WskncRDSfvkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eR75_F6su19oMKeNU1NE4yPRGdNrxfHR+WskncRDSfvkg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 09:28:13AM -0700, Jim Mattson wrote:
> On Wed, Apr 22, 2020 at 1:30 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 14/04/20 02:09, Jim Mattson wrote:
> > > Previously, if the hrtimer for the nested VMX-preemption timer fired
> > > while L0 was emulating an L2 instruction with RFLAGS.TF set, the
> > > synthesized single-step trap would be unceremoniously dropped when
> > > synthesizing the "VMX-preemption timer expired" VM-exit from L2 to L1.
> > >
> > > To fix this, don't synthesize a "VMX-preemption timer expired" VM-exit
> > > from L2 to L1 when there is a pending debug trap, such as a
> > > single-step trap.
> >
> > Do you have a testcase for these bugs?
> 
> Indeed. They should be just prior to this in your inbox.

Ah, I missed those too and apparently didn't think to search for preemption
timer tests.  Thanks for the refresher!
