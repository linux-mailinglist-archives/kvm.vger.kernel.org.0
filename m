Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1558C02D
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 20:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfHMSLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 14:11:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:48955 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfHMSLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 14:11:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 11:11:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,382,1559545200"; 
   d="scan'208";a="183949083"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Aug 2019 11:11:14 -0700
Date:   Tue, 13 Aug 2019 11:11:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 6/7] x86: KVM: svm: eliminate weird goto from
 vmrun_interception()
Message-ID: <20190813181113.GG13991@linux.intel.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
 <20190813135335.25197-7-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813135335.25197-7-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 03:53:34PM +0200, Vitaly Kuznetsov wrote:
> Regardless of whether or not nested_svm_vmrun_msrpm() fails, we return 1
> from vmrun_interception() so there's no point in doing goto. Also,
> nested_svm_vmrun_msrpm() call can be made from nested_svm_vmrun() where
> other nested launch issues are handled.
> 
> nested_svm_vmrun() returns a bool, however, its result is ignored in
> vmrun_interception() as we always return '1'. As a preparatory change
> to putting kvm_skip_emulated_instruction() inside nested_svm_vmrun()
> make nested_svm_vmrun() return an int (always '1' for now).
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
