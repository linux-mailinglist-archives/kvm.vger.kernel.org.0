Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958BA1FD956
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 01:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgFQXFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 19:05:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:2656 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgFQXFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 19:05:49 -0400
IronPort-SDR: GUhVSak5GqolMFJf7FtM5nYe615nEaYQuoeUYE7SMdKonR82JnRIluLHHmFxU6FAxND7mc28BU
 6szD5BSEnn6w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 16:05:49 -0700
IronPort-SDR: 9vximzcJgqehRjfvFYseEvBOUFNOQMbCenADGkETS6z2M7DTmrrRGRtNvlOZqjLVxo9jwJ6N6z
 8YUmQJry1h+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,523,1583222400"; 
   d="scan'208";a="477027095"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jun 2020 16:05:48 -0700
Date:   Wed, 17 Jun 2020 16:05:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, virtio-fs@redhat.com,
        miklos@szeredi.hu, stefanha@redhat.com, dgilbert@redhat.com,
        pbonzini@redhat.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kvm: Add capability to be able to report async pf
 error to guest
Message-ID: <20200617230548.GC27751@linux.intel.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
 <20200616214847.24482-3-vgoyal@redhat.com>
 <87lfklhm58.fsf@vitty.brq.redhat.com>
 <20200617183224.GK26818@linux.intel.com>
 <20200617215152.GF26770@redhat.com>
 <20200617230052.GB27751@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617230052.GB27751@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 04:00:52PM -0700, Sean Christopherson wrote:
> On Wed, Jun 17, 2020 at 05:51:52PM -0400, Vivek Goyal wrote:
> What I'm saying is that KVM cannot do the filtering.  KVM, by design, does
> not know what lies behind any given hva, or what the associated gpa maps to
> in the guest.  As is, userspace can't even opt out of this behavior, e.g.
> it can't even "filter" on a per-VM granularity, since kvm_pv_enable_async_pf()
> unconditionally allows the guest to enable the behavior[*].

Let me rephrase that slightly.  KVM can do the filtering, but it cannot make
the decision on what to filter.  E.g. if the use case is compatible with doing
this at a memslot level, then a memslot flag could be added to control the
behavior.
