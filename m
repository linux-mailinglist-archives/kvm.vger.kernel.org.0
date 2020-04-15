Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF6C1A9120
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 04:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388167AbgDOCvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 22:51:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:1607 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbgDOCvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 22:51:07 -0400
IronPort-SDR: FDcLjSRNUQGMlO6tN1lEKPA4uyVIi972AacZmK5IA6iTWQrx0EkB5TQYCDfkYhCmsWKUgNXIaV
 m7AWqx+rWx1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 19:51:05 -0700
IronPort-SDR: 5lXNmwCXudgWW8KsmxKVXjnbctzEfYwxrspNAggrcqJvmWIEruLwb4wz1c845I4voEH0SJWFnK
 884hRA6oncJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,385,1580803200"; 
   d="scan'208";a="272027224"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2020 19:51:05 -0700
Date:   Tue, 14 Apr 2020 19:51:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jon Cargille <jcargill@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Northup <digitaleric@gmail.com>,
        Eric Northup <digitaleric@google.com>
Subject: Re: [PATCH 1/1] KVM: pass through CPUID(0x80000006)
Message-ID: <20200415025105.GE12547@linux.intel.com>
References: <20200415012320.236065-1-jcargill@google.com>
 <20200415023726.GD12547@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415023726.GD12547@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 07:37:26PM -0700, Sean Christopherson wrote:
> On Tue, Apr 14, 2020 at 06:23:20PM -0700, Jon Cargille wrote:
> > From: Eric Northup <digitaleric@gmail.com>
> > 
> > Return L2 cache and TLB information to guests.
> > They could have been set before, but the defaults that KVM returns will be
> > necessary for usermode that doesn't supply their own CPUID tables.
> 
> I don't follow the changelog.  The code makes sense, but I don't understand
> the justification.  This only affects KVM_GET_SUPPORTED_CPUID, i.e. what's
> advertised to userspace, it doesn't directly change CPUID emulation in any
> way.  The "They could have been set before" blurb is especially confusing.
> 
> I assume you want to say something like:
> 
>   Return the host's L2 cache and TLB information for CPUID.0x80000006
>   instead of zeroing out the entry as part of KVM_GET_SUPPORTED_CPUID.
>   This allows a userspace VMM to feed KVM_GET_SUPPORTED_CPUID's output
>   directly into KVM_SET_CPUID2 (without breaking the guest).
> 
> > Signed-off-by: Eric Northup <digitaleric@google.com>
> > Signed-off-by: Eric Northup <digitaleric@gmail.com>
> > Signed-off-by: Jon Cargille <jcargill@google.com>
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> 
> Jim's tag is unnecessary, unless he was a middleman between Eric and Jon,
> in which case Jim's tag should also come between Eric's and Jon's.
> 
> Only one of Eric's signoffs is needed (the one that matches the From: tag,
> i.e. is the official author).  I'm guessing Google would prefer the author
> to be the @google.com address.

Ah, Eric's @google.com mail bounced.  Maybe do:

  Signed-off-by: Eric Northup (Google) <digitaleric@gmail.com>

to clarify the work was done for Google without having a double signoff
and/or a dead email.
