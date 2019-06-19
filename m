Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA044C1B2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 21:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfFSTrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 15:47:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:42929 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfFSTrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 15:47:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 12:47:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="358299752"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jun 2019 12:47:18 -0700
Date:   Wed, 19 Jun 2019 12:47:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: nVMX: trace nested VM-Enter failures detected
 by H/W
Message-ID: <20190619194718.GH1203@linux.intel.com>
References: <20190308231645.25402-1-sean.j.christopherson@intel.com>
 <20190308231645.25402-3-sean.j.christopherson@intel.com>
 <CALMp9eQ4ADEqTmL4-1wT9Xh9mT9Xof9nmFypqF7_-TeKkHdOMQ@mail.gmail.com>
 <20190314184540.GC4245@linux.intel.com>
 <fe728261-67dc-a247-3ed3-b403269ac83d@redhat.com>
 <CALMp9eQFT2qEuuOoZRpRkx0Fr0452kTnGyxKjK8qP9skWtY0rA@mail.gmail.com>
 <0cb40615-de9e-4c3e-bcc7-68300a09481d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cb40615-de9e-4c3e-bcc7-68300a09481d@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 18, 2019 at 10:47:03AM +0100, Paolo Bonzini wrote:
> On 15/03/19 20:53, Jim Mattson wrote:
> > On Fri, Mar 15, 2019 at 11:15 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 14/03/19 19:45, Sean Christopherson wrote:
> >>>>>         if (unlikely(vmx->fail)) {
> >>>>> -               pr_info_ratelimited("%s failed vm entry %x\n", __func__,
> >>>>> -                                   vmcs_read32(VM_INSTRUCTION_ERROR));
> >>>> I *love* the tracing, but I don't think we want to turn it on for
> >>>> production. Can we keep the pr_info_ratelimited for when tracing is
> >>>> disabled?
> >>> Could we drop it to pr_debug_ratelimited()?  Say "no" if it's at all
> >>> inconvenient to use debug instead of info.  The printing is nothing
> >>> more than a minor annoyance when I'm running unit tests, i.e. any kind
> >>> of actual use case trumps my partiality for a clean kernel log.
> >>>
> >>
> >> I agree, it should be pr_debug_ratelimited (if anything).
> > 
> > Let's go ahead and drop it, then.
> 
> I'll add at least a vcpu_stat.

Paolo, is this one of those series that you need to Google, or are you
waiting on me for something? :-D
