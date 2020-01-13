Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB61138B8D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 07:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732572AbgAMGAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 01:00:36 -0500
Received: from mga07.intel.com ([134.134.136.100]:36257 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgAMGAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 01:00:36 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2020 22:00:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,427,1571727600"; 
   d="scan'208";a="255770257"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jan 2020 22:00:34 -0800
Date:   Mon, 13 Jan 2020 14:04:55 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 03/10] mmu: spp: Add SPP Table setup functions
Message-ID: <20200113060455.GC12253@local-michael-cet-test.sh.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-4-weijiang.yang@intel.com>
 <20200110174026.GE21485@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110174026.GE21485@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 09:40:27AM -0800, Sean Christopherson wrote:
> On Thu, Jan 02, 2020 at 02:13:12PM +0800, Yang Weijiang wrote:
> > SPPT is a 4-level paging structure similar to EPT, when SPP is
> > armed for target physical page, bit 61 of the corresponding
> > EPT entry is flaged, then SPPT is traversed with the gfn,
> > the leaf entry of SPPT contains the access bitmap of subpages
> > inside the target 4KB physical page, one bit per 128-byte subpage.
> > 
> > Co-developed-by: He Chen <he.chen@linux.intel.com>
> > Signed-off-by: He Chen <he.chen@linux.intel.com>
> > Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |   5 +-
> >  arch/x86/kvm/mmu/spp.c          | 228 ++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/mmu/spp.h          |  10 ++
> 
> This patch is completely untesteable.  It adds spp.c but doesn't compile
> it.  Actually, everything up until patch 06 is untestable.
OK, will re-order the patches in a reasonable sequence. thank you!
