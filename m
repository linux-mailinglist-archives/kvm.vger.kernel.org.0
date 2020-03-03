Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42346178509
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 22:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgCCVmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 16:42:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:8395 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbgCCVmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 16:42:55 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 13:42:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="274392285"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2020 13:42:54 -0800
Date:   Tue, 3 Mar 2020 13:42:54 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v9 2/7] KVM: VMX: Define CET VMCS fields and #CP flag
Message-ID: <20200303214254.GZ1439@linux.intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
 <20191227021133.11993-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227021133.11993-3-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 27, 2019 at 10:11:28AM +0800, Yang Weijiang wrote:
> @@ -298,7 +298,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
>   * In future, applicable XSS state bits can be added here
>   * to make them available to KVM and guest.
>   */
> -#define KVM_SUPPORTED_XSS	0
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER \
> +				| XFEATURE_MASK_CET_KERNEL)

My preference would be to put the operator on the previous line, though I
realize this diverges from other KVM behavior.  I find it much easier to
read With the names aligned.

#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
				 XFEATURE_MASK_CET_KERNEL)
>  
>  extern u64 host_xcr0;
>  
> -- 
> 2.17.2
> 
