Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3F327DFE5
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 07:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgI3FI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 01:08:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:24900 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3FI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 01:08:29 -0400
IronPort-SDR: YsKGLSEBhbxslnml5eBNM2bTyjbBd1edMNBXPsxdaT6PHVFHPS0+UGHSfmeT4etPjc2Kd4MpLY
 cGoFBlmia4xQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="226516583"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="226516583"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 22:08:25 -0700
IronPort-SDR: 1zNnmGLO5DpVJkXdDf7JJ3OdVAnfUHijc1TOvsSZKuDZBsacmzZ4liUuV1fJIg7b1avCuaOmNz
 zm9BDMlQ2cvg==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="338939911"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 22:08:24 -0700
Date:   Tue, 29 Sep 2020 22:08:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
Message-ID: <20200930050821.GC29405@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-3-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:42PM -0700, Ben Gardon wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> new file mode 100644
> index 0000000000000..b102109778eac
> --- /dev/null
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0 */

Kernel style is to use C++ comments for the SPDX headers in .c and .h (and
maybe.S too?).
