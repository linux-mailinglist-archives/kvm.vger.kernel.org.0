Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A493E22765D
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 05:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGUDDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 23:03:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:59502 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbgGUDDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 23:03:23 -0400
IronPort-SDR: AukhDBGLKowAWdlz7POWWV+5BgpgN+0Muze9p6/g2PVSDjifzaeWRHCJp9Bb2IaKq1jO9O319N
 ICLgoQFSyJpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="214717283"
X-IronPort-AV: E=Sophos;i="5.75,377,1589266800"; 
   d="scan'208";a="214717283"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 20:03:22 -0700
IronPort-SDR: HzVpQaG5twjIfxpnju8GDWuos4dAPQdPHlwMjDDX3gAPI5polM1zA6MY0q1jyqRDJxkom6+vDk
 TzYQS+SHGubQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,377,1589266800"; 
   d="scan'208";a="487930766"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 20 Jul 2020 20:03:19 -0700
Date:   Mon, 20 Jul 2020 20:03:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Weijiang Yang <weijiang.yang@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
Message-ID: <20200721030319.GD20375@linux.intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
 <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
 <20200709211253.GW24919@linux.intel.com>
 <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
 <20200710042922.GA24919@linux.intel.com>
 <20200713122226.28188f93@x1.home>
 <20200713190649.GE29725@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713190649.GE29725@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Weijiang

On Mon, Jul 13, 2020 at 12:06:50PM -0700, Sean Christopherson wrote:
> The only ideas I have going forward are to:
> 
>   a) Reproduce the bug outside of your environment and find a resource that
>      can go through the painful bisection.

We're trying to reproduce the original issue in the hopes of biesecting, but
have not yet discovered the secret sauce.  A few questions:

  - Are there any known hardware requirements, e.g. specific flavor of GPU?

  - What's the average time to failure when running FurMark/PassMark?  E.g.
    what's a reasonable time to wait before rebooting to rerun the tests (I
    assume this is what you meant when you said you sometimes needed to
    reboot to observe failure).

Thanks!
