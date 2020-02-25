Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD9916F110
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 22:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgBYVWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 16:22:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:46361 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgBYVWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 16:22:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 13:22:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,485,1574150400"; 
   d="scan'208";a="231158820"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 25 Feb 2020 13:22:42 -0800
Date:   Tue, 25 Feb 2020 13:22:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 43/61] KVM: x86: Use KVM cpu caps to mark CR4.LA57 as
 not-reserved
Message-ID: <20200225212242.GJ9245@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-44-sean.j.christopherson@intel.com>
 <8736azocyp.fsf@vitty.brq.redhat.com>
 <66467dd7-09f0-7975-5c4e-c0404d779d8d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66467dd7-09f0-7975-5c4e-c0404d779d8d@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 04:12:28PM +0100, Paolo Bonzini wrote:
> On 24/02/20 23:08, Vitaly Kuznetsov wrote:
> >> +
> >> +static __always_inline bool kvm_cpu_cap_has(unsigned x86_feature)
> >> +{
> >> +	return kvm_cpu_cap_get(x86_feature);
> >> +}
> > I know this works (and I even checked C99 to make sure that it works not
> > by accident) but I have to admit that explicit '!!' conversion to bool
> > always makes me feel safer :-)
> 
> Same here, I don't really like the automagic bool behavior...

Sounds like I need to add '!!'?
