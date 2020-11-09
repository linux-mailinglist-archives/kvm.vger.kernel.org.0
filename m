Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0762AB151
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 07:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgKIGes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 01:34:48 -0500
Received: from mga12.intel.com ([192.55.52.136]:27633 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729076AbgKIGer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 01:34:47 -0500
IronPort-SDR: Hy1ZvAHhX4b+JsYm7tbuu3s643L7rxOYF6ZHLe2vWLTgCrSXKegtiG/aK06AmAyV+rYDksBn6c
 UaYyZHKiMwgw==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="149035416"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="149035416"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 22:34:47 -0800
IronPort-SDR: epgwv5nkki90oJuuM6jW+S8ec5md4ptPQZLXv9wT+rvJ5nOm4ZXwF4aBldsS9I312p4Oykmr0t
 e1Ge+n1wmpog==
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="530588466"
Received: from tassilo.jf.intel.com ([10.54.74.11])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 22:34:47 -0800
Date:   Sun, 8 Nov 2020 22:34:46 -0800
From:   Andi Kleen <ak@linux.intel.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v12 01/11] perf/x86: Fix variable types for LBR registers
Message-ID: <20201109063446.GM466880@tassilo.jf.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
 <20200613080958.132489-2-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200613080958.132489-2-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 13, 2020 at 04:09:46PM +0800, Like Xu wrote:
> From: Wei Wang <wei.w.wang@intel.com>
> 
> The MSR variable type can be 'unsigned int', which uses less memory than
> the longer 'unsigned long'. Fix 'struct x86_pmu' for that. The lbr_nr won't
> be a negative number, so make it 'unsigned int' as well.

Hi, 

What's the status of this patchkit? It would be quite useful to me (and
various other people) to use LBRs in guest. I reviewed it earlier and the
patches all looked good to me.  But i don't see it in any -next tree.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

Could it please be merged?

Thanks,

-Andi
