Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F78191985
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgCXSzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:55:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:49449 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbgCXSzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 14:55:48 -0400
IronPort-SDR: yJW7tnWVtkH8e3owpxUQYpPY/NeW/PGAedlmyzWE6hKo9ddWPaoNVr5vnogesH3zN/wEVvzsYO
 xq75IBkFrj0g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 11:55:47 -0700
IronPort-SDR: In7cgZMu3NkGD/UCKqQlH4ZNdzJZDxYiul/vchXAotnhR52/UqOtrXim3CmKEPSA7hOZsjlwxA
 6fki7FVS2Bmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="326005935"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 24 Mar 2020 11:55:46 -0700
Date:   Tue, 24 Mar 2020 11:55:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] KVM: SVM: Move and split up svm.c
Message-ID: <20200324185545.GB7798@linux.intel.com>
References: <20200324094154.32352-1-joro@8bytes.org>
 <20200324183007.GA7798@linux.intel.com>
 <CALMp9eRYNH+=Ra=1KSJdT5Ej5kTfdV8J7Rf6JcS9NGbPOYPj8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRYNH+=Ra=1KSJdT5Ej5kTfdV8J7Rf6JcS9NGbPOYPj8A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 11:42:21AM -0700, Jim Mattson wrote:
> On Tue, Mar 24, 2020 at 11:30 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Tue, Mar 24, 2020 at 10:41:50AM +0100, Joerg Roedel wrote:
> > > Hi,
> > >
> > > here is a patch-set agains kvm/queue which moves svm.c into its own
> > > subdirectory arch/x86/kvm/svm/ and splits moves parts of it into
> > > separate source files:
> >
> > What are people's thoughts on using "arch/x86/kvm/{amd,intel}" instead of
> > "arch/x86/kvm/{svm,vmx}"?  Maybe this won't be an issue for AMD/SVM, but on
> > the Intel/VMX side, there is stuff in the pipeline that makes using "vmx"
> > for the sub-directory quite awkward.  I wasn't planning on proposing the
> > rename (from vmx->intel) until I could justify _why_, but perhaps it makes
> > sense to bundle all the pain of a reorganizing code into a single kernel
> > version?
> 
> Doesn't VIA have some CPUs that implement VMX?

Yes (and this is why I didn't want broach this subject without being able
to go into details).  On the other hand, the module is kvm_intel...
