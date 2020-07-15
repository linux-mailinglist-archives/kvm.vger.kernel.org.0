Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08525220408
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgGOEgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:36:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:62154 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgGOEgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:36:11 -0400
IronPort-SDR: zzn39vgLgbXi0qnq6hOxjYSxFTUfMnOeTLbcYbVZadbehq2g6ta/TZK+unV7F7eQaVyIplwS+R
 U5cYyt2lTHeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="137209908"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="137209908"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:36:11 -0700
IronPort-SDR: FrWtwjUjHLiCzh7e6Apd6mNCDEQYWBCNGa+rOe2YiIz9CR54NKkx394U05SrAObHpbfVCiQy6y
 p14f+Ww3D/yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="429992962"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 14 Jul 2020 21:36:11 -0700
Date:   Tue, 14 Jul 2020 21:36:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/9] KVM: nSVM: introduce
 nested_svm_load_cr3()/nested_npt_enabled()
Message-ID: <20200715043609.GF14404@linux.intel.com>
References: <20200710141157.1640173-1-vkuznets@redhat.com>
 <20200710141157.1640173-6-vkuznets@redhat.com>
 <20200713223814.GG29725@linux.intel.com>
 <87zh82s5gf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh82s5gf.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 01:26:24PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > IMO the addition of nested_npt_enabled() should be a separate patch, and
> > the additoin of @nested_npt should be in patch 7.
> >
> > Hypothetically speaking, if nested_npt_enabled() is inaccurate at the call
> > site in nested_prepare_vmcb_save(), then this patch is technically wrong
> > even though it doesn't introduce a bug.  Given that the call site of
> > nested_svm_load_cr3() is moved in patch 7, I don't see any value in adding
> > the placeholder parameter early.
> >
> 
> I see and I mostly agree, I put it here to avoid the unneeded churn and
> make it easier to review the whole thing: this patch is technically a
> nop so it can be reviewed in "doesn't change anything" mode and patches
> which actually change things are smaller.
> 
> Paolo already said 'queued' here and your comments can't be addressed in
> a follow-up patch but I can certainly do v5 if needed.

Eh, not necessary, I didn't see that the series was in kvm/queue until after
I hit send.  Thanks!
