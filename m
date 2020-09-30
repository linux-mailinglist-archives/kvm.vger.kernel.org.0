Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF6A27F12F
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgI3STK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:19:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:12972 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3STK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:19:10 -0400
IronPort-SDR: HLlXYE1cZ7Dm/Bvhf/emQbAESWeX8y/6BwpmV03+uZ3P5sZ483xAney/08N9CJcuJxROvVwXX9
 LL3iVkdfiNWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="180678008"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="180678008"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 11:19:09 -0700
IronPort-SDR: QqYFsGe5M9XI/hDL7ELxRXKWe8pX0Q3dEBtu3QKVNQb0gNFertXxLmfYVNbYNxzOHSESukUJmN
 QU/2dRGRUsoA==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="457759350"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 11:19:08 -0700
Date:   Wed, 30 Sep 2020 11:19:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 21/22] kvm: mmu: Support MMIO in the TDP MMU
Message-ID: <20200930181907.GK32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-22-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-22-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:23:01PM -0700, Ben Gardon wrote:
> In order to support MMIO, KVM must be able to walk the TDP paging

Probably worth clarifying that this is for emulated MMIO, as opposed to
mapping MMIO host addresses.

> structures to find mappings for a given GFN. Support this walk for
> the TDP MMU.
