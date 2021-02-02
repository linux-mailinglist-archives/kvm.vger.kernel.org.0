Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09B030CD29
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 21:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhBBUgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 15:36:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:25768 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhBBUgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 15:36:22 -0500
IronPort-SDR: QVKNqy4NwuxsSx9Q81gE2ETwefyfPtFLrDQbr6be/YN1W1P1a7xCPhXwEBEooqhUEsdetM0UDi
 FoZl/h7TzEag==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="265758367"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="265758367"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 12:35:35 -0800
IronPort-SDR: POfVSk7vGi04vDpbLhh+tFnD/EmXf0WzZtfgJsXHcc3v1s3WBmyo8/TAK2OUrXVvFS0Q3tXvE3
 d7ocOsdeTPIA==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="433069135"
Received: from asalasax-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.175])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 12:35:30 -0800
Date:   Wed, 3 Feb 2021 09:35:28 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 14/27] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-Id: <20210203093528.51d33baaaee390ba8d66bf0d@intel.com>
In-Reply-To: <YBmJ9tvbw3RE63F6@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <e807033e3d56ede1177d7a1af34477678bfbfff9.1611634586.git.kai.huang@intel.com>
        <YBVyfQQPo18Fyv64@kernel.org>
        <20210201131744.30530bd817ae299df92b8164@intel.com>
        <YBmJ9tvbw3RE63F6@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 19:20:54 +0200 Jarkko Sakkinen wrote:
> On Mon, Feb 01, 2021 at 01:17:44PM +1300, Kai Huang wrote:
> > On Sat, 30 Jan 2021 16:51:41 +0200 Jarkko Sakkinen wrote:
> > > On Tue, Jan 26, 2021 at 10:31:06PM +1300, Kai Huang wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > 
> > > > The bare-metal kernel must intercept ECREATE to be able to impose policies
> > > > on guests.  When it does this, the bare-metal kernel runs ECREATE against
> > > > the userspace mapping of the virtualized EPC.
> > > 
> > > I guess Andy's earlier comment applies here, i.e. SGX driver?
> > 
> > Sure.
> > 
> > [...]
> > 
> > > > +	}
> > > > +
> > > > +	if (encls_faulted(ret)) {
> > > > +		*trapnr = ENCLS_TRAPNR(ret);
> 
> Also here is an empty line needed.

I honestly don't like putting new line here, since it is just two lines of
code. Adding new line is too sparse I think.

> 
> > > > +		return -EFAULT;
> > > > +	}
> > > 
> > > Empty line here before return. Applies also to sgx_virt_ecreate().
> > 
> > Yes I can remove, but I am just carious: isn't "having empty line before return"
> > a good coding-style? Do you have any reference to the guideline?
> 
> In the initial SGX patch set, this was the review feedback that I got
> from Boris, so I would presume it is tip tree convention. Also, looking
> at a random selection of files under arch/x86, it is commonly done this
> way.

I'll add a new line here. Sorry I misunderstood your original comment.

> 
> > 
> > > 
> > > > +	return ret;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(sgx_virt_einit);
> > > > -- 
> > > > 2.29.2
> > > 
> > > Great work. I think this patch sets is shaping up.
> > > 
> > > /Jarkko
> > > > 
> > > > 
> > 
> 
> /Jarkko
