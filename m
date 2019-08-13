Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A1B8C02F
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 20:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfHMSLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 14:11:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:40507 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbfHMSLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 14:11:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 11:11:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,382,1559545200"; 
   d="scan'208";a="177876696"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 13 Aug 2019 11:11:22 -0700
Date:   Tue, 13 Aug 2019 11:11:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 7/7] x86: KVM: svm: eliminate hardcoded RIP
 advancement from vmrun_interception()
Message-ID: <20190813181121.GH13991@linux.intel.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
 <20190813135335.25197-8-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813135335.25197-8-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 03:53:35PM +0200, Vitaly Kuznetsov wrote:
> Just like we do with other intercepts, in vmrun_interception() we should be
> doing kvm_skip_emulated_instruction() and not just RIP += 3. Also, it is
> wrong to increment RIP before nested_svm_vmrun() as it can result in
> kvm_inject_gp().
> 
> We can't call kvm_skip_emulated_instruction() after nested_svm_vmrun() so
> move it inside.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
