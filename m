Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D982A6F9A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 18:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbfICQdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 12:33:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:59971 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730658AbfICQdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 12:33:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 09:33:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="173263755"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 03 Sep 2019 09:33:32 -0700
Date:   Tue, 3 Sep 2019 09:33:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: kvm: fix return description of KVM_SET_MSRS
Message-ID: <20190903163332.GF10768@linux.intel.com>
References: <20190902101214.77833-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902101214.77833-1-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 02, 2019 at 06:12:14PM +0800, Xiaoyao Li wrote:

It may seem silly, but a proper changelog would be helpful even here,
e.g. to explain how and when a positive return value can diverge from the
number of MSRs specific in struct kvm_msrs.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  Documentation/virt/kvm/api.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 2d067767b617..a2efc19e0f4e 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -586,7 +586,7 @@ Capability: basic
>  Architectures: x86
>  Type: vcpu ioctl
>  Parameters: struct kvm_msrs (in)
> -Returns: 0 on success, -1 on error
> +Returns: number of msrs successfully set, -1 on error

Similar to the changelong comment, it'd be helpful to elaborate on the
positive return value, e.g.:

  Returns: number of msrs successfully set (see below), -1 on error

and then something in the free form text explaining how the ioctl stops
processing MSRs if setting an MSR fails.

>  Writes model-specific registers to the vcpu.  See KVM_GET_MSRS for the
>  data structures.
> -- 
> 2.19.1
> 
