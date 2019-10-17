Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F990DB1E1
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 18:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390456AbfJQQFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 12:05:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:48344 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728391AbfJQQFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 12:05:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 09:05:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="186531520"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 17 Oct 2019 09:05:08 -0700
Date:   Thu, 17 Oct 2019 09:05:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
Message-ID: <20191017160508.GA20903@linux.intel.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
 <d14d22e2-d74c-ed73-b5bb-3ed5eb087deb@redhat.com>
 <6cc430c1-5729-c2d3-df11-3bf1ec1272f8@intel.com>
 <245dcfe2-d167-fdec-a371-506352d3c684@redhat.com>
 <11318bab-a377-bb8c-b881-76331c92f11e@intel.com>
 <10300339-e4cb-57b0-ac2f-474604551df0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10300339-e4cb-57b0-ac2f-474604551df0@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 11:41:05AM +0200, Paolo Bonzini wrote:
> On 16/10/19 09:48, Xiaoyao Li wrote:
> > BTW, could you have a look at the series I sent yesterday to refactor
> > the vcpu creation flow, which is inspired partly by this issue. Any
> > comment and suggestion is welcomed since I don't want to waste time on
> > wrong direction.
> 
> Yes, that's the series from which I'll take your patch.

Can you hold off on taking that patch?  I'm pretty sure we can do more
cleanup in that area, with less code.
