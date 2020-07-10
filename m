Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C5C21BAE1
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgGJQ2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:28:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:25693 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgGJQ2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 12:28:25 -0400
IronPort-SDR: AcpXix8XKZrbNzJLzrbc4ApEhVWof5VEpqwRK0eg7spL4FbVr+VKgkCFlWmijCKjb4JvTHPXWV
 mEwIMW5c4HOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="147341884"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="147341884"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 09:28:22 -0700
IronPort-SDR: jNSta/rj/b6HojzQ2Vt4c9e27f53Vtt08K6Z/1hxpWryNwBeZMALkBgyV6R3IhR+Gp3br40JJ2
 u+y/rOen/2sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="428610403"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 10 Jul 2020 09:28:20 -0700
Date:   Fri, 10 Jul 2020 09:28:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v12 07/11] KVM: vmx/pmu: Unmask LBR fields in the
 MSR_IA32_DEBUGCTLMSR emualtion
Message-ID: <20200710162819.GF1749@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200613080958.132489-8-like.xu@linux.intel.com>
 <654d931c-a724-ed69-6501-52ce195a6f44@intel.com>
 <ea424570-c93f-2624-3e85-d7255b609da4@intel.com>
 <20200707202155.GL20096@linux.intel.com>
 <a162343f-74be-c72e-ff65-323c1415c1e3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a162343f-74be-c72e-ff65-323c1415c1e3@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 08, 2020 at 03:06:57PM +0800, Xu, Like wrote:
> Hi Sean,
> 
> First of all, are you going to queue the LBR patch series in your tree
> considering the host perf patches have already queued in Peter's tree ?

No, I'll let Paolo take 'em directly, I'm nowhere near knowledgeable enough
with respect to the PMU to feel comfortable taking them.
