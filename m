Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B01023BF95
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 21:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHDTJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 15:09:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:56305 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgHDTJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 15:09:51 -0400
IronPort-SDR: Vit3+XxibjKDv6Roo+xkHmJicK+PVlzi9qHgEyAEOImjM0k8RWaeq43MbmEglulrH3Serr9lX3
 6wBLiKOuEksw==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="140309315"
X-IronPort-AV: E=Sophos;i="5.75,434,1589266800"; 
   d="scan'208";a="140309315"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 12:09:50 -0700
IronPort-SDR: L1oUZE7jtEEZS22QES15jEaxtE4URsOGUOXBmMsTxSk3u9vjhEgoqVtqetarXRf7WCdzcJcBnS
 MMGNGMHmU3Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,434,1589266800"; 
   d="scan'208";a="315470701"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 04 Aug 2020 12:09:49 -0700
Date:   Tue, 4 Aug 2020 12:09:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH] KVM: x86: Don't attempt to load PDPTRs when 64-bit mode
 is enabled
Message-ID: <20200804190949.GA25586@linux.intel.com>
References: <20200714015732.32426-1-sean.j.christopherson@intel.com>
 <20200804184146.GA16023@linux.intel.com>
 <CALMp9eQb32UB_tLowkr5T+Rt9SBdJbTkjHWyWFg+6ruJ_OuaKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQb32UB_tLowkr5T+Rt9SBdJbTkjHWyWFg+6ruJ_OuaKw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 04, 2020 at 11:46:58AM -0700, Jim Mattson wrote:
> On Tue, Aug 4, 2020 at 11:41 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
> > Ping.  This really needs to be in the initial pull for 5.9, as is kvm/queue
> > has a 100% fatality rate for me.
> 
> I agree completely, but I am curious what guest you have that toggles
> CD/NW in 64-bit mode.

It's my OVMF build.  I assume it's MTRR programming, but I haven't bothered
to debug that far.  Nor do I want to, the EDKII build framework makes my
head explode :-).
