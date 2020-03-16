Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C518186F7C
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 16:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbgCPP7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 11:59:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:22664 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731636AbgCPP7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 11:59:12 -0400
IronPort-SDR: QkLoDr5lP5fZcT9LPFONdEBzCAMXD40aJ4eo8swUHQbDXLPFEUZLd8nMvgodT5HQn2VFyhAYQN
 0V3U+mEkfdCQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 08:59:12 -0700
IronPort-SDR: LFRVufw+A4o3TUlLrRxDp0Z4sDzsIwPexFSbedmHPUvuJ7osdKCp/FFzlJ1Y5isntLrkHklOOj
 WB8LrF4PxeeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,561,1574150400"; 
   d="scan'208";a="262718644"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2020 08:59:11 -0700
Date:   Mon, 16 Mar 2020 08:59:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: correct meaningless kvm_apicv_activated() check
Message-ID: <20200316155911.GE24267@linux.intel.com>
References: <1584185480-3556-1-git-send-email-pbonzini@redhat.com>
 <878sk0n1g1.fsf@vitty.brq.redhat.com>
 <20200316152650.GD24267@linux.intel.com>
 <87zhcgl2xc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zhcgl2xc.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 16, 2020 at 04:44:47PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Mon, Mar 16, 2020 at 09:33:50AM +0100, Vitaly Kuznetsov wrote:
> >> Paolo Bonzini <pbonzini@redhat.com> writes:
> >> > +	if ((old == 0) == (new == 0))
> >> > +		return;
> >> 
> >> This is a very laconic expression I personally find hard to read :-)
> >> 
> >> 	/* Check if WE actually changed APICv state */
> >>         if ((!old && !new) || (old && new))
> >> 		return;
> >> 
> >> would be my preference (not strong though, I read yours several times
> >> and now I feel like I understand it just fine :-)
> >
> > Or maybe this to avoid so many equals signs?
> >
> > 	if (!old == !new)
> > 		return;
> >
> 
> 	if (!!old == !!new)
> 		return;
> 
> to make it clear we're converting them to 1/0 :-)

All I can think of now is the Onion article regarding razor blades...

	if (!!!!old == !!!!new)
		return;
