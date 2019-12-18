Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6731247EF
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 14:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfLRNTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 08:19:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:36888 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfLRNTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 08:19:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 05:19:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,329,1571727600"; 
   d="scan'208";a="266886586"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Dec 2019 05:19:05 -0800
Date:   Wed, 18 Dec 2019 21:20:14 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 4/7] KVM: VMX: Load CET states on vmentry/vmexit
Message-ID: <20191218132014.GA7926@local-michael-cet-test>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-5-weijiang.yang@intel.com>
 <20191210212305.GM15758@linux.intel.com>
 <20191211015423.GC12845@local-michael-cet-test>
 <20191211163510.GF5044@linux.intel.com>
 <20191212010423.GB17570@local-michael-cet-test.sh.intel.com>
 <20191218003005.GO11771@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218003005.GO11771@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 04:30:05PM -0800, Sean Christopherson wrote:
> On Thu, Dec 12, 2019 at 09:04:24AM +0800, Yang Weijiang wrote:
> > On Wed, Dec 11, 2019 at 08:35:10AM -0800, Sean Christopherson wrote:
> > > Have you tested SMM at all?  The interaction between CR0 and CR4 may be
> > > problematic for em_rsm() and/or rsm_enter_protected_mode().
> > >
> > Not yet, what's an easy way to test code in SMM mode?
> 
> IIRC, SeaBIOS does SMM stuff by default.
Thanks Sean. I'll check this part.
