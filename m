Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CDD22B30E
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 17:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgGWP5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 11:57:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:39414 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgGWP5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 11:57:12 -0400
IronPort-SDR: vu8i4Sl4xOoFB/JWK/82MKB0X5AIK/uQmZRTX1tZGfAPna13DbbZNd0vvkTf0hhIGRQYlGMSEh
 /AEO2r1QC2xA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="138055932"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="138055932"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 08:57:11 -0700
IronPort-SDR: WgfvmvBADdiXis6e61jhSmVSItsancSBTqRCpczfMDMPmJuPRyP8VbEg/ovxlWgGzMzfGmlFsp
 bAA104OlEruw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="319031598"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 23 Jul 2020 08:57:11 -0700
Date:   Thu, 23 Jul 2020 08:57:11 -0700
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
Message-ID: <20200723155711.GD21891@linux.intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
 <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
 <20200709211253.GW24919@linux.intel.com>
 <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
 <20200710042922.GA24919@linux.intel.com>
 <20200713122226.28188f93@x1.home>
 <20200713190649.GE29725@linux.intel.com>
 <20200721030319.GD20375@linux.intel.com>
 <20200721100036.464d4440@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721100036.464d4440@w520.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 10:00:36AM -0600, Alex Williamson wrote:
> On Mon, 20 Jul 2020 20:03:19 -0700
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> > +Weijiang
> > 
> > On Mon, Jul 13, 2020 at 12:06:50PM -0700, Sean Christopherson wrote:
> > > The only ideas I have going forward are to:
> > > 
> > >   a) Reproduce the bug outside of your environment and find a resource that
> > >      can go through the painful bisection.  
> > 
> > We're trying to reproduce the original issue in the hopes of biesecting, but
> > have not yet discovered the secret sauce.  A few questions:
> > 
> >   - Are there any known hardware requirements, e.g. specific flavor of GPU?
> 
> I'm using an old GeForce GT635, I don't think there's anything special
> about this card.

Would you be able to provide your QEMU command line?  Or at least any
potentially relevant bits?  Still no luck reproducing this on our end.

Thanks again!
