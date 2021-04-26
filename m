Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0808036B53E
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhDZOvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:51:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:21832 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232575AbhDZOvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:51:47 -0400
IronPort-SDR: IEX33GqCT5lFOVs2nGOjnXkmALLALnpeEKBcGZqB6meZp1/fusgS5v4ikwacYx1NlzHlJZhOjI
 +hxID+ImWsZw==
X-IronPort-AV: E=McAfee;i="6200,9189,9966"; a="193159518"
X-IronPort-AV: E=Sophos;i="5.82,252,1613462400"; 
   d="scan'208";a="193159518"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2021 07:51:05 -0700
IronPort-SDR: B5X7ktmXc2xBxLtvvCf8gK8EeCArF9unwmaSxwOKWRwzj/46PQ5PBSKzofelvtbM8mvFK/lFJB
 Mqpx6m2F8l2g==
X-IronPort-AV: E=Sophos;i="5.82,252,1613462400"; 
   d="scan'208";a="424923296"
Received: from tassilo.jf.intel.com ([10.54.74.11])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2021 07:51:05 -0700
Date:   Mon, 26 Apr 2021 07:51:04 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 2/2] KVM: VMX: Invoke NMI handler via indirect call
 instead of INTn
Message-ID: <20210426145104.GW1401198@tassilo.jf.intel.com>
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
 <20200915191505.10355-3-sean.j.christopherson@intel.com>
 <CAJhGHyBOLUeqnwx2X=WToE2oY8Zkqj_y4KZ0hoq-goe+UWcR9g@mail.gmail.com>
 <bb2c2d93-8046-017a-5711-c61c8f1a4c09@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb2c2d93-8046-017a-5711-c61c8f1a4c09@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > The original code "int $2" can provide the needed CPU-hidden-NMI-masked
> > when entering #NMI, but I doubt it about this change.
> 
> How would "int $2" block NMIs?  The hidden effect of this change (and I
> should have reviewed better the effect on the NMI entry code) is that the
> call will not use the IST anymore.

My understanding is that int $2 does not block NMIs.

So reentries might have been possible.

-Andi
