Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE83137503
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 18:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgAJRk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 12:40:28 -0500
Received: from mga17.intel.com ([192.55.52.151]:47386 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbgAJRk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 12:40:27 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 09:40:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="422189094"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Jan 2020 09:40:27 -0800
Date:   Fri, 10 Jan 2020 09:40:27 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 03/10] mmu: spp: Add SPP Table setup functions
Message-ID: <20200110174026.GE21485@linux.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-4-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102061319.10077-4-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 02, 2020 at 02:13:12PM +0800, Yang Weijiang wrote:
> SPPT is a 4-level paging structure similar to EPT, when SPP is
> armed for target physical page, bit 61 of the corresponding
> EPT entry is flaged, then SPPT is traversed with the gfn,
> the leaf entry of SPPT contains the access bitmap of subpages
> inside the target 4KB physical page, one bit per 128-byte subpage.
> 
> Co-developed-by: He Chen <he.chen@linux.intel.com>
> Signed-off-by: He Chen <he.chen@linux.intel.com>
> Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   5 +-
>  arch/x86/kvm/mmu/spp.c          | 228 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/spp.h          |  10 ++

This patch is completely untesteable.  It adds spp.c but doesn't compile
it.  Actually, everything up until patch 06 is untestable.
