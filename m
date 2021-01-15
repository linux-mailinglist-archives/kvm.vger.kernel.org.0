Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FE62F8525
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 20:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387662AbhAOTL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 14:11:56 -0500
Received: from one.firstfloor.org ([193.170.194.197]:46312 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733159AbhAOTLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 14:11:55 -0500
Received: by one.firstfloor.org (Postfix, from userid 503)
        id 724AF86852; Fri, 15 Jan 2021 20:11:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1610737873;
        bh=V4l2I3v0GSHTyKiki+4APxm2kYXFuyZMSHfMsKLhGZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBWC5xAQhnRr0zGIjYFJ2JFHdnvxCO9FqHoip1/gXPAVp6+rosEHAOdu4q6X3Ir2w
         Cao0D0TLCdRC/0j9kx6YkYHNOmjlkWxJr1sJwZEB9tpN4bsW3tEl03REk5iwMhUhed
         mDlxlnJjoZ+myVZ8boUSBgRtC5qDpTMvtISl3CLA=
Date:   Fri, 15 Jan 2021 11:11:13 -0800
From:   Andi Kleen <andi@firstfloor.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andi Kleen <andi@firstfloor.org>, "Xu, Like" <like.xu@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
Message-ID: <20210115191113.nktlnmivc3edstiv@two.firstfloor.org>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
 <YAHXlWmeR9p6JZm2@google.com>
 <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
 <YAHkOiQsxMfOMYvp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAHkOiQsxMfOMYvp@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 10:51:38AM -0800, Sean Christopherson wrote:
> On Fri, Jan 15, 2021, Andi Kleen wrote:
> > > I'm asking about ucode/hardare.  Is the "guest pebs buffer write -> PEBS PMI"
> > > guaranteed to be atomic?
> > 
> > Of course not.
> 
> So there's still a window where the guest could observe the bad counter index,
> correct?

Yes.

But with single record PEBS it doesn't really matter with normal perfmon
drivers.

-Andi
