Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714C4D1425
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 18:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731787AbfJIQgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 12:36:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:8927 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbfJIQgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 12:36:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 09:36:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,276,1566889200"; 
   d="scan'208";a="277476987"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 09 Oct 2019 09:36:00 -0700
Date:   Wed, 9 Oct 2019 09:36:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: Add WARNs to detect out-of-bounds
 register indices
Message-ID: <20191009163600.GA19952@linux.intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <20190927214523.3376-6-sean.j.christopherson@intel.com>
 <9e4570a4-1da1-1109-32d3-1fba25de1963@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4570a4-1da1-1109-32d3-1fba25de1963@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 09, 2019 at 12:50:44PM +0200, Paolo Bonzini wrote:
> On 27/09/19 23:45, Sean Christopherson wrote:
> > Open code the RIP and RSP accessors so as to avoid pointless overhead of
> > WARN_ON_ONCE().
> 
> Is there actually an overhead here?  It is effectively WARN_ON_ONCE(0)
> which should be compiled out just fine.

Doh, you're correct, it does get compiled out.
