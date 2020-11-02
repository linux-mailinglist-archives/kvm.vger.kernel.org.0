Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208C92A3194
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 18:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgKBRcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 12:32:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:60774 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKBRci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 12:32:38 -0500
IronPort-SDR: 5GYPaCuZgQaEpPHK3BSx7kzgVcq5QwNsINTf02SmvRsjRqBT+AOn6Jp+jZq0jzlSS/v30NMwlx
 A37yo2HwmaFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="169054546"
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="169054546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 09:32:38 -0800
IronPort-SDR: b2zKfegSK6u2fKZJCw6Gaf/EocNmnRgzgPtTJHciwnCyb8+DMpI9FJ133BAjKXmGfOT9DNxNSc
 53UxS1zaFlUw==
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="324927291"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 09:32:38 -0800
Date:   Mon, 2 Nov 2020 09:32:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
Message-ID: <20201102173236.GD21563@linux.intel.com>
References: <20201102061445.191638-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102061445.191638-1-tao3.xu@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 02:14:45PM +0800, Tao Xu wrote:
> There are some cases that malicious virtual machines can cause CPU stuck
> (event windows don't open up), e.g., infinite loop in microcode when
> nested #AC (CVE-2015-5307). No event window obviously means no events,
> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
> hardware CPU can't be used by host or other VM.
> 
> To resolve those cases, it can enable a notify VM exit if no
> event window occur in VMX non-root mode for a specified amount of
> time (notify window).
> 
> Expose a module param for setting notify window, default setting it to
> the time as 1/10 of periodic tick, and user can set it to 0 to disable
> this feature.
> 
> TODO:
> 1. The appropriate value of notify window.
> 2. Another patch to disable interception of #DB and #AC when notify
> VM-Exiting is enabled.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Tao Xu <tao3.xu@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Incorrect ordering, since you're sending the patch, you "handled" it last,
therefore your SOB should come last, i.e.:

  Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
  Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
  Signed-off-by: Tao Xu <tao3.xu@intel.com>
