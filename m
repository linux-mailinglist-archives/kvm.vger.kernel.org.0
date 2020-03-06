Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2506C17B305
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 01:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgCFAeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 19:34:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:52582 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFAeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 19:34:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 16:34:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="scan'208";a="387670859"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 05 Mar 2020 16:34:41 -0800
Date:   Fri, 6 Mar 2020 08:38:08 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v9 1/7] KVM: CPUID: Fix IA32_XSS support in CPUID(0xd,i)
 enumeration
Message-ID: <20200306003808.GA29236@local-michael-cet-test.sh.intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
 <20191227021133.11993-2-weijiang.yang@intel.com>
 <bd75450f-a929-f60b-e973-205e4f5a9743@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd75450f-a929-f60b-e973-205e4f5a9743@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 05, 2020 at 03:51:17PM +0100, Paolo Bonzini wrote:
> On 27/12/19 03:11, Yang Weijiang wrote:
> > +	u64 (*supported_xss)(void);
> 
> I don't think the new callback is needed.  Anyway I'm rewriting this
> patch on top of the new CPUID feature and will post it shortly.
> 
> Paolo
Yes, it's not necessary. I've removed this in the internal
version, a global variable like that in Sean's patch can serve
the functions.
You may go ahead with the new patch, thanks for review!

