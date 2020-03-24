Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1237191930
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgCXSaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:30:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:34730 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgCXSaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 14:30:14 -0400
IronPort-SDR: mFTkOP7K71GplkTDUhiaZN3k1ylGgs7UiHF1FXWXbWTAd/5TZuJ8DbL+5QcBhg5MEQCRUxpw2P
 8C1amQlDyOBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 11:30:13 -0700
IronPort-SDR: xth4tBULpanFhb+3uafVHhHfTbxNA0xvSSc5K7/cV8QKWxNqO7Q1gDLVi+rEKJjY5/r5bGYhMq
 KH6TAH/HkEFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="281807473"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 24 Mar 2020 11:30:13 -0700
Date:   Tue, 24 Mar 2020 11:30:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: SVM: Move and split up svm.c
Message-ID: <20200324183007.GA7798@linux.intel.com>
References: <20200324094154.32352-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324094154.32352-1-joro@8bytes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 10:41:50AM +0100, Joerg Roedel wrote:
> Hi,
> 
> here is a patch-set agains kvm/queue which moves svm.c into its own
> subdirectory arch/x86/kvm/svm/ and splits moves parts of it into
> separate source files:

What are people's thoughts on using "arch/x86/kvm/{amd,intel}" instead of
"arch/x86/kvm/{svm,vmx}"?  Maybe this won't be an issue for AMD/SVM, but on
the Intel/VMX side, there is stuff in the pipeline that makes using "vmx"
for the sub-directory quite awkward.  I wasn't planning on proposing the
rename (from vmx->intel) until I could justify _why_, but perhaps it makes
sense to bundle all the pain of a reorganizing code into a single kernel
version?
