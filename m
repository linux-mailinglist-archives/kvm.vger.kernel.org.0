Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0433186E8B
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 16:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbgCPP0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 11:26:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:48163 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731822AbgCPP0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 11:26:51 -0400
IronPort-SDR: 5MFZcVF54I6GT2ul4WgPnvt0ASBKxa79KWYSHNW9elC2Kz/8ys0Pog/MX1Eybslo0ENMVQpPDA
 BFX4TYaf+gXw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 08:26:51 -0700
IronPort-SDR: BYukCOSEs4by1h0DChVnv0ZZ8vO+P1f+VhQP6gv4v9KBzZ9qkMrmzSs2YMrjm05nfSwp/5neov
 uezYMQ4cP2zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,560,1574150400"; 
   d="scan'208";a="290728497"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2020 08:26:50 -0700
Date:   Mon, 16 Mar 2020 08:26:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: correct meaningless kvm_apicv_activated() check
Message-ID: <20200316152650.GD24267@linux.intel.com>
References: <1584185480-3556-1-git-send-email-pbonzini@redhat.com>
 <878sk0n1g1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sk0n1g1.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 16, 2020 at 09:33:50AM +0100, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> > +	if ((old == 0) == (new == 0))
> > +		return;
> 
> This is a very laconic expression I personally find hard to read :-)
> 
> 	/* Check if WE actually changed APICv state */
>         if ((!old && !new) || (old && new))
> 		return;
> 
> would be my preference (not strong though, I read yours several times
> and now I feel like I understand it just fine :-)

Or maybe this to avoid so many equals signs?

	if (!old == !new)
		return;
