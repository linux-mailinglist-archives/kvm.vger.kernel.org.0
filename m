Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E9C3E31B6
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 00:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245523AbhHFWYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 18:24:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:44002 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241242AbhHFWYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 18:24:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="201633025"
X-IronPort-AV: E=Sophos;i="5.84,301,1620716400"; 
   d="scan'208";a="201633025"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 15:24:29 -0700
X-IronPort-AV: E=Sophos;i="5.84,301,1620716400"; 
   d="scan'208";a="672548845"
Received: from alsoller-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.16.75])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 15:24:25 -0700
Date:   Sat, 7 Aug 2021 10:24:23 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen
 GPA bits
Message-Id: <20210807102423.f896d034690ef91cd1e18f44@intel.com>
In-Reply-To: <YQ2zH+XiLCLQWs0l@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
        <c958a131ded780808a687b0f25c02127ca14418a.1625186503.git.isaku.yamahata@intel.com>
        <20210805234424.d14386b79413845b990a18ac@intel.com>
        <YQwMkbBFUuNGnGFw@google.com>
        <20210806095922.6e2ca6587dc6f5b4fe8d52e7@intel.com>
        <YQ2HT3dL/bFjdEdS@google.com>
        <20210807100006.3518bf9fbdecf13006030c22@intel.com>
        <YQ2zH+XiLCLQWs0l@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Aug 2021 22:09:35 +0000 Sean Christopherson wrote:
> On Sat, Aug 07, 2021, Kai Huang wrote:
> > So could we have your final suggestion? :)
> 
> Try the kvm_mmu_page_role.private approach.  So long as it doesn't end up splattering
> code everywhere, I think that's more aligned with how KVM generally wants to treat
> the shared bit.

OK.

> 
> In the changelog for this patch, make it very clear that ensuring different aliases
> get different shadow page (if necessary) is the responsiblity of each individual
> feature that leverages stolen gfn bits.

Make sense.  Thanks.
