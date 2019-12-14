Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C867811F02B
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 04:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLNDfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 22:35:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:9065 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfLNDfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 22:35:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 19:35:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="221051250"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2019 19:35:17 -0800
Date:   Fri, 13 Dec 2019 19:35:16 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86: X86_FEATURE bit() cleanup
Message-ID: <20191214033516.GA6676@linux.intel.com>
References: <20191211175822.1925-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211175822.1925-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 09:58:20AM -0800, Sean Christopherson wrote:
> Small series to add build-time protections on reverse CPUID lookup (and
> other usages of bit()), and to rename the misleading-generic bit() helper
> to something that better conveys its purpose.

Paolo, please don't merge this even though Jim's feedback was minor, I
have a revamped version that I'll send out next week.  Thanks!
