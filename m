Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB0B1054E3
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 15:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKUOxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 09:53:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:14815 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfKUOxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 09:53:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 06:53:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="205169559"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 21 Nov 2019 06:53:08 -0800
Date:   Thu, 21 Nov 2019 22:55:05 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 3/9] mmu: spp: Add SPP Table setup functions
Message-ID: <20191121145505.GC17169@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-4-weijiang.yang@intel.com>
 <5b0da087-8ce0-2b01-5a1a-4d8c5f319d33@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b0da087-8ce0-2b01-5a1a-4d8c5f319d33@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:38:18AM +0100, Paolo Bonzini wrote:
> On 19/11/19 09:49, Yang Weijiang wrote:
> > +static int is_spp_shadow_present(u64 pte)
> > +{
> > +	return pte & PT_PRESENT_MASK;
> > +}
> > +
> 
> This should not be needed, is_shadow_present_pte works well for SPP PTEs
> as well (and in fact you're already using it here and there, so it's
> confusing to have both).
>
OK, will remove it.
> Paolo
