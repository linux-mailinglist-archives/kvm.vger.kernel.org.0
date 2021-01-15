Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80342F84BE
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 19:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbhAOSvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 13:51:39 -0500
Received: from one.firstfloor.org ([193.170.194.197]:42214 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbhAOSvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 13:51:38 -0500
X-Greylist: delayed 898 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2021 13:51:38 EST
Received: by one.firstfloor.org (Postfix, from userid 503)
        id D269386852; Fri, 15 Jan 2021 19:27:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1610735220;
        bh=31CxBw19B4liGLfT90HOu8/1FDJ+TbGT3dFu6N0lNBI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uHSPvcfFdbSWbNz+YfxwNvqKiskkpFagDxHS0TXKIQgSWMgf5g6rVdtG3tu1CfyPI
         7t7kVXfAWQZXmb6fB+vHxkQN0ONY7dfrbwgx0t0b078NA7Hv5sd9v/OwQa65iLR0/j
         CpN1I6wWSLzgX/CoOOw89o/9mlG2gVuVjzbU2Z04=
Date:   Fri, 15 Jan 2021 10:27:00 -0800
From:   Andi Kleen <andi@firstfloor.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Xu, Like" <like.xu@intel.com>, Andi Kleen <andi@firstfloor.org>,
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
Message-ID: <20210115182700.byczztx3vjhsq3p3@two.firstfloor.org>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <YACXQwBPI8OFV1T+@google.com>
 <f8a8e4e2-e0b1-8e68-81d4-044fb62045d5@intel.com>
 <YAHXlWmeR9p6JZm2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAHXlWmeR9p6JZm2@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I'm asking about ucode/hardare.  Is the "guest pebs buffer write -> PEBS PMI"
> guaranteed to be atomic?

Of course not.
> 
> In practice, under what scenarios will guest counters get cross-mapped?  And,
> how does this support affect guest accuracy?  I.e. how bad do things get for the
> guest if we simply disable guest counters if they can't have a 1:1 association
> with their physical counter?

This would completely break perfmon for the guest, likely with no way to
recover.

-Andi
